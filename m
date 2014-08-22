Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1DA387F53
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2014 08:19:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E35DD304053
	for <xfs@oss.sgi.com>; Fri, 22 Aug 2014 06:19:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5yTNS1MM4ql9BTqx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 22 Aug 2014 06:19:54 -0700 (PDT)
Date: Fri, 22 Aug 2014 09:19:51 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: combine xfs_rtmodify_summary and
	xfs_rtget_summary
Message-ID: <20140822131950.GC3915@laptop.bfoster>
References: <53F6942B.80808@redhat.com>
 <53F6963D.9090500@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F6963D.9090500@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Aug 21, 2014 at 08:00:45PM -0500, Eric Sandeen wrote:
> xfs_rtmodify_summary and xfs_rtget_summary are
> almost identical; fold them into
> xfs_rtmodify_summary_int(), with wrappers for
> each of the original calls.
> 
> The _int function modifies if a delta is passed,
> and returns a summary pointer if *sum is passed.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> index f4dd697..50e3b93 100644
> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> @@ -424,20 +424,24 @@ xfs_rtfind_forw(
>  }
>  
>  /*
> - * Read and modify the summary information for a given extent size,
> + * Read and/or modify the summary information for a given extent size,
>   * bitmap block combination.
>   * Keeps track of a current summary block, so we don't keep reading
>   * it from the buffer cache.
> + *
> + * Summary information is returned in *sum if specified.
> + * If no delta is specified, returns summary only.
>   */
>  int
> -xfs_rtmodify_summary(
> -	xfs_mount_t	*mp,		/* file system mount point */
> +xfs_rtmodify_summary_int(
> +	xfs_mount_t	*mp,		/* file system mount structure */
>  	xfs_trans_t	*tp,		/* transaction pointer */
>  	int		log,		/* log2 of extent size */
>  	xfs_rtblock_t	bbno,		/* bitmap block number */
>  	int		delta,		/* change to make to summary info */
>  	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
> -	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
> +	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
> +	xfs_suminfo_t	*sum)		/* out: summary info for this block */
>  {
>  	xfs_buf_t	*bp;		/* buffer for the summary block */
>  	int		error;		/* error value */
> @@ -480,15 +484,40 @@ xfs_rtmodify_summary(
>  		}
>  	}
>  	/*
> -	 * Point to the summary information, modify and log it.
> +	 * Point to the summary information, modify/log it, and/or copy it out.
>  	 */
>  	sp = XFS_SUMPTR(mp, bp, so);
> -	*sp += delta;
> -	xfs_trans_log_buf(tp, bp, (uint)((char *)sp - (char *)bp->b_addr),
> -		(uint)((char *)sp - (char *)bp->b_addr + sizeof(*sp) - 1));
> +	if (delta) {
> +		uint first = (uint)((char *)sp - (char *)bp->b_addr);
> +
> +		*sp += delta;
> +		xfs_trans_log_buf(tp, bp, first, first + sizeof(*sp) - 1);
> +	}
> +	if (sum) {
> +		/*
> +		 * Drop the buffer if we're not asked to remember it.
> +		 */
> +		if (!rbpp)
> +			xfs_trans_brelse(tp, bp);

This introduces some potentially weird circumstances (e.g., acquire,
log, release of a buffer), but I think it's resolved by the next patch.

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		*sum = *sp;
> +	}
>  	return 0;
>  }
>  
> +int
> +xfs_rtmodify_summary(
> +	xfs_mount_t	*mp,		/* file system mount structure */
> +	xfs_trans_t	*tp,		/* transaction pointer */
> +	int		log,		/* log2 of extent size */
> +	xfs_rtblock_t	bbno,		/* bitmap block number */
> +	int		delta,		/* change to make to summary info */
> +	xfs_buf_t	**rbpp,		/* in/out: summary block buffer */
> +	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
> +{
> +	return xfs_rtmodify_summary_int(mp, tp, log, bbno,
> +					delta, rbpp, rsb, NULL);
> +}
> +
>  /*
>   * Set the given range of bitmap bits to the given value.
>   * Do whatever I/O and logging is required.
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 909e143..d1160cc 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -46,7 +46,7 @@
>   * Keeps track of a current summary block, so we don't keep reading
>   * it from the buffer cache.
>   */
> -STATIC int				/* error */
> +int
>  xfs_rtget_summary(
>  	xfs_mount_t	*mp,		/* file system mount structure */
>  	xfs_trans_t	*tp,		/* transaction pointer */
> @@ -56,60 +56,9 @@ xfs_rtget_summary(
>  	xfs_fsblock_t	*rsb,		/* in/out: summary block number */
>  	xfs_suminfo_t	*sum)		/* out: summary info for this block */
>  {
> -	xfs_buf_t	*bp;		/* buffer for summary block */
> -	int		error;		/* error value */
> -	xfs_fsblock_t	sb;		/* summary fsblock */
> -	int		so;		/* index into the summary file */
> -	xfs_suminfo_t	*sp;		/* pointer to returned data */
> -
> -	/*
> -	 * Compute entry number in the summary file.
> -	 */
> -	so = XFS_SUMOFFS(mp, log, bbno);
> -	/*
> -	 * Compute the block number in the summary file.
> -	 */
> -	sb = XFS_SUMOFFSTOBLOCK(mp, so);
> -	/*
> -	 * If we have an old buffer, and the block number matches, use that.
> -	 */
> -	if (rbpp && *rbpp && *rsb == sb)
> -		bp = *rbpp;
> -	/*
> -	 * Otherwise we have to get the buffer.
> -	 */
> -	else {
> -		/*
> -		 * If there was an old one, get rid of it first.
> -		 */
> -		if (rbpp && *rbpp)
> -			xfs_trans_brelse(tp, *rbpp);
> -		error = xfs_rtbuf_get(mp, tp, sb, 1, &bp);
> -		if (error) {
> -			return error;
> -		}
> -		/*
> -		 * Remember this buffer and block for the next call.
> -		 */
> -		if (rbpp) {
> -			*rbpp = bp;
> -			*rsb = sb;
> -		}
> -	}
> -	/*
> -	 * Point to the summary information & copy it out.
> -	 */
> -	sp = XFS_SUMPTR(mp, bp, so);
> -	*sum = *sp;
> -	/*
> -	 * Drop the buffer if we're not asked to remember it.
> -	 */
> -	if (!rbpp)
> -		xfs_trans_brelse(tp, bp);
> -	return 0;
> +	return xfs_rtmodify_summary_int(mp, tp, log, bbno, 0, rbpp, rsb, sum);
>  }
>  
> -
>  /*
>   * Return whether there are any free extents in the size range given
>   * by low and high, for the bitmap block bbno.
> diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
> index c642795..76c0a4a 100644
> --- a/fs/xfs/xfs_rtalloc.h
> +++ b/fs/xfs/xfs_rtalloc.h
> @@ -111,6 +111,10 @@ int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
>  		    xfs_rtblock_t *rtblock);
>  int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
>  		       xfs_rtblock_t start, xfs_extlen_t len, int val);
> +int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
> +			     int log, xfs_rtblock_t bbno, int delta,
> +			     xfs_buf_t **rbpp, xfs_fsblock_t *rsb,
> +			     xfs_suminfo_t *sum);
>  int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
>  			 xfs_rtblock_t bbno, int delta, xfs_buf_t **rbpp,
>  			 xfs_fsblock_t *rsb);
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
