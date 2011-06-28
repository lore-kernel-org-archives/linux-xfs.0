Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5SFXSWO236269 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 10:33:28 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64DAE1770BE5
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:33:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7Bqoizz0q5Zw0vka for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2011 08:33:27 -0700 (PDT)
From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Tue, 28 Jun 2011 11:33:19 -0400
Message-Id: <1309275199-10801-5-git-send-email-josef@redhat.com>
In-Reply-To: <1309275199-10801-1-git-send-email-josef@redhat.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, viro@ZenIV.linux.org.uk

This is a test to make sure seek_data/seek_hole is acting like it does on
Solaris.  It will check to see if the fs supports finding a hole or not and will
adjust as necessary.

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 255               |   71 ++++++++
 255.out           |    2 +
 group             |    1 +
 src/Makefile      |    2 +-
 src/seek-tester.c |  475 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 550 insertions(+), 1 deletions(-)
 create mode 100755 255
 create mode 100644 255.out
 create mode 100644 src/seek-tester.c

diff --git a/255 b/255
new file mode 100755
index 0000000..4bb4d0b
--- /dev/null
+++ b/255
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FS QA Test No. 255
+#
+# Test SEEK_DATA and SEEK_HOLE
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Red Hat.  All Rights Reserved.
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
+owner=josef@redhat.com
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
+testfile=$TEST_DIR/seek_test.$$
+logfile=$TEST_DIR/seek_test.$$.log
+
+[ -x $here/src/seek-tester ] || _notrun "seek-tester not built"
+
+_cleanup()
+{
+	rm -f $testfile
+	rm -f $logfile
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+echo "Silence is golden"
+$here/src/seek-tester -q $testfile 2>&1 | tee -a $logfile
+
+if grep -q "SEEK_HOLE is not supported" $logfile; then
+	_notrun "SEEK_HOLE/SEEK_DATA not supported by this kernel"
+fi
+
+rm -f $logfile
+rm -f $testfile
+
+status=0 ; exit
diff --git a/255.out b/255.out
new file mode 100644
index 0000000..7eefb82
--- /dev/null
+++ b/255.out
@@ -0,0 +1,2 @@
+QA output created by 255
+Silence is golden
diff --git a/group b/group
index 1f86075..c045e70 100644
--- a/group
+++ b/group
@@ -368,3 +368,4 @@ deprecated
 252 auto quick prealloc
 253 auto quick
 254 auto quick
+255 auto quick
diff --git a/src/Makefile b/src/Makefile
index 91088bf..ccdaeec 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -17,7 +17,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
-	stale_handle pwrite_mmap_blocked fstrim
+	stale_handle pwrite_mmap_blocked fstrim seek-tester
 
 SUBDIRS =
 
diff --git a/src/seek-tester.c b/src/seek-tester.c
new file mode 100644
index 0000000..5141b45
--- /dev/null
+++ b/src/seek-tester.c
@@ -0,0 +1,475 @@
+/*
+ * Copyright (C) 2011 Oracle.  All rights reserved.
+ * Copyright (C) 2011 Red Hat.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#define _XOPEN_SOURCE 500
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+
+#ifndef SEEK_DATA
+#define SEEK_DATA	3
+#define SEEK_HOLE	4
+#endif
+
+#define FS_NO_HOLES	(1 << 0)
+#define QUIET		(1 << 1)
+
+static blksize_t alloc_size;
+static unsigned flags = 0;
+
+static int get_io_sizes(int fd)
+{
+	struct stat buf;
+	int ret;
+
+	ret = fstat(fd, &buf);
+	if (ret)
+		fprintf(stderr, "  ERROR %d: Failed to find io blocksize\n",
+			errno);
+
+	/* st_blksize is typically also the allocation size */
+	alloc_size = buf.st_blksize;
+
+	if (!(flags & QUIET))
+		printf("Allocation size: %ld\n", alloc_size);
+
+	return ret;
+}
+
+#define do_free(x)	do { if(x) free(x); } while(0);
+
+static void *do_malloc(size_t size)
+{
+	void *buf;
+
+	buf = malloc(size);
+	if (!buf)
+		fprintf(stderr, "  ERROR: Unable to allocate %ld bytes\n",
+			(long)size);
+
+	return buf;
+}
+
+static int do_truncate(int fd, off_t length)
+{
+	int ret;
+
+	ret = ftruncate(fd, length);
+	if (ret)
+		fprintf(stderr, "  ERROR %d: Failed to extend file "
+			"to %ld bytes\n", errno, (long)length);
+	return ret;
+}
+
+static ssize_t do_pwrite(int fd, const void *buf, size_t count, off_t offset)
+{
+	ssize_t ret, written = 0;
+
+	while (count > written) {
+		ret = pwrite(fd, buf + written, count - written, offset + written);
+		if (ret < 0) {
+			fprintf(stderr, "  ERROR %d: Failed to write %ld "
+				"bytes\n", errno, (long)count);
+			return ret;
+		}
+		written += ret;
+	}
+
+	return 0;
+}
+
+static int do_lseek(int testnum, int subtest, int fd, int origin, off_t set,
+		    off_t exp)
+{
+	off_t pos;
+	int ret = -1;
+
+	pos = lseek(fd, set, origin);
+
+	if (pos != exp) {
+		fprintf(stderr, "  ERROR in Test %d.%d: POS expected %ld, "
+			"got %ld\n", testnum, subtest, (long)exp, (long)pos);
+		goto out;
+	}
+
+	if (pos == -1 && errno != ENXIO) {
+		fprintf(stderr, "  ERROR in Test %d.%d: ERRNO expected %d, "
+			"got %d\n", testnum, subtest, ENXIO, errno);
+		goto out;
+	}
+
+	ret = 0;
+
+out:
+	return ret;
+}
+
+static int get_flags(int fd)
+{
+	const char *buf = "ABCDEF";
+	ssize_t written;
+	off_t pos;
+	int ret;
+
+	ret = do_truncate(fd, alloc_size * 2);
+	if (ret)
+		return ret;
+
+	written = do_pwrite(fd, buf, strlen(buf), 0);
+	if (written)
+		return -1;
+
+	pos = lseek(fd, 0, SEEK_HOLE);
+	if (pos == alloc_size * 2) {
+		if (!(flags & QUIET))
+			printf("File system does not recognize holes, the only "
+			       "hole found will be at the end.\n");
+		flags |= FS_NO_HOLES;
+	} else if (pos == (off_t)-1) {
+		fprintf(stderr, "SEEK_HOLE is not supported\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+/* test hole data hole data */
+static int test06(int fd, int testnum)
+{
+	int ret = 0;
+	char *buf = NULL;
+	int bufsz = alloc_size;
+	int filsz = bufsz * 4;
+	int off;
+
+	if (flags & FS_NO_HOLES)
+		return 1;
+
+	/* HOLE - DATA - HOLE - DATA */
+	/* Each unit is bufsz */
+
+	buf = do_malloc(bufsz);
+	if (!buf)
+		goto out;
+	memset(buf, 'a', bufsz);
+
+	ret = do_pwrite(fd, buf, bufsz, bufsz);
+	if (!ret)
+		do_pwrite(fd, buf, bufsz, bufsz * 3);
+	if (ret)
+		goto out;
+
+	/* offset at the beginning */
+	ret += do_lseek(testnum,  1, fd, SEEK_HOLE, 0, 0);
+	ret += do_lseek(testnum,  2, fd, SEEK_HOLE, 1, 1);
+	ret += do_lseek(testnum,  3, fd, SEEK_DATA, 0, bufsz);
+	ret += do_lseek(testnum,  4, fd, SEEK_DATA, 1, bufsz);
+
+	/* offset around first hole-data boundary */
+	off = bufsz;
+	ret += do_lseek(testnum,  5, fd, SEEK_HOLE, off - 1, off - 1);
+	ret += do_lseek(testnum,  6, fd, SEEK_DATA, off - 1, off);
+	ret += do_lseek(testnum,  7, fd, SEEK_HOLE, off,     bufsz * 2);
+	ret += do_lseek(testnum,  8, fd, SEEK_DATA, off,     off);
+	ret += do_lseek(testnum,  9, fd, SEEK_HOLE, off + 1, bufsz * 2);
+	ret += do_lseek(testnum, 10, fd, SEEK_DATA, off + 1, off + 1);
+
+	/* offset around data-hole boundary */
+	off = bufsz * 2;
+	ret += do_lseek(testnum, 11, fd, SEEK_HOLE, off - 1, off);
+	ret += do_lseek(testnum, 12, fd, SEEK_DATA, off - 1, off - 1);
+	ret += do_lseek(testnum, 13, fd, SEEK_HOLE, off,     off);
+	ret += do_lseek(testnum, 14, fd, SEEK_DATA, off,     bufsz * 3);
+	ret += do_lseek(testnum, 15, fd, SEEK_HOLE, off + 1, off + 1);
+	ret += do_lseek(testnum, 16, fd, SEEK_DATA, off + 1, bufsz * 3);
+
+	/* offset around second hole-data boundary */
+	off = bufsz * 3;
+	ret += do_lseek(testnum, 17, fd, SEEK_HOLE, off - 1, off - 1);
+	ret += do_lseek(testnum, 18, fd, SEEK_DATA, off - 1, off);
+	ret += do_lseek(testnum, 19, fd, SEEK_HOLE, off,     filsz);
+	ret += do_lseek(testnum, 20, fd, SEEK_DATA, off,     off);
+	ret += do_lseek(testnum, 21, fd, SEEK_HOLE, off + 1, filsz);
+	ret += do_lseek(testnum, 22, fd, SEEK_DATA, off + 1, off + 1);
+
+	/* offset around the end of file */
+	off = filsz;
+	ret += do_lseek(testnum, 23, fd, SEEK_HOLE, off - 1, filsz);
+	ret += do_lseek(testnum, 24, fd, SEEK_DATA, off - 1, filsz - 1);
+	ret += do_lseek(testnum, 25, fd, SEEK_HOLE, off, -1);
+	ret += do_lseek(testnum, 26, fd, SEEK_DATA, off, -1);
+	ret += do_lseek(testnum, 27, fd, SEEK_HOLE, off + 1, -1);
+	ret += do_lseek(testnum, 28, fd, SEEK_DATA, off + 1, -1);
+
+out:
+	do_free(buf);
+	return ret;
+}
+
+/* test file with data at the beginning and a hole at the end */
+static int test05(int fd, int testnum)
+{
+	int ret = -1;
+	char *buf = NULL;
+	int bufsz = alloc_size;
+	int filsz = bufsz * 4;
+
+	if (flags & FS_NO_HOLES)
+		return 1;
+
+	/* DATA - HOLE */
+	/* Each unit is bufsz */
+
+	buf = do_malloc(bufsz);
+	if (!buf)
+		goto out;
+	memset(buf, 'a', bufsz);
+
+	ret = do_truncate(fd, filsz);
+	if (!ret)
+		ret = do_pwrite(fd, buf, bufsz, 0);
+	if (ret)
+		goto out;
+
+	/* offset at the beginning */
+	ret += do_lseek(testnum,  1, fd, SEEK_HOLE, 0, bufsz);
+	ret += do_lseek(testnum,  2, fd, SEEK_HOLE, 1, bufsz);
+	ret += do_lseek(testnum,  3, fd, SEEK_DATA, 0, 0);
+	ret += do_lseek(testnum,  4, fd, SEEK_DATA, 1, 1);
+
+	/* offset around data-hole boundary */
+	ret += do_lseek(testnum,  5, fd, SEEK_HOLE, bufsz - 1, bufsz);
+	ret += do_lseek(testnum,  6, fd, SEEK_DATA, bufsz - 1, bufsz - 1);
+	ret += do_lseek(testnum,  7, fd, SEEK_HOLE, bufsz,     bufsz);
+	ret += do_lseek(testnum,  8, fd, SEEK_DATA, bufsz,     -1);
+	ret += do_lseek(testnum,  9, fd, SEEK_HOLE, bufsz + 1, bufsz + 1);
+	ret += do_lseek(testnum, 10, fd, SEEK_DATA, bufsz + 1, -1);
+
+	/* offset around eof */
+	ret += do_lseek(testnum, 11, fd, SEEK_HOLE, filsz - 1, filsz - 1);
+	ret += do_lseek(testnum, 12, fd, SEEK_DATA, filsz - 1, -1);
+	ret += do_lseek(testnum, 13, fd, SEEK_HOLE, filsz,     -1);
+	ret += do_lseek(testnum, 14, fd, SEEK_DATA, filsz,     -1);
+	ret += do_lseek(testnum, 15, fd, SEEK_HOLE, filsz + 1, -1);
+	ret += do_lseek(testnum, 16, fd, SEEK_DATA, filsz + 1, -1);
+
+out:
+	do_free(buf);
+	return ret;
+}
+
+/* test hole begin and data end */
+static int test04(int fd, int testnum)
+{
+	int ret;
+	char *buf = "ABCDEFGH";
+	int bufsz = sizeof(buf);
+	int holsz = alloc_size * 2;
+	int filsz = holsz + bufsz;
+
+	if (flags & FS_NO_HOLES)
+		return 1;
+
+	/* HOLE - DATA */
+
+	ret = do_pwrite(fd, buf, bufsz, holsz);
+	if (ret)
+		goto out;
+
+	/* offset at the beginning */
+	ret += do_lseek(testnum,  1, fd, SEEK_HOLE, 0, 0);
+	ret += do_lseek(testnum,  2, fd, SEEK_HOLE, 1, 1);
+	ret += do_lseek(testnum,  3, fd, SEEK_DATA, 0, holsz);
+	ret += do_lseek(testnum,  4, fd, SEEK_DATA, 1, holsz);
+
+	/* offset around hole-data boundary */
+	ret += do_lseek(testnum,  5, fd, SEEK_HOLE, holsz - 1, holsz - 1);
+	ret += do_lseek(testnum,  6, fd, SEEK_DATA, holsz - 1, holsz);
+	ret += do_lseek(testnum,  7, fd, SEEK_HOLE, holsz,     filsz);
+	ret += do_lseek(testnum,  8, fd, SEEK_DATA, holsz,     holsz);
+	ret += do_lseek(testnum,  9, fd, SEEK_HOLE, holsz + 1, filsz);
+	ret += do_lseek(testnum, 10, fd, SEEK_DATA, holsz + 1, holsz + 1);
+
+	/* offset around eof */
+	ret += do_lseek(testnum, 11, fd, SEEK_HOLE, filsz - 1, filsz);
+	ret += do_lseek(testnum, 12, fd, SEEK_DATA, filsz - 1, filsz - 1);
+	ret += do_lseek(testnum, 13, fd, SEEK_HOLE, filsz,     -1);
+	ret += do_lseek(testnum, 14, fd, SEEK_DATA, filsz,     -1);
+	ret += do_lseek(testnum, 15, fd, SEEK_HOLE, filsz + 1, -1);
+	ret += do_lseek(testnum, 16, fd, SEEK_DATA, filsz + 1, -1);
+out:
+	return ret;
+}
+
+/* test full file */
+static int test03(int fd, int testnum)
+{
+	char *buf = NULL;
+	int bufsz = alloc_size + 100;
+	int ret = -1;
+
+	buf = do_malloc(bufsz);
+	if (!buf)
+		goto out;
+	memset(buf, 'a', bufsz);
+
+	ret = do_pwrite(fd, buf, bufsz, 0);
+	if (ret)
+		goto out;
+
+	/* offset at the beginning */
+	ret += do_lseek(testnum,  1, fd, SEEK_HOLE, 0, bufsz);
+	ret += do_lseek(testnum,  2, fd, SEEK_HOLE, 1, bufsz);
+	ret += do_lseek(testnum,  3, fd, SEEK_DATA, 0, 0);
+	ret += do_lseek(testnum,  4, fd, SEEK_DATA, 1, 1);
+
+	/* offset around eof */
+	ret += do_lseek(testnum,  5, fd, SEEK_HOLE, bufsz - 1, bufsz);
+	ret += do_lseek(testnum,  6, fd, SEEK_DATA, bufsz - 1, bufsz - 1);
+	ret += do_lseek(testnum,  7, fd, SEEK_HOLE, bufsz,     -1);
+	ret += do_lseek(testnum,  8, fd, SEEK_DATA, bufsz,     -1);
+	ret += do_lseek(testnum,  9, fd, SEEK_HOLE, bufsz + 1, -1);
+	ret += do_lseek(testnum, 10, fd, SEEK_DATA, bufsz + 1, -1);
+
+out:
+	do_free(buf);
+	return ret;
+}
+
+/* test empty file */
+static int test02(int fd, int testnum)
+{
+	int ret = 0;
+
+	ret += do_lseek(testnum, 1, fd, SEEK_DATA, 0, -1);
+	ret += do_lseek(testnum, 2, fd, SEEK_HOLE, 0, -1);
+	ret += do_lseek(testnum, 3, fd, SEEK_HOLE, 1, -1);
+
+	return ret;
+}
+
+/* test feature support */
+static int test01(int fd, int testnum)
+{
+	int ret;
+	char buf[] = "ABCDEFGH";
+	int bufsz = sizeof(buf);
+
+	ret = do_pwrite(fd, buf, bufsz, 0);
+	if (ret)
+		goto out;
+
+	ret += do_lseek(testnum, 1, fd, SEEK_DATA, 0, 0);
+	ret += do_lseek(testnum, 2, fd, SEEK_HOLE, 0, bufsz);
+
+out:
+	return ret;
+}
+
+struct testrec {
+	int	test_num;
+	int	(*test_func)(int fd, int testnum);
+	char	*test_desc;
+};
+
+struct testrec seek_tests[] = {
+	{  1, test01, "Test basic support" },
+	{  2, test02, "Test an empty file" },
+	{  3, test03, "Test a full file" },
+	{  4, test04, "Test file hole at beg, data at end" },
+	{  5, test05, "Test file data at beg, hole at end" },
+	{  6, test06, "Test file hole data hole data" },
+};
+
+static int run_test(int fd, struct testrec *tr)
+{
+	int ret;
+
+	ret = tr->test_func(fd, tr->test_num);
+	if (!(flags & QUIET))
+		printf("%02d. %-50s\t%s\n", tr->test_num, tr->test_desc,
+		       ret < 0 ? "FAIL" : (ret == 0 ? "SUCC" : "NOT RUN"));
+	return ret;
+}
+
+void print_help()
+{
+	printf("seek-test [-h] [-q] filename\n");
+	printf("\t-h - this message\n");
+	printf("\t-q - quiet, no output\n");
+	printf("\tfilename - file to use for the test\n");
+}
+
+int main(int argc, char **argv)
+{
+	int ret = -1;
+	int i, fd = -1;
+	int c;
+	int numtests = sizeof(seek_tests) / sizeof(struct testrec);
+
+	while ((c = getopt(argc, argv, "qh")) != -1) {
+		switch (c) {
+		case 'q':
+			flags |= QUIET;
+			break;
+		case 'h':
+			print_help();
+			exit(0);
+		default:
+			print_help();
+			exit(1);
+		}
+	}
+
+	if (optind >= argc) {
+		print_help();
+		exit(1);
+	}
+
+	fd = open(argv[optind], O_RDWR|O_CREAT|O_TRUNC, 0644);
+	if (fd < 0) {
+		fprintf(stderr, "Failed to open testfile: %d\n", errno);
+		goto out;
+	}
+
+	ret = get_io_sizes(fd);
+	if (ret)
+		goto out;
+
+	ret = get_flags(fd);
+	if (ret)
+		goto out;
+
+	for (i = 0; i < numtests; ++i) {
+		ret = do_truncate(fd, 0);
+		if (ret)
+			goto out;
+		run_test(fd, &seek_tests[i]);
+	}
+
+out:
+	if (fd > -1)
+		close(fd);
+	return ret;
+}
-- 
1.7.5.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
