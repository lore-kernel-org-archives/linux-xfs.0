Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0TK4eAO150789 for <xfs@oss.sgi.com>; Fri, 29 Jan 2010 14:04:40 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 690FA19C4EB
	for <xfs@oss.sgi.com>; Fri, 29 Jan 2010 12:05:45 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id eQdQtV3Zy3cthJQz for
	<xfs@oss.sgi.com>; Fri, 29 Jan 2010 12:05:45 -0800 (PST)
Message-ID: <4B633F9A.8000404@sandeen.net>
Date: Fri, 29 Jan 2010 14:05:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests 224: test aio hole-fill at 4g
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
To: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
Cc: Giel de Nijs <giel@vectorwise.com>

Testcase from Giel de Nijs <giel@vectorwise.com>
on linux-ext4 list, ""Possible ext4 data corruption
with large files and async I/O," on 29 Jan 2010

ext4 put byte offsets in a block offset u32 container
in the endio struct, so 4g wrapped to 0 leading to
data corruption when the unwritten extent did not
get converted.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/224 b/224
new file mode 100755
index 0000000..47e614c
--- /dev/null
+++ b/224
@@ -0,0 +1,68 @@
+#! /bin/bash
+# FS QA Test No. 224
+#
+# Test aio hole-filling past 2^32 bytes
+#
+# Testcase from Giel de Nijs <giel@vectorwise.com>
+# on linux-ext4 list, ""Possible ext4 data corruption
+# with large files and async I/O," on 29 Jan 2010
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Eric Sandeen.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+# creator
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+[ ! -x $here/src/aio-write ] && _notrun "aio-write not built"
+
+TESTFILE=$TEST_DIR/$seq-aio-write-testfile
+
+rm -f $TESTFILE
+$here/src/aio-write -v -s 0xab -o 6g -l 512k $TESTFILE
+$here/src/aio-write -v -s 0xcd -o 4g -l 512k $TESTFILE
+
+# Bug in ext4 caused the 4g offset to wrap and io
+# completion happened at 0, leaving extent unwritten,
+# and 0s returned
+
+$XFS_IO_PROG -F -c "pread -v 4g 512k" -c "pread -v 6g 512k" $TESTFILE | \
+	_filter_xfs_io_unique
+
+status=0 ; exit
diff --git a/224.out b/224.out
new file mode 100644
index 0000000..4bb51d5
--- /dev/null
+++ b/224.out
@@ -0,0 +1,19 @@
+QA output created by 224
+opening file /mnt/test/224-aio-write-testfile
+submitting write of 524288 bytes at offset 6442450944
+waiting for write to be finished
+got 1 events
+written 524288 bytes
+opening file /mnt/test/224-aio-write-testfile
+submitting write of 524288 bytes at offset 4294967296
+waiting for write to be finished
+got 1 events
+written 524288 bytes
+100000000:  cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd cd  ................
+*
+read 524288/524288 bytes at offset 4294967296
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+180000000:  ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab ab  ................
+*
+read 524288/524288 bytes at offset 6442450944
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/group b/group
index c66d965..46acc2b 100644
--- a/group
+++ b/group
@@ -336,4 +336,5 @@ deprecated
 220 auto quota quick
 221 auto metadata quick
 222 auto fsr ioctl quick
+224 auto aio quick
 223 auto quick
diff --git a/src/Makefile b/src/Makefile
index 619a752..2ac7041 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -42,6 +42,8 @@ LLDLIBS += $(LIBGDBM)
 endif
 
 ifeq ($(HAVE_AIO), true)
+LINUX_TARGETS += aio-write
+LLDLIBS += -laio
 SUBDIRS += aio-dio-regress
 endif
 
diff --git a/src/aio-write.c b/src/aio-write.c
new file mode 100644
index 0000000..59fbb24
--- /dev/null
+++ b/src/aio-write.c
@@ -0,0 +1,174 @@
+/*
+ *  Author: Giel de Nijs, VectorWise B.V. <giel@vectorwise.com>
+ *
+ * perform an AIO write to a file at a given length & offset
+ * Compile with -laio
+ *
+ * Copyright (c) 2010 Giel de Nijs, VectorWise B.V. <giel@vectorwise.com>
+ * Modifications Copyright (c) Eric Sandeen <sandeen@sandeen.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+
+ */
+
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#define _LARGEFILE64_SOURCE
+#define _FILE_OFFSET_BITS 64
+#include <features.h>
+#include <libaio.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <error.h>
+#include <errno.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <ctype.h>
+#include <limits.h>
+
+void usage(void)
+{
+	fprintf(stderr, "usage: aio_write [-v] [-s seed]"
+		" -o offset -l length filename\n");
+	exit(1);
+}
+
+/*
+ * Scale value by kilo, mega, or giga.
+ */
+loff_t scale_by_kmg(long long value, char scale)
+{
+switch (scale) {
+	case 'g':
+	case 'G':
+		value *= 1024;
+		/* fallthrough */
+	case 'm':
+	case 'M':
+		value *= 1024;
+		/* fallthrough */
+	case 'k':
+	case 'K':
+		value *= 1024;
+		break;
+	case '\0':
+		break;
+	default:
+		usage();
+		break;
+	}
+	return value;
+}
+
+int main(int argc, char ** argv)
+{
+	char filename[PATH_MAX];
+	loff_t offset = 0;
+	size_t length = 0;
+	int seed = 0xFF;
+	int queue_depth = 8;
+	int err;
+	char *buf;
+	io_context_t io_ctx;
+	struct iocb iocb;
+	struct iocb *iocblist[1];
+	struct io_event events[1];
+	int fd;
+	int c;
+	int verbose = 0;
+	extern char *optarg;
+	extern int optind, optopt, opterr;
+
+	if (argc < 4)
+		usage();
+
+	while ((c = getopt(argc, argv, "s:o:l:v")) != -1) {
+		char *endp;
+		switch (c) {
+		case 's':
+			seed = (int)strtol(optarg, &endp, 0);
+			break;
+		case 'o':
+			offset = strtol(optarg, &endp, 0);
+			offset = scale_by_kmg((long long)offset, *endp);
+			break;
+		case 'l':
+			length = strtol(optarg, &endp, 0);
+			length = scale_by_kmg((long long)length, *endp);
+			break;
+		case 'v':
+			verbose++;
+			break;
+		case '?':
+			usage();
+			break;
+		}
+	}
+
+	strncpy(filename, argv[argc-1], PATH_MAX);
+
+	/* allocate aligned memory (for direct i/o) */
+	err = posix_memalign((void **)&buf, getpagesize(), length);
+	if (err) {
+		printf("error allocating memory: %s\n", strerror(err));
+		return(err);
+	}
+	memset(buf, seed, length);
+
+	/* initialize async i/o */
+	err = io_queue_init(queue_depth, &io_ctx);
+	if (err < 0) {
+		printf("error initializing I/O queue: %s\n", strerror(-err));
+		return(-err);
+	}
+
+	/* create file */
+	if (verbose)
+		printf("opening file %s\n", filename);
+	fd = open(filename, O_DIRECT|O_RDWR|O_LARGEFILE|O_CREAT, 0666);
+	if (fd < 0) {
+		perror("error opening file");
+		return(errno);
+	}
+
+	/* write buf at offset */
+	io_prep_pwrite(&iocb, fd, buf, length, offset);
+	iocblist[0] = &iocb;
+	if (verbose)
+		printf("submitting write of %zd bytes at offset %zd\n", length, offset);
+	err = io_submit(io_ctx, 1, iocblist);
+	if (err < 0) {
+		printf("error submitting I/O requests: %s\n", strerror(-err));
+		return(-err);
+	}
+
+	if (verbose)
+		printf("waiting for write to be finished\n");
+	err = io_getevents(io_ctx, 1, 1, events, NULL);
+	if (err < 0) {
+		printf("error getting I/O events: %s\n", strerror(-err));
+		return(-err);
+	}
+	if (verbose)
+		printf("got %d events\n", err);
+	err = events[0].res;
+	if (err < 0) {
+		printf("error writing buffer: %s\n", strerror(-err));
+		return(-err);
+	}
+	if (verbose)
+		printf("written %ld bytes\n", events[0].res);
+
+	close(fd);
+	io_destroy(io_ctx);
+
+	free(buf);
+	return 0;
+}
+

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
