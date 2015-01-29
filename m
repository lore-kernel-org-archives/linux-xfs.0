Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 46D2029DFB
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:29:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24732304043
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:29:46 -0800 (PST)
Received: from mail-pa0-f50.google.com (mail-pa0-f50.google.com
	[209.85.220.50]) by cuda.sgi.com with ESMTP id FBVymGnW6rwUubaw
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:29:28 -0800 (PST)
Received: by mail-pa0-f50.google.com with SMTP id rd3so39064928pab.9
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 05:29:28 -0800 (PST)
Received: from dhruv-MacBookAir ([14.97.215.112])
	by mx.google.com with ESMTPSA id ph7sm7867491pbb.6.2015.01.29.05.29.25
	for <xfs@oss.sgi.com> (version=TLSv1 cipher=RC4-SHA bits=128/128);
	Thu, 29 Jan 2015 05:29:27 -0800 (PST)
Message-ID: <54ca35b7.2786440a.6990.450d@mx.google.com>
From: Dhruvesh Rathore <adrscube@gmail.com>
Date: Thu, 29 Jan 2015 18:59:22 +0530
Subject: [PATCH 3/4] xfs: Adding XFS_IOC_FIEMAPFS ioctl for use in xfs_spaceman
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
To: xfs@oss.sgi.com


This patch is concerned with the changes to be done in kernel space code for
turning FS_IOC_FIEMAPFS present in the earlier version of xfs_spaceman 
into an XFS specific ioctl called XFS_IOC_FIEMAPFS, which uses all existing
fiemap insfrastructure.
By introducing XFS_IOC_FIMEAPFS ioctl, it can be seperated from file based
fiemap commands and allows us to review it and push it as we need, making the
process much simpler.

----------------------------------------------------------------------------------------

Signed-off-by: Dhruvesh Rathore <dhruvesh_r@outlook.com>
Signed-off-by: Amey Ruikar <ameyruikar@yahoo.com>
Signed-off-by: Somdeep Dey <somdeepdey10@gmail.com>
---
fs/ioctl.c		| 3  ++-
include/linux/fs.h	| 6  ++++++
fs/xfs/xfs_ioctl.c	| 55 +++++++++++++
fs/xfs/xfs_fs.h		| 1  +
4 files changed, 64 insertions(+), 1 deletion(-) 

--- a/fs/ioctl.c	2015-01-29 18:08:19.608874677 +0530
+++ b/fs/ioctl.c	2015-01-29 18:07:39.624876178 +0530

@@ -175,7 +175,7 @@
 }
 EXPORT_SYMBOL(fiemapfs_check_flags);
 
-static int fiemap_check_ranges(struct super_block *sb,
+int fiemap_check_ranges(struct super_block *sb,
 			       u64 start, u64 len, u64 *new_len)
 {
 	u64 maxbytes = (u64) sb->s_maxbytes;
@@ -196,6 +196,7 @@
 
 	return 0;
 }
+EXPORT_SYMBOL(fiemap_check_ranges);
 
 static int ioctl_fiemap(struct file *filp, unsigned long arg)
 {

----------------------------------------------------------------------------------------

--- a/include/linux/fs.h	2015-01-29 18:00:44.716891762 +0530
+++ b/include/linux/fs.h	2015-01-29 17:59:34.532894398 +0530

@@ -1435,6 +1435,9 @@
  * VFS FS_IOC_FIEMAP helper definitions.
  */
 
+/* So that the fiemap access checks can't overflow on 32 bit machines. */
+#define FIEMAP_MAX_EXTENTS	(UINT_MAX / sizeof(struct fiemap_extent))
+
 struct fiemap_extent_info {
 	unsigned int fi_flags;		/* Flags as passed from user */
 	unsigned int fi_extents_mapped;	/* Number of mapped extents */
@@ -1447,6 +1450,9 @@
 int fiemap_check_flags(struct fiemap_extent_info *fieinfo, u32 fs_flags);
 int fiemapfs_check_flags(struct fiemap_extent_info *fieinfo, u32 fs_flags);
 
+int fiemap_check_ranges(struct super_block *sb,
+			u64 start, u64 len, u64 *new_len);
+
 /*
  * File types
  *

----------------------------------------------------------------------------------------

--- a/fs/xfs/xfs_ioctl.c	2015-01-29 17:55:05.452904504 +0530
+++ b/fs/xfs/xfs_ioctl.c	2015-01-29 17:50:40.852914441 +0530

@@ -1509,6 +1509,58 @@
 	return error;
 }
 
+/*
+ * Mostly similar to ioctl_fiemap() function present
+ * in fs/ioctl.c
+ */
+static int
+xfs_ioctl_fiemapfs(
+	struct xfs_mount	*mp,
+	void			__user *arg)
+{
+	struct fiemap		fiemap;
+	u64			len;
+	int			error;
+
+	struct fiemap __user *ufiemap = (struct fiemap __user *) arg;
+	struct fiemap_extent_info fieinfo = { 0, };
+
+	if (copy_from_user(&fiemap, ufiemap, sizeof(fiemap)))
+		return -EFAULT;
+
+	if (fiemap.fm_extent_count > FIEMAP_MAX_EXTENTS)
+		return -EINVAL;
+
+	error = fiemap_check_ranges(mp->m_super, fiemap.fm_start, fiemap.fm_length,
+					&len);
+	if (error)
+		return error;
+
+	fieinfo.fi_flags = fiemap.fm_flags;
+	fieinfo.fi_extents_max = fiemap.fm_extent_count;
+	fieinfo.fi_extents_start = ufiemap->fm_extents;
+
+	if (fiemap.fm_extent_count != 0 &&
+		!access_ok(VERIFY_WRITE, fieinfo.fi_extents_start,
+			fieinfo.fi_extents_max * sizeof(struct fiemap_extent)))
+		return -EFAULT;
+
+	if (fiemap.fm_extent_count != 0 &&
+		(fiemap.fm_flags & FIEMAPFS_FLAG_FREESP_SIZE_HINT) &&
+		!access_ok(VERIFY_READ, fieinfo.fi_extents_start,
+			sizeof(struct fiemap_extent)))
+		return -EFAULT;
+
+	error = mp->m_super->s_op->fiemapfs(mp->m_super, &fieinfo, fiemap.fm_start,
+						len);
+
+	fiemap.fm_flags = fieinfo.fi_flags;
+	fiemap.fm_mapped_extents = fieinfo.fi_extents_mapped;
+	if (copy_to_user(ufiemap, &fiemap, sizeof(fiemap)))
+		error = -EFAULT;
+
+	return error;
+}
 
 /*
  * Note: some of the ioctl's return positive numbers as a
@@ -1566,6 +1618,9 @@
 		return 0;
 	}
 
+	case XFS_IOC_FIEMAPFS:
+		return xfs_ioctl_fiemapfs(mp, arg);
+
 	case XFS_IOC_FSBULKSTAT_SINGLE:
 	case XFS_IOC_FSBULKSTAT:
 	case XFS_IOC_FSINUMBERS:

----------------------------------------------------------------------------------------

--- a/fs/xfs/xfs_fs.h	2015-01-29 15:26:46.954401773 +0530
+++ b/fs/xfs/xfs_fs.h	2015-01-29 11:29:54.531652554 +0530

@@ -505,6 +505,7 @@
 #define XFS_IOC_DIOINFO	_IOR ('X', 30, struct dioattr)
 #define XFS_IOC_FSGETXATTR	_IOR ('X', 31, struct fsxattr)
 #define XFS_IOC_FSSETXATTR	_IOW ('X', 32, struct fsxattr)
+#define XFS_IOC_FIEMAPFS	_IOWR('X', 33, struct fiemap)
 #define XFS_IOC_ALLOCSP64	_IOW ('X', 36, struct xfs_flock64)
 #define XFS_IOC_FREESP64	_IOW ('X', 37, struct xfs_flock64)
 #define XFS_IOC_GETBMAP	_IOWR('X', 38, struct getbmap)

----------------------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
