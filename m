Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C0A67F57
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 10:41:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E92288F8052
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2014 08:41:37 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JbAqn6WgLl0bCgy6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Dec 2014 08:41:36 -0800 (PST)
Date: Mon, 1 Dec 2014 11:41:30 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: cleanup xfs_bmse_shift_one goto mess
Message-ID: <20141201164130.GB23055@bfoster.bfoster>
References: <1417407608-8016-1-git-send-email-david@fromorbit.com>
	<1417407608-8016-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1417407608-8016-2-git-send-email-david@fromorbit.com>
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

On Mon, Dec 01, 2014 at 03:20:07PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_bmse_shift_one() jumps around determining whether to shift or
> merge, making the code flow difficult to follow. Clean it up and
> use direct error returns (including XFS_WANT_CORRUPTED_RETURN) to
> make the code flow better and be easier to read.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c | 43 +++++++++++++++++--------------------------
>  1 file changed, 17 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 20d2e96..0628a67 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5544,35 +5544,29 @@ xfs_bmse_shift_one(
>  	startoff = got.br_startoff - offset_shift_fsb;
>  
>  	/* delalloc extents should be prevented by caller */
> -	XFS_WANT_CORRUPTED_GOTO(!isnullstartblock(got.br_startblock),
> -				out_error);
> +	XFS_WANT_CORRUPTED_RETURN(!isnullstartblock(got.br_startblock));
>  
>  	/*
> -	 * If this is the first extent in the file, make sure there's enough
> -	 * room at the start of the file and jump right to the shift as there's
> -	 * no left extent to merge.
> +	 * Check for merge if we've got an extent to the left, otherwise make
> +	 * sure there's enough room at the start of the file for the shift.
>  	 */
> -	if (*current_ext == 0) {
> -		if (got.br_startoff < offset_shift_fsb)
> -			return -EINVAL;
> -		goto shift_extent;
> -	}
> +	if (*current_ext) {
> +		/* grab the left extent and check for a large enough hole */
> +		leftp = xfs_iext_get_ext(ifp, *current_ext - 1);
> +		xfs_bmbt_get_all(leftp, &left);
>  
> -	/* grab the left extent and check for a large enough hole */
> -	leftp = xfs_iext_get_ext(ifp, *current_ext - 1);
> -	xfs_bmbt_get_all(leftp, &left);
> +		if (startoff < left.br_startoff + left.br_blockcount)
> +			return -EINVAL;
>  
> -	if (startoff < left.br_startoff + left.br_blockcount)
> +		/* check whether to merge the extent or shift it down */
> +		if (xfs_bmse_can_merge(&left, &got, offset_shift_fsb)) {
> +			return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
> +					      *current_ext, gotp, leftp, cur,
> +					      logflags);
> +		}
> +	} else if (got.br_startoff < offset_shift_fsb)
>  		return -EINVAL;
>  
> -	/* check whether to merge the extent or shift it down */
> -	if (!xfs_bmse_can_merge(&left, &got, offset_shift_fsb))
> -		goto shift_extent;
> -
> -	return xfs_bmse_merge(ip, whichfork, offset_shift_fsb, *current_ext,
> -			      gotp, leftp, cur, logflags);
> -
> -shift_extent:
>  	/*
>  	 * Increment the extent index for the next iteration, update the start
>  	 * offset of the in-core extent and update the btree if applicable.
> @@ -5589,14 +5583,11 @@ shift_extent:
>  				   got.br_blockcount, &i);
>  	if (error)
>  		return error;
> -	XFS_WANT_CORRUPTED_GOTO(i == 1, out_error);
> +	XFS_WANT_CORRUPTED_RETURN(i == 1);
>  
>  	got.br_startoff = startoff;
>  	return xfs_bmbt_update(cur, got.br_startoff, got.br_startblock,
>  				got.br_blockcount, got.br_state);
> -
> -out_error:
> -	return error;
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
