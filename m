Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52654 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760244AbdDSGhz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 02:37:55 -0400
Date: Tue, 18 Apr 2017 23:37:54 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/8] Use RWF_* flags for AIO operations
Message-ID: <20170419063754.GA20053@infradead.org>
References: <20170414120257.8932-1-rgoldwyn@suse.de>
 <20170414120257.8932-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170414120257.8932-2-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Fri, Apr 14, 2017 at 07:02:50AM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> RWF_* flags is used for preadv2/pwritev2 calls. Port to use
> it for aio operations as well. For this, aio_rw_flags is
> introduced in struct iocb (using aio_reserved1) which will
> carry these flags.
> 
> This is a precursor to the nowait AIO calls.
> 
> Note, the only place RWF_HIPRI comes in effect is dio_await_one().
> All the rest of the locations, aio code return -EIOCBQUEUED before the
> checks for RWF_HIPRI.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/aio.c                     | 10 +++++++++-
>  fs/read_write.c              |  7 +------
>  include/linux/fs.h           | 12 ++++++++++++
>  include/uapi/linux/aio_abi.h |  2 +-
>  4 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index f52d925ee259..b8a33f5beef5 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1541,11 +1541,17 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  	ssize_t ret;
>  
>  	/* enforce forwards compatibility on users */
> -	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
> +	if (unlikely(iocb->aio_reserved2)) {
>  		pr_debug("EINVAL: reserve field set\n");
>  		return -EINVAL;
>  	}
>  
> +	if (unlikely(iocb->aio_rw_flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC))) {
> +		pr_debug("EINVAL: aio_rw_flags set with incompatible flags\n");
> +		return -EINVAL;
> +	}
> +

> +	req->common.ki_flags |= iocb_rw_flags(iocb->aio_rw_flags);

The flag validity checking also needs to go into what's currently
iocb_rw_flags (which will need a new name and a return value).

