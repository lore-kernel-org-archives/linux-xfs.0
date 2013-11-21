Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BAE397F54
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 23:54:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A92F3304051
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 21:54:01 -0800 (PST)
Received: from mail-pa0-f49.google.com (mail-pa0-f49.google.com
	[209.85.220.49]) by cuda.sgi.com with ESMTP id QQnnzcX1WmZz9dQp
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Nov 2013 21:54:00 -0800 (PST)
Received: by mail-pa0-f49.google.com with SMTP id kx10so4607864pab.8
	for <xfs@oss.sgi.com>; Wed, 20 Nov 2013 21:54:00 -0800 (PST)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] xfstests: add a new test case to test i_size updated properly
	under dio
Date: Thu, 21 Nov 2013 13:56:34 +0800
Message-Id: <1385013394-20379-1-git-send-email-wenqing.lz@taobao.com>
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
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Rich Johnston <rjohnston@sgi.com>, Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

In this commit a new test case is added to test that i_size is updated
properly under dio reads/writes.  We add a program in /src dir, which
has a writer to issue some append dio writes.  Meanwhile it has a
reader in this test do some dio reads.  As we expect, reader should read
nothing or data with 'a'.  But it might read some data with '0'.

This program is used to simulate binary log operations of database
application.  In these applications it implements an master/slave
synchronziation for database.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Rich Johnston <rjohnston@sgi.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 src/Makefile          |    2 +-
 src/diotest.c         |  166 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/321     |   56 +++++++++++++++++
 tests/generic/321.out |    1 +
 tests/generic/group   |    1 +
 5 files changed, 225 insertions(+), 1 deletion(-)
 create mode 100644 src/diotest.c
 create mode 100755 tests/generic/321
 create mode 100644 tests/generic/321.out

diff --git a/src/Makefile b/src/Makefile
index 84c8297..8c4f592 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
-	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec
+	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec diotest
 
 SUBDIRS =
 
diff --git a/src/diotest.c b/src/diotest.c
new file mode 100644
index 0000000..7d2378f
--- /dev/null
+++ b/src/diotest.c
@@ -0,0 +1,166 @@
+/*
+ * Copyright (c) 2013 Alibaba Group.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+/*
+ * This is a normal case that we do some append dio writes and meanwhile
+ * we do some dio reads.  Currently in vfs we don't ensure that i_size
+ * is updated properly.  Hence the reader will read some data with '0'.
+ * But we expect that the reader should read nothing or data with 'a'.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+
+#include <pthread.h>
+
+static char *prog;
+
+struct writer_data {
+	int fd;
+	size_t blksize;
+	char *buf;
+};
+
+static void usage(void)
+{
+	fprintf(stderr, "usage: %s [FILE]\n", prog);
+}
+
+static void *writer(void *arg)
+{
+	struct writer_data *data = (struct writer_data *)arg;
+	int ret;
+
+	ret = write(data->fd, data->buf, data->blksize);
+	if (ret < 0)
+		fprintf(stderr, "write file failed: %s\n", strerror(errno));
+
+	return NULL;
+}
+
+int main(int argc, char *argv[])
+{
+	pthread_t tid;
+	struct writer_data wdata;
+	size_t max_blocks = 128;		/* 128 */
+	size_t blksize = 1 * 1024 * 1024;	/* 1M */
+	char *rbuf = NULL, *wbuf = NULL;
+	int rfd = 0, wfd = 0;
+	int i, j;
+	int ret = 0;
+
+	prog = basename(argv[0]);
+
+	if (argc != 2) {
+		usage();
+		exit(1);
+	}
+
+	wfd = open(argv[1], O_CREAT|O_DIRECT|O_WRONLY|O_APPEND|O_TRUNC, S_IRWXU);
+	if (wfd < 0) {
+		fprintf(stderr, "failed to open write file: %s\n",
+			strerror(errno));
+		exit(1);
+	}
+
+	rfd = open(argv[1], O_DIRECT|O_RDONLY, S_IRWXU);
+	if (wfd < 0) {
+		fprintf(stderr, "failed to open read file: %s\n",
+			strerror(errno));
+		ret = 1;
+		goto err;
+	}
+
+	/*
+	 * We set 1024 as an alignment size for write buf.  Feel free to change
+	 * it with 4096.  But the problem is also hitted.
+	 */
+	if (posix_memalign((void **)&wbuf, 1024, blksize)) {
+		fprintf(stderr, "failed to alloc memory: %s\n", strerror(errno));
+		ret = 1;
+		goto err;
+	}
+
+	if (posix_memalign((void **)&rbuf, 4096, blksize)) {
+		fprintf(stderr, "failed to alloc memory: %s\n", strerror(errno));
+		ret = 1;
+		goto err;
+	}
+
+	memset(wbuf, 'a', blksize);
+	wdata.fd = wfd;
+	wdata.blksize = blksize;
+	wdata.buf = wbuf;
+
+	for (i = 0; i < max_blocks; i++) {
+		void *retval;
+
+		if (pthread_create(&tid, NULL, writer, &wdata)) {
+			fprintf(stderr, "create thread failed: %s\n",
+				strerror(errno));
+			ret = 1;
+			goto err;
+		}
+
+		memset(rbuf, 'b', blksize);
+		do {
+			ret = pread(rfd, rbuf, blksize, i * blksize);
+			if (ret < 0)
+				fprintf(stderr, "read file failed: %s\n",
+					strerror(errno));
+		} while (ret <= 0);
+
+		if (pthread_join(tid, &retval)) {
+			fprintf(stderr, " pthread join failed: %s\n",
+				strerror(errno));
+			ret = 1;
+			goto err;
+		}
+
+		if (ret >= 0) {
+			for (j = 0; j < ret; j ++) {
+				if (rbuf[j] != 'a') {
+					fprintf(stderr, "encounter an error: "
+						"offset %d content %c\n",
+						i, rbuf[j]);
+					ret = 1;
+					goto err;
+				}
+			}
+		}
+	}
+
+err:
+	if (rfd)
+		close(rfd);
+	if (wfd)
+		close(wfd);
+	if (rbuf)
+		free(rbuf);
+	if (wbuf)
+		free(wbuf);
+
+	return ret;
+}
diff --git a/tests/generic/321 b/tests/generic/321
new file mode 100755
index 0000000..372d23a
--- /dev/null
+++ b/tests/generic/321
@@ -0,0 +1,56 @@
+#! /bin/bash
+# FS QA Test No. 321
+#
+# Test i_size is updated properly under dio read/write
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Alibaba Group.  All Rights Reserved.
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
+    rm -f $tmp.* $testfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+testfile=$TEST_DIR/$seq.$$
+
+[ -x $here/src/diotest ] || _notrun "diotest not built"
+
+$here/src/diotest $testfile > $seqres.full 2>&1 ||
+	_fail "i_size isn't update properly!"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/321.out b/tests/generic/321.out
new file mode 100644
index 0000000..0cda9e4
--- /dev/null
+++ b/tests/generic/321.out
@@ -0,0 +1 @@
+QA output created by 321
diff --git a/tests/generic/group b/tests/generic/group
index 40da6dc..0b86d9f 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -123,3 +123,4 @@
 318 acl attr auto quick
 319 acl auto quick
 320 auto rw
+321 auto rw quick
-- 
1.7.9.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
