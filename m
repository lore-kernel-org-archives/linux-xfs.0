Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3i2I145569 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FE8E1CC6FBC
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	URKeHqLp8Rv5QCg6 for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHq-0003BZ-Qh
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:42 +0000
Message-Id: <20111028100342.775104164@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:55:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 40/45] xfs: do not write the buffer from xfs_qm_dqflush
References: <20111028095423.796574703@bombadil.infradead.org>
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
to the caller and let the caller decide what to do with it.  While we're at
it also remove the pincount check that all non-blocking callers already
implement and the new now unused flags parameter.  Also remove the
XFS_DQ_IS_DIRTY check that all callers already do for us.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c      |   35 ++++++++++++-----------------------
 fs/xfs/xfs_dquot.h      |    2 +-
 fs/xfs/xfs_dquot_item.c |   19 +++++++++++++++++--
 fs/xfs/xfs_qm.c         |   30 ++++++++++++++++++++++--------
 4 files changed, 52 insertions(+), 34 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-10-27 22:40:11.298171586 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-10-27 22:40:14.809173098 +0200
@@ -984,8 +984,8 @@ xfs_qm_dqflush_done(
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
@@ -997,14 +997,8 @@ xfs_qm_dqflush(
 
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
@@ -1084,20 +1078,10 @@ xfs_qm_dqflush(
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
 
-	/*
-	 * dqp is still locked, but caller is free to unlock it now.
-	 */
+	*bpp = bp;
 	return error;
-
 }
 
 void
@@ -1174,13 +1158,18 @@ xfs_qm_dqpurge(
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
+		if (!error && bp) {
+			error = xfs_bwrite(bp);
+			xfs_buf_relse(bp);
+		}
 		if (error)
 			xfs_warn(mp, "%s: dquot %p flush failed",
 				__func__, dqp);
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2011-10-27 22:40:07.534173092 +0200
+++ xfs/fs/xfs/xfs_dquot.h	2011-10-27 22:40:14.809173098 +0200
@@ -132,7 +132,7 @@ static inline void xfs_dqunlock_nonotify
 extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
 					uint, struct xfs_dquot	**);
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
-extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
+extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
 extern void		xfs_qm_dqpurge(xfs_dquot_t *);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
 extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
Index: xfs/fs/xfs/xfs_dquot_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot_item.c	2011-10-27 22:40:02.254174248 +0200
+++ xfs/fs/xfs/xfs_dquot_item.c	2011-10-27 22:40:14.813173372 +0200
@@ -120,10 +120,12 @@ xfs_qm_dquot_logitem_push(
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
@@ -134,10 +136,14 @@ xfs_qm_dquot_logitem_push(
 	 * lock without sleeping, then there must not have been
 	 * anyone in the process of flushing the dquot.
 	 */
-	error = xfs_qm_dqflush(dqp, SYNC_TRYLOCK);
-	if (error)
+	error = xfs_qm_dqflush(dqp, &bp);
+	if (error) {
 		xfs_warn(dqp->q_mount, "%s: push error %d on dqp %p",
 			__func__, error, dqp);
+	} else if (bp) {
+		xfs_buf_delwri_queue(bp);
+		xfs_buf_relse(bp);
+	}
 	xfs_dqunlock(dqp);
 }
 
@@ -240,6 +246,15 @@ xfs_qm_dquot_logitem_trylock(
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
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:09.097172140 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:14.813173372 +0200
@@ -394,6 +394,8 @@ xfs_qm_dqflush_all(
 again:
 	mutex_lock(&q->qi_dqlist_lock);
 	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
+		struct xfs_buf	*bp = NULL;
+
 		xfs_dqlock(dqp);
 		if ((dqp->dq_flags & XFS_DQ_FREEING) ||
 		    !XFS_DQ_IS_DIRTY(dqp)) {
@@ -418,7 +420,11 @@ again:
 		 * across a disk write.
 		 */
 		mutex_unlock(&q->qi_dqlist_lock);
-		error = xfs_qm_dqflush(dqp, 0);
+		error = xfs_qm_dqflush(dqp, &bp);
+		if (!error && bp) {
+			xfs_buf_delwri_queue(bp);
+			xfs_buf_relse(bp);
+		}
 		xfs_dqunlock(dqp);
 		if (error)
 			return error;
@@ -1645,16 +1651,24 @@ xfs_qm_dqreclaim_one(
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		if (!write_dirty)
 			goto out_busy;
+		else {
+			struct xfs_buf	*bp = NULL;
 
-		trace_xfs_dqreclaim_dirty(dqp);
 
-		mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
-		error = xfs_qm_dqflush(dqp, SYNC_WAIT);
-		if (error) {
-			xfs_warn(mp, "%s: dquot %p flush failed",
-				 __func__, dqp);
+			trace_xfs_dqreclaim_dirty(dqp);
+
+			mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
+			error = xfs_qm_dqflush(dqp, &bp);
+			if (!error && bp) {
+				xfs_buf_delwri_queue(bp);
+				xfs_buf_relse(bp);
+			}
+			if (error) {
+				xfs_warn(mp, "%s: dquot %p flush failed",
+					 __func__, dqp);
+			}
+			mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
 		}
-		mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
 	}
 	xfs_dqfunlock(dqp);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
