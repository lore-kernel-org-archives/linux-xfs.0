Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B27AF7EEB
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:28:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 844578F804C
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:28:13 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id SGlPzdMEBTTBu1Wo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:28:12 -0700 (PDT)
Subject: [PATCH 095/119] xfs: CoW shared EOF block when truncating file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:28:04 -0700
Message-ID: <146612688440.12839.3166686602599403800.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

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
index e57bfe8..0fa86bd 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -38,6 +38,7 @@
 #include "xfs_dir2.h"
 #include "xfs_trans_space.h"
 #include "xfs_pnfs.h"
+#include "xfs_reflink.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -816,6 +817,14 @@ xfs_setattr_size(
 	}
 
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
index 78f24c3..b42ffb0 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1740,3 +1740,45 @@ out:
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
index a369b2a..437087c5 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -50,6 +50,7 @@ extern int xfs_reflink_remap_range(struct xfs_inode *src, xfs_off_t srcoff,
 		unsigned int flags);
 extern int xfs_reflink_unshare(struct xfs_inode *ip, xfs_off_t offset,
 		xfs_off_t len);
+extern int xfs_reflink_cow_eof_block(struct xfs_inode *ip, xfs_off_t newsize);
 
 /* xfs_aops.c */
 extern int xfs_map_cow_blocks(struct inode *inode, xfs_off_t offset,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
