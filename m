Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6395C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 23:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbiADXmU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 18:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiADXmU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 18:42:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10065C061761
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 15:42:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF3A0B81846
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 23:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713EEC36AEB
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 23:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641339736;
        bh=pMPgHj6YlnKrQ+VPoC32H4IjAt1F6dd4N+U4Zkm/fOg=;
        h=Date:From:To:Subject:From;
        b=XTgw+NC1AWp/+QujuxXz46ZyOi3jJe9U5wsvmqh4locWz5suw4mjq6V7PPDyD94kf
         71bXHGXpARkHdCPDm6Zx3whweOnsZFHnOkNn2IoO+vbYcRAoW9ylPKdIhp4P+GuKTa
         JBYg2ZKHqEoccf89OnNpO2/DQlQ4ybgXwOXVJjTRDWmtaQLYybljJdNED5eeLMizLN
         iYO6WRI7KXPATXiD+oE/MflPQtYw+hruJw6HesVKJ08lbNIXSUq7hkFpvdBil3fTG8
         q3SMsTA5JgBF/fH6EuxaihUZa7IKPFKQiHs8oNoZBmcJX24/UMIHmCriZ6gPWA2+B0
         rFE3qQgVsEl5g==
Date:   Tue, 4 Jan 2022 15:42:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: hold quota inode ILOCK_EXCL until the end of dqalloc
Message-ID: <20220104234216.GI31583@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Online fsck depends on callers holding ILOCK_EXCL from the time they
decide to update a block mapping until after they've updated the reverse
mapping records to guarantee the stability of both mapping records.
Unfortunately, the quota code drops ILOCK_EXCL at the first transaction
roll in the dquot allocation process, which breaks that assertion.  This
leads to sporadic failures in the online rmap repair code if the repair
code grabs the AGF after bmapi_write maps a new block into the quota
file's data fork but before it can finish the deferred rmap update.

Fix this by rewriting the function to hold the ILOCK until after the
transaction commit like all other bmap updates do, and get rid of the
dqread wrapper that does nothing but complicate the codebase.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c |   79 ++++++++++++++++++----------------------------------
 1 file changed, 28 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index e48ae227bb11..5afedcbc78c7 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -289,13 +289,12 @@ xfs_dquot_set_prealloc_limits(struct xfs_dquot *dqp)
  */
 STATIC int
 xfs_dquot_disk_alloc(
-	struct xfs_trans	**tpp,
 	struct xfs_dquot	*dqp,
 	struct xfs_buf		**bpp)
 {
 	struct xfs_bmbt_irec	map;
-	struct xfs_trans	*tp = *tpp;
-	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_buf		*bp;
 	xfs_dqtype_t		qtype = xfs_dquot_type(dqp);
 	struct xfs_inode	*quotip = xfs_quota_inode(mp, qtype);
@@ -304,29 +303,35 @@ xfs_dquot_disk_alloc(
 
 	trace_xfs_dqalloc(dqp);
 
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
+			XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
+	if (error)
+		return error;
+
 	xfs_ilock(quotip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, quotip, 0);
+
 	if (!xfs_this_quota_on(dqp->q_mount, qtype)) {
 		/*
 		 * Return if this type of quotas is turned off while we didn't
 		 * have an inode lock
 		 */
-		xfs_iunlock(quotip, XFS_ILOCK_EXCL);
-		return -ESRCH;
+		error = -ESRCH;
+		goto err_cancel;
 	}
 
-	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
-
 	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
-		return error;
+		goto err_cancel;
 
 	/* Create the block mapping. */
 	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
 			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
 			&nmaps);
 	if (error)
-		return error;
+		goto err_cancel;
+
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
 	ASSERT(nmaps == 1);
 	ASSERT((map.br_startblock != DELAYSTARTBLOCK) &&
@@ -341,7 +346,7 @@ xfs_dquot_disk_alloc(
 	error = xfs_trans_get_buf(tp, mp->m_ddev_targp, dqp->q_blkno,
 			mp->m_quotainfo->qi_dqchunklen, 0, &bp);
 	if (error)
-		return error;
+		goto err_cancel;
 	bp->b_ops = &xfs_dquot_buf_ops;
 
 	/*
@@ -371,16 +376,25 @@ xfs_dquot_disk_alloc(
 	 * is responsible for unlocking any buffer passed back, either
 	 * manually or by committing the transaction.  On error, the buffer is
 	 * released and not passed back.
+	 *
+	 * Keep the quota inode ILOCKed until after the transaction commit to
+	 * maintain the atomicity of bmap/rmap updates.
 	 */
 	xfs_trans_bhold(tp, bp);
-	error = xfs_defer_finish(tpp);
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(quotip, XFS_ILOCK_EXCL);
 	if (error) {
-		xfs_trans_bhold_release(*tpp, bp);
-		xfs_trans_brelse(*tpp, bp);
+		xfs_buf_relse(bp);
 		return error;
 	}
+
 	*bpp = bp;
 	return 0;
+
+err_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(quotip, XFS_ILOCK_EXCL);
+	return error;
 }
 
 /*
@@ -629,43 +643,6 @@ xfs_dquot_to_disk(
 	ddqp->d_rtbtimer = xfs_dquot_to_disk_ts(dqp, dqp->q_rtb.timer);
 }
 
-/* Allocate and initialize the dquot buffer for this in-core dquot. */
-static int
-xfs_qm_dqread_alloc(
-	struct xfs_mount	*mp,
-	struct xfs_dquot	*dqp,
-	struct xfs_buf		**bpp)
-{
-	struct xfs_trans	*tp;
-	int			error;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
-			XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
-	if (error)
-		goto err;
-
-	error = xfs_dquot_disk_alloc(&tp, dqp, bpp);
-	if (error)
-		goto err_cancel;
-
-	error = xfs_trans_commit(tp);
-	if (error) {
-		/*
-		 * Buffer was held to the transaction, so we have to unlock it
-		 * manually here because we're not passing it back.
-		 */
-		xfs_buf_relse(*bpp);
-		*bpp = NULL;
-		goto err;
-	}
-	return 0;
-
-err_cancel:
-	xfs_trans_cancel(tp);
-err:
-	return error;
-}
-
 /*
  * Read in the ondisk dquot using dqtobp() then copy it to an incore version,
  * and release the buffer immediately.  If @can_alloc is true, fill any
@@ -689,7 +666,7 @@ xfs_qm_dqread(
 	/* Try to read the buffer, allocating if necessary. */
 	error = xfs_dquot_disk_read(mp, dqp, &bp);
 	if (error == -ENOENT && can_alloc)
-		error = xfs_qm_dqread_alloc(mp, dqp, &bp);
+		error = xfs_dquot_disk_alloc(dqp, &bp);
 	if (error)
 		goto err;
 
