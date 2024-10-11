Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEB794A2D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609422; cv=none; b=YGOxy2rpH9nF29+7nLzFApuTB7c0Y1Pf4LnIcxn/b1Zw0ygTCU0Zw0we0rj1E7tv7gWrZv+ubTv1vpOys7JCTmHo2KC/MsJNRtn00l9ycQZoL2N7IMrtXJfZrDorE0bOekhYiGj/dRYa45IaUXedZdvQVpzI8a7HM0rHBF/995w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609422; c=relaxed/simple;
	bh=jXU2cBmGhXTgR41c9Qdhc7+KdtEzzduUtfxJr1eTXug=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VV9E0hLthZjd157eWWHNlFM3zS0Yms/YTm4NXZiwvn+qQCD1OjPKHImh0/j/a3EXmUep0dI693P4AvE44d87UmxDrP3O+jIRED3AE8VDWA4rq4+OmC8zOgZZTH8LthAK0YNuNVn7+DyeqM0VmhieUQsCXS7zxN53/w4qtRLKFLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MI4MwBVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MI4MwBVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F0BC4CEC5;
	Fri, 11 Oct 2024 01:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609422;
	bh=jXU2cBmGhXTgR41c9Qdhc7+KdtEzzduUtfxJr1eTXug=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MI4MwBVXDeE0TP3T6iz9IkKJ5slgl6/eUp7K0dpqt07qBmQbIBF5Y0J4zEi7sQ91c
	 5TWf0l8MqbFT186HrmhqMy5XppuV8QtEY8uoKR/LfMy3cTNIbU1vxK1B52DNLIFqDB
	 5dgliUBhqITUrBH7aW5t78ukS6IDCwQ4c0qJyOyq1JLK6ygT5jxvhuKwIXrNP8+BUb
	 nO/yFzPq2mtPj6eRTUjtfWn76F+jLhi+0Klkrcza7qm0f2lZ9amOfdoyUbxXpg92mB
	 4MyRQEV0iJDBx70+AaZsSGoL/vdnGrjLwU4/rXjNWhLMBHhMicA/EjQswnoXqdvXzy
	 PDfzMrKB/yJHQ==
Date: Thu, 10 Oct 2024 18:17:02 -0700
Subject: [PATCH 11/38] xfs_io: support scrubbing metadata directory paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654145.4183231.15665068172546109736.stgit@frogsfrogsfrogs>
In-Reply-To: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
References: <172860653916.4183231.1358667198522212154.stgit@frogsfrogsfrogs>
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

Support invoking the metadata directory path scrubber from xfs_io for
testing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

