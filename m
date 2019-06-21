Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50084 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfFUX6s (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 19:58:48 -0400
Subject: [PATCH 2/7] vfs: flush and wait for io when setting the immutable
 flag via SETFLAGS
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jun 2019 16:57:07 -0700
Message-ID: <156116142734.1664939.5074567130774423066.stgit@magnolia>
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

When we're using FS_IOC_SETFLAGS to set the immutable flag on a file, we
need to ensure that userspace can't continue to write the file after the
file becomes immutable.  To make that happen, we have to flush all the
dirty pagecache pages to disk to ensure that we can fail a page fault on
a mmap'd region, wait for pending directio to complete, and hope the
caller locked out any new writes by holding the inode lock.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/btrfs/ioctl.c       |    3 +++
 fs/efivarfs/file.c     |    5 +++++
 fs/ext2/ioctl.c        |    5 +++++
 fs/ext4/ioctl.c        |    3 +++
 fs/f2fs/file.c         |    3 +++
 fs/hfsplus/ioctl.c     |    3 +++
 fs/nilfs2/ioctl.c      |    3 +++
 fs/ocfs2/ioctl.c       |    3 +++
 fs/orangefs/file.c     |   11 ++++++++---
 fs/orangefs/protocol.h |    3 +++
 fs/reiserfs/ioctl.c    |    3 +++
 fs/ubifs/ioctl.c       |    3 +++
 include/linux/fs.h     |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 13 files changed, 93 insertions(+), 3 deletions(-)


diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7ddda5b4b6a6..f431813b2454 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -214,6 +214,9 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	fsflags = btrfs_mask_fsflags_for_type(inode, fsflags);
 	old_fsflags = btrfs_inode_flags_to_fsflags(binode->flags);
 	ret = vfs_ioc_setflags_check(inode, old_fsflags, fsflags);
+	if (ret)
+		goto out_unlock;
+	ret = vfs_ioc_setflags_flush_data(inode, fsflags);
 	if (ret)
 		goto out_unlock;
 
diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index f4f6c1bec132..845016a67724 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -163,6 +163,11 @@ efivarfs_ioc_setxflags(struct file *file, void __user *arg)
 		return error;
 
 	inode_lock(inode);
+	error = vfs_ioc_setflags_flush_data(inode, flags);
+	if (error) {
+		inode_unlock(inode);
+		return error;
+	}
 	inode_set_flags(inode, i_flags, S_IMMUTABLE);
 	inode_unlock(inode);
 
diff --git a/fs/ext2/ioctl.c b/fs/ext2/ioctl.c
index 88b3b9720023..75f75619237c 100644
--- a/fs/ext2/ioctl.c
+++ b/fs/ext2/ioctl.c
@@ -65,6 +65,11 @@ long ext2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			inode_unlock(inode);
 			goto setflags_out;
 		}
+		ret = vfs_ioc_setflags_flush_data(inode, flags);
+		if (ret) {
+			inode_unlock(inode);
+			goto setflags_out;
+		}
 
 		flags = flags & EXT2_FL_USER_MODIFIABLE;
 		flags |= oldflags & ~EXT2_FL_USER_MODIFIABLE;
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 6aa1df1918f7..a05341b94d98 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -290,6 +290,9 @@ static int ext4_ioctl_setflags(struct inode *inode,
 	jflag = flags & EXT4_JOURNAL_DATA_FL;
 
 	err = vfs_ioc_setflags_check(inode, oldflags, flags);
+	if (err)
+		goto flags_out;
+	err = vfs_ioc_setflags_flush_data(inode, flags);
 	if (err)
 		goto flags_out;
 
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 183ed1ac60e1..d3cf4bdb8738 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1681,6 +1681,9 @@ static int __f2fs_ioc_setflags(struct inode *inode, unsigned int flags)
 	oldflags = fi->i_flags;
 
 	err = vfs_ioc_setflags_check(inode, oldflags, flags);
+	if (err)
+		return err;
+	err = vfs_ioc_setflags_flush_data(inode, flags);
 	if (err)
 		return err;
 
diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
index 862a3c9481d7..f8295fa35237 100644
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -104,6 +104,9 @@ static int hfsplus_ioctl_setflags(struct file *file, int __user *user_flags)
 	inode_lock(inode);
 
 	err = vfs_ioc_setflags_check(inode, oldflags, flags);
+	if (err)
+		goto out_unlock_inode;
+	err = vfs_ioc_setflags_flush_data(inode, flags);
 	if (err)
 		goto out_unlock_inode;
 
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 0632336d2515..a3c200ab9f60 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -149,6 +149,9 @@ static int nilfs_ioctl_setflags(struct inode *inode, struct file *filp,
 	oldflags = NILFS_I(inode)->i_flags;
 
 	ret = vfs_ioc_setflags_check(inode, oldflags, flags);
+	if (ret)
+		goto out;
+	ret = vfs_ioc_setflags_flush_data(inode, flags);
 	if (ret)
 		goto out;
 
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 467a2faf0305..e91ca0dad3d7 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -107,6 +107,9 @@ static int ocfs2_set_inode_attr(struct inode *inode, unsigned flags,
 	flags |= oldflags & ~mask;
 
 	status = vfs_ioc_setflags_check(inode, oldflags, flags);
+	if (status)
+		goto bail_unlock;
+	status = vfs_ioc_setflags_flush_data(inode, flags);
 	if (status)
 		goto bail_unlock;
 
diff --git a/fs/orangefs/file.c b/fs/orangefs/file.c
index a35c17017210..fec5dfbc3dac 100644
--- a/fs/orangefs/file.c
+++ b/fs/orangefs/file.c
@@ -389,6 +389,8 @@ static long orangefs_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 			     (unsigned long long)uval);
 		return put_user(uval, (int __user *)arg);
 	} else if (cmd == FS_IOC_SETFLAGS) {
+		struct inode *inode = file_inode(file);
+
 		ret = 0;
 		if (get_user(uval, (int __user *)arg))
 			return -EFAULT;
@@ -399,11 +401,14 @@ static long orangefs_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		 * the flags and then updates the flags with some new
 		 * settings. So, we ignore it in the following edit. bligon.
 		 */
-		if ((uval & ~ORANGEFS_MIRROR_FL) &
-		    (~(FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NOATIME_FL))) {
+		if ((uval & ~ORANGEFS_MIRROR_FL) & ~ORANGEFS_VFS_FL) {
 			gossip_err("orangefs_ioctl: the FS_IOC_SETFLAGS only supports setting one of FS_IMMUTABLE_FL|FS_APPEND_FL|FS_NOATIME_FL\n");
 			return -EINVAL;
 		}
+		ret = vfs_ioc_setflags_flush_data(inode,
+						  uval & ORANGEFS_VFS_FL);
+		if (ret)
+			goto out;
 		val = uval;
 		gossip_debug(GOSSIP_FILE_DEBUG,
 			     "orangefs_ioctl: FS_IOC_SETFLAGS: %llu\n",
@@ -412,7 +417,7 @@ static long orangefs_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 					      "user.pvfs2.meta_hint",
 					      &val, sizeof(val), 0);
 	}
-
+out:
 	return ret;
 }
 
diff --git a/fs/orangefs/protocol.h b/fs/orangefs/protocol.h
index d403cf29a99b..3dbe1c4534ce 100644
--- a/fs/orangefs/protocol.h
+++ b/fs/orangefs/protocol.h
@@ -129,6 +129,9 @@ static inline void ORANGEFS_khandle_from(struct orangefs_khandle *kh,
 #define ORANGEFS_IMMUTABLE_FL FS_IMMUTABLE_FL
 #define ORANGEFS_APPEND_FL    FS_APPEND_FL
 #define ORANGEFS_NOATIME_FL   FS_NOATIME_FL
+#define ORANGEFS_VFS_FL				(FS_IMMUTABLE_FL | \
+						 FS_APPEND_FL | \
+						 FS_NOATIME_FL)
 #define ORANGEFS_MIRROR_FL    0x01000000ULL
 #define ORANGEFS_FS_ID_NULL       ((__s32)0)
 #define ORANGEFS_ATTR_SYS_UID                   (1 << 0)
diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index 92bcb1ecd994..50494f54392c 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -77,6 +77,9 @@ long reiserfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			err = vfs_ioc_setflags_check(inode,
 						     REISERFS_I(inode)->i_attrs,
 						     flags);
+			if (err)
+				goto setflags_out;
+			err = vfs_ioc_setflags_flush_data(inode, flags);
 			if (err)
 				goto setflags_out;
 			if ((flags & REISERFS_NOTAIL_FL) &&
diff --git a/fs/ubifs/ioctl.c b/fs/ubifs/ioctl.c
index bdea836fc38b..ff4a43314599 100644
--- a/fs/ubifs/ioctl.c
+++ b/fs/ubifs/ioctl.c
@@ -110,6 +110,9 @@ static int setflags(struct inode *inode, int flags)
 	mutex_lock(&ui->ui_mutex);
 	oldflags = ubifs2ioctl(ui->flags);
 	err = vfs_ioc_setflags_check(inode, oldflags, flags);
+	if (err)
+		goto out_unlock;
+	err = vfs_ioc_setflags_flush_data(inode, flags);
 	if (err)
 		goto out_unlock;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0c3ef24afe22..ed9a74cf5ef3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3557,7 +3557,55 @@ static inline struct sock *io_uring_get_socket(struct file *file)
 
 int vfs_ioc_setflags_check(struct inode *inode, int oldflags, int flags);
 
+/*
+ * Do we need to flush the file data before changing attributes?  When we're
+ * setting the immutable flag we must stop all directio writes and flush the
+ * dirty pages so that we can fail the page fault on the next write attempt.
+ */
+static inline bool vfs_ioc_setflags_need_flush(struct inode *inode, int flags)
+{
+	if (S_ISREG(inode->i_mode) && !IS_IMMUTABLE(inode) &&
+	    (flags & FS_IMMUTABLE_FL))
+		return true;
+
+	return false;
+}
+
+/*
+ * Flush file data before changing attributes.  Caller must hold any locks
+ * required to prevent further writes to this file until we're done setting
+ * flags.
+ */
+static inline int inode_flush_data(struct inode *inode)
+{
+	inode_dio_wait(inode);
+	return filemap_write_and_wait(inode->i_mapping);
+}
+
+/*
+ * Flush all pending IO and dirty mappings before setting S_IMMUTABLE on an
+ * inode via FS_IOC_SETFLAGS.  If the flush fails we'll clear the flag before
+ * returning error.
+ *
+ * Note: the caller should be holding i_mutex, or else be sure that
+ * they have exclusive access to the inode structure.
+ */
+static inline int vfs_ioc_setflags_flush_data(struct inode *inode, int flags)
+{
+	int ret;
+
+	if (!vfs_ioc_setflags_need_flush(inode, flags))
+		return 0;
+
+	inode_set_flags(inode, S_IMMUTABLE, S_IMMUTABLE);
+	ret = inode_flush_data(inode);
+	if (ret)
+		inode_set_flags(inode, 0, S_IMMUTABLE);
+	return ret;
+}
+
 int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 			     struct fsxattr *fa);
 
+
 #endif /* _LINUX_FS_H */
