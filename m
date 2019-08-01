Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43618 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHABn2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 21:43:28 -0400
Subject: [PATCH 5/5] xfs: test new v5 bulkstat commands
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 31 Jul 2019 18:43:10 -0700
Message-ID: <156462379043.2945299.17354996626313190310.stgit@magnolia>
In-Reply-To: <156462375516.2945299.16564635037236083118.stgit@magnolia>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check that the new v5 bulkstat commands do everything the old one do,
and then make sure the new functionality actually works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 .gitignore                 |    1 
 src/Makefile               |    2 
 src/bulkstat_null_ocount.c |   61 +++++++++
 tests/xfs/744              |  215 ++++++++++++++++++++++++++++++++
 tests/xfs/744.out          |  297 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/745              |   47 +++++++
 tests/xfs/745.out          |    2 
 tests/xfs/group            |    2 
 8 files changed, 626 insertions(+), 1 deletion(-)
 create mode 100644 src/bulkstat_null_ocount.c
 create mode 100755 tests/xfs/744
 create mode 100644 tests/xfs/744.out
 create mode 100755 tests/xfs/745
 create mode 100644 tests/xfs/745.out


diff --git a/.gitignore b/.gitignore
index 11232be7..c8c815f9 100644
--- a/.gitignore
+++ b/.gitignore
@@ -55,6 +55,7 @@
 /src/attr_replace_test
 /src/attr-list-by-handle-cursor-test
 /src/bstat
+/src/bulkstat_null_ocount
 /src/bulkstat_unlink_test
 /src/bulkstat_unlink_test_modified
 /src/cloner
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
diff --git a/tests/xfs/744 b/tests/xfs/744
new file mode 100755
index 00000000..182c6ee5
--- /dev/null
+++ b/tests/xfs/744
@@ -0,0 +1,215 @@
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
+# Print the number of inodes counted by bulkstat
+bstat_count()
+{
+	local batchsize="$1"
+	local tag="$2"
+
+	bstat_versions | while read v_tag v_flag; do
+		echo "$tag($v_tag): passing \"$v_flag\" to bulkstat" >> $seqres.full
+		echo -n "bulkstat $tag($v_tag): "
+		$XFS_IO_PROG -c "bulkstat -n $batchsize $v_flag" $SCRATCH_MNT | grep ino | wc -l
+	done
+}
+
+# Print the number of inodes counted by per-ag bulkstat
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
+# Print the number of inodes counted by inumbers
+inumbers_count()
+{
+	local expect="$1"
+
+	# There probably aren't more than 10 hidden inodes, right?
+	local tolerance=10
+
+	# Force all background unlinked inode cleanup to run so that we don't
+	# race changes to the inode btree with our inumbers query.
+	_scratch_cycle_mount
+
+	bstat_versions | while read v_tag v_flag; do
+		echo -n "inumbers all($v_tag): "
+		nr=$(inumbers_fs $SCRATCH_MNT $v_flag)
+		_within_tolerance "inumbers" $nr $expect $tolerance -v
+
+		local agcount=$(_xfs_mount_agcount $SCRATCH_MNT)
+		for batchsize in 71 2 1; do
+			echo -n "inumbers $batchsize($v_tag): "
+			nr=$(inumbers_ag $agcount $batchsize $SCRATCH_MNT $v_flag)
+			_within_tolerance "inumbers" $nr $expect $tolerance -v
+		done
+	done
+}
+
+# Compare the src/bstat output against the xfs_io bstat output.
+# This compares the actual inode numbers output by one tool against another,
+# so we can't easily put the output in the golden output.
+bstat_compare()
+{
+	bstat_versions | while read v_tag v_flag; do
+		diff -u <(./src/bstat $SCRATCH_MNT | grep ino | awk '{print $2}') \
+			<($XFS_IO_PROG -c "bulkstat $v_flag" $SCRATCH_MNT | grep ino | awk '{print $3}')
+	done
+}
+
+# Print bulkstat counts using varied batch sizes
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
+# Get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_require_scratch
+_require_xfs_io_command bulkstat
+_require_xfs_io_command bulkstat_single
+_require_xfs_io_command inumbers
+
+# Real QA test starts here
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
+# Create a set of directories and fill each with a fixed number of files
+for dir in $(seq 1 $DIRCOUNT); do
+	mkdir -p $SCRATCH_MNT/$dir
+	for i in $(seq 1 $INOCOUNT); do
+		touch $SCRATCH_MNT/$dir/$i
+	done
+done
+bstat_test
+
+# Remove every other file from each dir
+for dir in $(seq 1 $DIRCOUNT); do
+	for i in $(seq 2 2 $INOCOUNT); do
+		rm -f $SCRATCH_MNT/$dir/$i
+	done
+done
+bstat_test
+
+# Remove the entire second half of files
+for dir in $(seq 1 $DIRCOUNT); do
+	for i in $(seq $((INOCOUNT / 2)) $INOCOUNT); do
+		rm -f $SCRATCH_MNT/$dir/$i
+	done
+done
+bstat_test
+
+# Remove all regular files
+for dir in $(seq 1 $DIRCOUNT); do
+	rm -f $SCRATCH_MNT/$dir/*
+done
+bstat_test
+
+# Success, all done
+status=0
+exit
diff --git a/tests/xfs/744.out b/tests/xfs/744.out
new file mode 100644
index 00000000..ed6b03cf
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
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 71 all(default): 2057
+bulkstat 71 all(v1): 2057
+bulkstat 71 all(v5): 2057
+bulkstat 71 perag(default): 2057
+bulkstat 71 perag(v1): 2057
+bulkstat 71 perag(v5): 2057
+inumbers all(default): inumbers is in range
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 32 all(default): 2057
+bulkstat 32 all(v1): 2057
+bulkstat 32 all(v5): 2057
+bulkstat 32 perag(default): 2057
+bulkstat 32 perag(v1): 2057
+bulkstat 32 perag(v5): 2057
+inumbers all(default): inumbers is in range
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 1 all(default): 2057
+bulkstat 1 all(v1): 2057
+bulkstat 1 all(v5): 2057
+bulkstat 1 perag(default): 2057
+bulkstat 1 perag(v1): 2057
+bulkstat 1 perag(v5): 2057
+inumbers all(default): inumbers is in range
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
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
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 71 all(default): 1033
+bulkstat 71 all(v1): 1033
+bulkstat 71 all(v5): 1033
+bulkstat 71 perag(default): 1033
+bulkstat 71 perag(v1): 1033
+bulkstat 71 perag(v5): 1033
+inumbers all(default): inumbers is in range
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 32 all(default): 1033
+bulkstat 32 all(v1): 1033
+bulkstat 32 all(v5): 1033
+bulkstat 32 perag(default): 1033
+bulkstat 32 perag(v1): 1033
+bulkstat 32 perag(v5): 1033
+inumbers all(default): inumbers is in range
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 1 all(default): 1033
+bulkstat 1 all(v1): 1033
+bulkstat 1 all(v5): 1033
+bulkstat 1 perag(default): 1033
+bulkstat 1 perag(v1): 1033
+bulkstat 1 perag(v5): 1033
+inumbers all(default): inumbers is in range
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
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
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 71 all(default): 521
+bulkstat 71 all(v1): 521
+bulkstat 71 all(v5): 521
+bulkstat 71 perag(default): 521
+bulkstat 71 perag(v1): 521
+bulkstat 71 perag(v5): 521
+inumbers all(default): inumbers is in range
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 32 all(default): 521
+bulkstat 32 all(v1): 521
+bulkstat 32 all(v5): 521
+bulkstat 32 perag(default): 521
+bulkstat 32 perag(v1): 521
+bulkstat 32 perag(v5): 521
+inumbers all(default): inumbers is in range
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 1 all(default): 521
+bulkstat 1 all(v1): 521
+bulkstat 1 all(v5): 521
+bulkstat 1 perag(default): 521
+bulkstat 1 perag(v1): 521
+bulkstat 1 perag(v5): 521
+inumbers all(default): inumbers is in range
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
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
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 71 all(default): 9
+bulkstat 71 all(v1): 9
+bulkstat 71 all(v5): 9
+bulkstat 71 perag(default): 9
+bulkstat 71 perag(v1): 9
+bulkstat 71 perag(v5): 9
+inumbers all(default): inumbers is in range
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 32 all(default): 9
+bulkstat 32 all(v1): 9
+bulkstat 32 all(v5): 9
+bulkstat 32 perag(default): 9
+bulkstat 32 perag(v1): 9
+bulkstat 32 perag(v5): 9
+inumbers all(default): inumbers is in range
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
+bulkstat 1 all(default): 9
+bulkstat 1 all(v1): 9
+bulkstat 1 all(v5): 9
+bulkstat 1 perag(default): 9
+bulkstat 1 perag(v1): 9
+bulkstat 1 perag(v5): 9
+inumbers all(default): inumbers is in range
+inumbers 71(default): inumbers is in range
+inumbers 2(default): inumbers is in range
+inumbers 1(default): inumbers is in range
+inumbers all(v1): inumbers is in range
+inumbers 71(v1): inumbers is in range
+inumbers 2(v1): inumbers is in range
+inumbers 1(v1): inumbers is in range
+inumbers all(v5): inumbers is in range
+inumbers 71(v5): inumbers is in range
+inumbers 2(v5): inumbers is in range
+inumbers 1(v5): inumbers is in range
diff --git a/tests/xfs/745 b/tests/xfs/745
new file mode 100755
index 00000000..dcb14c41
--- /dev/null
+++ b/tests/xfs/745
@@ -0,0 +1,47 @@
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
+# This is a regression test for commit f16fe3ecde62 ("xfs: bulkstat should copy
+# lastip whenever userspace supplies one")
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
