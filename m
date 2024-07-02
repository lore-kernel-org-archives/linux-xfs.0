Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E809449
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882579; cv=none; b=DmA9HrpS8acw0oAm5LlU8/A/SDPSjrmjpIFZ17U5Lc3PTJK50oIAnGTp2IJjlBvgBqqVFKC+vEireUqCwoUIouAvMoNMvxHIXVKix07zVNsHEf9+BLIkhQ6NtH6qpjx5MbAIj3+5YDi7OxzwcaN3Sb6ZsduaIOsqxuqJKUIk1UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882579; c=relaxed/simple;
	bh=h0FtgCksvKvi7oq0CzO0yfRGqYk5akb8pK6N+1igZjs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tiUBUpL4kl5ephcdgvHT4jeXtMHE/llA1/BiQS6M0tmSWSjTAjdTTpzU5vtbSLF5Keq99mJXgPf8Ob2CoMIL+yvLoJSQY4QBVfk3O55M6BY26utiIK8+4mkSvgxHe7SDEUVuMBfEFXsrfXdGixTrmyvzaCAmj4KJMZb0hs+vPFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/VGJG84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/VGJG84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B7BBC116B1;
	Tue,  2 Jul 2024 01:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882579;
	bh=h0FtgCksvKvi7oq0CzO0yfRGqYk5akb8pK6N+1igZjs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R/VGJG84DOd6VFOEnBQbRvW3FP5NjRe0xzax/m0fItzL92Dkld78s/Scy/GalXmcZ
	 tnXfMZ/DJH9iOCsBg9dGihmRKwIzGJ2r2A7g8H/aWmdmKGXswVic6TthOH6jQ0gyvp
	 AE1HwviytLJh5WTEx4tZTMzMvL/TAfiD7wD9PZwi6u/czHFJiqVMRtbfvSPMxKMG5X
	 ibUyUSmS84Ct/gdQOct8qWA2ZHiDLUjp+IHgnS6g44MQPAW5sRAWwMI9dnAXicUHgY
	 MyVD3JHSGUMApr/hLegTkgtfPtOPoOAnEiRnWqQwHMBPwOYfdMTxzlz6JekH6mX118
	 jOh9ePTKuN8lw==
Date: Mon, 01 Jul 2024 18:09:38 -0700
Subject: [PATCH 2/3] xfs_scrub: add an optimization-only mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988120244.2008941.17128913512937380737.stgit@frogsfrogsfrogs>
In-Reply-To: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
References: <171988120209.2008941.9839121054654380693.stgit@frogsfrogsfrogs>
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
index 6154011271e6..1fd122f2a242 100644
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
index 7e6882450d54..885b43e9948d 100644
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
index 451101811c9b..88cb53aeac90 100644
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
index 2883f98af4ab..0258210722ba 100644
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
index 2b6b6274e382..1b0609e7418b 100644
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
index d7cef115deea..bb316f73e02c 100644
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
index b0aa9fcc67b7..4d9a028921b5 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -27,6 +27,7 @@ extern bool			info_is_warning;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,
+	SCRUB_MODE_PREEN,
 	SCRUB_MODE_REPAIR,
 };
 

