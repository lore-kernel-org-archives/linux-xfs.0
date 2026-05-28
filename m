Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B041F938
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 05:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779944505; cv=none; b=T2NHi0TCM3HgaMCx5g81+9jy6ymroiEWO+WroH6yXcRSURRfII5at1mnJIGaMuMO1/62b7vk0fTaU20yyt8cwzXNwQUYrTNB7MQufeX4v/LNIkTMoHBVVSb4gvnCl7TH+1OhqB3XBkpehpiYKnYaiT8e0491PkYXZ6GtNjBTDC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779944505; c=relaxed/simple;
	bh=+9C/eKIkL7P41BOFed8VDaxfQZU/9OJKYDVZR4PzZBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pNUb29EzJ+7c2czGpj/jyDaEJ1w0J74nplBx/MszJeQ5WRxWaRRt5PaEdnfSTWqOXxwX2s1s57s5hceo9pVSTzS8tbhyIZvq9pPtbOsNellY6Fgdd2UvqkreA5IS5KJIqgfzVznvAh+OZWYv4obAJthV/ActMJyBLdVBFyUQpfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mq60wZF+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mq60wZF+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 02D951F000E9;
	Thu, 28 May 2026 05:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779944504;
	bh=vKx5ye0bIdMuICKqJ7N6TjLMEzb4zaloqow+Z6nBs5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mq60wZF+NrxRULatPZSezBLSL8YULbT60m/7p1J8QScd6aXvnnUQQGaEV5lBDXnrh
	 Ejw7l+RgG1ssFCPN00KieGYd1Y43/hJqYdSPCjT48AGLoJq92DQZD8IbDr7RBE9lcb
	 UcK+vKYH384qUDINS7rsPezUcnSnoycMx6KzJVUdf/17uqNjGX+vzvn+MWupNBI+7v
	 pyKQc1ny8AtmwKmAIcW61yERzfYk+51Zexqzdp7wEYJ14mnUx5JUwg8ZTbEr2/uwZI
	 j800EH/vJB542driCfbIO068hmO27jt/sLswOBvBLC0BrumM6eCXOz9M4c+uQf+MlR
	 C1ralTuQTP3Zg==
Date: Wed, 27 May 2026 22:01:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, dgc@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 5/5] xfsprogs: mkfs.xfs clean up unused dft option
 in various validators
Message-ID: <20260528050143.GG6078@frogsfrogsfrogs>
References: <20260525075752.4159504-1-lukas@herbolt.com>
 <20260525075752.4159504-6-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525075752.4159504-6-lukas@herbolt.com>

On Mon, May 25, 2026 at 09:57:52AM +0200, Lukas Herbolt wrote:
> The struct cli_params dft was only used in validate_blocksize().
> Now the cli.blocksize is always set either over bld_dflt or
> file_dflt or from command line/config file. All the other functions
> are not accessing the dft in their body.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>

I wish this had come first, but oh well whatever.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_mkfs.c | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index cb9c528021d6..5d1d27235a72 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2392,7 +2392,6 @@ static void
>  validate_sectorsize(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli,
> -	struct cli_params	*dft,
>  	struct fs_topology	*ft,
>  	int			dry_run,
>  	int			force_overwrite)
> @@ -2481,18 +2480,19 @@ _("block size %d cannot be smaller than sector size %d\n"),
>  static void
>  validate_blocksize(
>  	struct mkfs_params	*cfg,
> -	struct cli_params	*cli,
> -	struct cli_params	*dft)
> +	struct cli_params	*cli)
>  {
>  	/*
>  	 * Blocksize and sectorsize first, other things depend on them
>  	 * For RAID4/5/6 we want to align sector size and block size,
>  	 * so we need to start with the device geometry extraction too.
> +	 *
> +	 * The cli->blocksize size is already set from the bld_dflt
> +	 * or from file_dflt or via command line. We just need to check
> +	 * if the value is within our limits.
>  	 */
> -	if (!cli->blocksize)
> -		cfg->blocksize = dft->blocksize;
> -	else
> -		cfg->blocksize = cli->blocksize;
> +
> +	cfg->blocksize = cli->blocksize;
>  	cfg->blocklog = libxfs_highbit32(cfg->blocksize);
>  
>  	/* validate block sizes are in range */
> @@ -2522,7 +2522,6 @@ static void
>  validate_log_sectorsize(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli,
> -	struct cli_params	*dft,
>  	struct fs_topology	*ft)
>  {
>  
> @@ -2714,7 +2713,6 @@ static void
>  validate_zoned(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli,
> -	struct cli_params	*dft,
>  	struct zone_topology	*zt)
>  {
>  	if (!cli->xi->data.isfile) {
> @@ -6163,8 +6161,8 @@ main(
>  	 * Extract as much of the valid config as we can from the CLI input
>  	 * before opening the libxfs devices.
>  	 */
> -	validate_blocksize(&cfg, &cli, &bld_dft);
> -	validate_sectorsize(&cfg, &cli, &bld_dft, &ft, dry_run, force_overwrite);
> +	validate_blocksize(&cfg, &cli);
> +	validate_sectorsize(&cfg, &cli, &ft, dry_run, force_overwrite);
>  
>  	/*
>  	 * XXX: we still need to set block size and sector size global variables
> @@ -6173,8 +6171,8 @@ main(
>  	blocksize = cfg.blocksize;
>  	sectorsize = cfg.sectorsize;
>  
> -	validate_log_sectorsize(&cfg, &cli, &bld_dft, &ft);
> -	validate_zoned(&cfg, &cli, &bld_dft, &zt);
> +	validate_log_sectorsize(&cfg, &cli, &ft);
> +	validate_zoned(&cfg, &cli, &zt);
>  	validate_sb_features(&cfg, &cli);
>  
>  	/*
> -- 
> 2.54.0
> 
> 
