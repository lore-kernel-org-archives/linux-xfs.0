Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1K2maOL042609 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 20:48:36 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GqyWeBSl6k9S8zbR (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 18:31:53 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RzJ2e-0005dv-FY
	for xfs@oss.sgi.com; Mon, 20 Feb 2012 02:31:52 +0000
Message-Id: <20120220023152.433334180@bombadil.infradead.org>
Date: Sun, 19 Feb 2012 21:31:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/12] xfs: remove xfs_trans_unlocked_item
References: <20120220023119.435889631@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_trans_unlocked_item
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

There is no reason to wake up log space waiters when unlocking inodes or
dquots, and the commit log has no explanation for this function either.

Given that we now have exact log space wakeups everywhere we can assume
the reason for this function was to paper over log space races in earlier
XFS versions.

Reviewed-by: Ben Myers <bpm@sgi.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c      |   11 -----------
 fs/xfs/xfs_dquot.h      |    3 +--
 fs/xfs/xfs_iget.c       |   13 +------------
 fs/xfs/xfs_inode.h      |    4 +---
 fs/xfs/xfs_inode_item.c |    6 +-----
 fs/xfs/xfs_trans_ail.c  |   44 --------------------------------------------
 fs/xfs/xfs_trans_buf.c  |   25 +------------------------
 fs/xfs/xfs_trans_priv.h |    3 ---
 8 files changed, 5 insertions(+), 104 deletions(-)

Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2012-02-17 18:45:34.000000000 -0800
+++ xfs/fs/xfs/xfs_iget.c	2012-02-19 13:02:44.699961529 -0800
@@ -642,8 +642,7 @@ xfs_iunlock(
 	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
 	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
 	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
-	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_IUNLOCK_NONOTIFY |
-			XFS_LOCK_DEP_MASK)) == 0);
+	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
 	ASSERT(lock_flags != 0);
 
 	if (lock_flags & XFS_IOLOCK_EXCL)
@@ -656,16 +655,6 @@ xfs_iunlock(
 	else if (lock_flags & XFS_ILOCK_SHARED)
 		mrunlock_shared(&ip->i_lock);
 
-	if ((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) &&
-	    !(lock_flags & XFS_IUNLOCK_NONOTIFY) && ip->i_itemp) {
-		/*
-		 * Let the AIL know that this item has been unlocked in case
-		 * it is in the AIL and anyone is waiting on it.  Don't do
-		 * this if the caller has asked us not to.
-		 */
-		xfs_trans_unlocked_item(ip->i_itemp->ili_item.li_ailp,
-					(xfs_log_item_t*)(ip->i_itemp));
-	}
 	trace_xfs_iunlock(ip, lock_flags, _RET_IP_);
 }
 
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2012-02-17 18:45:34.000000000 -0800
+++ xfs/fs/xfs/xfs_inode.h	2012-02-19 13:02:44.699961529 -0800
@@ -422,7 +422,6 @@ static inline int xfs_isiflocked(struct
 #define	XFS_IOLOCK_SHARED	(1<<1)
 #define	XFS_ILOCK_EXCL		(1<<2)
 #define	XFS_ILOCK_SHARED	(1<<3)
-#define	XFS_IUNLOCK_NONOTIFY	(1<<4)
 
 #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
 				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)
@@ -431,8 +430,7 @@ static inline int xfs_isiflocked(struct
 	{ XFS_IOLOCK_EXCL,	"IOLOCK_EXCL" }, \
 	{ XFS_IOLOCK_SHARED,	"IOLOCK_SHARED" }, \
 	{ XFS_ILOCK_EXCL,	"ILOCK_EXCL" }, \
-	{ XFS_ILOCK_SHARED,	"ILOCK_SHARED" }, \
-	{ XFS_IUNLOCK_NONOTIFY,	"IUNLOCK_NONOTIFY" }
+	{ XFS_ILOCK_SHARED,	"ILOCK_SHARED" }
 
 
 /*
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2012-02-17 18:45:34.000000000 -0800
+++ xfs/fs/xfs/xfs_inode_item.c	2012-02-19 13:02:44.699961529 -0800
@@ -596,11 +596,7 @@ xfs_inode_item_trylock(
 	/* Stale items should force out the iclog */
 	if (ip->i_flags & XFS_ISTALE) {
 		xfs_ifunlock(ip);
-		/*
-		 * we hold the AIL lock - notify the unlock routine of this
-		 * so it doesn't try to get the lock again.
-		 */
-		xfs_iunlock(ip, XFS_ILOCK_SHARED|XFS_IUNLOCK_NONOTIFY);
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		return XFS_ITEM_PINNED;
 	}
 
Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-02-19 12:58:47.169962173 -0800
+++ xfs/fs/xfs/xfs_dquot.c	2012-02-19 13:02:44.699961529 -0800
@@ -983,17 +983,6 @@ xfs_qm_dqflush(
 
 }
 
-void
-xfs_dqunlock(
-	xfs_dquot_t *dqp)
-{
-	xfs_dqunlock_nonotify(dqp);
-	if (dqp->q_logitem.qli_dquot == dqp) {
-		xfs_trans_unlocked_item(dqp->q_logitem.qli_item.li_ailp,
-					&dqp->q_logitem.qli_item);
-	}
-}
-
 /*
  * Lock two xfs_dquot structures.
  *
Index: xfs/fs/xfs/xfs_dquot.h
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.h	2012-02-19 12:30:44.000000000 -0800
+++ xfs/fs/xfs/xfs_dquot.h	2012-02-19 13:02:44.699961529 -0800
@@ -97,7 +97,7 @@ static inline void xfs_dqlock(struct xfs
 	mutex_lock(&dqp->q_qlock);
 }
 
-static inline void xfs_dqunlock_nonotify(struct xfs_dquot *dqp)
+static inline void xfs_dqunlock(struct xfs_dquot *dqp)
 {
 	mutex_unlock(&dqp->q_qlock);
 }
@@ -152,7 +152,6 @@ extern int		xfs_qm_dqget(xfs_mount_t *,
 extern void		xfs_qm_dqput(xfs_dquot_t *);
 
 extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
-extern void		xfs_dqunlock(struct xfs_dquot *);
 extern void		xfs_dqflock_pushbuf_wait(struct xfs_dquot *dqp);
 
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2012-02-19 12:59:53.000000000 -0800
+++ xfs/fs/xfs/xfs_trans_ail.c	2012-02-19 13:03:06.199961470 -0800
@@ -611,50 +611,6 @@ xfs_ail_push_all(
 }
 
 /*
- * This is to be called when an item is unlocked that may have
- * been in the AIL.  It will wake up the first member of the AIL
- * wait list if this item's unlocking might allow it to progress.
- * If the item is in the AIL, then we need to get the AIL lock
- * while doing our checking so we don't race with someone going
- * to sleep waiting for this event in xfs_trans_push_ail().
- */
-void
-xfs_trans_unlocked_item(
-	struct xfs_ail	*ailp,
-	xfs_log_item_t	*lip)
-{
-	xfs_log_item_t	*min_lip;
-
-	/*
-	 * If we're forcibly shutting down, we may have
-	 * unlocked log items arbitrarily. The last thing
-	 * we want to do is to move the tail of the log
-	 * over some potentially valid data.
-	 */
-	if (!(lip->li_flags & XFS_LI_IN_AIL) ||
-	    XFS_FORCED_SHUTDOWN(ailp->xa_mount)) {
-		return;
-	}
-
-	/*
-	 * This is the one case where we can call into xfs_ail_min()
-	 * without holding the AIL lock because we only care about the
-	 * case where we are at the tail of the AIL.  If the object isn't
-	 * at the tail, it doesn't matter what result we get back.  This
-	 * is slightly racy because since we were just unlocked, we could
-	 * go to sleep between the call to xfs_ail_min and the call to
-	 * xfs_log_space_wake, have someone else lock us, commit to us disk,
-	 * move us out of the tail of the AIL, and then we wake up.  However,
-	 * the call to xfs_log_space_wake() doesn't do anything if there's
-	 * not enough free space to wake people up so we're safe calling it.
-	 */
-	min_lip = xfs_ail_min(ailp);
-
-	if (min_lip == lip)
-		xfs_log_space_wake(ailp->xa_mount, true);
-}	/* xfs_trans_unlocked_item */
-
-/*
  * xfs_trans_ail_update - bulk AIL insertion operation.
  *
  * @xfs_trans_ail_update takes an array of log items that all need to be
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2012-02-17 18:45:34.000000000 -0800
+++ xfs/fs/xfs/xfs_trans_buf.c	2012-02-19 13:02:44.699961529 -0800
@@ -463,19 +463,7 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 	 * Default to a normal brelse() call if the tp is NULL.
 	 */
 	if (tp == NULL) {
-		struct xfs_log_item	*lip = bp->b_fspriv;
-
 		ASSERT(bp->b_transp == NULL);
-
-		/*
-		 * If there's a buf log item attached to the buffer,
-		 * then let the AIL know that the buffer is being
-		 * unlocked.
-		 */
-		if (lip != NULL && lip->li_type == XFS_LI_BUF) {
-			bip = bp->b_fspriv;
-			xfs_trans_unlocked_item(bip->bli_item.li_ailp, lip);
-		}
 		xfs_buf_relse(bp);
 		return;
 	}
@@ -550,21 +538,10 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 		ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
 		ASSERT(!(bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF));
 		xfs_buf_item_relse(bp);
-		bip = NULL;
-	}
-	bp->b_transp = NULL;
-
-	/*
-	 * If we've still got a buf log item on the buffer, then
-	 * tell the AIL that the buffer is being unlocked.
-	 */
-	if (bip != NULL) {
-		xfs_trans_unlocked_item(bip->bli_item.li_ailp,
-					(xfs_log_item_t*)bip);
 	}
 
+	bp->b_transp = NULL;
 	xfs_buf_relse(bp);
-	return;
 }
 
 /*
Index: xfs/fs/xfs/xfs_trans_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_priv.h	2012-02-17 18:45:34.593333162 -0800
+++ xfs/fs/xfs/xfs_trans_priv.h	2012-02-19 13:02:44.703294862 -0800
@@ -104,9 +104,6 @@ void			xfs_ail_push(struct xfs_ail *, xf
 void			xfs_ail_push_all(struct xfs_ail *);
 xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
 
-void			xfs_trans_unlocked_item(struct xfs_ail *,
-					xfs_log_item_t *);
-
 struct xfs_log_item *	xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur,
 					xfs_lsn_t lsn);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
