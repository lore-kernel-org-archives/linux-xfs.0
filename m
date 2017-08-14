Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751082AbdHNNvG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Aug 2017 09:51:06 -0400
Date: Mon, 14 Aug 2017 09:51:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2] xfs: open code end_buffer_async_write in
 xfs_finish_page_writeback
Message-ID: <20170814135104.GD39742@bfoster.bfoster>
References: <20170813144040.11093-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170813144040.11093-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Aug 13, 2017 at 04:40:40PM +0200, Christoph Hellwig wrote:
> Our loop in xfs_finish_page_writeback, which iterates over all buffer
> heads in a page and then calls end_buffer_async_write, which also
> iterates over all buffers in the page to check if any I/O is in flight
> is not only inefficient, but also potentially dangerous as
> end_buffer_async_write can cause the page and all buffers to be freed.
> 
> Replace it with a single loop that does the work of end_buffer_async_write
> on a per-page basis.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 68 ++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 45 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 6bf120bb1a17..845f77bf96a1 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -85,11 +85,11 @@ xfs_find_bdev_for_inode(
>   * associated buffer_heads, paying attention to the start and end offsets that
>   * we need to process on the page.
>   *
> - * Landmine Warning: bh->b_end_io() will call end_page_writeback() on the last
> - * buffer in the IO. Once it does this, it is unsafe to access the bufferhead or
> - * the page at all, as we may be racing with memory reclaim and it can free both
> - * the bufferhead chain and the page as it will see the page as clean and
> - * unused.
> + * Note that we open code the action in end_buffer_async_write here so that we
> + * only have to iterate over the buffers attached to the page once.  This is not
> + * only more efficient, but also ensures that we only calls end_page_writeback
> + * at the end of the iteration, and thus avoids the pitfall of having the page
> + * and buffers potentially freed after every call to end_buffer_async_write.
>   */

This all seems fine to me, but afaict the only reason to set b_end_io is
either to use submit_bh(), which we don't do in XFS, or if we call
->b_end_io directly ourselves.

Since this patch kills off the latter, I don't see why we'd ever want to
set b_end_io = end_buffer_async_write. So why not replace the
mark_buffer_async_write() call in xfs_start_buffer_writeback() with
set_buffer_async_write() and lose the unnecessary assertions and
documentation around open-coding the former? (I suppose a brief
reference in the comment as to how this models/implements
end_buffer_async_write() couldn't hurt, though.).

Brian

>  static void
>  xfs_finish_page_writeback(
> @@ -97,29 +97,44 @@ xfs_finish_page_writeback(
>  	struct bio_vec		*bvec,
>  	int			error)
>  {
> -	unsigned int		end = bvec->bv_offset + bvec->bv_len - 1;
> -	struct buffer_head	*head, *bh, *next;
> +	struct buffer_head	*head = page_buffers(bvec->bv_page), *bh = head;
> +	bool			busy = false;
>  	unsigned int		off = 0;
> -	unsigned int		bsize;
> +	unsigned long		flags;
>  
>  	ASSERT(bvec->bv_offset < PAGE_SIZE);
>  	ASSERT((bvec->bv_offset & (i_blocksize(inode) - 1)) == 0);
> -	ASSERT(end < PAGE_SIZE);
> +	ASSERT(bvec->bv_offset + bvec->bv_len <= PAGE_SIZE);
>  	ASSERT((bvec->bv_len & (i_blocksize(inode) - 1)) == 0);
>  
> -	bh = head = page_buffers(bvec->bv_page);
> -
> -	bsize = bh->b_size;
> +	local_irq_save(flags);
> +	bit_spin_lock(BH_Uptodate_Lock, &head->b_state);
>  	do {
> -		if (off > end)
> -			break;
> -		next = bh->b_this_page;
> -		if (off < bvec->bv_offset)
> -			goto next_bh;
> -		bh->b_end_io(bh, !error);
> -next_bh:
> -		off += bsize;
> -	} while ((bh = next) != head);
> +		if (off >= bvec->bv_offset &&
> +		    off < bvec->bv_offset + bvec->bv_len) {
> +			ASSERT(buffer_async_write(bh));
> +			ASSERT(bh->b_end_io == end_buffer_async_write);
> +
> +			if (error) {
> +				mark_buffer_write_io_error(bh);
> +				clear_buffer_uptodate(bh);
> +				SetPageError(bvec->bv_page);
> +			} else {
> +				set_buffer_uptodate(bh);
> +			}
> +			clear_buffer_async_write(bh);
> +			unlock_buffer(bh);
> +		} else if (buffer_async_write(bh)) {
> +			ASSERT(buffer_locked(bh));
> +			busy = true;
> +		}
> +		off += bh->b_size;
> +	} while ((bh = bh->b_this_page) != head);
> +	bit_spin_unlock(BH_Uptodate_Lock, &head->b_state);
> +	local_irq_restore(flags);
> +
> +	if (!busy)
> +		end_page_writeback(bvec->bv_page);
>  }
>  
>  /*
> @@ -133,8 +148,10 @@ xfs_destroy_ioend(
>  	int			error)
>  {
>  	struct inode		*inode = ioend->io_inode;
> -	struct bio		*last = ioend->io_bio;
> -	struct bio		*bio, *next;
> +	struct bio		*bio = &ioend->io_inline_bio;
> +	struct bio		*last = ioend->io_bio, *next;
> +	u64			start = bio->bi_iter.bi_sector;
> +	bool			quiet = bio_flagged(bio, BIO_QUIET);
>  
>  	for (bio = &ioend->io_inline_bio; bio; bio = next) {
>  		struct bio_vec	*bvec;
> @@ -155,6 +172,11 @@ xfs_destroy_ioend(
>  
>  		bio_put(bio);
>  	}
> +
> +	if (unlikely(error && !quiet)) {
> +		xfs_err_ratelimited(XFS_I(inode)->i_mount,
> +			"writeback error on sector %llu", start);
> +	}
>  }
>  
>  /*
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
