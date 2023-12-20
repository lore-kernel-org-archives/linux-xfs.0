Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA0B47787
	for <linux-xfs@vger.kernel.org>; Wed, 20 Dec 2023 17:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ernGT/6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A19C433C7;
	Wed, 20 Dec 2023 17:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703092489;
	bh=gZHG9gFNGDYJOMfHUNWI/dOFGVtRgNuxNifk+/8yYvA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ernGT/6gjwdjP5KPgiAK4q1wWorgX8NJTlRclXZIc7EDaM5vpSKhMBCC6nHjfbSWH
	 1Iua3ITvsKGgZbH557PDs4rYlbBhTMbx87UcT+hbxV2x5qci+AhquFNrFfhd7AcM4o
	 yT9Iz57MpzrmAGbYdSWOPCzF0B4amQjDEdUYH7+EoNu8azAB74fJUEV4rnEK3MOwOs
	 DMZ1Mgbs+vMd7OtCe9KvXFpmC7Q013eT6bnuy84RKShhMF9npB1zTqvXXmSM8rmisf
	 D2mSEJ21DDVtvFhg9JsgdnF73VIUu5+tv8nk3lGwWMjtSSIyo/8VhGDd7IjM+xHrWV
	 CHwfyCDrB/G0Q==
Date: Wed, 20 Dec 2023 09:14:48 -0800
Subject: [PATCH 2/4] xfs_io: collapse trivial helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170309219107.1608142.4643674100831010643.stgit@frogsfrogsfrogs>
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

Simply the call chain by having parse_args set the scrub ioctl
parameters in the caller's object.  The parse_args callers can then
invoke the ioctl directly, eliminating one function and one indirect
call.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/scrub.c |  124 +++++++++++++++++++-----------------------------------------
 1 file changed, 40 insertions(+), 84 deletions(-)


diff --git a/io/scrub.c b/io/scrub.c
index 8b3bdd77..238d9240 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -41,57 +41,12 @@ scrub_help(void)
 	printf("\n");
 }
 
-static void
-scrub_ioctl(
-	int				fd,
-	int				type,
-	uint64_t			control,
-	uint32_t			control2)
-{
-	struct xfs_scrub_metadata	meta;
-	const struct xfrog_scrub_descr	*sc;
-	int				error;
-
-	sc = &xfrog_scrubbers[type];
-	memset(&meta, 0, sizeof(meta));
-	meta.sm_type = type;
-	switch (sc->type) {
-	case XFROG_SCRUB_TYPE_AGHEADER:
-	case XFROG_SCRUB_TYPE_PERAG:
-		meta.sm_agno = control;
-		break;
-	case XFROG_SCRUB_TYPE_INODE:
-		meta.sm_ino = control;
-		meta.sm_gen = control2;
-		break;
-	case XFROG_SCRUB_TYPE_NONE:
-	case XFROG_SCRUB_TYPE_FS:
-		/* no control parameters */
-		break;
-	}
-	meta.sm_flags = 0;
-
-	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
-	if (error)
-		perror("scrub");
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		printf(_("Corruption detected.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_PREEN)
-		printf(_("Optimization possible.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_XFAIL)
-		printf(_("Cross-referencing failed.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)
-		printf(_("Corruption detected during cross-referencing.\n"));
-	if (meta.sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
-		printf(_("Scan was not complete.\n"));
-}
-
 static int
 parse_args(
 	int				argc,
 	char				**argv,
-	struct cmdinfo			*cmdinfo,
-	void				(*fn)(int, int, uint64_t, uint32_t))
+	const struct cmdinfo		*cmdinfo,
+	struct xfs_scrub_metadata	*meta)
 {
 	char				*p;
 	int				type = -1;
@@ -100,6 +55,7 @@ parse_args(
 	uint32_t			control2 = 0;
 	const struct xfrog_scrub_descr	*d = NULL;
 
+	memset(meta, 0, sizeof(struct xfs_scrub_metadata));
 	while ((c = getopt(argc, argv, "")) != EOF) {
 		switch (c) {
 		default:
@@ -125,6 +81,8 @@ parse_args(
 	}
 	optind++;
 
+	meta->sm_type = type;
+
 	switch (d->type) {
 	case XFROG_SCRUB_TYPE_INODE:
 		if (optind == argc) {
@@ -153,6 +111,8 @@ parse_args(
 			exitcode = 1;
 			return command_usage(cmdinfo);
 		}
+		meta->sm_ino = control;
+		meta->sm_gen = control2;
 		break;
 	case XFROG_SCRUB_TYPE_AGHEADER:
 	case XFROG_SCRUB_TYPE_PERAG:
@@ -169,6 +129,7 @@ parse_args(
 			exitcode = 1;
 			return command_usage(cmdinfo);
 		}
+		meta->sm_agno = control;
 		break;
 	case XFROG_SCRUB_TYPE_FS:
 	case XFROG_SCRUB_TYPE_NONE:
@@ -178,13 +139,12 @@ parse_args(
 			exitcode = 1;
 			return command_usage(cmdinfo);
 		}
+		/* no control parameters */
 		break;
 	default:
 		ASSERT(0);
 		break;
 	}
-	fn(file->fd, type, control, control2);
-
 	return 0;
 }
 
@@ -193,7 +153,27 @@ scrub_f(
 	int				argc,
 	char				**argv)
 {
-	return parse_args(argc, argv, &scrub_cmd, scrub_ioctl);
+	struct xfs_scrub_metadata	meta;
+	int				error;
+
+	error = parse_args(argc, argv, &scrub_cmd, &meta);
+	if (error)
+		return error;
+
+	error = ioctl(file->fd, XFS_IOC_SCRUB_METADATA, &meta);
+	if (error)
+		perror("scrub");
+	if (meta.sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		printf(_("Corruption detected.\n"));
+	if (meta.sm_flags & XFS_SCRUB_OFLAG_PREEN)
+		printf(_("Optimization possible.\n"));
+	if (meta.sm_flags & XFS_SCRUB_OFLAG_XFAIL)
+		printf(_("Cross-referencing failed.\n"));
+	if (meta.sm_flags & XFS_SCRUB_OFLAG_XCORRUPT)
+		printf(_("Corruption detected during cross-referencing.\n"));
+	if (meta.sm_flags & XFS_SCRUB_OFLAG_INCOMPLETE)
+		printf(_("Scan was not complete.\n"));
+	return 0;
 }
 
 void
@@ -236,37 +216,20 @@ repair_help(void)
 	printf("\n");
 }
 
-static void
-repair_ioctl(
-	int				fd,
-	int				type,
-	uint64_t			control,
-	uint32_t			control2)
+static int
+repair_f(
+	int				argc,
+	char				**argv)
 {
 	struct xfs_scrub_metadata	meta;
-	const struct xfrog_scrub_descr	*sc;
 	int				error;
 
-	sc = &xfrog_scrubbers[type];
-	memset(&meta, 0, sizeof(meta));
-	meta.sm_type = type;
-	switch (sc->type) {
-	case XFROG_SCRUB_TYPE_AGHEADER:
-	case XFROG_SCRUB_TYPE_PERAG:
-		meta.sm_agno = control;
-		break;
-	case XFROG_SCRUB_TYPE_INODE:
-		meta.sm_ino = control;
-		meta.sm_gen = control2;
-		break;
-	case XFROG_SCRUB_TYPE_NONE:
-	case XFROG_SCRUB_TYPE_FS:
-		/* no control parameters */
-		break;
-	}
-	meta.sm_flags = XFS_SCRUB_IFLAG_REPAIR;
+	error = parse_args(argc, argv, &repair_cmd, &meta);
+	if (error)
+		return error;
+	meta.sm_flags |= XFS_SCRUB_IFLAG_REPAIR;
 
-	error = ioctl(fd, XFS_IOC_SCRUB_METADATA, &meta);
+	error = ioctl(file->fd, XFS_IOC_SCRUB_METADATA, &meta);
 	if (error)
 		perror("repair");
 	if (meta.sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
@@ -281,14 +244,7 @@ repair_ioctl(
 		printf(_("Repair was not complete.\n"));
 	if (meta.sm_flags & XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 		printf(_("Metadata did not need repair or optimization.\n"));
-}
-
-static int
-repair_f(
-	int				argc,
-	char				**argv)
-{
-	return parse_args(argc, argv, &repair_cmd, repair_ioctl);
+	return 0;
 }
 
 void

