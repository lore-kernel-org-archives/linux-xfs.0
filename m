Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3103918DF85
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838152; cv=none; b=Il0Na9WCG0N/LzC7FwK9G6YQJaeqJvZtAjPBFjaf5Wt27vd0LiVJZIJUdB0OB3QeD3YAf9ABiMiu6BPPQLQ6yrXISi/q5GT50ZldXOd8yKu5xgzOApIh2g0aj/qdw3TFcewDRDO5+Ww4ECWGK2yPhkG1OP4ugx7hNe30VIgN0DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838152; c=relaxed/simple;
	bh=7QssViXl5FkbD6N6UmW+cI1hiqNtvaqzFr8TBJ2/sSw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rA6kjVvJVaiUEd5Nhf/q5tSGbXBc+SEokuDfC05VS5H809iD0UfZklF/jE7agWljVR4MbwB8tT2gPKRX49TICX6yjmH+IWmch7TT1MGBEMYqNKjZcbVYxavS4ykSryELsQ/zNsmAAMWEzkVTo48ujasHZMmlnxF8uJRWO3VFqQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I+xkhFol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+xkhFol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09939C4CEC3;
	Fri, 25 Oct 2024 06:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838152;
	bh=7QssViXl5FkbD6N6UmW+cI1hiqNtvaqzFr8TBJ2/sSw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=I+xkhFol23RfE2Oz+hZUqd4+x2Pnhb/72Tyn4jDRpUkS9Jgu0jeWVYRGDm5ZpHXqj
	 hGmFAgErHDyb4qq4SQHLGEvxxSohHOqxkzO/PI+SCA0FV7YlymyAQiN1teeb30nZgc
	 0AV+ry8QfY1o09L3yy3E9DMA/KqTz+lmTsqMzZ5WN1rWS81GnnqSs4wQEu9xE7bg60
	 iAUuibrjdjl3MEbQefiM7YGQlmlW9vpUU2n8xAPVrF0JCAEx55vzfGEV7j01gW50zk
	 5+WwzZU5NuT6wap8aRHTTOZtqbY9oPNYctY5xKM3rT9LWvW/r05JXVDuAjrEj1zPYJ
	 zo63/2RgOi72w==
Date: Thu, 24 Oct 2024 23:35:51 -0700
Subject: [PATCH 6/8] xfs_db: enable conversion of rt space units
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773819.3041229.79394639669103592.stgit@frogsfrogsfrogs>
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

Teach the xfs_db convert function about rt extents, rt block numbers,
and how to compute offsets within the rt bitmap and summary files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/convert.c      |  232 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 man/man8/xfs_db.8 |   51 ++++++++++++
 2 files changed, 260 insertions(+), 23 deletions(-)


diff --git a/db/convert.c b/db/convert.c
index e1466057031da6..811bac00f7196f 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -26,6 +26,10 @@
 	 agino_to_bytes(XFS_INO_TO_AGINO(mp, (x))))
 #define	inoidx_to_bytes(x)	\
 	((uint64_t)(x) << mp->m_sb.sb_inodelog)
+#define rtblock_to_bytes(x)	\
+	((uint64_t)(x) << mp->m_sb.sb_blocklog)
+#define rtx_to_rtblock(x)	\
+	((uint64_t)(x) * mp->m_sb.sb_rextsize)
 
 typedef enum {
 	CT_NONE = -1,
@@ -40,11 +44,12 @@ typedef enum {
 	CT_INO,			/* xfs_ino_t */
 	CT_INOIDX,		/* index of inode in fsblock */
 	CT_INOOFF,		/* byte offset in inode */
+	CT_RTBLOCK,		/* realtime block */
+	CT_RTX,			/* realtime extent */
 	NCTS
 } ctype_t;
 
 typedef struct ctydesc {
-	ctype_t		ctype;
 	int		allowed;
 	const char	**names;
 } ctydesc_t;
@@ -61,12 +66,16 @@ typedef union {
 	xfs_ino_t	ino;
 	int		inoidx;
 	int		inooff;
+	xfs_rtblock_t	rtblock;
+	xfs_rtblock_t	rtx;
 } cval_t;
 
 static uint64_t		bytevalue(ctype_t ctype, cval_t *val);
+static int		rtconvert_f(int argc, char **argv);
 static int		convert_f(int argc, char **argv);
 static int		getvalue(char *s, ctype_t ctype, cval_t *val);
-static ctype_t		lookupcty(char *ctyname);
+static ctype_t		lookupcty(const struct ctydesc *descs,
+				  const char *ctyname);
 
 static const char	*agblock_names[] = { "agblock", "agbno", NULL };
 static const char	*agino_names[] = { "agino", "aginode", NULL };
@@ -74,6 +83,8 @@ static const char	*agnumber_names[] = { "agnumber", "agno", NULL };
 static const char	*bboff_names[] = { "bboff", "daddroff", NULL };
 static const char	*blkoff_names[] = { "blkoff", "fsboff", "agboff",
 					    NULL };
+static const char	*rtblkoff_names[] = { "blkoff", "rtboff",
+					    NULL };
 static const char	*byte_names[] = { "byte", "fsbyte", NULL };
 static const char	*daddr_names[] = { "daddr", "bb", NULL };
 static const char	*fsblock_names[] = { "fsblock", "fsb", "fsbno", NULL };
@@ -81,30 +92,91 @@ static const char	*ino_names[] = { "ino", "inode", NULL };
 static const char	*inoidx_names[] = { "inoidx", "offset", NULL };
 static const char	*inooff_names[] = { "inooff", "inodeoff", NULL };
 
+static const char	*rtblock_names[] = { "rtblock", "rtb", "rtbno", NULL };
+static const char	*rtx_names[] = { "rtx", "rtextent", NULL };
+
 static const ctydesc_t	ctydescs[NCTS] = {
-	{ CT_AGBLOCK, M(AGNUMBER)|M(BBOFF)|M(BLKOFF)|M(INOIDX)|M(INOOFF),
-	  agblock_names },
-	{ CT_AGINO, M(AGNUMBER)|M(INOOFF), agino_names },
-	{ CT_AGNUMBER,
-	  M(AGBLOCK)|M(AGINO)|M(BBOFF)|M(BLKOFF)|M(INOIDX)|M(INOOFF),
-	  agnumber_names },
-	{ CT_BBOFF, M(AGBLOCK)|M(AGNUMBER)|M(DADDR)|M(FSBLOCK), bboff_names },
-	{ CT_BLKOFF, M(AGBLOCK)|M(AGNUMBER)|M(FSBLOCK), blkoff_names },
-	{ CT_BYTE, 0, byte_names },
-	{ CT_DADDR, M(BBOFF), daddr_names },
-	{ CT_FSBLOCK, M(BBOFF)|M(BLKOFF)|M(INOIDX), fsblock_names },
-	{ CT_INO, M(INOOFF), ino_names },
-	{ CT_INOIDX, M(AGBLOCK)|M(AGNUMBER)|M(FSBLOCK)|M(INOOFF),
-	  inoidx_names },
-	{ CT_INOOFF,
-	  M(AGBLOCK)|M(AGINO)|M(AGNUMBER)|M(FSBLOCK)|M(INO)|M(INOIDX),
-	  inooff_names },
+	[CT_AGBLOCK] = {
+		.allowed = M(AGNUMBER)|M(BBOFF)|M(BLKOFF)|M(INOIDX)|M(INOOFF),
+		.names   = agblock_names,
+	},
+	[CT_AGINO] = {
+		.allowed = M(AGNUMBER)|M(INOOFF),
+		.names   = agino_names,
+	},
+	[CT_AGNUMBER] = {
+		.allowed = M(AGBLOCK)|M(AGINO)|M(BBOFF)|M(BLKOFF)|M(INOIDX)|M(INOOFF),
+		.names   = agnumber_names,
+	},
+	[CT_BBOFF] = {
+		.allowed = M(AGBLOCK)|M(AGNUMBER)|M(DADDR)|M(FSBLOCK),
+		.names   = bboff_names,
+	},
+	[CT_BLKOFF] = {
+		.allowed = M(AGBLOCK)|M(AGNUMBER)|M(FSBLOCK),
+		.names   = blkoff_names,
+	},
+	[CT_BYTE] = {
+		.allowed = 0,
+		.names   = byte_names,
+	},
+	[CT_DADDR] = {
+		.allowed = M(BBOFF),
+		.names   = daddr_names,
+	},
+	[CT_FSBLOCK] = {
+		.allowed = M(BBOFF)|M(BLKOFF)|M(INOIDX),
+		.names   = fsblock_names,
+	},
+	[CT_INO] = {
+		.allowed = M(INOOFF),
+		.names   = ino_names,
+	},
+	[CT_INOIDX] = {
+		.allowed = M(AGBLOCK)|M(AGNUMBER)|M(FSBLOCK)|M(INOOFF),
+		.names   = inoidx_names,
+	},
+	[CT_INOOFF] = {
+		.allowed = M(AGBLOCK)|M(AGINO)|M(AGNUMBER)|M(FSBLOCK)|M(INO)|M(INOIDX),
+		.names   = inooff_names,
+	},
+};
+
+static const ctydesc_t	ctydescs_rt[NCTS] = {
+	[CT_BBOFF] = {
+		.allowed = M(DADDR)|M(RTBLOCK),
+		.names   = bboff_names,
+	},
+	[CT_BLKOFF] = {
+		.allowed = M(RTBLOCK),
+		.names   = rtblkoff_names,
+	},
+	[CT_BYTE] = {
+		.allowed = 0,
+		.names   = byte_names,
+	},
+	[CT_DADDR] = {
+		.allowed = M(BBOFF),
+		.names   = daddr_names,
+	},
+	[CT_RTBLOCK] = {
+		.allowed = M(BBOFF)|M(BLKOFF),
+		.names   = rtblock_names,
+	},
+	[CT_RTX] = {
+		.allowed = M(BBOFF)|M(BLKOFF),
+		.names   = rtx_names,
+	},
 };
 
 static const cmdinfo_t	convert_cmd =
 	{ "convert", NULL, convert_f, 3, 9, 0, "type num [type num]... type",
 	  "convert from one address form to another", NULL };
 
+static const cmdinfo_t	rtconvert_cmd =
+	{ "rtconvert", NULL, rtconvert_f, 3, 9, 0, "type num [type num]... type",
+	  "convert from one realtime address form to another", NULL };
+
 static uint64_t
 bytevalue(ctype_t ctype, cval_t *val)
 {
@@ -131,6 +203,10 @@ bytevalue(ctype_t ctype, cval_t *val)
 		return inoidx_to_bytes(val->inoidx);
 	case CT_INOOFF:
 		return (uint64_t)val->inooff;
+	case CT_RTBLOCK:
+		return rtblock_to_bytes(val->rtblock);
+	case CT_RTX:
+		return rtblock_to_bytes(rtx_to_rtblock(val->rtx));
 	case CT_NONE:
 	case NCTS:
 		break;
@@ -159,13 +235,13 @@ convert_f(int argc, char **argv)
 			 "arguments\n"), argc);
 		return 0;
 	}
-	if ((wtype = lookupcty(argv[argc - 1])) == CT_NONE) {
+	if ((wtype = lookupcty(ctydescs, argv[argc - 1])) == CT_NONE) {
 		dbprintf(_("unknown conversion type %s\n"), argv[argc - 1]);
 		return 0;
 	}
 
 	for (i = mask = conmask = 0; i < (argc - 1) / 2; i++) {
-		c = lookupcty(argv[i * 2]);
+		c = lookupcty(ctydescs, argv[i * 2]);
 		if (c == CT_NONE) {
 			dbprintf(_("unknown conversion type %s\n"), argv[i * 2]);
 			return 0;
@@ -230,6 +306,107 @@ convert_f(int argc, char **argv)
 	case CT_INOOFF:
 		v &= mp->m_sb.sb_inodesize - 1;
 		break;
+	case CT_RTBLOCK:
+	case CT_RTX:
+		/* shouldn't get here */
+		ASSERT(0);
+		break;
+	case CT_NONE:
+	case NCTS:
+		/* NOTREACHED */
+		break;
+	}
+	dbprintf("0x%llx (%llu)\n", v, v);
+	return 0;
+}
+
+static inline xfs_rtblock_t
+xfs_daddr_to_rtb(
+	struct xfs_mount	*mp,
+	xfs_daddr_t		daddr)
+{
+	return daddr >> mp->m_blkbb_log;
+}
+
+static int
+rtconvert_f(int argc, char **argv)
+{
+	ctype_t		c;
+	int		conmask;
+	cval_t		cvals[NCTS] = {};
+	int		i;
+	int		mask;
+	uint64_t	v;
+	ctype_t		wtype;
+
+	/* move past the "rtconvert" command */
+	argc--;
+	argv++;
+
+	if ((argc % 2) != 1) {
+		dbprintf(_("bad argument count %d to rtconvert, expected 3,5,7,9 "
+			 "arguments\n"), argc);
+		return 0;
+	}
+	if ((wtype = lookupcty(ctydescs_rt, argv[argc - 1])) == CT_NONE) {
+		dbprintf(_("unknown conversion type %s\n"), argv[argc - 1]);
+		return 0;
+	}
+
+	for (i = mask = conmask = 0; i < (argc - 1) / 2; i++) {
+		c = lookupcty(ctydescs_rt, argv[i * 2]);
+		if (c == CT_NONE) {
+			dbprintf(_("unknown conversion type %s\n"), argv[i * 2]);
+			return 0;
+		}
+		if (c == wtype) {
+			dbprintf(_("result type same as argument\n"));
+			return 0;
+		}
+		if (conmask & (1 << c)) {
+			dbprintf(_("conflicting conversion type %s\n"),
+				argv[i * 2]);
+			return 0;
+		}
+		if (!getvalue(argv[i * 2 + 1], c, &cvals[c]))
+			return 0;
+		mask |= 1 << c;
+		conmask |= ~ctydescs_rt[c].allowed;
+	}
+	v = 0;
+	for (c = (ctype_t)0; c < NCTS; c++) {
+		if (!(mask & (1 << c)))
+			continue;
+		v += bytevalue(c, &cvals[c]);
+	}
+	switch (wtype) {
+	case CT_BBOFF:
+		v &= BBMASK;
+		break;
+	case CT_BLKOFF:
+		v &= mp->m_blockmask;
+		break;
+	case CT_BYTE:
+		break;
+	case CT_DADDR:
+		v >>= BBSHIFT;
+		break;
+	case CT_RTBLOCK:
+		v = xfs_daddr_to_rtb(mp, v >> BBSHIFT);
+		break;
+	case CT_RTX:
+		v = xfs_daddr_to_rtb(mp, v >> BBSHIFT) / mp->m_sb.sb_rextsize;
+		break;
+	case CT_AGBLOCK:
+	case CT_AGINO:
+	case CT_AGNUMBER:
+	case CT_FSBLOCK:
+	case CT_INO:
+	case CT_INOIDX:
+	case CT_INOOFF:
+		/* shouldn't get here */
+		ASSERT(0);
+		break;
 	case CT_NONE:
 	case NCTS:
 		/* NOTREACHED */
@@ -243,6 +420,7 @@ void
 convert_init(void)
 {
 	add_command(&convert_cmd);
+	add_command(&rtconvert_cmd);
 }
 
 static int
@@ -290,6 +468,12 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
 	case CT_INOOFF:
 		val->inooff = (int)v;
 		break;
+	case CT_RTBLOCK:
+		val->rtblock = (xfs_rtblock_t)v;
+		break;
+	case CT_RTX:
+		val->rtx = (xfs_rtblock_t)v;
+		break;
 	case CT_NONE:
 	case NCTS:
 		/* NOTREACHED */
@@ -299,13 +483,15 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
 }
 
 static ctype_t
-lookupcty(char *ctyname)
+lookupcty(
+	const struct ctydesc	*descs,
+	const char		*ctyname)
 {
 	ctype_t		cty;
 	const char	**name;
 
 	for (cty = (ctype_t)0; cty < NCTS; cty++) {
-		for (name = ctydescs[cty].names; *name; name++) {
+		for (name = descs[cty].names; name && *name; name++) {
 			if (strcmp(ctyname, *name) == 0)
 				return cty;
 		}
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index b5060a68d3bfc4..fdff10cbb4fcbe 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1125,6 +1125,57 @@ .SH COMMANDS
 argument is given), or move to a specific entry in the position ring given by
 .IR index .
 .TP
+.BI "rtconvert " "type number" " [" "type number" "] ... " type
+Convert from one address form to another for realtime section addresses.
+The known
+.IR type s,
+with alternate names, are:
+.RS 1.0i
+.PD 0
+.HP
+.B bboff
+or
+.B daddroff
+(byte offset in a
+.BR daddr )
+.HP
+.B blkoff
+or
+.B fsboff or
+.B rtboff
+(byte offset in a
+.B rtblock
+or
+.BR rtextent )
+.HP
+.B byte
+or
+.B fsbyte
+(byte address in filesystem)
+.HP
+.B daddr
+or
+.B bb
+(disk address, 512-byte blocks)
+.HP
+.B rtblock
+or
+.B rtb
+or
+.B rtbno
+(realtime filesystem block, see the
+.B fsblock
+command)
+.HP
+.B rtx
+or
+.B rtextent
+(realtime extent)
+.PD
+.RE
+.IP
+Only conversions that "make sense" are allowed.
+.TP
 .BI "sb [" agno ]
 Set current address to SB header in allocation group
 .IR agno .

