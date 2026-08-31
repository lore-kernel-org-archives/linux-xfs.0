Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9BC41D10A;
	Mon, 31 Aug 2026 17:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198785; cv=none; b=i2pqbHJPXqloFensCDw/Oo3uRsj3s2uEFTG+7ZfdH9/AYsAakDRN4WXmoOEhfBq5I/JbOTiCVZzm3vrmJ7zr4EOnzCHWRKp5dWHxjSmkAF39a+L4fCKd1h/67zRxhYjm0tVhPY0qpQXTlpie9WXjeFu5sOEWDW93d2Q/9c+trs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198785; c=relaxed/simple;
	bh=2p/Us1J8UyIDxIPq48JngO2s6wwMJWNv/yyKbfssE68=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IV/C3PlxDqQbfmjL0k4QdzPpXmtKrfZxdV4WCafDguWDTRhOGLQL3u2YKuDdPNUeEivOQ08kXuttUy70U4W+8DtSju8e+RIzyUo5s/g9kHWxSDTJv4/1cyOskUSEYQUgn3o3jOrvVIqkr+gpTCcr2D7kCZ0h/RLue7cd0w7gHjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PsBKsV3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PsBKsV3P"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 714551F000E9;
	Mon, 31 Aug 2026 17:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788198783;
	bh=VBmaV1QH08XkgXgX0pExouJAma9Veal/gZZoSZ77GtE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PsBKsV3PnHVSBgMrHXRf9WiMDs75kNsTKsjDX1vpw7Un3kpUFPqwPlSG1FY9a5mC3
	 P9HkxbetegXw32COHtgvY0lURE/5/IPnb3IV1L45ZNW+JK3Opw2EgMdC4oglpCK5BG
	 Pp08M1II9vxCoIn4Invek66r40B/DEUlG3VOtwVE2R2e64QTcgW8F5rb2207R9xcO9
	 EFzj5GPrMJv8D5+r3vJpzksvSHv7O+8SUPW5q/ixl4Ir8IJ0OGkFzGfUauX52AhSjE
	 eBM0IwNOo3okKPnhhB1zmwCDJNXCO0bkQQTxHVo5YBwX1JBinvaICPU2C5kpQdTk4g
	 bpgNOn9lnDpcQ==
Date: Mon, 31 Aug 2026 10:53:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 09/17] xfs: move PI generation into xfs_submit_zoned_bio
Message-ID: <20260831175303.GE1933798@frogsfrogsfrogs>
References: <20260831064010.2574896-1-hch@lst.de>
 <20260831064010.2574896-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064010.2574896-10-hch@lst.de>

On Mon, Aug 31, 2026 at 09:39:57AM +0300, Christoph Hellwig wrote:
> Keep the code in one place, and do so only after splitting to
> keep the allocation size down in case of a split.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good, just like last time ;)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_aops.c       | 4 +---
>  fs/xfs/xfs_file.c       | 2 --
>  fs/xfs/xfs_zone_alloc.c | 3 +++
>  3 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 4e862406eee9..d2cdb7cffa6b 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -23,7 +23,6 @@
>  #include "xfs_ioend.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_rtgroup.h"
> -#include <linux/bio-integrity.h>
>  
>  struct xfs_writepage_ctx {
>  	struct iomap_writepage_ctx ctx;
> @@ -498,8 +497,7 @@ xfs_zoned_writeback_submit(
>  		bio_endio(&ioend->io_bio);
>  		return error;
>  	}
> -	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> -		fs_bio_integrity_generate(&ioend->io_bio);
> +
>  	xfs_zone_alloc_and_submit(ioend, &XFS_ZWPC(wpc)->open_zone);
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index acbfd55f56a3..0e029db2e85b 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -739,8 +739,6 @@ xfs_dio_zoned_submit_io(
>  	bio->bi_end_io = xfs_end_bio;
>  	ioend = iomap_init_ioend(iter->inode, bio, file_offset,
>  			iomap_ioend_flags(&iter->iomap) | IOMAP_IOEND_DIRECT);
> -	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> -		fs_bio_integrity_generate(bio);
>  	xfs_zone_alloc_and_submit(ioend, &ac->open_zone);
>  }
>  
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index bdbb60cc5d5b..e427be806f97 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -26,6 +26,7 @@
>  #include "xfs_zones.h"
>  #include "xfs_trace.h"
>  #include "xfs_mru_cache.h"
> +#include <linux/bio-integrity.h>
>  
>  static void
>  xfs_open_zone_free_rcu(
> @@ -890,6 +891,8 @@ xfs_submit_zoned_bio(
>  		xfs_mark_rtg_boundary(ioend);
>  	}
>  
> +	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> +		fs_bio_integrity_generate(&ioend->io_bio);
>  	submit_bio(&ioend->io_bio);
>  }
>  
> -- 
> 2.53.0
> 
> 
