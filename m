Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 061867CAF
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 09:17:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BEFDC304043
	for <xfs@oss.sgi.com>; Thu,  3 Mar 2016 07:17:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wviuH7Q8KNFySAKX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Mar 2016 07:17:32 -0800 (PST)
Date: Thu, 3 Mar 2016 10:17:30 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: optimize bio handling in the buffer writeback
	path
Message-ID: <20160303151730.GC57990@bfoster.bfoster>
References: <1456302011-18915-1-git-send-email-hch@lst.de>
	<1456302011-18915-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1456302011-18915-4-git-send-email-hch@lst.de>
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
Cc: xfs@oss.sgi.com

On Wed, Feb 24, 2016 at 09:20:11AM +0100, Christoph Hellwig wrote:
> This patch implements two closely related changes:  First it embedds a
> bio the ioend structure so that we don't have to allocate one separately.
> Second it uses the block layer bio chaining mechanism to chain additional
> bios off this first one if needed instead of manually accouting for
> multiple bio completions in the ioend structure.  Together this removes a
> memory allocation per ioend and greatly simplifies the ioend setup and
> I/O completion path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c  | 217 ++++++++++++++++++++---------------------------------
>  fs/xfs/xfs_aops.h  |  15 ++--
>  fs/xfs/xfs_super.c |  26 ++-----
>  3 files changed, 93 insertions(+), 165 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index fc4fed6..1ea4167 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -118,17 +118,15 @@ next_bh:
>   */
>  STATIC void
>  xfs_destroy_ioend(
> -	struct xfs_ioend	*ioend)
> +	struct xfs_ioend	*ioend,
> +	int			error)
>  {
> -	struct bio		*bio, *next;
> +	struct bio		*bio, *next, *last = ioend->io_bio;
>  
> -	for (bio = ioend->io_bio_done; bio; bio = next) {
> +	for (bio = &ioend->io_inline_bio; bio; bio = next) {
>  		struct bio_vec	*bvec;
>  		int		i;
>  
> -		next = bio->bi_private;
> -		bio->bi_private = NULL;
> -
>  		/* walk each page on bio, ending page IO on them */
>  		bio_for_each_segment_all(bvec, bio, i) {
>  			struct page	*page = bvec->bv_page;
> @@ -138,17 +136,21 @@ xfs_destroy_ioend(
>  			ASSERT(off < PAGE_SIZE);
>  			ASSERT(end_off <= PAGE_SIZE);
>  
> -			xfs_finish_page_writeback(page, off, end_off,
> -						  ioend->io_error);
> -
> +			xfs_finish_page_writeback(page, off, end_off, error);
>  		}
> +
> +		/*
> +		 * For the last bio, bi_private points to the ioend, so we
> +		 * need to explicitly end the iteration here.
> +		 */

Do you mean the last bio is pointed to by the ioend?

> +		if (bio == last)
> +			next = NULL;
> +		else
> +			next = bio->bi_private;
>  		bio_put(bio);
>  	}
> -
> -	mempool_free(ioend, xfs_ioend_pool);
>  }
>  
> -
>  /*
>   * Fast and loose check if this write could update the on-disk inode size.
>   */
...
> @@ -515,10 +430,10 @@ static inline int xfs_bio_add_buffer(struct bio *bio, struct buffer_head *bh)
>  STATIC int
>  xfs_submit_ioend(
>  	struct writeback_control *wbc,
> -	xfs_ioend_t		*ioend,
> +	struct xfs_ioend	*ioend,
>  	int			status)
>  {
> -	if (!ioend->io_bio || status)
> +	if (status)
>  		goto error_finish;
>  
>  	/* Reserve log space if we might write beyond the on-disk inode size. */
> @@ -529,9 +444,10 @@ xfs_submit_ioend(
>  			goto error_finish;
>  	}
>  
> -	xfs_submit_ioend_bio(wbc, ioend, ioend->io_bio);
> -	ioend->io_bio = NULL;
> -	xfs_finish_ioend(ioend);
> +	ioend->io_bio->bi_private = ioend;
> +	ioend->io_bio->bi_end_io = xfs_end_bio;
> +	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE,
> +			ioend->io_bio);
>  	return 0;
>  
>  	/*
> @@ -541,10 +457,8 @@ xfs_submit_ioend(
>  	 * at this point in time.
>  	 */
>  error_finish:
> -	if (ioend->io_bio)
> -		bio_put(ioend->io_bio);
> -	ioend->io_error = status;
> -	xfs_finish_ioend(ioend);
> +	ioend->io_bio->bi_error = status;
> +	bio_endio(ioend->io_bio);
>  	return status;

bi_end_io is not set here, so what happens to the buffers added to the
ioend in this case?

>  }
>  
> @@ -565,22 +479,51 @@ xfs_add_to_ioend(
>  	struct list_head	*iolist)
>  {
>  	struct xfs_ioend	*ioend = wpc->ioend;
> +	struct bio		*new;
>  
>  	if (!ioend || wpc->io_type != ioend->io_type ||
>  	    bh->b_blocknr != wpc->last_block + 1) {
> +		new = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES,
> +					xfs_ioend_bioset);
> +		new->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
> +		new->bi_bdev = bh->b_bdev;
> +	

Trailing whitespace on the above line. And FWIW, I'm not a huge fan of
open coding both the bio and ioend allocations. It makes it easier to
distinguish the higher level algorithm from all of the structure
initialization noise. It looks to me that alloc_ioend() could remain
mostly as is, using the new bioset allocation, and alloc_ioend_bio()
could be inlined and renamed to something like init_bio_from_bh() or
some such.

>  		if (ioend)
>  			list_add(&ioend->io_list, iolist);
> -		ioend = wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type);
> +
> +		ioend = container_of(new, struct xfs_ioend, io_inline_bio);
> +		INIT_LIST_HEAD(&ioend->io_list);
> +		ioend->io_type = wpc->io_type;
> +		ioend->io_inode = inode;
> +		ioend->io_size = 0;
>  		ioend->io_offset = offset;
> +		INIT_WORK(&ioend->io_work, xfs_end_io);
> +		ioend->io_append_trans = NULL;
> +		ioend->io_bio = new;
> +
> +		wpc->ioend = ioend;
>  	}
>  
>  retry:
> -	if (!ioend->io_bio)
> -		ioend->io_bio = xfs_alloc_ioend_bio(bh);
> -
>  	if (xfs_bio_add_buffer(ioend->io_bio, bh) != bh->b_size) {
> -		xfs_submit_ioend_bio(wbc, ioend, ioend->io_bio);
> -		ioend->io_bio = NULL;
> +		/*
> +		 * No space left in the bio.
> +		 *
> +		 * Allocate a new one, and chain the old bio to the new one.
> +		 * Note that we have to do perform the chaining in this
> +		 * unintuitive order so that the bi_private linkage is set up
> +		 * in the right direction for the traversal in
> +		 * xfs_destroy_ioend().
> +		 */
> +		new = bio_alloc(GFP_NOFS, BIO_MAX_PAGES);
> +		new->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
> +		new->bi_bdev = bh->b_bdev;
> +
> +		bio_chain(ioend->io_bio, new);
> +		bio_get(ioend->io_bio);	/* for xfs_destroy_ioend */
> +		submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE,
> +				ioend->io_bio);
> +		ioend->io_bio = new;

I'm trying to make sure I grok how this works without knowing much about
the block layer. So we chain the current bio to the new one, the latter
becoming the parent, and submit the old one. It looks to me that this
could result in bio_endio() on the parent, which seems fishy... what am
I missing? IOW, is it safe to submit bios like this before the entire
chain is created?

>  		goto retry;
>  	}
>  
...
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 59c9b7b..33aa638 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
...
> @@ -1755,10 +1749,8 @@ xfs_init_zones(void)
>  	kmem_zone_destroy(xfs_bmap_free_item_zone);
>   out_destroy_log_ticket_zone:
>  	kmem_zone_destroy(xfs_log_ticket_zone);
> - out_destroy_ioend_pool:
> -	mempool_destroy(xfs_ioend_pool);
> - out_destroy_ioend_zone:
> -	kmem_zone_destroy(xfs_ioend_zone);
> + out_free_ioend_bioset:
> + 	bioset_free(xfs_ioend_bioset);

Space before tab ^.

>   out:
>  	return -ENOMEM;
>  }
> @@ -1784,9 +1776,7 @@ xfs_destroy_zones(void)
>  	kmem_zone_destroy(xfs_btree_cur_zone);
>  	kmem_zone_destroy(xfs_bmap_free_item_zone);
>  	kmem_zone_destroy(xfs_log_ticket_zone);
> -	mempool_destroy(xfs_ioend_pool);
> -	kmem_zone_destroy(xfs_ioend_zone);
> -
> + 	bioset_free(xfs_ioend_bioset);

Space before tab ^.

Brian

>  }
>  
>  STATIC int __init
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
