Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 452ED433D5
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992297; cv=none; b=AAakeb/zaNa1x7NgLt9NmnfSGosiG4EiGr8ZdXpRUN27034CdcGAr35e7hIKpxK2NE/IFbfvV8tNGyi2cK7Msh2xK5xPo6ralbvT4O0t0wdCXFBIcGdj3oMiOhZehrMo/209DJMbabxnguaqebksim2qETJzd2X6Rf5OfmmPYLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992297; c=relaxed/simple;
	bh=KP7Op/Q3TUsPKmAFZEnFy8TvqnYfuU6iwuo9VVj1dD0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ou9vpFPtz/KNLezFJSPA/XrlKr6k9OfgC3sEZ9LWl4m5NKt9iUQnXWBfurezkyHe5jZ5ac0xf6SLg5ylWekA90gilArdl16Bue/3tiSD/e+sC9u9HQJ/iHep2l5lzEuF7N+wbxGuN5P1A5q1MFqKf/U9OGVs9oy38raORLFZecM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnXwUstl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnXwUstl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2B4C4CED3;
	Mon, 23 Dec 2024 22:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992297;
	bh=KP7Op/Q3TUsPKmAFZEnFy8TvqnYfuU6iwuo9VVj1dD0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SnXwUstlA+lTGiZyriFkZ3bDpR/V5TNQQ3Paxxc1uu9UZQzzOs7aBCeeSUkg7wb0I
	 1nu3J8omxC0mImAM21ZgoJrkGkI02rX8nNAx13kLWcHjBytMlS5NQdeeg3RXRbbezO
	 YXTH+j0t+ECNrAyTLTf+Q+TTsSrlqr/vjSPve/j7FDi5k0NASy+CJjApcVv4chLU/z
	 WJABKePJqlgZoVYhcXS9fAiOQfFEl1SNtd/KG68hn/n7wuHPGpiHGJY/Tt0WGfJHKR
	 2Z7YKKFyJq987D53289epVYr1E0QS2kx4MtOj2bIvRbrsHRXQRjmU2fAtpFNxp5c4F
	 n2+U+l6mxnM/A==
Date: Mon, 23 Dec 2024 14:18:16 -0800
Subject: [PATCH 25/51] xfs_db: enable rtconvert to handle segmented rtblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944186.2297565.8870209811470018728.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Now that we've turned xfs_rtblock_t into a segmented address and
xfs_rtxnum_t into a per-rtgroup address, port the rtconvert debugger
command to handle the unit conversions correctly.  Also add an example
of the bitmap/summary-related conversion commands to the manpage.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/convert.c      |   52 ++++++++++++++++++++++++++++++++++++++--------------
 man/man8/xfs_db.8 |   17 +++++++++++++++--
 2 files changed, 53 insertions(+), 16 deletions(-)


diff --git a/db/convert.c b/db/convert.c
index 0c5c942150fe6f..2cdde7d05ac397 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -26,14 +26,14 @@
 	 agino_to_bytes(XFS_INO_TO_AGINO(mp, (x))))
 #define	inoidx_to_bytes(x)	\
 	((uint64_t)(x) << mp->m_sb.sb_inodelog)
-#define rtblock_to_bytes(x)	\
-	((uint64_t)(x) << mp->m_sb.sb_blocklog)
-#define rtx_to_rtblock(x)	\
-	((uint64_t)(x) * mp->m_sb.sb_rextsize)
-#define rbmblock_to_bytes(x)	\
-	rtblock_to_bytes(rtx_to_rtblock(xfs_rbmblock_to_rtx(mp, (uint64_t)x)))
-#define rbmword_to_bytes(x)	\
-	rtblock_to_bytes(rtx_to_rtblock((uint64_t)(x) << XFS_NBWORDLOG))
+#define	rtblock_to_bytes(x)	\
+	(xfs_rtb_to_daddr(mp, (x)) << BBSHIFT)
+#define	rtx_to_bytes(x)		\
+	(((uint64_t)(x) * mp->m_sb.sb_rextsize) << mp->m_sb.sb_blocklog)
+#define	rbmblock_to_bytes(x)	\
+	rtx_to_bytes(xfs_rbmblock_to_rtx(mp, (x)))
+#define	rbmword_to_bytes(x)	\
+	rtx_to_bytes((uint64_t)(x) << XFS_NBWORDLOG)
 
 typedef enum {
 	CT_NONE = -1,
@@ -316,7 +316,7 @@ bytevalue(ctype_t ctype, cval_t *val)
 	case CT_RTBLOCK:
 		return rtblock_to_bytes(val->rtblock);
 	case CT_RTX:
-		return rtblock_to_bytes(rtx_to_rtblock(val->rtx));
+		return rtx_to_bytes(val->rtx);
 	case CT_RBMBLOCK:
 		return rbmblock_to_bytes(val->rbmblock);
 	case CT_RBMWORD:
@@ -495,6 +495,32 @@ rt_daddr_to_rsuminfo(
 	return xfs_rtsumoffs_to_infoword(mp, rsumoff);
 }
 
+/* Translate an rt device disk address to be in units of realtime extents. */
+static inline uint64_t
+rt_daddr_to_rtx(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		daddr)
+{
+	return XFS_BB_TO_FSBT(mp, daddr) / mp->m_sb.sb_rextsize;
+}
+
+/*
+ * Compute the offset of an rt device disk address from the start of an
+ * rtgroup and return the result in units of realtime extents.
+ */
+static inline uint64_t
+rt_daddr_to_rtgrtx(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		daddr)
+{
+	uint64_t		rtx = rt_daddr_to_rtx(mp, daddr);
+
+	if (xfs_has_rtgroups(mp))
+		return rtx % mp->m_sb.sb_rgextents;
+
+	return rtx;
+}
+
 static int
 rtconvert_f(int argc, char **argv)
 {
@@ -565,17 +591,15 @@ rtconvert_f(int argc, char **argv)
 		v = xfs_daddr_to_rtb(mp, v >> BBSHIFT);
 		break;
 	case CT_RTX:
-		v = xfs_daddr_to_rtb(mp, v >> BBSHIFT) / mp->m_sb.sb_rextsize;
+		v = rt_daddr_to_rtx(mp, v >> BBSHIFT);
 		break;
 	case CT_RBMBLOCK:
 		v = xfs_rtx_to_rbmblock(mp,
-				xfs_rtb_to_rtx(mp,
-					xfs_daddr_to_rtb(mp, v >> BBSHIFT)));
+				rt_daddr_to_rtgrtx(mp, v >> BBSHIFT));
 		break;
 	case CT_RBMWORD:
 		v = xfs_rtx_to_rbmword(mp,
-				xfs_rtb_to_rtx(mp,
-					xfs_daddr_to_rtb(mp, v >> BBSHIFT)));
+				rt_daddr_to_rtgrtx(mp, v >> BBSHIFT));
 		break;
 	case CT_RSUMBLOCK:
 		v = rt_daddr_to_rsumblock(mp, v);
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 2325ef169ddc1b..38916036d76c03 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1239,10 +1239,23 @@ .SH COMMANDS
 conversion type, and the type must be
 .BR rsumlog .
 
-To compute the rt bitmap block from summary file location, the type/number pairs
-must be specified exactly in the order
+For example, these commands tell us where to look in the rt summary file for
+the number of free rtextents of length 2^21 starting in rt bitmap block 30:
+
+.B rtconvert rbmblock 30 rsumlog 21 rsumblock
+
+.B rtconvert rbmblock 30 rsumlog 21 rsuminfo
+
+To compute the rt bitmap block from summary file location, the type/number
+pairs must be specified exactly in the order
 .BR rsumlog ", " rsuminfo ", " rsumblock .
 
+For example, this command tells us which block in the rt bitmap file is
+summarized by info word 809 in rt summary block 10 assuming that the
+maximum free extent length is 2^21 rtextents:
+
+.B rtconvert rsumlog 21 rsuminfo 809 rsumblock 10 rbmblock
+
 .TP
 .BI "sb [" agno ]
 Set current address to SB header in allocation group

