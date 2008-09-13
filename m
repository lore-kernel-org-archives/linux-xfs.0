Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 06:56:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DDtjBn012305
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:55:45 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 00B7C1ADDEFF
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:57:14 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id wvcrGq4ieYHCTdKi for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:57:14 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeVcd-0007U4-2Y
	for xfs@oss.sgi.com; Sat, 13 Sep 2008 23:57:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/10] XFS: kill xfs_syncsub
Date: Sat, 13 Sep 2008 23:57:04 +1000
Message-Id: <1221314230-28618-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1221314230-28618-1-git-send-email-david@fromorbit.com>
References: <1221314230-28618-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Now that the only caller is xfs_sync(), merge the two
together as it makes no sense to keep them separate.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |  141 +++++++++++++++++++------------------------
 1 files changed, 62 insertions(+), 79 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 7e9fb52..d4b7b21 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -48,79 +48,6 @@
 #include <linux/freezer.h>
 
 /*
- * xfs_sync flushes any pending I/O to file system vfsp.
- *
- * This routine is called by vfs_sync() to make sure that things make it
- * out to disk eventually, on sync() system calls to flush out everything,
- * and when the file system is unmounted.  For the vfs_sync() case, all
- * we really need to do is sync out the log to make all of our meta-data
- * updates permanent (except for timestamps).  For calls from pflushd(),
- * dirty pages are kept moving by calling pdflush() on the inodes
- * containing them.  We also flush the inodes that we can lock without
- * sleeping and the superblock if we can lock it without sleeping from
- * vfs_sync() so that items at the tail of the log are always moving out.
- *
- * Flags:
- *      SYNC_BDFLUSH - We're being called from vfs_sync() so we don't want
- *		       to sleep if we can help it.  All we really need
- *		       to do is ensure that the log is synced at least
- *		       periodically.  We also push the inodes and
- *		       superblock if we can lock them without sleeping
- *			and they are not pinned.
- *      SYNC_ATTR    - We need to flush the inodes.  If SYNC_BDFLUSH is not
- *		       set, then we really want to lock each inode and flush
- *		       it.
- *      SYNC_WAIT    - All the flushes that take place in this call should
- *		       be synchronous.
- *      SYNC_DELWRI  - This tells us to push dirty pages associated with
- *		       inodes.  SYNC_WAIT and SYNC_BDFLUSH are used to
- *		       determine if they should be flushed sync, async, or
- *		       delwri.
- *      SYNC_CLOSE   - This flag is passed when the system is being
- *		       unmounted.  We should sync and invalidate everything.
- *      SYNC_FSDATA  - This indicates that the caller would like to make
- *		       sure the superblock is safe on disk.  We can ensure
- *		       this by simply making sure the log gets flushed
- *		       if SYNC_BDFLUSH is set, and by actually writing it
- *		       out otherwise.
- *	SYNC_IOWAIT  - The caller wants us to wait for all data I/O to complete
- *		       before we return (including direct I/O). Forms the drain
- *		       side of the write barrier needed to safely quiesce the
- *		       filesystem.
- *
- */
-int
-xfs_sync(
-	xfs_mount_t	*mp,
-	int		flags)
-{
-	int		error;
-
-	/*
-	 * Get the Quota Manager to flush the dquots.
-	 *
-	 * If XFS quota support is not enabled or this filesystem
-	 * instance does not use quotas XFS_QM_DQSYNC will always
-	 * return zero.
-	 */
-	error = XFS_QM_DQSYNC(mp, flags);
-	if (error) {
-		/*
-		 * If we got an IO error, we will be shutting down.
-		 * So, there's nothing more for us to do here.
-		 */
-		ASSERT(error != EIO || XFS_FORCED_SHUTDOWN(mp));
-		if (XFS_FORCED_SHUTDOWN(mp))
-			return XFS_ERROR(error);
-	}
-
-	if (flags & SYNC_IOWAIT)
-		xfs_filestream_flush(mp);
-
-	return xfs_syncsub(mp, flags);
-}
-
-/*
  * Sync all the inodes in the given AG according to the
  * direction given by the flags.
  */
@@ -396,22 +323,78 @@ xfs_sync_fsdata(
 }
 
 /*
- * xfs sync routine for internal use
+ * xfs_sync flushes any pending I/O to file system vfsp.
  *
- * This routine supports all of the flags defined for the generic vfs_sync
- * interface as explained above under xfs_sync.
+ * This routine is called by vfs_sync() to make sure that things make it
+ * out to disk eventually, on sync() system calls to flush out everything,
+ * and when the file system is unmounted.  For the vfs_sync() case, all
+ * we really need to do is sync out the log to make all of our meta-data
+ * updates permanent (except for timestamps).  For calls from pflushd(),
+ * dirty pages are kept moving by calling pdflush() on the inodes
+ * containing them.  We also flush the inodes that we can lock without
+ * sleeping and the superblock if we can lock it without sleeping from
+ * vfs_sync() so that items at the tail of the log are always moving out.
+ *
+ * Flags:
+ *      SYNC_BDFLUSH - We're being called from vfs_sync() so we don't want
+ *		       to sleep if we can help it.  All we really need
+ *		       to do is ensure that the log is synced at least
+ *		       periodically.  We also push the inodes and
+ *		       superblock if we can lock them without sleeping
+ *			and they are not pinned.
+ *      SYNC_ATTR    - We need to flush the inodes.  If SYNC_BDFLUSH is not
+ *		       set, then we really want to lock each inode and flush
+ *		       it.
+ *      SYNC_WAIT    - All the flushes that take place in this call should
+ *		       be synchronous.
+ *      SYNC_DELWRI  - This tells us to push dirty pages associated with
+ *		       inodes.  SYNC_WAIT and SYNC_BDFLUSH are used to
+ *		       determine if they should be flushed sync, async, or
+ *		       delwri.
+ *      SYNC_CLOSE   - This flag is passed when the system is being
+ *		       unmounted.  We should sync and invalidate everything.
+ *      SYNC_FSDATA  - This indicates that the caller would like to make
+ *		       sure the superblock is safe on disk.  We can ensure
+ *		       this by simply making sure the log gets flushed
+ *		       if SYNC_BDFLUSH is set, and by actually writing it
+ *		       out otherwise.
+ *	SYNC_IOWAIT  - The caller wants us to wait for all data I/O to complete
+ *		       before we return (including direct I/O). Forms the drain
+ *		       side of the write barrier needed to safely quiesce the
+ *		       filesystem.
  *
  */
-STATIC int
-xfs_syncsub(
+int
+xfs_sync(
 	xfs_mount_t	*mp,
 	int		flags)
 {
-	int		error = 0;
+	int		error;
 	int		last_error = 0;
 	uint		log_flags = XFS_LOG_FORCE;
 
 	/*
+	 * Get the Quota Manager to flush the dquots.
+	 *
+	 * If XFS quota support is not enabled or this filesystem
+	 * instance does not use quotas XFS_QM_DQSYNC will always
+	 * return zero.
+	 */
+	error = XFS_QM_DQSYNC(mp, flags);
+	if (error) {
+		/*
+		 * If we got an IO error, we will be shutting down.
+		 * So, there's nothing more for us to do here.
+		 */
+		ASSERT(error != EIO || XFS_FORCED_SHUTDOWN(mp));
+		if (XFS_FORCED_SHUTDOWN(mp))
+			return XFS_ERROR(error);
+	}
+
+	if (flags & SYNC_IOWAIT)
+		xfs_filestream_flush(mp);
+
+	/*
 	 * Sync out the log.  This ensures that the log is periodically
 	 * flushed even if there is not enough activity to fill it up.
 	 */
-- 
1.5.6
