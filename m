Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49093 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932650AbdKPBWm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Nov 2017 20:22:42 -0500
Subject: [PATCH 3/5] aio-dio-append-write-read-race: abort if we encounter
 syscall errors
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 15 Nov 2017 17:22:37 -0800
Message-ID: <151079535786.25590.5675435278026701306.stgit@magnolia>
In-Reply-To: <151079533937.25590.1037061486182471724.stgit@magnolia>
References: <151079533937.25590.1037061486182471724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If any of the library calls return error codes, just print out a message
and abort the test.  Whoever wrote the write test did not check for
write failures, which means that if we ENOSPC without writing anything
then the reader thread will loop forever trying to read.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .../aio-dio-append-write-read-race.c               |   41 +++++++++++---------
 1 file changed, 23 insertions(+), 18 deletions(-)


diff --git a/src/aio-dio-regress/aio-dio-append-write-read-race.c b/src/aio-dio-regress/aio-dio-append-write-read-race.c
index 1a78009..b3fbe61 100644
--- a/src/aio-dio-regress/aio-dio-append-write-read-race.c
+++ b/src/aio-dio-regress/aio-dio-append-write-read-race.c
@@ -70,6 +70,11 @@ static void *reader(void *arg)
 	return NULL;
 }
 
+#define fail(fmt , args...) do {	\
+	fprintf(stderr, fmt , ##args);	\
+	exit(1);			\
+} while (0)
+
 static void *writer(struct io_data *data)
 {
 	int ret;
@@ -84,28 +89,28 @@ static void *writer(struct io_data *data)
 		struct iocb *iocbs[] = { &iocb };
 
 		ret = io_setup(1, &ctx);
-		if (ret) {
-			fprintf(stderr, "error %s during io_setup\n",
+		if (ret)
+			fail("error %s during io_setup\n",
 				strerror(ret));
-			return NULL;
-		}
 		io_prep_pwrite(&iocb, data->fd, data->buf, data->blksize, data->offset);
 		ret = io_submit(ctx, 1, iocbs);
-		if (ret != 1) {
-			fprintf(stderr, "error %s during io_submit\n",
+		if (ret != 1)
+			fail("error %s during io_submit\n",
 				strerror(ret));
-			return NULL;
-		}
 		ret = io_getevents(ctx, 1, 1, evs, NULL);
-		if (ret != 1) {
-			fprintf(stderr, "error %s during io_getevents\n",
+		if (ret != 1)
+			fail("error %s during io_getevents\n",
 				strerror(ret));
-			return NULL;
-		}
+		if ((signed)evs[0].res < 0)
+			fail("error %s during write\n",
+				strerror(-evs[0].res));
+		if ((signed)evs[0].res2 < 0)
+			fail("secondary error %s during write\n",
+				strerror(-evs[0].res2));
 	} else {
 		ret = pwrite(data->fd, data->buf, data->blksize, data->offset);
 		if (ret < 0)
-			perror("write file failed");
+			fail("write file failed: %s", strerror(errno));
 	}
 
 	return NULL;
@@ -161,14 +166,14 @@ int main(int argc, char *argv[])
 
 	ret = posix_memalign((void **)&wbuf, io_align, blksize);
 	if (ret) {
-		fprintf(stderr, "failed to alloc memory: %s\n", strerror(ret));
+		fail("failed to alloc memory: %s\n", strerror(ret));
 		ret = 1;
 		goto err;
 	}
 
 	ret = posix_memalign((void **)&rbuf, io_align, blksize);
 	if (ret) {
-		fprintf(stderr, "failed to alloc memory: %s\n", strerror(ret));
+		fail("failed to alloc memory: %s\n", strerror(ret));
 		ret = 1;
 		goto err;
 	}
@@ -189,7 +194,7 @@ int main(int argc, char *argv[])
 		reader_ready = 0;
 		ret = pthread_create(&tid, NULL, reader, &rdata);
 		if (ret) {
-			fprintf(stderr, "create reader thread failed: %s\n",
+			fail("create reader thread failed: %s\n",
 				strerror(ret));
 			ret = 1;
 			goto err;
@@ -199,7 +204,7 @@ int main(int argc, char *argv[])
 
 		ret = pthread_join(tid, NULL);
 		if (ret) {
-			fprintf(stderr, "pthread join reader failed: %s\n",
+			fail("pthread join reader failed: %s\n",
 				strerror(ret));
 			ret = 1;
 			goto err;
@@ -207,7 +212,7 @@ int main(int argc, char *argv[])
 
 		for (j = 0; j < blksize; j++) {
 			if (rdata.buf[j] != 'a') {
-				fprintf(stderr, "encounter an error: "
+				fail("encounter an error: "
 					"block %d offset %d, content %x\n",
 					i, j, rbuf[j]);
 				ret = 1;

