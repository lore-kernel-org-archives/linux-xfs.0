Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433FF2DE70B
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 15:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761752363; cv=none; b=Qkylno9diUzc4G88kFYKfG2Kx6Pt6nSW9H+kWDbOeDfz1dpSK/e2JVLuT5iumAQhxbvxLQy2WhjtqLBfqQcYttwnm6/VZdZjASNLmOxnPYnQi6Rq/Y1/XQWUY/nfmYJiwhEcNGj2hVqOjdHKFQGAx5Le66z5n5vfAgRsBRd4uAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761752363; c=relaxed/simple;
	bh=iZFeDyqGKJUOhyb15kOMPmGJ5C3IWOGfzlrPDuozD3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jedm37kQoZ0ZNyv4d1NfpvOk+0tihNlEcIcnCNCsk99o9SieskcfQlTnNBfA1Wz8cRJ0WcTrD1ks+ZVTeUnkigjSAMxToh863SVJ5S0jSvdxdLzowD1LkA6tJ4z9RtIYYviZ2owdsqiYA+eHX8+aRBfQpd53bIxAVSQReWdDwLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XLTzKOAw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLTzKOAw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DECC4CEF7;
	Wed, 29 Oct 2025 15:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761752362;
	bh=iZFeDyqGKJUOhyb15kOMPmGJ5C3IWOGfzlrPDuozD3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XLTzKOAwYgWx4OmMbRwkv26euMhe81saMpFOz0l3HmYdm1yOioNMXH/wReYfBMj+S
	 QLVDv4AQNNETk6DL3v+5ntNWNtPsJB/n/m9+VijB7Vk/qKxb29WOpJ0yCYyOQGh8QM
	 RCzunipsnuQYk+mgSbs3WF03PUYY1K++xoHyQJamb8ugwQmXwvVKBZDlU3/rjc8GC2
	 jUei4gqGjQswddlCSCrF4oNfMO5z7EnywyCE8lVDSu46iXdGqqkRDfyJ8kD53OrL9j
	 imMLx+g3ROlQCFx8up8CGR+s8o3T0abmoX05KoVkY7vIb8V88y/Fm+V8Yl/ViT+XRd
	 835cvdrQsY50g==
Date: Wed, 29 Oct 2025 08:39:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] libxfs: cleanup get_topology
Message-ID: <20251029153921.GY3356773@frogsfrogsfrogs>
References: <20251029090737.1164049-1-hch@lst.de>
 <20251029090737.1164049-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029090737.1164049-3-hch@lst.de>

On Wed, Oct 29, 2025 at 10:07:30AM +0100, Christoph Hellwig wrote:
> Add a libxfs_ prefix to the name, clear the structure in the helper
> instead of in the callers, and use a bool to pass a boolean argument.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  libxfs/topology.c | 9 +++++----
>  libxfs/topology.h | 7 ++-----
>  mkfs/xfs_mkfs.c   | 3 +--
>  repair/sb.c       | 3 +--
>  4 files changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/libxfs/topology.c b/libxfs/topology.c
> index 7764687beac0..366165719c84 100644
> --- a/libxfs/topology.c
> +++ b/libxfs/topology.c
> @@ -224,7 +224,7 @@ static void
>  blkid_get_topology(
>  	const char		*device,
>  	struct device_topology	*dt,
> -	int			force_overwrite)
> +	bool			force_overwrite)
>  {
>  	blkid_topology tp;
>  	blkid_probe pr;
> @@ -317,7 +317,7 @@ static void
>  get_device_topology(
>  	struct libxfs_dev	*dev,
>  	struct device_topology	*dt,
> -	int			force_overwrite)
> +	bool			force_overwrite)
>  {
>  	struct stat		st;
>  
> @@ -364,11 +364,12 @@ get_device_topology(
>  }
>  
>  void
> -get_topology(
> +libxfs_get_topology(
>  	struct libxfs_init	*xi,
>  	struct fs_topology	*ft,
> -	int			force_overwrite)
> +	bool			force_overwrite)
>  {
> +	memset(ft, 0, sizeof(*ft));
>  	get_device_topology(&xi->data, &ft->data, force_overwrite);
>  	get_device_topology(&xi->rt, &ft->rt, force_overwrite);
>  	get_device_topology(&xi->log, &ft->log, force_overwrite);
> diff --git a/libxfs/topology.h b/libxfs/topology.h
> index f0ca65f3576e..3688d56b542f 100644
> --- a/libxfs/topology.h
> +++ b/libxfs/topology.h
> @@ -25,11 +25,8 @@ struct fs_topology {
>  	struct device_topology	log;
>  };
>  
> -void
> -get_topology(
> -	struct libxfs_init	*xi,
> -	struct fs_topology	*ft,
> -	int			force_overwrite);
> +void libxfs_get_topology(struct libxfs_init *xi, struct fs_topology *ft,
> +		bool force_overwrite);
>  
>  extern void
>  calc_default_ag_geometry(
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 3ccd37920321..0ba7798eccf6 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2395,8 +2395,7 @@ validate_sectorsize(
>  		check_device_type(cli, &cli->xi->rt, !cli->rtsize, dry_run,
>  				"RT", "r");
>  
> -	memset(ft, 0, sizeof(*ft));
> -	get_topology(cli->xi, ft, force_overwrite);
> +	libxfs_get_topology(cli->xi, ft, force_overwrite);
>  
>  	/* set configured sector sizes in preparation for checks */
>  	if (!cli->sectorsize) {
> diff --git a/repair/sb.c b/repair/sb.c
> index 0e4827e04678..ee1cc63fae64 100644
> --- a/repair/sb.c
> +++ b/repair/sb.c
> @@ -184,8 +184,7 @@ guess_default_geometry(
>  	uint64_t		dblocks;
>  	int			multidisk;
>  
> -	memset(&ft, 0, sizeof(ft));
> -	get_topology(x, &ft, 1);
> +	libxfs_get_topology(x, &ft, true);
>  
>  	/*
>  	 * get geometry from get_topology result.
> -- 
> 2.47.3
> 
> 
