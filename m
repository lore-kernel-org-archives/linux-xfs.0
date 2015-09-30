Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AFAA67F37
	for <xfs@oss.sgi.com>; Wed, 30 Sep 2015 10:59:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8B7B38F8078
	for <xfs@oss.sgi.com>; Wed, 30 Sep 2015 08:59:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sOComY3KWUv6Eqpq for <xfs@oss.sgi.com>;
	Wed, 30 Sep 2015 08:59:32 -0700 (PDT)
Subject: [PATCH V2] test extending sub-block AIO writes for races
References: <560B34E3.4080107@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <560C06E3.4090708@sandeen.net>
Date: Wed, 30 Sep 2015 10:59:31 -0500
MIME-Version: 1.0
In-Reply-To: <560B34E3.4080107@sandeen.net>
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
To: fstests <fstests@vger.kernel.org>
Cc: xfs@oss.sgi.com

This tests bfoster's
[PATCH 1/2] xfs: always drain dio before extending aio write submission
patch; it launches four adjacent 1k IOs past EOF, then reads back
to see if we have 4k worth of the data we wrote, or something else - 
possibly zeros from sub-block zeroing and eof racing.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2:
	do 4x512 IOs to get as much sub-block goodness as possible
	fix up comments & typos

diff --git a/src/aio-dio-regress/aio-dio-eof-race.c b/src/aio-dio-regress/aio-dio-eof-race.c
new file mode 100644
index 0000000..ce5d715
--- /dev/null
+++ b/src/aio-dio-regress/aio-dio-eof-race.c
@@ -0,0 +1,173 @@
+/*
+ * Launch 4 sub-block AIOs past EOF and ensure that we don't see
+ * corruption from racing sub-block zeroing when they're complete.
+ *
+ * Copyright (C) 2015 Red Hat, Inc. All Rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <ctype.h>
+
+#include <libaio.h>
+
+/* Sized to allow 4 x 512 AIOs */
+#define BUF_SIZE	2048
+#define IO_PATTERN	0xab
+
+void
+dump_buffer(
+	void	*buf,
+	off64_t	offset,
+	ssize_t	len)
+{
+	int	i, j;
+	char	*p;
+	int	new;
+	
+	for (i = 0, p = (char *)buf; i < len; i += 16) {
+		char    *s = p;
+
+		if (i && !memcmp(p, p - 16, 16)) {
+			new = 0;
+		} else {
+			if (i)
+				printf("*\n");
+			new = 1;
+		}
+
+		if (!new) {
+			p += 16;
+			continue;
+		}
+
+		printf("%08llx  ", (unsigned long long)offset + i);
+		for (j = 0; j < 16 && i + j < len; j++, p++)
+			printf("%02x ", *p);
+		printf(" ");
+		for (j = 0; j < 16 && i + j < len; j++, s++) {
+			if (isalnum((int)*s))
+				printf("%c", *s);
+			else
+				printf(".");
+		}
+		printf("\n");
+
+	}
+	printf("%08llx\n", (unsigned long long)offset + i);
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_context *ctx = NULL;
+	struct io_event evs[4];
+	struct iocb iocb1, iocb2, iocb3, iocb4;
+	struct iocb *iocbs[] = { &iocb1, &iocb2, &iocb3, &iocb4 };
+	void *buf;
+	struct stat statbuf;
+	char cmp_buf[BUF_SIZE];
+	int fd, err = 0;
+	off_t eof;
+
+	fd = open(argv[1], O_DIRECT | O_CREAT | O_TRUNC | O_RDWR, 0600);
+	if (fd == -1) {
+		perror("open");
+		return 1;
+	}
+
+	err = posix_memalign(&buf, getpagesize(), BUF_SIZE);
+	if (err) {
+		fprintf(stderr, "error %s during %s\n",
+			strerror(err),
+			"posix_memalign");
+		return 1;
+	}
+	memset(cmp_buf, IO_PATTERN, BUF_SIZE);
+
+	err = io_setup(4, &ctx);
+	if (err) {
+		fprintf(stderr, "error %s during %s\n",
+			strerror(err),
+			"io_setup");
+		return 1;
+	}
+
+	eof = 0;
+
+	/* Keep extending until 8MB (fairly arbitrary) */
+	while (eof < 8 * 1024 * 1024) {
+		memset(buf, IO_PATTERN, BUF_SIZE);
+		fstat(fd, &statbuf);
+		eof = statbuf.st_size;
+
+		/*
+		 * Split the buffer into multiple I/Os to send a mix of block
+		 * aligned/unaligned writes as well as writes that start beyond
+		 * the current EOF. This stresses things like inode size
+		 * management and stale block zeroing for races and can lead to
+		 * data corruption when not handled properly.
+		 */
+		io_prep_pwrite(&iocb1, fd, buf, BUF_SIZE/4, eof + 0*BUF_SIZE/4);
+		io_prep_pwrite(&iocb2, fd, buf, BUF_SIZE/4, eof + 1*BUF_SIZE/4);
+		io_prep_pwrite(&iocb3, fd, buf, BUF_SIZE/4, eof + 2*BUF_SIZE/4);
+		io_prep_pwrite(&iocb4, fd, buf, BUF_SIZE/4, eof + 3*BUF_SIZE/4);
+	
+		err = io_submit(ctx, 4, iocbs);
+		if (err != 4) {
+			fprintf(stderr, "error %s during %s\n",
+				strerror(err),
+				"io_submit");
+			return 1;
+		}
+
+		err = io_getevents(ctx, 4, 4, evs, NULL);
+		if (err != 4) {
+			fprintf(stderr, "error %s during %s\n",
+				strerror(err),
+				"io_getevents");
+			return 1;
+		}
+
+		/*
+		 * And then read it back.
+		 *
+		 * Using pread to keep it simple, but AIO has the same effect.
+		 * eof is the prior eof; we just wrote BUF_SIZE more.
+		 */
+		if (pread(fd, buf, BUF_SIZE, eof) != BUF_SIZE) {
+			perror("pread");
+			return 1;
+		}
+
+		/*
+		 * We launched 4 AIOs which, stitched together, should write
+		 * a seamless BUF_SIZE worth of IO_PATTERN to the last block.
+		 */
+		if (memcmp(buf, cmp_buf, BUF_SIZE)) {
+			printf("corruption while extending from %ld\n", eof);
+			dump_buffer(buf, 0, BUF_SIZE);
+			return 1;
+		}
+	}
+
+	printf("Success, all done.\n");
+	return 0;
+}
diff --git a/tests/generic/326 b/tests/generic/326
new file mode 100755
index 0000000..f20375a
--- /dev/null
+++ b/tests/generic/326
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 326
+#
+# Test races while extending past EOF via sub-block AIO writes
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Red Hat, Inc.  All Rights Reserved.
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
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $TEST_DIR/tst-aio-dio-eof-race
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_supported_fs generic
+_supported_os Linux
+
+_require_test
+_require_sparse_files
+_require_aiodio aio-dio-eof-race
+
+# Test does 512 byte DIO, so make sure that'll work
+logical_block_size=`_min_dio_alignment $TEST_DEV`
+
+if [ "$logical_block_size" -gt "512" ]; then
+	_notrun "device block size: $logical_block_size greater than 512"
+fi
+
+# We don't mind 512-byte fs blocks; the IOs won't be sub-block,
+# but the test should still pass, even if it doesn't stress the code
+# we're targeting.
+
+# Note, this test does several extending loops internally
+$AIO_TEST $TEST_DIR/tst-aio-dio-eof-race
+
+status=$?
+exit
diff --git a/tests/generic/326.out b/tests/generic/326.out
new file mode 100644
index 0000000..22a3e78
--- /dev/null
+++ b/tests/generic/326.out
@@ -0,0 +1,2 @@
+QA output created by 326
+Success, all done.
diff --git a/tests/generic/group b/tests/generic/group
index 4ae256f..a5f3008 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -207,3 +207,4 @@
 323 auto aio stress
 324 auto fsr quick
 325 auto quick data log
+326 auto quick aio

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
