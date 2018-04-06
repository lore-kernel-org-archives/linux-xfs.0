Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50048 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754328AbeDFOSR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Apr 2018 10:18:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] tests/xfs: filestream allocator inode use-after-free test
Date: Fri,  6 Apr 2018 10:18:15 -0400
Message-Id: <20180406141815.6472-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

The XFS filestreams allocator caches dir inode -> agno mappings in
an MRU mechanism that holds elements in memory for an amount of time
and then cleans up expired elements in the background. The elements
typically held inode pointers without holding a reference to the
associated inode. This means that if the inode is reclaimed before
an expired entry is cleaned up, the MRU reaper can access freed
memory and cause a panic.

Test for this problem by performing continuous filestreams
allocations under short-lived parent directory inodes. This will
produce KASAN use-after-free splats if enabled during the test.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This test reproduces the problem described in this[1] thread. It's
XFS-specific because of the filestream option and specific geometry used
to format the scratch device.

Brian

[1] https://marc.info/?l=linux-xfs&m=152293031029161&w=2

 tests/xfs/445     | 111 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/445.out |   2 +
 tests/xfs/group   |   1 +
 3 files changed, 114 insertions(+)
 create mode 100755 tests/xfs/445
 create mode 100644 tests/xfs/445.out

diff --git a/tests/xfs/445 b/tests/xfs/445
new file mode 100755
index 00000000..331a7dd4
--- /dev/null
+++ b/tests/xfs/445
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FS QA Test 445
+#
+# Test the XFS filestreams allocator for use-after-free inode access. The
+# filestreams allocator uses the MRU and historically kept around unreferenced
+# inode pointers in each element. These pointers could outlive the inodes they
+# referred to and thus lead to access of freed or reused memory when the MRU
+# element was reaped. Test for this problem by performing filestream allocations
+# against short-lived parent directory inodes.
+#
+# Note that some form of kernel debug mechanism for use-after-free detection
+# (i.e., KASAN) is required for this test to reproduce the original problem.
+# This is because XFS uses a kmem cache for xfs_inode objects which means that
+# the backing pages for freed inodes may still reside in the cache with the
+# freed inodes in a partially initialized state.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
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
+. ./common/filestreams
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+drop_caches()
+{
+	while [ true ]; do
+		echo 2 > /proc/sys/vm/drop_caches
+		sleep 1
+	done
+}
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+
+# check for filestreams and min device size
+_check_filestreams_support || _notrun "filestreams not available"
+devsize=`blockdev --getsize64 $SCRATCH_DEV`
+[ $devsize -gt $((2 * 1024 * 1024 * 1024)) ] || _notrun "scratch dev too small"
+
+# use small AGs for frequent stream switching
+_scratch_mkfs_xfs -d agsize=20m,size=2g >> $seqres.full 2>&1 ||
+	_fail "mkfs failed"
+_scratch_mount "-o filestreams" || _fail "mount failed"
+
+# start background inode reclaim
+drop_caches &
+pid=$!
+
+# Stress the filestreams allocator via continuous allocation to a file under
+# different parent dirs. Remove the old dirs as the file is moved so the MRU
+# references point to an unlinked inode by the time they are removed. If the
+# old dir inodes are reclaimed and associated memory reused, MRU cleanup can
+# access the inode after it's been freed.
+dir=$SCRATCH_MNT
+for i in $(seq 0 90); do
+	mkdir -p $dir/$i
+	$XFS_IO_PROG -fc "falloc $(($i * 20))m 20m" $dir/$i/file
+
+	mkdir -p $dir/$((i + 1))
+	mv $dir/$i/file $dir/$((i + 1))/file
+	rmdir $dir/$i
+
+	# throttle to ensure this loop sees several cache reclaims
+	sleep 0.1
+done
+
+kill $pid 2> /dev/null
+wait $pid 2> /dev/null
+
+echo Silence is golden
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/445.out b/tests/xfs/445.out
new file mode 100644
index 00000000..44e55d20
--- /dev/null
+++ b/tests/xfs/445.out
@@ -0,0 +1,2 @@
+QA output created by 445
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index 831f2cfa..2a7dec6f 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -442,3 +442,4 @@
 442 auto stress clone quota
 443 auto quick ioctl fsr
 444 auto quick
+445 auto filestreams
-- 
2.13.6

