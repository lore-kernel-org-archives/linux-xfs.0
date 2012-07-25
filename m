Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6PMV0Qe179558 for <xfs@oss.sgi.com>; Wed, 25 Jul 2012 17:31:00 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	NCfx2QfUhB8VHLEz for <xfs@oss.sgi.com>;
	Wed, 25 Jul 2012 15:30:58 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuA6X-0006Zt-Sp
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 08:30:53 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuA6X-0007Rj-OX
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 08:30:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs_io: implement preadv for vectored reads
Date: Thu, 26 Jul 2012 08:30:49 +1000
Message-Id: <1343255450-28559-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1343255450-28559-1-git-send-email-david@fromorbit.com>
References: <1343255450-28559-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When looking at KVM based direct IO patterns, I noticed that it was
using preadv and pwritev, and I could not use xfs_io to simulate
these IO patterns. Extend the pread command to be able to issue
vectored read IO to enable use to simulate KVM style direct IO.

Also document the new parameters as well as all the missing pread
command parameters in the xfs_io(8) man page.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 io/pread.c        |  127 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 man/man8/xfs_io.8 |   21 ++++++++-
 2 files changed, 136 insertions(+), 12 deletions(-)

diff --git a/io/pread.c b/io/pread.c
index 705dc69..f6e4ca2 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -46,6 +46,8 @@ pread_help(void)
 " -R   -- read at random offsets in the range of bytes\n"
 " -Z N -- zeed the random number generator (used when reading randomly)\n"
 "         (heh, zorry, the -s/-S arguments were already in use in pwrite)\n"
+" -V N -- use vectored IO with N iovecs of blocksize each (preadv)\n"
+"\n"
 " When in \"random\" mode, the number of read operations will equal the\n"
 " number required to do a complete forward/backward scan of the range.\n"
 " Note that the offset within the range is chosen at random each time\n"
@@ -56,6 +58,42 @@ pread_help(void)
 void	*buffer;
 size_t	highwater;
 size_t	buffersize;
+int	vectors;
+struct iovec *iov;
+
+static int
+alloc_iovec(
+	size_t		bsize,
+	int		uflag,
+	unsigned int	seed)
+{
+	int		i;
+
+	iov = calloc(vectors, sizeof(struct iovec));
+	if (!iov)
+		return -1;
+
+	buffersize = 0;
+	for (i = 0; i < vectors; i++) {
+		iov[i].iov_base = memalign(pagesize, bsize);
+		buffer = memalign(pagesize, bsize);
+		if (!buffer) {
+			perror("memalign");
+			goto unwind;
+		}
+		iov[i].iov_len = bsize;
+		if (!uflag)
+			memset(iov[i].iov_base, seed, bsize);
+	}
+	buffersize = bsize * vectors;
+	return 0;
+unwind:
+	for( ; i >= 0; i--)
+		free(iov[i].iov_base);
+	free(iov);
+	iov = NULL;
+	return -1;
+}
 
 int
 alloc_buffer(
@@ -63,6 +101,9 @@ alloc_buffer(
 	int		uflag,
 	unsigned int	seed)
 {
+	if (vectors)
+		return alloc_iovec(bsize, uflag, seed);
+
 	if (bsize > highwater) {
 		if (buffer)
 			free(buffer);
@@ -81,7 +122,8 @@ alloc_buffer(
 }
 
 void
-dump_buffer(
+__dump_buffer(
+	void		*buf,
 	off64_t		offset,
 	ssize_t		len)
 {
@@ -105,6 +147,64 @@ dump_buffer(
 	}
 }
 
+void
+dump_buffer(
+	off64_t		offset,
+	ssize_t		len)
+{
+	int		i, l;
+
+	if (!vectors) {
+		__dump_buffer(buffer, offset, len);
+		return;
+	}
+
+	for (i = 0; len > 0 && i < vectors; i++) {
+		l = min(len, iov[i].iov_len);
+
+		__dump_buffer(iov[i].iov_base, offset, l);
+		len -= l;
+		offset += l;
+	}
+}
+
+static int
+do_pread(
+	int		fd,
+	off64_t		offset,
+	ssize_t		count,
+	ssize_t		buffer_size)
+{
+	int		vecs = 0;
+	ssize_t		oldlen = 0;
+	ssize_t		bytes = 0;
+
+
+	if (!vectors)
+		return pread64(fd, buffer, min(count, buffer_size), offset);
+
+	/* trim the iovec if necessary */
+	if (count < buffersize) {
+		size_t	len = 0;
+		while (len + iov[vecs].iov_len < count) {
+			len += iov[vecs].iov_len;
+			vecs++;
+		}
+		oldlen = iov[vecs].iov_len;
+		iov[vecs].iov_len = count - len;
+		vecs++;
+	} else {
+		vecs = vectors;
+	}
+	bytes = preadv(fd, iov, vectors, offset);
+
+	/* restore trimmed iov */
+	if (oldlen)
+		iov[vecs - 1].iov_len = oldlen;
+
+	return bytes;
+}
+
 static int
 read_random(
 	int		fd,
@@ -132,7 +232,7 @@ read_random(
 	*total = 0;
 	while (count > 0) {
 		off = ((random() % range) / buffersize) * buffersize;
-		bytes = pread64(fd, buffer, buffersize, off);
+		bytes = do_pread(fd, off, buffersize, buffersize);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
@@ -173,9 +273,8 @@ read_backward(
 
 	/* Do initial unaligned read if needed */
 	if ((bytes_requested = (off % buffersize))) {
-		bytes_requested = min(cnt, bytes_requested);
 		off -= bytes_requested;
-		bytes = pread(fd, buffer, bytes_requested, off);
+		bytes = do_pread(fd, off, bytes_requested, buffersize);
 		if (bytes == 0)
 			return ops;
 		if (bytes < 0) {
@@ -193,7 +292,7 @@ read_backward(
 	while (cnt > end) {
 		bytes_requested = min(cnt, buffersize);
 		off -= bytes_requested;
-		bytes = pread64(fd, buffer, bytes_requested, off);
+		bytes = do_pread(fd, off, cnt, buffersize);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
@@ -219,14 +318,12 @@ read_forward(
 	int		onlyone,
 	int		eof)
 {
-	size_t		bytes_requested;
 	ssize_t		bytes;
 	int		ops = 0;
 
 	*total = 0;
 	while (count > 0 || eof) {
-		bytes_requested = min(count, buffersize);
-		bytes = pread64(fd, buffer, bytes_requested, offset);
+		bytes = do_pread(fd, offset, count, buffersize);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
@@ -237,7 +334,7 @@ read_forward(
 		if (verbose)
 			dump_buffer(offset, bytes);
 		*total += bytes;
-		if (onlyone || bytes < bytes_requested)
+		if (onlyone || bytes < min(count, buffersize))
 			break;
 		offset += bytes;
 		count -= bytes;
@@ -278,7 +375,7 @@ pread_f(
 	init_cvtnum(&fsblocksize, &fssectsize);
 	bsize = fsblocksize;
 
-	while ((c = getopt(argc, argv, "b:BCFRquvZ:")) != EOF) {
+	while ((c = getopt(argc, argv, "b:BCFRquvV:Z:")) != EOF) {
 		switch (c) {
 		case 'b':
 			tmp = cvtnum(fsblocksize, fssectsize, optarg);
@@ -309,6 +406,14 @@ pread_f(
 		case 'v':
 			vflag = 1;
 			break;
+		case 'V':
+			vectors = strtoul(optarg, &sp, 0);
+			if (!sp || sp == optarg) {
+				printf(_("non-numberic vector count == %s\n"),
+					optarg);
+				return 0;
+			}
+			break;
 		case 'Z':
 			zeed = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
@@ -393,7 +498,7 @@ pread_init(void)
 	pread_cmd.argmin = 2;
 	pread_cmd.argmax = -1;
 	pread_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	pread_cmd.args = _("[-b bs] [-v] off len");
+	pread_cmd.args = _("[-b bs] [-v] [-i N] [-FBR [-Z N]] off len");
 	pread_cmd.oneline = _("reads a number of bytes at a specified offset");
 	pread_cmd.help = pread_help;
 
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index a185798..ae707f4 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -131,7 +131,7 @@ See the
 .B close
 command.
 .TP
-.BI "pread [ \-b " bsize " ] [ \-v ] " "offset length"
+.BI "pread [ \-b " bsize " ] [ \-v ] [ \-FBR [ \-Z " seed " ] ] [ \-V " vectors " ] " "offset length"
 Reads a range of bytes in a specified blocksize from the given
 .IR offset .
 .RS 1.0i
@@ -145,6 +145,25 @@ requests will be split. The default blocksize is 4096 bytes.
 .B \-v
 dump the contents of the buffer after reading,
 by default only the count of bytes actually read is dumped.
+.TP
+.B \-F
+read the buffers in a forwards sequential direction.
+.TP
+.B \-B
+read the buffers in a reserve sequential direction.
+.TP
+.B \-R
+read the buffers in the give range in a random order.
+.TP
+.B \-Z seed
+specify the random number seed used for random reads.
+.TP
+.B \-V vectors
+Use the vectored IO read syscall
+.BR preadv (2)
+with a number of blocksize length iovecs. The number of iovecs is set by the
+.I vectors
+parameter.
 .PD
 .RE
 .TP
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
