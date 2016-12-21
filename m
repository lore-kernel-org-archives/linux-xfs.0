Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46218 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936090AbcLUREB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:01 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 13/30] affs: convert to new i_version API
Date: Wed, 21 Dec 2016 12:03:30 -0500
Message-Id: <1482339827-7882-14-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/affs/amigaffs.c | 4 ++--
 fs/affs/dir.c      | 4 ++--
 fs/affs/super.c    | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index 0ec65c133b93..00aff7cfc883 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -59,7 +59,7 @@ affs_insert_hash(struct inode *dir, struct buffer_head *bh)
 	affs_brelse(dir_bh);
 
 	dir->i_mtime = dir->i_ctime = current_time(dir);
-	dir->i_version++;
+	inode_inc_iversion_locked(dir);
 	mark_inode_dirty(dir);
 
 	return 0;
@@ -113,7 +113,7 @@ affs_remove_hash(struct inode *dir, struct buffer_head *rem_bh)
 	affs_brelse(bh);
 
 	dir->i_mtime = dir->i_ctime = current_time(dir);
-	dir->i_version++;
+	inode_inc_iversion_locked(dir);
 	mark_inode_dirty(dir);
 
 	return retval;
diff --git a/fs/affs/dir.c b/fs/affs/dir.c
index f1e7294381c5..a587d57668e3 100644
--- a/fs/affs/dir.c
+++ b/fs/affs/dir.c
@@ -79,7 +79,7 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 	 * we can jump directly to where we left off.
 	 */
 	ino = (u32)(long)file->private_data;
-	if (ino && file->f_version == inode->i_version) {
+	if (ino && inode_cmp_iversion(inode, file->f_version) == 0) {
 		pr_debug("readdir() left off=%d\n", ino);
 		goto inside;
 	}
@@ -129,7 +129,7 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 		} while (ino);
 	}
 done:
-	file->f_version = inode->i_version;
+	file->f_version = inode_get_iversion(inode);
 	file->private_data = (void *)(long)ino;
 	affs_brelse(fh_bh);
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index d6384863192c..b3ebf90f9798 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -99,7 +99,7 @@ static struct inode *affs_alloc_inode(struct super_block *sb)
 	if (!i)
 		return NULL;
 
-	i->vfs_inode.i_version = 1;
+	inode_set_iversion(&i->vfs_inode, 1);
 	i->i_lc = NULL;
 	i->i_ext_bh = NULL;
 	i->i_pa_cnt = 0;
-- 
2.7.4

