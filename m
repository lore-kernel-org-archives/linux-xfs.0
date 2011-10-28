Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3hJW145530 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4688203868
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	cSP4wJDtckGvdDB7 for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:42 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHq-0003A1-9W
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:42 +0000
Message-Id: <20111028100342.243803750@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:55:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 37/45] xfs: implement freezing by emptying the AIL
References: <20111028095423.796574703@bombadil.infradead.org>
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

As an upside we can now remove the radix tree based inode writeback
completely.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_sync.c       |   90 ++++--------------------------------------------
 fs/xfs/xfs_trans_ail.c  |   50 ++++++++++++++++++++++----
 fs/xfs/xfs_trans_priv.h |    3 +
 3 files changed, 54 insertions(+), 89 deletions(-)

Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2011-10-27 22:40:10.705172023 +0200
+++ xfs/fs/xfs/xfs_sync.c	2011-10-27 22:40:12.489171652 +0200
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
--- xfs.orig/fs/xfs/xfs_trans_ail.c	2011-10-27 22:39:32.544671415 +0200
+++ xfs/fs/xfs/xfs_trans_ail.c	2011-10-27 22:40:12.489171652 +0200
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
+		prepare_to_wait(&ailp->xa_empty, &wait, TASK_UNINTERRUPTIBLE);
+
+		wake_up_process(ailp->xa_task);
+
+		if (!xfs_ail_min_lsn(ailp))
+			break;
+		schedule();
+	} while (xfs_ail_min_lsn(ailp));
+	atomic_dec(&ailp->xa_wait_empty);
+
+	finish_wait(&ailp->xa_empty, &wait);
+}
+
+/*
  * This is to be called when an item is unlocked that may have
  * been in the AIL.  It will wake up the first member of the AIL
  * wait list if this item's unlocking might allow it to progress.
@@ -802,6 +833,9 @@ xfs_trans_ail_delete_bulk(
 	tail_lsn = mlip ? mlip->li_lsn : 0;
 	spin_unlock(&ailp->xa_lock);
 	xfs_log_move_tail(ailp->xa_mount, tail_lsn);
+
+	if (!mlip)
+		wake_up_all(&ailp->xa_empty);
 }
 
 /*
@@ -832,6 +866,8 @@ xfs_trans_ail_init(
 	INIT_LIST_HEAD(&ailp->xa_ail);
 	INIT_LIST_HEAD(&ailp->xa_cursors);
 	spin_lock_init(&ailp->xa_lock);
+	init_waitqueue_head(&ailp->xa_empty);
+	atomic_set(&ailp->xa_wait_empty, 0);
 
 	ailp->xa_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
 			ailp->xa_mount->m_fsname);
Index: xfs/fs/xfs/xfs_trans_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_priv.h	2011-10-27 22:39:32.560674824 +0200
+++ xfs/fs/xfs/xfs_trans_priv.h	2011-10-27 22:40:12.489171652 +0200
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
 xfs_lsn_t		xfs_ail_min_lsn(struct xfs_ail *ailp);
 
 void			xfs_trans_unlocked_item(struct xfs_ail *,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
