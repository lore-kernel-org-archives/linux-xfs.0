Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47204 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936440AbcLUREE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:04:04 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 16/30] exofs: switch to new i_version API
Date: Wed, 21 Dec 2016 12:03:33 -0500
Message-Id: <1482339827-7882-17-git-send-email-jlayton@redhat.com>
In-Reply-To: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
References: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/exofs/dir.c   | 8 ++++----
 fs/exofs/super.c | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/exofs/dir.c b/fs/exofs/dir.c
index 42f9a0a0c4ca..753828ef2db1 100644
--- a/fs/exofs/dir.c
+++ b/fs/exofs/dir.c
@@ -60,7 +60,7 @@ static int exofs_commit_chunk(struct page *page, loff_t pos, unsigned len)
 	struct inode *dir = mapping->host;
 	int err = 0;
 
-	dir->i_version++;
+	inode_inc_iversion_locked(dir);
 
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
@@ -241,7 +241,7 @@ exofs_readdir(struct file *file, struct dir_context *ctx)
 	unsigned long n = pos >> PAGE_SHIFT;
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(exofs_chunk_size(inode)-1);
-	int need_revalidate = (file->f_version != inode->i_version);
+	bool need_revalidate = inode_cmp_iversion(inode, file->f_version);
 
 	if (pos > inode->i_size - EXOFS_DIR_REC_LEN(1))
 		return 0;
@@ -264,8 +264,8 @@ exofs_readdir(struct file *file, struct dir_context *ctx)
 								chunk_mask);
 				ctx->pos = (n<<PAGE_SHIFT) + offset;
 			}
-			file->f_version = inode->i_version;
-			need_revalidate = 0;
+			file->f_version = inode_get_iversion(inode);
+			need_revalidate = false;
 		}
 		de = (struct exofs_dir_entry *)(kaddr + offset);
 		limit = kaddr + exofs_last_byte(inode, n) -
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 1076a4233b39..74400d1dcea5 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -159,7 +159,7 @@ static struct inode *exofs_alloc_inode(struct super_block *sb)
 	if (!oi)
 		return NULL;
 
-	oi->vfs_inode.i_version = 1;
+	inode_set_iversion(&oi->vfs_inode, 1);
 	return &oi->vfs_inode;
 }
 
-- 
2.7.4

