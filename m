Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD332348C75;
	Thu, 24 Sep 2026 22:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790288042; cv=none; b=uG/c2H3HjzFOO9FCeEmz+D6c/UcTCY/g2j1Hpw6l+IbJxcFw7EfYSPzWMqI/coneDIrPJFFZ+zq0xh5td8KiMPF/HyXuW1KNIqlD7Sbb9QhddIbp+ourYwzDESDFFj7XWp19IFYeI+sapKLRMWaB9KwQ9pOCwsc0TPXRrnq3xbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790288042; c=relaxed/simple;
	bh=nFAeH0M09bw5VE/4XM5lVtiZhmlpIjkQJI4ZqV9ipqg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I7XLzi/SPerckcQJGcjiS1RoElGzGpFhl4XiU65y6iB/r8aMlbhCDt4nwHJ/g5ussoAUt+KtwtT1gtbP/4bdeLLGpvR21H9fDlu2geFrYfd3/v72FHPqKrOm7kuB3kqaDSgfH/QaybnSBfc183YNT5q/Ofhw1Af47CNLSS3Cbro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWk3uwGW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWk3uwGW"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 738161F000FF;
	Thu, 24 Sep 2026 22:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790288040;
	bh=xoRUsgSGzoh3Mb1F3TvW9VoZ8MejKI1jiDwI31AFZvk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UWk3uwGWZIzSuZsDKcucjvvEJzNt26YGHKURLZb4IcZp877eRKNz7nmaJYxVKK8pl
	 26uesg0Kb0x75Fl8Zy5t0FhVvGJKduziOWv8X5R/gELdWd1lwc95Fy/lXUczwtGkfO
	 f89Gq0FK5OzWnOk1VglPLLPqNYZ/CTcp8pkQS0NWwX8C5VWdyWiZad+/Dkk56Hjnbi
	 5BLBGvL+xTqnzcpTZBKS/eftK06xkfeV7akZxiU+MJ5bIAJkkN6Vb5IVxwK9kMri02
	 NLFGnN2l7hYej9uEILkdp2p5bW43ZmwHvJWRLg3u3lreQHjNNdGNmnQ7jnti3O7A9r
	 g4kBydIiZ0qug==
Date: Thu, 24 Sep 2026 15:13:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/21] xfs: define the RT data checksum on-disk format
Message-ID: <20260924221359.GI2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-9-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:40AM +0200, Christoph Hellwig wrote:
> Add the on-disk format for the new RT data checksum format.
> 
> Keyed off a new read-only compat feature flag, this adds new fields to
> the superblock to indicate the checksum algorithm used and the size of
> the blocks containing the checksums.  These new fields reuse the
> previously reserved padding to make efficient use of the space in the
> on-disk superblock.
> 
> Data checksums are only supported on zoned RT devices, because they
> require out of places writes to safely update the checksums for file
> overwrites and a data/metadata split to be able to store the checksums
> for a group in a file without causing recursion.  This means they can't
> be supported directly on the data device at all, and only when using
> the always_cow mode on regular RT devices, but that has no benefit
> over the zoned allocator which is designed for out of place writes.
> 
> The initially supported data checksum algorithms are crc32c and crc64 as
> specified by NVMe.  Both have extremely fast kernel implementations and
> the strong data protection guarantees offered by CRC-style algorithms.
> Both also happen to be support by NVMe for protection information so that
> the userspace PI passthrough support (once extended to files on file
> systems) can be reused to expose the checksums to applications and thus
> provide true end-to-end data integrity.

And just to play the peanut gallery here, xxhash? <duck>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h     | 43 +++++++++++++++++--
>  fs/xfs/libxfs/xfs_log_format.h |  1 +
>  fs/xfs/libxfs/xfs_ondisk.h     |  4 +-
>  fs/xfs/libxfs/xfs_sb.c         | 75 ++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_sb.h         |  1 +
>  fs/xfs/scrub/agheader.c        |  5 +++
>  fs/xfs/xfs_mount.h             |  7 ++++
>  7 files changed, 132 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index dd0ed046fbe9..1be3d21910a7 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -179,7 +179,9 @@ typedef struct xfs_sb {
>  	xfs_rgnumber_t	sb_rgcount;	/* number of realtime groups */
>  	xfs_rtxlen_t	sb_rgextents;	/* size of a realtime group in rtx */
>  	uint8_t		sb_rgblklog;    /* rt group number shift */
> -	uint8_t		sb_pad[7];	/* zeroes */
> +	uint8_t		sb_rtcsum_type;	/* RT device data checksum type */
> +	uint8_t		sb_rtcsum_blklog; /* log2 of rtcsum bsize */
> +	uint8_t		sb_pad[5];	/* zero */
>  	xfs_rfsblock_t	sb_rtstart;	/* start of internal RT section (FSB) */
>  	xfs_filblks_t	sb_rtreserved;	/* reserved (zoned) RT blocks */
>  
> @@ -272,7 +274,9 @@ struct xfs_dsb {
>  	__be32		sb_rgcount;	/* # of realtime groups */
>  	__be32		sb_rgextents;	/* size of rtgroup in rtx */
>  	__u8		sb_rgblklog;    /* rt group number shift */
> -	__u8		sb_pad[7];	/* zeroes */
> +	__u8		sb_rtcsum_type;	/* RT device data checksum type */
> +	__u8		sb_rtcsum_blklog; /* log2 of rtcsum bsize */
> +	__u8		sb_pad[5];	/* zero */
>  	__be64		sb_rtstart;	/* start of internal RT section (FSB) */
>  	__be64		sb_rtreserved;	/* reserved (zoned) RT blocks */
>  
> @@ -374,6 +378,8 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
>  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
>  #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
> +#define XFS_SB_FEAT_RO_COMPAT_RTCSUM     (1 << 5)	/* RT data checksums */
> +
>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
>  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> @@ -866,6 +872,7 @@ enum xfs_metafile_type {
>  	XFS_METAFILE_RTSUMMARY,		/* rt summary */
>  	XFS_METAFILE_RTRMAP,		/* rt rmap */
>  	XFS_METAFILE_RTREFCOUNT,	/* rt refcount */
> +	XFS_METAFILE_RTCSUM,		/* rt data checksums */
>  
>  	XFS_METAFILE_MAX
>  } __packed;
> @@ -879,7 +886,8 @@ enum xfs_metafile_type {
>  	{ XFS_METAFILE_RTBITMAP,	"rtbitmap" }, \
>  	{ XFS_METAFILE_RTSUMMARY,	"rtsummary" }, \
>  	{ XFS_METAFILE_RTRMAP,		"rtrmap" }, \
> -	{ XFS_METAFILE_RTREFCOUNT,	"rtrefcount" }
> +	{ XFS_METAFILE_RTREFCOUNT,	"rtrefcount" }, \
> +	{ XFS_METAFILE_RTCSUM,		"rtcsum", }
>  
>  /*
>   * On-disk inode structure.
> @@ -1318,6 +1326,7 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
>   */
>  #define XFS_RTBITMAP_MAGIC	0x424D505A	/* BMPZ */
>  #define XFS_RTSUMMARY_MAGIC	0x53554D59	/* SUMY */
> +#define XFS_RTCSUM_MAGIC	0x4353554D	/* CSUM */
>  
>  struct xfs_rtbuf_blkinfo {
>  	__be32		rt_magic;	/* validity check on block */
> @@ -2027,4 +2036,32 @@ struct xfs_acl {
>  #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
>  #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
>  
> +/*
> + * Size of a RT data checksum block.  Data reads must be contained in a single
> + * block, so this should be fairly large.
> + *
> + * The default is 32k, matching the default inode cluster size and the maximum
> + * memory allocation the Linux MM can handle in the fast path.  64k is primarily
> + * there so that his value never needs to be below the FSB size, even for 64k

                    this

> + * blocks.
> + */
> +#define XFS_RTCSUM_BSIZE_LOG_MIN	15
> +#define XFS_RTCSUM_BSIZE_LOG_MAX	16
> +
> +/*
> + * Data checksum types.
> + */
> +#define XFS_CSUM_TYPE_NONE	0u
> +#define XFS_CSUM_TYPE_CRC32C	1u
> +#define XFS_CSUM_TYPE_CRC64	2u
> +#define XFS_CSUM_TYPE_MAX	3u
> +
> +/*
> + * On-disk data checksums.
> + */
> +union xfs_disk_csum {
> +	__le32			crc32c;
> +	__le64			crc64;
> +};

I'm curious where this type will lead since its size is 8 bytes...
but we'll see.

> +
>  #endif /* __XFS_FORMAT_H__ */
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index a4e1b3eb425c..b1037b77338b 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -581,6 +581,7 @@ enum xfs_blft {
>  	XFS_BLFT_SB_BUF,
>  	XFS_BLFT_RTBITMAP_BUF,
>  	XFS_BLFT_RTSUMMARY_BUF,
> +	XFS_BLFT_RTCSUM_BUF,
>  	XFS_BLFT_MAX_BUF = (1 << XFS_BLFT_BITS),
>  };
>  
> diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
> index 23cde1248f01..17ab9366b3b9 100644
> --- a/fs/xfs/libxfs/xfs_ondisk.h
> +++ b/fs/xfs/libxfs/xfs_ondisk.h
> @@ -284,7 +284,9 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_SB_OFFSET(sb_rgcount,			272);
>  	XFS_CHECK_SB_OFFSET(sb_rgextents,		276);
>  	XFS_CHECK_SB_OFFSET(sb_rgblklog,		280);
> -	XFS_CHECK_SB_OFFSET(sb_pad,			281);
> +	XFS_CHECK_SB_OFFSET(sb_rtcsum_type,		281);
> +	XFS_CHECK_SB_OFFSET(sb_rtcsum_blklog,		282);
> +	XFS_CHECK_SB_OFFSET(sb_pad,			283);
>  	XFS_CHECK_SB_OFFSET(sb_rtstart,			288);
>  	XFS_CHECK_SB_OFFSET(sb_rtreserved,		296);
>  
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index f0341adbb879..3a470aec6c0c 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -487,6 +487,40 @@ xfs_validate_sb_zoned(
>  	return 0;
>  }
>  
> +static int
> +xfs_validate_sb_csum(
> +	struct xfs_mount	*mp,
> +	struct xfs_sb		*sbp)
> +{
> +	unsigned int		rtcsum_bsize = 1u << sbp->sb_rtcsum_blklog;
> +
> +	if (!(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
> +		xfs_warn(mp, "data checksum required the zone allocator");
> +		return -EINVAL;
> +	}
> +	if (sbp->sb_rtcsum_type >= XFS_CSUM_TYPE_MAX) {
> +		xfs_warn(mp, "invalid data checksum type: 0x%x",
> +			sbp->sb_rtcsum_type);
> +		return -EINVAL;
> +	}
> +	if (sbp->sb_rtcsum_blklog < XFS_RTCSUM_BSIZE_LOG_MIN ||
> +	    sbp->sb_rtcsum_blklog > XFS_RTCSUM_BSIZE_LOG_MAX) {
> +		xfs_warn(mp,
> +"invalid data checksum block log: %u (min %u/max %u)",
> +			sbp->sb_rtcsum_blklog,
> +			XFS_RTCSUM_BSIZE_LOG_MIN,
> +			XFS_RTCSUM_BSIZE_LOG_MAX);
> +		return -EINVAL;
> +	}
> +	if (rtcsum_bsize < sbp->sb_blocksize) {
> +		xfs_warn(mp,
> +"checksum block size must not be smaller than file system block size: %u/%u",
> +			rtcsum_bsize, sbp->sb_blocksize);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  /* Check the validity of the SB. */
>  STATIC int
>  xfs_validate_sb_common(
> @@ -580,6 +614,17 @@ xfs_validate_sb_common(
>  			if (error)
>  				return error;
>  		}
> +		if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RTCSUM) {
> +			error = xfs_validate_sb_csum(mp, sbp);
> +			if (error)
> +				return error;
> +		} else {
> +			if (sbp->sb_rtcsum_type || sbp->sb_rtcsum_blklog) {
> +				xfs_warn(mp,
> +"rtcsum superblock fields must be zero for non-RTCSUM file systems.");
> +				return -EINVAL;
> +			}
> +		}
>  	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
>  				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
>  			xfs_notice(mp,
> @@ -900,6 +945,14 @@ __xfs_sb_from_disk(
>  		to->sb_rtstart = 0;
>  		to->sb_rtreserved = 0;
>  	}
> +
> +	if (to->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RTCSUM) {
> +		to->sb_rtcsum_type = from->sb_rtcsum_type;
> +		to->sb_rtcsum_blklog = from->sb_rtcsum_blklog;
> +	} else {
> +		to->sb_rtcsum_type = XFS_CSUM_TYPE_NONE;
> +		to->sb_rtcsum_blklog = 0;
> +	}
>  }
>  
>  void
> @@ -1071,6 +1124,11 @@ xfs_sb_to_disk(
>  		to->sb_rtstart = cpu_to_be64(from->sb_rtstart);
>  		to->sb_rtreserved = cpu_to_be64(from->sb_rtreserved);
>  	}
> +
> +	if (from->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RTCSUM) {
> +		to->sb_rtcsum_type = from->sb_rtcsum_type;
> +		to->sb_rtcsum_blklog = from->sb_rtcsum_blklog;
> +	}
>  }
>  
>  /*
> @@ -1243,6 +1301,20 @@ xfs_mount_sb_set_rextsize(
>  	xfs_sb_mount_rextsize(mp, sbp);
>  }
>  
> +uint8_t
> +xfs_data_csum_shift(
> +	uint8_t			csum)
> +{
> +	switch (csum) {
> +	case XFS_CSUM_TYPE_CRC32C:
> +		return 2;
> +	case XFS_CSUM_TYPE_CRC64:
> +		return 3;
> +	default:
> +		return 0;
> +	}
> +}
> +
>  /*
>   * xfs_mount_common
>   *
> @@ -1311,6 +1383,9 @@ xfs_sb_mount_common(
>  	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
>  	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
>  	mp->m_ag_max_usable = xfs_alloc_ag_max_usable(mp);
> +
> +	mp->m_rtcsum_shift = xfs_data_csum_shift(mp->m_sb.sb_rtcsum_type);
> +	mp->m_rtcsum_bsize = 1u << mp->m_sb.sb_rtcsum_blklog;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
> index 34d0dd374e9b..16f300c12e37 100644
> --- a/fs/xfs/libxfs/xfs_sb.h
> +++ b/fs/xfs/libxfs/xfs_sb.h
> @@ -20,6 +20,7 @@ extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
>  void		xfs_sb_mount_rextsize(struct xfs_mount *mp, struct xfs_sb *sbp);
>  void		xfs_mount_sb_set_rextsize(struct xfs_mount *mp,
>  			struct xfs_sb *sbp, xfs_agblock_t rextsize);
> +uint8_t		xfs_data_csum_shift(uint8_t csum);
>  extern void	xfs_sb_from_disk(struct xfs_sb *to, struct xfs_dsb *from);
>  extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
>  extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
> diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
> index 1fa66aa68e16..316a3085f95e 100644
> --- a/fs/xfs/scrub/agheader.c
> +++ b/fs/xfs/scrub/agheader.c
> @@ -416,6 +416,11 @@ xchk_superblock(
>  
>  		if (memchr_inv(sb->sb_pad, 0, sizeof(sb->sb_pad)))
>  			xchk_block_set_corrupt(sc, bp);
> +
> +		if (sb->sb_rtcsum_type != mp->m_sb.sb_rtcsum_type)
> +			xchk_block_set_corrupt(sc, bp);
> +		if (sb->sb_rtcsum_blklog != mp->m_sb.sb_rtcsum_blklog)
> +			xchk_block_set_corrupt(sc, bp);
>  	}
>  
>  	/* Everything else must be zero. */
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 894ff2f4ecbd..fa86697f463a 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -191,6 +191,8 @@ typedef struct xfs_mount {
>  	uint8_t			m_agno_log;	/* log #ag's */
>  	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
>  	int8_t			m_rtxblklog;	/* log2 of rextsize, if possible */
> +	uint8_t			m_rtcsum_shift;	/* log2 of RT data csum size */
> +	uint32_t		m_rtcsum_bsize;	/* rtcsum block size in bytes */
>  
>  	uint			m_blockmask;	/* sb_blocksize-1 */
>  	uint			m_blockwsize;	/* sb_blocksize in words */
> @@ -461,6 +463,11 @@ __XFS_HAS_FEAT(metadir, METADIR)
>  __XFS_HAS_FEAT(zoned, ZONED)
>  __XFS_HAS_FEAT(nolifetime, NOLIFETIME)
>  
> +static inline bool xfs_has_rtcsum(const struct xfs_mount *mp)
> +{
> +	return mp->m_sb.sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RTCSUM;

Shouldn't this be an __XFS_HAS_FEAT item that gets set in
xfs_sb_version_to_features?

I think the only place why we need to look at the ondisk superblock
fields are the xfs_sb_version_hasXXXX calls in secondary_sb_whack in
xfs_repair (and a few other places in userspace).

--D

> +}
> +
>  static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
>  {
>  	/* all metadir file systems also allow rtgroups */
> -- 
> 2.53.0
> 
> 
