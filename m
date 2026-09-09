Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0A256E053;
	Wed,  9 Sep 2026 16:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788969983; cv=none; b=trfBTefiS/RVZO3psISbCM43ggBaAR4PTDu6/9F8Uuj5clh5OuBv04Rw08OXMwYjDHvo0n+pLqVm4Nu0TIyh8oV2JCjy61zwfopwa/tcwPQgqkEGRTOc7NzmseUBPu9W/Sf4Pv+f44qOQ8aQr/+vdXTymBikKvVHCsUS0wR2DK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788969983; c=relaxed/simple;
	bh=YcuE7/i+dqR02L9kD8OWxQHXGUgP2QZsa2sNtbrX0TQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kCnwzGd3d96Z9c+W68jxH0vVkSpl+XeO77r8otWtQSGrWobKyrGYZEeI6ae/Mv7SJ6HF+R2kDLJ2aLR314AYZpvUQdhVq611J6Nk3/jKl4qnU60E/PBAHoQx9EwKaDBXk6hZtF9+hSEvN/QI2U2e9MDzMraVTTBfL7bAFGTFTSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SMNgV2X0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SMNgV2X0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6C9E71F00A3A;
	Wed,  9 Sep 2026 16:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788969981;
	bh=Xv3uIMYqi1UrniARielT9QO0j0vrY4VwXIlo/FO7kjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SMNgV2X0KinqnW8obuJKDFi+nXM052ExvjATb+IfnaaqlwxJ9nbw3T3OFObX5RwyH
	 WW/kIQaViQzCv4GB1OclC9h4PJdjo6AcHoXk59rbvBGwEcRme4R3cwDp3jsJjoMFri
	 uxNeSEkXG9Yi3V0oLE+Vvwh07TNtSfNVX7j6k3TK5ySHg1+7VcuQuoKe5E7bYPoH+M
	 R0ZT6TX0jFksbd+wo/Pkp28gf/c6l6LHUSmpsVTs19Qvzu/aInSelbFsUmOeJ58Pzg
	 8KKDBUm1562/PswZndpTDrXv1RHmzbMR2c2jHb27/Wp5nqjzDKc+CUH/4R1epdRFLJ
	 5rtIkK677c4tA==
Date: Wed, 9 Sep 2026 09:06:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/16] xfs: move PI generation into xfs_submit_zoned_bio
Message-ID: <20260909160619.GJ2619314@frogsfrogsfrogs>
References: <20260909060924.1102037-1-hch@lst.de>
 <20260909060924.1102037-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909060924.1102037-9-hch@lst.de>

On Wed, Sep 09, 2026 at 09:08:57AM +0300, Christoph Hellwig wrote:
> Keep the code in one place.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems reasonable to move this to a common function.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_aops.c       | 4 +---
>  fs/xfs/xfs_file.c       | 2 --
>  fs/xfs/xfs_zone_alloc.c | 4 ++++
>  3 files changed, 5 insertions(+), 5 deletions(-)
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
> index bdbb60cc5d5b..bede79859671 100644
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
> @@ -909,6 +910,9 @@ xfs_zone_alloc_and_submit(
>  	if (xfs_is_shutdown(mp))
>  		goto out_error;
>  
> +	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
> +		fs_bio_integrity_generate(&ioend->io_bio);
> +
>  	/*
>  	 * If we don't have a locally cached zone in this write context, see if
>  	 * the inode is still associated with a zone and use that if so.
> -- 
> 2.53.0
> 
> 
