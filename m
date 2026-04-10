Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81076226D02
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801687; cv=none; b=ANtv+yXHEUJTSXOIosA0Nu2JdXLz/1c3T5wTlD1N6M045j7/qnoNUDJtk1QNMGuWFr6G444HEqJJLTlHe0ix7Py7yR3k6QfupQ9DHmZCx3e5sJB87KhBArMjxBsBwvuYPQvigtio8WqnfOEy+51aM4oX0/B4M+dIytfAzbjs41A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801687; c=relaxed/simple;
	bh=2MH5j3JyMCIqd5MBDh5FDIRmfcGnH31BjoT3DHSEVyU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Eh4KorJt6ER3VoAqOZwTBZXl+f5ro+qRLIeRXvv5hdvbVgzfLpqMqEka0EQWVF2O+JWA/R2NAUtR4l+n1d/9YWJ57vDZob2oXG/Jp5N4nw3QR7/WBhDWitS9Fev2fjg4qJeKdcg0LzGP0AjcnmtISZa+eNKJVDJWPkTyLz/sMYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bVD4km19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bVD4km19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EFCC19421;
	Fri, 10 Apr 2026 06:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801687;
	bh=2MH5j3JyMCIqd5MBDh5FDIRmfcGnH31BjoT3DHSEVyU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bVD4km19HEwn7X6ne7LPZR3OKZx9gtLVmbPtbBlJS9oI8+i1epfiu3/YhNJ+98bcK
	 HCfLn6Z0gmuX2cq2jir8IG8N5GfuS+UK7+C2io6/HA5v0gMlIKNmnZbh6Or7xZ9wB9
	 b8jjEZp7hrVnafnVeM93oH62nPCp7foXPXsGtClUaDikgVPNcdR1H+kyu4L0HMy9cg
	 yOScq9H6m1YVaZJDCZdtdO9GNd8NJ2o3DrLU5lC36cEx1dFqdfCkg9LPhNyCzYwzN3
	 Tvypab0QXJlYGArRRVe4BHQurNGnov3gteMJpqR92MFu87bkZ8nzy+xGnM5HUyb6Lk
	 eMxktv+dnVaCw==
Date: Thu, 09 Apr 2026 23:14:46 -0700
Subject: [PATCH 16/26] xfs_healer: use the autofsck fsproperty to select mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384526.2089237.17948326565329601714.stgit@frogsfrogsfrogs>
In-Reply-To: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
References: <177577384104.2089237.6309276904931285911.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make the xfs_healer background service query the autofsck filesystem
property to figure out which operating mode it should use.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 healer/xfs_healer.h    |    1 
 libfrog/fsproperties.h |    5 ++
 healer/xfs_healer.c    |  103 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 106 insertions(+), 3 deletions(-)


diff --git a/healer/xfs_healer.h b/healer/xfs_healer.h
index 7caa6c66a59c6f..a2a46053928e33 100644
--- a/healer/xfs_healer.h
+++ b/healer/xfs_healer.h
@@ -28,6 +28,7 @@ struct healer_ctx {
 	int			want_repair;
 	int			print_svcname;
 	int			support_check;
+	int			autofsck;
 
 	/* fd and fs geometry for mount */
 	struct xfs_fd		mnt;
diff --git a/libfrog/fsproperties.h b/libfrog/fsproperties.h
index 11d6530bc9a6d6..1cf90d058765b2 100644
--- a/libfrog/fsproperties.h
+++ b/libfrog/fsproperties.h
@@ -52,6 +52,11 @@ bool fsprop_validate(const char *name, const char *value);
 
 #define FSPROP_AUTOFSCK_NAME		"autofsck"
 
+/* filesystem property name for fgetxattr */
+#define VFS_FSPROP_AUTOFSCK_NAME	(FSPROP_NAMESPACE \
+					 FSPROP_NAME_PREFIX \
+					 FSPROP_AUTOFSCK_NAME)
+
 enum fsprop_autofsck {
 	FSPROP_AUTOFSCK_UNSET = 0,	/* do not set property */
 	FSPROP_AUTOFSCK_NONE,		/* no background scrubs */
diff --git a/healer/xfs_healer.c b/healer/xfs_healer.c
index cf26f9c04ef225..95e952ed5cb940 100644
--- a/healer/xfs_healer.c
+++ b/healer/xfs_healer.c
@@ -6,6 +6,7 @@
 #include "xfs.h"
 #include <pthread.h>
 #include <stdlib.h>
+#include <sys/xattr.h>
 
 #include "platform_defs.h"
 #include "libfrog/fsgeom.h"
@@ -13,6 +14,7 @@
 #include "libfrog/healthevent.h"
 #include "libfrog/workqueue.h"
 #include "libfrog/systemd.h"
+#include "libfrog/fsproperties.h"
 #include "xfs_healer.h"
 
 /* Program name; needed for libfrog error reports. */
@@ -195,6 +197,63 @@ healer_nproc(
 	return ctx->foreground ? platform_nproc() : 1;
 }
 
+enum want_repair {
+	WR_REPAIR,
+	WR_LOG_ONLY,
+	WR_EXIT,
+};
+
+/* Determine want_repair from the autofsck filesystem property. */
+static enum want_repair
+want_repair_from_autofsck(
+	struct healer_ctx	*ctx)
+{
+	char			valuebuf[FSPROP_MAX_VALUELEN + 1] = { 0 };
+	enum fsprop_autofsck	shval;
+	ssize_t			ret;
+
+	/*
+	 * Any OS error (including ENODATA) or string parsing error is treated
+	 * the same as an unrecognized value.
+	 */
+	ret = fgetxattr(ctx->mnt.fd, VFS_FSPROP_AUTOFSCK_NAME, valuebuf,
+			FSPROP_MAX_VALUELEN);
+	if (ret < 0)
+		goto no_advice;
+
+	shval = fsprop_autofsck_read(valuebuf);
+	switch (shval) {
+	case FSPROP_AUTOFSCK_NONE:
+		/* don't run at all */
+		ret = WR_EXIT;
+		break;
+	case FSPROP_AUTOFSCK_CHECK:
+	case FSPROP_AUTOFSCK_OPTIMIZE:
+		/* log events, do not repair */
+		ret = WR_LOG_ONLY;
+		break;
+	case FSPROP_AUTOFSCK_REPAIR:
+		/* repair stuff */
+		ret = WR_REPAIR;
+		break;
+	case FSPROP_AUTOFSCK_UNSET:
+		goto no_advice;
+	}
+
+	return ret;
+
+no_advice:
+	/*
+	 * For an unrecognized value, log but do not fix runtime corruption if
+	 * backref metadata are enabled.  If no backref metadata are available,
+	 * the fs is too old so don't run at all.
+	 */
+	if (healer_has_rmapbt(ctx) || healer_has_parent(ctx))
+		return WR_LOG_ONLY;
+
+	return WR_EXIT;
+}
+
 enum mon_state {
 	MON_START,
 	MON_EXIT,
@@ -225,14 +284,46 @@ setup_monitor(
 		goto out_mnt_fd;
 	}
 
-	if (ctx->want_repair) {
-		/* Check that the kernel supports repairs at all. */
-		if (!healer_can_repair(ctx)) {
+	if (ctx->autofsck) {
+		switch (want_repair_from_autofsck(ctx)) {
+		case WR_EXIT:
+			printf("%s: %s\n", ctx->mntpoint,
+ _("Disabling daemon per autofsck directive."));
+			fflush(stdout);
+			close(ctx->mnt.fd);
+			return MON_UNSUPPORTED;
+		case WR_REPAIR:
+			ctx->want_repair = 1;
+			printf("%s: %s\n", ctx->mntpoint,
+ _("Automatically repairing per autofsck directive."));
+			fflush(stdout);
+			break;
+		case WR_LOG_ONLY:
+			ctx->want_repair = 0;
+			if (ctx->log != 0) {
+				printf("%s: %s\n", ctx->mntpoint,
+ _("Only logging errors per autofsck directive."));
+				fflush(stdout);
+			}
+			break;
+		}
+	}
+
+	/* Check that the kernel supports repairs at all. */
+	if (ctx->want_repair && !healer_can_repair(ctx)) {
+		if (!ctx->autofsck) {
 			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
  _("XFS online repair is not supported, exiting"));
 			goto out_mnt_fd;
 		}
 
+		printf("%s: %s\n", ctx->mntpoint,
+ _("XFS online repair is not supported, will report only"));
+		fflush(stdout);
+		ctx->want_repair = 0;
+	}
+
+	if (ctx->want_repair) {
 		/* Check for backref metadata that makes repair effective. */
 		if (!healer_has_rmapbt(ctx))
 			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
@@ -429,6 +520,7 @@ usage(void)
 	fprintf(stderr, _("  --debug       Enable debugging messages.\n"));
 	fprintf(stderr, _("  --everything  Capture all events.\n"));
 	fprintf(stderr, _("  --foreground  Process events as soon as possible.\n"));
+	fprintf(stderr, _("  --no-autofsck Do not use the \"autofsck\" fs property to decide to repair.\n"));
 	fprintf(stderr, _("  --quiet       Do not log health events to stdout.\n"));
 	fprintf(stderr, _("  --repair      Repair corrupt metadata found at runtime.\n"));
 	fprintf(stderr, _("  --supported   Check that health monitoring is supported.\n"));
@@ -442,6 +534,7 @@ enum long_opt_nr {
 	LOPT_EVERYTHING,
 	LOPT_FOREGROUND,
 	LOPT_HELP,
+	LOPT_NO_AUTOFSCK,
 	LOPT_QUIET,
 	LOPT_REPAIR,
 	LOPT_SUPPORTED,
@@ -459,6 +552,7 @@ main(
 		.conlock	= (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER,
 		.log		= 1,
 		.mnt.fd		= -1,
+		.autofsck	= 1,
 	};
 	int			option_index;
 	int			vflag = 0;
@@ -475,6 +569,7 @@ main(
 		[LOPT_EVERYTHING]  = {"everything", no_argument, &ctx.everything, 1 },
 		[LOPT_FOREGROUND]  = {"foreground", no_argument, &ctx.foreground, 1 },
 		[LOPT_HELP]	   = {"help", no_argument, NULL, 0 },
+		[LOPT_NO_AUTOFSCK] = {"no-autofsck", no_argument, &ctx.autofsck, 0 },
 		[LOPT_QUIET]	   = {"quiet", no_argument, &ctx.log, 0 },
 		[LOPT_REPAIR]	   = {"repair", no_argument, &ctx.want_repair, 1 },
 		[LOPT_SUPPORTED]   = {"supported", no_argument, &ctx.support_check, 1 },
@@ -512,6 +607,8 @@ main(
 
 	if (optind != argc - 1)
 		usage();
+	if (ctx.want_repair)
+		ctx.autofsck = 0;
 
 	ctx.mntpoint = argv[optind];
 

