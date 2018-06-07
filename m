Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752260AbeFGXzh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 19:55:37 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH v5 4/4] mkfs.xfs: add configuration file parsing support using our own parser
Date: Thu,  7 Jun 2018 16:55:33 -0700
Message-Id: <20180607235533.20391-5-mcgrof@kernel.org>
In-Reply-To: <20180607235533.20391-1-mcgrof@kernel.org>
References: <20180607235533.20391-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

You may want to stick to specific set of configuration options when
creating filesystems with mkfs.xfs -- sometimes due to pure technical
reasons, but some other times to ensure systems remain compatible as
new features are introduced with older kernels, or if you always want
to take advantage of some new feature which would otherwise typically
be disruptive.

This adds support for parsing a configuration file to override defaults
parameters to be used for mkfs.xfs.

We define an XFS configuration directory, /etc/xfs/mkfs/ and allow for
different configuration files, if none is specified we look for the
default configuration file, /etc/xfs/mkfs/default. You can override
with -c.  For instance, if you specify:

	mkfs.xfs -c experimental -f /dev/loop0

The search path for the configuration file will be:

	1) $PWD/experimental
	2) /etc/xfs/mkfs/experimental

Absolute paths are supported, in which case they will be used directly
and the /etc/xfs/mkfs/ directory is ignored.

To verify what configuration file is used on a system use the typical:

  mkfs.xfs -N

There is only a subset of options allowed to be set on the configuration
file. The default parameters you can override on a configuration file and
their current built-in default settings are:

[data]
noalign=0

[inode]
align=1
projid32bit=1
sparse=0

[log]
lazy-count=1

[metadata]
crc=1
finobt=1
rmapbt=0
reflink=0

[naming]
ftype=1

[rtdev]
noalign=0

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 configure.ac         |   1 +
 include/builddefs.in |   2 +
 mkfs/Makefile        |   2 +-
 mkfs/config.c        | 664 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mkfs/config.h        |  25 +-
 mkfs/xfs_mkfs.c      |  71 +++++-
 6 files changed, 751 insertions(+), 14 deletions(-)
 create mode 100644 mkfs/config.c

diff --git a/configure.ac b/configure.ac
index 508eefede073..64bf41aef00c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -5,6 +5,7 @@ AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_SRCDIR([include/libxfs.h])
 AC_CONFIG_HEADER(include/platform_defs.h)
 AC_PREFIX_DEFAULT(/usr)
+test "$sysconfdir" = '${prefix}/etc' && sysconfdir=/etc
 
 AC_PROG_INSTALL
 AC_PROG_LIBTOOL
diff --git a/include/builddefs.in b/include/builddefs.in
index 8aac06cf90dc..e1ee9f7ba086 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -62,6 +62,7 @@ PKG_LIB_DIR	= @libdir@@libdirsuffix@
 PKG_INC_DIR	= @includedir@/xfs
 DK_INC_DIR	= @includedir@/disk
 PKG_MAN_DIR	= @mandir@
+PKG_ETC_DIR	= @sysconfdir@
 PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
 PKG_LOCALE_DIR	= @datadir@/locale
 
@@ -196,6 +197,7 @@ endif
 
 GCFLAGS = $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
+	  -DROOT_SYSCONFDIR=\"$(PKG_ETC_DIR)\"  \
 	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
 
 ifeq ($(ENABLE_GETTEXT),yes)
diff --git a/mkfs/Makefile b/mkfs/Makefile
index c84f9b6ae63b..c7815b3e106b 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 LTCOMMAND = mkfs.xfs
 
 HFILES =
-CFILES = proto.c xfs_mkfs.c
+CFILES = proto.c xfs_mkfs.c config.c
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
 	$(LIBUUID)
diff --git a/mkfs/config.c b/mkfs/config.c
new file mode 100644
index 000000000000..c5c991054ff7
--- /dev/null
+++ b/mkfs/config.c
@@ -0,0 +1,664 @@
+/*
+ * Copyright (c) 2018 Luis R. Rodriguez <mcgrof@kernel.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#include <ctype.h>
+#include <dirent.h>
+#include <fcntl.h>
+
+#include "libxfs.h"
+#include "config.h"
+
+/*
+ * Enums for each configuration option. All these currently match the CLI
+ * parameters for now but this may change later, so we keep all this code
+ * and definitions separate. The rules for configuration parameters may also
+ * differ.
+ *
+ * We only provide definitions for what we currently support parsing.
+ */
+
+enum data_subopts {
+	D_NOALIGN = 0,
+};
+
+enum inode_subopts {
+	I_ALIGN = 0,
+	I_PROJID32BIT,
+	I_SPINODES,
+};
+
+enum log_subopts {
+	L_LAZYSBCNTR = 0,
+};
+
+enum metadata_subopts {
+	M_CRC = 0,
+	M_FINOBT,
+	M_RMAPBT,
+	M_REFLINK,
+};
+
+enum naming_subopts {
+	N_FTYPE = 0,
+};
+
+enum rtdev_subopts {
+	R_NOALIGN = 0,
+};
+
+/* Just define the max options array size manually right now */
+#define MAX_SUBOPTS	5
+
+static int config_check_bool(
+	uint64_t			value)
+{
+	if (value > 1)
+		goto out;
+
+	return 0;
+out:
+	errno = ERANGE;
+	return -1;
+}
+
+
+static int
+data_config_parser(
+	struct mkfs_default_params	*dft,
+	int				psubopt,
+	uint64_t			value)
+{
+	enum data_subopts	subopt = psubopt;
+
+	if (config_check_bool(value) != 0)
+		return -EINVAL;
+
+	switch (subopt) {
+	case D_NOALIGN:
+		dft->sb_feat.nodalign = value;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int
+inode_config_parser(
+	struct mkfs_default_params	*dft,
+	int				psubopt,
+	uint64_t			value)
+{
+	enum inode_subopts	subopt = psubopt;
+
+	if (config_check_bool(value) != 0)
+		return -EINVAL;
+
+	switch (subopt) {
+	case I_ALIGN:
+		dft->sb_feat.inode_align = value;
+		return 0;
+	case I_PROJID32BIT:
+		dft->sb_feat.projid32bit = value;
+		return 0;
+	case I_SPINODES:
+		dft->sb_feat.spinodes = value;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int
+log_config_parser(
+	struct mkfs_default_params	*dft,
+	int				psubopt,
+	uint64_t			value)
+{
+	enum log_subopts	subopt = psubopt;
+
+	if (config_check_bool(value) != 0)
+		return -EINVAL;
+
+	switch (subopt) {
+	case L_LAZYSBCNTR:
+		dft->sb_feat.lazy_sb_counters = value;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int
+metadata_config_parser(
+	struct mkfs_default_params	*dft,
+	int				psubopt,
+	uint64_t			value)
+{
+	enum metadata_subopts	subopt = psubopt;
+
+	if (config_check_bool(value) != 0)
+		return -EINVAL;
+
+	switch (subopt) {
+	case M_CRC:
+		dft->sb_feat.crcs_enabled = value;
+		if (dft->sb_feat.crcs_enabled)
+			dft->sb_feat.dirftype = true;
+		return 0;
+	case M_FINOBT:
+		dft->sb_feat.finobt = value;
+		return 0;
+	case M_RMAPBT:
+		dft->sb_feat.rmapbt = value;
+		return 0;
+	case M_REFLINK:
+		dft->sb_feat.reflink = value;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int
+naming_config_parser(
+	struct mkfs_default_params	*dft,
+	int				psubopt,
+	uint64_t			value)
+{
+	enum naming_subopts	subopt = psubopt;
+
+	if (config_check_bool(value) != 0)
+		return -EINVAL;
+
+	switch (subopt) {
+	case N_FTYPE:
+		dft->sb_feat.dirftype = value;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int
+rtdev_config_parser(
+	struct mkfs_default_params	*dft,
+	int				psubopt,
+	uint64_t			value)
+{
+	enum rtdev_subopts	subopt = psubopt;
+
+	if (config_check_bool(value) != 0)
+		return -EINVAL;
+
+	switch (subopt) {
+	case R_NOALIGN:
+		dft->sb_feat.nortalign = value;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+struct confopts {
+	const char		*name;
+	const char		*subopts[MAX_SUBOPTS];
+	int			(*parser)(struct mkfs_default_params *dft,
+					  int psubopt, uint64_t value);
+	bool			seen;
+} confopts_tab[] = {
+	{
+		.name = "data",
+		.subopts = {
+			[D_NOALIGN] = "noalign",
+			NULL
+		},
+		.parser = data_config_parser,
+	},
+	{
+		.name = "inode",
+		.subopts = {
+			[I_ALIGN] = "align",
+			[I_PROJID32BIT] = "projid32bit",
+			[I_SPINODES] = "sparse",
+			NULL
+		},
+		.parser = inode_config_parser,
+	},
+	{
+		.name = "log",
+		.subopts = {
+			[L_LAZYSBCNTR] = "lazy-count",
+			NULL
+		},
+		.parser = log_config_parser,
+	},
+	{
+		.name = "naming",
+		.subopts = {
+			[N_FTYPE] = "ftype",
+			NULL
+		},
+		.parser = naming_config_parser,
+	},
+	{
+		.name = "rtdev",
+		.subopts = {
+			[R_NOALIGN] = "noalign",
+			NULL
+		},
+		.parser = rtdev_config_parser,
+	},
+	{
+		.name = "metadata",
+		.subopts = {
+			[M_CRC] = "crc",
+			[M_FINOBT] = "finobt",
+			[M_RMAPBT] = "rmapbt",
+			[M_REFLINK] = "reflink",
+			NULL
+		},
+		.parser = metadata_config_parser,
+	},
+};
+
+static struct confopts *
+get_confopts(
+	const char	*section)
+{
+	unsigned int	i;
+	struct confopts	*opts;
+
+	for (i=0; i < ARRAY_SIZE(confopts_tab); i++) {
+		opts = &confopts_tab[i];
+		if (!opts)
+			goto out;
+		if (strcmp(opts->name, section) == 0)
+			return opts;
+	}
+out:
+	errno = EINVAL;
+	return NULL;
+}
+
+enum parse_line_type {
+	PARSE_COMMENT = 0,
+	PARSE_EMPTY,
+	PARSE_SECTION,
+	PARSE_TAG_VALUE,
+	PARSE_INVALID,
+	PARSE_EOF,
+};
+
+static bool
+isempty(
+	const char	*line,
+	ssize_t		linelen)
+{
+	ssize_t		i = 0;
+	char		p;
+
+	while (i < linelen) {
+		p = line[i++];
+
+		/* tab or space */
+		if (!isblank(p))
+			return false;
+	}
+
+	return true;
+}
+
+static bool
+iscomment(
+	const char	*line,
+	ssize_t		linelen)
+{
+	ssize_t		i = 0;
+	char		p;
+
+	while (i != linelen) {
+		p = line[i];
+		i++;
+
+		/* tab or space */
+		if (isblank(p))
+			continue;
+
+		if (p == '#')
+			return true;
+
+		return false;
+	}
+
+	return false;
+}
+
+static enum parse_line_type
+parse_get_line_type(
+	const char	*line,
+	ssize_t		linelen,
+	char		**tag,
+	uint64_t	*value)
+{
+	int		ret;
+	uint64_t	u64_value;
+
+	if (isempty(line, linelen))
+		return PARSE_EMPTY;
+
+	if (iscomment(line, linelen))
+		return PARSE_COMMENT;
+
+	/* check if we have a section header */
+	ret = sscanf(line, " [%m[^]]]", tag);
+	if (ret == 1)
+		return  PARSE_SECTION;
+
+	if (ret == EOF)
+		return PARSE_EOF;
+
+	/* should be a "tag = value" config option */
+	ret = sscanf(line, " %m[^ \t=] = %" PRIu64 " ", tag, &u64_value);
+	if (ret == 2) {
+		*value = u64_value;
+
+		return PARSE_TAG_VALUE;
+	}
+
+	if (ret == EOF)
+		return PARSE_EOF;
+
+	errno = EINVAL;
+	return PARSE_INVALID;
+}
+
+static int
+parse_config_stream(
+	struct mkfs_default_params	*dft,
+	const char 			*config_file,
+	FILE				*fp)
+{
+	int				ret;
+	char				*line = NULL;
+	ssize_t				linelen;
+	size_t				len = 0, lineno = 0;
+	uint64_t			value;
+	enum parse_line_type		parse_type;
+	struct confopts			*confopt = NULL;
+	int				subopt;
+	char *tag = NULL;
+
+	while ((linelen = getline(&line, &len, fp)) != -1) {
+		char *ignore_value;
+		char *p, *tag = NULL;
+
+		lineno++;
+
+		/*
+		 * tag is allocated for us by scanf(), it must freed only on any
+		 * successful parse of a section or tag-value pair.
+		 */
+		parse_type = parse_get_line_type(line, linelen, &tag, &value);
+
+		switch (parse_type) {
+		case PARSE_EMPTY:
+		case PARSE_COMMENT:
+			/* Nothing tag to free for these */
+			continue;
+		case PARSE_EOF:
+			break;
+		case PARSE_INVALID:
+			ret = -EINVAL;
+			fprintf(stderr, _("Invalid line %s:%zu : %s\n"),
+					  config_file, lineno, line);
+			goto out;
+		case PARSE_SECTION:
+			confopt = get_confopts(tag);
+			if (!confopt) {
+				fprintf(stderr, _("Invalid section on line %s:%zu : %s\n"),
+						config_file, lineno, tag);
+				goto out_free_tag;
+			}
+			if (!confopt->subopts) {
+				fprintf(stderr, _("Section not yet supported on line %s:%zu : %s\n"),
+						config_file, lineno, tag);
+				goto out_free_tag;
+			}
+			if (confopt->seen) {
+				errno = EINVAL;
+				fprintf(stderr, _("Section '%s' respecified\n"),
+						tag);
+				goto out_free_tag;
+			}
+			confopt->seen = true;
+			free(tag);
+			break;
+		case PARSE_TAG_VALUE:
+			if (!confopt) {
+				fprintf(stderr, _("No section specified yet on line %s:%zu : %s\n"),
+						config_file, lineno, line);
+				goto out_free_tag;
+			}
+
+			/*
+			 * We re-use the line buffer allocated by getline(),
+			 * however line must be kept pointing to its original
+			 * value to free it later. A separate pointer is needed
+			 * as getsubopt() will otherwise muck with the value
+			 * passed.
+			 */
+			p = line;
+
+			/*
+			 * Trims white spaces. getsubopt() does not grok
+			 * white space, it would fail otherwise.
+			 */
+			snprintf(p, len, "%s=%lu", tag, value);
+
+			/* Not needed anymore */
+			free(tag);
+
+			/*
+			 * We only use getsubopt() to validate the possible
+			 * subopt, we already parsed the value and its already
+			 * in a more preferred data type.
+			 */
+			subopt = getsubopt(&p, (char **) confopt->subopts,
+					   &ignore_value);
+
+			ret = confopt->parser(dft, subopt, value);
+			if (ret) {
+				errno = EINVAL;
+				fprintf(stderr, _("Error parsine line %s:%zu : %s\n"),
+						config_file, lineno, line);
+				goto out;
+			}
+
+			break;
+		}
+		free(line);
+		line = NULL;
+	}
+
+out:
+	/* We must free even if getline() failed */
+	if (line)
+		free(line);
+	return ret;
+
+out_free_tag:
+	if (tag)
+		free(tag);
+	ret = -EINVAL;
+	goto out;
+}
+
+static int
+config_stat_check(
+	struct stat		*sp)
+{
+	if (!S_ISREG(sp->st_mode)) {
+		errno = -EINVAL;
+		return -1;
+	}
+
+	/* Anything beyond 1 MiB is kind of silly right now */
+	if (sp->st_size > 1 * 1024 * 1024) {
+		errno = E2BIG;
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * If the file is not found -1 is returned and errno set. Otherwise
+ * the file descriptor is returned.
+ */
+int
+open_cli_config(
+	int			dirfd,
+	const char		*cli_config_file,
+	char			**fpath)
+{
+	int			fd = -1, len, ret;
+	struct stat		st;
+
+	ret = fstatat(AT_FDCWD, cli_config_file, &st, AT_SYMLINK_NOFOLLOW);
+	if (ret != 0) {
+		len = snprintf(*fpath, PATH_MAX, "%s/%s", MKFS_XFS_CONF_DIR,
+			       cli_config_file);
+		/* Indicates truncation */
+		if (len >= PATH_MAX) {
+			errno = ENAMETOOLONG;
+			goto out;
+		}
+
+		ret = fstatat(dirfd, cli_config_file, &st,
+			      AT_SYMLINK_NOFOLLOW);
+		if (ret != 0)
+			goto out;
+
+		ret = config_stat_check(&st);
+		if (ret != 0)
+			goto out;
+
+		fd = openat(dirfd, cli_config_file, O_NOFOLLOW, O_RDONLY);
+		goto out;
+	}
+
+	memcpy(*fpath, cli_config_file, strlen(cli_config_file));
+
+	ret = config_stat_check(&st);
+	if (ret != 0)
+		return -1;
+
+	fd = openat(AT_FDCWD, cli_config_file, O_NOFOLLOW, O_RDONLY);
+out:
+	return fd;
+}
+
+int
+open_config_file(
+	const char			*cli_config_file,
+	struct mkfs_default_params	*dft,
+	char				**fpath)
+{
+	int			dirfd, fd = -1, len, ret;
+	struct stat		st;
+
+	*fpath = malloc(PATH_MAX);
+	if (!*fpath) {
+		errno = ENOMEM;
+		return -1;
+	}
+
+	memset(*fpath, 0, PATH_MAX);
+
+	dirfd = open(MKFS_XFS_CONF_DIR, O_PATH|O_NOFOLLOW|O_DIRECTORY);
+
+	if (cli_config_file) {
+		if (strlen(cli_config_file) > PATH_MAX) {
+			errno = ENAMETOOLONG;
+			goto out;
+		}
+		fd = open_cli_config(dirfd, cli_config_file, fpath);
+		goto out;
+	}
+
+	ret = fstatat(dirfd, "default", &st, AT_SYMLINK_NOFOLLOW);
+	if (ret != 0)
+		goto out;
+
+	dft->type = DEFAULTS_CONFIG;
+
+	ret = config_stat_check(&st);
+	if (ret != 0)
+		goto out;
+
+	fd = openat(dirfd, "default", O_NOFOLLOW, O_RDONLY);
+	if (fd >= 0) {
+		len = snprintf(*fpath, PATH_MAX, "%s/%s", MKFS_XFS_CONF_DIR,
+			       "default");
+		/* Indicates truncation */
+		if (len >= PATH_MAX) {
+			errno = ENAMETOOLONG;
+			close(fd);
+			fd = -1;
+			goto out;
+		}
+	}
+
+out:
+	if (fd < 0) {
+		if (dft->type != DEFAULTS_BUILTIN) {
+			fprintf(stderr, _("Unable to open %s config file: %s : %s\n"),
+					default_type_str(dft->type), *fpath,
+					strerror(errno));
+			free(*fpath);
+			exit(1);
+		}
+	}
+	if (dirfd >= 0)
+		close(dirfd);
+	return fd;
+}
+
+/*
+ * This is only called *iff* there is a configuration file which we know we
+ * *must* parse.
+ */
+int
+parse_defaults_file(
+	int					fd,
+	struct mkfs_default_params		*dft,
+	const char				*config_file)
+{
+	FILE			*fp;
+	int			ret;
+
+	fp = fdopen(fd, "r");
+	if (!fp)
+		goto out;
+
+	ret = parse_config_stream(dft, config_file, fp);
+	if (ret) {
+		fclose(fp);
+		goto out;
+	}
+
+	printf(_("config-file=%s\n"), config_file);
+
+	return 0;
+out:
+	return -1;
+}
diff --git a/mkfs/config.h b/mkfs/config.h
index a3c6c99c3064..163d1e893eab 100644
--- a/mkfs/config.h
+++ b/mkfs/config.h
@@ -19,6 +19,8 @@
 #ifndef _XFS_MKFS_CONFIG_H
 #define _XFS_MKFS_CONFIG_H
 
+#define MKFS_XFS_CONF_DIR      ROOT_SYSCONFDIR "/xfs/mkfs"
+
 struct fsxattr;
 
 /*
@@ -29,7 +31,7 @@ struct fsxattr;
  * source can overriding the later source:
  *
  * 	o built-in defaults
- * 	o configuration file (XXX)
+ * 	o configuration file
  * 	o command line
  *
  * These values are not used directly - they are inputs into the mkfs geometry
@@ -60,9 +62,14 @@ struct sb_feat_args {
  * These are the different possibilities by which you can end up parsing
  * default settings with. DEFAULTS_BUILTIN indicates there was no configuration
  * file parsed and we are using the built-in defaults on this code.
+ * DEFAULTS_CONFIG means the default configuration file was found and used.
+ * DEFAULTS_CLI_CONFIG means the user asked for a custom configuration type
+ * through the command line interface and it was used.
  */
 enum default_params_type {
 	DEFAULTS_BUILTIN = 0,
+	DEFAULTS_CONFIG,
+	DEFAULTS_CLI_CONFIG,
 };
 
 /*
@@ -91,8 +98,24 @@ static inline const char *default_type_str(enum default_params_type type)
 	switch (type) {
 	case DEFAULTS_BUILTIN:
 		return _("package built-in definitions");
+	case DEFAULTS_CONFIG:
+		return _("package default config file");
+	case DEFAULTS_CLI_CONFIG:
+		return _("CLI supplied file");
 	}
 	return _("Unkown\n");
 }
 
+int
+open_config_file(
+	const char			*cli_config_file,
+	struct mkfs_default_params	*dft,
+	char				**fpath);
+
+int
+parse_defaults_file(
+	int				fd,
+	struct mkfs_default_params	*dft,
+	const char			*config_file);
+
 #endif /* _XFS_MKFS_CONFIG_H */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2e344aa9dad1..949f592809e7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3744,6 +3744,9 @@ main(
 			.nortalign = false,
 		},
 	};
+	char			*cli_config_file = NULL;
+	char			*config_file = NULL;
+	int			fd, ret;
 
 	platform_uuid_generate(&cli.uuid);
 	progname = basename(argv[0]);
@@ -3752,26 +3755,70 @@ main(
 	textdomain(PACKAGE);
 
 	/*
-	 * TODO: Sourcing defaults from a config file
-	 *
 	 * Before anything else, see if there's a config file with different
-	 * defaults. If a file exists in <package location>, read in the new
-	 * default values and overwrite them in the &dft structure. This way the
-	 * new defaults will apply before we parse the CLI, and the CLI will
-	 * still be able to override them. When more than one source is
-	 * implemented, emit a message to indicate where the defaults being
-	 * used came from.
+	 * defaults. If the CLI specified a full path we use and require that.
+	 * If a relative path was provided on the CLI we search the allowed
+	 * search paths for the file. If no config file was specified on the
+	 * CLI we will look for MKFS_XFS_CONF_DIR/default and use that if
+	 * present, however this file is optional.
 	 *
-	 * printf(_("Default configuration sourced from %s\n"),
-	 *	  default_type_str(dft.type));
+	 * If a configuration file is found we use it to help overwrite default
+	 * values in the &dft structure. This way the new defaults will apply
+	 * before we parse the CLI, and the user will still be able to override
+	 * them through the CLI.
 	 */
 
-	/* copy new defaults into CLI parsing structure */
+	/*
+	 * Pull config line options from command line
+	 */
+	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
+		switch (c) {
+		case 'c':
+			if (cli_config_file) {
+				fprintf(stderr, _("respecification of configuration not allowed\n"));
+				exit(1);
+			}
+			cli_config_file = optarg;
+			dft.type = DEFAULTS_CLI_CONFIG;
+			break;
+		default:
+			continue;
+		}
+	}
+
+	fd = open_config_file(cli_config_file, &dft, &config_file);
+	if (fd >= 0) {
+		ret = parse_defaults_file(fd, &dft, config_file);
+		if (ret) {
+			fprintf(stderr, _("Error parsing %s config file: %s : %s\n"),
+					default_type_str(dft.type),
+					config_file,
+					strerror(errno));
+			free(config_file);
+			close(fd);
+			exit(1);
+		}
+		free(config_file);
+		close(fd);
+	}
+
+	printf(_("Default configuration sourced from %s\n"),
+	       default_type_str(dft.type));
+
+	/*
+	 * Done parsing defaults now, so memcpy defaults into CLI
+	 * structure, reset getopt and start parsing CLI options
+	 */
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
 
-	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
+	platform_getoptreset();
+
+	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
 		switch (c) {
+		case 'c':
+			/* already validated and parsed, ignore */
+			break;
 		case 'C':
 		case 'f':
 			force_overwrite = 1;
-- 
2.16.3

