Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115CB32ED29;
	Tue, 10 Mar 2026 01:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773104753; cv=none; b=VT5yaiU3j3gWmWuqpcplzDejGmPz5p5uihGjn8VWq+d+tGXIKULPCM827XVJPgp4i1jrmnJxeZ4NHPNucj3dM6bfLbUhGdE0VN8Ubp3I6TIJ2lHBPNT4Lu45MVK2v2PDLyuf/ZLqdeUpRQbY7kzrfG7f7GNit+LTC4J2cpfVV0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773104753; c=relaxed/simple;
	bh=aUKDupC9eg6IqmhfO1YbMuAZG/32Sgrd20f3Tc9BPdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pJ6G2m3CAVB43lFv+7umqpkPSibV3FeM7p3sJD68oXx7JpkNcnqATDDb1kElFoD+WbS4Ue5nXpHKStBQnLQt/xZcm3OhmLI/eUBpDQhNNepjKfU/ZUpBM4cs8/gH4Pn8685w1yO/asEL+umjiV2C95YkVqfEDljOwLyPPGU8Slo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1jGGpyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1jGGpyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9180CC4CEF7;
	Tue, 10 Mar 2026 01:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104752;
	bh=aUKDupC9eg6IqmhfO1YbMuAZG/32Sgrd20f3Tc9BPdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d1jGGpyiSyUBEjiqzNypUpmXJsTHj07FCWLK6mv7BxQeHbQ9yApuaIyw4iD6hEWZt
	 9UMeBVkNmLvcnwK/b2k3yLspTLZjvNMljELG/Uq3OaGFwCCxdTadxR1qjQxJKmCut3
	 zicmzsUSBiCZFWQ6UbwIx3Sjngu4jGc8Dr3iYHjQzCuZagnbliDwweiHhrwnIaUQy2
	 p3kLWeXgE6xh2p3hNZAkqer9VvdY8S/H4lHStKzbg9ipAWBgZ9aD5ez1tzDlQG0+AR
	 zgxwNdn81hzFjuAfjVrsB5EOA1c4qOO4zInSUv3oGJU5em/WcyqPuz3foFUWsAOezq
	 LhOyEpV9ocTfA==
Date: Mon, 9 Mar 2026 18:05:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 12/25] xfs: introduce fsverity on-disk changes
Message-ID: <20260310010552.GC1105363@frogsfrogsfrogs>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-13-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309192355.176980-13-aalbersh@kernel.org>

On Mon, Mar 09, 2026 at 08:23:27PM +0100, Andrey Albershteyn wrote:
> Introduce XFS_DIFLAG2_VERITY for inodes with fsverity. This flag
> indicates that inode has fs-verity enabled (i.e. descriptor exist,
> tree is built and file is read-only).
> 
> Introduce XFS_SB_FEAT_RO_COMPAT_VERITY for filesystems having
> fsverity inodes. As on-disk changes applies to fsverity inodes only, let
> older kernels read-only access. This will be enabled in the further
> patch after full fsverity support.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_format.h     | 8 +++++++-
>  fs/xfs/libxfs/xfs_inode_buf.c  | 8 ++++++++
>  fs/xfs/libxfs/xfs_inode_util.c | 2 ++
>  fs/xfs/libxfs/xfs_sb.c         | 2 ++
>  fs/xfs/xfs_iops.c              | 2 ++
>  fs/xfs/xfs_mount.h             | 2 ++
>  6 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 779dac59b1f3..d67b404964fc 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -374,6 +374,7 @@ xfs_sb_has_compat_feature(
>  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
>  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
>  #define XFS_SB_FEAT_RO_COMPAT_INOBTCNT (1 << 3)		/* inobt block counts */
> +#define XFS_SB_FEAT_RO_COMPAT_VERITY   (1 << 4)		/* fs-verity */
>  #define XFS_SB_FEAT_RO_COMPAT_ALL \
>  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
>  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> @@ -1230,16 +1231,21 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>   */
>  #define XFS_DIFLAG2_METADATA_BIT	5
>  
> +/* inodes sealed with fs-verity */
> +#define XFS_DIFLAG2_VERITY_BIT		6
> +
>  #define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
>  #define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
>  #define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
>  #define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
>  #define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
>  #define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)
> +#define XFS_DIFLAG2_VERITY	(1ULL << XFS_DIFLAG2_VERITY_BIT)
>  
>  #define XFS_DIFLAG2_ANY \
>  	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
> -	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA)
> +	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA | \
> +	 XFS_DIFLAG2_VERITY)
>  
>  static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
>  {
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index a017016e9075..c5822d938d81 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -756,6 +756,14 @@ xfs_dinode_verify(
>  	    !xfs_has_rtreflink(mp))
>  		return __this_address;
>  
> +	/* only regular files can have fsverity */
> +	if (flags2 & XFS_DIFLAG2_VERITY) {
> +		if (!xfs_has_verity(mp))
> +			return __this_address;
> +		if ((mode & S_IFMT) != S_IFREG)

Nit: This can be S_ISREG(mode)

With that tidied up,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>


--D

> +			return __this_address;
> +	}
> +
>  	if (xfs_has_zoned(mp) &&
>  	    dip->di_metatype == cpu_to_be16(XFS_METAFILE_RTRMAP)) {
>  		if (be32_to_cpu(dip->di_used_blocks) > mp->m_sb.sb_rgextents)
> diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
> index 551fa51befb6..6b1e20a4bb9b 100644
> --- a/fs/xfs/libxfs/xfs_inode_util.c
> +++ b/fs/xfs/libxfs/xfs_inode_util.c
> @@ -126,6 +126,8 @@ xfs_ip2xflags(
>  			flags |= FS_XFLAG_DAX;
>  		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
>  			flags |= FS_XFLAG_COWEXTSIZE;
> +		if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
> +			flags |= FS_XFLAG_VERITY;
>  	}
>  
>  	if (xfs_inode_has_attr_fork(ip))
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 38d16fe1f6d8..4401a5f16344 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -165,6 +165,8 @@ xfs_sb_version_to_features(
>  		features |= XFS_FEAT_REFLINK;
>  	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_INOBTCNT)
>  		features |= XFS_FEAT_INOBTCNT;
> +	if (sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_VERITY)
> +		features |= XFS_FEAT_VERITY;
>  	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_FTYPE)
>  		features |= XFS_FEAT_FTYPE;
>  	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_SPINODES)
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 208543e57eda..ca369eb96561 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -1415,6 +1415,8 @@ xfs_diflags_to_iflags(
>  		flags |= S_NOATIME;
>  	if (init && xfs_inode_should_enable_dax(ip))
>  		flags |= S_DAX;
> +	if (xflags & FS_XFLAG_VERITY)
> +		flags |= S_VERITY;
>  
>  	/*
>  	 * S_DAX can only be set during inode initialization and is never set by
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 61c71128d171..c746bc90cf3e 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -385,6 +385,7 @@ typedef struct xfs_mount {
>  #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
>  #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
>  #define XFS_FEAT_ZONED		(1ULL << 29)	/* zoned RT device */
> +#define XFS_FEAT_VERITY		(1ULL << 30)	/* fs-verity */
>  
>  /* Mount features */
>  #define XFS_FEAT_NOLIFETIME	(1ULL << 47)	/* disable lifetime hints */
> @@ -442,6 +443,7 @@ __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
>  __XFS_HAS_FEAT(metadir, METADIR)
>  __XFS_HAS_FEAT(zoned, ZONED)
>  __XFS_HAS_FEAT(nolifetime, NOLIFETIME)
> +__XFS_HAS_FEAT(verity, VERITY)
>  
>  static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
>  {
> -- 
> 2.51.2
> 
> 
