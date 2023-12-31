Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B15C14C
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eT9vgP2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D62C433C7;
	Sun, 31 Dec 2023 22:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704063359;
	bh=nTokLvHwpBYLT8Vol16Mq2p3cuYArmyof72S5tb8duU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eT9vgP2GXg9mB/YKc2+vSKRfVUHwGL8iFf1aB0jOeU0OP4WQhxOQ4T8suPthl2z05
	 RcV7hCdEkgq/FKi9s5QdqUEnzXjT5oRqU+50CuZ+KX9+yUAXdsjsFTPjZw8/upO3FS
	 HzKHsQIen7h5MCUeRckmJZfABa6cbmFT2M/S6p2ZdcwGZEW6cH39XtsZAb1FqZgsr/
	 Uw6MQy7Khzm7oCujG4eYxKcYoZOOQgYBnw9KEbUfoCiILsMnEFit2cBoL3RcO8CFla
	 3v8i5tkqCFeIZNeVKZajVv5AKk1BApD9NcjLBeKLjNYxHAvlGFVZk67Zq+aPPwJMyF
	 PefqWzx9sOZLQ==
Date: Sun, 31 Dec 2023 14:55:59 -0800
Subject: [PATCH 1/6] xfs_scrub: allow auxiliary pathnames for sandboxing
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405002619.1801298.8465209620940926881.stgit@frogsfrogsfrogs>
In-Reply-To: <170405002602.1801298.14531646183046394491.stgit@frogsfrogsfrogs>
References: <170405002602.1801298.14531646183046394491.stgit@frogsfrogsfrogs>
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

In the next patch, we'll tighten up the security on the xfs_scrub
service so that it can't escape.  However, sandboxing the service
involves making the host filesystem as inaccessible as possible, with
the filesystem to scrub bind mounted onto a known location within the
sandbox.  Hence we need one path for reporting and a new -M argument to
tell scrub what it should actually be trying to open.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_scrub.8 |    9 ++++++++-
 scrub/phase1.c       |    4 ++--
 scrub/vfs.c          |    2 +-
 scrub/xfs_scrub.c    |   11 ++++++++---
 scrub/xfs_scrub.h    |    5 ++++-
 5 files changed, 23 insertions(+), 8 deletions(-)


diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index b9f253e1b07..6154011271e 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -4,7 +4,7 @@ xfs_scrub \- check and repair the contents of a mounted XFS filesystem
 .SH SYNOPSIS
 .B xfs_scrub
 [
-.B \-abCemnTvx
+.B \-abCeMmnTvx
 ]
 .I mount-point
 .br
@@ -79,6 +79,13 @@ behavior.
 .B \-k
 Do not call TRIM on the free space.
 .TP
+.BI \-M " real-mount-point"
+Open the this path for issuing scrub system calls to the kernel.
+The positional
+.I mount-point
+parameter will be used for displaying informational messages and logging.
+This parameter exists to enable process sandboxing for service mode.
+.TP
 .BI \-m " file"
 Search this file for mounted filesystems instead of /etc/mtab.
 .TP
diff --git a/scrub/phase1.c b/scrub/phase1.c
index 1b3f6e8eb4f..516d929d626 100644
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
index 22c19485a2d..fca9a4cf356 100644
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
index 37b95aa1e67..4912333219d 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -725,7 +725,7 @@ main(
 	pthread_mutex_init(&ctx.lock, NULL);
 	ctx.mode = SCRUB_MODE_REPAIR;
 	ctx.error_action = ERRORS_CONTINUE;
-	while ((c = getopt(argc, argv, "a:bC:de:km:no:TvxV")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bC:de:kM:m:no:TvxV")) != EOF) {
 		switch (c) {
 		case 'a':
 			ctx.max_errors = cvt_u64(optarg, 10);
@@ -769,6 +769,9 @@ main(
 		case 'k':
 			want_fstrim = false;
 			break;
+		case 'M':
+			ctx.actual_mntpoint = optarg;
+			break;
 		case 'm':
 			mtab = optarg;
 			break;
@@ -823,6 +826,8 @@ main(
 		usage();
 
 	ctx.mntpoint = argv[optind];
+	if (!ctx.actual_mntpoint)
+		ctx.actual_mntpoint = ctx.mntpoint;
 
 	stdout_isatty = isatty(STDOUT_FILENO);
 	stderr_isatty = isatty(STDERR_FILENO);
@@ -840,7 +845,7 @@ main(
 		return SCRUB_RET_OPERROR;
 
 	/* Find the mount record for the passed-in argument. */
-	if (stat(argv[optind], &ctx.mnt_sb) < 0) {
+	if (stat(ctx.actual_mntpoint, &ctx.mnt_sb) < 0) {
 		fprintf(stderr,
 			_("%s: could not stat: %s: %s\n"),
 			progname, argv[optind], strerror(errno));
@@ -863,7 +868,7 @@ main(
 	}
 
 	fs_table_initialise(0, NULL, 0, NULL);
-	fsp = fs_table_lookup_mount(ctx.mntpoint);
+	fsp = fs_table_lookup_mount(ctx.actual_mntpoint);
 	if (!fsp) {
 		fprintf(stderr, _("%s: Not a XFS mount point.\n"),
 				ctx.mntpoint);
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 7d48f4bad9c..b0aa9fcc67b 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -38,9 +38,12 @@ enum error_action {
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

