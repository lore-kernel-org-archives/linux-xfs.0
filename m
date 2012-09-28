Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8S4i4ws174869 for <xfs@oss.sgi.com>; Thu, 27 Sep 2012 23:44:04 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Le2PVH5ZcPm3s0LL for <xfs@oss.sgi.com>;
	Thu, 27 Sep 2012 21:45:22 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1THSRf-0007LW-FU
	for xfs@oss.sgi.com; Fri, 28 Sep 2012 14:44:59 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1THSRV-0005GK-27
	for xfs@oss.sgi.com; Fri, 28 Sep 2012 14:44:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/13] xfs: don't run the sync work if the filesystem is
	read-only
Date: Fri, 28 Sep 2012 14:44:35 +1000
Message-Id: <1348807485-20165-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1348807485-20165-1-git-send-email-david@fromorbit.com>
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
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

If the filesystem is mounted or remounted read-only, stop the sync
worker that tries to flush or cover the log if the filesystem is
dirty. It's read-only, so it isn't dirty. Restart it on a remount,rw
as necessary. This avoids the need for RO checks in the work.

Similarly, stop the sync work when the filesystem is frozen, and
start it again when the filesysetm is thawed. This avoids the need
for special freeze checks in the work.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_super.c |    2 ++
 fs/xfs/xfs_sync.c  |   29 ++++++++++++++++-------------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 935b2c7..f6147ae 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1107,6 +1107,7 @@ xfs_fs_remount(
 		 * value if it is non-zero, otherwise go with the default.
 		 */
 		xfs_restore_resvblks(mp);
+		xfs_syncd_queue_sync(mp);
 	}
 
 	/* rw -> ro */
@@ -1152,6 +1153,7 @@ xfs_fs_unfreeze(
 	struct xfs_mount	*mp = XFS_M(sb);
 
 	xfs_restore_resvblks(mp);
+	xfs_syncd_queue_sync(mp);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 509190f..5d69f23 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -323,6 +323,9 @@ xfs_quiesce_data(
  * Second stage of a quiesce. The data is already synced, now we have to take
  * care of the metadata. New transactions are already blocked, so we need to
  * wait for any remaining transactions to drain out before proceeding.
+ *
+ * Note: this stops background sync work - the callers must ensure it is started
+ * again when appropriate.
  */
 void
 xfs_quiesce_attr(
@@ -341,6 +344,9 @@ xfs_quiesce_attr(
 	/* flush all pending changes from the AIL */
 	xfs_ail_push_all_sync(mp->m_ail);
 
+	/* stop background sync work */
+	cancel_delayed_work_sync(&mp->m_sync_work);
+
 	/*
 	 * Just warn here till VFS can correctly support
 	 * read-only remount without racing.
@@ -379,9 +385,8 @@ xfs_syncd_queue_sync(
 }
 
 /*
- * Every sync period we need to unpin all items in the AIL and push them to
- * disk. If there is nothing dirty, then we might need to cover the log to
- * indicate that the filesystem is idle and not frozen.
+ * Every sync period we need to push dirty metadata and try to cover the log
+ * to indicate the filesystem is idle and not frozen.
  */
 void
 xfs_sync_worker(
@@ -391,17 +396,15 @@ xfs_sync_worker(
 					struct xfs_mount, m_sync_work);
 	int		error;
 
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		/* dgc: errors ignored here */
-		if (mp->m_super->s_writers.frozen == SB_UNFROZEN &&
-		    xfs_log_need_covered(mp))
-			error = xfs_fs_log_dummy(mp);
-		else
-			xfs_log_force(mp, 0);
+	/* dgc: errors ignored here */
+	if (mp->m_super->s_writers.frozen == SB_UNFROZEN &&
+	    xfs_log_need_covered(mp))
+		error = xfs_fs_log_dummy(mp);
+	else
+		xfs_log_force(mp, 0);
 
-		/* start pushing all the metadata that is currently dirty */
-		xfs_ail_push_all(mp->m_ail);
-	}
+	/* start pushing all the metadata that is currently dirty */
+	xfs_ail_push_all(mp->m_ail);
 
 	/* queue us up again */
 	xfs_syncd_queue_sync(mp);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
