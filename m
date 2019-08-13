Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbfHML5B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Aug 2019 07:57:01 -0400
Date: Tue, 13 Aug 2019 07:56:58 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: Rename __xfs_buf_submit to xfs_buf_submit
Message-ID: <20190813115658.GB37069@bfoster>
References: <20190813090306.31278-1-nborisov@suse.com>
 <20190813090306.31278-3-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813090306.31278-3-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

On Tue, Aug 13, 2019 at 12:03:05PM +0300, Nikolay Borisov wrote:
> Since xfs_buf_submit no longer has any callers just rename its __
> prefixed counterpart.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---

Now we have a primary submission interface that allows combinations of
XBF_ASYNC and waiting or not while the underlying mechanisms are not so
flexible. It looks like the current factoring exists to support delwri
queues where we never wait in buffer submission regardless of async
state because we are batching the submission/wait across multiple
buffers. But what happens if a caller passes an async buffer with wait
== true? I/O completion only completes ->b_iowait if XBF_ASYNC is clear.

I find this rather confusing because now a caller needs to know about
implementation details to use the function properly. That's already true
of __xfs_buf_submit(), but that's partly why it's named as an "internal"
function. I think we ultimately need the interface flexibility so the
delwri case can continue to work. One option could be to update
xfs_buf_submit() such that we never wait on an XBF_ASYNC buffer and add
an assert to flag wait == true as invalid, but TBH I'm not convinced
this is any simpler than the current interface where most callers simply
only need to care about the flag. Maybe others have thoughts...

Brian

>  fs/xfs/xfs_buf.c         | 10 +++++-----
>  fs/xfs/xfs_buf.h         |  7 +------
>  fs/xfs/xfs_buf_item.c    |  2 +-
>  fs/xfs/xfs_log_recover.c |  2 +-
>  4 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a75d05e49a98..99c66f80d7cc 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -759,7 +759,7 @@ _xfs_buf_read(
>  	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
>  	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
>  
> -	return __xfs_buf_submit(bp, wait);
> +	return xfs_buf_submit(bp, wait);
>  }
>  
>  /*
> @@ -885,7 +885,7 @@ xfs_buf_read_uncached(
>  	bp->b_flags |= XBF_READ;
>  	bp->b_ops = ops;
>  
> -	__xfs_buf_submit(bp, true);
> +	xfs_buf_submit(bp, true);
>  	if (bp->b_error) {
>  		int	error = bp->b_error;
>  		xfs_buf_relse(bp);
> @@ -1216,7 +1216,7 @@ xfs_bwrite(
>  	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
>  			 XBF_WRITE_FAIL | XBF_DONE);
>  
> -	error = __xfs_buf_submit(bp, true);
> +	error = xfs_buf_submit(bp, true);
>  	if (error)
>  		xfs_force_shutdown(bp->b_mount, SHUTDOWN_META_IO_ERROR);
>  	return error;
> @@ -1427,7 +1427,7 @@ xfs_buf_iowait(
>   * holds an additional reference itself.
>   */
>  int
> -__xfs_buf_submit(
> +xfs_buf_submit(
>  	struct xfs_buf	*bp,
>  	bool		wait)
>  {
> @@ -1929,7 +1929,7 @@ xfs_buf_delwri_submit_buffers(
>  			bp->b_flags |= XBF_ASYNC;
>  			list_del_init(&bp->b_list);
>  		}
> -		__xfs_buf_submit(bp, false);
> +		xfs_buf_submit(bp, false);
>  	}
>  	blk_finish_plug(&plug);
>  
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index c6e57a3f409e..ec7037284d62 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -262,12 +262,7 @@ extern void __xfs_buf_ioerror(struct xfs_buf *bp, int error,
>  #define xfs_buf_ioerror(bp, err) __xfs_buf_ioerror((bp), (err), __this_address)
>  extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
>  
> -extern int __xfs_buf_submit(struct xfs_buf *bp, bool);
> -static inline int xfs_buf_submit(struct xfs_buf *bp)
> -{
> -	bool wait = bp->b_flags & XBF_ASYNC ? false : true;
> -	return __xfs_buf_submit(bp, wait);
> -}
> +extern int xfs_buf_submit(struct xfs_buf *bp, bool);
>  
>  void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
>  
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index fef08980dd21..93f38fdceb80 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -1123,7 +1123,7 @@ xfs_buf_iodone_callback_error(
>  			bp->b_first_retry_time = jiffies;
>  
>  		xfs_buf_ioerror(bp, 0);
> -		__xfs_buf_submit(bp, false);
> +		xfs_buf_submit(bp, false);
>  		return true;
>  	}
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 64e315f80147..9b7822638f83 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -5610,7 +5610,7 @@ xlog_do_recover(
>  	bp->b_flags |= XBF_READ;
>  	bp->b_ops = &xfs_sb_buf_ops;
>  
> -	error = __xfs_buf_submit(bp, true);
> +	error = xfs_buf_submit(bp, true);
>  	if (error) {
>  		if (!XFS_FORCED_SHUTDOWN(mp)) {
>  			xfs_buf_ioerror_alert(bp, __func__);
> -- 
> 2.17.1
> 
