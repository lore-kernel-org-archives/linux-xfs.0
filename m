Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECE0C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236130AbiLaC2b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiLaC2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:28:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A30E1C921
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:28:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17ABB61CF1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AF3C433D2;
        Sat, 31 Dec 2022 02:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453709;
        bh=7ZXxazAzlRZ6QluoLdP5vO8nVDRlvTiPh1Ry2ROZMTQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DJkq219So7ZOML/q72/poi+SWvbGg3gkB6UbYqArDyue3MXfGUUiB/L1gnP4LUf43
         KYHpmGB2Lb6Eq64ITgF87N7iNV6sXSSkSxusI9RXpWzd3o4r+71XBSpiQDmBF8x4qj
         d/cksHJND5IaITw0I7yQ+DjKtYao1fr4yUYSrCpNejvKMZP0aeFEmJftDaLMgkVCqs
         6RbV+4rLN5kqrlPQ6RH7qHQ0hNoRvQD4Qbse16y1pbaLJBQ3KEKcuWQbZy5cUAWwgx
         tusYJwAK+hAmV3IR3ABMPk+qFN4SeMXhdq0zOz1uGljl4q3X6tp1Qr+SIklxBwcMlS
         7buBlLOiPFcjQ==
Subject: [PATCH 7/8] xfs_db: convert rtbitmap geometry
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:37 -0800
Message-ID: <167243877705.728317.14956604988449250736.stgit@magnolia>
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
extents to locations within the rt bitmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/convert.c      |   38 ++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   10 ++++++++++
 2 files changed, 48 insertions(+)


diff --git a/db/convert.c b/db/convert.c
index 811bac00f71..691361604ee 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -30,6 +30,10 @@
 	((uint64_t)(x) << mp->m_sb.sb_blocklog)
 #define rtx_to_rtblock(x)	\
 	((uint64_t)(x) * mp->m_sb.sb_rextsize)
+#define rbmblock_to_bytes(x)	\
+	rtblock_to_bytes(rtx_to_rtblock(xfs_rbmblock_to_rtx(mp, (uint64_t)x)))
+#define rbmword_to_bytes(x)	\
+	rtblock_to_bytes(rtx_to_rtblock((uint64_t)(x) << XFS_NBWORDLOG))
 
 typedef enum {
 	CT_NONE = -1,
@@ -46,6 +50,8 @@ typedef enum {
 	CT_INOOFF,		/* byte offset in inode */
 	CT_RTBLOCK,		/* realtime block */
 	CT_RTX,			/* realtime extent */
+	CT_RBMBLOCK,		/* block within rt bitmap */
+	CT_RBMWORD,		/* word within rt bitmap */
 	NCTS
 } ctype_t;
 
@@ -68,6 +74,8 @@ typedef union {
 	int		inooff;
 	xfs_rtblock_t	rtblock;
 	xfs_rtblock_t	rtx;
+	xfs_fileoff_t	rbmblock;
+	unsigned int	rbmword;
 } cval_t;
 
 static uint64_t		bytevalue(ctype_t ctype, cval_t *val);
@@ -94,6 +102,8 @@ static const char	*inooff_names[] = { "inooff", "inodeoff", NULL };
 
 static const char	*rtblock_names[] = { "rtblock", "rtb", "rtbno", NULL };
 static const char	*rtx_names[] = { "rtx", "rtextent", NULL };
+static const char	*rbmblock_names[] = { "rbmblock", "rbmb", NULL };
+static const char	*rbmword_names[] = { "rbmword", "rbmw", NULL };
 
 static const ctydesc_t	ctydescs[NCTS] = {
 	[CT_AGBLOCK] = {
@@ -167,6 +177,14 @@ static const ctydesc_t	ctydescs_rt[NCTS] = {
 		.allowed = M(BBOFF)|M(BLKOFF),
 		.names   = rtx_names,
 	},
+	[CT_RBMBLOCK] = {
+		.allowed = M(RBMWORD),
+		.names   = rbmblock_names,
+	},
+	[CT_RBMWORD] = {
+		.allowed = M(RBMBLOCK),
+		.names   = rbmword_names,
+	},
 };
 
 static const cmdinfo_t	convert_cmd =
@@ -207,6 +225,10 @@ bytevalue(ctype_t ctype, cval_t *val)
 		return rtblock_to_bytes(val->rtblock);
 	case CT_RTX:
 		return rtblock_to_bytes(rtx_to_rtblock(val->rtx));
+	case CT_RBMBLOCK:
+		return rbmblock_to_bytes(val->rbmblock);
+	case CT_RBMWORD:
+		return rbmword_to_bytes(val->rbmword);
 	case CT_NONE:
 	case NCTS:
 		break;
@@ -308,6 +330,8 @@ convert_f(int argc, char **argv)
 		break;
 	case CT_RTBLOCK:
 	case CT_RTX:
+	case CT_RBMBLOCK:
+	case CT_RBMWORD:
 		/* shouldn't get here */
 		ASSERT(0);
 		break;
@@ -397,6 +421,14 @@ rtconvert_f(int argc, char **argv)
 	case CT_RTX:
 		v = xfs_daddr_to_rtb(mp, v >> BBSHIFT) / mp->m_sb.sb_rextsize;
 		break;
+	case CT_RBMBLOCK:
+		v = xfs_rtx_to_rbmblock(mp, xfs_rtb_to_rtxt(mp,
+					xfs_daddr_to_rtb(mp, v >> BBSHIFT)));
+		break;
+	case CT_RBMWORD:
+		v = xfs_rtx_to_rbmword(mp, xfs_rtb_to_rtxt(mp,
+					xfs_daddr_to_rtb(mp, v >> BBSHIFT)));
+		break;
 	case CT_AGBLOCK:
 	case CT_AGINO:
 	case CT_AGNUMBER:
@@ -474,6 +506,12 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
 	case CT_RTX:
 		val->rtx = (xfs_rtblock_t)v;
 		break;
+	case CT_RBMBLOCK:
+		val->rbmblock = (xfs_fileoff_t)v;
+		break;
+	case CT_RBMWORD:
+		val->rbmword = (unsigned int)v;
+		break;
 	case CT_NONE:
 	case NCTS:
 		/* NOTREACHED */
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 40ff7de335e..65d1a65b75f 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -999,6 +999,16 @@ command)
 or
 .B rtextent
 (realtime extent)
+.HP
+.B rbmblock
+or
+.B rbmb
+(realtime bitmap block)
+.HP
+.B rbmword
+or
+.B rbmw
+(32-bit word within a realtime bitmap block)
 .PD
 .RE
 .IP

