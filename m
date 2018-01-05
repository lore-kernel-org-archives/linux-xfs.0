Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47558 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbeAENIc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jan 2018 08:08:32 -0500
Date: Fri, 5 Jan 2018 08:08:31 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: hoist xfs_fs_geometry to libxfs
Message-ID: <20180105130830.GB27973@bfoster.bfoster>
References: <151512356118.14363.7797314285394643799.stgit@magnolia>
 <151512358515.14363.15388539486249607694.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151512358515.14363.15388539486249607694.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 04, 2018 at 07:39:45PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move xfs_fs_geometry to libxfs so that we can clean up the fs geometry
> reporting in xfsprogs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Looks like a straightforward move:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_sb.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_sb.h |    3 ++
>  fs/xfs/xfs_fsops.c     |   77 -----------------------------------------------
>  fs/xfs/xfs_fsops.h     |    1 -
>  fs/xfs/xfs_ioctl.c     |    1 +
>  fs/xfs/xfs_ioctl32.c   |    1 +
>  6 files changed, 84 insertions(+), 78 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 63e0331..139517a 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -40,6 +40,8 @@
>  #include "xfs_rmap_btree.h"
>  #include "xfs_bmap.h"
>  #include "xfs_refcount_btree.h"
> +#include "xfs_da_format.h"
> +#include "xfs_da_btree.h"
>  
>  /*
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
> @@ -874,3 +876,80 @@ xfs_sync_sb(
>  		xfs_trans_set_sync(tp);
>  	return xfs_trans_commit(tp);
>  }
> +
> +int
> +xfs_fs_geometry(
> +	xfs_mount_t		*mp,
> +	xfs_fsop_geom_t		*geo,
> +	int			new_version)
> +{
> +
> +	memset(geo, 0, sizeof(*geo));
> +
> +	geo->blocksize = mp->m_sb.sb_blocksize;
> +	geo->rtextsize = mp->m_sb.sb_rextsize;
> +	geo->agblocks = mp->m_sb.sb_agblocks;
> +	geo->agcount = mp->m_sb.sb_agcount;
> +	geo->logblocks = mp->m_sb.sb_logblocks;
> +	geo->sectsize = mp->m_sb.sb_sectsize;
> +	geo->inodesize = mp->m_sb.sb_inodesize;
> +	geo->imaxpct = mp->m_sb.sb_imax_pct;
> +	geo->datablocks = mp->m_sb.sb_dblocks;
> +	geo->rtblocks = mp->m_sb.sb_rblocks;
> +	geo->rtextents = mp->m_sb.sb_rextents;
> +	geo->logstart = mp->m_sb.sb_logstart;
> +	ASSERT(sizeof(geo->uuid) == sizeof(mp->m_sb.sb_uuid));
> +	memcpy(geo->uuid, &mp->m_sb.sb_uuid, sizeof(mp->m_sb.sb_uuid));
> +	if (new_version >= 2) {
> +		geo->sunit = mp->m_sb.sb_unit;
> +		geo->swidth = mp->m_sb.sb_width;
> +	}
> +	if (new_version >= 3) {
> +		geo->version = XFS_FSOP_GEOM_VERSION;
> +		geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
> +			     XFS_FSOP_GEOM_FLAGS_DIRV2 |
> +			(xfs_sb_version_hasattr(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_ATTR : 0) |
> +			(xfs_sb_version_hasquota(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_QUOTA : 0) |
> +			(xfs_sb_version_hasalign(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_IALIGN : 0) |
> +			(xfs_sb_version_hasdalign(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_DALIGN : 0) |
> +			(xfs_sb_version_hasextflgbit(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_EXTFLG : 0) |
> +			(xfs_sb_version_hassector(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_SECTOR : 0) |
> +			(xfs_sb_version_hasasciici(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_DIRV2CI : 0) |
> +			(xfs_sb_version_haslazysbcount(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_LAZYSB : 0) |
> +			(xfs_sb_version_hasattr2(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_ATTR2 : 0) |
> +			(xfs_sb_version_hasprojid32bit(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_PROJID32 : 0) |
> +			(xfs_sb_version_hascrc(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_V5SB : 0) |
> +			(xfs_sb_version_hasftype(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_FTYPE : 0) |
> +			(xfs_sb_version_hasfinobt(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_FINOBT : 0) |
> +			(xfs_sb_version_hassparseinodes(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_SPINODES : 0) |
> +			(xfs_sb_version_hasrmapbt(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_RMAPBT : 0) |
> +			(xfs_sb_version_hasreflink(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_REFLINK : 0);
> +		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
> +				mp->m_sb.sb_logsectsize : BBSIZE;
> +		geo->rtsectsize = mp->m_sb.sb_blocksize;
> +		geo->dirblocksize = mp->m_dir_geo->blksize;
> +	}
> +	if (new_version >= 4) {
> +		geo->flags |=
> +			(xfs_sb_version_haslogv2(&mp->m_sb) ?
> +				XFS_FSOP_GEOM_FLAGS_LOGV2 : 0);
> +		geo->logsunit = mp->m_sb.sb_logsunit;
> +	}
> +	return 0;
> +}
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 961e647..a16632c 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -34,4 +34,7 @@ extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
>  extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
>  extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
>  
> +extern int	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
> +				int nversion);
> +
>  #endif	/* __XFS_SB_H__ */
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 60a2e12..84d7383 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -49,83 +49,6 @@
>   * File system operations
>   */
>  
> -int
> -xfs_fs_geometry(
> -	xfs_mount_t		*mp,
> -	xfs_fsop_geom_t		*geo,
> -	int			new_version)
> -{
> -
> -	memset(geo, 0, sizeof(*geo));
> -
> -	geo->blocksize = mp->m_sb.sb_blocksize;
> -	geo->rtextsize = mp->m_sb.sb_rextsize;
> -	geo->agblocks = mp->m_sb.sb_agblocks;
> -	geo->agcount = mp->m_sb.sb_agcount;
> -	geo->logblocks = mp->m_sb.sb_logblocks;
> -	geo->sectsize = mp->m_sb.sb_sectsize;
> -	geo->inodesize = mp->m_sb.sb_inodesize;
> -	geo->imaxpct = mp->m_sb.sb_imax_pct;
> -	geo->datablocks = mp->m_sb.sb_dblocks;
> -	geo->rtblocks = mp->m_sb.sb_rblocks;
> -	geo->rtextents = mp->m_sb.sb_rextents;
> -	geo->logstart = mp->m_sb.sb_logstart;
> -	ASSERT(sizeof(geo->uuid)==sizeof(mp->m_sb.sb_uuid));
> -	memcpy(geo->uuid, &mp->m_sb.sb_uuid, sizeof(mp->m_sb.sb_uuid));
> -	if (new_version >= 2) {
> -		geo->sunit = mp->m_sb.sb_unit;
> -		geo->swidth = mp->m_sb.sb_width;
> -	}
> -	if (new_version >= 3) {
> -		geo->version = XFS_FSOP_GEOM_VERSION;
> -		geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
> -			     XFS_FSOP_GEOM_FLAGS_DIRV2 |
> -			(xfs_sb_version_hasattr(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_ATTR : 0) |
> -			(xfs_sb_version_hasquota(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_QUOTA : 0) |
> -			(xfs_sb_version_hasalign(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_IALIGN : 0) |
> -			(xfs_sb_version_hasdalign(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_DALIGN : 0) |
> -			(xfs_sb_version_hasextflgbit(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_EXTFLG : 0) |
> -			(xfs_sb_version_hassector(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_SECTOR : 0) |
> -			(xfs_sb_version_hasasciici(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_DIRV2CI : 0) |
> -			(xfs_sb_version_haslazysbcount(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_LAZYSB : 0) |
> -			(xfs_sb_version_hasattr2(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_ATTR2 : 0) |
> -			(xfs_sb_version_hasprojid32bit(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_PROJID32 : 0) |
> -			(xfs_sb_version_hascrc(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_V5SB : 0) |
> -			(xfs_sb_version_hasftype(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_FTYPE : 0) |
> -			(xfs_sb_version_hasfinobt(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_FINOBT : 0) |
> -			(xfs_sb_version_hassparseinodes(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_SPINODES : 0) |
> -			(xfs_sb_version_hasrmapbt(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_RMAPBT : 0) |
> -			(xfs_sb_version_hasreflink(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_REFLINK : 0);
> -		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
> -				mp->m_sb.sb_logsectsize : BBSIZE;
> -		geo->rtsectsize = mp->m_sb.sb_blocksize;
> -		geo->dirblocksize = mp->m_dir_geo->blksize;
> -	}
> -	if (new_version >= 4) {
> -		geo->flags |=
> -			(xfs_sb_version_haslogv2(&mp->m_sb) ?
> -				XFS_FSOP_GEOM_FLAGS_LOGV2 : 0);
> -		geo->logsunit = mp->m_sb.sb_logsunit;
> -	}
> -	return 0;
> -}
> -
>  static struct xfs_buf *
>  xfs_growfs_get_hdr_buf(
>  	struct xfs_mount	*mp,
> diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> index 2954c13..20484ed 100644
> --- a/fs/xfs/xfs_fsops.h
> +++ b/fs/xfs/xfs_fsops.h
> @@ -18,7 +18,6 @@
>  #ifndef __XFS_FSOPS_H__
>  #define	__XFS_FSOPS_H__
>  
> -extern int xfs_fs_geometry(xfs_mount_t *mp, xfs_fsop_geom_t *geo, int nversion);
>  extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
>  extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
>  extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 20dc65f..3015e17 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -45,6 +45,7 @@
>  #include <linux/fsmap.h>
>  #include "xfs_fsmap.h"
>  #include "scrub/xfs_scrub.h"
> +#include "xfs_sb.h"
>  
>  #include <linux/capability.h>
>  #include <linux/cred.h>
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 35c79e2..66cc3cd 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -37,6 +37,7 @@
>  #include "xfs_ioctl.h"
>  #include "xfs_ioctl32.h"
>  #include "xfs_trace.h"
> +#include "xfs_sb.h"
>  
>  #define  _NATIVE_IOC(cmd, type) \
>  	  _IOC(_IOC_DIR(cmd), _IOC_TYPE(cmd), _IOC_NR(cmd), sizeof(type))
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
