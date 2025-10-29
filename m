Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A36B21B192
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 15:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761752451; cv=none; b=JUC9bx3SbR+ehw8GdFQESXdHmCP7+oy00RedKBfyp3xth1tnwM92P/C1xLut8FFG8NnLPC4nrfRQzm5mMVUdo4l1Yqj94YjrbTYP/VFHoarelpNhYcMffj8bl4yNkT9R57GpBG+NH/yz7+ei5NPs3/3Ol5cGXVo1+GaFQF2FrUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761752451; c=relaxed/simple;
	bh=ADdcnVi+/DrtKIXtznMrbDxJaXRlEfPIjuN/yV+rDl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mHeNExDo2+uEWAwaK34/nVq8K1nEJakHW8LY8P6b+uNCf6LPJDTixuCu58cGQzYkrkhTJG/qal27zP2eZNEN9bD5Cdf08jL6W7tH4vQ7DdCtq4h/8HN3e8ZpFCynx1KHa9wVwbabuRVKi7ZStjrWr+nQQ0sdGVXaunTwYTQg0Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vDsGKVRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vDsGKVRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFAF2C4CEF7;
	Wed, 29 Oct 2025 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761752450;
	bh=ADdcnVi+/DrtKIXtznMrbDxJaXRlEfPIjuN/yV+rDl0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vDsGKVRJ24wveOLYkn+8MMyHhAiMz3XrW9hdMcLZw/KXUBgEUY6w12axshHc982SM
	 cyah2o2uWLsuQpOxx6vAPK+eNncuzvTDhocZPlOloPATH0Q+76CNWI5ErYucSIDgC8
	 ha12owJpfOfZW8XaCPt0nbLsH/P7VsEmkajHxpsFNwZLPVDcADHDVm6x2yLGzRVO5g
	 anoyvHXPaGMGooERprxnsb3+w4xQvYxE73lhYJlSNN+cd8vMf4HpLL7mWJXFCIC6nv
	 et+iTZTjM62u9dp83X7AiDbiSy+Jg91pyaVNrt0Gosi1DAdDgiGvRUUnF62wWii5us
	 1qzDDoISOazIQ==
Date: Wed, 29 Oct 2025 08:40:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] mkfs: split zone reset from discard
Message-ID: <20251029154050.GA3356773@frogsfrogsfrogs>
References: <20251029090737.1164049-1-hch@lst.de>
 <20251029090737.1164049-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251029090737.1164049-5-hch@lst.de>

On Wed, Oct 29, 2025 at 10:07:32AM +0100, Christoph Hellwig wrote:
> Zone reset is a mandatory part of creating a file system on a zoned
> device, unlike discard, which can be skipped.  It also is implemented
> a bit different, so just split the handling.  This also means that we
> can now support the -K option to skip discard on the data section for
> zoned file systems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice feature improvement! ;)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_mkfs.c | 112 +++++++++++++++++++++++-------------------------
>  1 file changed, 53 insertions(+), 59 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 09a69af31be5..cd4f3ba4a549 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1607,34 +1607,6 @@ discard_blocks(int fd, uint64_t nsectors, int quiet)
>  		printf("Done.\n");
>  }
>  
> -static void
> -reset_zones(
> -	struct mkfs_params	*cfg,
> -	int			fd,
> -	uint64_t		start_sector,
> -	uint64_t		nsectors,
> -	int			quiet)
> -{
> -	struct blk_zone_range range = {
> -		.sector		= start_sector,
> -		.nr_sectors	= nsectors,
> -	};
> -
> -	if (!quiet) {
> -		printf("Resetting zones...");
> -		fflush(stdout);
> -	}
> -
> -	if (ioctl(fd, BLKRESETZONE, &range) < 0) {
> -		if (!quiet)
> -			printf(" FAILED (%d)\n", -errno);
> -		exit(1);
> -	}
> -
> -	if (!quiet)
> -		printf("Done.\n");
> -}
> -
>  static __attribute__((noreturn)) void
>  illegal_option(
>  	const char		*value,
> @@ -3780,41 +3752,66 @@ discard_devices(
>  	struct zone_topology	*zt,
>  	int			quiet)
>  {
> -	/*
> -	 * This function has to be called after libxfs has been initialized.
> -	 */
> -
>  	if (!xi->data.isfile) {
>  		uint64_t	nsectors = xi->data.size;
>  
> -		if (cfg->rtstart && zt->data.nr_zones) {
> -			/*
> -			 * Note that the zone reset here includes the LBA range
> -			 * for the data device.
> -			 *
> -			 * This is because doing a single zone reset all on the
> -			 * entire device (which the kernel automatically does
> -			 * for us for a full device range) is a lot faster than
> -			 * resetting each zone individually and resetting
> -			 * the conventional zones used for the data device is a
> -			 * no-op.
> -			 */
> -			reset_zones(cfg, xi->data.fd, 0,
> -					cfg->rtstart + xi->rt.size, quiet);
> +		if (cfg->rtstart && zt->data.nr_zones)
>  			nsectors -= cfg->rtstart;
> -		}
>  		discard_blocks(xi->data.fd, nsectors, quiet);
>  	}
> -	if (xi->rt.dev && !xi->rt.isfile) {
> -		if (zt->rt.nr_zones)
> -			reset_zones(cfg, xi->rt.fd, 0, xi->rt.size, quiet);
> -		else
> -			discard_blocks(xi->rt.fd, xi->rt.size, quiet);
> -	}
> +	if (xi->rt.dev && !xi->rt.isfile && !zt->rt.nr_zones)
> +		discard_blocks(xi->rt.fd, xi->rt.size, quiet);
>  	if (xi->log.dev && xi->log.dev != xi->data.dev && !xi->log.isfile)
>  		discard_blocks(xi->log.fd, xi->log.size, quiet);
>  }
>  
> +static void
> +reset_zones(
> +	struct mkfs_params	*cfg,
> +	struct libxfs_dev	*dev,
> +	uint64_t		size,
> +	bool			quiet)
> +{
> +	struct blk_zone_range range = {
> +		.nr_sectors	= size,
> +	};
> +
> +	if (!quiet) {
> +		printf("Resetting zones...");
> +		fflush(stdout);
> +	}
> +	if (ioctl(dev->fd, BLKRESETZONE, &range) < 0) {
> +		if (!quiet)
> +			printf(" FAILED (%d)\n", -errno);
> +		exit(1);
> +	}
> +	if (!quiet)
> +		printf("Done.\n");
> +}
> +
> +static void
> +reset_devices(
> +	struct mkfs_params	*cfg,
> +	struct libxfs_init	*xi,
> +	struct zone_topology	*zt,
> +	int			quiet)
> +{
> +	/*
> +	 * Note that the zone reset here includes the conventional zones used
> +	 * for the data device.
> +	 *
> +	 * It is done that way because doing a single zone reset all on the
> +	 * entire device (which the kernel automatically does for us for a full
> +	 * device range) is a lot faster than resetting each zone individually
> +	 * and resetting the conventional zones used for the data device is a
> +	 * no-op.
> +	 */
> +	if (!xi->data.isfile && zt->data.nr_zones && cfg->rtstart)
> +		reset_zones(cfg, &xi->data, cfg->rtstart + xi->rt.size, quiet);
> +	if (xi->rt.dev && !xi->rt.isfile && zt->rt.nr_zones)
> +		reset_zones(cfg, &xi->rt, xi->rt.size, quiet);
> +}
> +
>  static void
>  validate_datadev(
>  	struct mkfs_params	*cfg,
> @@ -6196,13 +6193,10 @@ main(
>  	/*
>  	 * All values have been validated, discard the old device layout.
>  	 */
> -	if (cli.sb_feat.zoned && !discard) {
> -		fprintf(stderr,
> - _("-K not support for zoned file systems.\n"));
> -		return 1;
> -	}
>  	if (discard && !dry_run)
> -		discard_devices(&cfg, &xi, &zt, quiet);
> +		discard_devices(&cfg, cli.xi, &zt, quiet);
> +	if (cli.sb_feat.zoned && !dry_run)
> +		reset_devices(&cfg, cli.xi, &zt, quiet);
>  
>  	/*
>  	 * we need the libxfs buffer cache from here on in.
> -- 
> 2.47.3
> 
> 
