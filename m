Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F97533EC
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 16:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767717119; cv=none; b=n3/uYc3LtxliKlTalvY7p9Y5h4M6Lo8+95GF+udKXmrfwbcWKjogBTaSLe9tBC5aVghrLnXjFqZscvPFoVa9dz79XJ3PYEYvghs4Taqc39s5TaknzV6XD/1i7r4bIakuLCO0gSexrWWAgjawt1+JQrZXRFB9nZ53+EhBY6ETzIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767717119; c=relaxed/simple;
	bh=Nuq+5p38KYlcXrYfiezBb1E3AWagQbrlgXvaELQkOEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BCBMpT+mIUtryIJaReqR5NzXp/SOYwoFg0TaS0Yxv2DBfGeGaaoHK3XDP/x9jxZlNiAX7AVQ8ak7Os+39ERtsuGR+MGV51qnWDQrOJeUVBkTPT94hHlvJWlmHerbCzj1SVwS8TVngw97y6pa7g8RZhz1jTO1/w3sN9PqYJ0AoBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uXEiDuid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uXEiDuid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13632C116C6;
	Tue,  6 Jan 2026 16:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767717119;
	bh=Nuq+5p38KYlcXrYfiezBb1E3AWagQbrlgXvaELQkOEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uXEiDuid0GoFU+SJkKcQbubMB5KKcPq9t9tB3nZ97Mckd9u8SlS3Qwige58XRRSYv
	 RzEcjr2jN4wXCE2xpOaYDkR2Ijpao6hY+E8loks9l0mlwC/vQuGT+OMzc3ig9H/2DG
	 zAUJvaq6mrkDcx29LqA7G6gf1DHlXeFtKqhSYRO208EJ1UOgNHc+zu76xO45A/XMQL
	 h8UlMmAT1fGVJqK6Ls3TRhRdZLOHb48HAjnT6yy/icw076txopsPgpo4XnONn5x4xj
	 Aj7IhWqEEbjKvs29H7AbJxR6Frxpc/HI16HG5lWGeirCeUBnEx9CvqyroCaABrb4FA
	 1OANRXtGpOQeA==
Date: Tue, 6 Jan 2026 08:31:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v3 4/6] mkfs: use xfrog_report_zones()
Message-ID: <20260106163158.GE191501@frogsfrogsfrogs>
References: <20251220025326.209196-1-dlemoal@kernel.org>
 <20251220025326.209196-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220025326.209196-5-dlemoal@kernel.org>

On Sat, Dec 20, 2025 at 11:53:24AM +0900, Damien Le Moal wrote:
> Use the function xfrog_report_zones() to obtain zone information from
> a zoned device instead of directly issuing a BLKREPORTZONE ioctl.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  mkfs/xfs_mkfs.c | 35 +++++++++--------------------------
>  1 file changed, 9 insertions(+), 26 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 550fc011b614..ac7ad0661805 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -6,7 +6,6 @@
>  #include "libfrog/util.h"
>  #include "libxfs.h"
>  #include <ctype.h>
> -#include <linux/blkzoned.h>
>  #include "libxfs/xfs_zones.h"
>  #include "xfs_multidisk.h"
>  #include "libxcmd.h"
> @@ -15,6 +14,7 @@
>  #include "libfrog/crc32cselftest.h"
>  #include "libfrog/dahashselftest.h"
>  #include "libfrog/fsproperties.h"
> +#include "libfrog/zones.h"
>  #include "proto.h"
>  #include <ini.h>
>  
> @@ -2566,20 +2566,16 @@ struct zone_topology {
>  	struct zone_info	log;
>  };
>  
> -/* random size that allows efficient processing */
> -#define ZONES_PER_IOCTL			16384
> -
>  static void
>  report_zones(
>  	const char		*name,
>  	struct zone_info	*zi)
>  {
> -	struct blk_zone_report	*rep;
> +	struct blk_zone_report	*rep = NULL;
>  	bool			found_seq = false;
> -	int			fd, ret = 0;
> +	int			fd;
>  	uint64_t		device_size;
>  	uint64_t		sector = 0;
> -	size_t			rep_size;
>  	unsigned int		i, n = 0;
>  	struct stat		st;
>  
> @@ -2606,31 +2602,18 @@ report_zones(
>  	zi->nr_zones = device_size / zi->zone_size;
>  	zi->nr_conv_zones = 0;
>  
> -	rep_size = sizeof(struct blk_zone_report) +
> -		   sizeof(struct blk_zone) * ZONES_PER_IOCTL;
> -	rep = malloc(rep_size);
> -	if (!rep) {
> -		fprintf(stderr,
> -_("Failed to allocate memory for zone reporting.\n"));
> -		exit(1);
> -	}
> -
>  	while (n < zi->nr_zones) {
> -		struct blk_zone *zones = (struct blk_zone *)(rep + 1);
> +		struct blk_zone *zones;
>  
> -		memset(rep, 0, rep_size);
> -		rep->sector = sector;
> -		rep->nr_zones = ZONES_PER_IOCTL;
> -
> -		ret = ioctl(fd, BLKREPORTZONE, rep);
> -		if (ret) {
> -			fprintf(stderr,
> -_("ioctl(BLKREPORTZONE) failed: %d!\n"), -errno);
> +		free(rep);
> +		rep = xfrog_report_zones(fd, sector);

Now that I see the actual usage patterns I wonder if this would be more
efficient if you had a separate allocator function to avoid repeatedly
freeing and re-allocating the buffer?

Also this could be combined with the previous patch since you're really
just hoisting code from mkfs to libfrog.

--D

> +		if (!rep)
>  			exit(1);
> -		}
> +
>  		if (!rep->nr_zones)
>  			break;
>  
> +		zones = (struct blk_zone *)(rep + 1);
>  		for (i = 0; i < rep->nr_zones; i++) {
>  			if (n >= zi->nr_zones)
>  				break;
> -- 
> 2.52.0
> 
> 
