Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7FD9B7CB4
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 14:49:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E6C7BAC008
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 12:49:18 -0800 (PST)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	8GEG3NQp3drXhPy5 for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 12:49:17 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 1/2] dax: supply DAX clearing code with correct bdev
Date: Wed, 10 Feb 2016 13:48:55 -0700
Message-Id: <1455137336-28720-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1455137336-28720-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1455137336-28720-1-git-send-email-ross.zwisler@linux.intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, xfs@oss.sgi.com, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

dax_clear_blocks() needs a valid struct block_device and previously it was
using inode->i_sb->s_bdev in all cases.  This is correct for normal inodes
on mounted ext2, ext4 and XFS filesystems, but is incorrect for DAX raw
block devices and for XFS real-time devices.

Instead, rename dax_clear_blocks() to dax_clear_sectors(), and change its
arguments to take a bdev and a sector instead of an inode and a block.
This better reflects what the function does, and it allows the filesystem
and raw block device code to pass in an appropriate struct block_device.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c               | 9 ++++-----
 fs/ext2/inode.c        | 6 ++++--
 fs/xfs/xfs_aops.c      | 2 +-
 fs/xfs/xfs_aops.h      | 1 +
 fs/xfs/xfs_bmap_util.c | 3 ++-
 include/linux/dax.h    | 2 +-
 6 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index fc2e314..9a173dd 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -79,15 +79,14 @@ struct page *read_dax_sector(struct block_device *bdev, sector_t n)
 }
 
 /*
- * dax_clear_blocks() is called from within transaction context from XFS,
+ * dax_clear_sectors() is called from within transaction context from XFS,
  * and hence this means the stack from this point must follow GFP_NOFS
  * semantics for all operations.
  */
-int dax_clear_blocks(struct inode *inode, sector_t block, long _size)
+int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size)
 {
-	struct block_device *bdev = inode->i_sb->s_bdev;
 	struct blk_dax_ctl dax = {
-		.sector = block << (inode->i_blkbits - 9),
+		.sector = _sector,
 		.size = _size,
 	};
 
@@ -109,7 +108,7 @@ int dax_clear_blocks(struct inode *inode, sector_t block, long _size)
 	wmb_pmem();
 	return 0;
 }
-EXPORT_SYMBOL_GPL(dax_clear_blocks);
+EXPORT_SYMBOL_GPL(dax_clear_sectors);
 
 /* the clear_pmem() calls are ordered by a wmb_pmem() in the caller */
 static void dax_new_buf(void __pmem *addr, unsigned size, unsigned first,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 338eefd..b6b965b 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -737,8 +737,10 @@ static int ext2_get_blocks(struct inode *inode,
 		 * so that it's not found by another thread before it's
 		 * initialised
 		 */
-		err = dax_clear_blocks(inode, le32_to_cpu(chain[depth-1].key),
-						1 << inode->i_blkbits);
+		err = dax_clear_sectors(inode->i_sb->s_bdev,
+				le32_to_cpu(chain[depth-1].key) <<
+				(inode->i_blkbits - 9),
+				1 << inode->i_blkbits);
 		if (err) {
 			mutex_unlock(&ei->truncate_mutex);
 			goto cleanup;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 379c089..fc20518 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -55,7 +55,7 @@ xfs_count_page_state(
 	} while ((bh = bh->b_this_page) != head);
 }
 
-STATIC struct block_device *
+struct block_device *
 xfs_find_bdev_for_inode(
 	struct inode		*inode)
 {
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index f6ffc9a..a4343c6 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -62,5 +62,6 @@ int	xfs_get_blocks_dax_fault(struct inode *inode, sector_t offset,
 			         struct buffer_head *map_bh, int create);
 
 extern void xfs_count_page_state(struct page *, int *, int *);
+extern struct block_device *xfs_find_bdev_for_inode(struct inode *);
 
 #endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 07ef29b..ae9d755 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -75,7 +75,8 @@ xfs_zero_extent(
 	ssize_t		size = XFS_FSB_TO_B(mp, count_fsb);
 
 	if (IS_DAX(VFS_I(ip)))
-		return dax_clear_blocks(VFS_I(ip), block, size);
+		return dax_clear_sectors(xfs_find_bdev_for_inode(VFS_I(ip)),
+				sector, size);
 
 	/*
 	 * let the block layer decide on the fastest method of
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 818e450..7b6bced 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -7,7 +7,7 @@
 
 ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
 		  get_block_t, dio_iodone_t, int flags);
-int dax_clear_blocks(struct inode *, sector_t block, long size);
+int dax_clear_sectors(struct block_device *bdev, sector_t _sector, long _size);
 int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 int dax_truncate_page(struct inode *, loff_t from, get_block_t);
 int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
