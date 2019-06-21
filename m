Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36844 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfFUX62 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 19:58:28 -0400
Subject: [PATCH 3/7] vfs: flush and wait for io when setting the immutable
 flag via FSSETXATTR
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jun 2019 16:57:15 -0700
Message-ID: <156116143526.1664939.6767366095685084430.stgit@magnolia>
In-Reply-To: <156116141046.1664939.11424021489724835645.stgit@magnolia>
References: <156116141046.1664939.11424021489724835645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu, darrick.wong@oracle.com, ard.biesheuvel@linaro.org, josef@toxicpanda.com, clm@fb.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org, jk@ozlabs.org
Cc: reiserfs-devel@vger.kernel.org, linux-efi@vger.kernel.org, devel@lists.orangefs.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're using FS_IOC_FSSETXATTR to set the immutable flag on a file,
we need to ensure that userspace can't continue to write the file after
the file becomes immutable.  To make that happen, we have to flush all
the dirty pagecache pages to disk to ensure that we can fail a page
fault on a mmap'd region, wait for pending directio to complete, and
hope the caller locked out any new writes by holding the inode lock.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/btrfs/ioctl.c   |    3 +++
 fs/ext4/ioctl.c    |    3 +++
 fs/f2fs/file.c     |    3 +++
 fs/xfs/xfs_ioctl.c |   39 +++++++++++++++++++++++++++++++++------
 include/linux/fs.h |   37 +++++++++++++++++++++++++++++++++++++
 5 files changed, 79 insertions(+), 6 deletions(-)


diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index f431813b2454..63a9281e6ce0 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -432,6 +432,9 @@ static int btrfs_ioctl_fssetxattr(struct file *file, void __user *arg)
 
 	__btrfs_ioctl_fsgetxattr(binode, &old_fa);
 	ret = vfs_ioc_fssetxattr_check(inode, &old_fa, &fa);
+	if (ret)
+		goto out_unlock;
+	ret = vfs_ioc_fssetxattr_flush_data(inode, &fa);
 	if (ret)
 		goto out_unlock;
 
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a05341b94d98..6037585c1520 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -1115,6 +1115,9 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		inode_lock(inode);
 		ext4_fsgetxattr(inode, &old_fa);
 		err = vfs_ioc_fssetxattr_check(inode, &old_fa, &fa);
+		if (err)
+			goto out;
+		err = vfs_ioc_fssetxattr_flush_data(inode, &fa);
 		if (err)
 			goto out;
 		flags = (ei->i_flags & ~EXT4_FL_XFLAG_VISIBLE) |
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d3cf4bdb8738..97f4bb36540f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2832,6 +2832,9 @@ static int f2fs_ioc_fssetxattr(struct file *filp, unsigned long arg)
 
 	__f2fs_ioc_fsgetxattr(inode, &old_fa);
 	err = vfs_ioc_fssetxattr_check(inode, &old_fa, &fa);
+	if (err)
+		goto out;
+	err = vfs_ioc_fssetxattr_flush_data(inode, &fa);
 	if (err)
 		goto out;
 	flags = (fi->i_flags & ~F2FS_FL_XFLAG_VISIBLE) |
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index b494e7e881e3..88583b3e1e76 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1014,6 +1014,28 @@ xfs_diflags_to_linux(
 #endif
 }
 
+/*
+ * Lock the inode against file io and page faults, then flush all dirty pages
+ * and wait for writeback and direct IO operations to finish.  Returns with
+ * the relevant inode lock flags set in @join_flags.  Caller is responsible for
+ * unlocking even on error return.
+ */
+static int
+xfs_ioctl_setattr_flush(
+	struct xfs_inode	*ip,
+	int			*join_flags)
+{
+	/* Already locked the inode from IO?  Assume we're done. */
+	if (((*join_flags) & (XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL)) ==
+			     (XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL))
+		return 0;
+
+	/* Lock and flush all mappings and IO in preparation for flag change */
+	*join_flags = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	xfs_ilock(ip, *join_flags);
+	return inode_flush_data(VFS_I(ip));
+}
+
 static int
 xfs_ioctl_setattr_xflags(
 	struct xfs_trans	*tp,
@@ -1099,23 +1121,22 @@ xfs_ioctl_setattr_dax_invalidate(
 	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
 		return 0;
 
-	if (S_ISDIR(inode->i_mode))
+	if (!S_ISREG(inode->i_mode))
 		return 0;
 
-	/* lock, flush and invalidate mapping in preparation for flag change */
-	xfs_ilock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
-	error = filemap_write_and_wait(inode->i_mapping);
+	error = xfs_ioctl_setattr_flush(ip, join_flags);
 	if (error)
 		goto out_unlock;
 	error = invalidate_inode_pages2(inode->i_mapping);
 	if (error)
 		goto out_unlock;
 
-	*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
 	return 0;
 
 out_unlock:
-	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL);
+	if (*join_flags)
+		xfs_iunlock(ip, *join_flags);
+	*join_flags = 0;
 	return error;
 
 }
@@ -1337,6 +1358,12 @@ xfs_ioctl_setattr(
 	if (code)
 		goto error_free_dquots;
 
+	if (!join_flags && vfs_ioc_fssetxattr_need_flush(VFS_I(ip), fa)) {
+		code = xfs_ioctl_setattr_flush(ip, &join_flags);
+		if (code)
+			goto error_free_dquots;
+	}
+
 	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
 	if (IS_ERR(tp)) {
 		code = PTR_ERR(tp);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ed9a74cf5ef3..b4553d01e254 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3607,5 +3607,42 @@ static inline int vfs_ioc_setflags_flush_data(struct inode *inode, int flags)
 int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 			     struct fsxattr *fa);
 
+/*
+ * Do we need to flush the file data before changing attributes?  When we're
+ * setting the immutable flag we must stop all directio writes and flush the
+ * dirty pages so that we can fail the page fault on the next write attempt.
+ */
+static inline bool vfs_ioc_fssetxattr_need_flush(struct inode *inode,
+						 struct fsxattr *fa)
+{
+	if (S_ISREG(inode->i_mode) && !IS_IMMUTABLE(inode) &&
+	    (fa->fsx_xflags & FS_XFLAG_IMMUTABLE))
+		return true;
+
+	return false;
+}
+
+/*
+ * Flush all pending IO and dirty mappings before setting S_IMMUTABLE on an
+ * inode via FS_IOC_SETXATTR.  If the flush fails we'll clear the flag before
+ * returning error.
+ *
+ * Note: the caller should be holding i_mutex, or else be sure that
+ * they have exclusive access to the inode structure.
+ */
+static inline int vfs_ioc_fssetxattr_flush_data(struct inode *inode,
+						struct fsxattr *fa)
+{
+	int ret;
+
+	if (!vfs_ioc_fssetxattr_need_flush(inode, fa))
+		return 0;
+
+	inode_set_flags(inode, S_IMMUTABLE, S_IMMUTABLE);
+	ret = inode_flush_data(inode);
+	if (ret)
+		inode_set_flags(inode, 0, S_IMMUTABLE);
+	return ret;
+}
 
 #endif /* _LINUX_FS_H */
