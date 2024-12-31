Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C13813FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688660; cv=none; b=pVvCXX1Ej9hB53AiuAAiP3MkvIB1fzk5lqoKHbRk+9VLGDF9Q/Dr0zZS60JU0rgsMsWgpjVl/QQatZz/AUDIWYje1Pbg1+ZhN6//bSOfFlbtE13HJBXkoX4Rf6HruHL/0tcXVcMvOT0z0fN94pN0IlY4hGucS+HRAEGk2tdFc0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688660; c=relaxed/simple;
	bh=lIdImL701tgru6YrzkI7F4ckUkV6qrDcRaxbXhrBQMw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k9aIREPGDdpc59zckYiHq6ukKVcON0dpMyDomjk665dFcoEUswxQa4DQ2KDeK7YswpL22/XDYMsdmnQOPQ2vqbnFvFxr1rcJPKFzSSE+FCQpEWjiwndrqHh9nRaLQEXRmkhib5UoxeMq80IcnAZCmxKk3XCXNrqj+eDmwWbaupg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OapAINpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OapAINpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6695C4CED2;
	Tue, 31 Dec 2024 23:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688659;
	bh=lIdImL701tgru6YrzkI7F4ckUkV6qrDcRaxbXhrBQMw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OapAINpUiWw5C4Dt+WFyfoICJXwFlIjr9QbfVLk1jtok9TNa3Bc62dhOiJJFgDGoW
	 KFlJK2h6+pejSX2Y4V3ZZXF7hlDsIVEWbctV1t6c7f8oXocUbu0lf/Am8AKq8YW4ek
	 i23kRaQEtCtgbucEa3FaD8Iv9iu1RHC9yQjHt0Gy9BpTAtY/mmM7+skEY4PvgCiVSu
	 g1UwN44kXOw+0iXLzFFt8RvttftU4rZSN1ritjbI1P+DblubuHGHnXPybETqpuh/lL
	 xJfhIscYRqRvbFgYHIodK26JbOcYCCyAnMZMc2DALXwgK2iyRAwUtz/LA22AW20v2m
	 bxeLg/D//XgJg==
Date: Tue, 31 Dec 2024 15:44:19 -0800
Subject: [PATCH 5/5] xfs_io: enhance the aginfo command to control the noalloc
 flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568777085.2709441.14866795327136765077.stgit@frogsfrogsfrogs>
In-Reply-To: <173568777001.2709441.13781927144429990672.stgit@frogsfrogsfrogs>
References: <173568777001.2709441.13781927144429990672.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Augment the aginfo command to be able to set and clear the noalloc
state for an AG.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/aginfo.c       |   45 ++++++++++++++++++++++++++++++++++++++++-----
 man/man8/xfs_io.8 |    6 +++++-
 2 files changed, 45 insertions(+), 6 deletions(-)


diff --git a/io/aginfo.c b/io/aginfo.c
index f81986f0df4df3..0320a98b12f981 100644
--- a/io/aginfo.c
+++ b/io/aginfo.c
@@ -19,9 +19,11 @@ static cmdinfo_t rginfo_cmd;
 static int
 report_aginfo(
 	struct xfs_fd		*xfd,
-	xfs_agnumber_t		agno)
+	xfs_agnumber_t		agno,
+	int			oflag)
 {
 	struct xfs_ag_geometry	ageo = { 0 };
+	bool			update = false;
 	int			ret;
 
 	ret = -xfrog_ag_geometry(xfd->fd, agno, &ageo);
@@ -30,6 +32,26 @@ report_aginfo(
 		return 1;
 	}
 
+	switch (oflag) {
+	case 0:
+		ageo.ag_flags |= XFS_AG_FLAG_UPDATE;
+		ageo.ag_flags &= ~XFS_AG_FLAG_NOALLOC;
+		update = true;
+		break;
+	case 1:
+		ageo.ag_flags |= (XFS_AG_FLAG_UPDATE | XFS_AG_FLAG_NOALLOC);
+		update = true;
+		break;
+	}
+
+	if (update) {
+		ret = -xfrog_ag_geometry(xfd->fd, agno, &ageo);
+		if (ret) {
+			xfrog_perror(ret, "aginfo update");
+			return 1;
+		}
+	}
+
 	printf(_("AG: %u\n"),		ageo.ag_number);
 	printf(_("Blocks: %u\n"),	ageo.ag_length);
 	printf(_("Free Blocks: %u\n"),	ageo.ag_freeblks);
@@ -51,6 +73,7 @@ aginfo_f(
 	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
 	unsigned long long	x;
 	xfs_agnumber_t		agno = NULLAGNUMBER;
+	int			oflag = -1;
 	int			c;
 	int			ret = 0;
 
@@ -61,7 +84,7 @@ aginfo_f(
 		return 1;
 	}
 
-	while ((c = getopt(argc, argv, "a:")) != EOF) {
+	while ((c = getopt(argc, argv, "a:o:")) != EOF) {
 		switch (c) {
 		case 'a':
 			errno = 0;
@@ -74,16 +97,27 @@ aginfo_f(
 			}
 			agno = x;
 			break;
+		case 'o':
+			errno = 0;
+			x = strtoll(optarg, NULL, 10);
+			if (!errno && x != 0 && x != 1)
+				errno = ERANGE;
+			if (errno) {
+				perror("aginfo");
+				return 1;
+			}
+			oflag = x;
+			break;
 		default:
 			return command_usage(&aginfo_cmd);
 		}
 	}
 
 	if (agno != NULLAGNUMBER) {
-		ret = report_aginfo(&xfd, agno);
+		ret = report_aginfo(&xfd, agno, oflag);
 	} else {
 		for (agno = 0; !ret && agno < xfd.fsgeom.agcount; agno++) {
-			ret = report_aginfo(&xfd, agno);
+			ret = report_aginfo(&xfd, agno, oflag);
 		}
 	}
 
@@ -98,6 +132,7 @@ aginfo_help(void)
 "Report allocation group geometry.\n"
 "\n"
 " -a agno  -- Report on the given allocation group.\n"
+" -o state -- Change the NOALLOC state for this allocation group.\n"
 "\n"));
 
 }
@@ -107,7 +142,7 @@ static cmdinfo_t aginfo_cmd = {
 	.cfunc = aginfo_f,
 	.argmin = 0,
 	.argmax = -1,
-	.args = "[-a agno]",
+	.args = "[-a agno] [-o state]",
 	.flags = CMD_NOMAP_OK,
 	.help = aginfo_help,
 };
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 59d5ddc54dcc66..a42ab61a0de422 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1243,7 +1243,7 @@ .SH MEMORY MAPPED I/O COMMANDS
 
 .SH FILESYSTEM COMMANDS
 .TP
-.BI "aginfo [ \-a " agno " ]"
+.BI "aginfo [ \-a " agno " ] [ \-o " nr " ]"
 Show information about or update the state of allocation groups.
 .RE
 .RS 1.0i
@@ -1251,6 +1251,10 @@ .SH FILESYSTEM COMMANDS
 .TP
 .BI \-a
 Act only on a specific allocation group.
+.TP
+.BI \-o
+If 0, clear the NOALLOC flag.
+If 1, set the NOALLOC flag.
 .PD
 .RE
 

