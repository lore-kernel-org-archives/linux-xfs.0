Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43208C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B1AB6136E
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhGNXSn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhGNXSl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:18:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8021E613C9;
        Wed, 14 Jul 2021 23:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626304549;
        bh=SS9MrV4GR87UxEq0OxgEPX50AI8QAjXUPgQxLkOTYds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CNGelnfPF3Ashcc5TGB/e3awUjav1pgrRgohD4ElmXi6XfoovOXlwXkiy8LQqRuo/
         Ors9Q36Yxcbnlqid0Ssl0pPJhJB2JadaQ69vbfj46BKxhgRd7ZUK6Gzibzk8DwApYG
         jv5Sbb2QIsnq9up8aYZwhtpu+v5dXUyFz40yUNsFNfRJOzRBxQ32bHn/9P3166d7ma
         vtSOdis7oxB0gZb7vzl/EcGALTKk5tHX8aaZdi1RoRaoD18EtG9qy58jyZUe7CyyZb
         U4QOTbHf8KlN9qDg/TdhRK7VMRWmjhgvRb5I32OMN0dkfJ3xOZfV/nZ0ye5GOOGAnt
         AcbeIH9yWI1Fw==
Date:   Wed, 14 Jul 2021 16:15:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/16] xfs: convert xfs_fs_geometry to use mount feature
 checks
Message-ID: <20210714231549.GD22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-11-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Reporting filesystem features to userspace is currently superblock
> based. Now we have a general mount-based feature infrastructure,
> switch to using the xfs_mount rather than the superblock directly.
> 
> This reduces the size of the function by over 300 bytes.
> 
> $ size -t fs/xfs/built-in.a
> 	text    data     bss     dec     hex filename
> before	1127855  311352     484 1439691  15f7cb (TOTALS)
> after	1127535  311352     484 1439371  15f68b (TOTALS)
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_sb.c | 46 ++++++++++++++++++++++--------------------
>  fs/xfs/libxfs/xfs_sb.h |  2 +-
>  fs/xfs/xfs_ioctl.c     |  2 +-
>  fs/xfs/xfs_ioctl32.c   |  2 +-
>  4 files changed, 27 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index baaec7e6a975..5eaf14b6fe3c 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1016,10 +1016,12 @@ xfs_sync_sb_buf(
>  
>  void
>  xfs_fs_geometry(
> -	struct xfs_sb		*sbp,
> +	struct xfs_mount	*mp,

Hmm.  I /think/ this won't cause problems in userspace, because db
passes in &mp->m_sb, and mkfs passes in sbp, which points to &mp->m_sb,
and mp itself points to &mbuf...

>  	struct xfs_fsop_geom	*geo,
>  	int			struct_version)
>  {
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +
>  	memset(geo, 0, sizeof(struct xfs_fsop_geom));
>  
>  	geo->blocksize = sbp->sb_blocksize;
> @@ -1050,51 +1052,51 @@ xfs_fs_geometry(
>  	geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
>  		     XFS_FSOP_GEOM_FLAGS_DIRV2 |
>  		     XFS_FSOP_GEOM_FLAGS_EXTFLG;
> -	if (xfs_sb_version_hasattr(sbp))
> +	if (xfs_has_attr(mp))

...provided those utilities set m_features before we get to this point,
right?  And provided that libxfs_init will take care of that, I think
only mkfs would need special consideration, right?

--D

>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR;
> -	if (xfs_sb_version_hasquota(sbp))
> +	if (xfs_has_quota(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_QUOTA;
> -	if (xfs_sb_version_hasalign(sbp))
> +	if (xfs_has_align(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_IALIGN;
> -	if (xfs_sb_version_hasdalign(sbp))
> +	if (xfs_has_dalign(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_DALIGN;
> -	if (xfs_sb_version_hassector(sbp))
> -		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
> -	if (xfs_sb_version_hasasciici(sbp))
> +	if (xfs_has_asciici(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_DIRV2CI;
> -	if (xfs_sb_version_haslazysbcount(sbp))
> +	if (xfs_has_lazysbcount(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_LAZYSB;
> -	if (xfs_sb_version_hasattr2(sbp))
> +	if (xfs_has_attr2(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR2;
> -	if (xfs_sb_version_hasprojid32(sbp))
> +	if (xfs_has_projid32(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_PROJID32;
> -	if (xfs_sb_version_hascrc(sbp))
> +	if (xfs_has_crc(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_V5SB;
> -	if (xfs_sb_version_hasftype(sbp))
> +	if (xfs_has_ftype(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_FTYPE;
> -	if (xfs_sb_version_hasfinobt(sbp))
> +	if (xfs_has_finobt(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_FINOBT;
> -	if (xfs_sb_version_hassparseinodes(sbp))
> +	if (xfs_has_sparseinodes(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_SPINODES;
> -	if (xfs_sb_version_hasrmapbt(sbp))
> +	if (xfs_has_rmapbt(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_RMAPBT;
> -	if (xfs_sb_version_hasreflink(sbp))
> +	if (xfs_has_reflink(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_REFLINK;
> -	if (xfs_sb_version_hasbigtime(sbp))
> +	if (xfs_has_bigtime(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_BIGTIME;
> -	if (xfs_sb_version_hasinobtcounts(sbp))
> +	if (xfs_has_inobtcounts(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_INOBTCNT;
> -	if (xfs_sb_version_hassector(sbp))
> +	if (xfs_has_sector(mp)) {
> +		geo->flags |= XFS_FSOP_GEOM_FLAGS_SECTOR;
>  		geo->logsectsize = sbp->sb_logsectsize;
> -	else
> +	} else {
>  		geo->logsectsize = BBSIZE;
> +	}
>  	geo->rtsectsize = sbp->sb_blocksize;
>  	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
>  
>  	if (struct_version < 4)
>  		return;
>  
> -	if (xfs_sb_version_haslogv2(sbp))
> +	if (xfs_has_logv2(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_LOGV2;
>  
>  	geo->logsunit = sbp->sb_logsunit;
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index d2dd99cb6921..8902f4bfa5df 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -25,7 +25,7 @@ extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
>  extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
>  
>  #define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
> -extern void	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
> +extern void	xfs_fs_geometry(struct xfs_mount *mp, struct xfs_fsop_geom *geo,
>  				int struct_version);
>  extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
>  				struct xfs_trans *tp, xfs_agnumber_t agno,
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index d54f2e0875d7..320d7481736d 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1010,7 +1010,7 @@ xfs_ioc_fsgeometry(
>  	struct xfs_fsop_geom	fsgeo;
>  	size_t			len;
>  
> -	xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
> +	xfs_fs_geometry(mp, &fsgeo, struct_version);
>  
>  	if (struct_version <= 3)
>  		len = sizeof(struct xfs_fsop_geom_v1);
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 20adf35aa37b..8783af203cfc 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -50,7 +50,7 @@ xfs_compat_ioc_fsgeometry_v1(
>  {
>  	struct xfs_fsop_geom	  fsgeo;
>  
> -	xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
> +	xfs_fs_geometry(mp, &fsgeo, 3);
>  	/* The 32-bit variant simply has some padding at the end */
>  	if (copy_to_user(arg32, &fsgeo, sizeof(struct compat_xfs_fsop_geom_v1)))
>  		return -EFAULT;
> -- 
> 2.31.1
> 
