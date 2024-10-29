Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003FE1957E9
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730216878; cv=none; b=k/f4gimB1uX/AUbUG8NXn0h77olvdeLTvg+7nl6XeFCcH5uc3DkTAEZGIaK8xHdwblvqZfOJ5SMvjuBllTET4AIsB/iPdWtZaspVZKk4mofTGpldaHUSroLa0flu+LuoZutVcgwiKmpVp2DqFi6VBgseBmch6CvH3B/gLhi+xMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730216878; c=relaxed/simple;
	bh=ur2gudVZzIXpQd8c6rSBo5jZllmdXOFK2Rv3VShCmr8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NdBUwZ3rPRxb3mL/mw30kfH5/FMxtE9AVy+z08uwveaMwq/0GXViway+kLiTAJlo1jCOJ3thxCx9KVAYLZ5vznuDqtaesb2b5LZTR24viH05avTvwrFnJn/U3g53gizZJRZ+9uWYQ7G9yRVfE0cxNo8bx8GS7buxsSikCfiG99s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqtBHM9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqtBHM9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA21C4CECD;
	Tue, 29 Oct 2024 15:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730216877;
	bh=ur2gudVZzIXpQd8c6rSBo5jZllmdXOFK2Rv3VShCmr8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bqtBHM9JGgLIM2rShIZvmyWBJcB/G1drnXJttd5CG/hwnUzvvf+arq33Jkf/lgbcy
	 K5aDxx3EizjG/dhq2A1N4Vx4lIu8NCklUO807avLZ7xtACw72PZQOgdIrvjtEKkfZC
	 vbxa8Drfa+FD1fXoEQ/peu/z3j3oJ1SaRkBh6ofzZoXgFW32n9k0rZ9mj8gHcczBFO
	 bMWI4Zg1S+lv2mNhAPWgHOOkuRtlP1Tir2ZrPBxpEOYT6uZXEcAxt3DOauMtOlVPdV
	 f2QxCykq1IstxZZ5CqB+URcnXP/yLqmdxafbKjCQZl3cFErgfrRIaam49ssYjvbYWH
	 BMmWtsJTXAyvw==
Date: Tue, 29 Oct 2024 08:47:56 -0700
Subject: [PATCH 1/8] xfs_db: support passing the realtime device to the
 debugger
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173021673250.3128727.4592508216176625209.stgit@frogsfrogsfrogs>
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

Create a new -R flag so that sysadmins can pass the realtime device to
the xfs debugger.  Since we can now have superblocks on the rt device,
we need this to be able to inspect/dump/etc.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/init.c         |    7 +++++--
 db/io.c           |   28 +++++++++++++++++++++++-----
 db/io.h           |    2 ++
 db/xfs_admin.sh   |    4 +++-
 man/man8/xfs_db.8 |   13 +++++++++++++
 5 files changed, 46 insertions(+), 8 deletions(-)


diff --git a/db/init.c b/db/init.c
index cea25ae52bd1b7..17fb094296c2b8 100644
--- a/db/init.c
+++ b/db/init.c
@@ -33,7 +33,7 @@ static void
 usage(void)
 {
 	fprintf(stderr, _(
-		"Usage: %s [-ifFrxV] [-p prog] [-l logdev] [-c cmd]... device\n"
+		"Usage: %s [-ifFrxV] [-p prog] [-l logdev] [-R rtdev] [-c cmd]... device\n"
 		), progname);
 	exit(1);
 }
@@ -54,7 +54,7 @@ init(
 	textdomain(PACKAGE);
 
 	progname = basename(argv[0]);
-	while ((c = getopt(argc, argv, "c:fFip:rxVl:")) != EOF) {
+	while ((c = getopt(argc, argv, "c:fFip:rR:xVl:")) != EOF) {
 		switch (c) {
 		case 'c':
 			cmdline = xrealloc(cmdline, (ncmdline+1)*sizeof(char*));
@@ -75,6 +75,9 @@ init(
 		case 'r':
 			x.flags = LIBXFS_ISREADONLY;
 			break;
+		case 'R':
+			x.rt.name = optarg;
+			break;
 		case 'l':
 			x.log.name = optarg;
 			break;
diff --git a/db/io.c b/db/io.c
index 9b2c6b4cf7e963..26b8e78c2ebda8 100644
--- a/db/io.c
+++ b/db/io.c
@@ -458,6 +458,7 @@ ring_add(void)
 static void
 write_cur_buf(void)
 {
+	struct xfs_buftarg	*btp = iocur_top->bp->b_target;
 	int ret;
 
 	ret = -libxfs_bwrite(iocur_top->bp);
@@ -465,7 +466,7 @@ write_cur_buf(void)
 		dbprintf(_("write error: %s\n"), strerror(ret));
 
 	/* re-read buffer from disk */
-	ret = -libxfs_readbufr(mp->m_ddev_targp, iocur_top->bb, iocur_top->bp,
+	ret = -libxfs_readbufr(btp, iocur_top->bb, iocur_top->bp,
 			      iocur_top->blen, 0);
 	if (ret != 0)
 		dbprintf(_("read error: %s\n"), strerror(ret));
@@ -474,6 +475,7 @@ write_cur_buf(void)
 static void
 write_cur_bbs(void)
 {
+	struct xfs_buftarg	*btp = iocur_top->bp->b_target;
 	int ret;
 
 	ret = -libxfs_bwrite(iocur_top->bp);
@@ -482,7 +484,7 @@ write_cur_bbs(void)
 
 
 	/* re-read buffer from disk */
-	ret = -libxfs_readbufr_map(mp->m_ddev_targp, iocur_top->bp, 0);
+	ret = -libxfs_readbufr_map(btp, iocur_top->bp, 0);
 	if (ret != 0)
 		dbprintf(_("read error: %s\n"), strerror(ret));
 }
@@ -541,9 +543,9 @@ static void
 __set_cur(
 	struct xfs_buftarg	*btargp,
 	const typ_t		*type,
-	xfs_daddr_t		 blknum,
-	int			 len,
-	int			 ring_flag,
+	xfs_daddr_t		blknum,
+	int			len,
+	int			ring_flag,
 	bbmap_t			*bbmap)
 {
 	struct xfs_buf		*bp;
@@ -647,6 +649,22 @@ set_log_cur(
 	__set_cur(mp->m_logdev_targp, type, blknum, len, ring_flag, bbmap);
 }
 
+int
+set_rt_cur(
+	const typ_t	*type,
+	xfs_daddr_t	blknum,
+	int		len,
+	int		ring_flag,
+	bbmap_t		*bbmap)
+{
+	if (!mp->m_rtdev_targp->bt_bdev) {
+		printf(_("realtime device not loaded, use -R.\n"));
+		return ENODEV;
+	}
+
+	__set_cur(mp->m_rtdev_targp, type, blknum, len, ring_flag, bbmap);
+	return 0;
+}
 
 void
 set_iocur_type(
diff --git a/db/io.h b/db/io.h
index f48b67b47a2b55..cece66a1cf825a 100644
--- a/db/io.h
+++ b/db/io.h
@@ -51,6 +51,8 @@ extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
 			int len, int ring_add, bbmap_t *bbmap);
 extern void	set_log_cur(const struct typ *type, xfs_daddr_t blknum,
 			int len, int ring_add, bbmap_t *bbmap);
+int		set_rt_cur(const struct typ *type, xfs_daddr_t blknum,
+			int len, int ring_add, bbmap_t *bbmap);
 extern void     ring_add(void);
 extern void	set_iocur_type(const struct typ *type);
 extern void	xfs_dummy_verify(struct xfs_buf *bp);
diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index cc650c4255036b..52a658ba4a540f 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -8,6 +8,7 @@ status=0
 require_offline=""
 require_online=""
 DB_OPTS=""
+DB_DEV_OPTS=""
 REPAIR_OPTS=""
 IO_OPTS=""
 REPAIR_DEV_OPTS=""
@@ -42,6 +43,7 @@ do
 		require_offline=1
 		;;
 	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'"
+		DB_DEV_OPTS=" -R '$OPTARG'"
 		require_offline=1
 		;;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid"
@@ -89,7 +91,7 @@ case $# in
 
 		if [ -n "$DB_OPTS" ]
 		then
-			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS "$1"
+			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_DEV_OPTS $DB_OPTS "$1"
 			status=$?
 		fi
 		if [ -n "$REPAIR_OPTS" ]
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 291ec1c5827bfd..5faf8dbb1d679f 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -14,6 +14,9 @@ .SH SYNOPSIS
 .B \-l
 .I logdev
 ] [
+.B \-R
+.I rtdev
+] [
 .B \-p
 .I progname
 ]
@@ -80,6 +83,16 @@ .SH OPTIONS
 for prompts and some error messages, the default value is
 .BR xfs_db .
 .TP
+.B -R
+.I rtdev
+Specifies the device where the realtime data resides.
+This is only relevant for filesystems that have a realtime section.
+See the
+.BR mkfs.xfs "(8) " \-r
+option, and refer to
+.BR xfs (5)
+for a detailed description of the XFS realtime section.
+.TP
 .B -r
 Open
 .I device

