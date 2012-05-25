Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PKeGcn205936 for <xfs@oss.sgi.com>; Fri, 25 May 2012 15:40:16 -0500
Date: Fri, 25 May 2012 15:45:36 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH] xfs:  shutdown xfs_sync_worker before the log
Message-ID: <20120525204536.GA4721@sgi.com>
References: <20120323174327.GU7762@sgi.com> <20120514203449.GE16099@sgi.com>
	<20120516015626.GN25351@dastard> <20120516170402.GD3963@sgi.com>
	<20120517071658.GP25351@dastard> <20120524223952.GU16099@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120524223952.GU16099@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hey Dave,

On Thu, May 24, 2012 at 05:39:52PM -0500, Ben Myers wrote:
> Anyway, I'll make some time to work on this tomorrow so I can test it over
> the weekend.

This is going to spin over the weekend.  See what you think.

-----------

xfs:  shutdown xfs_sync_worker before the log

Revert commit 1307bbd, which uses the s_umount semaphore to provide
exclusion between xfs_sync_worker and unmount, in favor of shutting down
the sync worker before freeing the log in xfs_log_unmount.  This is a
cleaner way of resolving the race between xfs_sync_worker and unmount
than using s_umount.

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c
+++ xfs/fs/xfs/xfs_log.c
@@ -810,6 +810,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 void
 xfs_log_unmount(xfs_mount_t *mp)
 {
+	cancel_delayed_work_sync(&mp->m_sync_work);
 	xfs_trans_ail_destroy(mp);
 	xlog_dealloc_log(mp->m_log);
 }
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c
+++ xfs/fs/xfs/xfs_sync.c
@@ -386,23 +386,23 @@ xfs_sync_worker(
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
-		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
-			/* dgc: errors ignored here */
-			if (mp->m_super->s_frozen == SB_UNFROZEN &&
-			    xfs_log_need_covered(mp))
-				error = xfs_fs_log_dummy(mp);
-			else
-				xfs_log_force(mp, 0);
+	if (!(mp->m_super->s_flags & MS_ACTIVE) &&
+	    !(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		/* dgc: errors ignored here */
+		if (mp->m_super->s_frozen == SB_UNFROZEN &&
+		    xfs_log_need_covered(mp))
+			error = xfs_fs_log_dummy(mp);
+		else
+			xfs_log_force(mp, 0);
 
-			/* start pushing all the metadata that is currently
-			 * dirty */
-			xfs_ail_push_all(mp->m_ail);
-		}
-		up_read(&mp->m_super->s_umount);
+		/* start pushing all the metadata that is currently
+		 * dirty */
+		xfs_ail_push_all(mp->m_ail);
 	}
 
 	/* queue us up again */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
