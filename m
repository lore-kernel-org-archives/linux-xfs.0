Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70BB14D717
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528629; cv=none; b=nIhr/6eKdRPyuvBa2USI2o+5E0fJYoneV0A4ztK97WoUSJEk2CGAmaAOO2xDiqyZXkVOHNYMEQKS4WKCwmaifsfzJYguCGS3Fa41pG6KYfYiYZwyK/05EhKVGZShzEQ6tt/WdtTbvGRc+8t04DdtNq5igs6AtJkJ8FlSWp4L29Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528629; c=relaxed/simple;
	bh=95tcmvUy/aa9REApCaG9Y/9vBC/Ul37F+xmPmgCJyM8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RUMnFu+jWEdYW91KTnamgxCvuN8s+AqgaLKHSiG4czewEmXydNze9rDe3sQkiPDn+TBx0mgKx974+yy4UmpUd7GdvmO754jBb1AK0kFSFObHKqsqI3lb1rmbxPTmsWUJsw/CnNe6JedyS/xQGjV7C7FF9+FuwbuA4z7tvLBzaW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nTemEOlX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nTemEOlX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A083CC4CED1;
	Fri,  6 Dec 2024 23:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528629;
	bh=95tcmvUy/aa9REApCaG9Y/9vBC/Ul37F+xmPmgCJyM8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nTemEOlXsF269o/MT8DLsY6VxFhQi9EAZy6q0l1vXLGP1dFWaX0oRltus96iVKUIa
	 uaIcYvdmibPpL0fhs6JKQ33FEowHuBqawc0kXeRBvuYvTkZxPiePrtpYiWSf1eFyo/
	 sBSoc8RxiJc5s4qNw55/cSfOewpxSDi9pP4eaYZiN6waGEpeL37NjMalA7AKBQnLCA
	 FxCQSLFwJ3j6dYnH2OoGoESVaLa2I+DZVFsS8wUqD7y/CD/p1Dskf78MoHz9LBNNQI
	 dTLND5s6iIYQ6aIGdHeV8k0x20lI4Go5/5vV8sWXVeZKAgF7NV9QVd3nb1lq6OpH44
	 M/4xoJdk81YMg==
Date: Fri, 06 Dec 2024 15:43:49 -0800
Subject: [PATCH 16/41] xfs_io: support scrubbing metadata directory paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748483.122992.13810127442680845944.stgit@frogsfrogsfrogs>
In-Reply-To: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Support invoking the metadata directory path scrubber from xfs_io for
testing.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/scrub.c        |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 man/man8/xfs_io.8 |    3 ++-
 2 files changed, 62 insertions(+), 3 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index e03c1d0eaf1db8..45229a8ae81099 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -41,6 +41,12 @@ scrub_help(void)
 " Known metadata scrub types are:"));
 	for (i = 0, d = xfrog_scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++)
 		printf(" %s", d->name);
+	printf(_(
+"\n"
+"\n"
+" Known metapath scrub arguments are:"));
+	for (i = 0, d = xfrog_metapaths; i < XFS_SCRUB_METAPATH_NR; i++, d++)
+		printf(" %s", d->name);
 	printf("\n");
 }
 
@@ -125,6 +131,40 @@ parse_none(
 	return true;
 }
 
+static bool
+parse_metapath(
+	int		argc,
+	char		**argv,
+	int		optind,
+	__u64		*ino)
+{
+	char		*p;
+	unsigned long long control;
+	int		i;
+
+	if (optind != argc - 1) {
+		fprintf(stderr, _("Must specify metapath number.\n"));
+		return false;
+	}
+
+	for (i = 0; i < XFS_SCRUB_METAPATH_NR; i++) {
+		if (!strcmp(argv[optind], xfrog_metapaths[i].name)) {
+			*ino = i;
+			return true;
+		}
+	}
+
+	control = strtoll(argv[optind], &p, 0);
+	if (*p != '\0') {
+		fprintf(stderr, _("Bad metapath number '%s'.\n"),
+				argv[optind]);
+		return false;
+	}
+
+	*ino = control;
+	return true;
+}
+
 static int
 parse_args(
 	int				argc,
@@ -170,6 +210,12 @@ parse_args(
 	meta->sm_flags = flags;
 
 	switch (d->group) {
+	case XFROG_SCRUB_GROUP_METAPATH:
+		if (!parse_metapath(argc, argv, optind, &meta->sm_ino)) {
+			exitcode = 1;
+			return command_usage(cmdinfo);
+		}
+		break;
 	case XFROG_SCRUB_GROUP_INODE:
 		if (!parse_inode(argc, argv, optind, &meta->sm_ino,
 						     &meta->sm_gen)) {
@@ -244,7 +290,7 @@ scrub_init(void)
 	scrub_cmd.argmin = 1;
 	scrub_cmd.argmax = -1;
 	scrub_cmd.flags = CMD_NOMAP_OK;
-	scrub_cmd.args = _("type [agno|ino gen]");
+	scrub_cmd.args = _("type [agno|ino gen|metapath]");
 	scrub_cmd.oneline = _("scrubs filesystem metadata");
 	scrub_cmd.help = scrub_help;
 
@@ -275,6 +321,12 @@ repair_help(void)
 " Known metadata repair types are:"));
 	for (i = 0, d = xfrog_scrubbers; i < XFS_SCRUB_TYPE_NR; i++, d++)
 		printf(" %s", d->name);
+	printf(_(
+"\n"
+"\n"
+" Known metapath repair arguments are:"));
+	for (i = 0, d = xfrog_metapaths; i < XFS_SCRUB_METAPATH_NR; i++, d++)
+		printf(" %s", d->name);
 	printf("\n");
 }
 
@@ -327,7 +379,7 @@ repair_init(void)
 	repair_cmd.argmin = 1;
 	repair_cmd.argmax = -1;
 	repair_cmd.flags = CMD_NOMAP_OK;
-	repair_cmd.args = _("type [agno|ino gen]");
+	repair_cmd.args = _("type [agno|ino gen|metapath]");
 	repair_cmd.oneline = _("repairs filesystem metadata");
 	repair_cmd.help = repair_help;
 
@@ -495,6 +547,12 @@ scrubv_f(
 	optind++;
 
 	switch (group) {
+	case XFROG_SCRUB_GROUP_METAPATH:
+		if (!parse_metapath(argc, argv, optind, &scrubv.head.svh_ino)) {
+			exitcode = 1;
+			return command_usage(&scrubv_cmd);
+		}
+		break;
 	case XFROG_SCRUB_GROUP_INODE:
 		if (!parse_inode(argc, argv, optind, &scrubv.head.svh_ino,
 						     &scrubv.head.svh_gen)) {
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index fb7a026224fda7..c73fee7c2780c6 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1425,13 +1425,14 @@ .SH FILESYSTEM COMMANDS
 .RE
 .PD
 .TP
-.BI "scrub " type " [ " agnumber " | " "ino" " " "gen" " ]"
+.BI "scrub " type " [ " agnumber " | " "ino" " " "gen" " | " metapath " ]"
 Scrub internal XFS filesystem metadata.  The
 .BI type
 parameter specifies which type of metadata to scrub.
 For AG metadata, one AG number must be specified.
 For file metadata, the scrub is applied to the open file unless the
 inode number and generation number are specified.
+For metapath, the name of a file or a raw number must be specified.
 .RE
 .PD
 .TP

