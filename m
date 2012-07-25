Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6PMV8IK179597 for <xfs@oss.sgi.com>; Wed, 25 Jul 2012 17:31:08 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ypxiwQAwemvSIB0B for <xfs@oss.sgi.com>;
	Wed, 25 Jul 2012 15:31:05 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuA6h-0006a1-Sy
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 08:31:03 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuA6X-0007Rn-PQ
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 08:30:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/3] xfs_io: implement pwritev for vectored writes
Date: Thu, 26 Jul 2012 08:30:50 +1000
Message-Id: <1343255450-28559-4-git-send-email-david@fromorbit.com>
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
these IO patterns. Extend the pwrite command to be able to issue
vectored write IO to enable use to simulate KVM style direct IO.

Also document the new parameters as well as all the missing pwrite
command parameters in the xfs_io(8) man page.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 io/io.h           |    2 ++
 io/pwrite.c       |   61 +++++++++++++++++++++++++++++++++++++++++++++--------
 man/man8/xfs_io.8 |   31 ++++++++++++++++++++++++++-
 3 files changed, 84 insertions(+), 10 deletions(-)

diff --git a/io/io.h b/io/io.h
index 8151b7b..91f0e3e 100644
--- a/io/io.h
+++ b/io/io.h
@@ -82,6 +82,8 @@ extern unsigned int	recurse_dir;
 
 extern void		*buffer;
 extern size_t		buffersize;
+extern int		vectors;
+extern struct iovec	*iov;
 extern int		alloc_buffer(size_t, int, unsigned int);
 extern int		read_buffer(int, off64_t, long long, long long *,
 					int, int);
diff --git a/io/pwrite.c b/io/pwrite.c
index 7c3932c..3689960 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -50,10 +50,47 @@ pwrite_help(void)
 " -R   -- write at random offsets in the specified range of bytes\n"
 " -Z N -- zeed the random number generator (used when writing randomly)\n"
 "         (heh, zorry, the -s/-S arguments were already in use in pwrite)\n"
+" -V N -- use vectored IO with N iovecs of blocksize each (pwritev)\n"
 "\n"));
 }
 
 static int
+do_pwrite(
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
+		return pwrite64(fd, buffer, min(count, buffer_size), offset);
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
+	bytes = pwritev(fd, iov, vectors, offset);
+
+	/* restore trimmed iov */
+	if (oldlen)
+		iov[vecs - 1].iov_len = oldlen;
+
+	return bytes;
+}
+static int
 write_random(
 	off64_t		offset,
 	long long	count,
@@ -76,7 +113,7 @@ write_random(
 	*total = 0;
 	while (count > 0) {
 		off = ((random() % range) / buffersize) * buffersize;
-		bytes = pwrite64(file->fd, buffer, buffersize, off);
+		bytes = do_pwrite(file->fd, off, buffersize, buffersize);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
@@ -114,7 +151,7 @@ write_backward(
 	if ((bytes_requested = (off % buffersize))) {
 		bytes_requested = min(cnt, bytes_requested);
 		off -= bytes_requested;
-		bytes = pwrite(file->fd, buffer, bytes_requested, off);
+		bytes = do_pwrite(file->fd, off, bytes_requested, buffersize);
 		if (bytes == 0)
 			return ops;
 		if (bytes < 0) {
@@ -132,7 +169,7 @@ write_backward(
 	while (cnt > end) {
 		bytes_requested = min(cnt, buffersize);
 		off -= bytes_requested;
-		bytes = pwrite64(file->fd, buffer, bytes_requested, off);
+		bytes = do_pwrite(file->fd, off, cnt, buffersize);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
@@ -157,7 +194,6 @@ write_buffer(
 	off64_t		skip,
 	long long	*total)
 {
-	size_t		bytes_requested;
 	ssize_t		bytes;
 	long long	bar = min(bs, count);
 	int		ops = 0;
@@ -168,8 +204,7 @@ write_buffer(
 			if (read_buffer(fd, skip + *total, bs, &bar, 0, 1) < 0)
 				break;
 		}
-		bytes_requested = min(bar, count);
-		bytes = pwrite64(file->fd, buffer, bytes_requested, offset);
+		bytes = do_pwrite(file->fd, offset, count, bar);
 		if (bytes == 0)
 			break;
 		if (bytes < 0) {
@@ -178,7 +213,7 @@ write_buffer(
 		}
 		ops++;
 		*total += bytes;
-		if (bytes < bytes_requested)
+		if (bytes <  min(count, bar))
 			break;
 		offset += bytes;
 		count -= bytes;
@@ -209,7 +244,7 @@ pwrite_f(
 	init_cvtnum(&fsblocksize, &fssectsize);
 	bsize = fsblocksize;
 
-	while ((c = getopt(argc, argv, "b:Cdf:i:qs:S:uwWZ:")) != EOF) {
+	while ((c = getopt(argc, argv, "b:Cdf:i:qs:S:uV:wWZ:")) != EOF) {
 		switch (c) {
 		case 'b':
 			tmp = cvtnum(fsblocksize, fssectsize, optarg);
@@ -258,6 +293,14 @@ pwrite_f(
 		case 'u':
 			uflag = 1;
 			break;
+		case 'V':
+			vectors = strtoul(optarg, &sp, 0);
+			if (!sp || sp == optarg) {
+				printf(_("non-numberic vector count == %s\n"),
+					optarg);
+				return 0;
+			}
+			break;
 		case 'w':
 			wflag = 1;
 			break;
@@ -356,7 +399,7 @@ pwrite_init(void)
 	pwrite_cmd.argmax = -1;
 	pwrite_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
 	pwrite_cmd.args =
-		_("[-i infile [-d] [-s skip]] [-b bs] [-S seed] [-wW] off len");
+_("[-i infile [-d] [-s skip]] [-b bs] [-S seed] [-wW] [-FBR [-Z N]] [-V N] off len");
 	pwrite_cmd.oneline =
 		_("writes a number of bytes at a specified offset");
 	pwrite_cmd.help = pwrite_help;
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index ae707f4..f7c6935 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -172,7 +172,7 @@ See the
 .B pread
 command.
 .TP
-.BI "pwrite [ \-i " file " ] [ \-d ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] " "offset length"
+.BI "pwrite [ \-i " file " ] [ \-d ] [ \-s " skip " ] [ \-b " size " ] [ \-S " seed " ] [ \-FBR [ \-Z " zeed " ] ] [ \-wW ] [ \-V " vectors " ] " "offset length"
 Writes a range of bytes in a specified blocksize from the given
 .IR offset .
 The bytes written can be either a set pattern or read in from another
@@ -203,6 +203,35 @@ requests will be split. The default blocksize is 4096 bytes.
 used to set the (repeated) fill pattern which
 is used when the data to write is not coming from a file.
 The default buffer fill pattern value is 0xcdcdcdcd.
+.TP
+.B \-F
+write the buffers in a forwards sequential direction.
+.TP
+.B \-B
+write the buffers in a reserve sequential direction.
+.TP
+.B \-R
+write the buffers in the give range in a random order.
+.TP
+.B \-Z seed
+specify the random number seed used for random write
+.TP
+.B \-w
+call
+.BR fdatasync (2)
+once all writes are complete (included in timing results)
+.TP
+.B \-W
+call
+.BR fsync (2)
+once all writes are complete (included in timing results)
+.TP
+.B \-V vectors
+Use the vectored IO write syscall
+.BR pwritev (2)
+with a number of blocksize length iovecs. The number of iovecs is set by the
+.I vectors
+parameter.
 .RE
 .PD
 .TP
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
