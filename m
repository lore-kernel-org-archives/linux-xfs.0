Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF4E18A6AF
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 17:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734111093; cv=none; b=FS4IZYJp/L2XMB+yRu7L+pFq1IezxF9m/Iq5rI/tn6BzjASFHSwau/Ng6EMoM/VleomhTX3s+wGhvLoNKfTFBRrBx8peeN3whXTRGYVtMrmwnqbVtYd63xZx2GcwKK+d3601qT7m9dnpW7tlF0N2igQKH9iKQER6z7qSzeGLiAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734111093; c=relaxed/simple;
	bh=8fRnlobXHSYmP483Sqyr/j8ym0NK+HUqHNV8YiSRTTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MUCOLDENuByrAsLrNHa2LG7tcP6Tk4EoRkbiZUFbOT8tTTq11q0/xskQd9cj9/ZoiZggz0Hh8ljVLKGuF8bbHgyiocl1fz53UNMAIfCMytQ7DAQifsgEJWhvj/8PChS7h9FEpnPuQ4srO3C/etegMQksMCrlgB9nC8gFGI0KSXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AXYUNFd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AXYUNFd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080D4C4CED0;
	Fri, 13 Dec 2024 17:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734111093;
	bh=8fRnlobXHSYmP483Sqyr/j8ym0NK+HUqHNV8YiSRTTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AXYUNFd3gMYtqqOvcUU0Dj4XByf7PIYCCoFn6cGCTZS/Noyv+V3JjrkDLiek7X8fa
	 OhXmcvTyD/sSNnK+qRWaZY5A2EtSMPGr15H6LhTi+joAF3rzQc7Q4OhfY4+embSdM1
	 HirGFh4d0r9Q4n/qS9frvWbZArU7UgEjzCGuIx/FeTnja8O9YRrp1eYfx6FPi6ja2p
	 xBhDOBARefuC4rBK7gmw6/ouvU2U7XvJgnnF6qS+Pgp5mfT3us+Q0GtvbKCzsXLVgG
	 PfoRIvgr1Op53kCcqAEG89MWo8ZsRr0Uv1CLDSEtq+gkz6k38LcVz/ulIb2+xBEVby
	 6lCIdpe+f3xHA==
Date: Fri, 13 Dec 2024 09:31:32 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/43] xfs: parse and validate hardware zone information
Message-ID: <20241213173132.GM6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-24-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-24-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:48AM +0100, Christoph Hellwig wrote:
> Add support to validate and parse reported hardware zone state.
> 
> Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/Makefile           |   1 +
>  fs/xfs/libxfs/xfs_zones.c | 169 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_zones.h |  33 ++++++++
>  3 files changed, 203 insertions(+)
>  create mode 100644 fs/xfs/libxfs/xfs_zones.c
>  create mode 100644 fs/xfs/libxfs/xfs_zones.h
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index 7afa51e41427..ea8e66c1e969 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -64,6 +64,7 @@ xfs-y				+= $(addprefix libxfs/, \
>  xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
>  				   xfs_rtbitmap.o \
>  				   xfs_rtgroup.o \
> +				   xfs_zones.o \
>  				   )
>  
>  # highlevel code
> diff --git a/fs/xfs/libxfs/xfs_zones.c b/fs/xfs/libxfs/xfs_zones.c
> new file mode 100644
> index 000000000000..e170d7c13533
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_zones.c
> @@ -0,0 +1,169 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2023-2024 Christoph Hellwig.
> + * Copyright (c) 2024, Western Digital Corporation or its affiliates.
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_inode.h"
> +#include "xfs_rtgroup.h"
> +#include "xfs_zones.h"
> +
> +static int
> +xfs_zone_validate_empty(
> +	struct blk_zone		*zone,
> +	struct xfs_rtgroup	*rtg,
> +	xfs_rgblock_t		*write_pointer)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +
> +	if (rtg_rmap(rtg)->i_used_blocks > 0) {
> +		xfs_warn(mp, "empty zone %u has non-zero used counter (0x%x).",
> +			 rtg_rgno(rtg), rtg_rmap(rtg)->i_used_blocks);
> +		return -EIO;

Why do some of these validation failures return EIO vs. EFSCORRUPTED?
Is "EIO" used for "filesystem metadata out of sync with storage device"
whereas "EFSCORRUPTED" is used for "filesystem metadata inconsistent
with itself"?

Do the _validate_{empty,full} functions need to validate zone->wp is
zero/rtg_extents, respectively?

--D

> +	}
> +	*write_pointer = 0;
> +	return 0;
> +}
> +
> +static int
> +xfs_zone_validate_wp(
> +	struct blk_zone		*zone,
> +	struct xfs_rtgroup	*rtg,
> +	xfs_rgblock_t		*write_pointer)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	xfs_rtblock_t		wp_fsb = xfs_daddr_to_rtb(mp, zone->wp);
> +
> +	if (rtg_rmap(rtg)->i_used_blocks > rtg->rtg_extents) {
> +		xfs_warn(mp, "zone %u has too large used counter (0x%x).",
> +			 rtg_rgno(rtg), rtg_rmap(rtg)->i_used_blocks);
> +		return -EIO;
> +	}
> +
> +	if (xfs_rtb_to_rgno(mp, wp_fsb) != rtg_rgno(rtg)) {
> +		xfs_warn(mp, "zone %u write pointer (0x%llx) outside of zone.",
> +			 rtg_rgno(rtg), wp_fsb);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	*write_pointer = xfs_rtb_to_rgbno(mp, wp_fsb);
> +	if (*write_pointer >= rtg->rtg_extents) {
> +		xfs_warn(mp, "zone %u has invalid write pointer (0x%x).",
> +			 rtg_rgno(rtg), *write_pointer);
> +		return -EFSCORRUPTED;
> +	}
> +	return 0;
> +}
> +
> +static int
> +xfs_zone_validate_full(
> +	struct blk_zone		*zone,
> +	struct xfs_rtgroup	*rtg,
> +	xfs_rgblock_t		*write_pointer)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +
> +	if (rtg_rmap(rtg)->i_used_blocks > rtg->rtg_extents) {
> +		xfs_warn(mp, "zone %u has too large used counter (0x%x).",
> +			 rtg_rgno(rtg), rtg_rmap(rtg)->i_used_blocks);
> +		return -EIO;
> +	}
> +	*write_pointer = rtg->rtg_extents;
> +
> +	return 0;
> +}
> +
> +static int
> +xfs_zone_validate_seq(
> +	struct blk_zone		*zone,
> +	struct xfs_rtgroup	*rtg,
> +	xfs_rgblock_t		*write_pointer)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +
> +	switch (zone->cond) {
> +	case BLK_ZONE_COND_EMPTY:
> +		return xfs_zone_validate_empty(zone, rtg, write_pointer);
> +	case BLK_ZONE_COND_IMP_OPEN:
> +	case BLK_ZONE_COND_EXP_OPEN:
> +	case BLK_ZONE_COND_CLOSED:
> +		return xfs_zone_validate_wp(zone, rtg, write_pointer);
> +	case BLK_ZONE_COND_FULL:
> +		return xfs_zone_validate_full(zone, rtg, write_pointer);
> +	case BLK_ZONE_COND_NOT_WP:
> +	case BLK_ZONE_COND_OFFLINE:
> +	case BLK_ZONE_COND_READONLY:
> +		xfs_warn(mp, "zone %u has unsupported zone condition 0x%x.",
> +			rtg_rgno(rtg), zone->cond);
> +		return -EIO;
> +	default:
> +		xfs_warn(mp, "zone %u has unknown zone condition 0x%x.",
> +			rtg_rgno(rtg), zone->cond);
> +		return -EIO;
> +	}
> +}
> +
> +static int
> +xfs_zone_validate_conv(
> +	struct blk_zone		*zone,
> +	struct xfs_rtgroup	*rtg)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +
> +	switch (zone->cond) {
> +	case BLK_ZONE_COND_NOT_WP:
> +		return 0;
> +	default:
> +		xfs_warn(mp,
> +"conventional zone %u has unsupported zone condition 0x%x.",
> +			 rtg_rgno(rtg), zone->cond);
> +		return -EIO;
> +	}
> +}
> +
> +int
> +xfs_zone_validate(
> +	struct blk_zone		*zone,
> +	struct xfs_rtgroup	*rtg,
> +	xfs_rgblock_t		*write_pointer)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +	struct xfs_groups	*g = &mp->m_groups[XG_TYPE_RTG];
> +
> +	/*
> +	 * Check that the zone capacity matches the rtgroup size stored in the
> +	 * superblock.  Note that all zones including the last one must have a
> +	 * uniform capacity.
> +	 */
> +	if (XFS_BB_TO_FSB(mp, zone->capacity) != g->blocks) {
> +		xfs_warn(mp,
> +"zone %u capacity (0x%llx) does not match RT group size (0x%x).",
> +			rtg_rgno(rtg), XFS_BB_TO_FSB(mp, zone->capacity),
> +			g->blocks);
> +		return -EIO;
> +	}
> +
> +	if (XFS_BB_TO_FSB(mp, zone->len) != 1 << g->blklog) {
> +		xfs_warn(mp,
> +"zone %u length (0x%llx) does match geometry (0x%x).",
> +			rtg_rgno(rtg), XFS_BB_TO_FSB(mp, zone->len),
> +			1 << g->blklog);
> +	}
> +
> +	switch (zone->type) {
> +	case BLK_ZONE_TYPE_CONVENTIONAL:
> +		return xfs_zone_validate_conv(zone, rtg);
> +	case BLK_ZONE_TYPE_SEQWRITE_REQ:
> +		return xfs_zone_validate_seq(zone, rtg, write_pointer);
> +	default:
> +		xfs_warn(mp, "zoned %u has unsupported type 0x%x.",
> +			rtg_rgno(rtg), zone->type);
> +		return -EFSCORRUPTED;
> +	}
> +}
> diff --git a/fs/xfs/libxfs/xfs_zones.h b/fs/xfs/libxfs/xfs_zones.h
> new file mode 100644
> index 000000000000..4d3e53585654
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_zones.h
> @@ -0,0 +1,33 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LIBXFS_ZONES_H
> +#define _LIBXFS_ZONES_H
> +
> +/*
> + * In order to guarantee forward progress for GC we need to reserve at least
> + * two zones:  one that will be used for moving data into and one spare zone
> + * making sure that we have enough space to relocate a nearly-full zone.
> + * To allow for slightly sloppy accounting for when we need to reserve the
> + * second zone, we actually reserve three as that is easier than doing fully
> + * accurate bookkeeping.
> + */
> +#define XFS_GC_ZONES		3U
> +
> +/*
> + * In addition we need two zones for user writes, one open zone for writing
> + * and one to still have available blocks without resetting the open zone
> + * when data in the open zone has been freed.
> + */
> +#define XFS_RESERVED_ZONES	(XFS_GC_ZONES + 1)
> +#define XFS_MIN_ZONES		(XFS_RESERVED_ZONES + 1)
> +
> +/*
> + * Always keep one zone out of the general open zone pool to allow for GC to
> + * happen while other writers are waiting for free space.
> + */
> +#define XFS_OPEN_GC_ZONES	1U
> +#define XFS_MIN_OPEN_ZONES	(XFS_OPEN_GC_ZONES + 1U)
> +
> +int xfs_zone_validate(struct blk_zone *zone, struct xfs_rtgroup *rtg,
> +	xfs_rgblock_t *write_pointer);
> +
> +#endif /* _LIBXFS_ZONES_H */
> -- 
> 2.45.2
> 
> 
