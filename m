Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43038 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752848AbeEGX4r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 May 2018 19:56:47 -0400
Date: Mon, 7 May 2018 16:56:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] block: break discard submissions into the user
 defined size
Message-ID: <20180507235624.GW11261@magnolia>
References: <1525709615-14395-1-git-send-email-axboe@kernel.dk>
 <1525709615-14395-2-git-send-email-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1525709615-14395-2-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, dchinner@redhat.com, hch@lst.de

On Mon, May 07, 2018 at 10:13:32AM -0600, Jens Axboe wrote:
> Don't build discards bigger than what the user asked for, if the
> user decided to limit the size by writing to 'discard_max_bytes'.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Seems fine to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  block/blk-lib.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index a676084d4740..7417d617091b 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -62,10 +62,11 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  		unsigned int req_sects;
>  		sector_t end_sect, tmp;
>  
> -		/* Make sure bi_size doesn't overflow */
> -		req_sects = min_t(sector_t, nr_sects, UINT_MAX >> 9);
> +		/* Issue in chunks of the user defined max discard setting */
> +		req_sects = min_t(sector_t, nr_sects,
> +					q->limits.max_discard_sectors);
>  
> -		/**
> +		/*
>  		 * If splitting a request, and the next starting sector would be
>  		 * misaligned, stop the discard at the previous aligned sector.
>  		 */
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
