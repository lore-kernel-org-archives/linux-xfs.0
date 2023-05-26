Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45159C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjEZB7n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjEZB7m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:59:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0E6E4A
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:59:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3051F64C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90041C433EF;
        Fri, 26 May 2023 01:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066370;
        bh=33g1mW0KACusG1f2q4vU0f+NgJwa50oePGgq4PUBI3U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=QYpIbaBmNHqE+llby2V5ZMQLoFQrnCMSrG2M0aQ3Eh4MBMdEN6ok9+KaoIlbBkuNF
         mAPwYjgLqLTQ6KMYqt0Km3PlQ4l5FPyk6DWYxGL/heNowJ966lZ6VRnZbUWKnQrY1M
         NRnQm+WCnFYcZalZbon4WSRCTDhrEKLfsquvYNOf115t7NKb5khu8d+ZOwAHIfbDJz
         XKb0dJDc4CbIenbm2U+EPZCSNBg93gkWqGbzoyI44Z46RGdIrsc57NeWaFFGeaKRMV
         9WcSIWwiUDr7mwUtw7biUhc1574p+fed7oUZGEzoQ+T6PDrNwvCwnPZtQaMYp2ZdHg
         Udpi0rD+lQTEQ==
Date:   Thu, 25 May 2023 18:59:30 -0700
Subject: [PATCH 2/3] xfs_scrub: add an optimization-only mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506075585.3746649.380955951854119900.stgit@frogsfrogsfrogs>
In-Reply-To: <168506075558.3746649.11825051260686897396.stgit@frogsfrogsfrogs>
References: <168506075558.3746649.11825051260686897396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index eb0235af9e0..9a0c63df20f 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -4,7 +4,7 @@ xfs_scrub \- check and repair the contents of a mounted XFS filesystem
 .SH SYNOPSIS
 .B xfs_scrub
 [
-.B \-abCemnTvx
+.B \-abCemnpTvx
 ]
 .I mount-point
 .br
@@ -117,6 +117,10 @@ Smaller extents are ignored.
 By default, the percentage threshold is 99%.
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
index e2a8be2c441..ab9c2d14832 100644
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
index 14efe27d92c..a1123d71ec6 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -236,6 +236,12 @@ phase4_func(
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
index ed0179a4fa7..28330cfff53 100644
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
index 0227da5a926..1e45e57cb68 100644
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
index ee29148a2f1..2f685040b9b 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -182,6 +182,7 @@ usage(void)
 	fprintf(stderr, _("  -k           Do not FITRIM the free space.\n"));
 	fprintf(stderr, _("  -m path      Path to /etc/mtab.\n"));
 	fprintf(stderr, _("  -n           Dry run.  Do not modify anything.\n"));
+	fprintf(stderr, _("  -p           Only optimize, do not fix corruptions.\n"));
 	fprintf(stderr, _("  -T           Display timing/usage information.\n"));
 	fprintf(stderr, _("  -v           Verbose output.\n"));
 	fprintf(stderr, _("  -V           Print version.\n"));
@@ -462,6 +463,11 @@ run_scrub_phases(
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
@@ -600,7 +606,7 @@ report_outcome(
 	if (ctx->scrub_setup_succeeded && actionable_errors > 0) {
 		char		*msg;
 
-		if (ctx->mode == SCRUB_MODE_DRY_RUN)
+		if (ctx->mode != SCRUB_MODE_REPAIR)
 			msg = _("%s: Re-run xfs_scrub without -n.\n");
 		else
 			msg = _("%s: Unmount and run xfs_repair.\n");
@@ -714,7 +720,7 @@ main(
 	pthread_mutex_init(&ctx.lock, NULL);
 	ctx.mode = SCRUB_MODE_REPAIR;
 	ctx.error_action = ERRORS_CONTINUE;
-	while ((c = getopt(argc, argv, "a:bC:de:km:no:TvxV")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bC:de:km:no:pTvxV")) != EOF) {
 		switch (c) {
 		case 'a':
 			ctx.max_errors = cvt_u64(optarg, 10);
@@ -762,11 +768,22 @@ main(
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
index d1f0a1289b9..c59c4ef0e31 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -26,6 +26,7 @@ extern bool			use_force_rebuild;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,
+	SCRUB_MODE_PREEN,
 	SCRUB_MODE_REPAIR,
 };
 

