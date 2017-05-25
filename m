Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53355 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937601AbdEYI1t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 May 2017 04:27:49 -0400
Date: Thu, 25 May 2017 10:27:45 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 03/10] fs: Use RWF_* flags for AIO operations
Message-ID: <20170525082745.GD28950@quack2.suse.cz>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
 <20170524164150.9492-4-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170524164150.9492-4-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Wed 24-05-17 11:41:43, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> aio_rw_flags is introduced in struct iocb (using aio_reserved1) which will
> carry the RWF_* flags. We cannot use aio_flags because they are not
> checked for validity which may break existing applications.
> 
> Note, the only place RWF_HIPRI comes in effect is dio_await_one().
> All the rest of the locations, aio code return -EIOCBQUEUED before the
> checks for RWF_HIPRI.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/aio.c                     | 8 +++++++-
>  include/uapi/linux/aio_abi.h | 2 +-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index f52d925ee259..020fa0045e3c 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1541,7 +1541,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  	ssize_t ret;
>  
>  	/* enforce forwards compatibility on users */
> -	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
> +	if (unlikely(iocb->aio_reserved2)) {
>  		pr_debug("EINVAL: reserve field set\n");
>  		return -EINVAL;
>  	}
> @@ -1586,6 +1586,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  		req->common.ki_flags |= IOCB_EVENTFD;
>  	}
>  
> +	ret = kiocb_set_rw_flags(&req->common, iocb->aio_rw_flags);
> +	if (unlikely(ret)) {
> +		pr_debug("EINVAL: aio_rw_flags\n");
> +		goto out_put_req;
> +	}
> +
>  	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
>  	if (unlikely(ret)) {
>  		pr_debug("EFAULT: aio_key\n");
> diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
> index bb2554f7fbd1..a2d4a8ac94ca 100644
> --- a/include/uapi/linux/aio_abi.h
> +++ b/include/uapi/linux/aio_abi.h
> @@ -79,7 +79,7 @@ struct io_event {
>  struct iocb {
>  	/* these are internal to the kernel/libc. */
>  	__u64	aio_data;	/* data to be returned in event's data */
> -	__u32	PADDED(aio_key, aio_reserved1);
> +	__u32	PADDED(aio_key, aio_rw_flags);
>  				/* the kernel sets aio_key to the req # */
>  
>  	/* common fields */
> -- 
> 2.12.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
