Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEE26FC5
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 00:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744677575; cv=none; b=RAEMxP92OvVKSq5yikRmqpyE8mNfzrJpAyewKy2/8g8CYxxONScWwfBlQX1AkEshb6HRqZ/S4zvVgZUflEK41a0+vBgj81VfFcvYElhhTb1bFYNmK/HUOmxz2CblzcRU+EBiXbMaDt5JfZhutIs6rmLBOwvYRmlx22bev38EREU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744677575; c=relaxed/simple;
	bh=7uSd5FPJDHq3P1U7jB20hzWiE2YJRGSDzDpzbjfS1bU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u81RmqcM+WD5pxvFhkqsON9xt/q2onysfx+3vELRyr8uQrHlYPITWBhW4ZPOlz7NtnFBBKVxXI6FYzSX4bIQ0QtG17kW3Ynix2kZxSHpOU4PbnysN0lgoLdnGr4dnzzjGd1vjKaYCrqPFOEQuFlkDWmDD8pYFSB0cAxO8VG5IdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OgHCngVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OgHCngVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0116FC4CEE2;
	Tue, 15 Apr 2025 00:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744677574;
	bh=7uSd5FPJDHq3P1U7jB20hzWiE2YJRGSDzDpzbjfS1bU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OgHCngVOY1XdxJP5eKhVeV5SwbuSgNznimW4EHuD4IlJ+j+tcBPU1yHS9cpjZmSLB
	 TULebNft5g/B/qZgBrCFGsul4RiQIpuUvizCNi9VSp8fwRxbCR1taPfeVj3xmaRnos
	 NQPjm+ucYVUI6lv+dI46GWuKR8f+o/KHjrETrsBSTntL+2nMi0erxWOAH2F9c+zLZz
	 ID6cNu2Q3L7sajdQWLx8gadJ/4KvUKUKshYRX5Ez+FiIfhr9UugSD/es+K34geZ8pV
	 yjELs/f8qPrSSuwb95zubL4GGJD/2HmrU1pFT5elrLgU9DIEvQCTseDXf/G9HMObS3
	 SIvqii0q1FZLQ==
Date: Mon, 14 Apr 2025 17:39:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/43] xfs_repair: validate rt groups vs reported
 hardware zones
Message-ID: <20250415003933.GL25675@frogsfrogsfrogs>
References: <20250414053629.360672-1-hch@lst.de>
 <20250414053629.360672-30-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250414053629.360672-30-hch@lst.de>

On Mon, Apr 14, 2025 at 07:36:12AM +0200, Christoph Hellwig wrote:
> Run a report zones ioctl, and verify the rt group state vs the
> reported hardware zone state.  Note that there is no way to actually
> fix up any discrepancies here, as that would be rather scary without
> having transactions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  repair/Makefile |   1 +
>  repair/phase5.c |  11 +---
>  repair/zoned.c  | 139 ++++++++++++++++++++++++++++++++++++++++++++++++
>  repair/zoned.h  |  10 ++++
>  4 files changed, 152 insertions(+), 9 deletions(-)
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
> index 000000000000..456076b9817d
> --- /dev/null
> +++ b/repair/zoned.c
> @@ -0,0 +1,139 @@
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
> +	xfs_rtblock_t		zsbno = xfs_daddr_to_rtb(mp, zone->start);
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
> +void
> +check_zones(
> +	struct xfs_mount	*mp)
> +{
> +	int			fd = mp->m_rtdev_targp->bt_bdev_fd;
> +	uint64_t		sector = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart);
> +	unsigned int		zone_size, zone_capacity;
> +	uint64_t		device_size;
> +	size_t			rep_size;
> +	struct blk_zone_report	*rep;
> +	unsigned int		i, n = 0;
> +
> +	if (ioctl(fd, BLKGETSIZE64, &device_size))
> +		return; /* not a block device */
> +	if (ioctl(fd, BLKGETZONESZ, &zone_size) || !zone_size)
> +		return;	/* not zoned */
> +
> +	/* BLKGETSIZE64 reports a byte value */
> +	device_size = BTOBB(device_size);

Much better now, thanks for cleaning up the type conversions
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

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
