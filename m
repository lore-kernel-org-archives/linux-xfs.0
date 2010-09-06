Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o861i2QH144527 for <xfs@oss.sgi.com>; Sun, 5 Sep 2010 20:44:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C70817A5C51
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 18:44:45 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id H9SujN7iZvf46DFl for
	<xfs@oss.sgi.com>; Sun, 05 Sep 2010 18:44:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OsQlJ-0000SB-9j
	for xfs@oss.sgi.com; Mon, 06 Sep 2010 01:44:45 +0000
Date: Sun, 5 Sep 2010 21:44:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: stop using xfs_qm_dqtobp in xfs_qm_dqflush
Message-ID: <20100906014445.GB1587@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

In xfs_qm_dqflush we know that q_blkno must be initialized already from a
previous xfs_qm_dqread.  So instead of calling xfs_qm_dqtobp we can
simply read the quota buffer directly.  This also saves us from a duplicate
xfs_qm_dqcheck call check and allows xfs_qm_dqtobp to be simplified now
that it is always called for a newly initialized inode.  In addition to
that properly unwind all locks in xfs_qm_dqflush when xfs_qm_dqcheck
fails.

This mirrors a similar cleanup in the inode lookup done earlier.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2010-09-05 18:02:08.561011406 -0300
+++ xfs/fs/xfs/quota/xfs_dquot.c	2010-09-05 18:04:29.537005743 -0300
@@ -463,88 +463,69 @@ xfs_qm_dqtobp(
 	uint			flags)
 {
 	xfs_bmbt_irec_t map;
-	int		nmaps, error;
+	int		nmaps = 1, error;
 	xfs_buf_t	*bp;
-	xfs_inode_t	*quotip;
-	xfs_mount_t	*mp;
+	xfs_inode_t	*quotip = XFS_DQ_TO_QIP(dqp);
+	xfs_mount_t	*mp = dqp->q_mount;
 	xfs_disk_dquot_t *ddq;
-	xfs_dqid_t	id;
-	boolean_t	newdquot;
+	xfs_dqid_t	id = be32_to_cpu(dqp->q_core.d_id);
 	xfs_trans_t	*tp = (tpp ? *tpp : NULL);
 
-	mp = dqp->q_mount;
-	id = be32_to_cpu(dqp->q_core.d_id);
-	nmaps = 1;
-	newdquot = B_FALSE;
+	dqp->q_fileoffset = (xfs_fileoff_t)id / mp->m_quotainfo->qi_dqperchunk;
 
-	/*
-	 * If we don't know where the dquot lives, find out.
-	 */
-	if (dqp->q_blkno == (xfs_daddr_t) 0) {
-		/* We use the id as an index */
-		dqp->q_fileoffset = (xfs_fileoff_t)id /
-					mp->m_quotainfo->qi_dqperchunk;
-		nmaps = 1;
-		quotip = XFS_DQ_TO_QIP(dqp);
-		xfs_ilock(quotip, XFS_ILOCK_SHARED);
+	xfs_ilock(quotip, XFS_ILOCK_SHARED);
+	if (XFS_IS_THIS_QUOTA_OFF(dqp)) {
 		/*
-		 * Return if this type of quotas is turned off while we didn't
-		 * have an inode lock
+		 * Return if this type of quotas is turned off while we
+		 * didn't have the quota inode lock.
 		 */
-		if (XFS_IS_THIS_QUOTA_OFF(dqp)) {
-			xfs_iunlock(quotip, XFS_ILOCK_SHARED);
-			return (ESRCH);
-		}
-		/*
-		 * Find the block map; no allocations yet
-		 */
-		error = xfs_bmapi(NULL, quotip, dqp->q_fileoffset,
-				  XFS_DQUOT_CLUSTER_SIZE_FSB,
-				  XFS_BMAPI_METADATA,
-				  NULL, 0, &map, &nmaps, NULL);
-
 		xfs_iunlock(quotip, XFS_ILOCK_SHARED);
-		if (error)
-			return (error);
-		ASSERT(nmaps == 1);
-		ASSERT(map.br_blockcount == 1);
+		return ESRCH;
+	}
 
-		/*
-		 * offset of dquot in the (fixed sized) dquot chunk.
-		 */
-		dqp->q_bufoffset = (id % mp->m_quotainfo->qi_dqperchunk) *
-			sizeof(xfs_dqblk_t);
-		if (map.br_startblock == HOLESTARTBLOCK) {
-			/*
-			 * We don't allocate unless we're asked to
-			 */
-			if (!(flags & XFS_QMOPT_DQALLOC))
-				return (ENOENT);
+	/*
+	 * Find the block map; no allocations yet
+	 */
+	error = xfs_bmapi(NULL, quotip, dqp->q_fileoffset,
+			  XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
+			  NULL, 0, &map, &nmaps, NULL);
 
-			ASSERT(tp);
-			if ((error = xfs_qm_dqalloc(tpp, mp, dqp, quotip,
-						dqp->q_fileoffset, &bp)))
-				return (error);
-			tp = *tpp;
-			newdquot = B_TRUE;
-		} else {
-			/*
-			 * store the blkno etc so that we don't have to do the
-			 * mapping all the time
-			 */
-			dqp->q_blkno = XFS_FSB_TO_DADDR(mp, map.br_startblock);
-		}
-	}
-	ASSERT(dqp->q_blkno != DELAYSTARTBLOCK);
-	ASSERT(dqp->q_blkno != HOLESTARTBLOCK);
+	xfs_iunlock(quotip, XFS_ILOCK_SHARED);
+	if (error)
+		return error;
+
+	ASSERT(nmaps == 1);
+	ASSERT(map.br_blockcount == 1);
 
 	/*
-	 * Read in the buffer, unless we've just done the allocation
-	 * (in which case we already have the buf).
+	 * Offset of dquot in the (fixed sized) dquot chunk.
 	 */
-	if (!newdquot) {
+	dqp->q_bufoffset = (id % mp->m_quotainfo->qi_dqperchunk) *
+		sizeof(xfs_dqblk_t);
+
+	ASSERT(map.br_startblock != DELAYSTARTBLOCK);
+	if (map.br_startblock == HOLESTARTBLOCK) {
+		/*
+		 * We don't allocate unless we're asked to
+		 */
+		if (!(flags & XFS_QMOPT_DQALLOC))
+			return ENOENT;
+
+		ASSERT(tp);
+		error = xfs_qm_dqalloc(tpp, mp, dqp, quotip,
+					dqp->q_fileoffset, &bp);
+		if (error)
+			return error;
+		tp = *tpp;
+	} else {
 		trace_xfs_dqtobp_read(dqp);
 
+		/*
+		 * store the blkno etc so that we don't have to do the
+		 * mapping all the time
+		 */
+		dqp->q_blkno = XFS_FSB_TO_DADDR(mp, map.br_startblock);
+
 		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
 					   dqp->q_blkno,
 					   mp->m_quotainfo->qi_dqchunklen,
@@ -552,13 +533,14 @@ xfs_qm_dqtobp(
 		if (error || !bp)
 			return XFS_ERROR(error);
 	}
+
 	ASSERT(XFS_BUF_ISBUSY(bp));
 	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
 
 	/*
 	 * calculate the location of the dquot inside the buffer.
 	 */
-	ddq = (xfs_disk_dquot_t *)((char *)XFS_BUF_PTR(bp) + dqp->q_bufoffset);
+	ddq = (struct xfs_disk_dquot *)(XFS_BUF_PTR(bp) + dqp->q_bufoffset);
 
 	/*
 	 * A simple sanity check in case we got a corrupted dquot...
@@ -1176,18 +1158,18 @@ xfs_qm_dqflush(
 	xfs_dquot_t		*dqp,
 	uint			flags)
 {
-	xfs_mount_t		*mp;
-	xfs_buf_t		*bp;
-	xfs_disk_dquot_t	*ddqp;
+	struct xfs_mount	*mp = dqp->q_mount;
+	struct xfs_buf		*bp;
+	struct xfs_disk_dquot	*ddqp;
 	int			error;
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	ASSERT(!completion_done(&dqp->q_flush));
+
 	trace_xfs_dqflush(dqp);
 
 	/*
-	 * If not dirty, or it's pinned and we are not supposed to
-	 * block, nada.
+	 * If not dirty, or it's pinned and we are not supposed to block, nada.
 	 */
 	if (!XFS_DQ_IS_DIRTY(dqp) ||
 	    (!(flags & SYNC_WAIT) && atomic_read(&dqp->q_pincount) > 0)) {
@@ -1201,40 +1183,46 @@ xfs_qm_dqflush(
 	 * down forcibly. If that's the case we must not write this dquot
 	 * to disk, because the log record didn't make it to disk!
 	 */
-	if (XFS_FORCED_SHUTDOWN(dqp->q_mount)) {
-		dqp->dq_flags &= ~(XFS_DQ_DIRTY);
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		dqp->dq_flags &= ~XFS_DQ_DIRTY;
 		xfs_dqfunlock(dqp);
 		return XFS_ERROR(EIO);
 	}
 
 	/*
 	 * Get the buffer containing the on-disk dquot
-	 * We don't need a transaction envelope because we know that the
-	 * the ondisk-dquot has already been allocated for.
 	 */
-	if ((error = xfs_qm_dqtobp(NULL, dqp, &ddqp, &bp, XFS_QMOPT_DOWARN))) {
+	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
+				   mp->m_quotainfo->qi_dqchunklen, 0, &bp);
+	if (error) {
 		ASSERT(error != ENOENT);
-		/*
-		 * Quotas could have gotten turned off (ESRCH)
-		 */
 		xfs_dqfunlock(dqp);
-		return (error);
+		return error;
 	}
 
-	if (xfs_qm_dqcheck(&dqp->q_core, be32_to_cpu(ddqp->d_id),
-			   0, XFS_QMOPT_DOWARN, "dqflush (incore copy)")) {
-		xfs_force_shutdown(dqp->q_mount, SHUTDOWN_CORRUPT_INCORE);
+	/*
+	 * Calculate the location of the dquot inside the buffer.
+	 */
+	ddqp = (struct xfs_disk_dquot *)(XFS_BUF_PTR(bp) + dqp->q_bufoffset);
+
+	/*
+	 * A simple sanity check in case we got a corrupted dquot..
+	 */
+	if (xfs_qm_dqcheck(&dqp->q_core, be32_to_cpu(ddqp->d_id), 0,
+			   XFS_QMOPT_DOWARN, "dqflush (incore copy)")) {
+		xfs_buf_relse(bp);
+		xfs_dqfunlock(dqp);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		return XFS_ERROR(EIO);
 	}
 
 	/* This is the only portion of data that needs to persist */
-	memcpy(ddqp, &(dqp->q_core), sizeof(xfs_disk_dquot_t));
+	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
 
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
 	 */
-	dqp->dq_flags &= ~(XFS_DQ_DIRTY);
-	mp = dqp->q_mount;
+	dqp->dq_flags &= ~XFS_DQ_DIRTY;
 
 	xfs_trans_ail_copy_lsn(mp->m_ail, &dqp->q_logitem.qli_flush_lsn,
 					&dqp->q_logitem.qli_item.li_lsn);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
