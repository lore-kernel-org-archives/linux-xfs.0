Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EEqjjL024506 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 09:52:45 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F29E230408E
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 07:53:54 -0700 (PDT)
Subject: [PATCH 11/11] xfstests: randholes: a few final cleanups
From: Alex Elder <aelder@sgi.com>
Date: Thu, 14 Oct 2010 09:51:01 -0500
Message-ID: <1287067861.2362.226.camel@doink>
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

Minor bits to wrap up this series.
- Bumped up the number of blocks read at once from 10 to 256
- Shorten remaining long lines
- Re-factor findblock()
- Get rid of global variable "nvalid"
- Add a few more comments
- Give all global symbols static scope
- Update the copyright message
- Various other minor formatting changes.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 src/randholes.c |  155 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 86 insertions(+), 69 deletions(-)

Index: b/src/randholes.c
===================================================================
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2000-2003 Silicon Graphics, Inc.
+ * Copyright (c) 2000-2003, 2010 SGI
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or
@@ -20,31 +20,31 @@
 
 #include "global.h"
 
-unsigned char	*valid;	/* Bit-vector array showing which blocks have been written */
-int		nvalid;	/* number of bytes in valid array */
-#define	SETBIT(ARRAY, N)	((ARRAY)[(N)/8] |= (1 << ((N)%8)))
-#define	BITVAL(ARRAY, N)	((ARRAY)[(N)/8] & (1 << ((N)%8)))
-
 #define	power_of_2(x)	((x) && !((x) & ((x) - 1)))
 #define	DEFAULT_FILESIZE	((__uint64_t) (256 * 1024 * 1024))
 #define	DEFAULT_BLOCKSIZE	512
 
-__uint64_t filesize;
+#define	SETBIT(ARRAY, N)	((ARRAY)[(N)/8] |= (1 << ((N)%8)))
+#define	BITVAL(ARRAY, N)	((ARRAY)[(N)/8] & (1 << ((N)%8)))
+
+/* Bit-vector array showing which blocks have been written */
+static unsigned char	*valid;
 
-unsigned int blocksize;
-int count;
-int verbose;
-int wsync;
-int direct;
-int alloconly;
-int rt;
-int extsize;	/* used only for real-time */
-int preserve;
-int test;
-__uint64_t fileoffset;
+static __uint64_t filesize;
+static __uint64_t fileoffset;
 
+static unsigned int blocksize;
+static int count;
+static int verbose;
+static int wsync;
+static int direct;
+static int alloconly;
+static int rt;
+static int extsize;	/* used only for real-time */
+static int preserve;
+static int test;
 
-#define	READ_XFER	10	/* block to read at a time when checking */
+#define	READ_XFER	256	/* blocks to read at a time when checking */
 
 /*
  * Define xfscntl() to mask the difference between the Linux
@@ -62,7 +62,7 @@ __uint64_t fileoffset;
 		xfsctl((filename), (fd), XFS_IOC_ ## cmd, (arg))
 #endif	/* ! __sgi__ */
 
-void
+static void
 usage(char *progname)
 {
 	fprintf(stderr,
@@ -82,7 +82,6 @@ usage(char *progname)
 }
 
 /* Returns filename if successful or a null pointer if an error occurs */
-
 static char *
 parseargs(int argc, char *argv[])
 {
@@ -119,31 +118,35 @@ parseargs(int argc, char *argv[])
 
 	if ((filesize % blocksize) != 0) {
 		filesize -= filesize % blocksize;
-		printf("filesize not a multiple of blocksize, reducing filesize to %llu\n",
-		       (unsigned long long)filesize);
+		printf("filesize not a multiple of blocksize, "
+			"reducing filesize to %llu\n",
+		       (unsigned long long) filesize);
 	}
 	if ((fileoffset % blocksize) != 0) {
 		fileoffset -= fileoffset % blocksize;
-		printf("fileoffset not a multiple of blocksize, reducing fileoffset to %llu\n",
-		       (unsigned long long)fileoffset);
+		printf("fileoffset not a multiple of blocksize, "
+			"reducing fileoffset to %llu\n",
+		       (unsigned long long) fileoffset);
 	}
 	if (count > (filesize/blocksize)) {
 		count = (filesize/blocksize);
-		printf("count of blocks written is too large, setting to %d\n",
-			      count);
+		printf("count of blocks written is too large, "
+			"setting to %d\n", count);
 	} else if (count < 1) {
 		count = 1;
-		printf("count of blocks written is too small, setting to %d\n",
-			      count);
+		printf("count of blocks written is too small, "
+			"setting to %d\n", count);
 	}
-	printf("randholes: Seed = %d (use \"-s %d\" to re-execute this test)\n", seed, seed);
+	printf("randholes: Seed = %d (use \"-s %d\" "
+		"to re-execute this test)\n", seed, seed);
 	srandom(seed);
 
         printf("randholes: blocksize=%d, filesize=%llu, seed=%d\n"
                "randholes: count=%d, offset=%llu, extsize=%d\n",
                 blocksize, (unsigned long long)filesize, seed,
 	       count, (unsigned long long)fileoffset, extsize);
-        printf("randholes: verbose=%d, wsync=%d, direct=%d, rt=%d, alloconly=%d, preserve=%d, test=%d\n",
+        printf("randholes: verbose=%d, wsync=%d, direct=%d, "
+		"rt=%d, alloconly=%d, preserve=%d, test=%d\n",
                 verbose, wsync, direct ? 1 : 0, rt, alloconly, preserve, test);
 
 	/* Last argument is the file name.  Return it. */
@@ -151,40 +154,45 @@ parseargs(int argc, char *argv[])
 	return argv[optind];	/* Success */
 }
 
-int
+/*
+ * Determine the next random block number to which to write.
+ * If an already-written block is selected, choose the next
+ * unused higher-numbered block.  Returns the block number,
+ * or -1 if we exhaust available blocks looking for an unused
+ * one.
+ */
+static int
 findblock(void)
 {
 	int block, numblocks;
 
 	numblocks = filesize / blocksize;
 	block = random() % numblocks;
-	if (BITVAL(valid, block) == 0)
-		return(block);
 
-	for (  ; BITVAL(valid, block) != 0; block++) {
-		if (block == (numblocks-1))
-			block = -1;
-	}
-	if (block == -1)
-		printf("returning block -1\n");
-	return(block);
+	while (BITVAL(valid, block)) {
+		if (++block == numblocks) {
+			printf("returning block -1\n");
+			return -1;
+		}
+	}
+	return block;
 }
 
-void
+static void
 dumpblock(int *buffer, __uint64_t offset, int blocksize)
 {
 	int	i;
 
 	for (i = 0; i < (blocksize / 16); i++) {
 		printf("%llx: 0x%08x 0x%08x 0x%08x 0x%08x\n",
-		       (unsigned long long)offset, *buffer, *(buffer + 1), *(buffer + 2),
-		       *(buffer + 3));
+		       (unsigned long long) offset, *buffer, *(buffer + 1),
+		       *(buffer + 2), *(buffer + 3));
 		offset += 16;
 		buffer += 4;
 	}
 }
 
-void
+static void
 writeblks(char *fname, int fd, size_t alignment)
 {
 	__uint64_t offset;
@@ -255,7 +263,7 @@ writeblks(char *fname, int fd, size_t al
 	free(buffer);
 }
 
-int
+static int
 readblks(int fd, size_t alignment)
 {
 	__uint64_t offset;
@@ -335,7 +343,7 @@ readblks(int fd, size_t alignment)
  * system; otherwise pointer alignment is fine.  Returns the
  * alignment multiple, or 0 if an error occurs.
  */
-size_t
+static size_t
 get_alignment(char *filename, int fd)
 {
 	struct dioattr dioattr;
@@ -400,58 +408,67 @@ realtime_setup(char *filename, int fd)
 int
 main(int argc, char *argv[])
 {
-	int fd, oflags;
-	char *filename;
-        int r;
-	size_t alignment;
+	char	*filename;
+	size_t	size;
+	int	oflags;
+	int	fd;
+	size_t	alignment;
+	int	errors;
 
 	filename = parseargs(argc, argv);
 	if (! filename)
 		return 1;
 
 	/*
-	 * Open the file, write rand block in random places, read them all
-	 * back to check for correctness, then close the file.
+	 * Allocate a bitmap big enough to track the range of
+	 * blocks we'll be dealing with.
 	 */
-	nvalid = (filesize / blocksize) / 8 + 1;
-	if ((valid = (unsigned char *)calloc(1, (unsigned)nvalid)) == NULL) {
+	size = (filesize / blocksize) / 8 + 1;
+	valid = malloc(size);
+	if ((valid = malloc(size)) == NULL) {
 		perror("malloc");
 		return 1;
 	}
 
-        oflags=test?(O_RDONLY):(O_RDWR | O_CREAT);
-	oflags |=   (preserve ? 0 : O_TRUNC) |
-		    (wsync ? O_SYNC : 0) |
-		    (direct ? O_DIRECT : 0);
+	/* Lots of arguments affect how we open the file */
+	oflags = test ? O_RDONLY : O_RDWR|O_CREAT;
+	oflags |= preserve ? 0 : O_TRUNC;
+	oflags |= wsync ? O_SYNC : 0;
+	oflags |= direct ? O_DIRECT : 0;
 
+	/*
+	 * Open the file, write rand block in random places, read them all
+	 * back to check for correctness, then close the file.
+	 */
 	if ((fd = open(filename, oflags, 0666)) < 0) {
 		perror("open");
 		return 1;
 	}
-
 	if (rt && realtime_setup(filename, fd))
 		return 1;
-
 	alignment = get_alignment(filename, fd);
 	if (! alignment)
 	    	return 1;
 
-        printf(test?"write (skipped)\n":"write\n");
+        printf("write%s\n", test ? " (skipped)" : "");
 	writeblks(filename, fd, alignment);
+
         printf("readback\n");
-	r = readblks(fd, alignment);
+	errors = readblks(fd, alignment);
+
 	if (close(fd) < 0) {
 		perror("close");
 		return 1;
 	}
 	free(valid);
 
-        if (r) {
-            printf("randholes: %d errors found during readback\n", r);
-            return 2;
-        } else {
-            printf("randholes: ok\n");
-            return 0;
+        if (errors) {
+		printf("randholes: %d errors found during readback\n", errors);
+		return 2;
         }
+
+	printf("randholes: ok\n");
+
+	return 0;
 }
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
