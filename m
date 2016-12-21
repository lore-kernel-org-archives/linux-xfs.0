Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964804AbcLUREF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:05 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 17/30] ext2: convert to new i_version API
Date: Wed, 21 Dec 2016 12:03:34 -0500
Message-Id: <1482339827-7882-18-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ext2/dir.c   | 8 ++++----
 fs/ext2/super.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index d9650c9508e4..aae282798d18 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -91,7 +91,7 @@ static int ext2_commit_chunk(struct page *page, loff_t pos, unsigned len)
 	struct inode *dir = mapping->host;
 	int err = 0;
 
-	dir->i_version++;
+	inode_inc_iversion_locked(dir);
 	block_write_end(NULL, mapping, pos, len, len, page, NULL);
 
 	if (pos+len > dir->i_size) {
@@ -292,7 +292,7 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(ext2_chunk_size(inode)-1);
 	unsigned char *types = NULL;
-	int need_revalidate = file->f_version != inode->i_version;
+	bool need_revalidate = inode_cmp_iversion(inode, file->f_version);
 
 	if (pos > inode->i_size - EXT2_DIR_REC_LEN(1))
 		return 0;
@@ -318,8 +318,8 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
 				offset = ext2_validate_entry(kaddr, offset, chunk_mask);
 				ctx->pos = (n<<PAGE_SHIFT) + offset;
 			}
-			file->f_version = inode->i_version;
-			need_revalidate = 0;
+			file->f_version = inode_get_iversion(inode);
+			need_revalidate = false;
 		}
 		de = (ext2_dirent *)(kaddr+offset);
 		limit = kaddr + ext2_last_byte(inode, n) - EXT2_DIR_REC_LEN(1);
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 6cb042b53b5b..5c9ba3b3f77b 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -167,7 +167,7 @@ static struct inode *ext2_alloc_inode(struct super_block *sb)
 	if (!ei)
 		return NULL;
 	ei->i_block_alloc_info = NULL;
-	ei->vfs_inode.i_version = 1;
+	inode_set_iversion(&ei->vfs_inode, 1);
 #ifdef CONFIG_QUOTA
 	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
@@ -1542,7 +1542,7 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 		return err;
 	if (inode->i_size < off+len-towrite)
 		i_size_write(inode, off+len-towrite);
-	inode->i_version++;
+	inode_inc_iversion(inode);
 	inode->i_mtime = inode->i_ctime = current_time(inode);
 	mark_inode_dirty(inode);
 	return len - towrite;
-- 
2.7.4

