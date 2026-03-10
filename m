Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C541547C0
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114530; cv=none; b=LHdi8mpPJ0onR1/qJAXVfQMQvWT74MAgOsYhPsGSEYjRfDetYz/Rl6go+myQX292Msw1j0f/SuLIucpWTHMNlj+vl9VWYe7Tu5GeUYckaDJmyNATQLvXmy8Ve4Ui/ikvoGCX5nI+DmiMOCacIltHtyloO+0VBTQ/ERTnCC0joE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114530; c=relaxed/simple;
	bh=3d1H65mWhp/SjoHf3t9ibyrR8+0Ta6BCSnWr51r5gRA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F9HF1nKkuNGBDopYHry6OxY536tUpJnH8dSZVWs0X1RylbeAn87ryLXFXOaEHF/60tZeo/uFDyREIcD5ENPA2GodRYd+q3FSA3k+tkQGGPsB1bdWnM6HI4pNtEszpaxM0pN5hEaNbXy7H4vJk4JWPsmW3WvfDQ4tuNBlC+9S3OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=llQgdGPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="llQgdGPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799D9C19423;
	Tue, 10 Mar 2026 03:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114530;
	bh=3d1H65mWhp/SjoHf3t9ibyrR8+0Ta6BCSnWr51r5gRA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=llQgdGPyloxAv9sn4p4e4MW1Qb3dKh9mB99g7Y2rL0HOvI+V6Yh1X+bYYTEsFmnKU
	 kkdhF0gHP8XVHA0SxA//hFdvNGPxXT26OawfZYMvQMJ6SDLruH/e/Fnj2saRRnd7KS
	 OlQqXlktO3HfW8Suuqd3Pf1QMmghOXVzsBOth+9qPec7ywNQAFTauiALMnqhCURGtY
	 h3wn79KxRFK3NL1+gXq6Pv8WoC9NNEv2PodbPDFUaq4WW7F5Dd3qQS6jHZ2nu39eKj
	 vHwZOUn5b35wnl5cv6MuqgMzOMAFWxl9zRw9ZJj/3jKaIwNKUBdJm5FDebXVEUHkGt
	 asXTDWygStLDg==
Date: Mon, 09 Mar 2026 20:48:50 -0700
Subject: [PATCH 24/28] xfs_scrub: print systemd service names
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177311401894.1183235.1360530757418376989.stgit@frogsfrogsfrogs>
In-Reply-To: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
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
---
 scrub/xfs_scrub.h |    3 +++
 scrub/Makefile    |    7 +++++--
 scrub/xfs_scrub.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 54 insertions(+), 6 deletions(-)


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
index aee49bfce100e2..4aa0a7d836c342 100644
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
 

