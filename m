Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:60813 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752128AbeC0HHc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Mar 2018 03:07:32 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] iomap: Use FUA for pure data O_DSYNC DIO writes
Date: Tue, 27 Mar 2018 18:07:17 +1100
Message-Id: <20180327070717.7107-4-david@fromorbit.com>
In-Reply-To: <20180327070717.7107-1-david@fromorbit.com>
References: <20180327070717.7107-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

From: Dave Chinner <dchinner@redhat.com>

If we are doing direct IO writes with datasync semantics, we often
have to flush metadata changes along with the data write. However,
if we are overwriting existing data, there are no metadata changes
that we need to flush. In this case, optimising the IO by using
FUA write makes sense.

We know from teh IOMAP_F_DIRTY flag as to whether a specific inode
requires a metadata flush - this is currently used by DAX to ensure
extent modification as stable in page fault operations. For direct
IO writes, we can use it to determine if we need to flush metadata
or not once the data is on disk.

Hence if we have been returned a mapped extent that is not new and
the IO mapping is not dirty, then we can use a FUA write to provide
datasync semantics. This allows us to short-cut the
generic_write_sync() call in IO completion and hence avoid
unnecessary operations. This makes pure direct IO data write
behaviour identical to the way block devices use REQ_FUA to provide
datasync semantics.

Now that iomap_dio_rw() is determining if REQ_FUA can be used, we
have to stop issuing generic_write_sync() calls from the XFS code
when REQ_FUA is issued, otherwise it will still throw a cache flush
to the device via xfs_file_fsync(). To do this, we need to make
iomap_dio_rw() always responsible for issuing generic_write_sync()
when necessary, not just for AIO calls. This means the filesystem
doesn't have to guess when cache flushes are necessary now.

On a FUA enabled device, a synchronous direct IO write workload
(sequential 4k overwrites in 32MB file) had the following results:

# xfs_io -fd -c "pwrite -V 1 -D 0 32m" /mnt/scratch/boo

kernel		time	write()s	write iops	Write b/w
------		----	--------	----------	---------
(no dsync)	 4s	2173/s		2173		8.5MB/s
vanilla		22s	 370/s		 750		1.4MB/s
patched		19s	 420/s		 420		1.6MB/s

The patched code clearly doesn't send cache flushes anymore, but
instead uses FUA (confirmed via blktrace), and performance improves
a bit as a result. However, the benefits will be higher on workloads
that mix O_DSYNC overwrites with other write IO as we won't be
flushing the entire device cache on every DSYNC overwrite IO
anymore.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c             | 44 +++++++++++++++++++++++++++++++++++++++++---
 include/linux/blkdev.h |  1 +
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index f5d4e348bc9b..92f88ce8e2d4 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -685,6 +685,7 @@ EXPORT_SYMBOL_GPL(iomap_seek_data);
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
+#define IOMAP_DIO_WRITE_FUA	(1 << 28)
 #define IOMAP_DIO_WRITE_SYNC	(1 << 29)
 #define IOMAP_DIO_WRITE		(1 << 30)
 #define IOMAP_DIO_DIRTY		(1 << 31)
@@ -863,6 +864,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 	struct iov_iter iter;
 	struct bio *bio;
 	bool need_zeroout = false;
+	bool use_fua = false;
 	int nr_pages, ret;
 	size_t copied = 0;
 
@@ -888,6 +890,18 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 			dio->flags |= IOMAP_DIO_COW;
 		if (iomap->flags & IOMAP_F_NEW)
 			need_zeroout = true;
+		else {
+			/*
+			 * Use a FUA write if we need datasync semantics, this
+			 * is a pure data IO that doesn't require any metadata
+			 * updates and the underlying device supports FUA. This
+			 * allows us to avoid cache flushes on IO completion.
+			 */
+			if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
+			    (dio->flags & IOMAP_DIO_WRITE_FUA) &&
+			    blk_queue_fua(bdev_get_queue(iomap->bdev)))
+				use_fua = true;
+		}
 		break;
 	default:
 		WARN_ON_ONCE(1);
@@ -935,7 +949,13 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 
 		n = bio->bi_iter.bi_size;
 		if (dio->flags & IOMAP_DIO_WRITE) {
-			bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC | REQ_IDLE);
+			int op_flags = REQ_SYNC | REQ_IDLE;
+
+			if (use_fua)
+				op_flags |= REQ_FUA;
+			else
+				dio->flags &= ~IOMAP_DIO_WRITE_FUA;
+			bio_set_op_attrs(bio, REQ_OP_WRITE, op_flags);
 			task_io_account_write(n);
 		} else {
 			bio_set_op_attrs(bio, REQ_OP_READ, 0);
@@ -968,7 +988,12 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 
 /*
  * iomap_dio_rw() always completes O_[D]SYNC writes regardless of whether the IO
- * is being issued as AIO or not.
+ * is being issued as AIO or not.  This allows us to optimise pure data writes
+ * to use REQ_FUA rather than requiring generic_write_sync() to issue a
+ * REQ_FLUSH post write. This is slightly tricky because a single request here
+ * can be mapped into multiple disjoint IOs and only a subset of the IOs issued
+ * may be pure data writes. In that case, we still need to do a full data sync
+ * completion.
  */
 ssize_t
 iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
@@ -1015,8 +1040,14 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 			dio->flags |= IOMAP_DIO_DIRTY;
 	} else {
 		dio->flags |= IOMAP_DIO_WRITE;
-		if (iocb->ki_flags & IOCB_DSYNC)
+		if (iocb->ki_flags & IOCB_DSYNC) {
 			dio->flags |= IOMAP_DIO_WRITE_SYNC;
+			/*
+			 * Any non-FUA write will clear this flag, hence we know
+			 * before completion whether a cache flush is necessary.
+			 */
+			dio->flags |= IOMAP_DIO_WRITE_FUA;
+		}
 		flags |= IOMAP_WRITE;
 	}
 
@@ -1073,6 +1104,13 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (ret < 0)
 		iomap_dio_set_error(dio, ret);
 
+	/*
+	 * If all the writes we issued were FUA, we don't need to flush the
+	 * cache on IO completion. Clear the sync flag for this case.
+	 */
+	if (dio->flags & IOMAP_DIO_WRITE_FUA)
+		dio->flags &= ~IOMAP_DIO_WRITE_SYNC;
+
 	if (!atomic_dec_and_test(&dio->ref)) {
 		if (!is_sync_kiocb(iocb))
 			return -EIOCBQUEUED;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ed63f3b69c12..e853f1748a4b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -800,6 +800,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_quiesced(q)	test_bit(QUEUE_FLAG_QUIESCED, &(q)->queue_flags)
 #define blk_queue_preempt_only(q)				\
 	test_bit(QUEUE_FLAG_PREEMPT_ONLY, &(q)->queue_flags)
+#define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
 
 extern int blk_set_preempt_only(struct request_queue *q);
 extern void blk_clear_preempt_only(struct request_queue *q);
-- 
2.16.1

