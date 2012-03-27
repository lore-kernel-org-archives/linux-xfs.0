Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RGkmZh128431 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 11:46:48 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	vAHb7FAXs8uM0O9N (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 09:46:47 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCZXi-0007Ck-6h
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 16:46:46 +0000
Message-Id: <20120327164646.158577302@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 12:44:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/10] xfs: do not write the buffer from xfs_qm_dqflush
References: <20120327164400.967415009@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-dqflush-dont-write-buffer
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

Instead of writing the buffer directly from inside xfs_qm_dqflush return it
to the caller and let the caller decide what to do with the buffer.  Also
remove the pincount check in xfs_qm_dqflush that all non-blocking callers
already implement and the now unused flags parameter and the XFS_DQ_IS_DIRTY
check that all callers already perform.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c      |   43 +++++++++++++------------------------------
 fs/xfs/xfs_dquot.h      |    2 +-
 fs/xfs/xfs_dquot_item.c |   21 +++++++++++++++++++--
 fs/xfs/xfs_qm.c         |   23 +++++++++++++++++++----
 4 files changed, 52 insertions(+), 37 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-03-25 13:29:53.121004759 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2012-03-25 13:36:25.947678708 +0200
@@ -878,8 +878,8 @@ xfs_qm_dqflush_done(
  */
 int
 xfs_qm_dqflush(
-	xfs_dquot_t		*dqp,
-	uint			flags)
+	struct xfs_dquot	*dqp,
+	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_buf		*bp;
@@ -891,14 +891,8 @@ xfs_qm_dqflush(
 
 	trace_xfs_dqflush(dqp);
 
-	/*
-	 * If not dirty, or it's pinned and we are not supposed to block, nada.
-	 */
-	if (!XFS_DQ_IS_DIRTY(dqp) ||
-	    ((flags & SYNC_TRYLOCK) && atomic_read(&dqp->q_pincount) > 0)) {
-		xfs_dqfunlock(dqp);
-		return 0;
-	}
+	*bpp = NULL;
+
 	xfs_qm_dqunpin_wait(dqp);
 
 	/*
@@ -918,9 +912,8 @@ xfs_qm_dqflush(
 			xfs_trans_ail_delete(mp->m_ail, lip);
 		else
 			spin_unlock(&mp->m_ail->xa_lock);
-
-		xfs_dqfunlock(dqp);
-		return XFS_ERROR(EIO);
+		error = XFS_ERROR(EIO);
+		goto out_unlock;
 	}
 
 	/*
@@ -928,11 +921,8 @@ xfs_qm_dqflush(
 	 */
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
 				   mp->m_quotainfo->qi_dqchunklen, 0, &bp);
-	if (error) {
-		ASSERT(error != ENOENT);
-		xfs_dqfunlock(dqp);
-		return error;
-	}
+	if (error)
+		goto out_unlock;
 
 	/*
 	 * Calculate the location of the dquot inside the buffer.
@@ -978,20 +968,13 @@ xfs_qm_dqflush(
 		xfs_log_force(mp, 0);
 	}
 
-	if (flags & SYNC_WAIT)
-		error = xfs_bwrite(bp);
-	else
-		xfs_buf_delwri_queue(bp);
-
-	xfs_buf_relse(bp);
-
 	trace_xfs_dqflush_done(dqp);
+	*bpp = bp;
+	return 0;
 
-	/*
-	 * dqp is still locked, but caller is free to unlock it now.
-	 */
-	return error;
-
+out_unlock:
+	xfs_dqfunlock(dqp);
+	return XFS_ERROR(EIO);
 }
 
 /*
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2012-03-25 13:29:53.134338092 +0200
+++ xfs/fs/xfs/xfs_dquot.h	2012-03-25 13:31:55.844340367 +0200
@@ -141,7 +141,7 @@ static inline xfs_dquot_t *xfs_inode_dqu
 extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
 					uint, struct xfs_dquot	**);
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
-extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
+extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
 extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
 					xfs_disk_dquot_t *);
Index: xfs/fs/xfs/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot_item.c	2012-03-25 13:29:53.144338092 +0200
+++ xfs/fs/xfs/xfs_dquot_item.c	2012-03-25 13:36:38.981012285 +0200
@@ -119,10 +119,12 @@ xfs_qm_dquot_logitem_push(
 	struct xfs_log_item	*lip)
 {
 	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
+	struct xfs_buf		*bp = NULL;
 	int			error;
 
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	ASSERT(!completion_done(&dqp->q_flush));
+	ASSERT(atomic_read(&dqp->q_pincount) == 0);
 
 	/*
 	 * Since we were able to lock the dquot's flush lock and
@@ -133,10 +135,16 @@ xfs_qm_dquot_logitem_push(
 	 * lock without sleeping, then there must not have been
 	 * anyone in the process of flushing the dquot.
 	 */
-	error = xfs_qm_dqflush(dqp, SYNC_TRYLOCK);
-	if (error)
+	error = xfs_qm_dqflush(dqp, &bp);
+	if (error) {
 		xfs_warn(dqp->q_mount, "%s: push error %d on dqp %p",
 			__func__, error, dqp);
+		goto out_unlock;
+	}
+
+	xfs_buf_delwri_queue(bp);
+	xfs_buf_relse(bp);
+out_unlock:
 	xfs_dqunlock(dqp);
 }
 
@@ -239,6 +247,15 @@ xfs_qm_dquot_logitem_trylock(
 	if (!xfs_dqlock_nowait(dqp))
 		return XFS_ITEM_LOCKED;
 
+	/*
+	 * Re-check the pincount now that we stabilized the value by
+	 * taking the quota lock.
+	 */
+	if (atomic_read(&dqp->q_pincount) > 0) {
+		xfs_dqunlock(dqp);
+		return XFS_ITEM_PINNED;
+	}
+
 	if (!xfs_dqflock_nowait(dqp)) {
 		/*
 		 * dquot has already been flushed to the backing buffer,
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2012-03-25 13:29:53.161004759 +0200
+++ xfs/fs/xfs/xfs_qm.c	2012-03-25 13:36:22.031011971 +0200
@@ -175,16 +175,21 @@ xfs_qm_dqpurge(
 	 * we're unmounting, we do care, so we flush it and wait.
 	 */
 	if (XFS_DQ_IS_DIRTY(dqp)) {
-		int	error;
+		struct xfs_buf	*bp = NULL;
+		int		error;
 
 		/*
 		 * We don't care about getting disk errors here. We need
 		 * to purge this dquot anyway, so we go ahead regardless.
 		 */
-		error = xfs_qm_dqflush(dqp, SYNC_WAIT);
+		error = xfs_qm_dqflush(dqp, &bp);
 		if (error)
 			xfs_warn(mp, "%s: dquot %p flush failed",
 				__func__, dqp);
+		} else {
+			error = xfs_bwrite(bp);
+			xfs_buf_relse(bp);
+		}
 		xfs_dqflock(dqp);
 	}
 
@@ -1184,6 +1189,7 @@ STATIC int
 xfs_qm_flush_one(
 	struct xfs_dquot	*dqp)
 {
+	struct xfs_buf		*bp = NULL;
 	int			error = 0;
 
 	xfs_dqlock(dqp);
@@ -1195,8 +1201,12 @@ xfs_qm_flush_one(
 	if (!xfs_dqflock_nowait(dqp))
 		xfs_dqflock_pushbuf_wait(dqp);
 
-	error = xfs_qm_dqflush(dqp, 0);
+	error = xfs_qm_dqflush(dqp, &bp);
+	if (error)
+		goto out_unlock;
 
+	xfs_buf_delwri_queue(bp);
+	xfs_buf_relse(bp);
 out_unlock:
 	xfs_dqunlock(dqp);
 	return error;
@@ -1463,18 +1473,23 @@ xfs_qm_dqreclaim_one(
 	 * dirty dquots.
 	 */
 	if (XFS_DQ_IS_DIRTY(dqp)) {
+		struct xfs_buf	*bp = NULL;
+
 		trace_xfs_dqreclaim_dirty(dqp);
 
 		/*
 		 * We flush it delayed write, so don't bother releasing the
 		 * freelist lock.
 		 */
-		error = xfs_qm_dqflush(dqp, 0);
+		error = xfs_qm_dqflush(dqp, &bp);
 		if (error) {
 			xfs_warn(mp, "%s: dquot %p flush failed",
 				 __func__, dqp);
+			goto out_busy;
 		}
 
+		xfs_buf_delwri_queue(bp);
+		xfs_buf_relse(bp);
 		/*
 		 * Give the dquot another try on the freelist, as the
 		 * flushing will take some time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
