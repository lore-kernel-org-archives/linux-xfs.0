Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44364 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756587AbcK2R2f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2016 12:28:35 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] iomap: implement direct I/O
Date: Tue, 29 Nov 2016 18:28:15 +0100
Message-Id: <1480440496-25737-5-git-send-email-hch@lst.de>
In-Reply-To: <1480440496-25737-1-git-send-email-hch@lst.de>
References: <1480440496-25737-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: axboe@fb.com, linux-fsdevel@vger.kernel.org

This adds a full fledget direct I/O implementation using the iomap
interface. Full fledged in this case means all features are supported:
AIO, vectored I/O, any iov_iter type including kernel pointers, bvecs
and pipes, support for hole filling and async apending writes.  It does
not mean supporting all the warts of the old generic code.  We expect
i_rwsem to be held over the duration of the call, and we expect to
maintain i_dio_count ourselves, and we pass on any kinds of mapping
to the file system for now.

The algorithm used is very simple: We use iomap_apply to iterate over
the range of the I/O, and then we use the new bio_iov_iter_get_pages
helper to lock down the user range for the size of the extent.
bio_iov_iter_get_pages can currently lock down twice as many pages as
the old direct I/O code did, which means that we will have a better
batch factor for everything but overwrites of badly fragmented files.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 fs/iomap.c            | 373 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h |  11 ++
 2 files changed, 384 insertions(+)

diff --git a/fs/iomap.c b/fs/iomap.c
index 13dd413..93d36fd 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -24,6 +24,7 @@
 #include <linux/uio.h>
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
+#include <linux/task_io_accounting_ops.h>
 #include <linux/dax.h>
 #include "internal.h"
 
@@ -584,3 +585,375 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iomap_fiemap);
+
+/*
+ * Private flags for iomap_dio, must not overlap with the public ones in
+ * iomap.h:
+ */
+#define IOMAP_DIO_WRITE		(1 << 30)
+#define IOMAP_DIO_DIRTY	(1 << 31)
+
+struct iomap_dio {
+	struct kiocb		*iocb;
+	iomap_dio_end_io_t	*end_io;
+	loff_t			i_size;
+	loff_t			size;
+	atomic_t		ref;
+	unsigned		flags;
+	int			error;
+
+	union {
+		/* used during submission and for synchronous completion: */
+		struct {
+			struct iov_iter		*iter;
+			struct task_struct	*waiter;
+			struct request_queue	*last_queue;
+			blk_qc_t		cookie;
+		} submit;
+
+		/* used for aio completion: */
+		struct {
+			struct work_struct	work;
+		} aio;
+	};
+};
+
+static ssize_t iomap_dio_complete(struct iomap_dio *dio)
+{
+	struct kiocb *iocb = dio->iocb;
+	ssize_t ret;
+
+	if (dio->end_io) {
+		ret = dio->end_io(iocb,
+				dio->error ? dio->error : dio->size,
+				dio->flags);
+	} else {
+		ret = dio->error;
+	}
+
+	if (likely(!ret)) {
+		ret = dio->size;
+		/* check for short read */
+		if (iocb->ki_pos + ret > dio->i_size &&
+		    !(dio->flags & IOMAP_DIO_WRITE))
+			ret = dio->i_size - iocb->ki_pos;
+		iocb->ki_pos += ret;
+	}
+
+	inode_dio_end(file_inode(iocb->ki_filp));
+	kfree(dio);
+
+	return ret;
+}
+
+static void iomap_dio_complete_work(struct work_struct *work)
+{
+	struct iomap_dio *dio = container_of(work, struct iomap_dio, aio.work);
+	struct kiocb *iocb = dio->iocb;
+	bool is_write = (dio->flags & IOMAP_DIO_WRITE);
+	ssize_t ret;
+
+	ret = iomap_dio_complete(dio);
+	if (is_write && ret > 0)
+		ret = generic_write_sync(iocb, ret);
+	iocb->ki_complete(iocb, ret, 0);
+}
+
+/*
+ * Set an error in the dio if none is set yet.  We have to use cmpxchg
+ * as the submission context and the completion context(s) can race to
+ * update the error.
+ */
+static inline void iomap_dio_set_error(struct iomap_dio *dio, int ret)
+{
+	cmpxchg(&dio->error, 0, ret);
+}
+
+static void iomap_dio_bio_end_io(struct bio *bio)
+{
+	struct iomap_dio *dio = bio->bi_private;
+	bool should_dirty = (dio->flags & IOMAP_DIO_DIRTY);
+
+	if (bio->bi_error)
+		iomap_dio_set_error(dio, bio->bi_error);
+
+	if (atomic_dec_and_test(&dio->ref)) {
+		if (is_sync_kiocb(dio->iocb)) {
+			struct task_struct *waiter = dio->submit.waiter;
+
+			WRITE_ONCE(dio->submit.waiter, NULL);
+			wake_up_process(waiter);
+		} else if (dio->flags & IOMAP_DIO_WRITE) {
+			struct inode *inode = file_inode(dio->iocb->ki_filp);
+
+			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
+			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
+		} else {
+			iomap_dio_complete_work(&dio->aio.work);
+		}
+	}
+
+	if (should_dirty) {
+		bio_check_pages_dirty(bio);
+	} else {
+		struct bio_vec *bvec;
+		int i;
+
+		bio_for_each_segment_all(bvec, bio, i)
+			put_page(bvec->bv_page);
+		bio_put(bio);
+	}
+}
+
+static blk_qc_t
+iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
+		unsigned len)
+{
+	struct page *page = ZERO_PAGE(0);
+	struct bio *bio;
+
+	bio = bio_alloc(GFP_KERNEL, 1);
+	bio->bi_bdev = iomap->bdev;
+	bio->bi_iter.bi_sector =
+		iomap->blkno + ((pos - iomap->offset) >> 9);
+	bio->bi_private = dio;
+	bio->bi_end_io = iomap_dio_bio_end_io;
+
+	get_page(page);
+	if (bio_add_page(bio, page, len, 0) != len)
+		BUG();
+	bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_ODIRECT);
+
+	atomic_inc(&dio->ref);
+	return submit_bio(bio);
+}
+
+static loff_t
+iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
+		void *data, struct iomap *iomap)
+{
+	struct iomap_dio *dio = data;
+	unsigned blkbits = blksize_bits(bdev_logical_block_size(iomap->bdev));
+	unsigned fs_block_size = (1 << inode->i_blkbits), pad;
+	unsigned align = iov_iter_alignment(dio->submit.iter);
+	struct iov_iter iter;
+	struct bio *bio;
+	bool need_zeroout = false;
+	int nr_pages, ret;
+
+	if ((pos | length | align) & ((1 << blkbits) - 1))
+		return -EINVAL;
+
+	switch (iomap->type) {
+	case IOMAP_HOLE:
+		if (WARN_ON_ONCE(dio->flags & IOMAP_DIO_WRITE))
+			return -EIO;
+		/*FALLTHRU*/
+	case IOMAP_UNWRITTEN:
+		if (!(dio->flags & IOMAP_DIO_WRITE)) {
+			iov_iter_zero(length, dio->submit.iter);
+			dio->size += length;
+			return length;
+		}
+		dio->flags |= IOMAP_DIO_UNWRITTEN;
+		need_zeroout = true;
+		break;
+	case IOMAP_MAPPED:
+		if (iomap->flags & IOMAP_F_SHARED)
+			dio->flags |= IOMAP_DIO_COW;
+		if (iomap->flags & IOMAP_F_NEW)
+			need_zeroout = true;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EIO;
+	}
+
+	/*
+	 * Operate on a partial iter trimmed to the extent we were called for.
+	 * We'll update the iter in the dio once we're done with this extent.
+	 */
+	iter = *dio->submit.iter;
+	iov_iter_truncate(&iter, length);
+
+	nr_pages = iov_iter_npages(&iter, BIO_MAX_PAGES);
+	if (nr_pages <= 0)
+		return nr_pages;
+
+	if (need_zeroout) {
+		/* zero out from the start of the block to the write offset */
+		pad = pos & (fs_block_size - 1);
+		if (pad)
+			iomap_dio_zero(dio, iomap, pos - pad, pad);
+	}
+
+	do {
+		if (dio->error)
+			return 0;
+
+		bio = bio_alloc(GFP_KERNEL, nr_pages);
+		bio->bi_bdev = iomap->bdev;
+		bio->bi_iter.bi_sector =
+			iomap->blkno + ((pos - iomap->offset) >> 9);
+		bio->bi_private = dio;
+		bio->bi_end_io = iomap_dio_bio_end_io;
+
+		ret = bio_iov_iter_get_pages(bio, &iter);
+		if (unlikely(ret)) {
+			bio_put(bio);
+			return ret;
+		}
+
+		if (dio->flags & IOMAP_DIO_WRITE) {
+			bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_ODIRECT);
+			task_io_account_write(bio->bi_iter.bi_size);
+		} else {
+			bio_set_op_attrs(bio, REQ_OP_READ, 0);
+			if (dio->flags & IOMAP_DIO_DIRTY)
+				bio_set_pages_dirty(bio);
+		}
+
+		dio->size += bio->bi_iter.bi_size;
+		pos += bio->bi_iter.bi_size;
+
+		nr_pages = iov_iter_npages(&iter, BIO_MAX_PAGES);
+
+		atomic_inc(&dio->ref);
+
+		dio->submit.last_queue = bdev_get_queue(iomap->bdev);
+		dio->submit.cookie = submit_bio(bio);
+	} while (nr_pages);
+
+	if (need_zeroout) {
+		/* zero out from the end of the write to the end of the block */
+		pad = pos & (fs_block_size - 1);
+		if (pad)
+			iomap_dio_zero(dio, iomap, pos, fs_block_size - pad);
+	}
+
+	iov_iter_advance(dio->submit.iter, length);
+	return length;
+}
+
+ssize_t
+iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter, struct iomap_ops *ops,
+		iomap_dio_end_io_t end_io)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	struct inode *inode = file_inode(iocb->ki_filp);
+	size_t count = iov_iter_count(iter);
+	loff_t pos = iocb->ki_pos, end = iocb->ki_pos + count - 1, ret = 0;
+	unsigned int flags = IOMAP_DIRECT;
+	struct blk_plug plug;
+	struct iomap_dio *dio;
+
+	lockdep_assert_held(&inode->i_rwsem);
+
+	if (!count)
+		return 0;
+
+	dio = kmalloc(sizeof(*dio), GFP_KERNEL);
+	if (!dio)
+		return -ENOMEM;
+
+	dio->iocb = iocb;
+	atomic_set(&dio->ref, 1);
+	dio->size = 0;
+	dio->i_size = i_size_read(inode);
+	dio->end_io = end_io;
+	dio->error = 0;
+	dio->flags = 0;
+
+	dio->submit.iter = iter;
+	if (is_sync_kiocb(iocb)) {
+		dio->submit.waiter = current;
+		dio->submit.cookie = BLK_QC_T_NONE;
+		dio->submit.last_queue = NULL;
+	}
+
+	if (iov_iter_rw(iter) == READ) {
+		if (pos >= dio->i_size)
+			goto out_free_dio;
+
+		if (iter->type == ITER_IOVEC)
+			dio->flags |= IOMAP_DIO_DIRTY;
+	} else {
+		dio->flags |= IOMAP_DIO_WRITE;
+		flags |= IOMAP_WRITE;
+	}
+
+	if (mapping->nrpages) {
+		ret = filemap_write_and_wait_range(mapping, iocb->ki_pos, end);
+		if (ret)
+			goto out_free_dio;
+
+		ret = invalidate_inode_pages2_range(mapping,
+				iocb->ki_pos >> PAGE_SHIFT, end >> PAGE_SHIFT);
+		WARN_ON_ONCE(ret);
+		ret = 0;
+	}
+
+	inode_dio_begin(inode);
+
+	blk_start_plug(&plug);
+	do {
+		ret = iomap_apply(inode, pos, count, flags, ops, dio,
+				iomap_dio_actor);
+		if (ret <= 0) {
+			/* magic error code to fall back to buffered I/O */
+			if (ret == -ENOTBLK)
+				ret = 0;
+			break;
+		}
+		pos += ret;
+	} while ((count = iov_iter_count(iter)) > 0);
+	blk_finish_plug(&plug);
+
+	if (ret < 0)
+		iomap_dio_set_error(dio, ret);
+
+	if (ret >= 0 && iov_iter_rw(iter) == WRITE && !is_sync_kiocb(iocb) &&
+			!inode->i_sb->s_dio_done_wq) {
+		ret = sb_init_dio_done_wq(inode->i_sb);
+		if (ret < 0)
+			iomap_dio_set_error(dio, ret);
+	}
+
+	if (!atomic_dec_and_test(&dio->ref)) {
+		if (!is_sync_kiocb(iocb))
+			return -EIOCBQUEUED;
+
+		for (;;) {
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			if (!READ_ONCE(dio->submit.waiter))
+				break;
+
+			if (!(iocb->ki_flags & IOCB_HIPRI) ||
+			    !dio->submit.last_queue ||
+			    !blk_poll(dio->submit.last_queue,
+					dio->submit.cookie))
+				io_schedule();
+		}
+		__set_current_state(TASK_RUNNING);
+	}
+
+	/*
+	 * Try again to invalidate clean pages which might have been cached by
+	 * non-direct readahead, or faulted in by get_user_pages() if the source
+	 * of the write was an mmap'ed region of the file we're writing.  Either
+	 * one is a pretty crazy thing to do, so we don't support it 100%.  If
+	 * this invalidation fails, tough, the write still worked...
+	 */
+	if (iov_iter_rw(iter) == WRITE && mapping->nrpages) {
+		ret = invalidate_inode_pages2_range(mapping,
+				iocb->ki_pos >> PAGE_SHIFT, end >> PAGE_SHIFT);
+		WARN_ON_ONCE(ret);
+	}
+
+	return iomap_dio_complete(dio);
+
+out_free_dio:
+	kfree(dio);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iomap_dio_rw);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index f185156..a4c94b8 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -50,6 +50,7 @@ struct iomap {
 #define IOMAP_ZERO		(1 << 1) /* zeroing operation, may skip holes */
 #define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
 #define IOMAP_FAULT		(1 << 3) /* mapping for page fault */
+#define IOMAP_DIRECT		(1 << 4) /* direct I/O */
 
 struct iomap_ops {
 	/*
@@ -83,4 +84,14 @@ int iomap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf,
 int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		loff_t start, loff_t len, struct iomap_ops *ops);
 
+/*
+ * Flags for direct I/O ->end_io:
+ */
+#define IOMAP_DIO_UNWRITTEN	(1 << 0)	/* covers unwritten extent(s) */
+#define IOMAP_DIO_COW		(1 << 1)	/* covers COW extent(s) */
+typedef int (iomap_dio_end_io_t)(struct kiocb *iocb, ssize_t ret,
+		unsigned flags);
+ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
+		struct iomap_ops *ops, iomap_dio_end_io_t end_io);
+
 #endif /* LINUX_IOMAP_H */
-- 
2.1.4

