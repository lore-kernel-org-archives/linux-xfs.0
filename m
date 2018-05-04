Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bullwinkle.deer-run.com ([50.23.32.3]:57664 "EHLO
        bullwinkle.deer-run.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbeEDOcu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 May 2018 10:32:50 -0400
Received: from bullwinkle.deer-run.com (localhost.localdomain [127.0.0.1])
        by bullwinkle.deer-run.com (8.14.4/8.14.4) with ESMTP id w44E2l1X032241
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Fri, 4 May 2018 09:03:28 -0500
Received: (from hal@localhost)
        by bullwinkle.deer-run.com (8.14.4/8.14.4/Submit) id w44E2iHb032239
        for linux-xfs@vger.kernel.org; Fri, 4 May 2018 09:02:44 -0500
Date: Fri, 4 May 2018 09:02:44 -0500
From: hal@deer-run.com
Subject: [PATCH] xfs_db: add -R option
Message-ID: <20180504140244.GA32161@deer-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Hal Pomeranz <hal@deer-run.com>

-R is similar to -r, but allows for blockget on a mounted file system
or "dirty" file system image with pending log entries.  This makes
xfs_db more useful for forensics where we are often dealing with these
types of images.  Flushing log entries to disk by mounting/unmounting
the file system would allow us to use blockget, but would make changes
to the file system state which are not desirable in forensics
contexts.

Signed-off-by: Hal Pomeranz <hal@deer-run.com>
---
 db/init.c         | 7 +++++--
 db/init.h         | 1 +
 db/sb.c           | 2 +-
 man/man8/xfs_db.8 | 8 ++++++++
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/db/init.c b/db/init.c
index 29fc344..96a0e78 100644
--- a/db/init.c
+++ b/db/init.c
@@ -36,6 +36,7 @@ int			blkbb;
 int			exitcode;
 int			expert_mode;
 int			force;
+int                     ignore_dirty;
 struct xfs_mount	xmount;
 struct xfs_mount	*mp;
 struct xlog		xlog;
@@ -46,7 +47,7 @@ static void
 usage(void)
 {
 	fprintf(stderr, _(
-		"Usage: %s [-ifFrxV] [-p prog] [-l logdev] [-c cmd]... device\n"
+		"Usage: %s [-ifFrRxV] [-p prog] [-l logdev] [-c cmd]... device\n"
 		), progname);
 	exit(1);
 }
@@ -66,7 +67,7 @@ init(
 	textdomain(PACKAGE);
 
 	progname = basename(argv[0]);
-	while ((c = getopt(argc, argv, "c:fFip:rxVl:")) != EOF) {
+	while ((c = getopt(argc, argv, "c:fFip:rRxVl:")) != EOF) {
 		switch (c) {
 		case 'c':
 			cmdline = xrealloc(cmdline, (ncmdline+1)*sizeof(char*));
@@ -84,6 +85,8 @@ init(
 		case 'p':
 			progname = optarg;
 			break;
+		case 'R':
+		        ignore_dirty = 1;
 		case 'r':
 			x.isreadonly = LIBXFS_ISREADONLY;
 			break;
diff --git a/db/init.h b/db/init.h
index b09389e..f6bfda9 100644
--- a/db/init.h
+++ b/db/init.h
@@ -20,6 +20,7 @@ extern char		*fsdevice;
 extern int		blkbb;
 extern int		exitcode;
 extern int		expert_mode;
+extern int              ignore_dirty;
 extern xfs_mount_t	*mp;
 extern libxfs_init_t	x;
 extern xfs_agnumber_t	cur_agno;
diff --git a/db/sb.c b/db/sb.c
index c7fbfd6..4c04d79 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -251,7 +251,7 @@ sb_logcheck(void)
 	if (dirty == -1) {
 		dbprintf(_("ERROR: cannot find log head/tail, run xfs_repair\n"));
 		return 0;
-	} else if (dirty == 1) {
+	} else if (dirty == 1 && ignore_dirty == 0) {
 		dbprintf(_(
 "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
 "be replayed.  Mount the filesystem to replay the log, and unmount it before\n"
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 524b1ef..89be1aa 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -90,6 +90,14 @@ It is only necessary to omit this flag if a command that changes data
 .RB ( write ", " blocktrash ", " crc )
 is to be used.
 .TP
+.B -R
+Like
+.B -r
+but allows the 
+.B blockget
+command even if the file system is "dirty" (unreconciled transactions
+in the log).
+.TP
 .B \-x
 Specifies expert mode.
 This enables the
-- 
1.8.3.1

