Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5259C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236067AbiLaC1E (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:27:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbiLaC06 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:26:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4701E1C921
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:26:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8C9C61CD2
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:26:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457CDC433D2;
        Sat, 31 Dec 2022 02:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453616;
        bh=FgZzFCVbjpTjqVno40eR9F5ceUXXCnEZMjTysDFIrzE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WQUzRZMy6vT0vWz2TBPuORMECB/koZ9QktXFxCjo1KHpr7Bd/ww3lOFEv1/LxMi8t
         NrI/5VCd03D5zTidw/+aIXf3p1vwHVAaD3Rfpw3MROgFBktVJU6gMCf3CrTOt0r8nx
         LkR6T5QnBJWPIA8YRfbPIpe8gKP22qC4mN138bRXOvfo8128/thVb3O+RLcWxsUGiF
         KtEwvy/RYnWldTXRpuqd/wjrBv6HBH02sy6SLgtosZP9+S+IEq+ipP533HzdzW7rTn
         IFl5Ej72As3rdive8C2VxJjoGrIewID1mQT2TF+0R5Hc/3z6WeArZFNCbKhCD67uHa
         ROn6R7glDlT0g==
Subject: [PATCH 1/8] xfs_db: support passing the realtime device to the
 debugger
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:36 -0800
Message-ID: <167243877625.728317.12185309289237271664.stgit@magnolia>
In-Reply-To: <167243877610.728317.12510123562097453242.stgit@magnolia>
References: <167243877610.728317.12510123562097453242.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a new -R flag so that sysadmins can pass the realtime device to
the xfs debugger.  Since we can now have superblocks on the rt device,
we need this to be able to inspect/dump/etc.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/init.c         |    7 +++++--
 db/io.c           |   43 +++++++++++++++++++++++++++++++++++++------
 db/io.h           |    2 ++
 db/xfs_admin.sh   |    5 +++--
 man/man8/xfs_db.8 |   13 +++++++++++++
 5 files changed, 60 insertions(+), 10 deletions(-)


diff --git a/db/init.c b/db/init.c
index 9f045d27076..fc3bc403ea1 100644
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
 			x.isreadonly = LIBXFS_ISREADONLY;
 			break;
+		case 'R':
+			x.rtname = optarg;
+			break;
 		case 'l':
 			x.logname = optarg;
 			break;
diff --git a/db/io.c b/db/io.c
index 3d2572364d3..8688ee8e9c0 100644
--- a/db/io.c
+++ b/db/io.c
@@ -429,6 +429,7 @@ ring_add(void)
 static void
 write_cur_buf(void)
 {
+	struct xfs_buftarg	*btp = iocur_top->bp->b_target;
 	int ret;
 
 	ret = -libxfs_bwrite(iocur_top->bp);
@@ -436,7 +437,7 @@ write_cur_buf(void)
 		dbprintf(_("write error: %s\n"), strerror(ret));
 
 	/* re-read buffer from disk */
-	ret = -libxfs_readbufr(mp->m_ddev_targp, iocur_top->bb, iocur_top->bp,
+	ret = -libxfs_readbufr(btp, iocur_top->bb, iocur_top->bp,
 			      iocur_top->blen, 0);
 	if (ret != 0)
 		dbprintf(_("read error: %s\n"), strerror(ret));
@@ -445,6 +446,7 @@ write_cur_buf(void)
 static void
 write_cur_bbs(void)
 {
+	struct xfs_buftarg	*btp = iocur_top->bp->b_target;
 	int ret;
 
 	ret = -libxfs_bwrite(iocur_top->bp);
@@ -453,7 +455,7 @@ write_cur_bbs(void)
 
 
 	/* re-read buffer from disk */
-	ret = -libxfs_readbufr_map(mp->m_ddev_targp, iocur_top->bp, 0);
+	ret = -libxfs_readbufr_map(btp, iocur_top->bp, 0);
 	if (ret != 0)
 		dbprintf(_("read error: %s\n"), strerror(ret));
 }
@@ -508,8 +510,9 @@ write_cur(void)
 
 }
 
-void
-set_cur(
+static void
+__set_cur(
+	struct xfs_buftarg	*btp,
 	const typ_t	*type,
 	xfs_daddr_t	blknum,
 	int		len,
@@ -548,11 +551,11 @@ set_cur(
 		if (!iocur_top->bbmap)
 			return;
 		memcpy(iocur_top->bbmap, bbmap, sizeof(struct bbmap));
-		error = -libxfs_buf_read_map(mp->m_ddev_targp, bbmap->b,
+		error = -libxfs_buf_read_map(btp, bbmap->b,
 				bbmap->nmaps, LIBXFS_READBUF_SALVAGE, &bp,
 				ops);
 	} else {
-		error = -libxfs_buf_read(mp->m_ddev_targp, blknum, len,
+		error = -libxfs_buf_read(btp, blknum, len,
 				LIBXFS_READBUF_SALVAGE, &bp, ops);
 		iocur_top->bbmap = NULL;
 	}
@@ -589,6 +592,34 @@ set_cur(
 		ring_add();
 }
 
+void
+set_cur(
+	const typ_t	*type,
+	xfs_daddr_t	blknum,
+	int		len,
+	int		ring_flag,
+	bbmap_t		*bbmap)
+{
+	__set_cur(mp->m_ddev_targp, type, blknum, len, ring_flag, bbmap);
+}
+
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
+
 void
 set_iocur_type(
 	const typ_t	*type)
diff --git a/db/io.h b/db/io.h
index c29a7488198..29b22037bd6 100644
--- a/db/io.h
+++ b/db/io.h
@@ -49,6 +49,8 @@ extern void	push_cur_and_set_type(void);
 extern void	write_cur(void);
 extern void	set_cur(const struct typ *type, xfs_daddr_t blknum,
 			int len, int ring_add, bbmap_t *bbmap);
+extern int	set_rt_cur(const struct typ *type, xfs_daddr_t blknum,
+			int len, int ring_add, bbmap_t *bbmap);
 extern void     ring_add(void);
 extern void	set_iocur_type(const struct typ *type);
 extern void	xfs_dummy_verify(struct xfs_buf *bp);
diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 409975b2228..a45a75bc9a6 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -6,6 +6,7 @@
 
 status=0
 DB_OPTS=""
+DB_DEV_OPTS=""
 REPAIR_OPTS=""
 REPAIR_DEV_OPTS=""
 LOG_OPTS=""
@@ -22,7 +23,7 @@ do
 	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
 	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG";;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
-	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
+	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'"; DB_DEV_OPTS=" -R '$OPTARG'";;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
 	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
 	V)	xfs_db -p xfs_admin -V
@@ -45,7 +46,7 @@ case $# in
 
 		if [ -n "$DB_OPTS" ]
 		then
-			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS "$1"
+			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_DEV_OPTS $DB_OPTS "$1"
 			status=$?
 		fi
 		if [ -n "$REPAIR_OPTS" ]
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index a7e42e1a333..593b8037251 100644
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

