Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E851A8412
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 20:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734036279; cv=none; b=XpFPXcSl9CRRz+aLQaV/c0R6PPO6ioUc6LgZYIdAe6sp2XWJtSHUVL5YdMIa+2tKfqWYqOCiUIpYsTPXNnUbzGqdcJsUEy1p06dh3FDzFpfi0W4j+Yh7ExbnM+JMgPpEOENw+0HwWR4haJiX6+mITRTK4hLeIkMa+tEOxbvUa4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734036279; c=relaxed/simple;
	bh=mfb803ATRXf6kZ0NpzEP6vo93rMT/f7KrNdVlyoMKTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ovW7ag0WY2xQYC/B/X0NF6phcpa0RgSPSWXf5162E2DJUKQ3wrl8D639qayTtciiyp3mUXBH9OFYN1/hIK6l6BdbkOtQWIIRi3L5PmzyNyAH1TdNGA9IGXmhu85Q5yneAKyNKtlWyal4aCOBIRJQ+4ZV9QXm1DI3eQzblxGRgq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hJEiSSrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJEiSSrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0014CC4CECE;
	Thu, 12 Dec 2024 20:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734036279;
	bh=mfb803ATRXf6kZ0NpzEP6vo93rMT/f7KrNdVlyoMKTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hJEiSSrzeXWqIO0/fEqbZkpiIg4JNgXVfYNTgA+WSXXeBVDYekFCV3dtaI7l8wZbv
	 5I7THmHo8k7cPNBqfhhkg+gyJBurl+yin3M8ljCrtWNG17JDTWEidMOqWNax9z/eht
	 mL3gaxYgbTznQIn+1lfu7mLp/LV+OTc++ObPhQMgUxckHFXtEPNPLsOl6lw5kj7paT
	 9z6+gFY29hCZyPFnRahLzqmJ3eJuhmQtmQDxM2POmd/TCkzkomadkf6bgdv00k5TiS
	 UBJ+tgWPBiAdWXhTvNLqpvp5ZuyKnVLLt8lziy4diG7wzTNdpV61I4DLO7iZhdkxIs
	 PAvWXjc8p7VAw==
Date: Thu, 12 Dec 2024 12:44:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/43] xfs: constify feature checks
Message-ID: <20241212204438.GM6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-2-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:26AM +0100, Christoph Hellwig wrote:
> We'll need to call them on a const structure in growfs in a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_rtgroup.c |  2 +-
>  fs/xfs/scrub/scrub.h        |  2 +-
>  fs/xfs/xfs_mount.h          | 10 +++++-----
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> index a6468e591232..d84d32f1b48f 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.c
> +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> @@ -338,7 +338,7 @@ struct xfs_rtginode_ops {
>  	unsigned int		fmt_mask; /* all valid data fork formats */
>  
>  	/* Does the fs have this feature? */
> -	bool			(*enabled)(struct xfs_mount *mp);
> +	bool			(*enabled)(const struct xfs_mount *mp);
>  
>  	/* Create this rtgroup metadata inode and initialize it. */
>  	int			(*create)(struct xfs_rtgroup *rtg,
> diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
> index a1086f1f06d0..a3f1abc91390 100644
> --- a/fs/xfs/scrub/scrub.h
> +++ b/fs/xfs/scrub/scrub.h
> @@ -96,7 +96,7 @@ struct xchk_meta_ops {
>  	int		(*repair_eval)(struct xfs_scrub *sc);
>  
>  	/* Decide if we even have this piece of metadata. */
> -	bool		(*has)(struct xfs_mount *);
> +	bool		(*has)(const struct xfs_mount *);
>  
>  	/* type describing required/allowed inputs */
>  	enum xchk_type	type;
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 9a1516080e63..fbed172d6770 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -357,7 +357,7 @@ typedef struct xfs_mount {
>  #define XFS_FEAT_NOUUID		(1ULL << 63)	/* ignore uuid during mount */
>  
>  #define __XFS_HAS_FEAT(name, NAME) \
> -static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
> +static inline bool xfs_has_ ## name (const struct xfs_mount *mp) \
>  { \
>  	return mp->m_features & XFS_FEAT_ ## NAME; \
>  }
> @@ -393,25 +393,25 @@ __XFS_HAS_FEAT(large_extent_counts, NREXT64)
>  __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
>  __XFS_HAS_FEAT(metadir, METADIR)
>  
> -static inline bool xfs_has_rtgroups(struct xfs_mount *mp)
> +static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
>  {
>  	/* all metadir file systems also allow rtgroups */
>  	return xfs_has_metadir(mp);
>  }
>  
> -static inline bool xfs_has_rtsb(struct xfs_mount *mp)
> +static inline bool xfs_has_rtsb(const struct xfs_mount *mp)
>  {
>  	/* all rtgroups filesystems with an rt section have an rtsb */
>  	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp);
>  }
>  
> -static inline bool xfs_has_rtrmapbt(struct xfs_mount *mp)
> +static inline bool xfs_has_rtrmapbt(const struct xfs_mount *mp)
>  {
>  	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp) &&
>  	       xfs_has_rmapbt(mp);
>  }
>  
> -static inline bool xfs_has_rtreflink(struct xfs_mount *mp)
> +static inline bool xfs_has_rtreflink(const struct xfs_mount *mp)
>  {
>  	return xfs_has_metadir(mp) && xfs_has_realtime(mp) &&
>  	       xfs_has_reflink(mp);
> -- 
> 2.45.2
> 
> 
