Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932797AbeCBUcb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Mar 2018 15:32:31 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC v2] mkfs.xfs: add mkfs.xfs.conf parse support using libini_config
Date: Fri,  2 Mar 2018 12:32:28 -0800
Message-Id: <20180302203228.9622-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>

You may want to stick to specific set of configuration options when
creating filesystems with mkfs.xfs -- sometimes due to pure technical
reasons, but some other times to ensure systems remain compatible as
new features are introduced with older kernels, or if you always want
to take advantage of some new feature which would otherwise typically
be disruptive.

Although mkfs.xfs already uses sensible defaults this adds a configuration
option for parsing defaults settings for mkfs.xfs parsed prior to processing
input arguments from the command line.

We define an XFS configuration directory, /etc/mkfs.xfs.d/ and allow for
different types of configuration files, if none is specified we look for
the default type, /etc/mkfs.xfs.d/default, and you can override with -t.
For instance if you specify:

	mkfs.xfs -t experimental -f /dev/loop0

The file /etc/mkfs.xfs.d/experimental will be used as your configuration
file. If you really need to override the full path of the configuration
file you may use the MKFS_XFS_CONFIG enviornment variable.

To use /etc/ be sure to configure xfsprogs with:

 ./configure --sysconfdir=/etc/

To verify what configuration file is used on a system use the typical:

  mkfs.xfs -N

There is only a subset of options allowed to be set on the conifiguration
file, and currently only 1 or 0 are acceptable values. They are:

[data]
noalign=

[inode]
align=
attr=
projid32bit=
sparse=

[log]
lazy-count=
version=

[metadata]
crc=
finobt=
rmapbt=
reflink=

[naming]
ftype=

[rtdev]
noalign=

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---

So here is a follow up on the configuration front, now that the code refactor
is merged. I've used libini_config for an initial evaluation.

The big difference is I'm limitting configuration settings to only a set of
bools which are set via the default params. This simplifies parsing
considerably given we don't have to re-use the internal setters and checkers,
instead this is done later at processing time. There are other reasons to now
allow for configuring other parameters -- the fact that some have dependency on
others.

If we *really* intended to support parsing more options, we need to deal with
the last seen bit, and making the code much more complex.

For the life of me I couldn't get the @libiniconfig@ autoconf thing to parse.
Could use a second pair of eyeballs on that.

Let's bikeshed on this now.

 configure.ac             |   3 +
 include/builddefs.in     |   5 +
 m4/Makefile              |   1 +
 m4/package_ini_config.m4 |  20 +++
 m4/package_pthread.m4    |   2 +-
 man/man8/mkfs.xfs.8      |  23 +++
 mkfs/Makefile            |   2 +-
 mkfs/xfs_mkfs.c          | 408 ++++++++++++++++++++++++++++++++++++++++++++---
 8 files changed, 443 insertions(+), 21 deletions(-)
 create mode 100644 m4/package_ini_config.m4

diff --git a/configure.ac b/configure.ac
index d068ba0fee2d..d18b604fe688 100644
--- a/configure.ac
+++ b/configure.ac
@@ -142,6 +142,9 @@ AC_PACKAGE_NEED_UUIDCOMPARE
 AC_PACKAGE_NEED_PTHREAD_H
 AC_PACKAGE_NEED_PTHREADMUTEXINIT
 
+AC_PACKAGE_NEED_LIBINI_CONFIG_H
+AC_PACKAGE_NEED_INICONFIGGETSTAT
+
 AC_HAVE_FADVISE
 AC_HAVE_MADVISE
 AC_HAVE_MINCORE
diff --git a/include/builddefs.in b/include/builddefs.in
index df76b2c1610d..ebd35fc7c653 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -30,6 +30,9 @@ BUILD_CFLAGS = @BUILD_CFLAGS@ -D_FILE_OFFSET_BITS=64
 
 LIBRT = @librt@
 LIBUUID = @libuuid@
+# Can't figure out why this won't work yet.
+#LIBINICONFIG = @libiniconfig@
+LIBINICONFIG = -lini_config -lbasicobjects -lref_array -lcollection
 LIBPTHREAD = @libpthread@
 LIBTERMCAP = @libtermcap@
 LIBEDITLINE = @libeditline@
@@ -63,6 +66,7 @@ PKG_LIB_DIR	= @libdir@@libdirsuffix@
 PKG_INC_DIR	= @includedir@/xfs
 DK_INC_DIR	= @includedir@/disk
 PKG_MAN_DIR	= @mandir@
+PKG_ETC_DIR	= @sysconfdir@
 PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
 PKG_LOCALE_DIR	= @datadir@/locale
 
@@ -178,6 +182,7 @@ SANITIZER_LDFLAGS += @addrsan_ldflags@ @threadsan_ldflags@ @ubsan_ldflags@
 
 GCFLAGS = $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
+	  -DROOT_SYSCONFDIR=\"$(PKG_ETC_DIR)\"  \
 	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
 
 ifeq ($(ENABLE_GETTEXT),yes)
diff --git a/m4/Makefile b/m4/Makefile
index a6d11e9704ff..ae974ed9d6a3 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -26,6 +26,7 @@ LSRCFILES = \
 	package_unistring.m4 \
 	package_utilies.m4 \
 	package_uuiddev.m4 \
+	package_ini_config.m4 \
 	multilib.m4 \
 	$(CONFIGURE)
 
diff --git a/m4/package_ini_config.m4 b/m4/package_ini_config.m4
new file mode 100644
index 000000000000..20b48492296e
--- /dev/null
+++ b/m4/package_ini_config.m4
@@ -0,0 +1,20 @@
+AC_DEFUN([AC_PACKAGE_NEED_LIBINI_CONFIG_H],
+  [ AC_CHECK_HEADERS([ini_configobj.h])
+    if test $ac_cv_header_ini_configobj_h = no ; then
+	AC_CHECK_HEADERS(ini_configobj.h,, [
+	echo 'FATAL ERROR: could not find a valid libini_config header.'
+	echo 'Install the libini_config development package.'
+	exit 1])
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_INICONFIGGETSTAT],
+    [
+    AC_CHECK_LIB([ini_config],
+        [ini_config_get_stat],
+        [libiniconfig=-lini_config -lbasicobjects -lref_array -lcollection], [
+            echo
+            echo 'FATAL ERROR: could not find a valid libini_config library.'
+            exit 1])
+    AC_SUBST(libiniconfig)
+  ])
diff --git a/m4/package_pthread.m4 b/m4/package_pthread.m4
index be21d2935170..ff2cb8d1923a 100644
--- a/m4/package_pthread.m4
+++ b/m4/package_pthread.m4
@@ -1,7 +1,7 @@
 AC_DEFUN([AC_PACKAGE_NEED_PTHREAD_H],
   [ AC_CHECK_HEADERS(pthread.h)
     if test $ac_cv_header_pthread_h = no; then
-	AC_CHECK_HEADERS(pthread.h,, [
+	AC_CHECK_HEADERS(ini_configobj.h,, [
 	echo
 	echo 'FATAL ERROR: could not find a valid pthread header.'
 	exit 1])
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
diff --git a/mkfs/Makefile b/mkfs/Makefile
index c84f9b6ae63b..b95ef98fbe61 100644
--- a/mkfs/Makefile
+++ b/mkfs/Makefile
@@ -11,7 +11,7 @@ HFILES =
 CFILES = proto.c xfs_mkfs.c
 
 LLDLIBS += $(LIBXFS) $(LIBXCMD) $(LIBFROG) $(LIBRT) $(LIBPTHREAD) $(LIBBLKID) \
-	$(LIBUUID)
+	$(LIBUUID) $(LIBINICONFIG)
 LTDEPENDENCIES += $(LIBXFS) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static-libtool-libs
 
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b20e3d68255e..b6db4da86280 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -20,8 +20,13 @@
 #include <ctype.h>
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
+#include <ini_configobj.h>
 
-
+#define MKFS_XFS_CONF_DIR	ROOT_SYSCONFDIR "/mkfs.xfs.d/"
+#define CONFIG_MAX_KEY		1024
+#define CONFIG_MAX_VALUE	PATH_MAX
+#define CONFIG_MAX_BUFFER	CONFIG_MAX_KEY + CONFIG_MAX_VALUE + 3
+#define PARAM_OPTS		"t:b:d:i:l:L:m:n:KNp:qr:s:CfV"
 
 #define TERABYTES(count, blog)	((uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((uint64_t)(count) << (30 - (blog)))
@@ -839,6 +844,43 @@ struct mkfs_params {
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
@@ -848,7 +890,8 @@ struct mkfs_params {
  * calculations.
  */
 struct mkfs_default_params {
-	char	*source;	/* where the defaults came from */
+	enum default_params_type type; /* where the defaults came from */
+	const char *config_file;
 
 	int	sectorsize;
 	int	blocksize;
@@ -1414,6 +1457,12 @@ block_opts_parser(
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
@@ -1477,6 +1526,17 @@ data_opts_parser(
 	return 0;
 }
 
+static int data_config_parser(struct mkfs_default_params *dft, int subopt,
+			      bool value)
+{
+	switch (subopt) {
+	case D_NOALIGN:
+		dft->sb_feat.nodalign = value;
+		break;
+	}
+	return -EINVAL;
+}
+
 static int
 inode_opts_parser(
 	struct opt_params	*opts,
@@ -1512,6 +1572,26 @@ inode_opts_parser(
 	return 0;
 }
 
+static int inode_config_parser(struct mkfs_default_params *dft, int subopt,
+			       bool value)
+{
+	switch (subopt) {
+	case I_ALIGN:
+		dft->sb_feat.inode_align = value;
+		break;
+	case I_ATTR:
+		dft->sb_feat.attr_version = value;
+		break;
+	case I_PROJID32BIT:
+		dft->sb_feat.projid32bit = value;
+		break;
+	case I_SPINODES:
+		dft->sb_feat.spinodes = value;
+		break;
+	}
+	return -EINVAL;
+}
+
 static int
 log_opts_parser(
 	struct opt_params	*opts,
@@ -1558,6 +1638,20 @@ log_opts_parser(
 	return 0;
 }
 
+static int log_config_parser(struct mkfs_default_params *dft, int subopt,
+			     bool value)
+{
+	switch (subopt) {
+	case L_VERSION:
+		dft->sb_feat.log_version = value;
+		break;
+	case L_LAZYSBCNTR:
+		dft->sb_feat.lazy_sb_counters = value;
+		break;
+	}
+	return -EINVAL;
+}
+
 static int
 meta_opts_parser(
 	struct opt_params	*opts,
@@ -1592,6 +1686,28 @@ meta_opts_parser(
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
+	}
+	return -EINVAL;
+}
+
 static int
 naming_opts_parser(
 	struct opt_params	*opts,
@@ -1621,6 +1737,20 @@ naming_opts_parser(
 	return 0;
 }
 
+static int naming_config_parser(struct mkfs_default_params *dft, int subopt,
+				bool value)
+{
+	switch (subopt) {
+	case N_VERSION:
+		/* both min and max is 2, so no need to support this yet */
+		break;
+	case N_FTYPE:
+		dft->sb_feat.dirftype = value;
+		break;
+	}
+	return -EINVAL;
+}
+
 static int
 rtdev_opts_parser(
 	struct opt_params	*opts,
@@ -1651,6 +1781,17 @@ rtdev_opts_parser(
 	return 0;
 }
 
+static int rtdev_config_parser(struct mkfs_default_params *dft, int subopt,
+			       bool value)
+{
+	switch (subopt) {
+	case R_NOALIGN:
+		dft->sb_feat.nortalign = value;
+		break;
+	}
+	return -EINVAL;
+}
+
 static int
 sector_opts_parser(
 	struct opt_params	*opts,
@@ -1670,19 +1811,27 @@ sector_opts_parser(
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
 
@@ -1720,6 +1869,195 @@ parse_subopts(
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
+	char *val = "0";
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
+static int get_subopt_type(const char *buffer)
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
+static int parse_config_init(struct mkfs_default_params *dft)
+{
+	int ret;
+	struct ini_cfgobj *ini_config = NULL;
+	struct ini_cfgfile *ctx = NULL;
+	const struct stat *sp = NULL;
+	unsigned int num_subopts_sections = sizeof(subopt_tab) /
+					    sizeof(struct subopts) - 1;
+	char **sections, **attrs;
+	char *section, *attr;
+	int i, x, size, num_attr;
+	int type = 0;
+
+	ret = ini_config_create(&ini_config);
+	if (ret)
+		return ret;
+
+	ret = ini_config_file_open(dft->config_file, INI_META_STATS, &ctx);
+	if (ret) {
+		if (dft->type != DEFAULTS_BUILTIN)
+			fprintf(stderr, _("ini_config_file_open(): could not open config file: %s: %s\n"),
+				dft->config_file, strerror(ret));
+		else
+			ret = 0;
+		goto out;
+	}
+
+	/* If we found a file magically, it would be the default file */
+	if (dft->type == DEFAULTS_BUILTIN)
+		dft->type = DEFAULTS_CONFIG;
+
+	sp = ini_config_get_stat(ctx);
+	if (!sp) {
+		ret = -EACCES;
+		fprintf(stderr, _("ini_config_get_stat(): could get stat on file: %s: %s\n"),
+			dft->config_file, strerror(ret));
+		goto out;
+	}
+
+	if (!sp->st_size)
+		return 0;
+
+	ret = mkfs_check_config_file_limits(dft->config_file, sp,
+					    num_subopts_sections);
+	if (ret)
+		goto out;
+
+	/* Stop on any errors detected */
+	ret = ini_config_parse(ctx,
+			       INI_STOP_ON_ANY,
+			       0,
+			       0,
+			       ini_config);
+	if (ret)
+		goto out;
+
+	sections = ini_get_section_list(ini_config, &size, &ret);
+	if (ret || sections == NULL)
+		goto out;
+
+	for (i=0; i < size; i++) {
+		if (!sections[i]) {
+			ret = -EINVAL;
+			goto out_free_sections;
+		}
+		section = sections[i];
+		type = get_subopt_type(section);
+		if (!type) {
+			ret = -EINVAL;
+			goto out_free_sections;
+		}
+		attrs = ini_get_attribute_list(ini_config, section,
+					       &num_attr, &ret);
+		if (ret || attrs == NULL) {
+			if (ret == 0 && !attrs)
+				ret = -EINVAL;
+			goto out_free_sections;
+		}
+
+		for (x=0; x < num_attr; x++) {
+			uint64_t val;
+			struct value_obj *vo;
+			char line[160];
+			bool value;
+
+			memset(line, 0, sizeof(line));
+			attr = attrs[x];
+			ret = ini_get_config_valueobj(section, attr, ini_config,
+						      INI_GET_FIRST_VALUE, &vo);
+			if (ret || !vo) {
+				if (ret == 0 && !vo)
+					ret = -EINVAL;
+				goto out_free_sections;
+			}
+
+			val = ini_get_unsigned_config_value(vo, 1, 0, &ret);
+			if (ret)
+				goto out_free_sections;
+
+			value = !!val;
+
+			snprintf(line, sizeof(line), "%s=%lu", attr, val);
+			parse_config_subopts(type, value, line, dft);
+		}
+		ini_free_attribute_list(attrs);
+	}
+
+out_free_sections:
+	ini_free_section_list(sections);
+out:
+	ini_config_destroy(ini_config);
+	return ret;
+}
+
+
 static void
 validate_sectorsize(
 	struct mkfs_params	*cfg,
@@ -3177,11 +3515,13 @@ print_mkfs_cfg(
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
@@ -3191,6 +3531,7 @@ print_mkfs_cfg(
 "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
 "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
+		dft->type != DEFAULTS_BUILTIN ? dft->config_file : "empty",
 		dfile, cfg->inodesize, (long long)cfg->agcount,
 			(long long)cfg->agsize,
 		"", cfg->sectorsize, fp->attr_version, fp->projid32bit,
@@ -3797,7 +4138,8 @@ main(
 
 	/* build time defaults */
 	struct mkfs_default_params	dft = {
-		.source = _("package build definitions"),
+		.type = DEFAULTS_BUILTIN,
+		.config_file = MKFS_XFS_CONF_DIR "default",
 		.sectorsize = XFS_MIN_SECTORSIZE,
 		.blocksize = 1 << XFS_DFL_BLOCKSIZE_LOG,
 		.sb_feat = {
@@ -3819,6 +4161,9 @@ main(
 			.nortalign = false,
 		},
 	};
+	char *tmp_config;
+	char custom_config[PATH_MAX];
+	int ret;
 
 	platform_uuid_generate(&cli.uuid);
 	progname = basename(argv[0]);
@@ -3827,25 +4172,49 @@ main(
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
+	if (ret && dft.type != DEFAULTS_BUILTIN) {
+		fprintf(stderr, _("Parsing failed"));
+		usage();
+	}
 
 	/* copy new defaults into CLI parsing structure */
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
 
-	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
+	while (true) {
+		if (c == EOF)
+			break;
 		switch (c) {
+		case 't':
+			break;
 		case 'C':
 		case 'f':
 			force_overwrite = 1;
@@ -3885,6 +4254,7 @@ main(
 		case '?':
 			unknown(optopt, "");
 		}
+		c = getopt(argc, argv, PARAM_OPTS);
 	}
 	if (argc - optind > 1) {
 		fprintf(stderr, _("extra arguments\n"));
@@ -3968,7 +4338,7 @@ main(
 	calculate_log_size(&cfg, &cli, mp);
 
 	if (!quiet || dry_run) {
-		print_mkfs_cfg(&cfg, dfile, logfile, rtfile);
+		print_mkfs_cfg(&cfg, dfile, logfile, rtfile, &dft);
 		if (dry_run)
 			exit(0);
 	}
-- 
2.16.2

