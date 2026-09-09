Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653F83A5431
	for <linux-xfs@vger.kernel.org>; Wed,  9 Sep 2026 06:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788933664; cv=none; b=JHDFTTWt/1iwja1EXGbvB7yK2oMwP33Gkja5ZA2guzxShVCyHxwYTZGBABSG3mwW2L4u5fPfrnmKgOclExfqZ6S+6s1HdzKY7uW/tdQmWXfNV4AjisAzrkuL0KgDtcL08wFWZ9QCnCl+wCoOC+YWqEBwYVerQOvpb0/dOqcOOG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788933664; c=relaxed/simple;
	bh=s7HyfWRu0dVDdihlVdoximlRUbG1crDawKENAR5wWRA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M2hm6LJ2j2t7AVtOFqHoyjwGaRkjYXdj/7LoJ3p891/sbugo7XjohKHENgSZSZSBY+aFDjaq7vWtiN7VZEyOUN3G62LnHq+hUFt3P2JW8RgrtG9pR4jQap0Bb0p6fbzOC0g/JNoN6eT+RjGjO8oV2vc1KPa9B69h9k1v44+Txgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QM8G+fiw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QM8G+fiw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A00991F00A3D;
	Wed,  9 Sep 2026 06:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788933662;
	bh=VD9P7ujH4H87d4IbwGk1C007zrmDf8j7oRL/xxZGMCc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=QM8G+fiwdzMF7T+qLHaopcNEJkIkZ90u4mFWGaJkxy78/5OqULnftO+LtTSgwJOOS
	 1Kz8erwFirso5XB2o6k3Gq5ilA+XWtWW5vAIIiBxHOJdHwu1I26UTQbaBkFCie6O5c
	 F7Gq9OEAmmKp9R3jWI4glbIc6X5FXGMrm2ZvgDDli22ciHlMjZ5J5LeMhYYVeZ6xtv
	 w+BNYj8+TELbNzqMj1Y+oVrm1dIc8vCHdICTaRd3PKemQBvm8C3yg5xnF7PBpJsED6
	 2aAsVX6J1fEwIGM58UdS7bfMXBPoeUtaYbbsHryVjjxMcY3tg9xInGMY3HQaHRL6zw
	 WuoEdUPpwlHPA==
Date: Tue, 08 Sep 2026 23:01:02 -0700
Subject: [PATCH 3/9] xfs_db: print configuration file for mounted filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178892910584.4047311.15010657722532410043.stgit@frogsfrogsfrogs>
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

Teach xfs_db to emit a mkfs.xfs config file for an unmounted filesystem.
This can be used to create a new filesystem based on an existing image.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 db/info.c         |  200 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |    6 ++
 2 files changed, 206 insertions(+)


diff --git a/db/info.c b/db/info.c
index 9c233c9c0e6602..939b359fd26677 100644
--- a/db/info.c
+++ b/db/info.c
@@ -9,6 +9,7 @@
 #include "output.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/logging.h"
+#include "libfrog/fsproperties.h"
 
 static void
 info_help(void)
@@ -276,10 +277,209 @@ static const struct cmdinfo rgresv_cmd = {
 	.help =		rgresv_help,
 };
 
+static void
+makecfg_help(void)
+{
+	dbprintf(_(
+"\n"
+" Print a mkfs.xfs configuration file for user-visible filesystem features\n"
+" of the current filesystem.  Geometry information are not printed.\n"
+"\n"
+));
+
+}
+static void
+fill_fsxattr(
+	struct xfs_inode	*ip,
+	struct fsxattr		*fa)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
+
+	fa->fsx_xflags = xfs_ip2xflags(ip);
+
+	if (ip->i_diflags & XFS_DIFLAG_EXTSIZE) {
+		fa->fsx_extsize = ip->i_extsize;
+	} else if (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
+		/*
+		 * Don't let a misaligned extent size hint on a directory
+		 * escape to userspace if it won't pass the setattr checks
+		 * later.
+		 */
+		if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+		    xfs_extlen_to_rtxmod(mp, ip->i_extsize) > 0) {
+			fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE |
+					    FS_XFLAG_EXTSZINHERIT);
+			fa->fsx_extsize = 0;
+		} else {
+			fa->fsx_extsize = ip->i_extsize;
+		}
+	}
+
+	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		/*
+		 * Don't let a misaligned CoW extent size hint on a directory
+		 * escape to userspace if it won't pass the setattr checks
+		 * later.
+		 */
+		if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+		    ip->i_cowextsize % mp->m_sb.sb_rextsize > 0) {
+			fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
+			fa->fsx_cowextsize = 0;
+		} else {
+			fa->fsx_cowextsize = ip->i_cowextsize;
+		}
+	}
+
+	fa->fsx_projid = ip->i_projid;
+	if (ifp && !xfs_need_iread_extents(ifp))
+		fa->fsx_nextents = xfs_iext_count(ifp);
+	else
+		fa->fsx_nextents = xfs_ifork_nextents(ifp);
+}
+
+static int
+get_autofsck(
+	struct xfs_inode	*ip,
+	enum fsprop_autofsck	*autofsck)
+{
+	char			value[FSPROP_MAX_VALUELEN + 1];
+	struct xfs_da_args	args = {
+		.dp		= ip,
+		.geo		= mp->m_attr_geo,
+		.whichfork	= XFS_ATTR_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+		.attr_filter	= LIBXFS_ATTR_ROOT,
+		.owner		= mp->m_sb.sb_rootino,
+		.value		= value,
+		.valuelen	= sizeof(value),
+	};
+	char			*p;
+	int			error;
+
+	*autofsck = FSPROP_AUTOFSCK_UNSET;
+
+	error = fsprop_name_to_attr_name(FSPROP_AUTOFSCK_NAME, &p);
+	if (error < 0)
+		return ENOMEM;
+
+	args.namelen = error;
+	args.name = (const uint8_t *)p;
+
+	libxfs_attr_sethash(&args);
+
+	error = -libxfs_attr_get(&args);
+	if (error == ENODATA) {
+		error = 0;
+		goto out_p;
+	}
+	if (error || !args.valuelen)
+		goto out_p;
+
+	/* raw xattr value is not terminated */
+	value[args.valuelen] = 0;
+	*autofsck = fsprop_autofsck_read(value);
+
+out_p:
+	free(p);
+	return error;
+}
+
+static int
+makecfg_f(
+	int			argc,
+	char			**argv)
+{
+	struct xfs_fsop_geom	geo;
+	struct fsxattr		fsx = { };
+	struct xfs_inode	*ip;
+	FILE			*fp;
+	bool			close_fp = false;
+	enum fsprop_autofsck	autofsck;
+	int			c;
+	int			error;
+
+	while ((c = getopt(argc, argv, "")) != EOF) {
+		switch (c) {
+		default:
+			dbprintf(_("bad option for makecfg command\n"));
+			return 0;
+		}
+	}
+
+	if (optind != argc && optind != argc - 1) {
+		dbprintf(_("bad option for makecfg command\n"));
+		return 0;
+	}
+
+	error = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &ip);
+	if (error) {
+		fprintf(stderr, "root: %s\n", strerror(error));
+		return 1;
+	}
+
+	error = get_autofsck(ip, &autofsck);
+	if (error) {
+		fprintf(stderr, "autofsck: %s\n", strerror(error));
+		error = 1;
+		goto out_ip;
+	}
+
+	fill_fsxattr(ip, &fsx);
+	libxfs_fs_geometry(mp, &geo, XFS_FS_GEOM_MAX_STRUCT_VER);
+
+	if (optind == argc) {
+		fp = stdout;
+	} else {
+		fp = fopen(argv[optind], "w");
+		if (!fp) {
+			perror(argv[optind]);
+			error = 1;
+			goto out_ip;
+		}
+		close_fp = true;
+	}
+
+	error = xfrog_write_mkfs_config(&geo, &fsx, autofsck, fp);
+	if (error) {
+		if (close_fp)
+			perror(argv[optind]);
+		else
+			perror("makecfg");
+		/* fall through to close fp */
+	}
+
+	if (close_fp) {
+		int	err2 = fclose(fp);
+
+		if (err2) {
+			perror(argv[optind]);
+			if (!error)
+				error = err2;
+		}
+	}
+
+out_ip:
+	libxfs_irele(ip);
+	return error;
+}
+
+static const struct cmdinfo makecfg_cmd = {
+	.name =		"makecfg",
+	.cfunc =	makecfg_f,
+	.argmin =	0,
+	.argmax =	1,
+	.canpush =	0,
+	.args =		NULL,
+	.oneline =	N_("print mkfs.xfs configuration file"),
+	.help =		makecfg_help,
+};
+
 void
 info_init(void)
 {
 	add_command(&info_cmd);
 	add_command(&agresv_cmd);
 	add_command(&rgresv_cmd);
+	add_command(&makecfg_cmd);
 }
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 89db535d38c9d4..6cfe9f6b06bde3 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -969,6 +969,12 @@ .SH COMMANDS
 .BI "help [" command ]
 Print help for one or all commands.
 .TP
+.BI "makecfg [" path ]
+Write a configuration file to the given path that can be re-read by mkfs.xfs
+for a future filesystem format attempt.
+This file will contain only user-visible features.
+If no path is given, the configuration will be printed on standard output.
+.TP
 .B info
 Displays selected geometry information about the filesystem.
 The output will have the same format that

