Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55223 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750746AbdEYIdx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 May 2017 04:33:53 -0400
Date: Thu, 25 May 2017 10:33:49 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 06/10] fs: Introduce IOMAP_NOWAIT
Message-ID: <20170525083349.GG28950@quack2.suse.cz>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
 <20170524164150.9492-7-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170524164150.9492-7-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Wed 24-05-17 11:41:46, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> IOCB_NOWAIT translates to IOMAP_NOWAIT for iomaps.
> This is used by XFS in the XFS patch.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/iomap.c            | 2 ++
>  include/linux/iomap.h | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/fs/iomap.c b/fs/iomap.c
> index 4b10892967a5..5d85ec6e7b20 100644
> --- a/fs/iomap.c
> +++ b/fs/iomap.c
> @@ -879,6 +879,8 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>  	} else {
>  		dio->flags |= IOMAP_DIO_WRITE;
>  		flags |= IOMAP_WRITE;
> +		if (iocb->ki_flags & IOCB_NOWAIT)
> +			flags |= IOMAP_NOWAIT;
>  	}
>  
>  	ret = filemap_write_and_wait_range(mapping, start, end);
> diff --git a/include/linux/iomap.h b/include/linux/iomap.h
> index f753e788da31..69f4e9470084 100644
> --- a/include/linux/iomap.h
> +++ b/include/linux/iomap.h
> @@ -52,6 +52,7 @@ struct iomap {
>  #define IOMAP_REPORT		(1 << 2) /* report extent status, e.g. FIEMAP */
>  #define IOMAP_FAULT		(1 << 3) /* mapping for page fault */
>  #define IOMAP_DIRECT		(1 << 4) /* direct I/O */
> +#define IOMAP_NOWAIT		(1 << 5) /* Don't wait for writeback */
>  
>  struct iomap_ops {
>  	/*
> -- 
> 2.12.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
