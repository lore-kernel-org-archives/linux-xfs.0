Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1CB18E362
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838136; cv=none; b=c9sgRmsjpVH/PtDSxG++ndl+HuhuZ4QX1uXLZ/ZqJxwi+FTvEE6FVvYYW836uF+eFFGatsk4/D877kZN24Qd9YOVbwDxmT8cH3NNpKhfKipa+AvyBeLG5de4mgNmuV6y6Fa1NGHJKhFidqK3b9u9fRmblTFPlg+UsvPMyjSDG5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838136; c=relaxed/simple;
	bh=olGLUNO8PIP8mlB+mV8X32PYLLSWsLPUA98XskmuKo0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cY1V0iQkiz5rM+d9B1x+P9xtRIxTZYrSaj72IerNuvMqGWhLBF/YiiaswHlTTD+YlebkxYNGx0XzMARVH4xyWE3ZjIWXcMaZEsr/oL64OLHEj50jI6UUSCQD2aF4KXdJtY5GCNJ/Kp5KNvV71TX+TqTXiwQBuF6yQIC50PkQjNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IU30SwP9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IU30SwP9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEA4C4CEC3;
	Fri, 25 Oct 2024 06:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838136;
	bh=olGLUNO8PIP8mlB+mV8X32PYLLSWsLPUA98XskmuKo0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IU30SwP9qdtoHeJVLoFCOe4Asq4pDpKddCpoh9uSHvLqZKG6P7kUoj6WbiS0fGR2h
	 TrvqnGbUldmbhdIzDGwf1TzoAOzVayg+8r1mYFTjm3mTy5O+gd444PV+ntmc7VwDgb
	 35yQ+MyWMnPc6Q3e1CQpxefDnPLEbA4Ejl0dAKpVpHyoFq4mhWMxZWERYYW+Ag0KgE
	 KcKWbhForfky1QKre7oxTygKPEXH/97tyZPIOkrtxoZncYf9SkerzdqdrgTZcc/z9T
	 9TtYM4CG4X9FBcmvMLgrGMDyBYfQYwBYPS5u0uoFf/SpZdVcWtL6e4GiZ+UkWZSS+T
	 hsFev749UZfWw==
Date: Thu, 24 Oct 2024 23:35:35 -0700
Subject: [PATCH 5/8] xfs_db: access arbitrary realtime blocks and extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983773804.3041229.7516109047720839026.stgit@frogsfrogsfrogs>
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

Add two commands to xfs_db so that we can point ourselves at any
arbitrary realtime block or extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c        |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   20 ++++++++++
 2 files changed, 125 insertions(+)


diff --git a/db/block.c b/db/block.c
index ff34557a612a2f..000f9c1ed10fcd 100644
--- a/db/block.c
+++ b/db/block.c
@@ -25,6 +25,10 @@ static int	dblock_f(int argc, char **argv);
 static void     dblock_help(void);
 static int	fsblock_f(int argc, char **argv);
 static void     fsblock_help(void);
+static int	rtblock_f(int argc, char **argv);
+static void	rtblock_help(void);
+static int	rtextent_f(int argc, char **argv);
+static void	rtextent_help(void);
 static void	print_rawdata(void *data, int len);
 
 static const cmdinfo_t	ablock_cmd =
@@ -39,6 +43,12 @@ static const cmdinfo_t	dblock_cmd =
 static const cmdinfo_t	fsblock_cmd =
 	{ "fsblock", "fsb", fsblock_f, 0, 1, 1, N_("[fsb]"),
 	  N_("set address to fsblock value"), fsblock_help };
+static const cmdinfo_t	rtblock_cmd =
+	{ "rtblock", "rtbno", rtblock_f, 0, 1, 1, N_("[rtbno]"),
+	  N_("set address to rtblock value"), rtblock_help };
+static const cmdinfo_t	rtextent_cmd =
+	{ "rtextent", "rtx", rtextent_f, 0, 1, 1, N_("[rtxno]"),
+	  N_("set address to rtextent value"), rtextent_help };
 
 static void
 ablock_help(void)
@@ -104,6 +114,8 @@ block_init(void)
 	add_command(&daddr_cmd);
 	add_command(&dblock_cmd);
 	add_command(&fsblock_cmd);
+	add_command(&rtblock_cmd);
+	add_command(&rtextent_cmd);
 }
 
 static void
@@ -302,6 +314,99 @@ fsblock_f(
 	return 0;
 }
 
+static void
+rtblock_help(void)
+{
+	dbprintf(_(
+"\n Example:\n"
+"\n"
+" 'rtblock 1023' - sets the file position to the 1023rd block on the realtime\n"
+" volume. The filesystem block size is specified in the superblock and set\n"
+" during mkfs time.\n\n"
+));
+}
+
+static int
+rtblock_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_rtblock_t	rtbno;
+	char		*p;
+
+	if (argc == 1) {
+		if (!iocur_is_rtdev(iocur_top)) {
+			dbprintf(_("cursor does not point to rt device\n"));
+			return 0;
+		}
+		dbprintf(_("current rtblock is %lld\n"),
+			XFS_BB_TO_FSB(mp, iocur_top->off >> BBSHIFT));
+		return 0;
+	}
+	rtbno = strtoull(argv[1], &p, 0);
+	if (*p != '\0') {
+		dbprintf(_("bad rtblock %s\n"), argv[1]);
+		return 0;
+	}
+	if (rtbno >= mp->m_sb.sb_rblocks) {
+		dbprintf(_("bad rtblock %s\n"), argv[1]);
+		return 0;
+	}
+	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
+	set_rt_cur(&typtab[TYP_DATA], XFS_FSB_TO_BB(mp, rtbno), blkbb,
+			DB_RING_ADD, NULL);
+	return 0;
+}
+
+static void
+rtextent_help(void)
+{
+	dbprintf(_(
+"\n Example:\n"
+"\n"
+" 'rtextent 10' - sets the file position to the 10th extent on the realtime\n"
+" volume. The realtime extent size is specified in the superblock and set\n"
+" during mkfs or growfs time.\n\n"
+));
+}
+
+static int
+rtextent_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_rtblock_t	rtbno;
+	xfs_rtxnum_t	rtx;
+	char		*p;
+
+	if (argc == 1) {
+		if (!iocur_is_rtdev(iocur_top)) {
+			dbprintf(_("cursor does not point to rt device\n"));
+			return 0;
+		}
+
+		rtbno = XFS_BB_TO_FSB(mp, iocur_top->off >> BBSHIFT);
+		dbprintf(_("current rtextent is %lld\n"),
+				xfs_rtb_to_rtx(mp, rtbno));
+		return 0;
+	}
+	rtx = strtoull(argv[1], &p, 0);
+	if (*p != '\0') {
+		dbprintf(_("bad rtextent %s\n"), argv[1]);
+		return 0;
+	}
+	if (rtx >= mp->m_sb.sb_rextents) {
+		dbprintf(_("bad rtextent %s\n"), argv[1]);
+		return 0;
+	}
+
+	rtbno = xfs_rtx_to_rtb(mp, rtx);
+	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
+	set_rt_cur(&typtab[TYP_DATA], XFS_FSB_TO_BB(mp, rtbno),
+			mp->m_sb.sb_rextsize * blkbb, DB_RING_ADD, NULL);
+	return 0;
+}
+
 void
 print_block(
 	const field_t	*fields,
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index f50ac949be0189..b5060a68d3bfc4 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1099,6 +1099,26 @@ .SH COMMANDS
 Exit
 .BR xfs_db .
 .TP
+.BI "rtblock [" rtbno ]
+Set current address to the rtblock value given by
+.IR rtbno .
+If no value for
+.I rtbno
+is given the current address is printed, expressed as an rtbno.
+The type is set to
+.B data
+(uninterpreted).
+.TP
+.BI "rtextent [" rtxno ]
+Set current address to the rtextent value given by
+.IR rtextent .
+If no value for
+.I rtextent
+is given the current address is printed, expressed as an rtextent.
+The type is set to
+.B data
+(uninterpreted).
+.TP
 .BI "ring [" index ]
 Show position ring (if no
 .I index

