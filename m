Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 21:07:20 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA5574Qj006251
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 21:07:09 -0800
Date: Mon, 5 Nov 2007 16:07:06 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH, RFC] Move AIL pushing into a separate thread
Message-ID: <20071105050706.GW66820511@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>

When many hundreds to thousands of threads all try to do simultaneous
transactions and the log is in a tail-pushing situation (i.e. full),
we can get multiple threads walking the AIL list and contending on
the AIL lock.

Recently wevve had two cases of machines basically locking up because
most of the CPUs in the system are trying to obtain the AIL lock.
The first was an 8p machine with ~2,500 kernel threads trying to
do transactions, and the latest is a 2048p altix closing a file per
MPI rank in a synchronised fashion resulting in > 400 processes
all trying to walk and push the AIL at the same time.

The AIL push is, in effect, a simple I/O dispatch algorithm complicated
by the ordering constraints placed on it by the transaction subsystem.
It really does not need multiple threads to push on it - even when
only a single CPU is pushing the AIL, it can push the I/O out far faster
that pretty much any disk subsystem can handle.

So, to avoid contention problems stemming from multiple list walkers,
move the list walk off into another thread and simply provide a "target"
to push to. When a thread requires a push, it sets the target and wakes
the push thread, then goes to sleep waiting for the required amount
of space to become available in the log.

This mechanism should also be a lot fairer under heavy load as the
waiters will queue in arrival order, rather than queuing in "who completed
a push first" order.

Also, by moving the pushing to a separate thread we can do more effectively
overload detection and prevention as we can keep context from loop iteration
to loop iteration. That is, we can push only part of the list each loop and not
have to loop back to the start of the list every time we run. This should
also help by reducing the number of items we try to lock and/or push items
that we cannot move.

Note that this patch is not intended to solve the inefficiencies in the
AIL structure and the associated issues with extremely large list contents.
That needs to be addresses separately; parallel access would cause problems
to any new structure as well, so I'm only aiming to isolate the structure
from unbounded parallelism here.

Signed-Off-By: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   60 +++++++++++
 fs/xfs/xfs_log.c             |   12 ++
 fs/xfs/xfs_mount.c           |    6 -
 fs/xfs/xfs_mount.h           |   10 +
 fs/xfs/xfs_trans.h           |    1 
 fs/xfs/xfs_trans_ail.c       |  231 ++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_trans_priv.h      |    8 +
 fs/xfs/xfsidbg.c             |   12 +-
 8 files changed, 247 insertions(+), 93 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2007-11-05 10:39:05.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2007-11-05 14:48:39.871177707 +1100
@@ -51,6 +51,7 @@
 #include "xfs_vfsops.h"
 #include "xfs_version.h"
 #include "xfs_log_priv.h"
+#include "xfs_trans_priv.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -765,6 +766,65 @@ xfs_blkdev_issue_flush(
 	blkdev_issue_flush(buftarg->bt_bdev, NULL);
 }
 
+/*
+ * XFS AIL push thread support
+ */
+void
+xfsaild_wakeup(
+	xfs_mount_t		*mp,
+	xfs_lsn_t		threshold_lsn)
+{
+
+	if (XFS_LSN_CMP(threshold_lsn, mp->m_ail.xa_target) > 0) {
+		mp->m_ail.xa_target = threshold_lsn;
+		wake_up_process(mp->m_ail.xa_task);
+	}
+}
+
+int
+xfsaild(
+	void	*data)
+{
+	xfs_mount_t	*mp = (xfs_mount_t *)data;
+	xfs_lsn_t	last_pushed_lsn = 0;
+	long		tout = 0;
+
+	while (!kthread_should_stop()) {
+		if (tout)
+			schedule_timeout_interruptible(msecs_to_jiffies(tout));
+
+		/* swsusp */
+		try_to_freeze();
+
+		/* we're either starting or stopping if there is no log */
+		if (!mp->m_log)
+			continue;
+
+		tout = xfsaild_push(mp, &last_pushed_lsn);
+	}
+
+	return 0;
+}	/* xfsaild */
+
+void
+xfsaild_start(
+	xfs_mount_t	*mp)
+{
+	mp->m_ail.xa_target = 0;
+	mp->m_ail.xa_task = kthread_run(xfsaild, mp, "xfsaild");
+	ASSERT(!IS_ERR(mp->m_ail.xa_task));
+	/* XXX: should return error but nowhere to do it */
+}
+
+void
+xfsaild_stop(
+	xfs_mount_t	*mp)
+{
+	kthread_stop(mp->m_ail.xa_task);
+}
+
+
+
 STATIC struct inode *
 xfs_fs_alloc_inode(
 	struct super_block	*sb)
Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-11-02 18:00:19.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-11-05 14:07:16.850189316 +1100
@@ -515,6 +515,12 @@ xfs_log_mount(xfs_mount_t	*mp,
 	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
 
 	/*
+	 * Initialize the AIL now we have a log.
+	 */
+	spin_lock_init(&mp->m_ail_lock);
+	xfs_trans_ail_init(mp);
+
+	/*
 	 * skip log recovery on a norecovery mount.  pretend it all
 	 * just worked.
 	 */
@@ -530,7 +536,7 @@ xfs_log_mount(xfs_mount_t	*mp,
 			mp->m_flags |= XFS_MOUNT_RDONLY;
 		if (error) {
 			cmn_err(CE_WARN, "XFS: log mount/recovery failed: error %d", error);
-			xlog_dealloc_log(mp->m_log);
+			xfs_log_unmount_dealloc(mp);
 			return error;
 		}
 	}
@@ -722,10 +728,14 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 
 /*
  * Deallocate log structures for unmount/relocation.
+ *
+ * We need to stop the aild from running before we destroy
+ * and deallocate the log as the aild references the log.
  */
 void
 xfs_log_unmount_dealloc(xfs_mount_t *mp)
 {
+	xfs_trans_ail_destroy(mp);
 	xlog_dealloc_log(mp->m_log);
 }
 
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-11-02 13:44:50.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-11-05 14:12:22.554601173 +1100
@@ -137,15 +137,9 @@ xfs_mount_init(void)
 		mp->m_flags |= XFS_MOUNT_NO_PERCPU_SB;
 	}
 
-	spin_lock_init(&mp->m_ail_lock);
 	spin_lock_init(&mp->m_sb_lock);
 	mutex_init(&mp->m_ilock);
 	mutex_init(&mp->m_growlock);
-	/*
-	 * Initialize the AIL.
-	 */
-	xfs_trans_ail_init(mp);
-
 	atomic_set(&mp->m_active_trans, 0);
 
 	return mp;
Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.h	2007-10-16 08:52:58.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.h	2007-11-05 14:14:42.652456849 +1100
@@ -219,12 +219,18 @@ extern void	xfs_icsb_sync_counters_flags
 #define xfs_icsb_sync_counters_flags(mp, flags)	do { } while (0)
 #endif
 
+typedef struct xfs_ail {
+	xfs_ail_entry_t		xa_ail;
+	uint			xa_gen;
+	struct task_struct	*xa_task;
+	xfs_lsn_t		xa_target;
+} xfs_ail_t;
+
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
 	spinlock_t		m_ail_lock;	/* fs AIL mutex */
-	xfs_ail_entry_t		m_ail;		/* fs active log item list */
-	uint			m_ail_gen;	/* fs AIL generation count */
+	xfs_ail_t		m_ail;		/* fs active log item list */
 	xfs_sb_t		m_sb;		/* copy of fs superblock */
 	spinlock_t		m_sb_lock;	/* sb counter lock */
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans.h	2007-11-02 13:44:46.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans.h	2007-11-05 14:01:13.205272667 +1100
@@ -993,6 +993,7 @@ int		_xfs_trans_commit(xfs_trans_t *,
 #define xfs_trans_commit(tp, flags)	_xfs_trans_commit(tp, flags, NULL)
 void		xfs_trans_cancel(xfs_trans_t *, int);
 void		xfs_trans_ail_init(struct xfs_mount *);
+void		xfs_trans_ail_destroy(struct xfs_mount *);
 xfs_lsn_t	xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
 xfs_lsn_t	xfs_trans_tail_ail(struct xfs_mount *);
 void		xfs_trans_unlocked_item(struct xfs_mount *,
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_ail.c	2007-10-02 16:01:48.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c	2007-11-05 14:46:44.206327966 +1100
@@ -57,7 +57,7 @@ xfs_trans_tail_ail(
 	xfs_log_item_t	*lip;
 
 	spin_lock(&mp->m_ail_lock);
-	lip = xfs_ail_min(&(mp->m_ail));
+	lip = xfs_ail_min(&(mp->m_ail.xa_ail));
 	if (lip == NULL) {
 		lsn = (xfs_lsn_t)0;
 	} else {
@@ -71,25 +71,22 @@ xfs_trans_tail_ail(
 /*
  * xfs_trans_push_ail
  *
- * This routine is called to move the tail of the AIL
- * forward.  It does this by trying to flush items in the AIL
- * whose lsns are below the given threshold_lsn.
+ * This routine is called to move the tail of the AIL forward.  It does this by
+ * trying to flush items in the AIL whose lsns are below the given
+ * threshold_lsn.
  *
- * The routine returns the lsn of the tail of the log.
+ * the push is run asynchronously in a separate thread, so we return the tail
+ * of the log right now instead of the tail after the push. This means we will
+ * either continue right away, or we will sleep waiting on the async thread to
+ * do it's work.
  */
 xfs_lsn_t
 xfs_trans_push_ail(
 	xfs_mount_t		*mp,
 	xfs_lsn_t		threshold_lsn)
 {
-	xfs_lsn_t		lsn;
 	xfs_log_item_t		*lip;
 	int			gen;
-	int			restarts;
-	int			lock_result;
-	int			flush_log;
-
-#define	XFS_TRANS_PUSH_AIL_RESTARTS	1000
 
 	spin_lock(&mp->m_ail_lock);
 	lip = xfs_trans_first_ail(mp, &gen);
@@ -100,57 +97,105 @@ xfs_trans_push_ail(
 		spin_unlock(&mp->m_ail_lock);
 		return (xfs_lsn_t)0;
 	}
+	if (XFS_LSN_CMP(threshold_lsn, mp->m_ail.xa_target) > 0)
+		xfsaild_wakeup(mp, threshold_lsn);
+	spin_unlock(&mp->m_ail_lock);
+	return (xfs_lsn_t)lip->li_lsn;
+}
+
+/*
+ * Return the item in the AIL with the current lsn.
+ * Return the current tree generation number for use
+ * in calls to xfs_trans_next_ail().
+ */
+STATIC xfs_log_item_t *
+xfs_trans_first_push_ail(
+	xfs_mount_t	*mp,
+	int		*gen,
+	xfs_lsn_t	lsn)
+{
+	xfs_log_item_t	*lip;
+
+	lip = xfs_ail_min(&(mp->m_ail.xa_ail));
+	*gen = (int)mp->m_ail.xa_gen;
+	while (lip && (XFS_LSN_CMP(lip->li_lsn, lsn) < 0))
+		lip = lip->li_ail.ail_forw;
+
+	return (lip);
+}
+
+/*
+ * Function that does the work of pushing on the AIL
+ */
+long
+xfsaild_push(
+	xfs_mount_t	*mp,
+	xfs_lsn_t	*last_lsn)
+{
+	long		tout = 100; /* milliseconds */
+	xfs_lsn_t	last_pushed_lsn = *last_lsn;
+	xfs_lsn_t	target =  mp->m_ail.xa_target;
+	xfs_lsn_t	lsn;
+	xfs_log_item_t	*lip;
+	int		lock_result;
+	int		gen;
+	int		restarts;
+	int		flush_log, count, stuck;
+
+#define	XFS_TRANS_PUSH_AIL_RESTARTS	10
+
+	spin_lock(&mp->m_ail_lock);
+	lip = xfs_trans_first_push_ail(mp, &gen, *last_lsn);
+	if (lip == NULL || XFS_FORCED_SHUTDOWN(mp)) {
+		/*
+		 * AIL is empty or our push has reached the end.
+		 */
+		spin_unlock(&mp->m_ail_lock);
+		last_pushed_lsn = 0;
+		goto out;
+	}
 
 	XFS_STATS_INC(xs_push_ail);
 
 	/*
 	 * While the item we are looking at is below the given threshold
-	 * try to flush it out.  Make sure to limit the number of times
-	 * we allow xfs_trans_next_ail() to restart scanning from the
-	 * beginning of the list.  We'd like not to stop until we've at least
+	 * try to flush it out. We'd like not to stop until we've at least
 	 * tried to push on everything in the AIL with an LSN less than
-	 * the given threshold. However, we may give up before that if
-	 * we realize that we've been holding the AIL lock for 'too long',
-	 * blocking interrupts. Currently, too long is < 500us roughly.
+	 * the given threshold.
+	 *
+	 * However, we will stop after a certain number of pushes and wait
+	 * for a reduced timeout to fire before pushing further. This
+	 * prevents use from spinning when we can't do anything or there is
+	 * lots of contention on the AIL lists.
 	 */
-	flush_log = 0;
-	restarts = 0;
-	while (((restarts < XFS_TRANS_PUSH_AIL_RESTARTS) &&
-		(XFS_LSN_CMP(lip->li_lsn, threshold_lsn) < 0))) {
+	tout = 10;
+	lsn = lip->li_lsn;
+	flush_log = stuck = count = 0;
+	while ((XFS_LSN_CMP(lip->li_lsn, target) < 0)) {
 		/*
-		 * If we can lock the item without sleeping, unlock
-		 * the AIL lock and flush the item.  Then re-grab the
-		 * AIL lock so we can look for the next item on the
-		 * AIL.  Since we unlock the AIL while we flush the
-		 * item, the next routine may start over again at the
-		 * the beginning of the list if anything has changed.
-		 * That is what the generation count is for.
+		 * If we can lock the item without sleeping, unlock the AIL
+		 * lock and flush the item.  Then re-grab the AIL lock so we
+		 * can look for the next item on the AIL. List changes are
+		 * handled by the AIL lookup functions internally
 		 *
-		 * If we can't lock the item, either its holder will flush
-		 * it or it is already being flushed or it is being relogged.
-		 * In any of these case it is being taken care of and we
-		 * can just skip to the next item in the list.
+		 * If we can't lock the item, either its holder will flush it
+		 * or it is already being flushed or it is being relogged.  In
+		 * any of these case it is being taken care of and we can just
+		 * skip to the next item in the list.
 		 */
 		lock_result = IOP_TRYLOCK(lip);
+		spin_unlock(&mp->m_ail_lock);
 		switch (lock_result) {
 		      case XFS_ITEM_SUCCESS:
-			spin_unlock(&mp->m_ail_lock);
 			XFS_STATS_INC(xs_push_ail_success);
 			IOP_PUSH(lip);
-			spin_lock(&mp->m_ail_lock);
+			last_pushed_lsn = lsn;
 			break;
 
 		      case XFS_ITEM_PUSHBUF:
-			spin_unlock(&mp->m_ail_lock);
 			XFS_STATS_INC(xs_push_ail_pushbuf);
-#ifdef XFSRACEDEBUG
-			delay_for_intr();
-			delay(300);
-#endif
-			ASSERT(lip->li_ops->iop_pushbuf);
-			ASSERT(lip);
 			IOP_PUSHBUF(lip);
-			spin_lock(&mp->m_ail_lock);
+			last_pushed_lsn = lsn;
 			break;
 
 		      case XFS_ITEM_PINNED:
@@ -160,10 +205,14 @@ xfs_trans_push_ail(
 
 		      case XFS_ITEM_LOCKED:
 			XFS_STATS_INC(xs_push_ail_locked);
+			last_pushed_lsn = lsn;
+			stuck++;
 			break;
 
 		      case XFS_ITEM_FLUSHING:
 			XFS_STATS_INC(xs_push_ail_flushing);
+			last_pushed_lsn = lsn;
+			stuck++;
 			break;
 
 		      default:
@@ -171,19 +220,26 @@ xfs_trans_push_ail(
 			break;
 		}
 
+		spin_lock(&mp->m_ail_lock);
+		count++;
+		/* Too many items we can't do anything with? */
+		if (stuck > 100)
+			break;
+		/* we're either starting or stopping if there is no log */
+		if (!mp->m_log)
+			break;
+		/* should we bother continuing? */
+		if (XFS_FORCED_SHUTDOWN(mp))
+			break;
+		/* get the next item */
 		lip = xfs_trans_next_ail(mp, lip, &gen, &restarts);
-		if (lip == NULL) {
+		if (lip == NULL)
 			break;
-		}
-		if (XFS_FORCED_SHUTDOWN(mp)) {
-			/*
-			 * Just return if we shut down during the last try.
-			 */
-			spin_unlock(&mp->m_ail_lock);
-			return (xfs_lsn_t)0;
-		}
-
+		if (restarts > XFS_TRANS_PUSH_AIL_RESTARTS)
+			break;
+		lsn = lip->li_lsn;
 	}
+	spin_unlock(&mp->m_ail_lock);
 
 	if (flush_log) {
 		/*
@@ -191,22 +247,33 @@ xfs_trans_push_ail(
 		 * push out the log so it will become unpinned and
 		 * move forward in the AIL.
 		 */
-		spin_unlock(&mp->m_ail_lock);
 		XFS_STATS_INC(xs_push_ail_flush);
 		xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE);
-		spin_lock(&mp->m_ail_lock);
 	}
 
-	lip = xfs_ail_min(&(mp->m_ail));
-	if (lip == NULL) {
-		lsn = (xfs_lsn_t)0;
-	} else {
-		lsn = lip->li_lsn;
+	/*
+	 * We reached the target so wait a bit longer for I/O to complete and
+	 * remove pushed items from the AIL before we start the next scan from
+	 * the start of the AIL.
+	 */
+	if ((XFS_LSN_CMP(lsn, target) >= 0)) {
+		tout += 20;
+		last_pushed_lsn = 0;
+	} else if ((restarts > XFS_TRANS_PUSH_AIL_RESTARTS) ||
+		   (count && (count < (stuck + 10)))) {
+		/*
+		 * Either there is a lot of contention on the AIL or we
+		 * found a lot of items we couldn't do anything with.
+		 * Backoff a bit more to allow some I/O to complete before
+		 * continuing from where we were.
+		 */
+		tout += 10;
 	}
 
-	spin_unlock(&mp->m_ail_lock);
-	return lsn;
-}	/* xfs_trans_push_ail */
+out:
+	*last_lsn = last_pushed_lsn;
+	return tout;
+}	/* xfsaild_push */
 
 
 /*
@@ -247,7 +314,7 @@ xfs_trans_unlocked_item(
 	 * the call to xfs_log_move_tail() doesn't do anything if there's
 	 * not enough free space to wake people up so we're safe calling it.
 	 */
-	min_lip = xfs_ail_min(&mp->m_ail);
+	min_lip = xfs_ail_min(&mp->m_ail.xa_ail);
 
 	if (min_lip == lip)
 		xfs_log_move_tail(mp, 1);
@@ -279,7 +346,7 @@ xfs_trans_update_ail(
 	xfs_log_item_t		*dlip=NULL;
 	xfs_log_item_t		*mlip;	/* ptr to minimum lip */
 
-	ailp = &(mp->m_ail);
+	ailp = &(mp->m_ail.xa_ail);
 	mlip = xfs_ail_min(ailp);
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
@@ -292,10 +359,10 @@ xfs_trans_update_ail(
 	lip->li_lsn = lsn;
 
 	xfs_ail_insert(ailp, lip);
-	mp->m_ail_gen++;
+	mp->m_ail.xa_gen++;
 
 	if (mlip == dlip) {
-		mlip = xfs_ail_min(&(mp->m_ail));
+		mlip = xfs_ail_min(&(mp->m_ail.xa_ail));
 		spin_unlock(&mp->m_ail_lock);
 		xfs_log_move_tail(mp, mlip->li_lsn);
 	} else {
@@ -330,7 +397,7 @@ xfs_trans_delete_ail(
 	xfs_log_item_t		*mlip;
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
-		ailp = &(mp->m_ail);
+		ailp = &(mp->m_ail.xa_ail);
 		mlip = xfs_ail_min(ailp);
 		dlip = xfs_ail_delete(ailp, lip);
 		ASSERT(dlip == lip);
@@ -338,10 +405,10 @@ xfs_trans_delete_ail(
 
 		lip->li_flags &= ~XFS_LI_IN_AIL;
 		lip->li_lsn = 0;
-		mp->m_ail_gen++;
+		mp->m_ail.xa_gen++;
 
 		if (mlip == dlip) {
-			mlip = xfs_ail_min(&(mp->m_ail));
+			mlip = xfs_ail_min(&(mp->m_ail.xa_ail));
 			spin_unlock(&mp->m_ail_lock);
 			xfs_log_move_tail(mp, (mlip ? mlip->li_lsn : 0));
 		} else {
@@ -379,10 +446,10 @@ xfs_trans_first_ail(
 {
 	xfs_log_item_t	*lip;
 
-	lip = xfs_ail_min(&(mp->m_ail));
-	*gen = (int)mp->m_ail_gen;
+	lip = xfs_ail_min(&(mp->m_ail.xa_ail));
+	*gen = (int)mp->m_ail.xa_gen;
 
-	return (lip);
+	return lip;
 }
 
 /*
@@ -402,11 +469,11 @@ xfs_trans_next_ail(
 	xfs_log_item_t	*nlip;
 
 	ASSERT(mp && lip && gen);
-	if (mp->m_ail_gen == *gen) {
-		nlip = xfs_ail_next(&(mp->m_ail), lip);
+	if (mp->m_ail.xa_gen == *gen) {
+		nlip = xfs_ail_next(&(mp->m_ail.xa_ail), lip);
 	} else {
-		nlip = xfs_ail_min(&(mp->m_ail));
-		*gen = (int)mp->m_ail_gen;
+		nlip = xfs_ail_min(&(mp->m_ail).xa_ail);
+		*gen = (int)mp->m_ail.xa_gen;
 		if (restarts != NULL) {
 			XFS_STATS_INC(xs_push_ail_restarts);
 			(*restarts)++;
@@ -435,8 +502,16 @@ void
 xfs_trans_ail_init(
 	xfs_mount_t	*mp)
 {
-	mp->m_ail.ail_forw = (xfs_log_item_t*)&(mp->m_ail);
-	mp->m_ail.ail_back = (xfs_log_item_t*)&(mp->m_ail);
+	mp->m_ail.xa_ail.ail_forw = (xfs_log_item_t*)&mp->m_ail.xa_ail;
+	mp->m_ail.xa_ail.ail_back = (xfs_log_item_t*)&mp->m_ail.xa_ail;
+	xfsaild_start(mp);
+}
+
+void
+xfs_trans_ail_destroy(
+	xfs_mount_t	*mp)
+{
+	xfsaild_stop(mp);
 }
 
 /*
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_priv.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_priv.h	2007-10-02 16:01:48.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans_priv.h	2007-11-05 14:02:18.784782356 +1100
@@ -57,4 +57,12 @@ struct xfs_log_item	*xfs_trans_next_ail(
 				     struct xfs_log_item *, int *, int *);
 
 
+/*
+ * AIL push thread support
+ */
+long	xfsaild_push(struct xfs_mount *, xfs_lsn_t *);
+void	xfsaild_wakeup(struct xfs_mount *, xfs_lsn_t);
+void	xfsaild_start(struct xfs_mount *);
+void	xfsaild_stop(struct xfs_mount *);
+
 #endif	/* __XFS_TRANS_PRIV_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2007-11-02 13:44:50.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2007-11-05 14:50:43.099049624 +1100
@@ -6220,13 +6220,13 @@ xfsidbg_xaildump(xfs_mount_t *mp)
 		};
 	int count;
 
-	if ((mp->m_ail.ail_forw == NULL) ||
-	    (mp->m_ail.ail_forw == (xfs_log_item_t *)&mp->m_ail)) {
+	if ((mp->m_ail.xa_ail.ail_forw == NULL) ||
+	    (mp->m_ail.xa_ail.ail_forw == (xfs_log_item_t *)&mp->m_ail.xa_ail)) {
 		kdb_printf("AIL is empty\n");
 		return;
 	}
 	kdb_printf("AIL for mp 0x%p, oldest first\n", mp);
-	lip = (xfs_log_item_t*)mp->m_ail.ail_forw;
+	lip = (xfs_log_item_t*)mp->m_ail.xa_ail.ail_forw;
 	for (count = 0; lip; count++) {
 		kdb_printf("[%d] type %s ", count, xfsidbg_item_type_str(lip));
 		printflags((uint)(lip->li_flags), li_flags, "flags:");
@@ -6255,7 +6255,7 @@ xfsidbg_xaildump(xfs_mount_t *mp)
 			break;
 		}
 
-		if (lip->li_ail.ail_forw == (xfs_log_item_t*)&mp->m_ail) {
+		if (lip->li_ail.ail_forw == (xfs_log_item_t*)&mp->m_ail.xa_ail) {
 			lip = NULL;
 		} else {
 			lip = lip->li_ail.ail_forw;
@@ -6312,9 +6312,9 @@ xfsidbg_xmount(xfs_mount_t *mp)
 
 	kdb_printf("xfs_mount at 0x%p\n", mp);
 	kdb_printf("tid 0x%x ail_lock 0x%p &ail 0x%p\n",
-		mp->m_tid, &mp->m_ail_lock, &mp->m_ail);
+		mp->m_tid, &mp->m_ail_lock, &mp->m_ail.xa_ail);
 	kdb_printf("ail_gen 0x%x &sb 0x%p\n",
-		mp->m_ail_gen, &mp->m_sb);
+		mp->m_ail.xa_gen, &mp->m_sb);
 	kdb_printf("sb_lock 0x%p sb_bp 0x%p dev 0x%x logdev 0x%x rtdev 0x%x\n",
 		&mp->m_sb_lock, mp->m_sb_bp,
 		mp->m_ddev_targp ? mp->m_ddev_targp->bt_dev : 0,
