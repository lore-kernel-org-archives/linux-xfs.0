Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2886814D717
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528614; cv=none; b=cHqNRqU0G+KLhrv5dAv3gv/n79bLlYrA0Pun9U3O4VWIZu5ptOhN0s2jSxHA8ak9fWiDaezPsv3LI3bv8LWJW2vdMZaixXTqiH/taHpa+q7aJNlQ65WRXK2hwCF910pfj51YAv/9njDon7k6bahzAPpK3o9Sx+EJyOtghLv+Les=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528614; c=relaxed/simple;
	bh=gCVZmQGMVWtnrFFhQJsg4HVP4rA9dHK4GLP4vekB8kI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u6go7cWjCaHCQj+Cp3JdrLQh2oUMiB3NadCGC3FEDKklbhjqbQyVdPgUdYoqUM72LGJ+LIoQ/J6kCGtwafeHoFc2J+wv++pqYyEyUoFyJ1Aky3pv0HNGykA2Cako9sL+jYfJ/DmC0hQuUMMpKeN55eHAHUhxwpLKNMAR7Ey0EMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g4jRQYla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4jRQYla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2099C4CED1;
	Fri,  6 Dec 2024 23:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528614;
	bh=gCVZmQGMVWtnrFFhQJsg4HVP4rA9dHK4GLP4vekB8kI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=g4jRQYlaeGL9wa4KKDgAhvyPvgiADxAX/gxOimmsElfFu1+xdjgaFF8srQWC0nhUa
	 ZaHveAJVoaupt65+AmyoENz77APFA1QiDCPQB9fjE84+EQzHTWuJ6yJap0h/DOkiS4
	 6l6rf41qA4CgBqIq19TTvBOmXNkkpvYl7eOaEfXA8ov2dFH2CBdQsCYvwxvVgBRHQZ
	 J43AzWFsVador30Cf8CUV94+/EZnpa1xV44fxbvXUxe3+hqt2Xj0Zxm77rkNpljBjt
	 UIqOkzUdx5MZ/an11FJ5Vl7+lOYnCLdmR7L2yRD1C+FTJzXaf/Cfxg4poKQu5njBu9
	 EUJQUk4NhSQ1A==
Date: Fri, 06 Dec 2024 15:43:33 -0800
Subject: [PATCH 15/41] xfs_io: support the bulkstat metadata directory flag
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352748467.122992.7994504931432399626.stgit@frogsfrogsfrogs>
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

Support the new XFS_BULK_IREQ_METADIR flag for bulkstat commands.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
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

