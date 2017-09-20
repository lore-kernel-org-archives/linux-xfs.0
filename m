Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46688 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751488AbdITAqw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 20:46:52 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8K0h9go006732
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2017 17:46:52 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2d39sj996e-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 19 Sep 2017 17:46:52 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v3] xfs: Add test for CVE-2017-14340
Date: Tue, 19 Sep 2017 17:46:50 -0700
Message-ID: <20170920004650.36174-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Verify kernel doesn't panic when user attempts to set realtime flags
on non-realtime FS, using kernel compiled with CONFIG_XFS_RT.  Unpatched
kernels will panic during this test.  Kernels not compiled with
CONFIG_XFS_RT should pass test.

This bug was fixed via commit b31ff3cdf540110da4572e3e29bd172087af65cc
on the main kernel tree.

Signed-off-by: Richard Wareing <rwareing@fb.com>
---
Changes since v2:
* Added to dangerous group

Changes since v1:
* Corrected copyright text

 tests/xfs/431     | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/431.out |  3 ++
 tests/xfs/group   |  1 +
 3 files changed, 92 insertions(+)
 create mode 100755 tests/xfs/431
 create mode 100644 tests/xfs/431.out

diff --git a/tests/xfs/431 b/tests/xfs/431
new file mode 100755
index 0000000..eea0878
--- /dev/null
+++ b/tests/xfs/431
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test 431
+#
+# Verify kernel doesn't panic when user attempts to set realtime flags
+# on non-realtime FS, using kernel compiled with CONFIG_XFS_RT.  Unpatched 
+# kernels will panic during this test.  Kernels not compiled with 
+# CONFIG_XFS_RT should pass test.
+#
+# See CVE-2017-14340 for more information.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Facebook, Inc.  All Rights Reserved.
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
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+_require_xfs_io_command "chattr"
+_require_xfs_io_command "fsync"
+_require_xfs_io_command "pwrite"
+_require_scratch
+_require_test
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# Set realtime inherit flag on scratch mount, suppress output
+# as this may simply error out on future kernels, we will check
+# exit code instead.
+$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT &> /dev/null
+chattr_ret=$?
+
+# Erroring out here is fine, this would be desired behavior for
+# FSes without realtime devices present.
+if (( chattr_ret == 0)); then
+  # Attempt to write/fsync data to file
+  $XFS_IO_PROG -fc 'pwrite 0 1m' -c fsync $SCRATCH_MNT/testfile | 
+    tee -a $seqres.full | common_line_filter | _filter_xfs_io
+
+  # Remove the rt inherit flag after we are done or xfs_repair
+  # will fail.
+  $XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT | tee -a $seqres.full 2>&1
+fi
+
+
+rm -f $SCRATCH_MNT/testfile
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/431.out b/tests/xfs/431.out
new file mode 100644
index 0000000..8c14f11
--- /dev/null
+++ b/tests/xfs/431.out
@@ -0,0 +1,3 @@
+QA output created by 431
+wrote 1048576/1048576 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
diff --git a/tests/xfs/group b/tests/xfs/group
index 0a449b9..476fe66 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -427,3 +427,4 @@
 428 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 429 dangerous_fuzzers dangerous_scrub dangerous_repair
 430 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+431 quick dangerous
-- 
2.9.5

