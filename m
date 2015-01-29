Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BAE7929DF7
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 09:36:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 74891304053
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 07:36:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 95Ak0CrQ2tPtBXGs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 07:36:01 -0800 (PST)
Date: Thu, 29 Jan 2015 10:35:49 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 9/9] xfs: fix behaviour of XFS_IOC_FSSETXATTR on
	directories
Message-ID: <20150129153549.GI17652@laptop.bfoster>
References: <1422328486-24661-1-git-send-email-david@fromorbit.com>
	<1422328486-24661-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1422328486-24661-10-git-send-email-david@fromorbit.com>
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

On Tue, Jan 27, 2015 at 02:14:46PM +1100, Dave Chinner wrote:
> From: Iustin Pop <iustin@k1024.org>
> 
> Currently, the ioctl handling code for XFS_IOC_FSSETXATTR treats all
> targets as regular files: it refuses to change the extent size if
> extents are allocated. This is wrong for directories, as there the
> extent size is only used as a default for children.
> 
> The patch fixes this issue and improves validation of flag
> combinations:
> 
> - only disallow extent size changes after extents have been allocated
>   for regular files
> - only allow XFS_XFLAG_EXTSIZE for regular files
> - only allow XFS_XFLAG_EXTSZINHERIT for directories
> - automatically clear the flags if the extent size is zero
> 
> Thanks to Dave Chinner for guidance on the proper fix for this issue.
> 
> [dchinner: ported changes onto cleanup series. Makes changes clear
> 	   and obvious.]
> [dchinner: added comments documenting validity checking rules.]
> 
> Signed-off-by: Iustin Pop <iustin@k1024.org>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c | 39 +++++++++++++++++++++++++--------------
>  1 file changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 561d142..5d9dc69 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1098,6 +1098,20 @@ out_cancel:
>  	return ERR_PTR(error);
>  }
>  
> +/*
> + * extent size hint validation is somewhat cumbersome. Rules are:
> + *
> + * 1. extent size hint is only valid for directories and regular files
> + * 2. XFS_XFLAG_EXTSIZE is only valid for regular files
> + * 3. XFS_XFLAG_EXTSZINHERIT is only valid for directories.
> + * 4. can only be changed on regular files if no extents are allocated
> + * 5. can be changed on directories at any time
> + * 6. extsize hint of 0 turns off hints, clears inode flags.
> + * 7. Extent size must be a multiple of the appropriate block size.
> + * 8. for non-realtime files, the extent size hint must be limited
> + *    to half the AG size to avoid alignment extending the extent beyond the
> + *    limits of the AG.
> + */
>  int
>  xfs_ioctl_setattr_check_extsize(
>  	struct xfs_inode	*ip,
> @@ -1105,20 +1119,17 @@ xfs_ioctl_setattr_check_extsize(
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  
> -	/* Can't change extent size if any extents are allocated. */
> -	if (ip->i_d.di_nextents &&
> +	if ((fa->fsx_xflags & XFS_XFLAG_EXTSIZE) && !S_ISREG(ip->i_d.di_mode))
> +		return -EINVAL;
> +
> +	if ((fa->fsx_xflags & XFS_XFLAG_EXTSZINHERIT) &&
> +	    !S_ISDIR(ip->i_d.di_mode))
> +		return -EINVAL;
> +
> +	if (S_ISREG(ip->i_d.di_mode) && ip->i_d.di_nextents &&
>  	    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
>  		return -EINVAL;
>  
> -	/*
> -	 * Extent size must be a multiple of the appropriate block size, if set
> -	 * at all. It must also be smaller than the maximum extent size
> -	 * supported by the filesystem.
> -	 *
> -	 * Also, for non-realtime files, limit the extent size hint to half the
> -	 * size of the AGs in the filesystem so alignment doesn't result in
> -	 * extents larger than an AG.
> -	 */
>  	if (fa->fsx_extsize != 0) {
>  		xfs_extlen_t    size;
>  		xfs_fsblock_t   extsize_fsb;
> @@ -1138,7 +1149,9 @@ xfs_ioctl_setattr_check_extsize(
>  
>  		if (fa->fsx_extsize % size)
>  			return -EINVAL;
> -	}
> +	} else
> +		fa->fsx_xflags &= ~(XFS_XFLAG_EXTSIZE | XFS_XFLAG_EXTSZINHERIT);
> +
>  	return 0;
>  }
>  
> @@ -1169,8 +1182,6 @@ xfs_ioctl_setattr_check_projid(
>  	return 0;
>  }
>  
> -
> -
>  STATIC int
>  xfs_ioctl_setattr(
>  	xfs_inode_t		*ip,
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
