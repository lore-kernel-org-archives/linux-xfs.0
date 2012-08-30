Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7UBxWpr192323 for <xfs@oss.sgi.com>; Thu, 30 Aug 2012 06:59:33 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	s20SP4PZJoahkxkC for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 05:00:25 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T73Q4-0003qH-3G
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 22:00:20 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T73Q4-0000kP-08
	for xfs@oss.sgi.com; Thu, 30 Aug 2012 22:00:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/13] xfs: don't run the sync work if the filesyste is
	read-only
Date: Thu, 30 Aug 2012 22:00:08 +1000
Message-Id: <1346328017-2795-5-git-send-email-david@fromorbit.com>
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

If the filesytem is mounted or remounted read-only, stop the sync
worker that tries to flush or cover the log if the filesystem is
dirty. It's read-only, so it isn't dirty. Restart it on a remount,rw
as necessary. This avoids the need for RO checks in the work.

Similarly, stop the sync work when the filesystem is frozen, and
start it again when the filesysetm is thawed. This avoids the need
for special freeze checks in the work.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_super.c |    2 ++
 fs/xfs/xfs_sync.c  |   26 ++++++++++++++------------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a08a648..619a3ff 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1106,6 +1106,7 @@ xfs_fs_remount(
 		 * value if it is non-zero, otherwise go with the default.
 		 */
 		xfs_restore_resvblks(mp);
+		xfs_sync_queue_work(mp);
 	}
 
 	/* rw -> ro */
@@ -1151,6 +1152,7 @@ xfs_fs_unfreeze(
 	struct xfs_mount	*mp = XFS_M(sb);
 
 	xfs_restore_resvblks(mp);
+	xfs_sync_queue_work(mp);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index ea8e0a1..b0a11cd 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -322,6 +322,9 @@ xfs_quiesce_data(
  * Second stage of a quiesce. The data is already synced, now we have to take
  * care of the metadata. New transactions are already blocked, so we need to
  * wait for any remaining transactions to drain out before proceeding.
+ *
+ * Note: this stops background sync work - the callers must ensure it is started
+ * again when appropriate.
  */
 void
 xfs_quiesce_attr(
@@ -340,6 +343,9 @@ xfs_quiesce_attr(
 	/* flush all pending changes from the AIL */
 	xfs_ail_push_all_sync(mp->m_ail);
 
+	/* stop background sync work */
+	cancel_delayed_work_sync(&mp->m_sync_work);
+
 	/*
 	 * Just warn here till VFS can correctly support
 	 * read-only remount without racing.
@@ -380,7 +386,7 @@ xfs_sync_work_queue(
 /*
  * Every sync period we need to unpin all items in the AIL and push them to
  * disk. If there is nothing dirty, then we might need to cover the log to
- * indicate that the filesystem is idle and not frozen.
+ * indicate that the filesystem is idle.
  */
 void
 xfs_sync_worker(
@@ -388,19 +394,15 @@ xfs_sync_worker(
 {
 	struct xfs_mount *mp = container_of(to_delayed_work(work),
 					struct xfs_mount, m_sync_work);
-	int		error;
 
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
-		/* dgc: errors ignored here */
-		if (mp->m_super->s_writers.frozen == SB_UNFROZEN &&
-		    xfs_log_need_covered(mp))
-			error = xfs_fs_log_dummy(mp);
-		else
-			xfs_log_force(mp, 0);
+	/* dgc: errors ignored - not fatal and nowhere to report them */
+	if (xfs_log_need_covered(mp))
+		xfs_fs_log_dummy(mp);
+	else
+		xfs_log_force(mp, 0);
 
-		/* start pushing all the metadata that is currently dirty */
-		xfs_ail_push_all(mp->m_ail);
-	}
+	/* start pushing all the metadata that is currently dirty */
+	xfs_ail_push_all(mp->m_ail);
 
 	/* queue us up again */
 	xfs_sync_work_queue(mp);
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
