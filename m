Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2F24A07
	for <linux-xfs@vger.kernel.org>; Sat,  7 Dec 2024 00:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733530303; cv=none; b=cpDmsSCgdr4it9W9Tg1CEJ/Yd55THoT8yj216BWrfLA3Lz5T3obIcpsTz3yhCHLCgM6+sYVpyDx2q03dQNnsaotN04SLrYbBkwfyLLDOuMjV7+HU87aFEjmJ1HXBkdIaTYJ8CwS5AuHAQXsJAxyFoYUyXuw75MVBifIPgYTvLnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733530303; c=relaxed/simple;
	bh=wJgZk9icS/MyBkG7z51XooIslFn9A1go55AgCM0hWZk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=USt8HU2bOy6UJTTgY7nzmB+oIaS/IYmk611xh1QWUmuiszHOUYLsh9571GVq/kEtOiQF05sX4drkf2PUyshDwgwKIX4GoxjrK+WALxhvZw85RDRejgNrVBMtie18DgveES6cv9asAAYbcwyJiwd9VThdpjhfPCR2bjT/xoE7k2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ObcRobha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ObcRobha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5753C4CED1;
	Sat,  7 Dec 2024 00:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733530302;
	bh=wJgZk9icS/MyBkG7z51XooIslFn9A1go55AgCM0hWZk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ObcRobha2KTb1OQ6xjBkJoA+8G5YQIls4VZoSmQ58wxDa/QB9bykmM6t2vKzu9jCJ
	 1tT4FXaM4Z+Dt4jj4MkSYC29uyC4UESfh0XDD9PmsuS/PzwMGJI6qKSruJyU4Qe1XQ
	 jI5s+4hQ4NQCyoanWcUOkLRIPOZbMOpERHoAZg0yGkiGeuieeRbn3qsaq7BhEbKw5t
	 OIf/GSEEhE7wPGsU3NSX4pKtdqpF3nGAlZyEkuhHkos+WLNGCdWe7fpWCB2KckI+lc
	 YZaeE+IunAiD/hjHbR6esR/3b62joGv9ngy0Q8U/QHHSauVFpnq9KakTijrDj/H37t
	 P+r4I33kVW3ew==
Date: Fri, 06 Dec 2024 16:11:42 -0800
Subject: [PATCH 26/50] xfs_db: fix rtconvert to handle segmented rtblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352752342.126362.7151084225885980106.stgit@frogsfrogsfrogs>
In-Reply-To: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
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
index 066f124458b286..3cc7314cac0e66 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1244,10 +1244,23 @@ .SH COMMANDS
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

