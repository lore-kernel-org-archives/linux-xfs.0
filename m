Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02604777A
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ueyDWLvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B941FC433C8;
	Wed, 20 Dec 2023 17:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092473;
	bh=UKMhh4vUQ5+mlvx3PX22RA/0F31AJ/mw5lFiem5eTyE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ueyDWLvF6lTJwShUAVCULrNBpYvmkkTuuBrWWYmOY85byk5iB2NL+Z4FI/T6kYrlc
	 xu3mAvjBNHwBywV8G1v7llmh2bM+TXlpl8R4sIFSloRGA86K6dDYvfb3EFZCmOkdFQ
	 o4h70V2io/oQpoeIjBe98AKYC2mpw2Ju9CgrZuQkccW3XrsZQfm3MJQ9YaLBLKY72t
	 O2UPWnLYR1bhtWqufSLMPq3h4o3kq322dVVvodC2COcNdqxlSKxodQpX2Un7qAfg3/
	 1M2jruOAY2+EWfkX3EWlYHYBp79L47vhoNlyzT4eJGFvsZ6ggtfRZ9I9ftGY5vQ7jS
	 iDZ/eFsNa+w7g==
Date: Wed, 20 Dec 2023 09:14:33 -0800
Subject: [PATCH 1/4] xfs_io: set exitcode = 1 on parsing errors in
 scrub/repair command
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170309219094.1608142.4865155109436063528.stgit@frogsfrogsfrogs>
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

Set exitcode to 1 if there is an error parsing the CLI arguments to the
scrub or repair commands, like we do most other places in xfs_io.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index fc22ba49..8b3bdd77 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -103,11 +103,14 @@ parse_args(
 	while ((c = getopt(argc, argv, "")) != EOF) {
 		switch (c) {
 		default:
+			exitcode = 1;
 			return command_usage(cmdinfo);
 		}
 	}
-	if (optind > argc - 1)
+	if (optind > argc - 1) {
+		exitcode = 1;
 		return command_usage(cmdinfo);
+	}
 
 	for (i = 0, d = xfrog_scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++) {
 		if (strcmp(d->name, argv[optind]) == 0) {
@@ -117,6 +120,7 @@ parse_args(
 	}
 	if (type < 0) {
 		printf(_("Unknown type '%s'.\n"), argv[optind]);
+		exitcode = 1;
 		return command_usage(cmdinfo);
 	}
 	optind++;
@@ -132,19 +136,22 @@ parse_args(
 				fprintf(stderr,
 					_("Bad inode number '%s'.\n"),
 					argv[optind]);
-				return 0;
+				exitcode = 1;
+				return command_usage(cmdinfo);
 			}
 			control2 = strtoul(argv[optind + 1], &p, 0);
 			if (*p != '\0') {
 				fprintf(stderr,
 					_("Bad generation number '%s'.\n"),
 					argv[optind + 1]);
-				return 0;
+				exitcode = 1;
+				return command_usage(cmdinfo);
 			}
 		} else {
 			fprintf(stderr,
 				_("Must specify inode number and generation.\n"));
-			return 0;
+			exitcode = 1;
+			return command_usage(cmdinfo);
 		}
 		break;
 	case XFROG_SCRUB_TYPE_AGHEADER:
@@ -152,13 +159,15 @@ parse_args(
 		if (optind != argc - 1) {
 			fprintf(stderr,
 				_("Must specify one AG number.\n"));
-			return 0;
+			exitcode = 1;
+			return command_usage(cmdinfo);
 		}
 		control = strtoul(argv[optind], &p, 0);
 		if (*p != '\0') {
 			fprintf(stderr,
 				_("Bad AG number '%s'.\n"), argv[optind]);
-			return 0;
+			exitcode = 1;
+			return command_usage(cmdinfo);
 		}
 		break;
 	case XFROG_SCRUB_TYPE_FS:
@@ -166,7 +175,8 @@ parse_args(
 		if (optind != argc) {
 			fprintf(stderr,
 				_("No parameters allowed.\n"));
-			return 0;
+			exitcode = 1;
+			return command_usage(cmdinfo);
 		}
 		break;
 	default:

