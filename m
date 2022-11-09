Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5468C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Nov 2022 02:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbiKICG7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 21:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiKICG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Nov 2022 21:06:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4D96868A
        for <linux-xfs@vger.kernel.org>; Tue,  8 Nov 2022 18:06:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAB8BB81CF3
        for <linux-xfs@vger.kernel.org>; Wed,  9 Nov 2022 02:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85512C433D6;
        Wed,  9 Nov 2022 02:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959615;
        bh=7Dti90X9F2xuEvqdbFllmQsnBIgdgmOdToufiR1tiF4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QfCZPteQd83CG2Vevzn79ZAA7qz/tlM+4HYcX4apmWfcPjDfIRPH/PUS4UJpw3YmP
         iOYCiz0vQX2SHSIWbMj24/Bf+onMn45+xfrWikWT2W9KRmGWl0hdo3hixdY72nxr6g
         t9i+ApWlj+YE69+lvdIJ89nuQsby5RtIR4NArZ3MrJCdTqNjTQFfduUI+fZTLkhJes
         5gwP4Rc1IGmYq1jywkUp/O+vU89dHWI8OI1M+BcUrvE9ygTPWo65lR3RHEy9vVQIXf
         HDxCdWT0/glUoDRgJldboF0OfbQMipVLsPVTst2ngDNlkMVBCiyRhbx80GNzDiUr4Z
         3qWPyD8EgovDQ==
Subject: [PATCH 13/24] xfs: check deferred refcount op continuation parameters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 08 Nov 2022 18:06:55 -0800
Message-ID: <166795961515.3761583.4388997331012220257.stgit@magnolia>
In-Reply-To: <166795954256.3761583.3551179546135782562.stgit@magnolia>
References: <166795954256.3761583.3551179546135782562.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 4fa6f60a07b5ef09691919459cd7f6405810d4c2

If we're in the middle of a deferred refcount operation and decide to
roll the transaction to avoid overflowing the transaction space, we need
to check the new agbno/aglen parameters that we're about to record in
the new intent.  Specifically, we need to check that the new extent is
completely within the filesystem, and that continuation does not put us
into a different AG.

If the keys of a node block are wrong, the lookup to resume an
xfs_refcount_adjust_extents operation can put us into the wrong record
block.  If this happens, we might not find that we run out of aglen at
an exact record boundary, which will cause the loop control to do the
wrong thing.

The previous patch should take care of that problem, but let's add this
extra sanity check to stop corruption problems sooner than later.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_refcount.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index c1ebc5047b..5ba8241998 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1133,6 +1133,32 @@ xfs_refcount_finish_one_cleanup(
 		xfs_trans_brelse(tp, agbp);
 }
 
+/*
+ * Set up a continuation a deferred refcount operation by updating the intent.
+ * Checks to make sure we're not going to run off the end of the AG.
+ */
+static inline int
+xfs_refcount_continue_op(
+	struct xfs_btree_cur		*cur,
+	xfs_fsblock_t			startblock,
+	xfs_agblock_t			new_agbno,
+	xfs_extlen_t			new_len,
+	xfs_fsblock_t			*new_fsbno)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_perag		*pag = cur->bc_ag.pag;
+
+	if (XFS_IS_CORRUPT(mp, !xfs_verify_agbext(pag, new_agbno, new_len)))
+		return -EFSCORRUPTED;
+
+	*new_fsbno = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+
+	ASSERT(xfs_verify_fsbext(mp, *new_fsbno, new_len));
+	ASSERT(pag->pag_agno == XFS_FSB_TO_AGNO(mp, *new_fsbno));
+
+	return 0;
+}
+
 /*
  * Process one of the deferred refcount operations.  We pass back the
  * btree cursor to maintain our lock on the btree between calls.
@@ -1200,12 +1226,20 @@ xfs_refcount_finish_one(
 	case XFS_REFCOUNT_INCREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
 				new_len, XFS_REFCOUNT_ADJUST_INCREASE);
-		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+		if (error)
+			goto out_drop;
+		if (*new_len > 0)
+			error = xfs_refcount_continue_op(rcur, startblock,
+					new_agbno, *new_len, new_fsb);
 		break;
 	case XFS_REFCOUNT_DECREASE:
 		error = xfs_refcount_adjust(rcur, bno, blockcount, &new_agbno,
 				new_len, XFS_REFCOUNT_ADJUST_DECREASE);
-		*new_fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+		if (error)
+			goto out_drop;
+		if (*new_len > 0)
+			error = xfs_refcount_continue_op(rcur, startblock,
+					new_agbno, *new_len, new_fsb);
 		break;
 	case XFS_REFCOUNT_ALLOC_COW:
 		*new_fsb = startblock + blockcount;

