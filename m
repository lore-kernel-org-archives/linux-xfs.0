Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF43D296BD2;
	Wed, 15 Apr 2026 07:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776237297; cv=none; b=JIS1/xv2NkNtikJ6LT3u/+VseyAFTJAmdUMufcnDbVBBtid9r3EZ8/SynN7UnO7DmeJvWgAhYfqiE2XkAoXyBAn9I4si0KqS4WYKUpdjUiVxjHszbsRBuw2hprsD26t5ik9Vp73Ep1WYlC+7dFQBs1pVLFDwsyM3l7qHMInVRNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776237297; c=relaxed/simple;
	bh=LrHJhqCLpkudC12chwMsz3E0lmsl8hdf/QsiL+fDzJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQnx0tQdiLapnI1fpbTMilLjamRGTqL4NoiNxhOkr3ZXtXAXKOKJAoqXRSLb3v/9OhMiiEVXOPHyllpzJkX1zhKQ2+oVLB7YgkOeOaxmJM9tgewCj2L4Hav4kHkEY0XkQQg3JmmtIe8AEPLwEB+4Ur8TdC3XuTIYyOcwhxiTVSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RfC74fl5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RfC74fl5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nMX+sZj8drE/99C18prapzNEOvBD+6iIMi/RWCeMSzY=; b=RfC74fl5cE1YtHLCdbtF0Wnfsz
	fFCoaBRL66VmeO+0dWxl0u2479pS7f7GtH5S/ZNNcFaxN41dT9NvGAPh3zt3jq36tFs5btx55e7h1
	s2vFe9qmksPUsGmUstZ6JcdJibdcW8AmlPux09p2MDmJLF1btsjOqbfn4HrxJnavgo/RfUjzdgeyR
	gt4p+Al8qJg3mx8D4SNdOnQvjze8YwhblMCIkXHbO2H7R18Uyl8TnkGbKx7u1CwmL+uSWI6EO1c6X
	1f7oYAqxYrtumhzzp84zdK6DnZaa3fmCWEkaFzef5ka3u8xF04irjRyvYUfx4JRVkwnfB4RAcIFj2
	U6bJAWfg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCuSa-00000000hgG-1gw1;
	Wed, 15 Apr 2026 07:14:52 +0000
Date: Wed, 15 Apr 2026 00:14:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Fengnan Chang <fengnanchang@gmail.com>
Cc: brauner@kernel.org, djwong@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	lidiangang@bytedance.com,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: Re: [RFC PATCH] iomap: add fast read path for small direct I/O
Message-ID: <ad867C8dlaQGLS97@infradead.org>
References: <20260414122647.15686-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414122647.15686-1-changfengnan@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 14, 2026 at 08:26:47PM +0800, Fengnan Chang wrote:
> 1. Allocating the `bio` and `struct iomap_dio` together to avoid a
>    separate kmalloc. However, because `struct iomap_dio` is relatively
>    large and the main path is complex, this yielded almost no
>    performance improvement.

One interesting bit here would be a slab for struct iomap_dio, and
the previously discussed per-cpu allocation of some form.

> 2. Reducing unnecessary state resets in the iomap state machine (e.g.,
>    skipping `iomap_iter_reset_iomap` where safe). This provided a ~5%
>    IOPS boost, which is helpful but still falls far short of closing
>    the gap with the raw block device.

But it already is a major improvement, and one that would apply outside
of narrow special cases.  So I'd really like to see that patch.

> The fast path is triggered when the request satisfies:
> - Asynchronous READ request only for now.

I think you really should handle synchronous reads as well.

> - I/O size is <= inode blocksize (fits in a single block, no splits).

Makes sense, and I suspect this is the main source of speedups.

> - Aligned to the block device's logical block size.

All direct I/O requires this.

> - No bounce buffering, fscrypt, or fsverity involved.
> - No custom `iomap_dio_ops` (dops) registered by the filesystem.

I'm really curious at what difference this makes.  It removes a few
branches, but should not have much of an effect while limiting the
applicability a lot.

> After this optimization, the heavy generic functions disappear from the
> profile, replaced by a single streamlined execution path:
>   4.83%  [kernel]  [k] iomap_dio_fast_read_async.isra.31
> 
> With this patch, 4K random read IOPS on ext4 increases from 1.9M to
> 2.3M.

That is still a lot slower than the block device path.  A big part of
it should be the extent lookup and locking associated with it, but
I'd expect things to be a bit better.  Do you have XFS version as well?

> However, I am submitting this patch to validate whether this
> optimization direction is correct and worth pursuing. I would appreciate
> feedback on how to better integrate these ideas into the main iomap
> execution path.

I think a <= block size fast path makes a lot of sense, just like we
have a simple version on the block device, but it needs more work.

> +struct iomap_dio_fast_read {
> +	struct kiocb	*iocb;
> +	size_t		size;
> +	bool		should_dirty;
> +	struct work_struct	work;
> +	struct bio	bio ____cacheline_aligned_in_smp;

Does the cache line alignment matter here?  If yes, can you explain why
in a comment?

> +static struct bio_set iomap_dio_fast_read_pool;

In general I'd prefer to stick to simple as in the block device version
instead of fast.

> +static void iomap_dio_fast_read_complete_work(struct work_struct *work)
> +{
> +	struct iomap_dio_fast_read *fr =
> +		container_of(work, struct iomap_dio_fast_read, work);
> +	struct kiocb *iocb = fr->iocb;
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +	bool should_dirty = fr->should_dirty;
> +	struct bio *bio = &fr->bio;
> +	ssize_t ret;
> +
> +	WRITE_ONCE(iocb->private, NULL);
> +
> +	if (likely(!bio->bi_status)) {
> +		ret = fr->size;
> +		iocb->ki_pos += ret;
> +	} else {
> +		ret = blk_status_to_errno(bio->bi_status);
> +		fserror_report_io(inode, FSERR_DIRECTIO_READ, iocb->ki_pos,
> +				  fr->size, ret, GFP_NOFS);
> +	}
> +
> +	if (should_dirty) {
> +		bio_check_pages_dirty(bio);
> +	} else {
> +		bio_release_pages(bio, false);
> +		bio_put(bio);
> +	}
> +
> +	inode_dio_end(inode);
> +
> +	trace_iomap_dio_complete(iocb, ret < 0 ? ret : 0, ret > 0 ? ret : 0);
> +	iocb->ki_complete(iocb, ret);

This is a lot of duplicate cork.  Can we somehow share it by passing
more arguments or embedding the simple context into the bigger one?

> +static inline bool iomap_dio_fast_read_supported(struct kiocb *iocb,
> +					  struct iov_iter *iter,
> +					  unsigned int dio_flags,
> +					  size_t done_before)

Please stick to two-tab indents for prototype continuations, which is
both more readable and easier to modify later.

> +	if (count < bdev_logical_block_size(inode->i_sb->s_bdev))
> +		return false;

Sub-sector reads (unlike writes) don't require any special handling, so
I don't see why they are excluded.

> +	if (dio_flags & IOMAP_DIO_FSBLOCK_ALIGNED)
> +		alignment = i_blocksize(inode);
> +	else
> +		alignment = bdev_logical_block_size(inode->i_sb->s_bdev);
> +
> +	if ((iocb->ki_pos | count) & (alignment - 1))
> +		return false;

Factor this into a helper?

> +	inode_dio_begin(inode);
> +
> +	ret = ops->iomap_begin(inode, iomi.pos, count, iomi.flags,
> +			       &iomi.iomap, &iomi.srcmap);
> +	if (ret) {
> +		inode_dio_end(inode);
> +		return ret;
> +	}

If we can I'd much prefer avoiding the open coded iomap_begin
invocation, as that is a real maintenance burden.

> +
> +	if (iomi.iomap.type != IOMAP_MAPPED ||
> +	    iomi.iomap.offset > iomi.pos ||
> +	    iomi.iomap.offset + iomi.iomap.length < iomi.pos + count ||
> +	    (iomi.iomap.flags & IOMAP_F_ANON_WRITE)) {

IOMAP_F_ANON_WRITE (as the name implies) only applies to writes.

> +		ret = -EAGAIN;

-EAGAIN is a bad status code, as we already use to indicate that a
non-blocking read blocks.

> +	ret = bio_iov_iter_get_pages(bio, iter,
> +				     bdev_logical_block_size(iomi.iomap.bdev) - 1);

Overly long line.  Also this needs to use the calculated alignment
value.

> +	if (unlikely(ret)) {
> +		bio_put(bio);
> +		goto out_iomap_end;
> +	}
> +
> +	if (bio->bi_iter.bi_size != count) {
> +		iov_iter_revert(iter, bio->bi_iter.bi_size);
> +		bio_release_pages(bio, false);
> +		bio_put(bio);
> +		ret = -EAGAIN;
> +		goto out_iomap_end;
> +	}

Share the bio_put with a new goto label, and maybe also move all
the other cleanup code out of the main path into a label?

> +	if (!dops && iomap_dio_fast_read_supported(iocb, iter, dio_flags, done_before)) {

Overly long line.  But we should not make the fast path conditional
on an option anyway.

