Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42168 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938318AbcLUREM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:12 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 25/30] fs: add a "force" parameter to inode_inc_iversion
Date: Wed, 21 Dec 2016 12:03:42 -0500
Message-Id: <1482339827-7882-26-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

In some coming changes, we will want to avoid changing the i_version
counter in some cases as that may allow us to avoid having to log a
metadata change to the inode. In other cases we will want to forcibly
change it even when it's not strictly required (i.e. if we're going to
log a time change to disk anyway).

Add a parameter to tell the incrementing routine to forcibly bump the
counter. For now, everyone sets this to "true" and the value is ignored,
but later patches will change this.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/btrfs/file.c    |  4 ++--
 fs/btrfs/inode.c   | 34 +++++++++++++++++-----------------
 fs/btrfs/ioctl.c   |  4 ++--
 fs/btrfs/xattr.c   |  2 +-
 fs/ext2/super.c    |  2 +-
 fs/ext4/inode.c    |  4 ++--
 fs/ext4/namei.c    |  2 +-
 fs/inode.c         |  2 +-
 fs/ocfs2/namei.c   |  2 +-
 include/linux/fs.h |  2 +-
 10 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index b5c5da215d05..f301afaf9af5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1804,7 +1804,7 @@ static void update_time_for_write(struct inode *inode)
 		inode->i_ctime = now;
 
 	if (IS_I_VERSION(inode))
-		inode_inc_iversion(inode);
+		inode_inc_iversion(inode, true);
 }
 
 static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
@@ -2636,7 +2636,7 @@ static int btrfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	if (!trans)
 		goto out_free;
 
-	inode_inc_iversion(inode);
+	inode_inc_iversion(inode, true);
 	inode->i_mtime = inode->i_ctime = current_time(inode);
 
 	trans->block_rsv = &fs_info->trans_block_rsv;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a56a45a3e992..a03e5a1d5e05 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4086,8 +4086,8 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		goto out;
 
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
-	inode_inc_iversion(inode);
-	inode_inc_iversion(dir);
+	inode_inc_iversion(inode, true);
+	inode_inc_iversion(dir, true);
 	inode->i_ctime = dir->i_mtime =
 		dir->i_ctime = current_time(inode);
 	ret = btrfs_update_inode(trans, root, dir);
@@ -4232,7 +4232,7 @@ int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 	}
 
 	btrfs_i_size_write(dir, dir->i_size - name_len * 2);
-	inode_inc_iversion(dir);
+	inode_inc_iversion(dir, true);
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	ret = btrfs_update_inode_fallback(trans, root, dir);
 	if (ret)
@@ -5000,7 +5000,7 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 	 * explicitly if it wants a timestamp update.
 	 */
 	if (newsize != oldsize) {
-		inode_inc_iversion(inode);
+		inode_inc_iversion(inode, true);
 		if (!(mask & (ATTR_CTIME | ATTR_MTIME)))
 			inode->i_ctime = inode->i_mtime =
 				current_time(inode);
@@ -5122,7 +5122,7 @@ static int btrfs_setattr(struct dentry *dentry, struct iattr *attr)
 
 	if (attr->ia_valid) {
 		setattr_copy(inode, attr);
-		inode_inc_iversion(inode);
+		inode_inc_iversion(inode, true);
 		err = btrfs_dirty_inode(inode);
 
 		if (!err && attr->ia_valid & ATTR_MODE)
@@ -6030,7 +6030,7 @@ static int btrfs_update_time(struct inode *inode, struct timespec *now,
 		return -EROFS;
 
 	if (flags & S_VERSION)
-		inode_inc_iversion(inode);
+		inode_inc_iversion(inode, true);
 	if (flags & S_CTIME)
 		inode->i_ctime = *now;
 	if (flags & S_MTIME)
@@ -6354,7 +6354,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 
 	btrfs_i_size_write(parent_inode, parent_inode->i_size +
 			   name_len * 2);
-	inode_inc_iversion(parent_inode);
+	inode_inc_iversion(parent_inode, true);
 	parent_inode->i_mtime = parent_inode->i_ctime =
 		current_time(parent_inode);
 	ret = btrfs_update_inode(trans, root, parent_inode);
@@ -6576,7 +6576,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	/* There are several dir indexes for this inode, clear the cache. */
 	BTRFS_I(inode)->dir_index = 0ULL;
 	inc_nlink(inode);
-	inode_inc_iversion(inode);
+	inode_inc_iversion(inode, true);
 	inode->i_ctime = current_time(inode);
 	ihold(inode);
 	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
@@ -9576,10 +9576,10 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	}
 
 	/* Update inode version and ctime/mtime. */
-	inode_inc_iversion(old_dir);
-	inode_inc_iversion(new_dir);
-	inode_inc_iversion(old_inode);
-	inode_inc_iversion(new_inode);
+	inode_inc_iversion(old_dir, true);
+	inode_inc_iversion(new_dir, true);
+	inode_inc_iversion(old_inode, true);
+	inode_inc_iversion(new_inode, true);
 	old_dir->i_ctime = old_dir->i_mtime = ctime;
 	new_dir->i_ctime = new_dir->i_mtime = ctime;
 	old_inode->i_ctime = ctime;
@@ -9858,9 +9858,9 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto out_fail;
 	}
 
-	inode_inc_iversion(old_dir);
-	inode_inc_iversion(new_dir);
-	inode_inc_iversion(old_inode);
+	inode_inc_iversion(old_dir, true);
+	inode_inc_iversion(new_dir, true);
+	inode_inc_iversion(old_inode, true);
 	old_dir->i_ctime = old_dir->i_mtime =
 	new_dir->i_ctime = new_dir->i_mtime =
 	old_inode->i_ctime = current_time(old_dir);
@@ -9887,7 +9887,7 @@ static int btrfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	}
 
 	if (new_inode) {
-		inode_inc_iversion(new_inode);
+		inode_inc_iversion(new_inode, true);
 		new_inode->i_ctime = current_time(new_inode);
 		if (unlikely(btrfs_ino(new_inode) ==
 			     BTRFS_EMPTY_SUBVOL_DIR_OBJECTID)) {
@@ -10408,7 +10408,7 @@ static int __btrfs_prealloc_file_range(struct inode *inode, int mode,
 		cur_offset += ins.offset;
 		*alloc_hint = ins.objectid + ins.offset;
 
-		inode_inc_iversion(inode);
+		inode_inc_iversion(inode, true);
 		inode->i_ctime = current_time(inode);
 		BTRFS_I(inode)->flags |= BTRFS_INODE_PREALLOC;
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 33f967d30b2a..c2d845b73e58 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -348,7 +348,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	}
 
 	btrfs_update_iflags(inode);
-	inode_inc_iversion(inode);
+	inode_inc_iversion(inode, true);
 	inode->i_ctime = current_time(inode);
 	ret = btrfs_update_inode(trans, root, inode);
 
@@ -3294,7 +3294,7 @@ static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
-	inode_inc_iversion(inode);
+	inode_inc_iversion(inode, true);
 	if (!no_time_update)
 		inode->i_mtime = inode->i_ctime = current_time(inode);
 	/*
diff --git a/fs/btrfs/xattr.c b/fs/btrfs/xattr.c
index 9621c7f2503e..b9a5475754b8 100644
--- a/fs/btrfs/xattr.c
+++ b/fs/btrfs/xattr.c
@@ -253,7 +253,7 @@ int __btrfs_setxattr(struct btrfs_trans_handle *trans,
 	if (ret)
 		goto out;
 
-	inode_inc_iversion(inode);
+	inode_inc_iversion(inode, true);
 	inode->i_ctime = current_time(inode);
 	set_bit(BTRFS_INODE_COPY_EVERYTHING, &BTRFS_I(inode)->runtime_flags);
 	ret = btrfs_update_inode(trans, root, inode);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 5c9ba3b3f77b..db8251e9fbd9 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1542,7 +1542,7 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 		return err;
 	if (inode->i_size < off+len-towrite)
 		i_size_write(inode, off+len-towrite);
-	inode_inc_iversion(inode);
+	inode_inc_iversion(inode, true);
 	inode->i_mtime = inode->i_ctime = current_time(inode);
 	mark_inode_dirty(inode);
 	return len - towrite;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5603e1782c65..cd1c255944b3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5253,7 +5253,7 @@ int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 			return -EINVAL;
 
 		if (IS_I_VERSION(inode) && attr->ia_size != inode->i_size)
-			inode_inc_iversion(inode);
+			inode_inc_iversion(inode, true);
 
 		if (ext4_should_order_data(inode) &&
 		    (attr->ia_size < inode->i_size)) {
@@ -5488,7 +5488,7 @@ int ext4_mark_iloc_dirty(handle_t *handle,
 	int err = 0;
 
 	if (IS_I_VERSION(inode))
-		inode_inc_iversion(inode);
+		inode_inc_iversion(inode, true);
 
 	/* the do_update_inode consumes one bh->b_count */
 	get_bh(iloc->bh);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index a8f812162dd6..3c5110817a55 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3379,7 +3379,7 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 	ent->de->inode = cpu_to_le32(ino);
 	if (ext4_has_feature_filetype(ent->dir->i_sb))
 		ent->de->file_type = file_type;
-	inode_inc_iversion(ent->dir);
+	inode_inc_iversion(ent->dir, true);
 	ent->dir->i_ctime = ent->dir->i_mtime =
 		current_time(ent->dir);
 	ext4_mark_inode_dirty(handle, ent->dir);
diff --git a/fs/inode.c b/fs/inode.c
index 88110fd0b282..2484d91ae8ef 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1625,7 +1625,7 @@ int generic_update_time(struct inode *inode, struct timespec *time, int flags)
 	if (flags & S_ATIME)
 		inode->i_atime = *time;
 	if (flags & S_VERSION)
-		inode_inc_iversion(inode);
+		inode_inc_iversion(inode, true);
 	if (flags & S_CTIME)
 		inode->i_ctime = *time;
 	if (flags & S_MTIME)
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index c045826b716a..387cfa36c7b7 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1520,7 +1520,7 @@ static int ocfs2_rename(struct inode *old_dir,
 			mlog_errno(status);
 			goto bail;
 		}
-		inode_inc_iversion(new_dir);
+		inode_inc_iversion(new_dir, true);
 
 		if (S_ISDIR(new_inode->i_mode))
 			ocfs2_set_links_count(newfe, 0);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 075c915fe2b1..75323e7b6954 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2013,7 +2013,7 @@ inode_set_iversion_read(struct inode *inode, const u64 new)
  * The filesystem has to be mounted with MS_I_VERSION flag.
  */
 static inline bool
-inode_inc_iversion(struct inode *inode)
+inode_inc_iversion(struct inode *inode, bool force)
 {
 	spin_lock(&inode->i_lock);
 	inode_inc_iversion_locked(inode);
-- 
2.7.4

