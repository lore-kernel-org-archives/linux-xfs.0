Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:12317 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751148AbdIKUBJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Sep 2017 16:01:09 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH v2] xfs: add regression test for DAX mount option usage
Date: Mon, 11 Sep 2017 14:01:03 -0600
Message-Id: <20170911200103.28226-1-ross.zwisler@linux.intel.com>
In-Reply-To: <CAPcyv4gGpAW7kUCgqSoNCPkFZVYzTVQi3C4x6AFm2KHvFrZSfw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org, Eryu Guan <eguan@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

This adds a regression test for the following kernel patch:

  xfs: always use DAX if mount option is used

This test will also pass with kernel v4.14-rc1 and beyond because the XFS
DAX I/O mount option has been disabled (but not removed), so the
"chattr -x" to turn off DAX doesn't actually do anything.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
---

Changes since v1:
 - Use perf instead of tracepoints to detect whether DAX is used. (Dan)

---
 tests/xfs/431     | 77 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/431.out |  2 ++
 tests/xfs/group   |  1 +
 3 files changed, 80 insertions(+)
 create mode 100755 tests/xfs/431
 create mode 100644 tests/xfs/431.out

diff --git a/tests/xfs/431 b/tests/xfs/431
new file mode 100755
index 0000000..2865a6d
--- /dev/null
+++ b/tests/xfs/431
@@ -0,0 +1,77 @@
+#! /bin/bash
+# FS QA Test xfs/431
+#
+# This is a regression test for kernel patch:
+# 	xfs: always use DAX if mount option is used
+# created by Ross Zwisler <ross.zwisler@linux.intel.com>
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Intel Corporation.  All Rights Reserved.
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
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# Modify as appropriate.
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_dax
+
+# real QA test starts here
+export PERF_PROG="`set_prog_path perf`"
+[ "$PERF_PROG" = "" ] && _notrun "perf not found"
+
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount "-o dax" >> $seqres.full 2>&1
+
+pgsize=`$here/src/feature -s`
+
+PERF_OUTPUT=$tmp.perf
+
+$PERF_PROG record -o $PERF_OUTPUT -e 'fs_dax:dax_load_hole' \
+	$XFS_IO_PROG -t -c "truncate $pgsize" \
+	-c "chattr -x" \
+	-c "mmap -r 0 $pgsize" -c "mread 0 $pgsize" -c "munmap" \
+	-f $SCRATCH_MNT/testfile  > /dev/null 2>&1
+
+$PERF_PROG script -i $PERF_OUTPUT | grep -q 'fs_dax:dax_load_hole'
+if [[ $? == 0 ]]; then
+	echo "DAX was used"
+else
+	echo "DAX was NOT used"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/431.out b/tests/xfs/431.out
new file mode 100644
index 0000000..194ae1e
--- /dev/null
+++ b/tests/xfs/431.out
@@ -0,0 +1,2 @@
+QA output created by 431
+DAX was used
diff --git a/tests/xfs/group b/tests/xfs/group
index 0a449b9..4e7019c 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -427,3 +427,4 @@
 428 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 429 dangerous_fuzzers dangerous_scrub dangerous_repair
 430 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+431 auto quick
-- 
2.9.5

