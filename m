Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571272;
	b=X0waihAFBoWqF3MTkWYa9wpEDf7lgjm7C1OJkpIc0UWCqlMIEpN3wwFcA9XS2bjh2FF0
	 +eFH5Fk76jAJ2xUsHS75JvE98n4w2P3XL8fEFdktbDnYJdO0Yy+IHc7wTmHGx6R9vEFW2
	 M6AHKkO4pYLPbvsNENPEV3HqvpSCFq+rQYApsIuI38+pjzt3/p9ihC9YiX3584Bi1KVJx
	 RPzdleX//7nr9L/w26BS9io3lrPRsYM5vK7ClqL/s3sxLAxvs7jq0XFJ7G/xJHbnvTTN/
	 5hTM7Fv5SMB4XRkTP4SF6h7CedRKf1s8SPNIbXHnMaPRd136hz9bDKxjC6j6GUFLRmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571272;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=6iD7sstrNdnZdsGoW8MRvlzxFqMzWlzeZ0tM3s4uA9c=;
	b=aeDMUBc7NOEYZLo5G0XVlEjrShT/3z/xRiLCi0I6i2r/fyR9m2EEh8qpuk4OOSZC510f
	 0afyrt3aalQ0aaIy2wsy1LkiC29EQ/S1tRj7iX9DOmXDZNw/sShiuttBzwixUFbmHr78P
	 BOtagn8rZm7GKRVIW4GKM72n5XPZeS21hS/E5jQ1Qq6eVxsnB3o8Pitxlvixgzc9m0vHU
	 8aKbhva95HlWyAi2NBRrBm+jF8GIFvuG7mw0OskIstLuHCxDgmJssle5mHX6siyrMU68t
	 oZPdZgCuFyTIY8d9vpcW8Kzip03yMDfkPMnB0PUgiQsmSp0CJoAs7NXEd4DlwGVY43A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BMqxbTrz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8619A606A330;
	Fri, 13 Nov 2026 12:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BMqxbTrz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7F41F000C5;
	Fri, 13 Nov 2026 12:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571271;
	bh=6iD7sstrNdnZdsGoW8MRvlzxFqMzWlzeZ0tM3s4uA9c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BMqxbTrzVCboEKs2MS7YiMDuvFz/B9F7N6ntAC3JqYwRY2fkHbJKIHpX/XrK7TJ/K
	 gIuZhB7YK2k4gZ/apiEObn68R/8KgOohRxW7mD7OgVYPyyl0C04PKAiPQXIeVBLFab
	 BJYWN/PhCxKRmM3QmW5SnFh5vp+xasQfasRv83nmjs2sd1H7ius3tGEqWKaR9Di9DI
	 OV/dMm4REteTi73PmSOB3+yrlWxT159xnpqobPHw7N4rdx0xQLNB06VjChsFeJXRLT
	 5toImAztVZYz+AX9K7G3A4thEzuSxq8hrBeFgW1SJt9zhj9CUCHoBWrK8YYr2y/SG8
	 /dQNci1u69VgQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:10 +0100
Subject: [PATCH v3 14/33] hfs: use the generic emergency read-only state
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-14-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Viacheslav Dubeyko <slava@dubeyko.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=8251; i=brauner@kernel.org;
 h=from:subject:message-id; bh=dZGJW8u7u4x/QzeOZT2uu6h5vPsYTWe6mpgxZFR76tA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+70q70ZiwoVe9pXmjrxOcVf8F7bOX7WDXez6/Kxf0
 29vm37HuaOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiefUM/12fhma7HzBJK+Jl
 1jtu8Phy285NGZWPDS8riqd2XtRTu8nwV0rGRITPM4abO1Kh5pJVmHL3OnsNzbRK5a9am7eHpSv
 zAwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Set SB_STATE_EMERGENCY_RO instead of a private bit and drop the checks
the VFS does now. What's left is hfs_get_block(), hfs_file_truncate(),
write_begin, O_DIRECT writes, the hfs.type and hfs.creator xattrs and
the MDB commit, close and dirtying paths.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/hfs/attr.c   |  2 +-
 fs/hfs/dir.c    | 12 ------------
 fs/hfs/extent.c |  4 ++--
 fs/hfs/hfs_fs.h | 11 -----------
 fs/hfs/inode.c  | 13 ++-----------
 fs/hfs/mdb.c    |  8 ++++----
 fs/hfs/super.c  |  5 +----
 7 files changed, 10 insertions(+), 45 deletions(-)

diff --git a/fs/hfs/attr.c b/fs/hfs/attr.c
index bd9a1289d8c5d..337b22f282086 100644
--- a/fs/hfs/attr.c
+++ b/fs/hfs/attr.c
@@ -129,7 +129,7 @@ static int hfs_xattr_set(const struct xattr_handler *handler,
 	if (!value)
 		return -EOPNOTSUPP;
 
-	if (unlikely(hfs_emergency_ro(inode->i_sb)))
+	if (unlikely(sb_emergency_ro(inode->i_sb)))
 		return -EROFS;
 
 	return __hfs_setxattr(inode, handler->flags, value, size, flags);
diff --git a/fs/hfs/dir.c b/fs/hfs/dir.c
index f0d8ddb075034..f6b97da197887 100644
--- a/fs/hfs/dir.c
+++ b/fs/hfs/dir.c
@@ -189,9 +189,6 @@ static int hfs_create(const struct mnt_idmap *idmap, struct inode *dir,
 	struct inode *inode;
 	int res;
 
-	if (unlikely(hfs_emergency_ro(dir->i_sb)))
-		return -EROFS;
-
 	inode = hfs_new_inode(dir, &dentry->d_name, mode);
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
@@ -222,9 +219,6 @@ static struct dentry *hfs_mkdir(const struct mnt_idmap *idmap, struct inode *dir
 	struct inode *inode;
 	int res;
 
-	if (unlikely(hfs_emergency_ro(dir->i_sb)))
-		return ERR_PTR(-EROFS);
-
 	inode = hfs_new_inode(dir, &dentry->d_name, mode);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
@@ -258,9 +252,6 @@ static int hfs_remove(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = d_inode(dentry);
 	int res;
 
-	if (unlikely(hfs_emergency_ro(sb)))
-		return -EROFS;
-
 	if (S_ISDIR(inode->i_mode) && inode->i_size != 2)
 		return -ENOTEMPTY;
 
@@ -299,9 +290,6 @@ static int hfs_rename(const struct mnt_idmap *idmap, struct inode *old_dir,
 	if (flags & ~RENAME_NOREPLACE)
 		return -EINVAL;
 
-	if (unlikely(hfs_emergency_ro(old_dir->i_sb)))
-		return -EROFS;
-
 	/* Unlink destination if it already exists */
 	if (d_really_is_positive(new_dentry)) {
 		res = hfs_remove(new_dir, new_dentry);
diff --git a/fs/hfs/extent.c b/fs/hfs/extent.c
index dacf7ce1ffe4a..fd874a93a92f5 100644
--- a/fs/hfs/extent.c
+++ b/fs/hfs/extent.c
@@ -357,7 +357,7 @@ int hfs_get_block(struct inode *inode, sector_t block,
 			return -EIO;
 		if (ablock >= HFS_I(inode)->alloc_blocks) {
 			/* No new allocations after an error. */
-			if (unlikely(hfs_emergency_ro(sb)))
+			if (unlikely(sb_emergency_ro(sb)))
 				return -EROFS;
 			res = hfs_extend_file(inode);
 			if (res)
@@ -494,7 +494,7 @@ void hfs_file_truncate(struct inode *inode)
 	hfs_dbg("ino %llu, phys_size %llu -> i_size %llu\n",
 		inode->i_ino, (long long)HFS_I(inode)->phys_size,
 		inode->i_size);
-	if (unlikely(hfs_emergency_ro(sb)))
+	if (unlikely(sb_emergency_ro(sb)))
 		return;
 	if (inode->i_size > HFS_I(inode)->phys_size) {
 		struct address_space *mapping = inode->i_mapping;
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 325214573d91d..fdfa5d303d5ef 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -143,7 +143,6 @@ struct hfs_sb_info {
 #define HFS_FLG_BITMAP_DIRTY	0
 #define HFS_FLG_MDB_DIRTY	1
 #define HFS_FLG_ALT_MDB_DIRTY	2
-#define HFS_FLG_EMERGENCY_RO	3	/* read-only after an MDB write error */
 
 /* bitmap.c */
 extern u32 hfs_vbm_search_free(struct super_block *sb, u32 goal, u32 *num_bits);
@@ -294,16 +293,6 @@ static inline const char *hfs_mdb_name(struct super_block *sb)
 	return sb->s_id;
 }
 
-/*
- * Writing back the MDB failed and the filesystem stopped all modifications
- * until unmount. SB_RDONLY isn't used for that because it must not change
- * without s_umount.
- */
-static inline bool hfs_emergency_ro(struct super_block *sb)
-{
-	return test_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
-}
-
 static inline void hfs_bitmap_dirty(struct super_block *sb)
 {
 	set_bit(HFS_FLG_BITMAP_DIRTY, &HFS_SB(sb)->flags);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 10f72c0536a07..7e590e1308eac 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -54,7 +54,7 @@ int hfs_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 	loff_t total_capacity;
 	int ret;
 
-	if (unlikely(hfs_emergency_ro(inode->i_sb)))
+	if (unlikely(sb_emergency_ro(inode->i_sb)))
 		return -EROFS;
 
 	total_capacity = (loff_t)sbi->fs_ablocks * sbi->alloc_blksz;
@@ -143,7 +143,7 @@ static ssize_t hfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t ret;
 
 	if (iov_iter_rw(iter) == WRITE &&
-	    unlikely(hfs_emergency_ro(inode->i_sb)))
+	    unlikely(sb_emergency_ro(inode->i_sb)))
 		return -EROFS;
 
 	ret = blockdev_direct_IO(iocb, inode, iter, hfs_get_block);
@@ -626,8 +626,6 @@ void hfs_evict_inode(struct inode *inode)
 
 static int hfs_file_open(struct inode *inode, struct file *file)
 {
-	if ((file->f_mode & FMODE_WRITE) && hfs_emergency_ro(inode->i_sb))
-		return -EROFS;
 	if (HFS_IS_RSRC(inode))
 		inode = HFS_I(inode)->rsrc_inode;
 	atomic_inc(&HFS_I(inode)->opencnt);
@@ -659,9 +657,6 @@ int hfs_inode_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 	struct hfs_sb_info *hsb = HFS_SB(inode->i_sb);
 	int error;
 
-	if (unlikely(hfs_emergency_ro(inode->i_sb)))
-		return -EROFS;
-
 	error = setattr_prepare(&nop_mnt_idmap, dentry, attr);
 	if (error)
 		return error;
@@ -713,10 +708,6 @@ static int hfs_file_fsync(struct file *filp, loff_t start, loff_t end,
 	struct super_block * sb;
 	int ret, err;
 
-	/* Inodes aren't written back after an error. */
-	if (unlikely(hfs_emergency_ro(inode->i_sb)))
-		return -EROFS;
-
 	ret = file_write_and_wait_range(filp, start, end);
 	if (ret)
 		return ret;
diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 1a56cf5ea56e6..19dfc7a13d8c4 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -338,7 +338,7 @@ int hfs_mdb_commit(struct super_block *sb)
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 	int ret = 0;
 
-	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
+	if (sb_rdonly_any(sb))
 		return 0;
 
 	/*
@@ -347,7 +347,7 @@ int hfs_mdb_commit(struct super_block *sb)
 	 */
 	if (!buffer_uptodate(HFS_SB(sb)->mdb_bh)) {
 		pr_err("primary MDB is corrupt, mounting read-only\n");
-		set_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
+		sb_set_emergency_ro(sb);
 		return -EIO;
 	}
 
@@ -381,7 +381,7 @@ int hfs_mdb_commit(struct super_block *sb)
 	    HFS_SB(sb)->alt_mdb) {
 		if (!buffer_uptodate(HFS_SB(sb)->alt_mdb_bh)) {
 			pr_err("alternate MDB is corrupt, mounting read-only\n");
-			set_bit(HFS_FLG_EMERGENCY_RO, &HFS_SB(sb)->flags);
+			sb_set_emergency_ro(sb);
 			ret = -EIO;
 			goto out;
 		}
@@ -432,7 +432,7 @@ int hfs_mdb_commit(struct super_block *sb)
 void hfs_mdb_close(struct super_block *sb)
 {
 	/* update volume attributes */
-	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
+	if (sb_rdonly_any(sb))
 		return;
 
 	if (!buffer_uptodate(HFS_SB(sb)->mdb_bh))
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index bcc19c3a4f6bc..7abc0e61a222f 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -82,7 +82,7 @@ void hfs_mark_mdb_dirty(struct super_block *sb)
 	struct hfs_sb_info *sbi = HFS_SB(sb);
 	unsigned long delay;
 
-	if (sb_rdonly(sb) || hfs_emergency_ro(sb))
+	if (sb_rdonly_any(sb))
 		return;
 
 	spin_lock(&sbi->work_lock);
@@ -131,9 +131,6 @@ static int hfs_reconfigure(struct fs_context *fc)
 		return 0;
 
 	if (!(fc->sb_flags & SB_RDONLY)) {
-		/* After an MDB write error it stays read-only until unmount. */
-		if (hfs_emergency_ro(sb))
-			return -EROFS;
 		if (!(HFS_SB(sb)->mdb->drAtrb & cpu_to_be16(HFS_SB_ATTRIB_UNMNT))) {
 			pr_warn("filesystem was not cleanly unmounted, running fsck.hfs is recommended.  leaving read-only.\n");
 			sb->s_flags |= SB_RDONLY;

-- 
2.53.0

