Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5451A1422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990656; cv=none; b=PGDwXLYTsWJp5nm595XMf5pLvruMvCT4pLse4PhaN+BmIWIRbH1ib3ujSDX+xKYi3pfo8eJQ1SARSAH8E0QznyrpWjW0pHsgr722T5pAMq/HTnkSdYAkU+sSpVIxXJirITdXm05FChcAd0W/NpKtUxz2ZJ6HAX2/JriGUfuatH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990656; c=relaxed/simple;
	bh=1uYFW+FmgceaORNAYe53w7ng0XVL2zWulfhkiOGas4Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WgNbhrBNkcSZjahhB3qBrOW3cQJglsRdne0E8Jeg+mZ62YG8MqnnvnJ77AJnuRngDlXmcwIJEw3nmiriGXMyRFK2I4HM5+djN/rMSRKzhJIuNQQkNfR9V36eDJJvezB7TfykbD6wVmMchxyYeyT/bRiSpdDtsJGaG+g8lYNFJlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IohBJGXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IohBJGXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D0AC4CED3;
	Mon, 23 Dec 2024 21:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990656;
	bh=1uYFW+FmgceaORNAYe53w7ng0XVL2zWulfhkiOGas4Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IohBJGXNFUn6B9DcnOd96Rl/JfThu3jKW5nebG9GV5W6omGZzQIQePA9O9pYSWhtv
	 VtbnjuFKQ3utAtdEwdKdo39ZDCRcIZvh0ok7313ATYhY8rCGEAkLSW2Djeqfh9R7Pr
	 aGe6PDr1c0Q4jYZ16blDAdOjN8SRD/lbTaSUYPYfWmyxakKHh1z95OtCuMZczQ/WUI
	 yvxqQlWiqrNFIcmkykG8acVwi0zgsTpik0VELTPA2YdOyEH3dr1RFVnpdD/zw8VjWK
	 6uRVJuK9o5/XjVJAf0VeZH7HHvi091VTUaJlFrQRi8l3YgDAxQdibO8YW0ArZoQRpW
	 qe1J66XrIvGzQ==
Date: Mon, 23 Dec 2024 13:50:55 -0800
Subject: [PATCH 17/41] xfs_io: support scrubbing metadata directory paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941228.2294268.440032311520694618.stgit@frogsfrogsfrogs>
In-Reply-To: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
References: <173498940899.2294268.17862292027916012046.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

