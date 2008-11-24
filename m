Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAOHxYk3027791 for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 11:59:35 -0600
Message-ID: <492AEB83.5050000@sandeen.net>
Date: Mon, 24 Nov 2008 11:59:31 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: add mode to open call in devzero.c, which may have
	O_CREAT set.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs mailing list <xfs@oss.sgi.com>

Fedora is catching calls to open which have O_CREAT set w/o a mode.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfs-cmds/xfstests/src/devzero.c
===================================================================
--- xfs-cmds.orig/xfstests/src/devzero.c	2005-11-08 20:50:19.000000000 -0600
+++ xfs-cmds/xfstests/src/devzero.c	2008-11-24 10:29:11.211001169 -0600
@@ -74,7 +74,7 @@ main(int argc, char **argv)
 
 	path = argv[optind];
 
-	if ((fd = open(path, oflags)) < 0) {
+	if ((fd = open(path, oflags, 0600)) < 0) {
 		fprintf(stderr,
 			"error opening \"%s\": %s\n",
 			path, strerror(errno));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
