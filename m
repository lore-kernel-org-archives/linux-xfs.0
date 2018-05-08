Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:34659 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755489AbeEHUnV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 16:43:21 -0400
Received: by mail-pl0-f65.google.com with SMTP id ay10-v6so2906165plb.1
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 13:43:20 -0700 (PDT)
Date: Tue, 8 May 2018 13:43:18 -0700
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH 1/4] block: break discard submissions into the user
 defined size
Message-ID: <20180508204318.GB27324@vader>
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

Some drivers, including nvme, do

   blk_queue_max_discard_sectors(q, UINT_MAX)

That means q->limits.max_discard_sectors can be UINT_MAX, and

    bio->bi_iter.bi_size = req_sects << 9;

will overflow. We should probably cap max_discard_sectors at
UINT_MAX >> 9 in a prep patch.
