Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o54HYUtr236403 for <xfs@oss.sgi.com>; Fri, 4 Jun 2010 12:34:30 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 48A8D14885EF
	for <xfs@oss.sgi.com>; Fri,  4 Jun 2010 10:36:58 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id aVngRELtBKJUUsQC for
	<xfs@oss.sgi.com>; Fri, 04 Jun 2010 10:36:58 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id D58F348BC888
	for <xfs@oss.sgi.com>; Fri,  4 Jun 2010 12:36:57 -0500 (CDT)
Message-ID: <4C0939B9.9000109@sandeen.net>
Date: Fri, 04 Jun 2010 12:36:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests: use stat not lstat when examining devices
References: <4C091B4E.5030503@sandeen.net>
In-Reply-To: <4C091B4E.5030503@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

If you try running xfstests on lvm volumes which are symlinks,
it'll fail to run several tests because our _require_scratch 
framework ultimately uses lstat not stat, and does not think 
the lvm device (which is usually a symlink to a dm-X device) 
is a block device.  Sigh.

Adding a -l option to lstat64 in order to call stat not lstat,
and stat the target of the link, should be a simple fix.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/common.rc b/common.rc
index 6bf1e12..3539a43 100644
--- a/common.rc
+++ b/common.rc
@@ -584,7 +584,7 @@ _is_block_dev()
 	exit 1
     fi
 
-    [ -b $1 ] && src/lstat64 $1 | $AWK_PROG '/Device type:/ { print $9 }'
+    [ -b $1 ] && src/lstat64 -l $1 | $AWK_PROG '/Device type:/ { print $9 }'
 }
 
 # Do a command, log it to $seq.full, optionally test return status
diff --git a/src/lstat64.c b/src/lstat64.c
index 3b68c66..c7c7106 100644
--- a/src/lstat64.c
+++ b/src/lstat64.c
@@ -49,7 +49,7 @@ timesince(long timesec)
 void
 usage(void)
 {
-	fprintf(stderr, "Usage: lstat64 [-t] filename ...\n");
+	fprintf(stderr, "Usage: lstat64 [-tl] filename ...\n");
 	exit(1);
 }
 
@@ -59,13 +59,18 @@ main(int argc, char **argv)
 	struct stat64	sbuf;
 	int		i, c;
 	int		terse_flag = 0;
+	int		follow_flag = 0;
 
-	while ((c = getopt(argc, argv, "t")) != EOF) {
+	while ((c = getopt(argc, argv, "tl")) != EOF) {
 		switch (c) {
 			case 't':
 				terse_flag = 1;
 				break;
 
+			case 'l':
+				follow_flag = 1;
+				break;
+
 			case '?':
 				usage();
 		}
@@ -79,7 +84,10 @@ main(int argc, char **argv)
 	for (i = optind; i < argc; i++) {
 		char mode[] = "----------";
 
-		if( lstat64(argv[i], &sbuf) < 0) {
+		if (!follow_flag && lstat64(argv[i], &sbuf) < 0) {
+			perror(argv[i]);
+			continue;
+		} else if (follow_flag && stat64(argv[i], &sbuf) < 0) {
 			perror(argv[i]);
 			continue;
 		}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
