Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:54604 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751543AbeERAoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 20:44:09 -0400
Date: Fri, 18 May 2018 10:44:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180518004404.GF23861@dastard>
References: <20180517192700.23457-1-mcgrof@kernel.org>
 <20180517192700.23457-6-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180517192700.23457-6-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 17, 2018 at 12:27:00PM -0700, Luis R. Rodriguez wrote:
> You may want to stick to specific set of configuration options when
> creating filesystems with mkfs.xfs -- sometimes due to pure technical
> reasons, but some other times to ensure systems remain compatible as
> new features are introduced with older kernels, or if you always want
> to take advantage of some new feature which would otherwise typically
> be disruptive.
> 
> This adds support for parsing a configuration file to override defaults
> parameters to be used for mkfs.xfs.

.....

Just looking at code right now...

> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -21,6 +21,7 @@
>  #include "xfs_multidisk.h"
>  #include "libxcmd.h"
>  #include "xfs_mkfs_common.h"
> +#include "xfs_mkfs_config.h"
>  #include "xfs_mkfs_cli.h"
>  
>  
> @@ -3077,11 +3078,13 @@ print_mkfs_cfg(
>  	struct mkfs_params	*cfg,
>  	char			*dfile,
>  	char			*logfile,
> -	char			*rtfile)
> +	char			*rtfile,
> +	struct mkfs_default_params *dft)
>  {
>  	struct sb_feat_args	*fp = &cfg->sb_feat;
>  
>  	printf(_(
> +"config-file=%-22s\n"
>  "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
>  "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
>  "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
> @@ -3091,6 +3094,7 @@ print_mkfs_cfg(
>  "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
>  "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
>  "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
> +		dft->type != DEFAULTS_BUILTIN ? dft->config_file : "empty",
>  		dfile, cfg->inodesize, (long long)cfg->agcount,
>  			(long long)cfg->agsize,
>  		"", cfg->sectorsize, fp->attr_version, fp->projid32bit,

Haven't we already printed where the config was sourced from? Why do
we need to print it again here?

> @@ -3665,6 +3669,7 @@ rewrite_secondary_superblocks(
>  /* build time defaults */
>  struct mkfs_default_params	built_in_dft = {
>  	.type = DEFAULTS_BUILTIN,
> +	.config_file = MKFS_XFS_CONF_DIR "default",
>  	.sectorsize = XFS_MIN_SECTORSIZE,
>  	.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
>  	.sb_feat = {
> @@ -3714,6 +3719,13 @@ static void process_defaults(
>  	struct mkfs_default_params	*dft,
>  	struct cli_params		*cli)
>  {
> +	int ret;
> +
> +	ret = parse_config_init(dft);
> +
> +	if (ret && dft->type != DEFAULTS_BUILTIN)
> +		usage();

That doesn't make any sense in isolation.

>  	install_defaults(dft, cli);
>  }
>  
> @@ -3750,6 +3762,8 @@ main(
>  	};
>  	struct mkfs_params	cfg = {};
>  	struct mkfs_default_params	dft;
> +	char *tmp_config;
> +	char custom_config[PATH_MAX];
>  
>  	reset_defaults_and_cli(&dft, &cli);
>  
> @@ -3760,21 +3774,36 @@ main(
>  	textdomain(PACKAGE);
>  
>  	/*
> -	 * TODO: Sourcing defaults from a config file
> -	 *
>  	 * Before anything else, see if there's a config file with different
> -	 * defaults. If a file exists in <package location>, read in the new
> +	 * defaults. If a file exists in MKFS_XFS_CONF_DIR/default, read the new
>  	 * default values and overwrite them in the &dft structure. This way the
>  	 * new defaults will apply before we parse the CLI, and the CLI will
>  	 * still be able to override them. When more than one source is
>  	 * implemented, emit a message to indicate where the defaults being
>  	 * used came from.
>  	 */

This comment makes no mention of environment variables, or how they
interact with other sources of config files.

> +	tmp_config = getenv("MKFS_XFS_CONFIG");
> +	if (tmp_config != NULL) {
> +		dft.config_file = tmp_config;
> +		dft.type = DEFAULTS_ENVIRONMENT_CONFIG;
> +	}
>  
>  	process_defaults(&dft, &cli);

So why are we processing the defaults before we've checked if a
default file is specified on the command line? All this should do is
set up the config file to be read, and set the dft.source =
_("Environment Variable");

>  
> -	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
>  		switch (c) {
> +		case 'c':
> +			reset_defaults_and_cli(&dft, &cli);

This will trash the existing CLI inputs that have already been
parsed. All this code here should do is set up the config file
to be read.

> +
> +			memset(custom_config, 0, sizeof(custom_config));
> +			snprintf(custom_config, sizeof(custom_config), "%s%s",
> +				 MKFS_XFS_CONF_DIR, optarg);
> +			dft.config_file = custom_config;
> +			dft.type = DEFAULTS_TYPE_CONFIG;
> +
> +			process_defaults(&dft, &cli);

Again, what happens if the user specifies multiple config files?
The second config file will trash everything from the first, as well
as any other options between them.

I think that we need to pull the "-c <file>" option from the command
line and process all the defaults /before/ we enter the main command
line processing loop.

IOWs:
	config_file = getenv("MKFS_XFS_CONFIG");
	if (config_file)
		dft.source = _("Environment Variable");

	/*
	 * Pull config line options from command line
	 */
	while ((c = getopt(argc, argv, "c:")) != EOF) {
		switch (c) {
		case 'c':
			/* XXX: fail if already seen a CLI option */
			config_file = optarg;
			dft.source = _("Command Line");
			break;
		default:
			continue;
		}
	}

	if (config_file) {
		/*
		 * parse_defaults_file() knows about config file
		 * search paths, so just pass in the raw,
		 * unvalidated filename and let it do all the work
		 * finding the file containing the default values.
		 */
		error = parse_defaults_file(&dft, config_file);
		if (error) {
			/* fail! */
		}
	}
	printf(_("Default configuration sourced from %s\n"), dft.source);

	/*
	 * Done parsing defaults now, so memcpy defaults into CLI
	 * structure, reset getopt and start parsing CLI options
	 */
	memcpy(/* sb_feats */);
	memcpy(/* fsxattr */);
	optind = 1;
	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
		switch (c) {
		case 'c':
			/* already validated and parsed, ignore */
			break;
		....


> diff --git a/mkfs/xfs_mkfs_common.h b/mkfs/xfs_mkfs_common.h
> index d867ab377185..028bbf96017f 100644
> --- a/mkfs/xfs_mkfs_common.h
> +++ b/mkfs/xfs_mkfs_common.h
> @@ -46,9 +46,20 @@ struct sb_feat_args {
>   * These are the different possibilities by which you can end up parsing
>   * default settings with. DEFAULTS_BUILTIN indicates there was no configuration
>   * file parsed and we are using the built-in defaults on this code.
> + * DEFAULTS_CONFIG means the default configuration file was found and used.
> + * DEFAULTS_TYPE_CONFIG means the user asked for a custom configuration type
> + * and it was used, this means the default directory for mkfs.xfs
> + * configuration files was used to look for the type specified. If you need
> + * to override the default mkfs.xfs directory for configuration file you can
> + * use the MKFS_XFS_CONFIG environment variable to set the absolute path to
> + * your custom configuration file, when this is set the type is set to
> + * DEFAULTS_ENVIRONMENT_CONFIG.
>   */
>  enum default_params_type {
>  	DEFAULTS_BUILTIN = 0,
> +	DEFAULTS_CONFIG,
> +	DEFAULTS_ENVIRONMENT_CONFIG,
> +	DEFAULTS_TYPE_CONFIG,
>  };

Again, I just don't see the need for this...

>  /*
> @@ -61,6 +72,7 @@ enum default_params_type {
>   */
>  struct mkfs_default_params {
>  	enum default_params_type type; /* where the defaults came from */
> +	const char *config_file;

Or this (see above :).

>  
>  	int	sectorsize;
>  	int	blocksize;
> diff --git a/mkfs/xfs_mkfs_config.c b/mkfs/xfs_mkfs_config.c
> new file mode 100644
> index 000000000000..d554638982ff
> --- /dev/null
> +++ b/mkfs/xfs_mkfs_config.c
> @@ -0,0 +1,591 @@
> +/*
> + * Copyright (c) 2018 Luis R. Rodriguez <mcgrof@kernel.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +
> +#include "xfs_mkfs_common.h"
> +#include "xfs_mkfs_config.h"
> +
> +#define CONFIG_MAX_KEY		1024
> +#define CONFIG_MAX_VALUE	PATH_MAX
> +#define CONFIG_MAX_BUFFER	CONFIG_MAX_KEY + CONFIG_MAX_VALUE + 3
> +
> +/*
> + * Enums for each configuration option. All these currently match the CLI
> + * parameters for now but this may change later, so we keep all this code
> + * and definitions separate. The rules for configuration parameters may also
> + * differ.
> + */

Why define them all when we are only going to parse a small subset?

> +enum mkfs_config_section {
> +	MKFS_CONFIG_SECTION_BLOCK = 0,
> +	MKFS_CONFIG_SECTION_DATA,
> +	MKFS_CONFIG_SECTION_INODE,
> +	MKFS_CONFIG_SECTION_LOG,
> +	MKFS_CONFIG_SECTION_METADATA,
> +	MKFS_CONFIG_SECTION_NAMING,
> +	MKFS_CONFIG_SECTION_RTDEV,
> +	MKFS_CONFIG_SECTION_SECTOR,
> +
> +	MKFS_CONFIG_SECTION_INVALID,
> +};
> +
> +struct opt_params {
> +	const enum mkfs_config_section section;
> +	const char	*subopts[MAX_SUBOPTS];
> +};
> +
> +extern struct opt_params config_sopts;

Why is this declared here?

> +
> +struct opt_params config_bopts = {
> +	.section = 'b',

That's not an enum, looks broken. Why isn't this the ascii name
of the config section in the config file?

> +	.subopts = {
> +		[B_SIZE] = "size",
> +	},
> +};
> +
> +struct opt_params config_dopts = {
> +	.section = 'd',
> +	.subopts = {
> +		[D_AGCOUNT] = "agcount",
> +		[D_FILE] = "file",
> +		[D_NAME] = "name",
> +		[D_SIZE] = "size",
> +		[D_SUNIT] = "sunit",
> +		[D_SWIDTH] = "swidth",
> +		[D_AGSIZE] = "agsize",
> +		[D_SU] = "su",
> +		[D_SW] = "sw",
> +		[D_SECTSIZE] = "sectsize",
> +		[D_NOALIGN] = "noalign",
> +		[D_RTINHERIT] = "rtinherit",
> +		[D_PROJINHERIT] = "projinherit",
> +		[D_EXTSZINHERIT] = "extszinherit",
> +		[D_COWEXTSIZE] = "cowextsize",
> +	},
> +};

So the parser will accept names we can't configure?

[...]

> +const char *default_type_str(enum default_params_type type)
> +{
> +	switch (type) {
> +	case DEFAULTS_BUILTIN:
> +		return _("package built-in definitions");
> +	case DEFAULTS_CONFIG:
> +		return _("default configuration system file");
> +	case DEFAULTS_ENVIRONMENT_CONFIG:
> +		return _("custom configuration file set by environment");
> +	case DEFAULTS_TYPE_CONFIG:
> +		return _("custom configuration type file");
> +	}
> +	return _("Unkown\n");
> +}

This function can go away.

> +static int block_config_parser(struct mkfs_default_params *dft, int subopt,
> +			       bool value)
> +{
> +	return -EINVAL;
> +}

Why is the value passed to the parser a bool type and not a
uint64_t?

> +struct config_subopts {
> +	enum mkfs_config_section	section;
> +	struct opt_params		*opts;
> +	int (*config_parser)(struct mkfs_default_params *dft,
> +			     int subop, bool value);
> +} config_subopt_tab[] = {
> +	{ MKFS_CONFIG_SECTION_BLOCK, &config_bopts, block_config_parser },
> +	{ MKFS_CONFIG_SECTION_DATA, &config_dopts, data_config_parser },
> +	{ MKFS_CONFIG_SECTION_INODE, &config_iopts, inode_config_parser },
> +	{ MKFS_CONFIG_SECTION_LOG, &config_lopts, log_config_parser },
> +	{ MKFS_CONFIG_SECTION_METADATA, &config_mopts, meta_config_parser },
> +	{ MKFS_CONFIG_SECTION_NAMING, &config_nopts, naming_config_parser },
> +	{ MKFS_CONFIG_SECTION_RTDEV, &config_ropts, rtdev_config_parser },
> +	{ MKFS_CONFIG_SECTION_SECTOR, &config_sopts, sector_config_parser },
> +	{ '\0', NULL },
> +};
> +
> +static int
> +parse_config_subopts(
> +	enum mkfs_config_section	section,
> +	bool				value,
> +	char				*line,
> +	struct mkfs_default_params	*dft)
> +{
> +	struct config_subopts *sop = &config_subopt_tab[0];
> +	char	**subopts = (char **)sop->opts->subopts;
> +	int	subopt;
> +	char *val;
> +
> +	while (sop->opts) {
> +		if (sop->section == section)
> +			break;
> +		sop++;
> +	}
> +
> +	/* should never happen */
> +	if (!sop->opts)
> +		return -EINVAL;
> +
> +	subopts = (char **)sop->opts->subopts;
> +	subopt = getsubopt(&line, subopts, &val);
> +	return (sop->config_parser)(dft, subopt, value);
> +}

This seems back to front - why do we walk the table to find the
entry that corresponds to an enum when we've....

> +static enum mkfs_config_section get_config_section(const char *buffer)
> +{
> +	if (strncmp("block", buffer, 5) == 0)
> +		return MKFS_CONFIG_SECTION_BLOCK;

This will match "blocksdfsgdfgd" - strcmp is fine here.

> +	if (strncmp("data", buffer, 4) == 0)
> +		return MKFS_CONFIG_SECTION_DATA;
> +	if (strncmp("inode", buffer, 5) == 0)
> +		return MKFS_CONFIG_SECTION_INODE;
> +	if (strncmp("log", buffer, 3) == 0)
> +		return MKFS_CONFIG_SECTION_LOG;
> +	if (strncmp("metadata", buffer, 8) == 0)
> +		return MKFS_CONFIG_SECTION_METADATA;
> +	if (strncmp("naming", buffer, 6) == 0)
> +		return MKFS_CONFIG_SECTION_NAMING;
> +	if (strncmp("rtdev", buffer, 5) == 0)
> +		return MKFS_CONFIG_SECTION_RTDEV;
> +	if (strncmp("sector", buffer, 6) == 0)
> +		return MKFS_CONFIG_SECTION_SECTOR;
> +
> +	return MKFS_CONFIG_SECTION_INVALID;
> +}

Directly parsed the section name to turn it into an enum? Indeed,
this looks all wrong in terms of structure.

static struct confopts blockopts = {
	.name = "[block]",
	.subopts = {
		[B_SIZE] = "size",
	},
	.parser = block_config_parser,
	.seen = false,
};

struct confopts *
get_confopts(const char *section)
{
	if (strcmp(blockopts.name, section) == 0)
		return &blockopts;
	.....
}

	....
	opts = get_confopts(section);
	if (!opts)
		/* fail, invalid section */
	if (opts->seen)
		/* fail, multiple specification */
	/* loop extracting and processing sbuopts */


And now the whole section enum construct and the
parse_config_subopts() function goes away.

> +static int mkfs_check_config_file_limits(const char *filename,
> +					 const struct stat *sb,
> +					 unsigned int max_entries)
> +{
> +	unsigned long long size_limit;
> +
> +	size_limit = CONFIG_MAX_BUFFER * max_entries;
> +
> +	/*
> +	 * Detect wrap around -- if max_entries * size_limit goves over
> +	 * unsigned long long we detect that there. Note some libraries,
> +	 * like libiniconfig, only groks max INT_MAX entries anyway, so
> +	 * if we ever use a library for parsing we'd be restricted to that
> +	 * limit.
> +	 */
> +	if (size_limit < max_entries || max_entries > INT_MAX)
> +		return -E2BIG;
> +
> +	if (sb->st_size > size_limit) {
> +		fprintf(stderr,
> +			"File %s is too big! File size limit: %llu\n",
> +			filename, size_limit);
> +		return -E2BIG;
> +	}
> +
> +	return 0;
> +}

What is this supposed to protect again? If somone what to put lots
of comments or blank space in the config files, then what's the
problem with that? Seems like you jump through a lot of hoops to do
just this calculation - why not just say "1MB is more than enough
for anyone"?

> +enum parse_line_type {
> +	PARSE_COMMENT = 0,
> +	PARSE_SECTION,
> +	PARSE_TAG_VALUE,
> +	PARSE_INVALID,
> +	PARSE_EOF,
> +};

> +
> +static int parse_line_section(const char *line, char *tag)

I should have mentioned this before now, but it's finally got to me.
:) Function format for XFS code is:

static int
parse_line_section(
	const char	*line,
	char		*tag)
{
....

> +{
> +	return sscanf(line, " [%[^]]s]", tag);
> +}
> +
> +static int parse_line_tag_value(const char *line, char *tag,
> +				unsigned int *value)
> +{
> +	return sscanf(line, " %[^ \t=]"
> +		      " = "
> +		      "%u ",
> +		      tag, value);

Value can be a 64 bit quantity, so needs to be uint64_t....

> +}
> +
> +static enum parse_line_type parse_get_line_type(const char *line, char *tag,
> +						bool *value)
> +{
> +	int ret;
> +	unsigned int uint_value;
> +
> +	memset(tag, 0, 80);

Why? This should be done in the caller, and if there's a fixed
buffer size, then please use a #define.

> +
> +	if (strlen(line) < 2)
> +		return PARSE_INVALID;

So empty lines return PARSE_INVALID?

> +
> +	if (line[0] == '#')
> +		return PARSE_COMMENT;

What about lines starting with whitespace? e.g. " # comment"

> +	ret = parse_line_section(line, tag);
> +	if (ret == 1)
> +		return PARSE_SECTION;
> +
> +	if (ret == EOF)
> +		return PARSE_EOF;
> +
> +	ret = parse_line_tag_value(line, tag, &uint_value);
> +	if (ret == 2) {
> +		if (uint_value != 1 && uint_value != 0)
> +			return -EINVAL;
> +
> +		*value = !!uint_value;
> +
> +		return PARSE_TAG_VALUE;
> +	}

pass the full value back to the caller, let the subopt parser
validate it and squash it to the correct type.

> +
> +	if (ret == EOF)
> +		return PARSE_EOF;
> +
> +	return PARSE_INVALID;
> +}
> +
> +int parse_config_init(struct mkfs_default_params *dft)

int
parse_config_file(
	struct mkfs_default_params	*dft,
	const char 			*config_file)
{

i.e. we only get called if there's a config file configured.

> +{
> +	int ret;
> +	FILE *fp;
> +	struct stat sp;
> +	unsigned int num_subopts_sections = sizeof(config_subopt_tab) /
> +					    sizeof(struct config_subopts) - 1;
> +	char *p;
> +	char line[80], tag[80];
> +	bool value;
> +	enum parse_line_type parse_type;
> +	enum mkfs_config_section section = MKFS_CONFIG_SECTION_INVALID;
> +
> +	fp = fopen(dft->config_file, "r");
> +	if (!fp) {
> +		if (dft->type != DEFAULTS_BUILTIN) {
> +			fprintf(stderr, _("could not open config file: %s\n"),
> +				dft->config_file);
> +			ret = -ENOENT;
> +		} else
> +			ret = 0;
> +		return ret;
> +	}

This should be split out into a separate function that takes the
config file and tries to open it. If it's a relative path that was
supplied, then this function can also try all the configured search
paths for config files.

> +	/*
> +	 * If we found a file without it being specified on the command line,
> +	 * it would be the default configuration file.
> +	 */
> +	if (dft->type == DEFAULTS_BUILTIN)
> +		dft->type = DEFAULTS_CONFIG;
> +
> +	ret = stat(dft->config_file, &sp);
> +	if (ret) {
> +		if (dft->type != DEFAULTS_BUILTIN)
> +			fprintf(stderr, _("could not stat() config file: %s: %s\n"),
> +				dft->config_file, strerror(ret));
> +		return ret;
> +	}

This dft->type futzing can all go away - if the file exists, the
mkfs will already know where it came from.

> +
> +	if (!sp.st_size)
> +		return 0;
> +
> +	ret = mkfs_check_config_file_limits(dft->config_file, &sp,
> +					    num_subopts_sections);
> +	if (ret)
> +		return ret;
> +
> +	while (!feof(fp)) {
> +		p = fgets(line, sizeof(line), fp);

What if the line is longer than 80 characters? e.g. a long comment
In that case, we need a line[79] = '/0';, or a memset of line to
clear it before fgets is called. i think I prefer the latter...

> +		if (!p)
> +			continue;
> +
> +		parse_type = parse_get_line_type(line, tag, &value);
> +
> +		switch (parse_type) {
> +		case PARSE_COMMENT:
> +		case PARSE_INVALID:
> +		case PARSE_EOF:
> +			break;
> +		case PARSE_SECTION:
> +			section = get_config_section(tag);
> +			if (!section) {
> +				fprintf(stderr, _("Invalid section: %s\n"),
> +						tag);
> +				return -EINVAL;
> +			}
> +			break;
> +		case PARSE_TAG_VALUE:
> +			/* Trims white spaces */
> +			snprintf(line, sizeof(line), "%s=%u", tag, value);
> +			ret = parse_config_subopts(section, value, line, dft);

We've already got the tag and value as discrete variables - why put
them back into an ascii string to pass to another function for it to
split them back into discrete variables?

This really seems like it could be improved by making this less
abstract. i.e.

	while (!feof(fp)) {
		memset(line, 0, sizeof(line));
		p = fgets(line, sizeof(line), fp);
		if (!p)
			continue;

		token = parse_section(line);
		if (token) {
			opts = get_confopts(section);
			if (!opts)
				/* fail, invalid */;
			if (opts->seen)
				/* fail, respec */ ;
		}
		if (!opts)
			continue;

		token = parse_value(line, &value);
		if (!token)
			continue;
		error = opts->parse(opts, token, value);
		if (error) {
			/* warn, fail, ignore? */ ;
		}
	}

I suspect with this even all the B_SIZE type of enums can go away,
too, because all we need to do is string compares of the token
directly in the suboption parser to know what option we are about to
set....


> diff --git a/mkfs/xfs_mkfs_config.h b/mkfs/xfs_mkfs_config.h
> new file mode 100644
> index 000000000000..407d37fffb1a
> --- /dev/null
> +++ b/mkfs/xfs_mkfs_config.h
> @@ -0,0 +1,11 @@
> +#ifndef _XFS_MKFS_CONFIG_H
> +#define _XFS_MKFS_CONFIG_H
> +
> +#include "xfs_mkfs_common.h"
> +
> +#define MKFS_XFS_CONF_DIR      ROOT_SYSCONFDIR "/mkfs.xfs.d/"

This can go in the C file, as there's no need for anything other
than the file open routine to know this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
