Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Jun 2007 22:14:47 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l545EdWt002262
	for <xfs@oss.sgi.com>; Sun, 3 Jun 2007 22:14:42 -0700
Date: Mon, 4 Jun 2007 15:14:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: remount read-only path is as broken as freezing was....
Message-ID: <20070604051433.GP85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


I recently had a remount,ro test fail in a way I had previously
only seen freezing fail. That is, it failed because we still
had active transactions after calling xfs_quiesce_fs(). Further
investigation shows that this path is broken in the same ways
that the xfs freeze path was broken (and recently fixed).

Make the remount,ro path properly flush the filesystem down
to a clean state before returning.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_super.c |    2 -
 fs/xfs/linux-2.6/xfs_vfs.h   |   10 +++++++
 fs/xfs/xfs_vfsops.c          |   54 ++++++++++++++++++++++++-------------------
 3 files changed, 42 insertions(+), 24 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2007-05-10 16:56:09.594774832 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2007-05-10 17:39:02.374544197 +1000
@@ -726,7 +726,7 @@ xfs_fs_sync_super(
 		 * occur here so don't bother flushing the buftarg (i.e
 		 * SYNC_QUIESCE) because it'll just get dirty again.
 		 */
-		flags = SYNC_FSDATA | SYNC_DELWRI | SYNC_WAIT | SYNC_IOWAIT;
+		flags = SYNC_DATA_QUIESCE;
 	} else
 		flags = SYNC_FSDATA | (wait ? SYNC_WAIT : 0);
 
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-05-10 16:56:09.590775350 +1000
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.h	2007-05-10 17:39:02.386542627 +1000
@@ -94,6 +94,16 @@ typedef enum {
 #define SYNC_IOWAIT		0x0100  /* wait for all I/O to complete */
 #define SYNC_SUPER		0x0200  /* flush superblock to disk */
 
+/*
+ * When remounting a filesystem read-only or freezing the filesystem,
+ * we have two phases to execute. This first phase is syncing the data
+ * before we quiesce the filesystem, and the second is flushing all the
+ * inodes out after we've waited for all the transactions created by
+ * the first phase to complete.
+ */
+#define SYNC_DATA_QUIESCE	(SYNC_DELWRI|SYNC_FSDATA|SYNC_WAIT|SYNC_IOWAIT)
+#define SYNC_INODE_QUIESCE	(SYNC_REMOUNT|SYNC_ATTR|SYNC_WAIT)
+
 #define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
 #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
 #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-05-10 17:38:58.351070788 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-05-10 17:58:09.958425162 +1000
@@ -665,7 +665,7 @@ xfs_quiesce_fs(
 	 * we can write the unmount record.
 	 */
 	do {
-		xfs_syncsub(mp, SYNC_REMOUNT|SYNC_ATTR|SYNC_WAIT, NULL);
+		xfs_syncsub(mp, SYNC_INODE_QUIESCE, NULL);
 		pincount = xfs_flush_buftarg(mp->m_ddev_targp, 1);
 		if (!pincount) {
 			count++;
@@ -682,6 +682,30 @@ xfs_quiesce_fs(
 	return 0;
 }
 
+/*
+ * Second stage of a quiesce. The data is already synced, now we have to take
+ * care of the metadata. New transactions are already blocked, so we need to
+ * wait for any remaining transactions to drain out before proceding.
+ */
+STATIC void
+xfs_attr_quiesce(
+	xfs_mount_t	*mp)
+{
+	/* wait for all modifications to complete */
+	while (atomic_read(&mp->m_active_trans) > 0)
+		delay(100);
+
+	/* flush inodes and push all remaining buffers out to disk */
+	xfs_quiesce_fs(mp);
+
+	ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);
+
+	/* Push the superblock and write an unmount record */
+	xfs_log_sbcount(mp, 1);
+	xfs_log_unmount_write(mp);
+	xfs_unmountfs_writesb(mp);
+}
+
 STATIC int
 xfs_mntupdate(
 	bhv_desc_t			*bdp,
@@ -701,11 +725,7 @@ xfs_mntupdate(
 			mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		}
 	} else if (!(vfsp->vfs_flag & VFS_RDONLY)) {	/* rw -> ro */
-		bhv_vfs_sync(vfsp, SYNC_FSDATA|SYNC_BDFLUSH|SYNC_ATTR, NULL);
-		xfs_quiesce_fs(mp);
-		xfs_log_sbcount(mp, 1);
-		xfs_log_unmount_write(mp);
-		xfs_unmountfs_writesb(mp);
+		bhv_vfs_sync(vfsp, SYNC_DATA_QUIESCE, NULL);
+		xfs_attr_quiesce(mp);
 		vfsp->vfs_flag |= VFS_RDONLY;
 	}
 	return 0;
@@ -1998,9 +2018,9 @@ xfs_showargs(
 }
 
 /*
- * Second stage of a freeze. The data is already frozen, now we have to take
- * care of the metadata. New transactions are already blocked, so we need to
- * wait for any remaining transactions to drain out before proceding.
+ * Second stage of a freeze. The data is already frozen so we only
+ * need to take care of the metadata. Once that's done write a dummy
+ * record to dirty the log in case of a crash while frozen.
  */
 STATIC void
 xfs_freeze(
@@ -2008,19 +2028,7 @@ xfs_freeze(
 {
 	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
 
-	/* wait for all modifications to complete */
-	while (atomic_read(&mp->m_active_trans) > 0)
-		delay(100);
-
-	/* flush inodes and push all remaining buffers out to disk */
-	xfs_quiesce_fs(mp);
-
-	ASSERT_ALWAYS(atomic_read(&mp->m_active_trans) == 0);
-
-	/* Push the superblock and write an unmount record */
-	xfs_log_sbcount(mp, 1);
-	xfs_log_unmount_write(mp);
-	xfs_unmountfs_writesb(mp);
+	xfs_attr_quiesce(mp);
 	xfs_fs_log_dummy(mp);
 }
 
