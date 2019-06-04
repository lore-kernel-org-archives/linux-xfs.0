Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35136 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbfFDARs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 20:17:48 -0400
Date: Tue, 4 Jun 2019 10:17:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: refactor inode geometry setup routines
Message-ID: <20190604001743.GJ29573@dread.disaster.area>
References: <155960225918.1194435.11314723160642989835.stgit@magnolia>
 <155960227220.1194435.7625646115020669657.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155960227220.1194435.7625646115020669657.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jun 03, 2019 at 03:51:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Migrate all of the inode geometry setup code from xfs_mount.c into a
> single libxfs function that we can share with xfsprogs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c |   90 +++++++++++++++++++++++++++++++++++++-------
>  fs/xfs/libxfs/xfs_ialloc.h |    8 ----
>  fs/xfs/xfs_mount.c         |   83 -----------------------------------------
>  3 files changed, 78 insertions(+), 103 deletions(-)

I probably would have moved it to libxfs/xfs_inode_buf.c and
named it xfs_inode_setup_geometry(), but moving it here has some
advantages so I'm happy to leave it here. :)

> 
> - * Compute and fill in value of m_ino_geo.inobt_maxlevels.
> - */
> -void
> -xfs_ialloc_compute_maxlevels(
> -	xfs_mount_t	*mp)		/* file system mount structure */
> -{
> -	uint		inodes;
> -
> -	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
> -	M_IGEO(mp)->inobt_maxlevels = xfs_btree_compute_maxlevels(
> -			M_IGEO(mp)->inobt_mnr, inodes);
> -}
> -
>  /*
>   * Log specified fields for the ag hdr (inode section). The growth of the agi
>   * structure over time requires that we interpret the buffer as two logical
> @@ -2773,3 +2759,79 @@ xfs_ialloc_count_inodes(
>  	*freecount = ci.freecount;
>  	return 0;
>  }
> +
> +/*
> + * Initialize inode-related geometry information.
> + *
> + * Compute the inode btree min and max levels and set maxicount.
> + *
> + * Set the inode cluster size.  This may still be overridden by the file
> + * system block size if it is larger than the chosen cluster size.
> + *
> + * For v5 filesystems, scale the cluster size with the inode size to keep a
> + * constant ratio of inode per cluster buffer, but only if mkfs has set the
> + * inode alignment value appropriately for larger cluster sizes.
> + *
> + * Then compute the inode cluster alignment information.
> + */
> +void
> +xfs_ialloc_setup_geometry(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> +	uint64_t		icount;
> +	uint			inodes;
> +
> +	/* Compute and fill in value of m_ino_geo.inobt_maxlevels. */
> +	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
> +	igeo->inobt_maxlevels = xfs_btree_compute_maxlevels(igeo->inobt_mnr,
> +			inodes);

Hmmm - any reason why you didn't move the inobt_mnr/mxr
initalisation here as well?

> +
> +	/* Set the maximum inode count for this filesystem. */
> +	if (sbp->sb_imax_pct) {
> +		/*
> +		 * Make sure the maximum inode count is a multiple
> +		 * of the units we allocate inodes in.
> +		 */
> +		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
> +		do_div(icount, 100);
> +		do_div(icount, igeo->ialloc_blks);
> +		igeo->maxicount = XFS_FSB_TO_INO(mp,
> +				icount * igeo->ialloc_blks);
> +	} else {
> +		igeo->maxicount = 0;
> +	}
> +
> +	igeo->inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
> +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		int	new_size = igeo->inode_cluster_size;
> +
> +		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
> +		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
> +			igeo->inode_cluster_size = new_size;
> +	}
> +	igeo->blocks_per_cluster = xfs_icluster_size_fsb(mp);
> +	igeo->inodes_per_cluster = XFS_FSB_TO_INO(mp,
> +			igeo->blocks_per_cluster);
> +	igeo->cluster_align = xfs_ialloc_cluster_alignment(mp);

I'll comment on xfs_icluster_size_fsb() and
xfs_ialloc_cluster_alignment() here knowing that you make them
private/static in the next patch: I'd actually remove them and open
code them here. xfs_icluster_size_fsb() is only called from this
function and xfs_ialloc_cluster_alignment(), and
xfs_ialloc_cluster_alignment() is only called from here.

Given that they are both very short functions, I'd just open code
them directly here and get rid of them completely like you have with
xfs_ialloc_compute_maxlevels(). That way everyone is kinda forced to
use the pre-calculated geometry rather than trying to do it
themselves and maybe get it wrong...

Otherwise than that, this looks good....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
