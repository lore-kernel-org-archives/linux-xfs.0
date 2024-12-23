Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E05EAF6
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992360; cv=none; b=LKomaMR5MvPMWn+newgr+u2eiXPc+PMTJ3A3GB9doQ4TuZc80ovS+QWBU2Uqz1aj3xUNqEuaLmCINu0kZ8fLfYOYP+96ED85dDHueKmoV/ExIn34Y9W/Fo+bDerL7vXpqHUSHCR5DC/pg4/Q+z8ggFjqVa+jWS3b8eaxWXyMaNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992360; c=relaxed/simple;
	bh=UU+Xiph57lZ3DZiK3m+JoI05T7pHOSur3BCWv1hioN0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mqc648d9v5TB9hXMjhPXo/zOEIoaMoH56PMH9w1O/3lc71AGt+xZxux20ryLXShNJyM+bVCnKd15LwqOx1lJWItitgouWWsgu7GC49f6dtwRGY/nKFAE3vCNK/PXxWe7TTlmOR8LDgItTtpCexQgk19Eqz95tCn1q0tfvL5fej0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XzR/IXTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XzR/IXTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9BBC4CEDE;
	Mon, 23 Dec 2024 22:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992359;
	bh=UU+Xiph57lZ3DZiK3m+JoI05T7pHOSur3BCWv1hioN0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XzR/IXTYgVYtIqyjcFKCTezkq611D/PjLndWNlkQwGQudoKlYUyDPJFZXQz/ywnjK
	 ztwCkb7dDXoq9LMbVmbQlFtJm3lu9K2TSNE7lUIJrr748GsvfJp1t+Oa6YLRqfTx/v
	 d8kVr3d9CsLUUERtGKp9AQRXsFJRzRPXTfW4Gzp2QF4wWQI0PRAkYYaea1zoDEKFY4
	 LCpPl7ow5M87n6HqTHegh01se+Wh0Ai9pP+hn1P37kBBWMcf5q2+LJk8zvhazQjku0
	 FZH8Nb75P83Co4D0SO0oEsTdM0F/XS1X/844zdNPaRJ8a3HyLAQFwF5UgMwDXEHSft
	 6bOhxIxQJ5sKw==
Date: Mon, 23 Dec 2024 14:19:19 -0800
Subject: [PATCH 29/51] xfs_db: enable conversion of rt space units
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944247.2297565.6757015588226739985.stgit@frogsfrogsfrogs>
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

Teach the xfs_db convert function about realtime extents, blocks, and
realtime group numbers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/convert.c      |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_db.8 |   17 +++++++++++++
 2 files changed, 84 insertions(+), 1 deletion(-)


diff --git a/db/convert.c b/db/convert.c
index 2cdde7d05ac397..47d3e86fdc4ef2 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -34,6 +34,21 @@
 	rtx_to_bytes(xfs_rbmblock_to_rtx(mp, (x)))
 #define	rbmword_to_bytes(x)	\
 	rtx_to_bytes((uint64_t)(x) << XFS_NBWORDLOG)
+#define	rgblock_to_bytes(x)	\
+	((uint64_t)(x) << mp->m_sb.sb_blocklog)
+#define	rgnumber_to_bytes(x)	\
+	rgblock_to_bytes((uint64_t)(x) * mp->m_groups[XG_TYPE_RTG].blocks)
+
+static inline xfs_rgnumber_t
+xfs_daddr_to_rgno(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		daddr)
+{
+	if (!xfs_has_rtgroups(mp))
+		return 0;
+
+	return XFS_BB_TO_FSBT(mp, daddr) / mp->m_groups[XG_TYPE_RTG].blocks;
+}
 
 typedef enum {
 	CT_NONE = -1,
@@ -55,6 +70,8 @@ typedef enum {
 	CT_RSUMBLOCK,		/* block within rt summary */
 	CT_RSUMLOG,		/* log level for rtsummary computations */
 	CT_RSUMINFO,		/* info word within rt summary */
+	CT_RGBLOCK,		/* xfs_rgblock_t */
+	CT_RGNUMBER,		/* xfs_rgno_t */
 	NCTS
 } ctype_t;
 
@@ -80,6 +97,8 @@ typedef union {
 	xfs_fileoff_t	rbmblock;
 	unsigned int	rbmword;
 	xfs_fileoff_t	rsumblock;
+	xfs_rgnumber_t	rgnumber;
+	xfs_rgblock_t	rgblock;
 } cval_t;
 
 static uint64_t		bytevalue(ctype_t ctype, cval_t *val);
@@ -95,7 +114,7 @@ static const char	*agnumber_names[] = { "agnumber", "agno", NULL };
 static const char	*bboff_names[] = { "bboff", "daddroff", NULL };
 static const char	*blkoff_names[] = { "blkoff", "fsboff", "agboff",
 					    NULL };
-static const char	*rtblkoff_names[] = { "blkoff", "rtboff",
+static const char	*rtblkoff_names[] = { "blkoff", "rtboff", "rgboff",
 					    NULL };
 static const char	*byte_names[] = { "byte", "fsbyte", NULL };
 static const char	*daddr_names[] = { "daddr", "bb", NULL };
@@ -111,6 +130,8 @@ static const char	*rbmword_names[] = { "rbmword", "rbmw", NULL };
 static const char	*rsumblock_names[] = { "rsumblock", "rsmb", NULL };
 static const char	*rsumlog_names[] = { "rsumlog", "rsml", NULL };
 static const char	*rsumword_names[] = { "rsuminfo", "rsmi", NULL };
+static const char	*rgblock_names[] = { "rgblock", "rgbno", NULL };
+static const char	*rgnumber_names[] = { "rgnumber", "rgno", NULL };
 
 static int		rsuminfo;
 static int		rsumlog;
@@ -244,6 +265,22 @@ static const ctydesc_t	ctydescs_rt[NCTS] = {
 		.allowed = M(RSUMBLOCK),
 		.names   = rsumword_names,
 	},
+	[CT_RGBLOCK] = {
+		.allowed = M(RGNUMBER) |
+			   M(BBOFF) |
+			   M(BLKOFF) |
+			   M(RSUMLOG),
+		.names   = rgblock_names,
+	},
+	[CT_RGNUMBER] = {
+		.allowed = M(RGBLOCK) |
+			   M(BBOFF) |
+			   M(BLKOFF) |
+			   M(RSUMLOG) |
+			   M(RBMBLOCK) |
+			   M(RBMWORD),
+		.names   = rgnumber_names,
+	},
 };
 
 static const cmdinfo_t	convert_cmd =
@@ -331,6 +368,10 @@ bytevalue(ctype_t ctype, cval_t *val)
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
@@ -437,6 +478,8 @@ convert_f(int argc, char **argv)
 	case CT_RSUMBLOCK:
 	case CT_RSUMLOG:
 	case CT_RSUMINFO:
+	case CT_RGBLOCK:
+	case CT_RGNUMBER:
 		/* shouldn't get here */
 		ASSERT(0);
 		break;
@@ -521,6 +564,17 @@ rt_daddr_to_rtgrtx(
 	return rtx;
 }
 
+static inline xfs_rgblock_t
+rt_daddr_to_rgbno(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		daddr)
+{
+	if (!xfs_has_rtgroups(mp))
+		return 0;
+
+	return XFS_BB_TO_FSBT(mp, daddr) % mp->m_groups[XG_TYPE_RTG].blocks;
+}
+
 static int
 rtconvert_f(int argc, char **argv)
 {
@@ -611,6 +665,12 @@ rtconvert_f(int argc, char **argv)
 	case CT_RSUMINFO:
 		v = rt_daddr_to_rsuminfo(mp, v);
 		break;
+	case CT_RGBLOCK:
+		v = rt_daddr_to_rgbno(mp, v >> BBSHIFT);
+		break;
+	case CT_RGNUMBER:
+		v = xfs_daddr_to_rgno(mp, v >> BBSHIFT);
+		break;
 	case CT_AGBLOCK:
 	case CT_AGINO:
 	case CT_AGNUMBER:
@@ -703,6 +763,12 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
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
index 38916036d76c03..06f4464a928596 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1162,6 +1162,16 @@ .SH COMMANDS
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
@@ -1229,6 +1239,13 @@ .SH COMMANDS
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

