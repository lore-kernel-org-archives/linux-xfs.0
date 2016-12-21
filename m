Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46242 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964944AbcLUREQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:16 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 18/30] ext4: convert to new i_version API
Date: Wed, 21 Dec 2016 12:03:35 -0500
Message-Id: <1482339827-7882-19-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ext4/dir.c    |  8 ++++----
 fs/ext4/inline.c |  6 +++---
 fs/ext4/inode.c  | 12 ++++++++----
 fs/ext4/ioctl.c  |  2 +-
 fs/ext4/namei.c  |  8 ++++----
 fs/ext4/super.c  |  2 +-
 6 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index e8b365000d73..cd84f15d3d41 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -207,7 +207,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 		 * readdir(2), then we might be pointing to an invalid
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
-		if (file->f_version != inode->i_version) {
+		if (inode_cmp_iversion(inode, file->f_version)) {
 			for (i = 0; i < sb->s_blocksize && i < offset; ) {
 				de = (struct ext4_dir_entry_2 *)
 					(bh->b_data + i);
@@ -226,7 +226,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			offset = i;
 			ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1))
 				| offset;
-			file->f_version = inode->i_version;
+			file->f_version = inode_get_iversion(inode);
 		}
 
 		while (ctx->pos < inode->i_size
@@ -567,10 +567,10 @@ static int ext4_dx_readdir(struct file *file, struct dir_context *ctx)
 		 * cached entries.
 		 */
 		if ((!info->curr_node) ||
-		    (file->f_version != inode->i_version)) {
+		    inode_cmp_iversion(inode, file->f_version)) {
 			info->curr_node = NULL;
 			free_rb_tree_fname(&info->root);
-			file->f_version = inode->i_version;
+			file->f_version = inode_get_iversion(inode);
 			ret = ext4_htree_fill_tree(file, info->curr_hash,
 						   info->curr_minor_hash,
 						   &info->next_hash);
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 437df6a1a841..6a3d173cb9ec 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1042,7 +1042,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 	 */
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	ext4_update_dx_flag(dir);
-	dir->i_version++;
+	inode_inc_iversion_locked(dir);
 	ext4_mark_inode_dirty(handle, dir);
 	return 1;
 }
@@ -1496,7 +1496,7 @@ int ext4_read_inline_dir(struct file *file,
 	 * dirent right now.  Scan from the start of the inline
 	 * dir to make sure.
 	 */
-	if (file->f_version != inode->i_version) {
+	if (inode_cmp_iversion(inode, file->f_version)) {
 		for (i = 0; i < extra_size && i < offset;) {
 			/*
 			 * "." is with offset 0 and
@@ -1528,7 +1528,7 @@ int ext4_read_inline_dir(struct file *file,
 		}
 		offset = i;
 		ctx->pos = offset;
-		file->f_version = inode->i_version;
+		file->f_version = inode_get_iversion(inode);
 	}
 
 	while (ctx->pos < extra_size) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 88d57af1b516..5603e1782c65 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4709,12 +4709,14 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	EXT4_EINODE_GET_XTIME(i_crtime, ei, raw_inode);
 
 	if (likely(!test_opt2(inode->i_sb, HURD_COMPAT))) {
-		inode->i_version = le32_to_cpu(raw_inode->i_disk_version);
+		u64 ivers = le32_to_cpu(raw_inode->i_disk_version);
+
 		if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE) {
 			if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
-				inode->i_version |=
+				ivers |=
 		    (__u64)(le32_to_cpu(raw_inode->i_version_hi)) << 32;
 		}
+		inode_set_iversion_read(inode, ivers);
 	}
 
 	ret = 0;
@@ -5000,11 +5002,13 @@ static int ext4_do_update_inode(handle_t *handle,
 	}
 
 	if (likely(!test_opt2(inode->i_sb, HURD_COMPAT))) {
-		raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
+		u64 ivers = inode_get_iversion_raw(inode);
+
+		raw_inode->i_disk_version = cpu_to_le32(ivers);
 		if (ei->i_extra_isize) {
 			if (EXT4_FITS_IN_INODE(raw_inode, ei, i_version_hi))
 				raw_inode->i_version_hi =
-					cpu_to_le32(inode->i_version >> 32);
+					cpu_to_le32(ivers >> 32);
 			raw_inode->i_extra_isize =
 				cpu_to_le16(ei->i_extra_isize);
 		}
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index fb844da4836f..7e1d56e3def0 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -139,7 +139,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		i_gid_write(inode_bl, 0);
 		inode_bl->i_flags = 0;
 		ei_bl->i_flags = 0;
-		inode_bl->i_version = 1;
+		inode_set_iversion(inode_bl, 1);
 		i_size_write(inode_bl, 0);
 		inode_bl->i_mode = S_IFREG;
 		if (ext4_has_feature_extents(sb)) {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index eadba919f26b..a8f812162dd6 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1943,7 +1943,7 @@ static int add_dirent_to_buf(handle_t *handle, struct ext4_filename *fname,
 	 */
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	ext4_update_dx_flag(dir);
-	dir->i_version++;
+	inode_inc_iversion_locked(dir);
 	ext4_mark_inode_dirty(handle, dir);
 	BUFFER_TRACE(bh, "call ext4_handle_dirty_metadata");
 	err = ext4_handle_dirty_dirent_node(handle, dir, bh);
@@ -2350,7 +2350,7 @@ int ext4_generic_delete_entry(handle_t *handle,
 					blocksize);
 			else
 				de->inode = 0;
-			dir->i_version++;
+			inode_inc_iversion_locked(dir);
 			return 0;
 		}
 		i += ext4_rec_len_from_disk(de->rec_len, blocksize);
@@ -2980,7 +2980,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 			     "empty directory '%.*s' has too many links (%u)",
 			     dentry->d_name.len, dentry->d_name.name,
 			     inode->i_nlink);
-	inode->i_version++;
+	inode_inc_iversion_locked(inode);
 	clear_nlink(inode);
 	/* There's no need to set i_disksize: the fact that i_nlink is
 	 * zero will ensure that the right thing happens during any
@@ -3379,7 +3379,7 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 	ent->de->inode = cpu_to_le32(ino);
 	if (ext4_has_feature_filetype(ent->dir->i_sb))
 		ent->de->file_type = file_type;
-	ent->dir->i_version++;
+	inode_inc_iversion(ent->dir);
 	ent->dir->i_ctime = ent->dir->i_mtime =
 		current_time(ent->dir);
 	ext4_mark_inode_dirty(handle, ent->dir);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 63a6b6332682..7938d852733b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -921,7 +921,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	if (!ei)
 		return NULL;
 
-	ei->vfs_inode.i_version = 1;
+	inode_set_iversion(&ei->vfs_inode, 1);
 	spin_lock_init(&ei->i_raw_lock);
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
-- 
2.7.4

