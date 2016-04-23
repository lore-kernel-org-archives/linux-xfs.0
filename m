Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 87CFD7CCB
	for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 14:14:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3171AC003
	for <xfs@oss.sgi.com>; Sat, 23 Apr 2016 12:14:06 -0700 (PDT)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65]) by
	cuda.sgi.com with ESMTP id EMdfpPErGs1mzoM4 for
	<xfs@oss.sgi.com>; Sat, 23 Apr 2016 12:14:05 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 5/7] dax: handle media errors in dax_do_io
Date: Sat, 23 Apr 2016 13:13:40 -0600
Message-Id: <1461438822-3592-6-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1461438822-3592-1-git-send-email-vishal.l.verma@intel.com>
References: <1461438822-3592-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Vishal Verma <vishal.l.verma@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>

dax_do_io (called for read() or write() for a dax file system) may fail
in the presence of bad blocks or media errors. Since we expect that a
write should clear media errors on nvdimms, make dax_do_io fall back to
the direct_IO path, which will send down a bio to the driver, which can
then attempt to clear the error.

Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@fb.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 fs/block_dev.c      |  5 +++--
 fs/ext2/inode.c     |  5 +++--
 fs/ext4/inode.c     |  5 +++--
 fs/xfs/xfs_aops.c   |  8 ++++----
 include/linux/dax.h | 30 ++++++++++++++++++++++++++++++
 5 files changed, 43 insertions(+), 10 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 79defba..7c90516 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -168,8 +168,9 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 	struct inode *inode = bdev_file_inode(file);
 
 	if (IS_DAX(inode))
-		return dax_do_io(iocb, inode, iter, offset, blkdev_get_block,
-				NULL, DIO_SKIP_DIO_COUNT);
+		return dax_io_fallback(iocb, inode, I_BDEV(inode), iter, offset,
+				blkdev_get_block, blkdev_get_block,
+				NULL, NULL, DIO_SKIP_DIO_COUNT);
 	return __blockdev_direct_IO(iocb, inode, I_BDEV(inode), iter, offset,
 				    blkdev_get_block, NULL, NULL,
 				    DIO_SKIP_DIO_COUNT);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 35f2b0bf..1cec54b 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -862,8 +862,9 @@ ext2_direct_IO(struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 	ssize_t ret;
 
 	if (IS_DAX(inode))
-		ret = dax_do_io(iocb, inode, iter, offset, ext2_get_block, NULL,
-				DIO_LOCKING);
+		ret = dax_io_fallback(iocb, inode, inode->i_sb->s_bdev, iter,
+				offset, ext2_get_block, ext2_get_block,
+				NULL, NULL, DIO_LOCKING | DIO_SKIP_HOLES);
 	else
 		ret = blockdev_direct_IO(iocb, inode, iter, offset,
 					 ext2_get_block);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6d5d5c1..d29848b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3411,8 +3411,9 @@ static ssize_t ext4_direct_IO_write(struct kiocb *iocb, struct iov_iter *iter,
 	BUG_ON(ext4_encrypted_inode(inode) && S_ISREG(inode->i_mode));
 #endif
 	if (IS_DAX(inode)) {
-		ret = dax_do_io(iocb, inode, iter, offset, get_block_func,
-				ext4_end_io_dio, dio_flags);
+		ret = dax_io_fallback(iocb, inode, inode->i_sb->s_bdev, iter,
+				offset, get_block_func, get_block_func,
+				ext4_end_io_dio, NULL, dio_flags);
 	} else
 		ret = __blockdev_direct_IO(iocb, inode,
 					   inode->i_sb->s_bdev, iter, offset,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e49b240..48fe10a 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1412,7 +1412,7 @@ xfs_vm_direct_IO(
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 	dio_iodone_t		*endio = NULL;
 	int			flags = 0;
-	struct block_device	*bdev;
+	struct block_device     *bdev = xfs_find_bdev_for_inode(inode);
 
 	if (iov_iter_rw(iter) == WRITE) {
 		endio = xfs_end_io_direct_write;
@@ -1420,11 +1420,11 @@ xfs_vm_direct_IO(
 	}
 
 	if (IS_DAX(inode)) {
-		return dax_do_io(iocb, inode, iter, offset,
-				 xfs_get_blocks_direct, endio, 0);
+		return dax_io_fallback(iocb, inode, bdev, iter, offset,
+				xfs_get_blocks_direct, xfs_get_blocks_direct,
+				endio, NULL, flags);
 	}
 
-	bdev = xfs_find_bdev_for_inode(inode);
 	return  __blockdev_direct_IO(iocb, inode, bdev, iter, offset,
 			xfs_get_blocks_direct, endio, NULL, flags);
 }
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 426841a..7200e6f 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -3,6 +3,7 @@
 
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include <linux/uio.h>
 #include <linux/radix-tree.h>
 #include <asm/pgtable.h>
 
@@ -64,4 +65,33 @@ static inline bool dax_mapping(struct address_space *mapping)
 struct writeback_control;
 int dax_writeback_mapping_range(struct address_space *mapping,
 		struct block_device *bdev, struct writeback_control *wbc);
+/*
+ * This is a wrapper for dax_do_io which may be used for writes, and will
+ * perform a fallback to direct_io semantics if the dax_io fails due to a
+ * media error.
+ */
+static inline ssize_t dax_io_fallback(struct kiocb *iocb, struct inode *inode,
+		struct block_device *bdev, struct iov_iter *iter, loff_t pos,
+		get_block_t dax_get_block, get_block_t dio_get_block,
+		dio_iodone_t end_io, dio_submit_t submit_io, int flags)
+{
+	ssize_t retval;
+
+	retval = dax_do_io(iocb, inode, iter, pos, dax_get_block, end_io,
+			flags);
+	if (iov_iter_rw(iter) == WRITE && retval == -EIO) {
+		/*
+		 * __dax_do_io may have failed a write due to a bad block.
+		 * Retry with direct_io, and if the direct_IO also fails
+		 * (with the exception of -EIOCBQUEUED), return -EIO as
+		 * that was the original error that led us down the
+		 * direct_IO path.
+		 */
+		retval = __blockdev_direct_IO(iocb, inode, bdev, iter, pos,
+				dio_get_block, end_io, submit_io, flags);
+		if (retval < 0 && retval != -EIOCBQUEUED)
+			return -EIO;
+	}
+	return retval;
+}
 #endif
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
