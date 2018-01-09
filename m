Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753177AbeAIOLM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jan 2018 09:11:12 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v5 03/19] fat: convert to new i_version API
Date: Tue,  9 Jan 2018 09:10:43 -0500
Message-Id: <20180109141059.25929-4-jlayton@kernel.org>
In-Reply-To: <20180109141059.25929-1-jlayton@kernel.org>
References: <20180109141059.25929-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com, krzk@kernel.org

From: Jeff Layton <jlayton@redhat.com>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/fat/dir.c         |  3 ++-
 fs/fat/inode.c       |  9 +++++----
 fs/fat/namei_msdos.c |  7 ++++---
 fs/fat/namei_vfat.c  | 22 +++++++++++-----------
 4 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index b833ffeee1e1..8e100c3bf72c 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/compat.h>
 #include <linux/uaccess.h>
+#include <linux/iversion.h>
 #include "fat.h"
 
 /*
@@ -1055,7 +1056,7 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 	brelse(bh);
 	if (err)
 		return err;
-	dir->i_version++;
+	inode_inc_iversion(dir);
 
 	if (nr_slots) {
 		/*
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 20a0a89eaca5..ffbbf0520d9e 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -20,6 +20,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <asm/unaligned.h>
+#include <linux/iversion.h>
 #include "fat.h"
 
 #ifndef CONFIG_FAT_DEFAULT_IOCHARSET
@@ -507,7 +508,7 @@ int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 	MSDOS_I(inode)->i_pos = 0;
 	inode->i_uid = sbi->options.fs_uid;
 	inode->i_gid = sbi->options.fs_gid;
-	inode->i_version++;
+	inode_inc_iversion(inode);
 	inode->i_generation = get_seconds();
 
 	if ((de->attr & ATTR_DIR) && !IS_FREE(de->name)) {
@@ -590,7 +591,7 @@ struct inode *fat_build_inode(struct super_block *sb,
 		goto out;
 	}
 	inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
-	inode->i_version = 1;
+	inode_set_iversion(inode, 1);
 	err = fat_fill_inode(inode, de);
 	if (err) {
 		iput(inode);
@@ -1377,7 +1378,7 @@ static int fat_read_root(struct inode *inode)
 	MSDOS_I(inode)->i_pos = MSDOS_ROOT_INO;
 	inode->i_uid = sbi->options.fs_uid;
 	inode->i_gid = sbi->options.fs_gid;
-	inode->i_version++;
+	inode_inc_iversion(inode);
 	inode->i_generation = 0;
 	inode->i_mode = fat_make_mode(sbi, ATTR_DIR, S_IRWXUGO);
 	inode->i_op = sbi->dir_ops;
@@ -1828,7 +1829,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 	if (!root_inode)
 		goto out_fail;
 	root_inode->i_ino = MSDOS_ROOT_INO;
-	root_inode->i_version = 1;
+	inode_set_iversion(root_inode, 1);
 	error = fat_read_root(root_inode);
 	if (error < 0) {
 		iput(root_inode);
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index d24d2758a363..582ca731a6c9 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/iversion.h>
 #include "fat.h"
 
 /* Characters that are undesirable in an MS-DOS file name */
@@ -480,7 +481,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 			} else
 				mark_inode_dirty(old_inode);
 
-			old_dir->i_version++;
+			inode_inc_iversion(old_dir);
 			old_dir->i_ctime = old_dir->i_mtime = current_time(old_dir);
 			if (IS_DIRSYNC(old_dir))
 				(void)fat_sync_inode(old_dir);
@@ -508,7 +509,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 			goto out;
 		new_i_pos = sinfo.i_pos;
 	}
-	new_dir->i_version++;
+	inode_inc_iversion(new_dir);
 
 	fat_detach(old_inode);
 	fat_attach(old_inode, new_i_pos);
@@ -540,7 +541,7 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
 	old_sinfo.bh = NULL;
 	if (err)
 		goto error_dotdot;
-	old_dir->i_version++;
+	inode_inc_iversion(old_dir);
 	old_dir->i_ctime = old_dir->i_mtime = ts;
 	if (IS_DIRSYNC(old_dir))
 		(void)fat_sync_inode(old_dir);
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 02c066663a3a..cefea792cde8 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -20,7 +20,7 @@
 #include <linux/slab.h>
 #include <linux/namei.h>
 #include <linux/kernel.h>
-
+#include <linux/iversion.h>
 #include "fat.h"
 
 static inline unsigned long vfat_d_version(struct dentry *dentry)
@@ -46,7 +46,7 @@ static int vfat_revalidate_shortname(struct dentry *dentry)
 {
 	int ret = 1;
 	spin_lock(&dentry->d_lock);
-	if (vfat_d_version(dentry) != d_inode(dentry->d_parent)->i_version)
+	if (inode_cmp_iversion(d_inode(dentry->d_parent), vfat_d_version(dentry)))
 		ret = 0;
 	spin_unlock(&dentry->d_lock);
 	return ret;
@@ -759,7 +759,7 @@ static struct dentry *vfat_lookup(struct inode *dir, struct dentry *dentry,
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 	if (!inode)
-		vfat_d_version_set(dentry, dir->i_version);
+		vfat_d_version_set(dentry, inode_query_iversion(dir));
 	return d_splice_alias(inode, dentry);
 error:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
@@ -781,7 +781,7 @@ static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	err = vfat_add_entry(dir, &dentry->d_name, 0, 0, &ts, &sinfo);
 	if (err)
 		goto out;
-	dir->i_version++;
+	inode_inc_iversion(dir);
 
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
 	brelse(sinfo.bh);
@@ -789,7 +789,7 @@ static int vfat_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		err = PTR_ERR(inode);
 		goto out;
 	}
-	inode->i_version++;
+	inode_inc_iversion(inode);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
 
@@ -823,7 +823,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = current_time(inode);
 	fat_detach(inode);
-	vfat_d_version_set(dentry, dir->i_version);
+	vfat_d_version_set(dentry, inode_query_iversion(dir));
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
@@ -849,7 +849,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 	clear_nlink(inode);
 	inode->i_mtime = inode->i_atime = current_time(inode);
 	fat_detach(inode);
-	vfat_d_version_set(dentry, dir->i_version);
+	vfat_d_version_set(dentry, inode_query_iversion(dir));
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
 
@@ -875,7 +875,7 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	err = vfat_add_entry(dir, &dentry->d_name, 1, cluster, &ts, &sinfo);
 	if (err)
 		goto out_free;
-	dir->i_version++;
+	inode_inc_iversion(dir);
 	inc_nlink(dir);
 
 	inode = fat_build_inode(sb, sinfo.de, sinfo.i_pos);
@@ -885,7 +885,7 @@ static int vfat_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 		/* the directory was completed, just return a error */
 		goto out;
 	}
-	inode->i_version++;
+	inode_inc_iversion(inode);
 	set_nlink(inode, 2);
 	inode->i_mtime = inode->i_atime = inode->i_ctime = ts;
 	/* timestamp is already written, so mark_inode_dirty() is unneeded. */
@@ -951,7 +951,7 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 			goto out;
 		new_i_pos = sinfo.i_pos;
 	}
-	new_dir->i_version++;
+	inode_inc_iversion(new_dir);
 
 	fat_detach(old_inode);
 	fat_attach(old_inode, new_i_pos);
@@ -979,7 +979,7 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	old_sinfo.bh = NULL;
 	if (err)
 		goto error_dotdot;
-	old_dir->i_version++;
+	inode_inc_iversion(old_dir);
 	old_dir->i_ctime = old_dir->i_mtime = ts;
 	if (IS_DIRSYNC(old_dir))
 		(void)fat_sync_inode(old_dir);
-- 
2.14.3

