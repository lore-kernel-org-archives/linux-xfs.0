Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A6F2D4806;
	Tue, 10 Mar 2026 06:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773125300; cv=none; b=eA0PxdgezTBBixbiBTKY/Z2WQfB96oNjywtJeQ7Yujozb7OHmkQjhYXfHmI8yydFebeWuD13Gf40m+bKv/PkforO8GnylmX04fmE6FaUchwBeTA4LqTRZwFj8JwR823+KpyB7ojgoe1uSGoyUPXbloDHREiZ6j8fFGPu2/KYxcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773125300; c=relaxed/simple;
	bh=8fu+jiPiHAxp+9ifxUjeCOQRq6NLzOHNgLyDIonYBoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BHho4fWc6QzRp9zJLLPIlC2JIe8hLSM57wP7H1ZuQDPv64NIHLHnXNcO0amEUegqBjRKeC1+6mdeJEwUU1d4GFPFxyyBOywGAm9Ihd77keWtseAmaMIQlefA+QVWLNI4s0DM+sDkRZED0Oon6Mc5905ToqBRCpNv3Q3/T0O3BrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hZxab9eK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hZxab9eK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB210C19423;
	Tue, 10 Mar 2026 06:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773125300;
	bh=8fu+jiPiHAxp+9ifxUjeCOQRq6NLzOHNgLyDIonYBoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hZxab9eK/acz24eP/w8qpzElJG80Iye6roUoy3FPoWHBensMQbM19n7vTQE1T8QQ3
	 0aBfBgVrRgaTrNml+Ja9KZiCXkOBNdKCtIGdZtl47Hlu/lmTCmQSobO98Nv1CQkmDy
	 6nDFmL0j4UBpO5Zo08qjYJhXWUTFMkQaue2of9sDf6OSELk/NTAAHG51GHcbAYsDyr
	 HI6OGuma79jrJhJLT7y8nck8uOb9bs9qmiR5rf1oUOA3TDKle9sivS/AYoQWiQjlJI
	 k0dSzd49x4ZpHjfAMnbE05hLVIiKOsnI78ilRjv1VPzfxQ0OJzPbH4slQctjvSXaPW
	 tbEgAdc1oWtWA==
Date: Tue, 10 Mar 2026 17:48:12 +1100
From: Dave Chinner <dgc@kernel.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
	hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
	Luis Chamberlain <mcgrof@kernel.org>, tytso@mit.edu,
	p.raghav@samsung.com, andres@anarazel.de,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] iomap: Support buffered RWF_WRITETHROUGH via async dio
 backend
Message-ID: <aa--rBKQG7ck5nuM@dread>
References: <cover.1773076216.git.ojaswin@linux.ibm.com>
 <c84ddc3f864f840d646b6aa19fd9b3e83e079c0b.1773076216.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c84ddc3f864f840d646b6aa19fd9b3e83e079c0b.1773076216.git.ojaswin@linux.ibm.com>

On Mon, Mar 09, 2026 at 11:04:31PM +0530, Ojaswin Mujoo wrote:
> +/**
> + * iomap_writethrough_iter - perform RWF_WRITETHROUGH buffered write
> + * @iocb: kernel iocb struct
> + * @iter: iomap iter holding mapping information
> + * @i: iov_iter for write
> + * @wt_ops: the fs callbacks needed for writethrough
> + *
> + * This function copies the user buffer to folio similar to usual buffered
> + * IO path, with the difference that we immediately issue the IO. For this we
> + * utilize the async dio machinery. While issuing the async IO, we need to be
> + * careful to clone the iocb so that it doesnt get destroyed underneath us
> + * incase the syscall exits before endio() is triggered.
> + *
> + * Folio handling note: We might be writing through a partial folio so we need
> + * to be careful to not clear the folio dirty bit unless there are no dirty blocks
> + * in the folio after the writethrough.
> + *
> + * TODO: Filesystem freezing during ongoing writethrough writes is currently
> + * buggy. We call file_start_write() once before taking any lock but we can't
> + * just simply call the corresponding file_end_write() in endio because single
> + * RWF_WRITETHROUGH might be split into many IOs leading to multiple endio()
> + * calls. Currently we are looking into the right way to synchronise with
> + * freeze_super().
> + */
> +static int iomap_writethrough_iter(struct kiocb *iocb, struct iomap_iter *iter,
> +				   struct iov_iter *i,
> +				   const struct iomap_writethrough_ops *wt_ops)
> +{
> +	ssize_t total_written = 0;
> +	int status = 0;
> +	struct address_space *mapping = iter->inode->i_mapping;
> +	size_t chunk = mapping_max_folio_size(mapping);
> +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> +
> +	if (!(iter->flags & IOMAP_WRITETHROUGH))
> +		return -EINVAL;
> +
> +	do {
......
> +		status = iomap_write_begin(iter, wt_ops->write_ops, &folio,
> +					   &offset, &bytes);
> +		if (unlikely(status)) {
> +			iomap_write_failed(iter->inode, iter->pos, bytes);
> +			break;
> +		}
> +		if (iter->iomap.flags & IOMAP_F_STALE)
> +			break;
> +
> +		pos = iter->pos;
> +
> +		if (mapping_writably_mapped(mapping))
> +			flush_dcache_folio(folio);
> +
> +		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
> +		written = iomap_write_end(iter, bytes, copied, folio) ?
> +			  copied : 0;
......
> +		/*
> +		 * The copy-to-folio operation succeeded. Lets use the dio
> +		 * machinery to send the writethrough IO.
> +		 */
> +		if (written) {
> +			struct iomap_writethrough_ctx *wt_ctx;
> +			int dio_flags = IOMAP_DIO_BUF_WRITETHROUGH;
> +			struct iov_iter iov_wt;
> +
> +			wt_ctx = kzalloc(sizeof(struct iomap_writethrough_ctx),
> +					GFP_KERNEL | GFP_NOFS);
> +			if (!wt_ctx) {
> +				status = -ENOMEM;
> +				written = 0;
> +				goto put_folio;
> +			}
> +
> +			status = iomap_writethrough_begin(iocb, folio, iter,
> +							  wt_ctx, &iov_wt,
> +							  offset, written);
> +			if (status < 0) {
> +				if (status != -ENOMEM)
> +					noretry = true;
> +				written = 0;
> +				kfree(wt_ctx);
> +				goto put_folio;
> +			}
> +
> +			/* Dont retry for any failures in writethrough */
> +			noretry = true;
> +
> +			status = iomap_dio_rw(&wt_ctx->iocb, &iov_wt,
> +					      wt_ops->ops, wt_ops->dio_ops,
> +					      dio_flags, NULL, 0);
.....

This is not what I envisiaged write-through using DIO to look like.
This is a DIO per folio, rather than a DIO per write() syscall. We
want the latter to be the common case, not the former, especially
when it comes to RWF_ATOMIC support.

i.e. I was expecting something more like having a wt context
allocated up front with an appropriately sized bvec appended to it
(i.e. single allocation for the common case). Then in
iomap_write_end(), we'd mark the folio as under writeback and add it
to the bvec. Then we iterate through the IO range adding folio after
folio to the bvec.

When the bvec is full or we reach the end of the IO, we then push
that bvec down to the DIO code. Ideally we'd also push the iomap we
already hold down as well, so that the DIO code does not need to
look it up again (unless the mapping is stale). The DIO completion
callback then runs a completion callback that iterates the folios
attached ot the bvec and runs buffered writeback compeltion on them.
It can then decrements the wt-ctx IO-in-flight counter.

If there is more user data to submit, we keep going around (with a
new bvec if we need it) adding folios and submitting them to the dio
code until there is no more data to copy in and submit.

The writethrough context then drops it's own "in-flight" reference
and waits for the in-flight counter to go to zero.


> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index c24d94349ca5..f4d8ff08a83a 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -713,7 +713,8 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	dio->i_size = i_size_read(inode);
>  	dio->dops = dops;
>  	dio->error = 0;
> -	dio->flags = dio_flags & (IOMAP_DIO_FSBLOCK_ALIGNED | IOMAP_DIO_BOUNCE);
> +	dio->flags = dio_flags & (IOMAP_DIO_FSBLOCK_ALIGNED | IOMAP_DIO_BOUNCE |
> +				  IOMAP_DIO_BUF_WRITETHROUGH);
>  	dio->done_before = done_before;
>  
>  	dio->submit.iter = iter;
> @@ -747,8 +748,13 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		if (iocb->ki_flags & IOCB_ATOMIC)
>  			iomi.flags |= IOMAP_ATOMIC;
>  
> -		/* for data sync or sync, we need sync completion processing */
> -		if (iocb_is_dsync(iocb)) {
> +		/*
> +		 * for data sync or sync, we need sync completion processing.
> +		 * for buffered writethrough, sync is handled in buffered IO
> +		 * path so not needed here
> +		 */
> +		if (iocb_is_dsync(iocb) &&
> +		    !(dio->flags & IOMAP_DIO_BUF_WRITETHROUGH)) {
>  			dio->flags |= IOMAP_DIO_NEED_SYNC;

Ah, that looks wrong. We want writethrough to be able to use FUA
optimisations for RWF_DSYNC. This prevents the DIO write for wt from
setting IOMAP_DIO_WRITE_THROUGH which is needed to trigger FUA
writes for RWF_DSYNC ops.

i.e. we need DIO to handle the write completions directly to allow
conditional calling of generic_write_sync() based on whether FUA
writes were used or not.

> @@ -765,35 +771,47 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  		}
>  
>  		/*
> -		 * i_size updates must to happen from process context.
> +		 * i_size updates must to happen from process context. For
> +		 * buffered writetthrough, caller might have already changed the
> +		 * i_size but still needs endio i_size handling. We can't detect
> +		 * this here so just use process context unconditionally.
>  		 */
> -		if (iomi.pos + iomi.len > dio->i_size)
> +		if ((iomi.pos + iomi.len > dio->i_size) ||
> +		    dio_flags & IOMAP_DIO_BUF_WRITETHROUGH)
>  			dio->flags |= IOMAP_DIO_COMP_WORK;

This is only true because you called i_size_write() in
iomap_writethrough_iter() before calling down into the DIO code.
We should only update i_size on completion of the write-through IO,
not before we've submitted the IO.

i.e. i_size_write() should only be called by the IO completion that
drops the wt-ctx in-flight counter to zero. i.e. i_size should not
change until the entire IO is complete, it should not be updated
after each folio has the data copied into it.

>  		/*
>  		 * Try to invalidate cache pages for the range we are writing.
>  		 * If this invalidation fails, let the caller fall back to
>  		 * buffered I/O.
> +		 *
> +		 * The execption is if we are using dio path for buffered
> +		 * RWF_WRITETHROUGH in which case we cannot inavlidate the pages
> +		 * as we are writing them through and already hold their
> +		 * folio_lock. For the same reason, disable end of write invalidation
>  		 */
> -		ret = kiocb_invalidate_pages(iocb, iomi.len);
> -		if (ret) {
> -			if (ret != -EAGAIN) {
> -				trace_iomap_dio_invalidate_fail(inode, iomi.pos,
> -								iomi.len);
> -				if (iocb->ki_flags & IOCB_ATOMIC) {
> -					/*
> -					 * folio invalidation failed, maybe
> -					 * this is transient, unlock and see if
> -					 * the caller tries again.
> -					 */
> -					ret = -EAGAIN;
> -				} else {
> -					/* fall back to buffered write */
> -					ret = -ENOTBLK;
> +		if (!(dio_flags & IOMAP_DIO_BUF_WRITETHROUGH)) {
> +			ret = kiocb_invalidate_pages(iocb, iomi.len);
> +			if (ret) {
> +				if (ret != -EAGAIN) {
> +					trace_iomap_dio_invalidate_fail(inode, iomi.pos,
> +									iomi.len);
> +					if (iocb->ki_flags & IOCB_ATOMIC) {
> +						/*
> +						* folio invalidation failed, maybe
> +						* this is transient, unlock and see if
> +						* the caller tries again.
> +						*/
> +						ret = -EAGAIN;
> +					} else {
> +						/* fall back to buffered write */
> +						ret = -ENOTBLK;
> +					}
>  				}
> +				goto out_free_dio;
>  			}
> -			goto out_free_dio;
> -		}
> +		} else
> +			dio->flags |= IOMAP_DIO_NO_INVALIDATE;
>  	}

Waaaay too much indent. It is time to start factoring
__iomap_dio_rw() - it is turning into spaghetti with all these
conditional behaviours.

>  
>  	if (!wait_for_completion && !inode->i_sb->s_dio_done_wq) {
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8b3dd145b25e..ca291957140e 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -346,6 +346,7 @@ struct readahead_control;
>  #define IOCB_ATOMIC		(__force int) RWF_ATOMIC
>  #define IOCB_DONTCACHE		(__force int) RWF_DONTCACHE
>  #define IOCB_NOSIGNAL		(__force int) RWF_NOSIGNAL
> +#define IOCB_WRITETHROUGH	(__force int) RWF_WRITETHROUGH
>  
>  /* non-RWF related bits - start at 16 */
>  #define IOCB_EVENTFD		(1 << 16)
> @@ -1985,6 +1986,8 @@ struct file_operations {
>  #define FOP_ASYNC_LOCK		((__force fop_flags_t)(1 << 6))
>  /* File system supports uncached read/write buffered IO */
>  #define FOP_DONTCACHE		((__force fop_flags_t)(1 << 7))
> +/* File system supports write through buffered IO */
> +#define FOP_WRITETHROUGH	((__force fop_flags_t)(1 << 8))
>  
>  /* Wrap a directory iterator that needs exclusive inode access */
>  int wrap_directory_iterator(struct file *, struct dir_context *,
> @@ -3436,6 +3439,10 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
>  		if (IS_DAX(ki->ki_filp->f_mapping->host))
>  			return -EOPNOTSUPP;
>  	}
> +	if (flags & RWF_WRITETHROUGH)
> +		/* file system must support it */
> +		if (!(ki->ki_filp->f_op->fop_flags & FOP_WRITETHROUGH))
> +			return -EOPNOTSUPP;

Needs {}

>  	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
>  	if (flags & RWF_SYNC)
>  		kiocb_flags |= IOCB_DSYNC;
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index 531f9ebdeeae..b96574bb2918 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -209,6 +209,7 @@ struct iomap_write_ops {
>  #endif /* CONFIG_FS_DAX */
>  #define IOMAP_ATOMIC		(1 << 9) /* torn-write protection */
>  #define IOMAP_DONTCACHE		(1 << 10)
> +#define IOMAP_WRITETHROUGH	(1 << 11)
>  
>  struct iomap_ops {
>  	/*
> @@ -475,6 +476,15 @@ struct iomap_writepage_ctx {
>  	void			*wb_ctx;	/* pending writeback context */
>  };
>  
> +struct iomap_writethrough_ctx {
> +	struct kiocb iocb;
> +	struct folio *folio;
> +	struct inode *inode;
> +	struct bio_vec *bvec;
> +	loff_t orig_pos;
> +	loff_t orig_len;
> +};
> +
>  struct iomap_ioend *iomap_init_ioend(struct inode *inode, struct bio *bio,
>  		loff_t file_offset, u16 ioend_flags);
>  struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
> @@ -590,6 +600,14 @@ struct iomap_dio_ops {
>   */
>  #define IOMAP_DIO_BOUNCE		(1 << 4)
>  
> +/*
> + * Set when we are using the dio path to perform writethrough for
> + * RWF_WRITETHROUGH buffered write. The ->endio handler must check this
> + * to perform any writethrough related cleanup like ending writeback on
> + * a folio.
> + */
> +#define IOMAP_DIO_BUF_WRITETHROUGH	(1 << 5)

I suspect that iomap should provide the dio ->endio handler itself
to run the higher level buffered IO completion handling. i.e. we
have callbacks for custom endio handling, I'm not sure that we need
logic flags for that...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
