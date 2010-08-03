Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7399p8R233905 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 04:09:52 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC73D11C5A1E
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 02:18:05 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	peCoWVGH5sOnz9Oc for <xfs@oss.sgi.com>;
	Tue, 03 Aug 2010 02:18:05 -0700 (PDT)
Received: from dastard (unverified [121.44.216.100])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	33637054-1927428
	for <xfs@oss.sgi.com>; Tue, 03 Aug 2010 18:40:07 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OgDVe-0007Li-0r
	for xfs@oss.sgi.com; Tue, 03 Aug 2010 19:10:06 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OgDVd-0000v2-OF
	for xfs@oss.sgi.com; Tue, 03 Aug 2010 19:10:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: dummy transactions should not dirty VFS state
Date: Tue,  3 Aug 2010 19:10:05 +1000
Message-Id: <1280826605-3506-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/linux-2.6/xfs_sync.c |   37 +++----------------------------------
 fs/xfs/xfs_fsops.c          |   24 ++++++++++++++----------
 2 files changed, 17 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index dfcbd98..bec6539 100644
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
+		error2 = xfs_fs_log_dummy(mp);
 
 	/* flush data-only devices */
 	if (mp->m_rtdev_targp)
@@ -578,7 +547,7 @@ xfs_sync_worker(
 		/* dgc: errors ignored here */
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 		if (xfs_log_need_covered(mp))
-			error = xfs_commit_dummy_trans(mp, 0);
+			error = xfs_fs_log_dummy(mp);
 	}
 	mp->m_sync_seq++;
 	wake_up(&mp->m_wait_single_sync_task);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index dbca5f5..9e15623 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -604,6 +604,15 @@ out:
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
 	xfs_mount_t	*mp)
@@ -613,22 +622,17 @@ xfs_fs_log_dummy(
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
+	/* log the UUID because it is an unchanging field */
+	xfs_mod_sb(tp, XFS_SB_UUID);
 	xfs_trans_set_sync(tp);
-	error = xfs_trans_commit(tp, 0);
-
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
+	return xfs_trans_commit(tp, 0);
 }
 
 int
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
