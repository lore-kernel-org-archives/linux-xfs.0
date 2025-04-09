Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6A86268C78
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 15:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744213638; cv=none; b=X2PE8fPNefNuzhHpFBzEzSQLt/edqOZkW4sCyQxr5XSE4wSB978evZ885g0gaBEpefynG1ekI9qHcaM6fnn5XQkhk8kRZRUHcN5FNnnywjZEI4zG0Ng8ENlviXDl3oLQxL3UxBrsUucyYpWfjZgBtbe+9luljnHe9Z/Pm81ZYxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744213638; c=relaxed/simple;
	bh=wqIv9D290oe1Tf14tWYmEhj+jYmhTfzn+pU+vE/75U4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aC30E3tSv/mriudQxT4Qlntf5s/HtwLgP5JH6BWfvJFlOMbSPsmkGT5cjorFS9JBcHmoBMH85TDzCzm0KBeLZF7whmY1d0dB7oonCBLGCCUCNsuCgcSdnaDsfNfmxZsIrziXQrYA2ppE2HzsDnnRRhRUnsfSPuoatDnyeqo/wzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oB0fV5cI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oB0fV5cI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 224F3C4CEE2;
	Wed,  9 Apr 2025 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744213636;
	bh=wqIv9D290oe1Tf14tWYmEhj+jYmhTfzn+pU+vE/75U4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oB0fV5cIDPkW06TG5YFz11LnbHwTPikbzu1C5CjCM4eoF8Nygz7X8FN/uQJLPqdJr
	 H/nKY2/hOFs55+9pOPlWFJoAqPtmdmHxU1EBz7OMfzp3K8fGGyl3NczJreixoRWf8c
	 X8BB366zRPTM+DdI1wSc7uoi4XZUnGzaZv1klm9xo6t65xQ5tHwKCpjJijeq4sA55C
	 OYlTt79M7O+Ta2uLKvA0e/geRfOHOBxKMgUsmWgQX5MQkyZ58i6hOWbIP2AwCv2YcN
	 4GVLWTWdmPc2/FpW0N1ULf2YVtZjpfKfYutEMOluYEaSvHdLWgIfJBFoAM2VyZAZy1
	 mWkh0MEQOXzzw==
Date: Wed, 9 Apr 2025 08:47:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/45] FIXUP: xfs: define the zoned on-disk format
Message-ID: <20250409154715.GU6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-12-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-12-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:14AM +0200, Christoph Hellwig wrote:

No SoB?

Eh whatever it's going to get folded into the previous patch anyway so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/xfs_inode.h |  6 ++++++
>  include/xfs_mount.h | 12 ++++++++++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> index 5bb31eb4aa53..efef0da636d1 100644
> --- a/include/xfs_inode.h
> +++ b/include/xfs_inode.h
> @@ -234,6 +234,7 @@ typedef struct xfs_inode {
>  	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
>  	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
>  	union {
> +		uint32_t	i_used_blocks;
>  		xfs_extlen_t	i_cowextsize;	/* basic cow extent size */
>  		uint16_t	i_flushiter;	/* incremented on flush */
>  	};
> @@ -361,6 +362,11 @@ static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
>  }
>  #define XFS_IS_REALTIME_INODE(ip) ((ip)->i_diflags & XFS_DIFLAG_REALTIME)
>  
> +static inline bool xfs_is_zoned_inode(struct xfs_inode *ip)
> +{
> +	return xfs_has_zoned(ip->i_mount) && XFS_IS_REALTIME_INODE(ip);
> +}
> +
>  /* inode link counts */
>  static inline void set_nlink(struct inode *inode, uint32_t nlink)
>  {
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 0acf952eb9d7..7856acfb9f8e 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -207,6 +207,7 @@ typedef struct xfs_mount {
>  #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
>  #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
>  #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
> +#define XFS_FEAT_ZONED		(1ULL << 29)	/* zoned RT device */
>  
>  #define __XFS_HAS_FEAT(name, NAME) \
>  static inline bool xfs_has_ ## name (const struct xfs_mount *mp) \
> @@ -253,7 +254,7 @@ __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
>  __XFS_HAS_FEAT(large_extent_counts, NREXT64)
>  __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
>  __XFS_HAS_FEAT(metadir, METADIR)
> -
> +__XFS_HAS_FEAT(zoned, ZONED)
>  
>  static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
>  {
> @@ -264,7 +265,9 @@ static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
>  static inline bool xfs_has_rtsb(const struct xfs_mount *mp)
>  {
>  	/* all rtgroups filesystems with an rt section have an rtsb */
> -	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp);
> +	return xfs_has_rtgroups(mp) &&
> +		xfs_has_realtime(mp) &&
> +		!xfs_has_zoned(mp);
>  }
>  
>  static inline bool xfs_has_rtrmapbt(const struct xfs_mount *mp)
> @@ -279,6 +282,11 @@ static inline bool xfs_has_rtreflink(const struct xfs_mount *mp)
>  	       xfs_has_reflink(mp);
>  }
>  
> +static inline bool xfs_has_nonzoned(const struct xfs_mount *mp)
> +{
> +	return !xfs_has_zoned(mp);
> +}
> +
>  /* Kernel mount features that we don't support */
>  #define __XFS_UNSUPP_FEAT(name) \
>  static inline bool xfs_has_ ## name (const struct xfs_mount *mp) \
> -- 
> 2.47.2
> 
> 
