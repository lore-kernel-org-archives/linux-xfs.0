Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 774227F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 07:54:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4289E8F804B
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 05:53:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rKzP6EmoUGXwMC13 for
	<xfs@oss.sgi.com>; Thu, 24 Apr 2014 05:53:58 -0700 (PDT)
Date: Thu, 24 Apr 2014 08:53:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [3.15-rc4 PATCH] xfs: fully support v5 format filesystems
Message-ID: <20140424125354.GD51140@bfoster.bfoster>
References: <1398324998-2592-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1398324998-2592-1-git-send-email-david@fromorbit.com>
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

On Thu, Apr 24, 2014 at 05:36:38PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We have had this code in the kernel for over a year now and have
> shaken all the known issues out of the code over the past few
> releases. It's now time to remove the experimental warnings during
> mount and fully support the new filesystem format in production
> systems.
> 
> Remove the experimental warning, and add a version number to the
> initial "mounting filesystem" message to tell use what type of
> filesystem is being mounted. Also, remove the temporary inode
> cluster size output at mount time now we know that this code works
> fine.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Seems reasonable to me at this point.

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log.c   | 10 ++++++----
>  fs/xfs/xfs_mount.c |  2 --
>  fs/xfs/xfs_sb.c    |  4 ----
>  3 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 08624dc..a5f8bd9 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -616,11 +616,13 @@ xfs_log_mount(
>  	int		error = 0;
>  	int		min_logfsbs;
>  
> -	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY))
> -		xfs_notice(mp, "Mounting Filesystem");
> -	else {
> +	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
> +		xfs_notice(mp, "Mounting V%d Filesystem",
> +			   XFS_SB_VERSION_NUM(&mp->m_sb));
> +	} else {
>  		xfs_notice(mp,
> -"Mounting filesystem in no-recovery mode.  Filesystem will be inconsistent.");
> +"Mounting V%d filesystem in no-recovery mode. Filesystem will be inconsistent.",
> +			   XFS_SB_VERSION_NUM(&mp->m_sb));
>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
>  	}
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 993cb19..944f3d9 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -743,8 +743,6 @@ xfs_mountfs(
>  		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
>  		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
>  			mp->m_inode_cluster_size = new_size;
> -		xfs_info(mp, "Using inode cluster size of %d bytes",
> -			 mp->m_inode_cluster_size);
>  	}
>  
>  	/*
> diff --git a/fs/xfs/xfs_sb.c b/fs/xfs/xfs_sb.c
> index 0c0e41b..8baf61a 100644
> --- a/fs/xfs/xfs_sb.c
> +++ b/fs/xfs/xfs_sb.c
> @@ -201,10 +201,6 @@ xfs_mount_validate_sb(
>  	 * write validation, we don't need to check feature masks.
>  	 */
>  	if (check_version && XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) {
> -		xfs_alert(mp,
> -"Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!\n"
> -"Use of these features in this kernel is at your own risk!");
> -
>  		if (xfs_sb_has_compat_feature(sbp,
>  					XFS_SB_FEAT_COMPAT_UNKNOWN)) {
>  			xfs_warn(mp,
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
