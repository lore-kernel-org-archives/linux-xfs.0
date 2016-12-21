Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45750 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933996AbcLUREA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:00 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 12/30] fat: convert to new i_version API
Date: Wed, 21 Dec 2016 12:03:29 -0500
Message-Id: <1482339827-7882-13-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/fat/dir.c         |  2 +-
 fs/fat/inode.c       |  8 ++++----
 fs/fat/namei_msdos.c |  6 +++---
 fs/fat/namei_vfat.c  | 20 ++++++++++----------
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 81cecbe6d7cf..76a4cace7543 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1056,7 +1056,7 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 	brelse(bh);
 	if (err)
 		return err;
-	dir->i_version++;
+	inode_inc_iversion_locked(dir);
 
 	if (nr_slots) {
 		/*
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 338d2f73eb29..9a8a22111031 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -507,7 +507,7 @@ int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 	MSDOS_I(inode)->i_pos = 0;
 	inode->i_uid = sbi->options.fs_uid;
 	inode->i_gid = sbi->options.fs_gid;
-	inode->i_version++;
+	inode_inc_iversion_locked(inode);
 	inode->i_generation = get_seconds();
 
 	if ((de->attr & ATTR_DIR) && !IS_FREE(de->name)) {
@@ -590,7 +590,7 @@ struct inode *fat_build_inode(struct super_block *sb,
 		goto out;
 	}
 	inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
-	inode->i_version = 1;
+	inode_set_iversion(inode, 1);
 	err = fat_fill_inode(inode, de);
 	if (err) {
 		iput(inode);
@@ -1367,7 +1367,7 @@ static int fat_read_root(struct inode *inode)
 	MSDOS_I(inode)->i_pos = MSDOS_ROOT_INO;
 	inode->i_uid = sbi->options.fs_uid;
 	inode->i_gid = sbi->options.fs_gid;
-	inode->i_version++;
+	inode_inc_iversion_locked(inode);
 	inode->i_generation = 0;
 	inode->i_mode = fat_make_mode(sbi, ATTR_DIR, S_IRWXUGO);
 	inode->i_op = sbi->dir_ops;
@@ -1817,7 +1817,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	if (!root_inode)
 		goto out_fail;
 	root_inode->i_ino = MSDOS_ROOT_INO;
-	root_inode->i_version = 1;
+	inode_set_iversion(root_inode, 1);
 	error = fat_read_root(root_inode);
 	if (error < 0) {
 		iput(root_inode);
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 7d6a105d601b..459fe1d9b578 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -480,7 +480,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 			} else
 				mark_inode_dirty(old_inode);
 
-			old_dir->i_version++;
+			inode_inc_iversion_locked(old_dir);
 			old_dir->i_ctime = old_dir->i_mtime = current_time(old_dir);
 			if (IS_DIRSYNC(old_dir))
 				(void)fat_sync_inode(old_dir);
@@ -508,7 +508,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 			goto out;
 		new_i_pos = sinfo.i_pos;
 	}
-	new_dir->i_version++;
+	inode_inc_iversion_locked(new_dir);
 
 	fat_detach(old_inode);
 	fat_attach(old_inode, new_i_pos);
@@ -540,7 +540,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 	old_sinfo.bh = NULL;
 	if (err)
 		goto error_dotdot;
-	old_dir->i_version++;
+	inode_inc_iversion_locked(old_dir);
 	old_dir->i_ctime = old_dir->i_mtime = ts;
 	if (IS_DIRSYNC(old_dir))
 		(void)fat_sync_inode(old_dir);
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 6a7152d0c250..d7db82751a98 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -44,7 +44,7 @@ static int vfat_revalidate_shortname(struct dentry *dentry)
 {
 	int ret = 1;
 	spin_lock(&dentry->d_lock);
-	if (vfat_d_version(dentry) != d_inode(dentry->d_parent)->i_version)
+	if (inode_cmp_iversion(d_inode(dentry->d_parent), vfat_d_version(dentry)))
 		ret = 0;
 	spin_unlock(&dentry->d_lock);
 	return ret;
@@ -770,7 +770,7 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	if (!inode)
-		vfat_d_version_set(dentry, dir->i_version);
+		vfat_d_version_set(dentry, inode_get_iversion(dir));
 	return d_splice_alias(inode, dentry);
 error:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
@@ -792,7 +792,7 @@ static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	err = vfat_add_entry(dir, &dentry->d_name, 0, 0, &ts, &sinfo);
 	if (err)
 		goto out;
-	dir->i_version++;
+	inode_inc_iversion_locked(dir);
 
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
 	brelse(sinfo.bh);
@@ -800,7 +800,7 @@ static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		err = PTR_ERR(inode);
 		goto out;
 	}
-	inode->i_version++;
+	inode_inc_iversion_locked(inode);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
@@ -834,7 +834,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = current_time(inode);
 	fat_detach(inode);
-	vfat_d_version_set(dentry, dir->i_version);
+	vfat_d_version_set(dentry, inode_get_iversion(dir));
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
@@ -860,7 +860,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = current_time(inode);
 	fat_detach(inode);
-	vfat_d_version_set(dentry, dir->i_version);
+	vfat_d_version_set(dentry, inode_get_iversion(dir));
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
@@ -886,7 +886,7 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	err = vfat_add_entry(dir, &dentry->d_name, 1, cluster, &ts, &sinfo);
 	if (err)
 		goto out_free;
-	dir->i_version++;
+	inode_inc_iversion_locked(dir);
 	inc_nlink(dir);
 
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
@@ -896,7 +896,7 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		/* the directory was completed, just return a error */
 		goto out;
 	}
-	inode->i_version++;
+	inode_inc_iversion_locked(inode);
 	set_nlink(inode, 2);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
@@ -962,7 +962,7 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto out;
 		new_i_pos = sinfo.i_pos;
 	}
-	new_dir->i_version++;
+	inode_inc_iversion_locked(new_dir);
 
 	fat_detach(old_inode);
 	fat_attach(old_inode, new_i_pos);
@@ -990,7 +990,7 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_sinfo.bh = NULL;
 	if (err)
 		goto error_dotdot;
-	old_dir->i_version++;
+	inode_inc_iversion_locked(old_dir);
 	old_dir->i_ctime = old_dir->i_mtime = ts;
 	if (IS_DIRSYNC(old_dir))
 		(void)fat_sync_inode(old_dir);
-- 
2.7.4

