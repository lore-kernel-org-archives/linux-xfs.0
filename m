Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB3A87F9B
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 09:35:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA384304039
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:35:13 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2Vzq9IGjiFCMK0CV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 07:35:12 -0800 (PST)
Date: Thu, 29 Jan 2015 10:35:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/9] xfs: kill xfs_ioctl_setattr behaviour mask
Message-ID: <20150129153500.GE17652@laptop.bfoster>
References: <1422328486-24661-1-git-send-email-david@fromorbit.com>
	<1422328486-24661-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1422328486-24661-6-git-send-email-david@fromorbit.com>
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
Cc: iustin@k1024.org, xfs@oss.sgi.com

On Tue, Jan 27, 2015 at 02:14:42PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now there is only one caller to xfs_ioctl_setattr that uses all the
> functionality of the function we can kill the behviour mask and
> start cleaning up the code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c | 168 +++++++++++++++++++++--------------------------------
>  1 file changed, 65 insertions(+), 103 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index c71f32d..563d2b4 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1098,15 +1098,10 @@ out_cancel:
>  	return ERR_PTR(error);
>  }
>  
> -#define FSX_PROJID	1
> -#define FSX_EXTSIZE	2
> -#define FSX_XFLAGS	4
> -
>  STATIC int
>  xfs_ioctl_setattr(
>  	xfs_inode_t		*ip,
> -	struct fsxattr		*fa,
> -	int			mask)
> +	struct fsxattr		*fa)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
> @@ -1120,8 +1115,8 @@ xfs_ioctl_setattr(
>  	/*
>  	 * Disallow 32bit project ids when projid32bit feature is not enabled.
>  	 */
> -	if ((mask & FSX_PROJID) && (fa->fsx_projid > (__uint16_t)-1) &&
> -			!xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
> +	if (fa->fsx_projid > (__uint16_t)-1 &&
> +	    !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
>  		return -EINVAL;
>  
>  	/*
> @@ -1132,7 +1127,7 @@ xfs_ioctl_setattr(
>  	 * If the IDs do change before we take the ilock, we're covered
>  	 * because the i_*dquot fields will get updated anyway.
>  	 */
> -	if (XFS_IS_QUOTA_ON(mp) && (mask & FSX_PROJID)) {
> +	if (XFS_IS_QUOTA_ON(mp)) {
>  		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
>  					 ip->i_d.di_gid, fa->fsx_projid,
>  					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
> @@ -1149,72 +1144,53 @@ xfs_ioctl_setattr(
>  	 * Only allow changing of projid from init_user_ns since it is a
>  	 * non user namespace aware identifier.
>  	 */
> -	if (mask & FSX_PROJID) {
> -		if (current_user_ns() != &init_user_ns) {
> -			code = -EINVAL;
> -			goto error_return;
> -		}
> -
> -		if (XFS_IS_QUOTA_RUNNING(mp) &&
> -		    XFS_IS_PQUOTA_ON(mp) &&
> -		    xfs_get_projid(ip) != fa->fsx_projid) {
> -			ASSERT(tp);
> -			code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL,
> -						pdqp, capable(CAP_FOWNER) ?
> -						XFS_QMOPT_FORCE_RES : 0);
> -			if (code)	/* out of quota */
> -				goto error_return;
> -		}
> +	if (current_user_ns() != &init_user_ns) {
> +		code = -EINVAL;
> +		goto error_return;
>  	}
>  
> -	if (mask & FSX_EXTSIZE) {
> -		/*
> -		 * Can't change extent size if any extents are allocated.
> -		 */
> -		if (ip->i_d.di_nextents &&
> -		    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) !=
> -		     fa->fsx_extsize)) {
> -			code = -EINVAL;	/* EFBIG? */
> +	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
> +	    xfs_get_projid(ip) != fa->fsx_projid) {
> +		code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL, pdqp,
> +				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
> +		if (code)	/* out of quota */
>  			goto error_return;
> -		}
> +	}
>  
> -		/*
> -		 * Extent size must be a multiple of the appropriate block
> -		 * size, if set at all. It must also be smaller than the
> -		 * maximum extent size supported by the filesystem.
> -		 *
> -		 * Also, for non-realtime files, limit the extent size hint to
> -		 * half the size of the AGs in the filesystem so alignment
> -		 * doesn't result in extents larger than an AG.
> -		 */
> -		if (fa->fsx_extsize != 0) {
> -			xfs_extlen_t    size;
> -			xfs_fsblock_t   extsize_fsb;
> +	/* Can't change extent size if any extents are allocated. */
> +	code = -EINVAL;
> +	if (ip->i_d.di_nextents &&
> +	    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
> +		goto error_return;
>  
> -			extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
> -			if (extsize_fsb > MAXEXTLEN) {
> -				code = -EINVAL;
> -				goto error_return;
> -			}
> -
> -			if (XFS_IS_REALTIME_INODE(ip) ||
> -			    ((mask & FSX_XFLAGS) &&
> -			    (fa->fsx_xflags & XFS_XFLAG_REALTIME))) {
> -				size = mp->m_sb.sb_rextsize <<
> -				       mp->m_sb.sb_blocklog;
> -			} else {
> -				size = mp->m_sb.sb_blocksize;
> -				if (extsize_fsb > mp->m_sb.sb_agblocks / 2) {
> -					code = -EINVAL;
> -					goto error_return;
> -				}
> -			}
> -
> -			if (fa->fsx_extsize % size) {
> -				code = -EINVAL;
> +	/*
> +	 * Extent size must be a multiple of the appropriate block size, if set
> +	 * at all. It must also be smaller than the maximum extent size
> +	 * supported by the filesystem.
> +	 *
> +	 * Also, for non-realtime files, limit the extent size hint to half the
> +	 * size of the AGs in the filesystem so alignment doesn't result in
> +	 * extents larger than an AG.
> +	 */
> +	if (fa->fsx_extsize != 0) {
> +		xfs_extlen_t    size;
> +		xfs_fsblock_t   extsize_fsb;
> +
> +		extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
> +		if (extsize_fsb > MAXEXTLEN)
> +			goto error_return;
> +
> +		if (XFS_IS_REALTIME_INODE(ip) ||
> +		    (fa->fsx_xflags & XFS_XFLAG_REALTIME)) {
> +			size = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> +		} else {
> +			size = mp->m_sb.sb_blocksize;
> +			if (extsize_fsb > mp->m_sb.sb_agblocks / 2)
>  				goto error_return;
> -			}
>  		}
> +
> +		if (fa->fsx_extsize % size)
> +			goto error_return;
>  	}
>  
>  
> @@ -1223,32 +1199,25 @@ xfs_ioctl_setattr(
>  		goto error_return;
>  
>  	/*
> -	 * Change file ownership.  Must be the owner or privileged.
> +	 * Change file ownership.  Must be the owner or privileged.  CAP_FSETID
> +	 * overrides the following restrictions:
> +	 *
> +	 * The set-user-ID and set-group-ID bits of a file will be cleared upon
> +	 * successful return from chown()
>  	 */
> -	if (mask & FSX_PROJID) {
> -		/*
> -		 * CAP_FSETID overrides the following restrictions:
> -		 *
> -		 * The set-user-ID and set-group-ID bits of a file will be
> -		 * cleared upon successful return from chown()
> -		 */
> -		if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
> -		    !capable_wrt_inode_uidgid(VFS_I(ip), CAP_FSETID))
> -			ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
>  
> -		/*
> -		 * Change the ownerships and register quota modifications
> -		 * in the transaction.
> -		 */
> -		if (xfs_get_projid(ip) != fa->fsx_projid) {
> -			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
> -				olddquot = xfs_qm_vop_chown(tp, ip,
> -							&ip->i_pdquot, pdqp);
> -			}
> -			ASSERT(ip->i_d.di_version > 1);
> -			xfs_set_projid(ip, fa->fsx_projid);
> -		}
> +	if ((ip->i_d.di_mode & (S_ISUID|S_ISGID)) &&
> +	    !capable_wrt_inode_uidgid(VFS_I(ip), CAP_FSETID))
> +		ip->i_d.di_mode &= ~(S_ISUID|S_ISGID);
>  
> +	/* Change the ownerships and register project quota modifications */
> +	if (xfs_get_projid(ip) != fa->fsx_projid) {
> +		if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
> +			olddquot = xfs_qm_vop_chown(tp, ip,
> +						&ip->i_pdquot, pdqp);
> +		}
> +		ASSERT(ip->i_d.di_version > 1);
> +		xfs_set_projid(ip, fa->fsx_projid);
>  	}
>  
>  	/*
> @@ -1256,14 +1225,10 @@ xfs_ioctl_setattr(
>  	 * extent size hint should be set on the inode. If no extent size flags
>  	 * are set on the inode then unconditionally clear the extent size hint.
>  	 */
> -	if (mask & FSX_EXTSIZE) {
> -		int	extsize = 0;
> -
> -		if (ip->i_d.di_flags &
> -				(XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
> -			extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
> -		ip->i_d.di_extsize = extsize;
> -	}
> +	if (ip->i_d.di_flags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
> +		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
> +	else
> +		ip->i_d.di_extsize = 0;
>  
>  	code = xfs_trans_commit(tp, 0);
>  
> @@ -1290,18 +1255,15 @@ xfs_ioc_fssetxattr(
>  	void			__user *arg)
>  {
>  	struct fsxattr		fa;
> -	unsigned int		mask;
>  	int error;
>  
>  	if (copy_from_user(&fa, arg, sizeof(fa)))
>  		return -EFAULT;
>  
> -	mask = FSX_XFLAGS | FSX_EXTSIZE | FSX_PROJID;
> -
>  	error = mnt_want_write_file(filp);
>  	if (error)
>  		return error;
> -	error = xfs_ioctl_setattr(ip, &fa, mask);
> +	error = xfs_ioctl_setattr(ip, &fa);
>  	mnt_drop_write_file(filp);
>  	return error;
>  }
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
