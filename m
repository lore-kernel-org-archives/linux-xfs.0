Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EF62BEFFF
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 11:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769600163; cv=none; b=t8ajmxC2MqJGm4ZGgoJT7ptivywA3RWyob26Z1Fijub7YWbZQlkw9AQUws1MBXIWy20VlC6yVxB6U5A3HQyvUVkPfjadY9D9wbLgiYH3/GAzMfoNJXSJe1/hC9Jd/PZerB7FkPjfevNubIk25Ih+BEVBDbnby7IXIBgid1k8F0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769600163; c=relaxed/simple;
	bh=D6SgixMfw/BmJVh3nfVYw/o/DE0z6bGQ3RZxNBu3+5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SkG+ptYqlrhMbBAllUZlJIy4KHtfChErBzdzgMQVajThXNTbut188pFPyS2SGwkHoHR6gWr8goPsnIBC5sl8OuwZ5XVCDwDNsnVWlvEVPbnqs4/d1vukMEgKE+RY68cw9f8ScS7UNlKjE4bOu4EjqqacM0S2sKTWhBvxtXQ1610=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=at0563EM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="at0563EM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32F8C4CEF1;
	Wed, 28 Jan 2026 11:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769600163;
	bh=D6SgixMfw/BmJVh3nfVYw/o/DE0z6bGQ3RZxNBu3+5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=at0563EMi9Ah9BNyqKyHkl1OeHWkq/zP4puNCthwGrcleqWQ9nG5u2oRbQUaSYE2I
	 xeOOG8T86McBTq85eWGAmLf+nKdTjBtY4iP7n2+LGnykBkdoXTzo71MvGQbBjphVIl
	 6Za0yxGN+DQXgqUsa4qCJ2DG564JWuhM9q6gd6s4R5NcRd5V4mwXBciXgDp/jJdbXW
	 lWqkGTh78XzGnoWqJ2b1hCbUDcF1EDAwM0t7Li9O8WwH2mYR3eZ8he7Cf/rvTqhSqv
	 381Vmt2p3mzZN6a6hO4VePmBHcR3oZwjWRop2wVKkdnXbFa5qIAGknkHJTk9ckFCSi
	 ZdpemWNs6mrGg==
Date: Wed, 28 Jan 2026 12:35:59 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs: add zone reset error injection
Message-ID: <aXn0VtAiAu1QMMNk@nidhogg.toxiclabs.cc>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-10-hch@lst.de>

On Tue, Jan 27, 2026 at 05:05:49PM +0100, Christoph Hellwig wrote:
> Add a new errortag to test that zone reset errors are handled correctly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_errortag.h |  6 ++++--
>  fs/xfs/xfs_zone_gc.c         | 13 +++++++++++--
>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index b7d98471684b..6de207fed2d8 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -74,7 +74,8 @@
>  #define XFS_ERRTAG_EXCHMAPS_FINISH_ONE			44
>  #define XFS_ERRTAG_METAFILE_RESV_CRITICAL		45
>  #define XFS_ERRTAG_FORCE_ZERO_RANGE			46
> -#define XFS_ERRTAG_MAX					47
> +#define XFS_ERRTAG_ZONE_RESET				47
> +#define XFS_ERRTAG_MAX					48
>  
>  /*
>   * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
> @@ -135,7 +136,8 @@ XFS_ERRTAG(WB_DELAY_MS,		wb_delay_ms,		3000) \
>  XFS_ERRTAG(WRITE_DELAY_MS,	write_delay_ms,		3000) \
>  XFS_ERRTAG(EXCHMAPS_FINISH_ONE,	exchmaps_finish_one,	1) \
>  XFS_ERRTAG(METAFILE_RESV_CRITICAL, metafile_resv_crit,	4) \
> -XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4)
> +XFS_ERRTAG(FORCE_ZERO_RANGE,	force_zero_range,	4) \
> +XFS_ERRTAG(ZONE_RESET,		zone_reset,		1)
>  #endif /* XFS_ERRTAG */
>  
>  #endif /* __XFS_ERRORTAG_H_ */
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 4023448e85d1..570102184904 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -16,6 +16,8 @@
>  #include "xfs_rmap.h"
>  #include "xfs_rtbitmap.h"
>  #include "xfs_rtrmap_btree.h"
> +#include "xfs_errortag.h"
> +#include "xfs_error.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_zone_priv.h"
>  #include "xfs_zones.h"
> @@ -898,9 +900,17 @@ xfs_submit_zone_reset_bio(
>  	struct xfs_rtgroup	*rtg,
>  	struct bio		*bio)
>  {
> +	struct xfs_mount	*mp = rtg_mount(rtg);
> +
>  	trace_xfs_zone_reset(rtg);
>  
>  	ASSERT(rtg_rmap(rtg)->i_used_blocks == 0);
> +
> +	if (XFS_TEST_ERROR(mp, XFS_ERRTAG_ZONE_RESET)) {
> +		bio_io_error(bio);
> +		return;
> +	}
> +
>  	bio->bi_iter.bi_sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
>  	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
>  		/*
> @@ -913,8 +923,7 @@ xfs_submit_zone_reset_bio(
>  		}
>  		bio->bi_opf &= ~REQ_OP_ZONE_RESET;
>  		bio->bi_opf |= REQ_OP_DISCARD;
> -		bio->bi_iter.bi_size =
> -			XFS_FSB_TO_B(rtg_mount(rtg), rtg_blocks(rtg));
> +		bio->bi_iter.bi_size = XFS_FSB_TO_B(mp, rtg_blocks(rtg));
>  	}
>  
>  	submit_bio(bio);
> -- 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

