Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UFioUV124882 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 10:44:50 -0500
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id hpJg0lE8dwIxZYHB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 Mar 2012 08:44:47 -0700 (PDT)
From: Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [RFC PATCH v2 09/21] dio: Convert direct_IO to use iov_iter
Date: Fri, 30 Mar 2012 10:43:36 -0500
Message-Id: <1333122228-13633-10-git-send-email-dave.kleikamp@oracle.com>
In-Reply-To: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>, ocfs2-devel@oss.oracle.com, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, v9fs-developer@lists.sourceforge.net, ceph-devel@vger.kernel.org, Zach Brown <zab@zabbo.net>, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

Change the direct_IO aop to take an iov_iter argument rather than an iovec.
This will get passed down through most filesystems so that only the
__blockdev_direct_IO helper need be aware of whether user or kernel memory
is being passed to the function.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: v9fs-developer@lists.sourceforge.net
Cc: linux-btrfs@vger.kernel.org
Cc: ceph-devel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: jfs-discussion@lists.sourceforge.net
Cc: linux-nfs@vger.kernel.org
Cc: linux-nilfs@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com
Cc: reiserfs-devel@vger.kernel.org
Cc: xfs@oss.sgi.com
---
 Documentation/filesystems/Locking |    4 +--
 Documentation/filesystems/vfs.txt |    4 +--
 fs/9p/vfs_addr.c                  |    8 ++---
 fs/block_dev.c                    |    8 ++---
 fs/btrfs/inode.c                  |   70 ++++++++++++++++++++++---------------
 fs/ceph/addr.c                    |    3 +-
 fs/direct-io.c                    |   19 +++++-----
 fs/ext2/inode.c                   |    8 ++---
 fs/ext3/inode.c                   |   15 ++++----
 fs/ext4/ext4.h                    |    3 +-
 fs/ext4/indirect.c                |   16 ++++-----
 fs/ext4/inode.c                   |   23 ++++++------
 fs/fat/inode.c                    |   10 +++---
 fs/gfs2/aops.c                    |    7 ++--
 fs/hfs/inode.c                    |    7 ++--
 fs/hfsplus/inode.c                |    6 ++--
 fs/jfs/inode.c                    |    7 ++--
 fs/nfs/direct.c                   |    8 ++---
 fs/nilfs2/inode.c                 |    8 ++---
 fs/ocfs2/aops.c                   |    8 ++---
 fs/reiserfs/inode.c               |    7 ++--
 fs/xfs/xfs_aops.c                 |   11 +++---
 include/linux/fs.h                |   18 +++++-----
 include/linux/nfs_fs.h            |    3 +-
 mm/filemap.c                      |   13 +++++--
 25 files changed, 144 insertions(+), 150 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 4fca82e..1e725f7 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -194,8 +194,8 @@ prototypes:
 	int (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
-	int (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs);
+	int (*direct_IO)(int, struct kiocb *, struct iov_iter *iter,
+			loff_t offset);
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int, void **,
 				unsigned long *);
 	int (*migratepage)(struct address_space *, struct page *, struct page *);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 3d9393b..0029302 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -573,8 +573,8 @@ struct address_space_operations {
 	int (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
-	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs);
+	ssize_t (*direct_IO)(int, struct kiocb *, struct iov_iter *iter,
+			loff_t offset);
 	struct page* (*get_xip_page)(struct address_space *, sector_t,
 			int);
 	/* migrate the contents of a page to the specified target */
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 0ad61c6..e70f239 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -239,9 +239,8 @@ static int v9fs_launder_page(struct page *page)
  * v9fs_direct_IO - 9P address space operation for direct I/O
  * @rw: direction (read or write)
  * @iocb: target I/O control block
- * @iov: array of vectors that define I/O buffer
+ * @iter: array of vectors that define I/O buffer
  * @pos: offset in file to begin the operation
- * @nr_segs: size of iovec array
  *
  * The presence of v9fs_direct_IO() in the address space ops vector
  * allowes open() O_DIRECT flags which would have failed otherwise.
@@ -255,8 +254,7 @@ static int v9fs_launder_page(struct page *page)
  *
  */
 static ssize_t
-v9fs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-	       loff_t pos, unsigned long nr_segs)
+v9fs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
 	/*
 	 * FIXME
@@ -265,7 +263,7 @@ v9fs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	 */
 	p9_debug(P9_DEBUG_VFS, "v9fs_direct_IO: v9fs_direct_IO (%s) off/no(%lld/%lu) EINVAL\n",
 		 iocb->ki_filp->f_path.dentry->d_name.name,
-		 (long long)pos, nr_segs);
+		 (long long)pos, iter->nr_segs);
 
 	return -EINVAL;
 }
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 5e9f198..da889ae 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -209,14 +209,14 @@ blkdev_get_blocks(struct inode *inode, sector_t iblock,
 }
 
 static ssize_t
-blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+blkdev_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+			loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov, offset,
-				    nr_segs, blkdev_get_blocks, NULL, NULL, 0);
+	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iter,
+				    offset, blkdev_get_blocks, NULL, NULL, 0);
 }
 
 int __sync_blockdev(struct block_device *bdev, int wait)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 892b347..2d2bb2a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6139,8 +6139,7 @@ free_ordered:
 }
 
 static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+			struct iov_iter *iter, loff_t offset)
 {
 	int seg;
 	int i;
@@ -6154,34 +6153,49 @@ static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *io
 		goto out;
 
 	/* Check the memory alignment.  Blocks cannot straddle pages */
-	for (seg = 0; seg < nr_segs; seg++) {
-		addr = (unsigned long)iov[seg].iov_base;
-		size = iov[seg].iov_len;
-		end += size;
-		if ((addr & blocksize_mask) || (size & blocksize_mask))
-			goto out;
+	if (iov_iter_has_iovec(iter)) {
+		const struct iovec *iov = iov_iter_iovec(iter);
+
+		for (seg = 0; seg < iter->nr_segs; seg++) {
+			addr = (unsigned long)iov[seg].iov_base;
+			size = iov[seg].iov_len;
+			end += size;
+			if ((addr & blocksize_mask) || (size & blocksize_mask))
+				goto out;
 
-		/* If this is a write we don't need to check anymore */
-		if (rw & WRITE)
-			continue;
+			/* If this is a write we don't need to check anymore */
+			if (rw & WRITE)
+				continue;
 
-		/*
-		 * Check to make sure we don't have duplicate iov_base's in this
-		 * iovec, if so return EINVAL, otherwise we'll get csum errors
-		 * when reading back.
-		 */
-		for (i = seg + 1; i < nr_segs; i++) {
-			if (iov[seg].iov_base == iov[i].iov_base)
+			/*
+			 * Check to make sure we don't have duplicate iov_base's
+			 * in this iovec, if so return EINVAL, otherwise we'll
+			 * get csum errors when reading back.
+			 */
+			for (i = seg + 1; i < iter->nr_segs; i++) {
+				if (iov[seg].iov_base == iov[i].iov_base)
+					goto out;
+			}
+		}
+	} else if (iov_iter_has_bvec(iter)) {
+		struct bio_vec *bvec = iov_iter_bvec(iter);
+
+		for (seg = 0; seg < iter->nr_segs; seg++) {
+			addr = (unsigned long)bvec[seg].bv_offset;
+			size = bvec[seg].bv_len;
+			end += size;
+			if ((addr & blocksize_mask) || (size & blocksize_mask))
 				goto out;
 		}
-	}
+	} else
+		BUG();
+
 	retval = 0;
 out:
 	return retval;
 }
 static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+			struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -6191,12 +6205,10 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	ssize_t ret;
 	int writing = rw & WRITE;
 	int write_bits = 0;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 
-	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
-			    offset, nr_segs)) {
+	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iter, offset))
 		return 0;
-	}
 
 	lockstart = offset;
 	lockend = offset + count - 1;
@@ -6248,21 +6260,21 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 
 	ret = __blockdev_direct_IO(rw, iocb, inode,
 		   BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
-		   iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
+		   iter, offset, btrfs_get_blocks_direct, NULL,
 		   btrfs_submit_direct, 0);
 
 	if (ret < 0 && ret != -EIOCBQUEUED) {
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset,
-			      offset + iov_length(iov, nr_segs) - 1,
+			      offset + iov_iter_count(iter) - 1,
 			      EXTENT_LOCKED | write_bits, 1, 0,
 			      &cached_state, GFP_NOFS);
-	} else if (ret >= 0 && ret < iov_length(iov, nr_segs)) {
+	} else if (ret >= 0 && ret < iov_iter_count(iter)) {
 		/*
 		 * We're falling back to buffered, unlock the section we didn't
 		 * do IO on.
 		 */
 		clear_extent_bit(&BTRFS_I(inode)->io_tree, offset + ret,
-			      offset + iov_length(iov, nr_segs) - 1,
+			      offset + iov_iter_count(iter) - 1,
 			      EXTENT_LOCKED | write_bits, 1, 0,
 			      &cached_state, GFP_NOFS);
 	}
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 173b1d2..fce6738 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1144,8 +1144,7 @@ static int ceph_write_end(struct file *file, struct address_space *mapping,
  * never get called.
  */
 static ssize_t ceph_direct_io(int rw, struct kiocb *iocb,
-			      const struct iovec *iov,
-			      loff_t pos, unsigned long nr_segs)
+			      struct iov_iter *iter, loff_t pos)
 {
 	WARN_ON(1);
 	return -EINVAL;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index d1ee42b..b8bdfba 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1123,9 +1123,9 @@ static int dio_aligned(unsigned long offset, unsigned *blkbits,
  */
 static inline ssize_t
 do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags)
+	struct block_device *bdev, struct iov_iter *iter, loff_t offset,
+	get_block_t get_block, dio_iodone_t end_io, dio_submit_t submit_io,
+	int flags)
 {
 	int seg;
 	size_t size;
@@ -1138,6 +1138,8 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	unsigned long user_addr;
 	size_t bytes;
 	struct buffer_head map_bh = { 0, };
+	const struct iovec *iov = iov_iter_iovec(iter);
+	unsigned long nr_segs = iter->nr_segs;
 
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
@@ -1335,9 +1337,9 @@ out:
 
 ssize_t
 __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset,
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags)
+	struct block_device *bdev, struct iov_iter *iter, loff_t offset,
+	get_block_t get_block, dio_iodone_t end_io, dio_submit_t submit_io,
+	int flags)
 {
 	/*
 	 * The block device state is needed in the end to finally
@@ -1351,9 +1353,8 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	prefetch(bdev->bd_queue);
 	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
 
-	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				     nr_segs, get_block, end_io,
-				     submit_io, flags);
+	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iter, offset,
+				     get_block, end_io, submit_io, flags);
 }
 
 EXPORT_SYMBOL(__blockdev_direct_IO);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 740cad8..3c44aab 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -830,18 +830,16 @@ static sector_t ext2_bmap(struct address_space *mapping, sector_t block)
 }
 
 static ssize_t
-ext2_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+ext2_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 ext2_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, ext2_get_block);
 	if (ret < 0 && (rw & WRITE))
-		ext2_write_failed(mapping, offset + iov_length(iov, nr_segs));
+		ext2_write_failed(mapping, offset + iov_iter_count(iter));
 	return ret;
 }
 
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 2d0afec..c2b49b5 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1863,8 +1863,7 @@ static int ext3_releasepage(struct page *page, gfp_t wait)
  * VFS code falls back into buffered path in that case so we are safe.
  */
 static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+			struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -1872,10 +1871,10 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 	int retries = 0;
 
-	trace_ext3_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw);
+	trace_ext3_direct_IO_enter(inode, offset, count, rw);
 
 	if (rw == WRITE) {
 		loff_t final_size = offset + count;
@@ -1899,15 +1898,14 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 retry:
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 ext3_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, ext3_get_block);
 	/*
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again.
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + count;
 
 		if (end > isize)
 			ext3_truncate_failed_direct_write(inode);
@@ -1950,8 +1948,7 @@ retry:
 			ret = err;
 	}
 out:
-	trace_ext3_direct_IO_exit(inode, offset,
-				iov_length(iov, nr_segs), rw, ret);
+	trace_ext3_direct_IO_exit(inode, offset, count, rw, ret);
 	return ret;
 }
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 513004f..b680581 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1903,8 +1903,7 @@ extern void ext4_da_update_reserve_space(struct inode *inode,
 extern int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 				struct ext4_map_blocks *map, int flags);
 extern ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
-				const struct iovec *iov, loff_t offset,
-				unsigned long nr_segs);
+				struct iov_iter *iter, loff_t offset);
 extern int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock);
 extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks, int chunk);
 extern void ext4_ind_truncate(struct inode *inode);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 830e1b2..d6ee840 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -772,8 +772,7 @@ out:
  * VFS code falls back into buffered path in that case so we are safe.
  */
 ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
-			   const struct iovec *iov, loff_t offset,
-			   unsigned long nr_segs)
+			   struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -781,7 +780,7 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 	int retries = 0;
 
 	if (rw == WRITE) {
@@ -813,16 +812,15 @@ retry:
 			mutex_unlock(&inode->i_mutex);
 		}
 		ret = __blockdev_direct_IO(rw, iocb, inode,
-				 inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
-				 ext4_get_block, NULL, NULL, 0);
+				 inode->i_sb->s_bdev, iter,
+				 offset, ext4_get_block, NULL, NULL, 0);
 	} else {
-		ret = blockdev_direct_IO(rw, iocb, inode, iov,
-				 offset, nr_segs, ext4_get_block);
+		ret = blockdev_direct_IO(rw, iocb, inode, iter,
+				 offset, ext4_get_block);
 
 		if (unlikely((rw & WRITE) && ret < 0)) {
 			loff_t isize = i_size_read(inode);
-			loff_t end = offset + iov_length(iov, nr_segs);
+			loff_t end = offset + iov_iter_count(iter);
 
 			if (end > isize)
 				ext4_truncate_failed_write(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index feaa82f..db86d11 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2888,13 +2888,12 @@ retry:
  *
  */
 static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+			      struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 
 	loff_t final_size = offset + count;
 	if (rw == WRITE && final_size <= inode->i_size) {
@@ -2935,8 +2934,8 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		}
 
 		ret = __blockdev_direct_IO(rw, iocb, inode,
-					 inode->i_sb->s_bdev, iov,
-					 offset, nr_segs,
+					 inode->i_sb->s_bdev, iter,
+					 offset,
 					 ext4_get_block_write,
 					 ext4_end_io_dio,
 					 NULL,
@@ -2977,12 +2976,11 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 	/* for write the the end of file case, we fall back to old way */
-	return ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
+	return ext4_ind_direct_IO(rw, iocb, iter, offset);
 }
 
 static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+			      struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -2994,13 +2992,12 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	if (ext4_should_journal_data(inode))
 		return 0;
 
-	trace_ext4_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw);
+	trace_ext4_direct_IO_enter(inode, offset, iov_iter_count(iter), rw);
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		ret = ext4_ext_direct_IO(rw, iocb, iov, offset, nr_segs);
+		ret = ext4_ext_direct_IO(rw, iocb, iter, offset);
 	else
-		ret = ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
-	trace_ext4_direct_IO_exit(inode, offset,
-				iov_length(iov, nr_segs), rw, ret);
+		ret = ext4_ind_direct_IO(rw, iocb, iter, offset);
+	trace_ext4_direct_IO_exit(inode, offset, iov_iter_count(iter), rw, ret);
 	return ret;
 }
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 3ab8410..22cfb80 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -184,8 +184,7 @@ static int fat_write_end(struct file *file, struct address_space *mapping,
 }
 
 static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
-			     const struct iovec *iov,
-			     loff_t offset, unsigned long nr_segs)
+			     struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -202,7 +201,7 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 		 *
 		 * Return 0, and fallback to normal buffered write.
 		 */
-		loff_t size = offset + iov_length(iov, nr_segs);
+		loff_t size = offset + iov_iter_count(iter);
 		if (MSDOS_I(inode)->mmu_private < size)
 			return 0;
 	}
@@ -211,10 +210,9 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 	 * FAT need to use the DIO_LOCKING for avoiding the race
 	 * condition of fat_get_block() and ->truncate().
 	 */
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 fat_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, fat_get_block);
 	if (ret < 0 && (rw & WRITE))
-		fat_write_failed(mapping, offset + iov_length(iov, nr_segs));
+		fat_write_failed(mapping, offset + iov_iter_count(iter));
 
 	return ret;
 }
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 501e5cb..cb0c19f 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -1007,8 +1007,7 @@ static int gfs2_ok_for_dio(struct gfs2_inode *ip, int rw, loff_t offset)
 
 
 static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+			      struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -1032,8 +1031,8 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 	if (rv != 1)
 		goto out; /* dio not valid, fall back to buffered i/o */
 
-	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, gfs2_get_block_direct,
+	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iter,
+				  offset, gfs2_get_block_direct,
 				  NULL, NULL, 0);
 out:
 	gfs2_glock_dq_m(1, &gh);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 737dbeb..96650e7 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -117,14 +117,13 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 }
 
 static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
-		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+		struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 hfs_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, hfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
@@ -132,7 +131,7 @@ static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			vmtruncate(inode, isize);
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 6643b24..76e3f8e 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -113,13 +113,13 @@ static int hfsplus_releasepage(struct page *page, gfp_t mask)
 }
 
 static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
-		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+		struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset,
 				 hfsplus_get_block);
 
 	/*
@@ -128,7 +128,7 @@ static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			vmtruncate(inode, isize);
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 77b69b2..3dabfc9 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -323,14 +323,13 @@ static sector_t jfs_bmap(struct address_space *mapping, sector_t block)
 }
 
 static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
-	const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+			     struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 jfs_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, jfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
@@ -338,7 +337,7 @@ static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			vmtruncate(inode, isize);
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 1940f1a..9d0f3c2 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -107,20 +107,20 @@ static inline int put_dreq(struct nfs_direct_req *dreq)
  * nfs_direct_IO - NFS address space operation for direct I/O
  * @rw: direction (read or write)
  * @iocb: target I/O control block
- * @iov: array of vectors that define I/O buffer
+ * @iter: array of vectors that define I/O buffer
  * @pos: offset in file to begin the operation
- * @nr_segs: size of iovec array
  *
  * The presence of this routine in the address space ops vector means
  * the NFS client supports direct I/O.  However, we shunt off direct
  * read and write requests before the VFS gets them, so this method
  * should never be called.
  */
-ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t pos, unsigned long nr_segs)
+ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+		      loff_t pos)
 {
 	dprintk("NFS: nfs_direct_IO (%s) off/no(%Ld/%lu) EINVAL\n",
 			iocb->ki_filp->f_path.dentry->d_name.name,
-			(long long) pos, nr_segs);
+			(long long) pos, iter->nr_segs);
 
 	return -EINVAL;
 }
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 8f7b95a..882159f 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -248,8 +248,8 @@ static int nilfs_write_end(struct file *file, struct address_space *mapping,
 }
 
 static ssize_t
-nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-		loff_t offset, unsigned long nr_segs)
+nilfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+		loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -259,7 +259,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		return 0;
 
 	/* Needs synchronization with the cleaner */
-	size = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+	size = blockdev_direct_IO(rw, iocb, inode, iter, offset,
 				  nilfs_get_block);
 
 	/*
@@ -268,7 +268,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	 */
 	if (unlikely((rw & WRITE) && size < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			vmtruncate(inode, isize);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 78b68af..f4f2c1e 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -621,9 +621,8 @@ static int ocfs2_releasepage(struct page *page, gfp_t wait)
 
 static ssize_t ocfs2_direct_IO(int rw,
 			       struct kiocb *iocb,
-			       const struct iovec *iov,
-			       loff_t offset,
-			       unsigned long nr_segs)
+			       struct iov_iter *iter,
+			       loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_path.dentry->d_inode->i_mapping->host;
@@ -640,8 +639,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 		return 0;
 
 	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
-				    iov, offset, nr_segs,
-				    ocfs2_direct_IO_get_blocks,
+				    iter, offset, ocfs2_direct_IO_get_blocks,
 				    ocfs2_dio_end_io, NULL, 0);
 }
 
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 9e8cd5a..3142d40 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3066,14 +3066,13 @@ static int reiserfs_releasepage(struct page *page, gfp_t unused_gfp_flags)
 /* We thank Mingming Cao for helping us understand in great detail what
    to do in this section of the code. */
 static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
-				  const struct iovec *iov, loff_t offset,
-				  unsigned long nr_segs)
+				  struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset,
 				  reiserfs_get_blocks_direct_io);
 
 	/*
@@ -3082,7 +3081,7 @@ static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			vmtruncate(inode, isize);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 74b9baf..053a213 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1308,9 +1308,8 @@ STATIC ssize_t
 xfs_vm_direct_IO(
 	int			rw,
 	struct kiocb		*iocb,
-	const struct iovec	*iov,
-	loff_t			offset,
-	unsigned long		nr_segs)
+	struct iov_iter		*iter,
+	loff_t			offset)
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
@@ -1319,15 +1318,13 @@ xfs_vm_direct_IO(
 	if (rw & WRITE) {
 		iocb->private = xfs_alloc_ioend(inode, IO_DIRECT);
 
-		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
-					    offset, nr_segs,
+		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iter, offset,
 					    xfs_get_blocks_direct,
 					    xfs_end_io_direct_write, NULL, 0);
 		if (ret != -EIOCBQUEUED && iocb->private)
 			xfs_destroy_ioend(iocb->private);
 	} else {
-		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
-					    offset, nr_segs,
+		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iter, offset,
 					    xfs_get_blocks_direct,
 					    NULL, NULL, 0);
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5b69020..86ac246 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -690,8 +690,8 @@ struct address_space_operations {
 	void (*invalidatepage) (struct page *, unsigned long);
 	int (*releasepage) (struct page *, gfp_t);
 	void (*freepage)(struct page *);
-	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs);
+	ssize_t (*direct_IO)(int, struct kiocb *, struct iov_iter *iter,
+			loff_t offset);
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
 						void **, unsigned long *);
 	/*
@@ -2518,16 +2518,16 @@ void inode_dio_wait(struct inode *inode);
 void inode_dio_done(struct inode *inode);
 
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset,
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags);
+	struct block_device *bdev, struct iov_iter *iter, loff_t offset,
+	get_block_t get_block, dio_iodone_t end_io, dio_submit_t submit_io,
+	int flags);
 
 static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
-		struct inode *inode, const struct iovec *iov, loff_t offset,
-		unsigned long nr_segs, get_block_t get_block)
+		struct inode *inode, struct iov_iter *iter, loff_t offset,
+		get_block_t get_block)
 {
-	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				    offset, nr_segs, get_block, NULL, NULL,
+	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iter,
+				    offset, get_block, NULL, NULL,
 				    DIO_LOCKING | DIO_SKIP_HOLES);
 }
 #else
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 8c29950..50fd8ca 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -451,8 +451,7 @@ extern int nfs3_removexattr (struct dentry *, const char *name);
 /*
  * linux/fs/nfs/direct.c
  */
-extern ssize_t nfs_direct_IO(int, struct kiocb *, const struct iovec *, loff_t,
-			unsigned long);
+extern ssize_t nfs_direct_IO(int, struct kiocb *, struct iov_iter *, loff_t);
 extern ssize_t nfs_file_direct_read(struct kiocb *iocb,
 			const struct iovec *iov, unsigned long nr_segs,
 			loff_t pos);
diff --git a/mm/filemap.c b/mm/filemap.c
index 0533a71..b6f45b4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1418,14 +1418,18 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 			goto out; /* skip atime */
 		size = i_size_read(inode);
 		if (pos < size) {
+			size_t bytes = iov_length(iov, nr_segs);
 			retval = filemap_write_and_wait_range(mapping, pos,
-					pos + iov_length(iov, nr_segs) - 1);
+					pos + bytes - 1);
 			if (!retval) {
 				struct blk_plug plug;
+				struct iov_iter iter;
+
+				iov_iter_init(&iter, iov, nr_segs, bytes, 0);
 
 				blk_start_plug(&plug);
 				retval = mapping->a_ops->direct_IO(READ, iocb,
-							iov, pos, nr_segs);
+							&iter, pos);
 				blk_finish_plug(&plug);
 			}
 			if (retval > 0) {
@@ -2126,6 +2130,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	ssize_t		written;
 	size_t		write_len;
 	pgoff_t		end;
+	struct iov_iter iter;
 
 	if (count != ocount)
 		*nr_segs = iov_shorten((struct iovec *)iov, *nr_segs, count);
@@ -2157,7 +2162,9 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 	}
 
-	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
+	iov_iter_init(&iter, iov, *nr_segs, write_len, 0);
+
+	written = mapping->a_ops->direct_IO(WRITE, iocb, &iter, pos);
 
 	/*
 	 * Finally, try again to invalidate clean pages which might have been
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
