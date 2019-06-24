Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:34132 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726909AbfFXQTb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 12:19:31 -0400
Date: Mon, 24 Jun 2019 09:17:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: simplify xfs_chain_bio
Message-ID: <20190624161750.GR5387@magnolia>
References: <20190624134315.21307-1-hch@lst.de>
 <20190624134315.21307-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624134315.21307-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Mon, Jun 24, 2019 at 03:43:14PM +0200, Christoph Hellwig wrote:
> Move setting up operation and write hint to xfs_alloc_ioend, and
> then just copy over all needed information from the previous bio
> in xfs_chain_bio and stop passing various parameters to it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Uh, is this the same patch with the same name in the previous series?

--D

> ---
>  fs/xfs/xfs_aops.c | 35 +++++++++++++++++------------------
>  1 file changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index a6f0f4761a37..9cceb90e77c5 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -665,7 +665,6 @@ xfs_submit_ioend(
>  
>  	ioend->io_bio->bi_private = ioend;
>  	ioend->io_bio->bi_end_io = xfs_end_bio;
> -	ioend->io_bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
>  
>  	/*
>  	 * If we are failing the IO now, just mark the ioend with an
> @@ -679,7 +678,6 @@ xfs_submit_ioend(
>  		return status;
>  	}
>  
> -	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
>  	submit_bio(ioend->io_bio);
>  	return 0;
>  }
> @@ -691,7 +689,8 @@ xfs_alloc_ioend(
>  	xfs_exntst_t		state,
>  	xfs_off_t		offset,
>  	struct block_device	*bdev,
> -	sector_t		sector)
> +	sector_t		sector,
> +	struct writeback_control *wbc)
>  {
>  	struct xfs_ioend	*ioend;
>  	struct bio		*bio;
> @@ -699,6 +698,8 @@ xfs_alloc_ioend(
>  	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, &xfs_ioend_bioset);
>  	bio_set_dev(bio, bdev);
>  	bio->bi_iter.bi_sector = sector;
> +	bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
> +	bio->bi_write_hint = inode->i_write_hint;
>  
>  	ioend = container_of(bio, struct xfs_ioend, io_inline_bio);
>  	INIT_LIST_HEAD(&ioend->io_list);
> @@ -719,24 +720,22 @@ xfs_alloc_ioend(
>   * so that the bi_private linkage is set up in the right direction for the
>   * traversal in xfs_destroy_ioend().
>   */
> -static void
> +static struct bio *
>  xfs_chain_bio(
> -	struct xfs_ioend	*ioend,
> -	struct writeback_control *wbc,
> -	struct block_device	*bdev,
> -	sector_t		sector)
> +	struct bio		*prev)
>  {
>  	struct bio *new;
>  
>  	new = bio_alloc(GFP_NOFS, BIO_MAX_PAGES);
> -	bio_set_dev(new, bdev);
> -	new->bi_iter.bi_sector = sector;
> -	bio_chain(ioend->io_bio, new);
> -	bio_get(ioend->io_bio);		/* for xfs_destroy_ioend */
> -	ioend->io_bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
> -	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
> -	submit_bio(ioend->io_bio);
> -	ioend->io_bio = new;
> +	bio_copy_dev(new, prev);
> +	new->bi_iter.bi_sector = bio_end_sector(prev);
> +	new->bi_opf = prev->bi_opf;
> +	new->bi_write_hint = prev->bi_write_hint;
> +
> +	bio_chain(prev, new);
> +	bio_get(prev);		/* for xfs_destroy_ioend */
> +	submit_bio(prev);
> +	return new;
>  }
>  
>  /*
> @@ -771,14 +770,14 @@ xfs_add_to_ioend(
>  		if (wpc->ioend)
>  			list_add(&wpc->ioend->io_list, iolist);
>  		wpc->ioend = xfs_alloc_ioend(inode, wpc->fork,
> -				wpc->imap.br_state, offset, bdev, sector);
> +				wpc->imap.br_state, offset, bdev, sector, wbc);
>  	}
>  
>  	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff, true)) {
>  		if (iop)
>  			atomic_inc(&iop->write_count);
>  		if (bio_full(wpc->ioend->io_bio))
> -			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
> +			wpc->ioend->io_bio = xfs_chain_bio(wpc->ioend->io_bio);
>  		bio_add_page(wpc->ioend->io_bio, page, len, poff);
>  	}
>  
> -- 
> 2.20.1
> 
