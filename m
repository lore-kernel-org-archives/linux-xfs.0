Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46521 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753293AbeDUXTc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 21 Apr 2018 19:19:32 -0400
Date: Sat, 21 Apr 2018 14:54:05 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180421125405.hyx3bbkohdgvducq@quack2.suse.cz>
References: <20180418040828.18165-1-david@fromorbit.com>
 <20180418040828.18165-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418040828.18165-5-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

On Wed 18-04-18 14:08:28, Dave Chinner wrote:
> @@ -1012,8 +1035,16 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  			dio->flags |= IOMAP_DIO_DIRTY;
>  	} else {
>  		dio->flags |= IOMAP_DIO_WRITE;
> -		if (iocb->ki_flags & IOCB_DSYNC)
> +		if (iocb->ki_flags & IOCB_DSYNC) {
>  			dio->flags |= IOMAP_DIO_NEED_SYNC;
> +			/*
> +			 * We optimistically try using FUA for this IO.  Any
> +			 * non-FUA write that occurs will clear this flag, hence
> +			 * we know before completion whether a cache flush is
> +			 * necessary.
> +			 */
> +			dio->flags |= IOMAP_DIO_WRITE_FUA;
> +		}

So I don't think this is quite correct. IOCB_DSYNC gets set also for O_SYNC
writes (in that case we also set IOCB_SYNC). And for those we cannot use
the FUA optimization AFAICT (definitely IOMAP_F_DIRTY isn't a safe
indicator of a need of full fsync for O_SYNC). Other than that the patch
looks good to me.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
