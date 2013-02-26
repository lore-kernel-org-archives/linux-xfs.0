Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1A6647CBF
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 15:03:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 09668304059
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 13:03:31 -0800 (PST)
Received: from mail-qa0-f49.google.com (mail-qa0-f49.google.com
	[209.85.216.49]) by cuda.sgi.com with ESMTP id jknR63oO0g8MXhTW
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Feb 2013 13:03:27 -0800 (PST)
Received: by mail-qa0-f49.google.com with SMTP id o13so2806913qaj.15
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 13:03:26 -0800 (PST)
Date: Tue, 26 Feb 2013 16:03:22 -0500
From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH] xfstests: use native definition of O_DIRECT flag
Message-ID: <20130226210322.GB5275@wallace>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org

The definition of O_DIRECT in src/trunc.c causes xfstest 125 to fail
when run on a Pandaboard.  On ARM, the value used (0x040000) is
O_DIRECTORY rather than O_DIRECT as it is on x86.  Prefer the platform's
native definition of O_DIRECT supplied by fcntl.h if available.  Also,
fix a couple of error messages to properly reflect their context.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
---
 src/trunc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/src/trunc.c b/src/trunc.c
index 7539532..38fb21f 100644
--- a/src/trunc.c
+++ b/src/trunc.c
@@ -26,7 +26,9 @@
 #include <stdlib.h>
 #include <string.h>
 
+#ifndef O_DIRECT
 #define O_DIRECT	040000
+#endif
 
 #define WAITTIME	60
 #define BUFSIZE		4096
@@ -82,7 +84,7 @@ while((c=getopt(argc,argv,"f:"))!=EOF) {
 
 	printf("direct write of 1's into file\n");	
 	err = write(fd, buf, BUFSIZE);
-	if (err < 0) perror("buffered write failed");
+	if (err < 0) perror("direct write failed");
 
 	close(fd);
 	
@@ -96,7 +98,7 @@ while((c=getopt(argc,argv,"f:"))!=EOF) {
 
 	printf("buffered write of 2's into file\n");	
 	err = write(fd, buf, BUFSIZE);
-	if (err < 0) perror("direct write failed");
+	if (err < 0) perror("buffered write failed");
 
 	/* 1 now on disk, but 2 data is buffered */
 
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
