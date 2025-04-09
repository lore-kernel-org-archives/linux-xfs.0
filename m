Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4D7278149
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 18:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224076; cv=none; b=B2QVELHJtV+JpREELPE1P+e254vqpbg/yo+Kh0HvZCsKbAhDmLwUG9xuGlMBDK2+X1gq0Mb8VOhXsrYiCpLqorDMwP4dvpmAlV5LzabIoh8ABuIXXNEDVLH3VYrvMnC7Zw+Wy4bWes8loM31qTmQmxUzN/9+nQgE8jLxCDZifs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224076; c=relaxed/simple;
	bh=lWKdxWicH/AR6MyKKg5KOQ1DSslhf6NT0Kk3bXAhRQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQr5w7vyAoMvbBY2NrcX8bZv7mWwLCpPtjET+wi7MXNoqVkROWg4apFhv3xuC7dRnwWL7VJm40DPDDjy7oOghClrkLVYgv6A/VN53S2YJn5tY5FSOj6opbYt7h4mra9rKs8Id4JLUYQgLAjlrDPwt4JzRaUb8bkBKPVVcs0kkOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nO/MjuRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nO/MjuRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8F0C4CEE8;
	Wed,  9 Apr 2025 18:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744224073;
	bh=lWKdxWicH/AR6MyKKg5KOQ1DSslhf6NT0Kk3bXAhRQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nO/MjuRjZFdP2QYRBIaKlDnA8BkbwvKjCxykJ82+fM8aeAmtUlmtxJy4U6gl5fu+P
	 jnIabKuEgx/TFOThaDnQF/zP4O7ldTHi6OMUhM3y7O8ASCOv1efy+WuF3E2ETjDQh6
	 aTVKQYzHPH23/zuR6LDSvk3Re530TGPfQHpTdCG9/MI7vBzAoGAHdwLjP+FqpctBMA
	 H1JZ4GbOy/NQrcMZlr4Oc1/XOni1nFf9So/so35pKTMvw6gRt0XBPdIkm443SE/Ka3
	 uTtUrSkhgVVAQK0ww7rXk8JYLh4SdwprwxGRDYmuWGU9p4fS1bQWv/Qe72S/vT0Q4U
	 S9gb87jE2xtIw==
Date: Wed, 9 Apr 2025 11:41:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/45] xfs_repair: validate rt groups vs reported
 hardware zones
Message-ID: <20250409184112.GE6283@frogsfrogsfrogs>
References: <20250409075557.3535745-1-hch@lst.de>
 <20250409075557.3535745-30-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409075557.3535745-30-hch@lst.de>

On Wed, Apr 09, 2025 at 09:55:32AM +0200, Christoph Hellwig wrote:
> Run a report zones ioctl, and verify the rt group state vs the
> reported hardware zone state.  Note that there is no way to actually
> fix up any discrepancies here, as that would be rather scary without
> having transactions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/Makefile |   1 +
>  repair/phase5.c |  11 +---
>  repair/zoned.c  | 136 ++++++++++++++++++++++++++++++++++++++++++++++++
>  repair/zoned.h  |  10 ++++
>  4 files changed, 149 insertions(+), 9 deletions(-)
>  create mode 100644 repair/zoned.c
>  create mode 100644 repair/zoned.h
> 
> diff --git a/repair/Makefile b/repair/Makefile
> index ff5b1f5abeda..fb0b2f96cc91 100644
> --- a/repair/Makefile
> +++ b/repair/Makefile
> @@ -81,6 +81,7 @@ CFILES = \
>  	strblobs.c \
>  	threads.c \
>  	versions.c \
> +	zoned.c \
>  	xfs_repair.c
>  
>  LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
> diff --git a/repair/phase5.c b/repair/phase5.c
> index e350b411c243..e44c26885717 100644
> --- a/repair/phase5.c
> +++ b/repair/phase5.c
> @@ -21,6 +21,7 @@
>  #include "rmap.h"
>  #include "bulkload.h"
>  #include "agbtree.h"
> +#include "zoned.h"
>  
>  static uint64_t	*sb_icount_ag;		/* allocated inodes per ag */
>  static uint64_t	*sb_ifree_ag;		/* free inodes per ag */
> @@ -631,15 +632,7 @@ check_rtmetadata(
>  	struct xfs_mount	*mp)
>  {
>  	if (xfs_has_zoned(mp)) {
> -		/*
> -		 * Here we could/should verify the zone state a bit when we are
> -		 * on actual zoned devices:
> -		 *	- compare hw write pointer to last written
> -		 *	- compare zone state to last written
> -		 *
> -		 * Note much we can do when running in zoned mode on a
> -		 * conventional device.
> -		 */
> +		check_zones(mp);
>  		return;
>  	}
>  
> diff --git a/repair/zoned.c b/repair/zoned.c
> new file mode 100644
> index 000000000000..06b2a08dff39
> --- /dev/null
> +++ b/repair/zoned.c
> @@ -0,0 +1,136 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2024 Christoph Hellwig.
> + */
> +#include <ctype.h>
> +#include <linux/blkzoned.h>
> +#include "libxfs_priv.h"
> +#include "libxfs.h"
> +#include "xfs_zones.h"
> +#include "err_protos.h"
> +#include "zoned.h"
> +
> +/* random size that allows efficient processing */
> +#define ZONES_PER_IOCTL			16384
> +
> +static void
> +report_zones_cb(
> +	struct xfs_mount	*mp,
> +	struct blk_zone		*zone)
> +{
> +	xfs_fsblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);

        ^^^^^^^^^^^^^ nit: xfs_rtblock_t ?

> +	xfs_rgblock_t		write_pointer;
> +	xfs_rgnumber_t		rgno;
> +	struct xfs_rtgroup	*rtg;
> +
> +	if (xfs_rtb_to_rgbno(mp, zsbno) != 0) {
> +		do_error(_("mismatched zone start 0x%llx."),
> +				(unsigned long long)zsbno);
> +		return;
> +	}
> +
> +	rgno = xfs_rtb_to_rgno(mp, zsbno);
> +	rtg = xfs_rtgroup_grab(mp, rgno);
> +	if (!rtg) {
> +		do_error(_("realtime group not found for zone %u."), rgno);
> +		return;
> +	}
> +
> +	if (!rtg_rmap(rtg))
> +		do_warn(_("no rmap inode for zone %u."), rgno);
> +	else
> +		xfs_zone_validate(zone, rtg, &write_pointer);
> +	xfs_rtgroup_rele(rtg);
> +}
> +
> +void check_zones(struct xfs_mount *mp)
> +{
> +	int fd = mp->m_rtdev_targp->bt_bdev_fd;
> +	uint64_t sector = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
> +	unsigned int zone_size, zone_capacity;
> +	struct blk_zone_report *rep;
> +	unsigned int i, n = 0;
> +	uint64_t device_size;
> +	size_t rep_size;

Nit: inconsistent styles in declaration indentation
> +
> +	if (ioctl(fd, BLKGETSIZE64, &device_size))
> +		return; /* not a block device */
> +	if (ioctl(fd, BLKGETZONESZ, &zone_size) || !zone_size)
> +		return;	/* not zoned */
> +
> +	device_size /= 512; /* BLKGETSIZE64 reports a byte value */

device_size = BTOBB(device_size); ?

> +	if (device_size / zone_size < mp->m_sb.sb_rgcount) {
> +		do_error(_("rt device too small\n"));
> +		return;
> +	}
> +
> +	rep_size = sizeof(struct blk_zone_report) +
> +		   sizeof(struct blk_zone) * ZONES_PER_IOCTL;
> +	rep = malloc(rep_size);
> +	if (!rep) {
> +		do_warn(_("malloc failed for zone report\n"));
> +		return;
> +	}
> +
> +	while (n < mp->m_sb.sb_rgcount) {
> +		struct blk_zone *zones = (struct blk_zone *)(rep + 1);
> +		int ret;
> +
> +		memset(rep, 0, rep_size);
> +		rep->sector = sector;
> +		rep->nr_zones = ZONES_PER_IOCTL;
> +
> +		ret = ioctl(fd, BLKREPORTZONE, rep);
> +		if (ret) {
> +			do_error(_("ioctl(BLKREPORTZONE) failed: %d!\n"), ret);
> +			goto out_free;
> +		}
> +		if (!rep->nr_zones)
> +			break;
> +
> +		for (i = 0; i < rep->nr_zones; i++) {
> +			if (n >= mp->m_sb.sb_rgcount)
> +				break;
> +
> +			if (zones[i].len != zone_size) {
> +				do_error(_("Inconsistent zone size!\n"));
> +				goto out_free;
> +			}
> +
> +			switch (zones[i].type) {
> +			case BLK_ZONE_TYPE_CONVENTIONAL:
> +			case BLK_ZONE_TYPE_SEQWRITE_REQ:
> +				break;
> +			case BLK_ZONE_TYPE_SEQWRITE_PREF:
> +				do_error(
> +_("Found sequential write preferred zone\n"));

I wonder, can "sequential preferred" zones be treated as if they are
conventional zones?  Albeit really slow ones?

/me goes to rummage to see if he still has one of these DMSMR disks.

--D

> +				goto out_free;
> +			default:
> +				do_error(
> +_("Found unknown zone type (0x%x)\n"), zones[i].type);
> +				goto out_free;
> +			}
> +
> +			if (!n) {
> +				zone_capacity = zones[i].capacity;
> +				if (zone_capacity > zone_size) {
> +					do_error(
> +_("Zone capacity larger than zone size!\n"));
> +					goto out_free;
> +				}
> +			} else if (zones[i].capacity != zone_capacity) {
> +				do_error(
> +_("Inconsistent zone capacity!\n"));
> +				goto out_free;
> +			}
> +
> +			report_zones_cb(mp, &zones[i]);
> +			n++;
> +		}
> +		sector = zones[rep->nr_zones - 1].start +
> +			 zones[rep->nr_zones - 1].len;
> +	}
> +
> +out_free:
> +	free(rep);
> +}
> diff --git a/repair/zoned.h b/repair/zoned.h
> new file mode 100644
> index 000000000000..ab76bf15b3ca
> --- /dev/null
> +++ b/repair/zoned.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2024 Christoph Hellwig.
> + */
> +#ifndef _XFS_REPAIR_ZONED_H_
> +#define _XFS_REPAIR_ZONED_H_
> +
> +void check_zones(struct xfs_mount *mp);
> +
> +#endif /* _XFS_REPAIR_ZONED_H_ */
> -- 
> 2.47.2
> 
> 
