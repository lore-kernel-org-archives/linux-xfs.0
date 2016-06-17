Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CE1FC853F
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:47:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 914B0304048
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:47:30 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id z4PMeJFmP1xG08M1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:47:22 -0700 (PDT)
Subject: [PATCH 11/20] xfs: inject errors at various parts of the deferred
	op completion
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:47:11 -0700
Message-ID: <146612803133.25024.1931929844195025512.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
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
 common/inject     |   93 +++++++++++++++++++++++++++++++++++++++++++++
 common/log        |   28 ++++++++++++++
 common/rc         |    8 ++++
 tests/xfs/857     |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/857.out |   18 +++++++++
 tests/xfs/858     |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/858.out |   18 +++++++++
 tests/xfs/859     |  106 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/859.out |   18 +++++++++
 tests/xfs/860     |   99 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/860.out |   16 ++++++++
 tests/xfs/861     |  100 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/861.out |   16 ++++++++
 tests/xfs/862     |   95 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/862.out |   16 ++++++++
 tests/xfs/863     |   93 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/863.out |   15 +++++++
 tests/xfs/864     |   98 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/864.out |   19 +++++++++
 tests/xfs/865     |   96 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/865.out |   18 +++++++++
 tests/xfs/866     |   95 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/866.out |   17 ++++++++
 tests/xfs/867     |   98 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/867.out |   17 ++++++++
 tests/xfs/868     |   95 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/868.out |   17 ++++++++
 tests/xfs/869     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/869.out |   17 ++++++++
 tests/xfs/870     |   95 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/870.out |   15 +++++++
 tests/xfs/871     |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/871.out |   18 +++++++++
 tests/xfs/group   |   15 +++++++
 34 files changed, 1883 insertions(+)
 create mode 100644 common/inject
 create mode 100755 tests/xfs/857
 create mode 100644 tests/xfs/857.out
 create mode 100755 tests/xfs/858
 create mode 100644 tests/xfs/858.out
 create mode 100755 tests/xfs/859
 create mode 100644 tests/xfs/859.out
 create mode 100755 tests/xfs/860
 create mode 100644 tests/xfs/860.out
 create mode 100755 tests/xfs/861
 create mode 100644 tests/xfs/861.out
 create mode 100755 tests/xfs/862
 create mode 100644 tests/xfs/862.out
 create mode 100755 tests/xfs/863
 create mode 100644 tests/xfs/863.out
 create mode 100755 tests/xfs/864
 create mode 100644 tests/xfs/864.out
 create mode 100755 tests/xfs/865
 create mode 100644 tests/xfs/865.out
 create mode 100755 tests/xfs/866
 create mode 100644 tests/xfs/866.out
 create mode 100755 tests/xfs/867
 create mode 100644 tests/xfs/867.out
 create mode 100755 tests/xfs/868
 create mode 100644 tests/xfs/868.out
 create mode 100755 tests/xfs/869
 create mode 100644 tests/xfs/869.out
 create mode 100755 tests/xfs/870
 create mode 100644 tests/xfs/870.out
 create mode 100755 tests/xfs/871
 create mode 100644 tests/xfs/871.out


diff --git a/common/inject b/common/inject
new file mode 100644
index 0000000..e666d6d
--- /dev/null
+++ b/common/inject
@@ -0,0 +1,93 @@
+##/bin/bash
+# Routines for injecting errors into filesystems
+#-----------------------------------------------------------------------
+#  Copyright (c) 2016 Oracle.  All Rights Reserved.
+#  This program is free software; you can redistribute it and/or modify
+#  it under the terms of the GNU General Public License as published by
+#  the Free Software Foundation; either version 2 of the License, or
+#  (at your option) any later version.
+#
+#  This program is distributed in the hope that it will be useful,
+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+#  GNU General Public License for more details.
+#
+#  You should have received a copy of the GNU General Public License
+#  along with this program; if not, write to the Free Software
+#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+#  USA
+#
+#  Contact information: Oracle Corporation, 500 Oracle Parkway,
+#  Redwood Shores, CA 94065, USA, or: http://www.oracle.com/
+#-----------------------------------------------------------------------
+. ./common/log
+
+# Tests whether $FSTYP is one of the filesystems that supports error injection
+_require_error_injection()
+{
+	case "$FSTYP" in
+	"xfs")
+		grep -q 'debug 1' /proc/fs/xfs/stat || \
+			_notrun "XFS error injection requires CONFIG_XFS_DEBUG"
+		;;
+	*)
+		_notrun "Error injection not supported on filesystem type: $FSTYP"
+	esac
+}
+
+# Requires that xfs_io inject command knows about this error type
+_require_xfs_io_error_injection()
+{
+	type="$1"
+	_require_error_injection
+
+	# NOTE: We can't actually test error injection here because xfs
+	# hasn't always range checked the argument to xfs_errortag_add.
+	# We also don't want to trip an error before we're ready to deal
+	# with it.
+
+	$XFS_IO_PROG -x -c 'inject' $TEST_DIR | grep -q "$type" || \
+		_notrun "XFS error injection $type unknown."
+}
+
+# Inject an error into the test fs
+_test_inject_error()
+{
+	type="$1"
+	
+	$XFS_IO_PROG -x -c "inject $type" $TEST_DIR
+}
+
+# Inject an error into the scratch fs
+_scratch_inject_error()
+{
+	type="$1"
+	
+	$XFS_IO_PROG -x -c "inject $type" $SCRATCH_MNT
+}
+
+# Unmount and remount the scratch device, dumping the log
+_scratch_inject_logprint()
+{
+	local opts="$1"
+
+	if test -n "$opts"; then
+		opts="-o $opts"
+	fi
+	_scratch_unmount
+	_scratch_dump_log
+	_scratch_mount "$opts"
+}
+
+# Unmount and remount the test device, dumping the log
+_test_inject_logprint()
+{
+	local opts="$1"
+
+	if test -n "$opts"; then
+		opts="-o $opts"
+	fi
+	_test_unmount
+	_test_dump_log
+	_test_mount "$opts"
+}
diff --git a/common/log b/common/log
index cb687d2..44b9625 100644
--- a/common/log
+++ b/common/log
@@ -228,6 +228,34 @@ _scratch_f2fs_logstate()
     echo $?
 }
 
+_scratch_dump_log()
+{
+    case "$FSTYP" in
+    xfs)
+        _scratch_xfs_logprint
+        ;;
+    f2fs)
+        $DUMP_F2FS_PROG $SCRATCH_DEV
+        ;;
+    *)
+        ;;
+    esac
+}
+
+_test_dump_log()
+{
+    case "$FSTYP" in
+    xfs)
+        _test_xfs_logprint
+        ;;
+    f2fs)
+        $DUMP_F2FS_PROG $TEST_DEV
+        ;;
+    *)
+        ;;
+    esac
+}
+
 _print_logstate()
 {
     case "$FSTYP" in
diff --git a/common/rc b/common/rc
index 1648a8a..1225047 100644
--- a/common/rc
+++ b/common/rc
@@ -982,6 +982,14 @@ _scratch_xfs_logprint()
     $XFS_LOGPRINT_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
+_test_xfs_logprint()
+{
+    TEST_OPTIONS=""
+    [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_LOGDEV" ] && \
+        TEST_OPTIONS="-l$TEST_LOGDEV"
+    $XFS_LOGPRINT_PROG $TEST_OPTIONS $* $TEST_DEV
+}
+
 _scratch_xfs_check()
 {
     SCRATCH_OPTIONS=""
diff --git a/tests/xfs/857 b/tests/xfs/857
new file mode 100755
index 0000000..7798362
--- /dev/null
+++ b/tests/xfs/857
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 857
+#
+# Reflink a file with a few dozen extents, CoW a few blocks, and rm.
+# Inject an error during block remap to test log recovery.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_xfs_io_error_injection "bmap_finish_one"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+echo "Create files"
+_pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file3
+
+# Punch holes in file3
+seq 1 2 $blks | while read off; do
+	$XFS_IO_PROG -c "fpunch $((off * blksz)) $blksz" $SCRATCH_MNT/file3 >> $seqres.full
+done
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "bmap_finish_one"
+
+echo "CoW a few blocks"
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Check files again"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/857.out b/tests/xfs/857.out
new file mode 100644
index 0000000..ecc8e04
--- /dev/null
+++ b/tests/xfs/857.out
@@ -0,0 +1,18 @@
+QA output created by 857
+Format filesystem
+Create files
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file2
+153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
+Inject error
+CoW a few blocks
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Check files again
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+1e108771fba35e2f2961d1ad23efbff7  SCRATCH_MNT/file2
+153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
+Done
diff --git a/tests/xfs/858 b/tests/xfs/858
new file mode 100755
index 0000000..fe3ac07
--- /dev/null
+++ b/tests/xfs/858
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 858
+#
+# Reflink a file with a few dozen extents, CoW a few blocks, and rm.
+# Inject an error during refcount updates to test log recovery.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_xfs_io_error_injection "refcount_finish_one"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+echo "Create files"
+_pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file3
+
+# Punch holes in file3
+seq 1 2 $blks | while read off; do
+	$XFS_IO_PROG -c "fpunch $((off * blksz)) $blksz" $SCRATCH_MNT/file3 >> $seqres.full
+done
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "refcount_finish_one"
+
+echo "CoW a few blocks"
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Check files again"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/858.out b/tests/xfs/858.out
new file mode 100644
index 0000000..f5302de
--- /dev/null
+++ b/tests/xfs/858.out
@@ -0,0 +1,18 @@
+QA output created by 858
+Format filesystem
+Create files
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file2
+153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
+Inject error
+CoW a few blocks
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Check files again
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file2
+153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
+Done
diff --git a/tests/xfs/859 b/tests/xfs/859
new file mode 100755
index 0000000..c36cc5b
--- /dev/null
+++ b/tests/xfs/859
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test No. 859
+#
+# Reflink a file with a few dozen extents, CoW a few blocks, and rm.
+# Inject an error during rmap updates to test log recovery.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_error_injection
+_require_xfs_io_error_injection "rmap_finish_one"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+is_rmap=$(xfs_info $SCRATCH_MNT | grep -c "rmapbt=1")
+test $is_rmap -gt 0 || _notrun "rmap not supported on scratch fs"
+
+echo "Create files"
+_pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file3
+
+# Punch holes in file3
+seq 1 2 $blks | while read off; do
+	$XFS_IO_PROG -c "fpunch $((off * blksz)) $blksz" $SCRATCH_MNT/file3 >> $seqres.full
+done
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "rmap_finish_one"
+
+echo "CoW a few blocks"
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Check files again"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/859.out b/tests/xfs/859.out
new file mode 100644
index 0000000..b83e963
--- /dev/null
+++ b/tests/xfs/859.out
@@ -0,0 +1,18 @@
+QA output created by 859
+Format filesystem
+Create files
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file2
+153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
+Inject error
+CoW a few blocks
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Check files again
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file2
+153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
+Done
diff --git a/tests/xfs/860 b/tests/xfs/860
new file mode 100755
index 0000000..15716c1
--- /dev/null
+++ b/tests/xfs/860
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. 860
+#
+# Reflink a file with a few dozen extents and CoW a few blocks.
+# Inject an error during extent freeing to test log recovery.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_error_injection
+_require_xfs_io_error_injection "free_extent"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=4
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+$XFS_IO_PROG -c "cowextsize $sz" $SCRATCH_MNT
+
+echo "Create files"
+_pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+_pwrite_byte 0x66 $((sz / 2)) $((sz / 2)) $SCRATCH_MNT/file2 >> $seqres.full
+_reflink_range $SCRATCH_MNT/file1 0 $SCRATCH_MNT/file2 0 $((sz / 2)) >> $seqres.full
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "free_extent"
+
+echo "CoW a few blocks"
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz 0 $sz" $SCRATCH_MNT/file1 >> $seqres.full
+sync
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Check files again"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/860.out b/tests/xfs/860.out
new file mode 100644
index 0000000..0a6d763
--- /dev/null
+++ b/tests/xfs/860.out
@@ -0,0 +1,16 @@
+QA output created by 860
+Format filesystem
+Create files
+Check files
+cf41e243bf211225660f3fabe6db9eb6  SCRATCH_MNT/file1
+cf41e243bf211225660f3fabe6db9eb6  SCRATCH_MNT/file2
+Inject error
+CoW a few blocks
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Check files again
+fe9070b9c9deb97ed53811efda5c4ad5  SCRATCH_MNT/file1
+cf41e243bf211225660f3fabe6db9eb6  SCRATCH_MNT/file2
+Done
diff --git a/tests/xfs/861 b/tests/xfs/861
new file mode 100755
index 0000000..6f716a4
--- /dev/null
+++ b/tests/xfs/861
@@ -0,0 +1,100 @@
+#! /bin/bash
+# FS QA Test No. 861
+#
+# Reflink a file with a few dozen extents, CoW a few blocks, and rm.
+# Force XFS into "two refcount updates per transaction" mode.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_error_injection
+_require_xfs_io_error_injection "refcount_continue_update"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+echo "Create files"
+_pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file3
+
+# Punch holes in file3
+seq 1 2 $blks | while read off; do
+	$XFS_IO_PROG -c "fpunch $((off * blksz)) $blksz" $SCRATCH_MNT/file3 >> $seqres.full
+done
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "refcount_continue_update"
+
+echo "CoW all the blocks"
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz 0 $((blks * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Check files again"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/861.out b/tests/xfs/861.out
new file mode 100644
index 0000000..d353526
--- /dev/null
+++ b/tests/xfs/861.out
@@ -0,0 +1,16 @@
+QA output created by 861
+Format filesystem
+Create files
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file2
+153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
+Inject error
+CoW all the blocks
+Remount to replay log
+FS should be online, touch should succeed
+Check files again
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+4155b81ac6d45c0182fa2bc03960f230  SCRATCH_MNT/file2
+153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
+Done
diff --git a/tests/xfs/862 b/tests/xfs/862
new file mode 100755
index 0000000..167386c
--- /dev/null
+++ b/tests/xfs/862
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 862
+#
+# Simulate rmap update errors with a file write and a file remove.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch
+_require_error_injection
+_require_xfs_io_error_injection "rmap_finish_one"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+is_rmap=$(xfs_info $SCRATCH_MNT | grep -c "rmapbt=1")
+test $is_rmap -gt 0 || _notrun "rmap not supported on scratch fs"
+
+echo "Create files"
+touch $SCRATCH_MNT/file1
+_pwrite_byte 0x67 0 $sz $SCRATCH_MNT/file0 >> $seqres.full
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file0 | _filter_scratch
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "rmap_finish_one"
+
+echo "Write files"
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz 0 $sz" $SCRATCH_MNT/file1 >> $seqres.full
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file0 | _filter_scratch
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/862.out b/tests/xfs/862.out
new file mode 100644
index 0000000..1f6b47b
--- /dev/null
+++ b/tests/xfs/862.out
@@ -0,0 +1,16 @@
+QA output created by 862
+Format filesystem
+Create files
+Check files
+4155b81ac6d45c0182fa2bc03960f230  SCRATCH_MNT/file0
+d41d8cd98f00b204e9800998ecf8427e  SCRATCH_MNT/file1
+Inject error
+Write files
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+Check files
+4155b81ac6d45c0182fa2bc03960f230  SCRATCH_MNT/file0
+d41d8cd98f00b204e9800998ecf8427e  SCRATCH_MNT/file1
+FS should be online, touch should succeed
+Done
diff --git a/tests/xfs/863 b/tests/xfs/863
new file mode 100755
index 0000000..5069245
--- /dev/null
+++ b/tests/xfs/863
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 863
+#
+# Simulate free extent errors with a file write and a file remove.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch
+_require_error_injection
+_require_xfs_io_error_injection "rmap_finish_one"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+echo "Create files"
+touch $SCRATCH_MNT/file1
+
+echo "Write files"
+$XFS_IO_PROG -c "pwrite -S 0x67 0 $sz" $SCRATCH_MNT/file1 >> $seqres.full
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 2>&1 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "free_extent"
+
+echo "Remove files"
+rm -rf $SCRATCH_MNT/file1
+sync
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 2>&1 | _filter_scratch
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/863.out b/tests/xfs/863.out
new file mode 100644
index 0000000..718691f
--- /dev/null
+++ b/tests/xfs/863.out
@@ -0,0 +1,15 @@
+QA output created by 863
+Format filesystem
+Create files
+Write files
+Check files
+4155b81ac6d45c0182fa2bc03960f230  SCRATCH_MNT/file1
+Inject error
+Remove files
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+Check files
+md5sum: SCRATCH_MNT/file1: No such file or directory
+FS should be online, touch should succeed
+Done
diff --git a/tests/xfs/864 b/tests/xfs/864
new file mode 100755
index 0000000..6483639
--- /dev/null
+++ b/tests/xfs/864
@@ -0,0 +1,98 @@
+#! /bin/bash
+# FS QA Test No. 864
+#
+# Reflink a file.
+# Inject an error during block remap to test log recovery.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_scratch_reflink
+_require_xfs_io_error_injection "bmap_finish_one"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+echo "Create files"
+_pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
+_pwrite_byte 0x67 0 $sz $SCRATCH_MNT/file3 >> $seqres.full
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "bmap_finish_one"
+
+echo "Try to reflink"
+_reflink_range $SCRATCH_MNT/file1 0 $SCRATCH_MNT/file3 0 $sz >> $seqres.full
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/864.out b/tests/xfs/864.out
new file mode 100644
index 0000000..cd16235
--- /dev/null
+++ b/tests/xfs/864.out
@@ -0,0 +1,19 @@
+QA output created by 864
+Format filesystem
+Create files
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file2
+4155b81ac6d45c0182fa2bc03960f230  SCRATCH_MNT/file3
+Inject error
+Try to reflink
+XFS_IOC_CLONE_RANGE: Input/output error
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file2
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file3
+FS should be online, touch should succeed
+Done
diff --git a/tests/xfs/865 b/tests/xfs/865
new file mode 100755
index 0000000..9e2bf05
--- /dev/null
+++ b/tests/xfs/865
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 865
+#
+# Reflink a file.
+# Inject an error during block remap to test log recovery.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_cp_reflink
+_require_xfs_io_error_injection "bmap_finish_one"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks - 17))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+echo "Create files"
+_pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "bmap_finish_one"
+
+echo "Try to reflink"
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file3 2>&1 | _filter_scratch
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/865.out b/tests/xfs/865.out
new file mode 100644
index 0000000..9a2b04d
--- /dev/null
+++ b/tests/xfs/865.out
@@ -0,0 +1,18 @@
+QA output created by 865
+Format filesystem
+Create files
+Check files
+a98e7df2a7a456009a493e47411c58d1  SCRATCH_MNT/file1
+a98e7df2a7a456009a493e47411c58d1  SCRATCH_MNT/file2
+Inject error
+Try to reflink
+cp: failed to clone 'SCRATCH_MNT/file3' from 'SCRATCH_MNT/file1': Input/output error
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+Check files
+a98e7df2a7a456009a493e47411c58d1  SCRATCH_MNT/file1
+a98e7df2a7a456009a493e47411c58d1  SCRATCH_MNT/file2
+a98e7df2a7a456009a493e47411c58d1  SCRATCH_MNT/file3
+FS should be online, touch should succeed
+Done
diff --git a/tests/xfs/866 b/tests/xfs/866
new file mode 100755
index 0000000..9405325
--- /dev/null
+++ b/tests/xfs/866
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 866
+#
+# Reflink a file.
+# Inject an error during refcount update to test log recovery.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_scratch_reflink
+_require_xfs_io_error_injection "refcount_finish_one"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+echo "Create files"
+_pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $sz" $SCRATCH_MNT/file3 >> $seqres.full
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "refcount_finish_one"
+
+echo "Try to reflink"
+_reflink_range $SCRATCH_MNT/file1 0 $SCRATCH_MNT/file3 0 $sz >> $seqres.full
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/866.out b/tests/xfs/866.out
new file mode 100644
index 0000000..f2ca58c
--- /dev/null
+++ b/tests/xfs/866.out
@@ -0,0 +1,17 @@
+QA output created by 866
+Format filesystem
+Create files
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+b5cfa9d6c8febd618f91ac2843d50a1c  SCRATCH_MNT/file3
+Inject error
+Try to reflink
+XFS_IOC_CLONE_RANGE: Input/output error
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file3
+FS should be online, touch should succeed
+Done
diff --git a/tests/xfs/867 b/tests/xfs/867
new file mode 100755
index 0000000..5037a88
--- /dev/null
+++ b/tests/xfs/867
@@ -0,0 +1,98 @@
+#! /bin/bash
+# FS QA Test No. 867
+#
+# Reflink a file.
+# Inject an error during rmap update to test log recovery.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_scratch_reflink
+_require_xfs_io_error_injection "rmap_finish_one"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+is_rmap=$(xfs_info $SCRATCH_MNT | grep -c "rmapbt=1")
+test $is_rmap -gt 0 || _notrun "rmap not supported on scratch fs"
+
+echo "Create files"
+_pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $sz" $SCRATCH_MNT/file3 >> $seqres.full
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "rmap_finish_one"
+
+echo "Try to reflink"
+_reflink_range $SCRATCH_MNT/file1 0 $SCRATCH_MNT/file3 0 $sz >> $seqres.full
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/867.out b/tests/xfs/867.out
new file mode 100644
index 0000000..78a4e5a
--- /dev/null
+++ b/tests/xfs/867.out
@@ -0,0 +1,17 @@
+QA output created by 867
+Format filesystem
+Create files
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+b5cfa9d6c8febd618f91ac2843d50a1c  SCRATCH_MNT/file3
+Inject error
+Try to reflink
+XFS_IOC_CLONE_RANGE: Input/output error
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file3
+FS should be online, touch should succeed
+Done
diff --git a/tests/xfs/868 b/tests/xfs/868
new file mode 100755
index 0000000..71cf7ee
--- /dev/null
+++ b/tests/xfs/868
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 868
+#
+# Reflink a file.
+# Inject an error during extent free to test log recovery.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_scratch_reflink
+_require_xfs_io_error_injection "free_extent"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+echo "Create files"
+_pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+_pwrite_byte 0x67 0 $sz $SCRATCH_MNT/file3 >> $seqres.full
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "free_extent"
+
+echo "Try to reflink"
+_reflink_range $SCRATCH_MNT/file1 0 $SCRATCH_MNT/file3 0 $sz >> $seqres.full
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/868.out b/tests/xfs/868.out
new file mode 100644
index 0000000..583b1f9
--- /dev/null
+++ b/tests/xfs/868.out
@@ -0,0 +1,17 @@
+QA output created by 868
+Format filesystem
+Create files
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+4155b81ac6d45c0182fa2bc03960f230  SCRATCH_MNT/file3
+Inject error
+Try to reflink
+XFS_IOC_CLONE_RANGE: Input/output error
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file3
+FS should be online, touch should succeed
+Done
diff --git a/tests/xfs/869 b/tests/xfs/869
new file mode 100755
index 0000000..97c803b
--- /dev/null
+++ b/tests/xfs/869
@@ -0,0 +1,101 @@
+#! /bin/bash
+# FS QA Test No. 869
+#
+# Reflink a file with a few dozen extents.
+# Force XFS into "two refcount updates per transaction" mode.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_error_injection
+_require_xfs_io_error_injection "refcount_continue_update"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+echo "Create files"
+_pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file3
+
+# Punch holes in file3
+seq 1 2 $blks | while read off; do
+	$XFS_IO_PROG -c "fpunch $((off * blksz)) $blksz" $SCRATCH_MNT/file3 >> $seqres.full
+done
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "refcount_continue_update"
+
+echo "Reflink all the blocks"
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file4
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Check files again"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+md5sum $SCRATCH_MNT/file4 | _filter_scratch
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/869.out b/tests/xfs/869.out
new file mode 100644
index 0000000..1e7822e
--- /dev/null
+++ b/tests/xfs/869.out
@@ -0,0 +1,17 @@
+QA output created by 869
+Format filesystem
+Create files
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file2
+153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
+Inject error
+Reflink all the blocks
+Remount to replay log
+FS should be online, touch should succeed
+Check files again
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file2
+153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file4
+Done
diff --git a/tests/xfs/870 b/tests/xfs/870
new file mode 100755
index 0000000..fc13f53
--- /dev/null
+++ b/tests/xfs/870
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 870
+#
+# Reflink a file with a few dozen extents, CoW a few blocks, and rm.
+# Inject an error during extent freeing to test log recovery.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_error_injection
+_require_xfs_io_error_injection "free_extent"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=30
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+echo "Create files"
+_pwrite_byte 0x66 0 $((blksz * blks)) $SCRATCH_MNT/file1 >> $seqres.full
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "Inject error"
+_scratch_inject_error "free_extent"
+
+echo "CoW a few blocks"
+$XFS_IO_PROG -c "pwrite -W -S 0x67 $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
+rm $SCRATCH_MNT/file1
+sync
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Check files again"
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/870.out b/tests/xfs/870.out
new file mode 100644
index 0000000..49c4e4b
--- /dev/null
+++ b/tests/xfs/870.out
@@ -0,0 +1,15 @@
+QA output created by 870
+Format filesystem
+Create files
+Check files
+d5a0ed0305c8df4180cb2bf975ecffe8  SCRATCH_MNT/file1
+d5a0ed0305c8df4180cb2bf975ecffe8  SCRATCH_MNT/file2
+Inject error
+CoW a few blocks
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Check files again
+7629bd70d19d7291b448221ac44b26d9  SCRATCH_MNT/file2
+Done
diff --git a/tests/xfs/871 b/tests/xfs/871
new file mode 100755
index 0000000..69bb637
--- /dev/null
+++ b/tests/xfs/871
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. 871
+#
+# Reflink a file with a few dozen extents, CoW a few blocks, and rm.
+# Inject an error during refcount updates to test log recovery.  Use
+# cowextsize so that the refcount failure is somewhere in the CoW remap
+# instead of when we're stashing the CoW orphan record.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+_require_xfs_io_error_injection "refcount_finish_one"
+
+rm -f $seqres.full
+
+blksz=65536
+blks=64
+sz=$((blksz * blks))
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+$XFS_IO_PROG -c "cowextsize $sz" $SCRATCH_MNT
+
+echo "Create files"
+_pwrite_byte 0x66 0 $sz $SCRATCH_MNT/file1 >> $seqres.full
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file2
+_cp_reflink $SCRATCH_MNT/file1 $SCRATCH_MNT/file3
+
+# Punch holes in file3
+seq 1 2 $blks | while read off; do
+	$XFS_IO_PROG -c "fpunch $((off * blksz)) $blksz" $SCRATCH_MNT/file3 >> $seqres.full
+done
+sync
+
+echo "Check files"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+$XFS_IO_PROG -c "pwrite -W -S 0x67 $((10 * blksz)) 1" $SCRATCH_MNT/file2 >> $seqres.full
+sync
+
+echo "Inject error"
+_scratch_inject_error "refcount_finish_one"
+
+echo "CoW a few blocks"
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log"
+_scratch_inject_logprint >> $seqres.full
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+
+echo "Check files again"
+md5sum $SCRATCH_MNT/file1 | _filter_scratch
+md5sum $SCRATCH_MNT/file2 | _filter_scratch
+md5sum $SCRATCH_MNT/file3 | _filter_scratch
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/871.out b/tests/xfs/871.out
new file mode 100644
index 0000000..c0aba73
--- /dev/null
+++ b/tests/xfs/871.out
@@ -0,0 +1,18 @@
+QA output created by 871
+Format filesystem
+Create files
+Check files
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file2
+153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
+Inject error
+CoW a few blocks
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+FS should be online, touch should succeed
+Check files again
+2a4f043bf9730a9e8882c9264b9797b3  SCRATCH_MNT/file1
+1e108771fba35e2f2961d1ad23efbff7  SCRATCH_MNT/file2
+153498e22f8ff52d7f60b466a5e65285  SCRATCH_MNT/file3
+Done
diff --git a/tests/xfs/group b/tests/xfs/group
index 1ad37ff..0f94794 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -289,3 +289,18 @@
 854 auto quick clone
 855 auto clone
 856 auto quick clone rmap
+857 auto quick clone
+858 auto quick clone
+859 auto quick clone
+860 auto quick clone
+861 auto quick clone
+862 auto quick rmap
+863 auto quick rw
+864 auto quick clone
+865 auto quick clone
+866 auto quick clone
+867 auto quick clone
+868 auto quick clone
+869 auto quick clone
+870 auto quick clone
+871 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
