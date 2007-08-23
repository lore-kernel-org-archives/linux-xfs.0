Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:40:21 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJeF4p005507
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:40:18 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJeEA5008777
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:40:14 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJeEaM008775
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:40:14 +0200
Date: Thu, 23 Aug 2007 21:40:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/17] move syncing related members from struct bhv_vfs to struct xfs_mount
Message-ID: <20070823194014.GQ8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-08-13 18:08:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-08-13 18:08:10.000000000 +0200
@@ -455,9 +455,9 @@ xfs_fs_clear_inode(
  */
 STATIC void
 xfs_syncd_queue_work(
-	struct bhv_vfs	*vfs,
+	struct xfs_mount *mp,
 	void		*data,
-	void		(*syncer)(bhv_vfs_t *, void *))
+	void		(*syncer)(struct xfs_mount *, void *))
 {
 	struct bhv_vfs_sync_work *work;
 
@@ -465,11 +465,11 @@ xfs_syncd_queue_work(
 	INIT_LIST_HEAD(&work->w_list);
 	work->w_syncer = syncer;
 	work->w_data = data;
-	work->w_vfs = vfs;
-	spin_lock(&vfs->vfs_sync_lock);
-	list_add_tail(&work->w_list, &vfs->vfs_sync_list);
-	spin_unlock(&vfs->vfs_sync_lock);
-	wake_up_process(vfs->vfs_sync_task);
+	work->w_mount = mp;
+	spin_lock(&mp->m_sync_lock);
+	list_add_tail(&work->w_list, &mp->m_sync_list);
+	spin_unlock(&mp->m_sync_lock);
+	wake_up_process(mp->m_sync_task);
 }
 
 /*
@@ -480,22 +480,22 @@ xfs_syncd_queue_work(
  */
 STATIC void
 xfs_flush_inode_work(
-	bhv_vfs_t	*vfs,
-	void		*inode)
+	struct xfs_mount *mp,
+	void		*arg)
 {
-	filemap_flush(((struct inode *)inode)->i_mapping);
-	iput((struct inode *)inode);
+	struct inode	*inode = arg;
+	filemap_flush(inode->i_mapping);
+	iput(inode);
 }
 
 void
 xfs_flush_inode(
 	xfs_inode_t	*ip)
 {
-	struct inode	*inode = vn_to_inode(XFS_ITOV(ip));
-	struct bhv_vfs	*vfs = XFS_MTOVFS(ip->i_mount);
+	struct inode	*inode = ip->i_vnode;
 
 	igrab(inode);
-	xfs_syncd_queue_work(vfs, inode, xfs_flush_inode_work);
+	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inode_work);
 	delay(msecs_to_jiffies(500));
 }
 
@@ -505,11 +505,12 @@ xfs_flush_inode(
  */
 STATIC void
 xfs_flush_device_work(
-	bhv_vfs_t	*vfs,
-	void		*inode)
+	struct xfs_mount *mp,
+	void		*arg)
 {
-	sync_blockdev(vfs->vfs_super->s_bdev);
-	iput((struct inode *)inode);
+	struct inode	*inode = arg;
+	sync_blockdev(mp->m_vfsp->vfs_super->s_bdev);
+	iput(inode);
 }
 
 void
@@ -517,34 +518,33 @@ xfs_flush_device(
 	xfs_inode_t	*ip)
 {
 	struct inode	*inode = vn_to_inode(XFS_ITOV(ip));
-	struct bhv_vfs	*vfs = XFS_MTOVFS(ip->i_mount);
 
 	igrab(inode);
-	xfs_syncd_queue_work(vfs, inode, xfs_flush_device_work);
+	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_device_work);
 	delay(msecs_to_jiffies(500));
 	xfs_log_force(ip->i_mount, (xfs_lsn_t)0, XFS_LOG_FORCE|XFS_LOG_SYNC);
 }
 
 STATIC void
-vfs_sync_worker(
-	bhv_vfs_t	*vfsp,
+xfs_sync_worker(
+	struct xfs_mount *mp,
 	void		*unused)
 {
 	int		error;
 
-	if (!(XFS_VFSTOM(vfsp)->m_flags & XFS_MOUNT_RDONLY))
-		error = xfs_sync(XFS_VFSTOM(vfsp), SYNC_FSDATA | SYNC_BDFLUSH | \
-					SYNC_ATTR | SYNC_REFCACHE | SYNC_SUPER);
-	vfsp->vfs_sync_seq++;
-	wake_up(&vfsp->vfs_wait_single_sync_task);
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY))
+		error = xfs_sync(mp, SYNC_FSDATA | SYNC_BDFLUSH | SYNC_ATTR |
+				     SYNC_REFCACHE | SYNC_SUPER);
+	mp->m_sync_seq++;
+	wake_up(&mp->m_wait_single_sync_task);
 }
 
 STATIC int
 xfssyncd(
 	void			*arg)
 {
+	struct xfs_mount	*mp = arg;
 	long			timeleft;
-	bhv_vfs_t		*vfsp = (bhv_vfs_t *) arg;
 	bhv_vfs_sync_work_t	*work, *n;
 	LIST_HEAD		(tmp);
 
@@ -553,31 +553,31 @@ xfssyncd(
 		timeleft = schedule_timeout_interruptible(timeleft);
 		/* swsusp */
 		try_to_freeze();
-		if (kthread_should_stop() && list_empty(&vfsp->vfs_sync_list))
+		if (kthread_should_stop() && list_empty(&mp->m_sync_list))
 			break;
 
-		spin_lock(&vfsp->vfs_sync_lock);
+		spin_lock(&mp->m_sync_lock);
 		/*
 		 * We can get woken by laptop mode, to do a sync -
 		 * that's the (only!) case where the list would be
 		 * empty with time remaining.
 		 */
-		if (!timeleft || list_empty(&vfsp->vfs_sync_list)) {
+		if (!timeleft || list_empty(&mp->m_sync_list)) {
 			if (!timeleft)
 				timeleft = xfs_syncd_centisecs *
 							msecs_to_jiffies(10);
-			INIT_LIST_HEAD(&vfsp->vfs_sync_work.w_list);
-			list_add_tail(&vfsp->vfs_sync_work.w_list,
-					&vfsp->vfs_sync_list);
+			INIT_LIST_HEAD(&mp->m_sync_work.w_list);
+			list_add_tail(&mp->m_sync_work.w_list,
+					&mp->m_sync_list);
 		}
-		list_for_each_entry_safe(work, n, &vfsp->vfs_sync_list, w_list)
+		list_for_each_entry_safe(work, n, &mp->m_sync_list, w_list)
 			list_move(&work->w_list, &tmp);
-		spin_unlock(&vfsp->vfs_sync_lock);
+		spin_unlock(&mp->m_sync_lock);
 
 		list_for_each_entry_safe(work, n, &tmp, w_list) {
-			(*work->w_syncer)(vfsp, work->w_data);
+			(*work->w_syncer)(mp, work->w_data);
 			list_del(&work->w_list);
-			if (work == &vfsp->vfs_sync_work)
+			if (work == &mp->m_sync_work)
 				continue;
 			kmem_free(work, sizeof(struct bhv_vfs_sync_work));
 		}
@@ -586,25 +586,6 @@ xfssyncd(
 	return 0;
 }
 
-STATIC int
-xfs_fs_start_syncd(
-	bhv_vfs_t		*vfsp)
-{
-	vfsp->vfs_sync_work.w_syncer = vfs_sync_worker;
-	vfsp->vfs_sync_work.w_vfs = vfsp;
-	vfsp->vfs_sync_task = kthread_run(xfssyncd, vfsp, "xfssyncd");
-	if (IS_ERR(vfsp->vfs_sync_task))
-		return -PTR_ERR(vfsp->vfs_sync_task);
-	return 0;
-}
-
-STATIC void
-xfs_fs_stop_syncd(
-	bhv_vfs_t		*vfsp)
-{
-	kthread_stop(vfsp->vfs_sync_task);
-}
-
 STATIC void
 xfs_fs_put_super(
 	struct super_block	*sb)
@@ -613,7 +594,8 @@ xfs_fs_put_super(
 	struct xfs_mount	*mp = XFS_M(sb);
 	int			error;
 
-	xfs_fs_stop_syncd(vfsp);
+	kthread_stop(mp->m_sync_task);
+
 	xfs_sync(mp, SYNC_ATTR | SYNC_DELWRI);
 	error = xfs_unmount(mp, 0, NULL);
 	if (error) {
@@ -638,7 +620,6 @@ xfs_fs_sync_super(
 	struct super_block	*sb,
 	int			wait)
 {
-	bhv_vfs_t		*vfsp = vfs_from_sb(sb);
 	struct xfs_mount	*mp = XFS_M(sb);
 	int			error;
 	int			flags;
@@ -660,22 +641,22 @@ xfs_fs_sync_super(
 	sb->s_dirt = 0;
 
 	if (unlikely(laptop_mode)) {
-		int	prev_sync_seq = vfsp->vfs_sync_seq;
+		int	prev_sync_seq = mp->m_sync_seq;
 
 		/*
 		 * The disk must be active because we're syncing.
 		 * We schedule xfssyncd now (now that the disk is
 		 * active) instead of later (when it might not be).
 		 */
-		wake_up_process(vfsp->vfs_sync_task);
+		wake_up_process(mp->m_sync_task);
 		/*
 		 * We have to wait for the sync iteration to complete.
 		 * If we don't, the disk activity caused by the sync
 		 * will come after the sync is completed, and that
 		 * triggers another sync from laptop mode.
 		 */
-		wait_event(vfsp->vfs_wait_single_sync_task,
-				vfsp->vfs_sync_seq != prev_sync_seq);
+		wait_event(mp->m_wait_single_sync_task,
+				mp->m_sync_seq != prev_sync_seq);
 	}
 
 	return -error;
@@ -787,6 +768,11 @@ xfs_fs_fill_super(
 	int			error;
 
 	mp = xfs_mount_init();
+
+	INIT_LIST_HEAD(&mp->m_sync_list);
+	spin_lock_init(&mp->m_sync_lock);
+	init_waitqueue_head(&mp->m_wait_single_sync_task);
+
 	mp->m_vfsp = vfsp;
 	vfsp->vfs_mount = mp;
 
@@ -831,8 +817,15 @@ xfs_fs_fill_super(
 		error = EINVAL;
 		goto fail_vnrele;
 	}
-	if ((error = xfs_fs_start_syncd(vfsp)))
+
+	mp->m_sync_work.w_syncer = xfs_sync_worker;
+	mp->m_sync_work.w_mount = mp;
+	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd");
+	if (IS_ERR(mp->m_sync_task)) {
+		error = -PTR_ERR(mp->m_sync_task);
 		goto fail_vnrele;
+	}
+
 	vn_trace_exit(XFS_I(sb->s_root->d_inode), __FUNCTION__,
 			(inst_t *)__return_address);
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-13 18:08:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-13 18:08:10.000000000 +0200
@@ -37,9 +37,6 @@ vfs_allocate(
 	struct bhv_vfs		*vfsp;
 
 	vfsp = kmem_zalloc(sizeof(bhv_vfs_t), KM_SLEEP);
-	INIT_LIST_HEAD(&vfsp->vfs_sync_list);
-	spin_lock_init(&vfsp->vfs_sync_lock);
-	init_waitqueue_head(&vfsp->vfs_wait_single_sync_task);
 
 	vfsp->vfs_super = sb;
 	sb->s_fs_info = vfsp;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-13 18:08:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-13 18:08:10.000000000 +0200
@@ -36,20 +36,14 @@ typedef struct kstatfs	bhv_statvfs_t;
 
 typedef struct bhv_vfs_sync_work {
 	struct list_head	w_list;
-	struct bhv_vfs		*w_vfs;
+	struct xfs_mount	*w_mount;
 	void			*w_data;	/* syncer routine argument */
-	void			(*w_syncer)(struct bhv_vfs *, void *);
+	void			(*w_syncer)(struct xfs_mount *, void *);
 } bhv_vfs_sync_work_t;
 
 typedef struct bhv_vfs {
 	struct xfs_mount	*vfs_mount;
 	struct super_block	*vfs_super;	/* generic superblock pointer */
-	struct task_struct	*vfs_sync_task;	/* generalised sync thread */
-	bhv_vfs_sync_work_t	vfs_sync_work;	/* work item for VFS_SYNC */
-	struct list_head	vfs_sync_list;	/* sync thread work item list */
-	spinlock_t		vfs_sync_lock;	/* work item list lock */
-	int			vfs_sync_seq;	/* sync thread generation no. */
-	wait_queue_head_t	vfs_wait_single_sync_task;
 } bhv_vfs_t;
 
 #define SYNC_ATTR		0x0001	/* sync attributes */
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-08-13 18:08:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-08-13 18:08:10.000000000 +0200
@@ -433,6 +433,12 @@ typedef struct xfs_mount {
 	struct mutex		m_icsb_mutex;	/* balancer sync lock */
 #endif
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
+	struct task_struct	*m_sync_task;	/* generalised sync thread */
+	bhv_vfs_sync_work_t	m_sync_work;	/* work item for VFS_SYNC */
+	struct list_head	m_sync_list;	/* sync thread work item list */
+	spinlock_t		m_sync_lock;	/* work item list lock */
+	int			m_sync_seq;	/* sync thread generation no. */
+	wait_queue_head_t	m_wait_single_sync_task;
 } xfs_mount_t;
 
 /*
