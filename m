Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33729 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752200AbdEOMIg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 May 2017 08:08:36 -0400
Date: Mon, 15 May 2017 11:47:09 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 04/10] fs: Introduce RWF_NOWAIT
Message-ID: <20170515094709.GA16182@quack2.suse.cz>
References: <20170511191710.31959-1-rgoldwyn@suse.de>
 <20170511191710.31959-5-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170511191710.31959-5-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Thu 11-05-17 14:17:04, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> RWF_NOWAIT informs kernel to bail out if an AIO request will block
> for reasons such as file allocations, or a writeback triggered,
> or would block while allocating requests while performing
> direct I/O.
> 
> RWF_NOWAIT is translated to IOCB_NOWAIT for iocb->ki_flags.
> 
> The check for -EOPNOTSUPP is placed in generic_file_write_iter(). This
> is called by most filesystems, either through fsops.write_iter() or through
> the function defined by write_iter(). If not, we perform the check defined
> by .write_iter() which is called for direct IO specifically.
> 
> Filesystems xfs, btrfs and ext4 would be supported in the following patches.
...
> diff --git a/fs/aio.c b/fs/aio.c
> index 020fa0045e3c..34027b67e2f4 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1592,6 +1592,12 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  		goto out_put_req;
>  	}
>  
> +	if ((req->common.ki_flags & IOCB_NOWAIT) &&
> +			!(req->common.ki_flags & IOCB_DIRECT)) {
> +		ret = -EOPNOTSUPP;
> +		goto out_put_req;
> +	}
> +
>  	ret = put_user(KIOCB_KEY, &user_iocb->aio_key);
>  	if (unlikely(ret)) {
>  		pr_debug("EFAULT: aio_key\n");

I think you need to also check here that the IO is write. So that NOWAIT
reads don't silently pass.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
