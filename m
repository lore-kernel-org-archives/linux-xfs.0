Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1MMDpRL001246 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 16:13:51 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 303562F452E
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 14:16:33 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	p1ImWigBnzOAtYF2 for <xfs@oss.sgi.com>;
	Tue, 22 Feb 2011 14:16:33 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/5] xfs: convert ENOSPC inode flushing to use new syncd
	workqueue
Date: Wed, 23 Feb 2011 09:16:07 +1100
Message-Id: <1298412969-14389-4-git-send-email-david@fromorbit.com>
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

On of the problems with the current inode flush at ENOSPC is that we
queue a flush per ENOSPC event, regardless of how many are already
queued. Thi can result in    hundreds of queued flushes, most of
which simply burn CPU scanned and do no real work. This simply slows
down allocation at ENOSPC.

We really only need one active flush at a time, and we can easily
implement that via the new xfs_syncd_wq. All we need to do is queue
a flush if one is not already active, then block waiting for the
currently active flush to complete. The result is that we only ever
have a single ENOSPC inode flush active at a time and this greatly
reduces the overhead of ENOSPC processing.

On my 2p test machine, this results in tests exercising ENOSPC
conditions running significantly faster - 042 halves execution time,
083 drops from 60s to 5s, etc - while not introducing test
regressions.

This allows us to remove the old xfssyncd threads and infrastructure
as they are no longer used.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    2 -
 fs/xfs/linux-2.6/xfs_sync.c  |  137 ++++++++++++-----------------------------
 fs/xfs/xfs_mount.h           |    4 +-
 3 files changed, 41 insertions(+), 102 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 73a17b1..47eb457 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1479,8 +1479,6 @@ xfs_fs_fill_super(
 	spin_lock_init(&mp->m_sb_lock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
-	INIT_LIST_HEAD(&mp->m_sync_list);
-	spin_lock_init(&mp->m_sync_lock);
 
 	mp->m_super = sb;
 	sb->s_fs_info = mp;
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 28afe11..d47dc45 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -434,99 +434,6 @@ xfs_quiesce_attr(
 	xfs_unmountfs_writesb(mp);
 }
 
-/*
- * Enqueue a work item to be picked up by the vfs xfssyncd thread.
- * Doing this has two advantages:
- * - It saves on stack space, which is tight in certain situations
- * - It can be used (with care) as a mechanism to avoid deadlocks.
- * Flushing while allocating in a full filesystem requires both.
- */
-STATIC void
-xfs_syncd_queue_work(
-	struct xfs_mount *mp,
-	void		*data,
-	void		(*syncer)(struct xfs_mount *, void *),
-	struct completion *completion)
-{
-	struct xfs_sync_work *work;
-
-	work = kmem_alloc(sizeof(struct xfs_sync_work), KM_SLEEP);
-	INIT_LIST_HEAD(&work->w_list);
-	work->w_syncer = syncer;
-	work->w_data = data;
-	work->w_mount = mp;
-	work->w_completion = completion;
-	spin_lock(&mp->m_sync_lock);
-	list_add_tail(&work->w_list, &mp->m_sync_list);
-	spin_unlock(&mp->m_sync_lock);
-	wake_up_process(mp->m_sync_task);
-}
-
-/*
- * Flush delayed allocate data, attempting to free up reserved space
- * from existing allocations.  At this point a new allocation attempt
- * has failed with ENOSPC and we are in the process of scratching our
- * heads, looking about for more room...
- */
-STATIC void
-xfs_flush_inodes_work(
-	struct xfs_mount *mp,
-	void		*arg)
-{
-	struct inode	*inode = arg;
-	xfs_sync_data(mp, SYNC_TRYLOCK);
-	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
-	iput(inode);
-}
-
-void
-xfs_flush_inodes(
-	xfs_inode_t	*ip)
-{
-	struct inode	*inode = VFS_I(ip);
-	DECLARE_COMPLETION_ONSTACK(completion);
-
-	igrab(inode);
-	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inodes_work, &completion);
-	wait_for_completion(&completion);
-	xfs_log_force(ip->i_mount, XFS_LOG_SYNC);
-}
-
-STATIC int
-xfssyncd(
-	void			*arg)
-{
-	struct xfs_mount	*mp = arg;
-	long			timeleft;
-	xfs_sync_work_t		*work, *n;
-	LIST_HEAD		(tmp);
-
-	set_freezable();
-	timeleft = xfs_syncd_centisecs * msecs_to_jiffies(10);
-	for (;;) {
-		if (list_empty(&mp->m_sync_list))
-			timeleft = schedule_timeout_interruptible(timeleft);
-		/* swsusp */
-		try_to_freeze();
-		if (kthread_should_stop() && list_empty(&mp->m_sync_list))
-			break;
-
-		spin_lock(&mp->m_sync_lock);
-		list_splice_init(&mp->m_sync_list, &tmp);
-		spin_unlock(&mp->m_sync_lock);
-
-		list_for_each_entry_safe(work, n, &tmp, w_list) {
-			(*work->w_syncer)(mp, work->w_data);
-			list_del(&work->w_list);
-			if (work->w_completion)
-				complete(work->w_completion);
-			kmem_free(work);
-		}
-	}
-
-	return 0;
-}
-
 void
 xfs_syncd_queue_sync(
 	struct xfs_mount        *mp,
@@ -570,16 +477,52 @@ xfs_sync_worker(
 	xfs_syncd_queue_sync(mp, 0);
 }
 
+/*
+ * Flush delayed allocate data, attempting to free up reserved space
+ * from existing allocations.  At this point a new allocation attempt
+ * has failed with ENOSPC and we are in the process of scratching our
+ * heads, looking about for more room.
+ *
+ * Queue a new data flush if there isn't one already in progress and
+ * wait for completion of the flush. This means that we only ever have one
+ * inode flush in progress no matter how many ENOSPC events are occurring and
+ * so will prevent the system from bogging down due to every concurrent
+ * ENOSPC event scanning all the active inodes in the system for writeback.
+ */
+void
+xfs_flush_inodes(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	mutex_lock(&xfs_syncd_lock);
+	if (!work_pending(&mp->m_flush_work))
+		queue_work(xfs_syncd_wq, &mp->m_flush_work);
+	mutex_unlock(&xfs_syncd_lock);
+
+	flush_work_sync(&mp->m_flush_work);
+}
+
+STATIC void
+xfs_flush_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(work,
+					struct xfs_mount, m_flush_work);
+
+	xfs_sync_data(mp, SYNC_TRYLOCK);
+	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
+	xfs_log_force(mp, XFS_LOG_SYNC);
+}
+
 int
 xfs_syncd_init(
 	struct xfs_mount	*mp)
 {
+	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
 	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
 	xfs_syncd_queue_sync(mp, 0);
 
-	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd/%s", mp->m_fsname);
-	if (IS_ERR(mp->m_sync_task))
-		return -PTR_ERR(mp->m_sync_task);
 	return 0;
 }
 
@@ -589,8 +532,8 @@ xfs_syncd_stop(
 {
 	mutex_lock(&xfs_syncd_lock);
 	cancel_delayed_work_sync(&mp->m_sync_work);
+	cancel_work_sync(&mp->m_flush_work);
 	mutex_unlock(&xfs_syncd_lock);
-	kthread_stop(mp->m_sync_task);
 }
 
 void
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 2c11e62..a0ad90e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -204,9 +204,7 @@ typedef struct xfs_mount {
 #endif
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_sync_work;	/* background sync work */
-	struct task_struct	*m_sync_task;	/* generalised sync thread */
-	struct list_head	m_sync_list;	/* sync thread work item list */
-	spinlock_t		m_sync_lock;	/* work item list lock */
+	struct work_struct	m_flush_work;	/* background inode flush */
 	__int64_t		m_update_flags;	/* sb flags we need to update
 						   on the next remount,rw */
 	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
