Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752585AbdJSLiu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Oct 2017 07:38:50 -0400
Date: Thu, 19 Oct 2017 07:38:48 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH for-4.14] xfs: fix AIM7 regression
Message-ID: <20171019113848.GA8911@bfoster.bfoster>
References: <20171019074705.24827-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019074705.24827-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2017 at 09:47:05AM +0200, Christoph Hellwig wrote:
> Apparently our current rwsem code doesn't like doing the trylock, then
> lock for real scheme.  So change our read/write methods to just do the
> trylock for the RWF_NOWAIT case.  This fixes a ~25% regression in
> AIM7.
> 

The code looks fine, but this seems really strange. If the trylock
fails, then wouldn't the blocking lock have slept anyways if done
initially? Is there any more background info available on this, or
perhaps a theory on why there is such a significant regression..?

Brian

> Fixes: 91f9943e ("fs: support RWF_NOWAIT for buffered reads")
> Reported-by: kernel test robot <xiaolong.ye@intel.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_file.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 309e26c9dddb..f40b5da5d467 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -237,11 +237,13 @@ xfs_file_dax_read(
>  	if (!count)
>  		return 0; /* skip atime */
>  
> -	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
> -		if (iocb->ki_flags & IOCB_NOWAIT)
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
>  			return -EAGAIN;
> +	} else {
>  		xfs_ilock(ip, XFS_IOLOCK_SHARED);
>  	}
> +
>  	ret = dax_iomap_rw(iocb, to, &xfs_iomap_ops);
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
>  
> @@ -259,9 +261,10 @@ xfs_file_buffered_aio_read(
>  
>  	trace_xfs_file_buffered_read(ip, iov_iter_count(to), iocb->ki_pos);
>  
> -	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED)) {
> -		if (iocb->ki_flags & IOCB_NOWAIT)
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		if (!xfs_ilock_nowait(ip, XFS_IOLOCK_SHARED))
>  			return -EAGAIN;
> +	} else {
>  		xfs_ilock(ip, XFS_IOLOCK_SHARED);
>  	}
>  	ret = generic_file_read_iter(iocb, to);
> @@ -552,9 +555,10 @@ xfs_file_dio_aio_write(
>  		iolock = XFS_IOLOCK_SHARED;
>  	}
>  
> -	if (!xfs_ilock_nowait(ip, iolock)) {
> -		if (iocb->ki_flags & IOCB_NOWAIT)
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		if (!xfs_ilock_nowait(ip, iolock))
>  			return -EAGAIN;
> +	} else {
>  		xfs_ilock(ip, iolock);
>  	}
>  
> @@ -606,9 +610,10 @@ xfs_file_dax_write(
>  	size_t			count;
>  	loff_t			pos;
>  
> -	if (!xfs_ilock_nowait(ip, iolock)) {
> -		if (iocb->ki_flags & IOCB_NOWAIT)
> +	if (iocb->ki_flags & IOCB_NOWAIT) {
> +		if (!xfs_ilock_nowait(ip, iolock))
>  			return -EAGAIN;
> +	} else {
>  		xfs_ilock(ip, iolock);
>  	}
>  
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
