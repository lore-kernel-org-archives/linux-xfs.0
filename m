Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF05188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992469; cv=none; b=tLzNgM6h2BvOJsUmsrvlNmbUTKwalFZew21IY4XeRTNsJTF4d3VrLnx7VVBqT6CBBPeiC/0NYnAK9ESWq5ynrbReK6WtIhyobuuZA2FrHt1DwDJiWpfLYZcEtbG6zCaV9L8Gj9pYHFQxg6DwqoQ8l41dTy/WRgzgfZZuQWvAIag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992469; c=relaxed/simple;
	bh=eq6tBtzkd5KsN5NuMuoNphEdw2bw5DY5PeGzwxYYwBc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sGpldq9Bo6Uh/Ba8F2/l+iKVSlMMtxtSDrkr4zmZIP0AJ7rmcvbc74i3wUVo3hbEKuaLTyR5s6aClEpqxjJPrUNwYQGgnuIQQcWec4SYJ1AhHyYe49cnCDG6XPF9ymRsTq4QR9FLniYdDkx5VFF/+J4NNgdlvObQxKaj0SO5Lu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTd3ceGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTd3ceGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBF5C4CED6;
	Mon, 23 Dec 2024 22:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992469;
	bh=eq6tBtzkd5KsN5NuMuoNphEdw2bw5DY5PeGzwxYYwBc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uTd3ceGxu4JacoD4bshzBrNf6L6p11+6a2j3kKhI3HabA20Wu2PqPXglXN+0FwnxX
	 Ac1oHhKa+bGZif3PYRk+8mgIt7nUZ1CGh7CkhrlGWHRWUumUXdjD7/qTVNS+E8EYuq
	 tScmqDG0TR16Ib65FqDnIaEtpj8pt88yThdQKwsFzPnmMM+jJFNbLBugKmHa3PuRYY
	 fBKvZ+gGA9uXd8qLnuPjORBOLf72ivMPHcuDPfLaGLYQu4j5mi9qdZ6N3RWr9TPjFU
	 aD8ynfZKwiYs+NotzqYFb8pFnynp0ZXcVS7o+79lnJ8wYKLyfHW/HZPILM/5FhnknV
	 Zf1EZBUit9RfQ==
Date: Mon, 23 Dec 2024 14:21:09 -0800
Subject: [PATCH 36/51] xfs_io: support scrubbing rtgroup metadata paths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944354.2297565.16014666149393356538.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

