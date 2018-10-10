Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56218 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727460AbeJKDZV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:21 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 13/18] xfs_io: rename global buffer variable
Date: Wed, 10 Oct 2018 15:01:17 -0500
Message-Id: <1539201682-22198-14-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

"buffer" is a pretty poor name for a global variable, and leads to
shadow variable warnings from sparse when other functions (reasonably)
think it's a nice local variable name.

Rename it to io_buffer for less namespace pollution, and rename
buffersize to io_buffersize to go with it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 io/io.h     |  4 ++--
 io/mmap.c   |  6 +++---
 io/pread.c  | 56 ++++++++++++++++++++++++++++----------------------------
 io/pwrite.c | 28 ++++++++++++++--------------
 4 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/io/io.h b/io/io.h
index 9278ad0..bc1e806 100644
--- a/io/io.h
+++ b/io/io.h
@@ -79,8 +79,8 @@ extern void		printxattr(uint, int, int, const char *, int, int);
 extern unsigned int	recurse_all;
 extern unsigned int	recurse_dir;
 
-extern void		*buffer;
-extern size_t		buffersize;
+extern void		*io_buffer;
+extern size_t		io_buffersize;
 extern int		vectors;
 extern struct iovec	*iov;
 extern int		alloc_buffer(size_t, int, unsigned int);
diff --git a/io/mmap.c b/io/mmap.c
index 44749bb..f9383e5 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -436,7 +436,7 @@ mread_f(
 
 	if (alloc_buffer(pagesize, 0, 0) < 0)
 		return 0;
-	bp = (char *)buffer;
+	bp = (char *)io_buffer;
 
 	dumplen = length % pagesize;
 	if (!dumplen)
@@ -451,7 +451,7 @@ mread_f(
 					dump_buffer(printoffset, dumplen);
 					printoffset += dumplen;
 				}
-				bp = (char *)buffer;
+				bp = (char *)io_buffer;
 				dumplen = pagesize;
 				cnt = 0;
 			} else {
@@ -466,7 +466,7 @@ mread_f(
 				if (dump)
 					dump_buffer(printoffset + tmp -
 						(dumplen - 1), dumplen);
-				bp = (char *)buffer;
+				bp = (char *)io_buffer;
 				dumplen = pagesize;
 				cnt = 0;
 			} else {
diff --git a/io/pread.c b/io/pread.c
index e573377..1b4352b 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -47,9 +47,9 @@ pread_help(void)
 "\n"));
 }
 
-void	*buffer;
+void	*io_buffer;
 size_t	highwater;
-size_t	buffersize;
+size_t	io_buffersize;
 int	vectors;
 struct iovec *iov;
 
@@ -65,7 +65,7 @@ alloc_iovec(
 	if (!iov)
 		return -1;
 
-	buffersize = 0;
+	io_buffersize = 0;
 	for (i = 0; i < vectors; i++) {
 		iov[i].iov_base = memalign(pagesize, bsize);
 		if (!iov[i].iov_base) {
@@ -76,7 +76,7 @@ alloc_iovec(
 		if (!uflag)
 			memset(iov[i].iov_base, seed, bsize);
 	}
-	buffersize = bsize * vectors;
+	io_buffersize = bsize * vectors;
 	return 0;
 unwind:
 	for( ; i >= 0; i--)
@@ -96,19 +96,19 @@ alloc_buffer(
 		return alloc_iovec(bsize, uflag, seed);
 
 	if (bsize > highwater) {
-		if (buffer)
-			free(buffer);
-		buffer = memalign(pagesize, bsize);
-		if (!buffer) {
+		if (io_buffer)
+			free(io_buffer);
+		io_buffer = memalign(pagesize, bsize);
+		if (!io_buffer) {
 			perror("memalign");
-			highwater = buffersize = 0;
+			highwater = io_buffersize = 0;
 			return -1;
 		}
 		highwater = bsize;
 	}
-	buffersize = bsize;
+	io_buffersize = bsize;
 	if (!uflag)
-		memset(buffer, seed, buffersize);
+		memset(io_buffer, seed, io_buffersize);
 	return 0;
 }
 
@@ -146,7 +146,7 @@ dump_buffer(
 	int		i, l;
 
 	if (!vectors) {
-		__dump_buffer(buffer, offset, len);
+		__dump_buffer(io_buffer, offset, len);
 		return;
 	}
 
@@ -171,7 +171,7 @@ do_preadv(
 	ssize_t		bytes = 0;
 
 	/* trim the iovec if necessary */
-	if (count < buffersize) {
+	if (count < io_buffersize) {
 		size_t	len = 0;
 		while (len + iov[vecs].iov_len < count) {
 			len += iov[vecs].iov_len;
@@ -203,7 +203,7 @@ do_pread(
 	size_t		buffer_size)
 {
 	if (!vectors)
-		return pread(fd, buffer, min(count, buffer_size), offset);
+		return pread(fd, io_buffer, min(count, buffer_size), offset);
 
 	return do_preadv(fd, offset, count);
 }
@@ -224,22 +224,22 @@ read_random(
 	srandom(seed);
 	end = lseek(fd, 0, SEEK_END);
 	offset = (eof || offset > end) ? end : offset;
-	if ((bytes = (offset % buffersize)))
+	if ((bytes = (offset % io_buffersize)))
 		offset -= bytes;
 	offset = max(0, offset);
-	if ((bytes = (count % buffersize)))
+	if ((bytes = (count % io_buffersize)))
 		count += bytes;
-	count = max(buffersize, count);
-	range = count - buffersize;
+	count = max(io_buffersize, count);
+	range = count - io_buffersize;
 
 	*total = 0;
 	while (count > 0) {
 		if (range)
-			off = ((offset + (random() % range)) / buffersize) *
-				buffersize;
+			off = ((offset + (random() % range)) / io_buffersize) *
+				io_buffersize;
 		else
 			off = offset;
-		bytes = do_pread(fd, off, buffersize, buffersize);
+		bytes = do_pread(fd, off, io_buffersize, io_buffersize);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
@@ -248,7 +248,7 @@ read_random(
 		}
 		ops++;
 		*total += bytes;
-		if (bytes < buffersize)
+		if (bytes < io_buffersize)
 			break;
 		count -= bytes;
 	}
@@ -279,9 +279,9 @@ read_backward(
 	*offset = off;
 
 	/* Do initial unaligned read if needed */
-	if ((bytes_requested = (off % buffersize))) {
+	if ((bytes_requested = (off % io_buffersize))) {
 		off -= bytes_requested;
-		bytes = do_pread(fd, off, bytes_requested, buffersize);
+		bytes = do_pread(fd, off, bytes_requested, io_buffersize);
 		if (bytes == 0)
 			return ops;
 		if (bytes < 0) {
@@ -297,9 +297,9 @@ read_backward(
 
 	/* Iterate backward through the rest of the range */
 	while (cnt > end) {
-		bytes_requested = min(cnt, buffersize);
+		bytes_requested = min(cnt, io_buffersize);
 		off -= bytes_requested;
-		bytes = do_pread(fd, off, cnt, buffersize);
+		bytes = do_pread(fd, off, cnt, io_buffersize);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
@@ -330,7 +330,7 @@ read_forward(
 
 	*total = 0;
 	while (count > 0 || eof) {
-		bytes = do_pread(fd, offset, count, buffersize);
+		bytes = do_pread(fd, offset, count, io_buffersize);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
@@ -341,7 +341,7 @@ read_forward(
 		if (verbose)
 			dump_buffer(offset, bytes);
 		*total += bytes;
-		if (onlyone || bytes < min(count, buffersize))
+		if (onlyone || bytes < min(count, io_buffersize))
 			break;
 		offset += bytes;
 		count -= bytes;
diff --git a/io/pwrite.c b/io/pwrite.c
index 34235ca..ccf14be 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -62,7 +62,7 @@ do_pwritev(
 	ssize_t bytes = 0;
 
 	/* trim the iovec if necessary */
-	if (count < buffersize) {
+	if (count < io_buffersize) {
 		size_t	len = 0;
 		while (len + iov[vecs].iov_len < count) {
 			len += iov[vecs].iov_len;
@@ -102,7 +102,7 @@ do_pwrite(
 	int		pwritev2_flags)
 {
 	if (!vectors)
-		return pwrite(fd, buffer, min(count, buffer_size), offset);
+		return pwrite(fd, io_buffer, min(count, buffer_size), offset);
 
 	return do_pwritev(fd, offset, count, pwritev2_flags);
 }
@@ -120,22 +120,22 @@ write_random(
 	int		ops = 0;
 
 	srandom(seed);
-	if ((bytes = (offset % buffersize)))
+	if ((bytes = (offset % io_buffersize)))
 		offset -= bytes;
 	offset = max(0, offset);
-	if ((bytes = (count % buffersize)))
+	if ((bytes = (count % io_buffersize)))
 		count += bytes;
-	count = max(buffersize, count);
-	range = count - buffersize;
+	count = max(io_buffersize, count);
+	range = count - io_buffersize;
 
 	*total = 0;
 	while (count > 0) {
 		if (range)
-			off = ((offset + (random() % range)) / buffersize) *
-				buffersize;
+			off = ((offset + (random() % range)) / io_buffersize) *
+				io_buffersize;
 		else
 			off = offset;
-		bytes = do_pwrite(file->fd, off, buffersize, buffersize,
+		bytes = do_pwrite(file->fd, off, io_buffersize, io_buffersize,
 				pwritev2_flags);
 		if (bytes == 0)
 			break;
@@ -145,7 +145,7 @@ write_random(
 		}
 		ops++;
 		*total += bytes;
-		if (bytes < buffersize)
+		if (bytes < io_buffersize)
 			break;
 		count -= bytes;
 	}
@@ -172,10 +172,10 @@ write_backward(
 	*count = cnt;
 
 	/* Do initial unaligned write if needed */
-	if ((bytes_requested = (off % buffersize))) {
+	if ((bytes_requested = (off % io_buffersize))) {
 		bytes_requested = min(cnt, bytes_requested);
 		off -= bytes_requested;
-		bytes = do_pwrite(file->fd, off, bytes_requested, buffersize,
+		bytes = do_pwrite(file->fd, off, bytes_requested, io_buffersize,
 				pwritev2_flags);
 		if (bytes == 0)
 			return ops;
@@ -192,9 +192,9 @@ write_backward(
 
 	/* Iterate backward through the rest of the range */
 	while (cnt > end) {
-		bytes_requested = min(cnt, buffersize);
+		bytes_requested = min(cnt, io_buffersize);
 		off -= bytes_requested;
-		bytes = do_pwrite(file->fd, off, cnt, buffersize,
+		bytes = do_pwrite(file->fd, off, cnt, io_buffersize,
 				pwritev2_flags);
 		if (bytes == 0)
 			break;
-- 
1.8.3.1
