Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC38332ED51
	for <linux-xfs@vger.kernel.org>; Wed, 29 Oct 2025 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761752391; cv=none; b=bdMayLV+N9C3X0/ZMdwRgkV5P9nUXV+V/dRT2eCWhGHRcXscOdbO986Yiuihm3VKGbPMJqDCrStODnleCtQqGUX2VY6ZYAuVrcN1C3DMcTmQ1Qg2wWDCO+714vVltDslb/UlZBz/n5DTu0ECBpZUlrN0jLGRRrEF+bQiLWCLiPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761752391; c=relaxed/simple;
	bh=utX7ndpZ2ISVDFvYe/Qnm+2jmVpAEocuDz43mipUB4I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gs+Fxrp4nx1ohqMCb0o0ACkto3QO9quWjvOjZQU0tngHcv2LxMQp1tEGTMbSROrNf6TZkX9m2v770t3X+9dDwqtkMUnGI8OX+f10D7bmp8U1IGrL3QtNpH+5P/JVgB5AnfSd1J3GZT2oem8OUSyBAjLJknjdA3Bg0t+gU16dQHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TRmdUlFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRmdUlFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7757BC4CEF7;
	Wed, 29 Oct 2025 15:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761752390;
	bh=utX7ndpZ2ISVDFvYe/Qnm+2jmVpAEocuDz43mipUB4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TRmdUlFZYy8Lgwyr6HUGz4oCrl4E/E9joSss2dKcsRhK1IdaZsK30S9TJDW3k0Js2
	 xEf1yc2SFjJljNViKPGGglAO33ZeijK8BOYZ2b3JtiLkp5KLFrlaKxZzTeOg0GOLGM
	 slxMvOwDgjvbRdIJkLlIIG57IdZRIWMLzJlv17550iuCpEBiFAYS+iRkWq8W73t6an
	 SZh15AiFfJxnrO3CvPtZWEFVioDKTEqiinXd/epfJdIn1fqkOBZyiJDr+z8aCLQHMO
	 9gEZ93hzAoZf4849StL+MDQ+sc4XT1Zxt7Qs+OiXd/EcnduGekcQz2EjWpeVcY0c2w
	 WhBPxZ4UFRG3w==
Date: Wed, 29 Oct 2025 08:39:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] mkfs: remove duplicate struct libxfs_init arguments
Message-ID: <20251029153950.GZ3356773@frogsfrogsfrogs>
References: <20251029090737.1164049-1-hch@lst.de>
 <20251029090737.1164049-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029090737.1164049-4-hch@lst.de>

On Wed, Oct 29, 2025 at 10:07:31AM +0100, Christoph Hellwig wrote:
> The libxfs_init structure instance is pointed to by cli_params, so use
> that were it already exists instead of passing an additional argument.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yay fewer args,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mkfs/xfs_mkfs.c | 49 ++++++++++++++++++++++---------------------------
>  1 file changed, 22 insertions(+), 27 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 0ba7798eccf6..09a69af31be5 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -4005,8 +4005,7 @@ ddev_is_solidstate(
>  static void
>  calc_concurrency_ag_geometry(
>  	struct mkfs_params	*cfg,
> -	struct cli_params	*cli,
> -	struct libxfs_init	*xi)
> +	struct cli_params	*cli)
>  {
>  	uint64_t		try_agsize;
>  	uint64_t		def_agsize;
> @@ -4074,11 +4073,10 @@ out:
>  static void
>  calculate_initial_ag_geometry(
>  	struct mkfs_params	*cfg,
> -	struct cli_params	*cli,
> -	struct libxfs_init	*xi)
> +	struct cli_params	*cli)
>  {
>  	if (cli->data_concurrency > 0) {
> -		calc_concurrency_ag_geometry(cfg, cli, xi);
> +		calc_concurrency_ag_geometry(cfg, cli);
>  	} else if (cli->agsize) {	/* User-specified AG size */
>  		cfg->agsize = getnum(cli->agsize, &dopts, D_AGSIZE);
>  
> @@ -4099,8 +4097,9 @@ _("agsize (%s) not a multiple of fs blk size (%d)\n"),
>  		cfg->agcount = cli->agcount;
>  		cfg->agsize = cfg->dblocks / cfg->agcount +
>  				(cfg->dblocks % cfg->agcount != 0);
> -	} else if (cli->data_concurrency == -1 && ddev_is_solidstate(xi)) {
> -		calc_concurrency_ag_geometry(cfg, cli, xi);
> +	} else if (cli->data_concurrency == -1 &&
> +		   ddev_is_solidstate(cli->xi)) {
> +		calc_concurrency_ag_geometry(cfg, cli);
>  	} else {
>  		calc_default_ag_geometry(cfg->blocklog, cfg->dblocks,
>  					 cfg->dsunit, &cfg->agsize,
> @@ -4360,8 +4359,7 @@ rtdev_is_solidstate(
>  static void
>  calc_concurrency_rtgroup_geometry(
>  	struct mkfs_params	*cfg,
> -	struct cli_params	*cli,
> -	struct libxfs_init	*xi)
> +	struct cli_params	*cli)
>  {
>  	uint64_t		try_rgsize;
>  	uint64_t		def_rgsize;
> @@ -4468,8 +4466,7 @@ _("realtime group count (%llu) must be less than the maximum (%u)\n"),
>  static void
>  calculate_rtgroup_geometry(
>  	struct mkfs_params	*cfg,
> -	struct cli_params	*cli,
> -	struct libxfs_init	*xi)
> +	struct cli_params	*cli)
>  {
>  	if (!cli->sb_feat.metadir) {
>  		cfg->rgcount = 0;
> @@ -4510,8 +4507,9 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
>  		cfg->rgsize = cfg->rtblocks;
>  		cfg->rgcount = 0;
>  	} else if (cli->rtvol_concurrency > 0 ||
> -		   (cli->rtvol_concurrency == -1 && rtdev_is_solidstate(xi))) {
> -		calc_concurrency_rtgroup_geometry(cfg, cli, xi);
> +		   (cli->rtvol_concurrency == -1 &&
> +		    rtdev_is_solidstate(cli->xi))) {
> +		calc_concurrency_rtgroup_geometry(cfg, cli);
>  	} else if (is_power_of_2(cfg->rtextblocks)) {
>  		cfg->rgsize = calc_rgsize_extsize_power(cfg);
>  		cfg->rgcount = cfg->rtblocks / cfg->rgsize +
> @@ -4538,7 +4536,6 @@ static void
>  adjust_nr_zones(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli,
> -	struct libxfs_init	*xi,
>  	struct zone_topology	*zt)
>  {
>  	uint64_t		new_rtblocks, slack;
> @@ -4547,7 +4544,8 @@ adjust_nr_zones(
>  	if (zt->rt.nr_zones)
>  		max_zones = zt->rt.nr_zones;
>  	else
> -		max_zones = DTOBT(xi->rt.size, cfg->blocklog) / cfg->rgsize;
> +		max_zones = DTOBT(cli->xi->rt.size, cfg->blocklog) /
> +				cfg->rgsize;
>  
>  	if (!cli->rgcount)
>  		cfg->rgcount += XFS_RESERVED_ZONES;
> @@ -4576,7 +4574,6 @@ static void
>  calculate_zone_geometry(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli,
> -	struct libxfs_init	*xi,
>  	struct zone_topology	*zt)
>  {
>  	if (cfg->rtblocks == 0) {
> @@ -4645,7 +4642,7 @@ _("rgsize (%s) not a multiple of fs blk size (%d)\n"),
>  	}
>  
>  	if (cli->rtsize || cli->rgcount)
> -		adjust_nr_zones(cfg, cli, xi, zt);
> +		adjust_nr_zones(cfg, cli, zt);
>  
>  	if (cfg->rgcount < XFS_MIN_ZONES)  {
>  		fprintf(stderr,
> @@ -4984,7 +4981,6 @@ static uint64_t
>  calc_concurrency_logblocks(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli,
> -	struct libxfs_init	*xi,
>  	unsigned int		max_tx_bytes)
>  {
>  	uint64_t		log_bytes;
> @@ -4992,7 +4988,7 @@ calc_concurrency_logblocks(
>  	unsigned int		new_logblocks;
>  
>  	if (cli->log_concurrency < 0) {
> -		if (!ddev_is_solidstate(xi))
> +		if (!ddev_is_solidstate(cli->xi))
>  			goto out;
>  
>  		cli->log_concurrency = nr_cpus();
> @@ -5160,7 +5156,6 @@ static void
>  calculate_log_size(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli,
> -	struct libxfs_init	*xi,
>  	struct xfs_mount	*mp)
>  {
>  	struct xfs_sb		*sbp = &mp->m_sb;
> @@ -5225,8 +5220,8 @@ _("external log device size %lld blocks too small, must be at least %lld blocks\
>  		if (cfg->lsunit) {
>  			uint64_t	max_logblocks;
>  
> -			max_logblocks = min(DTOBT(xi->log.size, cfg->blocklog),
> -					    XFS_MAX_LOG_BLOCKS);
> +			max_logblocks = min(XFS_MAX_LOG_BLOCKS,
> +				DTOBT(cli->xi->log.size, cfg->blocklog));
>  			align_log_size(cfg, cfg->lsunit, max_logblocks);
>  		}
>  
> @@ -5261,7 +5256,7 @@ _("max log size %d smaller than min log size %d, filesystem is too small\n"),
>  
>  		if (cli->log_concurrency != 0)
>  			cfg->logblocks = calc_concurrency_logblocks(cfg, cli,
> -							xi, max_tx_bytes);
> +							max_tx_bytes);
>  
>  		/* But don't go below a reasonable size */
>  		cfg->logblocks = max(cfg->logblocks,
> @@ -6135,12 +6130,12 @@ main(
>  	 * dependent on device sizes. Once calculated, make sure everything
>  	 * aligns to device geometry correctly.
>  	 */
> -	calculate_initial_ag_geometry(&cfg, &cli, &xi);
> +	calculate_initial_ag_geometry(&cfg, &cli);
>  	align_ag_geometry(&cfg, &ft);
>  	if (cfg.sb_feat.zoned)
> -		calculate_zone_geometry(&cfg, &cli, &xi, &zt);
> +		calculate_zone_geometry(&cfg, &cli, &zt);
>  	else
> -		calculate_rtgroup_geometry(&cfg, &cli, &xi);
> +		calculate_rtgroup_geometry(&cfg, &cli);
>  
>  	calculate_imaxpct(&cfg, &cli);
>  
> @@ -6164,7 +6159,7 @@ main(
>  	 * With the mount set up, we can finally calculate the log size
>  	 * constraints and do default size calculations and final validation
>  	 */
> -	calculate_log_size(&cfg, &cli, &xi, mp);
> +	calculate_log_size(&cfg, &cli, mp);
>  
>  	finish_superblock_setup(&cfg, mp, sbp);
>  
> -- 
> 2.47.3
> 
> 
