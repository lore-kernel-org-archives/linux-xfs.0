Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE21D38D3FB
	for <linux-xfs@vger.kernel.org>; Thu, 14 May 2026 23:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778801746; cv=none; b=kZ2AZFqoaqfNSO6dtQcud/mhfo/6NXe2wDlGO9C0tdmBa/7qn8Ij0uK3wUZw8Y4BmsoKW0rQfUzF9vhotN2Eq4tLcMpsTJj0016RBbsWWeyeysabtkoiFtJyHMKqJuoN3RXg7CcK0oPERZESdHEsODfTPSGzy45g/7n33c8tdck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778801746; c=relaxed/simple;
	bh=7aujOcky1iEAzwkSwiG6FYFQHuN8KDkNatG4pJfGz9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K58h6AaUG6jWc3OFmZWuBHBasTc9da4OXSUlLfTiI1KYtcIo0MSAWCjayVMXllfO+VjRHTcAg2WuKrN5Yrv7+fyawa4ue62tbYZ6y+pvQT9puhv1D6vqb0ds3dylGT8WaXre5z47Zm2uF89mnMspZ0xZmA/ErQWXzbrfCddwgqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HG/yLMUM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HG/yLMUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC20C2BCB3;
	Thu, 14 May 2026 23:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778801746;
	bh=7aujOcky1iEAzwkSwiG6FYFQHuN8KDkNatG4pJfGz9Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HG/yLMUMl9sWE7MB7Ie1kCwQ/gtqxK3OXkDsLHknk1ZtsNnIzfp0srEnsBwJiihfG
	 cos7i8lWkRFstKHTecnH5L/zstF6d2A7urrkQqDIa45fzz6EkIx0hTA4WiQSdATgzX
	 pYWQjH1GTyuHOhfLnxSQDzimiuOJHC1aUq1mf1e+feq39vBqhoRHwe1BWzMnLcrq+H
	 /FWc9tfAGqFptJZmJjLxlnWBSd7nxke6xwZC+TKOY+1OOlgVE2NFtWc1KOE8yXlASb
	 FisTt8z8WMxtezEEjKO+43T4lSn4Zv3YSr2xdFi4VRg8y7jig1mGJivQ1wAMpVMiBJ
	 89peg0Bmw4plw==
Date: Fri, 15 May 2026 09:35:38 +1000
From: Dave Chinner <dgc@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, sandeen@sandeen.net, aalbersh@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] xfsprogs: mkfs.xfs add default configuration
 file.
Message-ID: <agZcSv04h0E1Tu0a@dread>
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

Why do we need a config file that contains all the current defaults
commented out? We don't do this for the command line conf files we
ship, so this just seems like unnecessary maintenance overhead to
me...

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

Not sure I like this way saying "autotune". This should match the
existing conf file behaviour to override the default. i.e. 0 turns
it off, 1 = autodetect, "nr_cpus" = autodetect", any other positive
value is the minimum concurrency value.

IMO we should be exactly consistent with the CLI options here so
that we don't need special parsing code just for the default
options.

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

Should we make the path for MKFS_SYSCONF_DIR mkfs specific, allowing
more than just one potential config file to be installed here?  e.g.
/etc/xfsprogs/mkfs/ allows us to use this directory for more than
just a single default config file. While we probably don't need that
right now, starting from a directory based conf fiel setup means we
aren't stuck with having to support a single hardcoded/fixed conf
file name forever.

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

This seems wrong to me. The defaults should always be parsed if the
default file is present, whilst the CLI conf file should -overlay-
the defaults like it currently does.

For example, the system might be set up for on, say 6.12-lts, so
it's default is lts_6.12.conf. The user then has a custom config
file for their cloud deployments that need some extra config (e.g.
turns off rmapbt). i.e. they want all of the 6.12 configs except for
one.

Instead of having to craft a config file for all the 6.12 defaults,
they simple have "rmapbt=0" in a conf file and provide that on the
CLI. Now they have a mkfs.xfs that defaults to 6.12-lts compatible
filesystems, and when making their cloud images it simply applies
a config overlay file via the command line.

When they upgrade all the systems to, say, 6.19-lts, they don't need
to rewrite their custom overlay conf file - the system mkfs.xfs now
defaults to 6.19-lts compatible filesystems, and their overlay conf
file doesn't need changing. If they still need everything to use
6.12 comaptible filesystems, then they change the system default
conf file, not their cloud-specific conf file.

>  
> +	parsing_cfgfile = true;
>  	error = ini_parse(cli->cfgfile, cfgfile_parse_ini, cli);
> +	parsing_cfgfile = false;
>  	if (error) {
>  		if (error > 0) {
>  			fprintf(stderr,

This is not how I envisiaged default config file setup to work for
mkfs back when I rewrote all the parsing to be able to support
config files. i.e.

commit 68344ba0f8cea778919e17958969b6c2459f890a
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Dec 6 17:14:27 2017 -0600

    mkfs: introduce default configuration structure

    mkfs has lots of options that require default values. Some of these
    are centralised, but others aren't. Introduce a new structure
    designed to hold default values for all the parameters that need
    defaults in one place.

    This structure also provides a mechanism for providing mkfs defaults
    from a config file. This is not implemented in this series, but a
    comment is left where it is expected this functionality will hook
    in.

    Signed-Off-By: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

That comment is right at the start of the main() function:

        /*
         * TODO: Sourcing defaults from a config file
         *
         * Before anything else, see if there's a config file with different
         * defaults. If a file exists in <package location>, read in the new
         * default values and overwrite them in the &dft structure. This way the
         * new defaults will apply before we parse the CLI, and the CLI will
         * still be able to override them. When more than one source is
         * implemented, emit a message to indicate where the defaults being
         * used came from.
         *
         * printf(_("Default configuration sourced from %s\n"), dft.source);
         */

        /* copy new defaults into CLI parsing structure */
        memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
        memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));

What the new defaults file code should be doing is parsing the
defaults file into a new "struct cli_params" structure, then using
the options parsed from the file to initialise the CLI parsing
structure. i.e. I had intended the above code to be replaced with
something like:

	struct cli_params file_dfts { ....};
....

        /* Source defaults from a config file if it exists */
	file_dfts.config_file = MKFS_DEFAULT_CFGFILE;
        memcpy(&cli.sb_feat, &file_dfts.sb_feat, sizeof(cli.sb_feat));
        memcpy(&cli.fsx, &file_dfts.fsx, sizeof(cli.fsx));
	cfgfile_parse(&file_dfts);

	/* Set up defaults for CLI parsing */
	intialise_cli_params(&cli, &file_dfts);

.....

and initialise_cli_params() looked something like:

initialise_cli_params(
	*cli,
	*default)
{
        /* copy feature fields into CLI parsing structure */
        memcpy(&cli->sb_feat, &default->sb_feat, sizeof(cli->sb_feat));
        memcpy(&cli->fsx, &default->fsx, sizeof(cli->fsx));

	/*
	 * Check for parameters we shouldn't set in default conf
	 * files. e.g. device specific parameters like sector sizes,
	 * sunit/swidth, etc probably shouldn't be set in global
	 * default conf files. Warn and clear these parameters.
	 */

	/*
	 * Iterate the parameters found in the default config file
	 * and set them as initial values for the CLI parameter
	 * parsing. CLI parsing will overwrite these.
	 */
	<exercise left to the reader>
}

Now the CLI and cli conf file parsing should be able to be done
pretty much as it is currently done. They should override the
defaults as they currently do, and all existing scripts will behave
as expected except for mkfs using different system-specified
defaults.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
