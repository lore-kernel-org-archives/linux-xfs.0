Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61A53749EA
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 01:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485466; cv=none; b=kcAtTOKVQc1K3Mj8ke9+4RUv/RAvGu+aCmHw4AvwlbGf3ocFndQtXIZ3LjVV5OQR9FejHcrXQhTPDpINL4Dnj1paYI0+cRdj8OQo+VWGiz8eo2y1rbHIsXX1uvv/04aYjKta0QuCcuh3LeMOYteR8R0UKxW1hpcL23dEcagcj1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485466; c=relaxed/simple;
	bh=rM2hLQlDDiFw6Y6bfAY3rikI03MBmTa4n2Q38gdo0EY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=apOdZRvCOaSue5X0111owOuE0IQBABZtlNgw2HmZGRQpbBFWpurdYTofEoX23BT7ikIeOLr46U8BLs11SDh195QYi/30pM1lKcOo0QiEbQzujoU1GrToC/BpP15qkgTk9hG5PCEWdofd4zygvwn+MpMNOeRNsqIVjwxyStlP3U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DzDmewRq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzDmewRq"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7DDA31F000E9;
	Fri,  4 Sep 2026 01:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485464;
	bh=DRaGlf2Plt10Mq1TZ1OP2iJgbW//Wv+kPJchuI0eECc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DzDmewRqo3ib0DlG0y5JEpF+bNt2l7ZV6kIqasRdypRVY1RihJayfNQPQ575bNvue
	 upOKoLpFYbtRmOiSpcnnvrPT9S94+z8E/9LjeuE3/amaqXvRlxgtMrzG/gRmP6OPwx
	 F+/UCnVtZnVfCAoxfv0fKG5NTz+gzRm5+fg1c9hIELO2bTxGh6wJNGGnUeP+AV+sFJ
	 f/Et3zivUVFuiYJLQcdk6SDD8npWkT7T3iz0520XG0qn2ri/CUaK54if8q4vGeF1kP
	 Kk+ENezHerFoqbXJGplSbJVBdb5o2zvyjS+ODPSgy88Y3G+ZqR1LNq+gw92xkQw4np
	 9QuY0P8FH3J5A==
Date: Thu, 03 Sep 2026 18:31:04 -0700
Subject: [PATCH 5/8] makecfg: handle metadir quota options
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178848534949.1052910.5093950459218799636.stgit@frogsfrogsfrogs>
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

A different LOLLM pointed out that the mkfs configuration file generator
should generate config file lines for the quota accounting/enforcement
mkfs options for metadir filesystems, because those quota flags persist
across mounts.  Add the necessary pieces to do that.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libfrog/fsgeom.h |   11 ++++++++-
 db/info.c        |    3 ++
 libfrog/fsgeom.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 mkfs/xfs_mkfs.c  |    4 ++-
 spaceman/info.c  |   51 ++++++++++++++++++++++++++++++++++++++--
 5 files changed, 131 insertions(+), 7 deletions(-)


diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index 1109dd2bcdb4cc..c3d865f0783e52 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -217,7 +217,16 @@ bytes_per_rtgroup(
 		fsgeo->blocksize;
 }
 
+/* These should correspond to XFS_[UGP]UOTA_{ACCT,ENFD} */
+#define MAKECFG_UQUOTA_ACCT	0x0001 /* user quota accounting ON */
+#define MAKECFG_UQUOTA_ENFD	0x0002 /* user quota limits enforced */
+#define MAKECFG_GQUOTA_ACCT	0x0040 /* group quota accounting ON */
+#define MAKECFG_GQUOTA_ENFD	0x0080 /* group quota limits enforced */
+#define MAKECFG_PQUOTA_ACCT	0x0008 /* project quota accounting ON */
+#define MAKECFG_PQUOTA_ENFD	0x0200 /* project quota limits enforced */
+
 int xfrog_write_mkfs_config(const struct xfs_fsop_geom *fsgeo,
-		const struct fsxattr *fsx, int autofsck, FILE *fp);
+		unsigned int qflags, const struct fsxattr *fsx, int autofsck,
+		FILE *fp);
 
 #endif /* __LIBFROG_FSGEOM_H__ */
diff --git a/db/info.c b/db/info.c
index 3621f0b53e031b..ad1933a2e7dedb 100644
--- a/db/info.c
+++ b/db/info.c
@@ -440,7 +440,8 @@ makecfg_f(
 		close_fp = true;
 	}
 
-	error = xfrog_write_mkfs_config(&geo, &fsx, autofsck, fp);
+	error = xfrog_write_mkfs_config(&geo, mp->m_sb.sb_qflags, &fsx,
+			autofsck, fp);
 	if (error) {
 		if (close_fp)
 			perror(argv[optind]);
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index fdb7b96e06b246..f1ca7e73df638a 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -262,6 +262,12 @@ enum {
 	M_BIGTIME,
 	M_METADIR,
 	M_AUTOFSCK,
+	M_UQUOTA,
+	M_GQUOTA,
+	M_PQUOTA,
+	M_UQNOENFORCE,
+	M_GQNOENFORCE,
+	M_PQNOENFORCE,
 	M_MAX_OPTS,
 };
 
@@ -298,6 +304,7 @@ struct mkfs_config_opt;
 struct mkfs_config_data {
 	const struct xfs_fsop_geom	*fsgeo;
 	const struct fsxattr		*fsx;
+	unsigned int			qflags;
 	enum fsprop_autofsck		autofsck;
 };
 
@@ -307,9 +314,11 @@ typedef int (*opt_print_fn)(const struct mkfs_config_opt *opt,
 
 struct mkfs_config_opt {
 	const char		*name;
+	opt_print_fn		print_fn;
 	uint64_t		fsgeom_flag;
 	uint64_t		xflags_flag;
-	opt_print_fn		print_fn;
+	unsigned int		qflags_mask;
+	unsigned int		qflags;
 };
 
 struct mkfs_config_section {
@@ -351,6 +360,26 @@ print_xflag(
 	return 0;
 }
 
+static int
+print_qflags(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	int				ret;
+
+	/* quota flags are only persisted on metadir filesystems */
+	if (!(data->fsgeo->flags & XFS_FSOP_GEOM_FLAGS_METADIR))
+		return 0;
+	if ((data->qflags & opt->qflags_mask) != opt->qflags)
+		return 0;
+
+	ret = fprintf(fp, "%s=1\n", opt->name);
+	if (ret <= 0)
+		return ret;
+	return 0;
+}
+
 static int
 print_projinherit(
 	const struct mkfs_config_opt	*opt,
@@ -497,6 +526,42 @@ static const struct mkfs_config_section config_sections[] = {
 				.name		= "autofsck",
 				.print_fn	= print_autofsck,
 			},
+			[M_UQUOTA] = {
+				.name		= "uquota",
+				.qflags		= MAKECFG_UQUOTA_ACCT | MAKECFG_UQUOTA_ENFD,
+				.qflags_mask	= MAKECFG_UQUOTA_ACCT | MAKECFG_UQUOTA_ENFD,
+				.print_fn	= print_qflags,
+			},
+			[M_GQUOTA] = {
+				.name		= "gquota",
+				.qflags		= MAKECFG_GQUOTA_ACCT | MAKECFG_GQUOTA_ENFD,
+				.qflags_mask	= MAKECFG_GQUOTA_ACCT | MAKECFG_GQUOTA_ENFD,
+				.print_fn	= print_qflags,
+			},
+			[M_PQUOTA] = {
+				.name		= "pquota",
+				.qflags		= MAKECFG_PQUOTA_ACCT | MAKECFG_PQUOTA_ENFD,
+				.qflags_mask	= MAKECFG_PQUOTA_ACCT | MAKECFG_PQUOTA_ENFD,
+				.print_fn	= print_qflags,
+			},
+			[M_UQNOENFORCE] = {
+				.name		= "uqnoenforce",
+				.qflags		= MAKECFG_UQUOTA_ACCT,
+				.qflags_mask	= MAKECFG_UQUOTA_ACCT | MAKECFG_UQUOTA_ENFD,
+				.print_fn	= print_qflags,
+			},
+			[M_GQNOENFORCE] = {
+				.name		= "gqnoenforce",
+				.qflags		= MAKECFG_GQUOTA_ACCT,
+				.qflags_mask	= MAKECFG_GQUOTA_ACCT | MAKECFG_GQUOTA_ENFD,
+				.print_fn	= print_qflags,
+			},
+			[M_PQNOENFORCE] = {
+				.name		= "pqnoenforce",
+				.qflags		= MAKECFG_PQUOTA_ACCT,
+				.qflags_mask	= MAKECFG_PQUOTA_ACCT | MAKECFG_PQUOTA_ENFD,
+				.print_fn	= print_qflags,
+			},
 			[M_MAX_OPTS] = { },
 		},
 	},
@@ -584,6 +649,7 @@ static const struct mkfs_config_section config_sections[] = {
 int
 xfrog_write_mkfs_config(
 	const struct xfs_fsop_geom		*fsgeo,
+	unsigned int				qflags,
 	const struct fsxattr			*fsx,
 	int					autofsck,
 	FILE					*fp)
@@ -592,6 +658,7 @@ xfrog_write_mkfs_config(
 		.fsgeo				= fsgeo,
 		.fsx				= fsx,
 		.autofsck			= autofsck,
+		.qflags				= qflags,
 	};
 	const struct mkfs_config_section	*section = config_sections;
 	const struct mkfs_config_opt		*opt;
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5b6dabb76fabfe..5c45e0248d1de6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6229,8 +6229,8 @@ main(
 		}
 
 		libxfs_fs_geometry(mp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
-		error = xfrog_write_mkfs_config(&geo, &cli.fsx, cli.autofsck,
-				fp);
+		error = xfrog_write_mkfs_config(&geo, cli.sb_feat.qflags,
+				&cli.fsx, cli.autofsck, fp);
 		if (error) {
 			perror(cli.makecfg);
 			exit(1);
diff --git a/spaceman/info.c b/spaceman/info.c
index 653b8ff98f5c3f..121556e6bd9909 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
+#include <sys/quota.h>
 #include "libxfs.h"
 #include "command.h"
 #include "init.h"
@@ -11,6 +12,7 @@
 #include "libfrog/fsproperties.h"
 #include "libfrog/fsprops.h"
 #include "space.h"
+#include "include/xqm.h"
 
 static void
 info_help(void)
@@ -88,7 +90,7 @@ get_autofsck(
 		ret = 0;
 		goto out_fph;
 	}
-	if (ret)
+	if (ret || !valuelen)
 		goto out_fph;
 
 	*autofsck = fsprop_autofsck_read(valuebuf);
@@ -98,6 +100,43 @@ get_autofsck(
 	return ret;
 }
 
+struct qflags_xlate {
+	unsigned int	qs_flag;
+	unsigned int	mkcfg_qflag;
+};
+
+static const struct qflags_xlate qsflags_xlate[] = {
+	{ .qs_flag = XFS_QUOTA_UDQ_ACCT, .mkcfg_qflag = MAKECFG_UQUOTA_ACCT },
+	{ .qs_flag = XFS_QUOTA_UDQ_ENFD, .mkcfg_qflag = MAKECFG_UQUOTA_ENFD },
+	{ .qs_flag = XFS_QUOTA_GDQ_ACCT, .mkcfg_qflag = MAKECFG_GQUOTA_ACCT },
+	{ .qs_flag = XFS_QUOTA_GDQ_ENFD, .mkcfg_qflag = MAKECFG_GQUOTA_ENFD },
+	{ .qs_flag = XFS_QUOTA_PDQ_ACCT, .mkcfg_qflag = MAKECFG_PQUOTA_ACCT },
+	{ .qs_flag = XFS_QUOTA_PDQ_ENFD, .mkcfg_qflag = MAKECFG_PQUOTA_ENFD },
+};
+
+static int
+get_qflags(
+	struct fileio		*f,
+	unsigned int		*qflags)
+{
+	struct fs_quota_stat	qstat;
+	int			i;
+	int			ret;
+
+	*qflags = 0;
+
+	ret = quotactl(QCMD(Q_XGETQSTAT, 0), f->fs_path.fs_name, 0,
+			(void *)&qstat);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(qsflags_xlate); i++)
+		if (qstat.qs_flags & qsflags_xlate[i].qs_flag)
+			*qflags |= qsflags_xlate[i].mkcfg_qflag;
+
+	return 0;
+}
+
 static int makecfg_usage(void);
 
 static int
@@ -109,6 +148,7 @@ makecfg_f(
 	FILE			*fp;
 	bool			close_fp = false;
 	enum fsprop_autofsck	autofsck;
+	unsigned int		qflags;
 	int			c;
 	int			ret;
 
@@ -145,6 +185,12 @@ makecfg_f(
 		return 1;
 	}
 
+	ret = get_qflags(file, &qflags);
+	if (ret) {
+		perror("quotactl");
+		return 1;
+	}
+
 	if (optind == argc) {
 		fp = stdout;
 	} else {
@@ -156,7 +202,8 @@ makecfg_f(
 		close_fp = true;
 	}
 
-	ret = xfrog_write_mkfs_config(&file->xfd.fsgeom, &fsx, autofsck, fp);
+	ret = xfrog_write_mkfs_config(&file->xfd.fsgeom, qflags, &fsx,
+			autofsck, fp);
 	if (ret) {
 		if (close_fp)
 			perror(argv[optind]);

