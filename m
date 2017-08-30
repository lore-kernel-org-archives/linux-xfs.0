Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:37320 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750851AbdH3Tud (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 15:50:33 -0400
Subject: [PATCH v3 4/4] ext4: perform dax_device lookup at mount
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 30 Aug 2017 12:44:08 -0700
Message-ID: <150412224853.10177.6213990706281408829.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>

The ->iomap_begin() operation is a hot path, so cache the
fs_dax_get_by_host() result at mount time to avoid the incurring the
hash lookup overhead on a per-i/o basis.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/inode.c |   11 +++--------
 fs/ext4/super.c |    5 +++++
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a2bb7d2870e4..194e622dc3dd 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1528,6 +1528,7 @@ struct ext4_sb_info {
 
 	/* Barrier between changing inodes' journal flags and writepages ops. */
 	struct percpu_rw_semaphore s_journal_flag_rwsem;
+	struct dax_device *s_daxdev;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c774bdc22759..16424b5c4e88 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3404,7 +3404,7 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
 static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 			    unsigned flags, struct iomap *iomap)
 {
-	struct block_device *bdev;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	unsigned int blkbits = inode->i_blkbits;
 	unsigned long first_block = offset >> blkbits;
 	unsigned long last_block = (offset + length - 1) >> blkbits;
@@ -3473,12 +3473,8 @@ static int ext4_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	}
 
 	iomap->flags = 0;
-	bdev = inode->i_sb->s_bdev;
-	iomap->bdev = bdev;
-	if (blk_queue_dax(bdev->bd_queue))
-		iomap->dax_dev = fs_dax_get_by_host(bdev->bd_disk->disk_name);
-	else
-		iomap->dax_dev = NULL;
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->dax_dev = sbi->s_daxdev;
 	iomap->offset = first_block << blkbits;
 
 	if (ret == 0) {
@@ -3511,7 +3507,6 @@ static int ext4_iomap_end(struct inode *inode, loff_t offset, loff_t length,
 	int blkbits = inode->i_blkbits;
 	bool truncate = false;
 
-	fs_put_dax(iomap->dax_dev);
 	if (!(flags & IOMAP_WRITE) || (flags & IOMAP_FAULT))
 		return 0;
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d61a70e2193a..0b3d94e25efb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -864,6 +864,7 @@ static inline void ext4_quota_off_umount(struct super_block *sb)
 static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct dax_device *dax_dev = sbi->s_daxdev;
 	struct ext4_super_block *es = sbi->s_es;
 	int aborted = 0;
 	int i, err;
@@ -952,6 +953,7 @@ static void ext4_put_super(struct super_block *sb)
 		crypto_free_shash(sbi->s_chksum_driver);
 	kfree(sbi->s_blockgroup_lock);
 	kfree(sbi);
+	fs_put_dax(dax_dev);
 }
 
 static struct kmem_cache *ext4_inode_cachep;
@@ -3377,6 +3379,7 @@ static void ext4_set_resv_clusters(struct super_block *sb)
 
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 {
+	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
 	char *orig_data = kstrdup(data, GFP_KERNEL);
 	struct buffer_head *bh;
 	struct ext4_super_block *es = NULL;
@@ -3399,6 +3402,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	ext4_group_t first_not_zeroed;
 
+	sbi->s_daxdev = dax_dev;
 	if ((data && !orig_data) || !sbi)
 		goto out_free_base;
 
@@ -4378,6 +4382,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 out_free_base:
 	kfree(sbi);
 	kfree(orig_data);
+	fs_put_dax(dax_dev);
 	return err ? err : ret;
 }
 

