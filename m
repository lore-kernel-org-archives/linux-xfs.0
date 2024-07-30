Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7561D8827
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302284; cv=none; b=cNYuSETdQkZ3FG7ychkmmJTV2ZzDYbb4KouvkGK5dvWeHKN1Gv0qjZ37AwyjNB18z2ma6RorLO8+TDa+pGk9c9RVYIy4jHzz1I5hJ142Ddsumslcy2HYBjcC9yXDrHBMqXkmamo8ovNSRchNwcVuIvT9PQNsgqVHa0YwVKWlMIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302284; c=relaxed/simple;
	bh=8+Di6C745a9HhuKX6lC5dMuZsJkgDwFz08dtvYHetiY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cjnQ8Q3XP08fQKWCigpzyBMbyrMY8cV+JiVHvaAFe0Sekvj5IJffg5NkF2aQj9IPBzaVDyKIdrHl3alCnZLQ7vyrN78Noy7q2Q9iEcP8CfTcYRovBgGeiaXcPbZBPcnRALI4BBmt9ankiZ4gaEOFbtEMgF5uQd2mzV8kOAgKmGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tn7ercWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tn7ercWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A5B0C32786;
	Tue, 30 Jul 2024 01:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722302284;
	bh=8+Di6C745a9HhuKX6lC5dMuZsJkgDwFz08dtvYHetiY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Tn7ercWDrc7Fwz6mujmmdsZwERVH//jykF2ZqSziMljS1e936XXdj5PNmqRQyF6Xj
	 dMfQWZBzn/vESgcBBlG6adnh1QkzaH1Kpv+in/gKVaijZd3zY2R7KNU03LNTB8zwqM
	 dqRn9TQWVNsDdT63uET9KXNI9w3W5DHaJEZEaxyxrE5i3lZ+WaKfrwFGKlW7FYGw9H
	 Gx3EfBEC4bA/185Hq/uesqo2rRfGFggXRDfvSdd0k3OeBLr13qmi1BnVSY5IeMtve9
	 I+6SOD8MvmkNkwtzt+cv0uJp5IDJd28dtTVh/lDTi1mg/DrA/YpUZuf3IhMNUxG5qV
	 HHe7zuZIfO7vw==
Date: Mon, 29 Jul 2024 18:18:03 -0700
Subject: [PATCH 3/6] xfs_scrub: add an optimization-only mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172229850100.1350643.17695303156049884569.stgit@frogsfrogsfrogs>
In-Reply-To: <172229850048.1350643.5520120825070703831.stgit@frogsfrogsfrogs>
References: <172229850048.1350643.5520120825070703831.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a "preen" mode in which we only optimize filesystem metadata.
Repairs will result in early exits.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 man/man8/xfs_scrub.8 |    6 +++++-
 scrub/Makefile       |    2 +-
 scrub/phase4.c       |    6 ++++++
 scrub/repair.c       |    4 +++-
 scrub/scrub.c        |    4 ++--
 scrub/xfs_scrub.c    |   21 +++++++++++++++++++--
 scrub/xfs_scrub.h    |    1 +
 7 files changed, 37 insertions(+), 7 deletions(-)


diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index 615401127..1fd122f2a 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -4,7 +4,7 @@ xfs_scrub \- check and repair the contents of a mounted XFS filesystem
 .SH SYNOPSIS
 .B xfs_scrub
 [
-.B \-abCeMmnTvx
+.B \-abCeMmnpTvx
 ]
 .I mount-point
 .br
@@ -128,6 +128,10 @@ Treat informational messages as warnings.
 This will result in a nonzero return code, and a higher logging level.
 .RE
 .TP
+.B \-p
+Only optimize filesystem metadata.
+If repairs are required, report them and exit.
+.TP
 .BI \-T
 Print timing and memory usage information for each phase.
 .TP
diff --git a/scrub/Makefile b/scrub/Makefile
index 7e6882450..885b43e99 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -16,7 +16,7 @@ LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
 XFS_SCRUB_FAIL_PROG = xfs_scrub_fail
-XFS_SCRUB_ARGS = -n
+XFS_SCRUB_ARGS = -p
 XFS_SCRUB_SERVICE_ARGS = -b
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 451101811..88cb53aea 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -240,6 +240,12 @@ phase4_func(
 	    action_list_empty(ctx->file_repair_list))
 		return 0;
 
+	if (ctx->mode == SCRUB_MODE_PREEN && ctx->corruptions_found) {
+		str_info(ctx, ctx->mntpoint,
+ _("Corruptions found; will not optimize.  Re-run without -p.\n"));
+		return 0;
+	}
+
 	/*
 	 * Check the resource usage counters early.  Normally we do this during
 	 * phase 7, but some of the cross-referencing requires fairly accurate
diff --git a/scrub/repair.c b/scrub/repair.c
index 2883f98af..025821072 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -651,7 +651,9 @@ repair_item_class(
 	unsigned int			scrub_type;
 	int				error = 0;
 
-	if (ctx->mode < SCRUB_MODE_REPAIR)
+	if (ctx->mode == SCRUB_MODE_DRY_RUN)
+		return 0;
+	if (ctx->mode == SCRUB_MODE_PREEN && !(repair_mask & SCRUB_ITEM_PREEN))
 		return 0;
 
 	/*
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 2b6b6274e..1b0609e74 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -174,7 +174,7 @@ _("Filesystem is shut down, aborting."));
 	 * repair if desired, otherwise complain.
 	 */
 	if (is_corrupt(&meta) || xref_disagrees(&meta)) {
-		if (ctx->mode < SCRUB_MODE_REPAIR) {
+		if (ctx->mode != SCRUB_MODE_REPAIR) {
 			/* Dry-run mode, so log an error and forget it. */
 			str_corrupt(ctx, descr_render(&dsc),
 _("Repairs are required."));
@@ -192,7 +192,7 @@ _("Repairs are required."));
 	 * otherwise complain.
 	 */
 	if (is_unoptimized(&meta)) {
-		if (ctx->mode != SCRUB_MODE_REPAIR) {
+		if (ctx->mode == SCRUB_MODE_DRY_RUN) {
 			/* Dry-run mode, so log an error and forget it. */
 			if (group != XFROG_SCRUB_GROUP_INODE) {
 				/* AG or FS metadata, always warn. */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index d7cef115d..bb316f73e 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -183,6 +183,7 @@ usage(void)
 	fprintf(stderr, _("  -k           Do not FITRIM the free space.\n"));
 	fprintf(stderr, _("  -m path      Path to /etc/mtab.\n"));
 	fprintf(stderr, _("  -n           Dry run.  Do not modify anything.\n"));
+	fprintf(stderr, _("  -p           Only optimize, do not fix corruptions.\n"));
 	fprintf(stderr, _("  -T           Display timing/usage information.\n"));
 	fprintf(stderr, _("  -v           Verbose output.\n"));
 	fprintf(stderr, _("  -V           Print version.\n"));
@@ -463,6 +464,11 @@ run_scrub_phases(
 			sp->descr = _("Repair filesystem.");
 			sp->fn = phase4_func;
 			sp->must_run = true;
+		} else if (sp->fn == REPAIR_DUMMY_FN &&
+			   ctx->mode == SCRUB_MODE_PREEN) {
+			sp->descr = _("Optimize filesystem.");
+			sp->fn = phase4_func;
+			sp->must_run = true;
 		}
 
 		/* Skip certain phases unless they're turned on. */
@@ -601,7 +607,7 @@ report_outcome(
 	if (ctx->scrub_setup_succeeded && actionable_errors > 0) {
 		char		*msg;
 
-		if (ctx->mode == SCRUB_MODE_DRY_RUN)
+		if (ctx->mode != SCRUB_MODE_REPAIR)
 			msg = _("%s: Re-run xfs_scrub without -n.\n");
 		else
 			msg = _("%s: Unmount and run xfs_repair.\n");
@@ -725,7 +731,7 @@ main(
 	pthread_mutex_init(&ctx.lock, NULL);
 	ctx.mode = SCRUB_MODE_REPAIR;
 	ctx.error_action = ERRORS_CONTINUE;
-	while ((c = getopt(argc, argv, "a:bC:de:kM:m:no:TvxV")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bC:de:kM:m:no:pTvxV")) != EOF) {
 		switch (c) {
 		case 'a':
 			ctx.max_errors = cvt_u64(optarg, 10);
@@ -776,11 +782,22 @@ main(
 			mtab = optarg;
 			break;
 		case 'n':
+			if (ctx.mode != SCRUB_MODE_REPAIR) {
+				fprintf(stderr, _("Cannot use -n with -p.\n"));
+				usage();
+			}
 			ctx.mode = SCRUB_MODE_DRY_RUN;
 			break;
 		case 'o':
 			parse_o_opts(&ctx, optarg);
 			break;
+		case 'p':
+			if (ctx.mode != SCRUB_MODE_REPAIR) {
+				fprintf(stderr, _("Cannot use -p with -n.\n"));
+				usage();
+			}
+			ctx.mode = SCRUB_MODE_PREEN;
+			break;
 		case 'T':
 			display_rusage = true;
 			break;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index b0aa9fcc6..4d9a02892 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -27,6 +27,7 @@ extern bool			info_is_warning;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,
+	SCRUB_MODE_PREEN,
 	SCRUB_MODE_REPAIR,
 };
 

