Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E164C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbiLaCiB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236259AbiLaChw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:37:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AA8BC9C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:37:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C037EB81DED
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B0CC433EF;
        Sat, 31 Dec 2022 02:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672454269;
        bh=T2rcw9zijVnEhsZ2JOKIJLSqrX3XBWHev44gfq4Jv8Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SXLcYrXgoEfOmT01BlHl9AQ5Lz1RvHTcy1A7nWxvJmIMFzsxaun8PHtxYWvsq8zE5
         x62+C/qL/jU/ypeHb/DiiNs8gVHmK9WJpnGIUYx9cBEcZiV0S4bsd0ec/pWFHhuM68
         NwZuPJie7/zRyPLtkVnovr6ctzSWd4Z0xQgWSA6EEG7yMqVm6qGxR3YEzE3BwHZfCz
         ZOP/4LyKmfTjIzO2e0Q/nodZ4mNN2ze3ZQ8v4+G/7a/wqCLRvWtRjCmJTUR/ml+Fef
         coMgpGrPk4avpeTOjJGqsS2BT/yGbju9HjDV5YzYVsB+bC9jC3fOtYJOVq0tutUGM9
         +wROf4twTOWeg==
Subject: [PATCH 30/45] xfs_db: enable conversion of rt space units
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:47 -0800
Message-ID: <167243878758.731133.6306481528555037356.stgit@magnolia>
In-Reply-To: <167243878346.731133.14642166452774753637.stgit@magnolia>
References: <167243878346.731133.14642166452774753637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the xfs_db convert function about realtime extents, blocks, and
realtime group numbers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/convert.c      |   38 +++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_db.8 |   17 +++++++++++++++++
 2 files changed, 54 insertions(+), 1 deletion(-)


diff --git a/db/convert.c b/db/convert.c
index 072ccc8f6ef..2214649650d 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -34,6 +34,10 @@
 	rtblock_to_bytes(rtx_to_rtblock(xfs_rbmblock_to_rtx(mp, (uint64_t)x)))
 #define rbmword_to_bytes(x)	\
 	rtblock_to_bytes(rtx_to_rtblock((uint64_t)(x) << XFS_NBWORDLOG))
+#define	rgblock_to_bytes(x)	\
+	((uint64_t)(x) << mp->m_sb.sb_blocklog)
+#define	rgnumber_to_bytes(x)	\
+	rgblock_to_bytes((uint64_t)(x) * mp->m_sb.sb_rgblocks)
 
 typedef enum {
 	CT_NONE = -1,
@@ -55,6 +59,8 @@ typedef enum {
 	CT_RSUMBLOCK,		/* block within rt summary */
 	CT_RSUMLOG,		/* log level for rtsummary computations */
 	CT_RSUMINFO,		/* info word within rt summary */
+	CT_RGBLOCK,		/* xfs_rgblock_t */
+	CT_RGNUMBER,		/* xfs_rgno_t */
 	NCTS
 } ctype_t;
 
@@ -80,6 +86,8 @@ typedef union {
 	xfs_fileoff_t	rbmblock;
 	unsigned int	rbmword;
 	xfs_fileoff_t	rsumblock;
+	xfs_rgnumber_t	rgnumber;
+	xfs_rgblock_t	rgblock;
 } cval_t;
 
 static uint64_t		bytevalue(ctype_t ctype, cval_t *val);
@@ -95,7 +103,7 @@ static const char	*agnumber_names[] = { "agnumber", "agno", NULL };
 static const char	*bboff_names[] = { "bboff", "daddroff", NULL };
 static const char	*blkoff_names[] = { "blkoff", "fsboff", "agboff",
 					    NULL };
-static const char	*rtblkoff_names[] = { "blkoff", "rtboff",
+static const char	*rtblkoff_names[] = { "blkoff", "rtboff", "rgboff",
 					    NULL };
 static const char	*byte_names[] = { "byte", "fsbyte", NULL };
 static const char	*daddr_names[] = { "daddr", "bb", NULL };
@@ -111,6 +119,8 @@ static const char	*rbmword_names[] = { "rbmword", "rbmw", NULL };
 static const char	*rsumblock_names[] = { "rsumblock", "rsmb", NULL };
 static const char	*rsumlog_names[] = { "rsumlog", "rsml", NULL };
 static const char	*rsumword_names[] = { "rsuminfo", "rsmi", NULL };
+static const char	*rgblock_names[] = { "rgblock", "rgbno", NULL };
+static const char	*rgnumber_names[] = { "rgnumber", "rgno", NULL };
 
 static int		rsuminfo;
 static int		rsumlog;
@@ -208,6 +218,14 @@ static const ctydesc_t	ctydescs_rt[NCTS] = {
 		.allowed = M(RSUMBLOCK),
 		.names   = rsumword_names,
 	},
+	[CT_RGBLOCK] = {
+		.allowed = M(RGNUMBER)|M(BBOFF)|M(BLKOFF)|M(RSUMLOG),
+		.names   = rgblock_names,
+	},
+	[CT_RGNUMBER] = {
+		.allowed = M(RGBLOCK)|M(BBOFF)|M(BLKOFF)|M(RSUMLOG),
+		.names   = rgnumber_names,
+	},
 };
 
 static const cmdinfo_t	convert_cmd =
@@ -295,6 +313,10 @@ bytevalue(ctype_t ctype, cval_t *val)
 		 * value.
 		 */
 		return 0;
+	case CT_RGBLOCK:
+		return rgblock_to_bytes(val->rgblock);
+	case CT_RGNUMBER:
+		return rgnumber_to_bytes(val->rgnumber);
 	case CT_NONE:
 	case NCTS:
 		break;
@@ -401,6 +423,8 @@ convert_f(int argc, char **argv)
 	case CT_RSUMBLOCK:
 	case CT_RSUMLOG:
 	case CT_RSUMINFO:
+	case CT_RGBLOCK:
+	case CT_RGNUMBER:
 		/* shouldn't get here */
 		ASSERT(0);
 		break;
@@ -537,6 +561,12 @@ rtconvert_f(int argc, char **argv)
 	case CT_RSUMINFO:
 		v = rt_daddr_to_rsuminfo(mp, v);
 		break;
+	case CT_RGBLOCK:
+		v = xfs_daddr_to_rgbno(mp, v >> BBSHIFT);
+		break;
+	case CT_RGNUMBER:
+		v = xfs_daddr_to_rgno(mp, v >> BBSHIFT);
+		break;
 	case CT_AGBLOCK:
 	case CT_AGINO:
 	case CT_AGNUMBER:
@@ -629,6 +659,12 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
 	case CT_RSUMINFO:
 		rsuminfo = (unsigned int)v;
 		break;
+	case CT_RGBLOCK:
+		val->rgblock = (xfs_rgblock_t)v;
+		break;
+	case CT_RGNUMBER:
+		val->rgnumber = (xfs_rgnumber_t)v;
+		break;
 	case CT_NONE:
 	case NCTS:
 		/* NOTREACHED */
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 9c1ce5d79cf..bcb4c871827 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -978,6 +978,16 @@ with alternate names, are:
 .RS 1.0i
 .PD 0
 .HP
+.B rgblock
+or
+.B rgbno
+(realtime block within a realtime group)
+.HP
+.B rgnumber
+or
+.B rgno
+(realtime group number)
+.HP
 .B bboff
 or
 .B daddroff
@@ -1045,6 +1055,13 @@ or
 .RE
 .IP
 Only conversions that "make sense" are allowed.
+The compound form (with more than three arguments) is useful for
+conversions such as
+.B convert rgno
+.I rg
+.B rgbno
+.I rgb
+.BR rtblock .
 
 Realtime summary file location conversions have the following rules:
 Each info word in the rt summary file counts the number of free extents of a

