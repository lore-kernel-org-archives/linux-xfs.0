Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Jun 2007 23:34:17 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5E6YCWt011983
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2007 23:34:14 -0700
Date: Thu, 14 Jun 2007 16:34:04 +1000
From: David Chinner <dgc@sgi.com>
Subject: [PATCH, RFC] fix null files exposure growing via ftruncate
Message-ID: <20070614063404.GW86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, hch@infradead.org

Christoph,

Looking into the test 140 failure you reported, I realised that none
of the specific null files tests were being run automatically, which
is why I hadn't seen any of those failures (nor had the QA team).
That's being fixed.

I suspect that the test passes on Irix because of a coincidence
(the test sleeps for 10s and that is the default writeback
timeout for file data) which means when the filesystem is shut down
all the data is already on disk so it's not really testing
the NULL files fix.

The failure is due to the ftruncate() logging the new file size
before any data that had previously been written had hit the
disk. IOWs, it violates the data write/inode size update rule
that fixes the null files problem.

The fix here checks when growing the file as to whether it the disk
inode size is different to the in memory size. If they are
different, we have data that needs to be written to disk beyond the
existing on disk EOF. Hence to maintain ordering we need to flush
this data out before we log the changed file size.

I suspect the flush could be done more optimally - I've just done a
brute-force flush the entire file mod. Should we only flush from the
old di_size to the current i_size?

There may also be better ways to fix this. Any thoughts on
that?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_vnodeops.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-06-13 14:12:09.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-06-14 16:01:48.562882473 +1000
@@ -593,9 +593,24 @@ xfs_setattr(
 		if ((vap->va_size > ip->i_size) &&
 		    (flags & ATTR_NOSIZETOK) == 0) {
 			code = xfs_igrow_start(ip, vap->va_size, credp);
-		}
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		vn_iowait(vp); /* wait for the completion of any pending DIOs */
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+			/*
+			 * We are going to log the inode size change in
+			 * this tranaction so any previous writes that are
+			 * beyond the on disk EOF that have not been written
+			 * out need to be written here. If we do not write the
+			 * data out, we expose ourselves to the null files
+			 * problem on grow.
+			 */
+			if (!code && ip->i_size != ip->i_d.di_size)
+				code = bhv_vop_flush_pages(XFS_ITOV(ip), 0, -1,
+							XFS_B_ASYNC, FI_NONE);
+		} else
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+		/* wait for I/O to complete */
+		vn_iowait(vp);
+
 		if (!code)
 			code = xfs_itruncate_data(ip, vap->va_size);
 		if (code) {
