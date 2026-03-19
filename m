Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCB1318EC4
	for <linux-xfs@vger.kernel.org>; Thu, 19 Mar 2026 04:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895469; cv=none; b=rnREAY8Wq/VO48fg/kn9rIuFn1TKJ+0yukWukqGcqSlV+FAuo/7v5YRksS4/YtJ8IkJ3Hsb+vrsutHYczah03qAFV6ivH7AMvtUAoyal29ru730+0Y8JayHp5Hf22mbxcCbg6HQMo2CuQ4RUhbKbjBxW2QH8EtYSNkvmC8vQIiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895469; c=relaxed/simple;
	bh=hykg1VrfhHJbpomuJPUuVJJwD6qpsE97ieTKNiQ+OOY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zoy1j5I8oPb3AN9MF/zyqfllyB9E6eWy2AQh5oGWZscdj90gXVP4LTgzg70Aj3ykHHMDoN6awU27SkRQ427lHBlmADDG1n4wgMzIJcqAQEaJBPnfUbJJjTqnoRdsk5Lpmwiw2CselF72DeQPjCEqOuHHdS5+qGlmyi+xYMxU4aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YEJlWSZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YEJlWSZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A5EC19425;
	Thu, 19 Mar 2026 04:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773895469;
	bh=hykg1VrfhHJbpomuJPUuVJJwD6qpsE97ieTKNiQ+OOY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YEJlWSZXwcNMRT5ufVX0piNHwcb5J0aczNI2TGLdiNY6keSeZpbcEeE3n2Dtr06l8
	 yhu7xpf3a/mlJ36Kmt0iLtLgHLtqGQfuTBZtC47D5pEZrknw0kWcsWhw5RyGV+3WCX
	 vfuHsEkp1bcg0c+PfdwVWxvUYknwh3gTsUJZEieBixEl97il0voIqrGpDJwpq1C8g8
	 jqJJtZO4Kw9MTq8nHngrnTxxHcFLGBy2VLbHA1psg+p3NGr7O26g4ZVGX6GVx+BiFW
	 Cw92JU4BlN9l6QgGo0PTkWIyK188MaSszbwXm/GfMerc/yUdtHsaoukGTBKT55jbfM
	 82EGcCxm0KxNA==
Date: Wed, 18 Mar 2026 21:44:29 -0700
Subject: [PATCH 22/26] xfs_scrub: print systemd service names
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177389506550.3680139.15247548785964582317.stgit@frogsfrogsfrogs>
In-Reply-To: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
References: <177389506017.3680139.913759001427336891.stgit@frogsfrogsfrogs>
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
 

