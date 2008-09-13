Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 06:56:12 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DDtkXc012318
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:55:46 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 353AD1ADDEFF
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:57:16 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id oSjt6iieODFfBesw for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 06:57:16 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeVcd-0007UF-8p
	for xfs@oss.sgi.com; Sat, 13 Sep 2008 23:57:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/10] XFS: Kill SYNC_CLOSE
Date: Sat, 13 Sep 2008 23:57:08 +1000
Message-Id: <1221314230-28618-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1221314230-28618-1-git-send-email-david@fromorbit.com>
References: <1221314230-28618-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

SYNC_CLOSE is only ever used and checked in conjunction with
SYNC_WAIT, and this only done in one spot. The only thing
this does is make XFS_bflush() calls to the data buftargs.

This will happen very shortly afterwards the xfs_sync() call
anyway in the unmount path via the xfs_close_devices(), so this
code is redundant and can be removed. That only user of SYNC_CLOSE
is now gone, so kill the flag completely.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   10 ----------
 fs/xfs/linux-2.6/xfs_sync.c  |   31 ++-----------------------------
 fs/xfs/linux-2.6/xfs_sync.h  |    1 -
 3 files changed, 2 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 4dbe279..b7e64f5 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -991,16 +991,6 @@ xfs_fs_put_super(
 	error = xfs_unmount_flush(mp, 0);
 	WARN_ON(error);
 
-	/*
-	 * If we're forcing a shutdown, typically because of a media error,
-	 * we want to make sure we invalidate dirty pages that belong to
-	 * referenced vnodes as well.
-	 */
-	if (XFS_FORCED_SHUTDOWN(mp)) {
-		error = xfs_sync(mp, SYNC_WAIT | SYNC_CLOSE);
-		ASSERT(error != EFSCORRUPTED);
-	}
-
 	if (mp->m_flags & XFS_MOUNT_DMAPI) {
 		XFS_SEND_UNMOUNT(mp, rip, DM_RIGHT_NULL, 0, 0,
 				unmount_event_flags);
diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
index 838070c..91a54a7 100644
--- a/fs/xfs/linux-2.6/xfs_sync.c
+++ b/fs/xfs/linux-2.6/xfs_sync.c
@@ -70,7 +70,7 @@ xfs_sync_inodes_ag(
 	if (flags & SYNC_WAIT)
 		fflag = 0;		/* synchronous overrides all */
 
-	if (flags & (SYNC_DELWRI | SYNC_CLOSE)) {
+	if (flags & SYNC_DELWRI) {
 		/*
 		 * We need the I/O lock if we're going to call any of
 		 * the flush/inval routines.
@@ -117,7 +117,7 @@ xfs_sync_inodes_ag(
 		}
 
 		/* nothing to sync during shutdown */
-		if (XFS_FORCED_SHUTDOWN(mp) && !(flags & SYNC_CLOSE)) {
+		if (XFS_FORCED_SHUTDOWN(mp)) {
 			read_unlock(&pag->pag_ici_lock);
 			return 0;
 		}
@@ -152,20 +152,6 @@ xfs_sync_inodes_ag(
 		 * If we need to drop the lock, insert a marker if we
 		 * have not already done so.
 		 */
-		if (flags & SYNC_CLOSE) {
-			xfs_iunlock(ip, XFS_ILOCK_SHARED);
-			if (XFS_FORCED_SHUTDOWN(mp))
-				xfs_tosspages(ip, 0, -1, FI_REMAPF);
-			else
-				error = xfs_flushinval_pages(ip, 0, -1,
-							FI_REMAPF);
-			/* wait for I/O on freeze */
-			if (flags & SYNC_IOWAIT)
-				vn_iowait(ip);
-
-			xfs_ilock(ip, XFS_ILOCK_SHARED);
-		}
-
 		if ((flags & SYNC_DELWRI) && VN_DIRTY(inode)) {
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
 			error = xfs_flush_pages(ip, 0, -1, fflag, FI_NONE);
@@ -390,8 +376,6 @@ xfs_quiesce_data(
  *		       inodes.  SYNC_WAIT and SYNC_BDFLUSH are used to
  *		       determine if they should be flushed sync, async, or
  *		       delwri.
- *      SYNC_CLOSE   - This flag is passed when the system is being
- *		       unmounted.  We should sync and invalidate everything.
  *      SYNC_FSDATA  - This indicates that the caller would like to make
  *		       sure the superblock is safe on disk.  We can ensure
  *		       this by simply making sure the log gets flushed
@@ -472,17 +456,6 @@ xfs_sync(
 			return error;
 	}
 
-	/*
-	 * When shutting down, we need to insure that the AIL is pushed
-	 * to disk or the filesystem can appear corrupt from the PROM.
-	 */
-	if ((flags & (SYNC_CLOSE|SYNC_WAIT)) == (SYNC_CLOSE|SYNC_WAIT)) {
-		XFS_bflush(mp->m_ddev_targp);
-		if (mp->m_rtdev_targp) {
-			XFS_bflush(mp->m_rtdev_targp);
-		}
-	}
-
 	return XFS_ERROR(last_error);
 }
 
diff --git a/fs/xfs/linux-2.6/xfs_sync.h b/fs/xfs/linux-2.6/xfs_sync.h
index fcd4040..2509db0 100644
--- a/fs/xfs/linux-2.6/xfs_sync.h
+++ b/fs/xfs/linux-2.6/xfs_sync.h
@@ -28,7 +28,6 @@ typedef struct bhv_vfs_sync_work {
 } bhv_vfs_sync_work_t;
 
 #define SYNC_ATTR		0x0001	/* sync attributes */
-#define SYNC_CLOSE		0x0002	/* close file system down */
 #define SYNC_DELWRI		0x0004	/* look at delayed writes */
 #define SYNC_WAIT		0x0008	/* wait for i/o to complete */
 #define SYNC_BDFLUSH		0x0010	/* BDFLUSH is calling -- don't block */
-- 
1.5.6
