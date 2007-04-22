Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Apr 2007 16:03:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3MN3FfB003682
	for <xfs@oss.sgi.com>; Sun, 22 Apr 2007 16:03:17 -0700
Date: Mon, 23 Apr 2007 09:03:03 +1000
From: David Chinner <dgc@sgi.com>
Subject: review: don't hold ilock when calling vn_iowait
Message-ID: <20070422230303.GX32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


Regression introduced by recent freezing fixes - we should
not hold the ilock while waiting for I/O completion.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_vfsops.c |   73 +++++++++++++++++++---------------------------------
 1 file changed, 28 insertions(+), 45 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vfsops.c	2007-04-19 17:51:09.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vfsops.c	2007-04-20 17:38:39.946453274 +1000
@@ -1169,58 +1169,41 @@ xfs_sync_inodes(
 		 * in the inode list.
 		 */
 
-		if ((flags & SYNC_CLOSE)  && (vp != NULL)) {
-			/*
-			 * This is the shutdown case.  We just need to
-			 * flush and invalidate all the pages associated
-			 * with the inode.  Drop the inode lock since
-			 * we can't hold it across calls to the buffer
-			 * cache.
-			 *
-			 * We don't set the VREMAPPING bit in the vnode
-			 * here, because we don't hold the vnode lock
-			 * exclusively.  It doesn't really matter, though,
-			 * because we only come here when we're shutting
-			 * down anyway.
-			 */
-			xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-			if (XFS_FORCED_SHUTDOWN(mp)) {
-				bhv_vop_toss_pages(vp, 0, -1, FI_REMAPF);
-			} else {
-				error = bhv_vop_flushinval_pages(vp, 0, -1, FI_REMAPF);
+		/*
+		 * If we have to flush data or wait for I/O completion
+		 * we need to drop the ilock that we currently hold.
+		 * If we need to drop the lock, insert a marker if we
+		 * have not already done so.
+		 */
+		if ((flags & (SYNC_CLOSE|SYNC_IOWAIT)) ||
+		    ((flags & SYNC_DELWRI) && VN_DIRTY(vp))) {
+			if (mount_locked) {
+				IPOINTER_INSERT(ip, mp);
 			}
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-			xfs_ilock(ip, XFS_ILOCK_SHARED);
-
-		} else if ((flags & SYNC_DELWRI) && (vp != NULL)) {
-			if (VN_DIRTY(vp)) {
-				/* We need to have dropped the lock here,
-				 * so insert a marker if we have not already
-				 * done so.
-				 */
-				if (mount_locked) {
-					IPOINTER_INSERT(ip, mp);
-				}
-
-				/*
-				 * Drop the inode lock since we can't hold it
-				 * across calls to the buffer cache.
-				 */
-				xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			if (flags & SYNC_CLOSE) {
+				/* Shutdown case. Flush and invalidate. */
+				if (XFS_FORCED_SHUTDOWN(mp))
+					bhv_vop_toss_pages(vp, 0, -1, FI_REMAPF);
+				else
+					error = bhv_vop_flushinval_pages(vp, 0,
+								-1, FI_REMAPF);
+			} else if ((flags & SYNC_DELWRI) && VN_DIRTY(vp)) {
 				error = bhv_vop_flush_pages(vp, (xfs_off_t)0,
 							-1, fflag, FI_NONE);
-				xfs_ilock(ip, XFS_ILOCK_SHARED);
 			}
 
+			/*
+			 * When freezing, we need to wait ensure all I/O (including direct
+			 * I/O) is complete to ensure no further data modification can take
+			 * place after this point
+			 */
+			if (flags & SYNC_IOWAIT)
+				vn_iowait(vp);
+
+			xfs_ilock(ip, XFS_ILOCK_SHARED);
 		}
-		/*
-		 * When freezing, we need to wait ensure all I/O (including direct
-		 * I/O) is complete to ensure no further data modification can take
-		 * place after this point
-		 */
-		if (flags & SYNC_IOWAIT)
-			vn_iowait(vp);
 
 		if (flags & SYNC_BDFLUSH) {
 			if ((flags & SYNC_ATTR) &&
