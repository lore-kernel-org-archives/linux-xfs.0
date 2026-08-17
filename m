Received: from mta1.migadu.com (out-161.mta1.migadu.com [95.215.58.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F9C435AA1
	for <linux-xfs@vger.kernel.org>; Mon, 17 Aug 2026 13:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786972828; cv=none; b=RxS+C76qsEji1vM0x7hJ2rbVVp/lQzrIz4cB/bAIZPARkKBR62EgRaSrBf/PowKaJLl28vc0mFp577nwAAVvV9NG4Uk4SyeY4iXTr0qfHXhPIPQep1hFsQ+IoUQeEOy+r2+Y1OJGIP1PlQB41jGtw9aESH3gYIU2Vu6Xgv/I/84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786972828; c=relaxed/simple;
	bh=YbseSLAsiMFEVOCVOci5cRXZ6Ax+SwzLt1f+lzKOqSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPs0K8a6X+vBpFEDFiOUPqUBJ3JomtyfNfa0NeB6aD1Ewf7Zoy0mGO4Qg6TBXnQIk04N4hElNKrBLoBSsErwv4NHO3aqc7ooFHP8XH6TLEhJ79XuER1QaaGnD4h4ZFpXdRBmYT9xgx4ig7YUkd9jtJRPWxG/mZE1sApks7gAb70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C2vL5DWt; arc=none smtp.client-ip=95.215.58.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C2vL5DWt"
X-Envelope-To: linux-xfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=YbseSLAsiMFEVOCVOci5cRXZ6Ax+SwzLt1f+lzKOqSE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786972824; v=1; x=1787577624;
 b=C2vL5DWtj/LSh6sjcZnnx3gXVBl1MTHyEoQAOl5bAEWkLhVB7m6n02IBgi5BhGBNVYxR8mt7
 IaQa7zDyrly5CeF/wFA4vBDZIificKy86sV4ro0PoVzY/ZMCRQmPRx4rts9Nhbq5T1p4PwNK8OO
 ghExY6+PMt10diHOIUShNJj4=
X-Envelope-To: linux-xfs@vger.kernel.org
Received: from localhost (195.100.225.50)
	by smtp.migadu.com with ESMTPS id ab5acc26bf925477;
	Mon, 17 Aug 2026 13:20:24 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 15:20:12 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <dchinner@redhat.com>, Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v3 04/11] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <aoMCtTAZFN_DlZjw@quentin>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <c108df815e3330e76f2d6adfde791a6e20a498b9.1785908600.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c108df815e3330e76f2d6adfde791a6e20a498b9.1785908600.git.ojaswin@linux.ibm.com>

I have added some minor comments. I haven't checked Sashiko's review, so
ignore them if it is a repeat.

> +
> +	if (!wt_ctx->nr_bvecs)
> +		goto exit;
> +
> +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
> +		len += wt_ctx->bvec[i].bv_len;
> +
> +	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, opf, GFP_NOFS);
> +	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
> +	bio->bi_end_io		= iomap_writethrough_bio_end_io;
> +	bio->bi_private		= wt_ctx;
> +
> +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
> +		__bio_add_page(bio, wt_ctx->bvec[i].bv_page,
> +				wt_ctx->bvec[i].bv_len,
> +				wt_ctx->bvec[i].bv_offset);

bio_add_folio_nofail()?

> +
> +	if (!error && wt_ops->writethrough_submit)
> +		error = wt_ops->writethrough_submit(wt_ctx->inode, iomap,
> +						    wt_ctx->bio_pos, len);
> +
> +
> +	atomic_inc(&wt_ctx->ref);
> +
> +	/*
> +	 * In case of error we still need the I/O completion to run so we can
> +	 * release references and end writeback on the folios.
> +	 */
> +	if (error) {
> +		bio->bi_status = errno_to_blk_status(error);
> +		bio_endio(bio);
> +		return error;
> +	}
> +
> +	submit_bio(bio);
> +	wt_ctx->nr_bvecs = 0;
> +
> +exit:
> +	return 0;
<snip>
> +
> +		if (!wt_ctx->nr_bvecs) {
> +			wt_ctx->bio_pos = round_down(pos, bs);
> +			submit_start_pos = pos;
> +		}
> +
> +		bvec_set_folio(&wt_ctx->bvec[wt_ctx->nr_bvecs], folio,
> +			       len_aligned, off_aligned);
> +		wt_ctx->nr_bvecs++;
> +
> +put_folio:
> +		__iomap_put_folio(iter, wt_ops->write_ops, written, folio);
> +
> +		if (old_size < pos)
> +			pagecache_isize_extended(iter->inode, old_size, pos);

Some new code has been added upstream to include VERITY. Probably the
same thing needs to be done here?

if (pos + written > old_size &&
     !(iter->iomap.flags & IOMAP_F_FSVERITY)) {
         i_size_write(iter->inode, pos + written);
         iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
 }
 __iomap_put_folio(iter, write_ops, written, folio);
 
 if (old_size < pos && !(iter->iomap.flags & IOMAP_F_FSVERITY))
         pagecache_isize_extended(iter->inode, old_size, pos);

> +
> +		cond_resched();
> +		if (unlikely(written == 0)) {
> +			iomap_write_failed(iter->inode, pos, bytes);
> +			iov_iter_revert(i, copied);
> +
> +			if (chunk > PAGE_SIZE)
> +				chunk /= 2;
> +			if (copied) {
> +				bytes = copied;
> +				goto retry;
> +			}
> +		} else {
> +			total_written += written;
> +			pending += written;
> +			iomap_iter_advance(iter, written);
> +		}
> +
> +		/*
> +		 * If we fail to submit the bio, we immediately call the
> +		 * IO completion handler that records the error. We
> +		 * shall not retry anymore cause this could lead to
> +		 * infinite loops in case of non-transient errors.
> +		 */
> +		if (wt_ctx->nr_bvecs == wt_ctx->max_bvecs) {
> +			status = iomap_writethrough_try_submit(wt_ctx,
> +					&iter->iomap, wt_ops, &pending);
> +			if (status)
> +				goto submit_failed;
> +		}
> +
> +	} while (iov_iter_count(i) && iomap_length(iter));
> +
> +	if (wt_ctx->nr_bvecs) {
> +		status = iomap_writethrough_try_submit(wt_ctx,
> +				&iter->iomap, wt_ops, &pending);
> +		if (status)
> +			goto submit_failed;
> +	}
> +
> +	/*
> +	 * In case of an error, we only consider the bytes we were actually able
> +	 * to submit IO for as valid data and revert the iters accordingly
> +	 */
> +	if (status) {
> +		/*
> +		 * we still need to run the endio completion for cleanup work
> +		 * hence call the below helper to take care of it, if we haven't
> +		 * already done so. We can ignore the return value here.
> +		 */
> +		iomap_writethrough_submit_bio(wt_ctx, &iter->iomap, wt_ops, status);

Do we even need to call iomap_writethrough_submit_bio() here? 

In all the failure scenario we reach submit_failed directly right? In
the cases where we fail before copy_folio_from_iter_atomic(), we will
not have anything to do anyway, therefore, making the above call a no
op? Am I missing something?

> +
> +submit_failed:
> +		iomap_write_failed(iter->inode, submit_start_pos, pending);
> +		iomap_iter_revert(iter, pending);
> +		iov_iter_revert(i, pending);
> +	}
> +
> +	return status;
> +}
> +
>  static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
>  		const struct iomap_write_ops *write_ops)
>  {
> @@ -1345,6 +1700,88 @@ int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
>  }
>  EXPORT_SYMBOL_GPL(iomap_fsverity_write);
>  
> +ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
> +				      const struct iomap_writethrough_ops *wt_ops,
> +				      void *private)
> +{
> +	struct inode *inode = iocb->ki_filp->f_mapping->host;
> +	struct iomap_iter iter = {
> +		.inode		= inode,
> +		.pos		= iocb->ki_pos,
> +		.len		= iov_iter_count(i),
> +		.flags		= IOMAP_WRITE | IOMAP_WRITETHROUGH,
> +		.private	= private,
> +	};
> +	struct iomap_writethrough_ctx *wt_ctx;
> +	unsigned int max_bvecs;
> +	ssize_t ret;
> +	struct blk_plug plug;
> +	size_t min_folio_bytes = PAGE_SIZE
> +				 << mapping_min_folio_order(inode->i_mapping);

mapping_min_folio_nrbytes can be used here.

> +
> +	/*
> +	 * For now we don't support any other flag with WRITETHROUGH
> +	 */
>  		__folio_cancel_dirty(folio);
>  }
>  bool folio_clear_dirty_for_io(struct folio *folio);
> +bool folio_clear_dirty_for_writethrough(struct folio *folio);
>  bool clear_page_dirty_for_io(struct page *page);
>  void folio_invalidate(struct folio *folio, size_t offset, size_t length);
>  bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index bd87262f2e34..9c8d91b926a7 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -451,10 +451,13 @@ typedef int __bitwise __kernel_rwf_t;
>  /* prevent pipe and socket writes from raising SIGPIPE */
>  #define RWF_NOSIGNAL	((__force __kernel_rwf_t)0x00000100)
>  
> +/* buffered IO that is asynchronously written through to disk after write */

Isn't it synchronously written?

> +#define RWF_WRITETHROUGH	((__force __kernel_rwf_t)0x00000200)
> +
>  /* mask of flags supported by the kernel */
>  #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
>  			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC |\
> -			 RWF_DONTCACHE | RWF_NOSIGNAL)
> +			 RWF_DONTCACHE | RWF_NOSIGNAL | RWF_WRITETHROUGH)
>  

--
Pankaj
