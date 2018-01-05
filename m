Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751487AbeAENIh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jan 2018 08:08:37 -0500
Date: Fri, 5 Jan 2018 08:08:35 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/3] xfs: refactor the geometry structure filling function
Message-ID: <20180105130835.GC27973@bfoster.bfoster>
References: <151512356118.14363.7797314285394643799.stgit@magnolia>
 <151512359134.14363.8696043274247703808.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151512359134.14363.8696043274247703808.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 04, 2018 at 07:39:51PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the geometry structure filling function to use the superblock
> to fill the fields.  While we're at it, make the function less indenty
> and use some whitespace to make the function easier to read.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Nice cleanup...

>  fs/xfs/libxfs/xfs_sb.c |  167 ++++++++++++++++++++++++++++--------------------
>  fs/xfs/libxfs/xfs_sb.h |    5 +
>  fs/xfs/xfs_ioctl.c     |    4 +
>  fs/xfs/xfs_ioctl32.c   |    2 -
>  4 files changed, 103 insertions(+), 75 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 139517a..70e5126 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -879,77 +879,104 @@ xfs_sync_sb(
>  
>  int
>  xfs_fs_geometry(
> -	xfs_mount_t		*mp,
> -	xfs_fsop_geom_t		*geo,
> -	int			new_version)
> +	struct xfs_sb		*sbp,
> +	struct xfs_fsop_geom	*geo,
> +	int			struct_version)
>  {
...
> +	geo->version = XFS_FSOP_GEOM_VERSION;
> +	geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
> +		     XFS_FSOP_GEOM_FLAGS_DIRV2;
> +
> +

One whitespace line too many here..?

> +	if (xfs_sb_version_hasattr(sbp))
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR;
> +

Obviously just a nit... but IMO the extra whitespace between each of
these feature checks is a bit much. It actually reads cleaner to me to
kill off the extra lines between them. Just my .02 though..

...
> +
> +	geo->rtsectsize = sbp->sb_blocksize;
> +	geo->dirblocksize = 1 << (sbp->sb_blocklog + sbp->sb_dirblklog);
> +

Slightly unfortunate that we have the geo abstraction and can't use it
for a simple reporting case. Is there a larger (userspace?) reason mp
was dropped as a parameter or was that just a cleanup? If the latter,
perhaps we could continue to pass mp and create a local sbp pointer. If
the former, then oh well, not a big deal. :P

Brian

> +	if (struct_version < 3)
> +		return 0;
> +
> +	if (xfs_sb_version_haslogv2(sbp))
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_LOGV2;
> +
> +	geo->logsunit = sbp->sb_logsunit;
>  
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
> -	ASSERT(sizeof(geo->uuid) == sizeof(mp->m_sb.sb_uuid));
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
>  	return 0;
>  }
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index a16632c..63dcd2a 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -34,7 +34,8 @@ extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
>  extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
>  extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
>  
> -extern int	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
> -				int nversion);
> +#define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
> +extern int	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
> +				int struct_version);
>  
>  #endif	/* __XFS_SB_H__ */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 3015e17..89fb1eb 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -810,7 +810,7 @@ xfs_ioc_fsgeometry_v1(
>  	xfs_fsop_geom_t         fsgeo;
>  	int			error;
>  
> -	error = xfs_fs_geometry(mp, &fsgeo, 3);
> +	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
>  	if (error)
>  		return error;
>  
> @@ -832,7 +832,7 @@ xfs_ioc_fsgeometry(
>  	xfs_fsop_geom_t		fsgeo;
>  	int			error;
>  
> -	error = xfs_fs_geometry(mp, &fsgeo, 4);
> +	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 4);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 66cc3cd..10fbde3 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -67,7 +67,7 @@ xfs_compat_ioc_fsgeometry_v1(
>  	xfs_fsop_geom_t		  fsgeo;
>  	int			  error;
>  
> -	error = xfs_fs_geometry(mp, &fsgeo, 3);
> +	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
>  	if (error)
>  		return error;
>  	/* The 32-bit variant simply has some padding at the end */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
