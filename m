Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1JEq3ST254724 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 08:52:03 -0600
Message-ID: <4F410C7F.7090702@oracle.com>
Date: Sun, 19 Feb 2012 22:51:43 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v3 2/2] xfstests: introduce 280 for SEEK_DATA/SEEK_HOLE copy
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
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>

Introduce 280 for SEEK_DATA/SEEK_HOLE copy tests.

Thanks Dave's suggestions for V2. :)

Changes to v3:
--------------
* Using xfs_io(8) to create sparse file, seek_copy_test was modified to only do extents copy accordingly.
* Redirect xfs_io(8) output to 280.full.
* Supplied two test cases for now.  The first test case is focus on copy a sparse file with written data and hole extents.
  The 2nd test case is focus on copy a sparse file with written, unwritten data as well as hole extents.
  I would continue to improve this tests when implementing the unwritten extents probe routine.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 280                  |  114 +++++++++++++++++++++++
 280.full             |   70 ++++++++++++++
 280.out              |    1 +
 group                |    1 +
 src/Makefile         |    3 +-
 src/seek_copy_test.c |  252 ++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 440 insertions(+), 1 deletions(-)
 create mode 100755 280
 create mode 100644 280.full
 create mode 100644 280.out
 create mode 100644 src/seek_copy_test.c

diff --git a/280 b/280
new file mode 100755
index 0000000..0cbe5fe
--- /dev/null
+++ b/280
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FS QA Test No. 280
+#
+# SEEK_DATA/SEEK_HOLE copy tests.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Oracle Inc.  All Rights Reserved.
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
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+src=$TEST_DIR/seek_copy_testfile
+dest=$TEST_DIR/seek_copy_testfile.dest
+
+[ -x $here/src/seek_copy_test ] || _notrun "seek_copy_test not built"
+
+_cleanup()
+{
+	rm -f $src $dest
+}
+
+# seek_copy_test_01: tests file with holes and written data extents.
+# verify results:
+# 1. file size is identical.
+# 2. perform cmp(1) to compare SRC and DEST file byte by byte.
+test01()
+{
+	rm -f $src $dest
+
+	write_cmd="-c \"truncate 100m\""
+	for i in $(seq 0 5 100); do
+		offset=$(($i * $((1 << 20))))
+		write_cmd="$write_cmd -c \"pwrite $offset 1m\""
+	done
+
+	echo "*** test01() create sparse file ***" >>$seq.full
+	eval ${XFS_IO_PROG} -F -f "${write_cmd}" $src >>$seq.full 2>&1 ||
+		_fail "create sparse file failed!"
+	echo "*** test01() create sparse file done ***" >>$seq.full
+	echo >>$seq.full
+
+	$here/src/seek_copy_test $src $dest
+	
+	test $(stat --printf "%s" $src) = $(stat --printf "%s" $dest) ||
+		_fail "TEST01: file size check failed"
+
+	cmp $src $dest || _fail "TEST01: file bytes check failed"
+}
+
+# seek_copy_test_02 - tests file with holes, written and unwritten extents.
+# verify results:
+# 1. file size is identical.
+# 2. perform cmp(1) to compare SRC and DEST file byte by byte.
+test02()
+{
+	rm -rf $src $dest
+
+	write_cmd="-c \"truncate 200m\""
+	for i in $(seq 0 10 100); do
+		offset=$(($((6 << 20)) + $i * $((1 << 20))))
+		write_cmd="$write_cmd -c \"falloc $offset 3m\" -c \"pwrite $offset 1m\""
+	done
+
+	echo "*** test02() create sparse file ***" >>$seq.full
+	eval ${XFS_IO_PROG} -F -f "${write_cmd}" $src >>$seq.full 2>&1 ||
+		_fail "create sparse file failed!"
+	echo "*** test02() create sparse file done ***" >>$seq.full
+	echo >>$seq.full
+
+	$here/src/seek_copy_test $src $dest
+
+	test $(stat --printf "%s" $src) = $(stat --printf "%s" $dest) ||
+		_fail "TEST02: file size check failed"
+
+	cmp $src $dest || _fail "TEST02: file bytes check failed"
+}
+
+rm -f $seq.full
+
+test01
+test02
+
+status=0
+exit
diff --git a/280.full b/280.full
new file mode 100644
index 0000000..a3aa779
--- /dev/null
+++ b/280.full
@@ -0,0 +1,70 @@
+*** test01() create sparse file ***
+wrote 1048576/1048576 bytes at offset 0
+1 MiB, 256 ops; 0.0000 sec (22.298 MiB/sec and 5708.1698 ops/sec)
+wrote 1048576/1048576 bytes at offset 5242880
+1 MiB, 256 ops; 0.0000 sec (25.217 MiB/sec and 6455.5175 ops/sec)
+wrote 1048576/1048576 bytes at offset 10485760
+1 MiB, 256 ops; 0.0000 sec (26.036 MiB/sec and 6665.2781 ops/sec)
+wrote 1048576/1048576 bytes at offset 15728640
+1 MiB, 256 ops; 0.0000 sec (26.073 MiB/sec and 6674.6624 ops/sec)
+wrote 1048576/1048576 bytes at offset 20971520
+1 MiB, 256 ops; 0.0000 sec (25.654 MiB/sec and 6567.4705 ops/sec)
+wrote 1048576/1048576 bytes at offset 26214400
+1 MiB, 256 ops; 0.0000 sec (26.350 MiB/sec and 6745.5403 ops/sec)
+wrote 1048576/1048576 bytes at offset 31457280
+1 MiB, 256 ops; 0.0000 sec (25.826 MiB/sec and 6611.3995 ops/sec)
+wrote 1048576/1048576 bytes at offset 36700160
+1 MiB, 256 ops; 0.0000 sec (23.480 MiB/sec and 6010.8007 ops/sec)
+wrote 1048576/1048576 bytes at offset 41943040
+1 MiB, 256 ops; 0.0000 sec (26.208 MiB/sec and 6709.2987 ops/sec)
+wrote 1048576/1048576 bytes at offset 47185920
+1 MiB, 256 ops; 0.0000 sec (25.471 MiB/sec and 6520.6317 ops/sec)
+wrote 1048576/1048576 bytes at offset 52428800
+1 MiB, 256 ops; 0.0000 sec (26.266 MiB/sec and 6724.1017 ops/sec)
+wrote 1048576/1048576 bytes at offset 57671680
+1 MiB, 256 ops; 0.0000 sec (25.765 MiB/sec and 6595.7282 ops/sec)
+wrote 1048576/1048576 bytes at offset 62914560
+1 MiB, 256 ops; 0.0000 sec (25.364 MiB/sec and 6493.1771 ops/sec)
+wrote 1048576/1048576 bytes at offset 68157440
+1 MiB, 256 ops; 0.0000 sec (25.169 MiB/sec and 6443.1692 ops/sec)
+wrote 1048576/1048576 bytes at offset 73400320
+1 MiB, 256 ops; 0.0000 sec (25.815 MiB/sec and 6608.6687 ops/sec)
+wrote 1048576/1048576 bytes at offset 78643200
+1 MiB, 256 ops; 0.0000 sec (25.353 MiB/sec and 6490.3785 ops/sec)
+wrote 1048576/1048576 bytes at offset 83886080
+1 MiB, 256 ops; 0.0000 sec (24.223 MiB/sec and 6201.0997 ops/sec)
+wrote 1048576/1048576 bytes at offset 89128960
+1 MiB, 256 ops; 0.0000 sec (26.048 MiB/sec and 6668.2295 ops/sec)
+wrote 1048576/1048576 bytes at offset 94371840
+1 MiB, 256 ops; 0.0000 sec (26.072 MiB/sec and 6674.3143 ops/sec)
+wrote 1048576/1048576 bytes at offset 99614720
+1 MiB, 256 ops; 0.0000 sec (25.773 MiB/sec and 6597.7681 ops/sec)
+wrote 1048576/1048576 bytes at offset 104857600
+1 MiB, 256 ops; 0.0000 sec (13.849 MiB/sec and 3545.4117 ops/sec)
+*** test01() create sparse file done ***
+
+*** test02() create sparse file ***
+wrote 1048576/1048576 bytes at offset 6291456
+1 MiB, 256 ops; 0.0000 sec (27.116 MiB/sec and 6941.8081 ops/sec)
+wrote 1048576/1048576 bytes at offset 16777216
+1 MiB, 256 ops; 0.0000 sec (26.946 MiB/sec and 6898.2242 ops/sec)
+wrote 1048576/1048576 bytes at offset 27262976
+1 MiB, 256 ops; 0.0000 sec (23.951 MiB/sec and 6131.4428 ops/sec)
+wrote 1048576/1048576 bytes at offset 37748736
+1 MiB, 256 ops; 0.0000 sec (26.213 MiB/sec and 6710.5298 ops/sec)
+wrote 1048576/1048576 bytes at offset 48234496
+1 MiB, 256 ops; 0.0000 sec (25.801 MiB/sec and 6605.0880 ops/sec)
+wrote 1048576/1048576 bytes at offset 58720256
+1 MiB, 256 ops; 0.0000 sec (26.990 MiB/sec and 6909.3952 ops/sec)
+wrote 1048576/1048576 bytes at offset 69206016
+1 MiB, 256 ops; 0.0000 sec (26.738 MiB/sec and 6844.9198 ops/sec)
+wrote 1048576/1048576 bytes at offset 79691776
+1 MiB, 256 ops; 0.0000 sec (26.389 MiB/sec and 6755.5086 ops/sec)
+wrote 1048576/1048576 bytes at offset 90177536
+1 MiB, 256 ops; 0.0000 sec (25.212 MiB/sec and 6454.2154 ops/sec)
+wrote 1048576/1048576 bytes at offset 100663296
+1 MiB, 256 ops; 0.0000 sec (27.028 MiB/sec and 6919.1059 ops/sec)
+wrote 1048576/1048576 bytes at offset 111149056
+1 MiB, 256 ops; 0.0000 sec (20.882 MiB/sec and 5345.8069 ops/sec)
+*** test02() create sparse file done ***
+
diff --git a/280.out b/280.out
new file mode 100644
index 0000000..fb29270
--- /dev/null
+++ b/280.out
@@ -0,0 +1 @@
+QA output created by 280
diff --git a/group b/group
index 02c6743..5d197ee 100644
--- a/group
+++ b/group
@@ -390,3 +390,4 @@ deprecated
 274 auto rw
 275 auto rw
 279 auto rw
+280 other
diff --git a/src/Makefile b/src/Makefile
index 1c6e717..d269e91 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -17,7 +17,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
-	stale_handle pwrite_mmap_blocked fstrim t_dir_offset2 seek_sanity_test
+	stale_handle pwrite_mmap_blocked fstrim t_dir_offset2 seek_sanity_test \
+	seek_copy_test
 
 SUBDIRS =
 
diff --git a/src/seek_copy_test.c b/src/seek_copy_test.c
new file mode 100644
index 0000000..6536194
--- /dev/null
+++ b/src/seek_copy_test.c
@@ -0,0 +1,252 @@
+/*
+ * Copyright (C) 2011 Oracle.  All rights reserved.
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
+#define _XOPEN_SOURCE 500
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdarg.h>
+#include <string.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <ctype.h>
+#include <errno.h>
+#include <limits.h>
+
+#ifndef SEEK_DATA
+#define SEEK_DATA	3
+#define SEEK_HOLE	4
+#endif
+
+#define BUF_SIZE	4096
+#ifndef MIN
+#define MIN(a,b) ((a)<(b)?(a):(b))
+#endif
+
+static void
+error(const char *fmt, ...)
+{
+	char buf[256];
+	va_list args;
+	va_start(args, fmt);
+	vsprintf(buf, fmt, args);
+	va_end(args);
+
+	fprintf(stderr, "ERROR: [%s:%d] %s:%s\n", __func__, __LINE__,
+		buf, strerror(errno));
+}
+
+static size_t
+full_write(int fd, const void *buf, size_t count)
+{
+	size_t total = 0;
+	const char *ptr = (const char *) buf;
+
+	while (count > 0) {
+		ssize_t n = write(fd, ptr, count);
+		if (n < 0) {
+			if (errno == EINTR)
+				continue;
+			error("failed as %s", strerror(errno));
+			break;
+		}
+
+		if (n == 0) {
+			error("%zu bytes transferred. Aborting.",
+			       total);
+			break;
+		}
+
+		total += n;
+		ptr += n;
+		count -= n;
+	}
+
+	return total;
+}
+
+/*
+ * Copy a data extent from source file to dest file.
+ * @data_off: data offset
+ * @hole_off: hole offset
+ * The length of this extent is (hole_off - data_off).
+ */
+static int
+do_extent_copy(int src_fd, int dest_fd, off_t data_off, off_t hole_off)
+{
+	uint64_t len = (uint64_t)(hole_off - data_off);
+	char buf[BUF_SIZE];
+	int ret;
+
+	/* Seek to data_off for data reading */
+	ret = lseek(src_fd, data_off, SEEK_SET);
+	if (ret < 0) {
+		error("seek source file to %llu failed as %s",
+		       (uint64_t)data_off, strerror(errno));
+		return ret;
+	}
+
+	/* Seek to data_off for data writing, make holes as well */
+	ret = lseek(dest_fd, data_off, SEEK_SET);
+	if (ret < 0) {
+		error("seek dest file to %llu failed as %s",
+		       (uint64_t)data_off, strerror(errno));
+		return ret;
+	}
+
+	while (len > 0) {
+		memset(buf, 0, sizeof(buf));
+		ssize_t nr_read = read(src_fd, buf, BUF_SIZE);
+		if (nr_read < 0) {
+			if (errno == EINTR)
+				continue;
+			error("read source file extent failed as %s",
+			      strerror(errno));
+			ret = -1;
+			break;
+		}
+
+		if (nr_read == 0) {
+			error("reached EOF");
+			break;
+		}
+
+		if (full_write(dest_fd, buf, nr_read) != nr_read) {
+			error("write data to dest file failed as %s",
+			       strerror(errno));
+			ret = -1;
+			break;
+		}
+
+		len -= nr_read;
+	}
+
+	return ret;
+}
+
+/*
+ * If lseek(2) failed and the errno is set to ENXIO, for
+ * SEEK_DATA there are no more data regions past the supplied
+ * offset.  For SEEK_HOLE, there are no more holes past the
+ * supplied offset.  Set scan->hit_final_extent to true for
+ * either case.
+ */
+static int
+copy_extents(int src_fd, int dest_fd, off_t src_total_size)
+{
+	int ret = 0;
+	unsigned int i = 0;
+	off_t seek_start = 0;
+	off_t dest_pos = 0;
+	off_t data_pos, hole_pos;
+
+	do {
+		data_pos = lseek(src_fd, seek_start, SEEK_DATA);
+		if (data_pos < 0) {
+			if (errno == ENXIO)
+				ret = 0;
+			else {
+				error("SEEK_DATA failed due to %s",
+				       strerror(errno));
+				ret = -1;
+			}
+			break;
+		}
+
+		hole_pos = lseek(src_fd, data_pos, SEEK_HOLE);
+		if (hole_pos < 0) {
+			if (errno == ENXIO)
+				ret = 0;
+			else {
+				error("SEEK_HOLE failed due to %s\n",
+				       strerror(errno));
+				ret = -1;
+			}
+			break;
+		}
+
+		/* do extent copy */
+		ret = do_extent_copy(src_fd, dest_fd, data_pos, hole_pos);
+		if (ret < 0) {
+			error("copy extent failed");
+			break;
+		}
+
+		dest_pos += (hole_pos - data_pos);
+		++i;
+		seek_start = hole_pos;
+	} while (seek_start < src_total_size);
+
+	if (dest_pos < src_total_size) {
+		ret = ftruncate(dest_fd, src_total_size);
+		if (ret < 0) {
+			error("truncate dest file to %lld bytes failed as %s",
+			      (long long)src_total_size, strerror(errno));
+		}
+	}
+
+	return ret;
+}
+
+int
+main(int argc, char **argv)
+{
+	int ret = 0;
+	int src_fd;
+	int dest_fd;
+	struct stat st;
+	size_t src_total_size;
+
+	if (argc != 3) {
+		fprintf(stdout, "Usage: %s source dest\n", argv[0]);
+		return 1;
+	}
+
+	src_fd = open(argv[1], O_RDONLY, 0644);
+	if (src_fd < 0) {
+		error("create %s failed", argv[1]);
+		return -1;
+	}
+
+	dest_fd = open(argv[2], O_RDWR|O_CREAT|O_EXCL, 0644);
+	if (dest_fd < 0) {
+		error("create %s failed", argv[2]);
+		ret = -errno;
+		goto close_src_fd;
+	}
+
+	ret = fstat(src_fd, &st);
+	if (ret < 0) {
+		error("get file %s staticis failed", argv[1]);
+		ret = -errno;
+		goto close_dest_fd;
+	}
+
+	src_total_size = st.st_size;
+	ret = copy_extents(src_fd, dest_fd, src_total_size);
+	if (ret < 0)
+		error("extents copy failed");
+
+close_dest_fd:
+	close(dest_fd);
+close_src_fd:
+	close(src_fd);
+
+	return ret;
+}
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
