Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2AB5A7CA3
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 01:19:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A20EDAC001
	for <xfs@oss.sgi.com>; Sat,  6 Feb 2016 23:19:34 -0800 (PST)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id LrydzCQQ3lH43TRJ for
	<xfs@oss.sgi.com>; Sat, 06 Feb 2016 23:19:32 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] dax: pass bdev argument to dax_clear_blocks()
Date: Sun,  7 Feb 2016 00:19:12 -0700
Message-Id: <1454829553-29499-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1454829553-29499-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1454829553-29499-1-git-send-email-ross.zwisler@linux.intel.com>
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

Instead, have the caller pass in a struct block_device pointer which it
knows to be correct.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/dax.c               | 4 ++--
 fs/ext2/inode.c        | 5 +++--
 fs/xfs/xfs_aops.c      | 2 +-
 fs/xfs/xfs_aops.h      | 1 +
 fs/xfs/xfs_bmap_util.c | 4 +++-
 include/linux/dax.h    | 3 ++-
 6 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 227974a..4592241 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -83,9 +83,9 @@ struct page *read_dax_sector(struct block_device *bdev, sector_t n)
  * and hence this means the stack from this point must follow GFP_NOFS
  * semantics for all operations.
  */
-int dax_clear_blocks(struct inode *inode, sector_t block, long _size)
+int dax_clear_blocks(struct inode *inode, struct block_device *bdev,
+		sector_t block, long _size)
 {
-	struct block_device *bdev = inode->i_sb->s_bdev;
 	struct blk_dax_ctl dax = {
 		.sector = block << (inode->i_blkbits - 9),
 		.size = _size,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 338eefd..277a32b 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -737,8 +737,9 @@ static int ext2_get_blocks(struct inode *inode,
 		 * so that it's not found by another thread before it's
 		 * initialised
 		 */
-		err = dax_clear_blocks(inode, le32_to_cpu(chain[depth-1].key),
-						1 << inode->i_blkbits);
+		err = dax_clear_blocks(inode, inode->i_sb->s_bdev,
+				le32_to_cpu(chain[depth-1].key),
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
index 07ef29b..f722ba2 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -73,9 +73,11 @@ xfs_zero_extent(
 	xfs_daddr_t	sector = xfs_fsb_to_db(ip, start_fsb);
 	sector_t	block = XFS_BB_TO_FSBT(mp, sector);
 	ssize_t		size = XFS_FSB_TO_B(mp, count_fsb);
+	struct inode	*inode = VFS_I(ip);
 
 	if (IS_DAX(VFS_I(ip)))
-		return dax_clear_blocks(VFS_I(ip), block, size);
+		return dax_clear_blocks(inode, xfs_find_bdev_for_inode(inode),
+				block, size);
 
 	/*
 	 * let the block layer decide on the fastest method of
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 8204c3d..bad27b0 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -7,7 +7,8 @@
 
 ssize_t dax_do_io(struct kiocb *, struct inode *, struct iov_iter *, loff_t,
 		  get_block_t, dio_iodone_t, int flags);
-int dax_clear_blocks(struct inode *, sector_t block, long size);
+int dax_clear_blocks(struct inode *inode, struct block_device *bdev,
+		sector_t block, long _size);
 int dax_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 int dax_truncate_page(struct inode *, loff_t from, get_block_t);
 int dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
