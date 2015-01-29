Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E8F1D7F92
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 09:34:47 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6833BAC002
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:34:47 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1cEqo49Y6mP4Qb7l (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 07:34:46 -0800 (PST)
Date: Thu, 29 Jan 2015 10:34:36 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/9] xfs: factor out xfs_ioctl_setattr transaciton preamble
Message-ID: <20150129153436.GC17652@laptop.bfoster>
References: <1422328486-24661-1-git-send-email-david@fromorbit.com>
	<1422328486-24661-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1422328486-24661-4-git-send-email-david@fromorbit.com>
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

On Tue, Jan 27, 2015 at 02:14:40PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The setup of the transaction is done after a random smattering of
> checks and before another bunch of ioperations specific
> validity checks. Pull all the preamble out into a helper function
> that returns a transaction or error.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_ioctl.c | 96 +++++++++++++++++++++++++++++-------------------------
>  1 file changed, 51 insertions(+), 45 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index ba98412..d06f596 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1042,7 +1042,6 @@ xfs_ioctl_setattr_xflags(
>  	    !capable(CAP_LINUX_IMMUTABLE))
>  		return -EPERM;
>  
> -	xfs_trans_ijoin(tp, ip, 0);
>  	xfs_set_diflags(ip, fa->fsx_xflags);
>  	xfs_diflags_to_linux(ip);
>  	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
> @@ -1051,6 +1050,54 @@ xfs_ioctl_setattr_xflags(
>  	return 0;
>  }
>  
> +/*
> + * Set up the transaction structure for the setattr operation, checking that we
> + * have permission to do so. On success, return a clean transaction and the
> + * inode locked exclusively ready for futher operation specific checks. On

					further

> + * failure, return an error without modifying or locking the inode.
> + */
> +static struct xfs_trans *
> +xfs_ioctl_setattr_get_trans(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
> +	int			error;
> +
> +	if (mp->m_flags & XFS_MOUNT_RDONLY)
> +		return ERR_PTR(-EROFS);
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return ERR_PTR(-EIO);
> +
> +	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
> +	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
> +	if (error)
> +		goto out_cancel;
> +
> +	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +
> +	/*
> +	 * CAP_FOWNER overrides the following restrictions:
> +	 *
> +	 * The user ID of the calling process must be equal to the file owner
> +	 * ID, except in cases where the CAP_FSETID capability is applicable.
> +	 */
> +	if (!inode_owner_or_capable(VFS_I(ip))) {
> +		error = -EPERM;
> +		goto out_cancel;
> +	}
> +
> +	if (mp->m_flags & XFS_MOUNT_WSYNC)
> +		xfs_trans_set_sync(tp);
> +
> +	return tp;
> +
> +out_cancel:
> +	xfs_trans_cancel(tp, 0);
> +	return ERR_PTR(error);
> +}
> +
>  #define FSX_PROJID	1
>  #define FSX_EXTSIZE	2
>  #define FSX_XFLAGS	4
> @@ -1063,7 +1110,6 @@ xfs_ioctl_setattr(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
> -	unsigned int		lock_flags = 0;
>  	struct xfs_dquot	*udqp = NULL;
>  	struct xfs_dquot	*pdqp = NULL;
>  	struct xfs_dquot	*olddquot = NULL;
> @@ -1071,11 +1117,6 @@ xfs_ioctl_setattr(
>  
>  	trace_xfs_ioctl_setattr(ip);
>  
> -	if (mp->m_flags & XFS_MOUNT_RDONLY)
> -		return -EROFS;
> -	if (XFS_FORCED_SHUTDOWN(mp))
> -		return -EIO;
> -
>  	/*
>  	 * Disallow 32bit project ids when projid32bit feature is not enabled.
>  	 */
> @@ -1099,29 +1140,9 @@ xfs_ioctl_setattr(
>  			return code;
>  	}
>  
> -	/*
> -	 * For the other attributes, we acquire the inode lock and
> -	 * first do an error checking pass.
> -	 */
> -	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
> -	code = xfs_trans_reserve(tp, &M_RES(mp)->tr_ichange, 0, 0);
> -	if (code)
> -		goto error_return;
> -
> -	lock_flags = XFS_ILOCK_EXCL;
> -	xfs_ilock(ip, lock_flags);
> -
> -	/*
> -	 * CAP_FOWNER overrides the following restrictions:
> -	 *
> -	 * The user ID of the calling process must be equal
> -	 * to the file owner ID, except in cases where the
> -	 * CAP_FSETID capability is applicable.
> -	 */
> -	if (!inode_owner_or_capable(VFS_I(ip))) {
> -		code = -EPERM;
> -		goto error_return;
> -	}
> +	tp = xfs_ioctl_setattr_get_trans(ip);
> +	if (IS_ERR(tp))
> +		return PTR_ERR(tp);
>   

We need to handle udqp and pdqp in this failure case. The rest looks Ok
to me.

Brian

>  	/*
>  	 * Do a quota reservation only if projid is actually going to change.
> @@ -1244,20 +1265,7 @@ xfs_ioctl_setattr(
>  		ip->i_d.di_extsize = extsize;
>  	}
>  
> -	/*
> -	 * If this is a synchronous mount, make sure that the
> -	 * transaction goes to disk before returning to the user.
> -	 * This is slightly sub-optimal in that truncates require
> -	 * two sync transactions instead of one for wsync filesystems.
> -	 * One for the truncate and one for the timestamps since we
> -	 * don't want to change the timestamps unless we're sure the
> -	 * truncate worked.  Truncates are less than 1% of the laddis
> -	 * mix so this probably isn't worth the trouble to optimize.
> -	 */
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> -		xfs_trans_set_sync(tp);
>  	code = xfs_trans_commit(tp, 0);
> -	xfs_iunlock(ip, lock_flags);
>  
>  	/*
>  	 * Release any dquot(s) the inode had kept before chown.
> @@ -1272,8 +1280,6 @@ xfs_ioctl_setattr(
>  	xfs_qm_dqrele(udqp);
>  	xfs_qm_dqrele(pdqp);
>  	xfs_trans_cancel(tp, 0);
> -	if (lock_flags)
> -		xfs_iunlock(ip, lock_flags);
>  	return code;
>  }
>  
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
