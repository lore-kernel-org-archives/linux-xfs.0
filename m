Received: from va-2-114.ptr.blmpb.com (va-2-114.ptr.blmpb.com [209.127.231.114])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3437D368953
	for <linux-xfs@vger.kernel.org>; Mon, 29 Jun 2026 12:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782734596; cv=none; b=QgqfuIDuBvNhlsiMC4d3IorOUyFaWIM/AJwRHRs5Repr9gfeRm3wnCZhLiH+5aBw+/5R+kXAcXnc2YSGnb85qARSUEq1f/0WTy8taKxXFOIOsdmVp7EAIfnO8tkhDpQxD48KauWQXkYxR7zMhM3GwS0VydXYOn0pXC1PPRoYD90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782734596; c=relaxed/simple;
	bh=e1nPDJPcEh7PEPGDu7cYXW1QCFfxF/4Kd8K27zbM36Y=;
	h=Subject:Date:In-Reply-To:References:Cc:Mime-Version:Content-Type:
	 From:To:Message-Id; b=M0ujzpJ5SuP5BuCojB6KQtER0loSQ060s1ZTid91MiuPg3pLqTjtg2QDnQIB6m2UZqGggOH0iHsOQyu483e+6NXeYhUXicFt81fCt+Hr8YNPFrKucIdmK58Gn8FKBo4eKun5NMUoEnLSX8jLgUQBFbpsMQFvaVtnbksNs+7K5Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=hhYEJ+Zz; arc=none smtp.client-ip=209.127.231.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="hhYEJ+Zz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782734583; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=FNJFSGUwknF6NUViVDL+nuItE8qclSQPXfIoyiXEDFw=;
 b=hhYEJ+Zzos6cfrEtJptVV7d56q4aM0LDgYDUy/cc64qjBTNAZi5kPdUC7ishSxV+6OE+Jy
 dKyrZDSyXJd5ly584xlYR+DlgnX4YcIWQW0UGivvtFjAPpTKWyJ50n3cLh8+qI4RCYyZO6
 PpB2dOcdZxNCWRDlbp1z8gCSvZqNkoLzZtb+H2GXaI7Nc9fivBvs4f4wi3za2CCE94dq1E
 qSQqqUQtoCwSKp2F27AIZg7tzwzSsye4bgi2ods/G82EgTbL3Fw8i12YynWa4xJrwwkYXd
 druyUrwrBtNMFyC0/NPJ3w6zmI4APt0P+GoVxX7xxeBZ1yYvWKV6nGoQcH2Shg==
Subject: [PATCH v5 4/4] iomap: add simple dio path for small direct I/O
Date: Mon, 29 Jun 2026 20:01:24 +0800
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260629120124.25223-1-changfengnan@bytedance.com>
References: <20260629120124.25223-1-changfengnan@bytedance.com>
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a425ef5+dd4fa3+vger.kernel.org+changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Fengnan Chang" <changfengnan@bytedance.com>
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
To: <brauner@kernel.org>, <djwong@kernel.org>, <hch@infradead.org>, 
	<ojaswin@linux.ibm.com>, <dgc@kernel.org>, <linux-xfs@vger.kernel.org>, 
	<linux-fsdevel@vger.kernel.org>, <linux-ext4@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <lidiangang@bytedance.com>, 
	<pankaj.raghav@linux.dev>
Message-Id: <20260629120124.25223-5-changfengnan@bytedance.com>

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

Introduce a simple dio path to reduce the overhead of iomap. It is
triggered when the request satisfies all of:
- a READ request whose I/O size is <= inode blocksize (fits in a single
  block, no splits);
- no custom iomap_dio_ops (dops) registered by the filesystem;
- no caller-accumulated residual (done_before == 0);
- none of IOMAP_DIO_FORCE_WAIT / IOMAP_DIO_PARTIAL / IOMAP_DIO_BOUNCE
  set, the range is within i_size, and the inode is not encrypted.

The bio is allocated from a dedicated bioset whose front_pad embeds
struct iomap_dio_simple, so the whole request lives in a single
cacheline-aligned allocation and no separate struct iomap_dio is
needed.  Completion is handled inline from ->bi_end_io for the common
success case, and only punted to the s_dio_done_wq workqueue on error.

After this optimization, the heavy generic functions disappear from the
profile, replaced by a single streamlined execution path:
  4.83%  [kernel]  [k] iomap_dio_simple

With this patch, 4K random read IOPS on ext4 increases from 1.92M to
2.19M in the original single-core io_uring poll-mode workload.

Below are the fio 4K direct randread results from a broader QD
sweep on a SOLIDIGM SB5PH27X038T NVMe SSD.  Each result is the
average of three 20-second runs after a 5-second ramp time, using a
128G test file and toggling /sys/kernel/iomap/simple_read:

  fs    workload       qd    simple=0      simple=1      gain
  ext4  libaio         1     18,740        18,761        +0.11%
  ext4  libaio         64    462,850       480,587       +3.83%
  ext4  libaio         128   459,498       478,824       +4.21%
  ext4  libaio         256   459,938       480,156       +4.40%
  ext4  io_uring       1     18,836        18,880        +0.24%
  ext4  io_uring       64    568,193       600,625       +5.71%
  ext4  io_uring       128   570,998       602,148       +5.46%
  ext4  io_uring       256   572,052       602,536       +5.33%
  ext4  io_uring_poll  1     19,283        19,272        -0.06%
  ext4  io_uring_poll  64    989,735       1,013,342     +2.39%
  ext4  io_uring_poll  128   1,467,336     1,538,444     +4.85%
  ext4  io_uring_poll  256   1,663,498     1,830,842     +10.06%
  xfs   libaio         1     18,764        18,776        +0.06%
  xfs   libaio         64    462,408       480,860       +3.99%
  xfs   libaio         128   461,280       480,819       +4.24%
  xfs   libaio         256   461,626       480,190       +4.02%
  xfs   io_uring       1     18,871        18,903        +0.17%
  xfs   io_uring       64    570,383       597,399       +4.74%
  xfs   io_uring       128   568,290       597,370       +5.12%
  xfs   io_uring       256   570,616       598,775       +4.93%
  xfs   io_uring_poll  1     19,211        19,315        +0.54%
  xfs   io_uring_poll  64    989,726       1,008,455     +1.89%
  xfs   io_uring_poll  128   1,430,426     1,513,064     +5.78%
  xfs   io_uring_poll  256   1,587,339     1,742,220     +9.76%

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/iomap/direct-io.c | 252 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 252 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 4db79ddc1ddd4..4dcc9fc766a92 100644
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
 
@@ -899,12 +902,253 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 }
 EXPORT_SYMBOL_GPL(__iomap_dio_rw);
 
+struct iomap_dio_simple {
+	struct kiocb		*iocb;
+	size_t			size;
+	unsigned int		dio_flags;
+	struct work_struct	work;
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
+static struct bio_set iomap_dio_simple_pool;
+
+static ssize_t iomap_dio_simple_complete(struct iomap_dio_simple *sr)
+{
+	struct bio *bio = &sr->bio;
+	struct kiocb *iocb = sr->iocb;
+	struct inode *inode = file_inode(iocb->ki_filp);
+	int error = blk_status_to_errno(bio->bi_status);
+	ssize_t ret = error;
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
+	inode_dio_end(inode);
+	trace_iomap_dio_complete(iocb, error, ret);
+	return ret;
+}
+
+static void iomap_dio_simple_complete_work(struct work_struct *work)
+{
+	struct iomap_dio_simple *sr =
+			container_of(work, struct iomap_dio_simple, work);
+
+	WRITE_ONCE(sr->iocb->private, NULL);
+	sr->iocb->ki_complete(sr->iocb, iomap_dio_simple_complete(sr));
+}
+
+static void iomap_dio_simple_end_io(struct bio *bio)
+{
+	struct iomap_dio_simple *sr =
+		container_of(bio, struct iomap_dio_simple, bio);
+
+	if (unlikely(sr->bio.bi_status)) {
+		struct inode *inode = file_inode(sr->iocb->ki_filp);
+
+		INIT_WORK(&sr->work, iomap_dio_simple_complete_work);
+		queue_work(inode->i_sb->s_dio_done_wq, &sr->work);
+		return;
+	}
+
+	sr->iocb->ki_complete(sr->iocb, iomap_dio_simple_complete(sr));
+}
+
+static inline bool iomap_dio_simple_supported(struct kiocb *iocb,
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
+	 * Simple dio is an optimization for small IO. Filter out large IO
+	 * early as it's the most common case to fail for typical direct IO
+	 * workloads.
+	 */
+	if (count > inode->i_sb->s_blocksize)
+		return false;
+	if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_PARTIAL |
+			 IOMAP_DIO_BOUNCE))
+		return false;
+	if (iocb->ki_pos + count > i_size_read(inode))
+		return false;
+	if (IS_ENCRYPTED(inode))
+		return false;
+
+	return true;
+}
+
+static ssize_t iomap_dio_simple(struct kiocb *iocb,
+		struct iov_iter *iter, const struct iomap_ops *ops,
+		void *private, unsigned int dio_flags)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	size_t count = iov_iter_count(iter);
+	struct iomap_dio_simple *sr;
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
+	bio = bio_alloc_bioset(iomi.iomap.bdev,
+			bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS),
+			REQ_OP_READ,
+			GFP_KERNEL, &iomap_dio_simple_pool);
+	sr = container_of(bio, struct iomap_dio_simple, bio);
+	sr->iocb = iocb;
+	sr->dio_flags = dio_flags;
+
+	bio->bi_iter.bi_sector = iomap_sector(&iomi.iomap, iomi.pos);
+	bio->bi_ioprio = iocb->ki_ioprio;
+
+	ret = bio_iov_iter_get_pages(bio, iter, alignment - 1);
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
+	if (dio_flags & IOMAP_DIO_USER_BACKED)
+		bio_set_pages_dirty(bio);
+
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		bio->bi_opf |= REQ_NOWAIT;
+	if ((iocb->ki_flags & IOCB_HIPRI) && !wait_for_completion) {
+		bio->bi_opf |= REQ_POLLED;
+		WRITE_ONCE(iocb->private, bio);
+	}
+
+	if (ops->iomap_end)
+		ops->iomap_end(inode, iomi.pos, count, count, iomi.flags,
+			       &iomi.iomap);
+
+	if (!wait_for_completion) {
+		bio->bi_end_io = iomap_dio_simple_end_io;
+		submit_bio(bio);
+		trace_iomap_dio_rw_queued(inode, iomi.pos, count);
+		return -EIOCBQUEUED;
+	}
+
+	submit_bio_wait(bio);
+	return iomap_dio_simple_complete(sr);
+
+out_bio_release_pages:
+	bio_release_pages(bio, false);
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
+	 * Fast path for small, block-aligned direct I/Os that map to a
+	 * single contiguous on-disk extent.
+	 *
+	 * @dops must be NULL: a non-NULL @dops means the caller wants its
+	 * ->end_io / ->submit_io hooks invoked, and in particular wants its
+	 * bios to be allocated from the filesystem-private @dops->bio_set
+	 * (whose front_pad sizes a filesystem-private wrapper around the
+	 * bio).  The fast path instead allocates from the shared
+	 * iomap_dio_simple_pool, whose front_pad matches
+	 * struct iomap_dio_simple; the two wrappers are not
+	 * interchangeable, so we must fall back to __iomap_dio_rw() in
+	 * that case.
+	 *
+	 * @done_before must be zero: a non-zero caller-accumulated residual
+	 * cannot be carried through a single-bio inline completion.
+	 *
+	 * -ENOTBLK is the private sentinel returned by iomap_dio_simple()
+	 * when it decides the request does not fit the fast path.
+	 * In that case we proceed to the generic __iomap_dio_rw() slow
+	 * path.  Any other errno is a real result and is propagated as-is,
+	 * in particular -EAGAIN for IOCB_NOWAIT must reach the caller.
+	 */
+	if (!dops && !done_before &&
+	    iomap_dio_simple_supported(iocb, iter, dio_flags)) {
+		ret = iomap_dio_simple(iocb, iter, ops, private, dio_flags);
+		if (ret != -ENOTBLK)
+			return ret;
+	}
 
 	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags, private,
 			     done_before);
@@ -913,3 +1157,11 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	return iomap_dio_complete(dio);
 }
 EXPORT_SYMBOL_GPL(iomap_dio_rw);
+
+static int __init iomap_dio_init(void)
+{
+	return bioset_init(&iomap_dio_simple_pool, 4,
+			   offsetof(struct iomap_dio_simple, bio),
+			   BIOSET_NEED_BVECS | BIOSET_PERCPU_CACHE);
+}
+fs_initcall(iomap_dio_init);
-- 
2.39.5 (Apple Git-154)
