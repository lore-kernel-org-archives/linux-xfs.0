Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2GHucjT122763 for <xfs@oss.sgi.com>; Fri, 16 Mar 2012 12:56:39 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	uO7UKd1qZfKNu4WK (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 16 Mar 2012 10:56:37 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1S8bOG-0001Gk-JL
	for xfs@oss.sgi.com; Fri, 16 Mar 2012 17:56:36 +0000
Message-Id: <20120316175636.554421689@bombadil.infradead.org>
Date: Fri, 16 Mar 2012 13:55:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] xfs: implement freezing by emptying the AIL
References: <20120316175541.258282540@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-empty-ail-on-freeze
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

Now that we write back all metadata either synchronously or through the AIL
we can simply implement metadata freezing in terms of emptying the AIL.

The implementation for this is fairly simply and straight-forward:  A new
routine is added that increments a counter that tells xfsaild to not stop
until the AIL is empty and then waits on a wakeup from
xfs_trans_ail_delete_bulk to signal that the AIL is empty.

As usual the devil is in the details, in this case the filesystem shutdown
code.  Currently we are a bit sloppy there and do not continue ail pushing
in that case, and thus never reach the code in the log item implementations
that can unwind in case of a shutdown filesystem.  Also the code to 
abort inode and dquot flushes was rather sloppy before and did not remove
the log items from the AIL, which had to be fixed as well.

Also treat unmount the same way as freeze now, except that we still keep a
synchronous inode reclaim pass to make sure we reclaim all clean inodes, too.

As an upside we can now remove the radix tree based inode writeback and
xfs_unmountfs_writesb.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_mount.c      |   56 ++++++-----------------------
 fs/xfs/xfs_mount.h      |    1 
 fs/xfs/xfs_sync.c       |   90 ++++--------------------------------------------
 fs/xfs/xfs_trans_ail.c  |   49 ++++++++++++++++++++++----
 fs/xfs/xfs_trans_priv.h |    3 +
 5 files changed, 65 insertions(+), 134 deletions(-)

Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2012-03-16 13:11:45.250393760 +0100
+++ xfs/fs/xfs/xfs_sync.c	2012-03-16 13:12:45.707061547 +0100
@@ -241,45 +241,6 @@ xfs_sync_inode_data(
 	return error;
 }
 
-STATIC int
-xfs_sync_inode_attr(
-	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
-	int			flags)
-{
-	int			error = 0;
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_inode_clean(ip))
-		goto out_unlock;
-	if (!xfs_iflock_nowait(ip)) {
-		if (!(flags & SYNC_WAIT))
-			goto out_unlock;
-		xfs_iflock(ip);
-	}
-
-	if (xfs_inode_clean(ip)) {
-		xfs_ifunlock(ip);
-		goto out_unlock;
-	}
-
-	error = xfs_iflush(ip, flags);
-
-	/*
-	 * We don't want to try again on non-blocking flushes that can't run
-	 * again immediately. If an inode really must be written, then that's
-	 * what the SYNC_WAIT flag is for.
-	 */
-	if (error == EAGAIN) {
-		ASSERT(!(flags & SYNC_WAIT));
-		error = 0;
-	}
-
- out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return error;
-}
-
 /*
  * Write out pagecache data for the whole filesystem.
  */
@@ -300,19 +261,6 @@ xfs_sync_data(
 	return 0;
 }
 
-/*
- * Write out inode metadata (attributes) for the whole filesystem.
- */
-STATIC int
-xfs_sync_attr(
-	struct xfs_mount	*mp,
-	int			flags)
-{
-	ASSERT((flags & ~SYNC_WAIT) == 0);
-
-	return xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags);
-}
-
 STATIC int
 xfs_sync_fsdata(
 	struct xfs_mount	*mp)
@@ -379,33 +327,6 @@ xfs_quiesce_data(
 	return error ? error : error2;
 }
 
-STATIC void
-xfs_quiesce_fs(
-	struct xfs_mount	*mp)
-{
-	int	count = 0, pincount;
-
-	xfs_reclaim_inodes(mp, 0);
-	xfs_flush_buftarg(mp->m_ddev_targp, 0);
-
-	/*
-	 * This loop must run at least twice.  The first instance of the loop
-	 * will flush most meta data but that will generate more meta data
-	 * (typically directory updates).  Which then must be flushed and
-	 * logged before we can write the unmount record. We also so sync
-	 * reclaim of inodes to catch any that the above delwri flush skipped.
-	 */
-	do {
-		xfs_reclaim_inodes(mp, SYNC_WAIT);
-		xfs_sync_attr(mp, SYNC_WAIT);
-		pincount = xfs_flush_buftarg(mp->m_ddev_targp, 1);
-		if (!pincount) {
-			delay(50);
-			count++;
-		}
-	} while (count < 2);
-}
-
 /*
  * Second stage of a quiesce. The data is already synced, now we have to take
  * care of the metadata. New transactions are already blocked, so we need to
@@ -421,8 +342,8 @@ xfs_quiesce_attr(
 	while (atomic_read(&mp->m_active_trans) > 0)
 		delay(100);
 
-	/* flush inodes and push all remaining buffers out to disk */
-	xfs_quiesce_fs(mp);
+	/* flush all pending changes from the AIL */
+	xfs_ail_push_all_sync(mp->m_ail);
 
 	/*
 	 * Just warn here till VFS can correctly support
@@ -436,7 +357,12 @@ xfs_quiesce_attr(
 		xfs_warn(mp, "xfs_attr_quiesce: failed to log sb changes. "
 				"Frozen image may not be consistent.");
 	xfs_log_unmount_write(mp);
-	xfs_unmountfs_writesb(mp);
+
+	/*
+	 * At this point we might have modified the superblock again and thus
+	 * added an item to the AIL, thus flush it again.
+	 */
+	xfs_ail_push_all_sync(mp->m_ail);
 }
 
 static void
Index: xfs/fs/xfs/xfs_trans_ail.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2012-03-16 13:11:45.880393771 +0100
+++ xfs/fs/xfs/xfs_trans_ail.c	2012-03-16 13:13:37.923729183 +0100
@@ -383,9 +383,8 @@ xfsaild_push(
 		spin_lock(&ailp->xa_lock);
 	}
 
-	target = ailp->xa_target;
 	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->xa_last_pushed_lsn);
-	if (!lip || XFS_FORCED_SHUTDOWN(mp)) {
+	if (!lip) {
 		/*
 		 * AIL is empty or our push has reached the end.
 		 */
@@ -397,6 +396,15 @@ xfsaild_push(
 	XFS_STATS_INC(xs_push_ail);
 
 	/*
+	 * If we are draining the AIL push all items, not just the current
+	 * threshold.
+	 */
+	if (atomic_read(&ailp->xa_wait_empty))
+		target = xfs_ail_max(ailp)->li_lsn;
+	else
+		target = ailp->xa_target;
+
+	/*
 	 * While the item we are looking at is below the given threshold
 	 * try to flush it out. We'd like not to stop until we've at least
 	 * tried to push on everything in the AIL with an LSN less than
@@ -466,11 +474,6 @@ xfsaild_push(
 		}
 
 		spin_lock(&ailp->xa_lock);
-		/* should we bother continuing? */
-		if (XFS_FORCED_SHUTDOWN(mp))
-			break;
-		ASSERT(mp->m_log);
-
 		count++;
 
 		/*
@@ -611,6 +614,34 @@ xfs_ail_push_all(
 }
 
 /*
+ * Push out all items in the AIL immediately and wait until the AIL is empty.
+ */
+void
+xfs_ail_push_all_sync(
+	struct xfs_ail  *ailp)
+{
+	DEFINE_WAIT(wait);
+
+	/*
+	 * We use a counter instead of a flag here to support multiple
+	 * processes calling into sync at the same time.
+	 */
+	atomic_inc(&ailp->xa_wait_empty);
+	do {
+		prepare_to_wait(&ailp->xa_empty, &wait, TASK_KILLABLE);
+
+		wake_up_process(ailp->xa_task);
+
+		if (!xfs_ail_min_lsn(ailp))
+			break;
+		schedule();
+	} while (xfs_ail_min_lsn(ailp) && !fatal_signal_pending(current));
+	atomic_dec(&ailp->xa_wait_empty);
+
+	finish_wait(&ailp->xa_empty, &wait);
+}
+
+/*
  * xfs_trans_ail_update - bulk AIL insertion operation.
  *
  * @xfs_trans_ail_update takes an array of log items that all need to be
@@ -737,6 +768,8 @@ xfs_trans_ail_delete_bulk(
 	if (mlip_changed) {
 		if (!XFS_FORCED_SHUTDOWN(ailp->xa_mount))
 			xlog_assign_tail_lsn_locked(ailp->xa_mount);
+		if (list_empty(&ailp->xa_ail))
+			wake_up_all(&ailp->xa_empty);
 		spin_unlock(&ailp->xa_lock);
 
 		xfs_log_space_wake(ailp->xa_mount);
@@ -773,6 +806,8 @@ xfs_trans_ail_init(
 	INIT_LIST_HEAD(&ailp->xa_ail);
 	INIT_LIST_HEAD(&ailp->xa_cursors);
 	spin_lock_init(&ailp->xa_lock);
+	init_waitqueue_head(&ailp->xa_empty);
+	atomic_set(&ailp->xa_wait_empty, 0);
 
 	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
 			ailp->xa_mount->m_fsname);
Index: xfs/fs/xfs/xfs_trans_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_priv.h	2012-03-16 13:11:45.880393771 +0100
+++ xfs/fs/xfs/xfs_trans_priv.h	2012-03-16 13:12:45.707061547 +0100
@@ -71,6 +71,8 @@ struct xfs_ail {
 	spinlock_t		xa_lock;
 	xfs_lsn_t		xa_last_pushed_lsn;
 	int			xa_log_flush;
+	wait_queue_head_t	xa_empty;
+	atomic_t		xa_wait_empty;
 };
 
 /*
@@ -102,6 +104,7 @@ xfs_trans_ail_delete(
 
 void			xfs_ail_push(struct xfs_ail *, xfs_lsn_t);
 void			xfs_ail_push_all(struct xfs_ail *);
+void			xfs_ail_push_all_sync(struct xfs_ail *);
 struct xfs_log_item	*xfs_ail_min(struct xfs_ail  *ailp);
 xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
 
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2012-03-16 13:10:40.357059223 +0100
+++ xfs/fs/xfs/xfs_mount.c	2012-03-16 13:12:45.710394881 +0100
@@ -22,6 +22,7 @@
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
@@ -1475,15 +1476,15 @@ xfs_unmountfs(
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
 	/*
-	 * Do a delwri reclaim pass first so that as many dirty inodes are
-	 * queued up for IO as possible. Then flush the buffers before making
-	 * a synchronous path to catch all the remaining inodes are reclaimed.
-	 * This makes the reclaim process as quick as possible by avoiding
-	 * synchronous writeout and blocking on inodes already in the delwri
-	 * state as much as possible.
+	 * Flush all pending changes from the AIL.
+	 */
+	xfs_ail_push_all_sync(mp->m_ail);
+
+	/*
+	 * And reclaim all inodes.  At this point there should be no dirty
+	 * inode, and none should be pinned or locked, but use synchronous
+	 * reclaim just to be sure.
 	 */
-	xfs_reclaim_inodes(mp, 0);
-	xfs_flush_buftarg(mp->m_ddev_targp, 1);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
 
 	xfs_qm_unmount(mp);
@@ -1519,15 +1520,12 @@ xfs_unmountfs(
 	if (error)
 		xfs_warn(mp, "Unable to update superblock counters. "
 				"Freespace may not be correct on next mount.");
-	xfs_unmountfs_writesb(mp);
 
 	/*
-	 * Make sure all buffers have been flushed and completed before
-	 * unmounting the log.
+	 * At this point we might have modified the superblock again and thus
+	 * added an item to the AIL, thus flush it again.
 	 */
-	error = xfs_flush_buftarg(mp->m_ddev_targp, 1);
-	if (error)
-		xfs_warn(mp, "%d busy buffers during unmount.", error);
+	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_wait_buftarg(mp->m_ddev_targp);
 
 	xfs_log_unmount_write(mp);
@@ -1588,36 +1586,6 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	return error;
 }
 
-int
-xfs_unmountfs_writesb(xfs_mount_t *mp)
-{
-	xfs_buf_t	*sbp;
-	int		error = 0;
-
-	/*
-	 * skip superblock write if fs is read-only, or
-	 * if we are doing a forced umount.
-	 */
-	if (!((mp->m_flags & XFS_MOUNT_RDONLY) ||
-		XFS_FORCED_SHUTDOWN(mp))) {
-
-		sbp = xfs_getsb(mp, 0);
-
-		XFS_BUF_UNDONE(sbp);
-		XFS_BUF_UNREAD(sbp);
-		xfs_buf_delwri_dequeue(sbp);
-		XFS_BUF_WRITE(sbp);
-		XFS_BUF_UNASYNC(sbp);
-		ASSERT(sbp->b_target == mp->m_ddev_targp);
-		xfsbdstrat(mp, sbp);
-		error = xfs_buf_iowait(sbp);
-		if (error)
-			xfs_buf_ioerror_alert(sbp, __func__);
-		xfs_buf_relse(sbp);
-	}
-	return error;
-}
-
 /*
  * xfs_mod_sb() can be used to copy arbitrary changes to the
  * in-core superblock into the superblock buffer to be logged.
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2012-03-16 13:10:40.373725891 +0100
+++ xfs/fs/xfs/xfs_mount.h	2012-03-16 13:12:45.710394881 +0100
@@ -378,7 +378,6 @@ extern __uint64_t xfs_default_resblks(xf
 extern int	xfs_mountfs(xfs_mount_t *mp);
 
 extern void	xfs_unmountfs(xfs_mount_t *);
-extern int	xfs_unmountfs_writesb(xfs_mount_t *);
 extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
 extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
 			uint, int);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
