Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8BD337CA1
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 09:17:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 431668F8039
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 07:17:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KnsPWDCxLe48o0wa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2016 07:17:24 -0800 (PST)
Date: Thu, 3 Mar 2016 10:17:22 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: don't release bios on completion immediately
Message-ID: <20160303151722.GB57990@bfoster.bfoster>
References: <1456302011-18915-1-git-send-email-hch@lst.de>
	<1456302011-18915-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1456302011-18915-3-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Wed, Feb 24, 2016 at 09:20:10AM +0100, Christoph Hellwig wrote:
> Completion of an ioend requires us to walk the bufferhead list to
> end writback on all the bufferheads. This, in turn, is needed so
> that we can end writeback on all the pages we just did IO on.
> 
> To remove our dependency on bufferheads in writeback, we need to
> turn this around the other way - we need to walk the pages we've
> just completed IO on, and then walk the buffers attached to the
> pages and complete their IO. In doing this, we remove the
> requirement for the ioend to track bufferheads directly.
> 
> To enable IO completion to walk all the pages we've submitted IO on,
> we need to keep the bios that we used for IO around until the ioend
> has been completed. We can do this simply by chaining the bios to
> the ioend at completion time, and then walking their pages directly
> just before destroying the ioend.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_aops.c | 90 +++++++++++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_aops.h |  5 ++--
>  2 files changed, 71 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 90e6e3a..fc4fed6 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -84,25 +84,71 @@ xfs_find_bdev_for_inode(
>  }
>  
>  /*
> - * We're now finished for good with this ioend structure.
> - * Update the page state via the associated buffer_heads,
> - * release holds on the inode and bio, and finally free
> - * up memory.  Do not use the ioend after this.
> + * We're now finished for good with this page.  Update the page state via the
> + * associated buffer_heads, paying attention to the start and end offsets that
> + * we need to process on the page.
> + */
> +static void
> +xfs_finish_page_writeback(
> +	struct page	*page,
> +	unsigned int	start,
> +	unsigned int	end,
> +	int		error)
> +{
> +	struct buffer_head	*head, *bh;
> +	unsigned int		off = 0;
> +
> +	bh = head = page_buffers(page);
> +
> +	do {
> +		if (start > off)
> +			goto next_bh;

Probably not an issue for current usage, which appears to be on buffer
size granularity, but shouldn't this check whether start is beyond the
end of the current buffer (e.g., start >= off + bh->b_size)?

> +		if (off > end)
> +			break;
> +		bh->b_end_io(bh, !error);
> +next_bh:
> +		off += bh->b_size;
> +	} while ((bh = bh->b_this_page) != head);
> +}
> +
> +/*
> + * We're now finished for good with this ioend structure.  Update the page
> + * state, release holds on bios, and finally free up memory.  Do not use the
> + * ioend after this.
>   */
>  STATIC void
>  xfs_destroy_ioend(
> -	xfs_ioend_t		*ioend)
> +	struct xfs_ioend	*ioend)
>  {
> -	struct buffer_head	*bh, *next;
> +	struct bio		*bio, *next;
> +
> +	for (bio = ioend->io_bio_done; bio; bio = next) {
> +		struct bio_vec	*bvec;
> +		int		i;
>  
> -	for (bh = ioend->io_buffer_head; bh; bh = next) {
> -		next = bh->b_private;
> -		bh->b_end_io(bh, !ioend->io_error);
> +		next = bio->bi_private;
> +		bio->bi_private = NULL;
> +
> +		/* walk each page on bio, ending page IO on them */
> +		bio_for_each_segment_all(bvec, bio, i) {
> +			struct page	*page = bvec->bv_page;
> +			unsigned int	off = bvec->bv_offset;
> +			unsigned int	end_off = off + bvec->bv_len - 1;
> +
> +			ASSERT(off < PAGE_SIZE);
> +			ASSERT(end_off <= PAGE_SIZE);
> +
> +			xfs_finish_page_writeback(page, off, end_off,
> +						  ioend->io_error);
> +
> +		}
> +		bio_put(bio);
>  	}
>  
>  	mempool_free(ioend, xfs_ioend_pool);
>  }
>  
> +

Unnecessary whitespace here.

Brian

>  /*
>   * Fast and loose check if this write could update the on-disk inode size.
>   */
> @@ -286,6 +332,7 @@ xfs_alloc_ioend(
>  	ioend->io_type = type;
>  	ioend->io_inode = inode;
>  	INIT_WORK(&ioend->io_work, xfs_end_io);
> +	spin_lock_init(&ioend->io_lock);
>  	return ioend;
>  }
>  
> @@ -365,15 +412,21 @@ STATIC void
>  xfs_end_bio(
>  	struct bio		*bio)
>  {
> -	xfs_ioend_t		*ioend = bio->bi_private;
> +	struct xfs_ioend	*ioend = bio->bi_private;
> +	unsigned long		flags;
>  
> -	if (!ioend->io_error)
> -		ioend->io_error = bio->bi_error;
> -
> -	/* Toss bio and pass work off to an xfsdatad thread */
>  	bio->bi_private = NULL;
>  	bio->bi_end_io = NULL;
> -	bio_put(bio);
> +
> +	spin_lock_irqsave(&ioend->io_lock, flags);
> +	if (!ioend->io_error)
> +	       ioend->io_error = bio->bi_error;
> +	if (!ioend->io_bio_done)
> +		ioend->io_bio_done = bio;
> +	else
> +		ioend->io_bio_done_tail->bi_private = bio;
> +	ioend->io_bio_done_tail = bio;
> +	spin_unlock_irqrestore(&ioend->io_lock, flags);
>  
>  	xfs_finish_ioend(ioend);
>  }
> @@ -517,16 +570,9 @@ xfs_add_to_ioend(
>  	    bh->b_blocknr != wpc->last_block + 1) {
>  		if (ioend)
>  			list_add(&ioend->io_list, iolist);
> -
>  		ioend = wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type);
>  		ioend->io_offset = offset;
> -		ioend->io_buffer_head = bh;
> -		ioend->io_buffer_tail = bh;
> -	} else {
> -		ioend->io_buffer_tail->b_private = bh;
> -		ioend->io_buffer_tail = bh;
>  	}
> -	bh->b_private = NULL;
>  
>  retry:
>  	if (!ioend->io_bio)
> diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
> index c89c3bd..1c7b041 100644
> --- a/fs/xfs/xfs_aops.h
> +++ b/fs/xfs/xfs_aops.h
> @@ -46,13 +46,14 @@ typedef struct xfs_ioend {
>  	int			io_error;	/* I/O error code */
>  	atomic_t		io_remaining;	/* hold count */
>  	struct inode		*io_inode;	/* file being written to */
> -	struct buffer_head	*io_buffer_head;/* buffer linked list head */
> -	struct buffer_head	*io_buffer_tail;/* buffer linked list tail */
>  	size_t			io_size;	/* size of the extent */
>  	xfs_off_t		io_offset;	/* offset in the file */
>  	struct work_struct	io_work;	/* xfsdatad work queue */
>  	struct xfs_trans	*io_append_trans;/* xact. for size update */
>  	struct bio		*io_bio;	/* bio being built */
> +	struct bio		*io_bio_done;	/* bios completed */
> +	struct bio		*io_bio_done_tail; /* bios completed */
> +	spinlock_t		io_lock;	/* for bio completion list */
>  } xfs_ioend_t;
>  
>  extern const struct address_space_operations xfs_address_space_operations;
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
