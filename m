Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93887136A
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 00:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711411358; cv=none; b=BTvQf9O/GB2fQCuxdkvWBVMtdjxJnk7tXR7h5ca1to0UwFI6uFqWegmFnaIKX0qR3NsrrfpmD/RtR8dBsc0OPuPwSRsIVMOKZcR0Z+ZDBfESXCw4m/KYpdPJVZpeyixvEhUuJoLE82pzgghrmVbQ3rZ51iJK6EZdxgGfLPgKaC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711411358; c=relaxed/simple;
	bh=CUXrbhUobqmWq64FWS3dCjMREw/siETjtOmRqfplPRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LA/XX4aoTodA7XInbJhVGkGMmICf4gK+lG1tR3M+lTTF0HNtJRdZN4zTN712wFk6Z06eIhY7wSMiV73BxOXmEJ9PreRxCX2MpygxHUtprN+fgPDkKDtAxTpR5bS3osTOyb4UC/ucsLFGCgMbDHIqcGKAAOhMWH1XqFJ9JSubpyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=loobvWtO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="loobvWtO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E11DC433C7;
	Tue, 26 Mar 2024 00:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711411358;
	bh=CUXrbhUobqmWq64FWS3dCjMREw/siETjtOmRqfplPRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=loobvWtOJHA+U+niP5TCeDQj4Um6+2z6FvoKpO+aniEzI7dKmXmMUlVE3vASU3umm
	 QP8cHe9UASqSJ4bLmb8EI910/GvbEgt3NJX5YJMieV61MQrxzEyz1aKQg6NK8rbshD
	 4mTvDokNjsJQKLScIy3S9K6K2/PxZvXzPRoVaEHVfuidXK3wbxHpv+/Tn5MTVlZAYs
	 qF2yDNMdLmql/H0VTUSx3UwHpDOd71RUsNb2uJG6xXCN20qcGSLPaAN8EesZM4lTfN
	 mZcIQJcU56nPNz0B9cO3+SC0hAQO6aRqORAwFdmrh08hJcn8pBFWVvs76wNSipmcZw
	 nhRVB7yiUD89Q==
Date: Mon, 25 Mar 2024 17:02:37 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: compile out v4 support if disabled
Message-ID: <20240326000237.GG6414@frogsfrogsfrogs>
References: <20240325031318.2052017-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325031318.2052017-1-hch@lst.de>

On Mon, Mar 25, 2024 at 11:13:18AM +0800, Christoph Hellwig wrote:
> Add a few strategic IS_ENABLED statements to let the compiler eliminate
> unused code when CONFIG_XFS_SUPPORT_V4 is disabled.
> 
> This saves multiple kilobytes of .text in my .config:
> 
> $ size xfs.o.*
> text	   data	    bss	    dec	    hex	filename
> 1363633	 294836	    592	1659061	 1950b5	xfs.o.new
> 1371453	 294868	    592	1666913	 196f61	xfs.o.old
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
> 
> Changes since v1:
>  - compile out the right bits, and more of them
> 
>  fs/xfs/xfs_mount.h | 40 +++++++++++++++++++++++++++++++---------
>  fs/xfs/xfs_super.c | 22 +++++++++++++---------
>  2 files changed, 44 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 0e8d7779c0a561..85e327bf05041f 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -337,19 +337,10 @@ static inline void xfs_add_ ## name (struct xfs_mount *mp) \
>  __XFS_ADD_FEAT(attr, ATTR)
>  __XFS_HAS_FEAT(nlink, NLINK)
>  __XFS_ADD_FEAT(quota, QUOTA)
> -__XFS_HAS_FEAT(align, ALIGN)
>  __XFS_HAS_FEAT(dalign, DALIGN)
> -__XFS_HAS_FEAT(logv2, LOGV2)
>  __XFS_HAS_FEAT(sector, SECTOR)
> -__XFS_HAS_FEAT(extflg, EXTFLG)
>  __XFS_HAS_FEAT(asciici, ASCIICI)
> -__XFS_HAS_FEAT(lazysbcount, LAZYSBCOUNT)
> -__XFS_ADD_FEAT(attr2, ATTR2)
>  __XFS_HAS_FEAT(parent, PARENT)
> -__XFS_ADD_FEAT(projid32, PROJID32)
> -__XFS_HAS_FEAT(crc, CRC)
> -__XFS_HAS_FEAT(v3inodes, V3INODES)
> -__XFS_HAS_FEAT(pquotino, PQUOTINO)
>  __XFS_HAS_FEAT(ftype, FTYPE)
>  __XFS_HAS_FEAT(finobt, FINOBT)
>  __XFS_HAS_FEAT(rmapbt, RMAPBT)
> @@ -362,6 +353,37 @@ __XFS_HAS_FEAT(bigtime, BIGTIME)
>  __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
>  __XFS_HAS_FEAT(large_extent_counts, NREXT64)
>  
> +/*
> + * Some features are always on for v5 file systems, allow the compiler to
> + * eliminiate dead code when building without v4 support.
> + */
> +#define __XFS_HAS_V4_FEAT(name, NAME) \

Shouldn't this be called __XFS_HAS_V5_FEAT?

> +static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
> +{ \
> +	return !IS_ENABLED(CONFIG_XFS_SUPPORT_V4) || \
> +		(mp->m_features & XFS_FEAT_ ## NAME); \
> +}
> +
> +#define __XFS_ADD_V4_FEAT(name, NAME) \
> +	__XFS_HAS_V4_FEAT(name, NAME); \

This too?

The rest of the patch looks ok. :)

--D

> +static inline void xfs_add_ ## name (struct xfs_mount *mp) \
> +{ \
> +	if (IS_ENABLED(CONFIG_XFS_SUPPORT_V4)) { \
> +		mp->m_features |= XFS_FEAT_ ## NAME; \
> +		xfs_sb_version_add ## name(&mp->m_sb); \
> +	} \
> +}
> +
> +__XFS_HAS_V4_FEAT(align, ALIGN)
> +__XFS_HAS_V4_FEAT(logv2, LOGV2)
> +__XFS_HAS_V4_FEAT(extflg, EXTFLG)
> +__XFS_HAS_V4_FEAT(lazysbcount, LAZYSBCOUNT)
> +__XFS_ADD_V4_FEAT(attr2, ATTR2)
> +__XFS_ADD_V4_FEAT(projid32, PROJID32)
> +__XFS_HAS_V4_FEAT(v3inodes, V3INODES)
> +__XFS_HAS_V4_FEAT(crc, CRC)
> +__XFS_HAS_V4_FEAT(pquotino, PQUOTINO)
> +
>  /*
>   * Mount features
>   *
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 71732457583370..f325a2d1b3a902 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1589,17 +1589,21 @@ xfs_fs_fill_super(
>  	if (error)
>  		goto out_free_sb;
>  
> -	/* V4 support is undergoing deprecation. */
> -	if (!xfs_has_crc(mp)) {
> -#ifdef CONFIG_XFS_SUPPORT_V4
> +	/*
> +	 * V4 support is undergoing deprecation.
> +	 *
> +	 * Note: this has to use an open coded m_features check as xfs_has_crc
> +	 * always returns false for !CONFIG_XFS_SUPPORT_V4.
> +	 */
> +	if (!(mp->m_features & XFS_FEAT_CRC)) {
> +		if (!IS_ENABLED(CONFIG_XFS_SUPPORT_V4)) {
> +			xfs_warn(mp,
> +	"Deprecated V4 format (crc=0) not supported by kernel.");
> +			error = -EINVAL;
> +			goto out_free_sb;
> +		}
>  		xfs_warn_once(mp,
>  	"Deprecated V4 format (crc=0) will not be supported after September 2030.");
> -#else
> -		xfs_warn(mp,
> -	"Deprecated V4 format (crc=0) not supported by kernel.");
> -		error = -EINVAL;
> -		goto out_free_sb;
> -#endif
>  	}
>  
>  	/* ASCII case insensitivity is undergoing deprecation. */
> -- 
> 2.39.2
> 
