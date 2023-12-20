Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361D34776B
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DnLfbRxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F337FC433C7;
	Wed, 20 Dec 2023 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092505;
	bh=CHCl/zMNcMr3PiLIAfk3i8JhfwnPwjrznk09LJEW9UE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DnLfbRxtEqJA2uQ2Dns+n1MbCWwMA8MDWrNXcZgg/HtuYLRWkba+56qsk6MDt4gMG
	 zvD7bSJJvKbc+hJm/y0KTv1VAt1mkWHvYovAJgtBX9Eadq+eRbH4jpeDinhZE8h/FY
	 ZQRFbQz+j8M408xa//9972bEsQw/OmZyWhyHVAXQYxlWwXdEnoSVHoRrBevrHM3p8s
	 FudB1mQQcHt5/jimXCmQPnyWrRh7KWAt1ppfRiAhZoxhjJjbnueXy/3QpXHrqGPDuS
	 +2Re9UqGSRXEmMPlGanaHzk8l49BiZZvSzof28WSVYkjBBKRTHzD1vX6n2M1SFz0M/
	 ydIYP4taI78uQ==
Date: Wed, 20 Dec 2023 09:15:04 -0800
Subject: [PATCH 3/4] xfs_io: extract contorl number parsing routines
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170309219120.1608142.14150492359425333052.stgit@frogsfrogsfrogs>
In-Reply-To: <170309219080.1608142.737701463093437769.stgit@frogsfrogsfrogs>
References: <170309219080.1608142.737701463093437769.stgit@frogsfrogsfrogs>
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

Break out the parts of parse_args that extract control numbers from the
CLI arguments, so that the function isn't as long.  This isn't all that
exciting now, but the scrub vectorization speedups will introduce a new
ioctl.  For the new command that comes with that, we'll want the control
number parsing helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c |  128 ++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 85 insertions(+), 43 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index 238d9240..cde788fb 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -41,6 +41,87 @@ scrub_help(void)
 	printf("\n");
 }
 
+static bool
+parse_inode(
+	int		argc,
+	char		**argv,
+	int		optind,
+	__u64		*ino,
+	__u32		*gen)
+{
+	char		*p;
+	unsigned long long control;
+	unsigned long	control2;
+
+	if (optind == argc) {
+		*ino = 0;
+		*gen = 0;
+		return true;
+	}
+
+	if (optind != argc - 2) {
+		fprintf(stderr,
+ _("Must specify inode number and generation.\n"));
+		return false;
+	}
+
+	control = strtoull(argv[optind], &p, 0);
+	if (*p != '\0') {
+		fprintf(stderr, _("Bad inode number '%s'.\n"),
+				argv[optind]);
+		return false;
+	}
+	control2 = strtoul(argv[optind + 1], &p, 0);
+	if (*p != '\0') {
+		fprintf(stderr, _("Bad generation number '%s'.\n"),
+				argv[optind + 1]);
+		return false;
+	}
+
+	*ino = control;
+	*gen = control2;
+	return true;
+}
+
+static bool
+parse_agno(
+	int		argc,
+	char		**argv,
+	int		optind,
+	__u32		*agno)
+{
+	char		*p;
+	unsigned long	control;
+
+	if (optind != argc - 1) {
+		fprintf(stderr, _("Must specify one AG number.\n"));
+		return false;
+	}
+
+	control = strtoul(argv[optind], &p, 0);
+	if (*p != '\0') {
+		fprintf(stderr, _("Bad AG number '%s'.\n"), argv[optind]);
+		return false;
+	}
+
+	*agno = control;
+	return true;
+}
+
+static bool
+parse_none(
+	int		argc,
+	int		optind)
+{
+	if (optind != argc) {
+		fprintf(stderr, _("No parameters allowed.\n"));
+		return false;
+	}
+
+	/* no control parameters */
+	return true;
+}
+
 static int
 parse_args(
 	int				argc,
@@ -48,11 +129,8 @@ parse_args(
 	const struct cmdinfo		*cmdinfo,
 	struct xfs_scrub_metadata	*meta)
 {
-	char				*p;
 	int				type = -1;
 	int				i, c;
-	uint64_t			control = 0;
-	uint32_t			control2 = 0;
 	const struct xfrog_scrub_descr	*d = NULL;
 
 	memset(meta, 0, sizeof(struct xfs_scrub_metadata));
@@ -85,61 +163,25 @@ parse_args(
 
 	switch (d->type) {
 	case XFROG_SCRUB_TYPE_INODE:
-		if (optind == argc) {
-			control = 0;
-			control2 = 0;
-		} else if (optind == argc - 2) {
-			control = strtoull(argv[optind], &p, 0);
-			if (*p != '\0') {
-				fprintf(stderr,
-					_("Bad inode number '%s'.\n"),
-					argv[optind]);
-				exitcode = 1;
-				return command_usage(cmdinfo);
-			}
-			control2 = strtoul(argv[optind + 1], &p, 0);
-			if (*p != '\0') {
-				fprintf(stderr,
-					_("Bad generation number '%s'.\n"),
-					argv[optind + 1]);
-				exitcode = 1;
-				return command_usage(cmdinfo);
-			}
-		} else {
-			fprintf(stderr,
-				_("Must specify inode number and generation.\n"));
+		if (!parse_inode(argc, argv, optind, &meta->sm_ino,
+						     &meta->sm_gen)) {
 			exitcode = 1;
 			return command_usage(cmdinfo);
 		}
-		meta->sm_ino = control;
-		meta->sm_gen = control2;
 		break;
 	case XFROG_SCRUB_TYPE_AGHEADER:
 	case XFROG_SCRUB_TYPE_PERAG:
-		if (optind != argc - 1) {
-			fprintf(stderr,
-				_("Must specify one AG number.\n"));
+		if (!parse_agno(argc, argv, optind, &meta->sm_agno)) {
 			exitcode = 1;
 			return command_usage(cmdinfo);
 		}
-		control = strtoul(argv[optind], &p, 0);
-		if (*p != '\0') {
-			fprintf(stderr,
-				_("Bad AG number '%s'.\n"), argv[optind]);
-			exitcode = 1;
-			return command_usage(cmdinfo);
-		}
-		meta->sm_agno = control;
 		break;
 	case XFROG_SCRUB_TYPE_FS:
 	case XFROG_SCRUB_TYPE_NONE:
-		if (optind != argc) {
-			fprintf(stderr,
-				_("No parameters allowed.\n"));
+		if (!parse_none(argc, optind)) {
 			exitcode = 1;
 			return command_usage(cmdinfo);
 		}
-		/* no control parameters */
 		break;
 	default:
 		ASSERT(0);

