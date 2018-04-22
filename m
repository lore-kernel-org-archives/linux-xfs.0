Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42726 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754767AbeDVPG5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Apr 2018 11:06:57 -0400
Subject: [PATCH 08/13] xfs: refactor xfs_qm_dqtobp and xfs_qm_dqalloc
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 22 Apr 2018 08:06:44 -0700
Message-ID: <152440960423.29601.4842354354335883165.stgit@magnolia>
In-Reply-To: <152440954198.29601.14390250048915099607.stgit@magnolia>
References: <152440954198.29601.14390250048915099607.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

Separate the disk dquot read and allocation functionality into
two helper functions, then refactor dqread to call them directly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c |  261 ++++++++++++++++++++--------------------------------
 1 file changed, 99 insertions(+), 162 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7154909..ef4cd56 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -288,49 +288,44 @@ xfs_dquot_set_prealloc_limits(struct xfs_dquot *dqp)
 }
 
 /*
- * Allocate a block and fill it with dquots.
- * This is called when the bmapi finds a hole.
+ * Ensure that the given in-core dquot has a buffer on disk backing it, and
+ * return the buffer. This is called when the bmapi finds a hole.
  */
 STATIC int
-xfs_qm_dqalloc(
-	xfs_trans_t	**tpp,
-	xfs_mount_t	*mp,
-	xfs_dquot_t	*dqp,
-	xfs_inode_t	*quotip,
-	xfs_fileoff_t	offset_fsb,
-	xfs_buf_t	**O_bpp)
+xfs_qm_dqalloc_ondisk(
+	struct xfs_trans	**tpp,
+	struct xfs_dquot	*dqp,
+	struct xfs_buf		**bpp)
 {
-	xfs_fsblock_t	firstblock;
-	struct xfs_defer_ops dfops;
-	xfs_bmbt_irec_t map;
-	int		nmaps, error;
-	xfs_buf_t	*bp;
-	xfs_trans_t	*tp = *tpp;
-
-	ASSERT(tp != NULL);
+	struct xfs_bmbt_irec	map;
+	struct xfs_defer_ops	dfops;
+	struct xfs_mount	*mp = (*tpp)->t_mountp;
+	struct xfs_buf		*bp;
+	struct xfs_inode	*quotip;
+	xfs_fsblock_t		firstblock;
+	int			nmaps = 1;
+	int			error;
 
 	trace_xfs_dqalloc(dqp);
 
-	/*
-	 * Initialize the bmap freelist prior to calling bmapi code.
-	 */
+	quotip = xfs_quota_inode(mp, dqp->dq_flags);
 	xfs_defer_init(&dfops, &firstblock);
 	xfs_ilock(quotip, XFS_ILOCK_EXCL);
-	/*
-	 * Return if this type of quotas is turned off while we didn't
-	 * have an inode lock
-	 */
 	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
+		/*
+		 * Return if this type of quotas is turned off while we didn't
+		 * have an inode lock
+		 */
 		xfs_iunlock(quotip, XFS_ILOCK_EXCL);
 		return -ESRCH;
 	}
 
-	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
-	nmaps = 1;
-	error = xfs_bmapi_write(tp, quotip, offset_fsb,
-				XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
-				&firstblock, XFS_QM_DQALLOC_SPACE_RES(mp),
-				&map, &nmaps, &dfops);
+	/* Create the block mapping. */
+	xfs_trans_ijoin(*tpp, quotip, XFS_ILOCK_EXCL);
+	error = xfs_bmapi_write(*tpp, quotip, dqp->q_fileoffset,
+			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
+			&firstblock, XFS_QM_DQALLOC_SPACE_RES(mp),
+			&map, &nmaps, &dfops);
 	if (error)
 		goto error0;
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
@@ -344,10 +339,8 @@ xfs_qm_dqalloc(
 	dqp->q_blkno = XFS_FSB_TO_DADDR(mp, map.br_startblock);
 
 	/* now we can just get the buffer (there's nothing to read yet) */
-	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
-			       dqp->q_blkno,
-			       mp->m_quotainfo->qi_dqchunklen,
-			       0);
+	bp = xfs_trans_get_buf(*tpp, mp->m_ddev_targp, dqp->q_blkno,
+			mp->m_quotainfo->qi_dqchunklen, 0);
 	if (!bp) {
 		error = -ENOMEM;
 		goto error1;
@@ -358,37 +351,22 @@ xfs_qm_dqalloc(
 	 * Make a chunk of dquots out of this buffer and log
 	 * the entire thing.
 	 */
-	xfs_qm_init_dquot_blk(tp, mp, be32_to_cpu(dqp->q_core.d_id),
+	xfs_qm_init_dquot_blk(*tpp, mp, be32_to_cpu(dqp->q_core.d_id),
 			      dqp->dq_flags & XFS_DQ_ALLTYPES, bp);
+	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
 
 	/*
-	 * xfs_defer_finish() may commit the current transaction and
-	 * start a second transaction if the freelist is not empty.
-	 *
-	 * Since we still want to modify this buffer, we need to
-	 * ensure that the buffer is not released on commit of
-	 * the first transaction and ensure the buffer is added to the
-	 * second transaction.
-	 *
-	 * If there is only one transaction then don't stop the buffer
-	 * from being released when it commits later on.
+	 * Hold the buffer and join it to the dfops so that we'll still own
+	 * the buffer when we return to the caller.
 	 */
-
-	xfs_trans_bhold(tp, bp);
-
+	xfs_trans_bhold(*tpp, bp);
+	error = xfs_defer_bjoin(&dfops, bp);
+	if (error)
+		goto error1;
 	error = xfs_defer_finish(tpp, &dfops);
 	if (error)
 		goto error1;
-
-	/* Transaction was committed? */
-	if (*tpp != tp) {
-		tp = *tpp;
-		xfs_trans_bjoin(tp, bp);
-	} else {
-		xfs_trans_bhold_release(tp, bp);
-	}
-
-	*O_bpp = bp;
+	*bpp = bp;
 	return 0;
 
 error1:
@@ -398,32 +376,25 @@ xfs_qm_dqalloc(
 }
 
 /*
- * Maps a dquot to the buffer containing its on-disk version.
- * This returns a ptr to the buffer containing the on-disk dquot
- * in the bpp param, and a ptr to the on-disk dquot within that buffer
+ * Read in the in-core dquot's on-disk metadata and return the buffer.
+ * Returns ENOENT to signal a hole.
  */
 STATIC int
-xfs_qm_dqtobp(
-	xfs_trans_t		**tpp,
-	xfs_dquot_t		*dqp,
-	xfs_disk_dquot_t	**O_ddpp,
-	xfs_buf_t		**O_bpp,
-	uint			flags)
+xfs_qm_dqread_ondisk(
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*dqp,
+	struct xfs_buf		**bpp)
 {
 	struct xfs_bmbt_irec	map;
-	int			nmaps = 1, error;
 	struct xfs_buf		*bp;
 	struct xfs_inode	*quotip;
-	struct xfs_mount	*mp = dqp->q_mount;
-	xfs_dqid_t		id = be32_to_cpu(dqp->q_core.d_id);
-	struct xfs_trans	*tp = (tpp ? *tpp : NULL);
 	uint			lock_mode;
+	int			nmaps = 1;
+	int			error;
 
-	quotip = xfs_quota_inode(dqp->q_mount, dqp->dq_flags);
-	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
-
+	quotip = xfs_quota_inode(mp, dqp->dq_flags);
 	lock_mode = xfs_ilock_data_map_shared(quotip);
-	if (!xfs_this_quota_on(dqp->q_mount, dqp->dq_flags)) {
+	if (!xfs_this_quota_on(mp, dqp->dq_flags)) {
 		/*
 		 * Return if this type of quotas is turned off while we
 		 * didn't have the quota inode lock.
@@ -436,57 +407,36 @@ xfs_qm_dqtobp(
 	 * Find the block map; no allocations yet
 	 */
 	error = xfs_bmapi_read(quotip, dqp->q_fileoffset,
-			       XFS_DQUOT_CLUSTER_SIZE_FSB, &map, &nmaps, 0);
-
+			XFS_DQUOT_CLUSTER_SIZE_FSB, &map, &nmaps, 0);
 	xfs_iunlock(quotip, lock_mode);
 	if (error)
 		return error;
 
 	ASSERT(nmaps == 1);
-	ASSERT(map.br_blockcount == 1);
+	ASSERT(map.br_blockcount >= 1);
+	ASSERT(map.br_startblock != DELAYSTARTBLOCK);
+	if (map.br_startblock == HOLESTARTBLOCK)
+		return -ENOENT;
+
+	trace_xfs_dqtobp_read(dqp);
 
 	/*
-	 * Offset of dquot in the (fixed sized) dquot chunk.
+	 * store the blkno etc so that we don't have to do the
+	 * mapping all the time
 	 */
-	dqp->q_bufoffset = (id % mp->m_quotainfo->qi_dqperchunk) *
-		sizeof(xfs_dqblk_t);
-
-	ASSERT(map.br_startblock != DELAYSTARTBLOCK);
-	if (map.br_startblock == HOLESTARTBLOCK) {
-		/*
-		 * We don't allocate unless we're asked to
-		 */
-		if (!(flags & XFS_QMOPT_DQALLOC))
-			return -ENOENT;
-
-		ASSERT(tp);
-		error = xfs_qm_dqalloc(tpp, mp, dqp, quotip,
-					dqp->q_fileoffset, &bp);
-		if (error)
-			return error;
-		tp = *tpp;
-	} else {
-		trace_xfs_dqtobp_read(dqp);
+	dqp->q_blkno = XFS_FSB_TO_DADDR(mp, map.br_startblock);
 
-		/*
-		 * store the blkno etc so that we don't have to do the
-		 * mapping all the time
-		 */
-		dqp->q_blkno = XFS_FSB_TO_DADDR(mp, map.br_startblock);
-
-		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-					   dqp->q_blkno,
-					   mp->m_quotainfo->qi_dqchunklen,
-					   0, &bp, &xfs_dquot_buf_ops);
-		if (error) {
-			ASSERT(bp == NULL);
-			return error;
-		}
+	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
+			mp->m_quotainfo->qi_dqchunklen, 0, &bp,
+			&xfs_dquot_buf_ops);
+	if (error) {
+		ASSERT(bp == NULL);
+		return error;
 	}
 
 	ASSERT(xfs_buf_islocked(bp));
-	*O_bpp = bp;
-	*O_ddpp = bp->b_addr + dqp->q_bufoffset;
+	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
+	*bpp = bp;
 
 	return 0;
 }
@@ -508,6 +458,12 @@ xfs_qm_dqinit_once(
 	INIT_LIST_HEAD(&dqp->q_lru);
 	mutex_init(&dqp->q_qlock);
 	init_waitqueue_head(&dqp->q_pinwait);
+	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
+	/*
+	 * Offset of dquot in the (fixed sized) dquot chunk.
+	 */
+	dqp->q_bufoffset = (id % mp->m_quotainfo->qi_dqperchunk) *
+			sizeof(xfs_dqblk_t);
 
 	/*
 	 * Because we want to use a counting completion, complete
@@ -544,8 +500,10 @@ xfs_qm_dqinit_once(
 STATIC void
 xfs_qm_dqinit_from_buf(
 	struct xfs_dquot	*dqp,
-	struct xfs_disk_dquot	*ddqp)
+	struct xfs_buf		*bp)
 {
+	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
+
 	/* copy everything from disk dquot to the incore dquot */
 	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
 	xfs_qm_dquot_logitem_init(dqp);
@@ -574,74 +532,53 @@ xfs_qm_dqread(
 	xfs_dqid_t		id,
 	uint			type,
 	uint			flags,
-	struct xfs_dquot	**O_dqpp)
+	struct xfs_dquot	**dqpp)
 {
 	struct xfs_dquot	*dqp;
-	struct xfs_disk_dquot	*ddqp;
 	struct xfs_buf		*bp;
-	struct xfs_trans	*tp = NULL;
+	struct xfs_trans	*tp;
 	int			error;
 
 	dqp = xfs_qm_dqinit_once(mp, id, type);
 	trace_xfs_dqread(dqp);
 
-	if (flags & XFS_QMOPT_DQALLOC) {
+	/* Try to read the buffer... */
+	error = xfs_qm_dqread_ondisk(mp, dqp, &bp);
+	if (error == -ENOENT && (flags & XFS_QMOPT_DQALLOC)) {
+		/* ...or allocate a new block and buffer. */
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_dqalloc,
 				XFS_QM_DQALLOC_SPACE_RES(mp), 0, 0, &tp);
 		if (error)
-			goto error0;
-	}
+			goto err;
 
-	/*
-	 * get a pointer to the on-disk dquot and the buffer containing it
-	 * dqp already knows its own type (GROUP/USER).
-	 */
-	error = xfs_qm_dqtobp(&tp, dqp, &ddqp, &bp, flags);
-	if (error) {
-		/*
-		 * This can happen if quotas got turned off (ESRCH),
-		 * or if the dquot didn't exist on disk and we ask to
-		 * allocate (ENOENT).
-		 */
-		trace_xfs_dqread_fail(dqp);
-		goto error1;
-	}
+		error = xfs_qm_dqalloc_ondisk(&tp, dqp, &bp);
+		if (error)
+			goto err_cancel;
 
-	xfs_qm_dqinit_from_buf(dqp, ddqp);
+		error = xfs_trans_commit(tp);
+	}
+	ASSERT(xfs_buf_islocked(bp));
+	if (error)
+		goto err;
 
-	/* Mark the buf so that this will stay incore a little longer */
-	xfs_buf_set_ref(bp, XFS_DQUOT_REF);
+	xfs_qm_dqinit_from_buf(dqp, bp);
 
 	/*
-	 * We got the buffer with a xfs_trans_read_buf() (in dqtobp())
-	 * So we need to release with xfs_trans_brelse().
-	 * The strategy here is identical to that of inodes; we lock
-	 * the dquot in xfs_qm_dqget() before making it accessible to
-	 * others. This is because dquots, like inodes, need a good level of
-	 * concurrency, and we don't want to take locks on the entire buffers
-	 * for dquot accesses.
-	 * Note also that the dquot buffer may even be dirty at this point, if
-	 * this particular dquot was repaired. We still aren't afraid to
-	 * brelse it because we have the changes incore.
+	 * At this point we should have a clean locked buffer.  Release the
+	 * buffer since the incore dquot has its own copy and locking
+	 * protocol so we needn't tie up the buffer any further.
 	 */
 	ASSERT(xfs_buf_islocked(bp));
-	xfs_trans_brelse(tp, bp);
-
-	if (tp) {
-		error = xfs_trans_commit(tp);
-		if (error)
-			goto error0;
-	}
-
-	*O_dqpp = dqp;
+	xfs_buf_relse(bp);
+	*dqpp = dqp;
 	return error;
 
-error1:
-	if (tp)
-		xfs_trans_cancel(tp);
-error0:
+err_cancel:
+	xfs_trans_cancel(tp);
+err:
+	trace_xfs_dqread_fail(dqp);
 	xfs_qm_dqdestroy(dqp);
-	*O_dqpp = NULL;
+	*dqpp = NULL;
 	return error;
 }
 

