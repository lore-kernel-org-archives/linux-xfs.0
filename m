Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67CC27FA7
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 11:00:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5545E304059
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 09:00:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 4FNIXThskQ9dphXr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 09:00:46 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VeSwn-0002jl-1C
	for xfs@oss.sgi.com; Thu, 07 Nov 2013 17:00:45 +0000
Date: Thu, 7 Nov 2013 09:00:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: posix_memalign and io_submit do not set errno
Message-ID: <20131107170045.GA6599@infradead.org>
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

posix_memalign and io_submit do not set errno, but rather return the
error respectively the negated error directly.

Found this out while figuring out why 240 reported an impossible error
from io_submit when run on NFS.


Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/src/aio-dio-regress/aiodio_sparse2.c b/src/aio-dio-regress/aiodio_sparse2.c
index 79aa924..51ede5b 100644
--- a/src/aio-dio-regress/aiodio_sparse2.c
+++ b/src/aio-dio-regress/aiodio_sparse2.c
@@ -117,8 +117,10 @@ void aiodio_sparse(char *filename, int align, int writesize, int startoffset, in
 	for (i = 0; i < num_aio; i++) {
 		void *bufptr;
 
-		if (posix_memalign(&bufptr, align, writesize)) {
-			perror("cannot malloc aligned memory");
+		w = posix_memalign(&bufptr, align, writesize);
+		if (w) {
+			fprintf(stderr, "cannot malloc aligned memory: %s\n",
+				strerror(w));
 			close(fd);
 			unlink(filename);
 			return;
@@ -131,8 +133,10 @@ void aiodio_sparse(char *filename, int align, int writesize, int startoffset, in
 	/*
 	 * start the 1st num_aio write requests
 	 */
-	if ((w = io_submit(myctx, num_aio, iocbs)) < 0) {
-		perror("io_submit failed");
+	w = io_submit(myctx, num_aio, iocbs);
+	if (w < 0) {
+		fprintf(stderr, "io_submit failed: %s\n",
+			strerror(-w));
 		close(fd);
 		unlink(filename);
 		return;
@@ -182,10 +186,11 @@ void aiodio_sparse(char *filename, int align, int writesize, int startoffset, in
 		/* start next write */
 		io_prep_pwrite(iocbp, fd, iocbp->u.c.buf, writesize, offset);
 		offset += step;
-		if ((w = io_submit(myctx, 1, &iocbp)) < 0) {
-			fprintf(stderr, "io_submit failed at offset %lld\n",
-				(long long)offset);
-			perror("");
+		w = io_submit(myctx, 1, &iocbp);
+		if (w < 0) {
+			fprintf(stderr, "io_submit failed at offset %lld: %s\n",
+				(long long)offset,
+				strerror(-w));
 			break;
 		}
 		if (debug)
@@ -200,8 +205,10 @@ void aiodio_sparse(char *filename, int align, int writesize, int startoffset, in
 		int n;
 		struct iocb *iocbp;
 
-		if ((n = io_getevents(myctx, 1, 1, &event, 0)) != 1) {
-			perror("io_getevents failed");
+		n = io_getevents(myctx, 1, 1, &event, 0);
+		if (n != 1) {
+			fprintf(stderr, "io_getevents failed: %s\n",
+				 strerror(-n));
 			break;
 		}
 		aio_inflight--;
diff --git a/src/fsync-tester.c b/src/fsync-tester.c
index 1c03ed0..657e00f 100644
--- a/src/fsync-tester.c
+++ b/src/fsync-tester.c
@@ -437,15 +437,16 @@ int main(int argc, char **argv)
 	if (direct_io) {
 		flags |= O_DIRECT;
 		ret = posix_memalign((void **)&buf, getpagesize(), 4096);
-		if (ret)
-			buf = NULL;
+		if (ret) {
+			fprintf(stderr, "Error allocating buf: %d\n", ret);
+			return 1;
+		}
 	} else {
 		buf = malloc(4096);
-	}
-
-	if (!buf) {
-		fprintf(stderr, "Error allocating buf: %d\n", errno);
-		return 1;
+		if (!buf) {
+			fprintf(stderr, "Error allocating buf: %d\n", errno);
+			return 1;
+		}
 	}
 
 	test_fd = open(fname, flags, 0644);
diff --git a/src/randholes.c b/src/randholes.c
index 545ee8e..5ad602e 100644
--- a/src/randholes.c
+++ b/src/randholes.c
@@ -193,11 +193,13 @@ writeblks(char *fname, int fd, size_t alignment)
 	__uint64_t offset;
 	char *buffer = NULL;
 	int block;
+	int ret;
 	struct flock64 fl;
 
 	if (!test) {
-		if (posix_memalign((void **) &buffer, alignment, blocksize)) {
-			perror("malloc");
+		ret = posix_memalign((void **) &buffer, alignment, blocksize);
+		if (ret) {
+			fprintf(stderr, "posix_memalign: %s\n", strerror(ret));
 			exit(1);
 		}
 		memset(buffer, 0, blocksize);
@@ -279,8 +281,9 @@ readblks(int fd, size_t alignment)
 	if (alloconly)
 		return 0;
 	xfer = READ_XFER*blocksize;
-	if (posix_memalign((void **) &buffer, alignment, xfer)) {
-		perror("malloc");
+	err = posix_memalign((void **) &buffer, alignment, xfer);
+	if (err) {
+		fprintf(stderr, "posix_memalign: %s\n", strerror(err));
 		exit(1);
 	}
 	memset(buffer, 0, xfer);
diff --git a/src/trunc.c b/src/trunc.c
index 38fb21f..c609852 100644
--- a/src/trunc.c
+++ b/src/trunc.c
@@ -69,10 +69,12 @@ while((c=getopt(argc,argv,"f:"))!=EOF) {
 	}
 
 	err = posix_memalign((void **)&buf, ALIGNMENT, BUFSIZE);
-	if (err < 0) perror("posix_memalign failed");
+	if (err)
+		fprintf(stderr, "posix_memalign failed: %s\n", strerror(err));
 
 	err = posix_memalign((void **)&goodbuf, ALIGNMENT, BUFSIZE);
-	if (err < 0) perror("posix_memalign failed");
+	if (err)
+		fprintf(stderr, "posix_memalign failed: %s\n", strerror(err));
 
 	err = unlink(filename);
 /*	if (err < 0) perror("unlink failed");*/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
