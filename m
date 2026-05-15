Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496794266BC
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 08:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778834474; cv=none; b=AvymxNMcxBd/q3L/rxuNVy3szFkNiKToMLz6mEcQ9891ArUZkKGYgGlY5ejn54xT1P/EoT5G/P1kV8fmdZsiyB4qZ44My3LBCOWWUPAUlR9aHA3rw26PsXa6xDU/wvCMoNhG0QttyLwWi0fltYmPRNj91xVoE261iB8VeKMzJbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778834474; c=relaxed/simple;
	bh=f/0AeHt8BgG68p6NtJ9hgznBtWUUN136MaDl72Ts0UY=;
	h=From:Message-Id:Mime-Version:Content-Type:To:Subject:Cc:Date; b=rFQSEKT2kYjotu+ZdNVtd++6YrTP7qXtTwrWNHv6EBegRrRO4WhfsFquJzS6M8IvXi7vgTzFAooGFp3WKPme2+ug8sW49DFby+TdnA/idjcHaTWMbHGBArLxodFEYlIEkbxdOFK5AeJHHWHenld5wy5tCk/jUABfptTQ2XMz2XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=GhxM7nKk; arc=none smtp.client-ip=209.127.231.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="GhxM7nKk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1778834465; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=1SbsNtnzMuDBvpJX8OGS0Ld1MXIW4hxE6xFwMIEQUh0=;
 b=GhxM7nKk2WlsUUcSHSrp22ezV3oOmeBdpeQpYq058lMgHvLBEw8M/ftZDgsub4lWFf5C6n
 6I2Q6ZeZQRZus7osNHDlst8uwR9j5oaHJzebzj+2zol2jQ81V8L9nCEQWXl+V+Y8Wgt5D3
 xkopBlqimiziNoFnAXX8AvFZHTZnYiyHYcQuX02Oh7o2c9nVKOtY5WriF73kx66NN1tAgn
 /ew1aZOFAwRq8W233L7nJisN7XBIxvAuLDheT2h5KynL9OBEDiW9JGYFi3UQnEq0b2u8IM
 QSSm5uJV+3+IqoBtFSuTytSg8ORH64QTUQUhPqJmQwnGnttMBDbt+3RjWvBmRg==
From: "Fengnan Chang" <changfengnan@bytedance.com>
Message-Id: <20260515084028.98160-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>
Subject: [PATCH v3] iomap: add simple read path for small direct I/O
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Date: Fri, 15 May 2026 16:40:28 +0800
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a06dc1f+73c38e+vger.kernel.org+changfengnan@bytedance.com>

When running 4K random read workloads on high-performance Gen5 NVMe
SSDs, the software overhead in the iomap direct I/O path
(__iomap_dio_rw) becomes a significant bottleneck.

Using io_uring with poll mode for a 4K randread test on a raw block
device:
taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
-n1 -P1 /dev/nvme10n1
Result: ~3.2M IOPS

Running the exact same workload on ext4 and XFS:
taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
-n1 -P1 /mnt/testfile
Result: ~1.92M IOPS

Profiling the ext4 workload reveals that a significant portion of CPU
time is spent on memory allocation and the iomap state machine
iteration:
  5.33%  [kernel]  [k] __iomap_dio_rw
  3.26%  [kernel]  [k] iomap_iter
  2.37%  [kernel]  [k] iomap_dio_bio_iter
  2.35%  [kernel]  [k] kfree
  1.33%  [kernel]  [k] iomap_dio_complete

Introduce simple reads to reduce the overhead of iomap, simple read path
is triggered when the request satisfies:
- I/O size is <= inode blocksize (fits in a single block, no splits).
- No custom `iomap_dio_ops` (dops) registered by the filesystem.

After this optimization, the heavy generic functions disappear from the
profile, replaced by a single streamlined execution path:
  4.83%  [kernel]  [k] iomap_dio_simple_read

With this patch, 4K random read IOPS on ext4 increases from 1.92M to
2.19M in the original single-core io_uring poll-mode workload.

Below are the test results using fio:

  fs    workload       qd    simple=0      simple=1      gain
  ext4  libaio         1     18,295        18,314        +0.10%
  ext4  libaio         64    458,374       473,557       +3.31%
  ext4  libaio         256   456,944       471,865       +3.27%
  ext4  libaio         1024  459,058       476,433       +3.78%
  ext4  io_uring       1     18,882        18,897        +0.08%
  ext4  io_uring       64    552,607       576,712       +4.36%
  ext4  io_uring       256   552,330       576,603       +4.39%
  ext4  io_uring       1024  557,330       584,227       +4.83%
  ext4  io_uring_poll  1     19,387        19,407        +0.10%
  ext4  io_uring_poll  64    794,073       843,926       +6.28%
  ext4  io_uring_poll  256   794,081       852,765       +7.39%
  ext4  io_uring_poll  1024  679,857       739,773       +8.81%
  xfs   libaio         1     18,314        18,344        +0.16%
  xfs   libaio         64    459,008       477,249       +3.97%
  xfs   libaio         256   455,308       475,960       +4.54%
  xfs   libaio         1024  461,499       477,098       +3.38%
  xfs   io_uring       1     18,867        18,895        +0.15%
  xfs   io_uring       64    556,197       582,650       +4.76%
  xfs   io_uring       256   556,946       582,802       +4.64%
  xfs   io_uring       1024  562,361       591,056       +5.10%
  xfs   io_uring_poll  1     19,380        19,406        +0.14%
  xfs   io_uring_poll  64    797,734       849,029       +6.43%
  xfs   io_uring_poll  256   796,156       852,550       +7.08%
  xfs   io_uring_poll  1024  677,254       735,667       +8.62%

v3:
Test data updated based on v7.1-rc3.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/iomap/direct-io.c | 384 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 373 insertions(+), 11 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b0a6549b38487..8b86ad7df4bbd 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -10,6 +10,9 @@
 #include <linux/iomap.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/fserror.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/init.h>
 #include "internal.h"
 #include "trace.h"
 
@@ -237,23 +240,29 @@ static void iomap_dio_done(struct iomap_dio *dio)
 	iomap_dio_complete_work(&dio->aio.work);
 }
 
-static void __iomap_dio_bio_end_io(struct bio *bio, bool inline_completion)
+static inline void iomap_dio_bio_release_pages(struct bio *bio,
+		unsigned int dio_flags, bool error)
 {
-	struct iomap_dio *dio = bio->bi_private;
-
 	if (bio_integrity(bio))
 		fs_bio_integrity_free(bio);
 
-	if (dio->flags & IOMAP_DIO_BOUNCE) {
-		bio_iov_iter_unbounce(bio, !!dio->error,
-				dio->flags & IOMAP_DIO_USER_BACKED);
+	if (dio_flags & IOMAP_DIO_BOUNCE) {
+		bio_iov_iter_unbounce(bio, error,
+				dio_flags & IOMAP_DIO_USER_BACKED);
 		bio_put(bio);
-	} else if (dio->flags & IOMAP_DIO_USER_BACKED) {
+	} else if (dio_flags & IOMAP_DIO_USER_BACKED) {
 		bio_check_pages_dirty(bio);
 	} else {
 		bio_release_pages(bio, false);
 		bio_put(bio);
 	}
+}
+
+static void __iomap_dio_bio_end_io(struct bio *bio, bool inline_completion)
+{
+	struct iomap_dio *dio = bio->bi_private;
+
+	iomap_dio_bio_release_pages(bio, dio->flags, !!dio->error);
 
 	/* Do not touch bio below, we just gave up our reference. */
 
@@ -398,6 +407,14 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	return ret;
 }
 
+static inline unsigned int iomap_dio_alignment(struct inode *inode,
+		struct block_device *bdev, unsigned int dio_flags)
+{
+	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
+		return i_blocksize(inode);
+	return bdev_logical_block_size(bdev);
+}
+
 static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 {
 	const struct iomap *iomap = &iter->iomap;
@@ -416,10 +433,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
 	 * File systems that write out of place and always allocate new blocks
 	 * need each bio to be block aligned as that's the unit of allocation.
 	 */
-	if (dio->flags & IOMAP_DIO_FSBLOCK_ALIGNED)
-		alignment = fs_block_size;
-	else
-		alignment = bdev_logical_block_size(iomap->bdev);
+	alignment = iomap_dio_alignment(inode, iomap->bdev, dio->flags);
 
 	if ((pos | length) & (alignment - 1))
 		return -EINVAL;
@@ -891,12 +905,352 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 }
 EXPORT_SYMBOL_GPL(__iomap_dio_rw);
 
+struct iomap_dio_simple_read {
+	struct kiocb		*iocb;
+	size_t			size;
+	unsigned int		dio_flags;
+	atomic_t		state;
+	union {
+		struct task_struct	*waiter;
+		struct work_struct	work;
+	};
+	/*
+	 * Align @bio to a cacheline boundary so that, combined with the
+	 * front_pad passed to bioset_init(), the bio sits at the start of
+	 * a cacheline in memory returned by the (HWCACHE-aligned) bio
+	 * slab.  This keeps the hot fields block layer touches on submit
+	 * and completion (bi_iter, bi_status, ...) within a single line.
+	 */
+	struct bio	bio ____cacheline_aligned_in_smp;
+};
+
+static struct bio_set iomap_dio_simple_read_pool;
+
+/*
+ * In the async simple read path, we need to prevent bio_endio() from
+ * triggering iocb->ki_complete() before the submitter has returned
+ * -EIOCBQUEUED. Otherwise, the caller might free the iocb concurrently.
+ *
+ * We use a three-state rendezvous to synchronize the submitter and end_io:
+ *
+ * IOMAP_DIO_SIMPLE_SUBMITTING: Initial state set before submitting the bio.
+ *
+ * IOMAP_DIO_SIMPLE_QUEUED: The submitter has safely queued the IO and will
+ * return -EIOCBQUEUED. If end_io sees this state, it takes over and calls
+ * ki_complete().
+ *
+ * IOMAP_DIO_SIMPLE_DONE: end_io fired before the submitter finished the
+ * submit path. end_io sets this state and does nothing else. The submitter
+ * will see this state and handle the completion synchronously (bypassing
+ * ki_complete() and returning the actual result).
+ */
+enum {
+	IOMAP_DIO_SIMPLE_SUBMITTING = 0,
+	IOMAP_DIO_SIMPLE_QUEUED,
+	IOMAP_DIO_SIMPLE_DONE,
+};
+
+static ssize_t iomap_dio_simple_read_finish(struct kiocb *iocb,
+		struct bio *bio, ssize_t ret)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	struct iomap_dio_simple_read *sr = bio->bi_private;
+
+	if (likely(!ret)) {
+		ret = sr->size;
+		iocb->ki_pos += ret;
+	} else {
+		fserror_report_io(inode, FSERR_DIRECTIO_READ, iocb->ki_pos,
+				  sr->size, ret, GFP_NOFS);
+	}
+
+	iomap_dio_bio_release_pages(bio, sr->dio_flags, ret < 0);
+
+	return ret;
+}
+
+static ssize_t iomap_dio_simple_read_complete(struct kiocb *iocb,
+		struct bio *bio)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	ssize_t ret;
+
+	WRITE_ONCE(iocb->private, NULL);
+
+	ret = iomap_dio_simple_read_finish(iocb, bio,
+			blk_status_to_errno(bio->bi_status));
+
+	inode_dio_end(inode);
+	trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0, ret > 0 ? ret : 0);
+	return ret;
+}
+
+static void iomap_dio_simple_read_complete_work(struct work_struct *work)
+{
+	struct iomap_dio_simple_read *sr =
+		container_of(work, struct iomap_dio_simple_read, work);
+	struct kiocb *iocb = sr->iocb;
+	ssize_t ret;
+
+	ret = iomap_dio_simple_read_complete(iocb, &sr->bio);
+	iocb->ki_complete(iocb, ret);
+}
+
+static void iomap_dio_simple_read_async_done(struct iomap_dio_simple_read *sr)
+{
+	struct kiocb *iocb = sr->iocb;
+
+	if (unlikely(sr->bio.bi_status)) {
+		struct inode *inode = file_inode(iocb->ki_filp);
+
+		INIT_WORK(&sr->work, iomap_dio_simple_read_complete_work);
+		queue_work(inode->i_sb->s_dio_done_wq, &sr->work);
+		return;
+	}
+
+	iomap_dio_simple_read_complete_work(&sr->work);
+}
+
+static void iomap_dio_simple_read_end_io(struct bio *bio)
+{
+	struct iomap_dio_simple_read *sr = bio->bi_private;
+
+	if (sr->waiter) {
+		struct task_struct *waiter = sr->waiter;
+
+		WRITE_ONCE(sr->waiter, NULL);
+		blk_wake_io_task(waiter);
+		return;
+	}
+
+	if (likely(atomic_read(&sr->state) == IOMAP_DIO_SIMPLE_QUEUED) ||
+	    atomic_cmpxchg(&sr->state, IOMAP_DIO_SIMPLE_SUBMITTING,
+			   IOMAP_DIO_SIMPLE_DONE) == IOMAP_DIO_SIMPLE_QUEUED)
+		iomap_dio_simple_read_async_done(sr);
+}
+
+static inline bool iomap_dio_simple_read_supported(struct kiocb *iocb,
+		struct iov_iter *iter, unsigned int dio_flags)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	size_t count = iov_iter_count(iter);
+
+	if (iov_iter_rw(iter) != READ)
+		return false;
+	if (!count)
+		return false;
+	/*
+	 * Simple read is an optimization for small IO. Filter out large IO
+	 * early as it's the most common case to fail for typical direct IO
+	 * workloads.
+	 */
+	if (count > inode->i_sb->s_blocksize)
+		return false;
+	if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_PARTIAL))
+		return false;
+	if (iocb->ki_pos + count > i_size_read(inode))
+		return false;
+
+	return true;
+}
+
+static ssize_t iomap_dio_simple_read(struct kiocb *iocb,
+		struct iov_iter *iter, const struct iomap_ops *ops,
+		void *private, unsigned int dio_flags)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	size_t count = iov_iter_count(iter);
+	int nr_pages;
+	struct iomap_dio_simple_read *sr;
+	unsigned int alignment;
+	struct iomap_iter iomi = {
+		.inode		= inode,
+		.pos		= iocb->ki_pos,
+		.len		= count,
+		.flags		= IOMAP_DIRECT,
+		.private	= private,
+	};
+	struct bio *bio;
+	bool wait_for_completion = is_sync_kiocb(iocb);
+	ssize_t ret;
+
+	if (dio_flags & IOMAP_DIO_BOUNCE)
+		nr_pages = bio_iov_bounce_nr_vecs(iter, REQ_OP_READ);
+	else
+		nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS);
+
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		iomi.flags |= IOMAP_NOWAIT;
+
+	ret = kiocb_write_and_wait(iocb, count);
+	if (ret)
+		return ret;
+
+	inode_dio_begin(inode);
+
+	ret = ops->iomap_begin(inode, iomi.pos, count, iomi.flags,
+			       &iomi.iomap, &iomi.srcmap);
+	if (ret) {
+		inode_dio_end(inode);
+		return ret;
+	}
+
+	if (iomi.iomap.type != IOMAP_MAPPED ||
+	    iomi.iomap.offset > iomi.pos ||
+	    iomi.iomap.offset + iomi.iomap.length < iomi.pos + count ||
+	    (iomi.iomap.flags & IOMAP_F_INTEGRITY)) {
+		ret = -ENOTBLK;
+		goto out_iomap_end;
+	}
+
+	alignment = iomap_dio_alignment(inode, iomi.iomap.bdev, dio_flags);
+	if ((iomi.pos | count) & (alignment - 1)) {
+		ret = -EINVAL;
+		goto out_iomap_end;
+	}
+
+	if (!wait_for_completion && unlikely(!inode->i_sb->s_dio_done_wq)) {
+		ret = sb_init_dio_done_wq(inode->i_sb);
+		if (ret < 0)
+			goto out_iomap_end;
+	}
+
+	trace_iomap_dio_rw_begin(iocb, iter, dio_flags, 0);
+
+	if (user_backed_iter(iter))
+		dio_flags |= IOMAP_DIO_USER_BACKED;
+
+	bio = bio_alloc_bioset(iomi.iomap.bdev, nr_pages,
+			       REQ_OP_READ | REQ_SYNC | REQ_IDLE,
+			       GFP_KERNEL, &iomap_dio_simple_read_pool);
+	sr = container_of(bio, struct iomap_dio_simple_read, bio);
+
+	fscrypt_set_bio_crypt_ctx(bio, inode, iomi.pos, GFP_KERNEL);
+	sr->iocb = iocb;
+	sr->dio_flags = dio_flags;
+
+	bio->bi_iter.bi_sector = iomap_sector(&iomi.iomap, iomi.pos);
+	bio->bi_ioprio = iocb->ki_ioprio;
+	bio->bi_private = sr;
+	bio->bi_end_io = iomap_dio_simple_read_end_io;
+
+	if (dio_flags & IOMAP_DIO_BOUNCE)
+		ret = bio_iov_iter_bounce(bio, iter, count);
+	else
+		ret = bio_iov_iter_get_pages(bio, iter, alignment - 1);
+	if (unlikely(ret))
+		goto out_bio_put;
+
+	if (bio->bi_iter.bi_size != count) {
+		iov_iter_revert(iter, bio->bi_iter.bi_size);
+		ret = -ENOTBLK;
+		goto out_bio_release_pages;
+	}
+
+	sr->size = bio->bi_iter.bi_size;
+
+	if ((dio_flags & IOMAP_DIO_USER_BACKED) &&
+	    !(dio_flags & IOMAP_DIO_BOUNCE))
+		bio_set_pages_dirty(bio);
+
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		bio->bi_opf |= REQ_NOWAIT;
+	if ((iocb->ki_flags & IOCB_HIPRI) && !wait_for_completion) {
+		bio->bi_opf |= REQ_POLLED;
+		bio_set_polled(bio, iocb);
+		WRITE_ONCE(iocb->private, bio);
+	}
+
+	if (wait_for_completion) {
+		sr->waiter = current;
+		blk_crypto_submit_bio(bio);
+	} else {
+		atomic_set(&sr->state, IOMAP_DIO_SIMPLE_SUBMITTING);
+		sr->waiter = NULL;
+		blk_crypto_submit_bio(bio);
+		ret = -EIOCBQUEUED;
+	}
+
+	if (ops->iomap_end)
+		ops->iomap_end(inode, iomi.pos, count, count, iomi.flags,
+			       &iomi.iomap);
+
+	if (wait_for_completion) {
+		for (;;) {
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			if (!READ_ONCE(sr->waiter))
+				break;
+			blk_io_schedule();
+		}
+		__set_current_state(TASK_RUNNING);
+
+		ret = iomap_dio_simple_read_finish(iocb, bio,
+				blk_status_to_errno(bio->bi_status));
+		inode_dio_end(inode);
+		trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0,
+					 ret > 0 ? ret : 0);
+	} else if (atomic_cmpxchg(&sr->state, IOMAP_DIO_SIMPLE_SUBMITTING,
+				  IOMAP_DIO_SIMPLE_QUEUED) ==
+		   IOMAP_DIO_SIMPLE_DONE) {
+		ret = iomap_dio_simple_read_complete(iocb, bio);
+	} else {
+		trace_iomap_dio_rw_queued(inode, iomi.pos, count);
+	}
+
+	return ret;
+
+out_bio_release_pages:
+	if (dio_flags & IOMAP_DIO_BOUNCE)
+		bio_iov_iter_unbounce(bio, true, false);
+	else
+		bio_release_pages(bio, false);
+out_bio_put:
+	bio_put(bio);
+out_iomap_end:
+	if (ops->iomap_end)
+		ops->iomap_end(inode, iomi.pos, count, 0, iomi.flags,
+			       &iomi.iomap);
+	inode_dio_end(inode);
+	return ret;
+}
+
 ssize_t
 iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags, void *private, size_t done_before)
 {
 	struct iomap_dio *dio;
+	ssize_t ret;
+
+	/*
+	 * Fast path for small, block-aligned reads that map to a single
+	 * contiguous on-disk extent.
+	 *
+	 * @dops must be NULL: a non-NULL @dops means the caller wants its
+	 * ->end_io / ->submit_io hooks invoked, and in particular wants its
+	 * bios to be allocated from the filesystem-private @dops->bio_set
+	 * (whose front_pad sizes a filesystem-private wrapper around the
+	 * bio).  The fast path instead allocates from the shared
+	 * iomap_dio_simple_read_pool, whose front_pad matches
+	 * struct iomap_dio_simple_read; the two wrappers are not
+	 * interchangeable, so we must fall back to __iomap_dio_rw() in
+	 * that case.
+	 *
+	 * @done_before must be zero: a non-zero caller-accumulated residual
+	 * cannot be carried through a single-bio inline completion.
+	 *
+	 * -ENOTBLK is the private sentinel returned by iomap_dio_simple_read()
+	 * when it decides the request does not fit the fast path.
+	 * In that case we proceed to the generic __iomap_dio_rw() slow
+	 * path.  Any other errno is a real result and is propagated as-is,
+	 * in particular -EAGAIN for IOCB_NOWAIT must reach the caller.
+	 */
+	if (!dops && !done_before &&
+	    iomap_dio_simple_read_supported(iocb, iter, dio_flags)) {
+		ret = iomap_dio_simple_read(iocb, iter, ops, private, dio_flags);
+		if (ret != -ENOTBLK)
+			return ret;
+	}
 
 	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags, private,
 			     done_before);
@@ -905,3 +1259,11 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	return iomap_dio_complete(dio);
 }
 EXPORT_SYMBOL_GPL(iomap_dio_rw);
+
+static int __init iomap_dio_init(void)
+{
+	return bioset_init(&iomap_dio_simple_read_pool, 4,
+			   offsetof(struct iomap_dio_simple_read, bio),
+			   BIOSET_NEED_BVECS | BIOSET_PERCPU_CACHE);
+}
+fs_initcall(iomap_dio_init);
-- 
2.39.5 (Apple Git-154)
