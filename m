Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52998 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750775AbdI1Syc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Sep 2017 14:54:32 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 1/3] Add support for pwritev2()
Date: Thu, 28 Sep 2017 13:54:24 -0500
Message-Id: <20170928185426.9070-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 io/Makefile |  2 +-
 io/pwrite.c | 36 +++++++++++++++++++++++-------------
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/io/Makefile b/io/Makefile
index 62bc03b8..87649dc6 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -87,7 +87,7 @@ endif
 
 # Also implies PWRITEV
 ifeq ($(HAVE_PREADV),yes)
-LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV
+LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV -DHAVE_PWRITEV2
 endif
 
 ifeq ($(HAVE_READDIR),yes)
diff --git a/io/pwrite.c b/io/pwrite.c
index 67631ce5..82eaf827 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -62,7 +62,8 @@ do_pwritev(
 	int		fd,
 	off64_t		offset,
 	ssize_t		count,
-	ssize_t		buffer_size)
+	ssize_t		buffer_size,
+	int 		pwritev2_flags)
 {
 	int vecs = 0;
 	ssize_t oldlen = 0;
@@ -81,7 +82,11 @@ do_pwritev(
 	} else {
 		vecs = vectors;
 	}
+#ifdef HAVE_PWRITEV2
+	bytes = pwritev2(fd, iov, vectors, offset, pwritev2_flags);
+#else
 	bytes = pwritev(fd, iov, vectors, offset);
+#endif
 
 	/* restore trimmed iov */
 	if (oldlen)
@@ -98,12 +103,13 @@ do_pwrite(
 	int		fd,
 	off64_t		offset,
 	ssize_t		count,
-	ssize_t		buffer_size)
+	ssize_t		buffer_size,
+	int 		pwritev2_flags)
 {
 	if (!vectors)
 		return pwrite64(fd, buffer, min(count, buffer_size), offset);
 
-	return do_pwritev(fd, offset, count, buffer_size);
+	return do_pwritev(fd, offset, count, buffer_size, pwritev2_flags);
 }
 
 static int
@@ -111,7 +117,8 @@ write_random(
 	off64_t		offset,
 	long long	count,
 	unsigned int	seed,
-	long long	*total)
+	long long	*total,
+	int 		pwritev2_flags)
 {
 	off64_t		off, range;
 	ssize_t		bytes;
@@ -133,7 +140,7 @@ write_random(
 				buffersize;
 		else
 			off = offset;
-		bytes = do_pwrite(file->fd, off, buffersize, buffersize);
+		bytes = do_pwrite(file->fd, off, buffersize, buffersize, pwritev2_flags);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
@@ -153,7 +160,8 @@ static int
 write_backward(
 	off64_t		offset,
 	long long	*count,
-	long long	*total)
+	long long	*total,
+	int		pwritev2_flags)
 {
 	off64_t		end, off = offset;
 	ssize_t		bytes = 0, bytes_requested;
@@ -171,7 +179,7 @@ write_backward(
 	if ((bytes_requested = (off % buffersize))) {
 		bytes_requested = min(cnt, bytes_requested);
 		off -= bytes_requested;
-		bytes = do_pwrite(file->fd, off, bytes_requested, buffersize);
+		bytes = do_pwrite(file->fd, off, bytes_requested, buffersize, pwritev2_flags);
 		if (bytes == 0)
 			return ops;
 		if (bytes < 0) {
@@ -189,7 +197,7 @@ write_backward(
 	while (cnt > end) {
 		bytes_requested = min(cnt, buffersize);
 		off -= bytes_requested;
-		bytes = do_pwrite(file->fd, off, cnt, buffersize);
+		bytes = do_pwrite(file->fd, off, cnt, buffersize, pwritev2_flags);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
@@ -212,7 +220,8 @@ write_buffer(
 	size_t		bs,
 	int		fd,
 	off64_t		skip,
-	long long	*total)
+	long long	*total,
+	int		pwritev2_flags)
 {
 	ssize_t		bytes;
 	long long	bar = min(bs, count);
@@ -224,7 +233,7 @@ write_buffer(
 			if (read_buffer(fd, skip + *total, bs, &bar, 0, 1) < 0)
 				break;
 		}
-		bytes = do_pwrite(file->fd, offset, count, bar);
+		bytes = do_pwrite(file->fd, offset, count, bar, pwritev2_flags);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
@@ -258,6 +267,7 @@ pwrite_f(
 	int		Cflag, qflag, uflag, dflag, wflag, Wflag;
 	int		direction = IO_FORWARD;
 	int		c, fd = -1;
+	int		pwritev2_flags = 0;
 
 	Cflag = qflag = uflag = dflag = wflag = Wflag = 0;
 	init_cvtnum(&fsblocksize, &fssectsize);
@@ -365,13 +375,13 @@ pwrite_f(
 	case IO_RANDOM:
 		if (!zeed)	/* srandom seed */
 			zeed = time(NULL);
-		c = write_random(offset, count, zeed, &total);
+		c = write_random(offset, count, zeed, &total, pwritev2_flags);
 		break;
 	case IO_FORWARD:
-		c = write_buffer(offset, count, bsize, fd, skip, &total);
+		c = write_buffer(offset, count, bsize, fd, skip, &total, pwritev2_flags);
 		break;
 	case IO_BACKWARD:
-		c = write_backward(offset, &count, &total);
+		c = write_backward(offset, &count, &total, pwritev2_flags);
 		break;
 	default:
 		total = 0;
-- 
2.14.1

