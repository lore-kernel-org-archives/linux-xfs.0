Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C471EEA31
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976356; cv=none; b=pKQnsDXRjmccZdSVVvGTbylBQCtUeFY2jQfow0zEYAWKMRq44xbj7airmjXnQyG4OJhEc+jsfU5rbWivs8vqRwnmxubmQ6i45gSLlomLQ0EZVrni4KlyFJn71UlGsqQtQSbo/F2h2BSZvwgmBGoRa3g6Wg1ESK9QkTYnIPzwAVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976356; c=relaxed/simple;
	bh=UIvk0hvVqRfNK+023NbEKK56ydAgxoi5b9vLs4lLq+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f9KxsutvtpgIXSs1R6Xnsk8lnKHB459ZHrKrztmr30T1X33dKxF/dZl93RzTUzPWDn4jTyvDKPokZ7zQHBJQB6rBuZDz2H3277yXY6coV9/AyLghx1h/2Y9qIU55YYf6CcdyN2RjKXjkUf/pSs0QlcIZcCPZoRRb3YE1rfJ6Cc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3T1sKcN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3T1sKcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B540EC4CEF1;
	Fri,  9 Jan 2026 16:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767976355;
	bh=UIvk0hvVqRfNK+023NbEKK56ydAgxoi5b9vLs4lLq+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z3T1sKcNCtDi/mFgRb62n30d8pD6j2/tCQ+/48rM0r0t/4pJqnBHk+5l3KSFL0dij
	 FFj2VNV+22oy1vXzmwaCHwCQnifVCa9MUIYuCYQ+M2uqmiMcEEzqHbsm1hoyQufE0g
	 yYJuEBb/AKuWOP8KIf39dRoAtbAXsXCXzLPJHyie8KZ1V76c5h3fm61+RJKWSH+znc
	 ADsymJsSsnBuUv4mOO6ZvhEe5TTCDiVpN8emXF4YzWBQiRFG+74jtc7wA7unP+gymC
	 fDcGB/iY5eJ2Cym/kPz0sbccYGAAYVxPPvcy8eXKbUD+vgaxY59l/YqdWmrLq7TFcw
	 VuNVNHvoXxt/A==
Date: Fri, 9 Jan 2026 08:32:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] libfrog: enable cached report zones
Message-ID: <20260109163235.GT15551@frogsfrogsfrogs>
References: <20260109162324.2386829-1-hch@lst.de>
 <20260109162324.2386829-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109162324.2386829-5-hch@lst.de>

On Fri, Jan 09, 2026 at 05:22:55PM +0100, Christoph Hellwig wrote:
> From: Damien Le Moal <dlemoal@kernel.org>
> 
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

That's an amusing use of atomic_t :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libfrog/zones.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/libfrog/zones.c b/libfrog/zones.c
> index 2276c56bec9c..f1ef0b24c564 100644
> --- a/libfrog/zones.c
> +++ b/libfrog/zones.c
> @@ -3,12 +3,24 @@
>   * Copyright (c) 2025, Western Digital Corporation or its affiliates.
>   */
>  #include "platform_defs.h"
> +#include "atomic.h"
>  #include "libfrog/zones.h"
>  #include <sys/ioctl.h>
>  
> +/*
> + * Cached report ioctl (/usr/include/linux/blkzoned.h).
> + * Add in Linux 6.19.
> + */
> +#ifndef BLKREPORTZONEV2
> +#define BLKREPORTZONEV2		_IOWR(0x12, 142, struct blk_zone_report)
> +#define BLK_ZONE_REP_CACHED	(1U << 31)
> +#endif /* BLKREPORTZONEV2 */
> +
>  /* random size that allows efficient processing */
>  #define ZONES_PER_REPORT		16384
>  
> +static atomic_t cached_reporting_disabled;
> +
>  struct xfrog_zone_report *
>  xfrog_report_zones(
>  	int			fd,
> @@ -24,10 +36,27 @@ _("Failed to allocate memory for reporting zones."));
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
