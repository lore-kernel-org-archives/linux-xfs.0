Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D445644A724;
	Wed,  1 Jul 2026 11:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782905015; cv=none; b=oh174VLRF6fWUECAYYlMKoVVWFNQzlS8KQUjzL6ZNRcIhZdX1tblb6oj3U2CbQYULrSp1kmb32VTp526CgMqXB5MtEkyRCB82PMq7xU188UCb0LFQba3hfMpSaJIqIL/9aValNJAX8TvsPo6mbjj41tQhouPr0RLoL2SQdETLYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782905015; c=relaxed/simple;
	bh=VasYCGeHP3ElEvAVGUOAMDgA84A1oQWtR/xJidvMi98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lxQsM+dW+9zSdCK6Zug2fX5gB+V5fOc38RIQjzFPdf5vTZAuTzwfSVJjeAHBbvUcAXVIRNGo6Wc3dA0dSeJQR8YcGtPiRfoPqJphxVH2+Tjz4hYb1+GOkOFFHYH4i/861m7PgrDv8/LhjAY624KZz0AnFBxCLEvudyIU7StSUm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U3dvPvW3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U3dvPvW3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wSlkpk/pXQqtQGp19r2NoW/jgzvNH6hFQOWBpD5JSt8=; b=U3dvPvW3InCu9YGfeaLzpmROPt
	qxseUN+i6bF9ubDbClN0TGHUfdfkDKRoQyx4k+LqZZWoy5qE+7LXl+y61OYgPAqbmKpSn+50JOiF5
	EhCLV2mFGnT2sfFf5pp1aX0Gj2dNSnWvfUrR0ZnVT/T/PdZtuxEXv0Q4sG25C5gESl6idAyV4eVEH
	d3qBosCnscXInN7fi3fyNCU93IH7eN6m7Lyj3tLTw9GGVxUH0MQJdq9qvg7Rbvcn2lWsNZMX4Wb18
	eFLn7ePVkYG0qLVdEvQxgzUNbvl1qvuBmsZyZqo/VMWCBcDdMQMptgBxw2XD2Yhzz7sUcR/viK3X2
	i6aFm34g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wet2S-00000001S6X-42hb;
	Wed, 01 Jul 2026 11:23:32 +0000
Date: Wed, 1 Jul 2026 04:23:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@infradead.org,
	ojaswin@linux.ibm.com, dgc@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, lidiangang@bytedance.com,
	pankaj.raghav@linux.dev, Joanne Koong <joannelkoong@gmail.com>
Subject: Re: [PATCH v6 3/3] iomap: add simple dio path for small direct I/O
Message-ID: <akT4tJzFSfrBxqdq@infradead.org>
References: <20260701033253.46420-1-changfengnan@bytedance.com>
 <20260701033253.46420-4-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701033253.46420-4-changfengnan@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

We'll need to sort out the interaction with the iomap_next work, though.

Joanne, is it ok to get this in first and have Fengnan help your with
the interactions due to the open coded iomap_begin/end calls?

On Wed, Jul 01, 2026 at 11:32:53AM +0800, Fengnan Chang wrote:
> When running 4K random read workloads on high-performance Gen5 NVMe
> SSDs, the software overhead in the iomap direct I/O path
> (__iomap_dio_rw) becomes a significant bottleneck.
> 
> Using io_uring with poll mode for a 4K randread test on a raw block
> device:
> taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
> -n1 -P1 /dev/nvme10n1
> Result: ~3.2M IOPS
> 
> Running the exact same workload on ext4 and XFS:
> taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
> -n1 -P1 /mnt/testfile
> Result: ~1.92M IOPS
> 
> Profiling the ext4 workload reveals that a significant portion of CPU
> time is spent on memory allocation and the iomap state machine
> iteration:
>   5.33%  [kernel]  [k] __iomap_dio_rw
>   3.26%  [kernel]  [k] iomap_iter
>   2.37%  [kernel]  [k] iomap_dio_bio_iter
>   2.35%  [kernel]  [k] kfree
>   1.33%  [kernel]  [k] iomap_dio_complete
> 
> Introduce a simple dio path to reduce the overhead of iomap. It is
> triggered when the request satisfies all of:
> - a READ request whose I/O size is <= inode blocksize (fits in a single
>   block, no splits);
> - no custom iomap_dio_ops (dops) registered by the filesystem;
> - no caller-accumulated residual (done_before == 0);
> - none of IOMAP_DIO_FORCE_WAIT / IOMAP_DIO_PARTIAL / IOMAP_DIO_BOUNCE
>   set, the range is within i_size, and the inode is not encrypted.
> 
> The bio is allocated from a dedicated bioset whose front_pad embeds
> struct iomap_dio_simple, so the whole request lives in a single
> cacheline-aligned allocation and no separate struct iomap_dio is
> needed.  Completion is handled inline from ->bi_end_io for the common
> success case, and only punted to the s_dio_done_wq workqueue on error.
> 
> After this optimization, the heavy generic functions disappear from the
> profile, replaced by a single streamlined execution path:
>   4.83%  [kernel]  [k] iomap_dio_simple
> 
> With this patch, 4K random read IOPS on ext4 increases from 1.92M to
> 2.19M in the original single-core io_uring poll-mode workload.
> 
> Below are the test results using fio:
> 
>   fs    workload       qd    simple=0      simple=1      gain
>   ext4  libaio         1     18,740        18,761        +0.11%
>   ext4  libaio         64    462,850       480,587       +3.83%
>   ext4  libaio         128   459,498       478,824       +4.21%
>   ext4  libaio         256   459,938       480,156       +4.40%
>   ext4  io_uring       1     18,836        18,880        +0.24%
>   ext4  io_uring       64    568,193       600,625       +5.71%
>   ext4  io_uring       128   570,998       602,148       +5.46%
>   ext4  io_uring       256   572,052       602,536       +5.33%
>   ext4  io_uring_poll  1     19,283        19,272        -0.06%
>   ext4  io_uring_poll  64    989,735       1,013,342     +2.39%
>   ext4  io_uring_poll  128   1,467,336     1,538,444     +4.85%
>   ext4  io_uring_poll  256   1,663,498     1,830,842     +10.06%
>   xfs   libaio         1     18,764        18,776        +0.06%
>   xfs   libaio         64    462,408       480,860       +3.99%
>   xfs   libaio         128   461,280       480,819       +4.24%
>   xfs   libaio         256   461,626       480,190       +4.02%
>   xfs   io_uring       1     18,871        18,903        +0.17%
>   xfs   io_uring       64    570,383       597,399       +4.74%
>   xfs   io_uring       128   568,290       597,370       +5.12%
>   xfs   io_uring       256   570,616       598,775       +4.93%
>   xfs   io_uring_poll  1     19,211        19,315        +0.54%
>   xfs   io_uring_poll  64    989,726       1,008,455     +1.89%
>   xfs   io_uring_poll  128   1,430,426     1,513,064     +5.78%
>   xfs   io_uring_poll  256   1,587,339     1,742,220     +9.76%
> 
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> ---
>  fs/iomap/direct-io.c | 274 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 274 insertions(+)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 1b9abdd831d0b..ca790239e5eb3 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -10,6 +10,7 @@
>  #include <linux/iomap.h>
>  #include <linux/task_io_accounting_ops.h>
>  #include <linux/fserror.h>
> +#include <linux/init.h>
>  #include "internal.h"
>  #include "trace.h"
>  
> @@ -893,12 +894,277 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  }
>  EXPORT_SYMBOL_GPL(__iomap_dio_rw);
>  
> +struct iomap_dio_simple {
> +	struct kiocb		*iocb;
> +	size_t			size;
> +	unsigned int		dio_flags;
> +	struct work_struct	work;
> +	/*
> +	 * Align @bio to a cacheline boundary so that, combined with the
> +	 * front_pad passed to bioset_init(), the bio sits at the start of
> +	 * a cacheline in memory returned by the (HWCACHE-aligned) bio
> +	 * slab.  This keeps the hot fields block layer touches on submit
> +	 * and completion (bi_iter, bi_status, ...) within a single line.
> +	 */
> +	struct bio		bio ____cacheline_aligned_in_smp;
> +};
> +
> +static struct bio_set iomap_dio_simple_pool;
> +
> +static ssize_t iomap_dio_simple_complete(struct iomap_dio_simple *sr)
> +{
> +	struct bio *bio = &sr->bio;
> +	struct kiocb *iocb = sr->iocb;
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +	ssize_t ret;
> +
> +	if (unlikely(bio->bi_status)) {
> +		ret = blk_status_to_errno(bio->bi_status);
> +		if (should_report_dio_fserror(ret))
> +			fserror_report_io(inode, FSERR_DIRECTIO_READ,
> +					  iocb->ki_pos, sr->size, ret,
> +					  GFP_NOFS);
> +	} else {
> +		ret = sr->size;
> +		iocb->ki_pos += ret;
> +	}
> +
> +	if (sr->dio_flags & IOMAP_DIO_USER_BACKED) {
> +		bio_check_pages_dirty(bio);
> +	} else {
> +		bio_release_pages(bio, false);
> +		bio_put(bio);
> +	}
> +	inode_dio_end(inode);
> +	trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0, ret);
> +	return ret;
> +}
> +
> +static void iomap_dio_simple_complete_work(struct work_struct *work)
> +{
> +	struct iomap_dio_simple *sr =
> +		container_of(work, struct iomap_dio_simple, work);
> +	struct kiocb *iocb = sr->iocb;
> +
> +	WRITE_ONCE(iocb->private, NULL);
> +	iocb->ki_complete(iocb, iomap_dio_simple_complete(sr));
> +}
> +
> +static void iomap_dio_simple_end_io(struct bio *bio)
> +{
> +	struct iomap_dio_simple *sr =
> +		container_of(bio, struct iomap_dio_simple, bio);
> +	struct kiocb *iocb = sr->iocb;
> +
> +	if (unlikely(sr->bio.bi_status)) {
> +		struct inode *inode = file_inode(iocb->ki_filp);
> +
> +		INIT_WORK(&sr->work, iomap_dio_simple_complete_work);
> +		queue_work(inode->i_sb->s_dio_done_wq, &sr->work);
> +		return;
> +	}
> +
> +	WRITE_ONCE(iocb->private, NULL);
> +	iocb->ki_complete(iocb, iomap_dio_simple_complete(sr));
> +}
> +
> +static inline bool
> +iomap_dio_simple_supported(struct kiocb *iocb, struct iov_iter *iter,
> +			   const struct iomap_dio_ops *dops,
> +			   unsigned int dio_flags, size_t done_before)
> +{
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +	size_t count = iov_iter_count(iter);
> +
> +	if (dops || done_before)
> +		return false;
> +	if (iov_iter_rw(iter) != READ)
> +		return false;
> +	if (!count)
> +		return false;
> +	/*
> +	 * Simple dio is an optimization for small IO. Filter out large IO
> +	 * early as it's the most common case to fail for typical direct IO
> +	 * workloads.
> +	 */
> +	if (count > inode->i_sb->s_blocksize)
> +		return false;
> +	if (dio_flags & (IOMAP_DIO_FORCE_WAIT | IOMAP_DIO_PARTIAL |
> +			 IOMAP_DIO_BOUNCE))
> +		return false;
> +	if (iocb->ki_pos + count > i_size_read(inode))
> +		return false;
> +	if (IS_ENCRYPTED(inode))
> +		return false;
> +
> +	return true;
> +}
> +
> +/*
> + * Fast path for small, block-aligned direct I/Os that map to a single
> + * contiguous on-disk extent.
> + *
> + * iomap_dio_simple_supported() enforces the cheap up-front constraints before
> + * entering this path.
> + *
> + * @dops must be NULL: a non-NULL @dops means the caller wants its
> + * ->end_io / ->submit_io hooks invoked, and in particular wants its bios to be
> + * allocated from the filesystem-private @dops->bio_set (whose front_pad sizes a
> + * filesystem-private wrapper around the bio).  The fast path instead allocates
> + * from the shared iomap_dio_simple_pool, whose front_pad matches struct
> + * iomap_dio_simple; the two wrappers are not interchangeable, so we must fall
> + * back to __iomap_dio_rw() in that case.
> + *
> + * @done_before must be zero: a non-zero caller-accumulated residual cannot be
> + * carried through a single-bio inline completion.
> + *
> + * @iter must describe a non-empty READ no larger than the inode block size:
> + * writes, zero-length I/O, and larger requests need the generic iomap direct
> + * I/O path.
> + *
> + * @dio_flags must not request IOMAP_DIO_FORCE_WAIT, IOMAP_DIO_PARTIAL, or
> + * IOMAP_DIO_BOUNCE: this path does not support forced waiting, partial direct
> + * I/O, or bouncing.  The range must also stay within i_size and encrypted
> + * inodes must use the generic iomap direct I/O path.
> + *
> + * -ENOTBLK is the private sentinel returned by iomap_dio_simple() when it
> + * decides the request does not fit the fast path.  In that case we proceed to
> + * the generic __iomap_dio_rw() slow path.  Any other errno is a real result and
> + * is propagated as-is, in particular -EAGAIN for IOCB_NOWAIT must reach the
> + * caller.
> + */
> +static ssize_t
> +iomap_dio_simple(struct kiocb *iocb, struct iov_iter *iter,
> +		 const struct iomap_ops *ops, void *private,
> +		 unsigned int dio_flags)
> +{
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +	size_t count = iov_iter_count(iter);
> +	bool wait_for_completion = is_sync_kiocb(iocb);
> +	struct iomap_iter iomi = {
> +		.inode		= inode,
> +		.pos		= iocb->ki_pos,
> +		.len		= count,
> +		.flags		= IOMAP_DIRECT,
> +		.private	= private,
> +	};
> +	struct iomap_dio_simple *sr;
> +	unsigned int alignment;
> +	struct bio *bio;
> +	ssize_t ret;
> +
> +	if (iocb->ki_flags & IOCB_NOWAIT)
> +		iomi.flags |= IOMAP_NOWAIT;
> +
> +	ret = kiocb_write_and_wait(iocb, count);
> +	if (ret)
> +		return ret;
> +
> +	inode_dio_begin(inode);
> +
> +	ret = ops->iomap_begin(inode, iomi.pos, count, iomi.flags,
> +			       &iomi.iomap, &iomi.srcmap);
> +	if (ret) {
> +		inode_dio_end(inode);
> +		return ret;
> +	}
> +
> +	if (iomi.iomap.type != IOMAP_MAPPED ||
> +	    iomi.iomap.offset + iomi.iomap.length < iomi.pos + count ||
> +	    (iomi.iomap.flags & IOMAP_F_INTEGRITY)) {
> +		ret = -ENOTBLK;
> +		goto out_iomap_end;
> +	}
> +
> +	alignment = iomap_dio_alignment(inode, iomi.iomap.bdev, dio_flags);
> +	if ((iomi.pos | count) & (alignment - 1)) {
> +		ret = -EINVAL;
> +		goto out_iomap_end;
> +	}
> +
> +	if (!wait_for_completion && unlikely(!inode->i_sb->s_dio_done_wq)) {
> +		ret = sb_init_dio_done_wq(inode->i_sb);
> +		if (ret < 0)
> +			goto out_iomap_end;
> +	}
> +
> +	trace_iomap_dio_rw_begin(iocb, iter, dio_flags, 0);
> +
> +	if (user_backed_iter(iter))
> +		dio_flags |= IOMAP_DIO_USER_BACKED;
> +
> +	bio = bio_alloc_bioset(iomi.iomap.bdev,
> +			       bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS),
> +			       REQ_OP_READ, GFP_KERNEL, &iomap_dio_simple_pool);
> +	sr = container_of(bio, struct iomap_dio_simple, bio);
> +	sr->iocb = iocb;
> +	sr->dio_flags = dio_flags;
> +
> +	bio->bi_iter.bi_sector = iomap_sector(&iomi.iomap, iomi.pos);
> +	bio->bi_ioprio = iocb->ki_ioprio;
> +
> +	ret = bio_iov_iter_get_pages(bio, iter, alignment - 1);
> +	if (unlikely(ret))
> +		goto out_bio_put;
> +
> +	if (bio->bi_iter.bi_size != count) {
> +		iov_iter_revert(iter, bio->bi_iter.bi_size);
> +		ret = -ENOTBLK;
> +		goto out_bio_release_pages;
> +	}
> +
> +	sr->size = bio->bi_iter.bi_size;
> +
> +	if (dio_flags & IOMAP_DIO_USER_BACKED)
> +		bio_set_pages_dirty(bio);
> +
> +	if (iocb->ki_flags & IOCB_NOWAIT)
> +		bio->bi_opf |= REQ_NOWAIT;
> +	if ((iocb->ki_flags & IOCB_HIPRI) && !wait_for_completion) {
> +		bio->bi_opf |= REQ_POLLED;
> +		WRITE_ONCE(iocb->private, bio);
> +	}
> +
> +	if (ops->iomap_end)
> +		ops->iomap_end(inode, iomi.pos, count, count, iomi.flags,
> +			       &iomi.iomap);
> +
> +	if (!wait_for_completion) {
> +		bio->bi_end_io = iomap_dio_simple_end_io;
> +		submit_bio(bio);
> +		trace_iomap_dio_rw_queued(inode, iomi.pos, count);
> +		return -EIOCBQUEUED;
> +	}
> +
> +	submit_bio_wait(bio);
> +	return iomap_dio_simple_complete(sr);
> +
> +out_bio_release_pages:
> +	bio_release_pages(bio, false);
> +out_bio_put:
> +	bio_put(bio);
> +out_iomap_end:
> +	if (ops->iomap_end)
> +		ops->iomap_end(inode, iomi.pos, count, 0, iomi.flags,
> +			       &iomi.iomap);
> +	inode_dio_end(inode);
> +	return ret;
> +}
> +
>  ssize_t
>  iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
>  		unsigned int dio_flags, void *private, size_t done_before)
>  {
>  	struct iomap_dio *dio;
> +	ssize_t ret;
> +
> +	if (iomap_dio_simple_supported(iocb, iter, dops, dio_flags,
> +				       done_before)) {
> +		ret = iomap_dio_simple(iocb, iter, ops, private, dio_flags);
> +		if (ret != -ENOTBLK)
> +			return ret;
> +	}
>  
>  	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags, private,
>  			     done_before);
> @@ -907,3 +1173,11 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	return iomap_dio_complete(dio);
>  }
>  EXPORT_SYMBOL_GPL(iomap_dio_rw);
> +
> +static int __init iomap_dio_init(void)
> +{
> +	return bioset_init(&iomap_dio_simple_pool, 4,
> +			   offsetof(struct iomap_dio_simple, bio),
> +			   BIOSET_NEED_BVECS | BIOSET_PERCPU_CACHE);
> +}
> +fs_initcall(iomap_dio_init);
> -- 
> 2.39.5 (Apple Git-154)
---end quoted text---
