Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UBxXBd192334 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 06:59:33 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	FkSYs6OqNCnAorRz for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 05:00:25 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T73Q4-0003qE-1Z
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 22:00:20 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T73Q3-0000kB-SW
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 22:00:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/13] xfs: xfs_syncd_stop must die
Date: Thu, 30 Aug 2012 22:00:05 +1000
Message-Id: <1346328017-2795-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1346328017-2795-1-git-send-email-david@fromorbit.com>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
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

xfs_syncd_start and xfs_syncd_stop tie a bunch of unrelated
functionailty together that actually have different start and stop
requirements. Kill these functions and open code the start/stop
methods for each of the background functions.

Subsequent patches will move the start/stop functions around to the
correct places to avoid races and shutdown issues.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_super.c |   25 ++++++++++++++++++-------
 fs/xfs/xfs_sync.c  |   30 ++++--------------------------
 fs/xfs/xfs_sync.h  |    6 ++++--
 3 files changed, 26 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bdaf4cb..116fcb8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -920,7 +920,11 @@ xfs_fs_put_super(
 
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
-	xfs_syncd_stop(mp);
+
+	cancel_delayed_work_sync(&mp->m_sync_work);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	cancel_work_sync(&mp->m_flush_work);
+
 	xfs_freesb(mp);
 	xfs_icsb_destroy_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
@@ -1290,9 +1294,11 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
-	error = xfs_syncd_init(mp);
-	if (error)
-		goto out_filestream_unmount;
+	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
+	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
+	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+
+	xfs_syncd_queue_sync(mp);
 
 	error = xfs_mountfs(mp);
 	if (error)
@@ -1315,8 +1321,10 @@ xfs_fs_fill_super(
 
 	return 0;
  out_syncd_stop:
-	xfs_syncd_stop(mp);
- out_filestream_unmount:
+	cancel_delayed_work_sync(&mp->m_sync_work);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	cancel_work_sync(&mp->m_flush_work);
+
 	xfs_filestream_unmount(mp);
  out_free_sb:
 	xfs_freesb(mp);
@@ -1335,7 +1343,10 @@ out_destroy_workqueues:
  out_unmount:
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
-	xfs_syncd_stop(mp);
+
+	cancel_delayed_work_sync(&mp->m_sync_work);
+	cancel_delayed_work_sync(&mp->m_reclaim_work);
+	cancel_work_sync(&mp->m_flush_work);
 	goto out_free_sb;
 }
 
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 9654817..13830e4 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -370,7 +370,7 @@ xfs_quiesce_attr(
 	xfs_buf_unlock(mp->m_sb_bp);
 }
 
-static void
+void
 xfs_syncd_queue_sync(
 	struct xfs_mount        *mp)
 {
@@ -383,7 +383,7 @@ xfs_syncd_queue_sync(
  * disk quotas.  We might need to cover the log to indicate that the
  * filesystem is idle and not frozen.
  */
-STATIC void
+void
 xfs_sync_worker(
 	struct work_struct *work)
 {
@@ -445,7 +445,7 @@ xfs_syncd_queue_reclaim(
  * goes low. It scans as quickly as possible avoiding locked inodes or those
  * already being flushed, and once done schedules a future pass.
  */
-STATIC void
+void
 xfs_reclaim_worker(
 	struct work_struct *work)
 {
@@ -478,7 +478,7 @@ xfs_flush_inodes(
 	flush_work_sync(&mp->m_flush_work);
 }
 
-STATIC void
+void
 xfs_flush_worker(
 	struct work_struct *work)
 {
@@ -489,28 +489,6 @@ xfs_flush_worker(
 	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
 }
 
-int
-xfs_syncd_init(
-	struct xfs_mount	*mp)
-{
-	INIT_WORK(&mp->m_flush_work, xfs_flush_worker);
-	INIT_DELAYED_WORK(&mp->m_sync_work, xfs_sync_worker);
-	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-
-	xfs_syncd_queue_sync(mp);
-
-	return 0;
-}
-
-void
-xfs_syncd_stop(
-	struct xfs_mount	*mp)
-{
-	cancel_delayed_work_sync(&mp->m_sync_work);
-	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	cancel_work_sync(&mp->m_flush_work);
-}
-
 void
 __xfs_inode_set_reclaim_tag(
 	struct xfs_perag	*pag,
diff --git a/fs/xfs/xfs_sync.h b/fs/xfs/xfs_sync.h
index 941202e..3f59e5b 100644
--- a/fs/xfs/xfs_sync.h
+++ b/fs/xfs/xfs_sync.h
@@ -26,8 +26,10 @@ struct xfs_perag;
 
 extern struct workqueue_struct	*xfs_syncd_wq;	/* sync workqueue */
 
-int xfs_syncd_init(struct xfs_mount *mp);
-void xfs_syncd_stop(struct xfs_mount *mp);
+void xfs_syncd_queue_sync(struct xfs_mount *mp);
+void xfs_sync_worker(struct work_struct *work);
+void xfs_flush_worker(struct work_struct *work);
+void xfs_reclaim_worker(struct work_struct *work);
 
 int xfs_quiesce_data(struct xfs_mount *mp);
 void xfs_quiesce_attr(struct xfs_mount *mp);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
