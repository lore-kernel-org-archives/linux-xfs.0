Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50220 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeE3Fwt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 May 2018 01:52:49 -0400
Date: Tue, 29 May 2018 22:52:42 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/34] iomap: add a iomap_sector helper
Message-ID: <20180530055242.GB30110@magnolia>
References: <20180523144357.18985-1-hch@lst.de>
 <20180523144357.18985-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180523144357.18985-14-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org

On Wed, May 23, 2018 at 04:43:36PM +0200, Christoph Hellwig wrote:
> Factor the repeated calculation of the on-disk sector for a given logical
> block into a littler helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 8e28f25f086f..f928df4ab9a9 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -97,6 +97,12 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
>  	return written ? written : ret;
>  }
>  
> +static sector_t
> +iomap_sector(struct iomap *iomap, loff_t pos)
> +{
> +	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
> +}
> +
>  static void
>  iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
>  {
> @@ -354,11 +360,8 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
>  static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
>  		struct iomap *iomap)
>  {
> -	sector_t sector = (iomap->addr +
> -			   (pos & PAGE_MASK) - iomap->offset) >> 9;
> -
> -	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev, sector,
> -			offset, bytes);
> +	return __dax_zero_page_range(iomap->bdev, iomap->dax_dev,
> +			iomap_sector(iomap, pos & PAGE_MASK), offset, bytes);
>  }
>  
>  static loff_t
> @@ -943,8 +946,7 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
>  
>  	bio = bio_alloc(GFP_KERNEL, 1);
>  	bio_set_dev(bio, iomap->bdev);
> -	bio->bi_iter.bi_sector =
> -		(iomap->addr + pos - iomap->offset) >> 9;
> +	bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
>  	bio->bi_private = dio;
>  	bio->bi_end_io = iomap_dio_bio_end_io;
>  
> @@ -1038,8 +1040,7 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
>  
>  		bio = bio_alloc(GFP_KERNEL, nr_pages);
>  		bio_set_dev(bio, iomap->bdev);
> -		bio->bi_iter.bi_sector =
> -			(iomap->addr + pos - iomap->offset) >> 9;
> +		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
>  		bio->bi_write_hint = dio->iocb->ki_hint;
>  		bio->bi_private = dio;
>  		bio->bi_end_io = iomap_dio_bio_end_io;
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
