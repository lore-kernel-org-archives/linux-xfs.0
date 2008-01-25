Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jan 2008 21:32:29 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0P5WLf7026163
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 21:32:24 -0800
Date: Fri, 25 Jan 2008 16:32:28 +1100
From: David Chinner <dgc@sgi.com>
Subject: [patch] Fix ctime/mtime update for truncate to same size
Message-ID: <20080125053228.GR155259@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Russell,

Can you test this change to see if it works for you.
It appears to do the job here.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/xfs_vnodeops.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2008-01-25 16:03:23.654971763 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2008-01-25 16:10:30.875397129 +1100
@@ -634,6 +634,15 @@ xfs_setattr(
 	 * Truncate file.  Must have write permission and not be a directory.
 	 */
 	if (mask & XFS_AT_SIZE) {
+		/*
+		 * Only change the c/mtime if we are changing the size
+		 * or we are explicitly asked to change it. This handles
+		 * the semantic difference between truncate() and ftruncate()
+		 * as implemented in the VFS.
+		 */
+		if (vap->va_size != ip->i_size || mask & XFS_AT_CTIME)
+			timeflags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
+
 		if (vap->va_size > ip->i_size) {
 			xfs_igrow_finish(tp, ip, vap->va_size,
 			    !(flags & ATTR_DMI));
@@ -662,10 +671,6 @@ xfs_setattr(
 			 */
 			xfs_iflags_set(ip, XFS_ITRUNCATED);
 		}
-		/*
-		 * Have to do this even if the file's size doesn't change.
-		 */
-		timeflags |= XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG;
 	}
 
 	/*
