Received: from va-2-114.ptr.blmpb.com (va-2-114.ptr.blmpb.com [209.127.231.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF8F282F02
	for <linux-xfs@vger.kernel.org>; Mon,  8 Jun 2026 07:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780903996; cv=none; b=Go/YxYv5oalajHWT+gRATKSOrIo5azkB+FZNiJ0JReFqzNrBDbuvNhRx1ERxRLFYAhfETDBk/0q9Ou4i4zG7mkDPCnMZhqL6lVdIC47GyM/WPKaWDnvmzHAhiUNFCMVbpS1zm4HdZDb/Tc2D9du3YEhGviZ/19oNsmNZzAp95y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780903996; c=relaxed/simple;
	bh=jMDxYi9bSGDpcLgim82R0ETgcuybreeRgKPsLYvEeos=;
	h=To:Message-Id:Mime-Version:Content-Type:Subject:Cc:From:Date; b=TlpIV+zyexyK5iFpo6ejm5dv3Ro60Ur013kOrpEIfnuWo9SqN4uCRCB+Qp4pRF01ELZDCNhvu894DsU44GSuDV9JGx75sAcx7GGdPpH0B6sFBks4dtCT0mTvhYt4Q6/JVnoUgkZ/4/vW6joCjwaleBuI9nRTmFDK+jbM3WKRmko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=EFI3Ash+; arc=none smtp.client-ip=209.127.231.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="EFI3Ash+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780903981; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=v/a4KSkF1+q1L1dGr/wbyoSKAQjmfLscwWEn5p/2D5U=;
 b=EFI3Ash+9YZEbIz2CLJXL79ulRcZQ8Bl71lzdaxGQEMlADwEAllJoDkbhENlvFFqU4UaUN
 3Cequ4rss5NpEE5E4i2GZ78haBNHJI5VB9NNzAMawH4FqEFgRO9+BbtzO/6fmuROoj/sya
 vNKZJSCSPLGnfEcGA5pbV6mS6XQ/e/k7eI928rHFCz+7ylxDz9U6bcFg+JiRBVbH9866y8
 67Grf9Mk7DWsa/35Q0H7vr5UKv7fvmj8O8HUhjwSg5U51YZVsQm5Cqq62kDRYDHWyQK1Fl
 4xS7Itp1umAcjkrGbc07bsSLAEO3Iz6CJaVlgoJ67l1vHu7yiET+n/S62eGaNQ==
To: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>
Message-Id: <20260608073134.95964-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+26a26702b+6dd0dc+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v4] iomap: add simple read path for small direct I/O
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
From: "Fengnan Chang" <changfengnan@bytedance.com>
Date: Mon,  8 Jun 2026 15:31:33 +0800
Content-Transfer-Encoding: 7bit

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
ext4  libaio         1     18,768        18,796        +0.15%
ext4  libaio         64    462,459       479,435       +3.67%
ext4  libaio         128   462,427       478,411       +3.46%
ext4  libaio         256   461,579       477,561       +3.46%
ext4  io_uring       1     18,898        18,914        +0.08%
ext4  io_uring       64    564,405       590,145       +4.56%
ext4  io_uring       128   563,322       592,365       +5.16%
ext4  io_uring       256   562,281       590,593       +5.04%
ext4  io_uring_poll  1     19,292        19,271        -0.11%
ext4  io_uring_poll  64    994,612       1,006,334     +1.18%
ext4  io_uring_poll  128   1,421,945     1,518,535     +6.79%
ext4  io_uring_poll  256   1,576,507     1,772,901     +12.46%
xfs   libaio         1     18,778        18,781        +0.01%
xfs   libaio         64    459,617       476,411       +3.65%
xfs   libaio         128   461,642       477,571       +3.45%
xfs   libaio         256   459,828       475,224       +3.35%
xfs   io_uring       1     18,898        18,923        +0.13%
xfs   io_uring       64    557,195       583,320       +4.69%
xfs   io_uring       128   560,109       585,549       +4.54%
xfs   io_uring       256   559,117       581,846       +4.07%
xfs   io_uring_poll  1     19,257        19,301        +0.23%
xfs   io_uring_poll  64    983,827       998,497       +1.49%
xfs   io_uring_poll  128   1,389,644     1,489,604     +7.19%
xfs   io_uring_poll  256   1,523,554     1,702,827     +11.77%

v4:
fix fserror report and update test data based on v7.1-rc3.

v3:
Test data updated based on v7.1-rc3.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/iomap/direct-io.c | 390 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 376 insertions(+), 14 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b36ee619cdcdd..3cb179752612e 100644
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
 
@@ -88,9 +91,9 @@ static inline enum fserror_type iomap_dio_err_type(const struct iomap_dio *dio)
 	return FSERR_DIRECTIO_READ;
 }
 
-static inline bool should_report_dio_fserror(const struct iomap_dio *dio)
+static inline bool should_report_dio_fserror(int error)
 {
-	switch (dio->error) {
+	switch (error) {
 	case 0:
 	case -EAGAIN:
 	case -ENOTBLK:
@@ -110,7 +113,7 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
 
 	if (dops && dops->end_io)
 		ret = dops->end_io(iocb, dio->size, ret, dio->flags);
-	if (should_report_dio_fserror(dio))
+	if (should_report_dio_fserror(dio->error))
 		fserror_report_io(file_inode(iocb->ki_filp),
 				  iomap_dio_err_type(dio), offset, dio->size,
 				  dio->error, GFP_NOFS);
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
+	} else if (should_report_dio_fserror(ret)) {
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
