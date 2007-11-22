Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 16:46:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAM0kbSf015876
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 16:46:39 -0800
Date: Thu, 22 Nov 2007 11:46:44 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 1/2] AIL list threading V2
Message-ID: <20071122004643.GP114266761@sgi.com>
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

Version 2:

o clean up xfs_trans_push_ail()
o xfs_trans_push_ail() can be done unlocked - the lsn we are returning
  is never used so we only need to know if the AIL is not empty before
  deciding whether we need to wake up the push thread.
o only check the threshold lsn against the current target once before
  waking the aild.
o change checks of mp->m_log to ASSERT()s. Any time this fires it's
  indicative of a bug as the aild should only run when there is a log.
o fixed switch indentation in xfsaild_push().
o initialised restarts variable correctly.
o lengthen idle timeout to 1s.
o return an error from xfs_trans_ail_init() and propagate it to fail
  mounting the log.
o add comment to "stuck" checks indicating the source of the magic
  numbers.
o pinned items are "stuck".

Signed-Off-By: Dave Chinner <dgc@sgi.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   59 +++++++++
 fs/xfs/xfs_log.c             |   33 ++++-
 fs/xfs/xfs_mount.c           |    6 
 fs/xfs/xfs_mount.h           |   10 +
 fs/xfs/xfs_trans.h           |    5 
 fs/xfs/xfs_trans_ail.c       |  269 ++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_trans_priv.h      |    8 +
 fs/xfs/xfsidbg.c             |   12 -
 8 files changed, 288 insertions(+), 114 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2007-11-22 10:33:51.041703837 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2007-11-22 10:34:01.556359712 +1100
@@ -51,6 +51,7 @@
 #include "xfs_vfsops.h"
 #include "xfs_version.h"
 #include "xfs_log_priv.h"
+#include "xfs_trans_priv.h"
 
 #include <linux/namei.h>
 #include <linux/init.h>
@@ -765,6 +766,64 @@ xfs_blkdev_issue_flush(
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
+	mp->m_ail.xa_target = threshold_lsn;
+	wake_up_process(mp->m_ail.xa_task);
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
+		tout = 1000;
+
+		/* swsusp */
+		try_to_freeze();
+
+		ASSERT(mp->m_log);
+		if (XFS_FORCED_SHUTDOWN(mp))
+			continue;
+
+		tout = xfsaild_push(mp, &last_pushed_lsn);
+	}
+
+	return 0;
+}	/* xfsaild */
+
+int
+xfsaild_start(
+	xfs_mount_t	*mp)
+{
+	mp->m_ail.xa_target = 0;
+	mp->m_ail.xa_task = kthread_run(xfsaild, mp, "xfsaild");
+	if (IS_ERR(mp->m_ail.xa_task))
+		return -PTR_ERR(mp->m_ail.xa_task);
+	return 0;
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
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-11-22 10:33:05.775490010 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-11-22 10:34:01.560359200 +1100
@@ -498,11 +498,14 @@ xfs_log_reserve(xfs_mount_t	 *mp,
  * Return error or zero.
  */
 int
-xfs_log_mount(xfs_mount_t	*mp,
-	      xfs_buftarg_t	*log_target,
-	      xfs_daddr_t	blk_offset,
-	      int		num_bblks)
+xfs_log_mount(
+	xfs_mount_t	*mp,
+	xfs_buftarg_t	*log_target,
+	xfs_daddr_t	blk_offset,
+	int		num_bblks)
 {
+	int		error;
+
 	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY))
 		cmn_err(CE_NOTE, "XFS mounting filesystem %s", mp->m_fsname);
 	else {
@@ -515,11 +518,21 @@ xfs_log_mount(xfs_mount_t	*mp,
 	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
 
 	/*
+	 * Initialize the AIL now we have a log.
+	 */
+	spin_lock_init(&mp->m_ail_lock);
+	error = xfs_trans_ail_init(mp);
+	if (error) {
+		cmn_err(CE_WARN, "XFS: AIL initialisation failed: error %d", error);
+		goto error;
+	}
+
+	/*
 	 * skip log recovery on a norecovery mount.  pretend it all
 	 * just worked.
 	 */
 	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
-		int		error, readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
+		int	readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
 
 		if (readonly)
 			mp->m_flags &= ~XFS_MOUNT_RDONLY;
@@ -530,8 +543,7 @@ xfs_log_mount(xfs_mount_t	*mp,
 			mp->m_flags |= XFS_MOUNT_RDONLY;
 		if (error) {
 			cmn_err(CE_WARN, "XFS: log mount/recovery failed: error %d", error);
-			xlog_dealloc_log(mp->m_log);
-			return error;
+			goto error;
 		}
 	}
 
@@ -540,6 +552,9 @@ xfs_log_mount(xfs_mount_t	*mp,
 
 	/* End mounting message in xfs_log_mount_finish */
 	return 0;
+error:
+	xfs_log_unmount_dealloc(mp);
+	return error;
 }	/* xfs_log_mount */
 
 /*
@@ -722,10 +737,14 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 
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
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-11-22 10:33:57.732848488 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-11-22 10:34:01.560359200 +1100
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
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.h	2007-11-22 10:25:24.974357020 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.h	2007-11-22 10:34:01.560359200 +1100
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
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans.h	2007-11-22 10:25:24.978356509 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans.h	2007-11-22 10:34:01.564358689 +1100
@@ -992,8 +992,9 @@ int		_xfs_trans_commit(xfs_trans_t *,
 				  int *);
 #define xfs_trans_commit(tp, flags)	_xfs_trans_commit(tp, flags, NULL)
 void		xfs_trans_cancel(xfs_trans_t *, int);
-void		xfs_trans_ail_init(struct xfs_mount *);
-xfs_lsn_t	xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
+int		xfs_trans_ail_init(struct xfs_mount *);
+void		xfs_trans_ail_destroy(struct xfs_mount *);
+void		xfs_trans_push_ail(struct xfs_mount *, xfs_lsn_t);
 xfs_lsn_t	xfs_trans_tail_ail(struct xfs_mount *);
 void		xfs_trans_unlocked_item(struct xfs_mount *,
 					xfs_log_item_t *);
Index: 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_ail.c	2007-11-22 10:25:24.978356509 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans_ail.c	2007-11-22 10:34:01.564358689 +1100
@@ -57,7 +57,7 @@ xfs_trans_tail_ail(
 	xfs_log_item_t	*lip;
 
 	spin_lock(&mp->m_ail_lock);
-	lip = xfs_ail_min(&(mp->m_ail));
+	lip = xfs_ail_min(&(mp->m_ail.xa_ail));
 	if (lip == NULL) {
 		lsn = (xfs_lsn_t)0;
 	} else {
@@ -71,119 +71,185 @@ xfs_trans_tail_ail(
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
+ *
+ * We do this unlocked - we only need to know whether there is anything in the
+ * AIL at the time we are called. We don't need to access the contents of
+ * any of the objects, so the lock is not needed.
  */
-xfs_lsn_t
+void
 xfs_trans_push_ail(
 	xfs_mount_t		*mp,
 	xfs_lsn_t		threshold_lsn)
 {
-	xfs_lsn_t		lsn;
 	xfs_log_item_t		*lip;
-	int			gen;
-	int			restarts;
-	int			lock_result;
-	int			flush_log;
 
-#define	XFS_TRANS_PUSH_AIL_RESTARTS	1000
+	lip = xfs_ail_min(&mp->m_ail.xa_ail);
+	if (lip && !XFS_FORCED_SHUTDOWN(mp)) {
+		if (XFS_LSN_CMP(threshold_lsn, mp->m_ail.xa_target) > 0)
+			xfsaild_wakeup(mp, threshold_lsn);
+	}
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
+	if (lsn == 0)
+		return lip;
+
+	while (lip && (XFS_LSN_CMP(lip->li_lsn, lsn) < 0))
+		lip = lip->li_ail.ail_forw;
+
+	return lip;
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
+	long		tout = 1000; /* milliseconds */
+	xfs_lsn_t	last_pushed_lsn = *last_lsn;
+	xfs_lsn_t	target =  mp->m_ail.xa_target;
+	xfs_lsn_t	lsn;
+	xfs_log_item_t	*lip;
+	int		gen;
+	int		restarts;
+	int		flush_log, count, stuck;
+
+#define	XFS_TRANS_PUSH_AIL_RESTARTS	10
 
 	spin_lock(&mp->m_ail_lock);
-	lip = xfs_trans_first_ail(mp, &gen);
-	if (lip == NULL || XFS_FORCED_SHUTDOWN(mp)) {
+	lip = xfs_trans_first_push_ail(mp, &gen, *last_lsn);
+	if (!lip || XFS_FORCED_SHUTDOWN(mp)) {
 		/*
-		 * Just return if the AIL is empty.
+		 * AIL is empty or our push has reached the end.
 		 */
 		spin_unlock(&mp->m_ail_lock);
-		return (xfs_lsn_t)0;
+		last_pushed_lsn = 0;
+		goto out;
 	}
 
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
+	flush_log = stuck = count = restarts = 0;
+	while ((XFS_LSN_CMP(lip->li_lsn, target) < 0)) {
+		int	lock_result;
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
-		      case XFS_ITEM_SUCCESS:
-			spin_unlock(&mp->m_ail_lock);
+		case XFS_ITEM_SUCCESS:
 			XFS_STATS_INC(xs_push_ail_success);
 			IOP_PUSH(lip);
-			spin_lock(&mp->m_ail_lock);
+			last_pushed_lsn = lsn;
 			break;
 
-		      case XFS_ITEM_PUSHBUF:
-			spin_unlock(&mp->m_ail_lock);
+		case XFS_ITEM_PUSHBUF:
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
 
-		      case XFS_ITEM_PINNED:
+		case XFS_ITEM_PINNED:
 			XFS_STATS_INC(xs_push_ail_pinned);
+			stuck++;
 			flush_log = 1;
 			break;
 
-		      case XFS_ITEM_LOCKED:
+		case XFS_ITEM_LOCKED:
 			XFS_STATS_INC(xs_push_ail_locked);
+			last_pushed_lsn = lsn;
+			stuck++;
 			break;
 
-		      case XFS_ITEM_FLUSHING:
+		case XFS_ITEM_FLUSHING:
 			XFS_STATS_INC(xs_push_ail_flushing);
+			last_pushed_lsn = lsn;
+			stuck++;
 			break;
 
-		      default:
+		default:
 			ASSERT(0);
 			break;
 		}
 
-		lip = xfs_trans_next_ail(mp, lip, &gen, &restarts);
-		if (lip == NULL) {
+		spin_lock(&mp->m_ail_lock);
+		/* should we bother continuing? */
+		if (XFS_FORCED_SHUTDOWN(mp))
 			break;
-		}
-		if (XFS_FORCED_SHUTDOWN(mp)) {
-			/*
-			 * Just return if we shut down during the last try.
-			 */
-			spin_unlock(&mp->m_ail_lock);
-			return (xfs_lsn_t)0;
-		}
+		ASSERT(mp->m_log);
+
+		count++;
 
+		/*
+		 * Are there too many items we can't do anything with?
+		 * If we we are skipping too many items because we can't flush
+		 * them or they are already being flushed, we back off and
+		 * given them time to complete whatever operation is being
+		 * done. i.e. remove pressure from the AIL while we can't make
+		 * progress so traversals don't slow down further inserts and
+		 * removals to/from the AIL.
+		 *
+		 * The value of 100 is an arbitrary magic number based on
+		 * observation.
+		 */
+		if (stuck > 100)
+			break;
+
+		lip = xfs_trans_next_ail(mp, lip, &gen, &restarts);
+		if (lip == NULL)
+			break;
+		if (restarts > XFS_TRANS_PUSH_AIL_RESTARTS)
+			break;
+		lsn = lip->li_lsn;
 	}
+	spin_unlock(&mp->m_ail_lock);
 
 	if (flush_log) {
 		/*
@@ -191,22 +257,35 @@ xfs_trans_push_ail(
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
+		   (count && ((stuck * 100) / count > 90))) {
+		/*
+		 * Either there is a lot of contention on the AIL or we
+		 * are stuck due to operations in progress. "Stuck" in this
+		 * case is defined as >90% of the items we tried to push
+		 * were stuck.
+		 *
+		 * Backoff a bit more to allow some I/O to complete before
+		 * continuing from where we were.
+		 */
+		tout += 10;
 	}
-
-	spin_unlock(&mp->m_ail_lock);
-	return lsn;
-}	/* xfs_trans_push_ail */
+out:
+	*last_lsn = last_pushed_lsn;
+	return tout;
+}	/* xfsaild_push */
 
 
 /*
@@ -247,7 +326,7 @@ xfs_trans_unlocked_item(
 	 * the call to xfs_log_move_tail() doesn't do anything if there's
 	 * not enough free space to wake people up so we're safe calling it.
 	 */
-	min_lip = xfs_ail_min(&mp->m_ail);
+	min_lip = xfs_ail_min(&mp->m_ail.xa_ail);
 
 	if (min_lip == lip)
 		xfs_log_move_tail(mp, 1);
@@ -279,7 +358,7 @@ xfs_trans_update_ail(
 	xfs_log_item_t		*dlip=NULL;
 	xfs_log_item_t		*mlip;	/* ptr to minimum lip */
 
-	ailp = &(mp->m_ail);
+	ailp = &(mp->m_ail.xa_ail);
 	mlip = xfs_ail_min(ailp);
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
@@ -292,10 +371,10 @@ xfs_trans_update_ail(
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
@@ -330,7 +409,7 @@ xfs_trans_delete_ail(
 	xfs_log_item_t		*mlip;
 
 	if (lip->li_flags & XFS_LI_IN_AIL) {
-		ailp = &(mp->m_ail);
+		ailp = &(mp->m_ail.xa_ail);
 		mlip = xfs_ail_min(ailp);
 		dlip = xfs_ail_delete(ailp, lip);
 		ASSERT(dlip == lip);
@@ -338,10 +417,10 @@ xfs_trans_delete_ail(
 
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
@@ -379,10 +458,10 @@ xfs_trans_first_ail(
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
@@ -402,11 +481,11 @@ xfs_trans_next_ail(
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
@@ -431,12 +510,20 @@ xfs_trans_next_ail(
 /*
  * Initialize the doubly linked list to point only to itself.
  */
-void
+int
 xfs_trans_ail_init(
 	xfs_mount_t	*mp)
 {
-	mp->m_ail.ail_forw = (xfs_log_item_t*)&(mp->m_ail);
-	mp->m_ail.ail_back = (xfs_log_item_t*)&(mp->m_ail);
+	mp->m_ail.xa_ail.ail_forw = (xfs_log_item_t*)&mp->m_ail.xa_ail;
+	mp->m_ail.xa_ail.ail_back = (xfs_log_item_t*)&mp->m_ail.xa_ail;
+	return xfsaild_start(mp);
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
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_trans_priv.h	2007-11-22 10:25:24.982355999 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_trans_priv.h	2007-11-22 10:34:01.568358178 +1100
@@ -57,4 +57,12 @@ struct xfs_log_item	*xfs_trans_next_ail(
 				     struct xfs_log_item *, int *, int *);
 
 
+/*
+ * AIL push thread support
+ */
+long	xfsaild_push(struct xfs_mount *, xfs_lsn_t *);
+void	xfsaild_wakeup(struct xfs_mount *, xfs_lsn_t);
+int	xfsaild_start(struct xfs_mount *);
+void	xfsaild_stop(struct xfs_mount *);
+
 #endif	/* __XFS_TRANS_PRIV_H__ */
Index: 2.6.x-xfs-new/fs/xfs/xfsidbg.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfsidbg.c	2007-11-22 10:33:54.001325501 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfsidbg.c	2007-11-22 10:34:01.572357667 +1100
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
