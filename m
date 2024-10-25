Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D7D18DF85
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838105; cv=none; b=PyluDurLlkjxGVmlB3admvRPfhelNmsIwFwILO29YDpdtdWNFZf4m0S8xtpLf0vE1mKXXkHlrfSDUGC4KkV1/nXL2x9rdzzDEC+Crdosa84+y4lHLl/mAKqy59I8RLD9iasnlMgegnsbAzs2EPttLvhzNDsV6RemUePriSOuv4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838105; c=relaxed/simple;
	bh=FC4hdguicim44b3MeNYNjVMOZnJhIDO6MCH8X4RXsmg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N13kRJGioggmIeJ+E6LvlxANySd5NAG6Tq0X5czpX6p5Iy2ERHbp02c+Jw4bh40ElgbkzbEnPYQku5FrtGyeBopRJ+K3R2m4kHD9DzTU3GKEdSgvygFmNR0Dzurezu3Dh+/GXfJiZkJH4QH6lY6pI2//Vy87h+vBd+iO57hEJOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZoFriuJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZoFriuJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC71C4CEC3;
	Fri, 25 Oct 2024 06:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838105;
	bh=FC4hdguicim44b3MeNYNjVMOZnJhIDO6MCH8X4RXsmg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZoFriuJlPZkHwcjdEuPFETocorTg/N4RD+UBq2cvP5ZsIuoiXLjEIrzLSMf5QNkkj
	 Pgx+hyrPWGSayrkPEZ4hPCb3HrptlDQYnrC3uNjjKXXOWranmZW/tjdJzwyytqISWi
	 zO0xNhkfc7VxzMsG98mQz4lNczfRBVYYA0lSUxZmt50BtGTmoUrmXFVA//vUD1m5iw
	 FC+QZD43t1u0Wt2wZmRDNyr8ipquyjCEWqxx46WE90cv2Si+ZG7p4HUKKxNPhvMySF
	 e8K3dIUYRlxoVa+J904GWqIQIVtI0UK9I1+Hkl8PLS/kZK/Z3csqwXUNOnstDwU7uj
	 f5uq3eGqvVxEQ==
Date: Thu, 24 Oct 2024 23:35:03 -0700
Subject: [PATCH 3/8] xfs_db: make the daddr command target the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773774.3041229.16383532207517050768.stgit@frogsfrogsfrogs>
In-Reply-To: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
References: <172983773721.3041229.1240437778522879907.stgit@frogsfrogsfrogs>
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
index bd25cdbe193f4f..6ad9f038c6da67 100644
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
@@ -117,16 +117,36 @@ daddr_help(void)
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
 	char		**argv)
 {
+	xfs_rfsblock_t	max_daddrs = mp->m_sb.sb_dblocks;
 	int64_t		d;
 	char		*p;
 	int		bb_count = BTOBB(mp->m_sb.sb_sectsize);
+	int		c;
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
@@ -140,14 +160,27 @@ daddr_f(
 
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
-	set_cur(&typtab[TYP_DATA], d, bb_count, DB_RING_ADD, NULL);
+	switch (tgt) {
+	case DT_DATA:
+		set_cur(&typtab[TYP_DATA], d, bb_count, DB_RING_ADD, NULL);
+		break;
+	case DT_RT:
+		set_rt_cur(&typtab[TYP_DATA], d, bb_count, DB_RING_ADD, NULL);
+		break;
+	}
 	return 0;
 }
 
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 5faf8dbb1d679f..f50ac949be0189 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -671,7 +671,7 @@ .SH COMMANDS
 Validate and display the current value and state of the structure's CRC.
 .RE
 .TP
-.BI "daddr [" d ]
+.BI "daddr [" -r "] [" d ]
 Set current address to the daddr (512 byte block) given by
 .IR d .
 If no value for
@@ -680,6 +680,10 @@ .SH COMMANDS
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

