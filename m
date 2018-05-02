Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:49906 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751234AbeEBUeE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 May 2018 16:34:04 -0400
Date: Wed, 2 May 2018 13:33:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/2] generic: test swapfile creation, activation, and
 deactivation
Message-ID: <20180502203338.GB4141@magnolia>
References: <20180502203228.GA4141@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180502203228.GA4141@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, darrick.wong@oracle.com
Cc: hch@infradead.org, cyberax@amazon.com, jack@suse.cz, osandov@osandov.com, Eryu Guan <guaneryu@gmail.com>

Test swapfile activation and deactivation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/708     |  120 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/708.out |    9 ++++
 tests/generic/group   |    1 
 3 files changed, 130 insertions(+)
 create mode 100755 tests/generic/708
 create mode 100644 tests/generic/708.out

diff --git a/tests/generic/708 b/tests/generic/708
new file mode 100755
index 00000000..49be8111
--- /dev/null
+++ b/tests/generic/708
@@ -0,0 +1,120 @@
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
+	rm -f $testfile
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
+
+rm -f $seqres.full
+_scratch_mkfs >>$seqres.full 2>&1
+_scratch_mount >>$seqres.full 2>&1
+
+swapfile=$SCRATCH_MNT/swap
+len=$((2 * 1048576))
+
+swapfile_cycle() {
+	local swapfile="$1"
+
+	mkswap $swapfile >> $seqres.full
+	filefrag -v $swapfile >> $seqres.full
+	swapon $swapfile 2>&1 | _filter_scratch
+	swapon -v --bytes >> $seqres.full
+	swapoff $swapfile 2>> $seeqres.full
+	rm -f $swapfile
+}
+
+# Create a sparse swap file
+echo "sparse swap" | tee -a $seqres.full
+$XFS_IO_PROG -f -c "truncate $len" $swapfile >> $seqres.full
+swapfile_cycle $swapfile
+
+# Create a regular swap file
+echo "regular swap" | tee -a $seqres.full
+_pwrite_byte 0x58 0 $len $swapfile >> $seqres.full
+swapfile_cycle $swapfile
+
+# Create a fallocated swap file
+echo "fallocate swap" | tee -a $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $len" $swapfile >> $seqres.full
+swapfile_cycle $swapfile
+
+# Create a swap file with a little too much junk on the end
+echo "too long swap" | tee -a $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $((len + 3))" $swapfile >> $seqres.full
+swapfile_cycle $swapfile
+
+# Create a swap file with a large discontiguous range(?)
+echo "large discontig swap" | tee -a $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $((len * 2))" $swapfile >> $seqres.full
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
+$XFS_IO_PROG -f -c "falloc 0 $((len + 1024))" $swapfile >> $seqres.full
+old_sz="$(stat -c '%s' $swapfile)"
+$XFS_IO_PROG -c "fcollapse 66560 1024" $swapfile >> $seqres.full 2>&1
+new_sz="$(stat -c '%s' $swapfile)"
+if [ $old_sz -gt $new_sz ]; then
+	swapfile_cycle $swapfile
+fi
+rm -f $swapfile
+
+# Create a fallocated swap file and touch every other $PAGE_SIZE to create
+# a mess of written/unwritten extent records
+echo "mixed swap" | tee -a $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $len" $swapfile >> $seqres.full
+page_size=$(get_page_size)
+seq $page_size $((page_size * 2)) $len | while read offset; do
+	_pwrite_byte 0x58 $offset 1 $swapfile >> $seqres.full
+done
+swapfile_cycle $swapfile
+
+status=0
+exit
diff --git a/tests/generic/708.out b/tests/generic/708.out
new file mode 100644
index 00000000..bc7b05d1
--- /dev/null
+++ b/tests/generic/708.out
@@ -0,0 +1,9 @@
+QA output created by 708
+sparse swap
+swapon: SCRATCH_MNT/swap: skipping - it appears to have holes.
+regular swap
+fallocate swap
+too long swap
+large discontig swap
+small discontig swap
+mixed swap
diff --git a/tests/generic/group b/tests/generic/group
index 49f5cbe1..94cbcee9 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -489,3 +489,4 @@
 484 auto quick
 600 auto quick insert
 706 auto quick attr
+708 auto quick swapfile
