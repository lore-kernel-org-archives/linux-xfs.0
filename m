Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9EEmwKr024141 for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 09:48:58 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7FD278F808F
	for <xfs@oss.sgi.com>; Thu, 14 Oct 2010 07:50:08 -0700 (PDT)
Subject: [PATCH 02/11] xfstests: randholes: only allocate write buffer when
	needed
From: Alex Elder <aelder@sgi.com>
Date: Thu, 14 Oct 2010 09:49:52 -0500
Message-ID: <1287067792.2362.214.camel@doink>
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

If nothing is being written (i.e., in "test" mode), there's no need
for "randholes" to allocate a write buffer.  But to do this we make
this series of changes:
- When "very" verbose (> 1), there's no point in printing the values
  that have just been written to the file.  They are just the file
  offset, and the buffer will not have changed between initializing
  those values and writing it out.
- If we don't print the values at those offsets, then there's no
  need to fill them in at all when we're in test mode.
- Now we only use the write buffer if we're not in test mode,
  so we can skip the allocation.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 src/randholes.c |   45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

Index: b/src/randholes.c
===================================================================
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -233,17 +233,21 @@ writeblks(char *fname, int fd)
 	int block;
 	struct flock64 fl;
 
-	if (direct)
-		buffer = memalign(diob.d_mem, blocksize);
-	else
-		buffer = malloc(blocksize);
-	if (buffer == NULL) {
-		perror("malloc");
-		exit(1);
+	if (test)
+		buffer = NULL;
+	else {
+		if (direct)
+			buffer = memalign(diob.d_mem, blocksize);
+		else
+			buffer = malloc(blocksize);
+		if (buffer == NULL) {
+			perror("malloc");
+			exit(1);
+		}
+		memset(buffer, 0, blocksize);
 	}
-	memset(buffer, 0, blocksize);
 
-	for (  ; count > 0; count--) {
+	do {
 		if (verbose && ((count % 100) == 0)) {
 			printf(".");
 			fflush(stdout);
@@ -285,23 +289,26 @@ bozo!
 			        perror("lseek");
 			        exit(1);
 		        }
-                }
-		*(__uint64_t *)buffer = *(__uint64_t *)(buffer+256) =
-			fileoffset + offset;
-                if (!test) {
+			/*
+			 * Before writing, record offset at the base
+			 * of the buffer and at offset 256 bytes
+			 * into it.  We'll verify this when we read
+			 * it back in again.
+			 */
+			*(__uint64_t *) buffer = fileoffset + offset;
+			*(__uint64_t *) (buffer + 256) = fileoffset + offset;
+
 		        if (write(fd, buffer, blocksize) < blocksize) {
 			        perror("write");
 			        exit(1);
 		        }
                 }
-                if (test && verbose>1) printf("NOT ");
 		if (verbose > 1) {
-			printf("writing data at offset=%llx, value 0x%llx and 0x%llx\n",
-			       (unsigned long long)(fileoffset + offset),
-			       *(unsigned long long *)buffer,
-			       *(unsigned long long *)(buffer+256));
+			printf("%swriting data at offset=%llx\n",
+				test ? "NOT " : "",
+				(unsigned long long) (fileoffset + offset));
 		}
-	}
+	} while (--count);
 
 	free(buffer);
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
