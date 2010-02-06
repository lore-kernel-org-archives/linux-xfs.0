Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o161euPR178328 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 19:40:56 -0600
Subject: Re: PATCH V2] more reserved blocks fixups
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4B6CA2E9.7020803@sandeen.net>
References: <4B60C8EE.5080700@sandeen.net>  <4B6CA2E9.7020803@sandeen.net>
Date: Fri, 05 Feb 2010 19:41:15 -0600
Message-ID: <1265420475.2714.162.camel@doink1>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Fri, 2010-02-05 at 16:59 -0600, Eric Sandeen wrote:
> This mangles the reserved blocks counts a little more.
> 
> 1) add a helper function for the default reserved count
> 2) add helper functions to save/restore counts on ro/rw
> 3) save/restore reserved blocks on freeze/thaw
> 4) disallow changing reserved count while readonly

Looks good.  Thanks for updating it.

> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
> 
> V2: changed field name to match Dave's changes
> 
> diff --git a/fs/xfs/linux-2.6/xfs_ioctl.c b/fs/xfs/linux-2.6/xfs_ioctl.c
> index a034cf6..883929b 100644
> --- a/fs/xfs/linux-2.6/xfs_ioctl.c
> +++ b/fs/xfs/linux-2.6/xfs_ioctl.c
> @@ -1431,6 +1431,9 @@ xfs_file_ioctl(
>  		if (!capable(CAP_SYS_ADMIN))
>  			return -EPERM;
>  
> +		if (mp->m_flags & XFS_MOUNT_RDONLY)
> +			return -XFS_ERROR(EROFS);
> +
>  		if (copy_from_user(&inout, arg, sizeof(inout)))
>  			return -XFS_ERROR(EFAULT);
>  
> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
> index 8884f26..97c0f5a 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -1257,6 +1257,29 @@ xfs_fs_statfs(
>  	return 0;
>  }
>  
> +STATIC void
> +xfs_save_resvblks(struct xfs_mount *mp)
> +{
> +	__uint64_t resblks = 0;
> +
> +	mp->m_resblks_save = mp->m_resblks;
> +	xfs_reserve_blocks(mp, &resblks, NULL);
> +}
> +
> +STATIC void
> +xfs_restore_resvblks(struct xfs_mount *mp)
> +{
> +	__uint64_t resblks;
> +
> +	if (mp->m_resblks_save) {
> +		resblks = mp->m_resblks_save;
> +		mp->m_resblks_save = 0;
> +	} else
> +		resblks = xfs_default_resblks(mp);
> +
> +	xfs_reserve_blocks(mp, &resblks, NULL);
> +}
> +
>  STATIC int
>  xfs_fs_remount(
>  	struct super_block	*sb,
> @@ -1319,8 +1342,6 @@ xfs_fs_remount(
>  
>  	/* ro -> rw */
>  	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & MS_RDONLY)) {
> -		__uint64_t resblks;
> -
>  		mp->m_flags &= ~XFS_MOUNT_RDONLY;
>  		if (mp->m_flags & XFS_MOUNT_BARRIER)
>  			xfs_mountfs_check_barriers(mp);
> @@ -1343,15 +1364,7 @@ xfs_fs_remount(
>  		 * Fill out the reserve pool if it is empty. Use the stashed
>  		 * value if it is non-zero, otherwise go with the default.
>  		 */
> -		if (mp->m_resblks_save) {
> -			resblks = mp->m_resblks_save;
> -			mp->m_resblks_save = 0;
> -		} else {
> -			resblks = mp->m_sb.sb_dblocks;
> -			do_div(resblks, 20);
> -			resblks = min_t(__uint64_t, resblks, 1024);
> -		}
> -		xfs_reserve_blocks(mp, &resblks, NULL);
> +		xfs_restore_resvblks(mp);
>  	}
>  
>  	/* rw -> ro */
> @@ -1364,11 +1377,9 @@ xfs_fs_remount(
>  		 * so that if we get remounted rw, we can return it to the same
>  		 * size.
>  		 */
> -		__uint64_t resblks = 0;
>  
>  		xfs_quiesce_data(mp);
> -		mp->m_resblks_save = mp->m_resblks;
> -		xfs_reserve_blocks(mp, &resblks, NULL);
> +		xfs_save_resvblks(mp);
>  		xfs_quiesce_attr(mp);
>  		mp->m_flags |= XFS_MOUNT_RDONLY;
>  	}
> @@ -1387,11 +1398,22 @@ xfs_fs_freeze(
>  {
>  	struct xfs_mount	*mp = XFS_M(sb);
>  
> +	xfs_save_resvblks(mp);
>  	xfs_quiesce_attr(mp);
>  	return -xfs_fs_log_dummy(mp);
>  }
>  
>  STATIC int
> +xfs_fs_unfreeze(
> +	struct super_block	*sb)
> +{
> +	struct xfs_mount	*mp = XFS_M(sb);
> +
> +	xfs_restore_resvblks(mp);
> +	return 0;
> +}
> +
> +STATIC int
>  xfs_fs_show_options(
>  	struct seq_file		*m,
>  	struct vfsmount		*mnt)
> @@ -1613,6 +1635,7 @@ static const struct super_operations xfs_super_operations = {
>  	.put_super		= xfs_fs_put_super,
>  	.sync_fs		= xfs_fs_sync_fs,
>  	.freeze_fs		= xfs_fs_freeze,
> +	.unfreeze_fs		= xfs_fs_unfreeze,
>  	.statfs			= xfs_fs_statfs,
>  	.remount_fs		= xfs_fs_remount,
>  	.show_options		= xfs_fs_show_options,
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index eb403b4..48e1ee7 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1008,6 +1008,22 @@ xfs_mount_reset_sbqflags(
>  	return xfs_trans_commit(tp, 0);
>  }
>  
> +__uint64_t
> +xfs_default_resblks(xfs_mount_t *mp)
> +{
> +	__uint64_t resblks;
> +
> +	/*
> +	 * We default to 5% or 1024 fsbs of space reserved, whichever is smaller.
> +	 * This may drive us straight to ENOSPC on mount, but that implies
> +	 * we were already there on the last unmount. Warn if this occurs.
> +	 */
> +	resblks = mp->m_sb.sb_dblocks;
> +	do_div(resblks, 20);
> +	resblks = min_t(__uint64_t, resblks, 1024);
> +	return resblks;
> +}
> +
>  /*
>   * This function does the following on an initial mount of a file system:
>   *	- reads the superblock from disk and init the mount struct
> @@ -1318,18 +1334,14 @@ xfs_mountfs(
>  	 * when at ENOSPC. This is needed for operations like create with
>  	 * attr, unwritten extent conversion at ENOSPC, etc. Data allocations
>  	 * are not allowed to use this reserved space.
> -	 *
> -	 * We default to 5% or 1024 fsbs of space reserved, whichever is smaller.
> -	 * This may drive us straight to ENOSPC on mount, but that implies
> -	 * we were already there on the last unmount. Warn if this occurs.
>  	 */
> -	resblks = mp->m_sb.sb_dblocks;
> -	do_div(resblks, 20);
> -	resblks = min_t(__uint64_t, resblks, 1024);
> -	error = xfs_reserve_blocks(mp, &resblks, NULL);
> -	if (error)
> -		cmn_err(CE_WARN, "XFS: Unable to allocate reserve blocks. "
> -				"Continuing without a reserve pool.");
> +	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
> +		resblks = xfs_default_resblks(mp);
> +		error = xfs_reserve_blocks(mp, &resblks, NULL);
> +		if (error)
> +			cmn_err(CE_WARN, "XFS: Unable to allocate reserve "
> +				"blocks. Continuing without a reserve pool.");
> +	}
>  
>  	return 0;
>  
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 996273d..c8f880d 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -429,6 +429,7 @@ typedef struct xfs_mod_sb {
>  } xfs_mod_sb_t;
>  
>  extern int	xfs_log_sbcount(xfs_mount_t *, uint);
> +extern __uint64_t xfs_default_resblks(xfs_mount_t *mp);
>  extern int	xfs_mountfs(xfs_mount_t *mp);
>  
>  extern void	xfs_unmountfs(xfs_mount_t *);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
