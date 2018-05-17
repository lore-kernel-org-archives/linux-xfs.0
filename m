Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47586 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750924AbeEQVbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 May 2018 17:31:49 -0400
Date: Thu, 17 May 2018 14:31:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 5/5] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180517205845.GV23858@magnolia>
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
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

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
> 
> We define an XFS configuration directory, /etc/mkfs.xfs.d/ and allow for
> different configuration files, if none is specified we look for the
> default configuration file, /etc/mkfs.xfs.d/default. You can override
> with -c.  For instance, if you specify:
> 
> 	mkfs.xfs -c experimental -f /dev/loop0
> 
> The file /etc/mkfs.xfs.d/experimental will be used as your configuration
> file. If you really need to override the full path of the configuration
> file you may use the MKFS_XFS_CONFIG environment variable.
> 
> To verify what configuration file is used on a system use the typical:
> 
>   mkfs.xfs -N
> 
> There is only a subset of options allowed to be set on the configuration
> file, and currently only 1 or 0 are acceptable values. The default
> parameters you can override on a configuration file and their current
> built-in default settings are:
> 
> [data]
> noalign=0
> 
> [inode]
> align=1
> projid32bit=1
> sparse=0
> 
> [log]
> lazy-count=1
> 
> [metadata]
> crc=1
> finobt=1
> rmapbt=0
> reflink=0
> 
> [naming]
> ftype=1
> 
> [rtdev]
> noalign=0

Separate patch, but should there be a way to spit out the current mkfs
settings as a config file?

> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  include/builddefs.in   |   2 +
>  man/man5/mkfs.xfs.d.5  | 121 ++++++++++
>  man/man8/mkfs.xfs.8    |  26 +++
>  mkfs/Makefile          |   2 +-
>  mkfs/xfs_mkfs.c        |  47 +++-
>  mkfs/xfs_mkfs_common.h |  12 +
>  mkfs/xfs_mkfs_config.c | 591 +++++++++++++++++++++++++++++++++++++++++++++++++
>  mkfs/xfs_mkfs_config.h |  11 +
>  8 files changed, 801 insertions(+), 11 deletions(-)
>  create mode 100644 man/man5/mkfs.xfs.d.5
>  create mode 100644 mkfs/xfs_mkfs_config.c
>  create mode 100644 mkfs/xfs_mkfs_config.h
> 
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 8aac06cf90dc..e1ee9f7ba086 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -62,6 +62,7 @@ PKG_LIB_DIR	= @libdir@@libdirsuffix@
>  PKG_INC_DIR	= @includedir@/xfs
>  DK_INC_DIR	= @includedir@/disk
>  PKG_MAN_DIR	= @mandir@
> +PKG_ETC_DIR	= @sysconfdir@
>  PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
>  PKG_LOCALE_DIR	= @datadir@/locale
>  
> @@ -196,6 +197,7 @@ endif
>  
>  GCFLAGS = $(DEBUG) \
>  	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
> +	  -DROOT_SYSCONFDIR=\"$(PKG_ETC_DIR)\"  \
>  	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
>  
>  ifeq ($(ENABLE_GETTEXT),yes)
> diff --git a/man/man5/mkfs.xfs.d.5 b/man/man5/mkfs.xfs.d.5
> new file mode 100644
> index 000000000000..5424f730a2e5
> --- /dev/null
> +++ b/man/man5/mkfs.xfs.d.5
> @@ -0,0 +1,121 @@
> +.TH mkfs.xfs.d 5
> +.SH NAME
> +mkfs.xfs.d \- mkfs.xfs configuration directory
> +.SH DESCRIPTION
> +.B mkfs.xfs (8)
> +uses a set of initial default parameters for configuration. These defaults
> +are conservatively decided by the community as xfsprogs and features for XFS
> +in the kernel advance. One can override these defaults on the

I'm not sure what the sentence "These defaults...in the kernel advance."
means... is this close to what you meant?:

"The builtin mkfs defaults are decided by the XFS community.  New features
are only enabled by default when the community consider it stable."

> +.B mkfs.xfs (8)
> +command line, but there are cases where it is desirable for sensible defaults
> +to always be specified by the system where

"...where it is desirable for the distro or the system administrator to
establish their own supported defaults in a uniform manner." ?

> +.B mkfs.xfs (8)
> +runs on. This may desirable for example on systems with old kernels where the
> +built-in default parameters on
> +.B mkfs.xfs (8)
> +may not be able to create a filesystem which the old kernel supports and it

"...where the built-in default mkfs.xfs parameters create a filesystem
that is not supported by the old kernel."

> +would be unclear what parameters are needed to produce a compatible filesystem.
> +Overriding
> +.B mkfs.xfs (8)
> +built-in defaults may also be desirable if you have a series of systems with
> +different kernels and want to be able to create filesystems which all systems
> +are able to support properly.
> +.PP
> +The XFS configuration directory
> +.B mkfs.xfs.d (5)
> +can be used to define different configuration files which can be used to
> +override the built-in default parameters by
> +.B mkfs.xfs (8).
> +Different configuration files are supported, the default
> +configuration file,
> +.I /etc/mkfs.xfs.d/default

The "/etc" part of the path should be sysconfdir and replaced by the
build script to match whatever we're encoding into the mkfs.xfs binary.

> +, will be looked for first and if present will be used to override
> +.B mkfs.xfs (8)
> +built-in default parameters. You can override the configuration file by
> +specifying its name when using
> +.B mkfs.xfs (8)
> +by using the
> +.B -c
> +parameter. For example:
> +.I mkfs.xfs -c experimental -f /dev/sda1
> +will make
> +.B mkfs.xfs (8)
> +look for and use the configuration file
> +.I /etc/mkfs.xfs.d/experimental
> +to override
> +.B mkfs.xfs (8)
> +default parameters. If you need to override the full path for a configuration
> +file you can use the
> +.I MKFS_XFS_CONFIG
> +environment variable prior to calling
> +.B mkfs.xfs (8)
> +to define the
> +full path to the configuration file to be used.

Does the environment variable override -c, or the other way around?

> If you used the
> +.B -c
> +parameter or if you set the
> +.I MKFS_XFS_CONFIG
> +environment variable the configuration file must be present and should parse

"...must parse..."

> +correctly.
> +.PP
> +Parameters passed to to the

"...passed to the..."

> +.B mkfs.xfs (8)
> +command line always override any defaults set on the configuration file used.
> +.PP
> +.B mkfs.xfs (8)
> +will always describe what configuration file was used, if any
> +was used at all. To verify which configuration file would be used prior to
> +execution of
> +.B mkfs.xfs (8)
> +you can use
> +.I mkfs.xfs -N.
> +.PP
> +.SH DEFAULT PARAMETERS
> +Default parameters for
> +.B mkfs.xfs (8)
> +consists of a small subset of the parameters one can set with on the command
> +line. Currently all default parameters can only be either enabled or disabled,
> +you can set their value to 1 to enable or 0 to disable. Below we list the
> +different supported default parameters which can be defined on configuration
> +files, along with the current built-in setting.
> +.PP
> +.BI [data]
> +.br
> +.BI noalign=0
> +.PP
> +.BI [inode]
> +.br
> +.BI align=1
> +.br
> +.BI projid32bit=1
> +.br
> +.BI sparse=0
> +.PP
> +.BI [log]
> +.br
> +.BI lazy-count=1
> +.PP
> +.BI [metadata]
> +.br
> +.BI crc=1
> +.br
> +.BI finobt=1
> +.br
> +.BI rmapbt=0
> +.br
> +.BI reflink=0
> +.PP
> +.BI [naming]
> +.br
> +.BI ftype=1
> +.PP
> +.BI [rtdev]
> +.br
> +.BI noalign=0
> +.PP
> +.SH SEE ALSO
> +.BR mkfs.xfs (8),
> +.BR xfsctl (3),
> +.BR xfs_info (8),
> +.BR xfs_admin (8),
> +.BR xfsdump (8),
> +.BR xfsrestore (8).
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 4b8c78c37806..fadc4c589a8c 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -83,6 +83,26 @@ and
>  .B \-l internal \-l size=10m
>  are equivalent.
>  .PP
> +An optional XFS configuration file directory
> +.B mkfs.xfs.d (5)

%sysconfigdir%/mkfs.xfs.d ?

> +exists to help fine tune default parameters which can be used when calling
> +.B mkfs.xfs (8).
> +If present, the default file /etc/mkfs.xfs.d/default
> +will be used to override system build-in defaults. Refer to mkfs.xfs.d (5)
> +for a list of current defaults.
> +Command line arguments directly passed to
> +.B mkfs.xfs (8)
> +will always override parameters set in the configuration file.
> +You can override the configuration file used within the
> +.B mkfs.xfs.d (5)
> +directory by using the -c parameter. Alternatively
> +you can set and use the MKFS_XFS_CONFIG environment variable to override
> +the default full path of the configuration file which
> +.B mkfs.xfs (8)
> +looks for.
> +If you use -c the configuration file must be present under
> +.B mkfs.xfs.d (8).
> +.PP
>  In the descriptions below, sizes are given in sectors, bytes, blocks,
>  kilobytes, megabytes, gigabytes, etc.
>  Sizes are treated as hexadecimal if prefixed by 0x or 0X,
> @@ -123,6 +143,11 @@ Many feature options allow an optional argument of 0 or 1, to explicitly
>  disable or enable the functionality.
>  .SH OPTIONS
>  .TP
> +.BI \-c " configuration-file"
> +Override the configuration file used under the
> +.B mkfs.xfs.d
> +directory.
> +.TP
>  .BI \-b " block_size_options"
>  This option specifies the fundamental block size of the filesystem.
>  The valid
> @@ -923,6 +948,7 @@ Prints the version number and exits.
>  .SH SEE ALSO
>  .BR xfs (5),
>  .BR mkfs (8),
> +.BR mkfs.xfs.d (5),
>  .BR mount (8),
>  .BR xfs_info (8),
>  .BR xfs_admin (8).
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index c84f9b6ae63b..7906b1d4e67d 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
>  LTCOMMAND = mkfs.xfs
>  
>  HFILES =
> -CFILES = proto.c xfs_mkfs.c
> +CFILES = proto.c xfs_mkfs.c xfs_mkfs_config.c
>  
>  LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
>  	$(LIBUUID)
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index cb549be89835..aaf3f71a93cf 100644
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

FWIW all this geometry printing was refactored into libfrog.

Though, you already print where we got the configuration data, so just
print dft->config_file there.

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
> +
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
> +	tmp_config = getenv("MKFS_XFS_CONFIG");
> +	if (tmp_config != NULL) {
> +		dft.config_file = tmp_config;
> +		dft.type = DEFAULTS_ENVIRONMENT_CONFIG;
> +	}
>  
>  	process_defaults(&dft, &cli);
>  
> -	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> +	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
>  		switch (c) {
> +		case 'c':
> +			reset_defaults_and_cli(&dft, &cli);
> +
> +			memset(custom_config, 0, sizeof(custom_config));
> +			snprintf(custom_config, sizeof(custom_config), "%s%s",
> +				 MKFS_XFS_CONF_DIR, optarg);
> +			dft.config_file = custom_config;
> +			dft.type = DEFAULTS_TYPE_CONFIG;

Ok, so we parse $MKFS_XFS_CONFIG but then if the user specifies -c we
reset all that and parse that config file.

Just for fun I decided to run:

$ cat > /tmp/butts.lol
[gugugugug]
bye = 1
[metadata]
hork = 1
$ ./build-x64/mkfs/mkfs.xfs -c ../../../../../../../tmp/butts.lol -N /dev/sda
Error parsine line: bye=1

I think we need to error out on unrecognized section names:

"Unrecognized section name 'gugugugug'."

And probably report the section name for unrecognized keys:

"Unrecognized name 'metadata.hork"."

> +
> +			process_defaults(&dft, &cli);
> +
> +			break;
>  		case 'C':
>  		case 'f':
>  			force_overwrite = 1;
> @@ -3823,10 +3852,8 @@ main(
>  	} else
>  		dfile = xi.dname;
>  
> -	/*
> -	 * printf(_("Default configuration sourced from %s\n"),
> -	 *	  default_type_str(dft.type));
> -	 */
> +	printf(_("Default configuration sourced from %s\n"),
> +	       default_type_str(dft.type));
>  
>  	protostring = setup_proto(protofile);
>  
> @@ -3902,7 +3929,7 @@ main(
>  	calculate_log_size(&cfg, &cli, mp);
>  
>  	if (!quiet || dry_run) {
> -		print_mkfs_cfg(&cfg, dfile, logfile, rtfile);
> +		print_mkfs_cfg(&cfg, dfile, logfile, rtfile, &dft);
>  		if (dry_run)
>  			exit(0);
>  	}
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
>  
>  /*
> @@ -61,6 +72,7 @@ enum default_params_type {
>   */
>  struct mkfs_default_params {
>  	enum default_params_type type; /* where the defaults came from */
> +	const char *config_file;
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

That's a pretty big size considering we only allow 0 and 1...

> +#define CONFIG_MAX_BUFFER	CONFIG_MAX_KEY + CONFIG_MAX_VALUE + 3
> +
> +/*
> + * Enums for each configuration option. All these currently match the CLI
> + * parameters for now but this may change later, so we keep all this code
> + * and definitions separate. The rules for configuration parameters may also
> + * differ.
> + */

So... I think these enums should be shared between cli and config file
processing, or if the config file parser retains its own private
definitions then it should only have the options that we support in the
config file.  It's weird how things like data.sunit are specified here
but the config file doesn't actually do anything with it?

$ cat > /tmp/butts.lol
[data]
sunit = 5
$ ./build-x64/mkfs/mkfs.xfs -c ../../../tmp/butts.lol -N /dev/sda | grep sunit
         =                       sunit=0      swidth=0 blks

That really ought to error out, since we don't support setting sunit?

> +
> +enum {
> +	B_SIZE = 0,
> +	B_MAX_OPTS,
> +};
> +
> +enum {
> +	D_AGCOUNT = 0,
> +	D_FILE,
> +	D_NAME,
> +	D_SIZE,
> +	D_SUNIT,
> +	D_SWIDTH,
> +	D_AGSIZE,
> +	D_SU,
> +	D_SW,
> +	D_SECTSIZE,
> +	D_NOALIGN,
> +	D_RTINHERIT,
> +	D_PROJINHERIT,
> +	D_EXTSZINHERIT,
> +	D_COWEXTSIZE,
> +	D_MAX_OPTS,
> +};
> +
> +enum {
> +	I_ALIGN = 0,
> +	I_MAXPCT,
> +	I_PERBLOCK,
> +	I_SIZE,
> +	I_ATTR,
> +	I_PROJID32BIT,
> +	I_SPINODES,
> +	I_MAX_OPTS,
> +};
> +
> +enum {
> +	L_AGNUM = 0,
> +	L_INTERNAL,
> +	L_SIZE,
> +	L_VERSION,
> +	L_SUNIT,
> +	L_SU,
> +	L_DEV,
> +	L_SECTSIZE,
> +	L_FILE,
> +	L_NAME,
> +	L_LAZYSBCNTR,
> +	L_MAX_OPTS,
> +};
> +
> +enum {
> +	N_SIZE = 0,
> +	N_VERSION,
> +	N_FTYPE,
> +	N_MAX_OPTS,
> +};
> +
> +enum {
> +	R_EXTSIZE = 0,
> +	R_SIZE,
> +	R_DEV,
> +	R_FILE,
> +	R_NAME,
> +	R_NOALIGN,
> +	R_MAX_OPTS,
> +};
> +
> +enum {
> +	S_SIZE = 0,
> +	S_SECTSIZE,
> +	S_MAX_OPTS,
> +};
> +
> +enum {
> +	M_CRC = 0,
> +	M_FINOBT,
> +	M_UUID,
> +	M_RMAPBT,
> +	M_REFLINK,
> +	M_MAX_OPTS,
> +};
> +
> +/* Just define the max options array size manually right now */
> +#define MAX_SUBOPTS	D_MAX_OPTS
> +
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
> +
> +struct opt_params config_bopts = {
> +	.section = 'b',
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
> +
> +struct opt_params config_iopts = {
> +	.section = 'i',
> +	.subopts = {
> +		[I_ALIGN] = "align",
> +		[I_MAXPCT] = "maxpct",
> +		[I_PERBLOCK] = "perblock",
> +		[I_SIZE] = "size",
> +		[I_ATTR] = "attr",
> +		[I_PROJID32BIT] = "projid32bit",
> +		[I_SPINODES] = "sparse",
> +	},
> +};
> +
> +struct opt_params config_lopts = {
> +	.section = 'l',
> +	.subopts = {
> +		[L_AGNUM] = "agnum",
> +		[L_INTERNAL] = "internal",
> +		[L_SIZE] = "size",
> +		[L_VERSION] = "version",
> +		[L_SUNIT] = "sunit",
> +		[L_SU] = "su",
> +		[L_DEV] = "logdev",
> +		[L_SECTSIZE] = "sectsize",
> +		[L_FILE] = "file",
> +		[L_NAME] = "name",
> +		[L_LAZYSBCNTR] = "lazy-count",
> +	},
> +};
> +
> +struct opt_params config_nopts = {
> +	.section = 'n',
> +	.subopts = {
> +		[N_SIZE] = "size",
> +		[N_VERSION] = "version",
> +		[N_FTYPE] = "ftype",
> +	},
> +};
> +
> +struct opt_params config_ropts = {
> +	.section = 'r',
> +	.subopts = {
> +		[R_EXTSIZE] = "extsize",
> +		[R_SIZE] = "size",
> +		[R_DEV] = "rtdev",
> +		[R_FILE] = "file",
> +		[R_NAME] = "name",
> +		[R_NOALIGN] = "noalign",
> +	},
> +};
> +
> +struct opt_params config_sopts = {
> +	.section = 's',
> +	.subopts = {
> +		[S_SIZE] = "size",
> +		[S_SECTSIZE] = "sectsize",
> +	},
> +};
> +
> +struct opt_params config_mopts = {
> +	.section = 'm',
> +	.subopts = {
> +		[M_CRC] = "crc",
> +		[M_FINOBT] = "finobt",
> +		[M_UUID] = "uuid",
> +		[M_RMAPBT] = "rmapbt",
> +		[M_REFLINK] = "reflink",
> +	},
> +};
> +
> +const char *default_type_str(enum default_params_type type)

const char *
default_type_str(
	enum default_params_type	type)
{
	...
}

Please follow regular xfs formatting conventions.

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

"Unknown"

> +}
> +
> +static int block_config_parser(struct mkfs_default_params *dft, int subopt,
> +			       bool value)
> +{
> +	return -EINVAL;
> +}
> +
> +static int data_config_parser(struct mkfs_default_params *dft, int subopt,
> +			      bool value)
> +{
> +	switch (subopt) {
> +	case D_NOALIGN:
> +		dft->sb_feat.nodalign = value;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int inode_config_parser(struct mkfs_default_params *dft, int subopt,
> +			       bool value)
> +{
> +	switch (subopt) {
> +	case I_ALIGN:
> +		dft->sb_feat.inode_align = value;
> +		break;
> +	case I_PROJID32BIT:
> +		dft->sb_feat.projid32bit = value;
> +		break;
> +	case I_SPINODES:
> +		dft->sb_feat.spinodes = value;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int log_config_parser(struct mkfs_default_params *dft, int subopt,
> +			     bool value)
> +{
> +	switch (subopt) {
> +	case L_LAZYSBCNTR:
> +		dft->sb_feat.lazy_sb_counters = value;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int meta_config_parser(struct mkfs_default_params *dft, int subopt,
> +			      bool value)
> +{
> +	switch (subopt) {
> +	case M_CRC:
> +		dft->sb_feat.crcs_enabled = value;
> +		if (dft->sb_feat.crcs_enabled)
> +			dft->sb_feat.dirftype = true;
> +		break;
> +	case M_FINOBT:
> +		dft->sb_feat.finobt = value;
> +		break;
> +	case M_RMAPBT:
> +		dft->sb_feat.rmapbt = value;
> +		break;
> +	case M_REFLINK:
> +		dft->sb_feat.reflink = value;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int naming_config_parser(struct mkfs_default_params *dft, int subopt,
> +				bool value)
> +{
> +	switch (subopt) {
> +	case N_FTYPE:
> +		dft->sb_feat.dirftype = value;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int rtdev_config_parser(struct mkfs_default_params *dft, int subopt,
> +			       bool value)
> +{
> +	switch (subopt) {
> +	case R_NOALIGN:
> +		dft->sb_feat.nortalign = value;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int sector_config_parser(struct mkfs_default_params *dft, int subopt,
> +				bool value)
> +{
> +	return -EINVAL;
> +}
> +
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
> +
> +static enum mkfs_config_section get_config_section(const char *buffer)
> +{
> +	if (strncmp("block", buffer, 5) == 0)
> +		return MKFS_CONFIG_SECTION_BLOCK;
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
> +
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

Not sure why we care about the file size?  If the config file
respecifies options a trillion times then let it.

> +
> +	return 0;
> +}
> +
> +enum parse_line_type {
> +	PARSE_COMMENT = 0,
> +	PARSE_SECTION,
> +	PARSE_TAG_VALUE,
> +	PARSE_INVALID,
> +	PARSE_EOF,
> +};
> +
> +static int parse_line_section(const char *line, char *tag)
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
> +}
> +
> +static enum parse_line_type parse_get_line_type(const char *line, char *tag,
> +						bool *value)
> +{
> +	int ret;
> +	unsigned int uint_value;
> +
> +	memset(tag, 0, 80);
> +
> +	if (strlen(line) < 2)
> +		return PARSE_INVALID;
> +
> +	if (line[0] == '#')
> +		return PARSE_COMMENT;
> +
> +	ret = parse_line_section(line, tag);
> +	if (ret == 1)
> +		return  PARSE_SECTION;
> +
> +	if (ret == EOF)
> +		return PARSE_EOF;
> +
> +	ret = parse_line_tag_value(line, tag, &uint_value);
> +	if (ret == 2) {
> +		if (uint_value != 1 && uint_value != 0)
> +			return -EINVAL;

If I set data.sunit = 5 this will return -EINVAL to the switch in
parse_config_init.  However, the switch lacks a default clause so it
silently drops invalid values and proceeds with the format.

> +
> +		*value = !!uint_value;
> +
> +		return PARSE_TAG_VALUE;
> +	}
> +
> +	if (ret == EOF)
> +		return PARSE_EOF;
> +
> +	return PARSE_INVALID;
> +}
> +
> +int parse_config_init(struct mkfs_default_params *dft)
> +{
> +	int ret;
> +	FILE *fp;
> +	struct stat sp;
> +	unsigned int num_subopts_sections = sizeof(config_subopt_tab) /
> +					    sizeof(struct config_subopts) - 1;
> +	char *p;
> +	char line[80], tag[80];

Waitaminute, didn't we set CONFIG_MAX_KEY = 1024 and CONFIG_MAX_VALUE
to PATH_MAX?

> +	bool value;
> +	enum parse_line_type parse_type;
> +	enum mkfs_config_section section = MKFS_CONFIG_SECTION_INVALID;
> +
> +	fp = fopen(dft->config_file, "r");
> +	if (!fp) {
> +		if (dft->type != DEFAULTS_BUILTIN) {

Why would we be parsing a config file if dft->type == DEFAULTS_BUILTIN?

> +			fprintf(stderr, _("could not open config file: %s\n"),
> +				dft->config_file);
> +			ret = -ENOENT;
> +		} else
> +			ret = 0;
> +		return ret;
> +	}
> +
> +	/*
> +	 * If we found a file without it being specified on the command line,
> +	 * it would be the default configuration file.
> +	 */
> +	if (dft->type == DEFAULTS_BUILTIN)
> +		dft->type = DEFAULTS_CONFIG;

Oh, I see, type == _BUILTIN really means "we picked up
/etc/mkfs.xfs.d/defaults"... shouldn't the caller set this?

> +
> +	ret = stat(dft->config_file, &sp);

fstat(fileno(fp), &sp); ?

> +	if (ret) {
> +		if (dft->type != DEFAULTS_BUILTIN)

Didn't we just set this to _CONFIG?

> +			fprintf(stderr, _("could not stat() config file: %s: %s\n"),
> +				dft->config_file, strerror(ret));
> +		return ret;

We just leaked fp...

> +	}
> +
> +	if (!sp.st_size)
> +		return 0;

Can't we just keep going?  If the file size is zero we never execute the
loop.

> +	ret = mkfs_check_config_file_limits(dft->config_file, &sp,
> +					    num_subopts_sections);
> +	if (ret)
> +		return ret;
> +
> +	while (!feof(fp)) {
> +		p = fgets(line, sizeof(line), fp);
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

So we reconstruct the line (without the whitespaces) so that we can use
getsubopt to map the tag to an integer value (e.g. D_AGCOUNT)... we
already isolated *tag, so can't we map it directly?

> +			ret = parse_config_subopts(section, value, line, dft);
> +			if (ret) {
> +				fprintf(stderr, _("Error parsine line: %s\n"),
> +						line);
> +				return ret;
> +			}
> +			break;

case -EINVAL?

--D

> +		}
> +	}
> +
> +	return 0;
> +}
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
> +
> +const char *default_type_str(enum default_params_type type);
> +int parse_config_init(struct mkfs_default_params *dft);
> +
> +#endif /* _XFS_MKFS_CONFIG_H */
> -- 
> 2.16.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
