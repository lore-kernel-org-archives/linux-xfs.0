Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1EFC2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nJKbD2L9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C17C433C8;
	Sun, 31 Dec 2023 23:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066298;
	bh=keFBWwUyJisLAIRFl08VxMSWVf5lEwpIjqEtR1l6HnE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nJKbD2L9XBf6phMznN5yRT1GzR1iw8hl3TIqP26YMLUXPAmGXUrwQ2oiEDkTrmQOC
	 fVyyxY/3/7u/TPePjQuQiwA68xfoEuCc03pO34pZT9SDBRITsI0WZLI0UohtQlXW0l
	 20nZBcNAIf6Abq9+Rp24tqIbvNt45YEYP7d94SwOLI/Mqkf3oxYpxiIQsk/2klThIV
	 DiYeO/yQXbIwK3izcLOfgwxFqMkhc0UyP7zWsCKt46z/DdgLD9MhZZ1tyogQHGX6VW
	 Ott5q7I8UpQ/y/WOkP1GL0gb5Ba934uCme2XZ4N2L43KJD7Lq0cPZnfd61woRRJ4s0
	 hDA1kj/ZNgMHw==
Date: Sun, 31 Dec 2023 15:44:58 -0800
Subject: [PATCH 1/8] xfs_db: support passing the realtime device to the
 debugger
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405011033.1810817.9046097201583232026.stgit@frogsfrogsfrogs>
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

Create a new -R flag so that sysadmins can pass the realtime device to
the xfs debugger.  Since we can now have superblocks on the rt device,
we need this to be able to inspect/dump/etc.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/init.c         |    7 +++++--
 db/io.c           |   28 +++++++++++++++++++++++-----
 db/io.h           |    2 ++
 db/xfs_admin.sh   |    4 +++-
 man/man8/xfs_db.8 |   13 +++++++++++++
 5 files changed, 46 insertions(+), 8 deletions(-)


diff --git a/db/init.c b/db/init.c
index cea25ae52bd..17fb094296c 100644
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
index 590dd1f82f7..61befb43437 100644
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
index f48b67b47a2..bb5065f06c0 100644
--- a/db/io.h
+++ b/db/io.h
@@ -51,6 +51,8 @@ extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
 			int len, int ring_add, bbmap_t *bbmap);
 extern void	set_log_cur(const struct typ *type, xfs_daddr_t blknum,
 			int len, int ring_add, bbmap_t *bbmap);
+extern int	set_rt_cur(const struct typ *type, xfs_daddr_t blknum,
+			int len, int ring_add, bbmap_t *bbmap);
 extern void     ring_add(void);
 extern void	set_iocur_type(const struct typ *type);
 extern void	xfs_dummy_verify(struct xfs_buf *bp);
diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index cc650c42550..52a658ba4a5 100755
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
index b1712a92f76..f5e3064d923 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -14,6 +14,9 @@ xfs_db \- debug an XFS filesystem
 .B \-l
 .I logdev
 ] [
+.B \-R
+.I rtdev
+] [
 .B \-p
 .I progname
 ]
@@ -80,6 +83,16 @@ Set the program name to
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

