Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE038314D03
	for <linux-xfs@vger.kernel.org>; Tue,  6 Jan 2026 16:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767716992; cv=none; b=m0VLszYBO2UBIDweyMMqFKlNF4/cGSH8XW2naspPdX/Qvi1uifi19LNl+nPlYku+1STZ0rWZRaxaAfkwyJOSswt2nO1yJA9edXB3sP5a6dHUUjBp2XeSb7yq/AgQXb9wuXsriZ6rYlWvGF4YOptj7zwwPRH+H6S8kO19GClV/OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767716992; c=relaxed/simple;
	bh=TRqkENdbzqbXrkPV0lfi5PsLP7p0dhnNssGpSJFh39o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ngPagh9gsNU8qHa5GIcRr9rpmaOikUbgEoFlO6HomUigMMPVOUfnHIf+vLJaXVsTRPPMDmx66UQAjYl7CbAJvLbk+fpjR2yZJUSoblAxjX0qe1Q2RGVR3+MagTnZkhmrYAx63fY6+uDFuWfn0L4eq1796GwXMV63JG8Yvr2WGoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HKwM3EC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HKwM3EC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D8DC116C6;
	Tue,  6 Jan 2026 16:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767716991;
	bh=TRqkENdbzqbXrkPV0lfi5PsLP7p0dhnNssGpSJFh39o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HKwM3EC7fS20rHxJX1Bmkb7pklpBqPHYQvk+tTi8iG6IW2NP3qnOMdg/BNO/oTmQd
	 1GbdKgkrBUlKsx4yJtpjiChBwMetmUldODIpLax2Q7TFZjFiJn5BTQ+nKs7+q0Xn0s
	 efcek3VIDbMXi+MKFRUOEVmVjFUTiF6huyU0lqK6vArh4HFZhh6eiUUVeWcZBtW71y
	 BBc38aKnq3F83gOLOsSWMt0NH5NB+FVibE0fkKaV3X1XY2GBKQNyTpa+kH24kXf4h9
	 xW1Yia3ccme4jcDU0jHSnj1GoQcWCFVNf9CfsXnfAx+YImMtmjgohjTypjVMHWh/hE
	 AWVUNxr5rkfrQ==
Date: Tue, 6 Jan 2026 08:29:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v3 3/6] libfrog: introduce xfrog_report_zones
Message-ID: <20260106162950.GD191501@frogsfrogsfrogs>
References: <20251220025326.209196-1-dlemoal@kernel.org>
 <20251220025326.209196-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220025326.209196-4-dlemoal@kernel.org>

On Sat, Dec 20, 2025 at 11:53:23AM +0900, Damien Le Moal wrote:
> Define the new helper function xfrog_report_zones() to report zones of
> a zoned block device. This function is implemented in the new file
> libfrog/zones.c and defined in the header file libfrog/zones.h.
> 
> xfrog_report_zones() allocates and returns a struct blk_zone_report
> structure. It is the responsibility of the caller to free this
> structure after use.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  libfrog/Makefile |  6 ++++--
>  libfrog/zones.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
>  libfrog/zones.h  | 13 +++++++++++++
>  3 files changed, 59 insertions(+), 2 deletions(-)
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
> index 000000000000..0187edce5fa4
> --- /dev/null
> +++ b/libfrog/zones.c
> @@ -0,0 +1,42 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2025, Western Digital Corporation or its affiliates.
> + */
> +#include "platform_defs.h"
> +#include "zones.h"

Nit:

#include "libfrog/zones.h"

to make it more obvious that we're looking for the libfrog version (on
the off chance /usr/include ever end up with a zones.h).

> +#include <sys/ioctl.h>
> +
> +/* random size that allows efficient processing */
> +#define ZONES_PER_REPORT		16384
> +
> +struct blk_zone_report	*
> +xfrog_report_zones(
> +	int			fd,
> +	uint64_t		sector)
> +{
> +	struct blk_zone_report	*rep;
> +	size_t			rep_size;
> +	int			ret;
> +
> +	rep_size = sizeof(struct blk_zone_report) +
> +		   sizeof(struct blk_zone) * ZONES_PER_REPORT;
> +	rep = calloc(1, rep_size);
> +	if (!rep) {
> +		fprintf(stderr,
> +_("Failed to allocate memory for reporting zones.\n"));
> +		return NULL;
> +	}
> +
> +	rep->sector = sector;
> +	rep->nr_zones = ZONES_PER_REPORT;
> +
> +	ret = ioctl(fd, BLKREPORTZONE, rep);
> +	if (ret) {
> +		fprintf(stderr,
> +_("ioctl(BLKREPORTZONE) failed: %d!\n"), -errno);

Note that eventually gcc & friends will start warning about non-constant
formatting strings because i18n catalogue attacks are a thing now.

<start rant>
aka the Rigellian translation pack maps that string to "Hork fubzzz %s
%s %s %s" and now fprintf walks right off the varargs list and kaboom.

Annoyingly this makes output even worse because the canonical form of
that becomes this monstrosity:

		fprintf(stderr, "%s: %s\n", _("BLKREPORTZONE failed"),
				strerror(-errno));

This also fails because the Rigellians use jack-o-lantern emoji to
separate fields instead of colon-space so I don't know what to do :P
<end rant>

That said, xfsprogs is full of potential i18n catalogue attacks so if
Andrey's cool with it, then I'll go along with it.

(Though I'll at least try to remember not to type out the familiar old
way even though I've been doing it for 30 years.)

> +		free(rep);
> +		return NULL;
> +	}
> +
> +	return rep;

The logic in here looks good, though.

> +}
> diff --git a/libfrog/zones.h b/libfrog/zones.h
> new file mode 100644
> index 000000000000..66df7a426a27
> --- /dev/null
> +++ b/libfrog/zones.h
> @@ -0,0 +1,13 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2025, Western Digital Corporation or its affiliates.
> + */
> +#ifndef __LIBFROG_ZONE_H__
> +#define __LIBFROG_ZONE_H__
> +
> +#include <stdint.h>
> +#include <linux/blkzoned.h>

Don't put includes in header files, please.  uint64_t should be covered
by platform_defs.h and you can just have a forward declaration of struct
blk_zone_report.

--D

> +
> +struct blk_zone_report	*xfrog_report_zones(int	fd, uint64_t sector);
> +
> +#endif /* __LIBFROG_ZONE_H__ */
> -- 
> 2.52.0
> 
> 
