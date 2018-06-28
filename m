Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60106 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932350AbeF1Qgk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DFFFBA5030
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CABED111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:37 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 10/24] xfs: use ->t_dfops in dqalloc transaction
Date: Thu, 28 Jun 2018 12:36:22 -0400
Message-Id: <20180628163636.52564-11-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfs_dquot_disk_alloc() receives a transaction from the caller and
passes a local dfops along to xfs_bmapi_write(). If we attach this
dfops to the transaction, we have to make sure to clear it before
returning to avoid invalid access of stack memory.

Since xfs_qm_dqread_alloc() is the only caller, pull dfops into the
caller and attach it to the transaction to eliminate this pattern
entirely.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_dquot.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 0973a0423bed..aa62f8b17376 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -286,8 +286,8 @@ xfs_dquot_disk_alloc(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_bmbt_irec	map;
-	struct xfs_defer_ops	dfops;
-	struct xfs_mount	*mp = (*tpp)->t_mountp;
+	struct xfs_trans	*tp = *tpp;
+	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*bp;
 	struct xfs_inode	*quotip = xfs_quota_inode(mp, dqp->dq_flags);
 	xfs_fsblock_t		firstblock;
@@ -296,7 +296,8 @@ xfs_dquot_disk_alloc(
 
 	trace_xfs_dqalloc(dqp);
 
-	xfs_defer_init(&dfops, &firstblock);
+	xfs_defer_init(tp->t_dfops, &firstblock);
+
 	xfs_ilock(quotip, XFS_ILOCK_EXCL);
 	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
 		/*
@@ -308,11 +309,11 @@ xfs_dquot_disk_alloc(
 	}
 
 	/* Create the block mapping. */
-	xfs_trans_ijoin(*tpp, quotip, XFS_ILOCK_EXCL);
-	error = xfs_bmapi_write(*tpp, quotip, dqp->q_fileoffset,
+	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
+	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
 			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
 			&firstblock, XFS_QM_DQALLOC_SPACE_RES(mp),
-			&map, &nmaps, &dfops);
+			&map, &nmaps, tp->t_dfops);
 	if (error)
 		goto error0;
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
@@ -326,7 +327,7 @@ xfs_dquot_disk_alloc(
 	dqp->q_blkno = XFS_FSB_TO_DADDR(mp, map.br_startblock);
 
 	/* now we can just get the buffer (there's nothing to read yet) */
-	bp = xfs_trans_get_buf(*tpp, mp->m_ddev_targp, dqp->q_blkno,
+	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, dqp->q_blkno,
 			mp->m_quotainfo->qi_dqchunklen, 0);
 	if (!bp) {
 		error = -ENOMEM;
@@ -338,7 +339,7 @@ xfs_dquot_disk_alloc(
 	 * Make a chunk of dquots out of this buffer and log
 	 * the entire thing.
 	 */
-	xfs_qm_init_dquot_blk(*tpp, mp, be32_to_cpu(dqp->q_core.d_id),
+	xfs_qm_init_dquot_blk(tp, mp, be32_to_cpu(dqp->q_core.d_id),
 			      dqp->dq_flags & XFS_DQ_ALLTYPES, bp);
 	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
 
@@ -364,14 +365,15 @@ xfs_dquot_disk_alloc(
 	 * is responsible for unlocking any buffer passed back, either
 	 * manually or by committing the transaction.
 	 */
-	xfs_trans_bhold(*tpp, bp);
-	error = xfs_defer_bjoin(&dfops, bp);
+	xfs_trans_bhold(tp, bp);
+	error = xfs_defer_bjoin(tp->t_dfops, bp);
 	if (error) {
-		xfs_trans_bhold_release(*tpp, bp);
-		xfs_trans_brelse(*tpp, bp);
+		xfs_trans_bhold_release(tp, bp);
+		xfs_trans_brelse(tp, bp);
 		goto error1;
 	}
-	error = xfs_defer_finish(tpp, &dfops);
+	error = xfs_defer_finish(tpp, tp->t_dfops);
+	tp = *tpp;
 	if (error) {
 		xfs_buf_relse(bp);
 		goto error1;
@@ -380,7 +382,7 @@ xfs_dquot_disk_alloc(
 	return 0;
 
 error1:
-	xfs_defer_cancel(&dfops);
+	xfs_defer_cancel(tp->t_dfops);
 error0:
 	return error;
 }
@@ -538,13 +540,17 @@ xfs_qm_dqread_alloc(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_trans	*tp;
+	struct xfs_defer_ops	dfops;
 	struct xfs_buf		*bp;
+	xfs_fsblock_t		firstblock;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
 			XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
 	if (error)
 		goto err;
+	xfs_defer_init(&dfops, &firstblock);
+	tp->t_dfops = &dfops;
 
 	error = xfs_dquot_disk_alloc(&tp, dqp, &bp);
 	if (error)
-- 
2.17.1

