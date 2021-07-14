Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8BBC12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 22:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D844610CB
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 22:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbhGNW64 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 18:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237084AbhGNW6z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 18:58:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88339613C2;
        Wed, 14 Jul 2021 22:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626303363;
        bh=OcqcEY1el6RjPcIQk135k04fx7D8ZdyHf9w5+4fGgjA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VfMq4mSpcrbKv2Gx4E+P2wxFyg1Jm5o/j7xOPvHQhD4i2/ZJHCDVTTXd8GN03SUxk
         q4EvBfsm/KByba7SKQbF73+dKcP6xlHonI1xJhtxkYl6ddtr9gfGtmqMvXUVcuE3z4
         3ZtqXFUDMZTn2gPUagPK4aBnydLHSKDQ1Su2u/U0AV4n/fpSm9s/vgY9tt04cp1JFY
         Jl6I/+U6KT72YRso0YcqbWzLfU/Ozcxn9qkmKgMesISlQhWqHb8aw3vNzPsArh69eD
         7a7sMWTnjXM0+hmh2kvtKi9ioLYAdyhlf7NCY66FwfNWdnAShnAvS3f+zaSTYrf27z
         mxzQTfLjnqkOA==
Date:   Wed, 14 Jul 2021 15:56:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/16] xfs: reflect sb features in xfs_mount
Message-ID: <20210714225603.GW22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:00PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently on-disk feature checks require decoding the superblock
> fileds and so can be non-trivial. We have almost 400 hundred
> individual feature checks in the XFS code, so this is a significant
> amount of code. To reduce runtime check overhead, pre-process all
> the version flags into a features field in the xfs_mount at mount
> time so we can convert all the feature checks to a simple flag
> check.
> 
> There is also a need to convert the dynamic feature flags to update
> the m_features field. This is required for attr, attr2 and quota
> features. New xfs_mount based wrappers are added for this.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_format.h |  2 +-
>  fs/xfs/libxfs/xfs_sb.c     | 66 +++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_sb.h     |  1 +
>  fs/xfs/xfs_log_recover.c   |  1 +
>  fs/xfs/xfs_mount.c         |  1 +
>  fs/xfs/xfs_mount.h         | 76 ++++++++++++++++++++++++++++++++++++++
>  6 files changed, 146 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index a8215bf478b2..44d374c65968 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -405,7 +405,7 @@ static inline bool xfs_sb_version_hasprojid32bit(struct xfs_sb *sbp)
>  		(sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT));
>  }
>  
> -static inline void xfs_sb_version_addprojid32bit(struct xfs_sb *sbp)
> +static inline void xfs_sb_version_addprojid32(struct xfs_sb *sbp)
>  {
>  	sbp->sb_versionnum |= XFS_SB_VERSION_MOREBITSBIT;
>  	sbp->sb_features2 |= XFS_SB_VERSION2_PROJID32BIT;
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 4a4586bd2ba2..f9af5f1c9ffc 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -30,6 +30,72 @@
>   * Physical superblock buffer manipulations. Shared with libxfs in userspace.
>   */
>  
> +uint64_t
> +xfs_sb_version_to_features(
> +	struct xfs_sb	*sbp)
> +{
> +	uint64_t	features = 0;
> +
> +	/* optional V4 features */
> +	if (sbp->sb_rblocks > 0)
> +		features |= XFS_FEAT_REALTIME;
> +	if (sbp->sb_versionnum & XFS_SB_VERSION_ATTRBIT)
> +		features |= XFS_FEAT_ATTR;
> +	if (sbp->sb_versionnum & XFS_SB_VERSION_QUOTABIT)
> +		features |= XFS_FEAT_QUOTA;
> +	if (sbp->sb_versionnum & XFS_SB_VERSION_ALIGNBIT)
> +		features |= XFS_FEAT_ALIGN;
> +	if (sbp->sb_versionnum & XFS_SB_VERSION_LOGV2BIT)
> +		features |= XFS_FEAT_LOGV2;
> +	if (sbp->sb_versionnum & XFS_SB_VERSION_DALIGNBIT)
> +		features |= XFS_FEAT_DALIGN;
> +	if (sbp->sb_versionnum & XFS_SB_VERSION_EXTFLGBIT)
> +		features |= XFS_FEAT_EXTFLG;
> +	if (sbp->sb_versionnum & XFS_SB_VERSION_SECTORBIT)
> +		features |= XFS_FEAT_SECTOR;
> +	if (sbp->sb_versionnum & XFS_SB_VERSION_BORGBIT)
> +		features |= XFS_FEAT_ASCIICI;
> +	if (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) {
> +		if (sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT)
> +			features |= XFS_FEAT_LAZYSBCOUNT;
> +		if (sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT)
> +			features |= XFS_FEAT_ATTR2;
> +		if (sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT)
> +			features |= XFS_FEAT_PROJID32;
> +		if (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE)
> +			features |= XFS_FEAT_FTYPE;
> +	}
> +
> +	if (XFS_SB_VERSION_NUM(sbp) != XFS_SB_VERSION_5)
> +		return features;
> +
> +	/* Always on V5 features */
> +	features |= XFS_FEAT_ALIGN | XFS_FEAT_LOGV2 | XFS_FEAT_EXTFLG |
> +		    XFS_FEAT_LAZYSBCOUNT | XFS_FEAT_ATTR2 | XFS_FEAT_PROJID32 |
> +		    XFS_FEAT_V3INODES | XFS_FEAT_CRC | XFS_FEAT_PQUOTINO;
> +
> +	/* Optional V5 features */
> +	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT)
> +		features |= XFS_FEAT_FINOBT;
> +	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT)
> +		features |= XFS_FEAT_RMAPBT;
> +	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK)
> +		features |= XFS_FEAT_REFLINK;
> +	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
> +		features |= XFS_FEAT_INOBTCNT;
> +	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
> +		features |= XFS_FEAT_FTYPE;
> +	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
> +		features |= XFS_FEAT_SPINODES;
> +	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID)
> +		features |= XFS_FEAT_META_UUID;
> +	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_BIGTIME)
> +		features |= XFS_FEAT_BIGTIME;
> +	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
> +		features |= XFS_FEAT_NEEDSREPAIR;
> +	return features;
> +}
> +
>  /* Check all the superblock fields we care about when reading one in. */
>  STATIC int
>  xfs_validate_sb_read(
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 0c1602d9b53d..d2dd99cb6921 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -20,6 +20,7 @@ extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
>  extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
>  extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
>  extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
> +extern uint64_t	xfs_sb_version_to_features(struct xfs_sb *sbp);
>  
>  extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
>  
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 5db3fb184fbe..488f472cedba 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3315,6 +3315,7 @@ xlog_do_recover(
>  	xfs_buf_relse(bp);
>  
>  	/* re-initialise in-core superblock and geometry structures */
> +	mp->m_features |= xfs_sb_version_to_features(sbp);

'|=' instead of '=' ?

I would have expected assignment, but I guess the assumption here is
that log recovery can process a sb update that adds a feature?  And that
log recovery won't be turning off features?

>  	xfs_reinit_percpu_counters(mp);
>  	error = xfs_initialize_perag(mp, sbp->sb_agcount, &mp->m_maxagi);
>  	if (error) {
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 6be2a1c5b0f4..0ec463d91cce 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -225,6 +225,7 @@ xfs_readsb(
>  		goto reread;
>  	}
>  
> +	mp->m_features |= xfs_sb_version_to_features(sbp);

Also, can't this be a plain assignment?

--D

>  	xfs_reinit_percpu_counters(mp);
>  
>  	/* no need to be quiet anymore, so reset the buf ops */
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index c78b63fe779a..8c0f928febac 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -132,6 +132,7 @@ typedef struct xfs_mount {
>  	int			m_fixedfsid[2];	/* unchanged for life of FS */
>  	uint			m_qflags;	/* quota status flags */
>  	uint64_t		m_flags;	/* global mount flags */
> +	uint64_t		m_features;	/* active filesystem features */
>  	int64_t			m_low_space[XFS_LOWSP_MAX];
>  	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
>  	struct xfs_trans_resv	m_resv;		/* precomputed res values */
> @@ -224,6 +225,81 @@ typedef struct xfs_mount {
>  
>  #define M_IGEO(mp)		(&(mp)->m_ino_geo)
>  
> +/*
> + * Flags for m_features.
> + *
> + * These are all the active features in the filesystem, regardless of how
> + * they are configured.
> + */
> +#define XFS_FEAT_ATTR		(1ULL << 0)	/* xattrs present in fs */
> +#define XFS_FEAT_NLINK		(1ULL << 1)	/* 32 bit link counts */
> +#define XFS_FEAT_QUOTA		(1ULL << 2)	/* quota active */
> +#define XFS_FEAT_ALIGN		(1ULL << 3)	/* inode alignment */
> +#define XFS_FEAT_DALIGN		(1ULL << 4)	/* data alignment */
> +#define XFS_FEAT_LOGV2		(1ULL << 5)	/* version 2 logs */
> +#define XFS_FEAT_SECTOR		(1ULL << 6)	/* sector size > 512 bytes */
> +#define XFS_FEAT_EXTFLG		(1ULL << 7)	/* unwritten extents */
> +#define XFS_FEAT_ASCIICI	(1ULL << 8)	/* ASCII only case-insens. */
> +#define XFS_FEAT_LAZYSBCOUNT	(1ULL << 9)	/* Superblk counters */
> +#define XFS_FEAT_ATTR2		(1ULL << 10)	/* dynamic attr fork */
> +#define XFS_FEAT_PARENT		(1ULL << 11)	/* parent pointers */
> +#define XFS_FEAT_PROJID32	(1ULL << 12)	/* 32 bit project id */
> +#define XFS_FEAT_CRC		(1ULL << 13)	/* metadata CRCs */
> +#define XFS_FEAT_V3INODES	(1ULL << 14)	/* Version 3 inodes */
> +#define XFS_FEAT_PQUOTINO	(1ULL << 15)	/* non-shared proj/grp quotas */
> +#define XFS_FEAT_FTYPE		(1ULL << 16)	/* inode type in dir */
> +#define XFS_FEAT_FINOBT		(1ULL << 17)	/* free inode btree */
> +#define XFS_FEAT_RMAPBT		(1ULL << 18)	/* reverse map btree */
> +#define XFS_FEAT_REFLINK	(1ULL << 19)	/* reflinked files */
> +#define XFS_FEAT_SPINODES	(1ULL << 20)	/* sparse inode chunks */
> +#define XFS_FEAT_META_UUID	(1ULL << 21)	/* metadata UUID */
> +#define XFS_FEAT_REALTIME	(1ULL << 22)	/* realtime device present */
> +#define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
> +#define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
> +#define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
> +
> +#define __XFS_HAS_FEAT(name, NAME) \
> +static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
> +{ \
> +	return mp->m_features & XFS_FEAT_ ## NAME; \
> +}
> +
> +/* Some features can be added dynamically so they need a set wrapper, too. */
> +#define __XFS_ADD_FEAT(name, NAME) \
> +	__XFS_HAS_FEAT(name, NAME); \
> +static inline void xfs_add_ ## name (struct xfs_mount *mp) \
> +{ \
> +	mp->m_features |= XFS_FEAT_ ## NAME; \
> +	xfs_sb_version_add ## name(&mp->m_sb); \
> +}
> +
> +__XFS_ADD_FEAT(attr, ATTR)
> +__XFS_HAS_FEAT(nlink, NLINK)
> +__XFS_ADD_FEAT(quota, QUOTA)
> +__XFS_HAS_FEAT(align, ALIGN)
> +__XFS_HAS_FEAT(dalign, DALIGN)
> +__XFS_HAS_FEAT(logv2, LOGV2)
> +__XFS_HAS_FEAT(sector, SECTOR)
> +__XFS_HAS_FEAT(extflg, EXTFLG)
> +__XFS_HAS_FEAT(asciici, ASCIICI)
> +__XFS_HAS_FEAT(lazysbcount, LAZYSBCOUNT)
> +__XFS_ADD_FEAT(attr2, ATTR2)
> +__XFS_HAS_FEAT(parent, PARENT)
> +__XFS_ADD_FEAT(projid32, PROJID32)
> +__XFS_HAS_FEAT(crc, CRC)
> +__XFS_HAS_FEAT(v3inodes, V3INODES)
> +__XFS_HAS_FEAT(pquotino, PQUOTINO)
> +__XFS_HAS_FEAT(ftype, FTYPE)
> +__XFS_HAS_FEAT(finobt, FINOBT)
> +__XFS_HAS_FEAT(rmapbt, RMAPBT)
> +__XFS_HAS_FEAT(reflink, REFLINK)
> +__XFS_HAS_FEAT(sparseinodes, SPINODES)
> +__XFS_HAS_FEAT(metauuid, META_UUID)
> +__XFS_HAS_FEAT(realtime, REALTIME)
> +__XFS_HAS_FEAT(inobtcounts, REALTIME)
> +__XFS_HAS_FEAT(bigtime, REALTIME)
> +__XFS_HAS_FEAT(needsrepair, REALTIME)
> +
>  /*
>   * Flags for m_flags.
>   */
> -- 
> 2.31.1
> 
