Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 329A07F37
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 12:04:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25517304051
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 10:04:39 -0700 (PDT)
Received: from emh07.mail.saunalahti.fi (emh07.mail.saunalahti.fi
	[62.142.5.117]) by cuda.sgi.com with ESMTP id LiACmgWHV76H9r3d
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2015 10:04:37 -0700 (PDT)
From: Mika Eloranta <mel@ohmu.fi>
Subject: [PATCH] mkfs.xfs: add [-U uuid] option
Date: Mon, 21 Sep 2015 20:04:20 +0300
Message-Id: <1442855060-38259-1-git-send-email-mel@ohmu.fi>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Mika Eloranta <mel@ohmu.fi>

The UUID can now be optionally specified during filesystem
creation.
---
 man/man8/mkfs.xfs.8 |  7 +++++++
 mkfs/xfs_mkfs.c     | 12 ++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
index 6260e0c..ab48dd7 100644
--- a/man/man8/mkfs.xfs.8
+++ b/man/man8/mkfs.xfs.8
@@ -38,6 +38,9 @@ mkfs.xfs \- construct an XFS filesystem
 .B \-L
 .I label
 ] [
+.B \-U
+.I uuid
+] [
 .B \-N
 ] [
 .B \-K
@@ -816,6 +819,10 @@ will not proceed with creating the filesystem.  Refer to the
 .BR mount "(8) and " xfs_admin (8)
 manual entries for additional information.
 .TP
+.BI \-U " uuid"
+Create the filesystem with the specified
+.IR UUID .
+.TP
 .B \-N
 Causes the file system parameters to be printed out without really
 creating the file system.
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d993fc0..9fc5c67 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -948,6 +948,7 @@ main(
 	bool			finobtflag;
 	int			spinodes;
 
+	platform_uuid_clear(&uuid);
 	progname = basename(argv[0]);
 	setlocale(LC_ALL, "");
 	bindtextdomain(PACKAGE, LOCALEDIR);
@@ -990,7 +991,7 @@ main(
 	xi.isdirect = LIBXFS_DIRECT;
 	xi.isreadonly = LIBXFS_EXCLUSIVELY;
 
-	while ((c = getopt(argc, argv, "b:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
+	while ((c = getopt(argc, argv, "b:d:i:l:L:U:m:n:KNp:qr:s:CfV")) != EOF) {
 		switch (c) {
 		case 'C':
 		case 'f':
@@ -1465,6 +1466,10 @@ main(
 				illegal(optarg, "L");
 			label = optarg;
 			break;
+		case 'U':
+			if (platform_uuid_parse(optarg, &uuid))
+				illegal(optarg, "U");
+			break;
 		case 'm':
 			p = optarg;
 			while (*p != '\0') {
@@ -2550,7 +2555,9 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	sbp->sb_dblocks = dblocks;
 	sbp->sb_rblocks = rtblocks;
 	sbp->sb_rextents = rtextents;
-	platform_uuid_generate(&uuid);
+	if (platform_uuid_is_null(&uuid)) {
+	    platform_uuid_generate(&uuid);
+	}
 	platform_uuid_copy(&sbp->sb_uuid, &uuid);
 	/* Only in memory; libxfs expects this as if read from disk */
 	platform_uuid_copy(&sbp->sb_meta_uuid, &uuid);
@@ -3175,6 +3182,7 @@ usage( void )
 			    sunit=value|su=num,sectlog=n|sectsize=num,\n\
 			    lazy-count=0|1]\n\
 /* label */		[-L label (maximum 12 characters)]\n\
+/* uuid */		[-U uuid]\n\
 /* naming */		[-n log=n|size=num,version=2|ci,ftype=0|1]\n\
 /* no-op info only */	[-N]\n\
 /* prototype file */	[-p fname]\n\
-- 
2.3.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
