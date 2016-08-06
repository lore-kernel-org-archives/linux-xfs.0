Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C45047CDC
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 02:35:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D6BC8F8035
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 00:35:50 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id UzXzfK1KjuTLBJ5W (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 07 Aug 2016 00:35:48 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 224D520A78
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:47 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s6XQV4hsFz1043
	for <xfs@oss.sgi.com>; Sun,  7 Aug 2016 09:35:46 +0200 (CEST)
Message-Id: <54046df0c8591a0c5678dee87a8c8aba02ea1d88.1470555003.git.felix.janda@posteo.de>
In-Reply-To: <cover.1470555003.git.felix.janda@posteo.de>
References: <cover.1470555003.git.felix.janda@posteo.de>
From: Felix Janda <felix.janda@posteo.de>
Date: Sat, 6 Aug 2016 12:45:52 +0200
Subject: [PATCH xfsprogs 08/14] replace pread64 by equivalent pread
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/darwin.h  |  1 -
 include/freebsd.h |  1 -
 io/pread.c        | 10 +++++-----
 libxfs/rdwr.c     |  2 +-
 repair/prefetch.c |  2 +-
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/darwin.h b/include/darwin.h
index 850d733..f4dbd9f 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -141,7 +141,6 @@ typedef u_int64_t	xfs_ino_t;
 typedef u_int32_t	xfs_dev_t;
 typedef int64_t		xfs_daddr_t;
 
-#define pread64		pread
 #define pwrite64	pwrite
 #define fdatasync	fsync
 #define memalign(a,sz)	valloc(sz)
diff --git a/include/freebsd.h b/include/freebsd.h
index 784e287..041dafe 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -35,7 +35,6 @@
 
 /* FreeBSD file API is 64-bit aware */
 #define pwrite64	pwrite
-#define pread64		pread
 #define fdatasync	fsync
 #define memalign(a,sz)	valloc(sz)
 
diff --git a/io/pread.c b/io/pread.c
index cafead0..3395503 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -214,7 +214,7 @@ do_pread(
 	ssize_t		buffer_size)
 {
 	if (!vectors)
-		return pread64(fd, buffer, min(count, buffer_size), offset);
+		return pread(fd, buffer, min(count, buffer_size), offset);
 
 	return do_preadv(fd, offset, count, buffer_size);
 }
@@ -254,7 +254,7 @@ read_random(
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
-			perror("pread64");
+			perror("pread");
 			return -1;
 		}
 		ops++;
@@ -296,7 +296,7 @@ read_backward(
 		if (bytes == 0)
 			return ops;
 		if (bytes < 0) {
-			perror("pread64");
+			perror("pread");
 			return -1;
 		}
 		ops++;
@@ -314,7 +314,7 @@ read_backward(
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
-			perror("pread64");
+			perror("pread");
 			return -1;
 		}
 		ops++;
@@ -345,7 +345,7 @@ read_forward(
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
-			perror("pread64");
+			perror("pread");
 			return -1;
 		}
 		ops++;
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index cb74b3c..36c39d9 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -915,7 +915,7 @@ __read_buf(int fd, void *buf, int len, off64_t offset, int flags)
 {
 	int	sts;
 
-	sts = pread64(fd, buf, len, offset);
+	sts = pread(fd, buf, len, offset);
 	if (sts < 0) {
 		int error = errno;
 		fprintf(stderr, _("%s: read failed: %s\n"),
diff --git a/repair/prefetch.c b/repair/prefetch.c
index b4f20d9..175594c 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -565,7 +565,7 @@ pf_batch_read(
 		/*
 		 * now read the data and put into the xfs_but_t's
 		 */
-		len = pread64(mp_fd, buf, (int)(last_off - first_off), first_off);
+		len = pread(mp_fd, buf, (int)(last_off - first_off), first_off);
 
 		/*
 		 * Check the last buffer on the list to see if we need to
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
