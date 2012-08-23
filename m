Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53KpM135042 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:20 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	kWnBXr5DUsZDMrCS for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:05 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaK-0003GS-SW
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:01 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaK-0003eJ-Ps
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 038/102] xfs: remove xfs_trans_unlocked_item
Date: Thu, 23 Aug 2012 15:01:56 +1000
Message-Id: <1345698180-13612-39-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

Upstream commit: 5b03ff1b2444ddf7b8084b7505101e97257aff5a

There is no reason to wake up log space waiters when unlocking inodes or
dquots, and the commit log has no explanation for this function either.

Given that we now have exact log space wakeups everywhere we can assume
the reason for this function was to paper over log space races in earlier
XFS versions.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/quota/xfs_dquot.c |    5 -----
 fs/xfs/xfs_iget.c        |   13 +------------
 fs/xfs/xfs_inode.h       |    4 +---
 fs/xfs/xfs_inode_item.c  |    6 +-----
 fs/xfs/xfs_trans_ail.c   |   44 --------------------------------------------
 fs/xfs/xfs_trans_buf.c   |   26 +-------------------------
 fs/xfs/xfs_trans_priv.h  |    3 ---
 7 files changed, 4 insertions(+), 97 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index b8be8a0..85176d6 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1278,11 +1278,6 @@ xfs_dqunlock(
 	xfs_dquot_t *dqp)
 {
 	mutex_unlock(&(dqp->q_qlock));
-	if (dqp->q_logitem.qli_dquot == dqp) {
-		/* Once was dqp->q_mount, but might just have been cleared */
-		xfs_trans_unlocked_item(dqp->q_logitem.qli_item.li_ailp,
-					(xfs_log_item_t*)&(dqp->q_logitem));
-	}
 }
 
 
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index 6364fc0..b8c110f 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -654,8 +654,7 @@ xfs_iunlock(
 	       (XFS_IOLOCK_SHARED | XFS_IOLOCK_EXCL));
 	ASSERT((lock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL)) !=
 	       (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
-	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_IUNLOCK_NONOTIFY |
-			XFS_LOCK_DEP_MASK)) == 0);
+	ASSERT((lock_flags & ~(XFS_LOCK_MASK | XFS_LOCK_DEP_MASK)) == 0);
 	ASSERT(lock_flags != 0);
 
 	if (lock_flags & XFS_IOLOCK_EXCL)
@@ -668,16 +667,6 @@ xfs_iunlock(
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
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 1a181d5..d3bbc93 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -409,7 +409,6 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
 #define	XFS_IOLOCK_SHARED	(1<<1)
 #define	XFS_ILOCK_EXCL		(1<<2)
 #define	XFS_ILOCK_SHARED	(1<<3)
-#define	XFS_IUNLOCK_NONOTIFY	(1<<4)
 
 #define XFS_LOCK_MASK		(XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED \
 				| XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)
@@ -418,8 +417,7 @@ static inline void xfs_ifunlock(xfs_inode_t *ip)
 	{ XFS_IOLOCK_EXCL,	"IOLOCK_EXCL" }, \
 	{ XFS_IOLOCK_SHARED,	"IOLOCK_SHARED" }, \
 	{ XFS_ILOCK_EXCL,	"ILOCK_EXCL" }, \
-	{ XFS_ILOCK_SHARED,	"ILOCK_SHARED" }, \
-	{ XFS_IUNLOCK_NONOTIFY,	"IUNLOCK_NONOTIFY" }
+	{ XFS_ILOCK_SHARED,	"ILOCK_SHARED" }
 
 
 /*
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 391044c..61fb163 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -600,11 +600,7 @@ xfs_inode_item_trylock(
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
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index db5cd1b..3934d97 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -662,50 +662,6 @@ xfs_ail_push_all(
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
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 26abce5..d733bb8 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -457,26 +457,12 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 		 xfs_buf_t	*bp)
 {
 	xfs_buf_log_item_t	*bip;
-	xfs_log_item_t		*lip;
 
 	/*
 	 * Default to a normal brelse() call if the tp is NULL.
 	 */
 	if (tp == NULL) {
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, void *) == NULL);
-		/*
-		 * If there's a buf log item attached to the buffer,
-		 * then let the AIL know that the buffer is being
-		 * unlocked.
-		 */
-		if (XFS_BUF_FSPRIVATE(bp, void *) != NULL) {
-			lip = XFS_BUF_FSPRIVATE(bp, xfs_log_item_t *);
-			if (lip->li_type == XFS_LI_BUF) {
-				bip = XFS_BUF_FSPRIVATE(bp,xfs_buf_log_item_t*);
-				xfs_trans_unlocked_item(bip->bli_item.li_ailp,
-							lip);
-			}
-		}
 		xfs_buf_relse(bp);
 		return;
 	}
@@ -551,19 +537,9 @@ xfs_trans_brelse(xfs_trans_t	*tp,
 		ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
 		ASSERT(!(bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF));
 		xfs_buf_item_relse(bp);
-		bip = NULL;
-	}
-	XFS_BUF_SET_FSPRIVATE2(bp, NULL);
-
-	/*
-	 * If we've still got a buf log item on the buffer, then
-	 * tell the AIL that the buffer is being unlocked.
-	 */
-	if (bip != NULL) {
-		xfs_trans_unlocked_item(bip->bli_item.li_ailp,
-					(xfs_log_item_t*)bip);
 	}
 
+	XFS_BUF_SET_FSPRIVATE2(bp, NULL);
 	xfs_buf_relse(bp);
 	return;
 }
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 8c0c465..0683936 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -104,9 +104,6 @@ void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
 void			xfs_ail_push_all(struct xfs_ail *);
 xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
 
-void			xfs_trans_unlocked_item(struct xfs_ail *,
-					xfs_log_item_t *);
-
 struct xfs_log_item *	xfs_trans_ail_cursor_first(struct xfs_ail *ailp,
 					struct xfs_ail_cursor *cur,
 					xfs_lsn_t lsn);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
