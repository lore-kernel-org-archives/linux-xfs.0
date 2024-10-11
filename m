Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D8AD268
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728610234; cv=none; b=Y8vzx5Yp3/ljVSy5QxhkEDhs2DuHhpY6jRsJZIhlHUYA3HIjSyQD5GQ58aX4pdEu49Emupl4jJHmjSO8yeptYEs3bT6wABnV/BQ5SBHF+KP2xNzw6vwH10f9Vs51qmByVKBJKy8QOIszpecqdTYqadkHnGR1cEkkkbcMBEiSfxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728610234; c=relaxed/simple;
	bh=kXGc2v+ndpiXbZZWUI5uF7SIkSry3gk/rKyc9E5symU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xw7IXNDxxhsvIKPbECOB3ELDjCcJYqjGWK81IZY+IW9PzBVujIf6KD1XwlGUckt+k4uBBtJSdEvMgfRTF3DGH7nJHXllY9yNBk3iNMrQhPvaFOtpvfhLxRIdR7LVZUqbuHDm6aSKhhi2OTChAC3v8OhcEaGJK6R0AkUgJhcY0JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qYug4RbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qYug4RbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134CCC4CEC5;
	Fri, 11 Oct 2024 01:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728610234;
	bh=kXGc2v+ndpiXbZZWUI5uF7SIkSry3gk/rKyc9E5symU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qYug4RbFGp2iLI5pnJwohNDqfjToPeoBN2UxKAAR4KUY/HEKCXw/b/T5BHZkbm3pr
	 XWSnRyOH2+PyeQMfQ2lxWluCRnmt/O/CM+bSNKRCOtP2oDHiLzr0n574z9z0cQjo/K
	 LJKeu4KZYph1HXfkDkdCSA71IWhnNuU1dPdMxiLDxyjRl/wWe0ENtzzMkri+31DT4O
	 7lpDKk9ENvuXOYDlYcYlCP9KuVGhUAzlCg0HLwMAfs7kcpfCHl//zUU4lJ93/xWrMX
	 DQZgieQcwq4oU4IZUQy/VDN8bs60bFSDsCW2H9D1chWjgIQRhnlWU3lnutCTj/qJRt
	 GVSFJNdORVwuQ==
Date: Thu, 10 Oct 2024 18:30:33 -0700
Subject: [PATCH 23/43] xfs_db: enable conversion of rt space units
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172860655719.4184637.5680065175015487206.stgit@frogsfrogsfrogs>
In-Reply-To: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
References: <172860655297.4184637.15225662719767407515.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/convert.c      |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_db.8 |   17 +++++++++++++++
 2 files changed, 76 insertions(+), 1 deletion(-)


diff --git a/db/convert.c b/db/convert.c
index 7c0b1edc2358d1..cb484eff755735 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -34,6 +34,21 @@
 	rtblock_to_bytes(rtx_to_rtblock(xfs_rbmblock_to_rtx(mp, (uint64_t)x)))
 #define rbmword_to_bytes(x)	\
 	rtblock_to_bytes(rtx_to_rtblock((uint64_t)(x) << XFS_NBWORDLOG))
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
@@ -208,6 +229,14 @@ static const ctydesc_t	ctydescs_rt[NCTS] = {
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
@@ -295,6 +324,10 @@ bytevalue(ctype_t ctype, cval_t *val)
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
@@ -401,6 +434,8 @@ convert_f(int argc, char **argv)
 	case CT_RSUMBLOCK:
 	case CT_RSUMLOG:
 	case CT_RSUMINFO:
+	case CT_RGBLOCK:
+	case CT_RGNUMBER:
 		/* shouldn't get here */
 		ASSERT(0);
 		break;
@@ -459,6 +494,17 @@ rt_daddr_to_rsuminfo(
 	return xfs_rtsumoffs_to_infoword(mp, rsumoff);
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
@@ -551,6 +597,12 @@ rtconvert_f(int argc, char **argv)
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
@@ -643,6 +695,12 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
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
index ab58a147fd9e23..04ab1893ee7504 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1165,6 +1165,16 @@ .SH COMMANDS
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
@@ -1232,6 +1242,13 @@ .SH COMMANDS
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

