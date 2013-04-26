Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7787A7CBE
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 14:14:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 55E138F8035
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 12:14:07 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id zGYA8WeMZRXCVDF2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 26 Apr 2013 12:14:04 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 743139A033F
	for <xfs@oss.sgi.com>; Fri, 26 Apr 2013 13:14:03 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests 311: test fsync with dm flakey V3
Date: Fri, 26 Apr 2013 15:13:59 -0400
Message-ID: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

This test sets up a dm flakey target and then runs my fsync tester I've been
using to verify btrfs's fsync() is working properly.  It will create a dm flakey
device, mount it, run my test, make the flakey device start dropping writes, and
then unmount the fs.  Then we mount it back up and make sure the md5sums match
and then run fsck on the device to make sure we got a consistent fs.  I used the
output from a run on BTRFS since it's the only one that passes this test
properly.  I verified each test manually to make sure they were in fact valid
files.  XFS and Ext4 both fail this test in one way or another.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V2->V3:
-encorporate all of Dave Chinners feedback
-expand the testing to run the tests with normal dmsetup suspend and with
 --nolockfs

 common/config         |    1 +
 common/punch          |    7 -
 common/rc             |   23 ++
 src/Makefile          |    2 +-
 src/fsync-tester.c    |  537 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/311     |  161 +++++++++++++++
 tests/generic/311.out |  321 +++++++++++++++++++++++++++++
 tests/generic/group   |    1 +
 8 files changed, 1045 insertions(+), 8 deletions(-)
 create mode 100644 src/fsync-tester.c
 create mode 100755 tests/generic/311
 create mode 100644 tests/generic/311.out

diff --git a/common/config b/common/config
index dfbb5c2..b8ab593 100644
--- a/common/config
+++ b/common/config
@@ -177,6 +177,7 @@ export FIO_PROG="`set_prog_path fio`"
 export FILEFRAG_PROG="`set_prog_path filefrag`"
 export E4DEFRAG_PROG="`set_prog_path e4defrag`"
 export LOGGER_PROG="`set_prog_path logger`"
+export DMSETUP_PROG="`set_prog_path dmsetup`"
 
 # Generate a comparable xfsprogs version number in the form of
 # major * 10000 + minor * 100 + release
diff --git a/common/punch b/common/punch
index cfbe576..b9f9acd 100644
--- a/common/punch
+++ b/common/punch
@@ -234,13 +234,6 @@ _filter_hole_fiemap()
 	_coalesce_extents
 }
 
-
-# Prints the md5 checksum of a given file
-_md5_checksum()
-{
-	md5sum $1 | cut -d ' ' -f1
-}
-
 _filter_bmap()
 {
 	awk '
diff --git a/common/rc b/common/rc
index b980697..ff18cc2 100644
--- a/common/rc
+++ b/common/rc
@@ -57,6 +57,13 @@ dd()
    fi
 }
 
+# Prints the md5 checksum of a given file
+_md5_checksum()
+{
+	md5sum $1 | cut -d ' ' -f1
+}
+
+
 # ls -l w/ selinux sometimes puts a dot at the end:
 # -rwxrw-r--. id1 id2 file1
 
@@ -1041,6 +1048,22 @@ _require_command()
     [ -n "$1" -a -x "$1" ] || _notrun "$_cmd utility required, skipped this test"
 }
 
+# this test requires the device mapper flakey target
+#
+_require_dm_flakey()
+{
+    _require_command $DMSETUP_PROG
+
+    modprobe dm-flakey >/dev/null 2>&1
+    $DMSETUP_PROG targets | grep flakey >/dev/null 2>&1
+    if [ $? -eq 0 ]
+    then
+	:
+    else
+	_notrun "This test requires dm flakey support"
+    fi
+}
+
 # this test requires the projid32bit feature to be available in
 # mkfs.xfs
 #
diff --git a/src/Makefile b/src/Makefile
index 8d8e97f..c18ffc9 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
-	seek_copy_test t_readdir_1 t_readdir_2
+	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester
 
 SUBDIRS =
 
diff --git a/src/fsync-tester.c b/src/fsync-tester.c
new file mode 100644
index 0000000..9f6b12d
--- /dev/null
+++ b/src/fsync-tester.c
@@ -0,0 +1,537 @@
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+
+static int test_fd;
+static char *buf;
+static char *fname;
+
+/*
+ * Just creates a random file, overwriting the file in a random number of loops
+ * and fsyncing between each loop.
+ */
+static int test_one(int *max_blocks)
+{
+	int loops = (random() % 20) + 5;
+
+	lseek(test_fd, 0, SEEK_SET);
+	while (loops--) {
+		int character = (random() % 126) + 33; /* printable character */
+		int blocks = (random() % 100) + 1;
+
+		if (blocks > *max_blocks)
+			*max_blocks = blocks;
+		lseek(test_fd, 0, SEEK_SET);
+		memset(buf, character, 4096);
+		if (fsync(test_fd)) {
+			fprintf(stderr, "Fsync failed, test results will be "
+				"invalid: %d\n", errno);
+			return 1;
+		}
+
+		while (blocks--) {
+			if (write(test_fd, buf, 4096) < 4096) {
+				fprintf(stderr, "Short write %d\n", errno);
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Preallocate a randomly sized file and then overwrite the entire thing and
+ * then fsync.
+ */
+static int test_two(int *max_blocks)
+{
+	int blocks = (random() % 1024) + 1;
+	int character = (random() % 126) + 33;
+
+	*max_blocks = blocks;
+
+	if (fallocate(test_fd, 0, 0, blocks * 4096)) {
+		fprintf(stderr, "Error fallocating %d (%s)\n", errno,
+			strerror(errno));
+		return 1;
+	}
+
+	lseek(test_fd, 0, SEEK_SET);
+	memset(buf, character, 4096);
+	while (blocks--) {
+		if (write(test_fd, buf, 4096) < 4096) {
+			fprintf(stderr, "Short write %d\n", errno);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static void drop_all_caches()
+{
+	char value[] = "3\n";
+	int fd;
+
+	if ((fd = open("/proc/sys/vm/drop_caches", O_WRONLY)) < 0) {
+		fprintf(stderr, "Error opening drop caches: %d\n", errno);
+		return;
+	}
+
+	write(fd, value, sizeof(value)-1);
+	close(fd);
+}
+
+/*
+ * Randomly write inside of a file, either creating a sparse file or prealloc
+ * the file and randomly write within it, depending on the prealloc flag
+ */
+static int test_three(int *max_blocks, int prealloc, int rand_fsync,
+		      int sync, int drop_caches)
+{
+	int size = (random() % 2048) + 4;
+	int blocks = size / 2;
+	int sync_block = blocks / 2;
+	int rand_sync_interval = (random() % blocks) + 1;
+	int character = (random() % 126) + 33;
+
+	if (prealloc && fallocate(test_fd, 0, 0, size * 4096)) {
+		fprintf(stderr, "Error fallocating %d (%s)\n", errno,
+			strerror(errno));
+		return 1;
+	}
+
+	if (prealloc)
+		*max_blocks = size;
+
+	memset(buf, character, 4096);
+	while (blocks--) {
+		int block = (random() % size);
+
+		if ((block + 1) > *max_blocks)
+			*max_blocks = block + 1;
+
+		if (rand_fsync && !(blocks % rand_sync_interval)) {
+			if (fsync(test_fd)) {
+				fprintf(stderr, "Fsync failed, test results "
+					"will be invalid: %d\n", errno);
+				return 1;
+			}
+		}
+
+		/* Force a transaction commit in between just for fun */
+		if (blocks == sync_block && (sync || drop_caches)) {
+			if (sync)
+				syncfs(test_fd);
+			else
+				sync_file_range(test_fd, 0, 0,
+						SYNC_FILE_RANGE_WRITE|
+						SYNC_FILE_RANGE_WAIT_AFTER);
+
+			if (drop_caches) {
+				close(test_fd);
+				drop_all_caches();
+				test_fd = open(fname, O_RDWR);
+				if (test_fd < 0) {
+					test_fd = 0;
+					fprintf(stderr, "Error re-opening file: %d\n",
+						errno);
+					return 1;
+				}
+			}
+		}
+
+		if (pwrite(test_fd, buf, 4096, block * 4096) < 4096) {
+			fprintf(stderr, "Short write %d\n", errno);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static void timeval_subtract(struct timeval *result,struct timeval *x,
+			     struct timeval *y)
+{
+	if (x->tv_usec < y->tv_usec) {
+		int nsec = (y->tv_usec - x->tv_usec) / 1000000 + 1;
+		y->tv_usec -= 1000000 * nsec;
+		y->tv_sec += nsec;
+	}
+
+	if (x->tv_usec - y->tv_usec > 1000000) {
+		int nsec = (x->tv_usec - y->tv_usec) / 1000000;
+		y->tv_usec += 1000000 * nsec;
+		y->tv_sec -= nsec;
+	}
+
+	result->tv_sec = x->tv_sec - y->tv_sec;
+	result->tv_usec = x->tv_usec - y->tv_usec;
+}
+
+static int test_four(int *max_blocks)
+{
+	size_t size = 2621440;	/* 10 gigabytes */
+	size_t blocks = size / 2;
+	size_t sync_block = blocks / 8;	/* fsync 8 times */
+	int character = (random() % 126) + 33;
+	struct timeval start, end, diff;
+
+	memset(buf, character, 4096);
+	while (blocks--) {
+		off_t block = (random() % size);
+
+		if ((block + 1) > *max_blocks)
+			*max_blocks = block + 1;
+
+		if ((blocks % sync_block) == 0) {
+			if (gettimeofday(&start, NULL)) {
+				fprintf(stderr, "Error getting time: %d\n",
+					errno);
+				return 1;
+			}
+			if (fsync(test_fd)) {
+				fprintf(stderr, "Fsync failed, test results "
+					"will be invalid: %d\n", errno);
+				return 1;
+			}
+			if (gettimeofday(&end, NULL)) {
+				fprintf(stderr, "Error getting time: %d\n",
+					errno);
+				return 1;
+			}
+			timeval_subtract(&diff, &end, &start);
+			printf("Fsync time was %ds and %dus\n",
+			       (int)diff.tv_sec, (int)diff.tv_usec);
+		}
+
+		if (pwrite(test_fd, buf, 4096, block * 4096) < 4096) {
+			fprintf(stderr, "Short write %d\n", errno);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int test_five()
+{
+	int character = (random() % 126) + 33;
+	int runs = (random() % 100) + 1;
+	int i;
+
+	memset(buf, character, 3072);
+	for (i = 0; i < runs; i++) {
+		size_t write_size = (random() % 3072) + 1;
+
+		if (pwrite(test_fd, buf, write_size, 0) < write_size) {
+			fprintf(stderr, "Short write %d\n", errno);
+			return 1;
+		}
+
+		if ((i % 8) == 0) {
+			if (fsync(test_fd)) {
+				fprintf(stderr, "Fsync failed, test results "
+					"will be invalid: %d\n", errno);
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Reproducer for something like this
+ *
+ * [data][prealloc][data]
+ *
+ * and then in the [prealloc] section we have
+ *
+ * [ pre ][pre][     pre     ]
+ * [d][pp][dd][ppp][d][ppp][d]
+ *
+ * where each letter represents on block of either data or prealloc.
+ *
+ * This explains all the weirdly specific numbers.
+ */
+static int test_six()
+{
+	int character = (random() % 126) + 33;
+	int i;
+
+	memset(buf, character, 4096);
+
+	/* Write on either side of the file, leaving a hole in the middle */
+	for (i = 0; i < 10; i++) {
+		if (pwrite(test_fd, buf, 4096, i * 4096) < 4096) {
+			fprintf(stderr, "Short write %d\n", errno);
+			return 1;
+		}
+	}
+
+	if (fsync(test_fd)) {
+		fprintf(stderr, "Fsync failed %d\n", errno);
+		return 1;
+	}
+
+	/*
+	 * The test fs I had the prealloc extent was 13 4k blocks long so I'm
+	 * just using that to give myself the best chances of reproducing.
+	 */
+	for (i = 23; i < 33; i++) {
+		if (pwrite(test_fd, buf, 4096, i * 4096) < 4096) {
+			fprintf(stderr, "Short write %d\n", errno);
+			return 1;
+		}
+	}
+
+	if (fsync(test_fd)) {
+		fprintf(stderr, "Fsync failed %d\n", errno);
+		return 1;
+	}
+
+	if (fallocate(test_fd, 0, 10 * 4096, 4 * 4096)) {
+		fprintf(stderr, "Error fallocating %d\n", errno);
+		return 1;
+	}
+
+	if (fallocate(test_fd, 0, 14 * 4096, 5 * 4096)) {
+		fprintf(stderr, "Error fallocating %d\n", errno);
+		return 1;
+	}
+
+	if (fallocate(test_fd, 0, 19 * 4096, 4 * 4096)) {
+		fprintf(stderr, "Error fallocating %d\n", errno);
+		return 1;
+	}
+
+	if (pwrite(test_fd, buf, 4096, 10 * 4096) < 4096) {
+		fprintf(stderr, "Short write %d\n", errno);
+		return 1;
+	}
+
+	if (fsync(test_fd)) {
+		fprintf(stderr, "Fsync failed %d\n", errno);
+		return 1;
+	}
+
+	for (i = 13; i < 15; i++) {
+		if (pwrite(test_fd, buf, 4096, i * 4096) < 4096) {
+			fprintf(stderr, "Short write %d\n", errno);
+			return 1;
+		}
+	}
+
+	if (fsync(test_fd)) {
+		fprintf(stderr, "Fsync failed %d\n", errno);
+		return 1;
+	}
+
+	if (pwrite(test_fd, buf, 4096, 18 * 4096) < 4096) {
+		fprintf(stderr, "Short write %d\n", errno);
+		return 1;
+	}
+
+	if (fsync(test_fd)) {
+		fprintf(stderr, "Fsync failed %d\n", errno);
+		return 1;
+	}
+
+	if (pwrite(test_fd, buf, 4096, 22 * 4096) < 4096) {
+		fprintf(stderr, "Short write %d\n", errno);
+		return 1;
+	}
+
+	if (fsync(test_fd)) {
+		fprintf(stderr, "Fsync failed %d\n", errno);
+		return 1;
+	}
+
+	return 0;
+}
+
+static void usage()
+{
+	printf("Usage fsync-tester [-s <seed>] [-r] [-d] -t <test-num> <filename>\n");
+	printf("   -s seed   : seed for teh random map generator (defaults to reading /dev/urandom)\n");
+	printf("   -r        : don't reboot the box immediately\n");
+	printf("   -d        : use O_DIRECT\n");
+	printf("   -t test   : test nr to run, required\n");
+	exit(1);
+}
+
+int main(int argc, char **argv)
+{
+	int opt;
+	int fd;
+	int max_blocks = 0;
+	char *endptr;
+	unsigned int seed = 123;
+	int reboot = 0;
+	int direct_io = 0;
+	long int test = 1;
+	long int tmp;
+	int ret = 0;
+	int flags = O_RDWR|O_CREAT|O_TRUNC;
+
+	if (argc < 2)
+		usage();
+
+	fd = open("/dev/urandom", O_RDONLY);
+	if (fd >= 0) {
+		read(fd, &seed, sizeof(seed));
+		close(fd);
+	}
+
+	while ((opt = getopt(argc, argv, "s:rdt:")) != -1) {
+		switch (opt) {
+		case 's':
+			tmp = strtol(optarg, &endptr, 10);
+			if (tmp == LONG_MAX || endptr == optarg)
+				usage();
+			seed = tmp;
+			break;
+		case 'r':
+			reboot = 1;
+			break;
+		case 'd':
+			direct_io = 1;
+			break;
+		case 't':
+			test = strtol(optarg, &endptr, 10);
+			if (test == LONG_MAX || endptr == optarg)
+				usage();
+			break;
+		default:
+			usage();
+		}
+	}
+
+	if (optind >= argc)
+		usage();
+
+	fname = argv[optind];
+	if (!fname)
+		usage();
+
+	printf("Random seed is %u\n", seed);
+	srandom(seed);
+
+	if (direct_io) {
+		flags |= O_DIRECT;
+		ret = posix_memalign((void **)&buf, getpagesize(), 4096);
+		if (ret)
+			buf = NULL;
+	} else {
+		buf = malloc(4096);
+	}
+
+	if (!buf) {
+		fprintf(stderr, "Error allocating buf: %d\n", errno);
+		return 1;
+	}
+
+	test_fd = open(fname, flags, 0644);
+	if (test_fd < 0) {
+		fprintf(stderr, "Error opening file %d (%s)\n", errno,
+			strerror(errno));
+		return 1;
+	}
+
+	switch (test) {
+	case 1:
+		ret = test_one(&max_blocks);
+		break;
+	case 2:
+		ret = test_two(&max_blocks);
+		break;
+	case 3:
+		ret = test_three(&max_blocks, 0, 0, 0, 0);
+		break;
+	case 4:
+		ret = test_three(&max_blocks, 1, 0, 0, 0);
+		break;
+	case 5:
+		ret = test_three(&max_blocks, 0, 1, 0, 0);
+		break;
+	case 6:
+		ret = test_three(&max_blocks, 1, 1, 0, 0);
+		break;
+	case 7:
+		ret = test_three(&max_blocks, 0, 0, 1, 0);
+		break;
+	case 8:
+		ret = test_three(&max_blocks, 1, 0, 1, 0);
+		break;
+	case 9:
+		ret = test_three(&max_blocks, 0, 1, 1, 0);
+		break;
+	case 10:
+		ret = test_three(&max_blocks, 1, 1, 1, 0);
+		break;
+	case 11:
+		ret = test_three(&max_blocks, 0, 0, 0, 1);
+		break;
+	case 12:
+		ret = test_three(&max_blocks, 0, 1, 0, 1);
+		break;
+	case 13:
+		ret = test_three(&max_blocks, 0, 0, 1, 1);
+		break;
+	case 14:
+		ret = test_three(&max_blocks, 0, 1, 1, 1);
+		break;
+	case 15:
+		ret = test_three(&max_blocks, 1, 0, 0, 1);
+		break;
+	case 16:
+		ret = test_three(&max_blocks, 1, 1, 0, 1);
+		break;
+	case 17:
+		ret = test_three(&max_blocks, 1, 0, 1, 1);
+		break;
+	case 18:
+		ret = test_three(&max_blocks, 1, 1, 1, 1);
+		break;
+	case 19:
+		ret = test_five();
+		break;
+	case 20:
+		ret = test_six();
+		break;
+	case 21:
+		/*
+		 * This is just a perf test, keep moving it down so it's always
+		 * the last test option.
+		 */
+		reboot = 0;
+		ret = test_four(&max_blocks);
+		goto out;
+	default:
+		usage();
+	}
+
+	if (ret)
+		goto out;
+
+	if (fsync(test_fd)) {
+		fprintf(stderr, "Fsync failed, test results will be invalid: "
+			"%d\n", errno);
+		return 1;
+	}
+	if (reboot)
+		system("reboot -fn");
+out:
+	free(buf);
+	close(test_fd);
+	return ret;
+}
diff --git a/tests/generic/311 b/tests/generic/311
new file mode 100755
index 0000000..2b3b569
--- /dev/null
+++ b/tests/generic/311
@@ -0,0 +1,161 @@
+#! /bin/bash
+# FS QA Test No. 311
+#
+# Run various fsync tests with dm flakey in freeze() mode and non freeze()
+# mode. The idea is that we do random writes and randomly fsync and verify that
+# after a fsync() followed by a freeze()+failure or just failure that the file
+# is correct.  We remount the file system after the failure so that the file
+# system can do whatever cleanup it needs to and md5sum the file to make sure
+# it matches hat it was before the failure.  We also fsck to make sure the file
+# system is consistent.
+#
+# The fsync tester just random writes into prealloc or not, and then fsync()s
+# randomly or sync()'s randomly and then fsync()'s before exit.  There are a few
+# tests that were handcrafted to reproduce bugs in btrfs, so it's also a
+# regression test of sorts.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Fusion IO. All Rights Reserved.
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
+status=1	# failure is the default!
+
+_cleanup()
+{
+	# If dmsetup load fails then we need to make sure to do resume here
+	# otherwise the umount will hang
+	$DMSETUP_PROG resume flakey-test > /dev/null 2>&1
+	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	$DMSETUP_PROG remove flakey-test > /dev/null 2>&1
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_dm_flakey
+
+[ -x $here/src/fsync-tester ] || _notrun "fsync-tester not build"
+
+rm -f $seqres.full
+BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
+FLAKEY_DEV=/dev/mapper/flakey-test
+SEED=1
+testfile=$SCRATCH_MNT/$seq.fsync
+FLAKEY_TABLE="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 180 0"
+FLAKEY_TABLE_DROP="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 0 180 1 drop_writes"
+_TEST_OPTIONS=""
+
+_mount_flakey()
+{
+	mount -t $FSTYP $MOUNT_OPTIONS $FLAKEY_DEV $SCRATCH_MNT
+}
+
+_unmount_flakey()
+{
+	$UMOUNT_PROG $SCRATCH_MNT
+}
+
+_load_flakey_table()
+{
+	# _load_flakey_table <table>
+
+	table="$FLAKEY_TABLE"
+	[ $1 -eq 1 ] && table="$FLAKEY_TABLE_DROP"
+
+	suspend_opt=""
+	[ $nolockfs -eq 1 ] && suspend_opt="--nolockfs"
+
+	$DMSETUP_PROG suspend $suspend_opt flakey-test
+	[ $? -ne 0 ] && _fatal "failed to suspend flakey-test"
+
+	$DMSETUP_PROG load flakey-test --table "$table"
+	[ $? -ne 0 ] && _fatal "failed to load table into flakey-test"
+
+	$DMSETUP_PROG resume flakey-test
+	[ $? -ne 0 ] && _fatal  "failed to resumeflakey-test"
+}
+
+_run_test()
+{
+	# _run_test <testnum> <0 - buffered | 1 - O_DIRECT>
+	allow_writes=0
+	drop_writes=1
+	test_num=$1
+
+	direct_opt=""
+	[ $2 -eq 1 ] && direct_opt="-d"
+
+	$here/src/fsync-tester -s $SEED -t $test_num $direct_opt $testfile
+	[ $? -ne 0 ] && _fatal "fsync tester exited abnormally"
+
+	_md5_checksum $testfile
+	_load_flakey_table $drop_writes
+	_unmount_flakey
+
+	#Ok mount so that any recovery that needs to happen is done
+	_load_flakey_table $allow_writes
+	_mount_flakey
+	_md5_checksum $testfile
+
+	#Unmount and fsck to make sure we got a valid fs after replay
+	_unmount_flakey
+	_check_scratch_fs
+	[ $? -ne 0 ] && _fatal "fsck failed"
+
+	_mount_flakey
+}
+
+_scratch_mkfs >> $seqres.full 2>&1
+
+# Create a basic flakey device that will never error out
+$DMSETUP_PROG create flakey-test --table "$FLAKEY_TABLE"
+[ $? -ne 0 ] && _fatal "failed to create flakey device"
+
+_mount_flakey
+
+buffered=0
+direct=1
+
+for i in $(seq 1 20); do
+	nolockfs=0
+	SEED=$i
+	echo "Running test $i buffered, normal suspend"
+	_run_test $i $buffered
+	echo "Running test $i direct, normal suspend"
+	_run_test $i $direct
+
+	nolockfs=1
+	echo "Running test $i buffered, nolockfs"
+	_run_test $i $buffered
+	echo "Running test $i direct, nolockfs"
+	_run_test $i $direct
+done
+
+status=0
+exit
diff --git a/tests/generic/311.out b/tests/generic/311.out
new file mode 100644
index 0000000..5bad6a7
--- /dev/null
+++ b/tests/generic/311.out
@@ -0,0 +1,321 @@
+QA output created by 311
+Running test 1 buffered, normal suspend
+Random seed is 1
+ee6103415276cde95544b11b2675f132
+ee6103415276cde95544b11b2675f132
+Running test 1 direct, normal suspend
+Random seed is 1
+ee6103415276cde95544b11b2675f132
+ee6103415276cde95544b11b2675f132
+Running test 1 buffered, nolockfs
+Random seed is 1
+ee6103415276cde95544b11b2675f132
+ee6103415276cde95544b11b2675f132
+Running test 1 direct, nolockfs
+Random seed is 1
+ee6103415276cde95544b11b2675f132
+ee6103415276cde95544b11b2675f132
+Running test 2 buffered, normal suspend
+Random seed is 2
+42d4a277a0a64deff214f15bb932a6e6
+42d4a277a0a64deff214f15bb932a6e6
+Running test 2 direct, normal suspend
+Random seed is 2
+42d4a277a0a64deff214f15bb932a6e6
+42d4a277a0a64deff214f15bb932a6e6
+Running test 2 buffered, nolockfs
+Random seed is 2
+42d4a277a0a64deff214f15bb932a6e6
+42d4a277a0a64deff214f15bb932a6e6
+Running test 2 direct, nolockfs
+Random seed is 2
+42d4a277a0a64deff214f15bb932a6e6
+42d4a277a0a64deff214f15bb932a6e6
+Running test 3 buffered, normal suspend
+Random seed is 3
+076dcf77aa365c8dfe567d973cad207a
+076dcf77aa365c8dfe567d973cad207a
+Running test 3 direct, normal suspend
+Random seed is 3
+076dcf77aa365c8dfe567d973cad207a
+076dcf77aa365c8dfe567d973cad207a
+Running test 3 buffered, nolockfs
+Random seed is 3
+076dcf77aa365c8dfe567d973cad207a
+076dcf77aa365c8dfe567d973cad207a
+Running test 3 direct, nolockfs
+Random seed is 3
+076dcf77aa365c8dfe567d973cad207a
+076dcf77aa365c8dfe567d973cad207a
+Running test 4 buffered, normal suspend
+Random seed is 4
+4c76ca100e40574a32f98b520d2e210d
+4c76ca100e40574a32f98b520d2e210d
+Running test 4 direct, normal suspend
+Random seed is 4
+4c76ca100e40574a32f98b520d2e210d
+4c76ca100e40574a32f98b520d2e210d
+Running test 4 buffered, nolockfs
+Random seed is 4
+4c76ca100e40574a32f98b520d2e210d
+4c76ca100e40574a32f98b520d2e210d
+Running test 4 direct, nolockfs
+Random seed is 4
+4c76ca100e40574a32f98b520d2e210d
+4c76ca100e40574a32f98b520d2e210d
+Running test 5 buffered, normal suspend
+Random seed is 5
+c79cdc2af7d4a18af401a919f7c21f20
+c79cdc2af7d4a18af401a919f7c21f20
+Running test 5 direct, normal suspend
+Random seed is 5
+c79cdc2af7d4a18af401a919f7c21f20
+c79cdc2af7d4a18af401a919f7c21f20
+Running test 5 buffered, nolockfs
+Random seed is 5
+c79cdc2af7d4a18af401a919f7c21f20
+c79cdc2af7d4a18af401a919f7c21f20
+Running test 5 direct, nolockfs
+Random seed is 5
+c79cdc2af7d4a18af401a919f7c21f20
+c79cdc2af7d4a18af401a919f7c21f20
+Running test 6 buffered, normal suspend
+Random seed is 6
+02d28dd2bbd4be579fea4128e7804dda
+02d28dd2bbd4be579fea4128e7804dda
+Running test 6 direct, normal suspend
+Random seed is 6
+02d28dd2bbd4be579fea4128e7804dda
+02d28dd2bbd4be579fea4128e7804dda
+Running test 6 buffered, nolockfs
+Random seed is 6
+02d28dd2bbd4be579fea4128e7804dda
+02d28dd2bbd4be579fea4128e7804dda
+Running test 6 direct, nolockfs
+Random seed is 6
+02d28dd2bbd4be579fea4128e7804dda
+02d28dd2bbd4be579fea4128e7804dda
+Running test 7 buffered, normal suspend
+Random seed is 7
+15b0f93f2f12c3feb34024af345adc21
+15b0f93f2f12c3feb34024af345adc21
+Running test 7 direct, normal suspend
+Random seed is 7
+15b0f93f2f12c3feb34024af345adc21
+15b0f93f2f12c3feb34024af345adc21
+Running test 7 buffered, nolockfs
+Random seed is 7
+15b0f93f2f12c3feb34024af345adc21
+15b0f93f2f12c3feb34024af345adc21
+Running test 7 direct, nolockfs
+Random seed is 7
+15b0f93f2f12c3feb34024af345adc21
+15b0f93f2f12c3feb34024af345adc21
+Running test 8 buffered, normal suspend
+Random seed is 8
+77bad17366ceaa24f538c915345aeb02
+77bad17366ceaa24f538c915345aeb02
+Running test 8 direct, normal suspend
+Random seed is 8
+77bad17366ceaa24f538c915345aeb02
+77bad17366ceaa24f538c915345aeb02
+Running test 8 buffered, nolockfs
+Random seed is 8
+77bad17366ceaa24f538c915345aeb02
+77bad17366ceaa24f538c915345aeb02
+Running test 8 direct, nolockfs
+Random seed is 8
+77bad17366ceaa24f538c915345aeb02
+77bad17366ceaa24f538c915345aeb02
+Running test 9 buffered, normal suspend
+Random seed is 9
+c989c34943ff1b1115d582d8cb7afa0d
+c989c34943ff1b1115d582d8cb7afa0d
+Running test 9 direct, normal suspend
+Random seed is 9
+c989c34943ff1b1115d582d8cb7afa0d
+c989c34943ff1b1115d582d8cb7afa0d
+Running test 9 buffered, nolockfs
+Random seed is 9
+c989c34943ff1b1115d582d8cb7afa0d
+c989c34943ff1b1115d582d8cb7afa0d
+Running test 9 direct, nolockfs
+Random seed is 9
+c989c34943ff1b1115d582d8cb7afa0d
+c989c34943ff1b1115d582d8cb7afa0d
+Running test 10 buffered, normal suspend
+Random seed is 10
+d76096280f08ca8907dfd53c102b3987
+d76096280f08ca8907dfd53c102b3987
+Running test 10 direct, normal suspend
+Random seed is 10
+d76096280f08ca8907dfd53c102b3987
+d76096280f08ca8907dfd53c102b3987
+Running test 10 buffered, nolockfs
+Random seed is 10
+d76096280f08ca8907dfd53c102b3987
+d76096280f08ca8907dfd53c102b3987
+Running test 10 direct, nolockfs
+Random seed is 10
+d76096280f08ca8907dfd53c102b3987
+d76096280f08ca8907dfd53c102b3987
+Running test 11 buffered, normal suspend
+Random seed is 11
+1144c9b3147873328cf4e81d066cd3da
+1144c9b3147873328cf4e81d066cd3da
+Running test 11 direct, normal suspend
+Random seed is 11
+1144c9b3147873328cf4e81d066cd3da
+1144c9b3147873328cf4e81d066cd3da
+Running test 11 buffered, nolockfs
+Random seed is 11
+1144c9b3147873328cf4e81d066cd3da
+1144c9b3147873328cf4e81d066cd3da
+Running test 11 direct, nolockfs
+Random seed is 11
+1144c9b3147873328cf4e81d066cd3da
+1144c9b3147873328cf4e81d066cd3da
+Running test 12 buffered, normal suspend
+Random seed is 12
+ae31d41d825b392bdd6b2453e05ad02e
+ae31d41d825b392bdd6b2453e05ad02e
+Running test 12 direct, normal suspend
+Random seed is 12
+ae31d41d825b392bdd6b2453e05ad02e
+ae31d41d825b392bdd6b2453e05ad02e
+Running test 12 buffered, nolockfs
+Random seed is 12
+ae31d41d825b392bdd6b2453e05ad02e
+ae31d41d825b392bdd6b2453e05ad02e
+Running test 12 direct, nolockfs
+Random seed is 12
+ae31d41d825b392bdd6b2453e05ad02e
+ae31d41d825b392bdd6b2453e05ad02e
+Running test 13 buffered, normal suspend
+Random seed is 13
+63f0ccfc767186236f887e5b25466e7d
+63f0ccfc767186236f887e5b25466e7d
+Running test 13 direct, normal suspend
+Random seed is 13
+63f0ccfc767186236f887e5b25466e7d
+63f0ccfc767186236f887e5b25466e7d
+Running test 13 buffered, nolockfs
+Random seed is 13
+63f0ccfc767186236f887e5b25466e7d
+63f0ccfc767186236f887e5b25466e7d
+Running test 13 direct, nolockfs
+Random seed is 13
+63f0ccfc767186236f887e5b25466e7d
+63f0ccfc767186236f887e5b25466e7d
+Running test 14 buffered, normal suspend
+Random seed is 14
+9085b05b3af61c8ce63430219d4a72d1
+9085b05b3af61c8ce63430219d4a72d1
+Running test 14 direct, normal suspend
+Random seed is 14
+9085b05b3af61c8ce63430219d4a72d1
+9085b05b3af61c8ce63430219d4a72d1
+Running test 14 buffered, nolockfs
+Random seed is 14
+9085b05b3af61c8ce63430219d4a72d1
+9085b05b3af61c8ce63430219d4a72d1
+Running test 14 direct, nolockfs
+Random seed is 14
+9085b05b3af61c8ce63430219d4a72d1
+9085b05b3af61c8ce63430219d4a72d1
+Running test 15 buffered, normal suspend
+Random seed is 15
+bda67622d5430b65c60d3d929949dbd8
+bda67622d5430b65c60d3d929949dbd8
+Running test 15 direct, normal suspend
+Random seed is 15
+bda67622d5430b65c60d3d929949dbd8
+bda67622d5430b65c60d3d929949dbd8
+Running test 15 buffered, nolockfs
+Random seed is 15
+bda67622d5430b65c60d3d929949dbd8
+bda67622d5430b65c60d3d929949dbd8
+Running test 15 direct, nolockfs
+Random seed is 15
+bda67622d5430b65c60d3d929949dbd8
+bda67622d5430b65c60d3d929949dbd8
+Running test 16 buffered, normal suspend
+Random seed is 16
+840e068eb58a9b68d31d6f8addc5b5dd
+840e068eb58a9b68d31d6f8addc5b5dd
+Running test 16 direct, normal suspend
+Random seed is 16
+840e068eb58a9b68d31d6f8addc5b5dd
+840e068eb58a9b68d31d6f8addc5b5dd
+Running test 16 buffered, nolockfs
+Random seed is 16
+840e068eb58a9b68d31d6f8addc5b5dd
+840e068eb58a9b68d31d6f8addc5b5dd
+Running test 16 direct, nolockfs
+Random seed is 16
+840e068eb58a9b68d31d6f8addc5b5dd
+840e068eb58a9b68d31d6f8addc5b5dd
+Running test 17 buffered, normal suspend
+Random seed is 17
+9d2d33931de2bb1fb07ee67a7daea6e8
+9d2d33931de2bb1fb07ee67a7daea6e8
+Running test 17 direct, normal suspend
+Random seed is 17
+9d2d33931de2bb1fb07ee67a7daea6e8
+9d2d33931de2bb1fb07ee67a7daea6e8
+Running test 17 buffered, nolockfs
+Random seed is 17
+9d2d33931de2bb1fb07ee67a7daea6e8
+9d2d33931de2bb1fb07ee67a7daea6e8
+Running test 17 direct, nolockfs
+Random seed is 17
+9d2d33931de2bb1fb07ee67a7daea6e8
+9d2d33931de2bb1fb07ee67a7daea6e8
+Running test 18 buffered, normal suspend
+Random seed is 18
+4bf90f24854b21e314924996bd7ec39e
+4bf90f24854b21e314924996bd7ec39e
+Running test 18 direct, normal suspend
+Random seed is 18
+4bf90f24854b21e314924996bd7ec39e
+4bf90f24854b21e314924996bd7ec39e
+Running test 18 buffered, nolockfs
+Random seed is 18
+4bf90f24854b21e314924996bd7ec39e
+4bf90f24854b21e314924996bd7ec39e
+Running test 18 direct, nolockfs
+Random seed is 18
+4bf90f24854b21e314924996bd7ec39e
+4bf90f24854b21e314924996bd7ec39e
+Running test 19 buffered, normal suspend
+Random seed is 19
+26b2ad08ac2589804a15ceb473f0b1ac
+26b2ad08ac2589804a15ceb473f0b1ac
+Running test 19 direct, normal suspend
+Random seed is 19
+26b2ad08ac2589804a15ceb473f0b1ac
+26b2ad08ac2589804a15ceb473f0b1ac
+Running test 19 buffered, nolockfs
+Random seed is 19
+26b2ad08ac2589804a15ceb473f0b1ac
+26b2ad08ac2589804a15ceb473f0b1ac
+Running test 19 direct, nolockfs
+Random seed is 19
+26b2ad08ac2589804a15ceb473f0b1ac
+26b2ad08ac2589804a15ceb473f0b1ac
+Running test 20 buffered, normal suspend
+Random seed is 20
+a16ac2b84456d41a15a1a4cc1202179f
+a16ac2b84456d41a15a1a4cc1202179f
+Running test 20 direct, normal suspend
+Random seed is 20
+a16ac2b84456d41a15a1a4cc1202179f
+a16ac2b84456d41a15a1a4cc1202179f
+Running test 20 buffered, nolockfs
+Random seed is 20
+a16ac2b84456d41a15a1a4cc1202179f
+a16ac2b84456d41a15a1a4cc1202179f
+Running test 20 direct, nolockfs
+Random seed is 20
+a16ac2b84456d41a15a1a4cc1202179f
+a16ac2b84456d41a15a1a4cc1202179f
diff --git a/tests/generic/group b/tests/generic/group
index eb52833..5a03a09 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -113,3 +113,4 @@
 308 auto quick
 309 auto quick
 310 auto
+311 auto metadata log
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
