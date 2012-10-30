Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6WW061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:19 -0500
Date: Mon, 29 Oct 2012 17:36:41 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 04/25] xfs: uncached buffer reads need to return an error
Message-ID: <20121030003641.GF30227@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-5-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 25, 2012 at 05:33:53PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With verification being done as an IO completion callback, different
> errors can be returned from a read. Uncached reads only return a
> buffer or NULL on failure, which means the verification error cannot
> be returned to the caller.
> 
> Split the error handling for these reads into two - a failure to get
> a buffer will still return NULL, but a read error will return a
> referenced buffer with b_error set rather than NULL. The caller is
> responsible for checking the error state of the buffer returned.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c     |    9 ++-------
>  fs/xfs/xfs_fsops.c   |    5 +++++
>  fs/xfs/xfs_mount.c   |    6 ++++++
>  fs/xfs/xfs_rtalloc.c |    9 ++++++++-
>  4 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 7cab1b3..62b7e89 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -715,8 +715,7 @@ xfs_buf_read_uncached(
>  	int			flags,
>  	xfs_buf_iodone_t	verify)
>  {
> -	xfs_buf_t		*bp;
> -	int			error;
> +	struct xfs_buf		*bp;
>  
>  	bp = xfs_buf_get_uncached(target, numblks, flags);
>  	if (!bp)
> @@ -730,11 +729,7 @@ xfs_buf_read_uncached(
>  	bp->b_iodone = verify;
>  
>  	xfsbdstrat(target->bt_mount, bp);
> -	error = xfs_buf_iowait(bp);
> -	if (error) {
> -		xfs_buf_relse(bp);
> -		return NULL;
> -	}
> +	xfs_buf_iowait(bp);
>  	return bp;
>  }
>  
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 917e121..dee14eb 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -149,6 +149,11 @@ xfs_growfs_data_private(
>  				XFS_FSS_TO_BB(mp, 1), 0, NULL);
>  	if (!bp)
>  		return EIO;
> +	if (bp->b_error) {
> +		int	error = bp->b_error;
> +		xfs_buf_relse(bp);
> +		return error;
> +	}
>  	xfs_buf_relse(bp);
>  
>  	new = nb;	/* use new as a temporary here */
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index d39ad72..dc51e32 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -658,6 +658,12 @@ reread:
>  			xfs_warn(mp, "SB buffer read failed");
>  		return EIO;
>  	}
> +	if (bp->b_error) {
> +		error = bp->b_error;
> +		if (loud)
> +			xfs_warn(mp, "SB validate failed");
> +		goto release_buf;
> +	}
>  
>  	/*
>  	 * Initialize the mount structure from the superblock.
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index b271ed9..98dc670 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1876,6 +1876,11 @@ xfs_growfs_rt(
>  				XFS_FSB_TO_BB(mp, 1), 0, NULL);
>  	if (!bp)
>  		return EIO;
> +	if (bp->b_error) {
> +		error = bp->b_error;
> +		xfs_buf_relse(bp);
> +		return error;
> +	}
>  	xfs_buf_relse(bp);
>  
>  	/*
> @@ -2221,8 +2226,10 @@ xfs_rtmount_init(
>  	bp = xfs_buf_read_uncached(mp->m_rtdev_targp,
>  					d - XFS_FSB_TO_BB(mp, 1),
>  					XFS_FSB_TO_BB(mp, 1), 0, NULL);
> -	if (!bp) {
> +	if (!bp || bp->b_error) {
>  		xfs_warn(mp, "realtime device size check failed");
> +		if (bp)
> +			xfs_buf_relse(bp);
>  		return EIO;
>  	}
>  	xfs_buf_relse(bp);
> -- 
> 1.7.10
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

Looks OK. 

Reviewed-by: Phil White <pwhite@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
