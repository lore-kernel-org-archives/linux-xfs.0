Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46122 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbeFEQnY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 12:43:24 -0400
Subject: [PATCH 4/6] generic: test swapfile creation, activation,
 and deactivation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 05 Jun 2018 09:43:20 -0700
Message-ID: <152821700095.24976.18190247208329715145.stgit@magnolia>
In-Reply-To: <152821697018.24976.12939094615403004592.stgit@magnolia>
References: <152821697018.24976.12939094615403004592.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Test swapfile activation and deactivation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/708     |  115 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/708.out |    8 +++
 tests/generic/709     |   91 +++++++++++++++++++++++++++++++++++++++
 tests/generic/709.out |    3 +
 tests/generic/710     |   94 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/710.out |    3 +
 tests/generic/group   |    3 +
 7 files changed, 317 insertions(+)
 create mode 100755 tests/generic/708
 create mode 100644 tests/generic/708.out
 create mode 100755 tests/generic/709
 create mode 100644 tests/generic/709.out
 create mode 100755 tests/generic/710
 create mode 100644 tests/generic/710.out


diff --git a/tests/generic/708 b/tests/generic/708
new file mode 100755
index 00000000..dc3c2924
--- /dev/null
+++ b/tests/generic/708
@@ -0,0 +1,115 @@
+#! /bin/bash
+# FS QA Test No. 708
+#
+# Test various swapfile activation oddities.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	swapoff $swapfile 2> /dev/null
+	rm -f $swapfile
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
+_require_scratch_swapfile
+_require_test_program mkswap
+_require_test_program swapon
+
+rm -f $seqres.full
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount >>$seqres.full 2>&1
+
+swapfile=$SCRATCH_MNT/swap
+len=$((2 * 1048576))
+page_size=$(get_page_size)
+
+swapfile_cycle() {
+	local swapfile="$1"
+
+	$CHATTR_PROG +C $swapfile >> $seqres.full 2>&1
+	"$here/src/mkswap" $swapfile >> $seqres.full
+	"$here/src/swapon" $swapfile 2>&1 | _filter_scratch
+	swapoff $swapfile 2>> $seeqres.full
+	rm -f $swapfile
+}
+
+# Create a regular swap file
+echo "regular swap" | tee -a $seqres.full
+_pwrite_byte 0x58 0 $len $swapfile >> $seqres.full
+swapfile_cycle $swapfile
+
+# Create a sparse swap file
+echo "sparse swap" | tee -a $seqres.full
+$XFS_IO_PROG -f -c "truncate $len" $swapfile >> $seqres.full
+swapfile_cycle $swapfile
+
+# Create a swap file with a little too much junk on the end
+echo "too long swap" | tee -a $seqres.full
+_pwrite_byte 0x58 0 $((len + 3)) $swapfile >> $seqres.full
+swapfile_cycle $swapfile
+
+# Create a swap file with a large discontiguous range(?)
+echo "large discontig swap" | tee -a $seqres.full
+_pwrite_byte 0x58 0 $((len * 2)) $swapfile >> $seqres.full
+old_sz="$(stat -c '%s' $swapfile)"
+$XFS_IO_PROG -c "fcollapse $((len / 2)) $len" $swapfile >> $seqres.full 2>&1
+new_sz="$(stat -c '%s' $swapfile)"
+if [ $old_sz -gt $new_sz ]; then
+	swapfile_cycle $swapfile
+fi
+rm -f $swapfile
+
+# Create a swap file with a small discontiguous range(?)
+echo "small discontig swap" | tee -a $seqres.full
+_pwrite_byte 0x58 0 $((len + 1024)) $swapfile >> $seqres.full
+old_sz="$(stat -c '%s' $swapfile)"
+$XFS_IO_PROG -c "fcollapse 66560 1024" $swapfile >> $seqres.full 2>&1
+new_sz="$(stat -c '%s' $swapfile)"
+if [ $old_sz -gt $new_sz ]; then
+	swapfile_cycle $swapfile
+fi
+rm -f $swapfile
+
+# Create a ridiculously small swap file.  Each swap file must have at least
+# two pages after the header page.
+echo "tiny swap" | tee -a $seqres.full
+tiny_len=$((page_size * 3))
+_pwrite_byte 0x58 0 $tiny_len $swapfile >> $seqres.full
+swapfile_cycle $swapfile
+
+status=0
+exit
diff --git a/tests/generic/708.out b/tests/generic/708.out
new file mode 100644
index 00000000..d002974c
--- /dev/null
+++ b/tests/generic/708.out
@@ -0,0 +1,8 @@
+QA output created by 708
+regular swap
+sparse swap
+swapon: Invalid argument
+too long swap
+large discontig swap
+small discontig swap
+tiny swap
diff --git a/tests/generic/709 b/tests/generic/709
new file mode 100755
index 00000000..5e636305
--- /dev/null
+++ b/tests/generic/709
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FS QA Test No. 709
+#
+# Test various swapfile activation oddities on filesystems that support
+# fallocated swapfiles.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	swapoff $swapfile 2> /dev/null
+	rm -f $swapfile
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
+_require_scratch_swapfile
+_require_test_program mkswap
+_require_test_program swapon
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount >>$seqres.full 2>&1
+
+swapfile=$SCRATCH_MNT/swap
+len=$((2 * 1048576))
+page_size=$(get_page_size)
+
+swapfile_cycle() {
+	local swapfile="$1"
+
+	$CHATTR_PROG +C $swapfile >> $seqres.full 2>&1
+	"$here/src/mkswap" $swapfile >> $seqres.full
+	"$here/src/swapon" $swapfile 2>&1 | _filter_scratch
+	swapoff $swapfile 2>> $seeqres.full
+	rm -f $swapfile
+}
+
+# Create a fallocated swap file
+echo "fallocate swap" | tee -a $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $len" $swapfile >> $seqres.full
+$CHATTR_PROG +C $swapfile >> $seqres.full 2>&1
+"$here/src/mkswap" $swapfile
+"$here/src/swapon" $swapfile >> $seqres.full 2>&1 || \
+	_notrun "fallocated swap not supported here"
+swapoff $swapfile
+
+# Create a fallocated swap file and touch every other $PAGE_SIZE to create
+# a mess of written/unwritten extent records
+echo "mixed swap" | tee -a $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $len" $swapfile >> $seqres.full
+seq $page_size $((page_size * 2)) $len | while read offset; do
+	_pwrite_byte 0x58 $offset 1 $swapfile >> $seqres.full
+done
+swapfile_cycle $swapfile
+
+status=0
+exit
diff --git a/tests/generic/709.out b/tests/generic/709.out
new file mode 100644
index 00000000..90ba38ae
--- /dev/null
+++ b/tests/generic/709.out
@@ -0,0 +1,3 @@
+QA output created by 709
+fallocate swap
+mixed swap
diff --git a/tests/generic/710 b/tests/generic/710
new file mode 100755
index 00000000..e9dc3f08
--- /dev/null
+++ b/tests/generic/710
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 710
+#
+# Test various swapfile activation oddities, having used fcollapse to
+# create discontiguous ranges in the file.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	swapoff $swapfile 2> /dev/null
+	rm -f $swapfile
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
+_require_scratch_swapfile
+_require_test_program mkswap
+_require_test_program swapon
+_require_xfs_io_command "fcollapse"
+
+rm -f $seqres.full
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount >>$seqres.full 2>&1
+
+swapfile=$SCRATCH_MNT/swap
+len=$((2 * 1048576))
+page_size=$(get_page_size)
+
+swapfile_cycle() {
+	local swapfile="$1"
+
+	"$here/src/mkswap" $swapfile >> $seqres.full
+	"$here/src/swapon" $swapfile 2>&1 | _filter_scratch
+	swapoff $swapfile 2>> $seeqres.full
+	rm -f $swapfile
+}
+
+# Create a swap file with a large discontiguous range(?)
+echo "large discontig swap" | tee -a $seqres.full
+_pwrite_byte 0x58 0 $((len * 2)) $swapfile >> $seqres.full
+old_sz="$(stat -c '%s' $swapfile)"
+$XFS_IO_PROG -c "fcollapse $((len / 2)) $len" $swapfile >> $seqres.full 2>&1
+new_sz="$(stat -c '%s' $swapfile)"
+if [ $old_sz -gt $new_sz ]; then
+	swapfile_cycle $swapfile
+fi
+rm -f $swapfile
+
+# Create a swap file with a small discontiguous range(?)
+echo "small discontig swap" | tee -a $seqres.full
+_pwrite_byte 0x58 0 $((len + 1024)) $swapfile >> $seqres.full
+old_sz="$(stat -c '%s' $swapfile)"
+$XFS_IO_PROG -c "fcollapse 66560 1024" $swapfile >> $seqres.full 2>&1
+new_sz="$(stat -c '%s' $swapfile)"
+if [ $old_sz -gt $new_sz ]; then
+	swapfile_cycle $swapfile
+fi
+rm -f $swapfile
+
+status=0
+exit
diff --git a/tests/generic/710.out b/tests/generic/710.out
new file mode 100644
index 00000000..ba1f8e40
--- /dev/null
+++ b/tests/generic/710.out
@@ -0,0 +1,3 @@
+QA output created by 710
+large discontig swap
+small discontig swap
diff --git a/tests/generic/group b/tests/generic/group
index 4339c64c..6d747450 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -497,3 +497,6 @@
 493 auto quick swap
 494 auto quick swap punch
 495 auto quick swap
+708 auto quick swap
+709 auto quick swap
+710 auto quick swap collapse

