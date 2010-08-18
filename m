Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IBaN7a110468 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 06:36:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D77C31E4AE04
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 04:36:51 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	zZXl5vI8atgtAMhg for <xfs@oss.sgi.com>;
	Wed, 18 Aug 2010 04:36:51 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	35775351-1927428
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 21:06:50 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Olgwh-0005Km-4G
	for xfs@oss.sgi.com; Wed, 18 Aug 2010 21:36:39 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OlgwT-0007nx-1b
	for xfs@oss.sgi.com; Wed, 18 Aug 2010 21:36:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfs: dummy transactions should not dirty VFS state
Date: Wed, 18 Aug 2010 21:36:15 +1000
Message-Id: <1282131379-29932-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1282131379-29932-1-git-send-email-david@fromorbit.com>
References: <1282131379-29932-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When we  need to cover the log, we issue dummy transactions to ensure
the current log tail is on disk. Unfortunately we currently use the
root inode in the dummy transaction, and the act of committing the
transaction dirties the inode at the VFS level.

As a result, the VFS writeback of the dirty inode will prevent the
filesystem from idling long enough for the log covering state
machine to complete. The state machine gets stuck in a loop issuing
new dummy transactions to cover the log and never makes progress.

To avoid this problem, the dummy transactions should not cause
externally visible state changes. To ensure this occurs, make sure
that dummy transactions log an unchanging field in the superblock as
it's state is never propagated outside the filesystem. This allows
the log covering state machine to complete successfully and the
filesystem now correctly enters a fully idle state about 90s after
the last modification was made.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 fs/xfs/linux-2.6/xfs_sync.c  |   42 ++++++------------------------------------
 fs/xfs/xfs_fsops.c           |   31 ++++++++++++++++++-------------
 fs/xfs/xfs_fsops.h           |    2 +-
 4 files changed, 26 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 15c35b6..d09cd14 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1402,7 +1402,7 @@ xfs_fs_freeze(
 
 	xfs_save_resvblks(mp);
 	xfs_quiesce_attr(mp);
-	return -xfs_fs_log_dummy(mp);
+	return -xfs_fs_log_dummy(mp, SYNC_WAIT);
 }
 
 STATIC int
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index dfcbd98..d59c4a6 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -34,6 +34,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_quota.h"
 #include "xfs_trace.h"
+#include "xfs_fsops.h"
 
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -341,38 +342,6 @@ xfs_sync_attr(
 }
 
 STATIC int
-xfs_commit_dummy_trans(
-	struct xfs_mount	*mp,
-	uint			flags)
-{
-	struct xfs_inode	*ip = mp->m_rootip;
-	struct xfs_trans	*tp;
-	int			error;
-
-	/*
-	 * Put a dummy transaction in the log to tell recovery
-	 * that all others are OK.
-	 */
-	tp = xfs_trans_alloc(mp, XFS_TRANS_DUMMY1);
-	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		return error;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, ip);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	error = xfs_trans_commit(tp, 0);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
-	/* the log force ensures this transaction is pushed to disk */
-	xfs_log_force(mp, (flags & SYNC_WAIT) ? XFS_LOG_SYNC : 0);
-	return error;
-}
-
-STATIC int
 xfs_sync_fsdata(
 	struct xfs_mount	*mp)
 {
@@ -432,7 +401,7 @@ xfs_quiesce_data(
 
 	/* mark the log as covered if needed */
 	if (xfs_log_need_covered(mp))
-		error2 = xfs_commit_dummy_trans(mp, SYNC_WAIT);
+		error2 = xfs_fs_log_dummy(mp, SYNC_WAIT);
 
 	/* flush data-only devices */
 	if (mp->m_rtdev_targp)
@@ -563,7 +532,7 @@ xfs_flush_inodes(
 /*
  * Every sync period we need to unpin all items, reclaim inodes and sync
  * disk quotas.  We might need to cover the log to indicate that the
- * filesystem is idle.
+ * filesystem is idle and not frozen.
  */
 STATIC void
 xfs_sync_worker(
@@ -577,8 +546,9 @@ xfs_sync_worker(
 		xfs_reclaim_inodes(mp, 0);
 		/* dgc: errors ignored here */
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
-		if (xfs_log_need_covered(mp))
-			error = xfs_commit_dummy_trans(mp, 0);
+		if (mp->m_super->s_frozen == SB_UNFROZEN &&
+		    xfs_log_need_covered(mp))
+			error = xfs_fs_log_dummy(mp, 0);
 	}
 	mp->m_sync_seq++;
 	wake_up(&mp->m_wait_single_sync_task);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index dbca5f5..43b1d56 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -604,31 +604,36 @@ out:
 	return 0;
 }
 
+/*
+ * Dump a transaction into the log that contains no real change. This is needed
+ * to be able to make the log dirty or stamp the current tail LSN into the log
+ * during the covering operation.
+ *
+ * We cannot use an inode here for this - that will push dirty state back up
+ * into the VFS and then periodic inode flushing will prevent log covering from
+ * making progress. Hence we log a field in the superblock instead.
+ */
 int
 xfs_fs_log_dummy(
-	xfs_mount_t	*mp)
+	xfs_mount_t	*mp,
+	int		flags)
 {
 	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
 	int		error;
 
 	tp = _xfs_trans_alloc(mp, XFS_TRANS_DUMMY1, KM_SLEEP);
-	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
+	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
+					XFS_DEFAULT_LOG_COUNT);
 	if (error) {
 		xfs_trans_cancel(tp, 0);
 		return error;
 	}
 
-	ip = mp->m_rootip;
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, ip);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
-
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
+	/* log the UUID because it is an unchanging field */
+	xfs_mod_sb(tp, XFS_SB_UUID);
+	if (flags & SYNC_WAIT)
+		xfs_trans_set_sync(tp);
+	return xfs_trans_commit(tp, 0);
 }
 
 int
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 88435e0..a786c52 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -25,6 +25,6 @@ extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
 extern int xfs_reserve_blocks(xfs_mount_t *mp, __uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, __uint32_t inflags);
-extern int xfs_fs_log_dummy(xfs_mount_t *mp);
+extern int xfs_fs_log_dummy(xfs_mount_t *mp, int flags);
 
 #endif	/* __XFS_FSOPS_H__ */
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
