Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46370 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbeELA53 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 May 2018 20:57:29 -0400
Date: Fri, 11 May 2018 17:57:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/10] xfs: make imaxpct changes in growfs separate
Message-ID: <20180512005725.GS11261@magnolia>
References: <20180511225107.27171-1-david@fromorbit.com>
 <20180511225107.27171-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180511225107.27171-7-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Sat, May 12, 2018 at 08:51:03AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When growfs changes the imaxpct value of the filesystem, it runs
> through all the "change size" growfs code, whether it needs to or
> not. Separate out changing imaxpct into it's own function and
> transaction to simplify the rest of the growfs code.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_fsops.c | 69 +++++++++++++++++++++++++++++++++-------------
>  1 file changed, 50 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 263f9b5da991..0fd50c68f1b0 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -400,25 +400,21 @@ xfs_growfs_data_private(
>  	xfs_agi_t		*agi;
>  	xfs_agnumber_t		agno;
>  	xfs_buf_t		*bp;
> -	int			dpct;
>  	int			error, saved_error = 0;
>  	xfs_agnumber_t		nagcount;
>  	xfs_agnumber_t		nagimax = 0;
>  	xfs_rfsblock_t		nb, nb_mod;
>  	xfs_rfsblock_t		new;
>  	xfs_agnumber_t		oagcount;
> -	int			pct;
>  	xfs_trans_t		*tp;
>  	LIST_HEAD		(buffer_list);
>  	struct aghdr_init_data	id = {};
>  
>  	nb = in->newblocks;
> -	pct = in->imaxpct;
> -	if (nb < mp->m_sb.sb_dblocks || pct < 0 || pct > 100)
> +	if (nb < mp->m_sb.sb_dblocks)
>  		return -EINVAL;
>  	if ((error = xfs_sb_validate_fsb_count(&mp->m_sb, nb)))
>  		return error;
> -	dpct = pct - mp->m_sb.sb_imax_pct;
>  	error = xfs_buf_read_uncached(mp->m_ddev_targp,
>  				XFS_FSB_TO_BB(mp, nb) - XFS_FSS_TO_BB(mp, 1),
>  				XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
> @@ -551,8 +547,6 @@ xfs_growfs_data_private(
>  				 nb - mp->m_sb.sb_dblocks);
>  	if (id.nfree)
>  		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, id.nfree);
> -	if (dpct)
> -		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
>  	xfs_trans_set_sync(tp);
>  	error = xfs_trans_commit(tp);
>  	if (error)
> @@ -561,12 +555,6 @@ xfs_growfs_data_private(
>  	/* New allocation groups fully initialized, so update mount struct */
>  	if (nagimax)
>  		mp->m_maxagi = nagimax;
> -	if (mp->m_sb.sb_imax_pct) {
> -		uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
> -		do_div(icount, 100);
> -		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
> -	} else
> -		mp->m_maxicount = 0;
>  	xfs_set_low_space_thresholds(mp);
>  	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
>  
> @@ -670,25 +658,68 @@ xfs_growfs_log_private(
>  	return -ENOSYS;
>  }
>  
> +static int
> +xfs_growfs_imaxpct(
> +	struct xfs_mount	*mp,
> +	__u32			imaxpct)
> +{
> +	struct xfs_trans	*tp;
> +	int64_t			dpct;
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
> +	dpct = (int64_t)imaxpct - mp->m_sb.sb_imax_pct;
> +	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IMAXPCT, dpct);
> +	xfs_trans_set_sync(tp);
> +	return xfs_trans_commit(tp);
> +}
> +
>  /*
>   * protected versions of growfs function acquire and release locks on the mount
>   * point - exported through ioctls: XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG,
>   * XFS_IOC_FSGROWFSRT
>   */
> -
> -
>  int
>  xfs_growfs_data(
> -	xfs_mount_t		*mp,
> -	xfs_growfs_data_t	*in)
> +	struct xfs_mount	*mp,
> +	struct xfs_growfs_data	*in)
>  {
> -	int error;
> +	int			error = 0;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  	if (!mutex_trylock(&mp->m_growlock))
>  		return -EWOULDBLOCK;
> -	error = xfs_growfs_data_private(mp, in);
> +
> +	/* update imaxpct separately to the physical grow of the filesystem */
> +	if (in->imaxpct != mp->m_sb.sb_imax_pct) {
> +		error = xfs_growfs_imaxpct(mp, in->imaxpct);
> +		if (error)
> +			goto out_error;
> +	}
> +
> +	if (in->newblocks != mp->m_sb.sb_dblocks) {
> +		error = xfs_growfs_data_private(mp, in);
> +		if (error)
> +			goto out_error;
> +	}
> +
> +	/* Post growfs calculations needed to reflect new state in operations */
> +	if (mp->m_sb.sb_imax_pct) {
> +		uint64_t icount = mp->m_sb.sb_dblocks * mp->m_sb.sb_imax_pct;
> +		do_div(icount, 100);
> +		mp->m_maxicount = icount << mp->m_sb.sb_inopblog;
> +	} else
> +		mp->m_maxicount = 0;
> +
> +out_error:
>  	/*
>  	 * Increment the generation unconditionally, the error could be from
>  	 * updating the secondary superblocks, in which case the new size
> -- 
> 2.17.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
