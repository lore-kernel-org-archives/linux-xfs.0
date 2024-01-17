Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B358225A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 23:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705535759; cv=none; b=F7B6L6oJYGbZDKCBFmVlrSADccQqwtcaS9i1vfjZ/fsAUa/02d0yTVYEPVlogGOBBfUDrLA5ADiG9ML4QtWKKvPsaUgNeVsOvv6XhA1XOwwmwUg2jfXui1BIP/G3SSU9wXy5zdelDbJghkMcbUAi0a5rBKcx1qan3fGsY72ihdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705535759; c=relaxed/simple;
	bh=fEwJSGVCHTiUmUAiBFkN19fOg99RaimMv/zTbSEmqiI=;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To; b=H8HQPB1/ehbO3JdfhGI3VfBOz4WoRB7OfDkp9ChM0j/5h5KDZClxVOISjIaGKLLd7OMzPjB6NL+31Vc/8CPZbyLYe+3BsIM/gdciBiEB/cn+zqlE6UNGxMYUAToKfdweBA0miGEEiWcOSlQblvi07mHvK1AOCUcqrsmIm+EVr48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQzfu+J8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQzfu+J8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA54C43390;
	Wed, 17 Jan 2024 23:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705535758;
	bh=fEwJSGVCHTiUmUAiBFkN19fOg99RaimMv/zTbSEmqiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WQzfu+J8BJ2Kk3F1rJbhaKBtWk3zYFD9LjfZjB9MNlEaFLhz9A70BgrJNvcBUMzPm
	 K8ukPMx6Nxolwc0YNe3Uz2HKgjonPgkgIvyQ6J41v8jJolqshEeSdni08VtDghpN7Q
	 UmFpBpElviKqdi/ViRGoOlgNtW34K3o2oDWSa3B2ViKAi9NKFjiW1Z+jRrwWknZbP5
	 JgDtvmVPR1b7+XpAS6z7yBfNbu7lnodWop7c8SjFURKVxXmGiKDIK87ucEOGhe9l4Q
	 N7MXDrhNj8v0yL2rnJRkctYU1pNzUciMT/XmYGdRTMgcOEoTUoIFRf0xX0dfzlGOaU
	 6v/CQYSd90efA==
Date: Wed, 17 Jan 2024 15:55:58 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] libxfs: refactor the fs_topology structure
Message-ID: <20240117235558.GA674499@frogsfrogsfrogs>
References: <20240117173312.868103-1-hch@lst.de>
 <20240117173312.868103-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240117173312.868103-3-hch@lst.de>

On Wed, Jan 17, 2024 at 06:33:09PM +0100, Christoph Hellwig wrote:
> fs_topology is a mess that mixes up data and RT device reporting,
> and to make things worse reuses lsectorsize for the logical sector
> size while other parts of xfsprogs use it for the log sector size.
> 
> Split out a device_topology structure that reports the topology for
> one device and embedded two of them into the fs_topology struture,
> and pass them directly to blkid_get_topology.
> 
> Rename the sector size members to be more explicit, and move some
> of the sanity checking from mkfs into the topology helpers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  libxfs/topology.c | 114 ++++++++++++++++++++++++----------------------
>  libxfs/topology.h |  14 ++++--
>  mkfs/xfs_mkfs.c   |  64 ++++++++++++--------------
>  repair/sb.c       |   2 +-
>  4 files changed, 99 insertions(+), 95 deletions(-)
> 
> diff --git a/libxfs/topology.c b/libxfs/topology.c
> index 06013d429..8ae5f7483 100644
> --- a/libxfs/topology.c
> +++ b/libxfs/topology.c
> @@ -173,18 +173,14 @@ out:
>  	return ret;
>  }
>  
> -static void blkid_get_topology(
> -	const char	*device,
> -	int		*sunit,
> -	int		*swidth,
> -	int		*lsectorsize,
> -	int		*psectorsize,
> -	int		force_overwrite)
> +static void
> +blkid_get_topology(
> +	const char		*device,
> +	struct device_topology	*dt,
> +	int			force_overwrite)

Yay for not passing four pointers around!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  {
> -
>  	blkid_topology tp;
>  	blkid_probe pr;
> -	unsigned long val;
>  	struct stat statbuf;
>  
>  	/* can't get topology info from a file */
> @@ -203,31 +199,28 @@ static void blkid_get_topology(
>  	if (!tp)
>  		goto out_free_probe;
>  
> -	val = blkid_topology_get_logical_sector_size(tp);
> -	*lsectorsize = val;
> -	val = blkid_topology_get_physical_sector_size(tp);
> -	*psectorsize = val;
> -	val = blkid_topology_get_minimum_io_size(tp);
> -	*sunit = val;
> -	val = blkid_topology_get_optimal_io_size(tp);
> -	*swidth = val;
> +	dt->logical_sector_size = blkid_topology_get_logical_sector_size(tp);
> +	dt->physical_sector_size = blkid_topology_get_physical_sector_size(tp);
> +	dt->sunit = blkid_topology_get_minimum_io_size(tp);
> +	dt->swidth = blkid_topology_get_optimal_io_size(tp);
>  
>  	/*
>  	 * If the reported values are the same as the physical sector size
>  	 * do not bother to report anything.  It will only cause warnings
>  	 * if people specify larger stripe units or widths manually.
>  	 */
> -	if (*sunit == *psectorsize || *swidth == *psectorsize) {
> -		*sunit = 0;
> -		*swidth = 0;
> +	if (dt->sunit == dt->physical_sector_size ||
> +	    dt->swidth == dt->physical_sector_size) {
> +		dt->sunit = 0;
> +		dt->swidth = 0;
>  	}
>  
>  	/*
>  	 * Blkid reports the information in terms of bytes, but we want it in
>  	 * terms of 512 bytes blocks (only to convert it to bytes later..)
>  	 */
> -	*sunit = *sunit >> 9;
> -	*swidth = *swidth >> 9;
> +	dt->sunit >>= 9;
> +	dt->swidth >>= 9;
>  
>  	if (blkid_topology_get_alignment_offset(tp) != 0) {
>  		fprintf(stderr,
> @@ -241,7 +234,7 @@ static void blkid_get_topology(
>  			exit(EXIT_FAILURE);
>  		}
>  		/* Do not use physical sector size if the device is misaligned */
> -		*psectorsize = *lsectorsize;
> +		dt->physical_sector_size = dt->logical_sector_size;
>  	}
>  
>  	blkid_free_probe(pr);
> @@ -268,65 +261,78 @@ check_overwrite(
>  	return 1;
>  }
>  
> -static void blkid_get_topology(
> -	const char	*device,
> -	int		*sunit,
> -	int		*swidth,
> -	int		*lsectorsize,
> -	int		*psectorsize,
> -	int		force_overwrite)
> +static void
> +blkid_get_topology(
> +	const char		*device,
> +	struct device_topology	*dt,
> +	int			force_overwrite)
>  {
>  	/*
>  	 * Shouldn't make any difference (no blkid = no block device access),
>  	 * but make sure this dummy replacement returns with at least some
>  	 * sanity.
>  	 */
> -	*lsectorsize = *psectorsize = 512;
> +	dt->logical_sector_size = 512;
> +	dt->physical_sector_size = 512;
>  }
>  
>  #endif /* ENABLE_BLKID */
>  
> -void
> -get_topology(
> -	struct libxfs_init	*xi,
> -	struct fs_topology	*ft,
> +static void
> +get_device_topology(
> +	struct libxfs_dev	*dev,
> +	struct device_topology	*dt,
>  	int			force_overwrite)
>  {
> -	struct stat statbuf;
> +	struct stat		st;
> +
> +	/*
> +	 * Nothing to do if this particular subvolume doesn't exist.
> +	 */
> +	if (!dev->name)
> +		return;
>  
>  	/*
>  	 * If our target is a regular file, use platform_findsizes
>  	 * to try to obtain the underlying filesystem's requirements
>  	 * for direct IO; we'll set our sector size to that if possible.
>  	 */
> -	if (xi->data.isfile ||
> -	    (!stat(xi->data.name, &statbuf) && S_ISREG(statbuf.st_mode))) {
> -		int fd;
> +	if (dev->isfile || (!stat(dev->name, &st) && S_ISREG(st.st_mode))) {
>  		int flags = O_RDONLY;
>  		long long dummy;
> +		int fd;
>  
>  		/* with xi->disfile we may not have the file yet! */
> -		if (xi->data.isfile)
> +		if (dev->isfile)
>  			flags |= O_CREAT;
>  
> -		fd = open(xi->data.name, flags, 0666);
> +		fd = open(dev->name, flags, 0666);
>  		if (fd >= 0) {
> -			platform_findsizes(xi->data.name, fd, &dummy,
> -					&ft->lsectorsize);
> +			platform_findsizes(dev->name, fd, &dummy,
> +					&dt->logical_sector_size);
>  			close(fd);
> -			ft->psectorsize = ft->lsectorsize;
> -		} else
> -			ft->psectorsize = ft->lsectorsize = BBSIZE;
> +		} else {
> +			dt->logical_sector_size = BBSIZE;
> +		}
>  	} else {
> -		blkid_get_topology(xi->data.name, &ft->dsunit, &ft->dswidth,
> -				   &ft->lsectorsize, &ft->psectorsize,
> -				   force_overwrite);
> +		blkid_get_topology(dev->name, dt, force_overwrite);
>  	}
>  
> -	if (xi->rt.name && !xi->rt.isfile) {
> -		int sunit, lsectorsize, psectorsize;
> +	ASSERT(dt->logical_sector_size);
>  
> -		blkid_get_topology(xi->rt.name, &sunit, &ft->rtswidth,
> -				   &lsectorsize, &psectorsize, force_overwrite);
> -	}
> +	/*
> +	 * Older kernels may not have physical/logical distinction.
> +	 */
> +	if (!dt->physical_sector_size)
> +		dt->physical_sector_size = dt->logical_sector_size;
> +}
> +
> +void
> +get_topology(
> +	struct libxfs_init	*xi,
> +	struct fs_topology	*ft,
> +	int			force_overwrite)
> +{
> +	get_device_topology(&xi->data, &ft->data, force_overwrite);
> +	get_device_topology(&xi->rt, &ft->rt, force_overwrite);
>  }
> diff --git a/libxfs/topology.h b/libxfs/topology.h
> index 3a309a4da..ba0c8f669 100644
> --- a/libxfs/topology.h
> +++ b/libxfs/topology.h
> @@ -10,12 +10,16 @@
>  /*
>   * Device topology information.
>   */
> +struct device_topology {
> +	int	logical_sector_size;	/* logical sector size */
> +	int	physical_sector_size;	/* physical sector size */
> +	int	sunit;		/* stripe unit */
> +	int	swidth;		/* stripe width  */
> +};
> +
>  struct fs_topology {
> -	int	dsunit;		/* stripe unit - data subvolume */
> -	int	dswidth;	/* stripe width - data subvolume */
> -	int	rtswidth;	/* stripe width - rt subvolume */
> -	int	lsectorsize;	/* logical sector size &*/
> -	int	psectorsize;	/* physical sector size */
> +	struct device_topology	data;
> +	struct device_topology	rt;
>  };
>  
>  void
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index fcbf54132..be65ccc1e 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1986,31 +1986,24 @@ validate_sectorsize(
>  		 * than that, then we can use logical, but warn about the
>  		 * inefficiency.
>  		 *
> -		 * Set the topology sectors if they were not probed to the
> -		 * minimum supported sector size.
> -		 */
> -		if (!ft->lsectorsize)
> -			ft->lsectorsize = dft->sectorsize;
> -
> -		/*
> -		 * Older kernels may not have physical/logical distinction.
> -		 *
>  		 * Some architectures have a page size > XFS_MAX_SECTORSIZE.
>  		 * In that case, a ramdisk or persistent memory device may
>  		 * advertise a physical sector size that is too big to use.
>  		 */
> -		if (!ft->psectorsize || ft->psectorsize > XFS_MAX_SECTORSIZE)
> -			ft->psectorsize = ft->lsectorsize;
> +		if (ft->data.physical_sector_size > XFS_MAX_SECTORSIZE) {
> +			ft->data.physical_sector_size =
> +				ft->data.logical_sector_size;
> +		}
>  
> -		cfg->sectorsize = ft->psectorsize;
> +		cfg->sectorsize = ft->data.physical_sector_size;
>  		if (cfg->blocksize < cfg->sectorsize &&
> -		    cfg->blocksize >= ft->lsectorsize) {
> +		    cfg->blocksize >= ft->data.logical_sector_size) {
>  			fprintf(stderr,
>  _("specified blocksize %d is less than device physical sector size %d\n"
>    "switching to logical sector size %d\n"),
> -				cfg->blocksize, ft->psectorsize,
> -				ft->lsectorsize);
> -			cfg->sectorsize = ft->lsectorsize;
> +				cfg->blocksize, ft->data.physical_sector_size,
> +				ft->data.logical_sector_size);
> +			cfg->sectorsize = ft->data.logical_sector_size;
>  		}
>  	} else
>  		cfg->sectorsize = cli->sectorsize;
> @@ -2031,9 +2024,9 @@ _("block size %d cannot be smaller than sector size %d\n"),
>  		usage();
>  	}
>  
> -	if (cfg->sectorsize < ft->lsectorsize) {
> +	if (cfg->sectorsize < ft->data.logical_sector_size) {
>  		fprintf(stderr, _("illegal sector size %d; hw sector is %d\n"),
> -			cfg->sectorsize, ft->lsectorsize);
> +			cfg->sectorsize, ft->data.logical_sector_size);
>  		usage();
>  	}
>  }
> @@ -2455,7 +2448,7 @@ validate_rtextsize(
>  
>  		if (!cfg->sb_feat.nortalign && !cli->xi->rt.isfile &&
>  		    !(!cli->rtsize && cli->xi->data.isfile))
> -			rswidth = ft->rtswidth;
> +			rswidth = ft->rt.swidth;
>  		else
>  			rswidth = 0;
>  
> @@ -2700,13 +2693,14 @@ _("data stripe width (%lld) is too large of a multiple of the data stripe unit (
>  	/* if no stripe config set, use the device default */
>  	if (!dsunit) {
>  		/* Ignore nonsense from device report. */
> -		if (!libxfs_validate_stripe_geometry(NULL, BBTOB(ft->dsunit),
> -				BBTOB(ft->dswidth), 0, true)) {
> +		if (!libxfs_validate_stripe_geometry(NULL, BBTOB(ft->data.sunit),
> +				BBTOB(ft->data.swidth), 0, true)) {
>  			fprintf(stderr,
>  _("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\n"),
> -				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
> -			ft->dsunit = 0;
> -			ft->dswidth = 0;
> +				progname,
> +				BBTOB(ft->data.sunit), BBTOB(ft->data.swidth));
> +			ft->data.sunit = 0;
> +			ft->data.swidth = 0;
>  		} else if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
>  			/*
>  			 * Don't use automatic stripe detection if the device
> @@ -2714,29 +2708,29 @@ _("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\
>  			 * on such a small system are not worth the risk that
>  			 * we'll end up with an undersized log.
>  			 */
> -			if (ft->dsunit || ft->dswidth)
> +			if (ft->data.sunit || ft->data.swidth)
>  				fprintf(stderr,
>  _("%s: small data volume, ignoring data volume stripe unit %d and stripe width %d\n"),
> -						progname, ft->dsunit,
> -						ft->dswidth);
> -			ft->dsunit = 0;
> -			ft->dswidth = 0;
> +						progname, ft->data.sunit,
> +						ft->data.swidth);
> +			ft->data.sunit = 0;
> +			ft->data.swidth = 0;
>  		} else {
> -			dsunit = ft->dsunit;
> -			dswidth = ft->dswidth;
> +			dsunit = ft->data.sunit;
> +			dswidth = ft->data.swidth;
>  			use_dev = true;
>  		}
>  	} else {
>  		/* check and warn if user-specified alignment is sub-optimal */
> -		if (ft->dsunit && ft->dsunit != dsunit) {
> +		if (ft->data.sunit && ft->data.sunit != dsunit) {
>  			fprintf(stderr,
>  _("%s: Specified data stripe unit %d is not the same as the volume stripe unit %d\n"),
> -				progname, dsunit, ft->dsunit);
> +				progname, dsunit, ft->data.sunit);
>  		}
> -		if (ft->dswidth && ft->dswidth != dswidth) {
> +		if (ft->data.swidth && ft->data.swidth != dswidth) {
>  			fprintf(stderr,
>  _("%s: Specified data stripe width %d is not the same as the volume stripe width %d\n"),
> -				progname, dswidth, ft->dswidth);
> +				progname, dswidth, ft->data.swidth);
>  		}
>  	}
>  
> diff --git a/repair/sb.c b/repair/sb.c
> index dedac53af..02c10d9a5 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -189,7 +189,7 @@ guess_default_geometry(
>  	 * Use default block size (2^12)
>  	 */
>  	blocklog = 12;
> -	multidisk = ft.dswidth | ft.dsunit;
> +	multidisk = ft.data.swidth | ft.data.sunit;
>  	dblocks = x->data.size >> (blocklog - BBSHIFT);
>  	calc_default_ag_geometry(blocklog, dblocks, multidisk,
>  				 agsize, agcount);
> -- 
> 2.39.2
> 
> 
