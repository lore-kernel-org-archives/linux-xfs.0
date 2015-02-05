Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A1A778017
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 08:10:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F9BA304039
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 06:10:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TLY0rFjzIG57k58Y (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 06:10:53 -0800 (PST)
Date: Thu, 5 Feb 2015 09:10:44 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/7] xfs: replace xfs_mod_incore_sb_batched
Message-ID: <20150205141044.GH31625@laptop.bfoster>
References: <1423083249-27493-1-git-send-email-david@fromorbit.com>
	<1423083249-27493-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423083249-27493-7-git-send-email-david@fromorbit.com>
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

On Thu, Feb 05, 2015 at 07:54:08AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Introduce helper functions for modifying fields in the superblock
> into xfs_trans.c, the only caller of xfs_mod_incore_sb_batch().  We
> can then use these directly in xfs_trans_unreserve_and_mod_sb() and
> so remove another user of the xfs_mode_incore_sb() API without
> losing any functionality or scalability of the transaction commit
> code..
> 
> Based on a patch from Christoph Hellwig.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.c |  51 --------------
>  fs/xfs/xfs_mount.h |  11 ---
>  fs/xfs/xfs_trans.c | 198 ++++++++++++++++++++++++++++++++++-------------------
>  3 files changed, 126 insertions(+), 134 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 284f528..9499e88 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1354,57 +1354,6 @@ xfs_mod_incore_sb(
>  }
>  
>  /*
> - * Change more than one field in the in-core superblock structure at a time.
> - *
> - * The fields and changes to those fields are specified in the array of
> - * xfs_mod_sb structures passed in.  Either all of the specified deltas
> - * will be applied or none of them will.  If any modified field dips below 0,
> - * then all modifications will be backed out and EINVAL will be returned.
> - *
> - * Note that this function may not be used for the superblock values that
> - * are tracked with the in-memory per-cpu counters - a direct call to
> - * xfs_mod_incore_sb is required for these.
> - */
> -int
> -xfs_mod_incore_sb_batch(
> -	struct xfs_mount	*mp,
> -	xfs_mod_sb_t		*msb,
> -	uint			nmsb,
> -	int			rsvd)
> -{
> -	xfs_mod_sb_t		*msbp;
> -	int			error = 0;
> -
> -	/*
> -	 * Loop through the array of mod structures and apply each individually.
> -	 * If any fail, then back out all those which have already been applied.
> -	 * Do all of this within the scope of the m_sb_lock so that all of the
> -	 * changes will be atomic.
> -	 */
> -	spin_lock(&mp->m_sb_lock);
> -	for (msbp = msb; msbp < (msb + nmsb); msbp++) {
> -		ASSERT(msbp->msb_field < XFS_SBS_ICOUNT ||
> -		       msbp->msb_field > XFS_SBS_FDBLOCKS);
> -
> -		error = xfs_mod_incore_sb_unlocked(mp, msbp->msb_field,
> -						   msbp->msb_delta, rsvd);
> -		if (error)
> -			goto unwind;
> -	}
> -	spin_unlock(&mp->m_sb_lock);
> -	return 0;
> -
> -unwind:
> -	while (--msbp >= msb) {
> -		error = xfs_mod_incore_sb_unlocked(mp, msbp->msb_field,
> -						   -msbp->msb_delta, rsvd);
> -		ASSERT(error == 0);
> -	}
> -	spin_unlock(&mp->m_sb_lock);
> -	return error;
> -}
> -
> -/*
>   * xfs_getsb() is called to obtain the buffer for the superblock.
>   * The buffer is returned locked and read in from disk.
>   * The buffer should be released with a call to xfs_brelse().
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 8970489..66f28c1 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -249,15 +249,6 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
>  }
>  
>  /*
> - * This structure is for use by the xfs_mod_incore_sb_batch() routine.
> - * xfs_growfs can specify a few fields which are more than int limit
> - */
> -typedef struct xfs_mod_sb {
> -	xfs_sb_field_t	msb_field;	/* Field to modify, see below */
> -	int64_t		msb_delta;	/* Change to make to specified field */
> -} xfs_mod_sb_t;
> -
> -/*
>   * Per-ag incore structure, copies of information in agf and agi, to improve the
>   * performance of allocation group selection.
>   */
> @@ -314,8 +305,6 @@ extern int	xfs_initialize_perag(xfs_mount_t *mp, xfs_agnumber_t agcount,
>  
>  extern void	xfs_unmountfs(xfs_mount_t *);
>  extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
> -extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
> -			uint, int);
>  extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
>  extern int	xfs_mod_ifree(struct xfs_mount *mp, int64_t delta);
>  extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 4e4bc5a..220ef2c 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -485,6 +485,54 @@ xfs_trans_apply_sb_deltas(
>  				  sizeof(sbp->sb_frextents) - 1);
>  }
>  
> +STATIC int
> +xfs_sb_mod8(
> +	uint8_t			*field,
> +	int8_t			delta)
> +{
> +	int8_t			counter = *field;
> +
> +	counter += delta;
> +	if (counter < 0) {
> +		ASSERT(0);
> +		return -EINVAL;
> +	}
> +	*field = counter;
> +	return 0;
> +}
> +
> +STATIC int
> +xfs_sb_mod32(
> +	uint32_t		*field,
> +	int32_t			delta)
> +{
> +	int32_t			counter = *field;
> +
> +	counter += delta;
> +	if (counter < 0) {
> +		ASSERT(0);
> +		return -EINVAL;
> +	}
> +	*field = counter;
> +	return 0;
> +}
> +
> +STATIC int
> +xfs_sb_mod64(
> +	uint64_t		*field,
> +	int64_t			delta)
> +{
> +	int64_t			counter = *field;
> +
> +	counter += delta;
> +	if (counter < 0) {
> +		ASSERT(0);
> +		return -EINVAL;
> +	}
> +	*field = counter;
> +	return 0;
> +}
> +
>  /*
>   * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations
>   * and apply superblock counter changes to the in-core superblock.  The
> @@ -492,13 +540,6 @@ xfs_trans_apply_sb_deltas(
>   * applied to the in-core superblock.  The idea is that that has already been
>   * done.
>   *
> - * This is done efficiently with a single call to xfs_mod_incore_sb_batch().
> - * However, we have to ensure that we only modify each superblock field only
> - * once because the application of the delta values may not be atomic. That can
> - * lead to ENOSPC races occurring if we have two separate modifcations of the
> - * free space counter to put back the entire reservation and then take away
> - * what we used.
> - *
>   * If we are not logging superblock counters, then the inode allocated/free and
>   * used block counts are not updated in the on disk superblock. In this case,
>   * XFS_TRANS_SB_DIRTY will not be set when the transaction is updated but we
> @@ -506,20 +547,15 @@ xfs_trans_apply_sb_deltas(
>   */
>  void
>  xfs_trans_unreserve_and_mod_sb(
> -	xfs_trans_t	*tp)
> +	struct xfs_trans	*tp)
>  {
> -	xfs_mod_sb_t	msb[9];	/* If you add cases, add entries */
> -	xfs_mod_sb_t	*msbp;
> -	xfs_mount_t	*mp = tp->t_mountp;
> -	/* REFERENCED */
> -	int		error;
> -	bool		rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
> -	int64_t		blkdelta = 0;
> -	int64_t		rtxdelta = 0;
> -	int64_t		idelta = 0;
> -	int64_t		ifreedelta = 0;
> -
> -	msbp = msb;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	bool			rsvd = (tp->t_flags & XFS_TRANS_RESERVE) != 0;
> +	int64_t			blkdelta = 0;
> +	int64_t			rtxdelta = 0;
> +	int64_t			idelta = 0;
> +	int64_t			ifreedelta = 0;
> +	int			error;
>  
>  	/* calculate deltas */
>  	if (tp->t_blk_res > 0)
> @@ -560,72 +596,90 @@ xfs_trans_unreserve_and_mod_sb(
>  			goto out_undo_icount;
>  	}
>  
> +	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
> +		return;
> +
>  	/* apply remaining deltas */
> +	spin_lock(&mp->m_sb_lock);
>  	if (rtxdelta) {
> -		error = xfs_mod_frextents(mp, rtxdelta);
> +		error = xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);

Any reason why we don't continue to use the xfs_mod_frextents() function
introduced in the previous patch? Seems like we should be consistent one
way or the other.

Brian

>  		if (error)
>  			goto out_undo_ifree;
>  	}
>  
> -	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
> -		if (tp->t_dblocks_delta != 0) {
> -			msbp->msb_field = XFS_SBS_DBLOCKS;
> -			msbp->msb_delta = tp->t_dblocks_delta;
> -			msbp++;
> -		}
> -		if (tp->t_agcount_delta != 0) {
> -			msbp->msb_field = XFS_SBS_AGCOUNT;
> -			msbp->msb_delta = tp->t_agcount_delta;
> -			msbp++;
> -		}
> -		if (tp->t_imaxpct_delta != 0) {
> -			msbp->msb_field = XFS_SBS_IMAX_PCT;
> -			msbp->msb_delta = tp->t_imaxpct_delta;
> -			msbp++;
> -		}
> -		if (tp->t_rextsize_delta != 0) {
> -			msbp->msb_field = XFS_SBS_REXTSIZE;
> -			msbp->msb_delta = tp->t_rextsize_delta;
> -			msbp++;
> -		}
> -		if (tp->t_rbmblocks_delta != 0) {
> -			msbp->msb_field = XFS_SBS_RBMBLOCKS;
> -			msbp->msb_delta = tp->t_rbmblocks_delta;
> -			msbp++;
> -		}
> -		if (tp->t_rblocks_delta != 0) {
> -			msbp->msb_field = XFS_SBS_RBLOCKS;
> -			msbp->msb_delta = tp->t_rblocks_delta;
> -			msbp++;
> -		}
> -		if (tp->t_rextents_delta != 0) {
> -			msbp->msb_field = XFS_SBS_REXTENTS;
> -			msbp->msb_delta = tp->t_rextents_delta;
> -			msbp++;
> -		}
> -		if (tp->t_rextslog_delta != 0) {
> -			msbp->msb_field = XFS_SBS_REXTSLOG;
> -			msbp->msb_delta = tp->t_rextslog_delta;
> -			msbp++;
> -		}
> -	}
> -
> -	/*
> -	 * If we need to change anything, do it.
> -	 */
> -	if (msbp > msb) {
> -		error = xfs_mod_incore_sb_batch(tp->t_mountp, msb,
> -			(uint)(msbp - msb), rsvd);
> +	if (tp->t_dblocks_delta != 0) {
> +		error = xfs_sb_mod64(&mp->m_sb.sb_dblocks, tp->t_dblocks_delta);
>  		if (error)
>  			goto out_undo_frextents;
>  	}
> -
> +	if (tp->t_agcount_delta != 0) {
> +		error = xfs_sb_mod32(&mp->m_sb.sb_agcount, tp->t_agcount_delta);
> +		if (error)
> +			goto out_undo_dblocks;
> +	}
> +	if (tp->t_imaxpct_delta != 0) {
> +		error = xfs_sb_mod8(&mp->m_sb.sb_imax_pct, tp->t_imaxpct_delta);
> +		if (error)
> +			goto out_undo_agcount;
> +	}
> +	if (tp->t_rextsize_delta != 0) {
> +		error = xfs_sb_mod32(&mp->m_sb.sb_rextsize,
> +				     tp->t_rextsize_delta);
> +		if (error)
> +			goto out_undo_imaxpct;
> +	}
> +	if (tp->t_rbmblocks_delta != 0) {
> +		error = xfs_sb_mod32(&mp->m_sb.sb_rbmblocks,
> +				     tp->t_rbmblocks_delta);
> +		if (error)
> +			goto out_undo_rextsize;
> +	}
> +	if (tp->t_rblocks_delta != 0) {
> +		error = xfs_sb_mod64(&mp->m_sb.sb_rblocks, tp->t_rblocks_delta);
> +		if (error)
> +			goto out_undo_rbmblocks;
> +	}
> +	if (tp->t_rextents_delta != 0) {
> +		error = xfs_sb_mod64(&mp->m_sb.sb_rextents,
> +				     tp->t_rextents_delta);
> +		if (error)
> +			goto out_undo_rblocks;
> +	}
> +	if (tp->t_rextslog_delta != 0) {
> +		error = xfs_sb_mod8(&mp->m_sb.sb_rextslog,
> +				     tp->t_rextslog_delta);
> +		if (error)
> +			goto out_undo_rextents;
> +	}
> +	spin_unlock(&mp->m_sb_lock);
>  	return;
>  
> +out_undo_rextents:
> +	if (tp->t_rextents_delta)
> +		xfs_sb_mod64(&mp->m_sb.sb_rextents, -tp->t_rextents_delta);
> +out_undo_rblocks:
> +	if (tp->t_rblocks_delta)
> +		xfs_sb_mod64(&mp->m_sb.sb_rblocks, -tp->t_rblocks_delta);
> +out_undo_rbmblocks:
> +	if (tp->t_rbmblocks_delta)
> +		xfs_sb_mod32(&mp->m_sb.sb_rbmblocks, -tp->t_rbmblocks_delta);
> +out_undo_rextsize:
> +	if (tp->t_rextsize_delta)
> +		xfs_sb_mod32(&mp->m_sb.sb_rextsize, -tp->t_rextsize_delta);
> +out_undo_imaxpct:
> +	if (tp->t_rextsize_delta)
> +		xfs_sb_mod8(&mp->m_sb.sb_imax_pct, -tp->t_imaxpct_delta);
> +out_undo_agcount:
> +	if (tp->t_agcount_delta)
> +		xfs_sb_mod32(&mp->m_sb.sb_agcount, -tp->t_agcount_delta);
> +out_undo_dblocks:
> +	if (tp->t_dblocks_delta)
> +		xfs_sb_mod64(&mp->m_sb.sb_dblocks, -tp->t_dblocks_delta);
>  out_undo_frextents:
>  	if (rtxdelta)
> -		xfs_mod_frextents(mp, -rtxdelta);
> +		xfs_sb_mod64(&mp->m_sb.sb_frextents, -rtxdelta);
>  out_undo_ifree:
> +	spin_unlock(&mp->m_sb_lock);
>  	if (ifreedelta)
>  		xfs_mod_ifree(mp, -ifreedelta);
>  out_undo_icount:
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
