Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089E628C009
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 23:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788218858; cv=none; b=HjSmnI/uq4aWKSrztaJPAC3qPrZ/tfpvdnW0Iz+e7yoU/7mn96719roCHK/dt90N5OKo5m0XUmUCrgXarqObOo3zqumpbp1yejrxzpJNPi5Ul4ZHPR7gADBxFTE0KMmcsE1x7pOL4bqEYnTgkw9PUo61dh5XmwLmakW1tBCp0dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788218858; c=relaxed/simple;
	bh=2VLmK8z1qhw2HDg4+LaIA9uxN155ZcyejcAnMT0XkXU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PYQUMTW3IJ5Hh41DZBBkU04WEy1b9hXB+mQybqpnw0s57PXP5XkQwNlecCzfXvEpPY6b+wzfKPmIXwNfSfoBCjSbWS3mLcjVAA9vFHoul/2aoxRbUbQjp1rRIWlD6FjzoiR08A8YZQj3BCkEy4ODxAxD6CjxZk7IakBIJZTJlLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kX6g5TiU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kX6g5TiU"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 826261F000E9;
	Mon, 31 Aug 2026 23:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788218856;
	bh=RAdOq93aFZlSy7BcU8S1HynP++/yN/+Lg+w1L044V90=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kX6g5TiUCyEALMgt9cguhIEG4oDxSpftchLp74fiH68yJbP3vK/Pldllmwkdn7+oy
	 7A+jMxaNHDF5mUe4OyU6H1Spcc/eDKGy23llUiiXqH4XiIGnTRa4yyiGN0+ovHGOCG
	 khUVhRHPwf5GvEnCK/DtxLuuLMTpqftJzZCCwK5axS5hIxWiiS9lxDltwtb0K49+IK
	 woqkedft5UdDHcLeZk0B0uD6cw3I5Vy7YMzkpUYqnPz2zGIFbSjn8+gFNOMeB3GGgN
	 5yLIjoYGl2ShZeZ50pkZq5qkGbbnPKXPJIHzavpMpShTWmbdj9U3ELTWGzb2Jt3z/m
	 Coym/ux0zYWyQ==
Date: Mon, 31 Aug 2026 16:27:36 -0700
Subject: [PATCH 4/5] xfs_spaceman: print configuration file for mounted
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178821870664.2381199.6011402424718513540.stgit@frogsfrogsfrogs>
In-Reply-To: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
References: <178821870568.2381199.9038448943413709082.stgit@frogsfrogsfrogs>
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

