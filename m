Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF65F7CB5
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 09:45:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4A3C6AC006
	for <xfs@oss.sgi.com>; Wed,  1 Jun 2016 07:45:10 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id CL2reS3HSKVTPNf7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Jun 2016 07:45:06 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/14] fs: introduce iomap infrastructure
Date: Wed,  1 Jun 2016 16:44:45 +0200
Message-Id: <1464792297-13185-3-git-send-email-hch@lst.de>
In-Reply-To: <1464792297-13185-1-git-send-email-hch@lst.de>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
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
To: xfs@oss.sgi.com
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org

Add infrastructure for multipage buffered writes.  This is implemented
using an main iterator that applies an actor function to a range that
can be written.

This infrastucture is used to implement a buffered write helper, one
to zero file ranges and one to implement the ->page_mkwrite VM
operations.  All of them borrow a fair amount of code from fs/buffers.
for now by using an internal version of __block_write_begin that
gets passed an iomap and builds the corresponding buffer head.

The file system is gets a set of paired ->iomap_begin and ->iomap_end
calls which allow it to map/reserve a range and get a notification
once the write code is finished with it.

Based on earlier code from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
---
 fs/Kconfig            |   3 +
 fs/Makefile           |   1 +
 fs/buffer.c           |  76 +++++++++-
 fs/internal.h         |   3 +
 fs/iomap.c            | 394 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h |  56 ++++++-
 6 files changed, 523 insertions(+), 10 deletions(-)
 create mode 100644 fs/iomap.c

diff --git a/fs/Kconfig b/fs/Kconfig
index b8fcb41..4524916 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -10,6 +10,9 @@ config DCACHE_WORD_ACCESS
 
 if BLOCK
 
+config FS_IOMAP
+	bool
+
 source "fs/ext2/Kconfig"
 source "fs/ext4/Kconfig"
 source "fs/jbd2/Kconfig"
diff --git a/fs/Makefile b/fs/Makefile
index 85b6e13..ed2b632 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_COREDUMP)		+= coredump.o
 obj-$(CONFIG_SYSCTL)		+= drop_caches.o
 
 obj-$(CONFIG_FHANDLE)		+= fhandle.o
+obj-$(CONFIG_FS_IOMAP)		+= iomap.o
 
 obj-y				+= quota/
 
diff --git a/fs/buffer.c b/fs/buffer.c
index 754813a..228288a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/syscalls.h>
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/mm.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
@@ -1891,8 +1892,62 @@ void page_zero_new_buffers(struct page *page, unsigned from, unsigned to)
 }
 EXPORT_SYMBOL(page_zero_new_buffers);
 
-int __block_write_begin(struct page *page, loff_t pos, unsigned len,
-		get_block_t *get_block)
+static void
+iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
+		struct iomap *iomap)
+{
+	loff_t offset = block << inode->i_blkbits;
+
+	bh->b_bdev = iomap->bdev;
+
+	/*
+	 * Block points to offset in file we need to map, iomap contains
+	 * the offset at which the map starts. If the map ends before the
+	 * current block, then do not map the buffer and let the caller
+	 * handle it.
+	 */
+	BUG_ON(offset >= iomap->offset + iomap->length);
+
+	switch (iomap->type) {
+	case IOMAP_HOLE:
+		/*
+		 * If the buffer is not up to date or beyond the current EOF,
+		 * we need to mark it as new to ensure sub-block zeroing is
+		 * executed if necessary.
+		 */
+		if (!buffer_uptodate(bh) ||
+		    (offset >= i_size_read(inode)))
+			set_buffer_new(bh);
+		break;
+	case IOMAP_DELALLOC:
+		if (!buffer_uptodate(bh) ||
+		    (offset >= i_size_read(inode)))
+			set_buffer_new(bh);
+		set_buffer_uptodate(bh);
+		set_buffer_mapped(bh);
+		set_buffer_delay(bh);
+		break;
+	case IOMAP_UNWRITTEN:
+		/*
+		 * For unwritten regions, we always need to ensure that
+		 * sub-block writes cause the regions in the block we are not
+		 * writing to are zeroed. Set the buffer as new to ensure this.
+		 */
+		set_buffer_new(bh);
+		set_buffer_unwritten(bh);
+		/* FALLTHRU */
+	case IOMAP_MAPPED:
+		if (offset >= i_size_read(inode))
+			set_buffer_new(bh);
+		bh->b_blocknr = (iomap->blkno >> (inode->i_blkbits - 9)) +
+				((offset - iomap->offset) >> inode->i_blkbits);
+		set_buffer_mapped(bh);
+		break;
+	}
+}
+
+int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
+		get_block_t *get_block, struct iomap *iomap)
 {
 	unsigned from = pos & (PAGE_SIZE - 1);
 	unsigned to = from + len;
@@ -1928,9 +1983,14 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 			clear_buffer_new(bh);
 		if (!buffer_mapped(bh)) {
 			WARN_ON(bh->b_size != blocksize);
-			err = get_block(inode, block, bh, 1);
-			if (err)
-				break;
+			if (get_block) {
+				err = get_block(inode, block, bh, 1);
+				if (err)
+					break;
+			} else {
+				iomap_to_bh(inode, block, bh, iomap);
+			}
+
 			if (buffer_new(bh)) {
 				unmap_underlying_metadata(bh->b_bdev,
 							bh->b_blocknr);
@@ -1971,6 +2031,12 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 		page_zero_new_buffers(page, from, to);
 	return err;
 }
+
+int __block_write_begin(struct page *page, loff_t pos, unsigned len,
+		get_block_t *get_block)
+{
+	return __block_write_begin_int(page, pos, len, get_block, NULL);
+}
 EXPORT_SYMBOL(__block_write_begin);
 
 static int __block_commit_write(struct inode *inode, struct page *page,
diff --git a/fs/internal.h b/fs/internal.h
index b71deee..c0c6f49 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -11,6 +11,7 @@
 
 struct super_block;
 struct file_system_type;
+struct iomap;
 struct linux_binprm;
 struct path;
 struct mount;
@@ -39,6 +40,8 @@ static inline int __sync_blockdev(struct block_device *bdev, int wait)
  * buffer.c
  */
 extern void guard_bio_eod(int rw, struct bio *bio);
+extern int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
+		get_block_t *get_block, struct iomap *iomap);
 
 /*
  * char_dev.c
diff --git a/fs/iomap.c b/fs/iomap.c
new file mode 100644
index 0000000..5cc6d48
--- /dev/null
+++ b/fs/iomap.c
@@ -0,0 +1,394 @@
+/*
+ * Copyright (C) 2010 Red Hat, Inc.
+ * Copyright (c) 2016 Christoph Hellwig.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/fs.h>
+#include <linux/iomap.h>
+#include <linux/uaccess.h>
+#include <linux/gfp.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/pagemap.h>
+#include <linux/file.h>
+#include <linux/uio.h>
+#include <linux/backing-dev.h>
+#include <linux/buffer_head.h>
+#include "internal.h"
+
+typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
+		void *data, struct iomap *iomap);
+
+/*
+ * Execute a iomap write on a segment of the mapping that spans a
+ * contiguous range of pages that have identical block mapping state.
+ *
+ * This avoids the need to map pages individually, do individual allocations
+ * for each page and most importantly avoid the need for filesystem specific
+ * locking per page. Instead, all the operations are amortised over the entire
+ * range of pages. It is assumed that the filesystems will lock whatever
+ * resources they require in the iomap_begin call, and release them in the
+ * iomap_end call.
+ */
+static loff_t
+iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
+		struct iomap_ops *ops, void *data, iomap_actor_t actor)
+{
+	struct iomap iomap = { 0 };
+	loff_t written = 0, ret;
+
+	/*
+	 * Need to map a range from start position for count bytes. This can
+	 * span multiple pages - it is only guaranteed to return a range of a
+	 * single type of pages (e.g. all into a hole, all mapped or all
+	 * unwritten). Failure at this point has nothing to undo.
+	 *
+	 * If allocation is required for this range, reserve the space now so
+	 * that the allocation is guaranteed to succeed later on. Once we copy
+	 * the data into the page cache pages, then we cannot fail otherwise we
+	 * expose transient stale data. If the reserve fails, we can safely
+	 * back out at this point as there is nothing to undo.
+	 */
+	ret = ops->iomap_begin(inode, pos, length, flags, &iomap);
+	if (ret)
+		return ret;
+	if (WARN_ON(iomap.offset > pos))
+		return -EIO;
+
+	/*
+	 * Cut down the length to the one actually provided by the filesystem,
+	 * as it might not be able to give us the whole size that we requested.
+	 */
+	if (iomap.offset + iomap.length < pos + length)
+		length = iomap.offset + iomap.length - pos;
+
+	/*
+	 * Now that we have guaranteed that the space allocation will succeed.
+	 * we can do the copy-in page by page without having to worry about
+	 * failures exposing transient data.
+	 */
+	written = actor(inode, pos, length, data, &iomap);
+
+	/*
+	 * Now the data has been copied, commit the range we've copied.  This
+	 * should not fail unless the filesystem has had a fatal error.
+	 */
+	ret = ops->iomap_end(inode, pos, length, written > 0 ? written : 0,
+			flags, &iomap);
+
+	return written ? written : ret;
+}
+
+static void
+iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
+{
+	loff_t i_size = i_size_read(inode);
+
+	/*
+	 * Only truncate newly allocated pages beyoned EOF, even if the
+	 * write started inside the existing inode size.
+	 */
+	if (pos + len > i_size)
+		truncate_pagecache_range(inode, max(pos, i_size), pos + len);
+}
+
+static int
+iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
+		struct page **pagep, struct iomap *iomap)
+{
+	pgoff_t index = pos >> PAGE_SHIFT;
+	struct page *page;
+	int status = 0;
+
+	BUG_ON(pos + len > iomap->offset + iomap->length);
+
+	page = grab_cache_page_write_begin(inode->i_mapping, index, flags);
+	if (!page)
+		return -ENOMEM;
+
+	status = __block_write_begin_int(page, pos, len, NULL, iomap);
+	if (unlikely(status)) {
+		unlock_page(page);
+		put_page(page);
+		page = NULL;
+
+		iomap_write_failed(inode, pos, len);
+	}
+
+	*pagep = page;
+	return status;
+}
+
+static int
+iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
+		unsigned copied, struct page *page)
+{
+	int ret;
+
+	ret = generic_write_end(NULL, inode->i_mapping, pos, len,
+			copied, page, NULL);
+	if (ret < len)
+		iomap_write_failed(inode, pos, len);
+	return ret;
+}
+
+static loff_t
+iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
+		struct iomap *iomap)
+{
+	struct iov_iter *i = data;
+	long status = 0;
+	ssize_t written = 0;
+	unsigned int flags = AOP_FLAG_NOFS;
+
+	/*
+	 * Copies from kernel address space cannot fail (NFSD is a big user).
+	 */
+	if (!iter_is_iovec(i))
+		flags |= AOP_FLAG_UNINTERRUPTIBLE;
+
+	do {
+		struct page *page;
+		unsigned long offset;	/* Offset into pagecache page */
+		unsigned long bytes;	/* Bytes to write to page */
+		size_t copied;		/* Bytes copied from user */
+
+		offset = (pos & (PAGE_SIZE - 1));
+		bytes = min_t(unsigned long, PAGE_SIZE - offset,
+						iov_iter_count(i));
+again:
+		if (bytes > length)
+			bytes = length;
+
+		/*
+		 * Bring in the user page that we will copy from _first_.
+		 * Otherwise there's a nasty deadlock on copying from the
+		 * same page as we're writing to, without it being marked
+		 * up-to-date.
+		 *
+		 * Not only is this an optimisation, but it is also required
+		 * to check that the address is actually valid, when atomic
+		 * usercopies are used, below.
+		 */
+		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+			status = -EFAULT;
+			break;
+		}
+
+		status = iomap_write_begin(inode, pos, bytes, flags, &page,
+				iomap);
+		if (unlikely(status))
+			break;
+
+		if (mapping_writably_mapped(inode->i_mapping))
+			flush_dcache_page(page);
+
+		pagefault_disable();
+		copied = iov_iter_copy_from_user_atomic(page, i, offset, bytes);
+		pagefault_enable();
+
+		flush_dcache_page(page);
+		mark_page_accessed(page);
+
+		status = iomap_write_end(inode, pos, bytes, copied, page);
+		if (unlikely(status < 0))
+			break;
+		copied = status;
+
+		cond_resched();
+
+		iov_iter_advance(i, copied);
+		if (unlikely(copied == 0)) {
+			/*
+			 * If we were unable to copy any data at all, we must
+			 * fall back to a single segment length write.
+			 *
+			 * If we didn't fallback here, we could livelock
+			 * because not all segments in the iov can be copied at
+			 * once without a pagefault.
+			 */
+			bytes = min_t(unsigned long, PAGE_SIZE - offset,
+						iov_iter_single_seg_count(i));
+			goto again;
+		}
+		pos += copied;
+		written += copied;
+		length -= copied;
+
+		balance_dirty_pages_ratelimited(inode->i_mapping);
+	} while (iov_iter_count(i) && length);
+
+	return written ? written : status;
+}
+
+ssize_t
+iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *iter,
+		struct iomap_ops *ops)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	loff_t pos = iocb->ki_pos, ret = 0, written = 0;
+
+	while (iov_iter_count(iter)) {
+		ret = iomap_apply(inode, pos, iov_iter_count(iter),
+				IOMAP_WRITE, ops, iter, iomap_write_actor);
+		if (ret <= 0)
+			break;
+		pos += ret;
+		written += ret;
+	}
+
+	return written ? written : ret;
+}
+EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
+
+static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
+		unsigned bytes, struct iomap *iomap)
+{
+	struct page *page;
+	int status;
+
+	status = iomap_write_begin(inode, pos, bytes,
+			AOP_FLAG_UNINTERRUPTIBLE | AOP_FLAG_NOFS, &page, iomap);
+	if (status)
+		return status;
+
+	zero_user(page, offset, bytes);
+	mark_page_accessed(page);
+
+	return iomap_write_end(inode, pos, bytes, bytes, page);
+}
+
+static loff_t
+iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
+		void *data, struct iomap *iomap)
+{
+	bool *did_zero = data;
+	loff_t written = 0;
+	int status;
+
+	/* already zeroed?  we're done. */
+	if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_UNWRITTEN)
+	    	return count;
+
+	do {
+		unsigned offset, bytes;
+
+		offset = pos & (PAGE_SIZE - 1); /* Within page */
+		bytes = min_t(unsigned, PAGE_SIZE - offset, count);
+
+		status = iomap_zero(inode, pos, offset, bytes, iomap);
+		if (status < 0)
+			return status;
+
+		pos += bytes;
+		count -= bytes;
+		written += bytes;
+		if (did_zero)
+			*did_zero = true;
+	} while (count > 0);
+
+	return written;
+}
+
+int
+iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
+		struct iomap_ops *ops)
+{
+	loff_t ret;
+
+	while (len > 0) {
+		ret = iomap_apply(inode, pos, len, IOMAP_ZERO,
+				ops, did_zero, iomap_zero_range_actor);
+		if (ret <= 0)
+			return ret;
+
+		pos += ret;
+		len -= ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iomap_zero_range);
+
+int
+iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
+		struct iomap_ops *ops)
+{
+	unsigned blocksize = (1 << inode->i_blkbits);
+	unsigned off = pos & (blocksize - 1);
+
+	/* Block boundary? Nothing to do */
+	if (!off)
+		return 0;
+	return iomap_zero_range(inode, pos, blocksize - off, did_zero, ops);
+}
+EXPORT_SYMBOL_GPL(iomap_truncate_page);
+
+static loff_t
+iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
+		void *data, struct iomap *iomap)
+{
+	struct page *page = data;
+	int ret;
+
+	ret = __block_write_begin_int(page, pos & ~PAGE_MASK, length,
+			NULL, iomap);
+	if (ret)
+		return ret;
+
+	block_commit_write(page, 0, length);
+	return length;
+}
+
+int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
+		struct iomap_ops *ops)
+{
+	struct page *page = vmf->page;
+	struct inode *inode = file_inode(vma->vm_file);
+	unsigned long length;
+	loff_t offset, size;
+	ssize_t ret;
+
+	lock_page(page);
+	size = i_size_read(inode);
+	if ((page->mapping != inode->i_mapping) ||
+	    (page_offset(page) > size)) {
+		/* We overload EFAULT to mean page got truncated */
+		ret = -EFAULT;
+		goto out_unlock;
+	}
+
+	/* page is wholly or partially inside EOF */
+	if (((page->index + 1) << PAGE_SHIFT) > size)
+		length = size & ~PAGE_MASK;
+	else
+		length = PAGE_SIZE;
+
+	offset = page_offset(page);
+	while (length > 0) {
+		ret = iomap_apply(inode, offset, length, IOMAP_WRITE,
+				ops, page, iomap_page_mkwrite_actor);
+		if (unlikely(ret <= 0))
+			goto out_unlock;
+		offset += ret;
+		length -= ret;
+	}
+
+	set_page_dirty(page);
+	wait_for_stable_page(page);
+	return 0;
+out_unlock:
+	unlock_page(page);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iomap_page_mkwrite);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 1b22197..854766f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -3,19 +3,65 @@
 
 #include <linux/types.h>
 
-/* types of block ranges for multipage write mappings. */
+struct inode;
+struct iov_iter;
+struct kiocb;
+struct vm_area_struct;
+struct vm_fault;
+
+/*
+ * Types of block ranges for iomap mappings:
+ */
 #define IOMAP_HOLE	0x01	/* no blocks allocated, need allocation */
 #define IOMAP_DELALLOC	0x02	/* delayed allocation blocks */
 #define IOMAP_MAPPED	0x03	/* blocks allocated @blkno */
 #define IOMAP_UNWRITTEN	0x04	/* blocks allocated @blkno in unwritten state */
 
+/*
+ * Magic value for blkno:
+ */
 #define IOMAP_NULL_BLOCK -1LL	/* blkno is not valid */
 
 struct iomap {
-	sector_t	blkno;	/* first sector of mapping */
-	loff_t		offset;	/* file offset of mapping, bytes */
-	u64		length;	/* length of mapping, bytes */
-	int		type;	/* type of mapping */
+	sector_t		blkno;	/* first sector of mapping, fs blocks */
+	loff_t			offset;	/* file offset of mapping, bytes */
+	u64			length;	/* length of mapping, bytes */
+	int			type;	/* type of mapping */
+	struct block_device	*bdev; /* block device for I/O */
+};
+
+/*
+ * Flags for iomap_begin / iomap_end.  No flag implies a read.
+ */
+#define IOMAP_WRITE		(1 << 0)
+#define IOMAP_ZERO		(1 << 1)
+
+struct iomap_ops {
+	/*
+	 * Return the existing mapping at pos, or reserve space starting at
+	 * pos for up to length, as long as we can do it as a single mapping.
+	 * The actual length is returned in iomap->length.
+	 */
+	int (*iomap_begin)(struct inode *inode, loff_t pos, loff_t length,
+			unsigned flags, struct iomap *iomap);
+
+	/*
+	 * Commit and/or unreserve space previous allocated using iomap_begin.
+	 * Written indicates the length of the successful write operation which
+	 * needs to be commited, while the rest needs to be unreserved.
+	 * Written might be zero if no data was written.
+	 */
+	int (*iomap_end)(struct inode *inode, loff_t pos, loff_t length,
+			ssize_t written, unsigned flags, struct iomap *iomap);
 };
 
+ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
+		struct iomap_ops *ops);
+int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
+		bool *did_zero, struct iomap_ops *ops);
+int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
+		struct iomap_ops *ops);
+int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
+		struct iomap_ops *ops);
+
 #endif /* LINUX_IOMAP_H */
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
