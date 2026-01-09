Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1807813D51E
	for <linux-xfs@vger.kernel.org>; Fri,  9 Jan 2026 16:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976297; cv=none; b=mwIvU6+g8Vde7/DpVnkvoq+ABwFQgdZR+JeSyj0F2pL56YYCxQoiD2w/dnyB0w0wJIJZmFku31Rb+SH+G/wusBnXFaUHb2ASA44j14igJ06vX6c7/OrnnyD/JsV/bGP4ev30QMbghNU0OwnKzin3oWNmdTdxgUk+kLRSFFcKEfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976297; c=relaxed/simple;
	bh=VQq9QPye8aWv54kIU4m1DZlnAKS3koNHRdTQ8VQcgWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QHMQuXLrDWR/PCk2klZe866xsGyLmfCiJoFowlYLLMfbBYVFXmCqL2TNHMQN7JtFtciSMeKj+yHCGMwxqTUfvb2Ax7PYnQsxLWVuiIWj9D/ZXdiZt/VLL2HPBN0vT4N14z2eHti7cS2opXcTymvuq7YUMZ6kHGh7zz/AB/Ti2Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cfGAbh3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cfGAbh3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6225C4CEF1;
	Fri,  9 Jan 2026 16:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767976297;
	bh=VQq9QPye8aWv54kIU4m1DZlnAKS3koNHRdTQ8VQcgWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cfGAbh3oKryczuz42sFtpByiAlr67zhFJw+5I0zmXC3YP6QCPSd4crPgzERyR0XNx
	 rhbQCMxoKJQMpVrOMcXAqENgNgndicgQk4nXynrdBM1JYCLK3SxZN9jzekoX98NQGN
	 qFPthqxyxp9qHcI4H56m3BSosyiXWaVqHL+tBwTUjY7vpAcri2GCoxiR8DKeQrrnVu
	 cp2jEnIkWUPdhTQ26yMQTEKXdXFveTQTBpm/ubnfuMJmFpeDBPyV11nPPWh19aJojZ
	 9SurL/XsGO9QLyrDVDJM9yp/UsE1l3K9+P6HeUVg275quAX0BKR4kJVArOSFjuJuWx
	 G1z/FzwPE+Rsw==
Date: Fri, 9 Jan 2026 08:31:36 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] libfrog: lift common zone reporting code from mkfs
 and repair
Message-ID: <20260109163136.GS15551@frogsfrogsfrogs>
References: <20260109162324.2386829-1-hch@lst.de>
 <20260109162324.2386829-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109162324.2386829-4-hch@lst.de>

On Fri, Jan 09, 2026 at 05:22:54PM +0100, Christoph Hellwig wrote:
> From: Damien Le Moal <dlemoal@kernel.org>
> 
> Define the new helper function xfrog_report_zones() to report zones of
> a zoned block device.  This function is implemented in the new file
> libfrog/zones.c and defined in the header file libfrog/zones.h and
> use it from mkfs and repair instead of the previous open coded versions.
> 
> xfrog_report_zones() allocates and returns a struct blk_zone_report
> structure, which can be be reused by subsequent invocations.  It is the
> responsibility of the caller to free this structure after use.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> [hch: refactored to allow buffer reuse]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now, thanx for avoiding the buffer reallocations
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libfrog/Makefile |  6 ++++--
>  libfrog/zones.c  | 39 +++++++++++++++++++++++++++++++++++++++
>  libfrog/zones.h  | 18 ++++++++++++++++++
>  mkfs/xfs_mkfs.c  | 41 ++++++++++++-----------------------------
>  repair/zoned.c   | 35 +++++++++++------------------------
>  5 files changed, 84 insertions(+), 55 deletions(-)
>  create mode 100644 libfrog/zones.c
>  create mode 100644 libfrog/zones.h
> 
> diff --git a/libfrog/Makefile b/libfrog/Makefile
> index 268fa26638d7..9f405ffe3475 100644
> --- a/libfrog/Makefile
> +++ b/libfrog/Makefile
> @@ -35,7 +35,8 @@ radix-tree.c \
>  randbytes.c \
>  scrub.c \
>  util.c \
> -workqueue.c
> +workqueue.c \
> +zones.c
>  
>  HFILES = \
>  avl64.h \
> @@ -65,7 +66,8 @@ radix-tree.h \
>  randbytes.h \
>  scrub.h \
>  statx.h \
> -workqueue.h
> +workqueue.h \
> +zones.h
>  
>  GETTEXT_PY = \
>  	gettext.py
> diff --git a/libfrog/zones.c b/libfrog/zones.c
> new file mode 100644
> index 000000000000..2276c56bec9c
> --- /dev/null
> +++ b/libfrog/zones.c
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2025, Western Digital Corporation or its affiliates.
> + */
> +#include "platform_defs.h"
> +#include "libfrog/zones.h"
> +#include <sys/ioctl.h>
> +
> +/* random size that allows efficient processing */
> +#define ZONES_PER_REPORT		16384
> +
> +struct xfrog_zone_report *
> +xfrog_report_zones(
> +	int			fd,
> +	uint64_t		sector,
> +	struct xfrog_zone_report *rep)
> +{
> +	if (!rep) {
> +		rep = calloc(1, struct_size(rep, zones, ZONES_PER_REPORT));
> +		if (!rep) {
> +			fprintf(stderr, "%s\n",
> +_("Failed to allocate memory for reporting zones."));
> +			return NULL;
> +		}
> +	}
> +
> +	rep->rep.sector = sector;
> +	rep->rep.nr_zones = ZONES_PER_REPORT;
> +
> +	if (ioctl(fd, BLKREPORTZONE, &rep->rep)) {
> +		fprintf(stderr, "%s %s\n",
> +_("ioctl(BLKREPORTZONE) failed:\n"),
> +			strerror(-errno));
> +		free(rep);
> +		return NULL;
> +	}
> +
> +	return rep;
> +}
> diff --git a/libfrog/zones.h b/libfrog/zones.h
> new file mode 100644
> index 000000000000..33c1da7ef192
> --- /dev/null
> +++ b/libfrog/zones.h
> @@ -0,0 +1,18 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2025, Western Digital Corporation or its affiliates.
> + */
> +#ifndef __LIBFROG_ZONES_H__
> +#define __LIBFROG_ZONES_H__
> +
> +#include <linux/blkzoned.h>
> +
> +struct xfrog_zone_report {
> +	struct blk_zone_report	rep;
> +	struct blk_zone		zones[];
> +};
> +
> +struct xfrog_zone_report *
> +xfrog_report_zones(int fd, uint64_t sector, struct xfrog_zone_report *rep);
> +
> +#endif /* __LIBFROG_ZONES_H__ */
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 215cff8db7b1..9c165f29c298 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -15,6 +15,7 @@
>  #include "libfrog/crc32cselftest.h"
>  #include "libfrog/dahashselftest.h"
>  #include "libfrog/fsproperties.h"
> +#include "libfrog/zones.h"
>  #include "proto.h"
>  #include <ini.h>
>  
> @@ -2542,9 +2543,6 @@ struct zone_topology {
>  	struct zone_info	log;
>  };
>  
> -/* random size that allows efficient processing */
> -#define ZONES_PER_IOCTL			16384
> -
>  static void
>  zone_validate_capacity(
>  	struct zone_info	*zi,
> @@ -2572,12 +2570,11 @@ report_zones(
>  	const char		*name,
>  	struct zone_info	*zi)
>  {
> -	struct blk_zone_report	*rep;
> +	struct xfrog_zone_report *rep = NULL;
>  	bool			found_seq = false;
> -	int			fd, ret = 0;
> +	int			fd;
>  	uint64_t		device_size;
>  	uint64_t		sector = 0;
> -	size_t			rep_size;
>  	unsigned int		i, n = 0;
>  	struct stat		st;
>  
> @@ -2604,32 +2601,18 @@ report_zones(
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
> +		rep = xfrog_report_zones(fd, sector, rep);
> +		if (!rep)
>  			exit(1);
> -		}
> -		if (!rep->nr_zones)
> +
> +		if (!rep->rep.nr_zones)
>  			break;
>  
> -		for (i = 0; i < rep->nr_zones; i++) {
> +		zones = rep->zones;
> +		for (i = 0; i < rep->rep.nr_zones; i++) {
>  			if (n >= zi->nr_zones)
>  				break;
>  
> @@ -2676,8 +2659,8 @@ _("Unknown zone type (0x%x) found.\n"), zones[i].type);
>  
>  			n++;
>  		}
> -		sector = zones[rep->nr_zones - 1].start +
> -			 zones[rep->nr_zones - 1].len;
> +		sector = zones[rep->rep.nr_zones - 1].start +
> +			 zones[rep->rep.nr_zones - 1].len;
>  	}
>  
>  	free(rep);
> diff --git a/repair/zoned.c b/repair/zoned.c
> index 206b0158f95f..5102d43e218d 100644
> --- a/repair/zoned.c
> +++ b/repair/zoned.c
> @@ -7,6 +7,7 @@
>  #include "libxfs_priv.h"
>  #include "libxfs.h"
>  #include "xfs_zones.h"
> +#include "libfrog/zones.h"
>  #include "err_protos.h"
>  #include "zoned.h"
>  
> @@ -51,8 +52,7 @@ check_zones(
>  	uint64_t		sector = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
>  	unsigned int		zone_size, zone_capacity;
>  	uint64_t		device_size;
> -	size_t			rep_size;
> -	struct blk_zone_report	*rep;
> +	struct xfrog_zone_report *rep = NULL;
>  	unsigned int		i, n = 0;
>  
>  	if (ioctl(fd, BLKGETSIZE64, &device_size))
> @@ -67,31 +67,18 @@ check_zones(
>  		return;
>  	}
>  
> -	rep_size = sizeof(struct blk_zone_report) +
> -		   sizeof(struct blk_zone) * ZONES_PER_IOCTL;
> -	rep = malloc(rep_size);
> -	if (!rep) {
> -		do_warn(_("malloc failed for zone report\n"));
> -		return;
> -	}
> -
>  	while (n < mp->m_sb.sb_rgcount) {
> -		struct blk_zone *zones = (struct blk_zone *)(rep + 1);
> -		int ret;
> +		struct blk_zone *zones;
>  
> -		memset(rep, 0, rep_size);
> -		rep->sector = sector;
> -		rep->nr_zones = ZONES_PER_IOCTL;
> +		rep = xfrog_report_zones(fd, sector, rep);
> +		if (!rep)
> +			return;
>  
> -		ret = ioctl(fd, BLKREPORTZONE, rep);
> -		if (ret) {
> -			do_error(_("ioctl(BLKREPORTZONE) failed: %d!\n"), ret);
> -			goto out_free;
> -		}
> -		if (!rep->nr_zones)
> +		if (!rep->rep.nr_zones)
>  			break;
>  
> -		for (i = 0; i < rep->nr_zones; i++) {
> +		zones = rep->zones;
> +		for (i = 0; i < rep->rep.nr_zones; i++) {
>  			if (n >= mp->m_sb.sb_rgcount)
>  				break;
>  
> @@ -130,8 +117,8 @@ _("Inconsistent zone capacity!\n"));
>  			report_zones_cb(mp, &zones[i]);
>  			n++;
>  		}
> -		sector = zones[rep->nr_zones - 1].start +
> -			 zones[rep->nr_zones - 1].len;
> +		sector = zones[rep->rep.nr_zones - 1].start +
> +			 zones[rep->rep.nr_zones - 1].len;
>  	}
>  
>  out_free:
> -- 
> 2.47.3
> 
> 
