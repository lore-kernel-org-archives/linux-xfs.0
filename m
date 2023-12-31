Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB3FC2D4
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ll0Q/gTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE02C433C7;
	Sun, 31 Dec 2023 23:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067080;
	bh=AaGsBEX5erp6nIP3VvopVfqQ1DtQOCMQqW2MVbd5wo0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ll0Q/gTqexbhpoYYHFWGjNg3jMMdjV5k4To6ZrZ455+Uc5510MRwHyY9k5ccA3DTn
	 YlGlON6LPLtKs63mfsgxoUO9Lq3zDrGzxfAOHwpZEdiihln2A+LM2tVPxE6zD5i05H
	 uD/toarfAwvM+lSovAkyO4rFdAq56SERWUhiL2ZvghLq+HB5xys1/c3QbJgqlvfzc5
	 1S/FqmDxYvaky+nYeyEzN8fH5R74ofo4Lqv+CPQKHa8Z5cXKkDMKDneHHkuZqFgejy
	 +c7HVc1fJUX3JmC5DaU3W6H44zL8bh9wKAM0FU4R+YvkqZiNyhqmyXG0XMpCJzVzk5
	 ZDnmy78Prj1Hw==
Date: Sun, 31 Dec 2023 15:57:59 -0800
Subject: [PATCH 40/52] xfs_io: support scrubbing rtgroup metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012698.1811243.8238486017822319285.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Support scrubbing all rtgroup metadata with a scrubv call.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c        |   40 ++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |    3 ++-
 2 files changed, 42 insertions(+), 1 deletion(-)


diff --git a/io/scrub.c b/io/scrub.c
index cb4e24503dc..e9254c7882a 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -165,6 +165,32 @@ parse_metapath(
 	return true;
 }
 
+static bool
+parse_rtgroup(
+	int		argc,
+	char		**argv,
+	int		optind,
+	__u32		*rgno)
+{
+	char		*p;
+	unsigned long	control;
+
+	if (optind != argc - 1) {
+		fprintf(stderr, _("Must specify one rtgroup number.\n"));
+		return false;
+	}
+
+	control = strtoul(argv[optind], &p, 0);
+	if (*p != '\0') {
+		fprintf(stderr, _("Bad rtgroup number '%s'.\n"),
+				argv[optind]);
+		return false;
+	}
+
+	*rgno = control;
+	return true;
+}
+
 static int
 parse_args(
 	int				argc,
@@ -230,6 +256,12 @@ parse_args(
 			return command_usage(cmdinfo);
 		}
 		break;
+	case XFROG_SCRUB_GROUP_RTGROUP:
+		if (!parse_rtgroup(argc, argv, optind, &meta->sm_agno)) {
+			exitcode = 1;
+			return command_usage(cmdinfo);
+		}
+		break;
 	case XFROG_SCRUB_GROUP_FS:
 	case XFROG_SCRUB_GROUP_NONE:
 	case XFROG_SCRUB_GROUP_SUMMARY:
@@ -544,6 +576,8 @@ scrubv_f(
 		group = XFROG_SCRUB_GROUP_ISCAN;
 	else if (!strcmp(argv[optind], "summary"))
 		group = XFROG_SCRUB_GROUP_SUMMARY;
+	else if (!strcmp(argv[optind], "rtgroup"))
+		group = XFROG_SCRUB_GROUP_RTGROUP;
 	else {
 		printf(_("Unknown group '%s'.\n"), argv[optind]);
 		exitcode = 1;
@@ -581,6 +615,12 @@ scrubv_f(
 			return command_usage(&scrubv_cmd);
 		}
 		break;
+	case XFROG_SCRUB_GROUP_RTGROUP:
+		if (!parse_rtgroup(argc, argv, optind, &vhead->svh_agno)) {
+			exitcode = 1;
+			return command_usage(&scrubv_cmd);
+		}
+		break;
 	default:
 		ASSERT(0);
 		break;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index ef3a5681a1a..61eed7f5aa8 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1422,11 +1422,12 @@ Currently supported versions are 1 and 5.
 .RE
 .PD
 .TP
-.BI "scrub " type " [ " agnumber " | " "ino" " " "gen" " | " metapath " ]"
+.BI "scrub " type " [ " agnumber " | " rgnumber " | " "ino" " " "gen" " | " metapath " ]"
 Scrub internal XFS filesystem metadata.  The
 .BI type
 parameter specifies which type of metadata to scrub.
 For AG metadata, one AG number must be specified.
+For realtime group metadata, one rtgroup number must be specified.
 For file metadata, the scrub is applied to the open file unless the
 inode number and generation number are specified.
 For metapath, the name of a file or a raw number must be specified.

