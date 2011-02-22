Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1MMDwiI001283 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 16:13:58 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9961B2F4548
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 14:16:41 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	o00GsgAwS5nTIBqL for <xfs@oss.sgi.com>;
	Tue, 22 Feb 2011 14:16:41 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfs: introduce a xfssyncd workqueue
Date: Wed, 23 Feb 2011 09:16:06 +1100
Message-Id: <1298412969-14389-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1298412969-14389-1-git-send-email-david@fromorbit.com>
References: <1298412969-14389-1-git-send-email-david@fromorbit.com>
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
Cc: chris.mason@oracle.com

From: Dave Chinner <dchinner@redhat.com>

All of the work xfssyncd does is background functionality. There is
no need for a thread per filesystem to do this work - it can al be
managed by a global workqueue now they manage concurrency
effectively.

Introduce a new gglobal xfssyncd workqueue, and convert the periodic
work to use this new functionality. To do this, use a delayed work
construct to schedule the next running of the periodic sync work
for the filesystem. When the sync work is complete, queue a new
delayed work for the next running of the sync work.

For laptop mode, we wait on completion for the sync works, so ensure
that the sync work queuing interface can flush and wait for work to
complete to enable the work queue infrastructure to replace the
current sequence number and wakeup that is used.

Because the sync work does non-trivial amounts of work, mark the
new work queue as CPU intensive.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   40 +++++++++---------
 fs/xfs/linux-2.6/xfs_sync.c  |   96 +++++++++++++++++++++++-------------------
 fs/xfs/linux-2.6/xfs_sync.h  |    3 +
 fs/xfs/xfs_mount.h           |    4 +-
 4 files changed, 76 insertions(+), 67 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index e010830..73a17b1 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1190,22 +1190,12 @@ xfs_fs_sync_fs(
 		return -error;
 
 	if (laptop_mode) {
-		int	prev_sync_seq = mp->m_sync_seq;
-
 		/*
 		 * The disk must be active because we're syncing.
 		 * We schedule xfssyncd now (now that the disk is
 		 * active) instead of later (when it might not be).
 		 */
-		wake_up_process(mp->m_sync_task);
-		/*
-		 * We have to wait for the sync iteration to complete.
-		 * If we don't, the disk activity caused by the sync
-		 * will come after the sync is completed, and that
-		 * triggers another sync from laptop mode.
-		 */
-		wait_event(mp->m_wait_single_sync_task,
-				mp->m_sync_seq != prev_sync_seq);
+		xfs_syncd_queue_sync(mp, SYNC_WAIT);
 	}
 
 	return 0;
@@ -1491,7 +1481,6 @@ xfs_fs_fill_super(
 	atomic_set(&mp->m_active_trans, 0);
 	INIT_LIST_HEAD(&mp->m_sync_list);
 	spin_lock_init(&mp->m_sync_lock);
-	init_waitqueue_head(&mp->m_wait_single_sync_task);
 
 	mp->m_super = sb;
 	sb->s_fs_info = mp;
@@ -1818,26 +1807,35 @@ init_xfs_fs(void)
 	if (error)
 		goto out_cleanup_procfs;
 
+	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_CPU_INTENSIVE, 8);
+	if (!xfs_syncd_wq) {
+		error = -ENOMEM;
+		goto out_sysctl_unregister;
+	}
+	mutex_init(&xfs_syncd_lock);
+
 	vfs_initquota();
 
 	error = register_filesystem(&xfs_fs_type);
 	if (error)
-		goto out_sysctl_unregister;
+		goto out_destroy_xfs_syncd;
 	return 0;
 
- out_sysctl_unregister:
+out_destroy_xfs_syncd:
+	destroy_workqueue(xfs_syncd_wq);
+out_sysctl_unregister:
 	xfs_sysctl_unregister();
- out_cleanup_procfs:
+out_cleanup_procfs:
 	xfs_cleanup_procfs();
- out_buf_terminate:
+out_buf_terminate:
 	xfs_buf_terminate();
- out_filestream_uninit:
+out_filestream_uninit:
 	xfs_filestream_uninit();
- out_mru_cache_uninit:
+out_mru_cache_uninit:
 	xfs_mru_cache_uninit();
- out_destroy_zones:
+out_destroy_zones:
 	xfs_destroy_zones();
- out:
+out:
 	return error;
 }
 
@@ -1846,6 +1844,8 @@ exit_xfs_fs(void)
 {
 	vfs_exitquota();
 	unregister_filesystem(&xfs_fs_type);
+	destroy_workqueue(xfs_syncd_wq);
+	mutex_destroy(&xfs_syncd_lock);
 	xfs_sysctl_unregister();
 	xfs_cleanup_procfs();
 	xfs_buf_terminate();
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 594cd82..28afe11 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -39,6 +39,9 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 
+struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
+struct mutex		xfs_syncd_lock;	/* lock for workqueue */
+
 /*
  * The inode lookup is done in batches to keep the amount of lock traffic and
  * radix tree lookups to a minimum. The batch size is a trade off between
@@ -489,32 +492,6 @@ xfs_flush_inodes(
 	xfs_log_force(ip->i_mount, XFS_LOG_SYNC);
 }
 
-/*
- * Every sync period we need to unpin all items, reclaim inodes and sync
- * disk quotas.  We might need to cover the log to indicate that the
- * filesystem is idle and not frozen.
- */
-STATIC void
-xfs_sync_worker(
-	struct xfs_mount *mp,
-	void		*unused)
-{
-	int		error;
-
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		/* dgc: errors ignored here */
-		if (mp->m_super->s_frozen == SB_UNFROZEN &&
-		    xfs_log_need_covered(mp))
-			error = xfs_fs_log_dummy(mp);
-		else
-			xfs_log_force(mp, 0);
-		xfs_reclaim_inodes(mp, 0);
-		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
-	}
-	mp->m_sync_seq++;
-	wake_up(&mp->m_wait_single_sync_task);
-}
-
 STATIC int
 xfssyncd(
 	void			*arg)
@@ -535,27 +512,12 @@ xfssyncd(
 			break;
 
 		spin_lock(&mp->m_sync_lock);
-		/*
-		 * We can get woken by laptop mode, to do a sync -
-		 * that's the (only!) case where the list would be
-		 * empty with time remaining.
-		 */
-		if (!timeleft || list_empty(&mp->m_sync_list)) {
-			if (!timeleft)
-				timeleft = xfs_syncd_centisecs *
-							msecs_to_jiffies(10);
-			INIT_LIST_HEAD(&mp->m_sync_work.w_list);
-			list_add_tail(&mp->m_sync_work.w_list,
-					&mp->m_sync_list);
-		}
 		list_splice_init(&mp->m_sync_list, &tmp);
 		spin_unlock(&mp->m_sync_lock);
 
 		list_for_each_entry_safe(work, n, &tmp, w_list) {
 			(*work->w_syncer)(mp, work->w_data);
 			list_del(&work->w_list);
-			if (work == &mp->m_sync_work)
-				continue;
 			if (work->w_completion)
 				complete(work->w_completion);
 			kmem_free(work);
@@ -565,13 +527,56 @@ xfssyncd(
 	return 0;
 }
 
+void
+xfs_syncd_queue_sync(
+	struct xfs_mount        *mp,
+	int			flags)
+{
+	mutex_lock(&xfs_syncd_lock);
+	if (!delayed_work_pending(&mp->m_sync_work))
+		queue_delayed_work(xfs_syncd_wq, &mp->m_sync_work,
+				xfs_syncd_centisecs * msecs_to_jiffies(10));
+	mutex_unlock(&xfs_syncd_lock);
+
+	if (flags & SYNC_WAIT)
+		flush_delayed_work_sync(&mp->m_sync_work);
+}
+
+/*
+ * Every sync period we need to unpin all items, reclaim inodes and sync
+ * disk quotas.  We might need to cover the log to indicate that the
+ * filesystem is idle and not frozen.
+ */
+STATIC void
+xfs_sync_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_sync_work);
+	int		error;
+
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		/* dgc: errors ignored here */
+		if (mp->m_super->s_frozen == SB_UNFROZEN &&
+		    xfs_log_need_covered(mp))
+			error = xfs_fs_log_dummy(mp);
+		else
+			xfs_log_force(mp, 0);
+		xfs_reclaim_inodes(mp, 0);
+		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
+	}
+
+	/* queue us up again */
+	xfs_syncd_queue_sync(mp, 0);
+}
+
 int
 xfs_syncd_init(
 	struct xfs_mount	*mp)
 {
-	mp->m_sync_work.w_syncer = xfs_sync_worker;
-	mp->m_sync_work.w_mount = mp;
-	mp->m_sync_work.w_completion = NULL;
+	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
+	xfs_syncd_queue_sync(mp, 0);
+
 	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd/%s", mp->m_fsname);
 	if (IS_ERR(mp->m_sync_task))
 		return -PTR_ERR(mp->m_sync_task);
@@ -582,6 +587,9 @@ void
 xfs_syncd_stop(
 	struct xfs_mount	*mp)
 {
+	mutex_lock(&xfs_syncd_lock);
+	cancel_delayed_work_sync(&mp->m_sync_work);
+	mutex_unlock(&xfs_syncd_lock);
 	kthread_stop(mp->m_sync_task);
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 0ae48ff..1cd2fec 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -32,6 +32,9 @@ typedef struct xfs_sync_work {
 #define SYNC_WAIT		0x0001	/* wait for i/o to complete */
 #define SYNC_TRYLOCK		0x0002  /* only try to lock inodes */
 
+extern struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
+extern struct mutex		xfs_syncd_lock;	/* lock for workqueue */
+
 int xfs_syncd_init(struct xfs_mount *mp);
 void xfs_syncd_stop(struct xfs_mount *mp);
 void xfs_syncd_queue_sync(struct xfs_mount *mp, int flags);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a62e897..2c11e62 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -203,12 +203,10 @@ typedef struct xfs_mount {
 	struct mutex		m_icsb_mutex;	/* balancer sync lock */
 #endif
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
+	struct delayed_work	m_sync_work;	/* background sync work */
 	struct task_struct	*m_sync_task;	/* generalised sync thread */
-	xfs_sync_work_t		m_sync_work;	/* work item for VFS_SYNC */
 	struct list_head	m_sync_list;	/* sync thread work item list */
 	spinlock_t		m_sync_lock;	/* work item list lock */
-	int			m_sync_seq;	/* sync thread generation no. */
-	wait_queue_head_t	m_wait_single_sync_task;
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
