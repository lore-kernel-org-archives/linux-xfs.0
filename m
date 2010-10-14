Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EEqiFL024499 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 09:52:45 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D0679304089
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 07:53:54 -0700 (PDT)
Subject: [PATCH 07/11] xfstests: randholes: use posix_memalign()
From: Alex Elder <aelder@sgi.com>
Date: Thu, 14 Oct 2010 09:50:36 -0500
Message-ID: <1287067836.2362.219.camel@doink>
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

Use posix_memalign() rather than memalign() regardless of whether
direct I/O is to be used.  Don't store the dioattr data in a global
variable.  

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 src/randholes.c |   71 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 24 deletions(-)

Index: b/src/randholes.c
===================================================================
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -25,6 +25,7 @@ int		nvalid;	/* number of bytes in valid
 #define	SETBIT(ARRAY, N)	((ARRAY)[(N)/8] |= (1 << ((N)%8)))
 #define	BITVAL(ARRAY, N)	((ARRAY)[(N)/8] & (1 << ((N)%8)))
 
+#define	power_of_2(x)	((x) && !((x) & ((x) - 1)))
 #define	DEFAULT_FILESIZE	((__uint64_t) (256 * 1024 * 1024))
 #define	DEFAULT_BLOCKSIZE	512
 
@@ -41,7 +42,7 @@ int extsize;	/* used only for real-time
 int preserve;
 int test;
 __uint64_t fileoffset;
-struct dioattr diob;
+
 struct fsxattr rtattr;
 
 #define	READ_XFER	10	/* block to read at a time when checking */
@@ -115,7 +116,7 @@ dumpblock(int *buffer, __uint64_t offset
 }
 
 void
-writeblks(char *fname, int fd)
+writeblks(char *fname, int fd, size_t alignment)
 {
 	__uint64_t offset;
 	char *buffer;
@@ -125,11 +126,7 @@ writeblks(char *fname, int fd)
 	if (test)
 		buffer = NULL;
 	else {
-		if (direct)
-			buffer = memalign(diob.d_mem, blocksize);
-		else
-			buffer = malloc(blocksize);
-		if (buffer == NULL) {
+		if (posix_memalign((void **) &buffer, alignment, blocksize)) {
 			perror("malloc");
 			exit(1);
 		}
@@ -192,7 +189,7 @@ writeblks(char *fname, int fd)
 }
 
 int
-readblks(int fd)
+readblks(int fd, size_t alignment)
 {
 	unsigned long offset;
 	char *buffer, *tmp;
@@ -202,11 +199,7 @@ readblks(int fd)
 	if (alloconly)
 		return 0;
 	xfer = READ_XFER*blocksize;
-	if (direct)
-		buffer = memalign(diob.d_mem, xfer);
-	else
-		buffer = malloc(xfer);
-	if (buffer == NULL) {
+	if (posix_memalign((void **) &buffer, alignment, xfer)) {
 		perror("malloc");
 		exit(1);
 	}
@@ -270,20 +263,48 @@ readblks(int fd)
         return err;
 }
 
-int
-direct_setup(char *filename, int fd)
+/*
+ * Determine the memory alignment required for I/O buffers.  For
+ * direct I/O we request the needed information from the file
+ * system; otherwise pointer alignment is fine.  Returns the
+ * alignment multiple, or 0 if an error occurs.
+ */
+size_t
+get_alignment(char *filename, int fd)
 {
-	if (xfscntl(filename, fd, DIOINFO, &diob) < 0) {
+	struct dioattr dioattr;
+
+	if (! direct)
+	    	return sizeof (void *);
+
+	memset(&dioattr, 0, sizeof dioattr);
+	if (xfscntl(filename, fd, DIOINFO, &dioattr) < 0) {
 		perror("xfscntl(FIOINFO)");
-		return 1;
+		return 0;
+	}
+
+	/* Make sure the alignment meets the needs of posix_memalign() */
+
+	if (dioattr.d_mem % sizeof (void *) || ! power_of_2(dioattr.d_mem)) {
+		perror("d_mem bad");
+		return 0;
+	}
+
+	/*
+	 * Also make sure user doesn't specify a block size that's
+	 * incompatible with the underlying file system.
+	 */
+	if (! dioattr.d_miniosz) {
+		perror("miniosz == 0!");
+		return 0;
 	}
-	if (blocksize % diob.d_miniosz) {
+	if (blocksize % dioattr.d_miniosz) {
 		fprintf(stderr, "blocksize %d must be a multiple of "
-			"%d for direct I/O\n", blocksize, diob.d_miniosz);
-		return 1;
+			"%d for direct I/O\n", blocksize, dioattr.d_miniosz);
+		return 0;
 	}
 
-	return 0;
+	return (size_t) dioattr.d_mem;
 }
 
 int
@@ -292,6 +313,7 @@ main(int argc, char *argv[])
 	int seed, ch, fd, oflags;
 	char *filename = NULL;
         int r;
+	size_t alignment;
 
 	filesize = DEFAULT_FILESIZE;
 	blocksize = DEFAULT_BLOCKSIZE;
@@ -390,13 +412,14 @@ main(int argc, char *argv[])
 		}
 	}
 
-	if (direct && direct_setup(filename, fd))
+	alignment = get_alignment(filename, fd);
+	if (! alignment)
 	    	return 1;
 
         printf(test?"write (skipped)\n":"write\n");
-	writeblks(filename, fd);
+	writeblks(filename, fd, alignment);
         printf("readback\n");
-	r=readblks(fd);
+	r = readblks(fd, alignment);
 	if (close(fd) < 0) {
 		perror("close");
 		return 1;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
