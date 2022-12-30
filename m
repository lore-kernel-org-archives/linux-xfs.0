Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CA9AC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbiLaC2D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiLaC2C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:28:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0197F1C921
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:28:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE594B81E69
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA2DC433EF;
        Sat, 31 Dec 2022 02:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453678;
        bh=wpEKgu8nv5+BbbpNI42msFc4rs+zeuF5M7bSifakpHA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MtMjaW8AxOsD01/LQNbcPrILOWyxCbQtqynh8yl9HuOwexGM+9eV1hkMBvzvF2PG4
         iFT6MBpEEj6lfDH8bswwTodZcdq4HMLVuRWcIvtU9yCJk0/lcYsyFfXA1ZpmHDPy6c
         lfxsRJELFJMju+ox4h59L/HhpRRfZ7h8BrcVwh5Uk10tqFg0yUQ+4RLnXN06oTLK3Q
         yJcQ0kR5uTYf5oCS5WOZa9MfgusWSc6iF4u9k6PWu44wAfTHhXuE7zMzynMtfTGmFn
         0wF0Ew1RaGN9lA1incCXYqcrzTPwjFCzhhYNyVQ4/4zf2aCBZ/Lh2Daxm6LTzpKkNT
         UbUelI5TzQHmw==
Subject: [PATCH 5/8] xfs_db: access arbitrary realtime blocks and extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:36 -0800
Message-ID: <167243877678.728317.13782091019281270247.stgit@magnolia>
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

Add two commands to xfs_db so that we can point ourselves at any
arbitrary realtime block or extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c        |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   20 ++++++++++
 2 files changed, 127 insertions(+)


diff --git a/db/block.c b/db/block.c
index ae8744685b0..1afe201d0b2 100644
--- a/db/block.c
+++ b/db/block.c
@@ -25,6 +25,10 @@ static int	dblock_f(int argc, char **argv);
 static void     dblock_help(void);
 static int	fsblock_f(int argc, char **argv);
 static void     fsblock_help(void);
+static int	rtblock_f(int argc, char **argv);
+static void	rtblock_help(void);
+static int	rtextent_f(int argc, char **argv);
+static void	rtextent_help(void);
 static void	print_rawdata(void *data, int len);
 
 static const cmdinfo_t	ablock_cmd =
@@ -39,6 +43,12 @@ static const cmdinfo_t	dblock_cmd =
 static const cmdinfo_t	fsblock_cmd =
 	{ "fsblock", "fsb", fsblock_f, 0, 1, 1, N_("[fsb]"),
 	  N_("set address to fsblock value"), fsblock_help };
+static const cmdinfo_t	rtblock_cmd =
+	{ "rtblock", "rtbno", rtblock_f, 0, 1, 1, N_("[rtbno]"),
+	  N_("set address to rtblock value"), rtblock_help };
+static const cmdinfo_t	rtextent_cmd =
+	{ "rtextent", "rtx", rtextent_f, 0, 1, 1, N_("[rtxno]"),
+	  N_("set address to rtextent value"), rtextent_help };
 
 static void
 ablock_help(void)
@@ -104,6 +114,8 @@ block_init(void)
 	add_command(&daddr_cmd);
 	add_command(&dblock_cmd);
 	add_command(&fsblock_cmd);
+	add_command(&rtblock_cmd);
+	add_command(&rtextent_cmd);
 }
 
 static void
@@ -301,6 +313,101 @@ fsblock_f(
 	return 0;
 }
 
+static void
+rtblock_help(void)
+{
+	dbprintf(_(
+"\n Example:\n"
+"\n"
+" 'rtblock 1023' - sets the file position to the 1023rd block on the realtime\n"
+" volume. The filesystem block size is specified in the superblock and set\n"
+" during mkfs time.\n\n"
+));
+}
+
+static int
+rtblock_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_rtblock_t	rtbno;
+	char		*p;
+
+	if (argc == 1) {
+		if (!iocur_is_rtdev(iocur_top)) {
+			dbprintf(_("cursor does not point to rt device\n"));
+			return 0;
+		}
+		dbprintf(_("current rtblock is %lld\n"),
+			XFS_BB_TO_FSB(mp, iocur_top->off >> BBSHIFT));
+		return 0;
+	}
+	rtbno = strtoull(argv[1], &p, 0);
+	if (*p != '\0') {
+		dbprintf(_("bad rtblock %s\n"), argv[1]);
+		return 0;
+	}
+	if (rtbno >= mp->m_sb.sb_rblocks) {
+		dbprintf(_("bad rtblock %s\n"), argv[1]);
+		return 0;
+	}
+	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
+	set_rt_cur(&typtab[TYP_DATA], XFS_FSB_TO_BB(mp, rtbno), blkbb,
+			DB_RING_ADD, NULL);
+	return 0;
+}
+
+static void
+rtextent_help(void)
+{
+	dbprintf(_(
+"\n Example:\n"
+"\n"
+" 'rtextent 10' - sets the file position to the 10th extent on the realtime\n"
+" volume. The realtime extent size is specified in the superblock and set\n"
+" during mkfs or growfs time.\n\n"
+));
+}
+
+static int
+rtextent_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_rtblock_t	rtbno;
+	xfs_rtxnum_t	rtx;
+	char		*p;
+
+	if (argc == 1) {
+		xfs_extlen_t	dontcare;
+
+		if (!iocur_is_rtdev(iocur_top)) {
+			dbprintf(_("cursor does not point to rt device\n"));
+			return 0;
+		}
+
+		rtbno = XFS_BB_TO_FSB(mp, iocur_top->off >> BBSHIFT);
+		dbprintf(_("current rtextent is %lld\n"),
+				xfs_rtb_to_rtx(mp, rtbno, &dontcare));
+		return 0;
+	}
+	rtx = strtoull(argv[1], &p, 0);
+	if (*p != '\0') {
+		dbprintf(_("bad rtextent %s\n"), argv[1]);
+		return 0;
+	}
+	if (rtx >= mp->m_sb.sb_rextents) {
+		dbprintf(_("bad rtextent %s\n"), argv[1]);
+		return 0;
+	}
+
+	rtbno = xfs_rtx_to_rtb(mp, rtx);
+	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
+	set_rt_cur(&typtab[TYP_DATA], XFS_FSB_TO_BB(mp, rtbno),
+			mp->m_sb.sb_rextsize * blkbb, DB_RING_ADD, NULL);
+	return 0;
+}
+
 void
 print_block(
 	const field_t	*fields,
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index aa097a13b27..de30fbc6230 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -927,6 +927,26 @@ command.
 Exit
 .BR xfs_db .
 .TP
+.BI "rtblock [" rtbno ]
+Set current address to the rtblock value given by
+.IR rtbno .
+If no value for
+.I rtbno
+is given the current address is printed, expressed as an rtbno.
+The type is set to
+.B data
+(uninterpreted).
+.TP
+.BI "rtextent [" rtxno ]
+Set current address to the rtextent value given by
+.IR rtextent .
+If no value for
+.I rtextent
+is given the current address is printed, expressed as an rtextent.
+The type is set to
+.B data
+(uninterpreted).
+.TP
 .BI "ring [" index ]
 Show position ring (if no
 .I index

