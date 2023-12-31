Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C5AC2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QG89Zk6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4162C433C7;
	Sun, 31 Dec 2023 23:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065860;
	bh=LrmUAeD1dxIFIDkTTojkSt6NAXHcFcrmx/mj3CIXHhs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QG89Zk6yY6FqQ/3k+7bZzHdS05rgpqjXtcI3eR+GQ7ZnJLEakcqM9DDjap/XA8qBn
	 gJC8n9tWmQRBrVTf1rjRBuVVQ7Y+F7nCE71xGo8vMGAwWAOLL09DgJNn4SVnSn9tzw
	 4dqspaHLK06Q/FIfijVsPFbBrkwcxYweJW5kimoadhrJ0k9pWDwG2SsqfSCIb7dNc9
	 zLASUWbypSTJiJvO685dWCSgssym02vNviYpNdxrnQBgNlfV4P4P9jEA7kWeI2JSsj
	 R0Mws1efQEjRefBXRiKUg0WgncJ7uzJ1zrP0kST2ZTqrU4g9zJVXFdRbc8hyAyRXJA
	 Gk2kZ0T63lG0A==
Date: Sun, 31 Dec 2023 15:37:40 -0800
Subject: [PATCH 31/58] xfs_io: support the bulkstat metadata directory flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010361.1809361.3505805825987122661.stgit@frogsfrogsfrogs>
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

Support the new XFS_BULK_IREQ_METADIR flag for bulkstat commands.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/bulkstat.c     |   16 +++++++++++++++-
 man/man8/xfs_io.8 |   10 +++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)


diff --git a/io/bulkstat.c b/io/bulkstat.c
index a9ad87ca183..829f6a02515 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -70,6 +70,7 @@ bulkstat_help(void)
 "   -d         Print debugging output.\n"
 "   -q         Be quiet, no output.\n"
 "   -e <ino>   Stop after this inode.\n"
+"   -m         Include metadata directories.\n"
 "   -n <nr>    Ask for this many results at once.\n"
 "   -s <ino>   Inode to start with.\n"
 "   -v <ver>   Use this version of the ioctl (1 or 5).\n"));
@@ -107,11 +108,12 @@ bulkstat_f(
 	bool			has_agno = false;
 	bool			debug = false;
 	bool			quiet = false;
+	bool			metadir = false;
 	unsigned int		i;
 	int			c;
 	int			ret;
 
-	while ((c = getopt(argc, argv, "a:de:n:qs:v:")) != -1) {
+	while ((c = getopt(argc, argv, "a:de:mn:qs:v:")) != -1) {
 		switch (c) {
 		case 'a':
 			agno = cvt_u32(optarg, 10);
@@ -131,6 +133,9 @@ bulkstat_f(
 				return 1;
 			}
 			break;
+		case 'm':
+			metadir = true;
+			break;
 		case 'n':
 			batch_size = cvt_u32(optarg, 10);
 			if (errno) {
@@ -185,6 +190,8 @@ bulkstat_f(
 
 	if (has_agno)
 		xfrog_bulkstat_set_ag(breq, agno);
+	if (metadir)
+		breq->hdr.flags |= XFS_BULK_IREQ_METADIR;
 
 	set_xfd_flags(&xfd, ver);
 
@@ -253,6 +260,7 @@ bulkstat_single_f(
 	unsigned long		ver = 0;
 	unsigned int		i;
 	bool			debug = false;
+	bool			metadir = false;
 	int			c;
 	int			ret;
 
@@ -261,6 +269,9 @@ bulkstat_single_f(
 		case 'd':
 			debug = true;
 			break;
+		case 'm':
+			metadir = true;
+			break;
 		case 'v':
 			errno = 0;
 			ver = strtoull(optarg, NULL, 10);
@@ -313,6 +324,9 @@ bulkstat_single_f(
 			}
 		}
 
+		if (metadir)
+			flags |= XFS_BULK_IREQ_METADIR;
+
 		ret = -xfrog_bulkstat_single(&xfd, ino, flags, &bulkstat);
 		if (ret) {
 			xfrog_perror(ret, "xfrog_bulkstat_single");
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 5a6b2724504..1975f5d1011 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1240,7 +1240,7 @@ for the current memory mapping.
 
 .SH FILESYSTEM COMMANDS
 .TP
-.BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-n " batchsize " ] [ \-q ] [ \-s " startino " ] [ \-v " version" ]
+.BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-m ] [ \-n " batchsize " ] [ \-q ] [ \-s " startino " ] [ \-v " version" ]
 Display raw stat information about a bunch of inodes in an XFS filesystem.
 Options are as follows:
 .RS 1.0i
@@ -1257,6 +1257,9 @@ Print debugging information about call results.
 Stop displaying records when this inode number is reached.
 Defaults to stopping when the system call stops returning results.
 .TP
+.BI \-m
+Include metadata directories in the output.
+.TP
 .BI \-n " batchsize"
 Retrieve at most this many records per call.
 Defaults to 4,096.
@@ -1277,10 +1280,11 @@ Currently supported versions are 1 and 5.
 .RE
 .PD
 .TP
-.BI "bulkstat_single [ \-d ] [ \-v " version " ] [ " inum... " | " special... " ]
+.BI "bulkstat_single [ \-d ] [ \-m ] [ \-v " version " ] [ " inum... " | " special... " ]
 Display raw stat information about individual inodes in an XFS filesystem.
 The
-.B \-d
+.BR \-d ,
+.BR \-m ,
 and
 .B \-v
 options are the same as the

