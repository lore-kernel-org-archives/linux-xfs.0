Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A182825619
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 17:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710871150; cv=none; b=WH60fgKdXvd/JYGO4emQo4F3NxQMuWZ8TCdHKZhfR/r36o4M6NcIyUfvkBycVREP15fgCOOxrDv8+mdxhj0WWbp4vifUrvJ44FnmZYzBiWnx/Zgy2QBly0ZzsD1dWhN8c0guuUykIZwUbMBRQjvRGgt7T17MCujvQXtFMjA7neA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710871150; c=relaxed/simple;
	bh=J2sFucbPfukJTQcpfheec7F4TEO5pDMIfBkVakvlJK4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ji8yTC4/lWcffBa5xJ9sx9lA6zxUO968Hx7hje+dABi1XZCCfAX1pxU9KrU4Bba4iwTGKuQUfZqc2UircFlG5k4j0shEc7PMF/84diq1WVYNQAeH5usTNyVa+eQjp7Ya/TV10Kji9zkNvHZ3EG0/Nu6wVamSrwi2gh3v83hOrs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pEBTi6gi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pEBTi6gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C94C433F1;
	Tue, 19 Mar 2024 17:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710871150;
	bh=J2sFucbPfukJTQcpfheec7F4TEO5pDMIfBkVakvlJK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pEBTi6gidASmnE1v8VmFLFnlVYw4tjMSTm8b4zABRBoKmngYL5YgqoZUy4V9ltneC
	 Weo09GmpKBK063fW+9EZCz3HoAfSUeIC+C7apXW6H0puh4v2AGk61J0w09ZiEGNVRk
	 ezgGVwcBU4KtGT20AJnUOFXLF9dG6OubbW4mPGRXU5pDQAv0SHFTD4LTmoBTTmuE7J
	 TBwBErmsmAig6T5K21KH4O4sEvJMTk57II6AipNuIUj199EPibBcZBRKu4+jBlDOcS
	 iAkiMTUlnv9RvgvzhKcYiQmO89NPjPjcSjnY7IDFkuEPC2chw3bORtP7/BNMRRzUX8
	 beiPdvgV3G2Ig==
Date: Tue, 19 Mar 2024 10:59:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: compile out v4 support if disabled
Message-ID: <20240319175909.GY1927156@frogsfrogsfrogs>
References: <20240319071952.682266-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319071952.682266-1-hch@lst.de>

On Tue, Mar 19, 2024 at 05:19:51PM +1000, Christoph Hellwig wrote:
> Add a strategic IS_ENABLED to let the compiler eliminate the unused
> non-crc code is CONFIG_XFS_SUPPORT_V4 is disabled.
> 
> This saves almost 20k worth of .text for my .config:
> 
> $ size xfs.o.*
>    text	   data	    bss	    dec	    hex	filename
> 1351126	 294836	    592	1646554	 191fda	xfs.o.new
> 1371453	 294868	    592	1666913	 196f61	xfs.o.old
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_mount.h |  7 ++++++-
>  fs/xfs/xfs_super.c | 22 +++++++++++++---------
>  2 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index e880aa48de68bb..24fe6e7913c49f 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -327,6 +327,12 @@ static inline void xfs_add_ ## name (struct xfs_mount *mp) \
>  	xfs_sb_version_add ## name(&mp->m_sb); \
>  }
>  
> +static inline bool xfs_has_crc(struct xfs_mount *mp)
> +{
> +	return IS_ENABLED(CONFIG_XFS_SUPPORT_V4) &&
> +		(mp->m_features & XFS_FEAT_CRC);

Can you save even more text bytes by defining
xfs_has_{nlink,v3inodes,projid32,lazysbcount,pquotino,attr2} to 1?
And I guess defining noattr2 to 0?

--D

> +}
> +
>  /* Superblock features */
>  __XFS_ADD_FEAT(attr, ATTR)
>  __XFS_HAS_FEAT(nlink, NLINK)
> @@ -341,7 +347,6 @@ __XFS_HAS_FEAT(lazysbcount, LAZYSBCOUNT)
>  __XFS_ADD_FEAT(attr2, ATTR2)
>  __XFS_HAS_FEAT(parent, PARENT)
>  __XFS_ADD_FEAT(projid32, PROJID32)
> -__XFS_HAS_FEAT(crc, CRC)
>  __XFS_HAS_FEAT(v3inodes, V3INODES)
>  __XFS_HAS_FEAT(pquotino, PQUOTINO)
>  __XFS_HAS_FEAT(ftype, FTYPE)
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 6828c48b15e9bd..7d972e1179255b 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1580,17 +1580,21 @@ xfs_fs_fill_super(
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
> 
