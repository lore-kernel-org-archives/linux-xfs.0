Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:17338 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757044AbdLXBF3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Dec 2017 20:05:29 -0500
Subject: [PATCH v4 14/18] ext2: use DEFINE_FSDAX_AOPS
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Dec 2017 16:57:15 -0800
Message-ID: <151407703518.38751.15720592028869946071.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: akpm@linux-foundation.org
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de

In preparation for the dax implementation to start associating dax pages
to inodes via page->mapping, we need to provide a 'struct
address_space_operations' instance for dax. Otherwise, direct-I/O
triggers incorrect page cache assumptions and warnings.

Cc: Jan Kara <jack@suse.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/ext2.h  |    1 +
 fs/ext2/inode.c |   23 +++++++++++++++--------
 fs/ext2/namei.c |   18 ++----------------
 3 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 032295e1d386..cc40802ddfa8 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -814,6 +814,7 @@ extern const struct inode_operations ext2_file_inode_operations;
 extern const struct file_operations ext2_file_operations;
 
 /* inode.c */
+extern void ext2_set_file_ops(struct inode *inode);
 extern const struct address_space_operations ext2_aops;
 extern const struct address_space_operations ext2_nobh_aops;
 extern const struct iomap_ops ext2_iomap_ops;
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 9b2ac55ac34f..d1f4546e0028 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -990,6 +990,8 @@ const struct address_space_operations ext2_nobh_aops = {
 	.error_remove_page	= generic_error_remove_page,
 };
 
+static DEFINE_FSDAX_AOPS(ext2_dax_aops, ext2_writepages);
+
 /*
  * Probably it should be a library function... search for first non-zero word
  * or memcmp with zero_page, whatever is better for particular architecture.
@@ -1388,6 +1390,18 @@ void ext2_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_DAX;
 }
 
+void ext2_set_file_ops(struct inode *inode)
+{
+	inode->i_op = &ext2_file_inode_operations;
+	inode->i_fop = &ext2_file_operations;
+	if (IS_DAX(inode))
+		inode->i_mapping->a_ops = &ext2_dax_aops;
+	else if (test_opt(inode->i_sb, NOBH))
+		inode->i_mapping->a_ops = &ext2_nobh_aops;
+	else
+		inode->i_mapping->a_ops = &ext2_aops;
+}
+
 struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 {
 	struct ext2_inode_info *ei;
@@ -1480,14 +1494,7 @@ struct inode *ext2_iget (struct super_block *sb, unsigned long ino)
 		ei->i_data[n] = raw_inode->i_block[n];
 
 	if (S_ISREG(inode->i_mode)) {
-		inode->i_op = &ext2_file_inode_operations;
-		if (test_opt(inode->i_sb, NOBH)) {
-			inode->i_mapping->a_ops = &ext2_nobh_aops;
-			inode->i_fop = &ext2_file_operations;
-		} else {
-			inode->i_mapping->a_ops = &ext2_aops;
-			inode->i_fop = &ext2_file_operations;
-		}
+		ext2_set_file_ops(inode);
 	} else if (S_ISDIR(inode->i_mode)) {
 		inode->i_op = &ext2_dir_inode_operations;
 		inode->i_fop = &ext2_dir_operations;
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index e078075dc66f..55f7caadb093 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -107,14 +107,7 @@ static int ext2_create (struct inode * dir, struct dentry * dentry, umode_t mode
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
-	inode->i_op = &ext2_file_inode_operations;
-	if (test_opt(inode->i_sb, NOBH)) {
-		inode->i_mapping->a_ops = &ext2_nobh_aops;
-		inode->i_fop = &ext2_file_operations;
-	} else {
-		inode->i_mapping->a_ops = &ext2_aops;
-		inode->i_fop = &ext2_file_operations;
-	}
+	ext2_set_file_ops(inode);
 	mark_inode_dirty(inode);
 	return ext2_add_nondir(dentry, inode);
 }
@@ -125,14 +118,7 @@ static int ext2_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (IS_ERR(inode))
 		return PTR_ERR(inode);
 
-	inode->i_op = &ext2_file_inode_operations;
-	if (test_opt(inode->i_sb, NOBH)) {
-		inode->i_mapping->a_ops = &ext2_nobh_aops;
-		inode->i_fop = &ext2_file_operations;
-	} else {
-		inode->i_mapping->a_ops = &ext2_aops;
-		inode->i_fop = &ext2_file_operations;
-	}
+	ext2_set_file_ops(inode);
 	mark_inode_dirty(inode);
 	d_tmpfile(dentry, inode);
 	unlock_new_inode(inode);

