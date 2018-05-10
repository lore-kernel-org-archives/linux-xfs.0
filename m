Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bullwinkle.deer-run.com ([50.23.32.3]:59956 "EHLO
        bullwinkle.deer-run.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752374AbeEJVhR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 17:37:17 -0400
Received: from bullwinkle.deer-run.com (localhost.localdomain [127.0.0.1])
        by bullwinkle.deer-run.com (8.14.4/8.14.4) with ESMTP id w4ALaaS8005162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Thu, 10 May 2018 16:37:13 -0500
Received: (from hal@localhost)
        by bullwinkle.deer-run.com (8.14.4/8.14.4/Submit) id w4ALaaQx005161
        for linux-xfs@vger.kernel.org; Thu, 10 May 2018 21:36:36 GMT
Date: Thu, 10 May 2018 21:36:36 +0000
From: hal@deer-run.com
Subject: [PATCH] xfs_db: add blockget -L option
Message-ID: <20180510213636.GA5045@deer-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Hal Pomeranz <hal@deer-run.com>

Allow blockget on a mounted file system or "dirty" file system image
with pending log entries-- by simply ignoring the log.  This makes
xfs_db more useful for forensics where we are often dealing with these
types of images.  Flushing log entries to disk by mounting/unmounting
the file system would allow us to use blockget, but would make changes
to the file system state which are not desirable in forensics contexts.

Signed-off-by: Hal Pomeranz <hal@deer-run.com>
---
 db/check.c        | 74 +++++++++++++++++++++++++++++++------------------------
 db/sb.c           | 12 ++++-----
 man/man8/xfs_db.8 |  8 +++++-
 3 files changed, 55 insertions(+), 39 deletions(-)

diff --git a/db/check.c b/db/check.c
index 2f8dee5..034676a 100644
--- a/db/check.c
+++ b/db/check.c
@@ -378,7 +378,7 @@ static const cmdinfo_t	blockfree_cmd =
 	  NULL, N_("free block usage information"), NULL };
 static const cmdinfo_t	blockget_cmd =
 	{ "blockget", "check", blockget_f, 0, -1, 0,
-	  N_("[-s|-v] [-n] [-t] [-b bno]... [-i ino] ..."),
+	  N_("[-s|-v] [-L] [-n] [-t] [-b bno]... [-i ino] ..."),
 	  N_("get block usage and check consistency"), NULL };
 static const cmdinfo_t	blocktrash_cmd =
 	{ "blocktrash", NULL, blocktrash_f, 0, -1, 0,
@@ -1850,38 +1850,11 @@ init(
 	int		c;
 	xfs_ino_t	ino;
 	int		rt;
+	int		ignore_log;
+	int		lc;
 
-	serious_error = 0;
-	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
-		dbprintf(_("bad superblock magic number %x, giving up\n"),
-			mp->m_sb.sb_magicnum);
-		serious_error = 1;
-		return 0;
-	}
-	if (!sb_logcheck())
-		return 0;
-	rt = mp->m_sb.sb_rextents != 0;
-	dbmap = xmalloc((mp->m_sb.sb_agcount + rt) * sizeof(*dbmap));
-	inomap = xmalloc((mp->m_sb.sb_agcount + rt) * sizeof(*inomap));
-	inodata = xmalloc(mp->m_sb.sb_agcount * sizeof(*inodata));
-	inodata_hash_size =
-		(int)MAX(MIN(mp->m_sb.sb_icount /
-				(INODATA_AVG_HASH_LENGTH * mp->m_sb.sb_agcount),
-			     MAX_INODATA_HASH_SIZE),
-			 MIN_INODATA_HASH_SIZE);
-	for (c = 0; c < mp->m_sb.sb_agcount; c++) {
-		dbmap[c] = xcalloc(mp->m_sb.sb_agblocks, sizeof(**dbmap));
-		inomap[c] = xcalloc(mp->m_sb.sb_agblocks, sizeof(**inomap));
-		inodata[c] = xcalloc(inodata_hash_size, sizeof(**inodata));
-	}
-	if (rt) {
-		dbmap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**dbmap));
-		inomap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**inomap));
-		sumfile = xcalloc(mp->m_rsumsize, 1);
-		sumcompute = xcalloc(mp->m_rsumsize, 1);
-	}
-	nflag = sflag = tflag = verbose = optind = 0;
-	while ((c = getopt(argc, argv, "b:i:npstv")) != EOF) {
+	ignore_log = nflag = sflag = tflag = verbose = optind = 0;
+	while ((c = getopt(argc, argv, "b:i:Lnpstv")) != EOF) {
 		switch (c) {
 		case 'b':
 			bno = strtoll(optarg, NULL, 10);
@@ -1891,6 +1864,9 @@ init(
 			ino = strtoll(optarg, NULL, 10);
 			add_ilist(ino);
 			break;
+		case 'L':
+			ignore_log = 1;
+			break;
 		case 'n':
 			nflag = 1;
 			break;
@@ -1911,6 +1887,40 @@ init(
 			return 0;
 		}
 	}
+
+	serious_error = 0;
+	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
+		dbprintf(_("bad superblock magic number %x, giving up\n"),
+			mp->m_sb.sb_magicnum);
+		serious_error = 1;
+		return 0;
+	}
+
+	lc = sb_logcheck();
+	if (lc < 0 || (lc == 0 && ignore_log == 0))
+		return 0;
+
+	rt = mp->m_sb.sb_rextents != 0;
+	dbmap = xmalloc((mp->m_sb.sb_agcount + rt) * sizeof(*dbmap));
+	inomap = xmalloc((mp->m_sb.sb_agcount + rt) * sizeof(*inomap));
+	inodata = xmalloc(mp->m_sb.sb_agcount * sizeof(*inodata));
+	inodata_hash_size =
+		(int)MAX(MIN(mp->m_sb.sb_icount /
+				(INODATA_AVG_HASH_LENGTH * mp->m_sb.sb_agcount),
+			     MAX_INODATA_HASH_SIZE),
+			 MIN_INODATA_HASH_SIZE);
+	for (c = 0; c < mp->m_sb.sb_agcount; c++) {
+		dbmap[c] = xcalloc(mp->m_sb.sb_agblocks, sizeof(**dbmap));
+		inomap[c] = xcalloc(mp->m_sb.sb_agblocks, sizeof(**inomap));
+		inodata[c] = xcalloc(inodata_hash_size, sizeof(**inodata));
+	}
+	if (rt) {
+		dbmap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**dbmap));
+		inomap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**inomap));
+		sumfile = xcalloc(mp->m_rsumsize, 1);
+		sumcompute = xcalloc(mp->m_rsumsize, 1);
+	}
+
 	error = sbver_err = serious_error = 0;
 	fdblocks = frextents = icount = ifree = 0;
 	sbversion = XFS_SB_VERSION_4;
diff --git a/db/sb.c b/db/sb.c
index c7fbfd6..ba51910 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -235,13 +235,13 @@ sb_logcheck(void)
 		if (x.logdev && x.logdev != x.ddev) {
 			dbprintf(_("aborting - external log specified for FS "
 				 "with an internal log\n"));
-			return 0;
+			return -1;
 		}
 	} else {
 		if (!x.logdev || (x.logdev == x.ddev)) {
 			dbprintf(_("aborting - no external log specified for FS "
 				 "with an external log\n"));
-			return 0;
+			return -1;
 		}
 	}
 
@@ -250,14 +250,14 @@ sb_logcheck(void)
 	dirty = xlog_is_dirty(mp, mp->m_log, &x, 0);
 	if (dirty == -1) {
 		dbprintf(_("ERROR: cannot find log head/tail, run xfs_repair\n"));
-		return 0;
+		return -1;
 	} else if (dirty == 1) {
 		dbprintf(_(
 "ERROR: The filesystem has valuable metadata changes in a log which needs to\n"
 "be replayed.  Mount the filesystem to replay the log, and unmount it before\n"
 "re-running %s.  If you are unable to mount the filesystem, then use\n"
-"the xfs_repair -L option to destroy the log and attempt a repair.\n"
-"Note that destroying the log may cause corruption -- please attempt a mount\n"
+"the -L option to ignore the log. Note that ignoring the log may cause\n"
+"the program to crash or produce erroneous output. Please attempt a mount\n"
 "of the filesystem before doing this.\n"), progname);
 		return 0;
 	}
@@ -271,7 +271,7 @@ sb_logzero(uuid_t *uuidp)
 	int	cycle = XLOG_INIT_CYCLE;
 	int	error;
 
-	if (!sb_logcheck())
+	if (sb_logcheck() < 1)
 		return 0;
 
 	/*
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 524b1ef..ec6a5ed 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -194,7 +194,7 @@ command. This must be done before another
 .B blockget
 command can be given, presumably with different arguments than the previous one.
 .TP
-.BI "blockget [\-npvs] [\-b " bno "] ... [\-i " ino "] ..."
+.BI "blockget [\-Lnpvs] [\-b " bno "] ... [\-i " ino "] ..."
 Get block usage and check filesystem consistency.
 The information is saved for use by a subsequent
 .BR blockuse ", " ncheck ", or " blocktrash
@@ -209,6 +209,12 @@ information should be printed.
 is used to specify inode numbers about which verbose information
 should be printed.
 .TP
+.B \-L
+is used to ignore unplayed log entries and attempt to run
+.B blockget
+anyway. Note that using this option may cause the program to crash
+or produce erroneous output.
+.TP
 .B \-n
 is used to save pathnames for inodes visited, this is used to support the
 .BR xfs_ncheck (8)
-- 
1.8.3.1

