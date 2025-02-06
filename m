Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68054194094
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 21:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738875937; cv=none; b=hjN5MPeW+Z2YvtTI/hxnNKCKlY6MMnCg/ch2efNKeZXIo8MwOdwT9WCcR5hgrK4nsaGzfAifSTCHNult1tmk0gN7/dPtUApmk0OGa701TDGz3eT3gnYHqtarzODALF6CWYhHygmf0vFa1MaNgzR1acA7XGm9oAdaebqjBK7Hwhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738875937; c=relaxed/simple;
	bh=yXFx69405usZpcTs53xY6Ip7WJOcn/gMhrg7EiDiw2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Po2tF4+UG540tOV9Dr3LK+m/EJ9AeITeVisae0MoJDLVS4kWQYqoMsIvF4iGql8AEtDQSKzRSpm1yfXEQDkkjLcYKWN59D3rnMbwsgDAvSXbrMtzkmgiT7qY2ISVhAQzdH1fLXiSPeahq8Y2lE9xta18wXRVtmwHNpqONs7KSHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGfn02PR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGfn02PR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D86EC4CEDD;
	Thu,  6 Feb 2025 21:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738875937;
	bh=yXFx69405usZpcTs53xY6Ip7WJOcn/gMhrg7EiDiw2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WGfn02PRCcv1S9FYcTy1p5KFuO+n5q7t8I4nTTHv36RAaGwwHQ6DslBY0oZ6+xvQ8
	 WRxaOma6NEST4dIbISW2vXUJvatqWnqnlLYP4Z8j7gg3EHYm82UPtuq2MnDMTrQNIl
	 RuGgWBWlp9ssyspxy5oU2U9MawWxkET1kB9iYxXoOIkA/X3lthdBr1S3TnFIHuhhWl
	 nsnd1inaXGfbF0oxuUYyx3bL4KX/go/b7QkFy424eqDP3P4VlJCck+xxwWEDHa+AZF
	 h8L7JHiXU0tzJxyA+EbFh3Sgx2hworDc+7QgyjNgtinMrZlaUjQCmoLUT5Q8ya20m+
	 PuqOyx3WVzjPw==
Date: Thu, 6 Feb 2025 13:05:36 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/43] xfs: parse and validate hardware zone information
Message-ID: <20250206210536.GS21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-22-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-22-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:37AM +0100, Christoph Hellwig wrote:
> Add support to validate and parse reported hardware zone state.
> 
> Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/Makefile           |   1 +
>  fs/xfs/libxfs/xfs_zones.c | 171 ++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_zones.h |  35 ++++++++
>  3 files changed, 207 insertions(+)
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
> index 000000000000..b022ed960eac
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_zones.c
> @@ -0,0 +1,171 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2023-2025 Christoph Hellwig.
> + * Copyright (c) 2024-2025, Western Digital Corporation or its affiliates.
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
> +static bool
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
> +		return false;
> +	}
> +
> +	*write_pointer = 0;
> +	return true;
> +}
> +
> +static bool
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
> +		return false;
> +	}
> +
> +	if (xfs_rtb_to_rgno(mp, wp_fsb) != rtg_rgno(rtg)) {
> +		xfs_warn(mp, "zone %u write pointer (0x%llx) outside of zone.",
> +			 rtg_rgno(rtg), wp_fsb);
> +		return false;
> +	}
> +
> +	*write_pointer = xfs_rtb_to_rgbno(mp, wp_fsb);
> +	if (*write_pointer >= rtg->rtg_extents) {
> +		xfs_warn(mp, "zone %u has invalid write pointer (0x%x).",
> +			 rtg_rgno(rtg), *write_pointer);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static bool
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
> +		return false;
> +	}
> +
> +	*write_pointer = rtg->rtg_extents;
> +	return true;
> +}
> +
> +static bool
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
> +		return false;
> +	default:
> +		xfs_warn(mp, "zone %u has unknown zone condition 0x%x.",
> +			rtg_rgno(rtg), zone->cond);
> +		return false;
> +	}
> +}
> +
> +static bool
> +xfs_zone_validate_conv(
> +	struct blk_zone		*zone,
> +	struct xfs_rtgroup	*rtg)
> +{
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +
> +	switch (zone->cond) {
> +	case BLK_ZONE_COND_NOT_WP:
> +		return true;
> +	default:
> +		xfs_warn(mp,
> +"conventional zone %u has unsupported zone condition 0x%x.",
> +			 rtg_rgno(rtg), zone->cond);
> +		return false;
> +	}
> +}
> +
> +bool
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
> +		return false;
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
> +		return false;
> +	}
> +}
> diff --git a/fs/xfs/libxfs/xfs_zones.h b/fs/xfs/libxfs/xfs_zones.h
> new file mode 100644
> index 000000000000..c4f1367b2cca
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_zones.h
> @@ -0,0 +1,35 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LIBXFS_ZONES_H
> +#define _LIBXFS_ZONES_H
> +
> +struct xfs_rtgroup;
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
> +bool xfs_zone_validate(struct blk_zone *zone, struct xfs_rtgroup *rtg,
> +	xfs_rgblock_t *write_pointer);
> +
> +#endif /* _LIBXFS_ZONES_H */
> -- 
> 2.45.2
> 
> 
