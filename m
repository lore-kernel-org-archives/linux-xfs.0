Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107D8344D88
	for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2026 06:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775801781; cv=none; b=YVzZtiNy5eIiYUhlEwMvHgoGSqKCAF+rT0DMIO5nUHTlI/piQ4lP3c69zncJ0u07olhhi825Dcgm7vExkm/3S6RH26QfpEabUCsrYdQedtiyinG3E3pwHxso16krNbZ3lJkxLanE5xu0CG+guAYkHDIRStPZGxJ5yKt1yjS9tL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775801781; c=relaxed/simple;
	bh=Q4YwxHD6PXjvKaCj/VdEejmDwvx4ZEA5DdQGh+mq9rg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A81MUMkPJpyLieyqxLaTA+nw35hJVcANk3BOlwf/IR2TyifeMoR3Cm77uFFv0ogMFSi+yexRyo7+M92pchYcqU8AVafP4TLeo918DKp81ufKllWZArqMEGP26KwuwwkOr6QGSyYci/DiIa+ZCL4viU5yazt3T3xpzD42uP6B3HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NzyYsQGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NzyYsQGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5ED8C19424;
	Fri, 10 Apr 2026 06:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775801780;
	bh=Q4YwxHD6PXjvKaCj/VdEejmDwvx4ZEA5DdQGh+mq9rg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NzyYsQGw1Kq+FhkbmOKvAz7dffgzwkIAiVt9IfMCSxlI09Toq2P7fRDSzGFQBLqSE
	 pKxIATMXeGSRlbK7NF4LL9Brv50ZJME2WxSFBhyIkmJQIy0hJCXBFPcZGxJYx4SXrc
	 3sELBDNjuKU1b9wHlnmlS+hvvb2sh5N+LgCZKqMHY2uuBdR6gHE2dM+nQ34SpV10VS
	 42sUQeLWbIM9LfoGkclQbEljNSHKS+jUiT5sQiRrh3NkFoKrqnzqjxerbQS3/wS1i2
	 D5E76RMRHSn72AbfJ8mx0is6XBWFUI8cz8iDCp90UTAqo1yBbWtUUfk9sN1hDVB2Kp
	 cLfITUcSVbVnw==
Date: Thu, 09 Apr 2026 23:16:20 -0700
Subject: [PATCH 22/26] xfs_scrub: print systemd service names
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177577384634.2089237.13675514358985884997.stgit@frogsfrogsfrogs>
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

Add a hidden switch to xfs_scrub to emit systemd service names for XFS
services targetting filesystems paths instead of opencoding the
computation in things like fstests.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/xfs_scrub.h |    3 +++
 scrub/Makefile    |    9 ++++++---
 scrub/xfs_scrub.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 55 insertions(+), 7 deletions(-)


diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 6ee359f4cebd47..041c0fadaa93c0 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -108,6 +108,9 @@ struct scrub_ctx {
 	 * this much space per volume.
 	 */
 	double			fstrim_block_pct;
+
+	/* CLI options, must be int */
+	int			print_svcname;
 };
 
 /*
diff --git a/scrub/Makefile b/scrub/Makefile
index aee49bfce100e2..f74cfa9a235d4f 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -8,9 +8,12 @@ include $(builddefs)
 
 SCRUB_PREREQS=$(HAVE_GETFSMAP)
 
-scrub_media_svcname=xfs_scrub_media@.service
+XFS_SCRUB_MEDIA_SVCNAME=xfs_scrub_media@.service
 
 ifeq ($(SCRUB_PREREQS),yes)
+CFLAGS+=-DXFS_SCRUB_SVCNAME=\"$(XFS_SCRUB_SVCNAME)\"
+CFLAGS+=-DXFS_SCRUB_MEDIA_SVCNAME=\"$(XFS_SCRUB_MEDIA_SVCNAME)\"
+
 LTCOMMAND = xfs_scrub
 INSTALL_SCRUB = install-scrub
 XFS_SCRUB_ALL_PROG = xfs_scrub_all.py
@@ -22,7 +25,7 @@ INSTALL_SCRUB += install-systemd
 SYSTEMD_SERVICES=\
 	$(XFS_SCRUB_SVCNAME) \
 	xfs_scrub_fail@.service \
-	$(scrub_media_svcname) \
+	$(XFS_SCRUB_MEDIA_SVCNAME) \
 	xfs_scrub_media_fail@.service \
 	xfs_scrub_all.service \
 	xfs_scrub_all_fail.service \
@@ -123,7 +126,7 @@ $(XFS_SCRUB_ALL_PROG): $(XFS_SCRUB_ALL_PROG).in $(builddefs) $(TOPDIR)/libfrog/g
 	@echo "    [SED]    $@"
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_svcname@|$(XFS_SCRUB_SVCNAME)|g" \
-		   -e "s|@scrub_media_svcname@|$(scrub_media_svcname)|g" \
+		   -e "s|@scrub_media_svcname@|$(XFS_SCRUB_MEDIA_SVCNAME)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
 		   -e "s|@stampfile@|$(XFS_SCRUB_ALL_AUTO_MEDIA_SCAN_STAMP)|g" \
 		   -e "s|@scrub_service_args@|$(XFS_SCRUB_SERVICE_ARGS)|g" \
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 79937aa8cce4c4..b74dc1635141aa 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -710,6 +710,13 @@ parse_o_opts(
 	}
 }
 
+enum long_opt_nr {
+	LOPT_HELP,
+	LOPT_SVCNAME,
+
+	LOPT_MAX,
+};
+
 int
 main(
 	int			argc,
@@ -717,11 +724,15 @@ main(
 {
 	struct scrub_ctx	ctx = {
 		.fstrim_block_pct = FSTRIM_BLOCK_PCT_DEFAULT,
+		.lock		= (pthread_mutex_t)PTHREAD_MUTEX_INITIALIZER,
+		.mode		= SCRUB_MODE_REPAIR,
+		.error_action	= ERRORS_CONTINUE,
 	};
 	struct phase_rusage	all_pi;
 	char			*mtab = NULL;
 	FILE			*progress_fp = NULL;
 	struct fs_path		*fsp;
+	int			option_index;
 	int			vflag = 0;
 	int			c;
 	int			fd;
@@ -742,11 +753,25 @@ main(
 		goto out_unicrash;
 	}
 
-	pthread_mutex_init(&ctx.lock, NULL);
-	ctx.mode = SCRUB_MODE_REPAIR;
-	ctx.error_action = ERRORS_CONTINUE;
-	while ((c = getopt(argc, argv, "a:bC:de:kM:m:no:pTvxV")) != EOF) {
+	struct option long_options[] = {
+		[LOPT_HELP]	   = {"help", no_argument, NULL, 0 },
+		[LOPT_SVCNAME]	   = {"svcname", no_argument, &ctx.print_svcname, 1 },
+
+		[LOPT_MAX]	   = {NULL, 0, NULL, 0 },
+	};
+
+	while ((c = getopt_long(argc, argv, "a:bC:de:kM:m:no:pTvxV",
+				long_options, &option_index)) != EOF) {
 		switch (c) {
+		case 0:
+			switch (option_index) {
+			case LOPT_HELP:
+				usage();
+				break;
+			default:
+				break;
+			}
+			break;
 		case 'a':
 			ctx.max_errors = cvt_u64(optarg, 10);
 			if (errno) {
@@ -860,6 +885,23 @@ main(
 	if (!ctx.actual_mntpoint)
 		ctx.actual_mntpoint = ctx.mntpoint;
 
+	if (ctx.print_svcname) {
+		char		unitname[PATH_MAX];
+		const char	*template =
+			scrub_data ? XFS_SCRUB_MEDIA_SVCNAME :
+				     XFS_SCRUB_SVCNAME;
+
+		ret = systemd_path_instance_unit_name(template,
+				ctx.mntpoint, unitname, sizeof(unitname));
+		if (ret) {
+			perror(ctx.mntpoint);
+			return EXIT_FAILURE;
+		}
+
+		printf("%s\n", unitname);
+		return EXIT_SUCCESS;
+	}
+
 	stdout_isatty = isatty(STDOUT_FILENO);
 	stderr_isatty = isatty(STDERR_FILENO);
 

