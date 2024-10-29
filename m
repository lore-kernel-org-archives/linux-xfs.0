Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DD4197A7C
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730216909; cv=none; b=RWZOxHKooNVBygEZn+P9HwkCg/aMDXQ1XMrQspm5oWWyyxcee8AycnH//K7is3dqh++OmwEzW+P/yxbC2pEYlx+imGmkafAhlYwTEt/87nIICR2UVLEpnSm70+GFrcEsnMfy/PNisk6X3aGRKNs97J0KiWGM+PpuPMF23r1v0Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730216909; c=relaxed/simple;
	bh=BxdhsulxgWizC8PUXkmOJHyz5/y0xgFDBCXZzpumeRs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hpDmuMoh7Hix6f4o0/nEECrd4UCK32Hs1xa3dQmxNOheEBJDyNtfDY4hRmdffjDDB5sbX8pTq/TRAtr9B1wmvcEGkrsWVhoxyqY/aKxA4r+6PTJAYt9PE+4hB8T3O1etsF+N2jZX7etZmN5UjZjVrXlOUD4sfhHxVe6VS/m0ixs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=szMo/LXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szMo/LXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE27C4CEE5;
	Tue, 29 Oct 2024 15:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730216909;
	bh=BxdhsulxgWizC8PUXkmOJHyz5/y0xgFDBCXZzpumeRs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=szMo/LXo/oF+VbZus5U2DdqL+lxMeZz/ibB9vhJTPX0dbeKBd+DPXZCiDOPvYpi1f
	 rStNc0nsiU9FWZsxufgk233cKlmXkUDxNShR9lfZQ/7V2Y597AueRN3qNSCbLJRhTg
	 fN5OX+UMqG1uRvp2llBzykKybFVaWDxyIk4cBbK3aLaQjpLYau7zlp/rmYV0AdgLcG
	 jRtUSg9IgSDJdyDk7JtHzBG9HEFkPZTjnFQhmlMENGpVPiA3/pKPGdgVPr2FUzhWDl
	 GyIlSM0EI9zJiNQDUjZOEJ2GHWs5t9ddnBDjwKdEsGGnJG5c0638VuvGwUSgFbQQpK
	 cThZxsWUXlhWw==
Date: Tue, 29 Oct 2024 08:48:28 -0700
Subject: [PATCH 3/8] xfs_db: make the daddr command target the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173021673280.3128727.10246665487603714123.stgit@frogsfrogsfrogs>
In-Reply-To: <173021673227.3128727.17882979358320595734.stgit@frogsfrogsfrogs>
References: <173021673227.3128727.17882979358320595734.stgit@frogsfrogsfrogs>
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

