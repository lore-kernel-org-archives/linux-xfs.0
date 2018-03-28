Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44346 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751038AbeC1Hsv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Mar 2018 03:48:51 -0400
Date: Wed, 28 Mar 2018 09:48:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180328074850.GE18726@lst.de>
References: <20180327070717.7107-1-david@fromorbit.com> <20180327070717.7107-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180327070717.7107-4-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

>  		if (iomap->flags & IOMAP_F_NEW)
>  			need_zeroout = true;
> +		else {

Curly braces on both sides of the else, please.

>  		if (dio->flags & IOMAP_DIO_WRITE) {
> -			bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC | REQ_IDLE);
> +			int op_flags = REQ_SYNC | REQ_IDLE;
> +
> +			if (use_fua)
> +				op_flags |= REQ_FUA;
> +			else
> +				dio->flags &= ~IOMAP_DIO_WRITE_FUA;
> +			bio_set_op_attrs(bio, REQ_OP_WRITE, op_flags);

Please kill the bio_set_op_attrs flags while you are at it and assign
directly to bio->bi_opf:

			bio->bi_opf = REQ_OP_WRITE | REQ_SYNC | REQ_IDLE;
			if (use_fua)
				bio->bi_opf |= REQ_FUA;
			else
				dio->flags &= ~IOMAP_DIO_WRITE_FUA;

>  		dio->flags |= IOMAP_DIO_WRITE;
> -		if (iocb->ki_flags & IOCB_DSYNC)
> +		if (iocb->ki_flags & IOCB_DSYNC) {
>  			dio->flags |= IOMAP_DIO_WRITE_SYNC;
> +			/*
> +			 * Any non-FUA write will clear this flag, hence we know
> +			 * before completion whether a cache flush is necessary.
> +			 */
> +			dio->flags |= IOMAP_DIO_WRITE_FUA;

I'd mention that we optimistically try fua first in the comment, and then
go on with what you wrote.

> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index ed63f3b69c12..e853f1748a4b 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -800,6 +800,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
>  #define blk_queue_quiesced(q)	test_bit(QUEUE_FLAG_QUIESCED, &(q)->queue_flags)
>  #define blk_queue_preempt_only(q)				\
>  	test_bit(QUEUE_FLAG_PREEMPT_ONLY, &(q)->queue_flags)
> +#define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)

Separate patch, please.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
