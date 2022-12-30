Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C53BAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:38:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235823AbiLaAip (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaAip (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:38:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4CD1E3EE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:38:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C36DB81E08
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DA1C433EF;
        Sat, 31 Dec 2022 00:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447121;
        bh=8d0vy62hr7zxDNR1y+X7wym6ncPWBgOkyW1o6hMwzjM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GoFEZHJGS3YgPTQHvmedIUvUW/Ub28xOOXDV5HWmnd7JJCqxu2Kwj6VszXb2Yenva
         f5KuzUxPT7iULdVejpECrf590c13xRnt/sRqhRU+ALn/VfAjRMggfn6XiZi4rUUBK9
         bRZ7ML3km3THPWDAYpzjJQ9e+aXTazXGPgaRUlXNT10VN8hvkS4/x8gPue88ewC/sl
         lM3b2q7UyIUuBIFmzdVedZiYZgj//IjIZgbnO1iyJ1I2hwJoRtZCO+M/e/heMdmNDY
         tuTRyx/AflafrSaer9sQWvsh7nKjfxWtEgTw74dyE2y1/LFdwx+4bxy+iQyHqn6QZh
         C0ZbqkE/EbTYA==
Subject: [PATCH 2/2] xfs_scrub: add an optimization-only mode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:41 -0800
Message-ID: <167243872139.718904.8611754562840808360.stgit@magnolia>
In-Reply-To: <167243872112.718904.9124514098518120883.stgit@magnolia>
References: <167243872112.718904.9124514098518120883.stgit@magnolia>
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
index e881ae76acb..cbf12f53b91 100644
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
@@ -86,6 +86,10 @@ Search this file for mounted filesystems instead of /etc/mtab.
 Only check filesystem metadata.
 Do not repair or optimize anything.
 .TP
+.B \-p
+Only optimize filesystem metadata.
+If repairs are required, report them and exit.
+.TP
 .BI \-T
 Print timing and memory usage information for each phase.
 .TP
diff --git a/scrub/Makefile b/scrub/Makefile
index f2d0c1aa0bf..04f2494233d 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -12,7 +12,7 @@ ifeq ($(SCRUB_PREREQS),yesyesyes)
 LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all
-XFS_SCRUB_ARGS = -b -n
+XFS_SCRUB_ARGS = -b -p
 ifeq ($(HAVE_SYSTEMD),yes)
 INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
diff --git a/scrub/phase4.c b/scrub/phase4.c
index 260f7bb7ac1..74fcc55b379 100644
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
index 127055f2f61..6629125578c 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -642,7 +642,9 @@ repair_item_class(
 	unsigned int			scrub_type;
 	int				error = 0;
 
-	if (ctx->mode < SCRUB_MODE_REPAIR)
+	if (ctx->mode == SCRUB_MODE_DRY_RUN)
+		return 0;
+	if (ctx->mode == SCRUB_MODE_PREEN && !(repair_mask & SCRUB_ITEM_PREEN))
 		return 0;
 
 	/*
diff --git a/scrub/scrub.c b/scrub/scrub.c
index c245e46afa7..19c35bfd907 100644
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
index 23d8fec5d9b..8104059ebb4 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -181,6 +181,7 @@ usage(void)
 	fprintf(stderr, _("  -k           Do not FITRIM the free space.\n"));
 	fprintf(stderr, _("  -m path      Path to /etc/mtab.\n"));
 	fprintf(stderr, _("  -n           Dry run.  Do not modify anything.\n"));
+	fprintf(stderr, _("  -p           Only optimize, do not fix corruptions.\n"));
 	fprintf(stderr, _("  -T           Display timing/usage information.\n"));
 	fprintf(stderr, _("  -v           Verbose output.\n"));
 	fprintf(stderr, _("  -V           Print version.\n"));
@@ -461,6 +462,11 @@ run_scrub_phases(
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
@@ -598,7 +604,7 @@ report_outcome(
 	if (ctx->scrub_setup_succeeded && actionable_errors > 0) {
 		char		*msg;
 
-		if (ctx->mode == SCRUB_MODE_DRY_RUN)
+		if (ctx->mode != SCRUB_MODE_REPAIR)
 			msg = _("%s: Re-run xfs_scrub without -n.\n");
 		else
 			msg = _("%s: Unmount and run xfs_repair.\n");
@@ -646,7 +652,7 @@ main(
 	pthread_mutex_init(&ctx.lock, NULL);
 	ctx.mode = SCRUB_MODE_REPAIR;
 	ctx.error_action = ERRORS_CONTINUE;
-	while ((c = getopt(argc, argv, "a:bC:de:km:nTvxV")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bC:de:km:npTvxV")) != EOF) {
 		switch (c) {
 		case 'a':
 			ctx.max_errors = cvt_u64(optarg, 10);
@@ -694,8 +700,19 @@ main(
 			mtab = optarg;
 			break;
 		case 'n':
+			if (ctx.mode != SCRUB_MODE_REPAIR) {
+				fprintf(stderr, _("Cannot use -n with -p.\n"));
+				usage();
+			}
 			ctx.mode = SCRUB_MODE_DRY_RUN;
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
index 2ef8b2e5066..7269b231015 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -25,6 +25,7 @@ extern bool			use_force_rebuild;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,
+	SCRUB_MODE_PREEN,
 	SCRUB_MODE_REPAIR,
 };
 

