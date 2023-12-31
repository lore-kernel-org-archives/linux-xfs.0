Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED203C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MYSy6H9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA22FC433C7;
	Sun, 31 Dec 2023 23:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066329;
	bh=rA70UZk60/sxeDfRuV3MT8PXdivtF0mjkkliGe8s9jc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MYSy6H9I4m8E+9rFfBNodUIlKlN0+9MlXM1Gbv7zxvEho+pDj5Hg4hIRibsXA3aU7
	 x2QLaz94iWxmwF4+xRt5dV4Cn6vBHEOVXvUSQE4mpYp61T5UvcUR+oUvf13U88rF1y
	 lJYjm8ALPp/Xkihicgh3CvcUhaLKGkDzm7J3yr2hqupI7dB5lSGUPls7++/BPXBEOz
	 CcyFXCTHkrkcAyTp9Ac33IB7AZi0FqzIeSaE8jXiRZzpa82FB/rbPsq3MSoDWIaeZ3
	 fOyo5L0D9BBq6ACZb5triMkSYTpkTZIZ1sfie9zSJkKJMqDvhYvdM8n0OiX8Dfwg0p
	 t4H7eRZjl9KAg==
Date: Sun, 31 Dec 2023 15:45:29 -0800
Subject: [PATCH 3/8] xfs_db: make the daddr command target the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405011059.1810817.6005939440281447162.stgit@frogsfrogsfrogs>
In-Reply-To: <170405011015.1810817.17512390006888048389.stgit@frogsfrogsfrogs>
References: <170405011015.1810817.17512390006888048389.stgit@frogsfrogsfrogs>
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

Make it so that users can issue the command "daddr -r XXX" to select
disk block XXX on the realtime device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c        |   43 ++++++++++++++++++++++++++++++++++++++-----
 man/man8/xfs_db.8 |    6 +++++-
 2 files changed, 43 insertions(+), 6 deletions(-)


diff --git a/db/block.c b/db/block.c
index b2b5edf9385..d064fbed5aa 100644
--- a/db/block.c
+++ b/db/block.c
@@ -31,7 +31,7 @@ static const cmdinfo_t	ablock_cmd =
 	{ "ablock", NULL, ablock_f, 1, 1, 1, N_("filoff"),
 	  N_("set address to file offset (attr fork)"), ablock_help };
 static const cmdinfo_t	daddr_cmd =
-	{ "daddr", NULL, daddr_f, 0, 1, 1, N_("[d]"),
+	{ "daddr", NULL, daddr_f, 0, -1, 1, N_("[d]"),
 	  N_("set address to daddr value"), daddr_help };
 static const cmdinfo_t	dblock_cmd =
 	{ "dblock", NULL, dblock_f, 1, 1, 1, N_("filoff"),
@@ -117,6 +117,11 @@ daddr_help(void)
 ));
 }
 
+enum daddr_target {
+	DT_DATA,
+	DT_RT,
+};
+
 static int
 daddr_f(
 	int		argc,
@@ -124,8 +129,23 @@ daddr_f(
 {
 	int64_t		d;
 	char		*p;
+	int		c;
+	xfs_rfsblock_t	max_daddrs = mp->m_sb.sb_dblocks;
+	enum daddr_target tgt = DT_DATA;
 
-	if (argc == 1) {
+	while ((c = getopt(argc, argv, "r")) != -1) {
+		switch (c) {
+		case 'r':
+			tgt = DT_RT;
+			max_daddrs = mp->m_sb.sb_rblocks;
+			break;
+		default:
+			daddr_help();
+			return 0;
+		}
+	}
+
+	if (optind == argc) {
 		xfs_daddr_t	daddr = iocur_top->off >> BBSHIFT;
 
 		if (iocur_is_ddev(iocur_top))
@@ -139,14 +159,27 @@ daddr_f(
 
 		return 0;
 	}
-	d = (int64_t)strtoull(argv[1], &p, 0);
+
+	if (optind != argc - 1) {
+		daddr_help();
+		return 0;
+	}
+
+	d = (int64_t)strtoull(argv[optind], &p, 0);
 	if (*p != '\0' ||
-	    d >= mp->m_sb.sb_dblocks << (mp->m_sb.sb_blocklog - BBSHIFT)) {
+	    d >= max_daddrs << (mp->m_sb.sb_blocklog - BBSHIFT)) {
 		dbprintf(_("bad daddr %s\n"), argv[1]);
 		return 0;
 	}
 	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
-	set_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
+	switch (tgt) {
+	case DT_DATA:
+		set_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
+		break;
+	case DT_RT:
+		set_rt_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
+		break;
+	}
 	return 0;
 }
 
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index f5e3064d923..dfd44900d15 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -590,7 +590,7 @@ Recalculate the current structure's correct CRC value, and write it to disk.
 Validate and display the current value and state of the structure's CRC.
 .RE
 .TP
-.BI "daddr [" d ]
+.BI "daddr [" -r "] [" d ]
 Set current address to the daddr (512 byte block) given by
 .IR d .
 If no value for
@@ -599,6 +599,10 @@ is given, the current address is printed, expressed as a daddr.
 The type is set to
 .B data
 (uninterpreted).
+
+If an address and the
+.B \-r
+option are specified, the current address is set to the realtime device.
 .TP
 .BI dblock " filoff"
 Set current address to the offset

