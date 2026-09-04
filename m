Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C75E372B3B
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 01:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485420; cv=none; b=IDXnGKCE+1sobXWCujisHi+/gkuJt4RzPlZmWgNJYNCvUnzRIIJY6LNKvnqaZGinIYzL9Mrhw25FQL7bLWRDJ9ntqEv/oQnKD7cnqx5V2InLtDN1orLRZp0NceHhA4GqB24zSt94FEFXfJHppK+2TwryHyzPI01EupsKiMouQW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485420; c=relaxed/simple;
	bh=NBuJabL20sNeu3DuOxEEvJpOhGdTkxDj0ZmncqL6xYs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UUSlf51sfKna/r8+Ia/4tNST1MOf0fQ5Fipo9FJ81XRNY3+LU0GR17gqddP4WltkgSTwh+CWoVo6hOrdBURPx86+T/MlgJoUZTQgQj6wUsuIFE+CnF7BwTRveKQTbpVe2KD2sn0PXeJW4elTbVg5wNKxorgLRvIBc5OgUEp9BvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ULV8vCig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ULV8vCig"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E81921F000E9;
	Fri,  4 Sep 2026 01:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485418;
	bh=dlath4I2u3OpaPoSZ5QAXBbn27RCVPmbrinblGH2UAM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ULV8vCig/zCH9t77cfs/404sHfkaZDlnE0ftjB2F01KLcjFtFVWd+sdnqf+irgQ10
	 gXOb7sLldeX3LRR53rTUoRnCjzSna8zMWsIS1AhDWzBZnplhFS8D4PtrKp/CJFqRdw
	 Kp+9IVa9MSXaU+RpS0TrvSiRSUeDf9VsWnzH6BM6zsc/KjkRYTYLnomtwqWDj/5x/T
	 4ltlnyuWWwZcLeGUeItxrw6oVqDDCJir3/QV92Jrg5dBAGEiPLbwAGEFIFi1la3ahc
	 /Xikz+Km9PhWDaZxPe6FdHgmYfcKUUWoZMbVVk9tQQZa7p08kC22xPV4dzEHJj3Pp3
	 aL1WH2oS4AiOw==
Date: Thu, 03 Sep 2026 18:30:17 -0700
Subject: [PATCH 2/8] mkfs: print config file for a given mkfs configuration
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178848534895.1052910.6121106667948017989.stgit@frogsfrogsfrogs>
In-Reply-To: <178848534822.1052910.754281019922260552.stgit@frogsfrogsfrogs>
References: <178848534822.1052910.754281019922260552.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a -c makecfg= switch to mkfs to emit a mkfs.xfs configuration file
documenting the user-visible filesystem featuresets of the configured
filesystem.  This can be used to emit default configuration files as we
do once a year for each LTS.

Note that geometry information is not written to the configuration file.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 libfrog/fsgeom.h       |    3 
 libfrog/fsgeom.c       |  376 ++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/mkfs.xfs.8.in |    8 +
 mkfs/xfs_mkfs.c        |   44 +++++-
 4 files changed, 430 insertions(+), 1 deletion(-)


diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index b851b9bbf36a58..1109dd2bcdb4cc 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -217,4 +217,7 @@ bytes_per_rtgroup(
 		fsgeo->blocksize;
 }
 
+int xfrog_write_mkfs_config(const struct xfs_fsop_geom *fsgeo,
+		const struct fsxattr *fsx, int autofsck, FILE *fp);
+
 #endif /* __LIBFROG_FSGEOM_H__ */
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 571d376c6b3c28..fdb7b96e06b246 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -7,6 +7,8 @@
 #include "bitops.h"
 #include "fsgeom.h"
 #include "util.h"
+#include "list.h"
+#include "libfrog/fsproperties.h"
 
 static inline const char *
 rtdev_name(
@@ -250,3 +252,377 @@ xfrog_rtgroup_geometry(
 		return -errno;
 	return 0;
 }
+
+enum {
+	M_CRC = 0,
+	M_FINOBT,
+	M_RMAPBT,
+	M_REFLINK,
+	M_INOBTCNT,
+	M_BIGTIME,
+	M_METADIR,
+	M_AUTOFSCK,
+	M_MAX_OPTS,
+};
+
+enum {
+	D_RTINHERIT = 0,
+	D_PROJINHERIT,
+	D_EXTSZINHERIT,
+	D_COWEXTSIZE,
+	D_DAXINHERIT,
+	D_MAX_OPTS,
+};
+
+enum {
+	I_SPINODES = 0,
+	I_NREXT64,
+	I_EXCHANGE,
+	I_MAX_OPTS,
+};
+
+enum {
+	N_PARENT = 0,
+	N_FTYPE,
+	N_VERSION,
+	N_MAX_OPTS,
+};
+
+enum {
+	R_EXTSIZE = 0,
+	R_MAX_OPTS,
+};
+
+struct mkfs_config_opt;
+
+struct mkfs_config_data {
+	const struct xfs_fsop_geom	*fsgeo;
+	const struct fsxattr		*fsx;
+	enum fsprop_autofsck		autofsck;
+};
+
+typedef int (*opt_print_fn)(const struct mkfs_config_opt *opt,
+			    const struct mkfs_config_data *data,
+			    FILE *fp);
+
+struct mkfs_config_opt {
+	const char		*name;
+	uint64_t		fsgeom_flag;
+	uint64_t		xflags_flag;
+	opt_print_fn		print_fn;
+};
+
+struct mkfs_config_section {
+	const char		*ini_section;
+	struct mkfs_config_opt	subopts[16];
+};
+
+static int
+print_fsgeom(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	int				ret;
+
+	ret = fprintf(fp, "%s=%d\n", opt->name,
+			!!(fsgeo->flags & opt->fsgeom_flag));
+	if (ret <= 0)
+		return ret;
+	return 0;
+}
+
+static int
+print_xflag(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct fsxattr		*fsx = data->fsx;
+	int				ret;
+
+	if (!(fsx->fsx_xflags & opt->xflags_flag))
+		return 0;
+
+	ret = fprintf(fp, "%s=%d\n", opt->name, 1);
+	if (ret <= 0)
+		return ret;
+	return 0;
+}
+
+static int
+print_projinherit(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct fsxattr		*fsx = data->fsx;
+	int				ret;
+
+	if (fsx->fsx_xflags & FS_XFLAG_PROJINHERIT) {
+		ret = fprintf(fp, "%s=%u\n", opt->name, fsx->fsx_projid);
+		if (ret <= 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+print_extszinherit(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct fsxattr		*fsx = data->fsx;
+	int				ret;
+
+	if (fsx->fsx_xflags & FS_XFLAG_EXTSZINHERIT) {
+		ret = fprintf(fp, "%s=%u\n", opt->name, fsx->fsx_extsize);
+		if (ret <= 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+print_cowextszinherit(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct fsxattr		*fsx = data->fsx;
+	int				ret;
+
+	if (fsx->fsx_xflags & FS_XFLAG_COWEXTSIZE) {
+		ret = fprintf(fp, "%s=%u\n", opt->name, fsx->fsx_cowextsize);
+		if (ret <= 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+print_rtextsize(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	int				ret;
+
+	if (fsgeo->rtextsize > 1) {
+		ret = fprintf(fp, "%s=%u\n", opt->name,
+				fsgeo->rtextsize * fsgeo->blocksize);
+		if (ret <= 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+print_dirversion(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	int				ret;
+
+	if (fsgeo->flags & XFS_FSOP_GEOM_FLAGS_DIRV2CI)
+		ret = fprintf(fp, "%s=ci\n", opt->name);
+	else
+		ret = fprintf(fp, "%s=2\n", opt->name);
+	if (ret <= 0)
+		return ret;
+	return 0;
+}
+
+static int
+print_autofsck(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	int				ret;
+	const char			*value =
+		fsprop_autofsck_write(data->autofsck);
+
+	if (value) {
+		ret = fprintf(fp, "%s=%s\n", opt->name, value);
+		if (ret <= 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static const struct mkfs_config_section config_sections[] = {
+	{
+		.ini_section = "metadata",
+		.subopts = {
+			[M_CRC] = {
+				.name		= "crc",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_V5SB,
+			},
+			[M_FINOBT] = {
+				.name		= "finobt",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_FINOBT,
+			},
+			[M_RMAPBT] = {
+				.name		= "rmapbt",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_RMAPBT,
+			},
+			[M_REFLINK] = {
+				.name		= "reflink",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_REFLINK,
+			},
+			[M_INOBTCNT] = {
+				.name		= "inobtcount",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_INOBTCNT,
+			},
+			[M_BIGTIME] = {
+				.name		= "bigtime",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_BIGTIME,
+			},
+			[M_METADIR] = {
+				.name		= "metadir",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_METADIR,
+			},
+			[M_AUTOFSCK] = {
+				.name		= "autofsck",
+				.print_fn	= print_autofsck,
+			},
+			[M_MAX_OPTS] = { },
+		},
+	},
+	{
+		.ini_section			= "data",
+		.subopts = {
+			[D_RTINHERIT] = {
+				.name		= "rtinherit",
+				.xflags_flag	= FS_XFLAG_RTINHERIT,
+			},
+			[D_PROJINHERIT] = {
+				.name		= "projinherit",
+				.print_fn	= print_projinherit,
+			},
+			[D_EXTSZINHERIT] = {
+				.name		= "extszinherit",
+				.print_fn	= print_extszinherit,
+			},
+			[D_COWEXTSIZE] = {
+				.name		= "cowextsize",
+				.print_fn	= print_cowextszinherit,
+			},
+			[D_DAXINHERIT] = {
+				.name		= "daxinherit",
+				.xflags_flag	= FS_XFLAG_DAX,
+			},
+			[D_MAX_OPTS] = { },
+		},
+	},
+	{
+		.ini_section			= "inode",
+		.subopts = {
+			[I_SPINODES] = {
+				.name		= "sparse",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_SPINODES,
+			},
+			[I_NREXT64] = {
+				.name		= "nrext64",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_NREXT64,
+			},
+			[I_EXCHANGE] = {
+				.name		= "exchange",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE,
+			},
+			[I_MAX_OPTS] = { },
+		},
+	},
+	{
+		.ini_section = "naming",
+		.subopts = {
+			[N_PARENT] = {
+				.name		= "parent",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_PARENT,
+			},
+			[N_FTYPE] = {
+				.name		= "ftype",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_FTYPE,
+			},
+			[N_VERSION] = {
+				.name		= "version",
+				.print_fn	= print_dirversion,
+			},
+		},
+	},
+	{
+		.ini_section = "realtime",
+		.subopts = {
+			[R_EXTSIZE] = {
+				.name		= "extsize",
+				.print_fn	= print_rtextsize,
+			},
+			[R_MAX_OPTS] = { },
+		},
+	},
+};
+
+/*
+ * Write a mkfs.xfs configuration file for the user-visible filesystem features
+ * enabled in the corresponding fs geometry and root directory file attribute
+ * structures.
+ *
+ * Note: The regular and COW extent size hints must be in units of fsblocks,
+ * not bytes.
+ */
+int
+xfrog_write_mkfs_config(
+	const struct xfs_fsop_geom		*fsgeo,
+	const struct fsxattr			*fsx,
+	int					autofsck,
+	FILE					*fp)
+{
+	struct mkfs_config_data			d = {
+		.fsgeo				= fsgeo,
+		.fsx				= fsx,
+		.autofsck			= autofsck,
+	};
+	const struct mkfs_config_section	*section = config_sections;
+	const struct mkfs_config_opt		*opt;
+	int					i, j;
+	int					error;
+
+	for (i = 0; i < ARRAY_SIZE(config_sections); i++, section++) {
+		if (i > 0) {
+			error = fprintf(fp, "\n");
+			if (error <= 0)
+				return error;
+		}
+
+		error = fprintf(fp, "[%s]\n", section->ini_section);
+		if (error <= 0)
+			return error;
+
+		opt = section->subopts;
+		for (j = 0;
+		     j < ARRAY_SIZE(section->subopts) && opt->name;
+		     j++, opt++) {
+			if (opt->print_fn)
+				error = opt->print_fn(opt, &d, fp);
+			else if (opt->xflags_flag)
+				error = print_xflag(opt, &d, fp);
+			else if (opt->fsgeom_flag)
+				error = print_fsgeom(opt, &d, fp);
+			if (error)
+				return error;
+		}
+	}
+
+	return fflush(fp);
+}
diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index c4dee4fe07ae83..f28f668a1e7e68 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -156,6 +156,14 @@ .SH OPTIONS
 is:
 .RS 1.2i
 .TP
+.BI makecfg= path
+Write a configuration file to the file specified by the
+.I path
+option string.
+This file can be re-read by mkfs.xfs for a future filesystem format attempt.
+This file will contain only user-visible features.
+If no path is given, the configuration will be printed on standard output.
+.TP
 .BI options= name
 The configuration options will be sourced from the file specified by the
 .I name
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 74bbb677eee2b6..5b6dabb76fabfe 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -61,6 +61,7 @@ enum {
 
 enum {
 	C_OPTFILE = 0,
+	C_MAKECFG,
 	C_MAX_OPTS,
 };
 
@@ -312,6 +313,7 @@ static struct opt_params copts = {
 	.name = 'c',
 	.subopts = {
 		[C_OPTFILE] = "options",
+		[C_MAKECFG] = "makecfg",
 		[C_MAX_OPTS] = NULL,
 	},
 	.subopt_params = {
@@ -319,6 +321,10 @@ static struct opt_params copts = {
 		  .conflicts = { { NULL, LAST_CONFLICT } },
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
+		{ .index = C_MAKECFG,
+		  .conflicts = { { NULL, LAST_CONFLICT } },
+		  .defaultval = 1,
+		},
 	},
 };
 
@@ -1072,6 +1078,7 @@ struct cli_params {
 
 	char	*cfgfile;
 	char	*protofile;
+	char	*makecfg;
 
 	enum fsprop_autofsck autofsck;
 
@@ -1207,7 +1214,7 @@ usage( void )
 {
 	fprintf(stderr, _("Usage: %s\n\
 /* blocksize */		[-b size=num]\n\
-/* config file */	[-c options=xxx]\n\
+/* config file */	[-c options=path,makecfg=path\n\
 /* metadata */		[-m crc=0|1,finobt=0|1,uuid=xxx,rmapbt=0|1,reflink=0|1,\n\
 			    inobtcount=0|1,bigtime=0|1,autofsck=xxx,\n\
 			    metadir=0|1]\n\
@@ -1787,6 +1794,12 @@ cfgfile_opts_parser(
 	case C_OPTFILE:
 		cli->cfgfile = getstr(value, opts, subopt);
 		break;
+	case C_MAKECFG:
+		if (!value)
+			cli->makecfg = "-";
+		else
+			cli->makecfg = getstr(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -6088,6 +6101,10 @@ main(
 	 */
 	cfgfile_parse(&cli);
 
+	/* Don't create anything if we're merely generating a config file */
+	if (cli.makecfg)
+		dry_run = 1;
+
 	/*
 	 * Extract as much of the valid config as we can from the CLI input
 	 * before opening the libxfs devices.
@@ -6197,6 +6214,31 @@ main(
 
 	validate_supported(mp, &cli);
 
+	if (cli.makecfg) {
+		struct xfs_fsop_geom	geo;
+		FILE			*fp;
+
+		if (!strcmp(cli.makecfg, "-")) {
+			fp = stdout;
+		} else {
+			fp = fopen(cli.makecfg, "w+");
+			if (!fp) {
+				perror(cli.makecfg);
+				exit(1);
+			}
+		}
+
+		libxfs_fs_geometry(mp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
+		error = xfrog_write_mkfs_config(&geo, &cli.fsx, cli.autofsck,
+				fp);
+		if (error) {
+			perror(cli.makecfg);
+			exit(1);
+		}
+
+		exit(0);
+	}
+
 	/* Print the intended geometry of the fs. */
 	if (!quiet || dry_run) {
 		struct xfs_fsop_geom	geo;

