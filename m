Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 06:56:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DDthBO012296
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:55:44 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 884337A7390
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:57:13 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id dDxlGy5nJPTzr4eA for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:57:13 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeVcd-0007UA-5d
	for xfs@oss.sgi.com; Sat, 13 Sep 2008 23:57:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/10] XFS: make SYNC_ATTR no longer use xfs_sync
Date: Sat, 13 Sep 2008 23:57:06 +1000
Message-Id: <1221314230-28618-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1221314230-28618-1-git-send-email-david@fromorbit.com>
References: <1221314230-28618-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Continue to de-multiplex xfs_sync be replacing all SYNC_ATTR
callers with direct calls xfs_sync_inodes(). Add an assert
into xfs_sync() to ensure we caught all the SYNC_ATTR callers.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    3 ++-
 fs/xfs/linux-2.6/xfs_sync.c  |   23 +++++++++++------------
 fs/xfs/linux-2.6/xfs_sync.h  |    1 -
 fs/xfs/xfs_vfsops.c          |    2 +-
 4 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 59f6209..59663f2 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -963,7 +963,8 @@ xfs_fs_put_super(
 	int			error;
 
 	xfs_syncd_stop(mp);
-	xfs_sync(mp, SYNC_ATTR | SYNC_DELWRI);
+	xfs_log_force(mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC);
+	xfs_sync_inodes(mp, SYNC_ATTR|SYNC_DELWRI);
 
 #ifdef HAVE_DMAPI
 	if (mp->m_flags & XFS_MOUNT_DMAPI) {
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 3c31137..002ccb6 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -342,9 +342,8 @@ xfs_sync_fsdata(
  *		       periodically.  We also push the inodes and
  *		       superblock if we can lock them without sleeping
  *			and they are not pinned.
- *      SYNC_ATTR    - We need to flush the inodes.  If SYNC_BDFLUSH is not
- *		       set, then we really want to lock each inode and flush
- *		       it.
+ *      SYNC_ATTR    - We need to flush the inodes. Now handled by direct calls
+ *		       to xfs_sync_inodes().
  *      SYNC_WAIT    - All the flushes that take place in this call should
  *		       be synchronous.
  *      SYNC_DELWRI  - This tells us to push dirty pages associated with
@@ -373,6 +372,8 @@ xfs_sync(
 	int		last_error = 0;
 	uint		log_flags = XFS_LOG_FORCE;
 
+	ASSERT(!(flags & SYNC_ATTR));
+
 	/*
 	 * Get the Quota Manager to flush the dquots.
 	 *
@@ -403,20 +404,18 @@ xfs_sync(
 
 	xfs_log_force(mp, (xfs_lsn_t)0, log_flags);
 
-	if (flags & (SYNC_ATTR|SYNC_DELWRI)) {
+	if (flags & SYNC_DELWRI) {
 		if (flags & SYNC_BDFLUSH)
 			xfs_finish_reclaim_all(mp, 1, XFS_IFLUSH_DELWRI_ELSE_ASYNC);
 		else
 			error = xfs_sync_inodes(mp, flags);
-	}
-
-	/*
-	 * Flushing out dirty data above probably generated more
-	 * log activity, so if this isn't vfs_sync() then flush
-	 * the log again.
-	 */
-	if (flags & SYNC_DELWRI)
+		/*
+		 * Flushing out dirty data above probably generated more
+		 * log activity, so if this isn't vfs_sync() then flush
+		 * the log again.
+		 */
 		xfs_log_force(mp, 0, log_flags);
+	}
 
 	if (flags & SYNC_FSDATA) {
 		error = xfs_sync_fsdata(mp, flags);
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index 2954861..5316915 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -49,7 +49,6 @@ typedef struct bhv_vfs_sync_work {
  * to disk (this is the main difference between a sync and a quiesce).
  */
 #define SYNC_DATA_QUIESCE	(SYNC_DELWRI|SYNC_FSDATA|SYNC_WAIT|SYNC_IOWAIT)
-#define SYNC_INODE_QUIESCE	(SYNC_REMOUNT|SYNC_ATTR|SYNC_WAIT)
 
 int xfs_syncd_init(struct xfs_mount *mp);
 void xfs_syncd_stop(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_vfsops.c b/fs/xfs/xfs_vfsops.c
index d5396d6..c82b955 100644
--- a/fs/xfs/xfs_vfsops.c
+++ b/fs/xfs/xfs_vfsops.c
@@ -76,7 +76,7 @@ xfs_quiesce_fs(
 	 */
 	do {
 		xfs_log_force(mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC);
-		xfs_sync_inodes(mp, SYNC_INODE_QUIESCE);
+		xfs_sync_inodes(mp, SYNC_ATTR|SYNC_WAIT);
 		pincount = xfs_flush_buftarg(mp->m_ddev_targp, 1);
 		if (!pincount) {
 			delay(50);
-- 
1.5.6
