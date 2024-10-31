Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90EB019CC1D
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416919; cv=none; b=p1ZFbgpExVSHCb09r4yhubegqraDgEDJtu7LTFaCpH1OcC0Hn5mMLEX7UQU6L6KZVb4HcdFJRMJTC3BwXZfcx7n4a/HDdQmOJjZKE7EVc27w7Ed+f5S8DzFrbtbrGxlPVqBZ+GenjwbeO7Cla1CAsRyOQO3LouXIQWpiANzlOiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416919; c=relaxed/simple;
	bh=BxdhsulxgWizC8PUXkmOJHyz5/y0xgFDBCXZzpumeRs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lI0G7ibSWnjFGdmeif0IxlNHqa9t/mkpeZVIS2dtkL3k+ie4ySIVRjmzklVlmzg0zZ53sBIQHdLuB2WXLZfLUs+/LsSzv89/y+kHx6oIr+GKMqyXYG1+uVwuo1mmC+pFPToguCnr/r1nUVpsTC/6xmcrBFOZVA0eirVzhlzq0f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btNSNEgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btNSNEgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B78FC4CEC3;
	Thu, 31 Oct 2024 23:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416919;
	bh=BxdhsulxgWizC8PUXkmOJHyz5/y0xgFDBCXZzpumeRs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=btNSNEgYFLvkveosviQoB0O3Vxl4VqhZJp0AxUsrpEEgWMO9US5EUxluaS8EvZ9tD
	 sqXlSmaTadVcTQM2BuCRNMuQYIOJBP+uP3KdbP5ZaTl9HgBySXAzaqSyujLhN9Je6h
	 HS0nHrcKAAOX1/if5/bq5Ma3/NAtg+qP9Zr23nLri/pzyzXzolLTa191kxX1409kDn
	 kp3gsoxSBDu9+kU03j/f6SOKZDT/1GAnMFmYgPhXd9nKF64l+KxpIEe0IeJAlgQRao
	 X09Q7hv6nmfTL53dsJtG6emIvL32jd+PJ/sQdSYb6jqjwSGN4+P0irkGcWreVwF8BY
	 BfklmcqdsLVxw==
Date: Thu, 31 Oct 2024 16:21:58 -0700
Subject: [PATCH 3/8] xfs_db: make the daddr command target the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041567384.964205.17596882044133219126.stgit@frogsfrogsfrogs>
In-Reply-To: <173041567330.964205.623580785256778088.stgit@frogsfrogsfrogs>
References: <173041567330.964205.623580785256778088.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

