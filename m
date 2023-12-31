Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA226C14C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ihbSezVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AD3C433C7;
	Sun, 31 Dec 2023 23:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063641;
	bh=chMOzlw1fe+YQit4YL9aRYqkgsqbnWXg9auxpU1fJas=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ihbSezVu3NeWNp8VSWio7WeQu9DDLq/QoRAuWV2K6vqNoHZExuJHnTEkMYKeKEMyZ
	 EQ6fF/Wngnh9bZGSTUK560dMA0gTaeu/2Vq//R/WeoS9Nggiobai+IIw3vXglQ+QuV
	 rVU1cSwCspWDFKJVJalKW/Oc36U7dysHcJr+1C5ceZK1M8xadP6WBL6nshuOHrkfO2
	 XaBH0N6I6b4zOUGYG41vU9vDB3vGvu4imsqQBRhUOn69wZXqT+jQ8y/eOflKeazi0z
	 7cTeGNkKRZjuMdi5rdmQzTIYdQxtGnVZACjiJEIaFyp0rZpQ4z03XyasNLX6QH3fr9
	 aWDZjb7eo9gpA==
Date: Sun, 31 Dec 2023 15:00:40 -0800
Subject: [PATCH 2/3] xfs_scrub: add an optimization-only mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405003738.1801869.6513793685557521944.stgit@frogsfrogsfrogs>
In-Reply-To: <170405003711.1801869.9864337837460047947.stgit@frogsfrogsfrogs>
References: <170405003711.1801869.9864337837460047947.stgit@frogsfrogsfrogs>
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
index 6154011271e..1fd122f2a24 100644
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
index 7e14d82ad66..c0fc927f427 100644
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
index 451101811c9..88cb53aeac9 100644
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
index 2883f98af4a..0258210722b 100644
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
index 2b6b6274e38..1b0609e7418 100644
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
index 4912333219d..7c73e4d3cca 100644
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
index b0aa9fcc67b..4d9a028921b 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -27,6 +27,7 @@ extern bool			info_is_warning;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,
+	SCRUB_MODE_PREEN,
 	SCRUB_MODE_REPAIR,
 };
 

