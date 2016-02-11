Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD3407FA5
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:42:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66987AC002
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:15 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id kruGEDlc6qFVZClp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:12 -0800 (PST)
Subject: [PATCH 25/32] xfs: test rmapbt functionality
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:42:08 -0800
Message-ID: <20160211234208.2202.66877.stgit@birch.djwong.org>
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
 common/rc         |   22 +++++++++++
 tests/xfs/233     |   73 ++++++++++++++++++++++++++++++++++++
 tests/xfs/233.out |    5 ++
 tests/xfs/234     |   88 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/234.out |    6 +++
 tests/xfs/235     |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/235.out |   14 +++++++
 tests/xfs/236     |   88 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/236.out |    7 +++
 tests/xfs/group   |    4 ++
 10 files changed, 415 insertions(+)
 create mode 100755 tests/xfs/233
 create mode 100644 tests/xfs/233.out
 create mode 100755 tests/xfs/234
 create mode 100644 tests/xfs/234.out
 create mode 100755 tests/xfs/235
 create mode 100644 tests/xfs/235.out
 create mode 100755 tests/xfs/236
 create mode 100644 tests/xfs/236.out


diff --git a/common/rc b/common/rc
index e05df74..7e83d6e 100644
--- a/common/rc
+++ b/common/rc
@@ -3053,6 +3053,28 @@ _require_test_lsattr()
 		_notrun "lsattr not supported by test filesystem type: $FSTYP"
 }
 
+_require_xfs_test_rmapbt()
+{
+	_require_test
+
+	if [ "$(xfs_info "$TEST_DIR" | grep -c "rmapbt=1")" -ne 1 ]; then
+		_notrun "rmapbt not supported by test filesystem type: $FSTYP"
+	fi
+}
+
+_require_xfs_scratch_rmapbt()
+{
+	_require_scratch
+
+	_scratch_mkfs > /dev/null
+	_scratch_mount
+	if [ "$(xfs_info "$SCRATCH_MNT" | grep -c "rmapbt=1")" -ne 1 ]; then
+		_scratch_unmount
+		_notrun "rmapbt not supported by scratch filesystem type: $FSTYP"
+	fi
+	_scratch_unmount
+}
+
 _get_total_inode()
 {
 	if [ -z "$1" ]; then
diff --git a/tests/xfs/233 b/tests/xfs/233
new file mode 100755
index 0000000..f821004
--- /dev/null
+++ b/tests/xfs/233
@@ -0,0 +1,73 @@
+#! /bin/bash
+# FS QA Test No. 233
+#
+# Tests xfs_growfs on a rmapbt filesystem
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
+#
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
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/xfs
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+
+echo "Format and mount"
+_scratch_mkfs_sized $((2 * 4096 * 4096)) > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+blksz="$(stat -f $testdir -c '%S')"
+_pwrite_byte 0x61 0 $((blksz * 14 + 71)) $testdir/original >> $seqres.full
+cp -p $testdir/original $testdir/copy1
+cp -p $testdir/copy1 $testdir/copy2
+
+echo "Grow fs"
+$XFS_GROWFS_PROG $SCRATCH_MNT 2>&1 |  _filter_growfs >> $seqres.full
+_scratch_remount
+
+echo "Create more copies"
+cp -p $testdir/original $testdir/copy3
+
+xfs_info $SCRATCH_MNT >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/233.out b/tests/xfs/233.out
new file mode 100644
index 0000000..4a4fc3a
--- /dev/null
+++ b/tests/xfs/233.out
@@ -0,0 +1,5 @@
+QA output created by 233
+Format and mount
+Create the original files
+Grow fs
+Create more copies
diff --git a/tests/xfs/234 b/tests/xfs/234
new file mode 100755
index 0000000..649cb7e
--- /dev/null
+++ b/tests/xfs/234
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 234
+#
+# Ensure that we can create enough distinct rmap entries to force creation
+# of a multi-level rmap btree, and that metadump will successfully copy
+# said block.
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
+    rm -rf $tmp.* $metadump_file $TEST_DIR/image
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/xfs
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_loop
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fpunch"
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+metadump_file=$TEST_DIR/${seq}_metadump
+
+echo "Create the original file blocks"
+blksz="$(stat -f $testdir -c '%S')"
+nr_blks=$((4 * blksz / 12))
+_pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/file1 >> $seqres.full
+sync
+
+echo "Punch every other block"
+seq 1 2 $((nr_blks - 1)) | while read nr; do
+	$XFS_IO_PROG -c "fpunch $((nr * blksz)) $blksz" $testdir/file1 >> $seqres.full
+done
+
+echo "Create metadump file"
+_scratch_unmount
+_scratch_metadump $metadump_file
+
+# Now restore the obfuscated one back and take a look around
+echo "Restore metadump"
+xfs_mdrestore $metadump_file $TEST_DIR/image
+_mount -t $FSTYP $TEST_DIR/image $SCRATCH_MNT
+umount $SCRATCH_MNT
+
+echo "Check restored fs"
+_check_generic_filesystem $metadump_file
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/234.out b/tests/xfs/234.out
new file mode 100644
index 0000000..463d466
--- /dev/null
+++ b/tests/xfs/234.out
@@ -0,0 +1,6 @@
+QA output created by 234
+Create the original file blocks
+Punch every other block
+Create metadump file
+Restore metadump
+Check restored fs
diff --git a/tests/xfs/235 b/tests/xfs/235
new file mode 100755
index 0000000..5af72a6
--- /dev/null
+++ b/tests/xfs/235
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 235
+#
+# Create and populate an XFS filesystem, corrupt the rmap btree,
+# then see how the kernel and xfs_repair deal with it.
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
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-7031  USA
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
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/xfs
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+test -n ${FORCE_FUZZ} || _require_scratch_xfs_crc
+
+rm -f $seqres.full
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz=$(stat -f -c '%s' ${SCRATCH_MNT})
+agcount=$(xfs_info ${SCRATCH_MNT} | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')
+
+echo "+ make some files"
+_pwrite_byte 0x62 0 $((blksz * 64)) ${SCRATCH_MNT}/file0 >> $seqres.full
+_pwrite_byte 0x61 0 $((blksz * 64)) ${SCRATCH_MNT}/file1 >> $seqres.full
+cp -p ${SCRATCH_MNT}/file0 ${SCRATCH_MNT}/file2
+cp -p ${SCRATCH_MNT}/file1 ${SCRATCH_MNT}/file3
+umount ${SCRATCH_MNT}
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || \
+	_fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+seq 0 $((agcount - 1)) | while read ag; do
+	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr rmaproot" \
+		-c "stack" -c "blocktrash -x 4096 -y 4096 -z -n 8 -3" \
+		${SCRATCH_DEV} >> $seqres.full 2>&1
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ copy more"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 0 $((blksz * 64))" -c "fsync" ${SCRATCH_MNT}/file4 >> $seqres.full
+test -s ${SCRATCH_MNT}/file4 || _fail "should not be able to copy with busted rmap btree"
+umount ${SCRATCH_MNT}
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i ${SCRATCH_MNT}/
+
+echo "+ copy more (2)"
+cp -p ${SCRATCH_MNT}/file1 ${SCRATCH_MNT}/file5 || \
+	_fail "modified rmap tree"
+umount ${SCRATCH_MNT}
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || \
+	_fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/235.out b/tests/xfs/235.out
new file mode 100644
index 0000000..89a11d6
--- /dev/null
+++ b/tests/xfs/235.out
@@ -0,0 +1,14 @@
+QA output created by 235
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ copy more
+fsync: Structure needs cleaning
++ repair fs
++ mount image (2)
++ chattr -R -i
++ copy more (2)
++ check fs (2)
diff --git a/tests/xfs/236 b/tests/xfs/236
new file mode 100755
index 0000000..99e9a75
--- /dev/null
+++ b/tests/xfs/236
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 236
+#
+# Ensure that we can create enough distinct rmapbt entries to force creation
+# of a multi-level rmap btree.  Delete and recreate a few times to
+# exercise the rmap btree grow/shrink functions.
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
+. ./common/xfs
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fpunch"
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original file blocks"
+blksz="$(stat -f $testdir -c '%S')"
+nr_blks=$((8 * blksz / 12))
+
+for i in 1 2 x; do
+	_pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/file1 >> $seqres.full
+	_pwrite_byte 0x62 0 $((blksz * nr_blks)) $testdir/file2 >> $seqres.full
+	sync
+
+	echo "$i: Reflink every other block"
+	seq 1 2 $((nr_blks - 1)) | while read nr; do
+		$XFS_IO_PROG -c "fpunch $((nr * blksz)) $blksz" $testdir/file2 >> $seqres.full
+	done
+	umount $SCRATCH_MNT
+	_check_scratch_fs
+	_scratch_mount
+
+	test $i = "x" && break
+
+	echo "$i: Delete both files"
+	rm -rf $testdir/file1 $testdir/file2
+	umount $SCRATCH_MNT
+	_check_scratch_fs
+	_scratch_mount
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/236.out b/tests/xfs/236.out
new file mode 100644
index 0000000..272246d
--- /dev/null
+++ b/tests/xfs/236.out
@@ -0,0 +1,7 @@
+QA output created by 236
+Create the original file blocks
+1: Reflink every other block
+1: Delete both files
+2: Reflink every other block
+2: Delete both files
+x: Reflink every other block
diff --git a/tests/xfs/group b/tests/xfs/group
index de3c7d6..1d08065 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -230,6 +230,10 @@
 230 auto quick clone
 231 auto quick clone
 232 auto quick clone
+233 auto quick rmap
+234 auto quick rmap
+235 fuzzers rmap
+236 auto quick rmap
 238 auto quick metadata ioctl
 242 auto quick prealloc
 244 auto quota quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
