Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D86EA7F5E
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 10:41:45 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 75B57AC003
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 08:41:42 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qI0rGBHwsq03QsCW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 08:41:41 -0800 (PST)
Date: Mon, 1 Dec 2014 11:41:36 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: cleanup xfs_bmse_merge returns
Message-ID: <20141201164136.GC23055@bfoster.bfoster>
References: <1417407608-8016-1-git-send-email-david@fromorbit.com>
	<1417407608-8016-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1417407608-8016-3-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 01, 2014 at 03:20:08PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> xfs_bmse_merge() has a jump label for return that just returns the
> error value. Convert all the code to just return the error directly
> and use XFS_WANT_CORRUPTED_RETURN. This also allows the final call
> to xfs_bmbt_update() to return directly.
> 
> Noticed while reviewing coccinelle return cleanup patches and
> wondering why the same return pattern as in xfs_bmse_shift_one()
> wasn't picked up by the checker pattern...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 0628a67..5a42e2b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5489,32 +5489,25 @@ xfs_bmse_merge(
>  	error = xfs_bmbt_lookup_eq(cur, got.br_startoff, got.br_startblock,
>  				   got.br_blockcount, &i);
>  	if (error)
> -		goto out_error;
> -	XFS_WANT_CORRUPTED_GOTO(i == 1, out_error);
> +		return error;
> +	XFS_WANT_CORRUPTED_RETURN(i == 1);
>  
>  	error = xfs_btree_delete(cur, &i);
>  	if (error)
> -		goto out_error;
> -	XFS_WANT_CORRUPTED_GOTO(i == 1, out_error);
> +		return error;
> +	XFS_WANT_CORRUPTED_RETURN(i == 1);
>  
>  	/* lookup and update size of the previous extent */
>  	error = xfs_bmbt_lookup_eq(cur, left.br_startoff, left.br_startblock,
>  				   left.br_blockcount, &i);
>  	if (error)
> -		goto out_error;
> -	XFS_WANT_CORRUPTED_GOTO(i == 1, out_error);
> +		return error;
> +	XFS_WANT_CORRUPTED_RETURN(i == 1);
>  
>  	left.br_blockcount = blockcount;
>  
> -	error = xfs_bmbt_update(cur, left.br_startoff, left.br_startblock,
> -				left.br_blockcount, left.br_state);
> -	if (error)
> -		goto out_error;
> -
> -	return 0;
> -
> -out_error:
> -	return error;
> +	return xfs_bmbt_update(cur, left.br_startoff, left.br_startblock,
> +			       left.br_blockcount, left.br_state);
>  }
>  
>  /*
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
