Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q98AsoTQ055513 for <xfs@oss.sgi.com>; Mon, 8 Oct 2012 05:54:50 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PIRWkz1DExGbwGNF for <xfs@oss.sgi.com>;
	Mon, 08 Oct 2012 03:56:18 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TLB0R-0000VD-Vz
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 21:56:16 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TLB0R-00027G-Sn
	for xfs@oss.sgi.com; Mon, 08 Oct 2012 21:56:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/14] xfs: rationalise xfs_mount_wq users
Date: Mon,  8 Oct 2012 21:56:00 +1100
Message-Id: <1349693772-8064-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1349693772-8064-1-git-send-email-david@fromorbit.com>
References: <1349693772-8064-1-git-send-email-david@fromorbit.com>
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

Instead of starting and stopping background work on the xfs_mount_wq
all at the same time, separate them to where they really are needed
to start and stop.

The xfs_sync_worker, only needs to be started after all the mount
processing has completed successfully, while it needs to be stopped
before the log is unmounted.

The xfs_reclaim_worker is started on demand, and can be
stopped before the unmount process does it's own inode reclaim pass.

The xfs_flush_inodes work is run on demand, and so we really only
need to ensure that it has stopped running before we start
processing an unmount, freeze or remount,ro.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_mount.c |    6 ++++--
 fs/xfs/xfs_super.c |   34 ++++++++++++++--------------------
 fs/xfs/xfs_sync.c  |   21 +++++----------------
 3 files changed, 23 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b2bd3a0..d9a31c6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1450,9 +1450,11 @@ xfs_unmountfs(
 
 	/*
 	 * And reclaim all inodes.  At this point there should be no dirty
-	 * inode, and none should be pinned or locked, but use synchronous
-	 * reclaim just to be sure.
+	 * inodes and none should be pinned or locked, but use synchronous
+	 * reclaim just to be sure. We can stop background inode reclaim
+	 * here as well if it is still running.
 	 */
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
 
 	xfs_qm_unmount(mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 26ad3ca..d01fd4d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1005,14 +1005,12 @@ xfs_fs_put_super(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
-	xfs_filestream_unmount(mp);
-	cancel_delayed_work_sync(&mp->m_sync_work);
-	xfs_unmountfs(mp);
-
 	cancel_delayed_work_sync(&mp->m_sync_work);
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	cancel_work_sync(&mp->m_flush_work);
 
+	xfs_filestream_unmount(mp);
+	xfs_unmountfs(mp);
+
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
@@ -1325,6 +1323,9 @@ xfs_fs_fill_super(
 	spin_lock_init(&mp->m_sb_lock);
 	mutex_init(&mp->m_growlock);
 	atomic_set(&mp->m_active_trans, 0);
+	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
+	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
+	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 
 	mp->m_super = sb;
 	sb->s_fs_info = mp;
@@ -1388,15 +1389,9 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
-	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
-	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
-	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-
-	xfs_syncd_queue_sync(mp);
-
 	error = xfs_mountfs(mp);
 	if (error)
-		goto out_syncd_stop;
+		goto out_filestream_unmount;
 
 	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
@@ -1413,12 +1408,15 @@ xfs_fs_fill_super(
 		goto out_unmount;
 	}
 
+	/*
+	 * The filesystem is successfully mounted, so we can start background
+	 * sync work now.
+	 */
+	xfs_syncd_queue_sync(mp);
+
 	return 0;
- out_syncd_stop:
-	cancel_delayed_work_sync(&mp->m_sync_work);
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	cancel_work_sync(&mp->m_flush_work);
 
+ out_filestream_unmount:
 	xfs_filestream_unmount(mp);
  out_free_sb:
 	xfs_freesb(mp);
@@ -1437,10 +1435,6 @@ out_destroy_workqueues:
  out_unmount:
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
-
-	cancel_delayed_work_sync(&mp->m_sync_work);
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	cancel_work_sync(&mp->m_flush_work);
 	goto out_free_sb;
 }
 
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 13830e4..509190f 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -379,9 +379,9 @@ xfs_syncd_queue_sync(
 }
 
 /*
- * Every sync period we need to unpin all items, reclaim inodes and sync
- * disk quotas.  We might need to cover the log to indicate that the
- * filesystem is idle and not frozen.
+ * Every sync period we need to unpin all items in the AIL and push them to
+ * disk. If there is nothing dirty, then we might need to cover the log to
+ * indicate that the filesystem is idle and not frozen.
  */
 void
 xfs_sync_worker(
@@ -391,17 +391,7 @@ xfs_sync_worker(
 					struct xfs_mount, m_sync_work);
 	int		error;
 
-	/*
-	 * We shouldn't write/force the log if we are in the mount/unmount
-	 * process or on a read only filesystem. The workqueue still needs to be
-	 * active in both cases, however, because it is used for inode reclaim
-	 * during these times.  Use the MS_ACTIVE flag to avoid doing anything
-	 * during mount.  Doing work during unmount is avoided by calling
-	 * cancel_delayed_work_sync on this work queue before tearing down
-	 * the ail and the log in xfs_log_unmount.
-	 */
-	if (!(mp->m_super->s_flags & MS_ACTIVE) &&
-	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		/* dgc: errors ignored here */
 		if (mp->m_super->s_writers.frozen == SB_UNFROZEN &&
 		    xfs_log_need_covered(mp))
@@ -409,8 +399,7 @@ xfs_sync_worker(
 		else
 			xfs_log_force(mp, 0);
 
-		/* start pushing all the metadata that is currently
-		 * dirty */
+		/* start pushing all the metadata that is currently dirty */
 		xfs_ail_push_all(mp->m_ail);
 	}
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
