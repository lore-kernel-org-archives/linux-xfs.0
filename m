Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609FB1946C3
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730216972; cv=none; b=rHwY5WLoTXT9YN5YZuFAYeyjHBh4P2E/T61ijZD4fNz1fXgbccWc0E9RH7p7KetTDsUF0dm7JyK3rI1a9iiya01ClyPe2ySOaZI961U/SnXtUHj04mmam2F89dP2GO69ogeZoEdyqOFuTCd0ccCFhOfuVNTBWQ61N4UfUAWldIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730216972; c=relaxed/simple;
	bh=3anpG3LeRIqS329po5OC4XLorhYdVJ8rgK5i4BUPD/Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iQ6BECVdpSEUeHq2Qnd+idMRTWG9bBs37XpS9RqbMKdUYsUeLOgy6zR//lydFJ63KrHC1lhMPn0N5GENZuFGcq007L6EDgDyyAPfQaZGJMhk/cw3LRAWA8Pw6xV55gAgrr/n0aDxNR6zfauKh3paQm+C2EaGi6eRvSeD1Ntie1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFWr8jlA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFWr8jlA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7209C4CECD;
	Tue, 29 Oct 2024 15:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730216971;
	bh=3anpG3LeRIqS329po5OC4XLorhYdVJ8rgK5i4BUPD/Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bFWr8jlAEY71qoMQKvudxB9oqJVi084+F6rin6sQ4w/aOpzaFy12nFWldEuOzLa4B
	 Y9ZRq5fSWjS6yKj2io+wqTpsu1PlCcSltdUbV/QONZXrB0+XWxFeyfjx4TkncmqTb4
	 5mWvJOEpF/BY5fkzABpfGoyXKzqHYAvs4lUtVgECtP0L0zUVIPHVqUxmvlV9isCTOG
	 z8MgeNDhp7QwEloiaYc8euRVLXVGdpkM+95notCEMkb8SmI19McwRkFMq6R+kxMQDP
	 2af04+gbLW2FPdZksXhxRSSmr6/q7hvXD9dsKNauelBV6stvgegZuXBIAQKCO7PxjZ
	 huRMX5Jn4wlEQ==
Date: Tue, 29 Oct 2024 08:49:31 -0700
Subject: [PATCH 7/8] xfs_db: convert rtbitmap geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173021673341.3128727.12682444981106419639.stgit@frogsfrogsfrogs>
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

Teach the rtconvert command to be able to convert realtime blocks and
extents to locations within the rt bitmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/convert.c      |   40 ++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   10 ++++++++++
 2 files changed, 50 insertions(+)


diff --git a/db/convert.c b/db/convert.c
index 4c2ff1c5804c47..7c10690f574f7a 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -31,6 +31,10 @@
 	((uint64_t)(x) << mp->m_sb.sb_blocklog)
 #define rtx_to_rtblock(x)	\
 	((uint64_t)(x) * mp->m_sb.sb_rextsize)
+#define rbmblock_to_bytes(x)	\
+	rtblock_to_bytes(rtx_to_rtblock(xfs_rbmblock_to_rtx(mp, (uint64_t)x)))
+#define rbmword_to_bytes(x)	\
+	rtblock_to_bytes(rtx_to_rtblock((uint64_t)(x) << XFS_NBWORDLOG))
 
 typedef enum {
 	CT_NONE = -1,
@@ -47,6 +51,8 @@ typedef enum {
 	CT_INOOFF,		/* byte offset in inode */
 	CT_RTBLOCK,		/* realtime block */
 	CT_RTX,			/* realtime extent */
+	CT_RBMBLOCK,		/* block within rt bitmap */
+	CT_RBMWORD,		/* word within rt bitmap */
 	NCTS
 } ctype_t;
 
@@ -69,6 +75,8 @@ typedef union {
 	int		inooff;
 	xfs_rtblock_t	rtblock;
 	xfs_rtblock_t	rtx;
+	xfs_fileoff_t	rbmblock;
+	unsigned int	rbmword;
 } cval_t;
 
 static uint64_t		bytevalue(ctype_t ctype, cval_t *val);
@@ -95,6 +103,8 @@ static const char	*inooff_names[] = { "inooff", "inodeoff", NULL };
 
 static const char	*rtblock_names[] = { "rtblock", "rtb", "rtbno", NULL };
 static const char	*rtx_names[] = { "rtx", "rtextent", NULL };
+static const char	*rbmblock_names[] = { "rbmblock", "rbmb", NULL };
+static const char	*rbmword_names[] = { "rbmword", "rbmw", NULL };
 
 static const ctydesc_t	ctydescs[NCTS] = {
 	[CT_AGBLOCK] = {
@@ -196,6 +206,14 @@ static const ctydesc_t	ctydescs_rt[NCTS] = {
 			   M(BLKOFF),
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
@@ -236,6 +254,10 @@ bytevalue(ctype_t ctype, cval_t *val)
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
@@ -337,6 +359,8 @@ convert_f(int argc, char **argv)
 		break;
 	case CT_RTBLOCK:
 	case CT_RTX:
+	case CT_RBMBLOCK:
+	case CT_RBMWORD:
 		/* shouldn't get here */
 		ASSERT(0);
 		break;
@@ -418,6 +442,16 @@ rtconvert_f(int argc, char **argv)
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
@@ -495,6 +529,12 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
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
index 0bf434299a3fb4..12fc4f3b51016b 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1173,6 +1173,16 @@ .SH COMMANDS
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

