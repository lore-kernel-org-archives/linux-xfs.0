Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756916AbdLPNrT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 08:47:19 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 08/19] ext2: convert to new i_version API
Date: Sat, 16 Dec 2017 08:46:45 -0500
Message-Id: <20171216134656.15561-9-jlayton@kernel.org>
In-Reply-To: <20171216134656.15561-1-jlayton@kernel.org>
References: <20171216134656.15561-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

From: Jeff Layton <jlayton@redhat.com>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ext2/dir.c   | 8 ++++----
 fs/ext2/super.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 987647986f47..c99f14fec3f3 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -92,7 +92,7 @@ static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
 	struct inode *dir = mapping->host;
 	int err = 0;
 
-	dir->i_version++;
+	inode_inc_iversion(dir);
 	block_write_end(NULL, mapping, pos, len, len, page, NULL);
 
 	if (pos+len > dir->i_size) {
@@ -293,7 +293,7 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(ext2_chunk_size(inode)-1);
 	unsigned char *types = NULL;
-	int need_revalidate = file->f_version != inode->i_version;
+	bool need_revalidate = inode_cmp_iversion(inode, file->f_version);
 
 	if (pos > inode->i_size - EXT2_DIR_REC_LEN(1))
 		return 0;
@@ -319,8 +319,8 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
 				offset = ext2_validate_entry(kaddr, offset, chunk_mask);
 				ctx->pos = (n<<PAGE_SHIFT) + offset;
 			}
-			file->f_version = inode->i_version;
-			need_revalidate = 0;
+			file->f_version = inode_query_iversion(inode);
+			need_revalidate = false;
 		}
 		de = (ext2_dirent *)(kaddr+offset);
 		limit = kaddr + ext2_last_byte(inode, n) - EXT2_DIR_REC_LEN(1);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 7646818ab266..dd7c3c81d918 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -184,7 +184,7 @@ static struct inode *ext2_alloc_inode(struct super_block *sb)
 	if (!ei)
 		return NULL;
 	ei->i_block_alloc_info = NULL;
-	ei->vfs_inode.i_version = 1;
+	inode_set_iversion(&ei->vfs_inode, 1);
 #ifdef CONFIG_QUOTA
 	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
@@ -1569,7 +1569,7 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 		return err;
 	if (inode->i_size < off+len-towrite)
 		i_size_write(inode, off+len-towrite);
-	inode->i_version++;
+	inode_inc_iversion(inode);
 	inode->i_mtime = inode->i_ctime = current_time(inode);
 	mark_inode_dirty(inode);
 	return len - towrite;
-- 
2.14.3

