Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1236718E361
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 13:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736775490; cv=none; b=ka6iCIvUe8HEpgdfqD/4stl+vR6ted8bNKGapIGCcVv0CcVkfufHJLzVH0rC9F89rC2Z+wm2EQLbZwc7jTdCo0reQ1S8BDKC7XcyF5k/4VyudKEz/sjEUJ9+n/vnwhu7e+mtwAwV0KAgy1KCGahbyz+q+gmG2ieZN0AysmEQziM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736775490; c=relaxed/simple;
	bh=qzKbb0FHdLOJ7EX8vAqjbc1rTodWM3F24fbCnUYZzW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jQPYkg3fKmdCcAq8L09jy31z1qq2wjuUW/j3Yp7F897mzV5JsAbE3P7ciPGB7vV+RoOYRnezxosfDM1WYa0x2WlVGl7f4LrfJCz0zSDWwJjTrW9vcYn7TOD9617oZhxh7FzF9OnCV/1MjtAeQRQx3ylJAB256Fw20ar1euORGvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tyfeQaJW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tyfeQaJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D31C4CED6;
	Mon, 13 Jan 2025 13:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736775489;
	bh=qzKbb0FHdLOJ7EX8vAqjbc1rTodWM3F24fbCnUYZzW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tyfeQaJWhF+9NQQAXNnVofJRgsqLbLpLwmLn5tOr9PDxwUZmPIPDQlsBz8u4X62ly
	 oV97OgtyHRgaXh5pXbtNJ8bXt4kVLJHslpI9FLOtRt6HIKEYmf3ZsC/ZfLt0XFKhh0
	 owdgCT+62xGfkBLv2vvTg3GiQG/gPDRAw410WA1cYo4qdS2pG8R7hcAbT4zTnwKguO
	 OS5O9qO7NeeySERlOnJTH8QDg0WOF4InFPTvrP8S4Me9NgRcCOoOU/nlWQrVM1jKxk
	 HbSSX0y2YaJfajR1N3d1aVLAx1IuAAwA3sZvjLK9e6+Hg2L7ytxBK4nD+8MTJev1Qd
	 PYYtO8W57hxKQ==
Date: Mon, 13 Jan 2025 14:38:05 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: constify feature checks
Message-ID: <goshy6s23gknojjukqaxiduh5remfy43uqcycltt6ep4q4vnza@7f2hazzrcqoa>
References: <20250113043120.2054080-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113043120.2054080-1-hch@lst.de>

On Mon, Jan 13, 2025 at 05:31:20AM +0100, Christoph Hellwig wrote:
> They will eventually be needed to be const for zoned growfs, but even
> now having such simpler helpers as const as possible is a good thing.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Looks good to me.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
