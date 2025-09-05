Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89E91F95C
	for <linux-xfs@vger.kernel.org>; Fri,  5 Sep 2025 08:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757061305; cv=none; b=diiAxn2L3diNjHvjsa6zLIzI5dBMaqDI3uOrsUwQ0bbfANh8m42sICQzrvnWfWWgXCrDIevPBqGX9bHln1pZmg46SmIUxws6dxfbcC9lyxG96LY8H+GTLh5ObjdxXkoDvc1ycmzjq7m1WQhpS/axXCAF37JOTufcAwHxKIcPIKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757061305; c=relaxed/simple;
	bh=u33SSEwg5Itzit5knayQHZ6AW7AVC6EyVIl8gOVhrCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pm+2oUATedBN/dA3+XRjzg9BjCTG51OHSAC/7yu328QF4fvH4tF6HgRPm89wCyliXbqQdi7TVnGgoQKUJu1df/ltItHvdmu97fpChKSdVvuGhvjgbNN0eEABtuNA+6iZOJs2UuT11SCzHZigsFRx9WcjCe+zzY1alUHirQtFWfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F5eWtGgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F5eWtGgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBBBC4CEF8;
	Fri,  5 Sep 2025 08:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757061305;
	bh=u33SSEwg5Itzit5knayQHZ6AW7AVC6EyVIl8gOVhrCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F5eWtGgwfz/h9LvFMR8pHVcUbwwjNbXeUSirwJOb70ZImdw2Lp5DBUIwRFdkgVUnQ
	 26CCmrbG4eOQ7w/n3gesOeDNITFgFdRrfrMlU9BzOCtd0pSenIZeP6vQ/Uj9CSCBv9
	 Z4G8k8kBcNEbYDLJPnXAxaAcQcG9fDkmbPf1mDS7dSj0oiRHHQ4Anrw+nav8B5/Qr4
	 AB7MOJ5zAUid/c08Knr9pccNeCT+kEnPU3uusrnQSWQQT6tLbbfBtbvOwRTpR8PLpI
	 T0Dj6qqm/j0rZK2ImKsEU1J3aN4DOCEBktVeGw07Pv5xMMKz4+cxdz1zDWjXyuFzRa
	 eJBHvknM/pmsA==
Date: Fri, 5 Sep 2025 10:35:00 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: preichl@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: remove deprecated mount options
Message-ID: <vtoumkh2he3xx3q42bwf7xpmgq2hqvtyqunt3qkonnmsvgkd7i@p253vjx5ainy>
References: <175691147603.1206750.9285060179974032092.stgit@frogsfrogsfrogs>
 <muu_F9WzxVlV7wwXYvleTQMz_gsQ4gb2ZjXdX2lkb6UVaWcTWopnJHY55oSAo3p3GsBObDuBTQFXuV9CAjgKdA==@protonmail.internalid>
 <175691147668.1206750.4620128821118989090.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <175691147668.1206750.4620128821118989090.stgit@frogsfrogsfrogs>

On Wed, Sep 03, 2025 at 08:00:08AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> These four mount options were scheduled for removal in September 2025,
> so remove them now.
> 
> Cc: preichl@redhat.com
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  fs/xfs/xfs_mount.h                |   12 ++++---
>  Documentation/admin-guide/xfs.rst |   26 +---------------
>  fs/xfs/libxfs/xfs_attr_leaf.c     |   23 +++-----------
>  fs/xfs/libxfs/xfs_bmap.c          |   14 ++-------
>  fs/xfs/libxfs/xfs_ialloc.c        |    4 +-
>  fs/xfs/libxfs/xfs_sb.c            |    9 ++----
>  fs/xfs/xfs_icache.c               |    6 +---
>  fs/xfs/xfs_mount.c                |   13 --------
>  fs/xfs/xfs_super.c                |   60 +------------------------------------
>  9 files changed, 25 insertions(+), 142 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 97de44c32272f2..f046d1215b043c 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -363,7 +363,6 @@ typedef struct xfs_mount {
>  #define XFS_FEAT_EXTFLG		(1ULL << 7)	/* unwritten extents */
>  #define XFS_FEAT_ASCIICI	(1ULL << 8)	/* ASCII only case-insens. */
>  #define XFS_FEAT_LAZYSBCOUNT	(1ULL << 9)	/* Superblk counters */
> -#define XFS_FEAT_ATTR2		(1ULL << 10)	/* dynamic attr fork */
>  #define XFS_FEAT_PARENT		(1ULL << 11)	/* parent pointers */
>  #define XFS_FEAT_PROJID32	(1ULL << 12)	/* 32 bit project id */
>  #define XFS_FEAT_CRC		(1ULL << 13)	/* metadata CRCs */
> @@ -386,7 +385,6 @@ typedef struct xfs_mount {
> 
>  /* Mount features */
>  #define XFS_FEAT_NOLIFETIME	(1ULL << 47)	/* disable lifetime hints */
> -#define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
>  #define XFS_FEAT_NOALIGN	(1ULL << 49)	/* ignore alignment */
>  #define XFS_FEAT_ALLOCSIZE	(1ULL << 50)	/* user specified allocation size */
>  #define XFS_FEAT_LARGE_IOSIZE	(1ULL << 51)	/* report large preferred
> @@ -396,7 +394,6 @@ typedef struct xfs_mount {
>  #define XFS_FEAT_DISCARD	(1ULL << 54)	/* discard unused blocks */
>  #define XFS_FEAT_GRPID		(1ULL << 55)	/* group-ID assigned from directory */
>  #define XFS_FEAT_SMALL_INUMS	(1ULL << 56)	/* user wants 32bit inodes */
> -#define XFS_FEAT_IKEEP		(1ULL << 57)	/* keep empty inode clusters*/
>  #define XFS_FEAT_SWALLOC	(1ULL << 58)	/* stripe width allocation */
>  #define XFS_FEAT_FILESTREAMS	(1ULL << 59)	/* use filestreams allocator */
>  #define XFS_FEAT_DAX_ALWAYS	(1ULL << 60)	/* DAX always enabled */
> @@ -504,12 +501,17 @@ __XFS_HAS_V4_FEAT(align, ALIGN)
>  __XFS_HAS_V4_FEAT(logv2, LOGV2)
>  __XFS_HAS_V4_FEAT(extflg, EXTFLG)
>  __XFS_HAS_V4_FEAT(lazysbcount, LAZYSBCOUNT)
> -__XFS_ADD_V4_FEAT(attr2, ATTR2)
>  __XFS_ADD_V4_FEAT(projid32, PROJID32)
>  __XFS_HAS_V4_FEAT(v3inodes, V3INODES)
>  __XFS_HAS_V4_FEAT(crc, CRC)
>  __XFS_HAS_V4_FEAT(pquotino, PQUOTINO)
> 
> +static inline void xfs_add_attr2(struct xfs_mount *mp)
> +{
> +	if (IS_ENABLED(CONFIG_XFS_SUPPORT_V4))
> +		xfs_sb_version_addattr2(&mp->m_sb);
> +}
> +
>  /*
>   * Mount features
>   *
> @@ -517,7 +519,6 @@ __XFS_HAS_V4_FEAT(pquotino, PQUOTINO)
>   * bit inodes and read-only state, are kept as operational state rather than
>   * features.
>   */
> -__XFS_HAS_FEAT(noattr2, NOATTR2)
>  __XFS_HAS_FEAT(noalign, NOALIGN)
>  __XFS_HAS_FEAT(allocsize, ALLOCSIZE)
>  __XFS_HAS_FEAT(large_iosize, LARGE_IOSIZE)
> @@ -526,7 +527,6 @@ __XFS_HAS_FEAT(dirsync, DIRSYNC)
>  __XFS_HAS_FEAT(discard, DISCARD)
>  __XFS_HAS_FEAT(grpid, GRPID)
>  __XFS_HAS_FEAT(small_inums, SMALL_INUMS)
> -__XFS_HAS_FEAT(ikeep, IKEEP)
>  __XFS_HAS_FEAT(swalloc, SWALLOC)
>  __XFS_HAS_FEAT(filestreams, FILESTREAMS)
>  __XFS_HAS_FEAT(dax_always, DAX_ALWAYS)
> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
> index 693b09ca62922f..7ad746a3e66c25 100644
> --- a/Documentation/admin-guide/xfs.rst
> +++ b/Documentation/admin-guide/xfs.rst
> @@ -34,22 +34,6 @@ When mounting an XFS filesystem, the following options are accepted.
>  	to the file. Specifying a fixed ``allocsize`` value turns off
>  	the dynamic behaviour.
> 
> -  attr2 or noattr2
> -	The options enable/disable an "opportunistic" improvement to
> -	be made in the way inline extended attributes are stored
> -	on-disk.  When the new form is used for the first time when
> -	``attr2`` is selected (either when setting or removing extended
> -	attributes) the on-disk superblock feature bit field will be
> -	updated to reflect this format being in use.
> -
> -	The default behaviour is determined by the on-disk feature
> -	bit indicating that ``attr2`` behaviour is active. If either
> -	mount option is set, then that becomes the new default used
> -	by the filesystem.
> -
> -	CRC enabled filesystems always use the ``attr2`` format, and so
> -	will reject the ``noattr2`` mount option if it is set.
> -
>    discard or nodiscard (default)
>  	Enable/disable the issuing of commands to let the block
>  	device reclaim space freed by the filesystem.  This is
> @@ -75,12 +59,6 @@ When mounting an XFS filesystem, the following options are accepted.
>  	across the entire filesystem rather than just on directories
>  	configured to use it.
> 
> -  ikeep or noikeep (default)
> -	When ``ikeep`` is specified, XFS does not delete empty inode
> -	clusters and keeps them around on disk.  When ``noikeep`` is
> -	specified, empty inode clusters are returned to the free
> -	space pool.
> -
>    inode32 or inode64 (default)
>  	When ``inode32`` is specified, it indicates that XFS limits
>  	inode creation to locations which will not result in inode
> @@ -267,8 +245,6 @@ Deprecated Mount Options
>  ============================    ================
>  Mounting with V4 filesystem     September 2030
>  Mounting ascii-ci filesystem    September 2030
> -ikeep/noikeep			September 2025
> -attr2/noattr2			September 2025
>  ============================    ================
> 
> 
> @@ -284,6 +260,8 @@ Removed Mount Options
>    osyncisdsync/osyncisosync	v4.0
>    barrier			v4.19
>    nobarrier			v4.19
> +  ikeep/noikeep			v6.18
> +  attr2/noattr2			v6.18
>  ===========================     =======
> 
>  sysctls
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index fddb55605e0cc6..47213e6023dd4b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -667,12 +667,8 @@ xfs_attr_shortform_bytesfit(
> 
>  	/*
>  	 * For attr2 we can try to move the forkoff if there is space in the
> -	 * literal area, but for the old format we are done if there is no
> -	 * space in the fixed attribute fork.
> +	 * literal area
>  	 */
> -	if (!xfs_has_attr2(mp))
> -		return 0;
> -
>  	dsize = dp->i_df.if_bytes;
> 
>  	switch (dp->i_df.if_format) {
> @@ -723,22 +719,16 @@ xfs_attr_shortform_bytesfit(
>  }
> 
>  /*
> - * Switch on the ATTR2 superblock bit (implies also FEATURES2) unless:
> - * - noattr2 mount option is set,
> - * - on-disk version bit says it is already set, or
> - * - the attr2 mount option is not set to enable automatic upgrade from attr1.
> + * Switch on the ATTR2 superblock bit (implies also FEATURES2) unless
> + * on-disk version bit says it is already set
>   */
>  STATIC void
>  xfs_sbversion_add_attr2(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans	*tp)
>  {
> -	if (xfs_has_noattr2(mp))
> -		return;
>  	if (mp->m_sb.sb_features2 & XFS_SB_VERSION2_ATTR2BIT)
>  		return;
> -	if (!xfs_has_attr2(mp))
> -		return;
> 
>  	spin_lock(&mp->m_sb_lock);
>  	xfs_add_attr2(mp);
> @@ -889,7 +879,7 @@ xfs_attr_sf_removename(
>  	/*
>  	 * Fix up the start offset of the attribute fork
>  	 */
> -	if (totsize == sizeof(struct xfs_attr_sf_hdr) && xfs_has_attr2(mp) &&
> +	if (totsize == sizeof(struct xfs_attr_sf_hdr) &&
>  	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
>  	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE)) &&
>  	    !xfs_has_parent(mp)) {
> @@ -900,7 +890,6 @@ xfs_attr_sf_removename(
>  		ASSERT(dp->i_forkoff);
>  		ASSERT(totsize > sizeof(struct xfs_attr_sf_hdr) ||
>  				(args->op_flags & XFS_DA_OP_ADDNAME) ||
> -				!xfs_has_attr2(mp) ||
>  				dp->i_df.if_format == XFS_DINODE_FMT_BTREE ||
>  				xfs_has_parent(mp));
>  		xfs_trans_log_inode(args->trans, dp,
> @@ -1040,8 +1029,7 @@ xfs_attr_shortform_allfit(
>  		bytes += xfs_attr_sf_entsize_byname(name_loc->namelen,
>  					be16_to_cpu(name_loc->valuelen));
>  	}
> -	if (xfs_has_attr2(dp->i_mount) &&
> -	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
> +	if ((dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
>  	    (bytes == sizeof(struct xfs_attr_sf_hdr)))
>  		return -1;
>  	return xfs_attr_shortform_bytesfit(dp, bytes);
> @@ -1161,7 +1149,6 @@ xfs_attr3_leaf_to_shortform(
>  		 * this case.
>  		 */
>  		if (!(args->op_flags & XFS_DA_OP_REPLACE)) {
> -			ASSERT(xfs_has_attr2(dp->i_mount));
>  			ASSERT(dp->i_df.if_format != XFS_DINODE_FMT_BTREE);
>  			xfs_attr_fork_remove(dp, args->trans);
>  		}
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index d954f9b8071f4b..80bdb537fcf783 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -997,8 +997,7 @@ xfs_bmap_add_attrfork_local(
>  static int
>  xfs_bmap_set_attrforkoff(
>  	struct xfs_inode	*ip,
> -	int			size,
> -	int			*version)
> +	int			size)
>  {
>  	int			default_size = xfs_default_attroffset(ip) >> 3;
> 
> @@ -1012,8 +1011,6 @@ xfs_bmap_set_attrforkoff(
>  		ip->i_forkoff = xfs_attr_shortform_bytesfit(ip, size);
>  		if (!ip->i_forkoff)
>  			ip->i_forkoff = default_size;
> -		else if (xfs_has_attr2(ip->i_mount) && version)
> -			*version = 2;
>  		break;
>  	default:
>  		ASSERT(0);
> @@ -1035,7 +1032,6 @@ xfs_bmap_add_attrfork(
>  	int			rsvd)		/* xact may use reserved blks */
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
> -	int			version = 1;	/* superblock attr version */
>  	int			logflags;	/* logging flags */
>  	int			error;		/* error return value */
> 
> @@ -1045,7 +1041,7 @@ xfs_bmap_add_attrfork(
>  	ASSERT(!xfs_inode_has_attr_fork(ip));
> 
>  	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -	error = xfs_bmap_set_attrforkoff(ip, size, &version);
> +	error = xfs_bmap_set_attrforkoff(ip, size);
>  	if (error)
>  		return error;
> 
> @@ -1069,16 +1065,12 @@ xfs_bmap_add_attrfork(
>  		xfs_trans_log_inode(tp, ip, logflags);
>  	if (error)
>  		return error;
> -	if (!xfs_has_attr(mp) ||
> -	   (!xfs_has_attr2(mp) && version == 2)) {
> +	if (!xfs_has_attr(mp)) {
>  		bool log_sb = false;
> 
>  		spin_lock(&mp->m_sb_lock);
>  		if (!xfs_has_attr(mp)) {
>  			xfs_add_attr(mp);
> -			log_sb = true;
> -		}
> -		if (!xfs_has_attr2(mp) && version == 2) {
>  			xfs_add_attr2(mp);
>  			log_sb = true;
>  		}
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 750111634d9f7b..5fefdd4fe75dbd 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2140,7 +2140,7 @@ xfs_difree_inobt(
>  	 * remove the chunk if the block size is large enough for multiple inode
>  	 * chunks (that might not be free).
>  	 */
> -	if (!xfs_has_ikeep(mp) && rec.ir_free == XFS_INOBT_ALL_FREE &&
> +	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
>  	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
>  		xic->deleted = true;
>  		xic->first_ino = xfs_agino_to_ino(pag, rec.ir_startino);
> @@ -2286,7 +2286,7 @@ xfs_difree_finobt(
>  	 * enough for multiple chunks. Leave the finobt record to remain in sync
>  	 * with the inobt.
>  	 */
> -	if (!xfs_has_ikeep(mp) && rec.ir_free == XFS_INOBT_ALL_FREE &&
> +	if (rec.ir_free == XFS_INOBT_ALL_FREE &&
>  	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
>  		error = xfs_btree_delete(cur, &i);
>  		if (error)
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 711e180f9ebb83..cdd16dd805d77c 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -142,8 +142,6 @@ xfs_sb_version_to_features(
>  	if (sbp->sb_versionnum & XFS_SB_VERSION_MOREBITSBIT) {
>  		if (sbp->sb_features2 & XFS_SB_VERSION2_LAZYSBCOUNTBIT)
>  			features |= XFS_FEAT_LAZYSBCOUNT;
> -		if (sbp->sb_features2 & XFS_SB_VERSION2_ATTR2BIT)
> -			features |= XFS_FEAT_ATTR2;
>  		if (sbp->sb_features2 & XFS_SB_VERSION2_PROJID32BIT)
>  			features |= XFS_FEAT_PROJID32;
>  		if (sbp->sb_features2 & XFS_SB_VERSION2_FTYPE)
> @@ -155,7 +153,7 @@ xfs_sb_version_to_features(
> 
>  	/* Always on V5 features */
>  	features |= XFS_FEAT_ALIGN | XFS_FEAT_LOGV2 | XFS_FEAT_EXTFLG |
> -		    XFS_FEAT_LAZYSBCOUNT | XFS_FEAT_ATTR2 | XFS_FEAT_PROJID32 |
> +		    XFS_FEAT_LAZYSBCOUNT | XFS_FEAT_PROJID32 |
>  		    XFS_FEAT_V3INODES | XFS_FEAT_CRC | XFS_FEAT_PQUOTINO;
> 
>  	/* Optional V5 features */
> @@ -1524,7 +1522,8 @@ xfs_fs_geometry(
>  	geo->version = XFS_FSOP_GEOM_VERSION;
>  	geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
>  		     XFS_FSOP_GEOM_FLAGS_DIRV2 |
> -		     XFS_FSOP_GEOM_FLAGS_EXTFLG;
> +		     XFS_FSOP_GEOM_FLAGS_EXTFLG |
> +		     XFS_FSOP_GEOM_FLAGS_ATTR2;
>  	if (xfs_has_attr(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR;
>  	if (xfs_has_quota(mp))
> @@ -1537,8 +1536,6 @@ xfs_fs_geometry(
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_DIRV2CI;
>  	if (xfs_has_lazysbcount(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_LAZYSB;
> -	if (xfs_has_attr2(mp))
> -		geo->flags |= XFS_FSOP_GEOM_FLAGS_ATTR2;
>  	if (xfs_has_projid32(mp))
>  		geo->flags |= XFS_FSOP_GEOM_FLAGS_PROJID32;
>  	if (xfs_has_crc(mp))
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 4cf7abe5014371..e44040206851fc 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -646,8 +646,7 @@ xfs_iget_cache_miss(
>  		goto out_destroy;
> 
>  	/*
> -	 * For version 5 superblocks, if we are initialising a new inode and we
> -	 * are not utilising the XFS_FEAT_IKEEP inode cluster mode, we can
> +	 * For version 5 superblocks, if we are initialising a new inode, we
>  	 * simply build the new inode core with a random generation number.
>  	 *
>  	 * For version 4 (and older) superblocks, log recovery is dependent on
> @@ -655,8 +654,7 @@ xfs_iget_cache_miss(
>  	 * value and hence we must also read the inode off disk even when
>  	 * initializing new inodes.
>  	 */
> -	if (xfs_has_v3inodes(mp) &&
> -	    (flags & XFS_IGET_CREATE) && !xfs_has_ikeep(mp)) {
> +	if (xfs_has_v3inodes(mp) && (flags & XFS_IGET_CREATE)) {
>  		VFS_I(ip)->i_generation = get_random_u32();
>  	} else {
>  		struct xfs_buf		*bp;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index dc32c5e34d8176..0953f6ae94abc8 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1057,19 +1057,6 @@ xfs_mountfs(
>  	xfs_inodegc_start(mp);
>  	xfs_blockgc_start(mp);
> 
> -	/*
> -	 * Now that we've recovered any pending superblock feature bit
> -	 * additions, we can finish setting up the attr2 behaviour for the
> -	 * mount. The noattr2 option overrides the superblock flag, so only
> -	 * check the superblock feature flag if the mount option is not set.
> -	 */
> -	if (xfs_has_noattr2(mp)) {
> -		mp->m_features &= ~XFS_FEAT_ATTR2;
> -	} else if (!xfs_has_attr2(mp) &&
> -		   (mp->m_sb.sb_features2 & XFS_SB_VERSION2_ATTR2BIT)) {
> -		mp->m_features |= XFS_FEAT_ATTR2;
> -	}
> -
>  	if (xfs_has_metadir(mp)) {
>  		error = xfs_mount_setup_metadir(mp);
>  		if (error)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bb0a82635a770d..77acb3e5a4eca1 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -105,8 +105,8 @@ enum {
>  	Opt_logbufs, Opt_logbsize, Opt_logdev, Opt_rtdev,
>  	Opt_wsync, Opt_noalign, Opt_swalloc, Opt_sunit, Opt_swidth, Opt_nouuid,
>  	Opt_grpid, Opt_nogrpid, Opt_bsdgroups, Opt_sysvgroups,
> -	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32, Opt_ikeep,
> -	Opt_noikeep, Opt_largeio, Opt_nolargeio, Opt_attr2, Opt_noattr2,
> +	Opt_allocsize, Opt_norecovery, Opt_inode64, Opt_inode32,
> +	Opt_largeio, Opt_nolargeio,
>  	Opt_filestreams, Opt_quota, Opt_noquota, Opt_usrquota, Opt_grpquota,
>  	Opt_prjquota, Opt_uquota, Opt_gquota, Opt_pquota,
>  	Opt_uqnoenforce, Opt_gqnoenforce, Opt_pqnoenforce, Opt_qnoenforce,
> @@ -133,12 +133,8 @@ static const struct fs_parameter_spec xfs_fs_parameters[] = {
>  	fsparam_flag("norecovery",	Opt_norecovery),
>  	fsparam_flag("inode64",		Opt_inode64),
>  	fsparam_flag("inode32",		Opt_inode32),
> -	fsparam_flag("ikeep",		Opt_ikeep),
> -	fsparam_flag("noikeep",		Opt_noikeep),
>  	fsparam_flag("largeio",		Opt_largeio),
>  	fsparam_flag("nolargeio",	Opt_nolargeio),
> -	fsparam_flag("attr2",		Opt_attr2),
> -	fsparam_flag("noattr2",		Opt_noattr2),
>  	fsparam_flag("filestreams",	Opt_filestreams),
>  	fsparam_flag("quota",		Opt_quota),
>  	fsparam_flag("noquota",		Opt_noquota),
> @@ -175,13 +171,11 @@ xfs_fs_show_options(
>  {
>  	static struct proc_xfs_info xfs_info_set[] = {
>  		/* the few simple ones we can get from the mount struct */
> -		{ XFS_FEAT_IKEEP,		",ikeep" },
>  		{ XFS_FEAT_WSYNC,		",wsync" },
>  		{ XFS_FEAT_NOALIGN,		",noalign" },
>  		{ XFS_FEAT_SWALLOC,		",swalloc" },
>  		{ XFS_FEAT_NOUUID,		",nouuid" },
>  		{ XFS_FEAT_NORECOVERY,		",norecovery" },
> -		{ XFS_FEAT_ATTR2,		",attr2" },
>  		{ XFS_FEAT_FILESTREAMS,		",filestreams" },
>  		{ XFS_FEAT_GRPID,		",grpid" },
>  		{ XFS_FEAT_DISCARD,		",discard" },
> @@ -1087,15 +1081,6 @@ xfs_finish_flags(
>  		}
>  	}
> 

Looks good.

I'm sure you already have it planned, but just being paranoid... Will
you consider updating xfsprogs too? :)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> -	/*
> -	 * V5 filesystems always use attr2 format for attributes.
> -	 */
> -	if (xfs_has_crc(mp) && xfs_has_noattr2(mp)) {
> -		xfs_warn(mp, "Cannot mount a V5 filesystem as noattr2. "
> -			     "attr2 is always enabled for V5 filesystems.");
> -		return -EINVAL;
> -	}
> -
>  	/*
>  	 * prohibit r/w mounts of read-only filesystems
>  	 */
> @@ -1542,22 +1527,6 @@ xfs_fs_parse_param(
>  		return 0;
>  #endif
>  	/* Following mount options will be removed in September 2025 */
> -	case Opt_ikeep:
> -		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_IKEEP, true);
> -		parsing_mp->m_features |= XFS_FEAT_IKEEP;
> -		return 0;
> -	case Opt_noikeep:
> -		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_IKEEP, false);
> -		parsing_mp->m_features &= ~XFS_FEAT_IKEEP;
> -		return 0;
> -	case Opt_attr2:
> -		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_ATTR2, true);
> -		parsing_mp->m_features |= XFS_FEAT_ATTR2;
> -		return 0;
> -	case Opt_noattr2:
> -		xfs_fs_warn_deprecated(fc, param, XFS_FEAT_NOATTR2, true);
> -		parsing_mp->m_features |= XFS_FEAT_NOATTR2;
> -		return 0;
>  	case Opt_max_open_zones:
>  		parsing_mp->m_max_open_zones = result.uint_32;
>  		return 0;
> @@ -1593,16 +1562,6 @@ xfs_fs_validate_params(
>  		return -EINVAL;
>  	}
> 
> -	/*
> -	 * We have not read the superblock at this point, so only the attr2
> -	 * mount option can set the attr2 feature by this stage.
> -	 */
> -	if (xfs_has_attr2(mp) && xfs_has_noattr2(mp)) {
> -		xfs_warn(mp, "attr2 and noattr2 cannot both be specified.");
> -		return -EINVAL;
> -	}
> -
> -
>  	if (xfs_has_noalign(mp) && (mp->m_dalign || mp->m_swidth)) {
>  		xfs_warn(mp,
>  	"sunit and swidth options incompatible with the noalign option");
> @@ -2177,21 +2136,6 @@ xfs_fs_reconfigure(
>  	if (error)
>  		return error;
> 
> -	/* attr2 -> noattr2 */
> -	if (xfs_has_noattr2(new_mp)) {
> -		if (xfs_has_crc(mp)) {
> -			xfs_warn(mp,
> -			"attr2 is always enabled for a V5 filesystem - can't be changed.");
> -			return -EINVAL;
> -		}
> -		mp->m_features &= ~XFS_FEAT_ATTR2;
> -		mp->m_features |= XFS_FEAT_NOATTR2;
> -	} else if (xfs_has_attr2(new_mp)) {
> -		/* noattr2 -> attr2 */
> -		mp->m_features &= ~XFS_FEAT_NOATTR2;
> -		mp->m_features |= XFS_FEAT_ATTR2;
> -	}
> -
>  	/* Validate new max_atomic_write option before making other changes */
>  	if (mp->m_awu_max_bytes != new_mp->m_awu_max_bytes) {
>  		error = xfs_set_max_atomic_write_opt(mp,
> 
