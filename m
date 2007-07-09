Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 09 Jul 2007 00:38:34 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l697cUtL029196
	for <xfs@oss.sgi.com>; Mon, 9 Jul 2007 00:38:32 -0700
Date: Mon, 9 Jul 2007 17:38:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: fix truncate vs null files issues
Message-ID: <20070709073826.GO31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>


When we change the file size via xfs_setattr(), we log the
new, in-memory file size in the transaction. We do this without
having flushed any dirty data so if we have previously extended
the file we change the on disk file size without having written
the data first.

This is a problem for both growing the file and truncating the
file. The truncate case is partially hidden by the VTRUNCATE
code, but if the file has not been closed before a crash has
occurred we can still get NULLs appearing in files. 

The following patch fixes this problem by flushing the range
between the on-disk filesize and the new file size as long
as the new file size is larger than the on disk file size.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_vnodeops.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-06-20 17:59:35.050768978 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-06-21 15:18:17.187347809 +1000
@@ -595,7 +595,30 @@ xfs_setattr(
 			code = xfs_igrow_start(ip, vap->va_size, credp);
 		}
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		vn_iowait(vp); /* wait for the completion of any pending DIOs */
+
+		/*
+		 * We are going to log the inode size change in this
+		 * transaction so any previous writes that are beyond the on
+		 * disk EOF and the new EOF that have not been written out need
+		 * to be written here. If we do not write the data out, we
+		 * expose ourselves to the null files problem.
+		 *
+		 * Only flush from the on disk size to the smaller of the in
+		 * memory file size or the new size as that's the range we
+		 * really care about here and prevents waiting for other data
+		 * not within the range we care about here.
+		 */
+		if (!code &&
+		    (ip->i_size != ip->i_d.di_size) &&
+		    (vap->va_size > ip->i_d.di_size)) {
+			code = bhv_vop_flush_pages(XFS_ITOV(ip),
+					ip->i_d.di_size, vap->va_size,
+					XFS_B_ASYNC, FI_NONE);
+		}
+
+		/* wait for all I/O to complete */
+		vn_iowait(vp);
+
 		if (!code)
 			code = xfs_itruncate_data(ip, vap->va_size);
 		if (code) {
