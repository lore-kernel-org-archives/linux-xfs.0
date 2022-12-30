Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0C5C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbiLaC13 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236094AbiLaC13 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:27:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537801C921
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:27:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E615161CD4
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDC0C433EF;
        Sat, 31 Dec 2022 02:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453647;
        bh=gu26SK12RLpjM6eDb3gNwBu0aZO/krySyWCN1OYkbQA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=I5B9uwHgLplxXA1hkbsBMBqZzLc+Uor+RkGh6KJ+LC+Ys+G8mrY3v1ElnmWYqYttb
         JQxrXx03jDOpTCr9DsGM7wO5yOh+pCBlf0r8yycq50859YjIvZDXLxRup2GH1rERC4
         6yT0ZlsbQfGmaZJTxCQXnJGMv4kt8/dAJs9ZPdDZSTd/vB3nRcrlv9lfF3uo1bzWgT
         Y89pugDyzu80gNV8cgeEwjlHLq2vZ16Bmiamt7/Z/Y2R/19DH6eudFA9eKTAdSLNTI
         U1SP1T7ylpKUtntLa1jhhVZ4ojfghHXJ/lCajHz4wLlZKOR93WXcATK0EfjjLljjsr
         Gw/q13xquU80Q==
Subject: [PATCH 3/8] xfs_db: make the daddr command target the realtime device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:36 -0800
Message-ID: <167243877651.728317.312052597903660667.stgit@magnolia>
In-Reply-To: <167243877610.728317.12510123562097453242.stgit@magnolia>
References: <167243877610.728317.12510123562097453242.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 593b8037251..aa097a13b27 100644
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

