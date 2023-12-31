Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9002EC2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sWhJXZ9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66653C433C7;
	Sun, 31 Dec 2023 23:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065876;
	bh=keXaPgE/1BEarJHHihhlh1+dc0D95dd+Mq2Jlja6cFs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sWhJXZ9KQtwq0ywrQnmKfl/BFiuNQNj2m8J6+9jIMyNmF007d9NZJ7tkhNQPhHP8k
	 3nWn7eWsc98eTtRmpuk3vEzNEpmINW0Kb44CDhNkPwdXXzj+fQFlNnsacEpi+/nzQZ
	 JqnmTD78dH+G8JyTa3cK0zso6shUfq65r8jYPAInmVzLb/h2oApvQ2cNAPdWPmCtLY
	 +mbR1VKXlz2Z7BwUh+NLzItdBCxGtxXnG7uAqx3frxUEMhy5RiHyolH/d7fKraDwjm
	 64JeBws0DImGPiQheTkyVz7cRPEptEhpBT3STRgaKtsJLJVVqABbuureK8m+i3AenG
	 k9nj/6LEtx/qA==
Date: Sun, 31 Dec 2023 15:37:55 -0800
Subject: [PATCH 32/58] xfs_io: support scrubbing metadata directory paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010374.1809361.13532991232757135946.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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
index 456d1594f22..cb4e24503dc 100644
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
 
@@ -500,6 +552,12 @@ scrubv_f(
 	optind++;
 
 	switch (group) {
+	case XFROG_SCRUB_GROUP_METAPATH:
+		if (!parse_metapath(argc, argv, optind, &vhead->svh_ino)) {
+			exitcode = 1;
+			return command_usage(&scrubv_cmd);
+		}
+		break;
 	case XFROG_SCRUB_GROUP_INODE:
 		if (!parse_inode(argc, argv, optind, &vhead->svh_ino,
 						     &vhead->svh_gen)) {
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 1975f5d1011..ef3a5681a1a 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1422,13 +1422,14 @@ Currently supported versions are 1 and 5.
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

