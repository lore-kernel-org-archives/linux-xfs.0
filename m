Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 06:52:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DDqaY3010525
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:52:36 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5D41810686BD
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:54:05 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id aCpTDYioC3KqdTq4 for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:54:05 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeVZY-0007O9-W3
	for xfs@oss.sgi.com; Sat, 13 Sep 2008 23:54:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] XFS: move xfssyncd code to xfs_sync.c
Date: Sat, 13 Sep 2008 23:53:56 +1000
Message-Id: <1221314040-27990-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1221314040-27990-1-git-send-email-david@fromorbit.com>
References: <1221314040-27990-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Move all the xfssyncd code to the new xfs_sync.c file.
This places it closer to the actual code that it interacts
with, rather than just being associated with high level
VFS code.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |  151 +--------------------------------------
 fs/xfs/linux-2.6/xfs_super.h |    3 -
 fs/xfs/linux-2.6/xfs_sync.c  |  163 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_sync.h  |   56 ++++++++++++++
 fs/xfs/linux-2.6/xfs_vfs.h   |   31 --------
 fs/xfs/xfs_mount.h           |    1 +
 6 files changed, 223 insertions(+), 182 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index aba1cf0..59f6209 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -944,146 +944,6 @@ xfs_fs_clear_inode(
 	ASSERT(XFS_I(inode) == NULL);
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
-	void		(*syncer)(struct xfs_mount *, void *))
-{
-	struct bhv_vfs_sync_work *work;
-
-	work = kmem_alloc(sizeof(struct bhv_vfs_sync_work), KM_SLEEP);
-	INIT_LIST_HEAD(&work->w_list);
-	work->w_syncer = syncer;
-	work->w_data = data;
-	work->w_mount = mp;
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
-xfs_flush_inode_work(
-	struct xfs_mount *mp,
-	void		*arg)
-{
-	struct inode	*inode = arg;
-	filemap_flush(inode->i_mapping);
-	iput(inode);
-}
-
-void
-xfs_flush_inode(
-	xfs_inode_t	*ip)
-{
-	struct inode	*inode = VFS_I(ip);
-
-	igrab(inode);
-	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inode_work);
-	delay(msecs_to_jiffies(500));
-}
-
-/*
- * This is the "bigger hammer" version of xfs_flush_inode_work...
- * (IOW, "If at first you don't succeed, use a Bigger Hammer").
- */
-STATIC void
-xfs_flush_device_work(
-	struct xfs_mount *mp,
-	void		*arg)
-{
-	struct inode	*inode = arg;
-	sync_blockdev(mp->m_super->s_bdev);
-	iput(inode);
-}
-
-void
-xfs_flush_device(
-	xfs_inode_t	*ip)
-{
-	struct inode	*inode = VFS_I(ip);
-
-	igrab(inode);
-	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_device_work);
-	delay(msecs_to_jiffies(500));
-	xfs_log_force(ip->i_mount, (xfs_lsn_t)0, XFS_LOG_FORCE|XFS_LOG_SYNC);
-}
-
-STATIC void
-xfs_sync_worker(
-	struct xfs_mount *mp,
-	void		*unused)
-{
-	int		error;
-
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY))
-		error = xfs_sync(mp, SYNC_FSDATA | SYNC_BDFLUSH | SYNC_ATTR);
-	mp->m_sync_seq++;
-	wake_up(&mp->m_wait_single_sync_task);
-}
-
-STATIC int
-xfssyncd(
-	void			*arg)
-{
-	struct xfs_mount	*mp = arg;
-	long			timeleft;
-	bhv_vfs_sync_work_t	*work, *n;
-	LIST_HEAD		(tmp);
-
-	set_freezable();
-	timeleft = xfs_syncd_centisecs * msecs_to_jiffies(10);
-	for (;;) {
-		timeleft = schedule_timeout_interruptible(timeleft);
-		/* swsusp */
-		try_to_freeze();
-		if (kthread_should_stop() && list_empty(&mp->m_sync_list))
-			break;
-
-		spin_lock(&mp->m_sync_lock);
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
-		list_for_each_entry_safe(work, n, &mp->m_sync_list, w_list)
-			list_move(&work->w_list, &tmp);
-		spin_unlock(&mp->m_sync_lock);
-
-		list_for_each_entry_safe(work, n, &tmp, w_list) {
-			(*work->w_syncer)(mp, work->w_data);
-			list_del(&work->w_list);
-			if (work == &mp->m_sync_work)
-				continue;
-			kmem_free(work);
-		}
-	}
-
-	return 0;
-}
-
 STATIC void
 xfs_free_fsname(
 	struct xfs_mount	*mp)
@@ -1102,8 +962,7 @@ xfs_fs_put_super(
 	int			unmount_event_flags = 0;
 	int			error;
 
-	kthread_stop(mp->m_sync_task);
-
+	xfs_syncd_stop(mp);
 	xfs_sync(mp, SYNC_ATTR | SYNC_DELWRI);
 
 #ifdef HAVE_DMAPI
@@ -1753,13 +1612,9 @@ xfs_fs_fill_super(
 		goto fail_vnrele;
 	}
 
-	mp->m_sync_work.w_syncer = xfs_sync_worker;
-	mp->m_sync_work.w_mount = mp;
-	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd");
-	if (IS_ERR(mp->m_sync_task)) {
-		error = -PTR_ERR(mp->m_sync_task);
+	error = xfs_syncd_init(mp);
+	if (error)
 		goto fail_vnrele;
-	}
 
 	xfs_itrace_exit(XFS_I(sb->s_root->d_inode));
 
diff --git a/fs/xfs/linux-2.6/xfs_super.h b/fs/xfs/linux-2.6/xfs_super.h
index fe2ef4e..56dc48a 100644
--- a/fs/xfs/linux-2.6/xfs_super.h
+++ b/fs/xfs/linux-2.6/xfs_super.h
@@ -101,9 +101,6 @@ struct block_device;
 
 extern __uint64_t xfs_max_file_offset(unsigned int);
 
-extern void xfs_flush_inode(struct xfs_inode *);
-extern void xfs_flush_device(struct xfs_inode *);
-
 extern void xfs_blkdev_issue_flush(struct xfs_buftarg *);
 
 extern const struct export_operations xfs_export_operations;
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index c765eb2..a51534c 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -44,6 +44,9 @@
 #include "xfs_inode_item.h"
 #include "xfs_rw.h"
 
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+
 /*
  * xfs_sync flushes any pending I/O to file system vfsp.
  *
@@ -603,3 +606,163 @@ xfs_syncsub(
 
 	return XFS_ERROR(last_error);
 }
+
+/*
+ * Enqueue a work item to be picked up by the vfs xfssyncd thread.
+ * Doing this has two advantages:
+ * - It saves on stack space, which is tight in certain situations
+ * - It can be used (with care) as a mechanism to avoid deadlocks.
+ * Flushing while allocating in a full filesystem requires both.
+ */
+STATIC void
+xfs_syncd_queue_work(
+	struct xfs_mount *mp,
+	void		*data,
+	void		(*syncer)(struct xfs_mount *, void *))
+{
+	struct bhv_vfs_sync_work *work;
+
+	work = kmem_alloc(sizeof(struct bhv_vfs_sync_work), KM_SLEEP);
+	INIT_LIST_HEAD(&work->w_list);
+	work->w_syncer = syncer;
+	work->w_data = data;
+	work->w_mount = mp;
+	spin_lock(&mp->m_sync_lock);
+	list_add_tail(&work->w_list, &mp->m_sync_list);
+	spin_unlock(&mp->m_sync_lock);
+	wake_up_process(mp->m_sync_task);
+}
+
+/*
+ * Flush delayed allocate data, attempting to free up reserved space
+ * from existing allocations.  At this point a new allocation attempt
+ * has failed with ENOSPC and we are in the process of scratching our
+ * heads, looking about for more room...
+ */
+STATIC void
+xfs_flush_inode_work(
+	struct xfs_mount *mp,
+	void		*arg)
+{
+	struct inode	*inode = arg;
+	filemap_flush(inode->i_mapping);
+	iput(inode);
+}
+
+void
+xfs_flush_inode(
+	xfs_inode_t	*ip)
+{
+	struct inode	*inode = VFS_I(ip);
+
+	igrab(inode);
+	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inode_work);
+	delay(msecs_to_jiffies(500));
+}
+
+/*
+ * This is the "bigger hammer" version of xfs_flush_inode_work...
+ * (IOW, "If at first you don't succeed, use a Bigger Hammer").
+ */
+STATIC void
+xfs_flush_device_work(
+	struct xfs_mount *mp,
+	void		*arg)
+{
+	struct inode	*inode = arg;
+	sync_blockdev(mp->m_super->s_bdev);
+	iput(inode);
+}
+
+void
+xfs_flush_device(
+	xfs_inode_t	*ip)
+{
+	struct inode	*inode = VFS_I(ip);
+
+	igrab(inode);
+	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_device_work);
+	delay(msecs_to_jiffies(500));
+	xfs_log_force(ip->i_mount, (xfs_lsn_t)0, XFS_LOG_FORCE|XFS_LOG_SYNC);
+}
+
+STATIC void
+xfs_sync_worker(
+	struct xfs_mount *mp,
+	void		*unused)
+{
+	int		error;
+
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY))
+		error = xfs_sync(mp, SYNC_FSDATA | SYNC_BDFLUSH | SYNC_ATTR);
+	mp->m_sync_seq++;
+	wake_up(&mp->m_wait_single_sync_task);
+}
+
+STATIC int
+xfssyncd(
+	void			*arg)
+{
+	struct xfs_mount	*mp = arg;
+	long			timeleft;
+	bhv_vfs_sync_work_t	*work, *n;
+	LIST_HEAD		(tmp);
+
+	set_freezable();
+	timeleft = xfs_syncd_centisecs * msecs_to_jiffies(10);
+	for (;;) {
+		timeleft = schedule_timeout_interruptible(timeleft);
+		/* swsusp */
+		try_to_freeze();
+		if (kthread_should_stop() && list_empty(&mp->m_sync_list))
+			break;
+
+		spin_lock(&mp->m_sync_lock);
+		/*
+		 * We can get woken by laptop mode, to do a sync -
+		 * that's the (only!) case where the list would be
+		 * empty with time remaining.
+		 */
+		if (!timeleft || list_empty(&mp->m_sync_list)) {
+			if (!timeleft)
+				timeleft = xfs_syncd_centisecs *
+							msecs_to_jiffies(10);
+			INIT_LIST_HEAD(&mp->m_sync_work.w_list);
+			list_add_tail(&mp->m_sync_work.w_list,
+					&mp->m_sync_list);
+		}
+		list_for_each_entry_safe(work, n, &mp->m_sync_list, w_list)
+			list_move(&work->w_list, &tmp);
+		spin_unlock(&mp->m_sync_lock);
+
+		list_for_each_entry_safe(work, n, &tmp, w_list) {
+			(*work->w_syncer)(mp, work->w_data);
+			list_del(&work->w_list);
+			if (work == &mp->m_sync_work)
+				continue;
+			kmem_free(work);
+		}
+	}
+
+	return 0;
+}
+
+int
+xfs_syncd_init(
+	struct xfs_mount	*mp)
+{
+	mp->m_sync_work.w_syncer = xfs_sync_worker;
+	mp->m_sync_work.w_mount = mp;
+	mp->m_sync_task = kthread_run(xfssyncd, mp, "xfssyncd");
+	if (IS_ERR(mp->m_sync_task))
+		return -PTR_ERR(mp->m_sync_task);
+	return 0;
+}
+
+void
+xfs_syncd_stop(
+	struct xfs_mount	*mp)
+{
+	kthread_stop(mp->m_sync_task);
+}
+
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index f4c3b1e..3746d15 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -1,7 +1,63 @@
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
 #ifndef XFS_SYNC_H
 #define XFS_SYNC_H 1
 
+struct xfs_mount;
+
+typedef struct bhv_vfs_sync_work {
+	struct list_head	w_list;
+	struct xfs_mount	*w_mount;
+	void			*w_data;	/* syncer routine argument */
+	void			(*w_syncer)(struct xfs_mount *, void *);
+} bhv_vfs_sync_work_t;
+
+#define SYNC_ATTR		0x0001	/* sync attributes */
+#define SYNC_CLOSE		0x0002	/* close file system down */
+#define SYNC_DELWRI		0x0004	/* look at delayed writes */
+#define SYNC_WAIT		0x0008	/* wait for i/o to complete */
+#define SYNC_BDFLUSH		0x0010	/* BDFLUSH is calling -- don't block */
+#define SYNC_FSDATA		0x0020	/* flush fs data (e.g. superblocks) */
+#define SYNC_REFCACHE		0x0040  /* prune some of the nfs ref cache */
+#define SYNC_REMOUNT		0x0080  /* remount readonly, no dummy LRs */
+#define SYNC_IOWAIT		0x0100  /* wait for all I/O to complete */
+
+/*
+ * When remounting a filesystem read-only or freezing the filesystem,
+ * we have two phases to execute. This first phase is syncing the data
+ * before we quiesce the fielsystem, and the second is flushing all the
+ * inodes out after we've waited for all the transactions created by
+ * the first phase to complete. The second phase uses SYNC_INODE_QUIESCE
+ * to ensure that the inodes are written to their location on disk
+ * rather than just existing in transactions in the log. This means
+ * after a quiesce there is no log replay required to write the inodes
+ * to disk (this is the main difference between a sync and a quiesce).
+ */
+#define SYNC_DATA_QUIESCE	(SYNC_DELWRI|SYNC_FSDATA|SYNC_WAIT|SYNC_IOWAIT)
+#define SYNC_INODE_QUIESCE	(SYNC_REMOUNT|SYNC_ATTR|SYNC_WAIT)
+
+int xfs_syncd_init(struct xfs_mount *mp);
+void xfs_syncd_stop(struct xfs_mount *mp);
+
 int xfs_sync(struct xfs_mount *mp, int flags);
 int xfs_syncsub(struct xfs_mount *mp, int flags, int *bypassed);
 
+void xfs_flush_inode(struct xfs_inode *ip);
+void xfs_flush_device(struct xfs_inode *ip);
+
 #endif
diff --git a/fs/xfs/linux-2.6/xfs_vfs.h b/fs/xfs/linux-2.6/xfs_vfs.h
index 7e60c77..0ab60bc 100644
--- a/fs/xfs/linux-2.6/xfs_vfs.h
+++ b/fs/xfs/linux-2.6/xfs_vfs.h
@@ -33,37 +33,6 @@ struct xfs_mount_args;
 
 typedef struct kstatfs	bhv_statvfs_t;
 
-typedef struct bhv_vfs_sync_work {
-	struct list_head	w_list;
-	struct xfs_mount	*w_mount;
-	void			*w_data;	/* syncer routine argument */
-	void			(*w_syncer)(struct xfs_mount *, void *);
-} bhv_vfs_sync_work_t;
-
-#define SYNC_ATTR		0x0001	/* sync attributes */
-#define SYNC_CLOSE		0x0002	/* close file system down */
-#define SYNC_DELWRI		0x0004	/* look at delayed writes */
-#define SYNC_WAIT		0x0008	/* wait for i/o to complete */
-#define SYNC_BDFLUSH		0x0010	/* BDFLUSH is calling -- don't block */
-#define SYNC_FSDATA		0x0020	/* flush fs data (e.g. superblocks) */
-#define SYNC_REFCACHE		0x0040  /* prune some of the nfs ref cache */
-#define SYNC_REMOUNT		0x0080  /* remount readonly, no dummy LRs */
-#define SYNC_IOWAIT		0x0100  /* wait for all I/O to complete */
-
-/*
- * When remounting a filesystem read-only or freezing the filesystem,
- * we have two phases to execute. This first phase is syncing the data
- * before we quiesce the fielsystem, and the second is flushing all the
- * inodes out after we've waited for all the transactions created by
- * the first phase to complete. The second phase uses SYNC_INODE_QUIESCE
- * to ensure that the inodes are written to their location on disk
- * rather than just existing in transactions in the log. This means
- * after a quiesce there is no log replay required to write the inodes
- * to disk (this is the main difference between a sync and a quiesce).
- */
-#define SYNC_DATA_QUIESCE	(SYNC_DELWRI|SYNC_FSDATA|SYNC_WAIT|SYNC_IOWAIT)
-#define SYNC_INODE_QUIESCE	(SYNC_REMOUNT|SYNC_ATTR|SYNC_WAIT)
-
 #define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
 #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
 #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 64116b5..16b5211 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -18,6 +18,7 @@
 #ifndef __XFS_MOUNT_H__
 #define	__XFS_MOUNT_H__
 
+#include "xfs_sync.h"
 
 typedef struct xfs_trans_reservations {
 	uint	tr_write;	/* extent alloc trans */
-- 
1.5.6
