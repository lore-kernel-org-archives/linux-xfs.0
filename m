Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757008AbdLPNrb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 08:47:31 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 13/19] ufs: use new i_version API
Date: Sat, 16 Dec 2017 08:46:50 -0500
Message-Id: <20171216134656.15561-14-jlayton@kernel.org>
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
 fs/ufs/dir.c   | 8 ++++----
 fs/ufs/inode.c | 2 +-
 fs/ufs/super.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index 2edc1755b7c5..547c4d4c4db8 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -47,7 +47,7 @@ static int ufs_commit_chunk(struct page *page, loff_t pos, unsigned len)
 	struct inode *dir = mapping->host;
 	int err = 0;
 
-	dir->i_version++;
+	inode_inc_iversion(dir);
 	block_write_end(NULL, mapping, pos, len, len, page, NULL);
 	if (pos+len > dir->i_size) {
 		i_size_write(dir, pos+len);
@@ -428,7 +428,7 @@ ufs_readdir(struct file *file, struct dir_context *ctx)
 	unsigned long n = pos >> PAGE_SHIFT;
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(UFS_SB(sb)->s_uspi->s_dirblksize - 1);
-	int need_revalidate = file->f_version != inode->i_version;
+	bool need_revalidate = inode_cmp_iversion(inode, file->f_version);
 	unsigned flags = UFS_SB(sb)->s_flags;
 
 	UFSD("BEGIN\n");
@@ -455,8 +455,8 @@ ufs_readdir(struct file *file, struct dir_context *ctx)
 				offset = ufs_validate_entry(sb, kaddr, offset, chunk_mask);
 				ctx->pos = (n<<PAGE_SHIFT) + offset;
 			}
-			file->f_version = inode->i_version;
-			need_revalidate = 0;
+			file->f_version = inode_query_iversion(inode);
+			need_revalidate = false;
 		}
 		de = (struct ufs_dir_entry *)(kaddr+offset);
 		limit = kaddr + ufs_last_byte(inode, n) - UFS_DIR_REC_LEN(1);
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index afb601c0dda0..58cb6dfb116d 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -693,7 +693,7 @@ struct inode *ufs_iget(struct super_block *sb, unsigned long ino)
 	if (err)
 		goto bad_inode;
 
-	inode->i_version++;
+	inode_inc_iversion(inode);
 	ufsi->i_lastfrag =
 		(inode->i_size + uspi->s_fsize - 1) >> uspi->s_fshift;
 	ufsi->i_dir_start_lookup = 0;
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 4d497e9c6883..7dee0b07a571 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1440,7 +1440,7 @@ static struct inode *ufs_alloc_inode(struct super_block *sb)
 	if (!ei)
 		return NULL;
 
-	ei->vfs_inode.i_version = 1;
+	inode_set_iversion(&ei->vfs_inode, 1);
 	seqlock_init(&ei->meta_lock);
 	mutex_init(&ei->truncate_mutex);
 	return &ei->vfs_inode;
-- 
2.14.3

