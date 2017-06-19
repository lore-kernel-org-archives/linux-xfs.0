Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45046 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbdFSUYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Jun 2017 16:24:08 -0400
Date: Mon, 19 Jun 2017 13:24:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: don't allow realtime swap files
Message-ID: <20170619202402.GC4733@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

Linux swapfiles use bmap which has no ability to tell the swap code
that the blocks its reporting aren't actually on the data device.
Therefore, swapon on a realtime file could corrupt random blocks on
the data device, so we must ensure that swapon cannot happen.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/701     |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/701.out |    5 ++++
 tests/xfs/group   |    1 +
 3 files changed, 79 insertions(+)
 create mode 100755 tests/xfs/701
 create mode 100644 tests/xfs/701.out

diff --git a/tests/xfs/701 b/tests/xfs/701
new file mode 100755
index 0000000..d7b63fd
--- /dev/null
+++ b/tests/xfs/701
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FS QA Test No. 357
+#
+# Check that we can't swapon a realtime file.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_require_realtime
+_require_scratch_swapfile
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blocks=160
+blksz=65536
+
+echo "Initialize file"
+echo >> $seqres.full
+$XFS_IO_PROG -c "open -f -R $testdir/dummy" $testdir >> $seqres.full
+echo moo >> $testdir/dummy
+$XFS_IO_PROG -c "open -f -R $testdir/file1" $testdir >> $seqres.full
+_pwrite_byte 0x61 0 $((blocks * blksz)) $testdir/file1 >> $seqres.full
+mkswap -U 27376b42-ff65-42ca-919f-6c9b62292a5c $testdir/file1 >> $seqres.full
+
+echo "Try to swapon"
+swapon $testdir/file1 2>&1 | _filter_scratch
+
+swapoff $testdir/file1 >> $seqres.full 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/701.out b/tests/xfs/701.out
new file mode 100644
index 0000000..98fd3a1
--- /dev/null
+++ b/tests/xfs/701.out
@@ -0,0 +1,5 @@
+QA output created by 701
+Format and mount
+Initialize file
+Try to swapon
+swapon: SCRATCH_MNT/test-701/file1: swapon failed: Invalid argument
diff --git a/tests/xfs/group b/tests/xfs/group
index 792161a..5f37c5a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -416,3 +416,4 @@
 416 dangerous_fuzzers dangerous_scrub dangerous_repair
 417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 418 dangerous_fuzzers dangerous_scrub dangerous_repair
+701 auto quick
