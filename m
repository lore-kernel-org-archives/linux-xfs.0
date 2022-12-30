Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C07C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235722AbiLaAgJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiLaAgH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:36:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D987512A8D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:36:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 688EA61CAA
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C087EC433D2;
        Sat, 31 Dec 2022 00:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446965;
        bh=ivCyPMTxgydXyBsNfhSM9J+xa6rIloBozJrCTvqQ/Bw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rOMyZlxS6yrPUMmex4oYNN1iSXRV3K3KKfAkz5lBFFXbMTu7cVbg7hmPAk2Pg4c7p
         FygmuJevvu6TgrCeMkV9xlh8LqIipt6r8e12+gWrmiUPLPBtBRuRAw0v9DjGQEzH+w
         WeMx2gpqHW6Ubu6LxQbNLVGFMGQR7LH/ZHvR11htLBIhzdNGUG6lvPSgcoOD/ksO4P
         rkalAZ3JEq7ReYJzxfl0VkiBbz1q8R6vCYKedG6ccJPtixGCHXyufnpvfrq3XNSZeT
         PlMcZlYWkr+L6apfGSQSA4vNJsT3kYiTx+jVyJsqNQ5Ltl3waBDPxjmKqoUI9JqAoL
         VM61ZhmoITkBA==
Subject: [PATCH 1/5] xfs_scrub: allow auxiliary pathnames for sandboxing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:34 -0800
Message-ID: <167243871478.718298.14119656193739596554.stgit@magnolia>
In-Reply-To: <167243871464.718298.4729609315819255063.stgit@magnolia>
References: <167243871464.718298.4729609315819255063.stgit@magnolia>
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
index faa554f1e1e..80fd0c6e27c 100644
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
index 85ee2694b00..c64c6c41105 100644
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
index bdee8e4fdae..23d8fec5d9b 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -118,6 +118,8 @@
  * Available even in non-debug mode:
  * SERVICE_MODE			-- compress all error codes to 1 for LSB
  *				   service action compliance
+ * SERVICE_MOUNTPOINT		-- actual path to open for issuing kernel
+ *				   scrub calls
  */
 
 /* Program name; needed for libfrog error reports. */
@@ -739,6 +741,9 @@ main(
 		usage();
 
 	ctx.mntpoint = argv[optind];
+	ctx.actual_mntpoint = getenv("SERVICE_MOUNTPOINT");
+	if (!ctx.actual_mntpoint)
+		ctx.actual_mntpoint = ctx.mntpoint;
 
 	stdout_isatty = isatty(STDOUT_FILENO);
 	stderr_isatty = isatty(STDERR_FILENO);
@@ -756,7 +761,7 @@ main(
 		return SCRUB_RET_OPERROR;
 
 	/* Find the mount record for the passed-in argument. */
-	if (stat(argv[optind], &ctx.mnt_sb) < 0) {
+	if (stat(ctx.actual_mntpoint, &ctx.mnt_sb) < 0) {
 		fprintf(stderr,
 			_("%s: could not stat: %s: %s\n"),
 			progname, argv[optind], strerror(errno));
@@ -779,7 +784,7 @@ main(
 	}
 
 	fs_table_initialise(0, NULL, 0, NULL);
-	fsp = fs_table_lookup_mount(ctx.mntpoint);
+	fsp = fs_table_lookup_mount(ctx.actual_mntpoint);
 	if (!fsp) {
 		fprintf(stderr, _("%s: Not a XFS mount point.\n"),
 				ctx.mntpoint);
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 004d2d02587..2ef8b2e5066 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -36,9 +36,12 @@ enum error_action {
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

