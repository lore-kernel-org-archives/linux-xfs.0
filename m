Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6A2196
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530493; cv=none; b=IqfIFDHYIi/WrC0q4WMEdmtSfOVb6CDqqi4/X3FK38znEIzpT7njymXRRltnwz/6g8hew0plLQnxNBaU1WdRzPDyj0Sj+X5RVyLpd9fiQgoSec9PgP+FJIejCr+ULaTMzPtXd17YGksTpi3i2ttCGDSjtAVfy7RMyfGBmc3m7m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530493; c=relaxed/simple;
	bh=2cuu2UUfHmmcZPCgm1HX3dXqr21jX0koMhOSBu+vV30=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f0SjRN7DSqdtUv0VmaGnjkT6Hs+3t/R5OYb2HKFPk3r1XPudtKjXbLhS/CFvoUcXXEbd+7XGEHQSV1TYH658dbB/Q4cR4fdJyYze4YbpA5rmbSttlmynnKQY+N3tLM0FLxCWhY5ke+b0EuOfiC4K+ghJbUSaV2OfJiVC2jJnxFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sTvmqRXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sTvmqRXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF5CC4CED1;
	Sat,  7 Dec 2024 00:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530492;
	bh=2cuu2UUfHmmcZPCgm1HX3dXqr21jX0koMhOSBu+vV30=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sTvmqRXzpi7qRLsAG+LcGjjGm/Z/vOU2jSbYQuQrdJ9GVgqSgLdfCbTTnFlyeYUIN
	 TN9JjZgsZiBGBcpR77qBquJRSDFQ1VZC90g4aitM3EU0BCeInwzSh5ejLQrqVfkA7d
	 QOJQPmV/Dhk9LtciLVp5NtBw4FAbPtxDxVHfK2VgrmTlPANT/YJx6XTPmcTMgq2KJf
	 STiAnYVA9D4Q/MuM1h0DgCAu7UFdDvzJactAOZCA4eW7tNlkSpmGgcnNvSYe71G8s8
	 fT4nEWTKFohX65JYAoVMXLEh4W+RFtIzKcU+G0k2x5/mXmRa+8CpQc/UTfFd8c9Cbv
	 yxPQqfDaA3b/A==
Date: Fri, 06 Dec 2024 16:14:52 -0800
Subject: [PATCH 38/50] xfs_io: support scrubbing rtgroup metadata paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752526.126362.1330837670564192968.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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

