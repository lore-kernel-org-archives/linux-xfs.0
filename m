Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EEqj5U024502 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 09:52:45 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB46230408D
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 07:53:54 -0700 (PDT)
Subject: [PATCH 10/11] xfstests: randholes: encapsulate argument parsing
From: Alex Elder <aelder@sgi.com>
Date: Thu, 14 Oct 2010 09:50:57 -0500
Message-ID: <1287067857.2362.225.camel@doink>
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

Move the argument parsing code out of main() and into a separate
parseargs() routine.  The name of the target file for the test
is returned by parseargs() if no error occurs.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 src/randholes.c |  134 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 75 insertions(+), 59 deletions(-)

Index: b/src/randholes.c
===================================================================
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -81,6 +81,76 @@ usage(char *progname)
 	exit(1);
 }
 
+/* Returns filename if successful or a null pointer if an error occurs */
+
+static char *
+parseargs(int argc, char *argv[])
+{
+	int seed;
+	int ch;
+
+	filesize = DEFAULT_FILESIZE;
+	blocksize = DEFAULT_BLOCKSIZE;
+	count = (int) filesize / blocksize;
+	verbose = 0;
+	wsync = 0;
+	seed = time(NULL);
+	test = 0;
+	while ((ch = getopt(argc, argv, "b:l:s:c:o:x:vwdrapt")) != EOF) {
+		switch(ch) {
+		case 'b':	blocksize  = atoi(optarg);	break;
+		case 'l':	filesize   = strtoull(optarg, NULL, 16); break;
+		case 's':	seed       = atoi(optarg);	break;
+		case 'c':	count      = atoi(optarg);	break;
+		case 'o':	fileoffset = strtoull(optarg, NULL, 16); break;
+		case 'x':	extsize    = atoi(optarg);	break;
+		case 'v':	verbose++;			break;
+		case 'w':	wsync++;			break;
+		case 'd':	direct++;			break;
+		case 'r':	rt++; direct++;			break;
+		case 'a':	alloconly++;			break;
+		case 'p':	preserve++;			break;
+		case 't':	test++; preserve++;		break;
+		default:	usage(argv[0]);			break;
+		}
+	}
+	if (optind != argc - 1)
+		usage(argv[0]);
+
+	if ((filesize % blocksize) != 0) {
+		filesize -= filesize % blocksize;
+		printf("filesize not a multiple of blocksize, reducing filesize to %llu\n",
+		       (unsigned long long)filesize);
+	}
+	if ((fileoffset % blocksize) != 0) {
+		fileoffset -= fileoffset % blocksize;
+		printf("fileoffset not a multiple of blocksize, reducing fileoffset to %llu\n",
+		       (unsigned long long)fileoffset);
+	}
+	if (count > (filesize/blocksize)) {
+		count = (filesize/blocksize);
+		printf("count of blocks written is too large, setting to %d\n",
+			      count);
+	} else if (count < 1) {
+		count = 1;
+		printf("count of blocks written is too small, setting to %d\n",
+			      count);
+	}
+	printf("randholes: Seed = %d (use \"-s %d\" to re-execute this test)\n", seed, seed);
+	srandom(seed);
+
+        printf("randholes: blocksize=%d, filesize=%llu, seed=%d\n"
+               "randholes: count=%d, offset=%llu, extsize=%d\n",
+                blocksize, (unsigned long long)filesize, seed,
+	       count, (unsigned long long)fileoffset, extsize);
+        printf("randholes: verbose=%d, wsync=%d, direct=%d, rt=%d, alloconly=%d, preserve=%d, test=%d\n",
+                verbose, wsync, direct ? 1 : 0, rt, alloconly, preserve, test);
+
+	/* Last argument is the file name.  Return it. */
+
+	return argv[optind];	/* Success */
+}
+
 int
 findblock(void)
 {
@@ -330,68 +400,14 @@ realtime_setup(char *filename, int fd)
 int
 main(int argc, char *argv[])
 {
-	int seed, ch, fd, oflags;
-	char *filename = NULL;
+	int fd, oflags;
+	char *filename;
         int r;
 	size_t alignment;
 
-	filesize = DEFAULT_FILESIZE;
-	blocksize = DEFAULT_BLOCKSIZE;
-	count = (int) filesize / blocksize;
-	verbose = 0;
-	wsync = 0;
-	seed = time(NULL);
-        test = 0;
-	while ((ch = getopt(argc, argv, "b:l:s:c:o:x:vwdrapt")) != EOF) {
-		switch(ch) {
-		case 'b':	blocksize  = atoi(optarg);	break;
-		case 'l':	filesize   = strtoull(optarg, NULL, 16); break;
-		case 's':	seed       = atoi(optarg);	break;
-		case 'c':	count      = atoi(optarg);	break;
-		case 'o':	fileoffset = strtoull(optarg, NULL, 16); break;
-		case 'x':	extsize    = atoi(optarg);	break;
-		case 'v':	verbose++;			break;
-		case 'w':	wsync++;			break;
-		case 'd':	direct++;			break;
-		case 'r':	rt++; direct++;			break;
-		case 'a':	alloconly++;			break;
-		case 'p':	preserve++;			break;
-                case 't':       test++; preserve++;             break;
-		default:	usage(argv[0]);			break;
-		}
-	}
-	if (optind == argc-1)
-		filename = argv[optind];
-	else
-		usage(argv[0]);
-	if ((filesize % blocksize) != 0) {
-		filesize -= filesize % blocksize;
-		printf("filesize not a multiple of blocksize, reducing filesize to %llu\n",
-		       (unsigned long long)filesize);
-	}
-	if ((fileoffset % blocksize) != 0) {
-		fileoffset -= fileoffset % blocksize;
-		printf("fileoffset not a multiple of blocksize, reducing fileoffset to %llu\n",
-		       (unsigned long long)fileoffset);
-	}
-	if (count > (filesize/blocksize)) {
-		count = (filesize/blocksize);
-		printf("count of blocks written is too large, setting to %d\n",
-			      count);
-	} else if (count < 1) {
-		count = 1;
-		printf("count of blocks written is too small, setting to %d\n",
-			      count);
-	}
-	printf("randholes: Seed = %d (use \"-s %d\" to re-execute this test)\n", seed, seed);
-	srandom(seed);
-
-        printf("randholes: blocksize=%d, filesize=%llu, seed=%d\n"
-               "randholes: count=%d, offset=%llu, extsize=%d\n",
-                blocksize, (unsigned long long)filesize, seed,
-	       count, (unsigned long long)fileoffset, extsize);
-        printf("randholes: verbose=%d, wsync=%d, direct=%d, rt=%d, alloconly=%d, preserve=%d, test=%d\n",
-                verbose, wsync, direct ? 1 : 0, rt, alloconly, preserve, test);
+	filename = parseargs(argc, argv);
+	if (! filename)
+		return 1;
 
 	/*
 	 * Open the file, write rand block in random places, read them all


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
