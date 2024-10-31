Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A94E1C2DA4
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417013; cv=none; b=UoqRPL++90FzQm6E5aFve0vsUqzziAjqdTlYuciVfZpaTuTsHmFF9RZFSF7fMoNB7+65j7KwrPX3mU3fTFOaihrnBpFVHTVS9gu96IE1kagZhB9BVIZYHQgaALiNiLaumcKUi3C9RnG56nyARvwJxeKx4G35Kka8T46/4mdhaqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417013; c=relaxed/simple;
	bh=YBjtjRd/2OpGEyqikaKzT+On7XFds6AhpRWGYmguWro=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XOzx9Gyafs889wkWFSP5H6PDi8VQ4z1wh0UPkCIylPVKd57rTBRYQOcRvZ+NvV97f2pAEn6hURPsvl+ArlGJQcxDjmR1sepMe9m5gU1XI9dJIlgBsRrOGErrDUIkx6w/HsjJIqfvLsMwHMCKViOLRHqI71+jdP2W2tyRr/D+gjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YZpb1SrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YZpb1SrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267ACC4CEC3;
	Thu, 31 Oct 2024 23:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730417013;
	bh=YBjtjRd/2OpGEyqikaKzT+On7XFds6AhpRWGYmguWro=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YZpb1SrIWHi6ji1q+0LB78+H9bc5x1Auf4eCN4tXN2KFwE4UWeeJbpK3JL6Bjcm11
	 HNnTU7OZqMP1/HYlqCsgzOrWB9Ogic/hnrD8YE6xN0pydsmQlshX1V70kwK8azqlfE
	 H325Fd63dQ8KY2WWsLtelZ8m4prxlEI6PatVz1//T8Z7WGwE19mWKOoD/f+F0raY6F
	 0KyC0IofYW8SDix4Rmbdxep/2s6fv8rQnv9jIyLpYmCQXx3/ZY+249j6k4RhTNNGBd
	 X8URXF+DUFOooRglO3YVv1HaBjtEPnmKlafShSc3Dmhxemw9iEV+nwCYRGHaYIW7aG
	 zu7sc0bknZAtQ==
Date: Thu, 31 Oct 2024 16:23:32 -0700
Subject: [PATCH 1/1] xfs_db: allow setting current address to log blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041567781.964525.1829023710047203991.stgit@frogsfrogsfrogs>
In-Reply-To: <173041567766.964525.18174530428305698304.stgit@frogsfrogsfrogs>
References: <173041567766.964525.18174530428305698304.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add commands so that users can target blocks on an external log device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/block.c        |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_db.8 |   17 +++++++++
 2 files changed, 119 insertions(+), 1 deletion(-)


diff --git a/db/block.c b/db/block.c
index 79ae0ea5802a83..b50b2c16060ac7 100644
--- a/db/block.c
+++ b/db/block.c
@@ -29,6 +29,8 @@ static int	rtblock_f(int argc, char **argv);
 static void	rtblock_help(void);
 static int	rtextent_f(int argc, char **argv);
 static void	rtextent_help(void);
+static int	logblock_f(int argc, char **argv);
+static void	logblock_help(void);
 static void	print_rawdata(void *data, int len);
 
 static const cmdinfo_t	ablock_cmd =
@@ -49,6 +51,9 @@ static const cmdinfo_t	rtblock_cmd =
 static const cmdinfo_t	rtextent_cmd =
 	{ "rtextent", "rtx", rtextent_f, 0, 1, 1, N_("[rtxno]"),
 	  N_("set address to rtextent value"), rtextent_help };
+static const cmdinfo_t	logblock_cmd =
+	{ "logblock", "lsb", logblock_f, 0, 1, 1, N_("[logbno]"),
+	  N_("set address to logblock value"), logblock_help };
 
 static void
 ablock_help(void)
@@ -116,6 +121,7 @@ block_init(void)
 	add_command(&fsblock_cmd);
 	add_command(&rtblock_cmd);
 	add_command(&rtextent_cmd);
+	add_command(&logblock_cmd);
 }
 
 static void
@@ -132,6 +138,7 @@ daddr_help(void)
 enum daddr_target {
 	DT_DATA,
 	DT_RT,
+	DT_LOG,
 };
 
 static int
@@ -146,18 +153,27 @@ daddr_f(
 	int		c;
 	enum daddr_target tgt = DT_DATA;
 
-	while ((c = getopt(argc, argv, "r")) != -1) {
+	while ((c = getopt(argc, argv, "rl")) != -1) {
 		switch (c) {
 		case 'r':
 			tgt = DT_RT;
 			max_daddrs = mp->m_sb.sb_rblocks;
 			break;
+		case 'l':
+			tgt = DT_LOG;
+			max_daddrs = mp->m_sb.sb_logblocks;
+			break;
 		default:
 			daddr_help();
 			return 0;
 		}
 	}
 
+	if (tgt == DT_LOG && mp->m_sb.sb_logstart > 0) {
+		dbprintf(_("filesystem has internal log\n"));
+		return 0;
+	}
+
 	if (optind == argc) {
 		xfs_daddr_t	daddr = iocur_top->off >> BBSHIFT;
 
@@ -192,6 +208,9 @@ daddr_f(
 	case DT_RT:
 		set_rt_cur(&typtab[TYP_DATA], d, bb_count, DB_RING_ADD, NULL);
 		break;
+	case DT_LOG:
+		set_log_cur(&typtab[TYP_DATA], d, bb_count, DB_RING_ADD, NULL);
+		break;
 	}
 	return 0;
 }
@@ -411,6 +430,88 @@ rtextent_f(
 	return 0;
 }
 
+static void
+logblock_help(void)
+{
+	dbprintf(_(
+"\n Example:\n"
+"\n"
+" 'logblock 1023' - sets the file position to the 1023rd log block.\n"
+" The external log device or the block offset within the internal log will be\n"
+" chosen as appropriate.\n"
+));
+}
+
+static int
+logblock_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_fsblock_t	logblock;
+	char		*p;
+
+	if (argc == 1) {
+		if (mp->m_sb.sb_logstart > 0 && iocur_is_ddev(iocur_top)) {
+			logblock = XFS_DADDR_TO_FSB(mp,
+						iocur_top->off >> BBSHIFT);
+
+			if (logblock < mp->m_sb.sb_logstart ||
+			    logblock >= mp->m_sb.sb_logstart +
+					mp->m_sb.sb_logblocks) {
+				dbprintf(
+ _("current address not within internal log\n"));
+				return 0;
+			}
+
+			dbprintf(_("current logblock is %lld\n"),
+					logblock - mp->m_sb.sb_logstart);
+			return 0;
+		}
+
+		if (mp->m_sb.sb_logstart == 0 &&
+		    iocur_is_extlogdev(iocur_top)) {
+			logblock = XFS_BB_TO_FSB(mp,
+						iocur_top->off >> BBSHIFT);
+
+			if (logblock >= mp->m_sb.sb_logblocks) {
+				dbprintf(
+ _("current address not within external log\n"));
+				return 0;
+			}
+
+			dbprintf(_("current logblock is %lld\n"), logblock);
+			return 0;
+		}
+
+		dbprintf(_("current address does not point to log\n"));
+		return 0;
+	}
+
+	logblock = strtoull(argv[1], &p, 0);
+	if (*p != '\0') {
+		dbprintf(_("bad logblock %s\n"), argv[1]);
+		return 0;
+	}
+
+	if (logblock >= mp->m_sb.sb_logblocks) {
+		dbprintf(_("bad logblock %s\n"), argv[1]);
+		return 0;
+	}
+
+	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
+
+	if (mp->m_sb.sb_logstart) {
+		logblock += mp->m_sb.sb_logstart;
+		set_cur(&typtab[TYP_DATA], XFS_FSB_TO_DADDR(mp, logblock),
+				blkbb, DB_RING_ADD, NULL);
+	} else {
+		set_log_cur(&typtab[TYP_DATA], XFS_FSB_TO_BB(mp, logblock),
+				blkbb, DB_RING_ADD, NULL);
+	}
+
+	return 0;
+}
+
 void
 print_block(
 	const field_t	*fields,
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index ffa04879ce76c8..998553684586c7 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -681,6 +681,9 @@ .SH COMMANDS
 .B data
 (uninterpreted).
 
+If an address and the
+.B \-l
+option are specified, the current address is set to the external log device.
 If an address and the
 .B \-r
 option are specified, the current address is set to the realtime device.
@@ -1009,6 +1012,20 @@ .SH COMMANDS
 .IR filename ,
 stop logging, or print the current logging status.
 .TP
+.BI "logblock [" logbno ]
+Set current address to the log block value given by
+.IR logbno .
+If no value for
+.I logbno
+is given the current address is printed, expressed as an fsb.
+The type is set to
+.B data
+(uninterpreted).
+If the filesystem has an external log, then the address will be within the log
+device.
+If the filesystem has an internal log, then the address will be within the
+internal log.
+.TP
 .BI "logformat [\-c " cycle "] [\-s " sunit "]"
 Reformats the log to the specified log cycle and log stripe unit.
 This has the effect of clearing the log destructively.

