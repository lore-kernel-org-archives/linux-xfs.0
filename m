Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20582 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752723AbdHKQUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 12:20:44 -0400
Date: Fri, 11 Aug 2017 09:20:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: open code end_buffer_async_write in
 xfs_finish_page_writeback
Message-ID: <20170811162037.GB24087@magnolia>
References: <20170811095905.11241-1-hch@lst.de>
 <20170811095905.11241-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811095905.11241-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 11, 2017 at 11:59:05AM +0200, Christoph Hellwig wrote:
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
>  fs/xfs/xfs_aops.c | 62 ++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 38 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 6bf120bb1a17..0ddda41ab428 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -84,12 +84,6 @@ xfs_find_bdev_for_inode(
>   * We're now finished for good with this page.  Update the page state via the
>   * associated buffer_heads, paying attention to the start and end offsets that
>   * we need to process on the page.
> - *
> - * Landmine Warning: bh->b_end_io() will call end_page_writeback() on the last
> - * buffer in the IO. Once it does this, it is unsafe to access the bufferhead or
> - * the page at all, as we may be racing with memory reclaim and it can free both
> - * the bufferhead chain and the page as it will see the page as clean and
> - * unused.

If we're going to open-code end_buffer_async_write, could we have a
comment here explaining that we've done so, and why?

>   */
>  static void
>  xfs_finish_page_writeback(
> @@ -97,29 +91,42 @@ xfs_finish_page_writeback(
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

ASSERT(bh->b_end_io == end_buffer_async_write), just in case we ever get
passed a buffer head with an endio function that isn't what we're
open-coding?

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
> +			BUG_ON(!buffer_async_write(bh));
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
> +			BUG_ON(!buffer_locked(bh));
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
> @@ -133,8 +140,10 @@ xfs_destroy_ioend(
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
> @@ -155,6 +164,11 @@ xfs_destroy_ioend(
>  
>  		bio_put(bio);
>  	}
> +
> +	if (unlikely(error && !quiet)) {
> +		xfs_err_ratelimited(XFS_I(inode)->i_mount,
> +			"read error on sector %llu", start);

Read error?  Isn't this writeback?

I also wonder about the wisdom of the text deviating from "lost async
page write", since scripts/admins have been trained to look for that as
evidence of writeback problems for years.

(That said, at least now it's a lot less spammy.)

--D

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
