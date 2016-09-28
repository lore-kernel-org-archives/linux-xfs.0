Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19979 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756200AbcI1C6i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:58:38 -0400
Subject: [PATCH 46/63] xfs: CoW shared EOF block when truncating file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:58:32 -0700
Message-ID: <147503151218.30303.13404244896095456650.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

When shrinking a file, the VFS zeroes everything in the associated
page between the new EOF and the previous EOF to avoid leaking data.
If this block is shared we need to CoW it before the VFS does its
zeroing to avoid corrupting the other files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iops.c    |    9 +++++++++
 fs/xfs/xfs_reflink.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    1 +
 3 files changed, 52 insertions(+)


diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b24c310..dc3f5ba5 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -39,6 +39,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_pnfs.h"
 #include "xfs_iomap.h"
+#include "xfs_reflink.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -827,6 +828,14 @@ xfs_setattr_size(
 		return error;
 
 	/*
+	 * CoW the EOF block of the file if it's necessary to avoid
+	 * corrupting other files.
+	 */
+	error = xfs_reflink_cow_eof_block(ip, newsize);
+	if (error)
+		return error;
+
+	/*
 	 * We are going to log the inode size change in this transaction so
 	 * any previous writes that are beyond the on disk EOF and the new
 	 * EOF that have not been written out need to be written here.  If we
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 72c81fd..5ea6a1f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1707,3 +1707,45 @@ xfs_reflink_unshare(
 	trace_xfs_reflink_unshare_error(ip, error, _RET_IP_);
 	return error;
 }
+
+/*
+ * If we're trying to truncate a file whose last block is shared and the new
+ * size isn't aligned to a block boundary, we need to dirty that last block
+ * ahead of the VFS zeroing the page.
+ */
+int
+xfs_reflink_cow_eof_block(
+	struct xfs_inode	*ip,
+	xfs_off_t		newsize)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		fbno;
+	xfs_off_t		isize;
+	int			error;
+
+	if (!xfs_is_reflink_inode(ip) ||
+	    (newsize & ((1 << VFS_I(ip)->i_blkbits) - 1)) == 0)
+		return 0;
+
+	/* Try to CoW the shared last block */
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	fbno = XFS_B_TO_FSBT(mp, newsize);
+	isize = i_size_read(VFS_I(ip));
+
+	if (newsize > isize)
+		trace_xfs_reflink_cow_eof_block(ip, isize, newsize - isize);
+	else
+		trace_xfs_reflink_cow_eof_block(ip, newsize, isize - newsize);
+
+	error = xfs_reflink_dirty_extents(ip, fbno, fbno + 1, isize);
+	if (error)
+		goto out_unlock;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	return 0;
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	trace_xfs_reflink_cow_eof_block_error(ip, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index ad4fc61..85f8118 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -50,5 +50,6 @@ extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
 		unsigned int flags);
 extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len);
+extern int xfs_reflink_cow_eof_block(struct xfs_inode *ip, xfs_off_t newsize);
 
 #endif /* __XFS_REFLINK_H */

