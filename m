Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1JEiiTR254426 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 08:44:44 -0600
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id hxeIovPbAvcpAda6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 06:44:41 -0800 (PST)
Message-ID: <4F410ABF.7070001@oracle.com>
Date: Sun, 19 Feb 2012 22:44:15 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v3 1/2] xfstests: introduce 279 for SEEK_DATA/SEEK_HOLE sanity
	test
Reply-To: jeff.liu@oracle.com
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
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

Introduce 279 for SEEK_DATA/SEEK_HOLE sanity tests.

Changes to v3:
--------------
* Redirect seek sanity test run log to 279.full.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 279                    |   58 ++++
 279.full               |  116 ++++++++
 279.out                |    1 +
 group                  |    1 +
 src/Makefile           |    2 +-
 src/seek_sanity_test.c |  683 ++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 860 insertions(+), 1 deletions(-)
 create mode 100755 279
 create mode 100644 279.full
 create mode 100644 279.out
 create mode 100644 src/seek_sanity_test.c

diff --git a/279 b/279
new file mode 100755
index 0000000..b9e9cc3
--- /dev/null
+++ b/279
@@ -0,0 +1,58 @@
+#! /bin/bash
+# FS QA Test No. 279
+#
+# SEEK_DATA/SEEK_HOLE sanity tests.
+#
+# Improved by Jeff.liu@oracle.com
+# Creater: josef@redhat.com
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Oracle Inc.  All Rights Reserved.
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
+#-----------------------------------------------------------------------
+#
+# creator
+owner=jeff.liu@oracle.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+_supported_fs generic
+_supported_os Linux
+
+BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
+
+[ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
+
+_cleanup()
+{
+	eval "rm -f $BASE_TEST_FILE.*"
+}
+
+$here/src/seek_sanity_test $BASE_TEST_FILE > $seq.full 2>&1 ||
+	_fail "seek sanity check failed!"
+
+# success, all done
+status=0
+exit
diff --git a/279.full b/279.full
new file mode 100644
index 0000000..f384aab
--- /dev/null
+++ b/279.full
@@ -0,0 +1,116 @@
+File system supports the default behavior.
+File system magic#: 0x58465342
+Allocation size: 4096
+
+01. Test empty file                                   
+01.01 SEEK_DATA expected -1 with errno -6, got -6.                succ
+01.02 SEEK_HOLE expected -1 with errno -6, got -6.                succ
+01.03 SEEK_HOLE expected -1 with errno -6, got -6.                succ
+
+02. Test a tiny full file                             
+02.01 SEEK_HOLE expected 8 or 8, got 8.                           succ
+02.02 SEEK_DATA expected 0 or 0, got 0.                           succ
+02.03 SEEK_DATA expected 1 or 1, got 1.                           succ
+02.04 SEEK_HOLE expected 8 or 8, got 8.                           succ
+02.05 SEEK_DATA expected 7 or 7, got 7.                           succ
+02.06 SEEK_HOLE expected -1 with errno -6, got -6.                succ
+02.07 SEEK_DATA expected -1 with errno -6, got -6.                succ
+02.08 SEEK_HOLE expected -1 with errno -6, got -6.                succ
+02.09 SEEK_DATA expected -1 with errno -6, got -6.                succ
+
+03. Test a larger full file                           
+03.01 SEEK_HOLE expected 8292 or 8292, got 8292.                  succ
+03.02 SEEK_HOLE expected 8292 or 8292, got 8292.                  succ
+03.03 SEEK_DATA expected 0 or 0, got 0.                           succ
+03.04 SEEK_DATA expected 1 or 1, got 1.                           succ
+03.05 SEEK_HOLE expected 8292 or 8292, got 8292.                  succ
+03.06 SEEK_DATA expected 8291 or 8291, got 8291.                  succ
+03.07 SEEK_HOLE expected -1 with errno -6, got -6.                succ
+03.08 SEEK_DATA expected -1 with errno -6, got -6.                succ
+03.09 SEEK_HOLE expected -1 with errno -6, got -6.                succ
+03.10 SEEK_DATA expected -1 with errno -6, got -6.                succ
+
+04. Test file hole at beg, data at end                
+04.01 SEEK_HOLE expected 0 or 8200, got 0.                        succ
+04.02 SEEK_HOLE expected 1 or 8200, got 1.                        succ
+04.03 SEEK_DATA expected 8192 or 0, got 8192.                     succ
+04.04 SEEK_DATA expected 8192 or 1, got 8192.                     succ
+04.05 SEEK_HOLE expected 8191 or 8200, got 8191.                  succ
+04.06 SEEK_DATA expected 8192 or 8191, got 8192.                  succ
+04.07 SEEK_HOLE expected 8200 or 8200, got 8200.                  succ
+04.08 SEEK_DATA expected 8192 or 8192, got 8192.                  succ
+04.09 SEEK_HOLE expected 8200 or 8200, got 8200.                  succ
+04.10 SEEK_DATA expected 8193 or 8193, got 8193.                  succ
+04.11 SEEK_HOLE expected 8200 or 8200, got 8200.                  succ
+04.12 SEEK_DATA expected 8199 or 8199, got 8199.                  succ
+04.13 SEEK_HOLE expected -1 with errno -6, got -6.                succ
+04.14 SEEK_DATA expected -1 with errno -6, got -6.                succ
+04.15 SEEK_HOLE expected -1 with errno -6, got -6.                succ
+04.16 SEEK_DATA expected -1 with errno -6, got -6.                succ
+
+05. Test file data at beg, hole at end                
+05.01 SEEK_HOLE expected 4096 or 16384, got 4096.                 succ
+05.02 SEEK_HOLE expected 4096 or 16384, got 4096.                 succ
+05.03 SEEK_DATA expected 0 or 0, got 0.                           succ
+05.04 SEEK_DATA expected 1 or 1, got 1.                           succ
+05.05 SEEK_HOLE expected 4096 or 16384, got 4096.                 succ
+05.06 SEEK_DATA expected 4095 or 4095, got 4095.                  succ
+05.07 SEEK_HOLE expected 4096 or 16384, got 4096.                 succ
+05.08 SEEK_DATA expected -1 with errno -6, got -6.                succ
+05.09 SEEK_HOLE expected 4097 or 16384, got 4097.                 succ
+05.10 SEEK_DATA expected -1 with errno -6, got -6.                succ
+05.11 SEEK_HOLE expected 16383 or 16384, got 16383.               succ
+05.12 SEEK_DATA expected -1 with errno -6, got -6.                succ
+05.13 SEEK_HOLE expected -1 with errno -6, got -6.                succ
+05.14 SEEK_DATA expected -1 with errno -6, got -6.                succ
+05.15 SEEK_HOLE expected -1 with errno -6, got -6.                succ
+05.16 SEEK_DATA expected -1 with errno -6, got -6.                succ
+
+06. Test file hole data hole data                     
+06.01 SEEK_HOLE expected 0 or 16384, got 0.                       succ
+06.02 SEEK_HOLE expected 1 or 16384, got 1.                       succ
+06.03 SEEK_DATA expected 4096 or 0, got 4096.                     succ
+06.04 SEEK_DATA expected 4096 or 1, got 4096.                     succ
+06.05 SEEK_HOLE expected 4095 or 16384, got 4095.                 succ
+06.06 SEEK_DATA expected 4096 or 4095, got 4096.                  succ
+06.07 SEEK_HOLE expected 8192 or 16384, got 16384.                succ
+06.08 SEEK_DATA expected 4096 or 4096, got 4096.                  succ
+06.09 SEEK_HOLE expected 8192 or 16384, got 16384.                succ
+06.10 SEEK_DATA expected 4097 or 4097, got 4097.                  succ
+06.11 SEEK_HOLE expected 8192 or 16384, got 16384.                succ
+06.12 SEEK_DATA expected 8191 or 8191, got 8191.                  succ
+06.13 SEEK_HOLE expected 8192 or 16384, got 16384.                succ
+06.14 SEEK_DATA expected 12288 or 8192, got 8192.                 succ
+06.15 SEEK_HOLE expected 8193 or 16384, got 16384.                succ
+06.16 SEEK_DATA expected 12288 or 8193, got 8193.                 succ
+06.17 SEEK_HOLE expected 12287 or 16384, got 16384.               succ
+06.18 SEEK_DATA expected 12288 or 12287, got 12287.               succ
+06.19 SEEK_HOLE expected 16384 or 16384, got 16384.               succ
+06.20 SEEK_DATA expected 12288 or 12288, got 12288.               succ
+06.21 SEEK_HOLE expected 16384 or 16384, got 16384.               succ
+06.22 SEEK_DATA expected 12289 or 12289, got 12289.               succ
+06.23 SEEK_HOLE expected 16384 or 16384, got 16384.               succ
+06.24 SEEK_DATA expected 16383 or 16383, got 16383.               succ
+06.25 SEEK_HOLE expected -1 with errno -6, got -6.                succ
+06.26 SEEK_DATA expected -1 with errno -6, got -6.                succ
+06.27 SEEK_HOLE expected -1 with errno -6, got -6.                succ
+06.28 SEEK_DATA expected -1 with errno -6, got -6.                succ
+
+07. Test file with unwritten extents, only have dirty pages
+07.01 SEEK_HOLE expected 0 or 4194304, got 4194304.               succ
+07.02 SEEK_HOLE expected 1 or 4194304, got 4194304.               succ
+07.03 SEEK_DATA expected 40960 or 0, got 0.                       succ
+07.04 SEEK_DATA expected 40960 or 1, got 1.                       succ
+
+08. Test file with unwritten extents, only have unwritten pages
+08.01 SEEK_HOLE expected 0 or 4194304, got 4194304.               succ
+08.02 SEEK_HOLE expected 1 or 4194304, got 4194304.               succ
+08.03 SEEK_DATA expected 40960 or 0, got 0.                       succ
+08.04 SEEK_DATA expected 40960 or 1, got 1.                       succ
+
+09. Test file with unwritten extents, have both dirty && unwritten pages
+09.01 SEEK_HOLE expected 0 or 8388608, got 8388608.               succ
+09.02 SEEK_HOLE expected 1 or 8388608, got 8388608.               succ
+09.03 SEEK_DATA expected 40960 or 0, got 0.                       succ
+09.04 SEEK_DATA expected 40960 or 1, got 1.                       succ
+
diff --git a/279.out b/279.out
new file mode 100644
index 0000000..4f954fd
--- /dev/null
+++ b/279.out
@@ -0,0 +1 @@
+QA output created by 279
diff --git a/group b/group
index 08d999a..02c6743 100644
--- a/group
+++ b/group
@@ -389,3 +389,4 @@ deprecated
 273 auto rw
 274 auto rw
 275 auto rw
+279 auto rw
diff --git a/src/Makefile b/src/Makefile
index 67250ee..1c6e717 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -17,7 +17,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
-	stale_handle pwrite_mmap_blocked fstrim t_dir_offset2
+	stale_handle pwrite_mmap_blocked fstrim t_dir_offset2 seek_sanity_test
 
 SUBDIRS =
 
diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
new file mode 100644
index 0000000..8f36dee
--- /dev/null
+++ b/src/seek_sanity_test.c
@@ -0,0 +1,683 @@
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
+#include <sys/vfs.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <assert.h>
+
+#ifndef SEEK_DATA
+#define SEEK_DATA      3
+#define SEEK_HOLE      4
+#endif
+
+static blksize_t alloc_size;
+int default_behavior = 0;
+char *base_file_path;
+
+static void get_file_system(int fd)
+{
+	struct statfs buf;
+
+	if (!fstatfs(fd, &buf))
+		fprintf(stdout, "File system magic#: 0x%x\n", buf.f_type);
+}
+
+static int get_io_sizes(int fd)
+{
+       struct stat buf;
+       int ret;
+
+       ret = fstat(fd, &buf);
+       if (ret)
+               fprintf(stderr, "  ERROR %d: Failed to find io blocksize\n",
+                       errno);
+
+       /* st_blksize is typically also the allocation size */
+       alloc_size = buf.st_blksize;
+       fprintf(stdout, "Allocation size: %ld\n", alloc_size);
+
+       return ret;
+}
+
+#define do_free(x)     do { if(x) free(x); } while(0);
+
+static void *do_malloc(size_t size)
+{
+       void *buf;
+
+       buf = malloc(size);
+       if (!buf)
+               fprintf(stderr, "  ERROR: Unable to allocate %ld bytes\n",
+                       (long)size);
+
+       return buf;
+}
+
+static int do_truncate(int fd, off_t length)
+{
+       int ret;
+
+       ret = ftruncate(fd, length);
+       if (ret)
+               fprintf(stderr, "  ERROR %d: Failed to extend file "
+                       "to %ld bytes\n", errno, (long)length);
+       return ret;
+}
+
+static int do_fallocate(int fd, off_t offset, off_t length, int mode)
+{
+	int ret;
+
+	ret = fallocate(fd, mode, offset, length);
+	if (ret)
+		fprintf(stderr, "  ERROR %d: Failed to preallocate "
+			"space to %ld bytes\n", errno, (long) length);
+
+	return ret;
+}
+
+/*
+ * Synchnorize all dirty pages in the file range starting from
+ * offset to nbytes length.
+ */
+static int do_sync_dirty_pages(int fd, off64_t offset, off64_t nbytes)
+{
+	int ret;
+
+	ret = sync_file_range(fd, offset, nbytes, SYNC_FILE_RANGE_WRITE);
+	if (ret)
+		fprintf(stderr, "  ERROR %d: Failed to sync out dirty "
+			"pages\n", errno);
+
+	return ret;
+}
+
+static ssize_t do_pwrite(int fd, const void *buf, size_t count, off_t offset)
+{
+       ssize_t ret, written = 0;
+
+       while (count > written) {
+               ret = pwrite(fd, buf + written, count - written, offset + written);
+               if (ret < 0) {
+                       fprintf(stderr, "  ERROR %d: Failed to write %ld "
+                               "bytes\n", errno, (long)count);
+                       return ret;
+               }
+               written += ret;
+       }
+
+       return 0;
+}
+
+#define do_close(x)	do { if ((x) > -1) close(x); } while(0);
+
+static int do_create(const char *filename)
+{
+	int fd;
+
+	fd = open(filename, O_RDWR|O_CREAT|O_TRUNC, 0644);
+	if (fd < 0)
+		fprintf(stderr, " ERROR %d: Failed to create file '%s'\n",
+			errno, filename);
+
+	return fd;
+}
+
+static int do_lseek(int testnum, int subtest, int fd, int filsz, int origin,
+		    off_t set, off_t exp)
+{
+	off_t pos, exp2;
+	int x, ret;
+
+	assert(!(origin != SEEK_HOLE && origin != SEEK_DATA));
+
+	/*
+	 * The file pointer can be set to different values depending
+	 * on the implementation. For SEEK_HOLE, EOF could be a valid
+	 * value. For SEEK_DATA, supplied offset could be the valid
+	 * value.
+	 */
+	exp2 = exp;
+	if (origin == SEEK_HOLE && exp2 != -1)
+		exp2 = filsz;
+	if (origin == SEEK_DATA && default_behavior && set < filsz)
+		exp2 = set;
+
+	pos = lseek(fd, set, origin);
+
+	if (pos == -1 && exp == -1) {
+		x = fprintf(stdout, "%02d.%02d %s expected -1 with errno %d, got %d. ",
+			    testnum, subtest,
+			    (origin == SEEK_HOLE) ? "SEEK_HOLE" : "SEEK_DATA",
+			    -ENXIO, -errno);
+		ret = !(errno == ENXIO);
+	} else {
+
+		x = fprintf(stdout, "%02d.%02d %s expected %ld or %ld, got %ld. ",
+			    testnum, subtest,
+			    (origin == SEEK_HOLE) ? "SEEK_HOLE" : "SEEK_DATA",
+			    (long)exp, (long)exp2, (long)pos);
+		ret = !(pos == exp || pos == exp2);
+	}
+
+	fprintf(stdout, "%*s\n", (70 - x), ret ? "FAIL" : "succ");
+
+	return ret;
+}
+
+/*
+ * test file with unwritten extents, have both dirty and
+ * writeback pages in page cache.
+ */
+static int test09(int fd, int testnum)
+{
+	int ret = 0;
+	char *buf = NULL;
+	int bufsz = alloc_size;
+	int filsz = 8 << 20;
+
+	/*
+	 * HOLE - unwritten DATA in dirty page - HOLE -
+	 * unwritten DATA in writeback page
+	 */
+
+	/* Each unit is bufsz */
+	buf = do_malloc(bufsz);
+	if (!buf)
+		goto out;
+	memset(buf, 'a', bufsz);
+
+	/* preallocate 8M space to file */
+	ret = do_fallocate(fd, 0, filsz, 0);
+	if (ret < 0)
+		goto out;
+
+	ret = do_pwrite(fd, buf, bufsz, bufsz * 10);
+	if (!ret) {
+		ret = do_pwrite(fd, buf, bufsz, bufsz * 100);
+		if (ret)
+			goto out;
+	}
+
+	/*
+	 * Sync out dirty pages from bufsz * 100, this will convert
+	 * the dirty page to writeback.
+	 */
+	ret = do_sync_dirty_pages(fd, bufsz * 100, 0);
+	if (ret)
+		goto out;
+
+	/* offset at the beginning */
+	ret += do_lseek(testnum,  1, fd, filsz, SEEK_HOLE, 0, 0);
+	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 1, 1);
+	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, 0, bufsz * 10);
+	ret += do_lseek(testnum,  4, fd, filsz, SEEK_DATA, 1, bufsz * 10);
+
+out:
+	do_free(buf);
+	return ret;
+}
+
+/* test file with unwritten extent, only have writeback page */
+static int test08(int fd, int testnum)
+{
+	int ret = 0;
+	char *buf = NULL;
+	int bufsz = alloc_size;
+	int filsz = 4 << 20;
+
+	/* HOLE - unwritten DATA in writeback page */
+	/* Each unit is bufsz */
+	buf = do_malloc(bufsz);
+	if (!buf)
+		goto out;
+	memset(buf, 'a', bufsz);
+
+	/* preallocate 4M space to file */
+	ret = do_fallocate(fd, 0, filsz, 0);
+	if (ret < 0)
+		goto out;
+
+	ret = do_pwrite(fd, buf, bufsz, bufsz * 10);
+	if (ret)
+		goto out;
+
+	/* Sync out all file */
+	ret = do_sync_dirty_pages(fd, 0, 0);
+	if (ret)
+		goto out;
+
+	/* offset at the beginning */
+	ret += do_lseek(testnum,  1, fd, filsz, SEEK_HOLE, 0, 0);
+	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 1, 1);
+	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, 0, bufsz * 10);
+	ret += do_lseek(testnum,  4, fd, filsz, SEEK_DATA, 1, bufsz * 10);
+
+out:
+	do_free(buf);
+	return ret;
+}
+
+/*
+ * test file with unwritten extents, only have dirty pages
+ * in page cache.
+ */
+static int test07(int fd, int testnum)
+{
+	int ret = 0;
+	char *buf = NULL;
+	int bufsz = alloc_size;
+	int filsz = 4 << 20;
+
+	/* HOLE - unwritten DATA in dirty page */
+	/* Each unit is bufsz */
+	buf = do_malloc(bufsz);
+	if (!buf)
+		goto out;
+	memset(buf, 'a', bufsz);
+
+	/* preallocate 4M space to file */
+	ret = do_fallocate(fd, 0, filsz, 0);
+	if (ret < 0)
+		goto out;
+
+	ret = do_pwrite(fd, buf, bufsz, bufsz * 10);
+	if (ret)
+		goto out;
+
+	/* offset at the beginning */
+	ret += do_lseek(testnum,  1, fd, filsz, SEEK_HOLE, 0, 0);
+	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 1, 1);
+	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, 0, bufsz * 10);
+	ret += do_lseek(testnum,  4, fd, filsz, SEEK_DATA, 1, bufsz * 10);
+
+out:
+	do_free(buf);
+	return ret;
+}
+
+/* test hole data hole data */
+static int test06(int fd, int testnum)
+{
+	int ret = -1;
+	char *buf = NULL;
+	int bufsz = alloc_size;
+	int filsz = bufsz * 4;
+	int off;
+
+	/* HOLE - DATA - HOLE - DATA */
+	/* Each unit is bufsz */
+
+	buf = do_malloc(bufsz);
+	if (!buf)
+		goto out;
+
+	memset(buf, 'a', bufsz);
+
+	ret = do_pwrite(fd, buf, bufsz, bufsz);
+	if (!ret)
+		do_pwrite(fd, buf, bufsz, bufsz * 3);
+	if (ret)
+		goto out;
+
+	/* offset at the beginning */
+	ret += do_lseek(testnum,  1, fd, filsz, SEEK_HOLE, 0, 0);
+	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 1, 1);
+	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, 0, bufsz);
+	ret += do_lseek(testnum,  4, fd, filsz, SEEK_DATA, 1, bufsz);
+
+	/* offset around first hole-data boundary */
+	off = bufsz;
+	ret += do_lseek(testnum,  5, fd, filsz, SEEK_HOLE, off - 1, off - 1);
+	ret += do_lseek(testnum,  6, fd, filsz, SEEK_DATA, off - 1, off);
+	ret += do_lseek(testnum,  7, fd, filsz, SEEK_HOLE, off,     bufsz * 2);
+	ret += do_lseek(testnum,  8, fd, filsz, SEEK_DATA, off,     off);
+	ret += do_lseek(testnum,  9, fd, filsz, SEEK_HOLE, off + 1, bufsz * 2);
+	ret += do_lseek(testnum, 10, fd, filsz, SEEK_DATA, off + 1, off + 1);
+
+	/* offset around data-hole boundary */
+	off = bufsz * 2;
+	ret += do_lseek(testnum, 11, fd, filsz, SEEK_HOLE, off - 1, off);
+	ret += do_lseek(testnum, 12, fd, filsz, SEEK_DATA, off - 1, off - 1);
+	ret += do_lseek(testnum, 13, fd, filsz, SEEK_HOLE, off,     off);
+	ret += do_lseek(testnum, 14, fd, filsz, SEEK_DATA, off,     bufsz * 3);
+	ret += do_lseek(testnum, 15, fd, filsz, SEEK_HOLE, off + 1, off + 1);
+	ret += do_lseek(testnum, 16, fd, filsz, SEEK_DATA, off + 1, bufsz * 3);
+
+	/* offset around second hole-data boundary */
+	off = bufsz * 3;
+	ret += do_lseek(testnum, 17, fd, filsz, SEEK_HOLE, off - 1, off - 1);
+	ret += do_lseek(testnum, 18, fd, filsz, SEEK_DATA, off - 1, off);
+	ret += do_lseek(testnum, 19, fd, filsz, SEEK_HOLE, off,     filsz);
+	ret += do_lseek(testnum, 20, fd, filsz, SEEK_DATA, off,     off);
+	ret += do_lseek(testnum, 21, fd, filsz, SEEK_HOLE, off + 1, filsz);
+	ret += do_lseek(testnum, 22, fd, filsz, SEEK_DATA, off + 1, off + 1);
+
+	/* offset around the end of file */
+	off = filsz;
+	ret += do_lseek(testnum, 23, fd, filsz, SEEK_HOLE, off - 1, filsz);
+	ret += do_lseek(testnum, 24, fd, filsz, SEEK_DATA, off - 1, filsz - 1);
+	ret += do_lseek(testnum, 25, fd, filsz, SEEK_HOLE, off, -1);
+	ret += do_lseek(testnum, 26, fd, filsz, SEEK_DATA, off, -1);
+	ret += do_lseek(testnum, 27, fd, filsz, SEEK_HOLE, off + 1, -1);
+	ret += do_lseek(testnum, 28, fd, filsz, SEEK_DATA, off + 1, -1);
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
+	/* |- DATA -|- HOLE -|- HOLE -|- HOLE -| */
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
+
+	ret += do_lseek(testnum,  1, fd, filsz, SEEK_HOLE, 0, bufsz);
+	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 1, bufsz);
+
+	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, 0, 0);
+	ret += do_lseek(testnum,  4, fd, filsz, SEEK_DATA, 1, 1);
+
+	/* offset around data-hole boundary */
+	ret += do_lseek(testnum,  5, fd, filsz, SEEK_HOLE, bufsz - 1, bufsz);
+	ret += do_lseek(testnum,  6, fd, filsz, SEEK_DATA, bufsz - 1, bufsz - 1);
+
+	ret += do_lseek(testnum,  7, fd, filsz, SEEK_HOLE, bufsz,     bufsz);
+	ret += do_lseek(testnum,  8, fd, filsz, SEEK_DATA, bufsz,     -1);
+	ret += do_lseek(testnum,  9, fd, filsz, SEEK_HOLE, bufsz + 1, bufsz + 1);
+	ret += do_lseek(testnum, 10, fd, filsz, SEEK_DATA, bufsz + 1, -1);
+
+	/* offset around eof */
+	ret += do_lseek(testnum, 11, fd, filsz, SEEK_HOLE, filsz - 1, filsz - 1);
+	ret += do_lseek(testnum, 12, fd, filsz, SEEK_DATA, filsz - 1, -1);
+	ret += do_lseek(testnum, 13, fd, filsz, SEEK_HOLE, filsz,     -1);
+	ret += do_lseek(testnum, 14, fd, filsz, SEEK_DATA, filsz,     -1);
+	ret += do_lseek(testnum, 15, fd, filsz, SEEK_HOLE, filsz + 1, -1);
+	ret += do_lseek(testnum, 16, fd, filsz, SEEK_DATA, filsz + 1, -1);
+out:
+	do_free(buf);
+	return ret;
+}
+/* test hole begin and data end */
+static int test04(int fd, int testnum)
+{
+	int ret;
+	char *buf = "ABCDEFGH";
+	int bufsz, holsz, filsz;
+
+	bufsz = strlen(buf);
+	holsz = alloc_size * 2;
+	filsz = holsz + bufsz;
+
+	/* |- HOLE -|- HOLE -|- DATA -| */
+
+	ret = do_pwrite(fd, buf, bufsz, holsz);
+	if (ret)
+		goto out;
+
+	/* offset at the beginning */
+	ret += do_lseek(testnum,  1, fd, filsz, SEEK_HOLE, 0, 0);
+	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 1, 1);
+	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, 0, holsz);
+	ret += do_lseek(testnum,  4, fd, filsz, SEEK_DATA, 1, holsz);
+	/* offset around hole-data boundary */
+	ret += do_lseek(testnum,  5, fd, filsz, SEEK_HOLE, holsz - 1, holsz - 1);
+	ret += do_lseek(testnum,  6, fd, filsz, SEEK_DATA, holsz - 1, holsz);
+	ret += do_lseek(testnum,  7, fd, filsz, SEEK_HOLE, holsz,     filsz);
+	ret += do_lseek(testnum,  8, fd, filsz, SEEK_DATA, holsz,     holsz);
+	ret += do_lseek(testnum,  9, fd, filsz, SEEK_HOLE, holsz + 1, filsz);
+	ret += do_lseek(testnum, 10, fd, filsz, SEEK_DATA, holsz + 1, holsz + 1);
+
+	/* offset around eof */
+	ret += do_lseek(testnum, 11, fd, filsz, SEEK_HOLE, filsz - 1, filsz);
+	ret += do_lseek(testnum, 12, fd, filsz, SEEK_DATA, filsz - 1, filsz - 1);
+	ret += do_lseek(testnum, 13, fd, filsz, SEEK_HOLE, filsz,     -1);
+	ret += do_lseek(testnum, 14, fd, filsz, SEEK_DATA, filsz,     -1);
+	ret += do_lseek(testnum, 15, fd, filsz, SEEK_HOLE, filsz + 1, -1);
+	ret += do_lseek(testnum, 16, fd, filsz, SEEK_DATA, filsz + 1, -1);
+out:
+	return ret;
+}
+
+/* test a larger full file */
+static int test03(int fd, int testnum)
+{
+	char *buf = NULL;
+	int bufsz = alloc_size * 2 + 100;
+	int filsz = bufsz;
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
+	ret += do_lseek(testnum,  1, fd, filsz, SEEK_HOLE, 0, bufsz);
+	ret += do_lseek(testnum,  2, fd, filsz, SEEK_HOLE, 1, bufsz);
+	ret += do_lseek(testnum,  3, fd, filsz, SEEK_DATA, 0, 0);
+	ret += do_lseek(testnum,  4, fd, filsz, SEEK_DATA, 1, 1);
+
+	/* offset around eof */
+	ret += do_lseek(testnum,  5, fd, filsz, SEEK_HOLE, bufsz - 1, bufsz);
+	ret += do_lseek(testnum,  6, fd, filsz, SEEK_DATA, bufsz - 1, bufsz - 1);
+	ret += do_lseek(testnum,  7, fd, filsz, SEEK_HOLE, bufsz,     -1);
+	ret += do_lseek(testnum,  8, fd, filsz, SEEK_DATA, bufsz,     -1);
+	ret += do_lseek(testnum,  9, fd, filsz, SEEK_HOLE, bufsz + 1, -1);
+	ret += do_lseek(testnum, 10, fd, filsz, SEEK_DATA, bufsz + 1, -1);
+
+out:
+	do_free(buf);
+	return ret;
+}
+
+/* test tiny full file */
+static int test02(int fd, int testnum)
+{
+	int ret;
+	char buf[] = "ABCDEFGH";
+	int bufsz, filsz;
+
+	bufsz = strlen(buf);
+	filsz = bufsz;
+
+	/* |- DATA -| */
+
+	ret = do_pwrite(fd, buf, bufsz, 0);
+	if (ret)
+		goto out;
+
+	ret += do_lseek(testnum, 1, fd, filsz, SEEK_HOLE, 0, filsz);
+	ret += do_lseek(testnum, 2, fd, filsz, SEEK_DATA, 0, 0);
+	ret += do_lseek(testnum, 3, fd, filsz, SEEK_DATA, 1, 1);
+	ret += do_lseek(testnum, 4, fd, filsz, SEEK_HOLE, bufsz - 1, filsz);
+	ret += do_lseek(testnum, 5, fd, filsz, SEEK_DATA, bufsz - 1, bufsz - 1);
+	ret += do_lseek(testnum, 6, fd, filsz, SEEK_HOLE, bufsz,     -1);
+	ret += do_lseek(testnum, 7, fd, filsz, SEEK_DATA, bufsz,     -1);
+	ret += do_lseek(testnum, 8, fd, filsz, SEEK_HOLE, bufsz + 1, -1);
+	ret += do_lseek(testnum, 9, fd, filsz, SEEK_DATA, bufsz + 1, -1);
+
+out:
+	return ret;
+}
+
+/* test empty file */
+static int test01(int fd, int testnum)
+{
+	int ret = 0;
+
+	ret += do_lseek(testnum, 1, fd, 0, SEEK_DATA, 0, -1);
+	ret += do_lseek(testnum, 2, fd, 0, SEEK_HOLE, 0, -1);
+	ret += do_lseek(testnum, 3, fd, 0, SEEK_HOLE, 1, -1);
+
+	return ret;
+}
+
+struct testrec {
+       int     test_num;
+       int     (*test_func)(int fd, int testnum);
+       char    *test_desc;
+};
+
+struct testrec seek_tests[] = {
+       {  1, test01, "Test empty file" },
+       {  2, test02, "Test a tiny full file" },
+       {  3, test03, "Test a larger full file" },
+       {  4, test04, "Test file hole at beg, data at end" },
+       {  5, test05, "Test file data at beg, hole at end" },
+       {  6, test06, "Test file hole data hole data" },
+       {  7, test07, "Test file with unwritten extents, only have dirty pages" },
+       {  8, test08, "Test file with unwritten extents, only have unwritten pages" },
+       {  9, test09, "Test file with unwritten extents, have both dirty && unwritten pages" },
+};
+
+static int run_test(struct testrec *tr)
+{
+	int ret = 0, fd = -1;
+	char filename[255];
+
+	snprintf(filename, sizeof(filename), "%s%02d", base_file_path, tr->test_num);
+
+	fd = do_create(filename);
+	if (fd > -1) {
+		printf("%02d. %-50s\n", tr->test_num, tr->test_desc);
+		ret = tr->test_func(fd, tr->test_num);
+		printf("\n");
+	}
+
+	do_close(fd);
+	return ret;
+}
+
+static int test_basic_support(void)
+{
+	int ret = -1, fd;
+	off_t pos;
+	char *buf = NULL;
+	int bufsz, filsz;
+
+	fd = do_create(base_file_path);
+	if (fd == -1)
+		goto out;
+
+	get_file_system(fd);
+
+	ret = get_io_sizes(fd);
+	if (ret)
+		goto out;
+
+	bufsz = alloc_size * 2;
+	filsz = bufsz * 2;
+
+	buf = do_malloc(bufsz);
+	if (!buf)
+		goto out;
+	memset(buf, 'a', bufsz);
+
+	/* File with 2 allocated blocks.... */
+	ret = do_pwrite(fd, buf, bufsz, 0);
+	if (ret)
+		goto out;
+
+	/* followed by a hole... */
+	ret = do_truncate(fd, filsz);
+	if (ret)
+		goto out;
+
+	/* Is SEEK_DATA and SEEK_HOLE supported in the kernel? */
+	pos = lseek(fd, 0, SEEK_DATA);
+	if (pos != -1)
+		pos = lseek(fd, 0, SEEK_HOLE);
+	if (pos == -1) {
+		fprintf(stderr, "Kernel does not support llseek(2) extensions "
+			"SEEK_HOLE and/or SEEK_DATA. Aborting.\n");
+		ret = -1;
+		goto out;
+	}
+
+	if (pos == filsz) {
+		default_behavior = 1;
+		fprintf(stderr, "File system supports the default behavior.\n");
+	}
+
+	printf("\n");
+
+out:
+	do_free(buf);
+	do_close(fd);
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+	int ret = -1;
+	int i = 0;
+	int numtests = sizeof(seek_tests) / sizeof(struct testrec);
+
+	if (argc != 2) {
+		fprintf(stdout, "Usage: %s base_file_path\n", argv[0]);
+		return ret;
+	}
+
+	base_file_path = (char *)strdup(argv[1]);
+
+	ret = test_basic_support();
+	if (ret)
+		goto out;
+
+	for (i = 0; i < numtests; ++i) {
+		if (ret)
+			goto out;
+		run_test(&seek_tests[i]);
+	}
+
+out:
+	free(base_file_path);
+	return ret;
+}
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
