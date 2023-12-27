Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B835389
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K52id64e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5D3C433C8;
	Mon,  1 Jan 2024 00:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068254;
	bh=R6gAFhOyzPFSoi+piO9GEISbBg+ArNB9mwUp/HRJ/K8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K52id64eDtnhqQtnQHWJYHuhmmAYEJJX+QXUIN01Zqv0YtDbUVPtKMEfP16sjJWa0
	 h7LtFMQdFrhpw2JXkMhjBtzIwtV5C1bYS5g7kdHfyWqODdMxsuRApt4+B++O8u5Aai
	 GZIPYZEtGcbltm8bqbxTc5m3FaWZmf+y7D/bl5iMSd6zSaKOfdPqOePvczRvnKkePc
	 d60T1z7luazOJTrApQG0PpPtw4Z9+wJZG+FkXzeMi1zNLRfFqz+JOf/fVuDkck5WS3
	 XXqBgiy6AOqjl5ZdQnc5AT6g6jTzw0OG0DCYXIoJ9iKMtQnBboLQkVY1yDIbwtp46C
	 dj5tWxcuP6uRQ==
Date: Sun, 31 Dec 2023 16:17:33 +9900
Subject: [PATCH 27/47] xfs_io: support scrubbing rtgroup metadata paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015672.1815505.2648554341105907093.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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

Support scrubbing the metadata directory path of an rtgroup metadata
file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c        |   41 +++++++++++++++++++++++++++++++++++------
 man/man8/xfs_io.8 |    3 ++-
 2 files changed, 37 insertions(+), 7 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index e9254c7882a..72296cbe86a 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -136,21 +136,23 @@ parse_metapath(
 	int		argc,
 	char		**argv,
 	int		optind,
-	__u64		*ino)
+	__u64		*ino,
+	__u32		*group)
 {
 	char		*p;
 	unsigned long long control;
+	unsigned long	control2 = 0;
 	int		i;
 
-	if (optind != argc - 1) {
+	if (optind != argc - 1 && optind != argc - 2) {
 		fprintf(stderr, _("Must specify metapath number.\n"));
 		return false;
 	}
 
 	for (i = 0; i < XFS_SCRUB_METAPATH_NR; i++) {
 		if (!strcmp(argv[optind], xfrog_metapaths[i].name)) {
-			*ino = i;
-			return true;
+			control = i;
+			goto find_group;
 		}
 	}
 
@@ -161,7 +163,32 @@ parse_metapath(
 		return false;
 	}
 
+find_group:
+	if (xfrog_metapaths[*ino].group == XFROG_SCRUB_GROUP_RTGROUP) {
+		if (optind == argc - 1) {
+			fprintf(stderr,
+_("%s: Metapath requires a group number.\n"),
+					xfrog_metapaths[*ino].name);
+			return false;
+		}
+		control2 = strtoul(argv[optind + 1], &p, 0);
+		if (*p != '\0') {
+			fprintf(stderr,
+ _("Bad group number '%s'.\n"),
+				argv[optind + 1]);
+			return false;
+		}
+	} else {
+		if (optind == argc - 2) {
+			fprintf(stderr,
+_("%s: Metapath does not take a second argument.\n"),
+					xfrog_metapaths[*ino].name);
+			return false;
+		}
+	}
+
 	*ino = control;
+	*group = control2;
 	return true;
 }
 
@@ -237,7 +264,8 @@ parse_args(
 
 	switch (d->group) {
 	case XFROG_SCRUB_GROUP_METAPATH:
-		if (!parse_metapath(argc, argv, optind, &meta->sm_ino)) {
+		if (!parse_metapath(argc, argv, optind, &meta->sm_ino,
+							&meta->sm_agno)) {
 			exitcode = 1;
 			return command_usage(cmdinfo);
 		}
@@ -587,7 +615,8 @@ scrubv_f(
 
 	switch (group) {
 	case XFROG_SCRUB_GROUP_METAPATH:
-		if (!parse_metapath(argc, argv, optind, &vhead->svh_ino)) {
+		if (!parse_metapath(argc, argv, optind, &vhead->svh_ino,
+							&vhead->svh_agno)) {
 			exitcode = 1;
 			return command_usage(&scrubv_cmd);
 		}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 6cf4b9e32e5..f94de0ce40f 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1447,7 +1447,7 @@ Currently supported versions are 1 and 5.
 .RE
 .PD
 .TP
-.BI "scrub " type " [ " agnumber " | " rgnumber " | " "ino" " " "gen" " | " metapath " ]"
+.BI "scrub " type " [ " agnumber " | " rgnumber " | " "ino" " " "gen" " | " metapath " [ " rgnumber " ] ]"
 Scrub internal XFS filesystem metadata.  The
 .BI type
 parameter specifies which type of metadata to scrub.
@@ -1456,6 +1456,7 @@ For realtime group metadata, one rtgroup number must be specified.
 For file metadata, the scrub is applied to the open file unless the
 inode number and generation number are specified.
 For metapath, the name of a file or a raw number must be specified.
+If the metapath file is a per-rtgroup file, the group number must be specified.
 .RE
 .PD
 .TP

