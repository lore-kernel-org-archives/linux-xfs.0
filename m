Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0322C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiJBS2N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiJBS2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:28:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF193BC6E
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:27:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6178260EB1
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACCEC433D6;
        Sun,  2 Oct 2022 18:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735277;
        bh=DyzdOfouwa7SeK5IIbfPmx9DfajXfjkQiJ4fznxkgf8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oYk1X+zkPVld7igj2Q/CAGlTa8BerADtR6wVSdI8ANCJxH+R33xLWWaiY2qJ5KfCp
         6+KMiZ03/+WpIvamp02KSdWaclXdjSuKFvHhRpUnPgP1yygW0IO/BU7tB8VI15OT4x
         AHWlSkAFWmUHTIB4J0Wny1GKqJCZzcD+CeImBWEa4qoiN8iTnl1gZHdLxm8A0U3gyG
         M9QeYGP5qX63UrY4JH+EwZg8WfS7U/sNhx95qj8BLpF+Sgbu+6qOq8Um9nSEoi7JJQ
         Cwx83WWknrUHlEstGksvK2YgikM9nkRKHRkGgmRdGhpsPSyxbM5pEFB2K5YNCXYRcp
         5TAcq3shRIZVg==
Subject: [PATCH 3/4] xfs: set the buffer type after holding the AG[IF] across
 trans_roll
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:48 -0700
Message-ID: <166473478893.1083155.2555785331844801316.stgit@magnolia>
In-Reply-To: <166473478844.1083155.9238102682926048449.stgit@magnolia>
References: <166473478844.1083155.9238102682926048449.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, the only way to lock an allocation group is to hold the AGI
and AGF buffers.  If repair needs to roll the transaction while
repairing some AG metadata, it maintains that lock by holding the two
buffers across the transaction roll and joins them afterwards.

However, repair is not the same as the other parts of XFS that employ
this bhold/bjoin sequence, because it's possible that the AGI or AGF
buffers are not actually dirty before the roll.  In this case, the
buffer log item can detach from the buffer, which means that we have to
re-set the buffer type in the bli after joining the buffer to the new
transaction so that log recovery will know what to do if the fs fails.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/repair.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 2ada7fc1c398..92c661b98892 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -138,11 +138,23 @@ xrep_roll_ag_trans(
 	if (error)
 		return error;
 
-	/* Join AG headers to the new transaction. */
-	if (sc->sa.agi_bp)
+	/*
+	 * Join AG headers to the new transaction.  The buffer log item can
+	 * detach from the buffer across the transaction roll if the bli is
+	 * clean, so ensure the buffer type is still set on the AG header
+	 * buffers' blis before we return.
+	 *
+	 * Normal code would never hold a clean buffer across a roll, but scrub
+	 * needs both buffers to maintain a total lock on the AG.
+	 */
+	if (sc->sa.agi_bp) {
 		xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
-	if (sc->sa.agf_bp)
+		xfs_trans_buf_set_type(sc->tp, sc->sa.agi_bp, XFS_BLFT_AGI_BUF);
+	}
+	if (sc->sa.agf_bp) {
 		xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
+		xfs_trans_buf_set_type(sc->tp, sc->sa.agf_bp, XFS_BLFT_AGF_BUF);
+	}
 
 	return 0;
 }

