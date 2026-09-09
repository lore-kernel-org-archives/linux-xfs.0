Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3D43A4539
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 06:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933696; cv=none; b=OgeJWhq7w6QntUhYzyYYiFvB4Qz2mbaMZ/QOBwL8vw583BejcHCe5a2x4rwJ5OeOYFcnSXGwPy77yXeel5vyen0fsafmUtt9Ki49eLSlOo3KcK5AeoVKknI8UHUFl+hZSB8of1WkeD0IkZ0NrsMw8RHZU08yxUHnaVHx0tMKFtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933696; c=relaxed/simple;
	bh=fawIoNFFg3/DPb/brNQ05P/58asoFsS+fROD2C/sez0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VDwvCaZdjwvNOKiKD6F7SlEo3WXoGuYayNNYPnzWpWe+EQjvP7F0qY1PSk/1S+HGfDxQyqm9wfSSlqY4ndKE0OHbKBQD4IuWC7pAZz/Q0DU21oxbq4I0GrlnIPuJo2MWQ5zCbDVhsQ3T29dotMuQUMgNCPNchnmIZxCrL0LFmOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ilhXLuss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ilhXLuss"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AFD6C1F00A3D;
	Wed,  9 Sep 2026 06:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933693;
	bh=tJ7HdiOu99LCrwz/PT9IpDWUtWaahs6hf08aH0lbHdI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=ilhXLussIAbruxJBI7O7o+zR6cOkn4g+WM3NB4LHAoui49RBkY4V3WGhrxhgbVF5U
	 3ydMl8BOLtplgkR1ReJr9JWQ7he/TzLgFamn4NRWDfCFAV2OnOC0fx7MaRKhnT8aSx
	 DqqTS2wcQmOUbbKzc72ceOJWdTB+TDnWKg4g8PJD0T2GhONuSmVkgYB9TbpFatuFpN
	 20/J933JgbVL/RmVqplU7isYC2BUksuOzjwSRyRNmAAqKs89Z4rrr+zBmLtI5aPnT5
	 bGegYVoFtlwjLpWWGIlOMq8+aK7mmsrsL7eKjMdC+fQxSkeQqMo7tgRJX45FvX/1kV
	 E0rUSL030Q/dw==
Date: Tue, 08 Sep 2026 23:01:33 -0700
Subject: [PATCH 5/9] makecfg: handle metadir quota options
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178892910621.4047311.16295302909903460048.stgit@frogsfrogsfrogs>
In-Reply-To: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
References: <178892910484.4047311.5337345469992668181.stgit@frogsfrogsfrogs>
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
 libfrog/fsgeom.h      |   11 ++++++-
 configure.ac          |    1 +
 db/info.c             |    3 +-
 include/builddefs.in  |    1 +
 libfrog/fsgeom.c      |   78 ++++++++++++++++++++++++++++++++++++++++++++++++-
 m4/package_libcdev.m4 |   19 ++++++++++++
 mkfs/xfs_mkfs.c       |    4 +--
 spaceman/Makefile     |    4 +++
 spaceman/info.c       |   77 +++++++++++++++++++++++++++++++++++++++++++++++-
 9 files changed, 191 insertions(+), 7 deletions(-)


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
diff --git a/configure.ac b/configure.ac
index 40ccd88aa2a950..8a2505e37c70ab 100644
--- a/configure.ac
+++ b/configure.ac
@@ -195,6 +195,7 @@ if test "$have_listmount" = "yes"; then
 fi
 AC_HAVE_STATMOUNT_SUPPORTED_MASK
 AC_HAVE_FANOTIFY_MOUNTINFO
+AC_HAVE_QUOTACTL_FD
 
 if test "$enable_ubsan" = "yes" || test "$enable_ubsan" = "probe"; then
         AC_PACKAGE_CHECK_UBSAN
diff --git a/db/info.c b/db/info.c
index 939b359fd26677..9c081aa58208be 100644
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
diff --git a/include/builddefs.in b/include/builddefs.in
index 3b52d1afd7031c..5d2e6c1b90ddbe 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -126,6 +126,7 @@ HAVE_LISTMOUNT_NS_FD = @have_listmount_ns_fd@
 HAVE_STATMOUNT_SUPPORTED_MASK = @have_statmount_supported_mask@
 NEED_INTERNAL_STATMOUNT = @need_internal_statmount@
 HAVE_FANOTIFY_MOUNTINFO = @have_fanotify_mountinfo@
+HAVE_QUOTACTL_FD = @have_quotactl_fd@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 26d0870f5d0611..2172310aa102d6 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -264,6 +264,12 @@ enum {
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
 
@@ -300,6 +306,7 @@ struct mkfs_config_opt;
 struct mkfs_config_data {
 	const struct xfs_fsop_geom	*fsgeo;
 	const struct fsxattr		*fsx;
+	unsigned int			qflags;
 	enum fsprop_autofsck		autofsck;
 };
 
@@ -309,9 +316,11 @@ typedef int (*opt_print_fn)(const struct mkfs_config_opt *opt,
 
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
@@ -353,6 +362,26 @@ print_xflag(
 	return 0;
 }
 
+static int
+print_metadir_qflags(
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
@@ -500,6 +529,51 @@ static const struct mkfs_config_section config_sections[] = {
 				.name		= "autofsck",
 				.print_fn	= print_autofsck,
 			},
+			[M_UQUOTA] = {
+				.name		= "uquota",
+				.qflags		= MAKECFG_UQUOTA_ACCT |
+						  MAKECFG_UQUOTA_ENFD,
+				.qflags_mask	= MAKECFG_UQUOTA_ACCT |
+						  MAKECFG_UQUOTA_ENFD,
+				.print_fn	= print_metadir_qflags,
+			},
+			[M_GQUOTA] = {
+				.name		= "gquota",
+				.qflags		= MAKECFG_GQUOTA_ACCT |
+						  MAKECFG_GQUOTA_ENFD,
+				.qflags_mask	= MAKECFG_GQUOTA_ACCT |
+						  MAKECFG_GQUOTA_ENFD,
+				.print_fn	= print_metadir_qflags,
+			},
+			[M_PQUOTA] = {
+				.name		= "pquota",
+				.qflags		= MAKECFG_PQUOTA_ACCT |
+						  MAKECFG_PQUOTA_ENFD,
+				.qflags_mask	= MAKECFG_PQUOTA_ACCT |
+						  MAKECFG_PQUOTA_ENFD,
+				.print_fn	= print_metadir_qflags,
+			},
+			[M_UQNOENFORCE] = {
+				.name		= "uqnoenforce",
+				.qflags		= MAKECFG_UQUOTA_ACCT,
+				.qflags_mask	= MAKECFG_UQUOTA_ACCT |
+						  MAKECFG_UQUOTA_ENFD,
+				.print_fn	= print_metadir_qflags,
+			},
+			[M_GQNOENFORCE] = {
+				.name		= "gqnoenforce",
+				.qflags		= MAKECFG_GQUOTA_ACCT,
+				.qflags_mask	= MAKECFG_GQUOTA_ACCT |
+						  MAKECFG_GQUOTA_ENFD,
+				.print_fn	= print_metadir_qflags,
+			},
+			[M_PQNOENFORCE] = {
+				.name		= "pqnoenforce",
+				.qflags		= MAKECFG_PQUOTA_ACCT,
+				.qflags_mask	= MAKECFG_PQUOTA_ACCT |
+						  MAKECFG_PQUOTA_ENFD,
+				.print_fn	= print_metadir_qflags,
+			},
 			[M_MAX_OPTS] = { },
 		},
 	},
@@ -587,6 +661,7 @@ static const struct mkfs_config_section config_sections[] = {
 int
 xfrog_write_mkfs_config(
 	const struct xfs_fsop_geom		*fsgeo,
+	unsigned int				qflags,
 	const struct fsxattr			*fsx,
 	int					autofsck,
 	FILE					*fp)
@@ -595,6 +670,7 @@ xfrog_write_mkfs_config(
 		.fsgeo				= fsgeo,
 		.fsx				= fsx,
 		.autofsck			= autofsck,
+		.qflags				= qflags,
 	};
 	const struct mkfs_config_section	*section = config_sections;
 	const struct mkfs_config_opt		*opt;
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 9586bc01fe0f25..5c1b6e4667d0ee 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -476,3 +476,22 @@ AC_DEFUN([AC_HAVE_FANOTIFY_MOUNTINFO],
        AC_MSG_RESULT(no))
     AC_SUBST(have_fanotify_mountinfo)
   ])
+
+#
+# Check if we have a quotactl_fd system call (5.14).
+#
+AC_DEFUN([AC_HAVE_QUOTACTL_FD],
+  [AC_MSG_CHECKING([for quotactl_fd])
+    AC_LINK_IFELSE(
+    [AC_LANG_PROGRAM([[
+#define _GNU_SOURCE
+#include <sys/syscall.h>
+#include <unistd.h>
+  ]], [[
+	return syscall(SYS_quotactl_fd);
+  ]])
+    ], have_quotactl_fd=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_quotactl_fd)
+  ])
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 47c18ecdfa2e3d..38a5769188b05a 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -6239,8 +6239,8 @@ main(
 		}
 
 		libxfs_fs_geometry(mp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
-		error = xfrog_write_mkfs_config(&geo, &cli.fsx, cli.autofsck,
-				fp);
+		error = xfrog_write_mkfs_config(&geo, cli.sb_feat.qflags,
+				&cli.fsx, cli.autofsck, fp);
 		if (!error)
 			error = fclose(fp);
 		if (error) {
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 358db9edf5cb73..2e382177e9a8cb 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -30,6 +30,10 @@ ifeq ($(HAVE_GETFSMAP),yes)
 CFILES += freesp.c
 endif
 
+ifeq ($(HAVE_QUOTACTL_FD),yes)
+CFLAGS += -DHAVE_QUOTACTL_FD
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/spaceman/info.c b/spaceman/info.c
index 1ff8bc4fc2915f..b3596332ec1fb7 100644
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
@@ -98,6 +100,69 @@ get_autofsck(
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
+static inline int
+quotactl_fd(
+	int			fd,
+	int			op,
+	int			id,
+	struct fs_quota_stat	*qstat)
+{
+#ifdef HAVE_QUOTACTL_FD
+	return syscall(SYS_quotactl_fd, fd, op, id, qstat);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
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
+	/* XGETQSTAT returns qflags for all quota types, not just user */
+	ret = quotactl_fd(f->xfd.fd, QCMD(Q_XGETQSTAT, USRQUOTA), 0, &qstat);
+	if (ret == -1 && errno == ENOSYS)
+		ret = quotactl(QCMD(Q_XGETQSTAT, USRQUOTA), f->fs_path.fs_name,
+				0, (void *)&qstat);
+	if (ret) {
+		/*
+		 * ENOSYS means quota is not enabled or compiled in; ENODEV
+		 * means that we couldn't find the filesystem in mtab (aka
+		 * the filesystem has been moved).
+		 */
+		if (errno == ENOSYS || errno == ENODEV)
+			return 0;
+		return ret;
+	}
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
@@ -109,6 +174,7 @@ makecfg_f(
 	FILE			*fp;
 	bool			close_fp = false;
 	enum fsprop_autofsck	autofsck;
+	unsigned int		qflags;
 	int			c;
 	int			ret;
 
@@ -145,6 +211,12 @@ makecfg_f(
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
@@ -156,7 +228,8 @@ makecfg_f(
 		close_fp = true;
 	}
 
-	ret = xfrog_write_mkfs_config(&file->xfd.fsgeom, &fsx, autofsck, fp);
+	ret = xfrog_write_mkfs_config(&file->xfd.fsgeom, qflags, &fsx,
+			autofsck, fp);
 	if (ret) {
 		if (close_fp)
 			perror(argv[optind]);

