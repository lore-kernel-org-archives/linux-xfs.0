Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CAD4219F9
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 15:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778772117; cv=none; b=IYDRQ1HJqRRNaB5LfTc/vgwDL0QGQLecWObWj03W+78WyF8nBu5XGOJB42s60oP0f89kdKUMk+EiEVqPnnkum6mJx2c5utldkSrbAH0CX4D3obVGMYPHdPXPRNXcFmVOq0V8I6B2efcjAgjm+HoxpauuSNUJA0vsssigsG/DrWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778772117; c=relaxed/simple;
	bh=ERUO1MXJVHgVWLhGh8nDBm4yVzSlyg0Sl0AqxAdff8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WbXJR9SRq8QsfCKa48DhSEknmBU2D/KEyRzWsxu7asMjEKseWt6h9HAMWF60QTJWiCEWxZRw+MdgQmIXcm0tQH669d7jsLwNurvA8aTyFq+oUFYU0WQMWG1l4pUPmh3lw3WC3ZUhTlMpcUnOYwfTnT5MMx5XWK4VAMHRswbj27o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uH/3LNuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uH/3LNuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B652BC2BCB3;
	Thu, 14 May 2026 15:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778772117;
	bh=ERUO1MXJVHgVWLhGh8nDBm4yVzSlyg0Sl0AqxAdff8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uH/3LNuzzHPGqCetcbb4BWEHW6XJ7GL64+C0G8yKS3YHDQXaodE+WupvJPBPzgRF1
	 K8zdDtQOJeEehehaT5TTDjT3qcXTHPLZphH75KO68EaB7KAJJm6SrWuxp/cHn03jYG
	 msr02tiIW6F42QCZNR1TtSJ/wag85+DuEpl2jM52tgr/0oLwK8eSd5XGegqVTet96r
	 1EaKueeUVd0RDn2w/DoutXDtBnfFPDzGiLF8jUMG5xdlaAKJsnNjqf7hA1qJ8kEed1
	 Xin/zURXnItDiKAzIqKbkCO+dnGwev8e0muLj3zRbkGRJjdUSQWzUtKw3SbayCP+FH
	 CZ05QSbKiflVw==
Date: Thu, 14 May 2026 17:21:52 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, sandeen@sandeen.net, aalbersh@kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] xfsprogs: mkfs.xfs add default configuration
 file.
Message-ID: <agXnLdc5kzfyOI3P@nidhogg.toxiclabs.cc>
References: <20260514143716.893814-2-lukas@herbolt.com>
 <20260514143716.893814-3-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514143716.893814-3-lukas@herbolt.com>

On Thu, May 14, 2026 at 04:37:17PM +0200, Lukas Herbolt wrote:
> Various users may prefer different default values. Having a default config
> file will allow them to utilize it without the need specifying configuration
> file on command line.
> 

The idea seems reasonable, to have a default file to load if it's found.
I just particularly don't like the idea of shipping/installing a 'default'
config file.
I think we could ship an "example" one, but leave to distributions to decide
what to do. If they would install a default config or not. And maintain
the default config file.
LTS configs are easy to maintain because we know no new features will be
ported to LTS. Providing a default config file from the mainline risks
getting a lot of user complains if we in the future decide to change the
'defaults' of the default config file.

> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  include/builddefs.in |  1 +
>  mkfs/Makefile        |  3 ++
>  mkfs/mkfs.xfs.conf   | 50 ++++++++++++++++++++++++++++++
>  mkfs/xfs_mkfs.c      | 72 +++++++++++++++++++++++++++++++++++++++-----
>  4 files changed, 119 insertions(+), 7 deletions(-)
>  create mode 100644 mkfs/mkfs.xfs.conf
> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 3b52d1afd703..b635a7cd08a6 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -59,6 +59,7 @@ PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
>  PKG_LOCALE_DIR	= @datadir@/locale
>  PKG_DATA_DIR	= @datadir@/@pkg_name@
>  MKFS_CFG_DIR	= @datadir@/@pkg_name@/mkfs
> +MKFS_SYSCONF_DIR = @sysconfdir@
>  PKG_STATE_DIR	= @localstatedir@/lib/@pkg_name@
>  
>  XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP=$(PKG_STATE_DIR)/xfs_scrub_all_media.stamp
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index fb1473324cde..57cee687eb1e 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -21,6 +21,7 @@ CFGFILES = \
>  	lts_6.12.conf \
>  	lts_6.18.conf
>  
> +LCFLAGS += -DMKFS_CFG_DIR=\"$(MKFS_CFG_DIR)\" -DMKFS_SYSCONF_DIR=\"$(MKFS_SYSCONF_DIR)\"
>  LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBBLKID) \
>  	$(LIBUUID) $(LIBINIH) $(LIBURCU) $(LIBPTHREAD)
>  LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
> @@ -45,6 +46,8 @@ install: default
>  	$(INSTALL) -m 755 $(XFS_PROTOFILE) $(PKG_SBIN_DIR)/xfs_protofile
>  	$(INSTALL) -m 755 -d $(MKFS_CFG_DIR)
>  	$(INSTALL) -m 644 $(CFGFILES) $(MKFS_CFG_DIR)
> +	$(INSTALL) -m 755 -d $(MKFS_SYSCONF_DIR)
> +	$(INSTALL) -m 644 mkfs.xfs.conf $(MKFS_SYSCONF_DIR)
>  
>  install-dev:
>  
> diff --git a/mkfs/mkfs.xfs.conf b/mkfs/mkfs.xfs.conf
> new file mode 100644
> index 000000000000..76f5ab4d4d8e
> --- /dev/null
> +++ b/mkfs/mkfs.xfs.conf
> @@ -0,0 +1,50 @@
> +# mkfs.xfs default configuration file
> +#
> +# This file documents some of the options recognised by mkfs.xfs config file.
> +# Adjust any value to override it system-wide.
> +#
> +# Command-line options always take precedence over values in this file.
> +# A specific config file can be selected with: mkfs.xfs -c options=<path>
> +
> +[block]
> +#size = 4096
> +
> +[metadata]
> +#crc = 1
> +#finobt = 1
> +#inobtcount = 1
> +#rmapbt = 1
> +#reflink = 1
> +#bigtime = 1
> +#metadir = 0
> +#autofsck = 0
> +
> +[inode]
> +#align = 1
> +# The default value is 25% for filesystems under 1TB,#5% for filesystems under
> +# 50TB and 1% for filesystems over 50TB.
> +#
> +#maxpct = 25
> +#size = 512
> +#perblock = 8
> +#attr = 2
> +#projid32bit = 1
> +#sparse = 1
> +#nrext64 = 1
> +#exchange = 1
> +
> +[data]
> +# -1 = autodetect (use CPU count only on solid-state devices), 0 = disabled
> +#concurrency = -1
> +
> +[log]
> +#internal = 1
> +#version = 2
> +#lazy-count = 1
> +# -1 = autodetect (use CPU count only on solid-state devices), 0 = disabled
> +#concurrency = -1
> +
> +[realtime]
> +# -1 = autodetect (use CPU count only on solid-state devices), 0 = disabled
> +#concurrency = -1
> +
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index dd8a48c3633e..dbf15eca3442 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -44,6 +44,11 @@
>   */
>  #define WHACK_SIZE (128 * 1024)
>  
> +/*
> + * Default configuration file which can keep distro specific values.
> + */
> +#define MKFS_DEFAULT_CFGFILE	MKFS_SYSCONF_DIR "/mkfs.xfs.conf"
> +
>  /*
>   * XXX: The configured block and sector sizes are defined as global variables so
>   * that they don't need to be passed to getnum/cvtnum().
> @@ -51,6 +56,11 @@
>  static unsigned int		blocksize;
>  static unsigned int		sectorsize;
>  
> +/*
> + * Set to true while parsing the config file so option handlers know the source
> + */
> +static bool			parsing_cfgfile;
> +
>  /*
>   * Enums for each CLI parameter type are declared first so we can calculate the
>   * maximum array size needed to hold them automatically.
> @@ -264,6 +274,7 @@ struct opt_params {
>  		bool		str_seen;
>  		bool		convert;
>  		bool		is_power_2;
> +		bool		from_file;
>  		struct _conflict {
>  			struct opt_params	*opts;
>  			int			subopt;
> @@ -472,7 +483,7 @@ static struct opt_params dopts = {
>  		  .conflicts = { { &dopts, D_AGCOUNT },
>  				 { &dopts, D_AGSIZE },
>  				 { NULL, LAST_CONFLICT } },
> -		  .minval = 0,
> +		  .minval = -1,
>  		  .maxval = INT_MAX,
>  		  .defaultval = 1,
>  		},
> @@ -672,7 +683,7 @@ static struct opt_params lopts = {
>  				 { &lopts, L_FILE },
>  				 { &lopts, L_DEV },
>  				 { NULL, LAST_CONFLICT } },
> -		  .minval = 0,
> +		  .minval = -1,
>  		  .maxval = INT_MAX,
>  		  .defaultval = 1,
>  		},
> @@ -827,7 +838,7 @@ static struct opt_params ropts = {
>  				 { &ropts, R_RGSIZE },
>  				 { NULL, LAST_CONFLICT } },
>  		  .convert = true,
> -		  .minval = 0,
> +		  .minval = -1,
>  		  .maxval = INT_MAX,
>  		  .defaultval = 1,
>  		},
> @@ -1072,6 +1083,7 @@ struct cli_params {
>  	int	blocksize;
>  
>  	char	*cfgfile;
> +	bool	cfgfile_had_options;
>  	char	*protofile;
>  
>  	enum fsprop_autofsck autofsck;
> @@ -1654,10 +1666,12 @@ check_opt(
>  		if (sp->seen)
>  			respec(opts->name, opts->subopts, index);
>  		sp->seen = true;
> +		sp->from_file = parsing_cfgfile;
>  	} else {
>  		if (sp->str_seen)
>  			respec(opts->name, opts->subopts, index);
>  		sp->str_seen = true;
> +		sp->from_file = parsing_cfgfile;
>  	}
>  
>  	/* check for conflicts with the option */
> @@ -1806,6 +1820,7 @@ set_data_concurrency(
>  	/*
>  	 * "nr_cpus" or "1" means set the concurrency level to the CPU count.
>  	 * If this cannot be determined, fall back to the default AG geometry.
> +	 * -1 means autodetect (use CPU count only on solid-state devices).
>  	 */
>  	if (!value || !strcmp(value, "nr_cpus"))
>  		optnum = 1;
> @@ -1814,6 +1829,8 @@ set_data_concurrency(
>  
>  	if (optnum == 1)
>  		cli->data_concurrency = nr_cpus();
> +	else if (optnum == -1)
> +		cli->data_concurrency = -1;
>  	else
>  		cli->data_concurrency = optnum;
>  }
> @@ -1954,6 +1971,7 @@ set_log_concurrency(
>  	/*
>  	 * "nr_cpus" or 1 means set the concurrency level to the CPU count.  If
>  	 * this cannot be determined, fall back to the default computation.
> +	 * -1 means autodetect (use CPU count only on solid-state devices).
>  	 */
>  	if (!value || !strcmp(value, "nr_cpus"))
>  		optnum = 1;
> @@ -1962,6 +1980,8 @@ set_log_concurrency(
>  
>  	if (optnum == 1)
>  		cli->log_concurrency = nr_cpus();
> +	else if (optnum == -1)
> +		cli->log_concurrency = -1;
>  	else
>  		cli->log_concurrency = optnum;
>  }
> @@ -2175,6 +2195,7 @@ set_rtvol_concurrency(
>  	 * "nr_cpus" or "1" means set the concurrency level to the CPU count.
>  	 * If this cannot be determined, fall back to the default rtgroup
>  	 * geometry.
> +	 * -1 means autodetect (use CPU count only on solid-state devices).
>  	 */
>  	if (!value || !strcmp(value, "nr_cpus"))
>  		optnum = 1;
> @@ -2183,6 +2204,8 @@ set_rtvol_concurrency(
>  
>  	if (optnum == 1)
>  		cli->rtvol_concurrency = nr_cpus();
> +	else if (optnum == -1)
> +		cli->rtvol_concurrency = -1;
>  	else
>  		cli->rtvol_concurrency = optnum;
>  }
> @@ -2336,9 +2359,32 @@ parse_cfgopt(
>  		if (!subopts[i])
>  			break;
>  		if (strcasecmp(name, subopts[i]) == 0) {
> +			struct subopt_param	*sp = &sop->opts->subopt_params[i];
> +			int			j;
> +
> +			/*
> +			 * Command line options take precedence over config file
> +			 * options. If this option or any option that conflicts
> +			 * with it was already set from the command line, skip
> +			 * the config file value silently.
> +			 */
> +			if ((sp->seen || sp->str_seen) && !sp->from_file)
> +				return true;
> +			for (j = 0; j < MAX_CONFLICTS; j++) {
> +				struct _conflict	*con = &sp->conflicts[j];
> +				struct subopt_param	*csp;
> +
> +				if (con->subopt == LAST_CONFLICT)
> +					break;
> +				csp = &con->opts->subopt_params[con->subopt];
> +				if ((csp->seen || csp->str_seen) && !csp->from_file)
> +					return true;
> +			}
> +
>  			ret = (sop->parser)(sop->opts, i, value, cli);
>  			if (ret)
>  				goto invalid_opt;
> +			cli->cfgfile_had_options = true;
>  			return true;
>  		}
>  	}
> @@ -5749,10 +5795,21 @@ cfgfile_parse(
>  {
>  	int			error;
>  
> -	if (!cli->cfgfile)
> -		return;
> +	bool	default_cfgfile = !cli->cfgfile;
> +
> +	if (!cli->cfgfile) {
> +		/*
> +		 * No config file specified on the command line. Use the default
> +		 * system-wide config file if it exists, otherwise do nothing.
> +		 */
> +		if (access(MKFS_DEFAULT_CFGFILE, F_OK) != 0)
> +			return;
> +		cli->cfgfile = MKFS_DEFAULT_CFGFILE;
> +	}
>  
> +	parsing_cfgfile = true;
>  	error = ini_parse(cli->cfgfile, cfgfile_parse_ini, cli);
> +	parsing_cfgfile = false;
>  	if (error) {
>  		if (error > 0) {
>  			fprintf(stderr,
> @@ -5773,8 +5830,9 @@ cfgfile_parse(
>  		}
>  		exit(1);
>  	}
> -	printf(_("Parameters parsed from config file %s successfully\n"),
> -		cli->cfgfile);
> +	if (!default_cfgfile || cli->cfgfile_had_options)
> +		printf(_("Parameters parsed from config file %s successfully\n"),
> +			cli->cfgfile);
>  }
>  
>  static void
> -- 
> 2.54.0
> 
> 
