Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 413997F9C
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 10:29:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2F337304053
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 08:29:55 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id t9hJFEr4ALfgyshV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 08:29:53 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/18] xfs: recall pNFS layouts on conflicting access
Date: Tue,  6 Jan 2015 17:28:41 +0100
Message-Id: <1420561721-9150-19-git-send-email-hch@lst.de>
In-Reply-To: <1420561721-9150-1-git-send-email-hch@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

Recall all outstanding pNFS layouts and truncates, writes and similar extent
list modifying operations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c  | 14 ++++++++++++--
 fs/xfs/xfs_ioctl.c |  9 +++++++--
 fs/xfs/xfs_iops.c  | 11 ++++++++---
 fs/xfs/xfs_pnfs.c  | 17 +++++++++++++++++
 fs/xfs/xfs_pnfs.h  |  7 +++++++
 5 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 13e974e..cb7464c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -36,6 +36,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_icache.h"
+#include "xfs_pnfs.h"
 
 #include <linux/aio.h>
 #include <linux/dcache.h>
@@ -518,6 +519,10 @@ restart:
 	if (error)
 		return error;
 
+	error = xfs_break_layouts(inode, iolock);
+	if (error)
+		return error;
+
 	/*
 	 * If the offset is beyond the size of the file, we need to zero any
 	 * blocks that fall between the existing EOF and the start of this
@@ -786,6 +791,7 @@ xfs_file_fallocate(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_trans	*tp;
 	long			error;
+	uint			iolock = XFS_IOLOCK_EXCL;
 	loff_t			new_size = 0;
 
 	if (!S_ISREG(inode->i_mode))
@@ -794,7 +800,11 @@ xfs_file_fallocate(
 		     FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, iolock);
+	error = xfs_break_layouts(inode, &iolock);
+	if (error)
+		goto out_unlock;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -874,7 +884,7 @@ xfs_file_fallocate(
 	}
 
 out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, iolock);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a183198..d9f3937 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -39,6 +39,7 @@
 #include "xfs_icache.h"
 #include "xfs_symlink.h"
 #include "xfs_trans.h"
+#include "xfs_pnfs.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -611,6 +612,7 @@ xfs_ioc_space(
 	struct iattr		iattr;
 	bool			setprealloc = false;
 	bool			clrprealloc = false;
+	uint			iolock = XFS_IOLOCK_EXCL;
 	int			error;
 
 	/*
@@ -634,7 +636,10 @@ xfs_ioc_space(
 	if (error)
 		return error;
 
-	xfs_ilock(ip, XFS_IOLOCK_EXCL);
+	xfs_ilock(ip, iolock);
+	error = xfs_break_layouts(inode, &iolock);
+	if (error)
+		goto out_unlock;
 
 	switch (bf->l_whence) {
 	case 0: /*SEEK_SET*/
@@ -751,7 +756,7 @@ xfs_ioc_space(
 	error = xfs_trans_commit(tp, 0);
 
 out_unlock:
-	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+	xfs_iunlock(ip, iolock);
 	mnt_drop_write_file(filp);
 	return error;
 }
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6ff84e8..b1e849a 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -37,6 +37,7 @@
 #include "xfs_da_btree.h"
 #include "xfs_dir2.h"
 #include "xfs_trans_space.h"
+#include "xfs_pnfs.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -970,9 +971,13 @@ xfs_vn_setattr(
 	int			error;
 
 	if (iattr->ia_valid & ATTR_SIZE) {
-		xfs_ilock(ip, XFS_IOLOCK_EXCL);
-		error = xfs_setattr_size(ip, iattr);
-		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
+		uint		iolock = XFS_IOLOCK_EXCL;
+
+		xfs_ilock(ip, iolock);
+		error = xfs_break_layouts(dentry->d_inode, &iolock);
+		if (!error)
+			error = xfs_setattr_size(ip, iattr);
+		xfs_iunlock(ip, iolock);
 	} else {
 		error = xfs_setattr_nonsize(ip, iattr, 0);
 	}
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index d95f596..130516a 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -18,6 +18,23 @@
 #include "xfs_pnfs.h"
 
 int
+xfs_break_layouts(
+	struct inode		*inode,
+	uint			*iolock)
+{
+	int			error;
+
+	while ((error = break_layout(inode, false) == -EWOULDBLOCK)) {
+		xfs_iunlock(XFS_I(inode), *iolock);
+		error = break_layout(inode, true);
+		*iolock = XFS_IOLOCK_EXCL;
+		xfs_ilock(XFS_I(inode), *iolock);
+	}
+
+	return error;
+}
+
+int
 xfs_fs_get_uuid(
 	struct super_block	*sb,
 	u8			*buf,
diff --git a/fs/xfs/xfs_pnfs.h b/fs/xfs/xfs_pnfs.h
index 0d91255..b7fbfce 100644
--- a/fs/xfs/xfs_pnfs.h
+++ b/fs/xfs/xfs_pnfs.h
@@ -7,5 +7,12 @@ int xfs_fs_map_blocks(struct inode *inode, loff_t offset, u64 length,
 		struct iomap *iomap, bool write, u32 *device_generation);
 int xfs_fs_commit_blocks(struct inode *inode, struct iomap *maps, int nr_maps,
 		struct iattr *iattr);
+
+int xfs_break_layouts(struct inode *inode, uint *iolock);
+#else
+static inline int xfs_break_layouts(struct inode *inode, uint *iolock)
+{
+	return 0;
+}
 #endif /* CONFIG_NFSD_PNFS */
 #endif /* _XFS_PNFS_H */
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
