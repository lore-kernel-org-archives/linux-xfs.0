Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60544 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727251AbfBMUtN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 15:49:13 -0500
Date: Wed, 13 Feb 2019 12:49:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 2/2] generic: check the behavior of programs opening a lot
 of O_TMPFILE files
Message-ID: <20190213204905.GC6477@magnolia>
References: <154993786231.2062.8490515215533507881.stgit@magnolia>
 <154993787478.2062.17047634303195751186.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154993787478.2062.17047634303195751186.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a test (+ helper program) that opens as many unlinked files as it
possibly can on the scratch filesystem, then closes all the files at
once to stress-test unlinked file cleanup.  Add an xfs-specific test to
make sure that the fallback code doesn't bitrot.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: g/710 and x/736 now test log recovery processing of unlinked inodes
---
 .gitignore            |    1 
 src/Makefile          |    2 -
 src/t_open_tmpfiles.c |  166 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/710     |   64 +++++++++++++++++++
 tests/generic/710.out |    2 +
 tests/generic/711     |   70 +++++++++++++++++++++
 tests/generic/711.out |    2 +
 tests/generic/group   |    2 +
 tests/xfs/736         |   90 +++++++++++++++++++++++++++
 tests/xfs/736.out     |    2 +
 tests/xfs/737         |   75 ++++++++++++++++++++++
 tests/xfs/737.out     |    2 +
 tests/xfs/group       |    2 +
 13 files changed, 479 insertions(+), 1 deletion(-)
 create mode 100644 src/t_open_tmpfiles.c
 create mode 100755 tests/generic/710
 create mode 100644 tests/generic/710.out
 create mode 100755 tests/generic/711
 create mode 100644 tests/generic/711.out
 create mode 100755 tests/xfs/736
 create mode 100644 tests/xfs/736.out
 create mode 100755 tests/xfs/737
 create mode 100644 tests/xfs/737.out

diff --git a/.gitignore b/.gitignore
index 0933dc7d..6454e4d6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -135,6 +135,7 @@
 /src/t_mmap_writev
 /src/t_mtab
 /src/t_ofd_locks
+/src/t_open_tmpfiles
 /src/t_readdir_1
 /src/t_readdir_2
 /src/t_rename_overwrite
diff --git a/src/Makefile b/src/Makefile
index ae09eb0a..dbba7c78 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -27,7 +27,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
 	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
 	dio-invalidate-cache stat_test t_encrypted_d_revalidate \
-	attr_replace_test swapon mkswap t_attr_corruption
+	attr_replace_test swapon mkswap t_attr_corruption t_open_tmpfiles
 
 SUBDIRS = log-writes perf
 
diff --git a/src/t_open_tmpfiles.c b/src/t_open_tmpfiles.c
new file mode 100644
index 00000000..9e70fbaa
--- /dev/null
+++ b/src/t_open_tmpfiles.c
@@ -0,0 +1,166 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * Test program to open unlinked files and leak them.
+ */
+#ifndef _GNU_SOURCE
+# define _GNU_SOURCE
+#endif
+#include <time.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include "global.h"
+
+static int min_fd = -1;
+static int max_fd = -1;
+static unsigned int nr_opened = 0;
+static float start_time;
+static int shutdown_fs = 0;
+
+void clock_time(float *time)
+{
+	static clockid_t clkid = CLOCK_MONOTONIC;
+	struct timespec ts;
+	int ret;
+
+retry:
+	ret = clock_gettime(clkid, &ts);
+	if (ret) {
+		if (clkid == CLOCK_MONOTONIC) {
+			clkid = CLOCK_REALTIME;
+			goto retry;
+		}
+		perror("clock_gettime");
+		exit(2);
+	}
+	*time = ts.tv_sec + ((float)ts.tv_nsec / 1000000000);
+}
+
+/*
+ * Exit the program due to an error.
+ *
+ * If we've exhausted all the file descriptors, make sure we close all the
+ * open fds in the order we received them in order to exploit a quirk of ext4
+ * and xfs where the oldest unlinked inodes are at the /end/ of the unlinked
+ * lists, which will make removing the unlinked files maximally painful.
+ *
+ * If it's some other error, just die and let the kernel sort it out.
+ */
+void die(void)
+{
+	float end_time;
+	int fd;
+
+	switch (errno) {
+	case EMFILE:
+	case ENFILE:
+	case ENOSPC:
+		clock_time(&end_time);
+		printf("Opened %u files in %.2fs.\n", nr_opened,
+				end_time - start_time);
+		fflush(stdout);
+
+		if (shutdown_fs) {
+			int flag = XFS_FSOP_GOING_FLAGS_NOLOGFLUSH;
+			int ret;
+
+			ret = ioctl(min_fd, XFS_IOC_GOINGDOWN, &flag);
+			if (ret) {
+				perror("shutdown");
+				exit(2);
+			}
+			exit(0);
+		}
+
+		clock_time(&start_time);
+		for (fd = min_fd; fd <= max_fd; fd++)
+			close(fd);
+		clock_time(&end_time);
+		printf("Closed %u files in %.2fs.\n", nr_opened,
+				end_time - start_time);
+		exit(0);
+		break;
+	default:
+		perror("open?");
+		exit(2);
+		break;
+	}
+}
+
+/* Remember how many file we open and all that. */
+void remember_fd(int fd)
+{
+	if (min_fd == -1 || min_fd > fd)
+		min_fd = fd;
+	if (max_fd == -1 || max_fd < fd)
+		max_fd = fd;
+	nr_opened++;
+}
+
+/* Put an opened file on the unlinked list and leak the fd. */
+void leak_tmpfile(void)
+{
+	int fd = -1;
+	int ret;
+#ifdef O_TMPFILE
+	static int try_o_tmpfile = 1;
+#endif
+
+	/* Try to create an O_TMPFILE and leak the fd. */
+#ifdef O_TMPFILE
+	if (try_o_tmpfile) {
+		fd = open(".", O_TMPFILE | O_RDWR, 0644);
+		if (fd >= 0) {
+			remember_fd(fd);
+			return;
+		}
+		if (fd < 0) {
+			if (errno == EOPNOTSUPP)
+				try_o_tmpfile = 0;
+			else
+				die();
+		}
+	}
+#endif
+
+	/* Oh well, create a new file, unlink it, and leak the fd. */
+	fd = open("./moo", O_CREAT | O_RDWR, 0644);
+	if (fd < 0)
+		die();
+	ret = unlink("./moo");
+	if (ret)
+		die();
+	remember_fd(fd);
+}
+
+/*
+ * Try to put as many files on the unlinked list and then kill them.
+ * The first argument is a directory to chdir into; passing any second arg
+ * will shut down the fs instead of closing files.
+ */
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1) {
+		ret = chdir(argv[1]);
+		if (ret)
+			perror(argv[1]);
+	}
+	if (argc > 2 && !strcmp(argv[2], "shutdown"))
+		shutdown_fs = 1;
+
+	clock_time(&start_time);
+	while (1)
+		leak_tmpfile();
+	return 0;
+}
diff --git a/tests/generic/710 b/tests/generic/710
new file mode 100755
index 00000000..e1e72c4d
--- /dev/null
+++ b/tests/generic/710
@@ -0,0 +1,64 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 710
+#
+# Stress test creating a lot of unlinked O_TMPFILE files and recovering them
+# after a crash, checking that we don't blow up the filesystem.  This is sort
+# of a performance test for the xfs unlinked inode backref patchset, but it
+# applies to most other filesystems.
+#
+# Use only a single CPU to test the single threaded situation.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+tmp=/tmp/$$
+status=1	# failure is the default!
+testfile=$TEST_DIR/$seq.txt
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
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_scratch_shutdown
+
+rm -f $seqres.full
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+# Set ULIMIT_NOFILE to min(file-max, 50000 files per LOAD_FACTOR)
+# so that this test doesn't take forever or OOM the box
+max_files=$((50000 * LOAD_FACTOR))
+max_allowable_files=$(( $(cat /proc/sys/fs/file-max) ))
+test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
+	max_files=$max_allowable_files
+ulimit -n $max_files
+
+# Open a lot of unlinked files
+echo create >> $seqres.full
+src/t_open_tmpfiles $SCRATCH_MNT/$i shutdown >> $seqres.full
+
+# Unmount to prove that we can clean it all
+echo umount >> $seqres.full
+before=$(date +%s)
+_scratch_unmount
+after=$(date +%s)
+echo "Unmount took $((after - before))s." >> $seqres.full
+
+# Mount so that we can run the usual checks
+echo silence is golden
+_scratch_mount
+status=0
+exit
diff --git a/tests/generic/710.out b/tests/generic/710.out
new file mode 100644
index 00000000..e0a55170
--- /dev/null
+++ b/tests/generic/710.out
@@ -0,0 +1,2 @@
+QA output created by 710
+silence is golden
diff --git a/tests/generic/711 b/tests/generic/711
new file mode 100755
index 00000000..0dd151b9
--- /dev/null
+++ b/tests/generic/711
@@ -0,0 +1,70 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 711
+#
+# Stress test creating a lot of unlinked O_TMPFILE files and closing them
+# all at once, checking that we don't blow up the filesystem.  This is sort
+# of a performance test for the xfs unlinked inode backref patchset, but it
+# applies to most other filesystems.
+#
+# Use every CPU possible to stress the filesystem.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+tmp=/tmp/$$
+status=1	# failure is the default!
+testfile=$TEST_DIR/$seq.txt
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
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+# Try to load up all the CPUs, two threads per CPU.
+nr_cpus=$(( $(getconf _NPROCESSORS_ONLN) * 2 ))
+
+# Set ULIMIT_NOFILE to min(file-max, 50000 files per LOAD_FACTOR)
+# so that this test doesn't take forever or OOM the box
+max_files=$((50000 * LOAD_FACTOR))
+max_allowable_files=$(( $(cat /proc/sys/fs/file-max) ))
+test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
+	max_files=$max_allowable_files
+ulimit -n $max_files
+
+# Open a lot of unlinked files
+echo create >> $seqres.full
+for i in $(seq 1 $nr_cpus); do
+	mkdir $SCRATCH_MNT/$i
+	src/t_open_tmpfiles $SCRATCH_MNT/$i >> $seqres.full &
+done
+wait
+
+# Unmount to prove that we can clean it all
+echo umount >> $seqres.full
+before=$(date +%s)
+_scratch_unmount
+after=$(date +%s)
+echo "Unmount took $((after - before))s." >> $seqres.full
+
+# Mount so that we can run the usual checks
+echo silence is golden
+_scratch_mount
+status=0
+exit
diff --git a/tests/generic/711.out b/tests/generic/711.out
new file mode 100644
index 00000000..cbbe36e9
--- /dev/null
+++ b/tests/generic/711.out
@@ -0,0 +1,2 @@
+QA output created by 711
+silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index b3086154..0233d5e8 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -529,4 +529,6 @@
 524 auto quick
 525 auto quick rw
 709 auto quick
+710 auto quick unlink
+711 auto quick unlink
 712 auto quick attr
diff --git a/tests/xfs/736 b/tests/xfs/736
new file mode 100755
index 00000000..b791cf5c
--- /dev/null
+++ b/tests/xfs/736
@@ -0,0 +1,90 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 736
+#
+# Stress test creating a lot of unlinked O_TMPFILE files and recovering them
+# after a crash, checking that we don't blow up the filesystem.  This is sort
+# of a performance test for the xfs unlinked inode backref patchset.
+#
+# Here we force the use of the slow iunlink bucket walk code in a single
+# threaded situation.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+tmp=/tmp/$$
+status=1	# failure is the default!
+testfile=$TEST_DIR/$seq.txt
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+delay_knob="/sys/fs/xfs/debug/log_recovery_delay"
+
+_cleanup()
+{
+	cd /
+	test -e "$delay_knob" && echo 0 > "$delay_knob"
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/inject
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_xfs_io_error_injection "iunlink_fallback"
+_require_xfs_sysfs debug/log_recovery_delay
+_require_scratch
+
+rm -f $seqres.full
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+# Set ULIMIT_NOFILE to min(file-max, 30000 files per LOAD_FACTOR)
+# so that this test doesn't take forever or OOM the box
+max_files=$((30000 * LOAD_FACTOR))
+max_allowable_files=$(( $(cat /proc/sys/fs/file-max) ))
+test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
+	max_files=$max_allowable_files
+ulimit -n $max_files
+
+# Open a lot of unlinked files
+echo create >> $seqres.full
+src/t_open_tmpfiles $SCRATCH_MNT/$i shutdown >> $seqres.full
+
+# Unmount to prove that we can clean it all
+echo umount >> $seqres.full
+before=$(date +%s)
+_scratch_unmount
+after=$(date +%s)
+echo "Unmount took $((after - before))s." >> $seqres.full
+
+# Force xfs to use the iunlinked fallback 50% of the time
+injector() {
+	# Slow down log recovery by 5s to give us enough time to set up
+	# error injection.
+	echo 5 > "$delay_knob"
+
+	# Try for 10s to set our knob.
+	knob="$(_find_xfs_mountdev_errortag_knob "${SCRATCH_DEV}" iunlink_fallback)"
+	nr=0
+	while [ ! -e "$knob" ] && [ "$nr" -lt 20 ]; do
+		sleep 0.5
+		nr=$((nr+1))
+	done
+	if [ -e "$knob" ]; then
+		echo 2 > "$knob"
+	else
+		echo "unable to set iunlink_fallback?"
+	fi
+}
+
+# Mount so that we can run the usual checks
+echo silence is golden
+injector &
+_scratch_mount
+status=0
+exit
diff --git a/tests/xfs/736.out b/tests/xfs/736.out
new file mode 100644
index 00000000..0258a248
--- /dev/null
+++ b/tests/xfs/736.out
@@ -0,0 +1,2 @@
+QA output created by 736
+silence is golden
diff --git a/tests/xfs/737 b/tests/xfs/737
new file mode 100755
index 00000000..2d8a32be
--- /dev/null
+++ b/tests/xfs/737
@@ -0,0 +1,75 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 737
+#
+# Stress test creating a lot of unlinked O_TMPFILE files and closing them
+# all at once, checking that we don't blow up the filesystem.  This is sort
+# of a performance test for the xfs unlinked inode backref patchset.
+#
+# Here we force the use of the slow iunlink bucket walk code, using every
+# CPU possible.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+tmp=/tmp/$$
+status=1	# failure is the default!
+testfile=$TEST_DIR/$seq.txt
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
+. ./common/inject
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+_require_xfs_io_error_injection "iunlink_fallback"
+_require_scratch
+
+rm -f $seqres.full
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+# Load up all the CPUs, two threads per CPU.
+nr_cpus=$(( $(getconf _NPROCESSORS_ONLN) * 2 ))
+
+# Set ULIMIT_NOFILE to min(file-max, 30000 files per cpu per LOAD_FACTOR)
+# so that this test doesn't take forever or OOM the box
+max_files=$((30000 * LOAD_FACTOR))
+max_allowable_files=$(( $(cat /proc/sys/fs/file-max) ))
+test $max_allowable_files -gt 0 && test $max_files -gt $max_allowable_files && \
+	max_files=$max_allowable_files
+ulimit -n $max_files
+
+# Force xfs to use the iunlinked fallback 50% of the time
+_scratch_inject_error "iunlink_fallback" "2"
+
+# Open a lot of unlinked files
+echo create >> $seqres.full
+for i in $(seq 1 $nr_cpus); do
+	mkdir $SCRATCH_MNT/$i
+	src/t_open_tmpfiles $SCRATCH_MNT/$i >> $seqres.full &
+done
+wait
+
+# Unmount to prove that we can clean it all
+echo umount >> $seqres.full
+before=$(date +%s)
+_scratch_unmount
+after=$(date +%s)
+echo "Unmount took $((after - before))s." >> $seqres.full
+
+# Mount so that we can run the usual checks
+echo silence is golden
+_scratch_mount
+status=0
+exit
diff --git a/tests/xfs/737.out b/tests/xfs/737.out
new file mode 100644
index 00000000..bdc4966d
--- /dev/null
+++ b/tests/xfs/737.out
@@ -0,0 +1,2 @@
+QA output created by 737
+silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 7b7d69f1..d3189cd5 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -497,3 +497,5 @@
 497 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 498 dangerous_fuzzers dangerous_norepair
 499 auto quick
+736 auto quick unlink
+737 auto quick unlink
