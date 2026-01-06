Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F59200C2
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 16:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767717270; cv=none; b=SHw/5ragtxkCj8abixvvITKp1OnsRVqzjq1/mRPGkJsVOE1rFlRS1ZxE09or3mhAKKJKs/lf3bJU416QElF5C+CZFQv1tkc/oXqLbc01DHDxyuS4i1ZjT6kujIzwMSEiNAYOFz96HitQaRC0al+TV6diaNnU7qGh4UlY0RGcrmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767717270; c=relaxed/simple;
	bh=yIgA4csgcQh//5YP/NCFEuAmEc3v5RpzsbcoQdtK3lU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYKPCq0f5e92mHc+ZLLZumAlDASfQIVK4pBMtNhvpTcNHGd9FdD/JZaj+u87L+Z5PDOWmr1t+ffkQ7iI4pxVIc59BQCIzdi/Q/4xFfay42O0uLDvayMFHqMAUitcDf6jMcToypLDa7qHjpyo7WBGXjeEyBSZdUE00mYXLrMcZKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=poqzzDkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="poqzzDkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E0DC16AAE;
	Tue,  6 Jan 2026 16:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767717270;
	bh=yIgA4csgcQh//5YP/NCFEuAmEc3v5RpzsbcoQdtK3lU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=poqzzDkvZJqpwav7vQvfK9CtGRgw3F7l4i6ClXT3cGwrZVCMgc9txc9aKg+dKufcI
	 VTjkcNzCVMrbFPQH36qKDIlye6Jrd12R5AOz6ZT7+zrtqN6hDs27EacHubp1ygJ61f
	 VnI3JGojzJsS4VbXBQwbmGdrfBpGsD0WGxUX4Qzn5Gz4ocD67rSethquVcs7WTUEQ5
	 SrdZWSScrUNfgb3UuAfGpB22NQsTA2DLrQsNzIKXwFoA7Cy2cFvo3WNT2UikIXPM59
	 TwJwu7AQjs2IomXvc6E0WvELflLQfWFkb9E63i6BMRP2+fIVUMFbjH/o30bqRBP/ej
	 Xp64OuPp350kw==
Date: Tue, 6 Jan 2026 08:34:29 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v3 6/6] libfrog: enable cached report zones
Message-ID: <20260106163429.GF191501@frogsfrogsfrogs>
References: <20251220025326.209196-1-dlemoal@kernel.org>
 <20251220025326.209196-7-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220025326.209196-7-dlemoal@kernel.org>

On Sat, Dec 20, 2025 at 11:53:26AM +0900, Damien Le Moal wrote:
> Modify the function xfrog_report_zones() to default to always trying
> first a cached report zones using the BLKREPORTZONEV2 ioctl.
> If the kernel does not support BLKREPORTZONEV2, fall back to the
> (slower) regular report zones BLKREPORTZONE ioctl.
> 
> TO enable this feature even if xfsprogs is compiled on a system where
> linux/blkzoned.h does not define BLKREPORTZONEV2, this ioctl is defined
> in libfrog/zones.h, together with the BLK_ZONE_REP_CACHED flag and the
> BLK_ZONE_COND_ACTIVE zone condition.
> 
> Since a cached report zone  always return the condition
> BLK_ZONE_COND_ACTIVE for any zone that is implicitly open, explicitly
> open or closed, the function xfs_zone_validate_seq() is modified to
> handle this new condition as being equivalent to the implicit open,
> explicit open or closed conditions.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  libfrog/zones.c    | 11 ++++++++++-
>  libfrog/zones.h    |  9 +++++++++
>  libxfs/xfs_zones.c |  3 ++-
>  3 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/libfrog/zones.c b/libfrog/zones.c
> index 0187edce5fa4..8b45066de176 100644
> --- a/libfrog/zones.c
> +++ b/libfrog/zones.c
> @@ -27,10 +27,19 @@ _("Failed to allocate memory for reporting zones.\n"));
>  		return NULL;
>  	}
>  
> +	/*
> +	 * Try cached report zones first. If this fails, fallback to the regular
> +	 * (slower) report zones.
> +	 */
>  	rep->sector = sector;
>  	rep->nr_zones = ZONES_PER_REPORT;
> +	rep->flags = BLK_ZONE_REP_CACHED;
>  
> -	ret = ioctl(fd, BLKREPORTZONE, rep);
> +	ret = ioctl(fd, BLKREPORTZONEV2, rep);
> +	if (ret < 0 && errno == ENOTTY) {
> +		rep->flags = 0;
> +		ret = ioctl(fd, BLKREPORTZONE, rep);
> +	}
>  	if (ret) {
>  		fprintf(stderr,
>  _("ioctl(BLKREPORTZONE) failed: %d!\n"), -errno);
> diff --git a/libfrog/zones.h b/libfrog/zones.h
> index 66df7a426a27..4605aea93114 100644
> --- a/libfrog/zones.h
> +++ b/libfrog/zones.h
> @@ -8,6 +8,15 @@
>  #include <stdint.h>
>  #include <linux/blkzoned.h>
>  
> +/*
> + * Cached report ioctl (/usr/include/linux/blkzoned.h)
> + */
> +#ifndef BLKREPORTZONEV2
> +#define BLKREPORTZONEV2		_IOWR(0x12, 142, struct blk_zone_report)
> +#define BLK_ZONE_REP_CACHED	(1U << 31)
> +#define BLK_ZONE_COND_ACTIVE	0xff

Of these three definitions, only BLK_ZONE_COND_ACTIVE is actually used
outside of libfrog/zones.c, right?  I suggest defining BLKREPORTZONEV2
and BLK_ZONE_REP_CACHED there instead of zones.h to reduce the number of
symbols floating around.

(The rest of the code changes look ok to me)

--D

> +#endif
> +
>  struct blk_zone_report	*xfrog_report_zones(int	fd, uint64_t sector);
>  
>  #endif /* __LIBFROG_ZONE_H__ */
> diff --git a/libxfs/xfs_zones.c b/libxfs/xfs_zones.c
> index 7a81d83f5b3e..3c89a89ca21e 100644
> --- a/libxfs/xfs_zones.c
> +++ b/libxfs/xfs_zones.c
> @@ -3,7 +3,7 @@
>   * Copyright (c) 2023-2025 Christoph Hellwig.
>   * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
>   */
> -#include <linux/blkzoned.h>
> +#include <libfrog/zones.h>
>  #include "libxfs_priv.h"
>  #include "xfs.h"
>  #include "xfs_fs.h"
> @@ -97,6 +97,7 @@ xfs_zone_validate_seq(
>  	case BLK_ZONE_COND_IMP_OPEN:
>  	case BLK_ZONE_COND_EXP_OPEN:
>  	case BLK_ZONE_COND_CLOSED:
> +	case BLK_ZONE_COND_ACTIVE:
>  		return xfs_zone_validate_wp(zone, rtg, write_pointer);
>  	case BLK_ZONE_COND_FULL:
>  		return xfs_zone_validate_full(zone, rtg, write_pointer);
> -- 
> 2.52.0
> 
> 
