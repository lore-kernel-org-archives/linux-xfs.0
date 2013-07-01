Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D30B97F56
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 05:29:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C27818F8037
	for <xfs@oss.sgi.com>; Mon,  1 Jul 2013 03:29:23 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id vOKOCVFzpC787DER (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 01 Jul 2013 03:29:19 -0700 (PDT)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r61ATIfG028225
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 1 Jul 2013 10:29:19 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r61ATHFI000864
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 1 Jul 2013 10:29:18 GMT
Received: from abhmt113.oracle.com (abhmt113.oracle.com [141.146.116.65])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r61ATH62017737 for <xfs@oss.sgi.com>; Mon, 1 Jul 2013 10:29:17 GMT
Message-ID: <51D159FF.401@oracle.com>
Date: Mon, 01 Jul 2013 18:29:19 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: generic/315, verify preallocated disk space is
	released per truncate
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

From: Jie Liu <jeff.liu@oracle.com>

Introduce generic test 315 to verify if the disk space is
released after truncating a preallocated file back to the
old smaller size.  Before Linux-3.10, Btrfs/OCFS2 test
failed in this case.

The test file is fallocated with FALLOC_FL_KEEP_SIZE option.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 tests/generic/315     |   79 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/315.out |    2 ++
 tests/generic/group   |    1 +
 3 files changed, 82 insertions(+)
 mode change 100644 => 100755 tests/generic/311
 create mode 100755 tests/generic/315
 create mode 100644 tests/generic/315.out

diff --git a/tests/generic/311 b/tests/generic/311
old mode 100644
new mode 100755
diff --git a/tests/generic/315 b/tests/generic/315
new file mode 100755
index 0000000..7cfc40d
--- /dev/null
+++ b/tests/generic/315
@@ -0,0 +1,79 @@
+#! /bin/bash
+# FS QA Test No. 315
+#
+# fallocate/truncate tests with FALLOC_FL_KEEP_SIZE option.
+# Verify if the disk space is released after truncating a file back
+# to the old smaller size.  Before Linux 3.10, Btrfs/OCFS2 are test
+# failed in this case.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Oracle, Inc.  All Rights Reserved.
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
+status=0	# success is the default!
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
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+rm -f $seqres.full
+
+echo "Slience is golden"
+
+# Check the current avaliable disk space on $TEST_DIR.
+# 1024KiB at least
+avail_begin=`df -P $TEST_DIR | awk 'END {print $4}'`
+[ "$avail_begin" -ge 1024 ] || _notrun "Test device is too small ($avail_begin KiB)"
+
+# Preallocate half size of the available disk space to a file
+# starts from offset 0 with FALLOC_FL_KEEP_SIZE option on the
+# test file system.
+fallocate -n -o 0 -l $(($avail_begin/2)) $TEST_DIR/testfile.$seq >>$seqres.full 2>&1
+
+# Verify the file size, it should keep unchanged as 0 in this case
+fsize=`ls -l $TEST_DIR/testfile.$seq | awk '{print $5}'`
+[ "$fsize" -eq 0 ] || _fail "File size is changed to ($fsize Bytes)"
+
+# Truncate the file size back to 0
+truncate -s 0 $TEST_DIR/testfile.$seq
+sync
+
+# Preallocated disk space should be released
+avail_done=`df -P $TEST_DIR | awk 'END {print $4}'`
+[ "$avail_done" -eq "$avail_begin" ] || _fail "Available disk space ($avail_done KiB)"
+
+# success, all done
+exit
diff --git a/tests/generic/315.out b/tests/generic/315.out
new file mode 100644
index 0000000..8414add
--- /dev/null
+++ b/tests/generic/315.out
@@ -0,0 +1,2 @@
+QA output created by 315
+Slience is golden
diff --git a/tests/generic/group b/tests/generic/group
index bd443c1..30889bd 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -115,3 +115,4 @@
 310 auto
 311 auto metadata log
 312 auto quick prealloc enospc
+315 auto quick rw prealloc
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
