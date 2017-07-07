Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33920 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbdGGMET (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 7 Jul 2017 08:04:19 -0400
Date: Fri, 7 Jul 2017 08:01:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] mkfs: set inode alignment and cluster size for minimum
 log size estimation
Message-ID: <20170707120144.GD61756@bfoster.bfoster>
References: <20170707033138.GC4103@magnolia>
 <20170707035152.GE4103@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170707035152.GE4103@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On Thu, Jul 06, 2017 at 08:51:52PM -0700, Darrick J. Wong wrote:
> In order for mkfs to calculate the minimum log size correctly, it must
> be able to find the transaction type with the largest reservation.  The
> iunlink transaction reservation size calculation depends on having the
> inode cluster size set correctly, which in turn depends on the inode
> alignment parameters being set as they will be in the final filesystem.
> Therefore we have to set up the inoalignmt field in max_trans_res.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  include/xfs_multidisk.h |    2 +-
>  libxfs/init.c           |    7 +++++++
>  mkfs/maxtrres.c         |   10 +++++++++-
>  mkfs/xfs_mkfs.c         |    3 ++-
>  4 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/include/xfs_multidisk.h b/include/xfs_multidisk.h
> index ce9bbce..e5f53b7 100644
> --- a/include/xfs_multidisk.h
> +++ b/include/xfs_multidisk.h
> @@ -69,6 +69,6 @@ extern void res_failed (int err);
>  extern int max_trans_res(unsigned long agsize, int crcs_enabled, int dirversion,
>  		int sectorlog, int blocklog, int inodelog, int dirblocklog,
>  		int logversion, int log_sunit, int finobt, int rmapbt,
> -		int reflink);
> +		int reflink, int inode_align);
>  
>  #endif	/* __XFS_MULTIDISK_H__ */
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 3fb0fdf..d77a9e6 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -707,6 +707,13 @@ libxfs_mount(
>  		mp->m_maxicount = 0;
>  
>  	mp->m_inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		int	new_size = mp->m_inode_cluster_size;
> +
> +		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
> +		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
> +			mp->m_inode_cluster_size = new_size;
> +	}
>  
>  	/*
>  	 * Set whether we're using stripe alignment.
> diff --git a/mkfs/maxtrres.c b/mkfs/maxtrres.c
> index 69ec67a..04028bf 100644
> --- a/mkfs/maxtrres.c
> +++ b/mkfs/maxtrres.c
> @@ -40,7 +40,8 @@ max_trans_res(
>  	int		log_sunit,
>  	int		finobt,
>  	int		rmapbt,
> -	int		reflink)
> +	int		reflink,
> +	int		inode_align)
>  {
>  	xfs_sb_t	*sbp;
>  	xfs_mount_t	mount;
> @@ -61,6 +62,13 @@ max_trans_res(
>  	sbp->sb_inopblock = 1 << (blocklog - inodelog);
>  	sbp->sb_dirblklog = dirblocklog - blocklog;
>  
> +	if (inode_align) {
> +		int	cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
> +		if (crcs_enabled)
> +			cluster_size *= sbp->sb_inodesize / XFS_DINODE_MIN_SIZE;
> +		sbp->sb_inoalignmt = cluster_size >> blocklog;
> +	}
> +
>  	if (log_sunit > 0) {
>  		log_sunit <<= blocklog;
>  		logversion = 2;
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index c839936..faa0e9a 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2612,7 +2612,8 @@ an AG size that is one stripe unit smaller, for example %llu.\n"),
>  				   sb_feat.crcs_enabled, sb_feat.dir_version,
>  				   sectorlog, blocklog, inodelog, dirblocklog,
>  				   sb_feat.log_version, lsunit, sb_feat.finobt,
> -				   sb_feat.rmapbt, sb_feat.reflink);
> +				   sb_feat.rmapbt, sb_feat.reflink,
> +				   sb_feat.inode_align);
>  	ASSERT(min_logblocks);
>  	min_logblocks = MAX(XFS_MIN_LOG_BLOCKS, min_logblocks);
>  	if (!logsize && dblocks >= (1024*1024*1024) >> blocklog)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
