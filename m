Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB3NeiLF067743 for <xfs@oss.sgi.com>; Mon, 3 Dec 2012 17:40:46 -0600
Message-Id: <20121203144311.665142015@sgi.com>
Date: Mon, 03 Dec 2012 17:42:39 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [3.0-stable PATCH 31/36] xfs: shutdown xfs_sync_worker before the log
References: <20121203144208.143464631@sgi.com>
Content-Disposition: inline; filename=098
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

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
 fs/xfs/linux-2.6/xfs_sync.c |   31 +++++++++++++++----------------
 fs/xfs/xfs_log.c            |    1 +
 2 files changed, 16 insertions(+), 16 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -506,24 +506,23 @@ xfs_sync_worker(
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
+	if (!(mp->m_super->s_flags & MS_ACTIVE) &&
+	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		/* dgc: errors ignored here */
+		if (mp->m_super->s_frozen == SB_UNFROZEN &&
+		    xfs_log_need_covered(mp))
+			error = xfs_fs_log_dummy(mp);
+		else
+			xfs_log_force(mp, 0);
+		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 
-			/* start pushing all the metadata that is currently dirty */
-			xfs_ail_push_all(mp->m_ail);
-		}
-		up_read(&mp->m_super->s_umount);
+		/* start pushing all the metadata that is currently dirty */
+		xfs_ail_push_all(mp->m_ail);
 	}
 
 	/* queue us up again */
Index: b/fs/xfs/xfs_log.c
===================================================================
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -618,6 +618,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 void
 xfs_log_unmount(xfs_mount_t *mp)
 {
+	cancel_delayed_work_sync(&mp->m_sync_work);
 	xfs_trans_ail_destroy(mp);
 	xlog_dealloc_log(mp->m_log);
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
