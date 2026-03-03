Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B5625BEF8
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498265; cv=none; b=NRHgGT04ft7POwBNoNgTTvqXsYBIE8XPUMpgxFiky09DOJmiaQKxqsBBmLcUGVxBa46TQOuyUMIF+ZIAzZLMiTsKuDn+QbmURKDolIuMmWXFvPH9yWMGNrz9NqpCvDaD5qzqbTNoSvQgzPzbmeFB3KZZUYSX5ksscTXMn33C0aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498265; c=relaxed/simple;
	bh=cyAdo+evnV1bT+U5cQoqOJJv3j0vBFO3c/AN4h5xVJA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HLBxZ/pb70SV26U8MZkw4Am9mBy7GMJPCO0pKOJfKKlOLmF6An0/iHle5LPyIraEhYZttbzQRa5iqrj67V07D++qbjzlmazm5x9ko0ujSvfrj1O9re7c2nBe207148tV7TWZ+DySCxdbixtAq6HX3auATE/heaPoSzCVAcMOfwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=stOsgEsz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="stOsgEsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF68AC19423;
	Tue,  3 Mar 2026 00:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498264;
	bh=cyAdo+evnV1bT+U5cQoqOJJv3j0vBFO3c/AN4h5xVJA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=stOsgEszqClgde/yt4aSp5wZj2dFjBdgYBzqYzC7glL6WthFp+3e454u/xHVpZLWq
	 +a6DOQbDfn/xo3j60aFKG15jcCx+uWrtYfvyTVhv0w5YQuBoqzK94Gv1fiOpFBdrYq
	 9q09+99Ldx68GqEbM9BN8sF5nbA6jNkA1qzmsjE/xBRjq5M8Y5VpWxg82UmAM9hLnh
	 ZnYWHO7nnpQisRn6F2HCO02sncAyKC2nFoHFkNeBg63gC3glo2IpBg2mEprnzFLBom
	 OGGWc5/6GvfOZU9n5Fw/DLdCq5PaF+ZF86FbLk55jUZ5SZYLhaoIHSWEUn5kLslqu0
	 Jdcrnb6gA1NSw==
Date: Mon, 02 Mar 2026 16:37:44 -0800
Subject: [PATCH 15/26] xfs_healer: use the autofsck fsproperty to select mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783564.482027.13356516089124376837.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
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
---
 healer/xfs_healer.h    |    1 
 libfrog/fsproperties.h |    5 ++
 healer/xfs_healer.c    |  102 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 105 insertions(+), 3 deletions(-)


diff --git a/healer/xfs_healer.h b/healer/xfs_healer.h
index 93cca394e9fdd1..3a8f9a67beb7b6 100644
--- a/healer/xfs_healer.h
+++ b/healer/xfs_healer.h
@@ -27,6 +27,7 @@ struct healer_ctx {
 	int			foreground;
 	int			want_repair;
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
index 69e5368f6ee794..975d28789d5e14 100644
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
@@ -154,6 +156,63 @@ healer_nproc(
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
@@ -175,15 +234,46 @@ setup_monitor(
 		return MON_ERROR;
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
+			return MON_EXIT;
+		case WR_REPAIR:
+			ctx->want_repair = 1;
+			printf("%s: %s\n", ctx->mntpoint,
+ _("Automatically repairing per autofsck directive."));
+			fflush(stdout);
+			break;
+		case WR_LOG_ONLY:
+			ctx->want_repair = 0;
+			ctx->log = 1;
+			printf("%s: %s\n", ctx->mntpoint,
+ _("Only logging errors per autofsck directive."));
+			fflush(stdout);
+			break;
+		}
+	}
+
+	/* Check that the kernel supports repairs at all. */
+	if (ctx->want_repair && !healer_can_repair(ctx)) {
+		if (!ctx->autofsck) {
 			fprintf(stderr, "%s: %s\n", ctx->mntpoint,
  _("XFS online repair is not supported, exiting"));
 			close(ctx->mnt.fd);
 			return MON_ERROR;
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
@@ -390,6 +480,7 @@ usage(void)
 	fprintf(stderr, _("  --debug       Enable debugging messages.\n"));
 	fprintf(stderr, _("  --everything  Capture all events.\n"));
 	fprintf(stderr, _("  --foreground  Process events as soon as possible.\n"));
+	fprintf(stderr, _("  --no-autofsck Do not use the \"autofsck\" fs property to decide to repair.\n"));
 	fprintf(stderr, _("  --quiet       Do not log health events to stdout.\n"));
 	fprintf(stderr, _("  --repair      Always repair corrupt metadata.\n"));
 	fprintf(stderr, _("  --supported   Check that health monitoring is supported.\n"));
@@ -403,6 +494,7 @@ enum long_opt_nr {
 	LOPT_EVERYTHING,
 	LOPT_FOREGROUND,
 	LOPT_HELP,
+	LOPT_NO_AUTOFSCK,
 	LOPT_QUIET,
 	LOPT_REPAIR,
 	LOPT_SUPPORTED,
@@ -418,6 +510,7 @@ main(
 	struct healer_ctx	ctx = {
 		.conlock	= (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER,
 		.log		= 1,
+		.autofsck	= 1,
 	};
 	int			option_index;
 	int			vflag = 0;
@@ -434,6 +527,7 @@ main(
 		[LOPT_EVERYTHING]  = {"everything", no_argument, &ctx.everything, 1 },
 		[LOPT_FOREGROUND]  = {"foreground", no_argument, &ctx.foreground, 1 },
 		[LOPT_HELP]	   = {"help", no_argument, NULL, 0 },
+		[LOPT_NO_AUTOFSCK] = {"no-autofsck", no_argument, &ctx.autofsck, 0 },
 		[LOPT_QUIET]	   = {"quiet", no_argument, &ctx.log, 0 },
 		[LOPT_REPAIR]	   = {"repair", no_argument, &ctx.want_repair, 1 },
 		[LOPT_SUPPORTED]   = {"supported", no_argument, &ctx.support_check, 1 },
@@ -470,6 +564,8 @@ main(
 
 	if (optind != argc - 1)
 		usage();
+	if (ctx.want_repair)
+		ctx.autofsck = 0;
 
 	ctx.mntpoint = argv[optind];
 	ctx.fsname = find_fsname(ctx.mntpoint);

