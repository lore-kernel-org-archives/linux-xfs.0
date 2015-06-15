Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A423A7F3F
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 09:58:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6A015304032
	for <xfs@oss.sgi.com>; Mon, 15 Jun 2015 07:58:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id o8II4HnY7ZgUEiTN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Jun 2015 07:58:02 -0700 (PDT)
Date: Mon, 15 Jun 2015 10:58:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 02/20] xfs: factor out free space extent length check
Message-ID: <20150615145800.GB36091@bfoster.bfoster>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
	<1433311497-10245-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1433311497-10245-3-git-send-email-david@fromorbit.com>
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

On Wed, Jun 03, 2015 at 04:04:39PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The longest extent length checks in xfs_alloc_fix_freelist() are now
> essentially identical. Factor them out into a helper function, so we
> know they are checking exactly the same thing before and after we
> lock the AGF.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 71 +++++++++++++++++++++++++++++------------------
>  1 file changed, 44 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 08b45f8..2471cb5 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1871,6 +1871,39 @@ xfs_alloc_longest_free_extent(
>  }
>  
>  /*
> + * Check if the operation we are fixing up the freelist for should go ahead or
> + * not. If we are freeing blocks, we always allow it, otherwise the allocation
> + * is dependent on whether the size and shape of free space available will
> + * permit the requested allocation to take place.
> + */
> +static bool
> +xfs_alloc_space_available(
> +	struct xfs_alloc_arg	*args,
> +	xfs_extlen_t		min_free,
> +	int			flags)
> +{
> +	struct xfs_perag	*pag = args->pag;
> +	xfs_extlen_t		longest;
> +	int			available;
> +
> +	if (flags & XFS_ALLOC_FLAG_FREEING)
> +		return true;
> +
> +	/* do we have enough contiguous free space for the allocation? */
> +	longest = xfs_alloc_longest_free_extent(args->mp, pag, min_free);
> +	if ((args->minlen + args->alignment + args->minalignslop - 1) > longest)
> +		return false;
> +
> +	/* do have enough free space remaining for the allocation? */
> +	available = (int)(pag->pagf_freeblks + pag->pagf_flcount -
> +			  min_free - args->total);
> +	if (available < (int)args->minleft)
> +		return false;
> +
> +	return true;
> +}
> +
> +/*
>   * Decide whether to use this allocation group for this allocation.
>   * If so, fix up the btree freelist's size.
>   */
> @@ -1883,7 +1916,6 @@ xfs_alloc_fix_freelist(
>  	xfs_buf_t	*agflbp;/* agfl buffer pointer */
>  	xfs_agblock_t	bno;	/* freelist block */
>  	int		error;	/* error result code */
> -	xfs_extlen_t	longest;/* longest extent in allocation group */
>  	xfs_mount_t	*mp;	/* file system mount point structure */
>  	xfs_extlen_t	need;	/* total blocks needed in freelist */
>  	xfs_perag_t	*pag;	/* per-ag information structure */
> @@ -1919,22 +1951,12 @@ xfs_alloc_fix_freelist(
>  		return 0;
>  	}
>  
> -	if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
> -		/*
> -		 * If it looks like there isn't a long enough extent, or enough
> -		 * total blocks, reject it.
> -		 */
> -		need = XFS_MIN_FREELIST_PAG(pag, mp);
> -		longest = xfs_alloc_longest_free_extent(mp, pag, need);
> -		if ((args->minlen + args->alignment + args->minalignslop - 1) >
> -				longest ||
> -		    ((int)(pag->pagf_freeblks + pag->pagf_flcount -
> -			   need - args->total) < (int)args->minleft)) {
> -			if (agbp)
> -				xfs_trans_brelse(tp, agbp);
> -			args->agbp = NULL;
> -			return 0;
> -		}
> +	need = XFS_MIN_FREELIST_PAG(pag, mp);

'need' could probably be initialized once at the top of the function at
this point. This is duplicated in the subsequent hunk and doesn't look
like the function modifies it anywhere. That minor bit aside, the rest
looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	if (!xfs_alloc_space_available(args, need, flags)) {
> +		if (agbp)
> +			xfs_trans_brelse(tp, agbp);
> +		args->agbp = NULL;
> +		return 0;
>  	}
>  
>  	/*
> @@ -1956,17 +1978,12 @@ xfs_alloc_fix_freelist(
>  
>  	/* If there isn't enough total space or single-extent, reject it. */
>  	need = XFS_MIN_FREELIST_PAG(pag, mp);
> -	if (!(flags & XFS_ALLOC_FLAG_FREEING)) {
> -		longest = xfs_alloc_longest_free_extent(mp, pag, need);
> -		if ((args->minlen + args->alignment + args->minalignslop - 1) >
> -				longest ||
> -		    ((int)(pag->pagf_freeblks + pag->pagf_flcount -
> -			   need - args->total) < (int)args->minleft)) {
> -			xfs_trans_brelse(tp, agbp);
> -			args->agbp = NULL;
> -			return 0;
> -		}
> +	if (!xfs_alloc_space_available(args, need, flags)) {
> +		xfs_trans_brelse(tp, agbp);
> +		args->agbp = NULL;
> +		return 0;
>  	}
> +
>  	/*
>  	 * Make the freelist shorter if it's too long.
>  	 *
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
