Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38841 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751461AbdICJd0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 3 Sep 2017 05:33:26 -0400
Date: Sun, 3 Sep 2017 11:33:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: test the per-inode DAX flag
Message-ID: <20170903093325.GA16272@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

This tests checks that the per-inode DAX flag is either reject
or sticks around, and that rapidly setting/clearing it will not
crash the kernel.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/tests/xfs/114 b/tests/xfs/114
new file mode 100755
index 0000000..4b6472f
--- /dev/null
+++ b/tests/xfs/114
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test 114
+#
+# Test that the DAX xflag works, and rapidly setting/clearing it doesn't
+# crash the kernel
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Christoph Hellwig.  All Rights Reserved.
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
+file=$TEST_DIR/test.$seq
+
+_lets_get_pidst()
+{
+	if [ -n "$pid" ]; then
+		kill -TERM $pid 2>/dev/null
+		pid=""
+		wait 2>/dev/null
+	fi
+}
+
+_cleanup()
+{
+	cd /
+	_lets_get_pidst
+	rm -f $tmp.*
+	rm -f $file*
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
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_test
+
+# test that the +x flag sticks if we don't get an error
+touch $file
+xfs_io -c 'chattr +x' $file > $tmp.log 2>&1
+if grep -q "Invalid argument" $tmp.log; then
+    _notrun "file system doesn't support the DAX flag"
+fi
+
+echo "checking for DAX flag:"
+xfs_io -c 'lsattr' $file | _filter_test_dir
+rm -f $file
+
+# run fsx racing with setting/clearing the DAX flag
+$here/ltp/fsx -N 1000 $file > $tmp.log 2>&1 &
+pid=$!
+
+for i in `seq 1 1000`; do
+    xfs_io -c 'chattr +x' $file
+    xfs_io -c 'chattr -x' $file
+done
+
+_lets_get_pidst
+
+# success, all done
+echo "*** done"
+status=0
+exit
diff --git a/tests/xfs/114.out b/tests/xfs/114.out
new file mode 100644
index 0000000..652276a
--- /dev/null
+++ b/tests/xfs/114.out
@@ -0,0 +1,4 @@
+QA output created by 114
+checking for DAX flag:
+--------------x- TEST_DIR/test.114 
+*** done
diff --git a/tests/xfs/group b/tests/xfs/group
index 5977330..5c02498 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -111,6 +111,7 @@
 111 ioctl
 112 fuzzers
 113 fuzzers
+114 auto rw dangerous
 116 quota auto quick
 117 fuzzers
 118 auto quick fsr dangerous
