Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52111 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753913AbdEIO55 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 10:57:57 -0400
Date: Tue, 9 May 2017 16:57:54 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6/8] nowait aio: ext4
Message-ID: <20170509145754.GG21467@quack2.suse.cz>
References: <20170509122219.31756-1-rgoldwyn@suse.de>
 <20170509122219.31756-7-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170509122219.31756-7-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Tue 09-05-17 07:22:17, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Return EAGAIN if any of the following checks fail for direct I/O:
>   + i_rwsem is lockable
>   + Writing beyond end of file (will trigger allocation)
>   + Blocks are not allocated at the write location
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

The patch looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/file.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index cefa9835f275..2efdc6d4d3e8 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -216,7 +216,13 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		return ext4_dax_write_iter(iocb, from);
>  #endif
>  
> -	inode_lock(inode);
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		if (!inode_trylock(inode))
> +			return -EAGAIN;
> +	} else {
> +		inode_lock(inode);
> +	}
> +
>  	ret = ext4_write_checks(iocb, from);
>  	if (ret <= 0)
>  		goto out;
> @@ -235,9 +241,15 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  
>  	iocb->private = &overwrite;
>  	/* Check whether we do a DIO overwrite or not */
> -	if (o_direct && ext4_should_dioread_nolock(inode) && !unaligned_aio &&
> -	    ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from)))
> -		overwrite = 1;
> +	if (o_direct && !unaligned_aio) {
> +		if (ext4_overwrite_io(inode, iocb->ki_pos, iov_iter_count(from))) {
> +			if (ext4_should_dioread_nolock(inode))
> +				overwrite = 1;
> +		} else if (iocb->ki_flags & IOCB_NOWAIT) {
> +			ret = -EAGAIN;
> +			goto out;
> +		}
> +	}
>  
>  	ret = __generic_file_write_iter(iocb, from);
>  	inode_unlock(inode);
> -- 
> 2.12.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
