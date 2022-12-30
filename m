Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8903C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbiLaC3V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiLaC3R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:29:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135131C921
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:29:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A647861CD4
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1139EC433D2;
        Sat, 31 Dec 2022 02:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453756;
        bh=ZrUN8IeOBx9+YyI/ttkm6jck4D9A/2umUbgUAuB1b30=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LdVGcB1lcfWfTLsXHGRyn6za55L0xchsVp9GMNgvApzQiWhjlOJYcZW2knqVUDKmR
         FbYnOjK8VMW3hWZdnJ4TmoHU+3YFn1ASV8QYUQgoJFp6bvaIf2S7x1wTfqKKz5slPD
         oL/HwgOX4IWeG0OGOUl2fvRHCD0NHylgElpdY8ZnC/UGOWo8UgVIB2yUrqnlzYY/ct
         oxpZupgoqULofUPg3t8IGfmFGTpvBmYYIOMi2dGPGzPmpG+xjQUFHJeKzQkjJvNKb9
         vZfXn8keoIEU0UvAlJcFRcZWJq54Vc0UcSxAAfBeFuHXnlcT/lclOtRL73OrXABjDN
         qu5sxi+cFLaJQ==
Subject: [PATCH 2/5] xfs_db: allow setting current address to log blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:40 -0800
Message-ID: <167243878009.730695.2275996586942542508.stgit@magnolia>
In-Reply-To: <167243877981.730695.7761889719607533776.stgit@magnolia>
References: <167243877981.730695.7761889719607533776.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add commands so that users can target blocks on an external log device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c        |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_db.8 |   17 +++++++++
 2 files changed, 119 insertions(+), 1 deletion(-)


diff --git a/db/block.c b/db/block.c
index 1afe201d0b2..98df0ce10ac 100644
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
@@ -145,18 +152,27 @@ daddr_f(
 	xfs_rfsblock_t	max_daddrs = mp->m_sb.sb_dblocks;
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
 
@@ -191,6 +207,9 @@ daddr_f(
 	case DT_RT:
 		set_rt_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
 		break;
+	case DT_LOG:
+		set_log_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
+		break;
 	}
 	return 0;
 }
@@ -408,6 +427,88 @@ rtextent_f(
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
index 1246eb6327c..9c1ce5d79cf 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -600,6 +600,9 @@ The type is set to
 .B data
 (uninterpreted).
 
+If an address and the
+.B \-l
+option are specified, the current address is set to the external log device.
 If an address and the
 .B \-r
 option are specified, the current address is set to the realtime device.
@@ -839,6 +842,20 @@ Start logging output to
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

