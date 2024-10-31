Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0CA1C2DA4
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416950; cv=none; b=EVcRiAAogat5PcwfL+EsEGGh9qifSiWjIbUZgXD5feBdSYwNQzyZEvZugStMG8UDMvRxb2FVDY6fS3OAW6T57F4lWrQrcxU8VzUjIACCjRQkpVGV3oe0xP1P45baKZd8srzjUrnSJNQJ5vCECII3IUENBHXfmzNGMfa2hSJOwyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416950; c=relaxed/simple;
	bh=kWU2wq6367IRNJ0xwh22GUcA+3YwONJal9s7FvIt3FE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R3wJMR70tur8IbvncCrQkdyR5u009ZIgEaRNClPPpKswOX9z0X8cvQZ9MDLN1ot8cn+szn25TxbQ9t3IbYOOz8V97xp2+2Cs3LJzqKEF0YB5epg3ROd+2AYFiJnORYrOKTRd868aYm6/r7hSrcYifj4Ma+dz6OwKWUoq3V5ef4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZl+1ZBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZl+1ZBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DE8C4CEC3;
	Thu, 31 Oct 2024 23:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416950;
	bh=kWU2wq6367IRNJ0xwh22GUcA+3YwONJal9s7FvIt3FE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EZl+1ZBVwf3oD0S+e3rKG3UmY3cSjnWmJVdsEDDemTBeVnj7/cCluoQtynVf3J9ny
	 8wsVPw7Q9aTh/dxWMMloiO6wPwPp+XillBwqwwzlXnXdJjiKGhOH1rCXqVtYjzaGN9
	 Cckr/uBJNDAZQeT401naU2Anf3Qe9df9D2knq19jQJnYaH4fZm5i7DWMUGvGTsf7gn
	 dXhzV75u3ZBY+WEvLSmoV4GeCPl611Xfcc3BtEaShbhp6y7bZ8ysrTcYICOQVAz0Hl
	 7fmb1+0wjPT+V7goAjmm41lK2eggPGC3PgPcMazMlvMLVgIGZ3pG+nR+MZutzk9B0N
	 VnO/vOJ0BcB9Q==
Date: Thu, 31 Oct 2024 16:22:30 -0700
Subject: [PATCH 5/8] xfs_db: access arbitrary realtime blocks and extents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041567414.964205.7827955008093452877.stgit@frogsfrogsfrogs>
In-Reply-To: <173041567330.964205.623580785256778088.stgit@frogsfrogsfrogs>
References: <173041567330.964205.623580785256778088.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/block.c        |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_db.8 |   22 +++++++++++
 2 files changed, 131 insertions(+)


diff --git a/db/block.c b/db/block.c
index 87118a4751ef94..79ae0ea5802a83 100644
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
@@ -302,6 +314,103 @@ fsblock_f(
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
+			xfs_daddr_to_rtb(mp, iocur_top->off >> BBSHIFT));
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
+	set_rt_cur(&typtab[TYP_DATA], xfs_rtb_to_daddr(mp, rtbno), blkbb,
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
+/*
+ * Move the cursor to a specific location on the realtime block device given
+ * a linear address in units of realtime extents.
+ */
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
+		rtbno = xfs_daddr_to_rtb(mp, iocur_top->off >> BBSHIFT);
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
+	set_rt_cur(&typtab[TYP_DATA], xfs_rtb_to_daddr(mp, rtbno),
+			mp->m_sb.sb_rextsize * blkbb, DB_RING_ADD, NULL);
+	return 0;
+}
+
 void
 print_block(
 	const field_t	*fields,
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index f50ac949be0189..48afcb6e81787b 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1099,6 +1099,28 @@ .SH COMMANDS
 Exit
 .BR xfs_db .
 .TP
+.BI "rtblock [" rtbno ]
+Set current address to the location on the realtime device given by
+.IR rtbno .
+This value must be a realtime block number.
+If no value for
+.I rtbno
+is given the current address is printed, expressed as an rtbno.
+The type is set to
+.B data
+(uninterpreted).
+.TP
+.BI "rtextent [" rtxno ]
+Set current address to the location on the realtime device given by
+.IR rtextent .
+This value must be a linear address in units of realtime extents.
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

