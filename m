Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 087C17CBC
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 12:55:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA79D30404E
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 10:55:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BJzSgtHvVr8jkZAg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 May 2016 10:55:51 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 3252774B
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 17:55:51 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u43HtiDW016424
	for <xfs@oss.sgi.com>; Tue, 3 May 2016 13:55:50 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 7/7] xfs: shutdown filesystem at unmount in case of errors
Date: Tue,  3 May 2016 19:55:40 +0200
Message-Id: <1462298140-12411-8-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1462298140-12411-1-git-send-email-cmaiolino@redhat.com>
References: <1462298140-12411-1-git-send-email-cmaiolino@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

If we take "retry forever" literally on metadata IO errors, we can
hang at unmount, once it retries those writes forever. This is the
default behavior, unfortunately.

Currently, there is no way to move the unmount forward, once the mount point
will be already detached, making a call to xfs_io shutdown impossible.

To fix this, we need to mark the filesystem as being in the process
of unmounting, so that a shutdown can be triggered in case of errors. It will be
noisy, though, as it will log the errors and the shutdown that occurs.

Do this with a mount flag that is added at the appropriate time (i.e. before
the blocking AIL sync). We also need to add this flag if mount fails after
the initial phase of log recovery has been run.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 4 ++++
 fs/xfs/xfs_mount.c    | 9 +++++++++
 fs/xfs/xfs_mount.h    | 1 +
 3 files changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 68ed2a0..3fd3389 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1106,6 +1106,10 @@ xfs_buf_iodone_callback_error(
 			       cfg->retry_timeout + bp->b_first_retry_time))
 			goto permanent_error;
 
+	/* At unmount we may treat errors differently */
+	if (mp->m_flags & XFS_MOUNT_UNMOUNTING)
+		goto permanent_error;
+
 	/* still a transient error, higher layers will retry */
 	xfs_buf_ioerror(bp, 0);
 	xfs_buf_relse(bp);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index eda3906..d89fba6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -961,6 +961,7 @@ xfs_mountfs(
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
  out_log_dealloc:
+	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 	xfs_log_mount_cancel(mp);
  out_fail_wait:
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
@@ -1012,6 +1013,14 @@ xfs_unmountfs(
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
 	/*
+	 * We now need to tell the world we are unmounting. This will allow
+	 * us to detect that the filesystem is going away and we should error
+	 * out anything that we have been retrying in the background. This will
+	 * prevent neverending retries iin AIL pushing from hanging the unmount.
+	 */
+	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
+
+	/*
 	 * Flush all pending changes from the AIL.
 	 */
 	xfs_ail_push_all_sync(mp->m_ail);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e3b3267..54e26fc 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -193,6 +193,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_WSYNC		(1ULL << 0)	/* for nfs - all metadata ops
 						   must be synchronous except
 						   for space allocations */
+#define XFS_MOUNT_UNMOUNTING	(1ULL << 1)	/* filesystem is unmounting */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
