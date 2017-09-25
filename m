Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:31168 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965663AbdIYXO1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Sep 2017 19:14:27 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/7] xfs: protect S_DAX transitions in XFS read path
Date: Mon, 25 Sep 2017 17:14:00 -0600
Message-Id: <20170925231404.32723-4-ross.zwisler@linux.intel.com>
In-Reply-To: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
References: <20170925231404.32723-1-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "J. Bruce Fields" <bfields@fieldses.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@poochiereds.net>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

In the current XFS read I/O path we check IS_DAX() in xfs_file_read_iter()
to decide whether to do DAX I/O, direct I/O or buffered I/O.  This check is
done without holding the XFS_IOLOCK, though, which means that if we allow
S_DAX to be manipulated via the inode flag we can run into this race:

CPU 0				CPU 1
-----				-----
xfs_file_read_iter()
  IS_DAX() << returns false
  				xfs_ioctl_setattr()
				  xfs_ioctl_setattr_dax_invalidate()
				   xfs_ilock(XFS_MMAPLOCK|XFS_IOLOCK)
				  sets S_DAX
				  releases XFS_MMAPLOCK and XFS_IOLOCK
  xfs_file_buffered_aio_read()
  does buffered I/O to DAX inode, death

Fix this by ensuring that we only check S_DAX when we hold the XFS_IOLOCK
in the read path.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/xfs/xfs_file.c | 42 +++++++++++++-----------------------------
 1 file changed, 13 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ebdd0bd..ca4c8fd 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -207,7 +207,6 @@ xfs_file_dio_aio_read(
 {
 	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
 	size_t			count = iov_iter_count(to);
-	ssize_t			ret;
 
 	trace_xfs_file_direct_read(ip, count, iocb->ki_pos);
 
@@ -215,12 +214,7 @@ xfs_file_dio_aio_read(
 		return 0; /* skip atime */
 
 	file_accessed(iocb->ki_filp);
-
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	ret = iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
-	return ret;
+	return iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);
 }
 
 static noinline ssize_t
@@ -230,23 +224,14 @@ xfs_file_dax_read(
 {
 	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
 	size_t			count = iov_iter_count(to);
-	ssize_t			ret = 0;
 
 	trace_xfs_file_dax_read(ip, count, iocb->ki_pos);
 
 	if (!count)
 		return 0; /* skip atime */
 
-	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			return -EAGAIN;
-		xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	}
-	ret = dax_iomap_rw(iocb, to, &xfs_iomap_ops);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
 	file_accessed(iocb->ki_filp);
-	return ret;
+	return dax_iomap_rw(iocb, to, &xfs_iomap_ops);
 }
 
 STATIC ssize_t
@@ -255,19 +240,9 @@ xfs_file_buffered_aio_read(
 	struct iov_iter		*to)
 {
 	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
-	ssize_t			ret;
 
 	trace_xfs_file_buffered_read(ip, iov_iter_count(to), iocb->ki_pos);
-
-	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			return -EAGAIN;
-		xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	}
-	ret = generic_file_read_iter(iocb, to);
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
-	return ret;
+	return generic_file_read_iter(iocb, to);
 }
 
 STATIC ssize_t
@@ -276,7 +251,8 @@ xfs_file_read_iter(
 	struct iov_iter		*to)
 {
 	struct inode		*inode = file_inode(iocb->ki_filp);
-	struct xfs_mount	*mp = XFS_I(inode)->i_mount;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	ssize_t			ret = 0;
 
 	XFS_STATS_INC(mp, xs_read_calls);
@@ -284,6 +260,12 @@ xfs_file_read_iter(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			return -EAGAIN;
+		xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	}
+
 	if (IS_DAX(inode))
 		ret = xfs_file_dax_read(iocb, to);
 	else if (iocb->ki_flags & IOCB_DIRECT)
@@ -291,6 +273,8 @@ xfs_file_read_iter(
 	else
 		ret = xfs_file_buffered_aio_read(iocb, to);
 
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+
 	if (ret > 0)
 		XFS_STATS_ADD(mp, xs_read_bytes, ret);
 	return ret;
-- 
2.9.5

