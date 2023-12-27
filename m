Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F457ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cpdgGozP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF37FC433C8;
	Mon,  1 Jan 2024 00:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069568;
	bh=gHrb4zg1fpl6CCmmysDDvtRCYlmOt0cpHSnh9+JvRiw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cpdgGozPEYp/XMb67jRMw21Buij3WaCHspyE14zN28Mz3QxS51rGx4QcqwWBL9PTT
	 rmtTUTsBd0rqQ5rC/MyZjagKIp0fATZrP0v0hmvOsrzLxdqzH2vfsHmsZT5w1+3d2r
	 Qi8GiV3FRnloDw+Kz5/16ZQ6WQPtUjiTTMRF3aK96ka1EMNLCozZ/GMHrVXqBEf5Pm
	 vpKNIhSXL4ZP3bWVQ+aIaj43FLLWcv2lZazt+Njy0oSm3HYqAvIi0RBjqiRHnY+2nH
	 6lN5VyChReh4hkOxIINvBFpXGAailNjiUHPJdmdYcmQjMgt2g8tww+oxBMuqCZo9Cs
	 qcmpuTv9q/LOw==
Date: Sun, 31 Dec 2023 16:39:27 +9900
Subject: [PATCH 5/5] xfs_io: enhance the aginfo command to control the noalloc
 flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405019630.1820520.15020176051154391607.stgit@frogsfrogsfrogs>
In-Reply-To: <170405019560.1820520.7145960948523376788.stgit@frogsfrogsfrogs>
References: <170405019560.1820520.7145960948523376788.stgit@frogsfrogsfrogs>
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

Augment the aginfo command to be able to set and clear the noalloc
state for an AG.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/aginfo.c       |   45 ++++++++++++++++++++++++++++++++++++++++-----
 man/man8/xfs_io.8 |    6 +++++-
 2 files changed, 45 insertions(+), 6 deletions(-)


diff --git a/io/aginfo.c b/io/aginfo.c
index 43e0e9c21b8..8345d25c559 100644
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
index f94de0ce40f..4ae47555ae3 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1240,7 +1240,7 @@ for the current memory mapping.
 
 .SH FILESYSTEM COMMANDS
 .TP
-.BI "aginfo [ \-a " agno " ]"
+.BI "aginfo [ \-a " agno " ] [ \-o " nr " ]"
 Show information about or update the state of allocation groups.
 .RE
 .RS 1.0i
@@ -1248,6 +1248,10 @@ Show information about or update the state of allocation groups.
 .TP
 .BI \-a
 Act only on a specific allocation group.
+.TP
+.BI \-o
+If 0, clear the NOALLOC flag.
+If 1, set the NOALLOC flag.
 .PD
 .RE
 

