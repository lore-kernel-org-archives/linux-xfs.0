Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751031AbeBIQLz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Feb 2018 11:11:55 -0500
Date: Fri, 9 Feb 2018 11:11:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/7] xfs: separate secondary sb update in growfs
Message-ID: <20180209161153.GC21413@bfoster.bfoster>
References: <20180201064202.7174-1-david@fromorbit.com>
 <20180201064202.7174-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180201064202.7174-7-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 01, 2018 at 05:42:01PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This happens after all the transactions to update the superblock
> occur, and errors need to be handled slightly differently. Seperate

Separate

> out the code into it's own function, and clean up the error goto
> stack in the core growfs code as it is now much simpler.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c | 154 ++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 87 insertions(+), 67 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 5c844e540320..113be7dbdc81 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
...
> @@ -572,16 +572,79 @@ xfs_growfs_data_private(
>  		error = xfs_ag_resv_free(pag);
>  		xfs_perag_put(pag);
>  		if (error)
> -			goto out;
> +			return error;
>  	}
>  
>  	/* Reserve AG metadata blocks. */
> -	error = xfs_fs_reserve_ag_blocks(mp);
> -	if (error && error != -ENOSPC)
> -		goto out;
> +	return xfs_fs_reserve_ag_blocks(mp);

It looks like we change the semantics of -ENOSPC during perag
reservation init. No mention of whether this is intentional and/or
why..?

Brian

> +
> +out_trans_cancel:
> +	xfs_trans_cancel(tp);
> +	return error;
> +}
> +
> +static int
> +xfs_growfs_log_private(
> +	xfs_mount_t		*mp,	/* mount point for filesystem */
> +	xfs_growfs_log_t	*in)	/* growfs log input struct */
> +{
> +	xfs_extlen_t		nb;
> +
> +	nb = in->newblocks;
> +	if (nb < XFS_MIN_LOG_BLOCKS || nb < XFS_B_TO_FSB(mp, XFS_MIN_LOG_BYTES))
> +		return -EINVAL;
> +	if (nb == mp->m_sb.sb_logblocks &&
> +	    in->isint == (mp->m_sb.sb_logstart != 0))
> +		return -EINVAL;
> +	/*
> +	 * Moving the log is hard, need new interfaces to sync
> +	 * the log first, hold off all activity while moving it.
> +	 * Can have shorter or longer log in the same space,
> +	 * or transform internal to external log or vice versa.
> +	 */
> +	return -ENOSYS;
> +}
> +
> +static int
> +xfs_growfs_imaxpct(
> +	struct xfs_mount	*mp,
> +	__u32			imaxpct)
> +{
> +	struct xfs_trans	*tp;
> +	int			dpct;
> +	int			error;
> +
> +	if (imaxpct > 100)
> +		return -EINVAL;
> +
> +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> +			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> +	if (error)
> +		return error;
> +
> +	dpct = imaxpct - mp->m_sb.sb_imax_pct;
> +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
> +	xfs_trans_set_sync(tp);
> +	return xfs_trans_commit(tp);
> +}
> +
> +/*
> + * After a grow operation, we need to update all the secondary superblocks
> + * to match the new state of the primary. Read/init the superblocks and update
> + * them appropriately.
> + */
> +static int
> +xfs_growfs_update_superblocks(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		oagcount)
> +{
> +	struct xfs_buf		*bp;
> +	xfs_agnumber_t		agno;
> +	int			saved_error = 0;
> +	int			error = 0;
>  
>  	/* update secondary superblocks. */
> -	for (agno = 1; agno < nagcount; agno++) {
> +	for (agno = 1; agno < mp->m_sb.sb_agcount; agno++) {
>  		error = 0;
>  		/*
>  		 * new secondary superblocks need to be zeroed, not read from
> @@ -631,57 +694,7 @@ xfs_growfs_data_private(
>  		}
>  	}
>  
> - out:
>  	return saved_error ? saved_error : error;
> -
> - error0:
> -	xfs_trans_cancel(tp);
> -	return error;
> -}
> -
> -static int
> -xfs_growfs_log_private(
> -	xfs_mount_t		*mp,	/* mount point for filesystem */
> -	xfs_growfs_log_t	*in)	/* growfs log input struct */
> -{
> -	xfs_extlen_t		nb;
> -
> -	nb = in->newblocks;
> -	if (nb < XFS_MIN_LOG_BLOCKS || nb < XFS_B_TO_FSB(mp, XFS_MIN_LOG_BYTES))
> -		return -EINVAL;
> -	if (nb == mp->m_sb.sb_logblocks &&
> -	    in->isint == (mp->m_sb.sb_logstart != 0))
> -		return -EINVAL;
> -	/*
> -	 * Moving the log is hard, need new interfaces to sync
> -	 * the log first, hold off all activity while moving it.
> -	 * Can have shorter or longer log in the same space,
> -	 * or transform internal to external log or vice versa.
> -	 */
> -	return -ENOSYS;
> -}
> -
> -static int
> -xfs_growfs_imaxpct(
> -	struct xfs_mount	*mp,
> -	__u32			imaxpct)
> -{
> -	struct xfs_trans	*tp;
> -	int64_t			dpct;
> -	int			error;
> -
> -	if (imaxpct > 100)
> -		return -EINVAL;
> -
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growdata,
> -			XFS_GROWFS_SPACE_RES(mp), 0, XFS_TRANS_RESERVE, &tp);
> -	if (error)
> -		return error;
> -
> -	dpct = (int64_t)imaxpct - mp->m_sb.sb_imax_pct;
> -	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
> -	xfs_trans_set_sync(tp);
> -	return xfs_trans_commit(tp);
>  }
>  
>  /*
> @@ -694,6 +707,7 @@ xfs_growfs_data(
>  	struct xfs_mount	*mp,
>  	struct xfs_growfs_data	*in)
>  {
> +	xfs_agnumber_t		oagcount;
>  	int			error = 0;
>  
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -708,6 +722,7 @@ xfs_growfs_data(
>  			goto out_error;
>  	}
>  
> +	oagcount = mp->m_sb.sb_agcount;
>  	error = xfs_growfs_data_private(mp, in);
>  	if (error)
>  		goto out_error;
> @@ -722,6 +737,11 @@ xfs_growfs_data(
>  	} else
>  		mp->m_maxicount = 0;
>  
> +	/*
> +	 * Update secondary superblocks now the physical grow has completed
> +	 */
> +	error = xfs_growfs_update_superblocks(mp, oagcount);
> +
>  out_error:
>  	/*
>  	 * Increment the generation unconditionally, the error could be from
> -- 
> 2.15.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
