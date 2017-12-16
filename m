Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756922AbdLPNrW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 08:47:22 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 09/19] ext4: convert to new i_version API
Date: Sat, 16 Dec 2017 08:46:46 -0500
Message-Id: <20171216134656.15561-10-jlayton@kernel.org>
In-Reply-To: <20171216134656.15561-1-jlayton@kernel.org>
References: <20171216134656.15561-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

From: Jeff Layton <jlayton@redhat.com>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/dir.c    |  8 ++++----
 fs/ext4/inline.c |  6 +++---
 fs/ext4/inode.c  | 12 ++++++++----
 fs/ext4/ioctl.c  |  2 +-
 fs/ext4/namei.c  |  4 ++--
 fs/ext4/super.c  |  2 +-
 fs/ext4/xattr.c  |  4 ++--
 7 files changed, 21 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index d5babc9f222b..18eb37395a45 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -208,7 +208,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 		 * readdir(2), then we might be pointing to an invalid
 		 * dirent right now.  Scan from the start of the block
 		 * to make sure. */
-		if (file->f_version != inode->i_version) {
+		if (inode_cmp_iversion(inode, file->f_version)) {
 			for (i = 0; i < sb->s_blocksize && i < offset; ) {
 				de = (struct ext4_dir_entry_2 *)
 					(bh->b_data + i);
@@ -227,7 +227,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			offset = i;
 			ctx->pos = (ctx->pos & ~(sb->s_blocksize - 1))
 				| offset;
-			file->f_version = inode->i_version;
+			file->f_version = inode_query_iversion(inode);
 		}
 
 		while (ctx->pos < inode->i_size
@@ -568,10 +568,10 @@ static int ext4_dx_readdir(struct file *file, struct dir_context *ctx)
 		 * cached entries.
 		 */
 		if ((!info->curr_node) ||
-		    (file->f_version != inode->i_version)) {
+		    inode_cmp_iversion(inode, file->f_version)) {
 			info->curr_node = NULL;
 			free_rb_tree_fname(&info->root);
-			file->f_version = inode->i_version;
+			file->f_version = inode_query_iversion(inode);
 			ret = ext4_htree_fill_tree(file, info->curr_hash,
 						   info->curr_minor_hash,
 						   &info->next_hash);
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 1367553c43bb..a4a621eb80c1 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1042,7 +1042,7 @@ static int ext4_add_dirent_to_inline(handle_t *handle,
 	 */
 	dir->i_mtime = dir->i_ctime = current_time(dir);
 	ext4_update_dx_flag(dir);
-	dir->i_version++;
+	inode_inc_iversion(dir);
 	return 1;
 }
 
@@ -1494,7 +1494,7 @@ int ext4_read_inline_dir(struct file *file,
 	 * dirent right now.  Scan from the start of the inline
 	 * dir to make sure.
 	 */
-	if (file->f_version != inode->i_version) {
+	if (inode_cmp_iversion(inode, file->f_version)) {
 		for (i = 0; i < extra_size && i < offset;) {
 			/*
 			 * "." is with offset 0 and
@@ -1526,7 +1526,7 @@ int ext4_read_inline_dir(struct file *file,
 		}
 		offset = i;
 		ctx->pos = offset;
-		file->f_version = inode->i_version;
+		file->f_version = inode_query_iversion(inode);
 	}
 
 	while (ctx->pos < extra_size) {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7df2c5644e59..1f8ec9cd042c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4873,12 +4873,14 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
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
+		inode_set_iversion_queried(inode, ivers);
 	}
 
 	ret = 0;
@@ -5164,11 +5166,13 @@ static int ext4_do_update_inode(handle_t *handle,
 	}
 
 	if (likely(!test_opt2(inode->i_sb, HURD_COMPAT))) {
-		raw_inode->i_disk_version = cpu_to_le32(inode->i_version);
+		u64 ivers = inode_peek_iversion(inode);
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
index 1eec25014f62..f2bed34869cd 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -144,7 +144,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		i_gid_write(inode_bl, 0);
 		inode_bl->i_flags = 0;
 		ei_bl->i_flags = 0;
-		inode_bl->i_version = 1;
+		inode_set_iversion(inode_bl, 1);
 		i_size_write(inode_bl, 0);
 		inode_bl->i_mode = S_IFREG;
 		if (ext4_has_feature_extents(sb)) {
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 798b3ac680db..fe91d6a8c98d 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2955,7 +2955,7 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 			     "empty directory '%.*s' has too many links (%u)",
 			     dentry->d_name.len, dentry->d_name.name,
 			     inode->i_nlink);
-	inode->i_version++;
+	inode_inc_iversion(inode);
 	clear_nlink(inode);
 	/* There's no need to set i_disksize: the fact that i_nlink is
 	 * zero will ensure that the right thing happens during any
@@ -3361,7 +3361,7 @@ static int ext4_setent(handle_t *handle, struct ext4_renament *ent,
 	ent->de->inode = cpu_to_le32(ino);
 	if (ext4_has_feature_filetype(ent->dir->i_sb))
 		ent->de->file_type = file_type;
-	ent->dir->i_version++;
+	inode_inc_iversion(ent->dir);
 	ent->dir->i_ctime = ent->dir->i_mtime =
 		current_time(ent->dir);
 	ext4_mark_inode_dirty(handle, ent->dir);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7c46693a14d7..5663547e97f8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -967,7 +967,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	if (!ei)
 		return NULL;
 
-	ei->vfs_inode.i_version = 1;
+	inode_set_iversion(&ei->vfs_inode, 1);
 	spin_lock_init(&ei->i_raw_lock);
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 218a7ba57819..d8e7baa681b5 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -294,13 +294,13 @@ ext4_xattr_inode_hash(struct ext4_sb_info *sbi, const void *buffer, size_t size)
 static u64 ext4_xattr_inode_get_ref(struct inode *ea_inode)
 {
 	return ((u64)ea_inode->i_ctime.tv_sec << 32) |
-	       ((u32)ea_inode->i_version);
+		(u32) inode_peek_iversion(ea_inode);
 }
 
 static void ext4_xattr_inode_set_ref(struct inode *ea_inode, u64 ref_count)
 {
 	ea_inode->i_ctime.tv_sec = (u32)(ref_count >> 32);
-	ea_inode->i_version = (u32)ref_count;
+	inode_set_iversion(ea_inode, ref_count & 0xffffffff);
 }
 
 static u32 ext4_xattr_inode_get_hash(struct inode *ea_inode)
-- 
2.14.3

