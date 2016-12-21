Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937229AbcLUREJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:09 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 22/30] ufs: use new i_version API
Date: Wed, 21 Dec 2016 12:03:39 -0500
Message-Id: <1482339827-7882-23-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ufs/dir.c   | 8 ++++----
 fs/ufs/inode.c | 2 +-
 fs/ufs/super.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index de01b8f2aa78..c6e670732cc5 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -46,7 +46,7 @@ static int ufs_commit_chunk(struct page *page, loff_t pos, unsigned len)
 	struct inode *dir = mapping->host;
 	int err = 0;
 
-	dir->i_version++;
+	inode_inc_iversion_locked(dir);
 	block_write_end(NULL, mapping, pos, len, len, page, NULL);
 	if (pos+len > dir->i_size) {
 		i_size_write(dir, pos+len);
@@ -427,7 +427,7 @@ ufs_readdir(struct file *file, struct dir_context *ctx)
 	unsigned long n = pos >> PAGE_SHIFT;
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(UFS_SB(sb)->s_uspi->s_dirblksize - 1);
-	int need_revalidate = file->f_version != inode->i_version;
+	bool need_revalidate = inode_cmp_iversion(inode, file->f_version);
 	unsigned flags = UFS_SB(sb)->s_flags;
 
 	UFSD("BEGIN\n");
@@ -454,8 +454,8 @@ ufs_readdir(struct file *file, struct dir_context *ctx)
 				offset = ufs_validate_entry(sb, kaddr, offset, chunk_mask);
 				ctx->pos = (n<<PAGE_SHIFT) + offset;
 			}
-			file->f_version = inode->i_version;
-			need_revalidate = 0;
+			file->f_version = inode_get_iversion(inode);
+			need_revalidate = false;
 		}
 		de = (struct ufs_dir_entry *)(kaddr+offset);
 		limit = kaddr + ufs_last_byte(inode, n) - UFS_DIR_REC_LEN(1);
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 1bc0bd6a9848..4cb39d555df6 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -680,7 +680,7 @@ struct inode *ufs_iget(struct super_block *sb, unsigned long ino)
 
 	if (err)
 		goto bad_inode;
-	inode->i_version++;
+	inode_inc_iversion_locked(inode);
 	ufsi->i_lastfrag =
 		(inode->i_size + uspi->s_fsize - 1) >> uspi->s_fshift;
 	ufsi->i_dir_start_lookup = 0;
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index f04ab232d08d..ed7038aaa258 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1398,7 +1398,7 @@ static struct inode *ufs_alloc_inode(struct super_block *sb)
 	if (!ei)
 		return NULL;
 
-	ei->vfs_inode.i_version = 1;
+	inode_set_iversion(&ei->vfs_inode, 1);
 	seqlock_init(&ei->meta_lock);
 	mutex_init(&ei->truncate_mutex);
 	return &ei->vfs_inode;
-- 
2.7.4

