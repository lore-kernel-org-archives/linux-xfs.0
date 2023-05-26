Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5492DC7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbjEZBzH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbjEZBzF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:55:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C8AE7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:55:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E12C964C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509F6C433EF;
        Fri, 26 May 2023 01:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066103;
        bh=Qi02TB3eL2BySndvxvUPOtFGDSuSBWd8blCodgnaKiA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=W6jjN0JI7vqt5RhSBOUA2F6Ux69NUeiJZT99VLzHbeK0hQ6yBa4Q7JToj7dEYX5V6
         KA+7B5+1REs9uronthYwpopz/w0gZwmEKOT4F/SwDvOTWnC3fpSiN1tURdsyTuoQlk
         QOs9O2LSjivvR+ESEb4eQKJG72q0J2YZmad831rCfzc7UI9JCPRFwVRcq1bnwi4uLi
         Ph7DNXJSuXXhMUP2SXGIrRQfn7Uv2L3Q67pKXYEuljgQyZUqVykkoq+mkehKyvjIaS
         4YWBKxefpuzF1pcq0s6MEiAIcZ1NlFummDYNZgyaJGTWjvy6AIXWveIgou6K/SVTef
         xXV1TiLGXnhsQ==
Date:   Thu, 25 May 2023 18:55:02 -0700
Subject: [PATCH 1/5] xfs_scrub: allow auxiliary pathnames for sandboxing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506074522.3746099.11941443473290571582.stgit@frogsfrogsfrogs>
In-Reply-To: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
References: <168506074508.3746099.18021671464566915249.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In the next patch, we'll tighten up the security on the xfs_scrub
service so that it can't escape.  However, sanboxing the service
involves making the host filesystem as inaccessible as possible, with
the filesystem to scrub bind mounted onto a known location within the
sandbox.  Hence we need one path for reporting and a new -A argument to
tell scrub what it should actually be trying to open.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 doc/README-env-vars.txt |    2 ++
 scrub/phase1.c          |    4 ++--
 scrub/vfs.c             |    2 +-
 scrub/xfs_scrub.c       |    9 +++++++--
 scrub/xfs_scrub.h       |    5 ++++-
 5 files changed, 16 insertions(+), 6 deletions(-)


diff --git a/doc/README-env-vars.txt b/doc/README-env-vars.txt
index eec59a82513..d7984df8202 100644
--- a/doc/README-env-vars.txt
+++ b/doc/README-env-vars.txt
@@ -24,3 +24,5 @@ XFS_SCRUB_THREADS            -- start exactly this number of threads
 Available even in non-debug mode:
 SERVICE_MODE                 -- compress all error codes to 1 for LSB
                                 service action compliance
+SERVICE_MOUNTPOINT           -- actual path to open for issuing kernel
+                                scrub calls
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 99c7a7a5d28..2a63563cc3d 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -146,7 +146,7 @@ phase1_func(
 	 * CAP_SYS_ADMIN, which we probably need to do anything fancy
 	 * with the (XFS driver) kernel.
 	 */
-	error = -xfd_open(&ctx->mnt, ctx->mntpoint,
+	error = -xfd_open(&ctx->mnt, ctx->actual_mntpoint,
 			O_RDONLY | O_NOATIME | O_DIRECTORY);
 	if (error) {
 		if (error == EPERM)
@@ -199,7 +199,7 @@ _("Not an XFS filesystem."));
 		return error;
 	}
 
-	error = path_to_fshandle(ctx->mntpoint, &ctx->fshandle,
+	error = path_to_fshandle(ctx->actual_mntpoint, &ctx->fshandle,
 			&ctx->fshandle_len);
 	if (error) {
 		str_errno(ctx, _("getting fshandle"));
diff --git a/scrub/vfs.c b/scrub/vfs.c
index 69b4a22d211..e0b2d3e0ef9 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -249,7 +249,7 @@ scan_fs_tree(
 		goto out_cond;
 	}
 
-	ret = queue_subdir(ctx, &sft, &wq, ctx->mntpoint, true);
+	ret = queue_subdir(ctx, &sft, &wq, ctx->actual_mntpoint, true);
 	if (ret) {
 		str_liberror(ctx, ret, _("queueing directory scan"));
 		goto out_wq;
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 04b423c7211..ee29148a2f1 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -119,6 +119,8 @@
  * Available even in non-debug mode:
  * SERVICE_MODE			-- compress all error codes to 1 for LSB
  *				   service action compliance
+ * SERVICE_MOUNTPOINT		-- actual path to open for issuing kernel
+ *				   scrub calls
  */
 
 /* Program name; needed for libfrog error reports. */
@@ -810,6 +812,9 @@ main(
 		usage();
 
 	ctx.mntpoint = argv[optind];
+	ctx.actual_mntpoint = getenv("SERVICE_MOUNTPOINT");
+	if (!ctx.actual_mntpoint)
+		ctx.actual_mntpoint = ctx.mntpoint;
 
 	stdout_isatty = isatty(STDOUT_FILENO);
 	stderr_isatty = isatty(STDERR_FILENO);
@@ -827,7 +832,7 @@ main(
 		return SCRUB_RET_OPERROR;
 
 	/* Find the mount record for the passed-in argument. */
-	if (stat(argv[optind], &ctx.mnt_sb) < 0) {
+	if (stat(ctx.actual_mntpoint, &ctx.mnt_sb) < 0) {
 		fprintf(stderr,
 			_("%s: could not stat: %s: %s\n"),
 			progname, argv[optind], strerror(errno));
@@ -850,7 +855,7 @@ main(
 	}
 
 	fs_table_initialise(0, NULL, 0, NULL);
-	fsp = fs_table_lookup_mount(ctx.mntpoint);
+	fsp = fs_table_lookup_mount(ctx.actual_mntpoint);
 	if (!fsp) {
 		fprintf(stderr, _("%s: Not a XFS mount point.\n"),
 				ctx.mntpoint);
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index dc45e486719..d1f0a1289b9 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -37,9 +37,12 @@ enum error_action {
 struct scrub_ctx {
 	/* Immutable scrub state. */
 
-	/* Strings we need for presentation */
+	/* Mountpoint we use for presentation */
 	char			*mntpoint;
 
+	/* Actual VFS path to the filesystem */
+	char			*actual_mntpoint;
+
 	/* Mountpoint info */
 	struct stat		mnt_sb;
 	struct statvfs		mnt_sv;

