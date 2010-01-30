Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0UAwujk203397 for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 04:58:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50C4F19D461
	for <xfs@oss.sgi.com>; Sat, 30 Jan 2010 02:55:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YxlcpEA0fPFoPUsC for
	<xfs@oss.sgi.com>; Sat, 30 Jan 2010 02:55:03 -0800 (PST)
Date: Sat, 30 Jan 2010 05:55:01 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 224: test aio hole-fill at 4g
Message-ID: <20100130105501.GA22909@infradead.org>
References: <4B633F9A.8000404@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B633F9A.8000404@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: ext4 development <linux-ext4@vger.kernel.org>, Giel de Nijs <giel@vectorwise.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jan 29, 2010 at 02:05:46PM -0600, Eric Sandeen wrote:
> Testcase from Giel de Nijs <giel@vectorwise.com>
> on linux-ext4 list, ""Possible ext4 data corruption
> with large files and async I/O," on 29 Jan 2010
> 
> ext4 put byte offsets in a block offset u32 container
> in the endio struct, so 4g wrapped to 0 leading to
> data corruption when the unwritten extent did not
> get converted.

There's various type messups in the test program that make it fail for
me on a 32-bit machine.  The patch below fixes it up, but it seems like
we should rather add a variant of that code as aio_read/write commands
to xfs_io instead of adding a new test program.

Index: xfstests-dev/src/aio-write.c
===================================================================
--- xfstests-dev.orig/src/aio-write.c	2010-01-30 10:42:24.000000000 +0000
+++ xfstests-dev/src/aio-write.c	2010-01-30 10:45:30.000000000 +0000
@@ -42,7 +42,7 @@ void usage(void)
 /*
  * Scale value by kilo, mega, or giga.
  */
-loff_t scale_by_kmg(long long value, char scale)
+long long scale_by_kmg(long long value, char scale)
 {
 switch (scale) {
 	case 'g':
@@ -69,7 +69,7 @@ switch (scale) {
 int main(int argc, char ** argv)
 {
 	char filename[PATH_MAX];
-	loff_t offset = 0;
+	long long offset = 0;
 	size_t length = 0;
 	int seed = 0xFF;
 	int queue_depth = 8;
@@ -95,12 +95,12 @@ int main(int argc, char ** argv)
 			seed = (int)strtol(optarg, &endp, 0);
 			break;
 		case 'o':
-			offset = strtol(optarg, &endp, 0);
-			offset = scale_by_kmg((long long)offset, *endp);
+			offset = strtoll(optarg, &endp, 0);
+			offset = scale_by_kmg(offset, *endp);
 			break;
 		case 'l':
 			length = strtol(optarg, &endp, 0);
-			length = scale_by_kmg((long long)length, *endp);
+			length = scale_by_kmg(length, *endp);
 			break;
 		case 'v':
 			verbose++;
@@ -141,7 +141,8 @@ int main(int argc, char ** argv)
 	io_prep_pwrite(&iocb, fd, buf, length, offset);
 	iocblist[0] = &iocb;
 	if (verbose)
-		printf("submitting write of %zd bytes at offset %zd\n", length, offset);
+		printf("submitting write of %zd bytes at offset %lld\n",
+			length, offset);
 	err = io_submit(io_ctx, 1, iocblist);
 	if (err < 0) {
 		printf("error submitting I/O requests: %s\n", strerror(-err));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
