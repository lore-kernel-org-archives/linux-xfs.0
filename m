Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 30 Jan 2007 14:04:38 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0UM4Rqw009728
	for <xfs@oss.sgi.com>; Tue, 30 Jan 2007 14:04:29 -0800
Date: Wed, 31 Jan 2007 09:03:26 +1100
From: David Chinner <dgc@sgi.com>
Subject: Review: freezing sometimes leaves the log dirty
Message-ID: <20070130220326.GM33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

When we freeze the filesystem on a system that is under
heavy load, the fleeze can complete it's flushes while there
are still transactions active. Hence the freeze completes
with a dirty log and dirty metadata buffers still in memory.

The Linux freeze path is a tangled mess - I had to go back
to the irix code to work out exactly what we should be doing
to work out why the linux code was failing because of
the convoluted paths the linux code takes through the
generic layers.

In short, when we freeze the writes, we should not be
quiescing the filesystem at this point. All we should
be doing is a blocking data sync because we haven't shut down
the transaction subsystem yet. We also need to wait
for all direct I/O writes to complete as well.

Once the data sync is complete, we can return to the generic
code for it to freeze new transactions. Then we can wait for
all active transactions to complete before we quiesce the
filesystem which flushes out all the dirty metadata buffers.

At this point we have a clean filesystem and an empty log
so we can safely write the unmount record followed by a
dummy record to dirty the log to ensure unlinked list
processing on remount if we crash or shut down the machine
while the filesystem is frozen.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_super.c |   14 +++++++++++---
 fs/xfs/linux-2.6/xfs_vfs.h   |    1 +
 fs/xfs/xfs_vfsops.c          |   26 ++++++++++++++++++++++----
 3 files changed, 34 insertions(+), 7 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2007-01-08 14:32:40.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2007-01-08 22:46:12.520522391 +1100
@@ -730,9 +730,17 @@ xfs_fs_sync_super(
 	int			error;
 	int			flags;
 
-	if (unlikely(sb->s_frozen == SB_FREEZE_WRITE))
-		flags = SYNC_QUIESCE;
-	else
+	if (unlikely(sb->s_frozen == SB_FREEZE_WRITE)) {
+		/*
+		 * First stage of freeze - no more writers will make progress
+		 * now we are here, so we flush delwri and delalloc buffers
+		 * here, then wait for all I/O to complete.  Data is frozen at
+		 * that point. Metadata is not frozen, transactions can still
+		 * occur here so don't bother flushing the buftarg (i.e
+		 * SYNC_QUIESCE) because it'll just get dirty again.
+		 */
+		flags = SYNC_FSDATA | SYNC_DELWRI | SYNC_WAIT | SYNC_DIO_WAIT;
+	} else
 		flags = SYNC_FSDATA | (wait ? SYNC_WAIT : 0);
 
 	error = bhv_vfs_sync(vfsp, flags, NULL);
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_vfs.h	2006-12-22 10:53:22.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_vfs.h	2007-01-08 22:27:26.366619320 +1100
@@ -92,6 +92,7 @@ typedef enum {
 #define SYNC_REFCACHE		0x0040  /* prune some of the nfs ref cache */
 #define SYNC_REMOUNT		0x0080  /* remount readonly, no dummy LRs */
 #define SYNC_QUIESCE		0x0100  /* quiesce fileystem for a snapshot */
+#define SYNC_DIO_WAIT		0x0200  /* wait for direct I/O to complete */
 
 #define SHUTDOWN_META_IO_ERROR	0x0001	/* write attempt to metadata failed */
 #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-01-08 20:06:55.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-01-08 23:27:54.696637946 +1100
@@ -881,6 +881,10 @@ xfs_statvfs(
  *		       this by simply making sure the log gets flushed
  *		       if SYNC_BDFLUSH is set, and by actually writing it
  *		       out otherwise.
+ *	SYNC_DIO_WAIT - The caller wants us to wait for all direct I/Os
+ *		       as well to ensure all data I/O completes before we
+ *		       return. Forms the drain side of the write barrier needed
+ *		       to safely quiesce the filesystem.
  *
  */
 /*ARGSUSED*/
@@ -892,10 +896,7 @@ xfs_sync(
 {
 	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
 
-	if (unlikely(flags == SYNC_QUIESCE))
-		return xfs_quiesce_fs(mp);
-	else
-		return xfs_syncsub(mp, flags, NULL);
+	return xfs_syncsub(mp, flags, NULL);
 }
 
 /*
@@ -1181,6 +1182,12 @@ xfs_sync_inodes(
 			}
 
 		}
+		/*
+		 * When freezing, we need to wait ensure direct I/O is complete
+		 * as well to ensure all data modification is complete here
+		 */
+		if (flags & SYNC_DIO_WAIT)
+			vn_iowait(vp);
 
 		if (flags & SYNC_BDFLUSH) {
 			if ((flags & SYNC_ATTR) &&
@@ -1959,15 +1966,26 @@ xfs_showargs(
 	return 0;
 }
 
+/*
+ * Second stage of a freeze. The data is already frozen, now we have to take
+ * care of the metadata. New transactions are already blocked, so we need to
+ * wait for any remaining transactions to drain out before proceding.
+ */
 STATIC void
 xfs_freeze(
 	bhv_desc_t	*bdp)
 {
 	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
 
+	/* wait for all modifications to complete */
 	while (atomic_read(&mp->m_active_trans) > 0)
 		delay(100);
 
+	/* flush inodes and push all remaining buffers out to disk */
+	xfs_quiesce_fs(mp);
+
+	BUG_ON(atomic_read(&mp->m_active_trans) > 0);
+
 	/* Push the superblock and write an unmount record */
 	xfs_log_unmount_write(mp);
 	xfs_unmountfs_writesb(mp);
