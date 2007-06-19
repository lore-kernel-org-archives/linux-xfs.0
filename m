Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Jun 2007 23:37:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5J6bIdo025784
	for <xfs@oss.sgi.com>; Mon, 18 Jun 2007 23:37:22 -0700
Date: Tue, 19 Jun 2007 16:37:14 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: fix null files exposure growing via truncate V2
Message-ID: <20070619063714.GP86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Test 140 fails due to the ftruncate() logging the new file size
before any data that had previously been written had hit the
disk. IOWs, it violates the data write/inode size update rule
that fixes the null files problem.

The fix here checks when growing the file as to whether it the disk
inode size is different to the in memory size. If they are
different, we have data that needs to be written to disk beyond the
existing on disk EOF. Hence to maintain ordering we need to flush
this data out before we log the changed file size.

Version 2:

o Only flush the range between the old on disk size and the current
  in memory size.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/xfs_vnodeops.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-06-18 11:44:53.986543106 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-06-18 15:11:43.258810667 +1000
@@ -593,9 +593,31 @@ xfs_setattr(
 		if ((vap->va_size > ip->i_size) &&
 		    (flags & ATTR_NOSIZETOK) == 0) {
 			code = xfs_igrow_start(ip, vap->va_size, credp);
-		}
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		vn_iowait(vp); /* wait for the completion of any pending DIOs */
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			/*
+			 * We are going to log the inode size change in
+			 * this transaction so any previous writes that are
+			 * beyond the on disk EOF that have not been written
+			 * out need to be written here. If we do not write the
+			 * data out, we expose ourselves to the null files
+			 * problem on grow.
+			 *
+			 * Only flush from the on disk size to the in memory
+			 * file size as that's the range we really care about
+			 * here and prevents waiting for other data not within
+			 * the range we care about here.
+			 */
+			if (!code && ip->i_size != ip->i_d.di_size) {
+				code = bhv_vop_flush_pages(XFS_ITOV(ip),
+						ip->i_d.di_size, ip->i_size,
+						XFS_B_ASYNC, FI_NONE);
+			}
+		} else
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+		/* wait for I/O to complete */
+		vn_iowait(vp);
+
 		if (!code)
 			code = xfs_itruncate_data(ip, vap->va_size);
 		if (code) {
