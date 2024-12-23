Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B582A19259D
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990640; cv=none; b=oVnCo5dflbWMxInVSeHTevgrDKsA0YJF/iajL+Sk1cY8B0ujxqcuWRPCjc5k9lGmFF7mHGOtrgHZn+lx6ofiHaX44VydS1sUT3XGSzNK2S7E7z//cVxjz48gBPKs0FGNAizEDon2v6eCiRdin1+gRPYPcTPiwyRusJDLVLyHBJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990640; c=relaxed/simple;
	bh=w4cPHE75WmiMvt1KsVlCPtrrimVYEdCY5WpRejjyRHY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Oh9tglHmNnqQ7A0Y+bSo25IHtCLRzggofYulvi0zi1fznLfgC/cg/NF/7jyhtB2VMbt58emCmf9n4FVMD5GzOdUB51FdVgGMbCNrfTumzePG8Ra81OxsSUb8ZRDqvbs4wVZ+UWjxZGf95iLjaob29lGt210aXdXll1KUj3O6f/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZkoOi9gW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZkoOi9gW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802CFC4CED3;
	Mon, 23 Dec 2024 21:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990640;
	bh=w4cPHE75WmiMvt1KsVlCPtrrimVYEdCY5WpRejjyRHY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZkoOi9gWJ/65cAFl/heOx3Tloj54+sLlSb66xj0fmzak0F+5WJgyQjXhPmgTPYchU
	 i+qqKB7a6Pu7jlvCa4R4rEDw6Wr/vVf35rFT+fjLv/7S+TKyRROvZZwnheGuLYsKmf
	 g+bTsY0QsOUdQdl826EbeW72nbJVpFPdlnUNHLkpqp42iXvP0qm91AjIFo9T2uxPVK
	 I43AWeSe8OXL6JC0IhYI6uLrZCmwHShvK5iaVyqLRxakUK6ztRLMpcJlytzwnuExxe
	 +swvxRfhs9ck1hF1boQ4vPW9HU1gxSQf3Qq4OL5VHCGPUzfd6fpif3ER6A2iw9XK66
	 bB6gFR8FnWrWg==
Date: Mon, 23 Dec 2024 13:50:40 -0800
Subject: [PATCH 16/41] xfs_io: support flag for limited bulkstat of the
 metadata directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498941213.2294268.10575337506816934722.stgit@frogsfrogsfrogs>
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

Support the new XFS_BULK_IREQ_METADIR flag for bulkstat commands.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

