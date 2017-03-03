Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752151AbdCCXOZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 18:14:25 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 9/9] mkfs.xfs: add mkfs.xfs.conf parse support
Date: Fri,  3 Mar 2017 15:13:16 -0800
Message-Id: <20170303231316.12716-10-mcgrof@kernel.org>
In-Reply-To: <20170303231316.12716-1-mcgrof@kernel.org>
References: <20170303231316.12716-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

You may want to stick to specific set of configuration options when
creating filesystems with mkfs.xfs -- sometimes due to pure technical
reasons, but some other times to ensure systems remain compatible as
new features are introduced with older kernels, or if you always want
to take advantage of some new feature which would otherwise typically
be disruptive.

Although mkfs.xfs already uses sensible defaults this adds a configuration
option for parsing defaults settings for mkfs.xfs parsed prior to processing
input arguments.

User input passed to mkfs.xfs overrides defaults founds through the
new optional configuration file, by default:

	/etc/mkfs.xfs.conf

To use /etc/ be sure to configure xfsprogs with:

 ./configure --sysconfdir=/etc/

The build system also allows distributions to override the default
mkfs.xfs.conf defaults with a custom:

	etc/mkfs.xfs.conf.custom.in

The default etc/mkfs.xfs.conf.in provides commented out examples.
You can also override the configuration file used either with the
MKFS_XFS_CONFIG environment variable or by using the new -c command
line argument to mkfs.xfs. Only when -c is used will the configuration
file be required to be present.

To verify what configuration file is used on a system use the typical:

  mkfs.xfs -N

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 .gitignore             |   3 ++
 Makefile               |   2 +-
 etc/Makefile           |  21 ++++++++
 etc/mkfs.xfs.conf.in   |  58 ++++++++++++++++++++
 include/builddefs.in   |   2 +
 include/buildmacros    |   6 +++
 man/man5/mkfs.xfs.conf | 113 +++++++++++++++++++++++++++++++++++++++
 man/man8/mkfs.xfs.8    |  28 ++++++++++
 mkfs/xfs_mkfs.c        | 140 ++++++++++++++++++++++++++++++++++++++++++++++++-
 9 files changed, 371 insertions(+), 2 deletions(-)
 create mode 100644 etc/Makefile
 create mode 100644 etc/mkfs.xfs.conf.in
 create mode 100644 man/man5/mkfs.xfs.conf

diff --git a/.gitignore b/.gitignore
index 913b371fce5f..869c59ce30b1 100644
--- a/.gitignore
+++ b/.gitignore
@@ -72,3 +72,6 @@ cscope.*
 /libxfs/crc32selftest
 /libxfs/crc32table.h
 /libxfs/gen_crc32table
+
+# etc files
+/etc/mkfs.xfs.conf
diff --git a/Makefile b/Makefile
index 6e45733ee6de..02e0e2e7c1ee 100644
--- a/Makefile
+++ b/Makefile
@@ -47,7 +47,7 @@ HDR_SUBDIRS = include libxfs
 DLIB_SUBDIRS = libxlog libxcmd libhandle
 LIB_SUBDIRS = libxfs $(DLIB_SUBDIRS)
 TOOL_SUBDIRS = copy db estimate fsck growfs io logprint mkfs quota \
-		mdrestore repair rtcp m4 man doc debian
+		mdrestore repair rtcp m4 man etc doc debian
 
 ifneq ("$(PKG_PLATFORM)","darwin")
 TOOL_SUBDIRS += fsr
diff --git a/etc/Makefile b/etc/Makefile
new file mode 100644
index 000000000000..a9b3dd75c343
--- /dev/null
+++ b/etc/Makefile
@@ -0,0 +1,21 @@
+TOPDIR = ..
+include $(TOPDIR)/include/builddefs
+
+ETC_FILES	= mkfs.xfs.conf
+ETC_DEST	= $(PKG_ETC_DIR)
+
+default : $(ETC_FILES)
+
+include $(BUILDRULES)
+
+install : default
+	$(INSTALL) -m 755 -d $(ETC_DEST)
+	$(INSTALL_ETC)
+install-dev :
+
+mkfs.xfs.conf: mkfs.xfs.conf.in
+	@if test -f mkfs.xfs.conf.custom.in ; then \
+		cp mkfs.xfs.conf.custom.in mkfs.xfs.conf; \
+	else \
+		cp mkfs.xfs.conf.in mkfs.xfs.conf; \
+	fi
diff --git a/etc/mkfs.xfs.conf.in b/etc/mkfs.xfs.conf.in
new file mode 100644
index 000000000000..0999f4ddfc02
--- /dev/null
+++ b/etc/mkfs.xfs.conf.in
@@ -0,0 +1,58 @@
+# Options assigned values mean they are the current mkfs.xfs defaults
+#[block_size_options]
+#log =
+#size =
+
+#[metadata_options]
+#crc = 1
+#finobt = 1
+#uuid =
+#rmapbt = 0
+#reflink = 0
+
+#[data_section_options]
+#agcount =
+#agsize =
+#name =
+#file = 1
+#size=
+#sunit=
+#su=
+#swidth=
+#sw=
+#noalign = 1
+
+#[inode_options]
+#size =
+#log =
+#perblock =
+#maxpct =
+#align =
+#attr =
+#projid32bit = 1
+#sparse = 1
+
+#[log_section_options]
+#internal = 1
+#logdev =
+#size =
+#version =
+#sunit =
+#su =
+#lazy-count = 1111
+
+#[naming_options]
+#size =
+#log =
+#version =
+#ftype = 1
+
+#[realtime_section_options]
+#rtdev =
+#extsize =
+#size =
+#noalign = 1
+
+#[sector_size]
+#size =
+#log =
diff --git a/include/builddefs.in b/include/builddefs.in
index 4d6bb2d8f6c2..a3af06ad0ef8 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -60,6 +60,7 @@ PKG_LIB_DIR	= @libdir@@libdirsuffix@
 PKG_INC_DIR	= @includedir@/xfs
 DK_INC_DIR	= @includedir@/disk
 PKG_MAN_DIR	= @mandir@
+PKG_ETC_DIR	= @sysconfdir@
 PKG_DOC_DIR	= @datadir@/doc/@pkg_name@
 PKG_LOCALE_DIR	= @datadir@/locale
 
@@ -154,6 +155,7 @@ endif
 
 GCFLAGS = $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
+	  -DROOT_SYSCONFDIR=\"$(PKG_ETC_DIR)\"  \
 	  -DPACKAGE=\"$(PKG_NAME)\" -I$(TOPDIR)/include -I$(TOPDIR)/libxfs
 
 ifeq ($(ENABLE_GETTEXT),yes)
diff --git a/include/buildmacros b/include/buildmacros
index a7c5d8ae2649..97b335fa615d 100644
--- a/include/buildmacros
+++ b/include/buildmacros
@@ -117,6 +117,12 @@ INSTALL_MAN = \
 		done; \
 	done
 
+INSTALL_ETC = \
+	@for d in $(ETC_FILES); do \
+		echo $(INSTALL) $d -m 644 $(ETC_DEST); \
+		$(INSTALL) -m 644 $${d} $(ETC_DEST) ; \
+	done
+
 ifeq ($(ENABLE_GETTEXT),yes)
 INSTALL_LINGUAS = \
 	@for l in $(LINGUAS) ""; do \
diff --git a/man/man5/mkfs.xfs.conf b/man/man5/mkfs.xfs.conf
new file mode 100644
index 000000000000..38b4ff6763b9
--- /dev/null
+++ b/man/man5/mkfs.xfs.conf
@@ -0,0 +1,113 @@
+.TH mkfs.xfs.conf 5
+.SH NAME
+mkfs.xfs.conf \- Configuration file for mkfs.xfs
+.SH DESCRIPTION
+.BR mkfs.xfs.conf (5)
+is the configuration for
+.BR mkfs.xfs (8).
+It controls the default parameters used by
+.BR mkfs.xfs (8)
+when it is creating an
+.BR xfs (5)
+filesystem.
+.PP
+The
+.BR mkfs.xfs.conf (5)
+file is optional, but if used any command line options passed directly
+.BR mkfs.xfs (8)
+always override configuration file options. The
+.BR mkfs.xfs.conf (5)
+location defaults to /etc/mkfs.xfs.conf, you can however override
+the default configuration file used by either using the environment variable
+MKFS_XFS_CONFIG or using the -c argument to
+.BR mkfs.xfs (8).
+Both the default configuration file and the configuration file searched for
+if MKFS_XFS_CONFIG is set are treated as an optional, if these files are
+present default options set by
+.BR mkfs.xfs (8)
+will be used. If you however use the -c argument to
+.BR mkfs.xfs (8)
+the configuration file will be required to be present. To verify what
+configuration file is used by
+.BR mkfs.xfs (8)
+you can use the -N argument to
+.BR mkfs.xfs (8)
+to look for the config-file path.
+The
+.BR mkfs.xfs.conf (5)
+file uses an INI-style format. Stanzas, or top-level sections, are delimited
+by square braces: [ ]. Within each section, each line defines a relation
+which assigns tags to values. Spaces and tabs are ignored. An example of the
+INI-style format used by this configuration file follows below:
+.P
+	# Some comment
+.br
+	[block_size_options]
+.br
+	log = 10
+.br
+.P
+	# More comments
+.br
+	[data_section_options]
+.br
+	agcount = 20
+.P
+Comments are delimited by a semicolon (';') or a hash ('#') character at the
+beginning of the comment, and are terminated by the end of line character.
+.P
+The following are valid stanzas allowed in the
+.BR mkfs.xfs.conf (5)
+file.  All allowed tag and corresponding allowed values for each stanza are
+documented on the
+.BR mkfs.xfs (8)
+manual, each allowed tag corresponds to the allowed tags under each
+corresponding stanza on the manual. There are a few options part of
+.BR mkfs.xfs (8)
+which do not have a dedicated stanza, and as such there is no support
+to specify them in the configuration file. Only the stanzas
+described below are allowed on the configuration file:
+.TP
+.I [block_size_options]
+Contains options which specify the fundamental block size of the filesystem.
+.TP
+.I [global_metadata_options]
+Contains options which specify metadata format options that either apply to
+the entire filesystem or aren't easily characterised by a specific
+functionality group.
+.TP
+.I [data_section_options]
+Contains options which specify the location, size, and other parameters of the
+data section of the filesystem.
+.TP
+.I [inode_options]
+Contains options which specifies the inode size of the filesystem, and other
+inode allocation parameters.
+.TP
+.I [log_section_options]
+Contains options which specify the location, size, and other parameters of the
+log section of the filesystem.
+.TP
+.I [naming_options]
+Contains options which specify the version and size parameters for the naming
+(directory) area of the filesystem.
+.TP
+.I [realtime_section_options]
+Contains options which specify the location, size, and other parameters of the
+real-time section of the filesystem.
+.TP
+.I [sector_size]
+Contains options which specify the fundamental sector size of the filesystem.
+.P
+
+.SH SEE ALSO
+.BR xfs (5)
+.BR mkfs.xfs (8)
+.BR xfs_growfs (8)
+.BR xfs_admin (8),
+.BR xfsdump (8)
+.BR xfsrestore (8)
+.BR xfsctl (3)
+.BR xfs_info (8),
+.BR chattr (1),
+.BR mount (8)
diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index b2bc223b0e1f..23606dd8d57b 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -83,6 +83,28 @@ and
 .B \-l internal \-l size=10m
 are equivalent.
 .PP
+An optional configuration file
+.B mkfs.xfs.conf (5)
+can also be used to help fine tune default parameters which should be
+used when calling
+.B mkfs.xfs (8).
+Command line arguments directly passed to
+.B mkfs.xfs (8)
+will always override
+.B mkfs.xfs.conf (5)
+configuration parameters. The default
+.B mkfs.xfs.conf (5)
+used is /etc/mkfs.xfs.conf, you can however override this either
+by using the MKFS_XFS_CONFIG environment variable or using the
+-c option to
+.B mkfs.xfs (8).
+The
+.B mkfs.xfs.conf (8)
+file will be required to be present if you used the -c argument to
+.B mkfs.xfs (8).
+To verify what configuration file is used use the -N option to
+.B mkfs.xfs (8).
+.PP
 In the descriptions below, sizes are given in sectors, bytes, blocks,
 kilobytes, megabytes, gigabytes, etc.
 Sizes are treated as hexadecimal if prefixed by 0x or 0X,
@@ -123,6 +145,11 @@ Many feature options allow an optional argument of 0 or 1, to explicitly
 disable or enable the functionality.
 .SH OPTIONS
 .TP
+.BI \-c " path-to-custom-mkfs.xfs.conf"
+Override the default
+.B mkfs.xfs.conf
+file used, the full path to your custom must be specified.
+.TP
 .BI \-b " block_size_options"
 This option specifies the fundamental block size of the filesystem.
 The valid
@@ -902,6 +929,7 @@ Prints the version number and exits.
 .SH SEE ALSO
 .BR xfs (5),
 .BR mkfs (8),
+.BR mkfs.xfs.conf (5),
 .BR mount (8),
 .BR xfs_info (8),
 .BR xfs_admin (8).
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 2a3786ece6b6..aa14ef0cddf6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -24,6 +24,8 @@
 #include "xfs_multidisk.h"
 #include "libxcmd.h"
 
+static const char *mkfs_config = ROOT_SYSCONFDIR "/mkfs.xfs.conf";
+
 /*
  * Prototypes for internal functions.
  */
@@ -1330,6 +1332,24 @@ illegal_option(
 	usage();
 }
 
+static void
+reset_opt(
+	struct opt_params	*opts,
+	int			index)
+{
+	struct subopt_param	*sp = &opts->subopt_params[index];
+
+	if (sp->index != index) {
+		fprintf(stderr,
+	("Developer screwed up option parsing (%d/%d)! Please report!\n"),
+			sp->index, index);
+		reqval(opts->name, (char **)opts->subopts, index);
+	}
+
+	sp->seen = false;
+	sp->str_seen = false;
+}
+
 /*
  * Check for conflicts and option respecification.
  */
@@ -1467,6 +1487,7 @@ parse_subopts(
 		while (*p != '\0') {
 			switch (getsubopt(&p, (char **)bopts.subopts, &value)) {
 			case B_LOG:
+				reset_opt(&bopts, B_LOG);
 				params->blocklog = getnum(value, &bopts, B_LOG);
 				blocksize = 1 << params->blocklog;
 				params->blflag = 1;
@@ -1797,6 +1818,107 @@ parse_subopts(
 	}
 }
 
+/* This lets us also add optional funky names for these */
+static int get_subopt_type(char *buffer)
+{
+	if ((strncmp("[bopts]", buffer, 7) == 0) ||
+	    (strncmp("[block_size_options]", buffer, 20) == 0))
+		return 'b';
+	if ((strncmp("[dopts]", buffer, 7) == 0) ||
+	    (strncmp("[data_section_options]", buffer, 22) == 0))
+		return 'd';
+	if ((strncmp("[iopts]", buffer, 7) == 0) ||
+	    (strncmp("[inode_options]", buffer, 15) == 0))
+		return 'i';
+	if ((strncmp("[lopts]", buffer, 7) == 0) ||
+	    (strncmp("[log_section_options]", buffer, 21) == 0))
+		return 'l';
+	if ((strncmp("[mopts]", buffer, 7) == 0) ||
+	    (strncmp("[metadata_options]", buffer, 18) == 0) ||
+	    (strncmp("[global_metadata_options]", buffer, 25) == 0))
+		return 'm';
+	if ((strncmp("[nopts]", buffer, 7) == 0) ||
+	    (strncmp("[naming_options]", buffer, 16) == 0))
+		return 'n';
+	if ((strncmp("[ropts]", buffer, 7) == 0) ||
+	    (strncmp("[realtime_section_options]", buffer, 26) == 0))
+		return 'r';
+	if ((strncmp("[sopts]", buffer, 7) == 0) ||
+	    (strncmp("[sector_size]", buffer, 13) == 0))
+		return 'n';
+	return 0;
+}
+
+static int parse_config(struct mkfs_xfs_opts *params)
+{
+	FILE *fp;
+	char line[80], tag[80], value[80], *buffer = NULL;
+	char *p;
+	int type = 0;
+	int type_set = 0;
+	int ret;
+
+	fp = fopen(mkfs_config, "r");
+	if (!fp)
+		return -ENOENT;
+
+	while (!feof(fp)) {
+		p = fgets(line, sizeof(line), fp);
+		if (!p)
+			continue;
+		if (strlen(line) < 2)
+			continue;
+
+		if (line[0] == '#')
+			continue;
+
+		memset(tag, 0, sizeof(tag));
+		memset(value, 0, sizeof(value));
+
+		if (type_set) {
+			ret = sscanf(line,
+				     " %[^ \t=]"
+				     " = "
+				     "%s ",
+				     tag, value);
+			if (ret == EOF)
+				continue;
+			if (ret == 2) {
+				snprintf(line, sizeof(line), "%s=%s", tag, value);
+				buffer = line;
+			} else {
+				ret = sscanf(line, " [%[^]]s]", tag);
+				if (ret == EOF)
+					continue;
+				if (ret == 1) {
+					snprintf(line, sizeof(line), "[%s]", tag);
+					buffer = line;
+				} else
+					continue;
+			}
+		} else {
+			ret = sscanf(line, " [%[^]]s]", tag);
+			if (ret != 1 || ret == EOF)
+				continue;
+			snprintf(line, sizeof(line), "[%s]", tag);
+			buffer = line;
+		}
+
+		type = get_subopt_type(buffer);
+		if (type) {
+			type_set = type;
+			continue;
+		}
+		if (!type_set)
+			continue;
+
+		parse_subopts(type_set, p, params);
+	}
+	fclose(fp);
+
+	return 0;
+}
+
 static void init_sb_feat_args_default(struct sb_feat_args *sb_feat)
 {
 	sb_feat->finobt = 1;
@@ -1858,6 +1980,8 @@ main(
 	struct fs_topology	ft;
 	struct mkfs_xfs_opts params;
 	struct sb_feat_args *sb_feat = &params.sb_feat;
+	char *tmp_config;
+	int ret;
 
 	memset(&params, 0, sizeof(params));
 	init_sb_feat_args_default(sb_feat);
@@ -1884,8 +2008,20 @@ main(
 	params.xi.isdirect = LIBXFS_DIRECT;
 	params.xi.isreadonly = LIBXFS_EXCLUSIVELY;
 
-	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
+	tmp_config = getenv("MKFS_XFS_CONFIG");
+	if (tmp_config != NULL)
+		mkfs_config = tmp_config;
+
+	parse_config(&params);
+
+	while ((c = getopt(argc, argv, "c:b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
 		switch (c) {
+		case 'c':
+			mkfs_config = optarg;
+			ret = parse_config(&params);
+			if (ret)
+				illegal(optarg, "c");
+			break;
 		case 'C':
 		case 'f':
 			force_overwrite = 1;
@@ -2793,6 +2929,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 
 	if (!qflag || Nflag) {
 		printf(_(
+		   "config-file=%-22s\n"
 		   "meta-data=%-22s isize=%-6d agcount=%lld, agsize=%lld blks\n"
 		   "         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
 		   "         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u, reflink=%u\n"
@@ -2802,6 +2939,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		   "log      =%-22s bsize=%-6d blocks=%lld, version=%d\n"
 		   "         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
 		   "realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
+			mkfs_config,
 			dfile, params.isize, (long long)params.agcount,
 			(long long)params.agsize,
 			"", sectorsize, sb_feat->attr_version,
-- 
2.11.0

