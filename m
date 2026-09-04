Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736C0372075
	for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2026 01:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788485450; cv=none; b=rC7juyaf+t+Tx+nvkrIavct3j2eDaMo34N82HTmXVYD4wmF0/57Hdxn2DXnh/MEbgg7LLBN0D8jKoagR5IwN2lstOqdLVDOYYM0N6I2lUb2+8rIIMp65E5HEnBPo5zBWxDqUNW2zRJ3q5oTmMgsQLug/7iJ9iju5rIxWfGdLgZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788485450; c=relaxed/simple;
	bh=86QbzD1+A3+wnrQxo0gXo/XfAINuXa+DB/NFt4EpJnc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fiD68h94zJq5CE35oyc70FSUpZzgcXR67Vcn9UPe6H0hvylZVLYQwdcMr9GXKpz/OR3U8ihjShPG7/gAW/uPb91xrc7hTwHI0gF7szgaKopOWVfO691hYhLuXId4cPk5bhKNiNFp/WQ6mPcuPYKZG5eLbF3Apg/H6Wn8LqMy6I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nF9ajQ3V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nF9ajQ3V"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F32AA1F000E9;
	Fri,  4 Sep 2026 01:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788485449;
	bh=I01NL0yyWY1UpVpy83KoIW8mMFeYNDpNX8tmJnfqztI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=nF9ajQ3V1087cl76sVu8TbvfrKbJ81rWJECn96DGN916jzJPmmpjDC+JB2UX8UzXJ
	 o5g2H+HnEfBXRDEVH8ncSqRL+M8THaAtXkh9U5xeYsxYDdeETC5MNDgF2SmJx2Matc
	 nJOk0pDLP3+tT+WgF6BcXhydQ1CdBZDiyKungA82NYpWsqGTbXYh6twxC5th1bdal9
	 r1n3aijz+mFgznal7FMLweFp1IzQzHrYF/bGiWvlO9peAtQEmMu97tIY1pfreQD+X3
	 MuRcpXpkIhEcHvEGzybHAcMPJEElDDFYbt091Ctj7E2YDeMS7CD+YWbLaMB0Lp8LhV
	 OTdWAsdhDc9gQ==
Date: Thu, 03 Sep 2026 18:30:48 -0700
Subject: [PATCH 4/8] xfs_spaceman: print configuration file for mounted
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178848534932.1052910.5780097091276418088.stgit@frogsfrogsfrogs>
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

Teach xfs_spaceman to emit a mkfs.xfs config file for a mounted
filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 man/man8/xfs_spaceman.8 |    6 ++
 spaceman/info.c         |  136 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 142 insertions(+)


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index 7d2d1ff94eeb55..26ff35ab59f2ec 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -84,6 +84,12 @@ .SH COMMANDS
 .PD
 .RE
 .TP
+.BI "makecfg [" path ]
+Write a configuration file to the given path that can be re-read by mkfs.xfs
+for a future filesystem format attempt.
+This file will contain only user-visible features.
+If no path is given, the configuration will be printed on standard output.
+.TP
 .B info
 Displays selected geometry information about the filesystem.
 The opened file must be a mount point of a XFS filesystem.
diff --git a/spaceman/info.c b/spaceman/info.c
index f6234c4c67aa19..653b8ff98f5c3f 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -8,6 +8,8 @@
 #include "init.h"
 #include "libfrog/paths.h"
 #include "libfrog/fsgeom.h"
+#include "libfrog/fsproperties.h"
+#include "libfrog/fsprops.h"
 #include "space.h"
 
 static void
@@ -51,8 +53,142 @@ static const struct cmdinfo info_cmd = {
 	.help =		info_help,
 };
 
+static void
+makecfg_help(void)
+{
+	printf(_(
+"\n"
+" Print a mkfs.xfs configuration file for user-visible filesystem features\n"
+" of the current filesystem.  Geometry information are not printed.\n"
+"\n"
+));
+
+}
+
+static int
+get_autofsck(
+	struct fileio		*f,
+	enum fsprop_autofsck	*autofsck)
+{
+	struct fsprops_handle	fph = { };
+	char			valuebuf[FSPROP_MAX_VALUELEN + 1] = { 0 };
+	size_t			valuelen = FSPROP_MAX_VALUELEN;
+	int			ret;
+
+	*autofsck = FSPROP_AUTOFSCK_UNSET;
+
+	ret = fsprops_open_handle(&f->xfd, &f->fs_path, &fph);
+	if (ret == -1 && errno == EOPNOTSUPP)
+		return 0;
+	if (ret)
+		return ret;
+
+	ret = fsprops_get(&fph, FSPROP_AUTOFSCK_NAME, valuebuf, &valuelen);
+	if (ret == -1 && errno == ENODATA) {
+		ret = 0;
+		goto out_fph;
+	}
+	if (ret)
+		goto out_fph;
+
+	*autofsck = fsprop_autofsck_read(valuebuf);
+
+out_fph:
+	fsprops_free_handle(&fph);
+	return ret;
+}
+
+static int makecfg_usage(void);
+
+static int
+makecfg_f(
+	int			argc,
+	char			**argv)
+{
+	struct fsxattr		fsx = { };
+	FILE			*fp;
+	bool			close_fp = false;
+	enum fsprop_autofsck	autofsck;
+	int			c;
+	int			ret;
+
+	while ((c = getopt(argc, argv, "")) != EOF) {
+		switch (c) {
+		default:
+			fprintf(stderr, _("bad option for makecfg command\n"));
+			return makecfg_usage();
+		}
+	}
+
+	if (optind != argc && optind != argc - 1) {
+		fprintf(stderr, _("bad option for makecfg command\n"));
+		return makecfg_usage();
+	}
+
+	if (fs_table_lookup_mount(file->name) == NULL) {
+		fprintf(stderr, _("%s: Not a XFS mount point.\n"), file->name);
+		return 1;
+	}
+
+	/* ioctl reports bytes, not fsblocks */
+	ret = ioctl(file->xfd.fd, FS_IOC_FSGETXATTR, &fsx);
+	if (ret) {
+		perror(file->name);
+		return 1;
+	}
+	fsx.fsx_extsize /= file->xfd.fsgeom.blocksize;
+	fsx.fsx_cowextsize /= file->xfd.fsgeom.blocksize;
+
+	ret = get_autofsck(file, &autofsck);
+	if (ret) {
+		perror("autofsck");
+		return 1;
+	}
+
+	if (optind == argc) {
+		fp = stdout;
+	} else {
+		fp = fopen(argv[optind], "w");
+		if (!fp) {
+			perror(argv[optind]);
+			return 1;
+		}
+		close_fp = true;
+	}
+
+	ret = xfrog_write_mkfs_config(&file->xfd.fsgeom, &fsx, autofsck, fp);
+	if (ret) {
+		if (close_fp)
+			perror(argv[optind]);
+		else
+			perror("makecfg");
+	}
+
+	if (close_fp)
+		fclose(fp);
+	return ret;
+}
+
+static const struct cmdinfo makecfg_cmd = {
+	.name =		"makecfg",
+	.cfunc =	makecfg_f,
+	.argmin =	0,
+	.argmax =	1,
+	.canpush =	0,
+	.args =		NULL,
+	.flags =	CMD_FLAG_ONESHOT,
+	.oneline =	N_("print mkfs.xfs configuration file"),
+	.help =		makecfg_help,
+};
+
+static int makecfg_usage(void)
+{
+	return command_usage(&makecfg_cmd);
+}
+
 void
 info_init(void)
 {
 	add_command(&info_cmd);
+	add_command(&makecfg_cmd);
 }

