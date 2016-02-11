Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 970E97FA3
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:41:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5CC6C304051
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:57 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id CQsJ8vTXK6bA25sy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:52 -0800 (PST)
Subject: [PATCH 22/32] reflink: test quota accounting
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:41:48 -0800
Message-ID: <20160211234148.2202.94396.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/reflink        |    2 -
 tests/generic/305     |  100 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/305.out |   22 ++++++++++
 tests/generic/326     |  101 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/326.out |   22 ++++++++++
 tests/generic/327     |   87 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/327.out |   12 ++++++
 tests/generic/328     |  105 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/328.out |   25 ++++++++++++
 tests/generic/group   |    4 ++
 tests/xfs/213         |  105 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/213.out     |   22 ++++++++++
 tests/xfs/214         |  106 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/214.out     |   22 ++++++++++
 tests/xfs/group       |    2 +
 15 files changed, 736 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/305
 create mode 100644 tests/generic/305.out
 create mode 100755 tests/generic/326
 create mode 100644 tests/generic/326.out
 create mode 100755 tests/generic/327
 create mode 100644 tests/generic/327.out
 create mode 100755 tests/generic/328
 create mode 100644 tests/generic/328.out
 create mode 100755 tests/xfs/213
 create mode 100644 tests/xfs/213.out
 create mode 100755 tests/xfs/214
 create mode 100644 tests/xfs/214.out


diff --git a/common/reflink b/common/reflink
index 5d92a88..4ec390d 100644
--- a/common/reflink
+++ b/common/reflink
@@ -153,7 +153,7 @@ _cp_reflink() {
 	file1="$1"
 	file2="$2"
 
-	cp --reflink=always "$file1" "$file2"
+	cp --reflink=always -p "$file1" "$file2"
 }
 
 # Reflink some file1 into file2
diff --git a/tests/generic/305 b/tests/generic/305
new file mode 100755
index 0000000..9356a86
--- /dev/null
+++ b/tests/generic/305
@@ -0,0 +1,100 @@
+#! /bin/bash
+# FS QA Test No. 305
+#
+# Ensure that quota charges us for reflinking a file and that we're not
+# charged for buffered copy on write.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/quota
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+_require_fiemap
+_require_quota
+_require_nobody
+
+_repquota() {
+	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
+}
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
+_scratch_mount >> $seqres.full 2>&1
+quotacheck -u -g $SCRATCH_MNT 2> /dev/null
+quotaon $SCRATCH_MNT 2> /dev/null
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+sz=1048576
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
+touch $testdir/urk
+chown nobody $testdir/urk
+touch $testdir/erk
+chown fsgqa $testdir/erk
+_repquota
+_scratch_remount
+
+echo "Change file ownership"
+chown fsgqa $testdir/file1
+chown fsgqa $testdir/file2
+chown fsgqa $testdir/file3
+_repquota
+
+echo "CoW one of the files"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $((sz/2)) 0 $((sz/2))" -c "fsync" $testdir/file2 >> $seqres.full
+_repquota
+
+echo "Remount the FS to see if accounting changes"
+_scratch_remount
+_repquota
+
+echo "Chown one of the files"
+chown nobody $testdir/file3
+_repquota
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/305.out b/tests/generic/305.out
new file mode 100644
index 0000000..0bfd620
--- /dev/null
+++ b/tests/generic/305.out
@@ -0,0 +1,22 @@
+QA output created by 305
+Format and mount
+Create the original files
+root      --    3072       0       0              7     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --       0       0       0              1     0     0       
+Change file ownership
+root      --       0       0       0              4     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --    3072       0       0              4     0     0       
+CoW one of the files
+root      --       0       0       0              4     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --    3072       0       0              4     0     0       
+Remount the FS to see if accounting changes
+root      --       0       0       0              4     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --    3072       0       0              4     0     0       
+Chown one of the files
+root      --       0       0       0              4     0     0       
+nobody    --    1024       0       0              2     0     0       
+fsgqa     --    2048       0       0              3     0     0       
diff --git a/tests/generic/326 b/tests/generic/326
new file mode 100755
index 0000000..b6c748c
--- /dev/null
+++ b/tests/generic/326
@@ -0,0 +1,101 @@
+#! /bin/bash
+# FS QA Test No. 326
+#
+# Ensure that quota charges us for reflinking a file and that we're not
+# charged for directio copy on write.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/quota
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+_require_fiemap
+_require_quota
+_require_nobody
+_require_odirect
+
+_repquota() {
+	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
+}
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
+_scratch_mount >> $seqres.full 2>&1
+quotacheck -u -g $SCRATCH_MNT 2> /dev/null
+quotaon $SCRATCH_MNT 2> /dev/null
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+sz=1048576
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
+touch $testdir/urk
+chown nobody $testdir/urk
+touch $testdir/erk
+chown fsgqa $testdir/erk
+_repquota
+_scratch_remount
+
+echo "Change file ownership"
+chown fsgqa $testdir/file1
+chown fsgqa $testdir/file2
+chown fsgqa $testdir/file3
+_repquota
+
+echo "CoW one of the files"
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $((sz/2)) 0 $((sz/2))" -c "fsync" $testdir/file2 >> $seqres.full
+_repquota
+
+echo "Remount the FS to see if accounting changes"
+_scratch_remount
+_repquota
+
+echo "Chown one of the files"
+chown nobody $testdir/file3
+_repquota
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/326.out b/tests/generic/326.out
new file mode 100644
index 0000000..e771eb7
--- /dev/null
+++ b/tests/generic/326.out
@@ -0,0 +1,22 @@
+QA output created by 326
+Format and mount
+Create the original files
+root      --    3072       0       0              7     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --       0       0       0              1     0     0       
+Change file ownership
+root      --       0       0       0              4     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --    3072       0       0              4     0     0       
+CoW one of the files
+root      --       0       0       0              4     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --    3072       0       0              4     0     0       
+Remount the FS to see if accounting changes
+root      --       0       0       0              4     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --    3072       0       0              4     0     0       
+Chown one of the files
+root      --       0       0       0              4     0     0       
+nobody    --    1024       0       0              2     0     0       
+fsgqa     --    2048       0       0              3     0     0       
diff --git a/tests/generic/327 b/tests/generic/327
new file mode 100755
index 0000000..90d2aca
--- /dev/null
+++ b/tests/generic/327
@@ -0,0 +1,87 @@
+#! /bin/bash
+# FS QA Test No. 327
+#
+# Ensure that we can't go over the hard block limit when reflinking.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/quota
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+_require_fiemap
+_require_quota
+_require_nobody
+
+_repquota() {
+	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
+}
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
+_scratch_mount >> $seqres.full 2>&1
+quotacheck -u -g $SCRATCH_MNT 2> /dev/null
+quotaon $SCRATCH_MNT 2> /dev/null
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+sz=1048576
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
+chown fsgqa $testdir/file1
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_repquota
+_scratch_remount
+
+echo "Set hard quota to prevent third reflink"
+setquota -u fsgqa 0 1024 0 0 $SCRATCH_MNT
+_repquota
+
+echo "Try to reflink again"
+touch $testdir/file3
+chown fsgqa $testdir/file3
+_cp_reflink $testdir/file1 $testdir/file3 2>&1 | _filter_scratch
+_repquota
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/327.out b/tests/generic/327.out
new file mode 100644
index 0000000..7160ff2
--- /dev/null
+++ b/tests/generic/327.out
@@ -0,0 +1,12 @@
+QA output created by 327
+Format and mount
+Create the original files
+root      --       0       0       0              4     0     0       
+fsgqa     --    2048       0       0              2     0     0       
+Set hard quota to prevent third reflink
+root      --       0       0       0              4     0     0       
+fsgqa     +-    2048       0    1024              2     0     0       
+Try to reflink again
+cp: failed to clone 'SCRATCH_MNT/test-327/file3' from 'SCRATCH_MNT/test-327/file1': Disk quota exceeded
+root      --       0       0       0              4     0     0       
+fsgqa     +-    2048       0    1024              3     0     0       
diff --git a/tests/generic/328 b/tests/generic/328
new file mode 100755
index 0000000..46cfa66
--- /dev/null
+++ b/tests/generic/328
@@ -0,0 +1,105 @@
+#! /bin/bash
+# FS QA Test No. 328
+#
+# Ensure that we can't go over the hard block limit when CoWing a file.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/quota
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+_require_fiemap
+_require_quota
+_require_nobody
+_require_odirect
+
+_repquota() {
+	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
+}
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
+_scratch_mount >> $seqres.full 2>&1
+quotacheck -u -g $SCRATCH_MNT 2> /dev/null
+quotaon $SCRATCH_MNT 2> /dev/null
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+sz=1048576
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
+chown fsgqa $testdir/file1
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
+_repquota
+_scratch_remount
+
+echo "Set hard quota to prevent rewrite"
+setquota -u fsgqa 0 1024 0 0 $SCRATCH_MNT
+_repquota
+
+echo "Try to dio write the whole file"
+_pwrite_byte 0x62 0 $sz $testdir/file1 -d >> $seqres.full
+_repquota
+
+echo "Try to write the whole file"
+_pwrite_byte 0x62 0 $sz $testdir/file1 >> $seqres.full
+_repquota
+
+echo "Set hard quota to allow rewrite"
+setquota -u fsgqa 0 8192 0 0 $SCRATCH_MNT
+_repquota
+
+echo "Try to dio write the whole file"
+_pwrite_byte 0x62 0 $sz $testdir/file1 -d >> $seqres.full
+sync
+_repquota
+
+echo "Try to write the whole file"
+_pwrite_byte 0x62 0 $sz $testdir/file3 >> $seqres.full
+sync
+_repquota
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/328.out b/tests/generic/328.out
new file mode 100644
index 0000000..5e99255
--- /dev/null
+++ b/tests/generic/328.out
@@ -0,0 +1,25 @@
+QA output created by 328
+Format and mount
+Create the original files
+root      --       0       0       0              4     0     0       
+fsgqa     --    3072       0       0              3     0     0       
+Set hard quota to prevent rewrite
+root      --       0       0       0              4     0     0       
+fsgqa     +-    3072       0    1024              3     0     0       
+Try to dio write the whole file
+pwrite64: Disk quota exceeded
+root      --       0       0       0              4     0     0       
+fsgqa     +-    3072       0    1024              3     0     0       
+Try to write the whole file
+pwrite64: Disk quota exceeded
+root      --       0       0       0              4     0     0       
+fsgqa     +-    3072       0    1024              3     0     0       
+Set hard quota to allow rewrite
+root      --       0       0       0              4     0     0       
+fsgqa     --    3072       0    8192              3     0     0       
+Try to dio write the whole file
+root      --       0       0       0              4     0     0       
+fsgqa     --    3072       0    8192              3     0     0       
+Try to write the whole file
+root      --       0       0       0              4     0     0       
+fsgqa     --    3072       0    8192              3     0     0       
diff --git a/tests/generic/group b/tests/generic/group
index 4a1cce4..8b9e0e5 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -307,6 +307,7 @@
 302 auto quick clone
 303 auto quick clone
 304 auto quick clone
+305 auto quick clone
 306 auto quick rw
 307 auto quick
 308 auto quick
@@ -327,3 +328,6 @@
 323 auto aio stress
 324 auto fsr quick
 325 auto quick data log
+326 auto quick clone
+327 auto quick clone
+328 auto quick clone
diff --git a/tests/xfs/213 b/tests/xfs/213
new file mode 100755
index 0000000..2450097
--- /dev/null
+++ b/tests/xfs/213
@@ -0,0 +1,105 @@
+#! /bin/bash
+# FS QA Test No. 213
+#
+# Ensure that quota charges us for reflnking a file and that we're not
+# charged for buffered copy on write.  Same test as g/305, but we get to
+# play with cowextsz.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/quota
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+_require_fiemap
+_require_quota
+_require_nobody
+_require_xfs_io_command "cowextsize"
+
+_repquota() {
+	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
+}
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
+_scratch_mount >> $seqres.full 2>&1
+quotacheck -u -g $SCRATCH_MNT 2> /dev/null
+quotaon $SCRATCH_MNT 2> /dev/null
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+sz=1048576
+blksz=65536
+echo "Create the original files"
+$XFS_IO_PROG -c "cowextsize $((sz/2))" $testdir >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
+touch $testdir/urk
+chown nobody $testdir/urk
+touch $testdir/erk
+chown fsgqa $testdir/erk
+_repquota
+_scratch_remount
+
+echo "Change file ownership"
+chown fsgqa $testdir/file1
+chown fsgqa $testdir/file2
+chown fsgqa $testdir/file3
+_repquota
+
+echo "CoW one of the files"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $blksz $((sz - blksz)) $blksz" -c "fsync" $testdir/file2 >> $seqres.full
+_repquota
+
+echo "Remount the FS to see if accounting changes"
+_scratch_remount
+_repquota
+
+echo "Chown one of the files"
+chown nobody $testdir/file3
+_repquota
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/213.out b/tests/xfs/213.out
new file mode 100644
index 0000000..be8d56c
--- /dev/null
+++ b/tests/xfs/213.out
@@ -0,0 +1,22 @@
+QA output created by 213
+Format and mount
+Create the original files
+root      --    3072       0       0              7     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --       0       0       0              1     0     0       
+Change file ownership
+root      --       0       0       0              4     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --    3072       0       0              4     0     0       
+CoW one of the files
+root      --       0       0       0              4     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --    3520       0       0              4     0     0       
+Remount the FS to see if accounting changes
+root      --       0       0       0              4     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --    3072       0       0              4     0     0       
+Chown one of the files
+root      --       0       0       0              4     0     0       
+nobody    --    1024       0       0              2     0     0       
+fsgqa     --    2048       0       0              3     0     0       
diff --git a/tests/xfs/214 b/tests/xfs/214
new file mode 100755
index 0000000..847f489
--- /dev/null
+++ b/tests/xfs/214
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test No. 214
+#
+# Ensure that quota charges us for reflnking a file and that we're not
+# charged for directio copy on write.  Same as g/326, but we get to play
+# with cowextsz.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/quota
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+_require_fiemap
+_require_quota
+_require_nobody
+_require_xfs_io_command "cowextsize"
+_require_odirect
+
+_repquota() {
+	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
+}
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
+_scratch_mount >> $seqres.full 2>&1
+quotacheck -u -g $SCRATCH_MNT 2> /dev/null
+quotaon $SCRATCH_MNT 2> /dev/null
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+sz=1048576
+blksz=65536
+echo "Create the original files"
+$XFS_IO_PROG -c "cowextsize $((sz/2))" $testdir >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $sz 0 $sz" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
+touch $testdir/urk
+chown nobody $testdir/urk
+touch $testdir/erk
+chown fsgqa $testdir/erk
+_repquota
+_scratch_remount
+
+echo "Change file ownership"
+chown fsgqa $testdir/file1
+chown fsgqa $testdir/file2
+chown fsgqa $testdir/file3
+_repquota
+
+echo "CoW one of the files"
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $blksz $((sz - blksz)) $blksz" -c "fsync" $testdir/file2 >> $seqres.full
+_repquota
+
+echo "Remount the FS to see if accounting changes"
+_scratch_remount
+_repquota
+
+echo "Chown one of the files"
+chown nobody $testdir/file3
+_repquota
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/214.out b/tests/xfs/214.out
new file mode 100644
index 0000000..496a503
--- /dev/null
+++ b/tests/xfs/214.out
@@ -0,0 +1,22 @@
+QA output created by 214
+Format and mount
+Create the original files
+root      --    3072       0       0              7     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --       0       0       0              1     0     0       
+Change file ownership
+root      --       0       0       0              4     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --    3072       0       0              4     0     0       
+CoW one of the files
+root      --       0       0       0              4     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --    3520       0       0              4     0     0       
+Remount the FS to see if accounting changes
+root      --       0       0       0              4     0     0       
+nobody    --       0       0       0              1     0     0       
+fsgqa     --    3072       0       0              4     0     0       
+Chown one of the files
+root      --       0       0       0              4     0     0       
+nobody    --    1024       0       0              2     0     0       
+fsgqa     --    2048       0       0              3     0     0       
diff --git a/tests/xfs/group b/tests/xfs/group
index d4a0d59..afd960f 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -210,6 +210,8 @@
 210 auto quick clone
 211 clone_stress
 212 auto quick clone
+213 auto quick clone
+214 auto quick clone
 216 log metadata auto quick
 217 log metadata auto
 220 auto quota quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
