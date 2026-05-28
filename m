Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9183101B9
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 04:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779943862; cv=none; b=fM9TFn0C/AK6stKJTrj9doQcPMHuGWIoaY0lP++8GHo+q6Ae3yPtiJkiqISZD2z4Z6d/+gvsTzG4oQ7FO4cH8ZHL//Wg5zqDoDjF6LaByWiWnZ7Io/2SV0puWoCJJ+/bGvD6CzaqwhtZfAKG4Xzn0Xw71FbK8rCaA1qWUMmo0bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779943862; c=relaxed/simple;
	bh=tsMQTkM++F5QymYgM0zz54ji64gYcMKqPCcfhOI1x7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P3wczm7m9UBl47/KFbyOa7sde+4espCWdLyUQLynNsuq6PBDDOjqIM31QcGYD0rrtRcTNuE4IeKncrulHAy3TvxjCZemQscX1jsV4Z8sKbbncucrKlk4dfeYEtZFhFhKiTWb8GM+8H8DrElxQV+ZegMB3qQejgh8nTmBofd/Usg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dnvy445j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dnvy445j"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3DE691F000E9;
	Thu, 28 May 2026 04:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779943860;
	bh=ndIMninH56F4HtYrsWASPqKfP/evSx9Ler+W6jrAE4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dnvy445j2X2xLGNLer8LEncEfk4OWz9+2m9y7ZHP5zD7FUSwUfTe+I3dPhc3uE2Fj
	 XeGZU99kgKy8COKotuUSEF94SZPx8GNKnsMSmzkJzHPFgR9tkXT8lk1XBy2s+7OIDd
	 DhSOkPCl/92jEwmX0QdXmOfHIBZ208eCQpy91l50/KN3ggYiwcWRpEBRT6QQFiZkLM
	 wZOkxWvkPFRYCh4s3T0C43dEeh1JbVoUXusBZcmF5Mn8k5cp7+zOA/cCD+Wca3ndvK
	 vOzkcqusn53WuYrGoERcHvNyfMXUSs1JpW1niKsIK9ZxDNRwKlnKNgqUJVvyyU3z7b
	 ymZWNj9AV7kRg==
Date: Wed, 27 May 2026 21:50:59 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, dgc@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/5] xfsprogs: mkfs.xfs Add buildtime default
 cli_params as global variable
Message-ID: <20260528045059.GC6078@frogsfrogsfrogs>
References: <20260525075752.4159504-1-lukas@herbolt.com>
 <20260525075752.4159504-2-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525075752.4159504-2-lukas@herbolt.com>

On Mon, May 25, 2026 at 09:57:48AM +0200, Lukas Herbolt wrote:
> This patch unites the settings of cli_params and mkfs_default_params
> into one global variable and then it copies its value into cli.
> The behavior should remain unchanged. It is preparation for next patch
> implementing the default config file.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  mkfs/xfs_mkfs.c | 116 +++++++++++++++++++++---------------------------
>  1 file changed, 50 insertions(+), 66 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index dd8a48c3633e..349afe65c9fc 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1190,17 +1190,44 @@ struct mkfs_params {
>   * values directly - they are inputs to the mkfs geometry validation and
>   * calculations.
>   */
> -struct mkfs_default_params {
> -	char	*source;	/* where the defaults came from */
> -
> -	int	sectorsize;
> -	int	blocksize;
> -
> -	/* feature flags that are set */
> -	struct sb_feat_args	sb_feat;
> -
> -	/* root inode characteristics */
> -	struct fsxattr		fsx;
> +struct cli_params bld_dft = {

static const?

and please spell out "build_default", we are no longer being charged by
the byte for source code.

> +       .sectorsize = XFS_MIN_SECTORSIZE,
> +       .blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
> +
> +       .loginternal = 1,
> +       .is_supported   = 1,
> +       .data_concurrency = -1, /* auto detect non-mechanical storage */
> +       .log_concurrency = -1, /* auto detect non-mechanical ddev */
> +       .rtvol_concurrency = -1, /* auto detect non-mechanical rtdev */
> +       .autofsck = FSPROP_AUTOFSCK_UNSET,
> +       .imaxpct = -1, /* set sb_imax_pct automatically */
> +
> +       .sb_feat = {
> +               .log_version = 2,
> +               .attr_version = 2,
> +               .dir_version = 2,
> +               .inode_align = true,
> +               .nci = false,
> +               .lazy_sb_counters = true,
> +               .projid32bit = true,
> +               .crcs_enabled = true,
> +               .dirftype = true,
> +               .finobt = true,
> +               .spinodes = true,
> +               .rmapbt = true,
> +               .reflink = true,
> +               .inobtcnt = true,
> +               .parent_pointers = true,
> +               .nodalign = false,
> +               .nortalign = false,
> +               .bigtime = true,
> +               .nrext64 = true,
> +               .exchrange = true,
> +               /*
> +                * When we decide to enable a new feature by default,
> +                * please remember to update the mkfs conf files.
> +                */
> +       },
>  };
>  
>  static void __attribute__((noreturn))
> @@ -2351,7 +2378,7 @@ static void
>  validate_sectorsize(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli,
> -	struct mkfs_default_params *dft,
> +	struct cli_params	*dft,
>  	struct fs_topology	*ft,
>  	int			dry_run,
>  	int			force_overwrite)
> @@ -2441,7 +2468,7 @@ static void
>  validate_blocksize(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli,
> -	struct mkfs_default_params *dft)
> +	struct cli_params	*dft)
>  {
>  	/*
>  	 * Blocksize and sectorsize first, other things depend on them
> @@ -2481,7 +2508,7 @@ static void
>  validate_log_sectorsize(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli,
> -	struct mkfs_default_params *dft,
> +	struct cli_params	*dft,
>  	struct fs_topology	*ft)
>  {
>  
> @@ -2673,7 +2700,7 @@ static void
>  validate_zoned(
>  	struct mkfs_params	*cfg,
>  	struct cli_params	*cli,
> -	struct mkfs_default_params *dft,
> +	struct cli_params	*dft,
>  	struct zone_topology	*zt)
>  {
>  	if (!cli->xi->data.isfile) {
> @@ -5949,17 +5976,8 @@ main(
>  	struct xfs_sb		*sbp = &mp->m_sb;
>  	struct xfs_dsb		*dsb;
>  	struct fs_topology	ft = {};
> -	struct cli_params	cli = {
> -		.xi = &xi,
> -		.loginternal = 1,
> -		.is_supported	= 1,
> -		.data_concurrency = -1, /* auto detect non-mechanical storage */
> -		.log_concurrency = -1, /* auto detect non-mechanical ddev */
> -		.rtvol_concurrency = -1, /* auto detect non-mechanical rtdev */
> -		.autofsck = FSPROP_AUTOFSCK_UNSET,
> -		.imaxpct = -1, /* set sb_imax_pct automatically */
> -	};
>  	struct mkfs_params	cfg = {};
> +	struct cli_params	cli;
>  
>  	struct option		long_options[] = {
>  	{
> @@ -5971,43 +5989,13 @@ main(
>  	{NULL, 0, NULL, 0 },
>  	};
>  	int			option_index = 0;
> -
> -	/* build time defaults */
> -	struct mkfs_default_params	dft = {
> -		.source = _("package build definitions"),
> -		.sectorsize = XFS_MIN_SECTORSIZE,
> -		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
> -		.sb_feat = {
> -			.log_version = 2,
> -			.attr_version = 2,
> -			.dir_version = 2,
> -			.inode_align = true,
> -			.nci = false,
> -			.lazy_sb_counters = true,
> -			.projid32bit = true,
> -			.crcs_enabled = true,
> -			.dirftype = true,
> -			.finobt = true,
> -			.spinodes = true,
> -			.rmapbt = true,
> -			.reflink = true,
> -			.inobtcnt = true,
> -			.parent_pointers = true,
> -			.nodalign = false,
> -			.nortalign = false,
> -			.bigtime = true,
> -			.nrext64 = true,
> -			.exchrange = true,
> -			/*
> -			 * When we decide to enable a new feature by default,
> -			 * please remember to update the mkfs conf files.
> -			 */
> -		},
> -	};
>  	struct zone_topology zt = {};
>  	struct list_head	buffer_list;
>  	int			error;
>  
> +	/* copy builtin defaults into CLI parsing structure */
> +	memcpy(&cli, &bld_dft, sizeof(cli));
> +	cli.xi = &xi;
>  	platform_uuid_generate(&cli.uuid);
>  	progname = basename(argv[0]);
>  	setlocale(LC_ALL, "");
> @@ -6028,10 +6016,6 @@ main(
>  	 * printf(_("Default configuration sourced from %s\n"), dft.source);
>  	 */
>  
> -	/* copy new defaults into CLI parsing structure */
> -	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
> -	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
> -
>  	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
>  					long_options, &option_index)) != EOF) {
>  		switch (c) {
> @@ -6093,8 +6077,8 @@ main(
>  	 * Extract as much of the valid config as we can from the CLI input
>  	 * before opening the libxfs devices.
>  	 */
> -	validate_blocksize(&cfg, &cli, &dft);
> -	validate_sectorsize(&cfg, &cli, &dft, &ft, dry_run, force_overwrite);
> +	validate_blocksize(&cfg, &cli, &bld_dft);
> +	validate_sectorsize(&cfg, &cli, &bld_dft, &ft, dry_run, force_overwrite);

Why is it necessary to pass &cli and &bld_dft into these validate
functions, since you already memcpy'd the defaults from bld_dft into
cli?

--D

>  	/*
>  	 * XXX: we still need to set block size and sector size global variables
> @@ -6103,8 +6087,8 @@ main(
>  	blocksize = cfg.blocksize;
>  	sectorsize = cfg.sectorsize;
>  
> -	validate_log_sectorsize(&cfg, &cli, &dft, &ft);
> -	validate_zoned(&cfg, &cli, &dft, &zt);
> +	validate_log_sectorsize(&cfg, &cli, &bld_dft, &ft);
> +	validate_zoned(&cfg, &cli, &bld_dft, &zt);
>  	validate_sb_features(&cfg, &cli);
>  
>  	/*
> -- 
> 2.54.0
> 
> 
