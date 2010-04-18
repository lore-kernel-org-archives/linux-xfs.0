Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3I090nu096522 for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 19:09:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9BAFF1DD6C68
	for <xfs@oss.sgi.com>; Sat, 17 Apr 2010 17:10:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YAWBQHGkGD54NRM3 for
	<xfs@oss.sgi.com>; Sat, 17 Apr 2010 17:10:58 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O3I6D-0006py-Sv
	for xfs@oss.sgi.com; Sun, 18 Apr 2010 00:10:57 +0000
Message-Id: <20100418001057.704530594@bombadil.infradead.org>
Date: Sat, 17 Apr 2010 20:10:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] xfs: access quotainfo structure directly
References: <20100418001041.865247520@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quota-macro-cleanup
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Access fields in m_quotainfo directly instead of hiding them behind the
XFS_QI_* macros.  Add local variables for the quotainfo pointer in places
where we have lots of them.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2010-04-17 17:02:22.945004897 -0700
+++ xfs/fs/xfs/quota/xfs_dquot.c	2010-04-17 17:02:25.147003849 -0700
@@ -252,7 +252,7 @@ xfs_qm_adjust_dqtimers(
 		     (be64_to_cpu(d->d_bcount) >=
 		      be64_to_cpu(d->d_blk_hardlimit)))) {
 			d->d_btimer = cpu_to_be32(get_seconds() +
-					XFS_QI_BTIMELIMIT(mp));
+					mp->m_quotainfo->qi_btimelimit);
 		} else {
 			d->d_bwarns = 0;
 		}
@@ -275,7 +275,7 @@ xfs_qm_adjust_dqtimers(
 		     (be64_to_cpu(d->d_icount) >=
 		      be64_to_cpu(d->d_ino_hardlimit)))) {
 			d->d_itimer = cpu_to_be32(get_seconds() +
-					XFS_QI_ITIMELIMIT(mp));
+					mp->m_quotainfo->qi_itimelimit);
 		} else {
 			d->d_iwarns = 0;
 		}
@@ -298,7 +298,7 @@ xfs_qm_adjust_dqtimers(
 		     (be64_to_cpu(d->d_rtbcount) >=
 		      be64_to_cpu(d->d_rtb_hardlimit)))) {
 			d->d_rtbtimer = cpu_to_be32(get_seconds() +
-					XFS_QI_RTBTIMELIMIT(mp));
+					mp->m_quotainfo->qi_rtbtimelimit);
 		} else {
 			d->d_rtbwarns = 0;
 		}
@@ -325,6 +325,7 @@ xfs_qm_init_dquot_blk(
 	uint		type,
 	xfs_buf_t	*bp)
 {
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	xfs_dqblk_t	*d;
 	int		curid, i;
 
@@ -337,16 +338,16 @@ xfs_qm_init_dquot_blk(
 	/*
 	 * ID of the first dquot in the block - id's are zero based.
 	 */
-	curid = id - (id % XFS_QM_DQPERBLK(mp));
+	curid = id - (id % q->qi_dqperchunk);
 	ASSERT(curid >= 0);
-	memset(d, 0, BBTOB(XFS_QI_DQCHUNKLEN(mp)));
-	for (i = 0; i < XFS_QM_DQPERBLK(mp); i++, d++, curid++)
+	memset(d, 0, BBTOB(q->qi_dqchunklen));
+	for (i = 0; i < q->qi_dqperchunk; i++, d++, curid++)
 		xfs_qm_dqinit_core(curid, type, d);
 	xfs_trans_dquot_buf(tp, bp,
 			    (type & XFS_DQ_USER ? XFS_BLI_UDQUOT_BUF :
 			    ((type & XFS_DQ_PROJ) ? XFS_BLI_PDQUOT_BUF :
 			     XFS_BLI_GDQUOT_BUF)));
-	xfs_trans_log_buf(tp, bp, 0, BBTOB(XFS_QI_DQCHUNKLEN(mp)) - 1);
+	xfs_trans_log_buf(tp, bp, 0, BBTOB(q->qi_dqchunklen) - 1);
 }
 
 
@@ -419,7 +420,7 @@ xfs_qm_dqalloc(
 	/* now we can just get the buffer (there's nothing to read yet) */
 	bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
 			       dqp->q_blkno,
-			       XFS_QI_DQCHUNKLEN(mp),
+			       mp->m_quotainfo->qi_dqchunklen,
 			       0);
 	if (!bp || (error = XFS_BUF_GETERROR(bp)))
 		goto error1;
@@ -500,7 +501,8 @@ xfs_qm_dqtobp(
 	 */
 	if (dqp->q_blkno == (xfs_daddr_t) 0) {
 		/* We use the id as an index */
-		dqp->q_fileoffset = (xfs_fileoff_t)id / XFS_QM_DQPERBLK(mp);
+		dqp->q_fileoffset = (xfs_fileoff_t)id /
+					mp->m_quotainfo->qi_dqperchunk;
 		nmaps = 1;
 		quotip = XFS_DQ_TO_QIP(dqp);
 		xfs_ilock(quotip, XFS_ILOCK_SHARED);
@@ -529,7 +531,7 @@ xfs_qm_dqtobp(
 		/*
 		 * offset of dquot in the (fixed sized) dquot chunk.
 		 */
-		dqp->q_bufoffset = (id % XFS_QM_DQPERBLK(mp)) *
+		dqp->q_bufoffset = (id % mp->m_quotainfo->qi_dqperchunk) *
 			sizeof(xfs_dqblk_t);
 		if (map.br_startblock == HOLESTARTBLOCK) {
 			/*
@@ -559,15 +561,13 @@ xfs_qm_dqtobp(
 	 * Read in the buffer, unless we've just done the allocation
 	 * (in which case we already have the buf).
 	 */
-	if (! newdquot) {
+	if (!newdquot) {
 		trace_xfs_dqtobp_read(dqp);
 
-		if ((error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
-					       dqp->q_blkno,
-					       XFS_QI_DQCHUNKLEN(mp),
-					       0, &bp))) {
-			return (error);
-		}
+		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+					   dqp->q_blkno,
+					   mp->m_quotainfo->qi_dqchunklen,
+					   0, &bp);
 		if (error || !bp)
 			return XFS_ERROR(error);
 	}
@@ -689,14 +689,14 @@ xfs_qm_idtodq(
 	tp = NULL;
 	if (flags & XFS_QMOPT_DQALLOC) {
 		tp = xfs_trans_alloc(mp, XFS_TRANS_QM_DQALLOC);
-		if ((error = xfs_trans_reserve(tp,
-				       XFS_QM_DQALLOC_SPACE_RES(mp),
-				       XFS_WRITE_LOG_RES(mp) +
-					      BBTOB(XFS_QI_DQCHUNKLEN(mp)) - 1 +
-					      128,
-				       0,
-				       XFS_TRANS_PERM_LOG_RES,
-				       XFS_WRITE_LOG_COUNT))) {
+		error = xfs_trans_reserve(tp, XFS_QM_DQALLOC_SPACE_RES(mp),
+				XFS_WRITE_LOG_RES(mp) +
+				BBTOB(mp->m_quotainfo->qi_dqchunklen) - 1 +
+				128,
+				0,
+				XFS_TRANS_PERM_LOG_RES,
+				XFS_WRITE_LOG_COUNT);
+		if (error) {
 			cancelflags = 0;
 			goto error0;
 		}
@@ -1495,6 +1495,7 @@ void
 xfs_qm_dqflock_pushbuf_wait(
 	xfs_dquot_t	*dqp)
 {
+	xfs_mount_t	*mp = dqp->q_mount;
 	xfs_buf_t	*bp;
 
 	/*
@@ -1503,14 +1504,14 @@ xfs_qm_dqflock_pushbuf_wait(
 	 * out immediately.  We'll be able to acquire
 	 * the flush lock when the I/O completes.
 	 */
-	bp = xfs_incore(dqp->q_mount->m_ddev_targp, dqp->q_blkno,
-		    XFS_QI_DQCHUNKLEN(dqp->q_mount), XBF_TRYLOCK);
+	bp = xfs_incore(mp->m_ddev_targp, dqp->q_blkno,
+			mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK);
 	if (!bp)
 		goto out_lock;
 
 	if (XFS_BUF_ISDELAYWRITE(bp)) {
 		if (XFS_BUF_ISPINNED(bp))
-			xfs_log_force(dqp->q_mount, 0);
+			xfs_log_force(mp, 0);
 		xfs_buf_delwri_promote(bp);
 		wake_up_process(bp->b_target->bt_task);
 	}
Index: xfs/fs/xfs/quota/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot_item.c	2010-04-17 17:02:22.951004268 -0700
+++ xfs/fs/xfs/quota/xfs_dquot_item.c	2010-04-17 17:02:25.148003989 -0700
@@ -227,7 +227,7 @@ xfs_qm_dquot_logitem_pushbuf(
 	}
 	mp = dqp->q_mount;
 	bp = xfs_incore(mp->m_ddev_targp, qip->qli_format.qlf_blkno,
-		    XFS_QI_DQCHUNKLEN(mp), XBF_TRYLOCK);
+			mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK);
 	xfs_dqunlock(dqp);
 	if (!bp)
 		return;
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-04-17 17:02:22.958004268 -0700
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-04-17 17:02:25.153276443 -0700
@@ -465,20 +465,21 @@ xfs_qm_unmount_quotas(
  */
 STATIC int
 xfs_qm_dqflush_all(
-	xfs_mount_t	*mp,
-	int		sync_mode)
+	struct xfs_mount	*mp,
+	int			sync_mode)
 {
-	int		recl;
-	xfs_dquot_t	*dqp;
-	int		niters;
-	int		error;
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
+	int			recl;
+	struct xfs_dquot	*dqp;
+	int			niters;
+	int			error;
 
-	if (mp->m_quotainfo == NULL)
+	if (!q)
 		return 0;
 	niters = 0;
 again:
-	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
-	list_for_each_entry(dqp, &mp->m_quotainfo->qi_dqlist, q_mplist) {
+	mutex_lock(&q->qi_dqlist_lock);
+	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
 		xfs_dqlock(dqp);
 		if (! XFS_DQ_IS_DIRTY(dqp)) {
 			xfs_dqunlock(dqp);
@@ -486,7 +487,7 @@ again:
 		}
 
 		/* XXX a sentinel would be better */
-		recl = mp->m_quotainfo->qi_dqreclaims;
+		recl = q->qi_dqreclaims;
 		if (!xfs_dqflock_nowait(dqp)) {
 			/*
 			 * If we can't grab the flush lock then check
@@ -501,21 +502,21 @@ again:
 		 * Let go of the mplist lock. We don't want to hold it
 		 * across a disk write.
 		 */
-		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+		mutex_unlock(&q->qi_dqlist_lock);
 		error = xfs_qm_dqflush(dqp, sync_mode);
 		xfs_dqunlock(dqp);
 		if (error)
 			return error;
 
-		mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
-		if (recl != mp->m_quotainfo->qi_dqreclaims) {
-			mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+		mutex_lock(&q->qi_dqlist_lock);
+		if (recl != q->qi_dqreclaims) {
+			mutex_unlock(&q->qi_dqlist_lock);
 			/* XXX restart limit */
 			goto again;
 		}
 	}
 
-	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+	mutex_unlock(&q->qi_dqlist_lock);
 	/* return ! busy */
 	return 0;
 }
@@ -525,14 +526,15 @@ again:
  */
 STATIC void
 xfs_qm_detach_gdquots(
-	xfs_mount_t	*mp)
+	struct xfs_mount	*mp)
 {
-	xfs_dquot_t	*dqp, *gdqp;
-	int		nrecl;
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
+	struct xfs_dquot	*dqp, *gdqp;
+	int			nrecl;
 
  again:
-	ASSERT(mutex_is_locked(&mp->m_quotainfo->qi_dqlist_lock));
-	list_for_each_entry(dqp, &mp->m_quotainfo->qi_dqlist, q_mplist) {
+	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
+	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
 		xfs_dqlock(dqp);
 		if ((gdqp = dqp->q_gdquot)) {
 			xfs_dqlock(gdqp);
@@ -545,12 +547,12 @@ xfs_qm_detach_gdquots(
 			 * Can't hold the mplist lock across a dqput.
 			 * XXXmust convert to marker based iterations here.
 			 */
-			nrecl = mp->m_quotainfo->qi_dqreclaims;
-			mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+			nrecl = q->qi_dqreclaims;
+			mutex_unlock(&q->qi_dqlist_lock);
 			xfs_qm_dqput(gdqp);
 
-			mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
-			if (nrecl != mp->m_quotainfo->qi_dqreclaims)
+			mutex_lock(&q->qi_dqlist_lock);
+			if (nrecl != q->qi_dqreclaims)
 				goto again;
 		}
 	}
@@ -564,22 +566,23 @@ xfs_qm_detach_gdquots(
  */
 STATIC int
 xfs_qm_dqpurge_int(
-	xfs_mount_t	*mp,
-	uint		flags) /* QUOTAOFF/UMOUNTING/UQUOTA/PQUOTA/GQUOTA */
+	struct xfs_mount	*mp,
+	uint			flags)
 {
-	xfs_dquot_t	*dqp, *n;
-	uint		dqtype;
-	int		nrecl;
-	int		nmisses;
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
+	struct xfs_dquot	*dqp, *n;
+	uint			dqtype;
+	int			nrecl;
+	int			nmisses;
 
-	if (mp->m_quotainfo == NULL)
+	if (!q)
 		return 0;
 
 	dqtype = (flags & XFS_QMOPT_UQUOTA) ? XFS_DQ_USER : 0;
 	dqtype |= (flags & XFS_QMOPT_PQUOTA) ? XFS_DQ_PROJ : 0;
 	dqtype |= (flags & XFS_QMOPT_GQUOTA) ? XFS_DQ_GROUP : 0;
 
-	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
+	mutex_lock(&q->qi_dqlist_lock);
 
 	/*
 	 * In the first pass through all incore dquots of this filesystem,
@@ -591,12 +594,12 @@ xfs_qm_dqpurge_int(
 
       again:
 	nmisses = 0;
-	ASSERT(mutex_is_locked(&mp->m_quotainfo->qi_dqlist_lock));
+	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
 	/*
 	 * Try to get rid of all of the unwanted dquots. The idea is to
 	 * get them off mplist and hashlist, but leave them on freelist.
 	 */
-	list_for_each_entry_safe(dqp, n, &mp->m_quotainfo->qi_dqlist, q_mplist) {
+	list_for_each_entry_safe(dqp, n, &q->qi_dqlist, q_mplist) {
 		/*
 		 * It's OK to look at the type without taking dqlock here.
 		 * We're holding the mplist lock here, and that's needed for
@@ -606,10 +609,10 @@ xfs_qm_dqpurge_int(
 			continue;
 
 		if (!mutex_trylock(&dqp->q_hash->qh_lock)) {
-			nrecl = mp->m_quotainfo->qi_dqreclaims;
-			mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+			nrecl = q->qi_dqreclaims;
+			mutex_unlock(&q->qi_dqlist_lock);
 			mutex_lock(&dqp->q_hash->qh_lock);
-			mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
+			mutex_lock(&q->qi_dqlist_lock);
 
 			/*
 			 * XXXTheoretically, we can get into a very long
@@ -617,7 +620,7 @@ xfs_qm_dqpurge_int(
 			 * No one can be adding dquots to the mplist at
 			 * this point, but somebody might be taking things off.
 			 */
-			if (nrecl != mp->m_quotainfo->qi_dqreclaims) {
+			if (nrecl != q->qi_dqreclaims) {
 				mutex_unlock(&dqp->q_hash->qh_lock);
 				goto again;
 			}
@@ -629,7 +632,7 @@ xfs_qm_dqpurge_int(
 		 */
 		nmisses += xfs_qm_dqpurge(dqp);
 	}
-	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+	mutex_unlock(&q->qi_dqlist_lock);
 	return nmisses;
 }
 
@@ -929,12 +932,13 @@ xfs_qm_dqdetach(
 
 int
 xfs_qm_sync(
-	xfs_mount_t	*mp,
-	int		flags)
+	struct xfs_mount	*mp,
+	int			flags)
 {
-	int		recl, restarts;
-	xfs_dquot_t	*dqp;
-	int		error;
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
+	int			recl, restarts;
+	struct xfs_dquot	*dqp;
+	int			error;
 
 	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
 		return 0;
@@ -942,7 +946,7 @@ xfs_qm_sync(
 	restarts = 0;
 
   again:
-	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
+	mutex_lock(&q->qi_dqlist_lock);
 	/*
 	 * dqpurge_all() also takes the mplist lock and iterate thru all dquots
 	 * in quotaoff. However, if the QUOTA_ACTIVE bits are not cleared
@@ -950,11 +954,11 @@ xfs_qm_sync(
 	 * as long as we have it locked.
 	 */
 	if (!XFS_IS_QUOTA_ON(mp)) {
-		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+		mutex_unlock(&q->qi_dqlist_lock);
 		return 0;
 	}
-	ASSERT(mutex_is_locked(&mp->m_quotainfo->qi_dqlist_lock));
-	list_for_each_entry(dqp, &mp->m_quotainfo->qi_dqlist, q_mplist) {
+	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
+	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
 		/*
 		 * If this is vfs_sync calling, then skip the dquots that
 		 * don't 'seem' to be dirty. ie. don't acquire dqlock.
@@ -978,7 +982,7 @@ xfs_qm_sync(
 		}
 
 		/* XXX a sentinel would be better */
-		recl = mp->m_quotainfo->qi_dqreclaims;
+		recl = q->qi_dqreclaims;
 		if (!xfs_dqflock_nowait(dqp)) {
 			if (flags & SYNC_TRYLOCK) {
 				xfs_dqunlock(dqp);
@@ -998,7 +1002,7 @@ xfs_qm_sync(
 		 * Let go of the mplist lock. We don't want to hold it
 		 * across a disk write
 		 */
-		mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+		mutex_unlock(&q->qi_dqlist_lock);
 		error = xfs_qm_dqflush(dqp, flags);
 		xfs_dqunlock(dqp);
 		if (error && XFS_FORCED_SHUTDOWN(mp))
@@ -1006,17 +1010,17 @@ xfs_qm_sync(
 		else if (error)
 			return error;
 
-		mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
-		if (recl != mp->m_quotainfo->qi_dqreclaims) {
+		mutex_lock(&q->qi_dqlist_lock);
+		if (recl != q->qi_dqreclaims) {
 			if (++restarts >= XFS_QM_SYNC_MAX_RESTARTS)
 				break;
 
-			mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+			mutex_unlock(&q->qi_dqlist_lock);
 			goto again;
 		}
 	}
 
-	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
+	mutex_unlock(&q->qi_dqlist_lock);
 	return 0;
 }
 
@@ -1382,10 +1386,10 @@ xfs_qm_reset_dqcounts(
 #ifdef DEBUG
 	j = XFS_FSB_TO_B(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
 	do_div(j, sizeof(xfs_dqblk_t));
-	ASSERT(XFS_QM_DQPERBLK(mp) == j);
+	ASSERT(mp->m_quotainfo->qi_dqperchunk == j);
 #endif
 	ddq = (xfs_disk_dquot_t *)XFS_BUF_PTR(bp);
-	for (j = 0; j < XFS_QM_DQPERBLK(mp); j++) {
+	for (j = 0; j < mp->m_quotainfo->qi_dqperchunk; j++) {
 		/*
 		 * Do a sanity check, and if needed, repair the dqblk. Don't
 		 * output any warnings because it's perfectly possible to
@@ -1440,7 +1444,7 @@ xfs_qm_dqiter_bufs(
 	while (blkcnt--) {
 		error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp,
 			      XFS_FSB_TO_DADDR(mp, bno),
-			      (int)XFS_QI_DQCHUNKLEN(mp), 0, &bp);
+			      mp->m_quotainfo->qi_dqchunklen, 0, &bp);
 		if (error)
 			break;
 
@@ -1450,7 +1454,7 @@ xfs_qm_dqiter_bufs(
 		 * goto the next block.
 		 */
 		bno++;
-		firstid += XFS_QM_DQPERBLK(mp);
+		firstid += mp->m_quotainfo->qi_dqperchunk;
 	}
 	return error;
 }
@@ -1516,7 +1520,7 @@ xfs_qm_dqiterate(
 				continue;
 
 			firstid = (xfs_dqid_t) map[i].br_startoff *
-				XFS_QM_DQPERBLK(mp);
+				mp->m_quotainfo->qi_dqperchunk;
 			/*
 			 * Do a read-ahead on the next extent.
 			 */
@@ -1527,7 +1531,7 @@ xfs_qm_dqiterate(
 				while (rablkcnt--) {
 					xfs_baread(mp->m_ddev_targp,
 					       XFS_FSB_TO_DADDR(mp, rablkno),
-					       (int)XFS_QI_DQCHUNKLEN(mp));
+					       mp->m_quotainfo->qi_dqchunklen);
 					rablkno++;
 				}
 			}
@@ -1758,7 +1762,7 @@ xfs_qm_quotacheck(
 	lastino = 0;
 	flags = 0;
 
-	ASSERT(XFS_QI_UQIP(mp) || XFS_QI_GQIP(mp));
+	ASSERT(mp->m_quotainfo->qi_uquotaip || mp->m_quotainfo->qi_gquotaip);
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
 	/*
@@ -1774,15 +1778,19 @@ xfs_qm_quotacheck(
 	 * their counters to zero. We need a clean slate.
 	 * We don't log our changes till later.
 	 */
-	if ((uip = XFS_QI_UQIP(mp))) {
-		if ((error = xfs_qm_dqiterate(mp, uip, XFS_QMOPT_UQUOTA)))
+	uip = mp->m_quotainfo->qi_uquotaip;
+	if (uip) {
+		error = xfs_qm_dqiterate(mp, uip, XFS_QMOPT_UQUOTA);
+		if (error)
 			goto error_return;
 		flags |= XFS_UQUOTA_CHKD;
 	}
 
-	if ((gip = XFS_QI_GQIP(mp))) {
-		if ((error = xfs_qm_dqiterate(mp, gip, XFS_IS_GQUOTA_ON(mp) ?
-					XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA)))
+	gip = mp->m_quotainfo->qi_gquotaip;
+	if (gip) {
+		error = xfs_qm_dqiterate(mp, gip, XFS_IS_GQUOTA_ON(mp) ?
+					XFS_QMOPT_GQUOTA : XFS_QMOPT_PQUOTA);
+		if (error)
 			goto error_return;
 		flags |= XFS_OQUOTA_CHKD;
 	}
@@ -1931,8 +1939,8 @@ xfs_qm_init_quotainos(
 		}
 	}
 
-	XFS_QI_UQIP(mp) = uip;
-	XFS_QI_GQIP(mp) = gip;
+	mp->m_quotainfo->qi_uquotaip = uip;
+	mp->m_quotainfo->qi_gquotaip = gip;
 
 	return 0;
 }
Index: xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2010-04-17 17:02:22.966004128 -0700
+++ xfs/fs/xfs/quota/xfs_qm_syscalls.c	2010-04-17 17:02:25.159284824 -0700
@@ -79,6 +79,7 @@ xfs_qm_scall_quotaoff(
 	xfs_mount_t		*mp,
 	uint			flags)
 {
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	uint			dqtype;
 	int			error;
 	uint			inactivate_flags;
@@ -102,11 +103,8 @@ xfs_qm_scall_quotaoff(
 	 * critical thing.
 	 * If quotaoff, then we must be dealing with the root filesystem.
 	 */
-	ASSERT(mp->m_quotainfo);
-	if (mp->m_quotainfo)
-		mutex_lock(&(XFS_QI_QOFFLOCK(mp)));
-
-	ASSERT(mp->m_quotainfo);
+	ASSERT(q);
+	mutex_lock(&q->qi_quotaofflock);
 
 	/*
 	 * If we're just turning off quota enforcement, change mp and go.
@@ -117,7 +115,7 @@ xfs_qm_scall_quotaoff(
 		spin_lock(&mp->m_sb_lock);
 		mp->m_sb.sb_qflags = mp->m_qflags;
 		spin_unlock(&mp->m_sb_lock);
-		mutex_unlock(&(XFS_QI_QOFFLOCK(mp)));
+		mutex_unlock(&q->qi_quotaofflock);
 
 		/* XXX what to do if error ? Revert back to old vals incore ? */
 		error = xfs_qm_write_sb_changes(mp, XFS_SB_QFLAGS);
@@ -150,10 +148,8 @@ xfs_qm_scall_quotaoff(
 	 * Nothing to do?  Don't complain. This happens when we're just
 	 * turning off quota enforcement.
 	 */
-	if ((mp->m_qflags & flags) == 0) {
-		mutex_unlock(&(XFS_QI_QOFFLOCK(mp)));
-		return (0);
-	}
+	if ((mp->m_qflags & flags) == 0)
+		goto out_unlock;
 
 	/*
 	 * Write the LI_QUOTAOFF log record, and do SB changes atomically,
@@ -162,7 +158,7 @@ xfs_qm_scall_quotaoff(
 	 */
 	error = xfs_qm_log_quotaoff(mp, &qoffstart, flags);
 	if (error)
-		goto out_error;
+		goto out_unlock;
 
 	/*
 	 * Next we clear the XFS_MOUNT_*DQ_ACTIVE bit(s) in the mount struct
@@ -222,7 +218,7 @@ xfs_qm_scall_quotaoff(
 	if (error) {
 		/* We're screwed now. Shutdown is the only option. */
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		goto out_error;
+		goto out_unlock;
 	}
 
 	/*
@@ -230,27 +226,26 @@ xfs_qm_scall_quotaoff(
 	 */
 	if (((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET1) ||
 	    ((flags & XFS_MOUNT_QUOTA_ALL) == XFS_MOUNT_QUOTA_SET2)) {
-		mutex_unlock(&(XFS_QI_QOFFLOCK(mp)));
+		mutex_unlock(&q->qi_quotaofflock);
 		xfs_qm_destroy_quotainfo(mp);
 		return (0);
 	}
 
 	/*
-	 * Release our quotainode references, and vn_purge them,
-	 * if we don't need them anymore.
+	 * Release our quotainode references if we don't need them anymore.
 	 */
-	if ((dqtype & XFS_QMOPT_UQUOTA) && XFS_QI_UQIP(mp)) {
-		IRELE(XFS_QI_UQIP(mp));
-		XFS_QI_UQIP(mp) = NULL;
-	}
-	if ((dqtype & (XFS_QMOPT_GQUOTA|XFS_QMOPT_PQUOTA)) && XFS_QI_GQIP(mp)) {
-		IRELE(XFS_QI_GQIP(mp));
-		XFS_QI_GQIP(mp) = NULL;
+	if ((dqtype & XFS_QMOPT_UQUOTA) && q->qi_uquotaip) {
+		IRELE(q->qi_uquotaip);
+		q->qi_uquotaip = NULL;
+	}
+	if ((dqtype & (XFS_QMOPT_GQUOTA|XFS_QMOPT_PQUOTA)) && q->qi_gquotaip) {
+		IRELE(q->qi_gquotaip);
+		q->qi_gquotaip = NULL;
 	}
-out_error:
-	mutex_unlock(&(XFS_QI_QOFFLOCK(mp)));
 
-	return (error);
+out_unlock:
+	mutex_unlock(&q->qi_quotaofflock);
+	return error;
 }
 
 int
@@ -379,9 +374,9 @@ xfs_qm_scall_quotaon(
 	/*
 	 * Switch on quota enforcement in core.
 	 */
-	mutex_lock(&(XFS_QI_QOFFLOCK(mp)));
+	mutex_lock(&mp->m_quotainfo->qi_quotaofflock);
 	mp->m_qflags |= (flags & XFS_ALL_QUOTA_ENFD);
-	mutex_unlock(&(XFS_QI_QOFFLOCK(mp)));
+	mutex_unlock(&mp->m_quotainfo->qi_quotaofflock);
 
 	return (0);
 }
@@ -392,11 +387,12 @@ xfs_qm_scall_quotaon(
  */
 int
 xfs_qm_scall_getqstat(
-	xfs_mount_t	*mp,
-	fs_quota_stat_t *out)
+	struct xfs_mount	*mp,
+	struct fs_quota_stat	*out)
 {
-	xfs_inode_t	*uip, *gip;
-	boolean_t	tempuqip, tempgqip;
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
+	struct xfs_inode	*uip, *gip;
+	boolean_t		tempuqip, tempgqip;
 
 	uip = gip = NULL;
 	tempuqip = tempgqip = B_FALSE;
@@ -415,9 +411,9 @@ xfs_qm_scall_getqstat(
 	out->qs_uquota.qfs_ino = mp->m_sb.sb_uquotino;
 	out->qs_gquota.qfs_ino = mp->m_sb.sb_gquotino;
 
-	if (mp->m_quotainfo) {
-		uip = mp->m_quotainfo->qi_uquotaip;
-		gip = mp->m_quotainfo->qi_gquotaip;
+	if (q) {
+		uip = q->qi_uquotaip;
+		gip = q->qi_gquotaip;
 	}
 	if (!uip && mp->m_sb.sb_uquotino != NULLFSINO) {
 		if (xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
@@ -441,15 +437,15 @@ xfs_qm_scall_getqstat(
 		if (tempgqip)
 			IRELE(gip);
 	}
-	if (mp->m_quotainfo) {
-		out->qs_incoredqs = mp->m_quotainfo->qi_dquots;
-		out->qs_btimelimit = XFS_QI_BTIMELIMIT(mp);
-		out->qs_itimelimit = XFS_QI_ITIMELIMIT(mp);
-		out->qs_rtbtimelimit = XFS_QI_RTBTIMELIMIT(mp);
-		out->qs_bwarnlimit = XFS_QI_BWARNLIMIT(mp);
-		out->qs_iwarnlimit = XFS_QI_IWARNLIMIT(mp);
+	if (q) {
+		out->qs_incoredqs = q->qi_dquots;
+		out->qs_btimelimit = q->qi_btimelimit;
+		out->qs_itimelimit = q->qi_itimelimit;
+		out->qs_rtbtimelimit = q->qi_rtbtimelimit;
+		out->qs_bwarnlimit = q->qi_bwarnlimit;
+		out->qs_iwarnlimit = q->qi_iwarnlimit;
 	}
-	return (0);
+	return 0;
 }
 
 /*
@@ -462,6 +458,7 @@ xfs_qm_scall_setqlim(
 	uint			type,
 	fs_disk_quota_t		*newlim)
 {
+	struct xfs_quotainfo	*q = mp->m_quotainfo;
 	xfs_disk_dquot_t	*ddq;
 	xfs_dquot_t		*dqp;
 	xfs_trans_t		*tp;
@@ -485,7 +482,7 @@ xfs_qm_scall_setqlim(
 	 * a quotaoff from happening). (XXXThis doesn't currently happen
 	 * because we take the vfslock before calling xfs_qm_sysent).
 	 */
-	mutex_lock(&(XFS_QI_QOFFLOCK(mp)));
+	mutex_lock(&q->qi_quotaofflock);
 
 	/*
 	 * Get the dquot (locked), and join it to the transaction.
@@ -493,9 +490,8 @@ xfs_qm_scall_setqlim(
 	 */
 	if ((error = xfs_qm_dqget(mp, NULL, id, type, XFS_QMOPT_DQALLOC, &dqp))) {
 		xfs_trans_cancel(tp, XFS_TRANS_ABORT);
-		mutex_unlock(&(XFS_QI_QOFFLOCK(mp)));
 		ASSERT(error != ENOENT);
-		return (error);
+		goto out_unlock;
 	}
 	xfs_trans_dqjoin(tp, dqp);
 	ddq = &dqp->q_core;
@@ -513,8 +509,8 @@ xfs_qm_scall_setqlim(
 		ddq->d_blk_hardlimit = cpu_to_be64(hard);
 		ddq->d_blk_softlimit = cpu_to_be64(soft);
 		if (id == 0) {
-			mp->m_quotainfo->qi_bhardlimit = hard;
-			mp->m_quotainfo->qi_bsoftlimit = soft;
+			q->qi_bhardlimit = hard;
+			q->qi_bsoftlimit = soft;
 		}
 	} else {
 		qdprintk("blkhard %Ld < blksoft %Ld\n", hard, soft);
@@ -529,8 +525,8 @@ xfs_qm_scall_setqlim(
 		ddq->d_rtb_hardlimit = cpu_to_be64(hard);
 		ddq->d_rtb_softlimit = cpu_to_be64(soft);
 		if (id == 0) {
-			mp->m_quotainfo->qi_rtbhardlimit = hard;
-			mp->m_quotainfo->qi_rtbsoftlimit = soft;
+			q->qi_rtbhardlimit = hard;
+			q->qi_rtbsoftlimit = soft;
 		}
 	} else {
 		qdprintk("rtbhard %Ld < rtbsoft %Ld\n", hard, soft);
@@ -546,8 +542,8 @@ xfs_qm_scall_setqlim(
 		ddq->d_ino_hardlimit = cpu_to_be64(hard);
 		ddq->d_ino_softlimit = cpu_to_be64(soft);
 		if (id == 0) {
-			mp->m_quotainfo->qi_ihardlimit = hard;
-			mp->m_quotainfo->qi_isoftlimit = soft;
+			q->qi_ihardlimit = hard;
+			q->qi_isoftlimit = soft;
 		}
 	} else {
 		qdprintk("ihard %Ld < isoft %Ld\n", hard, soft);
@@ -572,23 +568,23 @@ xfs_qm_scall_setqlim(
 		 * for warnings.
 		 */
 		if (newlim->d_fieldmask & FS_DQ_BTIMER) {
-			mp->m_quotainfo->qi_btimelimit = newlim->d_btimer;
+			q->qi_btimelimit = newlim->d_btimer;
 			ddq->d_btimer = cpu_to_be32(newlim->d_btimer);
 		}
 		if (newlim->d_fieldmask & FS_DQ_ITIMER) {
-			mp->m_quotainfo->qi_itimelimit = newlim->d_itimer;
+			q->qi_itimelimit = newlim->d_itimer;
 			ddq->d_itimer = cpu_to_be32(newlim->d_itimer);
 		}
 		if (newlim->d_fieldmask & FS_DQ_RTBTIMER) {
-			mp->m_quotainfo->qi_rtbtimelimit = newlim->d_rtbtimer;
+			q->qi_rtbtimelimit = newlim->d_rtbtimer;
 			ddq->d_rtbtimer = cpu_to_be32(newlim->d_rtbtimer);
 		}
 		if (newlim->d_fieldmask & FS_DQ_BWARNS)
-			mp->m_quotainfo->qi_bwarnlimit = newlim->d_bwarns;
+			q->qi_bwarnlimit = newlim->d_bwarns;
 		if (newlim->d_fieldmask & FS_DQ_IWARNS)
-			mp->m_quotainfo->qi_iwarnlimit = newlim->d_iwarns;
+			q->qi_iwarnlimit = newlim->d_iwarns;
 		if (newlim->d_fieldmask & FS_DQ_RTBWARNS)
-			mp->m_quotainfo->qi_rtbwarnlimit = newlim->d_rtbwarns;
+			q->qi_rtbwarnlimit = newlim->d_rtbwarns;
 	} else {
 		/*
 		 * If the user is now over quota, start the timelimit.
@@ -605,8 +601,9 @@ xfs_qm_scall_setqlim(
 	error = xfs_trans_commit(tp, 0);
 	xfs_qm_dqprint(dqp);
 	xfs_qm_dqrele(dqp);
-	mutex_unlock(&(XFS_QI_QOFFLOCK(mp)));
 
+ out_unlock:
+	mutex_unlock(&q->qi_quotaofflock);
 	return error;
 }
 
@@ -853,7 +850,8 @@ xfs_dqrele_inode(
 	int			error;
 
 	/* skip quota inodes */
-	if (ip == XFS_QI_UQIP(ip->i_mount) || ip == XFS_QI_GQIP(ip->i_mount)) {
+	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
+	    ip == ip->i_mount->m_quotainfo->qi_gquotaip) {
 		ASSERT(ip->i_udquot == NULL);
 		ASSERT(ip->i_gdquot == NULL);
 		read_unlock(&pag->pag_ici_lock);
Index: xfs/fs/xfs/quota/xfs_quota_priv.h
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_quota_priv.h	2010-04-17 17:02:22.977004408 -0700
+++ xfs/fs/xfs/quota/xfs_quota_priv.h	2010-04-17 17:02:34.568028739 -0700
@@ -24,22 +24,8 @@
  */
 #define XFS_DQITER_MAP_SIZE	10
 
-/* Number of dquots that fit in to a dquot block */
-#define XFS_QM_DQPERBLK(mp)	((mp)->m_quotainfo->qi_dqperchunk)
-
 #define XFS_DQ_IS_ADDEDTO_TRX(t, d)	((d)->q_transp == (t))
 
-#define XFS_QI_UQIP(mp)		((mp)->m_quotainfo->qi_uquotaip)
-#define XFS_QI_GQIP(mp)		((mp)->m_quotainfo->qi_gquotaip)
-#define XFS_QI_DQCHUNKLEN(mp)	((mp)->m_quotainfo->qi_dqchunklen)
-#define XFS_QI_BTIMELIMIT(mp)	((mp)->m_quotainfo->qi_btimelimit)
-#define XFS_QI_RTBTIMELIMIT(mp) ((mp)->m_quotainfo->qi_rtbtimelimit)
-#define XFS_QI_ITIMELIMIT(mp)	((mp)->m_quotainfo->qi_itimelimit)
-#define XFS_QI_BWARNLIMIT(mp)	((mp)->m_quotainfo->qi_bwarnlimit)
-#define XFS_QI_RTBWARNLIMIT(mp)	((mp)->m_quotainfo->qi_rtbwarnlimit)
-#define XFS_QI_IWARNLIMIT(mp)	((mp)->m_quotainfo->qi_iwarnlimit)
-#define XFS_QI_QOFFLOCK(mp)	((mp)->m_quotainfo->qi_quotaofflock)
-
 /*
  * Hash into a bucket in the dquot hash table, based on <mp, id>.
  */
Index: xfs/fs/xfs/quota/xfs_trans_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_trans_dquot.c	2010-04-17 17:02:22.989004617 -0700
+++ xfs/fs/xfs/quota/xfs_trans_dquot.c	2010-04-17 17:02:25.169283916 -0700
@@ -639,7 +639,7 @@ xfs_trans_dqresv(
 			softlimit = q->qi_bsoftlimit;
 		timer = be32_to_cpu(dqp->q_core.d_btimer);
 		warns = be16_to_cpu(dqp->q_core.d_bwarns);
-		warnlimit = XFS_QI_BWARNLIMIT(dqp->q_mount);
+		warnlimit = dqp->q_mount->m_quotainfo->qi_bwarnlimit;
 		resbcountp = &dqp->q_res_bcount;
 	} else {
 		ASSERT(flags & XFS_TRANS_DQ_RES_RTBLKS);
@@ -651,7 +651,7 @@ xfs_trans_dqresv(
 			softlimit = q->qi_rtbsoftlimit;
 		timer = be32_to_cpu(dqp->q_core.d_rtbtimer);
 		warns = be16_to_cpu(dqp->q_core.d_rtbwarns);
-		warnlimit = XFS_QI_RTBWARNLIMIT(dqp->q_mount);
+		warnlimit = dqp->q_mount->m_quotainfo->qi_rtbwarnlimit;
 		resbcountp = &dqp->q_res_rtbcount;
 	}
 
@@ -691,7 +691,7 @@ xfs_trans_dqresv(
 			count = be64_to_cpu(dqp->q_core.d_icount);
 			timer = be32_to_cpu(dqp->q_core.d_itimer);
 			warns = be16_to_cpu(dqp->q_core.d_iwarns);
-			warnlimit = XFS_QI_IWARNLIMIT(dqp->q_mount);
+			warnlimit = dqp->q_mount->m_quotainfo->qi_iwarnlimit;
 			hardlimit = be64_to_cpu(dqp->q_core.d_ino_hardlimit);
 			if (!hardlimit)
 				hardlimit = q->qi_ihardlimit;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
