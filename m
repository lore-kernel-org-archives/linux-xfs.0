Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N55FHi136142 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:05:15 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5W3LVfUkj0DcrAT0 for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:06:00 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4Pbp-0003KF-Gz
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4Pbp-0003jU-E3
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:05:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 098/102] xfs: shutdown xfs_sync_worker before the log
Date: Thu, 23 Aug 2012 15:02:56 +1000
Message-Id: <1345698180-13612-99-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

From: Ben Myers <bpm@sgi.com>

Upstream commit: 8866fc6fa55e31b2bce931b7963ff16641b39dc7

Revert commit 1307bbd, which uses the s_umount semaphore to provide
exclusion between xfs_sync_worker and unmount, in favor of shutting down
the sync worker before freeing the log in xfs_log_unmount.  This is a
cleaner way of resolving the race between xfs_sync_worker and unmount
than using s_umount.

Signed-off-by: Ben Myers <bpm@sgi.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sync.c |   33 ++++++++++++++++-----------------
 fs/xfs/xfs_log.c            |    1 +
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 74ea9b1..5b6f46b 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -470,24 +470,23 @@ xfs_sync_worker(
 	 * We shouldn't write/force the log if we are in the mount/unmount
 	 * process or on a read only filesystem. The workqueue still needs to be
 	 * active in both cases, however, because it is used for inode reclaim
-	 * during these times.  Use the s_umount semaphore to provide exclusion
-	 * with unmount.
+	 * during these times.  Use the MS_ACTIVE flag to avoid doing anything
+	 * during mount.  Doing work during unmount is avoided by calling
+	 * cancel_delayed_work_sync on this work queue before tearing down
+	 * the ail and the log in xfs_log_unmount.
 	 */
-	if (down_read_trylock(&mp->m_super->s_umount)) {
-		if (!(mp->m_super->s_flags & MS_ACTIVE) &&
-		    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
-			/* dgc: errors ignored here */
-			if (mp->m_super->s_frozen == SB_UNFROZEN &&
-			    xfs_log_need_covered(mp))
-				error = xfs_fs_log_dummy(mp);
-			else
-				xfs_log_force(mp, 0);
-			error = xfs_qm_sync(mp, SYNC_TRYLOCK);
-
-			/* start pushing all the metadata that is currently dirty */
-			xfs_ail_push_all(mp->m_ail);
-		}
-		up_read(&mp->m_super->s_umount);
+	if (!(mp->m_super->s_flags & MS_ACTIVE) &&
+	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		/* dgc: errors ignored here */
+		if (mp->m_super->s_frozen == SB_UNFROZEN &&
+		    xfs_log_need_covered(mp))
+			error = xfs_fs_log_dummy(mp);
+		else
+			xfs_log_force(mp, 0);
+		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
+
+		/* start pushing all the metadata that is currently dirty */
+		xfs_ail_push_all(mp->m_ail);
 	}
 
 	/* queue us up again */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index dc37cdb..3030618 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -813,6 +813,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 void
 xfs_log_unmount(xfs_mount_t *mp)
 {
+	cancel_delayed_work_sync(&mp->m_sync_work);
 	xfs_trans_ail_destroy(mp);
 	xlog_dealloc_log(mp->m_log);
 }
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
