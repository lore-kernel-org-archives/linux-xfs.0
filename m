Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933360AbdCUQxs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Mar 2017 12:53:48 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2] generic: test pagecache invalidation after direct write
Date: Wed, 22 Mar 2017 00:53:14 +0800
Message-Id: <20170321165314.11434-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>

Test if direct write invalidates pagecache correctly, so that subsequent
buffer read reads the correct data from disk.

This test is inspired by LTP tests dio29, and serves as a regression
test for the bug found by it, see kernel commit c771c14baa33
("iomap: invalidate page caches should be after iomap_dio_complete()
in direct write").

The test can be easily expanded to other write/read combinations, e.g.
buffer write + direct read and direct write + direct read, so they are
also being tested.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
v2: Address Brian's review comments
- compare buffer content byte-by-byte instead of strncmp
- use 'pids[i]' not *(pids + 1)
- dump buffer content to stdout on error
- initialize write buffer with (i + 1)
- use pwrite/pread instead of lseek+write/read
- remove increment of unused 'ret'
- call fsync(fd) instead of sync()
- fix typos

 .gitignore                 |   1 +
 src/Makefile               |   3 +-
 src/dio-invalidate-cache.c | 326 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/418          | 122 +++++++++++++++++
 tests/generic/418.out      |   2 +
 tests/generic/group        |   1 +
 6 files changed, 454 insertions(+), 1 deletion(-)
 create mode 100644 src/dio-invalidate-cache.c
 create mode 100755 tests/generic/418
 create mode 100644 tests/generic/418.out

diff --git a/.gitignore b/.gitignore
index 48a40a0..1ed2a92 100644
--- a/.gitignore
+++ b/.gitignore
@@ -45,6 +45,7 @@
 /src/dbtest
 /src/devzero
 /src/dio-interleaved
+/src/dio-invalidate-cache
 /src/dirperf
 /src/dirstress
 /src/dmiperf
diff --git a/src/Makefile b/src/Makefile
index eb5a56c..a7f27f0 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -21,7 +21,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
 	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
-	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type
+	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
+	dio-invalidate-cache
 
 SUBDIRS =
 
diff --git a/src/dio-invalidate-cache.c b/src/dio-invalidate-cache.c
new file mode 100644
index 0000000..bc795f9
--- /dev/null
+++ b/src/dio-invalidate-cache.c
@@ -0,0 +1,326 @@
+/*
+ * Copyright (c) 2017 Red Hat Inc. All Rights Reserved.
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
+ * Fork N children, each child writes to and reads from its own region of the
+ * same test file, and check if what it reads is what it writes. The test
+ * region is determined by N * blksz. Write and read operation can be either
+ * direct or buffered.
+ */
+
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <sys/file.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#define DEF_BLKSZ 4096
+
+int verbose = 0;
+
+static void usage(const char *prog)
+{
+	fprintf(stderr, "Usage: %s [-Fhptrwv] [-b blksz] [-n nr_child] [-i iterations] [-o offset] <-f filename>\n", prog);
+	fprintf(stderr, "\t-F\tPreallocate all blocks by writing them before test\n");
+	fprintf(stderr, "\t-p\tPreallocate all blocks using fallocate(2) before test\n");
+	fprintf(stderr, "\t-t\tTruncate test file to largest size before test\n");
+	fprintf(stderr, "\t-r\tDo direct read\n");
+	fprintf(stderr, "\t-w\tDo direct write\n");
+	fprintf(stderr, "\t-v\tBe verbose\n");
+	fprintf(stderr, "\t-h\tshow this help message\n");
+	exit(EXIT_FAILURE);
+}
+
+static int cmpbuf(char *b1, char *b2, int bsize)
+{
+	int i;
+
+	for (i = 0; i < bsize; i++) {
+		if (b1[i] != b2[i]) {
+			fprintf(stderr, "cmpbuf: offset %d: Expected: 0x%x,"
+				" got 0x%x\n", i, b1[i], b2[i]);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static void kill_children(pid_t *pids, int nr_child)
+{
+	int i;
+	pid_t pid;
+
+	for (i = 0; i < nr_child; i++) {
+		pid = *(pids + i);
+		if (pid == 0)
+			continue;
+		kill(pid, SIGTERM);
+	}
+	return;
+}
+
+static int wait_children(pid_t *pids, int nr_child)
+{
+	int i, status, ret = 0;
+	pid_t pid;
+
+	for (i = 0; i < nr_child; i++) {
+		pid = pids[i];
+		if (pid == 0)
+			continue;
+		waitpid(pid, &status, 0);
+		ret += WEXITSTATUS(status);
+	}
+	return ret;
+}
+
+static void dumpbuf(char *buf, int size, int blksz)
+{
+	int i;
+
+	printf("dumping buffer content\n");
+	for (i = 0; i < size; i++) {
+		if (((i % blksz) == 0) || ((i % 64) == 0))
+			putchar('\n');
+		printf("%x", buf[i]);
+	}
+	putchar('\n');
+}
+
+static int run_test(const char *filename, int n_child, int blksz, off_t offset,
+		    int nr_iter, int flag_rd, int flag_wr)
+{
+	char *buf_rd;
+	char *buf_wr;
+	off_t seekoff;
+	int fd_rd, fd_wr;
+	int i, ret;
+	long page_size;
+
+	seekoff = offset + blksz * n_child;
+
+	page_size = sysconf(_SC_PAGESIZE);
+	ret = posix_memalign((void **)&buf_rd, (size_t)page_size,
+		blksz > page_size ? blksz : (size_t)page_size);
+	if (ret) {
+		fprintf(stderr, "posix_memalign(buf_rd, %d, %d) failed: %d\n",
+			blksz, blksz, ret);
+		exit(EXIT_FAILURE);
+	}
+	memset(buf_rd, 0, blksz);
+	ret = posix_memalign((void **)&buf_wr, (size_t)page_size,
+		blksz > page_size ? blksz : (size_t)page_size);
+	if (ret) {
+		fprintf(stderr, "posix_memalign(buf_wr, %d, %d) failed: %d\n",
+			blksz, blksz, ret);
+		exit(EXIT_FAILURE);
+	}
+	memset(buf_wr, 0, blksz);
+
+	fd_rd = open(filename, flag_rd);
+	if (fd_rd < 0) {
+		perror("open readonly for read");
+		exit(EXIT_FAILURE);
+	}
+
+	fd_wr = open(filename, flag_wr);
+	if (fd_wr < 0) {
+		perror("open writeonly for direct write");
+		exit(EXIT_FAILURE);
+	}
+
+#define log(format, ...) 			\
+	if (verbose) {				\
+		printf("[%d:%d] ", n_child, i);	\
+		printf(format, __VA_ARGS__);	\
+	}
+
+
+	/* seek, write, read and verify */
+	for (i = 0; i < nr_iter; i++) {
+		memset(buf_wr, i + 1, blksz);
+		log("pwrite(fd_wr, %p, %d, %lu)\n", buf_wr, blksz, seekoff);
+		if (pwrite(fd_wr, buf_wr, blksz, seekoff) != blksz) {
+			perror("direct write");
+			exit(EXIT_FAILURE);
+		}
+
+		/* make sure buffer write hits disk before direct read */
+		if (!(flag_wr & O_DIRECT)) {
+			if (fsync(fd_wr) < 0) {
+				perror("fsync(fd_wr)");
+				exit(EXIT_FAILURE);
+			}
+		}
+
+		log("pread(fd_rd, %p, %d, %lu)\n", buf_rd, blksz, seekoff);
+		if (pread(fd_rd, buf_rd, blksz, seekoff) != blksz) {
+			perror("buffer read");
+			exit(EXIT_FAILURE);
+		}
+		if (cmpbuf(buf_wr, buf_rd, blksz) != 0) {
+			fprintf(stderr, "[%d:%d] FAIL - comparison failed, "
+				"offset %d\n", n_child, i, (int)seekoff);
+			if (verbose)
+				dumpbuf(buf_rd, blksz, blksz);
+			exit(EXIT_FAILURE);
+		}
+	}
+	exit(EXIT_SUCCESS);
+}
+
+int main(int argc, char *argv[])
+{
+	int nr_iter = 1;
+	int nr_child = 1;
+	int blksz = DEF_BLKSZ;
+	int fd, i, ret = 0;
+	int flag_rd = O_RDONLY;
+	int flag_wr = O_WRONLY;
+	int do_trunc = 0;
+	int pre_fill = 0;
+	int pre_alloc = 0;
+	pid_t pid;
+	pid_t *pids;
+	off_t offset = 0;
+	char *filename = NULL;
+
+	while ((i = getopt(argc, argv, "b:i:n:f:Fpo:tvrw")) != -1) {
+		switch (i) {
+		case 'b':
+			if ((blksz = atoi(optarg)) <= 0) {
+				fprintf(stderr, "blksz must be > 0\n");
+				exit(EXIT_FAILURE);
+			}
+			if (blksz % 512 != 0) {
+				fprintf(stderr, "blksz must be multiple of 512\n");
+				exit(EXIT_FAILURE);
+			}
+			break;
+		case 'i':
+			if ((nr_iter = atoi(optarg)) <= 0) {
+				fprintf(stderr, "iterations must be > 0\n");
+				exit(EXIT_FAILURE);
+			}
+			break;
+		case 'n':
+			if ((nr_child = atoi(optarg)) <= 0) {
+				fprintf(stderr, "no of children must be > 0\n");
+				exit(EXIT_FAILURE);
+			}
+			break;
+		case 'f':
+			filename = optarg;
+			break;
+		case 'F':
+			pre_fill = 1;
+			break;
+		case 'p':
+			pre_alloc = 1;
+			break;
+		case 'r':
+			flag_rd |= O_DIRECT;
+			break;
+		case 'w':
+			flag_wr |= O_DIRECT;
+			break;
+		case 't':
+			do_trunc = 1;
+			break;
+		case 'o':
+			if ((offset = atol(optarg)) < 0) {
+				fprintf(stderr, "offset must be >= 0\n");
+				exit(EXIT_FAILURE);
+			}
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		case 'h':	/* fall through */
+		default:
+			usage(argv[0]);
+		}
+	}
+
+	if (filename == NULL)
+		usage(argv[0]);
+	if (pre_fill && pre_alloc) {
+		fprintf(stderr, "Error: -F and -p are both specified\n");
+		exit(EXIT_FAILURE);
+	}
+
+	pids = malloc(nr_child * sizeof(pid_t));
+	if (!pids) {
+		fprintf(stderr, "failed to malloc memory for pids\n");
+		exit(EXIT_FAILURE);
+	}
+	memset(pids, 0, nr_child * sizeof(pid_t));
+
+	/* create & truncate testfile first */
+	fd = open(filename, O_CREAT | O_TRUNC | O_RDWR, 0600);
+	if (fd < 0) {
+		perror("create & truncate testfile");
+		free(pids);
+		exit(EXIT_FAILURE);
+	}
+	if (do_trunc && (ftruncate(fd, blksz * nr_child) < 0)) {
+		perror("ftruncate failed");
+		free(pids);
+		exit(EXIT_FAILURE);
+	}
+	if (pre_fill) {
+		char *buf;
+		buf = malloc(blksz * nr_child);
+		memset(buf, 's', blksz * nr_child);
+		write(fd, buf, blksz * nr_child);
+		free(buf);
+	}
+	if (pre_alloc) {
+		fallocate(fd, 0, 0, blksz * nr_child);
+	}
+	fsync(fd);
+	close(fd);
+
+	/* fork workers */
+	for (i = 0; i < nr_child; i++) {
+		pid = fork();
+		if (pid < 0) {
+			perror("fork");
+			kill_children(pids, nr_child);
+			free(pids);
+			exit(EXIT_FAILURE);
+		} else if (pid == 0) {
+			/* never returns */
+			run_test(filename, i, blksz, offset, nr_iter,
+				 flag_rd, flag_wr);
+		} else {
+			pids[i] = pid;
+		}
+	}
+
+	ret = wait_children(pids, nr_child);
+	free(pids);
+	exit(ret);
+}
diff --git a/tests/generic/418 b/tests/generic/418
new file mode 100755
index 0000000..1fa782e
--- /dev/null
+++ b/tests/generic/418
@@ -0,0 +1,122 @@
+#! /bin/bash
+# FS QA Test 418
+#
+# Test pagecache invalidation in buffer/direct write/read combination.
+#
+# Fork N children, each child writes to and reads from its own region of the
+# same test file, and check if what it reads is what it writes. The test region
+# is determined by N * blksz. Write and read operation can be either direct or
+# buffered.
+#
+# Regression test for commit c771c14baa33 ("iomap: invalidate page caches
+# should be after iomap_dio_complete() in direct write")
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat Inc.  All Rights Reserved.
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
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_test
+_require_odirect
+_require_block_device $TEST_DEV
+_require_test_program "dio-invalidate-cache"
+_require_test_program "feature"
+
+diotest=$here/src/dio-invalidate-cache
+testfile=$TEST_DIR/$seq-diotest
+sectorsize=`blockdev --getss $TEST_DEV`
+pagesize=`src/feature -s`
+
+# test case array, test different write/read combinations
+# -r: use direct read
+# -w: use direct write
+# -t: truncate file to final size before test, i.e. write to hole
+# -p: fallocate whole file before test, i.e. write to allocated but unwritten extents
+# -F: fulfill whole file before test, i.e. write to allocated & written extents
+t_cases=(
+	"-w"
+	"-wt"
+	"-wp"
+	"-wF"
+	"-r"
+	"-rt"
+	"-rp"
+	"-rF"
+	"-rw"
+	"-rwt"
+	"-rwp"
+	"-rwF"
+)
+
+runtest()
+{
+	local i=0
+	local tc=""
+	local loop=$1
+	shift
+
+	for tc in ${t_cases[*]}; do
+		echo "diotest $tc $*" >> $seqres.full
+		i=0
+		while [ $i -lt $loop ]; do
+			$diotest $tc $* -f $testfile
+			if [ $? -ne 0 ]; then
+				echo "diotest $tc $* failed at loop $i" | \
+					tee -a $seqres.full
+				break
+			fi
+			let i=i+1
+		done
+	done
+}
+
+while [ $sectorsize -le $((pagesize * 2)) ]; do
+	# reproducer for the original bug
+	runtest $((10 * LOAD_FACTOR)) -b $sectorsize -n 3 -i 1
+	# try more processes and iterations
+	runtest $((5 * LOAD_FACTOR))  -b $sectorsize -n 8 -i 4
+	sectorsize=$((sectorsize * 2))
+done
+echo "Silence is golden"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/418.out b/tests/generic/418.out
new file mode 100644
index 0000000..954de31
--- /dev/null
+++ b/tests/generic/418.out
@@ -0,0 +1,2 @@
+QA output created by 418
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index f0096bb..0a272b7 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -420,3 +420,4 @@
 415 auto clone
 416 auto enospc
 417 auto quick shutdown log
+418 auto rw
-- 
2.9.3

