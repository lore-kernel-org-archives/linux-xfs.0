Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58196 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbfHMLzq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Aug 2019 07:55:46 -0400
Date: Tue, 13 Aug 2019 07:55:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: Use __xfs_buf_submit everywhere
Message-ID: <20190813115544.GA37069@bfoster>
References: <20190813090306.31278-1-nborisov@suse.com>
 <20190813090306.31278-2-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813090306.31278-2-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Aug 13, 2019 at 12:03:04PM +0300, Nikolay Borisov wrote:
> Currently xfs_buf_submit is used as a tiny wrapper to __xfs_buf_submit.
> It only checks whether XFB_ASYNC flag is set and sets the second
> parameter to __xfs_buf_submit accordingly. It's possible to remove the
> level of indirection since in all contexts where xfs_buf_submit is
> called we already know if XBF_ASYNC is set or not.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---

Random nit: the use of upper case in the first word of the commit log
subject line kind of stands out to me. I know there are other instances
of this (I think I noticed one the other day), but my presumption was
that it was random/accidental where your patches seem to do it
intentionally. Do we have a common practice here? Do we care? I prefer
consistency of using lower case for normal text, but it's really just a
nit.

>  fs/xfs/xfs_buf.c         | 8 +++++---
>  fs/xfs/xfs_buf_item.c    | 2 +-
>  fs/xfs/xfs_log_recover.c | 2 +-
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ca0849043f54..a75d05e49a98 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -751,13 +751,15 @@ _xfs_buf_read(
>  	xfs_buf_t		*bp,
>  	xfs_buf_flags_t		flags)
>  {
> +	bool wait = bp->b_flags & XBF_ASYNC ? false : true;
> +

This doesn't look quite right. Just below we clear several flags from
->b_flags then potentially reapply based on the flags parameter. Hence,
I think ->b_flags above may not reflect ->b_flags by the time we call
__xfs_buf_submit().

Brian

>  	ASSERT(!(flags & XBF_WRITE));
>  	ASSERT(bp->b_maps[0].bm_bn != XFS_BUF_DADDR_NULL);
>  
>  	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
>  	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
>  
> -	return xfs_buf_submit(bp);
> +	return __xfs_buf_submit(bp, wait);
>  }
>  
>  /*
> @@ -883,7 +885,7 @@ xfs_buf_read_uncached(
>  	bp->b_flags |= XBF_READ;
>  	bp->b_ops = ops;
>  
> -	xfs_buf_submit(bp);
> +	__xfs_buf_submit(bp, true);
>  	if (bp->b_error) {
>  		int	error = bp->b_error;
>  		xfs_buf_relse(bp);
> @@ -1214,7 +1216,7 @@ xfs_bwrite(
>  	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
>  			 XBF_WRITE_FAIL | XBF_DONE);
>  
> -	error = xfs_buf_submit(bp);
> +	error = __xfs_buf_submit(bp, true);
>  	if (error)
>  		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
>  	return error;
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index 7dcaec54a20b..fef08980dd21 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1123,7 +1123,7 @@ xfs_buf_iodone_callback_error(
>  			bp->b_first_retry_time = jiffies;
>  
>  		xfs_buf_ioerror(bp, 0);
> -		xfs_buf_submit(bp);
> +		__xfs_buf_submit(bp, false);
>  		return true;
>  	}
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 13d1d3e95b88..64e315f80147 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5610,7 +5610,7 @@ xlog_do_recover(
>  	bp->b_flags |= XBF_READ;
>  	bp->b_ops = &xfs_sb_buf_ops;
>  
> -	error = xfs_buf_submit(bp);
> +	error = __xfs_buf_submit(bp, true);
>  	if (error) {
>  		if (!XFS_FORCED_SHUTDOWN(mp)) {
>  			xfs_buf_ioerror_alert(bp, __func__);
> -- 
> 2.17.1
> 
