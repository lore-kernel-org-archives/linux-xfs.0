Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35A027FD43
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789364946; cv=none; b=ISUlDrka+sqGyppXqeYxR2A+SsUy66929zSGA0krgQG8BHDd3gtzf1RGHhsN81MRvNlYnjUI/WwNAH7sn8qaoRVoOglr/I3tNz2PvotY7UbjDuLDEuK+RxUEVtk+OQTEps4+oDZPfy23aVxi5qHAbQVosCmEYxSpVLlbs4nrgvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789364946; c=relaxed/simple;
	bh=p/RGL4x17yHh2utnjO4TBY3TmWieKsBwTZkYCLqjOWY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jPpEJkPAs5HRsk6fOiuHLlp3k4cDXCUIaxzh0f7CX4VCIgjiLjqNjWCfnMBZXl1ERaJ8zpPEbc7YTJXVPRkVyC5qJBBfWZ8Uu84hkVeSx6ELx+u9LRgw87ZKEmZLR8kUTszin1saK3Amy4Z8FwuFCbKFi4d35ifYkZKCmwvEkRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mY5cnHX6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mY5cnHX6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5B1CA1F000FF;
	Mon, 14 Sep 2026 05:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789364944;
	bh=7qWZGBj8rcUw9TVXvLntg3uafvAhTn3OGM+zHqDYkLA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=mY5cnHX6RzrQuwKUT6QeyitBmBnGpeQCaSUjqzX6Jh+s8QY2nwl1PLKF3v7vqkrwL
	 QS90PTJZd4fKlZrp/QEkj390KWO8WjCZq61sYvI+rTG+Q6b7t/3rKsFBJDyspW3OwR
	 ev0vkY/M0/RWhd5MLtnoJilA+ev7MsTpN7PuV7iH9+cqps9OeickplssrGLzFuZzn/
	 W9iDaMu88rmOfXDhVM+uphSCTHODFp/JLmCK4V8ifhgn44ON2lgC6y0odCKinMdCKG
	 c0LlQGLzVbO/IMpD7KiFtOpRqcSnfdHIDJZg0SJA/KNj740LsADCZVmEh0jYkusPiH
	 BLVLLXgJ3c6/Q==
Date: Sun, 13 Sep 2026 22:49:04 -0700
Subject: [PATCH 4/6] xfs_spaceman: print configuration file for mounted
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178936484532.2108437.17787986492768221844.stgit@frogsfrogsfrogs>
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

Teach xfs_spaceman to emit a mkfs.xfs config file for a mounted
filesystem.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/xfs_spaceman.8 |    7 ++
 spaceman/info.c         |  201 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 208 insertions(+)


diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index 7d2d1ff94eeb55..5d63cd5435b7aa 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -84,6 +84,13 @@ .SH COMMANDS
 .PD
 .RE
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
 The opened file must be a mount point of a XFS filesystem.
diff --git a/spaceman/info.c b/spaceman/info.c
index f6234c4c67aa19..bacc48e8aa796f 100644
--- a/spaceman/info.c
+++ b/spaceman/info.c
@@ -3,12 +3,16 @@
  * Copyright (C) 2018 Oracle.  All Rights Reserved.
  * Author: Darrick J. Wong <darrick.wong@oracle.com>
  */
+#include <sys/quota.h>
 #include "libxfs.h"
 #include "command.h"
 #include "init.h"
 #include "libfrog/paths.h"
 #include "libfrog/fsgeom.h"
+#include "libfrog/fsproperties.h"
+#include "libfrog/fsprops.h"
 #include "space.h"
+#include "include/xqm.h"
 
 static void
 info_help(void)
@@ -51,8 +55,205 @@ static const struct cmdinfo info_cmd = {
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
+	if (ret || !valuelen)
+		goto out_fph;
+
+	*autofsck = fsprop_autofsck_read(valuebuf);
+
+out_fph:
+	fsprops_free_handle(&fph);
+	return ret;
+}
+
+struct qflags_xlate {
+	unsigned int	qs_flag;
+	unsigned int	mkcfg_qflag;
+};
+
+static const struct qflags_xlate qsflags_xlate[] = {
+	{ .qs_flag = XFS_QUOTA_UDQ_ACCT, .mkcfg_qflag = XFS_UQUOTA_ACCT },
+	{ .qs_flag = XFS_QUOTA_UDQ_ENFD, .mkcfg_qflag = XFS_UQUOTA_ENFD },
+	{ .qs_flag = XFS_QUOTA_GDQ_ACCT, .mkcfg_qflag = XFS_GQUOTA_ACCT },
+	{ .qs_flag = XFS_QUOTA_GDQ_ENFD, .mkcfg_qflag = XFS_GQUOTA_ENFD },
+	{ .qs_flag = XFS_QUOTA_PDQ_ACCT, .mkcfg_qflag = XFS_PQUOTA_ACCT },
+	{ .qs_flag = XFS_QUOTA_PDQ_ENFD, .mkcfg_qflag = XFS_PQUOTA_ENFD },
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
+	/* GETQSTAT returns qflags for all quota types, not just user */
+	ret = quotactl(QCMD(Q_XGETQSTAT, USRQUOTA), f->fs_path.fs_name, 0,
+			(void *)&qstat);
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
+	unsigned int		qflags;
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
+	ret = get_qflags(file, &qflags);
+	if (ret) {
+		perror("quotactl");
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
+	ret = xfrog_write_mkfs_config(&file->xfd.fsgeom, qflags, &fsx,
+			autofsck, fp);
+	if (ret) {
+		if (close_fp)
+			perror(argv[optind]);
+		else
+			perror("makecfg");
+		/* fall through to close fp */
+	}
+
+	if (close_fp) {
+		int	ret2 = fclose(fp);
+
+		if (ret2) {
+			perror(argv[optind]);
+			if (!ret)
+				ret = ret2;
+		}
+	}
+
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

