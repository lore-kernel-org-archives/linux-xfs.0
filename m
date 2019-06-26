Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59498 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbfFZCgk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:36:40 -0400
Subject: [PATCH 3/5] vfs: flush and wait for io when setting the immutable
 flag via FSSETXATTR
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Jun 2019 19:33:16 -0700
Message-ID: <156151639615.2283603.2028690322950797383.stgit@magnolia>
In-Reply-To: <156151637248.2283603.8458727861336380714.stgit@magnolia>
References: <156151637248.2283603.8458727861336380714.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, darrick.wong@oracle.com, ard.biesheuvel@linaro.org, josef@toxicpanda.com, hch@infradead.org, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org
Cc: reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're using FS_IOC_FSSETXATTR to set the immutable flag on a file,
we need to ensure that userspace can't continue to write the file after
the file becomes immutable.  To make that happen, we have to flush all
the dirty pagecache pages to disk to ensure that we can fail a page
fault on a mmap'd region, wait for pending directio to complete, and
hope the caller locked out any new writes by holding the inode lock.

XFS has more complex locking than other FSSETXATTR implementations so we
have to keep the checking and preparation code in different functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/btrfs/ioctl.c   |    2 +
 fs/ext4/ioctl.c    |    2 +
 fs/f2fs/file.c     |    2 +
 fs/inode.c         |   31 +++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c |   71 +++++++++++++++++++++++++++++++++++++++-------------
 include/linux/fs.h |    3 ++
 6 files changed, 90 insertions(+), 21 deletions(-)


diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 0f5af7c5f66b..bbd6d908900e 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -423,7 +423,7 @@ static int btrfs_ioctl_fssetxattr(struct file *file, void __user *arg)
 	old_flags = binode->flags;
 	old_i_flags = inode->i_flags;
 
-	ret = vfs_ioc_fssetxattr_check(inode, &old_fa, &fa);
+	ret = vfs_ioc_fssetxattr_prepare(inode, &old_fa, &fa);
 	if (ret)
 		goto out_unlock;
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 1e88c3af9a8d..146587c3fe8e 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1109,7 +1109,7 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 		inode_lock(inode);
 		ext4_fill_fsxattr(inode, &old_fa);
-		err = vfs_ioc_fssetxattr_check(inode, &old_fa, &fa);
+		err = vfs_ioc_fssetxattr_prepare(inode, &old_fa, &fa);
 		if (err)
 			goto out;
 		flags = (ei->i_flags & ~EXT4_FL_XFLAG_VISIBLE) |
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d6ed319388d6..af0fc040a15c 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2826,7 +2826,7 @@ static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
 	inode_lock(inode);
 
 	f2fs_fill_fsxattr(inode, &old_fa);
-	err = vfs_ioc_fssetxattr_check(inode, &old_fa, &fa);
+	err = vfs_ioc_fssetxattr_prepare(inode, &old_fa, &fa);
 	if (err)
 		goto out;
 	flags = (fi->i_flags & ~F2FS_FL_XFLAG_VISIBLE) |
diff --git a/fs/inode.c b/fs/inode.c
index 65a412af3ffb..cf07378e5731 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2293,3 +2293,34 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 	return 0;
 }
 EXPORT_SYMBOL(vfs_ioc_fssetxattr_check);
+
+/*
+ * Generic function to check FS_IOC_FSSETXATTR values and reject any invalid
+ * configurations.  If none are found, flush all pending IO and dirty mappings
+ * before setting S_IMMUTABLE on an inode.  If the flush fails we'll clear the
+ * flag before returning error.
+ *
+ * Note: the caller must hold whatever locks are necessary to block any other
+ * threads from starting a write to the file.
+ */
+int vfs_ioc_fssetxattr_prepare(struct inode *inode,
+			       const struct fsxattr *old_fa,
+			       struct fsxattr *fa)
+{
+	int ret;
+
+	ret = vfs_ioc_fssetxattr_check(inode, old_fa, fa);
+	if (ret)
+		return ret;
+
+	if (!S_ISREG(inode->i_mode) || IS_IMMUTABLE(inode) ||
+	    !(fa->fsx_xflags & FS_XFLAG_IMMUTABLE))
+		return 0;
+
+	inode_set_flags(inode, S_IMMUTABLE, S_IMMUTABLE);
+	ret = inode_drain_writes(inode);
+	if (ret)
+		inode_set_flags(inode, 0, S_IMMUTABLE);
+	return ret;
+}
+EXPORT_SYMBOL(vfs_ioc_fssetxattr_prepare);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 011657bd50ca..723550c8a2e4 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1058,6 +1058,30 @@ xfs_ioctl_setattr_xflags(
 	return 0;
 }
 
+/*
+ * If we're setting immutable on a regular file, we need to prevent new writes.
+ * Once we've done that, we must wait for all the other writes to complete.
+ *
+ * The caller must use @join_flags to release the locks which are held on @ip
+ * regardless of return value.
+ */
+static int
+xfs_ioctl_setattr_drain_writes(
+	struct xfs_inode	*ip,
+	const struct fsxattr	*fa,
+	int			*join_flags)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	if (!S_ISREG(inode->i_mode) || !(fa->fsx_xflags & FS_XFLAG_IMMUTABLE))
+		return 0;
+
+	*join_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	xfs_ilock(ip, *join_flags);
+
+	return inode_drain_writes(inode);
+}
+
 /*
  * If we are changing DAX flags, we have to ensure the file is clean and any
  * cached objects in the address space are invalidated and removed. This
@@ -1065,6 +1089,9 @@ xfs_ioctl_setattr_xflags(
  * operation. The locks need to be held until the transaction has been committed
  * so that the cache invalidation is atomic with respect to the DAX flag
  * manipulation.
+ *
+ * The caller must use @join_flags to release the locks which are held on @ip
+ * regardless of return value.
  */
 static int
 xfs_ioctl_setattr_dax_invalidate(
@@ -1076,8 +1103,6 @@ xfs_ioctl_setattr_dax_invalidate(
 	struct super_block	*sb = inode->i_sb;
 	int			error;
 
-	*join_flags = 0;
-
 	/*
 	 * It is only valid to set the DAX flag on regular files and
 	 * directories on filesystems where the block size is equal to the page
@@ -1103,21 +1128,15 @@ xfs_ioctl_setattr_dax_invalidate(
 		return 0;
 
 	/* lock, flush and invalidate mapping in preparation for flag change */
-	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
-	error = filemap_write_and_wait(inode->i_mapping);
-	if (error)
-		goto out_unlock;
-	error = invalidate_inode_pages2(inode->i_mapping);
-	if (error)
-		goto out_unlock;
-
-	*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
-	return 0;
-
-out_unlock:
-	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
-	return error;
+	if (*join_flags == 0) {
+		*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
+		xfs_ilock(ip, *join_flags);
+		error = filemap_write_and_wait(inode->i_mapping);
+		if (error)
+			return error;
+	}
 
+	return invalidate_inode_pages2(inode->i_mapping);
 }
 
 /*
@@ -1326,6 +1345,12 @@ xfs_ioctl_setattr(
 			return code;
 	}
 
+	code = xfs_ioctl_setattr_drain_writes(ip, fa, &join_flags);
+	if (code) {
+		xfs_iunlock(ip, join_flags);
+		goto error_free_dquots;
+	}
+
 	/*
 	 * Changing DAX config may require inode locking for mapping
 	 * invalidation. These need to be held all the way to transaction commit
@@ -1334,8 +1359,10 @@ xfs_ioctl_setattr(
 	 * appropriately.
 	 */
 	code = xfs_ioctl_setattr_dax_invalidate(ip, fa, &join_flags);
-	if (code)
+	if (code) {
+		xfs_iunlock(ip, join_flags);
 		goto error_free_dquots;
+	}
 
 	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
 	if (IS_ERR(tp)) {
@@ -1485,6 +1512,12 @@ xfs_ioc_setxflags(
 	if (error)
 		return error;
 
+	error = xfs_ioctl_setattr_drain_writes(ip, &fa, &join_flags);
+	if (error) {
+		xfs_iunlock(ip, join_flags);
+		goto out_drop_write;
+	}
+
 	/*
 	 * Changing DAX config may require inode locking for mapping
 	 * invalidation. These need to be held all the way to transaction commit
@@ -1493,8 +1526,10 @@ xfs_ioc_setxflags(
 	 * appropriately.
 	 */
 	error = xfs_ioctl_setattr_dax_invalidate(ip, &fa, &join_flags);
-	if (error)
+	if (error) {
+		xfs_iunlock(ip, join_flags);
 		goto out_drop_write;
+	}
 
 	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
 	if (IS_ERR(tp)) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 51266c9dbadc..675ce9743bc1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3560,6 +3560,9 @@ int vfs_ioc_setflags_prepare(struct inode *inode, unsigned int oldflags,
 
 int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 			     struct fsxattr *fa);
+int vfs_ioc_fssetxattr_prepare(struct inode *inode,
+			       const struct fsxattr *old_fa,
+			       struct fsxattr *fa);
 
 /*
  * Flush file data before changing attributes.  Caller must hold any locks
