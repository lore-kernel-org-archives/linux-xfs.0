Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 67D908016
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 08:10:42 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 564418F804C
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 06:10:42 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VQqZZnxaiZyzIL3E (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 06:10:41 -0800 (PST)
Date: Thu, 5 Feb 2015 09:10:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/7] xfs: introduce xfs_mod_frextents
Message-ID: <20150205141035.GG31625@laptop.bfoster>
References: <1423083249-27493-1-git-send-email-david@fromorbit.com>
	<1423083249-27493-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423083249-27493-6-git-send-email-david@fromorbit.com>
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

On Thu, Feb 05, 2015 at 07:54:07AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add a new helper to modify the incore counter of free realtime
> extents. This matches the helpers used for inode and data block
> counters, and removes a significant users of the xfs_mod_incore_sb()
> interface.
> 
> Based on a patch originally from Christoph Hellwig.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap.c |  8 +++-----
>  fs/xfs/xfs_mount.c       | 27 +++++++++++++++++++--------
>  fs/xfs/xfs_mount.h       |  2 ++
>  fs/xfs/xfs_trans.c       | 18 ++++++++++--------
>  4 files changed, 34 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index e39c9e8..b8e97fd0 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4158,8 +4158,7 @@ xfs_bmapi_reserve_delalloc(
>  	ASSERT(indlen > 0);
>  
>  	if (rt) {
> -		error = xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS,
> -					  -((int64_t)extsz), 0);
> +		error = xfs_mod_frextents(mp, -((int64_t)extsz));
>  	} else {
>  		error = xfs_mod_fdblocks(mp, -((int64_t)alen), false);
>  	}
> @@ -4194,7 +4193,7 @@ xfs_bmapi_reserve_delalloc(
>  
>  out_unreserve_blocks:
>  	if (rt)
> -		xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS, extsz, 0);
> +		xfs_mod_frextents(mp, extsz);
>  	else
>  		xfs_mod_fdblocks(mp, alen, false);
>  out_unreserve_quota:
> @@ -5278,8 +5277,7 @@ xfs_bunmapi(
>  
>  				rtexts = XFS_FSB_TO_B(mp, del.br_blockcount);
>  				do_div(rtexts, mp->m_sb.sb_rextsize);
> -				xfs_mod_incore_sb(mp, XFS_SBS_FREXTENTS,
> -						(int64_t)rtexts, 0);
> +				xfs_mod_frextents(mp, (int64_t)rtexts);
>  				(void)xfs_trans_reserve_quota_nblks(NULL,
>  					ip, -((long)del.br_blockcount), 0,
>  					XFS_QMOPT_RES_RTBLKS);
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 1d26200..284f528 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1199,6 +1199,24 @@ fdblocks_enospc:
>  	return -ENOSPC;
>  }
>  
> +int
> +xfs_mod_frextents(
> +	struct xfs_mount	*mp,
> +	int64_t			delta)
> +{
> +	int64_t			lcounter;
> +	int			ret = 0;
> +
> +	spin_lock(&mp->m_sb_lock);
> +	lcounter = mp->m_sb.sb_frextents + delta;
> +	if (lcounter < 0)
> +		ret = -ENOSPC;
> +	else
> +		mp->m_sb.sb_frextents = lcounter;
> +	spin_unlock(&mp->m_sb_lock);
> +	return ret;
> +}
> +
>  /*
>   * xfs_mod_incore_sb_unlocked() is a utility routine commonly used to apply
>   * a delta to a specified field in the in-core superblock.  Simply
> @@ -1228,16 +1246,9 @@ xfs_mod_incore_sb_unlocked(
>  	case XFS_SBS_ICOUNT:
>  	case XFS_SBS_IFREE:
>  	case XFS_SBS_FDBLOCKS:
> +	case XFS_SBS_FREXTENTS:
>  		ASSERT(0);
>  		return -EINVAL;
> -	case XFS_SBS_FREXTENTS:
> -		lcounter = (long long)mp->m_sb.sb_frextents;
> -		lcounter += delta;
> -		if (lcounter < 0) {
> -			return -ENOSPC;
> -		}
> -		mp->m_sb.sb_frextents = lcounter;
> -		return 0;
>  	case XFS_SBS_DBLOCKS:
>  		lcounter = (long long)mp->m_sb.sb_dblocks;
>  		lcounter += delta;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index ff1d1d5..8970489 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -320,6 +320,8 @@ extern int	xfs_mod_icount(struct xfs_mount *mp, int64_t delta);
>  extern int	xfs_mod_ifree(struct xfs_mount *mp, int64_t delta);
>  extern int	xfs_mod_fdblocks(struct xfs_mount *mp, int64_t delta,
>  				 bool reserved);
> +extern int	xfs_mod_frextents(struct xfs_mount *mp, int64_t delta);
> +
>  extern int	xfs_mount_log_sb(xfs_mount_t *);
>  extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
>  extern int	xfs_readsb(xfs_mount_t *, int);
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index e99f5e5..4e4bc5a 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -235,8 +235,7 @@ xfs_trans_reserve(
>  	 * fail if the count would go below zero.
>  	 */
>  	if (rtextents > 0) {
> -		error = xfs_mod_incore_sb(tp->t_mountp, XFS_SBS_FREXTENTS,
> -					  -((int64_t)rtextents), rsvd);
> +		error = xfs_mod_frextents(tp->t_mountp, -((int64_t)rtextents));
>  		if (error) {
>  			error = -ENOSPC;
>  			goto undo_log;
> @@ -562,10 +561,10 @@ xfs_trans_unreserve_and_mod_sb(
>  	}
>  
>  	/* apply remaining deltas */
> -	if (rtxdelta != 0) {
> -		msbp->msb_field = XFS_SBS_FREXTENTS;
> -		msbp->msb_delta = rtxdelta;
> -		msbp++;
> +	if (rtxdelta) {
> +		error = xfs_mod_frextents(mp, rtxdelta);
> +		if (error)
> +			goto out_undo_ifree;
>  	}
>  
>  	if (tp->t_flags & XFS_TRANS_SB_DIRTY) {
> @@ -618,12 +617,15 @@ xfs_trans_unreserve_and_mod_sb(
>  		error = xfs_mod_incore_sb_batch(tp->t_mountp, msb,
>  			(uint)(msbp - msb), rsvd);
>  		if (error)
> -			goto out_undo_ifreecount;
> +			goto out_undo_frextents;
>  	}
>  
>  	return;
>  
> -out_undo_ifreecount:
> +out_undo_frextents:
> +	if (rtxdelta)
> +		xfs_mod_frextents(mp, -rtxdelta);
> +out_undo_ifree:
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
