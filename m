Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171FC4A33
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609407; cv=none; b=AExpMaImjpxT7HI7Ur7jh/9gFAE8/kvYLPgNJsG8zvzlm1vXa+VlyxMFRFEbvXRer0Wmdkzx+kRtQ0Xv7JM5Np3HZgdd7odjoDx9McAJ/YopD9s4O+POk2yc3On9JcArUWUQM34lBWTJZ+e3Yj6KIfxq6cDQiEkuzT0jsF1uzJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609407; c=relaxed/simple;
	bh=gyfoFfF76oawmvV7W5bxPZGvExxB8J1jbg1w+D1rPMI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sYDVY2c70dZfxTpssJpGtTFmwiRTa3S+8FPp1ZnJvak7cRT0xESpE/FlG7eOnpa5aWKDrY7EKs/bcr/OaINpox4XyN2yB8NroinpuhEQvWuTO25ZPKK5afu1XzRdXiuJT4slMqnE61+L2MMjqIQLEdZG7SHLER3inYB8kput7sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YgNhKOLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YgNhKOLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C84C4CEC6;
	Fri, 11 Oct 2024 01:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609407;
	bh=gyfoFfF76oawmvV7W5bxPZGvExxB8J1jbg1w+D1rPMI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YgNhKOLcF4bwKAqYdonym5D0qKdsEA4jy7OhJWzkV1UEMhkWvGSTkwrDRgfBCZnOw
	 4u3Oe7sNYA2VRB6rcwzBEkpMLGBDUBBcEhKPLmtO3XCwg7UDbv1FL41oxVCbUIEYa3
	 AmUFbuv+BXIaCQq8wn+icwzuRC4hz6mRosgJQaiKoQPwXhbIpPQVRyyIKWhZ+1H3Zr
	 RieD2+/cRsdPbIwdx3qfjFEzNhFBzGSmq4i5zFJXkL+2pEwkOBZ1RyINpttDLKZueh
	 146oA16/kas7v0SCav7a12a5dQKimQ7neFUx3xR2aJqeu5UbF1Yj4fmTpW9P4c4G5d
	 9O0P4wDnrs/fA==
Date: Thu, 10 Oct 2024 18:16:46 -0700
Subject: [PATCH 10/38] xfs_io: support the bulkstat metadata directory flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860654130.4183231.8631766968893851561.stgit@frogsfrogsfrogs>
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

Support the new XFS_BULK_IREQ_METADIR flag for bulkstat commands.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/bulkstat.c     |   16 +++++++++++++++-
 man/man8/xfs_io.8 |   10 +++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)


diff --git a/io/bulkstat.c b/io/bulkstat.c
index 06023e1289e420..f312c6d55f47bc 100644
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
index eb2201fca74380..fb7a026224fda7 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1243,7 +1243,7 @@ .SH MEMORY MAPPED I/O COMMANDS
 
 .SH FILESYSTEM COMMANDS
 .TP
-.BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-n " batchsize " ] [ \-q ] [ \-s " startino " ] [ \-v " version" ]
+.BI "bulkstat [ \-a " agno " ] [ \-d ] [ \-e " endino " ] [ \-m ] [ \-n " batchsize " ] [ \-q ] [ \-s " startino " ] [ \-v " version" ]
 Display raw stat information about a bunch of inodes in an XFS filesystem.
 Options are as follows:
 .RS 1.0i
@@ -1260,6 +1260,9 @@ .SH FILESYSTEM COMMANDS
 Stop displaying records when this inode number is reached.
 Defaults to stopping when the system call stops returning results.
 .TP
+.BI \-m
+Include metadata directories in the output.
+.TP
 .BI \-n " batchsize"
 Retrieve at most this many records per call.
 Defaults to 4,096.
@@ -1280,10 +1283,11 @@ .SH FILESYSTEM COMMANDS
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

