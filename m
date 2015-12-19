Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 732868149
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:04:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 55DC38F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:15 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id eavOtsF985r61cXZ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:14 -0800 (PST)
Subject: [PATCH 70/76] xfs: fork shared EOF block when truncating file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:04:10 -0800
Message-ID: <20151219090410.12713.44591.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

When shrinking a file, the VFS zeroes everything in the associated
page between the new EOF and the previous EOF to avoid leaking data.
If this block is shared we need to fork it before the VFS does its
zeroing to avoid corrupting the other files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iops.c    |    9 +++++++++
 fs/xfs/xfs_reflink.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    2 ++
 3 files changed, 58 insertions(+)


diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ff1341c..56a1368 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -40,6 +40,7 @@
 #include "xfs_pnfs.h"
 #include "xfs_bit.h"
 #include "xfs_refcount.h"
+#include "xfs_reflink.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -814,6 +815,14 @@ xfs_setattr_size(
 	}
 
 	/*
+	 * Fork the last block of the file if it's necessary to avoid
+	 * corrupting other files.
+	 */
+	error = xfs_reflink_truncate(ip, iattr->ia_file, newsize);
+	if (error)
+		return error;
+
+	/*
 	 * We are going to log the inode size change in this transaction so
 	 * any previous writes that are beyond the on disk EOF and the new
 	 * EOF that have not been written out need to be written here.  If we
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index f68df66..04daa7c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1602,3 +1602,50 @@ out:
 	trace_xfs_reflink_unshare_error(ip, error, _RET_IP_);
 	return error;
 }
+
+/**
+ * xfs_reflink_truncate() - If we're trying to truncate a file whose last
+ *			    block is shared and the new size isn't aligned to
+ *			    a block boundary, we need to dirty that last block
+ *			    ahead of the VFS zeroing the page.
+ * @ip: XFS inode
+ * @filp: VFS file structure
+ * @len: New file length
+ */
+int
+xfs_reflink_truncate(
+	struct xfs_inode	*ip,
+	struct file		*filp,
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
+		trace_xfs_reflink_truncate(ip, isize, newsize - isize);
+	else
+		trace_xfs_reflink_truncate(ip, newsize, isize - newsize);
+
+	error = xfs_reflink_dirty_extents(ip, filp, fbno, fbno + 1, isize);
+	if (error)
+		goto out_unlock;
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	return 0;
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	trace_xfs_reflink_truncate_error(ip, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 1904b32..b6d7ce6 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -46,5 +46,7 @@ extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
 
 extern int xfs_reflink_unshare(struct xfs_inode *ip, struct file *filp,
 		xfs_off_t offset, xfs_off_t len);
+extern int xfs_reflink_truncate(struct xfs_inode *ip, struct file *filp,
+		xfs_off_t newsize);
 
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
