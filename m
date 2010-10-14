Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EEqiNr024498 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 09:52:45 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D7FFF30408A
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 07:53:54 -0700 (PDT)
Subject: [PATCH 08/11] xfstests: randholes: encapsulate realtime setup code
From: Alex Elder <aelder@sgi.com>
Date: Thu, 14 Oct 2010 09:50:43 -0500
Message-ID: <1287067843.2362.220.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: xfs@oss.sgi.com

Encapsulate the code that sets up the use of files on the realtime
volume.  Using realtime implies direct I/O; move the code that makes
that so into the argument parsing code.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 src/randholes.c |   55 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

Index: b/src/randholes.c
===================================================================
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -43,7 +43,6 @@ int preserve;
 int test;
 __uint64_t fileoffset;
 
-struct fsxattr rtattr;
 
 #define	READ_XFER	10	/* block to read at a time when checking */
 
@@ -119,13 +118,11 @@ void
 writeblks(char *fname, int fd, size_t alignment)
 {
 	__uint64_t offset;
-	char *buffer;
+	char *buffer = NULL;
 	int block;
 	struct flock64 fl;
 
-	if (test)
-		buffer = NULL;
-	else {
+	if (!test) {
 		if (posix_memalign((void **) &buffer, alignment, blocksize)) {
 			perror("malloc");
 			exit(1);
@@ -307,6 +304,30 @@ get_alignment(char *filename, int fd)
 	return (size_t) dioattr.d_mem;
 }
 
+static int
+realtime_setup(char *filename, int fd)
+{
+	struct fsxattr rtattr;
+
+	(void) memset(&rtattr, 0, sizeof rtattr);
+	if (xfscntl(filename, fd, FSGETXATTR, &rtattr) < 0) {
+		perror("FSGETXATTR)");
+		return 1;
+	}
+	if ((rtattr.fsx_xflags & XFS_XFLAG_REALTIME) == 0 ||
+	    (extsize && rtattr.fsx_extsize != extsize * blocksize)) {
+		rtattr.fsx_xflags |= XFS_XFLAG_REALTIME;
+		if (extsize)
+			rtattr.fsx_extsize = extsize * blocksize;
+		if (xfscntl(filename, fd, FSSETXATTR, &rtattr) < 0) {
+			perror("FSSETXATTR)");
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 int
 main(int argc, char *argv[])
 {
@@ -333,7 +354,7 @@ main(int argc, char *argv[])
 		case 'v':	verbose++;			break;
 		case 'w':	wsync++;			break;
 		case 'd':	direct++;			break;
-		case 'r':	rt++;				break;
+		case 'r':	rt++; direct++;			break;
 		case 'a':	alloconly++;			break;
 		case 'p':	preserve++;			break;
                 case 't':       test++; preserve++;             break;
@@ -371,7 +392,7 @@ main(int argc, char *argv[])
                 blocksize, (unsigned long long)filesize, seed,
 	       count, (unsigned long long)fileoffset, extsize);
         printf("randholes: verbose=%d, wsync=%d, direct=%d, rt=%d, alloconly=%d, preserve=%d, test=%d\n",
-                verbose, wsync, direct, rt, alloconly, preserve, test);
+                verbose, wsync, direct ? 1 : 0, rt, alloconly, preserve, test);
 
 	/*
 	 * Open the file, write rand block in random places, read them all
@@ -382,8 +403,6 @@ main(int argc, char *argv[])
 		perror("malloc");
 		return 1;
 	}
-	if (rt)
-		direct++;
 
         oflags=test?(O_RDONLY):(O_RDWR | O_CREAT);
 	oflags |=   (preserve ? 0 : O_TRUNC) |
@@ -395,22 +414,8 @@ main(int argc, char *argv[])
 		return 1;
 	}
 
-	if (rt) {
-		if (xfscntl(filename, fd, FSGETXATTR, &rtattr) < 0) {
-			perror("xfsnctl(FSGETXATTR)");
-			return 1;
-		}
-		if ((rtattr.fsx_xflags & XFS_XFLAG_REALTIME) == 0 ||
-		    (extsize && rtattr.fsx_extsize != extsize * blocksize)) {
-			rtattr.fsx_xflags |= XFS_XFLAG_REALTIME;
-			if (extsize)
-				rtattr.fsx_extsize = extsize * blocksize;
-			if (xfscntl(filename, fd, FSSETXATTR, &rtattr) < 0) {
-				perror("xfscntl(FSSETXATTR)");
-				return 1;
-			}
-		}
-	}
+	if (rt && realtime_setup(filename, fd))
+		return 1;
 
 	alignment = get_alignment(filename, fd);
 	if (! alignment)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
