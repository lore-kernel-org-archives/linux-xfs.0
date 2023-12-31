Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4C9C129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I11ebOOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9888C433C7;
	Sun, 31 Dec 2023 22:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062421;
	bh=vU/BPQkz3DHfoH1ONjjXzCiC5c9AphgxgViclvSnoPM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I11ebOOmRulfYklDx05yD+UkkEY7TGLBGkAz6iR7CuHRd85zrZyebYgUbJkkFA5Pl
	 hfcHPsW8gw1zzvvn+vblQ1F0Yk2x52WOsplT/pRn3Pg3LxpBjUpDHTm8w7KbxaCUx1
	 6AGMMmtGHWd0Jw8E7te5fE/xVAg5a8xcBUOqH7+J8adMiz0/YXfc3baOZFl8BQEVNW
	 fpDEf+bx4oDgjssTz40DB9Z1SA6yjr99AgT6o1aNgFtJ+PL1n8g8tQYltKtou+zrcW
	 gF+UtKXugxGC1mDD3O9rMCEvhcTloXpluwnmo3W+pqA+AN6GemBJ5Si4DnS4B/R6K+
	 t1Uv2+9/aMTXw==
Date: Sun, 31 Dec 2023 14:40:21 -0800
Subject: [PATCH 8/8] xfs_scrub: enable users to bump information messages to
 warnings
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404999140.1797544.9880902340998334029.stgit@frogsfrogsfrogs>
In-Reply-To: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
References: <170404999029.1797544.5974682335470417611.stgit@frogsfrogsfrogs>
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

Add a -o iwarn option that enables users to specify that informational
messages (such as incomplete scans, or confusing names) should be
treated as warnings.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man8/xfs_scrub.8 |   19 +++++++++++++++++++
 scrub/common.c       |    2 ++
 scrub/xfs_scrub.c    |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 scrub/xfs_scrub.h    |    1 +
 4 files changed, 66 insertions(+), 1 deletion(-)


diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index e881ae76acb..404baba696e 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -85,6 +85,25 @@ Search this file for mounted filesystems instead of /etc/mtab.
 .B \-n
 Only check filesystem metadata.
 Do not repair or optimize anything.
+.HP
+.B \-o
+.I subopt\c
+[\c
+.B =\c
+.IR value ]
+.BR
+Override what the program might conclude about the filesystem
+if left to its own devices.
+.IP
+The
+.IR subopt ions
+supported are:
+.RS 1.0i
+.TP
+.BI iwarn
+Treat informational messages as warnings.
+This will result in a nonzero return code, and a higher logging level.
+.RE
 .TP
 .BI \-T
 Print timing and memory usage information for each phase.
diff --git a/scrub/common.c b/scrub/common.c
index 283ac84e232..aca59648711 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -110,6 +110,8 @@ __str_out(
 	/* print strerror or format of choice but not both */
 	assert(!(error && format));
 
+	if (level == S_INFO && info_is_warning)
+		level = S_WARN;
 	if (level >= S_INFO)
 		stream = stdout;
 
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 752180d646b..aa68c23c62e 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -160,6 +160,9 @@ bool				is_service;
 /* Set to true if the kernel supports XFS_SCRUB_IFLAG_FORCE_REBUILD */
 bool				use_force_rebuild;
 
+/* Should we count informational messages as warnings? */
+bool				info_is_warning;
+
 #define SCRUB_RET_SUCCESS	(0)	/* no problems left behind */
 #define SCRUB_RET_CORRUPT	(1)	/* corruption remains on fs */
 #define SCRUB_RET_UNOPTIMIZED	(2)	/* fs could be optimized */
@@ -604,6 +607,43 @@ report_outcome(
 # define XFS_SCRUB_HAVE_UNICODE	"-"
 #endif
 
+/*
+ * -o: user-supplied override options
+ */
+enum o_opt_nums {
+	IWARN = 0,
+	O_MAX_OPTS,
+};
+
+static char *o_opts[] = {
+	[IWARN]			= "iwarn",
+	[O_MAX_OPTS]		= NULL,
+};
+
+static void
+parse_o_opts(
+	struct scrub_ctx	*ctx,
+	char			*p)
+{
+	while (*p != '\0')  {
+		char		*val;
+
+		switch (getsubopt(&p, o_opts, &val))  {
+		case IWARN:
+			if (val) {
+				fprintf(stderr,
+ _("iwarn does not take an argument\n"));
+				usage();
+			}
+			info_is_warning = true;
+			break;
+		default:
+			usage();
+			break;
+		}
+	}
+}
+
 int
 main(
 	int			argc,
@@ -637,7 +677,7 @@ main(
 	pthread_mutex_init(&ctx.lock, NULL);
 	ctx.mode = SCRUB_MODE_REPAIR;
 	ctx.error_action = ERRORS_CONTINUE;
-	while ((c = getopt(argc, argv, "a:bC:de:km:nTvxV")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bC:de:km:no:TvxV")) != EOF) {
 		switch (c) {
 		case 'a':
 			ctx.max_errors = cvt_u64(optarg, 10);
@@ -687,6 +727,9 @@ main(
 		case 'n':
 			ctx.mode = SCRUB_MODE_DRY_RUN;
 			break;
+		case 'o':
+			parse_o_opts(&ctx, optarg);
+			break;
 		case 'T':
 			display_rusage = true;
 			break;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 34d850d8db3..1151ee9ff3a 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -22,6 +22,7 @@ extern bool			stderr_isatty;
 extern bool			stdout_isatty;
 extern bool			is_service;
 extern bool			use_force_rebuild;
+extern bool			info_is_warning;
 
 enum scrub_mode {
 	SCRUB_MODE_DRY_RUN,

