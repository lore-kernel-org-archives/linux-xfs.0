Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7RHhRcn215332 for <xfs@oss.sgi.com>; Sat, 27 Aug 2011 12:43:27 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A06691F0558B
	for <xfs@oss.sgi.com>; Sat, 27 Aug 2011 10:43:25 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id 5KldeZDIXava1rTc for
	<xfs@oss.sgi.com>; Sat, 27 Aug 2011 10:43:25 -0700 (PDT)
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] xfstests: don't print "do not support" warnings unless
	verbose is specified
Date: Sat, 27 Aug 2011 13:43:22 -0400
Message-Id: <1314467002-20297-1-git-send-email-tytso@mit.edu>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>

Commit 630421f6d449 attempts to avoid printing the "fallocate not
supported" warning if the -q (quiet) option is specified on the
command-line.  Unfortunately tests 75 and 112 don't set the -q flag.
This causes test failures for file systems that don't support
fallocate or the punch hole functionality.

I considered changing tests 75 and 112 to pass -q to fsx, but that
would suppress other warning messages that could be legitimate test
failures, so I decided to add a new -v (vebose) flag.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 ltp/fsx.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/ltp/fsx.c b/ltp/fsx.c
index 36b38f7..cef2c7d 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -132,6 +132,7 @@ int	readbdy = 1;			/* -r flag */
 int	style = 0;			/* -s flag */
 int	prealloc = 0;			/* -x flag */
 int	truncbdy = 1;			/* -t flag */
+int	verbose = 0;			/* -v flag */
 int	writebdy = 1;			/* -w flag */
 long	monitorstart = -1;		/* -m flag */
 long	monitorend = -1;		/* -m flag */
@@ -1299,8 +1300,8 @@ test_fallocate()
 #ifdef FALLOCATE
 	if (!lite && fallocate_calls) {
 		if (fallocate(fd, 0, 0, 1) && errno == EOPNOTSUPP) {
-			if(!quiet)
-				warn("main: filesystem does not support fallocate, disabling\n");
+			if (verbose)
+				warn("main: filesystem does not support fallocate, disabling");
 			fallocate_calls = 0;
 		} else {
 			ftruncate(fd, 0);
@@ -1319,7 +1320,7 @@ test_punch_hole()
 	if (!lite && punch_hole_calls) {
 		if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
 				0, 1) && errno == EOPNOTSUPP) {
-			if(!quiet)
+			if (verbose)
 				warn("main: filesystem does not support fallocate punch hole, disabling");
 			punch_hole_calls = 0;
 		} else
@@ -1348,7 +1349,7 @@ main(int argc, char **argv)
 
 	setvbuf(stdout, (char *)0, _IOLBF, 0); /* line buffered stdout */
 
-	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:w:xyAD:FHLN:OP:RS:WZ"))
+	while ((ch = getopt(argc, argv, "b:c:dfl:m:no:p:qr:s:t:vw:xyAD:FHLN:OP:RS:WZ"))
 	       != EOF)
 		switch (ch) {
 		case 'b':
@@ -1423,6 +1424,9 @@ main(int argc, char **argv)
 			if (truncbdy <= 0)
 				usage();
 			break;
+		case 'v':
+			verbose = 1;
+			break;
 		case 'w':
 			writebdy = getnum(optarg, &endp);
 			if (writebdy <= 0)
-- 
1.7.4.1.22.gec8e1.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
