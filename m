Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE7526CE2C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 05:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769577003; cv=none; b=J8NHjpZAiRc1YM6jVsBXhVz4C+a5tJIAp2svrsJYeuZMSyg34D45c0Ts2KSFtk0Nk4tc2LGgScrqyD6nz8NxoDx14zvtw3Z1i/b3HdbcdyM7P96R/P9/C8HJ15wTKgDeQ8s4KV2BaYM7UwhXlgNuvtRHXbOEkSQu+srNC8sWTY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769577003; c=relaxed/simple;
	bh=8XQ5DPcBZqXMG79pY4Wt4f4s8XevQ78UkQUrmcNoQWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kue4qgE4upvVZq/OcPbnm9uf2E98huP2FEQof10xtuB9g/6GnjMSrfQNHZXD0GwHOnyomrZJdu/Kf8E1/2q9X9DP/O4Avbi/7gB9LFVM881yqiG6IHVkuwVPbTZPjoB3TDDzbcSniFYUWN9B5blZTU21p3HLKf9Tv5XqMAPeLVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OXxRZrMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OXxRZrMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E204AC4CEF1;
	Wed, 28 Jan 2026 05:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769577003;
	bh=8XQ5DPcBZqXMG79pY4Wt4f4s8XevQ78UkQUrmcNoQWs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OXxRZrMG/fpzmHVeIaM7KgvZNtngZNY5ppWyDOaMWIPJ4nN6bmSfSh8gV03xnPFrP
	 WbbzC8O7+R0aKDgSayLcC6gpyaydf2B3+AQ9sdZ/vxT3WizrRLnWhj1llxxZ1746yx
	 xqXqJE0egdpKw57wHYsW1GbJ2O6ChNSJfDOqgXHtU1kF9sEiRDQfBanmX1gZn6MRKH
	 aydq2NDtBEA9oxogvbhDQxmjGb8nvCP5hJVOqiMVwkvWCfzvYSDRpYg3M8LcFpu9N9
	 AWcqAgq0G48KBJjx0GIJZOalvxyd2zhu2Iju5BwrLfl9h1SLL9cvB8pDYFfSWhjgBW
	 Rr7kuQheNE1IA==
Date: Tue, 27 Jan 2026 21:10:02 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] libfrog: enable cached report zones
Message-ID: <20260128051002.GP5945@frogsfrogsfrogs>
References: <20260128043318.522432-1-hch@lst.de>
 <20260128043318.522432-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128043318.522432-6-hch@lst.de>

On Wed, Jan 28, 2026 at 05:32:59AM +0100, Christoph Hellwig wrote:
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
> [hch: don't try cached reporting again if not supported]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/platform_defs.h |  6 ++++++
>  libfrog/zones.c         | 22 +++++++++++++++++++++-
>  2 files changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/include/platform_defs.h b/include/platform_defs.h
> index 1a9f401fc11c..09129e0f22dc 100644
> --- a/include/platform_defs.h
> +++ b/include/platform_defs.h
> @@ -312,6 +312,12 @@ struct kvec {
>   * Local definitions for the new cached report zones added in Linux 6.19 in case
>   * the system <linux/blkzoned.h> doesn't provide them yet.
>   */
> +#ifndef BLKREPORTZONEV2
> +#define BLKREPORTZONEV2		_IOWR(0x12, 142, struct blk_zone_report)
> +#endif
> +#ifndef BLK_ZONE_REP_CACHED
> +#define BLK_ZONE_REP_CACHED	(1U << 31)
> +#endif
>  #ifndef BLK_ZONE_COND_ACTIVE
>  #define BLK_ZONE_COND_ACTIVE	0xff
>  #endif
> diff --git a/libfrog/zones.c b/libfrog/zones.c
> index 2276c56bec9c..c088d3240545 100644
> --- a/libfrog/zones.c
> +++ b/libfrog/zones.c
> @@ -3,12 +3,15 @@
>   * Copyright (c) 2025, Western Digital Corporation or its affiliates.
>   */
>  #include "platform_defs.h"
> +#include "atomic.h"
>  #include "libfrog/zones.h"
>  #include <sys/ioctl.h>
>  
>  /* random size that allows efficient processing */
>  #define ZONES_PER_REPORT		16384
>  
> +static atomic_t cached_reporting_disabled;
> +
>  struct xfrog_zone_report *
>  xfrog_report_zones(
>  	int			fd,
> @@ -24,10 +27,27 @@ _("Failed to allocate memory for reporting zones."));
>  		}
>  	}
>  
> +	/*
> +	 * Try cached report zones first. If this fails, fallback to the regular
> +	 * (slower) report zones.
> +	 */
>  	rep->rep.sector = sector;
>  	rep->rep.nr_zones = ZONES_PER_REPORT;
>  
> -	if (ioctl(fd, BLKREPORTZONE, &rep->rep)) {
> +	if (atomic_read(&cached_reporting_disabled))
> +		goto uncached;
> +
> +	rep->rep.flags = BLK_ZONE_REP_CACHED;
> +	if (ioctl(fd, BLKREPORTZONEV2, &rep->rep)) {
> +		atomic_inc(&cached_reporting_disabled);
> +		goto uncached;
> +	}
> +
> +	return rep;
> +
> +uncached:
> +	rep->rep.flags = 0;
> +	if (ioctl(fd, BLKREPORTZONE, rep)) {
>  		fprintf(stderr, "%s %s\n",
>  _("ioctl(BLKREPORTZONE) failed:\n"),
>  			strerror(-errno));
> -- 
> 2.47.3
> 
> 
