Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C547FA3741
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Oct 2022 18:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiJaSIk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Oct 2022 14:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiJaSIi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Oct 2022 14:08:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3135AF590
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 11:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A249B819A9
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 18:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C95C433C1;
        Mon, 31 Oct 2022 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667239714;
        bh=km0m0wrT35KMVAksL6JY29uA/H97C5qAJOZWhxWTuSY=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=gcufuKlFRayE1MKyV81R0r8MA1k1sPZKhR+S67qiCPpbfScLaSFhSvD1rW86jPfVf
         fuYijJ0p29tdt7mXHnoYDIbKVnP/SU7MRJWexrQHrTE4E3GOL8wANosvKD+Tb4fCwF
         TmhnysmlvfvUYLBoGDrG2dZuMU+LSjSvpwJAOcu3QuMhAkFN9jTcXy3Sh+3lk/PJ2Z
         PnL/lQ6v51DXe08jFpt/n2r6cIXW3UyWODcSXp56F3hBgKdPysnZq1TQ9UXNi8Q/Ly
         wEbkgPe4tYVgoVDWtJrjmg92AlGxrwpAQWVKBzcpW3tfbLIEYkFcnn7+kL8CiSPyao
         bkJbI/ohQIXtg==
Date:   Mon, 31 Oct 2022 11:08:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: [PATCH v23.2 3/4] xfs: log the AGI/AGF buffers when rolling
 transactions during an AG repair
Message-ID: <Y2APIan1VaLglNzY@magnolia>
References: <166473478844.1083155.9238102682926048449.stgit@magnolia>
 <166473478893.1083155.2555785331844801316.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473478893.1083155.2555785331844801316.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, the only way to lock an allocation group is to hold the AGI
and AGF buffers.  If a repair needs to roll the transaction while
repairing some AG metadata, it maintains that lock by holding the two
buffers across the transaction roll and joins them afterwards.

However, repair is not like other parts of XFS that employ the bhold -
roll - bjoin sequence because it's possible that the AGI or AGF buffers
are not actually dirty before the roll.  This presents two problems --
First, we need to redirty those buffers to keep them moving along in the
log to avoid pinning the log tail.  Second, a clean buffer log item can
detach from the buffer.  If this happens, the buffer type state is
discarded along with the bli and must be reattached before the next time
the buffer is logged.   If it is not, the logging code will complain and
log recovery will not work properly.

An earlier version of this patch tried to fix the second problem by
re-setting the buffer type in the bli after joining the buffer to the
new transaction, but that looked weird and didn't solve the first
problem.  Instead, solve both problems by logging the buffer before
rolling the transaction.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 2ada7fc1c398..22335619c84e 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -121,24 +121,36 @@ xrep_roll_ag_trans(
 {
 	int			error;
 
-	/* Keep the AG header buffers locked so we can keep going. */
-	if (sc->sa.agi_bp)
+	/*
+	 * Keep the AG header buffers locked while we roll the transaction.
+	 * Ensure that both AG buffers are dirty and held when we roll the
+	 * transaction so that they move forward in the log without losing the
+	 * bli (and hence the bli type) when the transaction commits.
+	 *
+	 * Normal code would never hold clean buffers across a roll, but repair
+	 * needs both buffers to maintain a total lock on the AG.
+	 */
+	if (sc->sa.agi_bp) {
+		xfs_ialloc_log_agi(sc->tp, sc->sa.agi_bp, XFS_AGI_MAGICNUM);
 		xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
-	if (sc->sa.agf_bp)
+	}
+
+	if (sc->sa.agf_bp) {
+		xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, XFS_AGF_MAGICNUM);
 		xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
+	}
 
 	/*
-	 * Roll the transaction.  We still own the buffer and the buffer lock
-	 * regardless of whether or not the roll succeeds.  If the roll fails,
-	 * the buffers will be released during teardown on our way out of the
-	 * kernel.  If it succeeds, we join them to the new transaction and
-	 * move on.
+	 * Roll the transaction.  We still hold the AG header buffers locked
+	 * regardless of whether or not that succeeds.  On failure, the buffers
+	 * will be released during teardown on our way out of the kernel.  If
+	 * successful, join the buffers to the new transaction and move on.
 	 */
 	error = xfs_trans_roll(&sc->tp);
 	if (error)
 		return error;
 
-	/* Join AG headers to the new transaction. */
+	/* Join the AG headers to the new transaction. */
 	if (sc->sa.agi_bp)
 		xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
 	if (sc->sa.agf_bp)
