Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16EVXW0139400 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 08:31:33 -0600
Message-ID: <4F2FE410.2040508@oracle.com>
Date: Mon, 06 Feb 2012 22:30:40 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 2/2] xfstests: introduce 280 for SEEK_DATA/SEEK_HOLE copy
	check
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

Introduce 280 for SEEK_DATA/SEEK_HOLE copy check.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 280                    |  148 ++++++++++
 280.out                |    1 +
 group                  |    1 +
 src/Makefile           |    3 +-
 src/seek_copy_tester.c |  709 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 861 insertions(+), 1 deletions(-)
 create mode 100755 280
 create mode 100644 280.out
 create mode 100644 src/seek_copy_tester.c

diff --git a/280 b/280
new file mode 100755
index 0000000..33efaaa
--- /dev/null
+++ b/280
@@ -0,0 +1,148 @@
+#! /bin/bash
+# FS QA Test No. 280
+#
+# SEEK_DATA/SEEK_HOLE tester.
+# Create a sparse file with a couple of holes and data extents.
+# Simulates the copy process to verify SEEK_DATA/SEEK_HOLE stuff works
+# as expected.
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
+_supported_os Linux Solaris
+
+src=$TEST_DIR/seek_copy_testfile
+dest=$TEST_DIR/seek_copy_testfile.dest
+
+[ -x $here/src/seek_copy_tester ] || _notrun "seek_copy_tester not built"
+
+_cleanup()
+{
+	rm -f $src $dest
+}
+
+# seek_copy_test_01()
+# create a 100Mytes file in preallocation mode.
+# fallocate offset start from 0.
+# the first data extent offset start from 80991, write 4Kbytes,
+# and then skip 195001 bytes for next write.
+# this is intended to test data buffer lookup for DIRTY pages.
+# verify results:
+# 1. file size is identical.
+# 2. perform cmp(1) to compare SRC and DEST file byte by byte.
+test01()
+{
+	rm -f $src $dest
+
+	$here/src/seek_copy_tester -P -O 0 -L 100m -s 80991 -k 195001 -l 4k $src $dest
+
+	test $(stat --printf "%s" $src) = $(stat --printf "%s" $dest) ||
+		echo "TEST01: file size check failed" >> $seq.out
+
+	cmp $src $dest						      ||
+		echo "TEST01: file bytes check failed" >> $seq.out
+}
+
+# seek_copy_test_02()
+# create a 100Mytes file in preallocation mode.
+# fallocate offset start from 0.
+# the first data extent offset start from 0, write 16Kbytes,
+# and then skip 8Mbytes for next write.
+# Try flushing DIRTY pages to WRITEBACK mode, this is intended to
+# test data buffer lookup in WRITEBACK pages.
+# verify results:
+# 1. file size is identical.
+# 2. perform cmp(1) to compare SRC and DEST file byte by byte.
+test02()
+{
+	rm -rf $src $dest
+
+	$here/src/seek_copy_tester -S -P -O 0 -L 100m -s 0 -k 8m -l 16k $src $dest
+
+	test $(stat --printf "%s" $src) = $(stat --printf "%s" $dest) ||
+		echo "TEST02: file size check failed" >> $seq.out
+
+	cmp $src $dest						      ||
+		echo "TEST02: file bytes check failed" >>$seq.out
+}
+
+# seek_copy_test_03
+# create a 100Mytes sparse file.
+# the first data extent offset start from 512, write 4Kbytes,
+# and then skip 1Mbytes for next write.
+# don't make holes at the end of file.
+# verify results:
+# 1. file size is identical.
+# 2. perform cmp(1) to compare SRC and DEST file byte by byte.
+test03()
+{
+	rm -f $src $dest
+
+	$here/src/seek_copy_tester -M 100m -s 512 -k 1m -l 4k $src $dest
+
+	test $(stat --printf "%s" $src) = $(stat --printf "%s" $dest) ||
+		echo "FAIL_TEST03: file size no equal" >> $seq.out
+
+	cmp $src $dest						      ||
+		echo "FAIL_TEST03: file compare failed" >>$seq.out
+}
+
+# seek_copy_test_04
+# create a 1Gbytes sparse file.
+# the first data extent offset start from 512, write 4Kbytes,
+# and then skip 1Mbytes for next write.
+# make holes at the end of file.
+# verify results:
+# 1. file size is identical.
+# 2. perform cmp(1) to compare SRC and DEST file byte by byte.
+test04()
+{
+	rm -f $src $dest
+
+	$here/src/seek_copy_tester -M 1g -s 512 -k 1m -l 4k -E $src $dest
+
+	test $(stat --printf "%s" $src) = $(stat --printf "%s" $dest) ||
+		echo "FAIL_TEST04: file size no equal" >> $seq.out
+	cmp $src $dest						      ||
+		echo "FAIL_TEST04: file compare failed" >>$seq.out
+}
+
+echo "QA output created by $seq" >> $seq.out
+test01
+test02
+test03
+test04
+
+status=0
+exit
diff --git a/280.out b/280.out
new file mode 100644
index 0000000..fb29270
--- /dev/null
+++ b/280.out
@@ -0,0 +1 @@
+QA output created by 280
diff --git a/group b/group
index 02c6743..b5a0578 100644
--- a/group
+++ b/group
@@ -390,3 +390,4 @@ deprecated
 274 auto rw
 275 auto rw
 279 auto rw
+280 auto rw
diff --git a/src/Makefile b/src/Makefile
index 6797064..4a24d3c 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -17,7 +17,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
-	stale_handle pwrite_mmap_blocked fstrim t_dir_offset2 seek_sanity_tester
+	stale_handle pwrite_mmap_blocked fstrim t_dir_offset2 seek_sanity_tester \
+	seek_copy_tester
 
 SUBDIRS =
 
diff --git a/src/seek_copy_tester.c b/src/seek_copy_tester.c
new file mode 100644
index 0000000..ddf683f
--- /dev/null
+++ b/src/seek_copy_tester.c
@@ -0,0 +1,709 @@
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
+#include <getopt.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <ctype.h>
+#include <errno.h>
+#include <limits.h>
+#include <assert.h>
+#include <linux/falloc.h>
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
+/* True if the arithmetic type T is signed, borrowed from Coreutils */
+#define TYPE_SIGNED(t) (! ((t)0 < (t)-1))
+#define TYPE_MAXIMUM(t)								\
+	((t) (! TYPE_SIGNED(t)							\
+		? (t) -1							\
+		: ((((t) 1 << (sizeof(t) * CHAR_BIT - 2)) - 1) * 2 + 1)))
+
+#ifndef OFF_T_MAX
+# define OFF_T_MAX TYPE_MAXIMUM (off_t)
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
+	fprintf(stderr, "ERROR: [%s:%d] %s\n", __func__, __LINE__, buf);
+}
+
+/* Borrowed from btrfs progs */
+static uint64_t
+parse_size(char *s)
+{
+	int len = strlen(s);
+	char c;
+	uint64_t mult = 1;
+
+	if (!isdigit(s[len - 1])) {
+		c = tolower(s[len - 1]);
+		switch (c) {
+		case 'g':
+			mult <<= 30;
+			break;
+		case 'm':
+			mult <<= 20;
+			break;
+		case 'k':
+			mult <<= 10;
+			break;
+		case 'b':
+			break;
+		default:
+			error("unknown size descriptor %c", c);
+			exit(1);
+		}
+		s[len - 1] = '\0';
+	}
+
+	return atoll(s) * mult;
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
+			error("full_write() failed as %s", strerror(errno));
+			break;
+		}
+
+		if (n == 0) {
+			error("full_write() ZERO bytes transferred");
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
+static size_t
+get_block_size(int fd)
+{
+	struct stat st;
+	return (fstat(fd, &st) < 0) ? -1 : st.st_blksize;
+}
+
+/*
+ * Write out of all dirty pages in the specified range which are
+ * not presently submitted write-out.
+ * @offset: the starting byte of the file range to be synchronized.
+ * @nbytes: specifies the length of the range to be synchronized, in bytes;
+ *	    if nbytes is zero, then all bytes from offset through to the end
+ *	    of file are synchronized.
+ * @flags:  by default, SYNC_FILE_RANGE_WRITE will be used.
+ */
+static int
+writeout_dirty_pages(int fd, off_t offset, off_t nbytes,
+		     unsigned int flags)
+{
+	if (sync_file_range(fd, offset, nbytes, flags) < 0) {
+		error("sync file range failed as %s", strerror(errno));
+		return -1;
+	}
+
+	return 0;
+}
+
+static size_t
+full_pwrite(int fd, const void *buf, size_t count, off_t offset)
+{
+	size_t total = 0;
+	size_t  written = 0;
+
+	while (written < count) {
+		ssize_t n = pwrite(fd, buf + written, count - written,
+				   offset + written);
+		if (n < 0) {
+			error("full_pwrite() failed as %s", strerror(errno));
+			break;
+		}
+
+		if (n == 0) {
+			error("full_pwrite(): ZERO byte transferred");
+			break;
+		}
+
+		written += n;
+		total += n;
+	}
+
+	return total;
+}
+
+/*
+ * Write N_BYTES zero bytes to file descriptor FD.
+ * Return true if successful. Upon write failure, set
+ * errno and return false. Borrowed from cp(1).
+ */
+static int
+write_zeros(int fd, uint64_t n_bytes)
+{
+	static char *zeros;
+	static size_t nz = BUF_SIZE;
+
+	/*
+	 * Attempt to use a relatively large calloc'd source buffer for
+	 * efficiency, but if that allocation fails, resort to a smaller
+	 * statically allocated one.
+	 */
+	if (zeros == NULL) {
+		static char fallback[1024];
+		zeros = calloc(nz, 1);
+		if (zeros == NULL) {
+			zeros = fallback;
+			nz = sizeof(fallback);
+		}
+	}
+
+	while (n_bytes) {
+		uint64_t n = MIN(nz, n_bytes);
+		if ((full_write(fd, zeros, n)) != n)
+			return -1;
+		n_bytes -= n;
+	}
+
+	return 0;
+}
+
+/*
+ * Produce a sparse file with data extents and holes.
+ * @len:		the maximum length of the produced file.
+ * @start_offset:	seek to here first to write data.
+ * @skip_bytes:		for the next lseek(2) operation, we need to
+ *			skip the number of bytes to create holes.
+ * @data_len:		how many bytes for each write(2).
+ */
+static int
+create_data_and_holes(int fd, size_t nr_total_bytes, off_t start_offset,
+		      uint64_t nr_skip_bytes, uint64_t nr_data_bytes,
+		      int wrote_hole_at_eof)
+{
+	int ret = 0;
+	off_t total = nr_total_bytes;
+	off_t data_len = nr_data_bytes;
+	off_t off = start_offset;
+	char buf[BUF_SIZE];
+
+	memset(buf, 'A', sizeof(buf));
+
+	total -= start_offset;
+	while (total > 0) {
+		do {
+			size_t nr_write = MIN(total, BUF_SIZE);
+			if (full_pwrite(fd, buf, nr_write, off) != nr_write) {
+				error("full_pwrite() failed as %s", strerror(errno));
+				ret = -1;
+				goto out;
+			}
+
+			off += nr_write;
+			data_len -= nr_write;
+		} while (data_len > 0);
+
+		off += (nr_skip_bytes + nr_data_bytes);
+		total -= off;
+	}
+
+	if (off < nr_total_bytes) {
+		if (wrote_hole_at_eof) {
+			ret = ftruncate(fd, nr_total_bytes);
+			if (ret < 0) {
+				error("truncate source file to %lld bytes failed as %s",
+				       (long long)nr_total_bytes, strerror(errno));
+			}
+		}
+
+		ret = write_zeros(fd, nr_total_bytes - off);
+		if (ret < 0) {
+			error("write_zeros to end of file failed as %s",
+			       strerror(errno));
+		}
+	}
+
+out:
+	return ret;
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
+			error("do_extent_copy() read reached EOF");
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
+static struct option const longopts[] = {
+	{"fallocate", no_argument, NULL, 'P'},
+	{"falloc-offset", required_argument, NULL, 'O'},
+	{"falloc-length", required_argument, NULL, 'L'},
+	{"falloc-keep-size", no_argument, NULL, 'N'},
+	{"max-file-size", required_argument, NULL, 'M'},
+	{"write-start-offset", required_argument, NULL, 's'},
+	{"write-skip-bytes", required_argument, NULL, 'k'},
+	{"write-bytes", required_argument, NULL, 'l'},
+	{"sync-dirty-pages", no_argument, NULL, 'S'},
+	{"sync-page-offset", required_argument, NULL, 'p'},
+	{"sync-page-bytes", required_argument, NULL, 'b'},
+	{"sync-page-flags", required_argument, NULL, 'f'},
+	{"wrote-hole-at-eof", no_argument, NULL, 'E'},
+	{NULL, 0, NULL, 0}
+};
+
+static void
+usage(const char *progname)
+{
+	fprintf(stdout, "Usage: %s [OPTION]... SOURCE DEST\n"
+		"	    [-P] [-O falloc-offset] [-L falloc-length] [-N]\n"
+		"	    [-M max-file-size]\n"
+		"	    [-s write-start-offset] [-k write-skip-bytes] [-l write-bytes]\n"
+		"	    [-S] [-p sync-page-offset] [-b sync-page-bytes] [-f sync-page-flags]\n"
+		"	    [-E wrote-hole-at-eof]\n"
+		"	-L, --falloc-length=LENGTH	fallocate length\n"
+		"	-O, --falloc-offset=OFFSET	fallocate offset\n"
+		"	-M, --max-file-size=LENGTH	maximum size of file, don't required in\n"
+		"					preallocation mode\n"
+		"	-s, --write-start-offset=OFFSET	make holes at the begnning of source file\n"
+		"	-k, --write-skip-bytes=BYTES	skip a range of bytes for next write\n"
+		"	-l, --write-bytes=BYTES		create data extent in number of bytes\n"
+		"	-p, --sync-page-offset=OFFSET   sync dirty pages from where\n"
+		"	-b, --sync-page-bytes=BYTES	sync dirty pages for a number of bytes\n"
+		"	-f, --sync-page-flags=FLAGS	sync dirty pages in which mode\n"
+		"	-P				preallocate space for source file\n"
+		"	-N				fallocate(2) in keep size mode\n"
+		"	-S				sync out dirty pages\n"
+		"	-E				make hole at the end of source file in\n"
+		"					non-preallocate mode\n",
+		progname);
+
+	exit(1);
+}
+
+int
+main(int argc, char **argv)
+{
+	int opt;
+	int src_fd;
+	int dest_fd;
+	int ret = 0;
+	int do_falloc = 0;
+	int falloc_mode = 0;
+	int do_sync_dirty_pages = 0;
+	int wrote_hole_at_eof = 0;
+	uint32_t sync_page_flags = 0;
+	size_t src_total_size;
+	size_t max_file_size = 0;
+	off_t falloc_length = 0;
+	off_t falloc_offset = 0;
+	off_t seek_start_offset = 0;
+	off_t seek_skip_bytes = 0;
+	off_t sync_page_offset = 0;
+	off_t sync_page_bytes = 0;
+	uint64_t seek_write_bytes = 0;
+	char *src_file = NULL;
+	char *dest_file = NULL;
+	struct stat st;
+
+	while ((opt = getopt_long(argc, argv, "PO:L:NM:s:k:l:Sp:b:f:E",
+				  longopts, NULL)) != -1) {
+		switch(opt) {
+		case 'P':
+			do_falloc = 1;
+			break;
+		case 'O':
+			/* Preallocate disk space from where */
+			falloc_offset = parse_size(optarg);
+			assert(falloc_offset <= OFF_T_MAX);
+			break;
+		case 'L':
+			/* Preallocate disk space length */
+			falloc_length = parse_size(optarg);
+			assert(falloc_offset <= OFF_T_MAX);
+			break;
+		case 'N':
+			/* Preallocation in KEEP_FILE_SIZE mode */
+			falloc_mode = FALLOC_FL_KEEP_SIZE;
+			break;
+		case 'M':
+			/*
+			 * The maximum length of source file, only valid
+			 * if the source file created in non-preallocation
+			 * mode. Otherwise, it will be set to falloc_length.
+			 */
+			max_file_size = parse_size(optarg);
+		case 's':
+			/*
+			 * Seek to where for the first write. It will create
+			 * a hole at the beginning of the source file if this
+			 * option was specified. It can be ignored if you don't
+			 * want that.
+			 */
+			seek_start_offset = parse_size(optarg);
+			assert(seek_start_offset <= OFF_T_MAX);
+			break;
+		case 'k':
+			/*
+			 * Skip the number of bytes for the next data write.
+			 * It is used to create holes in the middle of file.
+			 * If this option was not specified, using blocksize
+			 * instead.
+			 */
+			seek_skip_bytes = parse_size(optarg);
+			assert(seek_start_offset <= OFF_T_MAX);
+			break;
+		case 'l':
+			/*
+			 * Write the number of bytes after seeking, we
+			 * we can make the disk fragmented as much as
+			 * possbile by tweaking up this value.
+			 */
+			seek_write_bytes = parse_size(optarg);
+			break;
+		case 'S':
+			/*
+			 * Call sync_file_range(2) to writeout dirty
+			 * pages. It can be used to test WRITEBACK pages
+			 * probing branch.
+			 */
+			do_sync_dirty_pages = 1;
+			break;
+		case 'p':
+			/*
+			 * Sync out dirty pages starting from where, sync
+			 * from 0 if it was not specified.
+			 */
+			sync_page_offset = parse_size(optarg);
+			break;
+		case 'b':
+			/*
+			 * If it was not specified, sync out pages from
+			 * above offset to the end of file.
+			 */
+			sync_page_bytes = parse_size(optarg);
+			break;
+		case 'f':
+			/*
+			 * By default, SYNC_FILE_RANGE_WRITE will be used if
+			 * this option was not specified.
+			 */
+			sync_page_flags = (uint32_t)atol(optarg);
+			break;
+		case 'E':
+			wrote_hole_at_eof = 1;
+			break;
+		default:
+			usage(argv[0]);
+		}
+	}
+
+	if (argc - optind < 2) {
+		usage(argv[0]);
+		return 1;
+	}
+
+	src_file = strdup(argv[argc - 2]);
+	if (!src_file) {
+		usage(argv[0]);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	dest_file = strdup(argv[argc - 1]);
+	if (!dest_file) {
+		usage(argv[0]);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (!do_falloc && (falloc_length || falloc_offset)) {
+		error("Invalid arguments, missing -F or --fallocate option "
+		      "for fallocation tests");
+		usage(argv[0]);
+		goto out;
+	}
+
+	if (do_falloc && !falloc_length) {
+		error("Invalid arguments, fallocate length must be specified "
+		      "for fallocation tests");
+		usage(argv[0]);
+		goto out;
+	}
+
+	if (!do_falloc && !max_file_size) {
+		error("Invalid arguments, missing -M or --max-file-size option "
+		      "in none-fallocate mode");
+		usage(argv[0]);
+		goto out;
+	}
+
+	if (falloc_length && max_file_size) {
+		error("Invalid arguments, don't combine -M with -F options");
+		usage(argv[0]);
+		goto out;
+	}
+
+	if (!do_sync_dirty_pages && (sync_page_offset ||
+				     sync_page_bytes  ||
+				     sync_page_flags)) {
+		error("Invalid argument, missing -S or --sync-pages option "
+		      "for sync file range tests");
+		usage(argv[0]);
+		return 1;
+	}
+
+	if (do_sync_dirty_pages && !sync_page_flags)
+		sync_page_flags = SYNC_FILE_RANGE_WRITE;
+
+	src_fd = open(src_file, O_RDWR|O_CREAT|O_TRUNC, 0644);
+	if (src_fd < 0) {
+		error("create %s failed as %s", src_file, strerror(errno));
+		goto out;
+	}
+
+	dest_fd = open(dest_file, O_RDWR|O_CREAT|O_TRUNC, 0644);
+	if (dest_fd < 0) {
+		error("create %s failed as %s", dest_file, strerror(errno));
+		close(src_fd);
+		goto close_src_fd;
+	}
+
+	if (do_falloc) {
+		/* Preallocate space for source file */
+		ret = fallocate(src_fd, falloc_mode,
+				falloc_offset, falloc_length);
+		if (ret < 0) {
+			error("fallocate file %s failed as %s",
+			       src_file, strerror(errno));
+			goto close_dest_fd;
+		}
+		max_file_size = falloc_length;
+	}
+
+	/*
+	 * If seek_write_bytes was not specified, fill up data extent
+	 * to st.st_blksize for each write.
+	 */
+	if (!seek_write_bytes) {
+		seek_write_bytes = get_block_size(src_fd);
+		if (seek_write_bytes < 0) {
+			error("get %s block size failed as %s",
+			       src_file, strerror(errno));
+			goto close_dest_fd;
+		}
+	}
+
+	/*
+	 * Seek to seek_offset, write seek_write_len to dest file,
+	 * skip seek_skip_len for next write.
+	 */
+	ret = create_data_and_holes(src_fd, max_file_size,
+				    seek_start_offset,
+				    seek_skip_bytes,
+				    seek_write_bytes,
+				    wrote_hole_at_eof);
+	if (ret < 0) {
+		error("seek write to %s failed", src_file);
+		goto close_dest_fd;
+	}
+
+	if (do_sync_dirty_pages) {
+		ret = writeout_dirty_pages(src_fd, sync_page_offset,
+					   sync_page_bytes, sync_page_flags);
+		if (ret < 0) {
+			error("write out dirty pages failed as %s",
+			      strerror(errno));
+			goto close_dest_fd;
+		}
+	}
+
+	/*
+	 * Note that if the source file created in non-fallocte mode,
+	 * the source file size might less than the max_file_size.
+	 */
+	ret = fstat(src_fd, &st);
+	if (ret < 0) {
+		error("get file %s staticis failed as %s",
+		       src_file, strerror(errno));
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
+out:
+	if (src_file)
+		free(src_file);
+	if (dest_file)
+		free(dest_file);
+	return ret;
+}
-- 
1.7.9

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
