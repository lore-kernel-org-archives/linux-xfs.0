Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F32A7F3F
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 09:58:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3BCDA8F8037
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 07:58:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zHQOrxtSpb8gIcHK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Jun 2015 07:58:16 -0700 (PDT)
Date: Mon, 15 Jun 2015 10:58:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 03/20] xfs: sanitise error handling in
	xfs_alloc_fix_freelist
Message-ID: <20150615145814.GC36091@bfoster.bfoster>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
	<1433311497-10245-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433311497-10245-4-git-send-email-david@fromorbit.com>
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

On Wed, Jun 03, 2015 at 04:04:40PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The error handling is currently an inconsistent mess as every error
> condition handles return values and releasing buffers individually.
> Clean this up by using gotos and a sane error label stack.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 103 +++++++++++++++++++++-------------------------
>  1 file changed, 47 insertions(+), 56 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 2471cb5..352db46 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1909,80 +1909,65 @@ xfs_alloc_space_available(
>   */
>  STATIC int			/* error */
>  xfs_alloc_fix_freelist(
> -	xfs_alloc_arg_t	*args,	/* allocation argument structure */
> -	int		flags)	/* XFS_ALLOC_FLAG_... */
> +	struct xfs_alloc_arg	*args,	/* allocation argument structure */
> +	int			flags)	/* XFS_ALLOC_FLAG_... */
>  {
> -	xfs_buf_t	*agbp;	/* agf buffer pointer */
> -	xfs_buf_t	*agflbp;/* agfl buffer pointer */
> -	xfs_agblock_t	bno;	/* freelist block */
> -	int		error;	/* error result code */
> -	xfs_mount_t	*mp;	/* file system mount point structure */
> -	xfs_extlen_t	need;	/* total blocks needed in freelist */
> -	xfs_perag_t	*pag;	/* per-ag information structure */
> -	xfs_alloc_arg_t	targs;	/* local allocation arguments */
> -	xfs_trans_t	*tp;	/* transaction pointer */
> -
> -	mp = args->mp;
> +	struct xfs_mount	*mp = args->mp;
> +	struct xfs_perag	*pag = args->pag;
> +	struct xfs_trans	*tp = args->tp;
> +	struct xfs_buf		*agbp = NULL;
> +	struct xfs_buf		*agflbp = NULL;
> +	struct xfs_alloc_arg	targs;	/* local allocation arguments */
> +	xfs_agblock_t		bno;	/* freelist block */
> +	xfs_extlen_t		need;	/* total blocks needed in freelist */
> +	int			error;
>  
> -	pag = args->pag;
> -	tp = args->tp;
>  	if (!pag->pagf_init) {
> -		if ((error = xfs_alloc_read_agf(mp, tp, args->agno, flags,
> -				&agbp)))
> -			return error;
> +		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> +		if (error)
> +			goto out_no_agbp;
>  		if (!pag->pagf_init) {
>  			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
>  			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> -			args->agbp = NULL;
> -			return 0;
> +			goto out_agbp_relse;
>  		}
> -	} else
> -		agbp = NULL;
> +	}
>  
>  	/*
> -	 * If this is a metadata preferred pag and we are user data
> -	 * then try somewhere else if we are not being asked to
> -	 * try harder at this point
> +	 * If this is a metadata preferred pag and we are user data then try
> +	 * somewhere else if we are not being asked to try harder at this
> +	 * point
>  	 */
>  	if (pag->pagf_metadata && args->userdata &&
>  	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
>  		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> -		args->agbp = NULL;
> -		return 0;
> +		goto out_agbp_relse;
>  	}
>  
>  	need = XFS_MIN_FREELIST_PAG(pag, mp);
> -	if (!xfs_alloc_space_available(args, need, flags)) {
> -		if (agbp)
> -			xfs_trans_brelse(tp, agbp);
> -		args->agbp = NULL;
> -		return 0;
> -	}
> +	if (!xfs_alloc_space_available(args, need, flags))
> +		goto out_agbp_relse;
>  
>  	/*
>  	 * Get the a.g. freespace buffer.
>  	 * Can fail if we're not blocking on locks, and it's held.
>  	 */
> -	if (agbp == NULL) {
> -		if ((error = xfs_alloc_read_agf(mp, tp, args->agno, flags,
> -				&agbp)))
> -			return error;
> -		if (agbp == NULL) {
> +	if (!agbp) {
> +		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
> +		if (error)
> +			goto out_no_agbp;
> +		if (!agbp) {
>  			ASSERT(flags & XFS_ALLOC_FLAG_TRYLOCK);
>  			ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
> -			args->agbp = NULL;
> -			return 0;
> +			goto out_no_agbp;
>  		}
>  	}
>  
>  
>  	/* If there isn't enough total space or single-extent, reject it. */
>  	need = XFS_MIN_FREELIST_PAG(pag, mp);
> -	if (!xfs_alloc_space_available(args, need, flags)) {
> -		xfs_trans_brelse(tp, agbp);
> -		args->agbp = NULL;
> -		return 0;
> -	}
> +	if (!xfs_alloc_space_available(args, need, flags))
> +		goto out_agbp_relse;
>  
>  	/*
>  	 * Make the freelist shorter if it's too long.
> @@ -1997,10 +1982,10 @@ xfs_alloc_fix_freelist(
>  
>  		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
>  		if (error)
> -			return error;
> +			goto out_agbp_relse;

So at this point it looks like the buffer could be logged (i.e., dirty
in the transaction). Perhaps this is the reason for the lack of agbp
releases from this point forward in the current error handling. That
said, we do the agflbp release unconditionally at the end of the
function even when it might be logged. xfs_trans_brelse() appears to
handle this case as it just skips removing the item from the tp.

This is a bit confusing and at the very least seems like an unexpected
use of xfs_trans_brelse(). Is this intentional?

Brian

>  		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1);
>  		if (error)
> -			return error;
> +			goto out_agbp_relse;
>  		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
>  		xfs_trans_binval(tp, bp);
>  	}
> @@ -2015,7 +2000,7 @@ xfs_alloc_fix_freelist(
>  	targs.pag = pag;
>  	error = xfs_alloc_read_agfl(mp, tp, targs.agno, &agflbp);
>  	if (error)
> -		return error;
> +		goto out_agbp_relse;
>  
>  	/* Make the freelist longer if it's too short. */
>  	while (pag->pagf_flcount < need) {
> @@ -2024,10 +2009,9 @@ xfs_alloc_fix_freelist(
>  
>  		/* Allocate as many blocks as possible at once. */
>  		error = xfs_alloc_ag_vextent(&targs);
> -		if (error) {
> -			xfs_trans_brelse(tp, agflbp);
> -			return error;
> -		}
> +		if (error)
> +			goto out_agflbp_relse;
> +
>  		/*
>  		 * Stop if we run out.  Won't happen if callers are obeying
>  		 * the restrictions correctly.  Can happen for free calls
> @@ -2036,9 +2020,7 @@ xfs_alloc_fix_freelist(
>  		if (targs.agbno == NULLAGBLOCK) {
>  			if (flags & XFS_ALLOC_FLAG_FREEING)
>  				break;
> -			xfs_trans_brelse(tp, agflbp);
> -			args->agbp = NULL;
> -			return 0;
> +			goto out_agflbp_relse;
>  		}
>  		/*
>  		 * Put each allocated block on the list.
> @@ -2047,12 +2029,21 @@ xfs_alloc_fix_freelist(
>  			error = xfs_alloc_put_freelist(tp, agbp,
>  							agflbp, bno, 0);
>  			if (error)
> -				return error;
> +				goto out_agflbp_relse;
>  		}
>  	}
>  	xfs_trans_brelse(tp, agflbp);
>  	args->agbp = agbp;
>  	return 0;
> +
> +out_agflbp_relse:
> +	xfs_trans_brelse(tp, agflbp);
> +out_agbp_relse:
> +	if (agbp)
> +		xfs_trans_brelse(tp, agbp);
> +out_no_agbp:
> +	args->agbp = NULL;
> +	return error;
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
