Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 06:16:19 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7JDFZMS022796
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:15:36 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EF1B11BC6727
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:16:55 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id QbbNW4FPe28oKXOL for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 06:16:55 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KVR4o-0008Ae-3o
	for xfs@oss.sgi.com; Tue, 19 Aug 2008 23:16:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/28] XFS: make SYNC_DELWRI no longer use xfs_sync
Date: Tue, 19 Aug 2008 23:16:30 +1000
Message-Id: <1219151804-30749-15-git-send-email-david@fromorbit.com>
In-Reply-To: <1219151804-30749-1-git-send-email-david@fromorbit.com>
References: <1219151804-30749-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Continue to de-multiplex xfs_sync be replacing all SYNC_DELWRI
callers with direct calls functions that do the work. Isolate the
data quiesce case to a function in xfs_sync.c. Isolate the
FSDATA case with explicit calls to xfs_sync_fsdata().

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   24 ++++++------------------
 fs/xfs/linux-2.6/xfs_sync.c  |   37 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/linux-2.6/xfs_sync.h  |    3 +++
 3 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 59663f2..a4ff642 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1022,7 +1022,7 @@ xfs_fs_write_super(
 	struct super_block	*sb)
 {
 	if (!(sb->s_flags & MS_RDONLY))
-		xfs_sync(XFS_M(sb), SYNC_FSDATA);
+		xfs_sync_fsdata(XFS_M(sb), 0);
 	sb->s_dirt = 0;
 }
 
@@ -1033,7 +1033,6 @@ xfs_fs_sync_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 	int			error;
-	int			flags;
 
 	/*
 	 * Treat a sync operation like a freeze.  This is to work
@@ -1047,20 +1046,10 @@ xfs_fs_sync_super(
 	 * dirty the Linux inode until after the transaction I/O
 	 * completes.
 	 */
-	if (wait || unlikely(sb->s_frozen == SB_FREEZE_WRITE)) {
-		/*
-		 * First stage of freeze - no more writers will make progress
-		 * now we are here, so we flush delwri and delalloc buffers
-		 * here, then wait for all I/O to complete.  Data is frozen at
-		 * that point. Metadata is not frozen, transactions can still
-		 * occur here so don't bother flushing the buftarg (i.e
-		 * SYNC_QUIESCE) because it'll just get dirty again.
-		 */
-		flags = SYNC_DATA_QUIESCE;
-	} else
-		flags = SYNC_FSDATA;
-
-	error = xfs_sync(mp, flags);
+	if (wait || unlikely(sb->s_frozen == SB_FREEZE_WRITE))
+		error = xfs_quiesce_data(mp);
+	else
+		error = xfs_sync_fsdata(mp, 0);
 	sb->s_dirt = 0;
 
 	if (unlikely(laptop_mode)) {
@@ -1178,8 +1167,7 @@ xfs_fs_remount(
 
 	/* rw -> ro */
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (*flags & MS_RDONLY)) {
-		xfs_filestream_flush(mp);
-		xfs_sync(mp, SYNC_DATA_QUIESCE);
+		xfs_quiesce_data(mp);
 		xfs_attr_quiesce(mp);
 		mp->m_flags |= XFS_MOUNT_RDONLY;
 	}
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 002ccb6..adbbdd5 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -269,7 +269,7 @@ xfs_commit_dummy_trans(
 	return 0;
 }
 
-STATIC int
+int
 xfs_sync_fsdata(
 	struct xfs_mount	*mp,
 	int			flags)
@@ -323,6 +323,41 @@ xfs_sync_fsdata(
 }
 
 /*
+ * First stage of freeze - no more writers will make progress now we are here,
+ * so we flush delwri and delalloc buffers here, then wait for all I/O to
+ * complete.  Data is frozen at that point. Metadata is not frozen,
+ * transactions can still occur here so don't bother flushing the buftarg (i.e
+ * SYNC_QUIESCE) because it'll just get dirty again.
+ */
+int
+xfs_quiesce_data(
+	struct xfs_mount	*mp)
+{
+	int error;
+
+	/* push non-blocking */
+	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_BDFLUSH);
+	XFS_QM_DQSYNC(mp, SYNC_BDFLUSH);
+	xfs_filestream_flush(mp);
+
+	/* push and block */
+	xfs_log_force(mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC);
+	xfs_sync_inodes(mp, SYNC_DELWRI|SYNC_WAIT|SYNC_IOWAIT);
+	xfs_log_force(mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC);
+	XFS_QM_DQSYNC(mp, SYNC_WAIT);
+
+	/* write superblock and hoover shutdown errors */
+	error = xfs_sync_fsdata(mp, 0);
+
+	/* flush devices */
+	XFS_bflush(mp->m_ddev_targp);
+	if (mp->m_rtdev_targp)
+		XFS_bflush(mp->m_rtdev_targp);
+
+	return error;
+}
+
+/*
  * xfs_sync flushes any pending I/O to file system vfsp.
  *
  * This routine is called by vfs_sync() to make sure that things make it
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 5316915..fcd4040 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -55,6 +55,9 @@ void xfs_syncd_stop(struct xfs_mount *mp);
 
 int xfs_sync(struct xfs_mount *mp, int flags);
 int xfs_sync_inodes(struct xfs_mount *mp, int flags);
+int xfs_sync_fsdata(struct xfs_mount *mp, int flags);
+
+int xfs_quiesce_data(struct xfs_mount *mp);
 
 void xfs_flush_inode(struct xfs_inode *ip);
 void xfs_flush_device(struct xfs_inode *ip);
-- 
1.5.6
