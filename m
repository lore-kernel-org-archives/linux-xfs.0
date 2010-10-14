Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EEqj9B024501 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 09:52:45 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DF91530408B
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 07:53:54 -0700 (PDT)
Subject: [PATCH 09/11] xfstests: randholes: clean up readblks()
From: Alex Elder <aelder@sgi.com>
Date: Thu, 14 Oct 2010 09:50:51 -0500
Message-ID: <1287067851.2362.224.camel@doink>
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

Make readblks() a bit more readable by computing a few things
into local variables, and pulling out a few of the comma-separated
expressions that were previously in the for loop headers.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 src/randholes.c |   55 +++++++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

Index: b/src/randholes.c
===================================================================
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -188,7 +188,7 @@ writeblks(char *fname, int fd, size_t al
 int
 readblks(int fd, size_t alignment)
 {
-	unsigned long offset;
+	__uint64_t offset;
 	char *buffer, *tmp;
 	unsigned int xfer, block, i;
         int err=0;
@@ -208,49 +208,48 @@ readblks(int fd, size_t alignment)
 		perror("lseek");
 		exit(1);
 	}
-	for (offset = 0, block = 0; offset < filesize; offset += xfer) {
+	block = 0;
+	offset = 0;
+	while (offset < filesize) {
 		if ((i = read(fd, buffer, xfer) < xfer)) {
 			if (i < 2)
 				break;
 			perror("read");
 			exit(1);
 		}
-		for (tmp = buffer, i = 0; i < READ_XFER; i++, block++, tmp += blocksize) {
+		tmp = buffer;
+		for (i = 0; i < READ_XFER; i++) {
+			__uint64_t want;
+			__uint64_t first;
+			__uint64_t second;
+
 			if (verbose && ((block % 100) == 0)) {
 				printf("+");
 				fflush(stdout);
 			}
-			if (BITVAL(valid, block) == 0) {
-				if ((*(__uint64_t *)tmp != 0LL) ||
-				    (*(__uint64_t *)(tmp+256) != 0LL)) {
-					printf("mismatched data at offset=%llx, expected 0x%llx, got 0x%llx and 0x%llx\n",
-					       (unsigned long long)fileoffset + block * blocksize,
-					       0LL,
-					       *(unsigned long long *)tmp,
-					       *(unsigned long long *)(tmp+256));
-                                        err++;
-				}
-			} else {
-				if ( (*(__uint64_t *)tmp !=
-				      fileoffset + block * blocksize) ||
-				     (*(__uint64_t *)(tmp+256) !=
-				      fileoffset + block * blocksize) ) {
-					printf("mismatched data at offset=%llx, "
-					       "expected 0x%llx, got 0x%llx and 0x%llx\n",
-					       (unsigned long long)fileoffset + block * blocksize,
-					       (unsigned long long)fileoffset + block * blocksize,
-					       *(unsigned long long *)tmp,
-					       *(unsigned long long *)(tmp+256));
-                                        err++;
-				}
+
+			want = BITVAL(valid, block) ? offset : 0;
+			first = *(__uint64_t *) tmp;
+			second = *(__uint64_t *) (tmp + 256);
+			if (first != want || second != want) {
+				printf("mismatched data at offset=0x%" PRIx64
+					", expected 0x%" PRIx64
+					", got 0x%" PRIx64
+					" and 0x%" PRIx64 "\n",
+					 fileoffset + offset, want,
+					 first, second);
+				err++;
 			}
 			if (verbose > 2) {
 				printf("block %d blocksize %d\n", block,
 				       blocksize);
-				dumpblock((int *)tmp,
-					  fileoffset + block * blocksize,
+				dumpblock((int *)tmp, fileoffset + offset,
 					  blocksize);
 			}
+
+			block++;
+			offset += blocksize;
+			tmp += blocksize;
 		}
 	}
 	if (verbose)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
