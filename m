Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4754D34AB14
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789364930; cv=none; b=C5l5fQtNwxt6qkd0mO+UeRs1J+TL4KmKlxgKeJsh3Rrhh2eXuR6mSpoDFF7/INURzuWCB6o6VKWczBw52r14cAGmCT9z2zAL79Jp/ygoCir1B6/1IoRVrygtXD4+AOWsRt1QrRuRpEulUl02qLLgavwgri5RHP25XG3uAIXh1nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789364930; c=relaxed/simple;
	bh=AwhCN0a6vVAYZmLTK7iqd4Ov6ct9F//fz/az02wtSA4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IlP+CZcudsXVl+NXyMDhrwQBk3xn0R0tblYIDrCNzybLRXZ3qHEHCzMMmoqfatcmDQyjxZn5xZYehjYf10nKbQnzfvCi8CPFvx/V8Dt2rJwz4ShN/f6EY/K/+fw7HFyvBR9oUTyZoP9CfBO6LHQ5lNCcb1WPZ3dlfS8A+lvxnN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YrhgBFUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YrhgBFUg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C5BAE1F000FF;
	Mon, 14 Sep 2026 05:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789364928;
	bh=z9E2bKQOcxLwtc5SjPvcAXwZiyVFFhmYyixcQIdBhsY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YrhgBFUgnxzMhhXYtd0VMT+HleeYIa2UDvREsaU7PXtxftaNyfMlks870VEuJh4J9
	 SkEHKpEL0FhRWXfuxdEK5xGDi1JEXjZ6YhXlLnppaSsdqb0gjZjy6t5GuqFB0t1Xsq
	 wVazrWAeMzyH8+x8fzWqen96t5lUqm2ochihdgbcPse1qZLVtApiE2PVibgoBVaan3
	 QiMwU/mpAGyqoLfqYqSVQ2UPYqnqRPOt5OImRSYknAQo9OwBZw6B/igfvnoFc0lALQ
	 EHTdSRj88ZH7k3T7jeq290F4CPi4dnT63y6sbSsjDyhacySYQVXEJBZLN0NhjN8izm
	 8uCgEH/MK6fiA==
Date: Sun, 13 Sep 2026 22:48:48 -0700
Subject: [PATCH 3/6] xfs_db: print configuration file for mounted filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178936484514.2108437.4198840757993081663.stgit@frogsfrogsfrogs>
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

Teach xfs_db to emit a mkfs.xfs config file for an unmounted filesystem.
This can be used to create a new filesystem based on an existing image.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/info.c         |  201 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |    7 ++
 2 files changed, 208 insertions(+)


diff --git a/db/info.c b/db/info.c
index 9c233c9c0e6602..9c081aa58208be 100644
--- a/db/info.c
+++ b/db/info.c
@@ -9,6 +9,7 @@
 #include "output.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/logging.h"
+#include "libfrog/fsproperties.h"
 
 static void
 info_help(void)
@@ -276,10 +277,210 @@ static const struct cmdinfo rgresv_cmd = {
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
+	error = xfrog_write_mkfs_config(&geo, mp->m_sb.sb_qflags, &fsx,
+			autofsck, fp);
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
index 89db535d38c9d4..c2d4065944be10 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -969,6 +969,13 @@ .SH COMMANDS
 .BI "help [" command ]
 Print help for one or all commands.
 .TP
+.BI "makecfg [" path ]
+Write a configuration file to the given path that can be re-read by mkfs.xfs
+for a future filesystem format attempt.
+This file will contain only user-visible features.
+Filesystem geometry information is not written to the configuration file.
+If no path is given, the configuration will be printed on standard output.
+.TP
 .B info
 Displays selected geometry information about the filesystem.
 The output will have the same format that

