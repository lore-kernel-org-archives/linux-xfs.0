Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34128 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfFDVU6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:20:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LJMR7030882
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:20:55 GMT
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2sugstfk0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:20:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LKULC161845
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:20:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2swnh9u0p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:20:54 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54LKsfp009387
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:20:54 GMT
Date: Tue, 4 Jun 2019 14:20:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] xfstests: test new v5 bulkstat commands
Message-ID: <20190604212052.GE1200785@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Check that the new v5 bulkstat commands do everything the old one do,
and then make sure the new functionality actually works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs                 |    6 ++
 src/Makefile               |    2 -
 src/bulkstat_null_ocount.c |   61 ++++++++++++++++
 tests/xfs/085              |    2 -
 tests/xfs/086              |    2 -
 tests/xfs/087              |    2 -
 tests/xfs/088              |    2 -
 tests/xfs/089              |    2 -
 tests/xfs/091              |    2 -
 tests/xfs/093              |    2 -
 tests/xfs/097              |    2 -
 tests/xfs/130              |    2 -
 tests/xfs/235              |    2 -
 tests/xfs/271              |    2 -
 tests/xfs/744              |  171 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/744.out          |  105 +++++++++++++++++++++++++++
 tests/xfs/745              |   44 +++++++++++
 tests/xfs/745.out          |    2 +
 tests/xfs/group            |    2 +
 19 files changed, 403 insertions(+), 12 deletions(-)
 create mode 100644 src/bulkstat_null_ocount.c
 create mode 100755 tests/xfs/744
 create mode 100644 tests/xfs/744.out
 create mode 100755 tests/xfs/745
 create mode 100644 tests/xfs/745.out

diff --git a/common/xfs b/common/xfs
index 2510665e..8c1ec4f2 100644
--- a/common/xfs
+++ b/common/xfs
@@ -862,3 +862,9 @@ _force_xfsv4_mount_options()
 	fi
 	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
 }
+
+# Find AG count of mounted filesystem
+_xfs_mount_agcount()
+{
+	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
+}
diff --git a/src/Makefile b/src/Makefile
index 9d3d2529..c4fcf370 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -28,7 +28,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
 	dio-invalidate-cache stat_test t_encrypted_d_revalidate \
 	attr_replace_test swapon mkswap t_attr_corruption t_open_tmpfiles \
-	fscrypt-crypt-util
+	fscrypt-crypt-util bulkstat_null_ocount
 
 SUBDIRS = log-writes perf
 
diff --git a/src/bulkstat_null_ocount.c b/src/bulkstat_null_ocount.c
new file mode 100644
index 00000000..b8f8fd39
--- /dev/null
+++ b/src/bulkstat_null_ocount.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * Ensure the kernel returns the new lastip even when ocount is null.
+ */
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <xfs/xfs.h>
+
+static void die(const char *tag)
+{
+	perror(tag);
+	exit(1);
+}
+
+int main(int argc, char *argv[])
+{
+	struct xfs_bstat	bstat;
+	__u64			last;
+	struct xfs_fsop_bulkreq bulkreq = {
+		.lastip		= &last,
+		.icount		= 1,
+		.ubuffer	= &bstat,
+		.ocount		= NULL,
+	};
+	int ret;
+	int fd;
+
+	fd = open(argv[1], O_RDONLY);
+	if (fd < 0)
+		die(argv[1]);
+
+	last = 0;
+	ret = ioctl(fd, XFS_IOC_FSINUMBERS, &bulkreq);
+	if (ret)
+		die("inumbers");
+
+	if (last == 0)
+		printf("inumbers last = %llu\n", (unsigned long long)last);
+
+	last = 0;
+	ret = ioctl(fd, XFS_IOC_FSBULKSTAT, &bulkreq);
+	if (ret)
+		die("bulkstat");
+
+	if (last == 0)
+		printf("bulkstat last = %llu\n", (unsigned long long)last);
+
+	ret = close(fd);
+	if (ret)
+		die("close");
+
+	return 0;
+}
diff --git a/tests/xfs/085 b/tests/xfs/085
index 23095413..18ddeff8 100755
--- a/tests/xfs/085
+++ b/tests/xfs/085
@@ -63,7 +63,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/086 b/tests/xfs/086
index 8602a565..7429d39d 100755
--- a/tests/xfs/086
+++ b/tests/xfs/086
@@ -64,7 +64,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 test "${agcount}" -gt 1 || _notrun "Single-AG XFS not supported"
 umount "${SCRATCH_MNT}"
 
diff --git a/tests/xfs/087 b/tests/xfs/087
index ede8e447..b3d3bca9 100755
--- a/tests/xfs/087
+++ b/tests/xfs/087
@@ -64,7 +64,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/088 b/tests/xfs/088
index 6f36efab..74b45163 100755
--- a/tests/xfs/088
+++ b/tests/xfs/088
@@ -64,7 +64,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/089 b/tests/xfs/089
index 5c398299..bcbc6363 100755
--- a/tests/xfs/089
+++ b/tests/xfs/089
@@ -64,7 +64,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/091 b/tests/xfs/091
index 5d6cd363..be56d8ae 100755
--- a/tests/xfs/091
+++ b/tests/xfs/091
@@ -64,7 +64,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/093 b/tests/xfs/093
index e09e8499..4c4fbdc4 100755
--- a/tests/xfs/093
+++ b/tests/xfs/093
@@ -64,7 +64,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/097 b/tests/xfs/097
index db355de6..68eae1d4 100755
--- a/tests/xfs/097
+++ b/tests/xfs/097
@@ -67,7 +67,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/130 b/tests/xfs/130
index 71c1181f..f15366a6 100755
--- a/tests/xfs/130
+++ b/tests/xfs/130
@@ -43,7 +43,7 @@ _scratch_mkfs_xfs > /dev/null
 echo "+ mount fs image"
 _scratch_mount
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
-agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$(_xfs_mount_agcount $SCRATCH_MNT)"
 
 echo "+ make some files"
 _pwrite_byte 0x62 0 $((blksz * 64)) "${SCRATCH_MNT}/file0" >> "$seqres.full"
diff --git a/tests/xfs/235 b/tests/xfs/235
index 669f58b0..64b0a0b5 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -41,7 +41,7 @@ _scratch_mkfs_xfs > /dev/null
 echo "+ mount fs image"
 _scratch_mount
 blksz=$(stat -f -c '%s' ${SCRATCH_MNT})
-agcount=$($XFS_INFO_PROG ${SCRATCH_MNT} | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')
+agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
 
 echo "+ make some files"
 _pwrite_byte 0x62 0 $((blksz * 64)) ${SCRATCH_MNT}/file0 >> $seqres.full
diff --git a/tests/xfs/271 b/tests/xfs/271
index db14bfec..38844246 100755
--- a/tests/xfs/271
+++ b/tests/xfs/271
@@ -37,7 +37,7 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 
-agcount=$($XFS_INFO_PROG $SCRATCH_MNT | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')
+agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
 
 echo "Get fsmap" | tee -a $seqres.full
 $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT > $TEST_DIR/fsmap
diff --git a/tests/xfs/744 b/tests/xfs/744
new file mode 100755
index 00000000..cf3a3e81
--- /dev/null
+++ b/tests/xfs/744
@@ -0,0 +1,171 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 744
+#
+# Use the xfs_io bulkstat utility to verify bulkstat finds all inodes in a
+# filesystem.  Test under various inode counts, inobt record layouts and
+# bulkstat batch sizes.
+#
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
+    rm -f $tmp.*
+}
+
+# print the number of inodes counted by bulkstat
+_bstat_count()
+{
+	local batchsize="$1"
+	local tag="$2"
+
+	echo -n "$tag: "
+	$XFS_IO_PROG -c "bulkstat -n $batchsize" $SCRATCH_MNT | grep ino | wc -l
+}
+
+# print the number of inodes counted by per-ag bulkstat
+_bstat_perag_count()
+{
+	local batchsize="$1"
+	local tag="$2"
+
+	local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
+	echo -n "$tag: "
+	seq 0 $((agcount - 1)) | while read ag; do
+		$XFS_IO_PROG -c "bulkstat -a $ag -n $batchsize" $SCRATCH_MNT
+	done | grep ino | wc -l
+}
+
+# Sum the number of allocated inodes in a fs...
+_inumbers_ag()
+{
+	local agcount="$1"
+	local batchsize="$2"
+	local mount="$3"
+
+	seq 0 $((agcount - 1)) | while read ag; do
+		$XFS_IO_PROG -c "inumbers -a $ag -n $batchsize" $mount
+	done | grep alloccount | awk '{x += $3} END { print(x) }'
+}
+
+# print the number of inodes counted by inumbers
+_inumbers_count()
+{
+	local expect="$1"
+
+	# There probably aren't more than 10 hidden inodes, right?
+	local tolerance=10
+
+	# Force all background inode cleanup
+	_scratch_cycle_mount
+
+	echo -n "inumbers all: "
+	nr=$($XFS_IO_PROG -c "inumbers" $SCRATCH_MNT | grep alloccount | \
+		awk '{x += $3} END { print(x) }')
+	_within_tolerance "inumbers" $nr $expect $tolerance -v
+
+	local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
+	for batchsize in 64 2 1; do
+		echo -n "inumbers $batchsize: "
+		nr=$(_inumbers_ag $agcount $batchsize $SCRATCH_MNT)
+		_within_tolerance "inumbers" $nr $expect $tolerance -v
+	done
+}
+
+# compare the src/bstat output against the xfs_io bstat output
+_bstat_compare()
+{
+	diff -u <(./src/bstat $SCRATCH_MNT | grep ino | awk '{print $2}') \
+		<($XFS_IO_PROG -c 'bulkstat' $SCRATCH_MNT | grep ino | awk '{print $3}')
+}
+
+# print bulkstat counts using varied batch sizes
+_bstat_test()
+{
+	expect=`find $SCRATCH_MNT -print | wc -l`
+	echo
+	echo "expect $expect"
+
+	for sz in 4096 71 32 1; do
+		_bstat_count $sz "$sz all"
+		_bstat_perag_count $sz "$sz perag"
+		_bstat_compare
+		_inumbers_count $expect
+	done
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_require_scratch
+_require_xfs_io_command bulkstat
+_require_xfs_io_command bulkstat_single
+_require_xfs_io_command inumbers
+
+# real QA test starts here
+
+_supported_fs xfs
+_supported_os Linux
+
+rm -f $seqres.full
+
+DIRCOUNT=8
+INOCOUNT=$((2048 / DIRCOUNT))
+
+_scratch_mkfs "-d agcount=$DIRCOUNT" >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount
+
+# who is the root inode?
+bs_root=$($XFS_IO_PROG -c 'bulkstat_single root' $SCRATCH_MNT 2> /dev/null | grep ino | \
+	awk '{print $3}')
+stat_root=$(stat -c '%i' $SCRATCH_MNT)
+if [ -n "$bs_root" ] && [ "$stat_root" -ne "$bs_root" ]; then
+	echo "stat says root is $stat_root but bulkstat says $bs_root"
+fi
+
+# create a set of directories and fill each with a fixed number of files
+for dir in $(seq 1 $DIRCOUNT); do
+	mkdir -p $SCRATCH_MNT/$dir
+	for i in $(seq 1 $INOCOUNT); do
+		touch $SCRATCH_MNT/$dir/$i
+	done
+done
+_bstat_test
+
+# remove every other file from each dir
+for dir in $(seq 1 $DIRCOUNT); do
+	for i in $(seq 2 2 $INOCOUNT); do
+		rm -f $SCRATCH_MNT/$dir/$i
+	done
+done
+_bstat_test
+
+# remove the entire second half of files
+for dir in $(seq 1 $DIRCOUNT); do
+	for i in $(seq $((INOCOUNT / 2)) $INOCOUNT); do
+		rm -f $SCRATCH_MNT/$dir/$i
+	done
+done
+_bstat_test
+
+# remove all regular files
+for dir in $(seq 1 $DIRCOUNT); do
+	rm -f $SCRATCH_MNT/$dir/*
+done
+_bstat_test
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/744.out b/tests/xfs/744.out
new file mode 100644
index 00000000..250089d1
--- /dev/null
+++ b/tests/xfs/744.out
@@ -0,0 +1,105 @@
+QA output created by 744
+
+expect 2057
+4096 all: 2057
+4096 perag: 2057
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+71 all: 2057
+71 perag: 2057
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+32 all: 2057
+32 perag: 2057
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+1 all: 2057
+1 perag: 2057
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+
+expect 1033
+4096 all: 1033
+4096 perag: 1033
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+71 all: 1033
+71 perag: 1033
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+32 all: 1033
+32 perag: 1033
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+1 all: 1033
+1 perag: 1033
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+
+expect 521
+4096 all: 521
+4096 perag: 521
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+71 all: 521
+71 perag: 521
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+32 all: 521
+32 perag: 521
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+1 all: 521
+1 perag: 521
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+
+expect 9
+4096 all: 9
+4096 perag: 9
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+71 all: 9
+71 perag: 9
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+32 all: 9
+32 perag: 9
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
+1 all: 9
+1 perag: 9
+inumbers all: inumbers is in range
+inumbers 64: inumbers is in range
+inumbers 2: inumbers is in range
+inumbers 1: inumbers is in range
diff --git a/tests/xfs/745 b/tests/xfs/745
new file mode 100755
index 00000000..6931d46b
--- /dev/null
+++ b/tests/xfs/745
@@ -0,0 +1,44 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 745
+#
+# Regression test for a long-standing bug in BULKSTAT and INUMBERS where
+# the kernel fails to write thew new @lastip value back to userspace if
+# @ocount is NULL.
+#
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
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_require_test_program "bulkstat_null_ocount"
+
+# real QA test starts here
+
+_supported_fs xfs
+_supported_os Linux
+
+rm -f $seqres.full
+
+echo "Silence is golden."
+src/bulkstat_null_ocount $TEST_DIR
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/745.out b/tests/xfs/745.out
new file mode 100644
index 00000000..ce947de2
--- /dev/null
+++ b/tests/xfs/745.out
@@ -0,0 +1,2 @@
+QA output created by 745
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index e528c559..044fa797 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -504,4 +504,6 @@
 504 auto quick mkfs label
 505 auto quick spaceman
 506 auto quick health
+744 auto ioctl quick
+745 auto ioctl quick
 907 clone
