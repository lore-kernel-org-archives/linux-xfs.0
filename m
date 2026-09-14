Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B553374A19
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789364914; cv=none; b=jYgXdMfp3PYfo4tCDQW+h9pXVzSmYvNMc09zxIG8o2MJhbm69sggk+GkJtjWHPiKbDJwNP2RbXB0RCZhQN2MQZ7CWFNx50uOTP53giMCPi/ZGZvDrr/D+dh7fRaa1qyOGvQX4Y3EZIdYEsSExz6uaDOlQKfIlIz/ZUXYC2etfH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789364914; c=relaxed/simple;
	bh=wvOWD+o6YmbNNVSCwIlfnKMFgD6O/5XB8VhkjuI/9gw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ckM3PFHjcQ1C5d5TvEslIKvxC8WBe5E6L7txU5a470ibzfd5z9lpftEPFYHCR6kXDjP4y1lF1lZttsNDjCHlOGZiQTvx90/B/SMQP7wVj5YjjQ4kBfPF5RkUoyLyerW+lKJ8JbQesfdmA0VDBRTduJzeqBi7PiRVSpJaT+raEps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kjmFmKtB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kjmFmKtB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BC0D81F000FF;
	Mon, 14 Sep 2026 05:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789364913;
	bh=9LJCMzg572uENNtMFSb7eqtDH+8cqebleTGobM2yIb8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kjmFmKtBfPg8ou7OODmB+yOUzTt0dmEHWMc6QS65Lg48JPn9RkgTEaq5k9PHw9Akk
	 3E2iyatyTV2dKjh0Tk2ZxFm5gcpDozj1Mmw1uGzz4TTyo80qh/ckUYI3cMbDEa4Zdx
	 scpHn9fWKmU0jYtcDyJH1wv69fWuXosIFvXStGSylh63RL9/wIaJhRBEBsAy1oRJpM
	 CVFiMTYi3ygGF01XHCB4wwb1J+XDt5MyLDnyEFND9vpA0mvYI7GOIsGc54mXT0Ipze
	 2dcmYk/roHy5HUnYA6YVG0eY9PE5R29EtdhQsaulTmAsWk6+cpk47ObZ11tgSg/x3o
	 SqPwYQ+5GCadw==
Date: Sun, 13 Sep 2026 22:48:32 -0700
Subject: [PATCH 2/6] mkfs: print config file for a given mkfs configuration
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178936484495.2108437.2314476861869344064.stgit@frogsfrogsfrogs>
In-Reply-To: <178936484431.2108437.14645667775156303668.stgit@frogsfrogsfrogs>
References: <178936484431.2108437.14645667775156303668.stgit@frogsfrogsfrogs>
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
documenting the user-visible filesystem feature sets of the configured
filesystem.  This can be used to emit default configuration files as we
do once a year for each LTS.

Note that geometry information is not written to the configuration file.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/fsgeom.h       |    4 
 libfrog/fsgeom.c       |  629 ++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/mkfs.xfs.8.in |    8 +
 mkfs/xfs_mkfs.c        |   39 +++
 4 files changed, 679 insertions(+), 1 deletion(-)


diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index b851b9bbf36a58..45e0de31cf0096 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -217,4 +217,8 @@ bytes_per_rtgroup(
 		fsgeo->blocksize;
 }
 
+int xfrog_write_mkfs_config(const struct xfs_fsop_geom *fsgeo,
+		unsigned int qflags, const struct fsxattr *fsx, int autofsck,
+		FILE *fp);
+
 #endif /* __LIBFROG_FSGEOM_H__ */
diff --git a/libfrog/fsgeom.c b/libfrog/fsgeom.c
index 571d376c6b3c28..ad0476741cf5c8 100644
--- a/libfrog/fsgeom.c
+++ b/libfrog/fsgeom.c
@@ -7,6 +7,12 @@
 #include "bitops.h"
 #include "fsgeom.h"
 #include "util.h"
+#include "list.h"
+#include "libfrog/fsproperties.h"
+#include "xfs_arch.h"
+#include "libxfs/xfs_format.h"
+#include "libxfs/xfs_log_format.h"
+#include "xfs_multidisk.h"
 
 static inline const char *
 rtdev_name(
@@ -250,3 +256,626 @@ xfrog_rtgroup_geometry(
 		return -errno;
 	return 0;
 }
+
+enum {
+	B_SIZE = 0,
+	B_MAX_OPTS,
+};
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
+	M_UQUOTA,
+	M_GQUOTA,
+	M_PQUOTA,
+	M_UQNOENFORCE,
+	M_GQNOENFORCE,
+	M_PQNOENFORCE,
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
+	I_PROJID32BIT,
+	I_MAXPCT,
+	I_SIZE,
+	I_MAX_OPTS,
+};
+
+enum {
+	N_PARENT = 0,
+	N_FTYPE,
+	N_VERSION,
+	N_SIZE,
+	N_MAX_OPTS,
+};
+
+enum {
+	R_EXTSIZE = 0,
+	R_MAX_OPTS,
+};
+
+enum {
+	L_LAZYSBCNTR,
+	L_MAX_OPTS,
+};
+
+struct mkfs_config_opt;
+
+struct mkfs_config_data {
+	const struct xfs_fsop_geom	*fsgeo;
+	const struct fsxattr		*fsx;
+	unsigned int			qflags;
+	enum fsprop_autofsck		autofsck;
+};
+
+typedef int (*opt_print_fn)(const struct mkfs_config_opt *opt,
+			    const struct mkfs_config_data *data,
+			    FILE *fp);
+
+struct mkfs_config_opt {
+	const char		*name;
+	opt_print_fn		print_fn;
+	uint64_t		fsgeom_flag;
+	uint64_t		xflags_flag;
+	unsigned int		qflags_mask;
+	unsigned int		qflags;
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
+print_fsgeom_only_if_missing(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	int				ret;
+
+	if (fsgeo->flags & opt->fsgeom_flag)
+		return 0;
+
+	ret = fprintf(fp, "%s=0\n", opt->name);
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
+	const unsigned int		min_rtextsize =
+		max(XFS_MIN_RTEXTSIZE, fsgeo->blocksize) / fsgeo->blocksize;
+	int				ret;
+
+	if (fsgeo->rtextsize > min_rtextsize) {
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
+print_blocksize(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	int				ret;
+
+	if (fsgeo->blocksize != (1U << XFS_DFL_BLOCKSIZE_LOG)) {
+		ret = fprintf(fp, "%s=%u\n", opt->name, fsgeo->blocksize);
+		if (ret <= 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+print_dirsize(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	const unsigned int		min_dirblocksize =
+		max(fsgeo->blocksize, 1U << XFS_MIN_REC_DIRSIZE);
+	int				ret;
+
+	if (fsgeo->dirblocksize > min_dirblocksize) {
+		ret = fprintf(fp, "%s=%u\n", opt->name, fsgeo->dirblocksize);
+		if (ret <= 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static inline uint64_t terablocks(unsigned int nr, unsigned int blocksize)
+{
+	return (nr * (1ULL << 40)) / blocksize;
+}
+
+static inline unsigned int default_imaxpct(const struct xfs_fsop_geom *fsgeo)
+{
+	/*
+	 * This returns the % of the disk space that is used for
+	 * inodes, it changes relatively to the FS size:
+	 *  - over  50 TB, use 1%,
+	 *  - 1TB - 50 TB, use 5%,
+	 *  - under  1 TB, use XFS_DFL_IMAXIMUM_PCT (25%).
+	 */
+
+	if (fsgeo->datablocks < terablocks(1, fsgeo->blocksize))
+		return XFS_DFL_IMAXIMUM_PCT;
+	if (fsgeo->datablocks < terablocks(50, fsgeo->blocksize))
+		return 5;
+	return 1;
+}
+
+static int
+print_imaxpct(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	int				ret;
+
+	if (fsgeo->imaxpct != default_imaxpct(fsgeo)) {
+		ret = fprintf(fp, "%s=%u\n", opt->name, fsgeo->imaxpct);
+		if (ret <= 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static inline unsigned int default_inodesize(const struct xfs_fsop_geom *fsgeo)
+{
+	if (fsgeo->flags & XFS_FSOP_GEOM_FLAGS_V5SB)
+		return 1U << XFS_DINODE_DFL_CRC_LOG;
+	return 1U << XFS_DINODE_DFL_LOG;
+}
+
+static int
+print_inodesize(
+	const struct mkfs_config_opt	*opt,
+	const struct mkfs_config_data	*data,
+	FILE				*fp)
+{
+	const struct xfs_fsop_geom	*fsgeo = data->fsgeo;
+	int				ret;
+
+	if (fsgeo->inodesize != default_inodesize(fsgeo)) {
+		ret = fprintf(fp, "%s=%u\n", opt->name, fsgeo->inodesize);
+		if (ret <= 0)
+			return ret;
+	}
+
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
+		.ini_section = "block",
+		.subopts = {
+			[B_SIZE] = {
+				.name		= "size",
+				.print_fn	= print_blocksize,
+			},
+		},
+	},
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
+			[M_UQUOTA] = {
+				.name		= "uquota",
+				.qflags		= XFS_UQUOTA_ACCT |
+						  XFS_UQUOTA_ENFD,
+				.qflags_mask	= XFS_UQUOTA_ACCT |
+						  XFS_UQUOTA_ENFD,
+				.print_fn	= print_metadir_qflags,
+			},
+			[M_GQUOTA] = {
+				.name		= "gquota",
+				.qflags		= XFS_GQUOTA_ACCT |
+						  XFS_GQUOTA_ENFD,
+				.qflags_mask	= XFS_GQUOTA_ACCT |
+						  XFS_GQUOTA_ENFD,
+				.print_fn	= print_metadir_qflags,
+			},
+			[M_PQUOTA] = {
+				.name		= "pquota",
+				.qflags		= XFS_PQUOTA_ACCT |
+						  XFS_PQUOTA_ENFD,
+				.qflags_mask	= XFS_PQUOTA_ACCT |
+						  XFS_PQUOTA_ENFD,
+				.print_fn	= print_metadir_qflags,
+			},
+			[M_UQNOENFORCE] = {
+				.name		= "uqnoenforce",
+				.qflags		= XFS_UQUOTA_ACCT,
+				.qflags_mask	= XFS_UQUOTA_ACCT |
+						  XFS_UQUOTA_ENFD,
+				.print_fn	= print_metadir_qflags,
+			},
+			[M_GQNOENFORCE] = {
+				.name		= "gqnoenforce",
+				.qflags		= XFS_GQUOTA_ACCT,
+				.qflags_mask	= XFS_GQUOTA_ACCT |
+						  XFS_GQUOTA_ENFD,
+				.print_fn	= print_metadir_qflags,
+			},
+			[M_PQNOENFORCE] = {
+				.name		= "pqnoenforce",
+				.qflags		= XFS_PQUOTA_ACCT,
+				.qflags_mask	= XFS_PQUOTA_ACCT |
+						  XFS_PQUOTA_ENFD,
+				.print_fn	= print_metadir_qflags,
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
+			[I_PROJID32BIT] = {
+				.name		= "projid32bit",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_PROJID32,
+				.print_fn	= print_fsgeom_only_if_missing,
+			},
+			[I_MAXPCT] = {
+				.name		= "maxpct",
+				.print_fn	= print_imaxpct,
+			},
+			[I_SIZE] = {
+				.name		= "size",
+				.print_fn	= print_inodesize,
+			},
+			[I_MAX_OPTS] = { },
+		},
+	},
+	{
+		.ini_section = "log",
+		.subopts = {
+			[L_LAZYSBCNTR] = {
+				.name		= "lazy-count",
+				.fsgeom_flag	= XFS_FSOP_GEOM_FLAGS_LAZYSB,
+				.print_fn	= print_fsgeom_only_if_missing,
+			},
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
+			[N_SIZE] = {
+				.name		= "size",
+				.print_fn	= print_dirsize,
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
+	unsigned int				qflags,
+	const struct fsxattr			*fsx,
+	int					autofsck,
+	FILE					*fp)
+{
+	struct mkfs_config_data			d = {
+		.fsgeo				= fsgeo,
+		.fsx				= fsx,
+		.autofsck			= autofsck,
+		.qflags				= qflags,
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
index c4dee4fe07ae83..ed64e01aec4c55 100644
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
+Filesystem geometry information is not written to the configuration file.
+.TP
 .BI options= name
 The configuration options will be sourced from the file specified by the
 .I name
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 56e6f892e455dc..38a5769188b05a 100644
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
+		  .defaultval = SUBOPT_NEEDS_VAL,
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
@@ -1787,6 +1794,9 @@ cfgfile_opts_parser(
 	case C_OPTFILE:
 		cli->cfgfile = getstr(value, opts, subopt);
 		break;
+	case C_MAKECFG:
+		cli->makecfg = getstr(value, opts, subopt);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -6105,6 +6115,10 @@ main(
 	 */
 	cfgfile_parse(&cli);
 
+	/* Don't create anything if we're merely generating a config file */
+	if (cli.makecfg)
+		dry_run = 1;
+
 	/*
 	 * Extract as much of the valid config as we can from the CLI input
 	 * before opening the libxfs devices.
@@ -6214,6 +6228,29 @@ main(
 
 	validate_supported(mp, &cli);
 
+	if (cli.makecfg) {
+		struct xfs_fsop_geom	geo;
+		FILE			*fp;
+
+		fp = fopen(cli.makecfg, "w+");
+		if (!fp) {
+			perror(cli.makecfg);
+			exit(1);
+		}
+
+		libxfs_fs_geometry(mp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
+		error = xfrog_write_mkfs_config(&geo, cli.sb_feat.qflags,
+				&cli.fsx, cli.autofsck, fp);
+		if (!error)
+			error = fclose(fp);
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

