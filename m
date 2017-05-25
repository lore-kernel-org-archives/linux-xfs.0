Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50104 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964907AbdEYIQW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 May 2017 04:16:22 -0400
Date: Thu, 25 May 2017 10:16:14 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/10] fs: Separate out kiocb flags setup based on RWF_*
 flags
Message-ID: <20170525081614.GB28950@quack2.suse.cz>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
 <20170524164150.9492-2-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170524164150.9492-2-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Wed 24-05-17 11:41:41, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/read_write.c    | 12 +++---------
>  include/linux/fs.h | 14 ++++++++++++++
>  2 files changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 47c1d4484df9..53c816c61122 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -678,16 +678,10 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
>  	struct kiocb kiocb;
>  	ssize_t ret;
>  
> -	if (flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC))
> -		return -EOPNOTSUPP;
> -
>  	init_sync_kiocb(&kiocb, filp);
> -	if (flags & RWF_HIPRI)
> -		kiocb.ki_flags |= IOCB_HIPRI;
> -	if (flags & RWF_DSYNC)
> -		kiocb.ki_flags |= IOCB_DSYNC;
> -	if (flags & RWF_SYNC)
> -		kiocb.ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
> +	ret = kiocb_set_rw_flags(&kiocb, flags);
> +	if (ret)
> +		return ret;
>  	kiocb.ki_pos = *ppos;
>  
>  	if (type == READ)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 803e5a9b2654..f53867140f43 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3056,6 +3056,20 @@ static inline int iocb_flags(struct file *file)
>  	return res;
>  }
>  
> +static inline int kiocb_set_rw_flags(struct kiocb *ki, int flags)
> +{
> +	if (unlikely(flags & ~(RWF_HIPRI | RWF_DSYNC | RWF_SYNC)))
> +		return -EOPNOTSUPP;
> +
> +	if (flags & RWF_HIPRI)
> +		ki->ki_flags |= IOCB_HIPRI;
> +	if (flags & RWF_DSYNC)
> +		ki->ki_flags |= IOCB_DSYNC;
> +	if (flags & RWF_SYNC)
> +		ki->ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
> +	return 0;
> +}
> +
>  static inline ino_t parent_ino(struct dentry *dentry)
>  {
>  	ino_t res;
> -- 
> 2.12.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
