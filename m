Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13969C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bRTV683r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6738C433C8;
	Sun, 31 Dec 2023 23:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066407;
	bh=/mrS47RQauR4pN/bDnb7cw74kvRbnt8YFCwisB0QHuo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bRTV683r/bOLhzVj/1kVXwANNOXcX1WUUPwauqN4QrwsZ/OxYwhrtTCpW5RLLHx8B
	 7MhhIS5gslPzN2+5Id6Y5s5TsnNrKaPFg3R23gEfDxtNYnYH15RX2cCTdVN7/1lS5S
	 q2IKBUiInM0RHwVT+0f3NN2NGxOCbdENq2/s7LwSoWsZixlJ8tuB0yoScuOsQQF4Uo
	 TUNg1u3luN3f+DoIFTXiRduqYIp+pPuCxFzuDyy0uXB2url195MYQkeCkKbp3BeazY
	 DHbOy0E5XxmYNe8kdF6uzIOmlBZHQwh0DtYer2xC6mCGaVGZMATNhtSwty7iA1Niqd
	 9srHpruwYR4Rw==
Date: Sun, 31 Dec 2023 15:46:47 -0800
Subject: [PATCH 8/8] xfs_db: convert rtsummary geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405011126.1810817.3108102223603712366.stgit@frogsfrogsfrogs>
In-Reply-To: <170405011015.1810817.17512390006888048389.stgit@frogsfrogsfrogs>
References: <170405011015.1810817.17512390006888048389.stgit@frogsfrogsfrogs>
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

Teach the rtconvert command to be able to convert realtime blocks and
extents to locations within the rt summary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/convert.c      |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 man/man8/xfs_db.8 |   29 ++++++++++
 2 files changed, 174 insertions(+), 8 deletions(-)


diff --git a/db/convert.c b/db/convert.c
index 35e71f8a442..048c1766f81 100644
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
@@ -352,6 +421,52 @@ xfs_daddr_to_rtb(
 	return daddr >> mp->m_blkbb_log;
 }
 
+static inline uint64_t
+rt_daddr_to_rsumblock(
+	struct xfs_mount	*mp,
+	uint64_t		input)
+{
+	xfs_rtblock_t		rtbno;
+	xfs_rtxnum_t		rtx;
+	xfs_fileoff_t		rbmblock;
+	xfs_rtsumoff_t		rsumoff;
+
+	if (rsumlog < 0) {
+		dbprintf(_("need to set rsumlog\n"));
+		return 0;
+	}
+
+	rtbno = xfs_daddr_to_rtb(mp, input >> BBSHIFT);
+	rtx = xfs_rtb_to_rtx(mp, rtbno);
+	rbmblock = xfs_rtx_to_rbmblock(mp, rtx);
+	rsumoff = xfs_rtsumoffs(mp, rsumlog, rbmblock);
+
+	return xfs_rtsumoffs_to_block(mp, rsumoff);
+}
+
+static inline uint64_t
+rt_daddr_to_rsuminfo(
+	struct xfs_mount	*mp,
+	uint64_t		input)
+{
+	xfs_rtblock_t		rtbno;
+	xfs_rtxnum_t		rtx;
+	xfs_fileoff_t		rbmblock;
+	xfs_rtsumoff_t		rsumoff;
+
+	if (rsumlog < 0) {
+		dbprintf(_("need to set rsumlog\n"));
+		return 0;
+	}
+
+	rtbno = xfs_daddr_to_rtb(mp, input >> BBSHIFT);
+	rtx = xfs_rtb_to_rtx(mp, rtbno);
+	rbmblock = xfs_rtx_to_rbmblock(mp, rtx);
+	rsumoff = xfs_rtsumoffs(mp, rsumlog, rbmblock);
+
+	return xfs_rtsumoffs_to_infoword(mp, rsumoff);
+}
+
 static int
 rtconvert_f(int argc, char **argv)
 {
@@ -363,6 +478,9 @@ rtconvert_f(int argc, char **argv)
 	uint64_t	v;
 	ctype_t		wtype;
 
+	rsumlog = -1;
+	rsuminfo = -1;
+
 	/* move past the "rtconvert" command */
 	argc--;
 	argv++;
@@ -431,6 +549,16 @@ rtconvert_f(int argc, char **argv)
 				xfs_rtb_to_rtx(mp,
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
@@ -514,6 +642,15 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
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
index a1ea21162b5..91e9e0ed9a5 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1108,10 +1108,39 @@ or
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

