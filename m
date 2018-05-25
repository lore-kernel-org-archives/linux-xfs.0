Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44960 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbeEYECH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 May 2018 00:02:07 -0400
Date: Thu, 24 May 2018 21:01:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3 3/4] mkfs.xfs: add configuration file parsing support
 using our own parser
Message-ID: <20180525040143.GR14384@magnolia>
References: <20180525031943.29440-1-mcgrof@kernel.org>
 <20180525031943.29440-4-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525031943.29440-4-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 24, 2018 at 08:19:42PM -0700, Luis R. Rodriguez wrote:
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
> The search path for the configuration file will be:
> 
> 	1) $PWD/experimental
> 	2) /etc/mkfs.xfs.d/experimental
> 
> Absolute paths are supported, in which case they will be used directly
> and the mkfs.xfs.d directory is ignored.
> 
> To verify what configuration file is used on a system use the typical:
> 
>   mkfs.xfs -N
> 
> There is only a subset of options allowed to be set on the configuration
> file. The default parameters you can override on a configuration file and
> their current built-in default settings are:
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
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---
>  configure.ac                           |   6 +-
>  include/builddefs.in                   |   2 +
>  man/man5/Makefile                      |   2 +
>  man/man5/mkfs.xfs.d.5.in               | 153 ++++++++
>  man/man8/Makefile                      |   2 +
>  man/man8/{mkfs.xfs.8 => mkfs.xfs.8.in} |  27 ++
>  mkfs/Makefile                          |   2 +-
>  mkfs/config.c                          | 644 +++++++++++++++++++++++++++++++++
>  mkfs/config.h                          |  10 +-
>  mkfs/xfs_mkfs.c                        |  76 +++-
>  10 files changed, 910 insertions(+), 14 deletions(-)
>  create mode 100644 man/man5/mkfs.xfs.d.5.in
>  rename man/man8/{mkfs.xfs.8 => mkfs.xfs.8.in} (96%)
>  create mode 100644 mkfs/config.c
> 
> diff --git a/configure.ac b/configure.ac
> index 508eefede073..94c5bda725f2 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -233,5 +233,9 @@ AC_CHECK_SIZEOF([char *])
>  AC_TYPE_UMODE_T
>  AC_MANUAL_FORMAT
>  
> -AC_CONFIG_FILES([include/builddefs])
> +AC_CONFIG_FILES([
> +	include/builddefs
> +	man/man5/mkfs.xfs.d.5
> +	man/man8/mkfs.xfs.8

Building the manpages as part of configure?  That's clever. :)

> +])
>  AC_OUTPUT
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
> diff --git a/man/man5/Makefile b/man/man5/Makefile
> index fe0aef6f016b..0b33122b064e 100644
> --- a/man/man5/Makefile
> +++ b/man/man5/Makefile
> @@ -19,3 +19,5 @@ install : default
>  	$(INSTALL) -m 755 -d $(MAN_DEST)
>  	$(INSTALL_MAN)
>  install-dev :
> +
> +LDIRT += mkfs.xfs.d.5
> diff --git a/man/man5/mkfs.xfs.d.5.in b/man/man5/mkfs.xfs.d.5.in
> new file mode 100644
> index 000000000000..c8dac58f5c9d
> --- /dev/null
> +++ b/man/man5/mkfs.xfs.d.5.in
> @@ -0,0 +1,153 @@
> +.TH mkfs.xfs.d 5
> +.SH NAME
> +mkfs.xfs.d \- mkfs.xfs configuration directory
> +.SH DESCRIPTION
> +.B mkfs.xfs (8)
> +uses a set of initial default parameters for configuration.
> +
> +The built-in mkfs defaults are decided by the XFS community. New features are
> +only enabled by default when the community consider it stable.  One can

"...consider them stable."

> +override these defaults on the
> +.B mkfs.xfs (8)
> +command line, but there are cases where it is desirable for the distro or the
> +system administrator to establish their own supported defaults in a uniform
> +manner, regardless of the version of
> +.B mkfs.xfs (8)
> +used. This may desirable for example on systems with old kernels

"This may be desirable..."

> +where the built-in default
> +.B mkfs.xfs (8)
> +parameters create a filesystem that is not supported by the old kernel.
> +In such situations it would also be unclear what parameters are needed to
> +produce a compatible filesystem, having a configuration file present ensures
> +that if newer versions of
> +.B mkfs.xfs (8)
> +are deployed, creating a filesystem will remain compatible. Overriding
> +.B mkfs.xfs (8)
> +built-in defaults may also be desirable if you have a series of systems with
> +different kernels and want to be able to create filesystems which all systems
> +are able to support properly.
> +.PP
> +The XFS configuration directory
> +.B mkfs.xfs.d (5)
> +can be used as a home to define different configuration files which can be used
> +to override the built-in default parameters by
> +.B mkfs.xfs (8).
> +If the
> +.B -c
> +parameter is not used, the default configuration file:
> +.IP
> +.I @sysconfdir@/mkfs.xfs.d/default
> +.PP
> +will be looked for first and if present will be used to override
> +.B mkfs.xfs (8)
> +built-in default parameters.
> +.PP
> +You can override the configuration file by specifying its name when using

"...override the default configuration file...", right?

> +.B mkfs.xfs (8)
> +by using the
> +.B -c
> +parameter.
> +.PP
> +If a relative path without the special character '.' is passed,

"If the path does not start with a '.', the current working directory is
searched for the file.  If the file is not found there, the mkfs.xfs.d(5)
directory is searched for the file." ?

> +the configuration file is first looked for in you current working directory;
> +if the configuration file is not present in your current working directory
> +the configuration file with the name given is looked in the
> +.B mkfs.xfs.d (5)
> +directory.
> +.PP
> +If
> +.B -c
> +is used with relative path with which has a leading '.' character, the given
> +path is used directly, so the configuration file will be relative to your
> +current directory.

"...relative to the current working directory."

(Trying to be consistent with 'current working directory'.)

> +.PP
> +If
> +.B -c
> +is used with an absolute path -- a path with a leading '/' character --
> +then the absolute path given is used for the configuration file.

"If the -c argument starts with a '/', it is considered an absolute
path, and opened." ?

(dunno about that...)

> +.PP
> +For example:
> +.IP
> +.B mkfs.xfs -c experimental -f /dev/sda1
> +.PP
> +Will make
> +.B mkfs.xfs (8)
> +look for the following configuration files and use the first one it finds:
> +.IP
> +.B $PWD/experimental
> +.br
> +.B @sysconfdir@/mkfs.xfs.d/experimental
> +.PP
> +If you used an absolute path, for example:
> +.IP
> +.B mkfs.xfs -c /tmp/experimental -f /dev/sda1
> +.PP
> +Then only the configuration file /tmp/experimental will be looked for and
> +used if present.
> +.PP
> +If you use the
> +.B -c
> +parameter the configuration file must be present and must parse correctly.
> +.PP
> +Parameters passed to the
> +.B mkfs.xfs (8)
> +command line always override any defaults set on the configuration file used.

"...set by the configuration file."

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

We ought to have a comment in the same place that we define the builtin
defaults warning would-be patch authors to ensure that they update this
manpage.

> +.PP
> +.SH SEE ALSO
> +.BR mkfs.xfs (8),
> +.BR xfsctl (3),
> +.BR xfs_info (8),
> +.BR xfs_admin (8),
> +.BR xfsdump (8),
> +.BR xfsrestore (8).
> diff --git a/man/man8/Makefile b/man/man8/Makefile
> index 36620da172ae..2a6548079997 100644
> --- a/man/man8/Makefile
> +++ b/man/man8/Makefile
> @@ -19,3 +19,5 @@ install : default
>  	$(INSTALL) -m 755 -d $(MAN_DEST)
>  	$(INSTALL_MAN)
>  install-dev :
> +
> +LDIRT += mkfs.xfs.8
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8.in
> similarity index 96%
> rename from man/man8/mkfs.xfs.8
> rename to man/man8/mkfs.xfs.8.in
> index 4b8c78c37806..81e2753bd2b5 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8.in
> @@ -83,6 +83,24 @@ and
>  .B \-l internal \-l size=10m
>  are equivalent.
>  .PP
> +An optional XFS configuration file directory
> +.B mkfs.xfs.d (5)
> +exists to help fine tune different default parameters which can be used when
> +calling
> +.B mkfs.xfs (8).
> +If present, and if
> +.B -c
> +is not used, the default configuration file @sysconfigdir@/mkfs.xfs.d/default
> +will be used to override system build-in defaults. Refer to mkfs.xfs.d (5)
> +for a list of current defaults and further details.
> +Command line arguments directly passed to
> +.B mkfs.xfs (8)
> +will always override parameters set in the configuration file.
> +You can override the configuration file used by using the
> +.B -c
> +parameter, further explained below and in
> +.B mkfs.xfs.d (5)
> +.PP
>  In the descriptions below, sizes are given in sectors, bytes, blocks,
>  kilobytes, megabytes, gigabytes, etc.
>  Sizes are treated as hexadecimal if prefixed by 0x or 0X,
> @@ -123,6 +141,14 @@ Many feature options allow an optional argument of 0 or 1, to explicitly
>  disable or enable the functionality.
>  .SH OPTIONS
>  .TP
> +.BI \-c " configuration-file"
> +Override the configuration file used. If a relative path is given the search
> +path for the configuration file is your current directory and then the
> +.B mkfs.xfs.d (5)
> +directory. If an absolute path is given it is used directly. For more details
> +refer to
> +.B mkfs.xfs.d (5)
> +.TP
>  .BI \-b " block_size_options"
>  This option specifies the fundamental block size of the filesystem.
>  The valid
> @@ -923,6 +949,7 @@ Prints the version number and exits.
>  .SH SEE ALSO
>  .BR xfs (5),
>  .BR mkfs (8),
> +.BR mkfs.xfs.d (5),
>  .BR mount (8),
>  .BR xfs_info (8),
>  .BR xfs_admin (8).
> diff --git a/mkfs/Makefile b/mkfs/Makefile
> index c84f9b6ae63b..c7815b3e106b 100644
> --- a/mkfs/Makefile
> +++ b/mkfs/Makefile
> @@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
>  LTCOMMAND = mkfs.xfs
>  
>  HFILES =
> -CFILES = proto.c xfs_mkfs.c
> +CFILES = proto.c xfs_mkfs.c config.c
>  
>  LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
>  	$(LIBUUID)
> diff --git a/mkfs/config.c b/mkfs/config.c
> new file mode 100644
> index 000000000000..2d21728b7b62
> --- /dev/null
> +++ b/mkfs/config.c
> @@ -0,0 +1,644 @@
> +/*
> + * Copyright (c) 2018 Luis R. Rodriguez <mcgrof@kernel.org>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +
> +#include <ctype.h>
> +#include <dirent.h>
> +#include <fcntl.h>
> +
> +#include "libxfs.h"
> +#include "config.h"
> +
> +/*
> + * Enums for each configuration option. All these currently match the CLI
> + * parameters for now but this may change later, so we keep all this code
> + * and definitions separate. The rules for configuration parameters may also
> + * differ.
> + *
> + * We only provide definitions for what we currently support parsing.
> + */
> +
> +enum data_subopts {
> +	D_NOALIGN = 0,
> +};
> +
> +enum inode_subopts {
> +	I_ALIGN = 0,
> +	I_PROJID32BIT,
> +	I_SPINODES,
> +};
> +
> +enum log_subopts {
> +	L_LAZYSBCNTR = 0,
> +};
> +
> +enum metadata_subopts {
> +	M_CRC = 0,
> +	M_FINOBT,
> +	M_RMAPBT,
> +	M_REFLINK,
> +};
> +
> +enum naming_subopts {
> +	N_FTYPE = 0,
> +};
> +
> +enum rtdev_subopts {
> +	R_NOALIGN = 0,
> +};
> +
> +/* Just define the max options array size manually right now */
> +#define MAX_SUBOPTS	4
> +
> +static int
> +data_config_parser(
> +	struct mkfs_default_params	*dft,
> +	int				psubopt,
> +	uint64_t			value)
> +{
> +	enum data_subopts	subopt = psubopt;
> +
> +	switch (subopt) {
> +	case D_NOALIGN:
> +		dft->sb_feat.nodalign = value;
> +		return 0;
> +	}
> +	return EINVAL;
> +}
> +
> +static int
> +inode_config_parser(
> +	struct mkfs_default_params	*dft,
> +	int				psubopt,
> +	uint64_t			value)
> +{
> +	enum inode_subopts	subopt = psubopt;
> +
> +	switch (subopt) {
> +	case I_ALIGN:
> +		dft->sb_feat.inode_align = value;
> +		return 0;
> +	case I_PROJID32BIT:
> +		dft->sb_feat.projid32bit = value;
> +		return 0;
> +	case I_SPINODES:
> +		dft->sb_feat.spinodes = value;
> +		return 0;
> +	}
> +	return EINVAL;
> +}
> +
> +static int
> +log_config_parser(
> +	struct mkfs_default_params	*dft,
> +	int				psubopt,
> +	uint64_t			value)
> +{
> +	enum log_subopts	subopt = psubopt;
> +
> +	switch (subopt) {
> +	case L_LAZYSBCNTR:
> +		dft->sb_feat.lazy_sb_counters = value;
> +		return 0;
> +	}
> +	return EINVAL;
> +}
> +
> +static int
> +metadata_config_parser(
> +	struct mkfs_default_params	*dft,
> +	int				psubopt,
> +	uint64_t			value)
> +{
> +	enum metadata_subopts	subopt = psubopt;
> +
> +	switch (subopt) {
> +	case M_CRC:
> +		dft->sb_feat.crcs_enabled = value;
> +		if (dft->sb_feat.crcs_enabled)
> +			dft->sb_feat.dirftype = true;
> +		return 0;
> +	case M_FINOBT:
> +		dft->sb_feat.finobt = value;
> +		return 0;
> +	case M_RMAPBT:
> +		dft->sb_feat.rmapbt = value;
> +		return 0;
> +	case M_REFLINK:
> +		dft->sb_feat.reflink = value;
> +		return 0;
> +	}
> +	return EINVAL;
> +}
> +
> +static int
> +naming_config_parser(
> +	struct mkfs_default_params	*dft,
> +	int				psubopt,
> +	uint64_t			value)
> +{
> +	enum naming_subopts	subopt = psubopt;
> +
> +	switch (subopt) {
> +	case N_FTYPE:
> +		dft->sb_feat.dirftype = value;
> +		return 0;
> +	}
> +	return EINVAL;
> +}
> +
> +static int
> +rtdev_config_parser(
> +	struct mkfs_default_params	*dft,
> +	int				psubopt,
> +	uint64_t			value)
> +{
> +	enum rtdev_subopts	subopt = psubopt;
> +
> +	switch (subopt) {
> +	case R_NOALIGN:
> +		dft->sb_feat.nortalign = value;
> +		return 0;
> +	}
> +	return EINVAL;
> +}
> +
> +struct confopts {
> +	const char		*name;
> +	const char		*subopts[MAX_SUBOPTS];
> +	int			(*parser)(struct mkfs_default_params *dft,
> +					  int psubopt, uint64_t value);
> +	bool			seen;
> +} confopts_tab[] = {
> +	{
> +		.name = "data",
> +		.subopts = {
> +			[D_NOALIGN] = "noalign",
> +		},
> +		.parser = data_config_parser,
> +	},
> +	{
> +		.name = "inode",
> +		.subopts = {
> +			[I_ALIGN] = "align",
> +			[I_PROJID32BIT] = "projid32bit",
> +			[I_SPINODES] = "sparse",
> +		},
> +		.parser = inode_config_parser,
> +	},
> +	{
> +		.name = "log",
> +		.subopts = {
> +			[L_LAZYSBCNTR] = "lazy-count",
> +		},
> +		.parser = log_config_parser,
> +	},
> +	{
> +		.name = "naming",
> +		.subopts = {
> +			[N_FTYPE] = "ftype",
> +		},
> +		.parser = naming_config_parser,
> +	},
> +	{
> +		.name = "rtdev",
> +		.subopts = {
> +			[R_NOALIGN] = "noalign",
> +		},
> +		.parser = rtdev_config_parser,
> +	},
> +	{
> +		.name = "metadata",
> +		.subopts = {
> +			[M_CRC] = "crc",
> +			[M_FINOBT] = "finobt",
> +			[M_RMAPBT] = "rmapbt",
> +			[M_REFLINK] = "reflink",
> +		},
> +		.parser = metadata_config_parser,
> +	},
> +};
> +
> +static struct confopts *
> +get_confopts(
> +	const char	*section)
> +{
> +	unsigned int	i;
> +	struct confopts	*opts;
> +
> +	for (i=0; i < ARRAY_SIZE(confopts_tab); i++) {
> +		opts = &confopts_tab[i];
> +		if (!opts)
> +			return NULL;
> +		if (strcmp(opts->name, section) == 0) {
> +			if (opts->seen) {
> +				fprintf(stderr, _("Section '%s' respecified\n"),
> +						section);

If I have two [data] sections, will this resuilt in:

# mkfs.xfs -c foo /dev/sda1
Section 'data' respecified
Invalid section on line foo:1 [data]

?

The section isn't invalid, it's just double-specified, so...

> +				return NULL;
> +			}
> +			opts->seen = true;
> +			return opts;
> +		}
> +	}

...I'd print the 'Invalid section' error message here.

> +	return NULL;
> +}
> +
> +enum parse_line_type {
> +	PARSE_COMMENT = 0,
> +	PARSE_EMPTY,
> +	PARSE_SECTION,
> +	PARSE_TAG_VALUE,
> +	PARSE_INVALID,
> +	PARSE_EOF,
> +};
> +
> +static bool
> +isempty(
> +	const char	*line,
> +	ssize_t		linelen)
> +{
> +	ssize_t		i = 0;
> +	char		p;
> +
> +	while (i != linelen) {
> +		p = line[i];
> +		i++;
> +
> +		/* tab or space */
> +		if (isblank(p))
> +			continue;
> +		else
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
> +static bool
> +iscomment(
> +	const char	*line,
> +	ssize_t		linelen)
> +{
> +	ssize_t		i = 0;
> +	char		p;
> +
> +	while (i != linelen) {
> +		p = line[i];
> +		i++;
> +
> +		/* tab or space */
> +		if (isblank(p))
> +			continue;
> +
> +		if (p == '#')
> +			return true;
> +
> +		return false;
> +	}
> +
> +	return false;
> +}
> +
> +static int
> +parse_line_section(
> +	const char	*line,
> +	char		**tag)
> +{
> +	return sscanf(line, " [%m[^]]]", tag);
> +}
> +
> +static int
> +parse_line_tag_value(
> +	const char	*line,
> +	char		**tag,
> +	uint64_t	*value)
> +{
> +	return sscanf(line, " %m[^ \t=]"
> +		      " = "
> +		      "%lu ",
> +		      tag, value);
> +}
> +
> +static enum parse_line_type
> +parse_get_line_type(
> +	const char	*line,
> +	ssize_t		linelen,
> +	char		**tag,
> +	uint64_t	*value)
> +{
> +	int		ret;
> +	uint64_t	u64_value;
> +
> +	if (isempty(line, linelen))
> +		return PARSE_EMPTY;
> +
> +	if (iscomment(line, linelen))
> +		return PARSE_COMMENT;
> +
> +	ret = parse_line_section(line, tag);
> +	if (ret == 1)
> +		return  PARSE_SECTION;
> +
> +	if (ret == EOF)
> +		return PARSE_EOF;
> +
> +	ret = parse_line_tag_value(line, tag, &u64_value);
> +	if (ret == 2) {
> +		*value = u64_value;
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
> +static int
> +parse_config_stream(
> +	struct mkfs_default_params	*dft,
> +	const char 			*config_file,
> +	FILE				*fp)
> +{
> +	int				ret;
> +	char				*line = NULL;
> +	ssize_t				linelen;
> +	size_t				len = 0, lineno = 0;
> +	uint64_t			value;
> +	enum parse_line_type		parse_type;
> +	struct confopts			*confopt = NULL;
> +	int				subopt;
> +
> +	while ((linelen = getline(&line, &len, fp)) != -1) {
> +		char *ignore_value;
> +		char *p, *tag = NULL;
> +
> +		lineno++;
> +
> +		/*
> +		 * tag is allocated for us by scanf(), it must freed only on any
> +		 * successful parse of a section or tag-value pair.
> +		 */
> +		parse_type = parse_get_line_type(line, linelen, &tag, &value);
> +
> +		switch (parse_type) {
> +		case PARSE_EMPTY:
> +		case PARSE_COMMENT:
> +			/* Nothing tag to free for these */
> +			continue;
> +		case PARSE_EOF:
> +			break;
> +		case PARSE_INVALID:
> +			ret = EINVAL;
> +			fprintf(stderr, _("Invalid line %s:%zu : %s\n"),
> +					  config_file, lineno, line);
> +			goto out;
> +		case PARSE_SECTION:
> +			confopt = get_confopts(tag);
> +			if (!confopt) {
> +				ret = EINVAL;
> +				fprintf(stderr, _("Invalid section on line %s:%zu : %s\n"),
> +						config_file, lineno, tag);
> +				free(tag);
> +				goto out;
> +			}
> +			if (!confopt->subopts) {
> +				ret = EINVAL;
> +				fprintf(stderr, _("Section not yet supported on line %s:%zu : %s\n"),
> +						config_file, lineno, tag);
> +				free(tag);
> +				goto out;
> +			}
> +			free(tag);
> +			break;
> +		case PARSE_TAG_VALUE:
> +			if (!confopt) {
> +				ret = EINVAL;
> +				fprintf(stderr, _("No section specified yet on line %s:%zu : %s\n"),
> +						config_file, lineno, line);
> +				free(tag);
> +				goto out;
> +			}
> +
> +			/*
> +			 * We re-use the line buffer allocated by getline(),
> +			 * however line must be kept pointing to its original
> +			 * value to free it later. A separate pointer is needed
> +			 * as getsubopt() will otherwise muck with the value
> +			 * passed.
> +			 */
> +			p = line;
> +
> +			/*
> +			 * Trims white spaces. getsubopt() does not grok
> +			 * white space, it would fail otherwise.
> +			 */
> +			snprintf(p, len, "%s=%lu", tag, value);
> +
> +			/* Not needed anymore */
> +			free(tag);
> +
> +			/*
> +			 * We only use getsubopt() to validate the possible
> +			 * subopt, we already parsed the value and its already
> +			 * in a more preferred data type.
> +			 */
> +			subopt = getsubopt(&p, (char **) confopt->subopts,
> +					   &ignore_value);
> +
> +			ret = confopt->parser(dft, subopt, value);
> +			if (ret) {
> +				fprintf(stderr, _("Error parsine line %s:%zu : %s\n"),
> +						config_file, lineno, line);
> +				goto out;
> +			}
> +
> +			break;
> +		}
> +	}
> +out:
> +	/* We must free even if getline() failed */
> +	free(line);
> +	return ret;
> +}
> +
> +static const char *conf_paths[] = {
> +	".",
> +	MKFS_XFS_CONF_DIR,
> +};
> +
> +/*
> + * If the file is not found -1 is returned and errno set. Otherwise
> + * the file descriptor is returned.
> + */
> +int
> +open_cli_config(
> +	char			*cli_config_file,
> +	char			**fpath)
> +{
> +	int			fd, len;
> +	char			*final_path = NULL;
> +	char			*relative_path= NULL;
> +	unsigned int		i;
> +
> +	if (strlen(cli_config_file) > 2) {
> +		if (cli_config_file[0] == '.' && cli_config_file[1] == '/')
> +			final_path = cli_config_file;
> +		else if (cli_config_file[0] == '.' && cli_config_file[1] == '.')
> +			final_path = cli_config_file;
> +		else if (cli_config_file[0] == '/')
> +			final_path = cli_config_file;
> +		else
> +			relative_path = cli_config_file;
> +	} else if (strlen(cli_config_file) == 1) {
> +		if (cli_config_file[0] == '.' || cli_config_file[0] == '/') {
> +			errno = EINVAL;
> +			return -1;
> +		} else
> +			relative_path = cli_config_file;
> +	}
> +
> +	if (final_path) {
> +		fd = open(final_path, O_RDONLY);
> +		if (fd >= 0)
> +			memcpy(*fpath, final_path, strlen(final_path));
> +		return fd;
> +	}
> +
> +	/* We finally know the path is relative but just to be sure */
> +	if (!relative_path) {
> +		errno = ENXIO;
> +		return -1;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(conf_paths); i++) {
> +		memset(*fpath, 0, PATH_MAX);
> +		/*
> +		 * For current directory evaluation, skip concatenating the
> +		 * ./ from the file passed. We only concatenate for the other
> +		 * paths we look up on.

If conf_paths[0] was "./" then you wouldn't have to special case this,
I think.

> +		 */
> +		if (i == 0)
> +			memcpy(*fpath, relative_path, strlen(relative_path));
> +		else {
> +			len = snprintf(*fpath, PATH_MAX, "%s/%s", conf_paths[i],
> +				       relative_path);
> +			/* Indicates truncation */
> +			if (len >= PATH_MAX) {
> +				errno = ENAMETOOLONG;
> +				return -1;
> +			}
> +		}
> +		fd = open(*fpath, O_RDONLY);
> +		if (fd < 0)
> +			continue;
> +		return fd;
> +	}
> +
> +	errno = ENOENT;
> +	return -1;
> +}
> +
> +/*
> + * This is only called *iff* there is a configuration file which we know we
> + * *must* parse.
> + *
> + * If default_fd is set and is a valid file descriptor then the configuration
> + * file passed is the system default configuraiton file, and we already know
> + * it exists. If default_fd is not set we assume we've been passed a
> + * configuration file from the command line and must it must exist, otherwise
> + * we have to error out.
> + */
> +int
> +parse_defaults_file(
> +	struct mkfs_default_params		*dft,
> +	int					default_fd,
> +	char					*config_file)
> +{
> +	char			*fpath;
> +	int			fd;
> +	FILE			*fp;
> +	int			ret;
> +	struct stat		sp;
> +
> +	if (strlen(config_file) > PATH_MAX)
> +		return ENAMETOOLONG;
> +
> +	fpath = malloc(PATH_MAX);
> +	if (!fpath)
> +		return ENOMEM;
> +	memset(fpath, 0, PATH_MAX);
> +
> +	if (default_fd < 0) {
> +		fd = open_cli_config(config_file, &fpath);
> +		if (fd < 0) {
> +			free(fpath);
> +			return errno;
> +		}
> +	} else {
> +		fd = default_fd;
> +		memcpy(fpath, config_file, strlen(config_file));
> +	}
> +
> +	/*
> +	 * At this point we know we have a valid file descriptor and have
> +	 * figured out the path to the file used on fpath. Get the file stream
> +	 * and do a bit of sanity checks before parsing the file.
> +	 */
> +
> +	fp = fdopen(fd, "r");
> +	if (!fp) {
> +		ret = errno;
> +		fprintf(stderr, _("Unable to open stream for config file: %s : %s\n"),
> +				fpath, strerror(errno));

perror(fpath); ?

> +		goto out_close_fd;
> +	}
> +
> +	ret = fstat(fd, &sp);
> +	if (ret) {
> +		ret = errno;
> +		fprintf(stderr, _("Could not fstat() config file: %s: %s\n"),
> +			fpath, strerror(errno));
> +		goto out;
> +	}
> +
> +	if (S_ISDIR(sp.st_mode)) {
> +		ret = EBADF;
> +		fprintf(stderr, _("Config file is a directory: %s\n"), fpath);
> +		goto out;
> +	}
> +
> +	/* Anything beyond 1 MiB is kind of silly right now */
> +	if (sp.st_size > 1 * 1024 * 1024) {
> +		ret = E2BIG;
> +		goto out;
> +	}
> +
> +	ret = parse_config_stream(dft, config_file, fp);
> +	if (ret)
> +		goto out;
> +
> +	printf(_("config-file=%s\n"), fpath);
> +
> +out:
> +	fclose(fp);
> +out_close_fd:
> +	close(fd);
> +	free(fpath);
> +	return ret;
> +}
> diff --git a/mkfs/config.h b/mkfs/config.h
> index e5ea968e2d65..0f429d9b7fd7 100644
> --- a/mkfs/config.h
> +++ b/mkfs/config.h
> @@ -19,6 +19,8 @@
>  #ifndef _XFS_MKFS_CONFIG_H
>  #define _XFS_MKFS_CONFIG_H
>  
> +#define MKFS_XFS_CONF_DIR      ROOT_SYSCONFDIR "/mkfs.xfs.d"
> +
>  struct fsxattr;
>  
>  /*
> @@ -29,7 +31,7 @@ struct fsxattr;
>   * source can overriding the later source:
>   *
>   * 	o built-in defaults
> - * 	o configuration file (XXX)
> + * 	o configuration file
>   * 	o command line
>   *
>   * These values are not used directly - they are inputs into the mkfs geometry
> @@ -75,4 +77,10 @@ struct mkfs_default_params {
>  	struct fsxattr		fsx;
>  };
>  
> +int
> +parse_defaults_file(
> +	struct mkfs_default_params	*dft,
> +	int				default_fd,
> +	char				*config_file);
> +
>  #endif /* _XFS_MKFS_CONFIG_H */
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 217bb972538d..f759e6078ca1 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3777,6 +3777,11 @@ main(
>  			.nortalign = false,
>  		},
>  	};
> +	char                    *default_config = MKFS_XFS_CONF_DIR "/default";
> +	char			*cli_config_file = NULL;
> +	char			*config_file = NULL;
> +	int			default_fd = -1;
> +	int			ret;
>  
>  	platform_uuid_generate(&cli.uuid);
>  	progname = basename(argv[0]);
> @@ -3785,25 +3790,74 @@ main(
>  	textdomain(PACKAGE);
>  
>  	/*
> -	 * TODO: Sourcing defaults from a config file
> -	 *
>  	 * Before anything else, see if there's a config file with different
> -	 * defaults. If a file exists in <package location>, read in the new
> -	 * default values and overwrite them in the &dft structure. This way the
> -	 * new defaults will apply before we parse the CLI, and the CLI will
> -	 * still be able to override them. When more than one source is
> -	 * implemented, emit a message to indicate where the defaults being
> -	 * used came from.
> +	 * defaults. If the CLI specified a full path we use and require that.
> +	 * If a relative path was provided on the CLI we search the allowed
> +	 * search paths for the file. If no config file was specified on the
> +	 * CLI we will look for MKFS_XFS_CONF_DIR/default and use that if
> +	 * present, however this file is optional.
>  	 *
> -	 * printf(_("Default configuration sourced from %s\n"), dft.source);
> +	 * If a configuration file is found we use it to help overwrite default
> +	 * values in the &dft structure. This way the new defaults will apply
> +	 * before we parse the CLI, and the user will still be able to override
> +	 * them through the CLI.
> +	 */
> +
> +	/*
> +	 * Pull config line options from command line
>  	 */
> +	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> +		switch (c) {
> +		case 'c':
> +			if (cli_config_file) {
> +				fprintf(stderr, _("respecification of configuration not allowed\n"));
> +				exit(1);
> +			}
> +			cli_config_file = optarg;
> +			dft.source = _("command line");
> +			break;
> +		default:
> +			continue;
> +		}
> +	}
> +
> +	if (cli_config_file)
> +		config_file = cli_config_file;
> +	else {
> +		default_fd = open(default_config, O_RDONLY);
> +		if (default_fd >= 0) {
> +			dft.source = _("system default configuration file");
> +			config_file = default_config;
> +		}
> +	}
> +
> +	if (config_file) {
> +		/* If default_fd is set it will be closed for us */
> +		ret = parse_defaults_file(&dft, default_fd, config_file);
> +		if (ret) {
> +			fprintf(stderr, _("Could not open %s config file: %s : %s\n"),
> +					dft.source, config_file,
> +					strerror(ret));
> +			exit(1);
> +		}
> +	}
>  
> -	/* copy new defaults into CLI parsing structure */
> +	printf(_("Default configuration sourced from %s\n"), dft.source);
> +
> +	/*
> +	 * Done parsing defaults now, so memcpy defaults into CLI
> +	 * structure, reset getopt and start parsing CLI options
> +	 */
>  	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
>  	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
>  
> -	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
> +	platform_getoptreset();
> +
> +	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
>  		switch (c) {
> +		case 'c':
> +			/* already validated and parsed, ignore */
> +			break;

Looks good otherwise.

--D

>  		case 'C':
>  		case 'f':
>  			force_overwrite = 1;
> -- 
> 2.16.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
