Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51540 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfGXENr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 00:13:47 -0400
Subject: [PATCH 4/4] xfs: test new v5 bulkstat commands
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 23 Jul 2019 21:13:38 -0700
Message-ID: <156394161882.1850833.4351446431166375360.stgit@magnolia>
In-Reply-To: <156394159426.1850833.16316913520596851191.stgit@magnolia>
References: <156394159426.1850833.16316913520596851191.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check that the new v5 bulkstat commands do everything the old one do,
and then make sure the new functionality actually works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs                 |    6 +
 src/Makefile               |    2 
 src/bulkstat_null_ocount.c |   61 +++++++++
 tests/xfs/085              |    2 
 tests/xfs/086              |    2 
 tests/xfs/087              |    2 
 tests/xfs/088              |    2 
 tests/xfs/089              |    2 
 tests/xfs/091              |    2 
 tests/xfs/093              |    2 
 tests/xfs/097              |    2 
 tests/xfs/130              |    2 
 tests/xfs/235              |    2 
 tests/xfs/271              |    2 
 tests/xfs/744              |  212 +++++++++++++++++++++++++++++++
 tests/xfs/744.out          |  297 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/745              |   44 +++++++
 tests/xfs/745.out          |    2 
 tests/xfs/group            |    2 
 19 files changed, 636 insertions(+), 12 deletions(-)
 create mode 100644 src/bulkstat_null_ocount.c
 create mode 100755 tests/xfs/744
 create mode 100644 tests/xfs/744.out
 create mode 100755 tests/xfs/745
 create mode 100644 tests/xfs/745.out


diff --git a/common/xfs b/common/xfs
index 2b38e94b..1bce3c18 100644
--- a/common/xfs
+++ b/common/xfs
@@ -878,3 +878,9 @@ _force_xfsv4_mount_options()
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
index 00000000..ef605301
--- /dev/null
+++ b/tests/xfs/744
@@ -0,0 +1,212 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
+# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 744
+#
+# Use the xfs_io bulkstat utility to verify bulkstat finds all inodes in a
+# filesystem.  Test under various inode counts, inobt record layouts and
+# bulkstat batch sizes.  Test v1 and v5 ioctls explicitly, as well as the
+# ioctl version autodetection code in libfrog.
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
+	cd /
+	rm -f $tmp.*
+}
+
+bstat_versions()
+{
+	echo "default"
+	echo "v1 -v1"
+	if [ -n "$has_v5" ]; then
+		echo "v5 -v5"
+	else
+		echo "v5"
+	fi
+}
+
+# print the number of inodes counted by bulkstat
+bstat_count()
+{
+	local batchsize="$1"
+	local tag="$2"
+
+	bstat_versions | while read v_tag v_flag; do
+		echo "$tag($v_tag): passing \"$v_flag\" to bulkstat" >> $seqres.full
+		echo -n "bulkstat $tag($v_tag): "
+		$XFS_IO_PROG -c "bulkstat -n $batchsize $vflag" $SCRATCH_MNT | grep ino | wc -l
+	done
+}
+
+# print the number of inodes counted by per-ag bulkstat
+bstat_perag_count()
+{
+	local batchsize="$1"
+	local tag="$2"
+
+	local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
+
+	bstat_versions | while read v_tag v_flag; do
+		echo -n "bulkstat $tag($v_tag): "
+		seq 0 $((agcount - 1)) | while read ag; do
+			$XFS_IO_PROG -c "bulkstat -a $ag -n $batchsize $v_flag" $SCRATCH_MNT
+		done | grep ino | wc -l
+	done
+}
+
+# Sum the number of allocated inodes in each AG in a fs.
+inumbers_ag()
+{
+	local agcount="$1"
+	local batchsize="$2"
+	local mount="$3"
+	local v_flag="$4"
+
+	seq 0 $((agcount - 1)) | while read ag; do
+		$XFS_IO_PROG -c "inumbers -a $ag -n $batchsize $v_flag" $mount
+	done | grep alloccount | awk '{x += $3} END { print(x) }'
+}
+
+# Sum the number of allocated inodes in the whole fs all at once.
+inumbers_fs()
+{
+	local dir="$1"
+	local v_flag="$2"
+
+	$XFS_IO_PROG -c "inumbers $v_flag" "$dir" | grep alloccount | \
+		awk '{x += $3} END { print(x) }'
+}
+
+# print the number of inodes counted by inumbers
+inumbers_count()
+{
+	local expect="$1"
+
+	# There probably aren't more than 10 hidden inodes, right?
+	local tolerance=10
+
+	# Force all background inode cleanup
+	_scratch_cycle_mount
+
+	bstat_versions | while read v_tag v_flag; do
+		echo -n "inumbers all($v_tag): "
+		nr=$(inumbers_fs $SCRATCH_MNT $v_flag)
+		_within_tolerance "inumbers" $nr $expect $tolerance -v
+
+		local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
+		for batchsize in 64 2 1; do
+			echo -n "inumbers $batchsize($v_tag): "
+			nr=$(inumbers_ag $agcount $batchsize $SCRATCH_MNT $v_flag)
+			_within_tolerance "inumbers" $nr $expect $tolerance -v
+		done
+	done
+}
+
+# compare the src/bstat output against the xfs_io bstat output
+bstat_compare()
+{
+	bstat_versions | while read v_tag v_flag; do
+		diff -u <(./src/bstat $SCRATCH_MNT | grep ino | awk '{print $2}') \
+			<($XFS_IO_PROG -c "bulkstat $v_flag" $SCRATCH_MNT | grep ino | awk '{print $3}')
+	done
+}
+
+# print bulkstat counts using varied batch sizes
+bstat_test()
+{
+	expect=`find $SCRATCH_MNT -print | wc -l`
+	echo
+	echo "expect $expect"
+
+	for sz in 4096 71 32 1; do
+		bstat_count $sz "$sz all"
+		bstat_perag_count $sz "$sz perag"
+		bstat_compare
+		inumbers_count $expect
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
+# Figure out if we have v5 bulkstat/inumbers ioctls.
+has_v5=
+bs_root_out="$($XFS_IO_PROG -c 'bulkstat_single root' $SCRATCH_MNT 2>>$seqres.full)"
+test -n "$bs_root_out" && has_v5=1
+
+echo "this will be 1 if we have v5 bulkstat: $has_v5" >> $seqres.full
+
+# If v5 bulkstat is present, query the root inode and compare it to the stat
+# output of $SCRATCH_MNT to make sure it gave us the correct number
+if [ -n "$has_v5" ]; then
+	bs_root=$(echo "$bs_root_out" | grep ino | awk '{print $3}')
+	stat_root=$(stat -c '%i' $SCRATCH_MNT)
+	if [ "$stat_root" -ne "$bs_root" ]; then
+		echo "stat says root is $stat_root but bulkstat says $bs_root"
+	fi
+fi
+
+# create a set of directories and fill each with a fixed number of files
+for dir in $(seq 1 $DIRCOUNT); do
+	mkdir -p $SCRATCH_MNT/$dir
+	for i in $(seq 1 $INOCOUNT); do
+		touch $SCRATCH_MNT/$dir/$i
+	done
+done
+bstat_test
+
+# remove every other file from each dir
+for dir in $(seq 1 $DIRCOUNT); do
+	for i in $(seq 2 2 $INOCOUNT); do
+		rm -f $SCRATCH_MNT/$dir/$i
+	done
+done
+bstat_test
+
+# remove the entire second half of files
+for dir in $(seq 1 $DIRCOUNT); do
+	for i in $(seq $((INOCOUNT / 2)) $INOCOUNT); do
+		rm -f $SCRATCH_MNT/$dir/$i
+	done
+done
+bstat_test
+
+# remove all regular files
+for dir in $(seq 1 $DIRCOUNT); do
+	rm -f $SCRATCH_MNT/$dir/*
+done
+bstat_test
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/744.out b/tests/xfs/744.out
new file mode 100644
index 00000000..de89a8ff
--- /dev/null
+++ b/tests/xfs/744.out
@@ -0,0 +1,297 @@
+QA output created by 744
+
+expect 2057
+bulkstat 4096 all(default): 2057
+bulkstat 4096 all(v1): 2057
+bulkstat 4096 all(v5): 2057
+bulkstat 4096 perag(default): 2057
+bulkstat 4096 perag(v1): 2057
+bulkstat 4096 perag(v5): 2057
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 71 all(default): 2057
+bulkstat 71 all(v1): 2057
+bulkstat 71 all(v5): 2057
+bulkstat 71 perag(default): 2057
+bulkstat 71 perag(v1): 2057
+bulkstat 71 perag(v5): 2057
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 32 all(default): 2057
+bulkstat 32 all(v1): 2057
+bulkstat 32 all(v5): 2057
+bulkstat 32 perag(default): 2057
+bulkstat 32 perag(v1): 2057
+bulkstat 32 perag(v5): 2057
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 1 all(default): 2057
+bulkstat 1 all(v1): 2057
+bulkstat 1 all(v5): 2057
+bulkstat 1 perag(default): 2057
+bulkstat 1 perag(v1): 2057
+bulkstat 1 perag(v5): 2057
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+
+expect 1033
+bulkstat 4096 all(default): 1033
+bulkstat 4096 all(v1): 1033
+bulkstat 4096 all(v5): 1033
+bulkstat 4096 perag(default): 1033
+bulkstat 4096 perag(v1): 1033
+bulkstat 4096 perag(v5): 1033
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 71 all(default): 1033
+bulkstat 71 all(v1): 1033
+bulkstat 71 all(v5): 1033
+bulkstat 71 perag(default): 1033
+bulkstat 71 perag(v1): 1033
+bulkstat 71 perag(v5): 1033
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 32 all(default): 1033
+bulkstat 32 all(v1): 1033
+bulkstat 32 all(v5): 1033
+bulkstat 32 perag(default): 1033
+bulkstat 32 perag(v1): 1033
+bulkstat 32 perag(v5): 1033
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 1 all(default): 1033
+bulkstat 1 all(v1): 1033
+bulkstat 1 all(v5): 1033
+bulkstat 1 perag(default): 1033
+bulkstat 1 perag(v1): 1033
+bulkstat 1 perag(v5): 1033
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+
+expect 521
+bulkstat 4096 all(default): 521
+bulkstat 4096 all(v1): 521
+bulkstat 4096 all(v5): 521
+bulkstat 4096 perag(default): 521
+bulkstat 4096 perag(v1): 521
+bulkstat 4096 perag(v5): 521
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 71 all(default): 521
+bulkstat 71 all(v1): 521
+bulkstat 71 all(v5): 521
+bulkstat 71 perag(default): 521
+bulkstat 71 perag(v1): 521
+bulkstat 71 perag(v5): 521
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 32 all(default): 521
+bulkstat 32 all(v1): 521
+bulkstat 32 all(v5): 521
+bulkstat 32 perag(default): 521
+bulkstat 32 perag(v1): 521
+bulkstat 32 perag(v5): 521
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 1 all(default): 521
+bulkstat 1 all(v1): 521
+bulkstat 1 all(v5): 521
+bulkstat 1 perag(default): 521
+bulkstat 1 perag(v1): 521
+bulkstat 1 perag(v5): 521
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+
+expect 9
+bulkstat 4096 all(default): 9
+bulkstat 4096 all(v1): 9
+bulkstat 4096 all(v5): 9
+bulkstat 4096 perag(default): 9
+bulkstat 4096 perag(v1): 9
+bulkstat 4096 perag(v5): 9
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 71 all(default): 9
+bulkstat 71 all(v1): 9
+bulkstat 71 all(v5): 9
+bulkstat 71 perag(default): 9
+bulkstat 71 perag(v1): 9
+bulkstat 71 perag(v5): 9
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 32 all(default): 9
+bulkstat 32 all(v1): 9
+bulkstat 32 all(v5): 9
+bulkstat 32 perag(default): 9
+bulkstat 32 perag(v1): 9
+bulkstat 32 perag(v5): 9
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 1 all(default): 9
+bulkstat 1 all(v1): 9
+bulkstat 1 all(v5): 9
+bulkstat 1 perag(default): 9
+bulkstat 1 perag(v1): 9
+bulkstat 1 perag(v5): 9
+inumbers all(default): inumbers is in range
+inumbers 64(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 64(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 64(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
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
index 270d82ff..ef0cf92c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -506,3 +506,5 @@
 506 auto quick health
 507 clone
 508 auto quick quota
+744 auto ioctl quick
+745 auto ioctl quick
