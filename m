Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C97FEAF1
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610359; cv=none; b=SBRw6l6WAR9WDdz1fiDwswO3VeGqJ+Qk+hXpei1biNW6DcFyCTwy4pp0grX7fhASJEplJHxmR+iGeoyYpmDZJ01+w5bOG4R7qU1uFllzWMx2cxwJ1004ybRar+4IRi1GW1eYvvq47dWMuMXSp/T09fGqwnS8YLJVU3o/ww/ZvOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610359; c=relaxed/simple;
	bh=fl9r9m/8kfFSFAcBEvC4h2oMlnIkR4r45qakhy14mGw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VqikOIm2Smb1lqmsJ63GzTqWwUEhkIAQMpJVnW0srbqJwNoh+fF0PMGNQcYxIMCoRwjIEXDWYlnSu0y2SkXMBIwXv7PDN3yrpBAHNE7aceldBTnL714NPz7vOnTZdRvm3YU48ePXPfjWl7bjZxK9AWm8PEkiscGU+zH7ZqNe+Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LMDW0/zN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LMDW0/zN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94B4C4CECD;
	Fri, 11 Oct 2024 01:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610359;
	bh=fl9r9m/8kfFSFAcBEvC4h2oMlnIkR4r45qakhy14mGw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LMDW0/zNBKJOtnLIUD8HmeBswHL5jqfEaEfArQAhYnnh3tG6LlUeJNXbXM6V0bRqJ
	 c0Ikrpe3R+i0LejX7TqDYDt7dctEEoDqJZupc34nIiPI9AZ+IP5cv6E5p1dM9eUhZr
	 egDNf7osHFkeCF4kKaK4+bvML0b21VRX83hq+aJs09tR/dF7WL0VFz69kGMnAOCcI+
	 kFDS1OA2CTJPwMxG217VxXcvC+Hl/N+mBfOSlk/JSj0ZzeNql56ma4DvnRLm+Ba36P
	 HoJ0jJNk/lYLfWeaCs0NfTncPZwj2QMUcXGoQVSfxjzMqtsN74VB14nuMC1Tp8lymq
	 olzbKLYxK+XKg==
Date: Thu, 10 Oct 2024 18:32:38 -0700
Subject: [PATCH 31/43] xfs_io: support scrubbing rtgroup metadata paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655841.4184637.9164778130566548977.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
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
index 99c24d9550243c..a137f402b94d48 100644
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
+	if (xfrog_metapaths[control].group == XFROG_SCRUB_GROUP_RTGROUP) {
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
@@ -582,7 +610,8 @@ scrubv_f(
 
 	switch (group) {
 	case XFROG_SCRUB_GROUP_METAPATH:
-		if (!parse_metapath(argc, argv, optind, &scrubv.head.svh_ino)) {
+		if (!parse_metapath(argc, argv, optind, &scrubv.head.svh_ino,
+				    &scrubv.head.svh_agno)) {
 			exitcode = 1;
 			return command_usage(&scrubv_cmd);
 		}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 6775b0a273e5aa..4673b071901c28 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1425,7 +1425,7 @@ .SH FILESYSTEM COMMANDS
 .RE
 .PD
 .TP
-.BI "scrub " type " [ " agnumber " | " rgnumber " | " "ino" " " "gen" " | " metapath " ]"
+.BI "scrub " type " [ " agnumber " | " rgnumber " | " "ino" " " "gen" " | " metapath " [ " rgnumber " ] ]"
 Scrub internal XFS filesystem metadata.  The
 .BI type
 parameter specifies which type of metadata to scrub.
@@ -1434,6 +1434,7 @@ .SH FILESYSTEM COMMANDS
 For file metadata, the scrub is applied to the open file unless the
 inode number and generation number are specified.
 For metapath, the name of a file or a raw number must be specified.
+If the metapath file is a per-rtgroup file, the group number must be specified.
 .RE
 .PD
 .TP

