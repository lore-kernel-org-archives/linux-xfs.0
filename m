Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54875 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S937299AbdEYIch (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 May 2017 04:32:37 -0400
Date: Thu, 25 May 2017 10:32:32 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 05/10] fs: return if direct write will trigger writeback
Message-ID: <20170525083232.GF28950@quack2.suse.cz>
References: <20170524164150.9492-1-rgoldwyn@suse.de>
 <20170524164150.9492-6-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170524164150.9492-6-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, axboe@kernel.dk, linux-api@vger.kernel.org, adam.manzanares@wdc.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>

On Wed 24-05-17 11:41:45, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> Find out if the write will trigger a wait due to writeback. If yes,
> return -EAGAIN.
> 
> Return -EINVAL for buffered AIO: there are multiple causes of
> delay such as page locks, dirty throttling logic, page loading
> from disk etc. which cannot be taken care of.
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 097213275461..bc146efa6815 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2675,6 +2675,9 @@ inline ssize_t generic_write_checks(struct kiocb *iocb, struct iov_iter *from)
>  
>  	pos = iocb->ki_pos;
>  
> +	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
> +		return -EINVAL;
> +
>  	if (limit != RLIM_INFINITY) {
>  		if (iocb->ki_pos >= limit) {
>  			send_sig(SIGXFSZ, current, 0);
> @@ -2743,9 +2746,17 @@ generic_file_direct_write(struct kiocb *iocb, struct iov_iter *from)
>  	write_len = iov_iter_count(from);
>  	end = (pos + write_len - 1) >> PAGE_SHIFT;
>  
> -	written = filemap_write_and_wait_range(mapping, pos, pos + write_len - 1);
> -	if (written)
> -		goto out;
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		/* If there are pages to writeback, return */
> +		if (filemap_range_has_page(inode->i_mapping, pos,
> +					   pos + iov_iter_count(from)))
> +			return -EAGAIN;
> +	} else {
> +		written = filemap_write_and_wait_range(mapping, pos,
> +							pos + write_len - 1);
> +		if (written)
> +			goto out;
> +	}
>  
>  	/*
>  	 * After a write we want buffered reads to be sure to go to disk to get
> -- 
> 2.12.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
