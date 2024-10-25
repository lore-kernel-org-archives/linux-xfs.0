Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF06D18DF85
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838168; cv=none; b=uuFR2ppn+bfxf9VpI0MR8zyUYYxtf9mqMwR6gnO6qMwwBJHcs8PTr1uS4UJxhShb1gRhozPE/y14DKeBJp6/yod0Q2y8fcSGfoub1jreK6TiN5sJUJjxxXTwuclyPX0SQekZWvPaQf0o1L6Ul8K0oSytcwcn6pmpDqIzhiESUbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838168; c=relaxed/simple;
	bh=nji1vX+u1SzdK5ySLWRgWGcXm91gOLuHHz3Utsvjs/M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5/vlb7ufxNwvRh02uopJO3eHvFMxWuMPkWQPGn0NWrZy4gVX6zbKztgRnuJbPcqCTSJGHwTbUJi39JnmkPFpP6oboWUGrrJhN9FKtSTvO27XiB33chtTQwwMxnsmjQH2gsBFNTcTu3f+EFe2HY/Kyh/yCzIVWtGiXcoghAbbbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CArAhcYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CArAhcYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44E4C4CEC3;
	Fri, 25 Oct 2024 06:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838167;
	bh=nji1vX+u1SzdK5ySLWRgWGcXm91gOLuHHz3Utsvjs/M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CArAhcYQl8Mb/yf7WwbcGrjRd0UocuYC3CJj67hvIO0efmJLZLdyT9/nbaBQSIanF
	 smw1Qhv45XqX6eGgUy3cQnngKG50iltZyu5SYjM0mjnLnlByvQAnx6A1qo3xGJ5yps
	 eM2CNUIiLArx+33kanCQrYo1Mat5/RnCXtUKn9o8B+/w9D+HUJBGtfpQLCf4uCN7rK
	 7/O4SGQ43m3tSFAqejKylA+uT+CI+U0naxISYC1S69qn0n8gEWaAFV/Ngk7i0MuDVO
	 pgqZ1YZc3if6prsLhbtxkZ0HxrppMuhzmaqkxc4PKL/nXbRQo0nU/pWL+jJ2etaezr
	 IcRI8nozdOGow==
Date: Thu, 24 Oct 2024 23:36:07 -0700
Subject: [PATCH 7/8] xfs_db: convert rtbitmap geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773834.3041229.7195564819100747860.stgit@frogsfrogsfrogs>
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

Teach the rtconvert command to be able to convert realtime blocks and
extents to locations within the rt bitmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/convert.c      |   40 ++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   10 ++++++++++
 2 files changed, 50 insertions(+)


diff --git a/db/convert.c b/db/convert.c
index 811bac00f7196f..35e71f8a4421d6 100644
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
@@ -397,6 +421,16 @@ rtconvert_f(int argc, char **argv)
 	case CT_RTX:
 		v = xfs_daddr_to_rtb(mp, v >> BBSHIFT) / mp->m_sb.sb_rextsize;
 		break;
+	case CT_RBMBLOCK:
+		v = xfs_rtx_to_rbmblock(mp,
+				xfs_rtb_to_rtx(mp,
+					xfs_daddr_to_rtb(mp, v >> BBSHIFT)));
+		break;
+	case CT_RBMWORD:
+		v = xfs_rtx_to_rbmword(mp,
+				xfs_rtb_to_rtx(mp,
+					xfs_daddr_to_rtb(mp, v >> BBSHIFT)));
+		break;
 	case CT_AGBLOCK:
 	case CT_AGINO:
 	case CT_AGNUMBER:
@@ -474,6 +508,12 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
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
index fdff10cbb4fcbe..7b7d2ac124107c 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1171,6 +1171,16 @@ .SH COMMANDS
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

