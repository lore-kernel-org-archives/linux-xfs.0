Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C024CC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236139AbiLaC2s (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiLaC2r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:28:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1866E1C921
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A14261CFE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067D5C433EF;
        Sat, 31 Dec 2022 02:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453725;
        bh=8E7DZQFc8dmmvXphGRNfpgXkiqGlJoc64k50uSkpOKA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oPTd7Npk2L2VIP9FUFxESeA+T38ENMRoa15sCyZTkgSDzTHlV52wZI1raRm+RCVbD
         QZ5617IjHHdSECsvMj4UCF7ezo+Ne/VWcVx/YzgJ3zowxh3Qa530oYOKUaE0rhf9sh
         JUdGb0lFf8SW1pfemL8J3R7ybMBZ7yUZy0FAK0VfTxm4A01KzdzDR3jgbv5bRAvAfu
         Gr6it8rfdrfIMAfRNb6KNnLT3Sat+f/boKsi5an5yfOYr052/Gvmcn54XQTR0m1GNw
         YA0R9GWTaPPuCbkqx6Osvyr6cqGC/n4IGEzGElJn+Ld73PV3EOL6IPLUT5zbdxVB2a
         S0qgjr2HD7Aew==
Subject: [PATCH 8/8] xfs_db: convert rtsummary geometry
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:37 -0800
Message-ID: <167243877718.728317.7495027757328955619.stgit@magnolia>
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

Teach the rtconvert command to be able to convert realtime blocks and
extents to locations within the rt summary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/convert.c      |  141 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 man/man8/xfs_db.8 |   29 +++++++++++
 2 files changed, 162 insertions(+), 8 deletions(-)


diff --git a/db/convert.c b/db/convert.c
index 691361604ee..0aed1437dc4 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -52,6 +52,9 @@ typedef enum {
 	CT_RTX,			/* realtime extent */
 	CT_RBMBLOCK,		/* block within rt bitmap */
 	CT_RBMWORD,		/* word within rt bitmap */
+	CT_RSUMBLOCK,		/* block within rt summary */
+	CT_RSUMLOG,		/* log level for rtsummary computations */
+	CT_RSUMINFO,		/* info word within rt summary */
 	NCTS
 } ctype_t;
 
@@ -76,6 +79,7 @@ typedef union {
 	xfs_rtblock_t	rtx;
 	xfs_fileoff_t	rbmblock;
 	unsigned int	rbmword;
+	xfs_fileoff_t	rsumblock;
 } cval_t;
 
 static uint64_t		bytevalue(ctype_t ctype, cval_t *val);
@@ -104,6 +108,12 @@ static const char	*rtblock_names[] = { "rtblock", "rtb", "rtbno", NULL };
 static const char	*rtx_names[] = { "rtx", "rtextent", NULL };
 static const char	*rbmblock_names[] = { "rbmblock", "rbmb", NULL };
 static const char	*rbmword_names[] = { "rbmword", "rbmw", NULL };
+static const char	*rsumblock_names[] = { "rsumblock", "rsmb", NULL };
+static const char	*rsumlog_names[] = { "rsumlog", "rsml", NULL };
+static const char	*rsumword_names[] = { "rsuminfo", "rsmi", NULL };
+
+static int		rsuminfo;
+static int		rsumlog;
 
 static const ctydesc_t	ctydescs[NCTS] = {
 	[CT_AGBLOCK] = {
@@ -154,37 +164,50 @@ static const ctydesc_t	ctydescs[NCTS] = {
 
 static const ctydesc_t	ctydescs_rt[NCTS] = {
 	[CT_BBOFF] = {
-		.allowed = M(DADDR)|M(RTBLOCK),
+		.allowed = M(DADDR)|M(RTBLOCK)|M(RSUMLOG),
 		.names   = bboff_names,
 	},
 	[CT_BLKOFF] = {
-		.allowed = M(RTBLOCK),
+		.allowed = M(RTBLOCK)|M(RSUMLOG),
 		.names   = rtblkoff_names,
 	},
 	[CT_BYTE] = {
-		.allowed = 0,
+		.allowed = 0|M(RSUMLOG),
 		.names   = byte_names,
 	},
 	[CT_DADDR] = {
-		.allowed = M(BBOFF),
+		.allowed = M(BBOFF)|M(RSUMLOG),
 		.names   = daddr_names,
 	},
 	[CT_RTBLOCK] = {
-		.allowed = M(BBOFF)|M(BLKOFF),
+		.allowed = M(BBOFF)|M(BLKOFF)|M(RSUMLOG),
 		.names   = rtblock_names,
 	},
 	[CT_RTX] = {
-		.allowed = M(BBOFF)|M(BLKOFF),
+		.allowed = M(BBOFF)|M(BLKOFF)|M(RSUMLOG),
 		.names   = rtx_names,
 	},
 	[CT_RBMBLOCK] = {
-		.allowed = M(RBMWORD),
+		.allowed = M(RBMWORD)|M(RSUMLOG),
 		.names   = rbmblock_names,
 	},
 	[CT_RBMWORD] = {
-		.allowed = M(RBMBLOCK),
+		.allowed = M(RBMBLOCK)|M(RSUMLOG),
 		.names   = rbmword_names,
 	},
+	/* must be specified in order rsumlog -> rsuminfo -> rsumblock */
+	[CT_RSUMBLOCK] = {
+		.allowed = 0,
+		.names   = rsumblock_names,
+	},
+	[CT_RSUMLOG] = {
+		.allowed = M(RSUMINFO)|M(RSUMBLOCK),
+		.names   = rsumlog_names,
+	},
+	[CT_RSUMINFO] = {
+		.allowed = M(RSUMBLOCK),
+		.names   = rsumword_names,
+	},
 };
 
 static const cmdinfo_t	convert_cmd =
@@ -195,6 +218,39 @@ static const cmdinfo_t	rtconvert_cmd =
 	{ "rtconvert", NULL, rtconvert_f, 3, 9, 0, "type num [type num]... type",
 	  "convert from one realtime address form to another", NULL };
 
+static inline uint64_t
+rsumblock_to_bytes(
+	xfs_fileoff_t	rsumblock)
+{
+	/*
+	 * We compute the rt summary file block with this formula:
+	 *   sumoffs = (log2len * sb_rbmblocks) + rbmblock;
+	 *   sumblock = sumoffs / blockwsize;
+	 *
+	 * Hence the return value is the inverse of this:
+	 *   sumoffs = (rsumblock * blockwsize) + rsuminfo;
+	 *   rbmblock = sumoffs % (log2len * sb_rbmblocks);
+	 */
+	xfs_rtsumoff_t	sumoff;
+	xfs_fileoff_t	rbmblock;
+
+	if (rsumlog < 0) {
+		dbprintf(_("need to set rsumlog\n"));
+		return 0;
+	}
+	if (rsuminfo < 0) {
+		dbprintf(_("need to set rsuminfo\n"));
+		return 0;
+	}
+
+	sumoff = rsuminfo + (rsumblock * mp->m_blockwsize);
+	if (rsumlog)
+		rbmblock = sumoff % (rsumlog * mp->m_sb.sb_rbmblocks);
+	else
+		rbmblock = sumoff;
+	return rbmblock_to_bytes(rbmblock);
+}
+
 static uint64_t
 bytevalue(ctype_t ctype, cval_t *val)
 {
@@ -229,6 +285,16 @@ bytevalue(ctype_t ctype, cval_t *val)
 		return rbmblock_to_bytes(val->rbmblock);
 	case CT_RBMWORD:
 		return rbmword_to_bytes(val->rbmword);
+	case CT_RSUMBLOCK:
+		return rsumblock_to_bytes(val->rbmblock);
+	case CT_RSUMLOG:
+	case CT_RSUMINFO:
+		/*
+		 * These have to specified before rsumblock, and are stored in
+		 * global variables.  Hence they do not adjust the disk address
+		 * value.
+		 */
+		return 0;
 	case CT_NONE:
 	case NCTS:
 		break;
@@ -332,6 +398,9 @@ convert_f(int argc, char **argv)
 	case CT_RTX:
 	case CT_RBMBLOCK:
 	case CT_RBMWORD:
+	case CT_RSUMBLOCK:
+	case CT_RSUMLOG:
+	case CT_RSUMINFO:
 		/* shouldn't get here */
 		ASSERT(0);
 		break;
@@ -352,6 +421,40 @@ xfs_daddr_to_rtb(
 	return daddr >> mp->m_blkbb_log;
 }
 
+static inline uint64_t
+rt_daddr_to_rsumblock(
+	struct xfs_mount	*mp,
+	uint64_t		input)
+{
+	xfs_fileoff_t		rbmblock;
+
+	if (rsumlog < 0) {
+		dbprintf(_("need to set rsumlog\n"));
+		return 0;
+	}
+
+	rbmblock = xfs_rtx_to_rbmblock(mp, xfs_rtb_to_rtxt(mp,
+				xfs_daddr_to_rtb(mp, input >> BBSHIFT)));
+	return xfs_rtsumoffs_to_block(mp, xfs_rtsumoffs(mp, rsumlog, rbmblock));
+}
+
+static inline uint64_t
+rt_daddr_to_rsuminfo(
+	struct xfs_mount	*mp,
+	uint64_t		input)
+{
+	xfs_fileoff_t		rbmblock;
+
+	if (rsumlog < 0) {
+		dbprintf(_("need to set rsumlog\n"));
+		return 0;
+	}
+
+	rbmblock = xfs_rtx_to_rbmblock(mp, xfs_rtb_to_rtxt(mp,
+				xfs_daddr_to_rtb(mp, input >> BBSHIFT)));
+	return xfs_rtsumoffs_to_infoword(mp, xfs_rtsumoffs(mp, rsumlog, rbmblock));
+}
+
 static int
 rtconvert_f(int argc, char **argv)
 {
@@ -363,6 +466,9 @@ rtconvert_f(int argc, char **argv)
 	uint64_t	v;
 	ctype_t		wtype;
 
+	rsumlog = -1;
+	rsuminfo = -1;
+
 	/* move past the "rtconvert" command */
 	argc--;
 	argv++;
@@ -429,6 +535,16 @@ rtconvert_f(int argc, char **argv)
 		v = xfs_rtx_to_rbmword(mp, xfs_rtb_to_rtxt(mp,
 					xfs_daddr_to_rtb(mp, v >> BBSHIFT)));
 		break;
+	case CT_RSUMBLOCK:
+		v = rt_daddr_to_rsumblock(mp, v);
+		break;
+	case CT_RSUMLOG:
+		dbprintf(_("cannot convert to rsumlog\n"));
+		return 0;
+		break;
+	case CT_RSUMINFO:
+		v = rt_daddr_to_rsuminfo(mp, v);
+		break;
 	case CT_AGBLOCK:
 	case CT_AGINO:
 	case CT_AGNUMBER:
@@ -512,6 +628,15 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
 	case CT_RBMWORD:
 		val->rbmword = (unsigned int)v;
 		break;
+	case CT_RSUMBLOCK:
+		val->rsumblock = (xfs_fileoff_t)v;
+		break;
+	case CT_RSUMLOG:
+		rsumlog = (unsigned int)v;
+		break;
+	case CT_RSUMINFO:
+		rsuminfo = (unsigned int)v;
+		break;
 	case CT_NONE:
 	case NCTS:
 		/* NOTREACHED */
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 65d1a65b75f..1246eb6327c 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1009,10 +1009,39 @@ or
 or
 .B rbmw
 (32-bit word within a realtime bitmap block)
+.HP
+.B rsumblock
+or
+.B rsmb
+(realtime summary file block)
+.HP
+.B rsuminfo
+or
+.B rsmi
+(32-bit counter within a realtime summary block)
+.HP
+.B rsumlog
+or
+.B rsml
+(log2len parameter used for summary file offset computations)
 .PD
 .RE
 .IP
 Only conversions that "make sense" are allowed.
+
+Realtime summary file location conversions have the following rules:
+Each info word in the rt summary file counts the number of free extents of a
+given log2(length) that start in a given rt bitmap block.
+
+To compute summary file location information for a given rt bitmap block, a
+log2(extent length) must be specified as the last type/number pair before the
+conversion type, and the type must be
+.BR rsumlog .
+
+To compute the rt bitmap block from summary file location, the type/number pairs
+must be specified exactly in the order
+.BR rsumlog ", " rsuminfo ", " rsumblock .
+
 .TP
 .BI "sb [" agno ]
 Set current address to SB header in allocation group

