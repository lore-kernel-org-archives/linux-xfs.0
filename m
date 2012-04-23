Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xHK1127376 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:17 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	hsQ2LGL6XgCwDwav for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:15 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCIo-0001Zn-In
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIo-0004Xk-G4
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/37] xfs: do not write the buffer from xfs_qm_dqflush
Date: Mon, 23 Apr 2012 15:58:37 +1000
Message-Id: <1335160747-17254-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Instead of writing the buffer directly from inside xfs_qm_dqflush return it
to the caller and let the caller decide what to do with the buffer.  Also
remove the pincount check in xfs_qm_dqflush that all non-blocking callers
already implement and the now unused flags parameter and the XFS_DQ_IS_DIRTY
check that all callers already perform.

[ Dave Chinner: fixed build error cause by missing '{'. ]

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_dquot.c      |   43 +++++++++++++------------------------------
 fs/xfs/xfs_dquot.h      |    2 +-
 fs/xfs/xfs_dquot_item.c |   21 +++++++++++++++++++--
 fs/xfs/xfs_qm.c         |   25 ++++++++++++++++++++-----
 4 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 786a61e..53757d8 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
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
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index ef9190b..5f2a2f2 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -141,7 +141,7 @@ static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
 extern int		xfs_qm_dqread(struct xfs_mount *, xfs_dqid_t, uint,
 					uint, struct xfs_dquot	**);
 extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
-extern int		xfs_qm_dqflush(xfs_dquot_t *, uint);
+extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
 extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
 extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
 					xfs_disk_dquot_t *);
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 34baeae..8d82958 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
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
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 18ba438..95aecf5 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
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
-		if (error)
+		error = xfs_qm_dqflush(dqp, &bp);
+		if (error) {
 			xfs_warn(mp, "%s: dquot %p flush failed",
 				__func__, dqp);
+		} else {
+			error = xfs_bwrite(bp);
+			xfs_buf_relse(bp);
+		}
 		xfs_dqflock(dqp);
 	}
 
@@ -1200,6 +1205,7 @@ STATIC int
 xfs_qm_flush_one(
 	struct xfs_dquot	*dqp)
 {
+	struct xfs_buf		*bp = NULL;
 	int			error = 0;
 
 	xfs_dqlock(dqp);
@@ -1211,8 +1217,12 @@ xfs_qm_flush_one(
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
@@ -1479,18 +1489,23 @@ xfs_qm_dqreclaim_one(
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
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
