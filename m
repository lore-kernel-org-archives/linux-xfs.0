Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753116AbeCMU7P (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Mar 2018 16:59:15 -0400
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH] mkfs.xfs: add configuration file parsing support using our own parser
Date: Tue, 13 Mar 2018 13:59:11 -0700
Message-Id: <20180313205911.26082-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com, tytso@mit.edu, "Luis R. Rodriguez" <mcgrof@kernel.org>

You may want to stick to specific set of configuration options when
creating filesystems with mkfs.xfs -- sometimes due to pure technical
reasons, but some other times to ensure systems remain compatible as
new features are introduced with older kernels, or if you always want
to take advantage of some new feature which would otherwise typically
be disruptive.

This adds support for parsing a configuration file to override defaults
parameters to be used for mkfs.xfs.

We define an XFS configuration directory, /etc/mkfs.xfs.d/ and allow for
different types of configuration files, if none is specified we look for
the default type, /etc/mkfs.xfs.d/default, and you can override with -T.
For instance, if you specify:

	mkfs.xfs -T experimental -f /dev/loop0

The file /etc/mkfs.xfs.d/experimental will be used as your configuration
file. If you really need to override the full path of the configuration
file you may use the MKFS_XFS_CONFIG environment variable.

To use /etc/ be sure to configure xfsprogs with:

 ./configure --sysconfdir=/etc/

To verify what configuration file is used on a system use the typical:

  mkfs.xfs -N

There is only a subset of options allowed to be set on the configuration
file, and currently only 1 or 0 are acceptable values. The default
parameters you can override on a configuration file and their current
built-in default settings are:

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

We have floated around enough bike shedding emails to have at least reached
a consensus on the fact that we'd be only supporting a mimimum set of default
parameters and would strive to simplify our parser as much as possible.

We never really decided on what parser to use though. To help with this I've
implemented what we have discussed so far with 3 different parsers options and
provide below URLs to both just a single patch needed for each on top today's
xfsprogs's origin/for-next and also provide a respective xfsprogs branch on
kernel.org:

  a) Our own parser (this patch) [0] [1]
  b) Using libini_config [2] [3]
  c) Using e2fsprogs profile parser [4] [5]

I decided to re-evaluate using our own parser as well again, despite the
original stated goal to not reinvent the wheel, since we decided to purposely
simplify the parser as much as possible. To this end I also limited the default
parameters we can override via the configuration file only to settings which we
can enable or disable, so default parameters for which we can only set their
values to 1 or 0. Final mkfs.xfs size evaluations also reveal carrying our own
simple parser may be worth considering for now, provided at the end of this
email.

Using our own parser is not a requirement, it just seems to make sense for now
given the simplicity of our current parsing needs. We can switch to a library
at any time. We can use either libini_config or the e2fsprogs profile parser,
if we are willing to depend on an external shared library or use a static
library.

Using a library libini_config proved to be the most robust and actively engaged
library to consider [6].

Using the e2fsprogs profile parser may make sense if we wanted to groom and
optimize a library for sizes *together* with the community. If one of our goals
is to use a *shared library*, and if one of the requirements for this library
is for it be as small as possible, we may want to consider grooming together
with the community a future *shared profile parser*. An independent e2fsprogs
profile parser today is about 14.86% the size of libini_config.so.5.2.0 [6],
as such those really counting bytes may like this approach.

However implementing our own simple parser still produces the smallest binary,
and dependencies today.

I believe that the size gains of using the e2fsprogs profile parser only makes
sense if we want to *reduce overall shared space* with other filesystem
configuration tools.  I've already taken the e2fsprogs profile parser and made
it a standalone library which we can use [7] and Ted is willing to help with
this, should we want to embrark on that route.

Current file size evaluations using the different parsing options reveal that
carrying our own parser produces the smallest binary. Using libini_config
actually has an extra penalty of 576 bytes over carrying our own parser.

Using e2fsprogs actually carries an added penalty of 79776 bytes over using
and carrying our own simple parser at this point.

Because of all this I've tried to simplify our own parser as much as possible,
and strived to keep the code as readible as possible.

Current size evaluations with the different parser options:

own-parser:
$ size mkfs/mkfs.xfs
   text    data     bss     dec     hex filename
 394164   38448     568  433180   69c1c mkfs/mkfs.xfs
$ du -b mkfs/mkfs.xfs
2552400 mkfs/mkfs.xfs

libini_config
$ size mkfs/mkfs.xfs
   text    data     bss     dec     hex filename
 395160   38568     568  434296   6a078 mkfs/mkfs.xfs
$ du -b mkfs/mkfs.xfs
2552976 mkfs/mkfs.xfs

e2fsprogs profile:
$ size mkfs/mkfs.xfs
   text    data     bss     dec     hex filename
 411913   38656     728  451297   6e2e1 mkfs/mkfs.xfs
$ du -b mkfs/mkfs.xfs
2632176 mkfs/mkfs.xfs

Let me know what color of the bike shed you'd like for this.

[0] http://drvbp1.linux-foundation.org/~mcgrof/patches/2018/03/13/own-parser.patch
[1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/xfsprogs-dev.git/log/?h=20180313-own-parser
[2] http://drvbp1.linux-foundation.org/~mcgrof/patches/2018/03/13/libini.patch
[3] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/xfsprogs-dev.git/log/?h=20180313-libini_config
[4] http://drvbp1.linux-foundation.org/~mcgrof/patches/2018/03/13/eprofile.patch
[5] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/xfsprogs-dev.git/log/?h=20180313-eprofile-parser
[6] https://gitlab.com/mcgrof/filesystem-configuration-paper/blob/master/paper.pdf
[7] https://gitlab.com/mcgrof/libekprofile

  Luis

 include/builddefs.in  |   2 +
 man/man5/mkfs.xfs.d.5 | 121 ++++++++++++++
 man/man8/mkfs.xfs.8   |  23 +++
 mkfs/xfs_mkfs.c       | 432 +++++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 559 insertions(+), 19 deletions(-)
 create mode 100644 man/man5/mkfs.xfs.d.5

diff --git a/include/builddefs.in b/include/builddefs.in
index 7a2a62686717..231c96196ab9 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -63,6 +63,7 @@ PKG_LIB_DIR	= @libdir@@libdirsuffix@
 PKG_INC_DIR	= @includedir@/xfs
 DK_INC_DIR	= @includedir@/disk
 PKG_MAN_DIR	= @mandir@
+PKG_ETC_DIR	= @sysconfdir@
 PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
 PKG_LOCALE_DIR	= @datadir@/locale
 
@@ -194,6 +195,7 @@ endif
 
 GCFLAGS = $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
+	  -DROOT_SYSCONFDIR=\"$(PKG_ETC_DIR)\"  \
 	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
 
 ifeq ($(ENABLE_GETTEXT),yes)
diff --git a/man/man5/mkfs.xfs.d.5 b/man/man5/mkfs.xfs.d.5
new file mode 100644
index 000000000000..89fd28c79139
--- /dev/null
+++ b/man/man5/mkfs.xfs.d.5
@@ -0,0 +1,121 @@
+.TH mkfs.xfs.d 5
+.SH NAME
+mkfs.xfs.d \- mkfs.xfs configuration directory
+.SH DESCRIPTION
+.B mkfs.xfs (8)
+uses a set of initial default parameters for configuration. These defaults
+are conservatively decided by the community as xfsprogs and features for XFS
+in the kernel advance. One can override these default on the
+.B mkfs.xfs (8)
+command line, but there are cases where it is desirable for sensible defaults
+to always be specified by the system where
+.B mkfs.xfs (8)
+runs on. This may desirable for example on systems with old kernels where the
+built-in default parameters on
+.B mkfs.xfs (8)
+may not be able to create a filesystem which the old kernel supports and it
+would be unclear what parameters are needed to produce a compatible filesystem.
+Overriding
+.B mkfs.xfs (8)
+built-in defaults may also be desirable if you have a series of systems with
+different kernels and want to be able to create filesystems which all systems
+are able to support properly.
+.PP
+The XFS configuration directory
+.B mkfs.xfs.d (5)
+can be used to define different configuration file types which can be used to
+override the built-in default parameters by
+.B mkfs.xfs (8).
+Different configuration file types are supported, the default
+configuration file type,
+.I /etc/mkfs.xfs.d/default
+, will be looked for first and if present will be used to override
+.B mkfs.xfs (8)
+built-in default parameters. You can override the configuration file type by
+specifying the type when using
+.B mkfs.xfs (8)
+by using the
+.B -T
+parameter. For example:
+.I mkfs.xfs -T experimental -f /dev/sda1
+will make
+.B mkfs.xfs (8)
+look for and use the configuration file type
+.I /etc/mkfs.xfs.d/experimental
+to override
+.B mkfs.xfs (8)
+default parameters. If you need to override the full path for a configuration
+file type you can use the
+.I MKFS_XFS_CONFIG
+environment variable prior to calling
+.B mkfs.xfs (8)
+to define the
+full path to the configuration file to be used. If you used the
+.B -T
+parameter or if you set the
+.I MKFS_XFS_CONFIG
+environment variable the configuration file must be present and should parse
+correctly.
+.PP
+Parameters passed to to the
+.B mkfs.xfs (8)
+command line always override any defaults set on the configuration file used.
+.PP
+.B mkfs.xfs (8)
+will always describe what configuration file was used, if any
+was used at all. To verify which configuration file would be used prior to
+execution of
+.B mkfs.xfs (8)
+you can use
+.I mkfs.xfs -N.
+.PP
+.SH DEFAULT PARAMETERS
+Default parameters for
+.B mkfs.xfs (8)
+consists of a small subset of the parameters one can set with on the command
+line. Default parameters can only be either enabled or disabled, you can set
+their value to 1 to enable or 0 to disable. Below we list the different
+supported default parameters which can be defined on configuration files, along
+with the current built-in setting.
+.PP
+.BI [data]
+.br
+.BI noalign=0
+.PP
+.BI [inode]
+.br
+.BI align=1
+.br
+.BI projid32bit=1
+.br
+.BI sparse=0
+.PP
+.BI [log]
+.br
+.BI lazy-count=1
+.PP
+.BI [metadata]
+.br
+.BI crc=1
+.br
+.BI finobt=1
+.br
+.BI rmapbt=0
+.br
+.BI reflink=0
+.PP
+.BI [naming]
+.br
+.BI ftype=1
+.PP
+.BI [rtdev]
+.br
+.BI noalign=0
+.PP
+.SH SEE ALSO
+.BR mkfs.xfs (8),
+.BR xfsctl (3),
+.BR xfs_info (8),
+.BR xfs_admin (8),
+.BR xfsdump (8),
+.BR xfsrestore (8).
diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 4b8c78c37806..18489b3a19ff 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -83,6 +83,23 @@ and
 .B \-l internal \-l size=10m
 are equivalent.
 .PP
+An optional XFS configuration type file directory
+.B mkfs.xfs.d (5)
+exists to help fine tune default parameters which can be used when calling
+.B mkfs.xfs (8), by default type will be used by default, /etc/mkfs.xfs.d/default.
+Command line arguments directly passed to
+.B mkfs.xfs (8)
+will always override parameters set it the configuration type file.
+You can override configuration file type on the
+.B mkfs.xfs.d (5)
+directory by using the -t parameter and secifying the type. Alternatively
+you can set and use the MKFS_XFS_CONFIG environment variable to override
+the default full path of the first file
+.B mkfs.xfs (8)
+looks for.
+If you use -t the type configuration file must be present under
+.B mkfs.xfs.d (8).
+.PP
 In the descriptions below, sizes are given in sectors, bytes, blocks,
 kilobytes, megabytes, gigabytes, etc.
 Sizes are treated as hexadecimal if prefixed by 0x or 0X,
@@ -123,6 +140,11 @@ Many feature options allow an optional argument of 0 or 1, to explicitly
 disable or enable the functionality.
 .SH OPTIONS
 .TP
+.BI \-t " configuration-type"
+Override the default type of the configuratio file under
+.B mkfs.xfs.d
+used.
+.TP
 .BI \-b " block_size_options"
 This option specifies the fundamental block size of the filesystem.
 The valid
@@ -923,6 +945,7 @@ Prints the version number and exits.
 .SH SEE ALSO
 .BR xfs (5),
 .BR mkfs (8),
+.BR mkfs.xfs.d (5),
 .BR mount (8),
 .BR xfs_info (8),
 .BR xfs_admin (8).
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 1ca6a2d148c4..e66330a50b68 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -21,7 +21,11 @@
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 
-
+#define MKFS_XFS_CONF_DIR	ROOT_SYSCONFDIR "/mkfs.xfs.d/"
+#define CONFIG_MAX_KEY		1024
+#define CONFIG_MAX_VALUE	PATH_MAX
+#define CONFIG_MAX_BUFFER	CONFIG_MAX_KEY + CONFIG_MAX_VALUE + 3
+#define PARAM_OPTS		"T:b:d:i:l:L:m:n:KNp:qr:s:CfV"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
@@ -839,6 +843,43 @@ struct mkfs_params {
 	struct sb_feat_args	sb_feat;
 };
 
+/*
+ * File configuration type settings
+ *
+ * These are the different possibilities by which you can end up parsing
+ * default settings with. DEFAULTS_BUILTIN indicates there was no configuration
+ * file parsed and we are using the built-in defaults on this code.
+ * DEFAULTS_CONFIG means the default configuration file was found and used.
+ * DEFAULTS_TYPE_CONFIG means the user asked for a custom configuration type
+ * and it was used, this means the default directory for mkfs.xfs
+ * configuration files was used to look for the type specified. If you need
+ * to override the default mkfs.xfs directory for configuration file you can
+ * use the MKFS_XFS_CONFIG environment variable to set the absolute path to
+ * your custom configuration file, when this is set the type is set to
+ * DEFAULTS_ENVIRONMENT_CONFIG.
+ */
+enum default_params_type {
+	DEFAULTS_BUILTIN = 0,
+	DEFAULTS_CONFIG,
+	DEFAULTS_ENVIRONMENT_CONFIG,
+	DEFAULTS_TYPE_CONFIG,
+};
+
+static const char *default_type_str(enum default_params_type type)
+{
+	switch (type) {
+	case DEFAULTS_BUILTIN:
+		return _("package build definitions");
+	case DEFAULTS_CONFIG:
+		return _("default configuration system file");
+	case DEFAULTS_ENVIRONMENT_CONFIG:
+		return _("custom configuration file set by environment");
+	case DEFAULTS_TYPE_CONFIG:
+		return _("custom configuration type file");
+	}
+	return _("Unkown\n");
+}
+
 /*
  * Default filesystem features and configuration values
  *
@@ -848,7 +889,8 @@ struct mkfs_params {
  * calculations.
  */
 struct mkfs_default_params {
-	char	*source;	/* where the defaults came from */
+	enum default_params_type type; /* where the defaults came from */
+	const char *config_file;
 
 	int	sectorsize;
 	int	blocksize;
@@ -1414,6 +1456,12 @@ block_opts_parser(
 	return 0;
 }
 
+static int block_config_parser(struct mkfs_default_params *dft, int subopt,
+			       bool value)
+{
+	return -EINVAL;
+}
+
 static int
 data_opts_parser(
 	struct opt_params	*opts,
@@ -1477,6 +1525,19 @@ data_opts_parser(
 	return 0;
 }
 
+static int data_config_parser(struct mkfs_default_params *dft, int subopt,
+			      bool value)
+{
+	switch (subopt) {
+	case D_NOALIGN:
+		dft->sb_feat.nodalign = value;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int
 inode_opts_parser(
 	struct opt_params	*opts,
@@ -1512,6 +1573,25 @@ inode_opts_parser(
 	return 0;
 }
 
+static int inode_config_parser(struct mkfs_default_params *dft, int subopt,
+			       bool value)
+{
+	switch (subopt) {
+	case I_ALIGN:
+		dft->sb_feat.inode_align = value;
+		break;
+	case I_PROJID32BIT:
+		dft->sb_feat.projid32bit = value;
+		break;
+	case I_SPINODES:
+		dft->sb_feat.spinodes = value;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int
 log_opts_parser(
 	struct opt_params	*opts,
@@ -1558,6 +1638,19 @@ log_opts_parser(
 	return 0;
 }
 
+static int log_config_parser(struct mkfs_default_params *dft, int subopt,
+			     bool value)
+{
+	switch (subopt) {
+	case L_LAZYSBCNTR:
+		dft->sb_feat.lazy_sb_counters = value;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int
 meta_opts_parser(
 	struct opt_params	*opts,
@@ -1592,6 +1685,30 @@ meta_opts_parser(
 	return 0;
 }
 
+static int meta_config_parser(struct mkfs_default_params *dft, int subopt,
+			      bool value)
+{
+	switch (subopt) {
+	case M_CRC:
+		dft->sb_feat.crcs_enabled = value;
+		if (dft->sb_feat.crcs_enabled)
+			dft->sb_feat.dirftype = true;
+		break;
+	case M_FINOBT:
+		dft->sb_feat.finobt = value;
+		break;
+	case M_RMAPBT:
+		dft->sb_feat.rmapbt = value;
+		break;
+	case M_REFLINK:
+		dft->sb_feat.reflink = value;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int
 naming_opts_parser(
 	struct opt_params	*opts,
@@ -1621,6 +1738,19 @@ naming_opts_parser(
 	return 0;
 }
 
+static int naming_config_parser(struct mkfs_default_params *dft, int subopt,
+				bool value)
+{
+	switch (subopt) {
+	case N_FTYPE:
+		dft->sb_feat.dirftype = value;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int
 rtdev_opts_parser(
 	struct opt_params	*opts,
@@ -1651,6 +1781,19 @@ rtdev_opts_parser(
 	return 0;
 }
 
+static int rtdev_config_parser(struct mkfs_default_params *dft, int subopt,
+			       bool value)
+{
+	switch (subopt) {
+	case R_NOALIGN:
+		dft->sb_feat.nortalign = value;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int
 sector_opts_parser(
 	struct opt_params	*opts,
@@ -1670,19 +1813,27 @@ sector_opts_parser(
 	return 0;
 }
 
+static int sector_config_parser(struct mkfs_default_params *dft, int subopt,
+				bool value)
+{
+	return -EINVAL;
+}
+
 struct subopts {
 	char		opt;
 	struct opt_params *opts;
 	int		(*parser)();
+	int		(*config_parser)(struct mkfs_default_params *dft,
+					 int subop, bool value);
 } subopt_tab[] = {
-	{ 'b', &bopts, block_opts_parser },
-	{ 'd', &dopts, data_opts_parser },
-	{ 'i', &iopts, inode_opts_parser },
-	{ 'l', &lopts, log_opts_parser },
-	{ 'm', &mopts, meta_opts_parser },
-	{ 'n', &nopts, naming_opts_parser },
-	{ 'r', &ropts, rtdev_opts_parser },
-	{ 's', &sopts, sector_opts_parser },
+	{ 'b', &bopts, block_opts_parser, block_config_parser },
+	{ 'd', &dopts, data_opts_parser, data_config_parser },
+	{ 'i', &iopts, inode_opts_parser, inode_config_parser },
+	{ 'l', &lopts, log_opts_parser, log_config_parser },
+	{ 'm', &mopts, meta_opts_parser, meta_config_parser },
+	{ 'n', &nopts, naming_opts_parser, naming_config_parser },
+	{ 'r', &ropts, rtdev_opts_parser, rtdev_config_parser },
+	{ 's', &sopts, sector_opts_parser, sector_config_parser },
 	{ '\0', NULL, NULL },
 };
 
@@ -1720,6 +1871,219 @@ parse_subopts(
 	}
 }
 
+static int
+parse_config_subopts(
+	char		opt,
+	bool            value,
+	char 		*line,
+	struct mkfs_default_params *dft)
+{
+	struct subopts	*sop = &subopt_tab[0];
+	char	**subopts = (char **)sop->opts->subopts;
+	int	subopt;
+	char *val;
+
+	while (sop->opts) {
+		if (sop->opt == opt)
+			break;
+		sop++;
+	}
+
+	/* should never happen */
+	if (!sop->opts)
+		return -EINVAL;
+
+	subopts = (char **)sop->opts->subopts;
+	subopt = getsubopt(&line, subopts, &val);
+	return (sop->config_parser)(dft, subopt, value);
+}
+
+static int get_opt_type(const char *buffer)
+{
+	if (strncmp("block", buffer, 5) == 0)
+		return 'b';
+	if (strncmp("data", buffer, 4) == 0)
+		return 'd';
+	if (strncmp("inode", buffer, 5) == 0)
+		return 'i';
+	if (strncmp("log", buffer, 3) == 0)
+		return 'l';
+	if (strncmp("metadata", buffer, 8) == 0)
+		return 'm';
+	if (strncmp("naming", buffer, 6) == 0)
+		return 'n';
+	if (strncmp("rtdev", buffer, 5) == 0)
+		return 'r';
+	if (strncmp("sector", buffer, 6) == 0)
+		return 'n';
+	return 0;
+}
+
+static int mkfs_check_config_file_limits(const char *filename,
+					 const struct stat *sb,
+					 unsigned int max_entries)
+{
+	unsigned long long size_limit;
+
+	size_limit = CONFIG_MAX_BUFFER * max_entries;
+
+	/*
+	 * Detect wrap around -- if max_entries * size_limit goves over
+	 * unsigned long long we detect that there. Also libiniconfig only
+	 * groks max INT_MAX entries anyway.
+	 */
+	if (size_limit < max_entries || max_entries > INT_MAX)
+		return -E2BIG;
+
+	if (sb->st_size > size_limit) {
+		fprintf(stderr,
+			"File %s is too big! File size limit: %llu\n",
+			filename, size_limit);
+		return -E2BIG;
+	}
+
+	return 0;
+}
+
+enum parse_line_type {
+	PARSE_COMMENT = 0,
+	PARSE_SECTION,
+	PARSE_TAG_VALUE,
+	PARSE_INVALID,
+	PARSE_EOF,
+};
+
+static int parse_line_section(const char *line, char *tag)
+{
+	return sscanf(line, " [%[^]]s]", tag);
+}
+
+static int parse_line_tag_value(const char *line, char *tag,
+				unsigned int *value)
+{
+	return sscanf(line, " %[^ \t=]"
+		      " = "
+		      "%u ",
+		      tag, value);
+}
+
+static enum parse_line_type parse_get_line_type(const char *line, char *tag,
+						bool *value)
+{
+	int ret;
+	unsigned int uint_value;
+
+	memset(tag, 0, 80);
+
+	if (strlen(line) < 2)
+		return PARSE_INVALID;
+
+	if (line[0] == '#')
+		return PARSE_COMMENT;
+
+	ret = parse_line_section(line, tag);
+	if (ret == 1)
+		return  PARSE_SECTION;
+
+	if (ret == EOF)
+		return PARSE_EOF;
+
+	ret = parse_line_tag_value(line, tag, &uint_value);
+	if (ret == 2) {
+		if (uint_value != 1 && uint_value != 0)
+			return -EINVAL;
+
+		*value = !!uint_value;
+
+		return PARSE_TAG_VALUE;
+	}
+
+	if (ret == EOF)
+		return PARSE_EOF;
+
+	return PARSE_INVALID;
+}
+
+static int parse_config_init(struct mkfs_default_params *dft)
+{
+	int ret;
+	FILE *fp;
+	struct stat sp;
+	unsigned int num_subopts_sections = sizeof(subopt_tab) /
+					    sizeof(struct subopts) - 1;
+	char *p;
+	char line[80], tag[80];
+	bool value;
+	enum parse_line_type parse_type;
+	int opt = 0;
+
+	fp = fopen(dft->config_file, "r");
+	if (!fp) {
+		if (dft->type != DEFAULTS_BUILTIN) {
+			fprintf(stderr, _("could not open config file: %s\n"),
+				dft->config_file);
+			ret = -ENOENT;
+		} else
+			ret = 0;
+		return ret;
+	}
+
+	/* If we found a file magically, it would be the default file */
+	if (dft->type == DEFAULTS_BUILTIN)
+		dft->type = DEFAULTS_CONFIG;
+
+	ret = stat(dft->config_file, &sp);
+	if (ret) {
+		if (dft->type != DEFAULTS_BUILTIN)
+			fprintf(stderr, _("could not stat() config file: %s: %s\n"),
+				dft->config_file, strerror(ret));
+		return ret;
+	}
+
+	if (!sp.st_size)
+		return 0;
+
+	ret = mkfs_check_config_file_limits(dft->config_file, &sp,
+					    num_subopts_sections);
+	if (ret)
+		return ret;
+
+	while (!feof(fp)) {
+		p = fgets(line, sizeof(line), fp);
+		if (!p)
+			continue;
+
+		parse_type = parse_get_line_type(line, tag, &value);
+
+		switch (parse_type) {
+		case PARSE_COMMENT:
+		case PARSE_INVALID:
+		case PARSE_EOF:
+			break;
+		case PARSE_SECTION:
+			opt = get_opt_type(tag);
+			if (!opt) {
+				fprintf(stderr, _("Invalid section: %s\n"),
+						tag);
+				return -EINVAL;
+			}
+			break;
+		case PARSE_TAG_VALUE:
+			/* Trims white spaces */
+			snprintf(line, sizeof(line), "%s=%u", tag, value);
+			ret = parse_config_subopts(opt, value, line, dft);
+			if (ret) {
+				fprintf(stderr, _("Error parsine line: %s\n"),
+						line);
+				return ret;
+			}
+			break;
+		}
+	}
+
+	return 0;
+}
+
 static void
 validate_sectorsize(
 	struct mkfs_params	*cfg,
@@ -3177,11 +3541,13 @@ print_mkfs_cfg(
 	struct mkfs_params	*cfg,
 	char			*dfile,
 	char			*logfile,
-	char			*rtfile)
+	char			*rtfile,
+	struct mkfs_default_params *dft)
 {
 	struct sb_feat_args	*fp = &cfg->sb_feat;
 
 	printf(_(
+"config-file=%-22s\n"
 "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
@@ -3191,6 +3557,7 @@ print_mkfs_cfg(
 "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
+		dft->type != DEFAULTS_BUILTIN ? dft->config_file : "empty",
 		dfile, cfg->inodesize, (long long)cfg->agcount,
 			(long long)cfg->agsize,
 		"", cfg->sectorsize, fp->attr_version, fp->projid32bit,
@@ -3797,7 +4164,8 @@ main(
 
 	/* build time defaults */
 	struct mkfs_default_params	dft = {
-		.source = _("package build definitions"),
+		.type = DEFAULTS_BUILTIN,
+		.config_file = MKFS_XFS_CONF_DIR "default",
 		.sectorsize = XFS_MIN_SECTORSIZE,
 		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
 		.sb_feat = {
@@ -3819,6 +4187,9 @@ main(
 			.nortalign = false,
 		},
 	};
+	char *tmp_config;
+	char custom_config[PATH_MAX];
+	int ret;
 
 	platform_uuid_generate(&cli.uuid);
 	progname = basename(argv[0]);
@@ -3827,25 +4198,47 @@ main(
 	textdomain(PACKAGE);
 
 	/*
-	 * TODO: Sourcing defaults from a config file
-	 *
 	 * Before anything else, see if there's a config file with different
-	 * defaults. If a file exists in <package location>, read in the new
+	 * defaults. If a file exists in MKFS_XFS_CONF_DIR/default, read the new
 	 * default values and overwrite them in the &dft structure. This way the
 	 * new defaults will apply before we parse the CLI, and the CLI will
 	 * still be able to override them. When more than one source is
 	 * implemented, emit a message to indicate where the defaults being
 	 * used came from.
-	 *
-	 * printf(_("Default configuration sourced from %s\n"), dft.source);
 	 */
+	tmp_config = getenv("MKFS_XFS_CONFIG");
+	if (tmp_config != NULL) {
+		dft.config_file = tmp_config;
+		dft.type = DEFAULTS_ENVIRONMENT_CONFIG;
+	}
+
+	c = getopt(argc, argv, PARAM_OPTS);
+	if (c != EOF && c == 't') {
+		memset(custom_config, 0, sizeof(custom_config));
+		snprintf(custom_config, sizeof(custom_config), "%s%s",
+			 MKFS_XFS_CONF_DIR, optarg);
+		dft.config_file = custom_config;
+		dft.type = DEFAULTS_TYPE_CONFIG;
+	}
+
+	ret = parse_config_init(&dft);
+
+	printf(_("Default configuration sourced from %s\n"),
+	       default_type_str(dft.type));
+
+	if (ret && dft.type != DEFAULTS_BUILTIN)
+		usage();
 
 	/* copy new defaults into CLI parsing structure */
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
 
-	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
+	while (true) {
+		if (c == EOF)
+			break;
 		switch (c) {
+		case 'T':
+			break;
 		case 'C':
 		case 'f':
 			force_overwrite = 1;
@@ -3885,6 +4278,7 @@ main(
 		case '?':
 			unknown(optopt, "");
 		}
+		c = getopt(argc, argv, PARAM_OPTS);
 	}
 	if (argc - optind > 1) {
 		fprintf(stderr, _("extra arguments\n"));
@@ -3968,7 +4362,7 @@ main(
 	calculate_log_size(&cfg, &cli, mp);
 
 	if (!quiet || dry_run) {
-		print_mkfs_cfg(&cfg, dfile, logfile, rtfile);
+		print_mkfs_cfg(&cfg, dfile, logfile, rtfile, &dft);
 		if (dry_run)
 			exit(0);
 	}
-- 
2.16.2

