Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FDE30C63B
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 04:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779944216; cv=none; b=NMvwj3YHOz/HxXIWmTzyhBarHgPGQwoNluKqEybQrsxU91oSb3gmRxN+5z5uqLop9bbDCrfyVVZfbL+NEwnwlS0LtX+zYf/bW92X4EWjjtz3s7S/nC77N+xju7wi7npQfjOdpcQAMKrq2IURfyLuzZYRDHB/vz8mU8G6bLCV6wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779944216; c=relaxed/simple;
	bh=QtDe2AzjJ6Q8FpkFp7M6e2Nbmp71SyggucPY0ZPGBs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slJMYWAlFPyoG1eTp6uUeaE5PNDB82Fs9HPPZ4L9Fc21GFmiMpKGfxCuyMHbk2JMxs/T/rlCvjHe1+F9IPG5EtwTYeBrv5z62tVb41zy3W63ZdJIUgrvCUKqzWzWZObkBtEQhPjeGm2XYXtvo4udqZz46XrFqPJRWOnt8yfyMOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1kRa9/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1kRa9/B"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6FF881F000E9;
	Thu, 28 May 2026 04:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779944214;
	bh=T+Xklb7nxn5fJGqenSkmpVVj0XLZoLmJNxe9NHZlP6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P1kRa9/BZNOJ1fuMoctm9T1rq7hAHoUDU+pbJoCe/dJeoThb6IMfnFFqukUyJHuXg
	 rUDsy7d2ACixZJXW6gnBoMGQv5HU0ui5OAdPAPOnG7GJCKr+TiqfqpX7iisgItwIzG
	 YIxQMg4ne14kkMYYUh6dbpX0EvCW5IjX18kyW2eUo4HswAxpElvR6SOgEB4KAxa6DI
	 jizPVdDBB65QnzXZtGeBd8Tj+qDxKomIrfEHKztOPsuLzN/QCVuz8jFOX1M2C6w8ZF
	 LHaKNoDpalFsDyQSGFpW5cvIJlbFQKRSdHFBVSBvPcUvpPQOU+TeOeb234SAFG6wpF
	 MfGmWWOeVbnMA==
Date: Wed, 27 May 2026 21:56:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: sandeen@sandeen.net, aalbersh@kernel.org, dgc@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/5] xfsprogs: mkfs.xfs add default configuration
 file.
Message-ID: <20260528045653.GD6078@frogsfrogsfrogs>
References: <20260525075752.4159504-1-lukas@herbolt.com>
 <20260525075752.4159504-3-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525075752.4159504-3-lukas@herbolt.com>

On Mon, May 25, 2026 at 09:57:49AM +0200, Lukas Herbolt wrote:
> Various users may prefer different default values. Having a default config
> file will allow them to utilize it without the need specifying configuration
> file on command line. The behavior is: build time options are overwritten
> by the default config file and this options can be overwritten either by
> command line options or by config file.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  include/builddefs.in      |   1 +
>  mkfs/Makefile             |   2 +
>  mkfs/default.conf.example |  10 ++++
>  mkfs/xfs_mkfs.c           | 113 ++++++++++++++++++++++++++++++++------
>  4 files changed, 108 insertions(+), 18 deletions(-)
>  create mode 100644 mkfs/default.conf.example
> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 3b52d1afd703..bafea70af8ea 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -59,6 +59,7 @@ PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
>  PKG_LOCALE_DIR	= @datadir@/locale
>  PKG_DATA_DIR	= @datadir@/@pkg_name@
>  MKFS_CFG_DIR	= @datadir@/@pkg_name@/mkfs
> +MKFS_SYSCFG_DIR = @sysconfdir@/mkfs.xfs.d
>  PKG_STATE_DIR	= @localstatedir@/lib/@pkg_name@
>  
>  XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP=$(PKG_STATE_DIR)/xfs_scrub_all_media.stamp
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index fb1473324cde..468d2ab7896e 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -11,6 +11,7 @@ XFS_PROTOFILE = xfs_protofile.py
>  HFILES =
>  CFILES = proto.c xfs_mkfs.c
>  CFGFILES = \
> +	default.conf.example \
>  	dax_x86_64.conf \
>  	lts_4.19.conf \
>  	lts_5.4.conf \
> @@ -21,6 +22,7 @@ CFGFILES = \
>  	lts_6.12.conf \
>  	lts_6.18.conf
>  
> +LCFLAGS += -DMKFS_CFG_DIR=\"$(MKFS_CFG_DIR)\" -DMKFS_SYSCFG_DIR=\"$(MKFS_SYSCFG_DIR)\"
>  LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
>  	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
>  LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
> diff --git a/mkfs/default.conf.example b/mkfs/default.conf.example
> new file mode 100644
> index 000000000000..ab418eab000d
> --- /dev/null
> +++ b/mkfs/default.conf.example
> @@ -0,0 +1,10 @@
> +# Default config file example.
> +#[metadata]
> +#bigtime=1
> +#crc=1
> +
> +#[inode]
> +#sparse=1
> +
> +#[naming]
> +#parent=1
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 349afe65c9fc..bff7d078901c 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -44,6 +44,11 @@
>   */
>  #define WHACK_SIZE (128 * 1024)
>  
> +/*
> + * Default configuration file which can keep distro specific values.
> + */
> +#define MKFS_DEFAULT_CFGFILE   MKFS_SYSCFG_DIR "/default.conf"
> +
>  /*
>   * XXX: The configured block and sector sizes are defined as global variables so
>   * that they don't need to be passed to getnum/cvtnum().
> @@ -5800,7 +5805,8 @@ cfgfile_parse(
>  		}
>  		exit(1);
>  	}
> -	printf(_("Parameters parsed from config file %s successfully\n"),
> +	if  (strcmp(cli->cfgfile, MKFS_DEFAULT_CFGFILE) != 0)

No need   ^^ for double spaces here.

> +		printf(_("Parameters parsed from config file %s successfully.\n"),
>  		cli->cfgfile);
>  }
>  
> @@ -5953,6 +5959,75 @@ check_rt_meta_prealloc(
>  	mp->m_finobt_nores = false;
>  }
>  
> +static void
> +check_ignored_opt(
> +	struct cli_params	*dflt,
> +	const char		*section,
> +	const char		*key)
> +{
> +	bool need_warn = false;
> +	if (strcmp(section, "metadata") == 0 && strcmp(key, "uuid") == 0) {
> +		if (!platform_uuid_is_null(&dflt->uuid)) {
> +			platform_uuid_clear(&dflt->uuid);
> +			need_warn = true;
> +		}
> +	}
> +
> +	if (strcmp(section, "data") == 0) {
> +		if (strcmp(key, "sunit") == 0 || strcmp(key, "su") == 0) {
> +	                dflt->dsunit = 0;
> +	                dflt->dsu = NULL;
> +                        need_warn = true;

Weird indenting here...

> +		}
> +
> +		if (strcmp(key, "swidth") == 0 || strcmp(key, "sw") == 0) {
> +			dflt->dswidth = 0;
> +			dflt->dsw = 0;
> +			need_warn = true;
> +		}
> +	}
> +
> +	if (strcmp(section, "sector") == 0 && strcmp(key, "size") == 0) {
> +			dflt->sectorsize = XFS_MIN_SECTORSIZE;
> +                        need_warn = true;

...and here...

> +	}
> +
> +	if (strcmp(section, "block") == 0 && strcmp(key, "size") == 0) {
> +			dflt->blocksize  = 1 << XFS_DFL_BLOCKSIZE_LOG;
> +                        need_warn = true;

...and here.

> +	}
> +
> +	if (need_warn)
> +		fprintf(stderr,
> +		_("'%s' in section '%s' ignored in default config file\n"),
> +		key, section);
> +}

Why do the disk geometry options get a specific warning vs. all the
other parameters that one might set in the defaults config file and then
override?

> +
> +static void
> +reset_opts_seen(
> +	struct cli_params	*dflt)
> +{
> +	struct subopts		*sop;
> +	struct subopt_param	*sp;
> +	int			i;
> +
> +	for (sop = &subopt_tab[0]; sop->opts; sop++) {
> +		if (sop->opts->ini_section[0] == '\0')
> +			continue;
> +		for (i = 0; i < MAX_SUBOPTS; i++) {
> +			if (!sop->opts->subopts[i])
> +				break;
> +			sp = &sop->opts->subopt_params[i];
> +			if (sp->seen || sp->str_seen)
> +				check_ignored_opt(dflt, sop->opts->ini_section,
> +							sop->opts->subopts[i]);
> +			sp->seen     = false;
> +			sp->str_seen = false;
> +		}
> +	}
> +}
> +
> +
>  int
>  main(
>  	int			argc,
> @@ -5978,6 +6053,7 @@ main(
>  	struct fs_topology	ft = {};
>  	struct mkfs_params	cfg = {};
>  	struct cli_params	cli;
> +	struct cli_params	file_dft;
>  
>  	struct option		long_options[] = {
>  	{
> @@ -5993,28 +6069,29 @@ main(
>  	struct list_head	buffer_list;
>  	int			error;
>  
> -	/* copy builtin defaults into CLI parsing structure */
> -	memcpy(&cli, &bld_dft, sizeof(cli));
> -	cli.xi = &xi;
> -	platform_uuid_generate(&cli.uuid);
> +	/* copy builtin defaults into file_dft parsing structure */
> +	memcpy(&file_dft, &bld_dft, sizeof(cli));
>  	progname = basename(argv[0]);
>  	setlocale(LC_ALL, "");
>  	bindtextdomain(PACKAGE, LOCALEDIR);
>  	textdomain(PACKAGE);
>  
> -	/*
> -	 * TODO: Sourcing defaults from a config file
> -	 *
> -	 * Before anything else, see if there's a config file with different
> -	 * defaults. If a file exists in <package location>, read in the new
> -	 * default values and overwrite them in the &dft structure. This way the
> -	 * new defaults will apply before we parse the CLI, and the CLI will
> -	 * still be able to override them. When more than one source is
> -	 * implemented, emit a message to indicate where the defaults being
> -	 * used came from.
> -	 *
> -	 * printf(_("Default configuration sourced from %s\n"), dft.source);
> -	 */
> +	if (access(MKFS_DEFAULT_CFGFILE, F_OK) == 0){
> +		/*
> +		 * We need to reset some values that were loaded from
> +		 * build time and set the cfgfile to default value
> +		 */
> +		file_dft.cfgfile = MKFS_DEFAULT_CFGFILE;
> +		cfgfile_parse(&file_dft);

What happens if MKFS_DEFAULT_CFGFILE disappears between the access()
call and the cfgfile_parse?

> +		reset_opts_seen(&file_dft);
> +		printf(_("Default configuration sourced from %s\n"),
> +				MKFS_DEFAULT_CFGFILE);
> +	}
> +
> +	memcpy(&cli, &file_dft, sizeof(cli));

Why have a separate file_dft and cli structure?  build_dft gets copied
into file_dft, file_dft is (possibly) mutated and then copied into cli,
and afer that neither file_dft nor build_dft are used again.

--D

> +	cli.cfgfile = NULL;
> +	cli.xi = &xi;
> +	platform_uuid_generate(&cli.uuid);
>  
>  	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
>  					long_options, &option_index)) != EOF) {
> -- 
> 2.54.0
> 
> 
