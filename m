Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758579AbdLRPML (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Dec 2017 10:12:11 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v3 04/19] affs: convert to new i_version API
Date: Mon, 18 Dec 2017 10:11:41 -0500
Message-Id: <20171218151156.14565-5-jlayton@kernel.org>
In-Reply-To: <20171218151156.14565-1-jlayton@kernel.org>
References: <20171218151156.14565-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com

From: Jeff Layton <jlayton@redhat.com>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/affs/amigaffs.c | 5 +++--
 fs/affs/dir.c      | 5 +++--
 fs/affs/super.c    | 3 ++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/affs/amigaffs.c b/fs/affs/amigaffs.c
index 0f0e6925e97d..14a6c1b90c9f 100644
--- a/fs/affs/amigaffs.c
+++ b/fs/affs/amigaffs.c
@@ -10,6 +10,7 @@
  */
 
 #include <linux/math64.h>
+#include <linux/iversion.h>
 #include "affs.h"
 
 /*
@@ -60,7 +61,7 @@ affs_insert_hash(struct inode *dir, struct buffer_head *bh)
 	affs_brelse(dir_bh);
 
 	dir->i_mtime = dir->i_ctime = current_time(dir);
-	dir->i_version++;
+	inode_inc_iversion(dir);
 	mark_inode_dirty(dir);
 
 	return 0;
@@ -114,7 +115,7 @@ affs_remove_hash(struct inode *dir, struct buffer_head *rem_bh)
 	affs_brelse(bh);
 
 	dir->i_mtime = dir->i_ctime = current_time(dir);
-	dir->i_version++;
+	inode_inc_iversion(dir);
 	mark_inode_dirty(dir);
 
 	return retval;
diff --git a/fs/affs/dir.c b/fs/affs/dir.c
index a105e77df2c1..d180b46453cf 100644
--- a/fs/affs/dir.c
+++ b/fs/affs/dir.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <linux/iversion.h>
 #include "affs.h"
 
 static int affs_readdir(struct file *, struct dir_context *);
@@ -80,7 +81,7 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 	 * we can jump directly to where we left off.
 	 */
 	ino = (u32)(long)file->private_data;
-	if (ino && file->f_version == inode->i_version) {
+	if (ino && inode_cmp_iversion(inode, file->f_version) == 0) {
 		pr_debug("readdir() left off=%d\n", ino);
 		goto inside;
 	}
@@ -130,7 +131,7 @@ affs_readdir(struct file *file, struct dir_context *ctx)
 		} while (ino);
 	}
 done:
-	file->f_version = inode->i_version;
+	file->f_version = inode_query_iversion(inode);
 	file->private_data = (void *)(long)ino;
 	affs_brelse(fh_bh);
 
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 1117e36134cc..e602619aed9d 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -21,6 +21,7 @@
 #include <linux/writeback.h>
 #include <linux/blkdev.h>
 #include <linux/seq_file.h>
+#include <linux/iversion.h>
 #include "affs.h"
 
 static int affs_statfs(struct dentry *dentry, struct kstatfs *buf);
@@ -102,7 +103,7 @@ static struct inode *affs_alloc_inode(struct super_block *sb)
 	if (!i)
 		return NULL;
 
-	i->vfs_inode.i_version = 1;
+	inode_set_iversion(&i->vfs_inode, 1);
 	i->i_lc = NULL;
 	i->i_ext_bh = NULL;
 	i->i_pa_cnt = 0;
-- 
2.14.3

