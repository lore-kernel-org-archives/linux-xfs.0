Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9ABC57CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 00:57:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6DF17304039
	for <xfs@oss.sgi.com>; Wed, 25 May 2016 22:57:47 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id EBtJzGoHdYMJb161 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 May 2016 22:57:45 -0700 (PDT)
Subject: [PATCH 5/7] reflink: test interaction with swap files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 May 2016 22:57:36 -0700
Message-ID: <146424225618.6278.13884344251723851779.stgit@birch.djwong.org>
In-Reply-To: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Since none of the current filesystems support reflinked swap files,
make sure that we prohibit reflinking of swapfiles and swapon of
reflinked files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 tests/generic/923     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/923.out |    6 ++++
 tests/generic/924     |   73 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/924.out |    5 +++
 tests/generic/group   |    2 +
 5 files changed, 160 insertions(+)
 create mode 100755 tests/generic/923
 create mode 100644 tests/generic/923.out
 create mode 100755 tests/generic/924
 create mode 100644 tests/generic/924.out


diff --git a/tests/generic/923 b/tests/generic/923
new file mode 100755
index 0000000..73c1621
--- /dev/null
+++ b/tests/generic/923
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. 923
+#
+# Check that we can't reflink a swapfile.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
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
+    cd /
+    rm -rf $tmp.*
+    wait
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
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
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((blocks * blksz)) $testdir/file1 >> $seqres.full
+mkswap -U 27376b42-ff65-42ca-919f-6c9b62292a5c $testdir/file1 >> $seqres.full
+swapon $testdir/file1
+
+echo "Try to reflink"
+_cp_reflink $testdir/file1 $testdir/file2 2>&1 | _filter_scratch
+
+echo "Tear it down"
+swapoff $testdir/file1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/923.out b/tests/generic/923.out
new file mode 100644
index 0000000..97c18cf
--- /dev/null
+++ b/tests/generic/923.out
@@ -0,0 +1,6 @@
+QA output created by 923
+Format and mount
+Initialize file
+Try to reflink
+cp: failed to clone 'SCRATCH_MNT/test-923/file2' from 'SCRATCH_MNT/test-923/file1': Text file busy
+Tear it down
diff --git a/tests/generic/924 b/tests/generic/924
new file mode 100755
index 0000000..86c2a39
--- /dev/null
+++ b/tests/generic/924
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FS QA Test No. 924
+#
+# Check that we can't swapon a reflinked file.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
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
+    cd /
+    rm -rf $tmp.*
+    wait
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
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
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((blocks * blksz)) $testdir/file1 >> $seqres.full
+mkswap -U 27376b42-ff65-42ca-919f-6c9b62292a5c $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 2>&1 | _filter_scratch
+
+echo "Try to swapon"
+swapon $testdir/file1 2>&1 | _filter_scratch
+
+swapoff $testdir/file1 >> $seqres.full 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/924.out b/tests/generic/924.out
new file mode 100644
index 0000000..b67e6fa
--- /dev/null
+++ b/tests/generic/924.out
@@ -0,0 +1,5 @@
+QA output created by 924
+Format and mount
+Initialize file
+Try to swapon
+swapon: SCRATCH_MNT/test-924/file1: swapon failed: Invalid argument
diff --git a/tests/generic/group b/tests/generic/group
index 36fb759..6fdf109 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -354,3 +354,5 @@
 349 blockdev quick rw
 350 blockdev quick rw
 351 blockdev quick rw
+923 auto quick clone
+924 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
