Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35647 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754852AbdGUWEr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 18:04:47 -0400
Subject: [PATCH 2/5] ext4: fsmap tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jul 2017 15:04:39 -0700
Message-ID: <150067467904.30639.10970838819181222800.stgit@magnolia>
In-Reply-To: <150067465981.30639.14801416171688538711.stgit@magnolia>
References: <150067465981.30639.14801416171688538711.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Test the GETFSMAP ioctl against ext4.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/ext4/700     |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/700.out |    7 +++++
 tests/ext4/701     |   65 ++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/701.out |    3 ++
 tests/ext4/702     |   66 +++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/702.out |    4 +++
 tests/ext4/group   |    3 ++
 7 files changed, 224 insertions(+)
 create mode 100755 tests/ext4/700
 create mode 100644 tests/ext4/700.out
 create mode 100755 tests/ext4/701
 create mode 100644 tests/ext4/701.out
 create mode 100755 tests/ext4/702
 create mode 100644 tests/ext4/702.out


diff --git a/tests/ext4/700 b/tests/ext4/700
new file mode 100755
index 0000000..a4a1b83
--- /dev/null
+++ b/tests/ext4/700
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test No. 700
+#
+# Check that getfsmap reports the BG metadata we're expecting.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f "$tmp".* $TEST_DIR/fsmap $TEST_DIR/testout
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext4
+_require_scratch
+_require_xfs_io_command "fsmap"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+echo "Get fsmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'fsmap' $SCRATCH_MNT > $TEST_DIR/fsmap
+cat $TEST_DIR/fsmap >> $seqres.full
+
+echo "Check fs metadata" | tee -a $seqres.full
+x=$(grep -c 'static fs metadata' $TEST_DIR/fsmap)
+test $x -gt 0 || echo "No fs metadata?"
+
+echo "Check block bitmap" | tee -a $seqres.full
+x=$(grep -c 'special 102:1' $TEST_DIR/fsmap)
+test $x -gt 0 || echo "No block bitmaps?"
+
+echo "Check inode bitmap" | tee -a $seqres.full
+x=$(grep -c 'special 102:2' $TEST_DIR/fsmap)
+test $x -gt 0 || echo "No inode bitmaps?"
+
+echo "Check inodes" | tee -a $seqres.full
+x=$(grep -c 'inodes' $TEST_DIR/fsmap)
+test $x -gt 0 || echo "No inodes?"
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/700.out b/tests/ext4/700.out
new file mode 100644
index 0000000..3984319
--- /dev/null
+++ b/tests/ext4/700.out
@@ -0,0 +1,7 @@
+QA output created by 700
+Format and mount
+Get fsmap
+Check fs metadata
+Check block bitmap
+Check inode bitmap
+Check inodes
diff --git a/tests/ext4/701 b/tests/ext4/701
new file mode 100755
index 0000000..6ae93d7
--- /dev/null
+++ b/tests/ext4/701
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 701
+#
+# Populate filesystem, check that fsmap -n10000 matches fsmap -n1.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f "$tmp".* $TEST_DIR/a $TEST_DIR/b
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext4
+_require_scratch
+_require_populate_commands
+_require_xfs_io_command "fsmap"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_populate_cached nofill > $seqres.full 2>&1
+
+echo "Compare fsmap" | tee -a $seqres.full
+_scratch_mount
+$XFS_IO_PROG -c 'fsmap -n 65536' $SCRATCH_MNT | grep -v 'EXT:' > $TEST_DIR/a
+$XFS_IO_PROG -c 'fsmap -n 1' $SCRATCH_MNT | grep -v 'EXT:' > $TEST_DIR/b
+cat $TEST_DIR/a $TEST_DIR/b >> $seqres.full
+
+diff -uw $TEST_DIR/a $TEST_DIR/b
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/701.out b/tests/ext4/701.out
new file mode 100644
index 0000000..41ef1c6
--- /dev/null
+++ b/tests/ext4/701.out
@@ -0,0 +1,3 @@
+QA output created by 701
+Format and mount
+Compare fsmap
diff --git a/tests/ext4/702 b/tests/ext4/702
new file mode 100755
index 0000000..ce3ae11
--- /dev/null
+++ b/tests/ext4/702
@@ -0,0 +1,66 @@
+#! /bin/bash
+# FS QA Test No. 702
+#
+# Check that getfsmap reports external log devices
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f "$tmp".* $TEST_DIR/fsmap $TEST_DIR/testout
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext4
+_require_logdev
+_require_scratch
+_require_xfs_io_command "fsmap"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+echo "Get fsmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'fsmap' $SCRATCH_MNT >> $seqres.full
+$XFS_IO_PROG -c 'fsmap' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
+
+echo "Check device field of FS metadata and journalling log"
+data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+journal_dev=$(grep 'journalling log' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+test "${data_dev}" != "${journal_dev}" || echo "data ${data_dev} journal ${journal_dev}?"
+
+# success, all done
+status=0
+exit
diff --git a/tests/ext4/702.out b/tests/ext4/702.out
new file mode 100644
index 0000000..1d3b7ef
--- /dev/null
+++ b/tests/ext4/702.out
@@ -0,0 +1,4 @@
+QA output created by 702
+Format and mount
+Get fsmap
+Check device field of FS metadata and journalling log
diff --git a/tests/ext4/group b/tests/ext4/group
index 664c059..9007adf 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -37,3 +37,6 @@
 306 auto rw resize quick
 307 auto ioctl rw defrag
 308 auto ioctl rw prealloc quick defrag
+700 auto quick fsmap
+701 auto quick fsmap
+702 auto quick fsmap

