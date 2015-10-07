Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8931B29F3A
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:14:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25790AC005
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:14:21 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id xg0M6nQq7AeTQHOF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:14:18 -0700 (PDT)
Subject: [PATCH 10/12] xfs: test xfs-specific reflink pieces
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:14:11 -0700
Message-ID: <20151007051411.3260.97743.stgit@birch.djwong.org>
In-Reply-To: <20151007051257.3260.73072.stgit@birch.djwong.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Check that growfs and xfs_fsr still work properly on reflinked fses.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/800     |   77 +++++++++++++++++++++++++++++++
 tests/xfs/800.out |    5 ++
 tests/xfs/801     |  133 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/801.out |   15 ++++++
 tests/xfs/802     |   89 +++++++++++++++++++++++++++++++++++
 tests/xfs/802.out |    6 ++
 tests/xfs/803     |  104 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/803.out |   13 +++++
 tests/xfs/group   |    4 ++
 9 files changed, 446 insertions(+)
 create mode 100755 tests/xfs/800
 create mode 100644 tests/xfs/800.out
 create mode 100755 tests/xfs/801
 create mode 100644 tests/xfs/801.out
 create mode 100755 tests/xfs/802
 create mode 100644 tests/xfs/802.out
 create mode 100755 tests/xfs/803
 create mode 100644 tests/xfs/803.out


diff --git a/tests/xfs/800 b/tests/xfs/800
new file mode 100755
index 0000000..58059f7
--- /dev/null
+++ b/tests/xfs/800
@@ -0,0 +1,77 @@
+#! /bin/bash
+# FS QA Test No. 800
+#
+# Tests xfs_growfs on a reflinked filesystem
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+. common/rc
+. common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_scratch_reflink
+_supported_os Linux
+
+_require_cp_reflink
+
+echo "Format and mount"
+_scratch_mkfs -d size=$((2 * 4096 * 4096)) -l size=4194304 > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file and reflink to copy1, copy2"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * 14 + 71))" $TESTDIR/original \
+    >> $seqres.full 2>&1
+cp --reflink=always $TESTDIR/original $TESTDIR/copy1
+cp --reflink=always $TESTDIR/copy1 $TESTDIR/copy2
+
+echo "Grow fs"
+$XFS_GROWFS_PROG $SCRATCH_MNT 2>&1 |  _filter_growfs >> $seqres.full
+
+xfs_info $SCRATCH_MNT >> $seqres.full
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/800.out b/tests/xfs/800.out
new file mode 100644
index 0000000..280daa5
--- /dev/null
+++ b/tests/xfs/800.out
@@ -0,0 +1,5 @@
+QA output created by 800
+Format and mount
+Create the original file and reflink to copy1, copy2
+Grow fs
+Check scratch fs
diff --git a/tests/xfs/801 b/tests/xfs/801
new file mode 100755
index 0000000..96a47e4
--- /dev/null
+++ b/tests/xfs/801
@@ -0,0 +1,133 @@
+#! /bin/bash
+# FS QA Test No. 801
+#
+# Ensure that xfs_fsr un-reflinks files while defragmenting
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+. common/rc
+. common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_scratch
+_require_scratch_reflink
+_supported_os Linux
+
+_require_cp_reflink
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+FREE_BLOCKS0=$(stat -f $TESTDIR -c '%f')
+
+echo "Create the original file and reflink to file2, file3"
+BLKS=2000
+MARGIN=100
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKS * BLKSZ))" $TESTDIR/file1 \
+    >> $seqres.full 2>&1
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file2
+cp --reflink=always $TESTDIR/file2 $TESTDIR/file3
+cp --reflink=always $TESTDIR/file3 $TESTDIR/file4
+_test_remount
+FREE_BLOCKS1=$(stat -f $TESTDIR -c '%f')
+
+C01=$(_md5_checksum $TESTDIR/file1)
+C02=$(_md5_checksum $TESTDIR/file2)
+C03=$(_md5_checksum $TESTDIR/file3)
+C04=$(_md5_checksum $TESTDIR/file4)
+
+echo "CoW the reflink copies"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ $BLKSZ" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $(( BLKSZ * (BLKS - 1) )) $BLKSZ" $TESTDIR/file3 >> $seqres.full
+_test_remount
+FREE_BLOCKS2=$(stat -f $TESTDIR -c '%f')
+
+C11=$(_md5_checksum $TESTDIR/file1)
+C12=$(_md5_checksum $TESTDIR/file2)
+C13=$(_md5_checksum $TESTDIR/file3)
+C14=$(_md5_checksum $TESTDIR/file4)
+
+echo "Defragment"
+lsattr -l $TESTDIR/ | sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
+xfs_fsr -v -d $TESTDIR/file1 >> $seqres.full
+xfs_fsr -v -d $TESTDIR/file2 >> $seqres.full # fsr probably breaks the link
+xfs_fsr -v -d $TESTDIR/file3 >> $seqres.full # fsr probably breaks the link
+xfs_fsr -v -d $TESTDIR/file4 >> $seqres.full # fsr probably ignores this file
+_test_remount
+FREE_BLOCKS3=$(stat -f $TESTDIR -c '%f')
+
+C21=$(_md5_checksum $TESTDIR/file1)
+C22=$(_md5_checksum $TESTDIR/file2)
+C23=$(_md5_checksum $TESTDIR/file3)
+C24=$(_md5_checksum $TESTDIR/file4)
+
+echo "Check files"
+test $C01 = $C02 || echo "Files 1-2 do not match"
+test $C01 = $C03 || echo "Files 1-3 do not match"
+test $C01 = $C04 || echo "Files 1-4 do not match"
+test $C02 = $C03 || echo "Files 2-3 do not match"
+test $C02 = $C04 || echo "Files 2-4 do not match"
+test $C03 = $C04 || echo "Files 3-4 do not match"
+
+test $C01 = $C11 || echo "File1 should not be different after CoW"
+test $C02 != $C12 || echo "File2 should be different after CoW"
+test $C03 != $C13 || echo "File3 should be different after CoW"
+test $C04 = $C14 || echo "File4 should not be different after CoW"
+
+test $C11 = $C21 || echo "File1 changed by defrag"
+test $C12 = $C22 || echo "File2 changed by defrag"
+test $C13 = $C23 || echo "File3 changed by defrag"
+test $C14 = $C24 || echo "File4 changed by defrag"
+
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3
+
+_within_tolerance "free blocks after creating some reflink copies" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+_within_tolerance "free blocks after CoW some reflink copies" $FREE_BLOCKS2 $((FREE_BLOCKS1 - 2)) $MARGIN -v
+_within_tolerance "free blocks after defragging all reflink copies" $FREE_BLOCKS3 $((FREE_BLOCKS2 - (BLKS * 2))) $MARGIN -v
+_within_tolerance "free blocks after all tests" $FREE_BLOCKS3 $((FREE_BLOCKS0 - (BLKS * 3))) $MARGIN -v
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/801.out b/tests/xfs/801.out
new file mode 100644
index 0000000..9e5f4ca
--- /dev/null
+++ b/tests/xfs/801.out
@@ -0,0 +1,15 @@
+QA output created by 801
+Format and mount
+Create the original file and reflink to file2, file3
+CoW the reflink copies
+Defragment
+SCRATCH_MNT/test-801/file1          ---
+SCRATCH_MNT/test-801/file2          ---
+SCRATCH_MNT/test-801/file3          ---
+SCRATCH_MNT/test-801/file4          ---
+Check files
+free blocks after creating some reflink copies is in range
+free blocks after CoW some reflink copies is in range
+free blocks after defragging all reflink copies is in range
+free blocks after all tests is in range
+Check scratch fs
diff --git a/tests/xfs/802 b/tests/xfs/802
new file mode 100755
index 0000000..05c5004
--- /dev/null
+++ b/tests/xfs/802
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 802
+#
+# Ensure that we can create enough distinct reflink entries to force creation
+# of a multi-level refcount btree, and that metadump will successfully copy
+# said block.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+    rm -rf $tmp.* $TESTDIR $METADUMP_FILE
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_require_test
+_require_scratch
+_require_scratch_reflink
+_supported_os Linux
+
+_require_xfs_io_command "reflink"
+
+rm -f $seqres.full
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+METADUMP_FILE="${TEST_DIR}/${seq}_metadump"
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+NR_BLKS=$((4 * BLKSZ / 12))
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * NR_BLKS))" $TESTDIR/file1 >> $seqres.full
+
+echo "Reflink every other block"
+touch $TESTDIR/file2
+seq 1 $((NR_BLKS / 2)) | while read nr; do
+	$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $((nr * 2 * BLKSZ)) $((nr * 2 * BLKSZ)) $BLKSZ" $TESTDIR/file2 >> $seqres.full
+done
+
+echo "Create metadump file"
+_scratch_unmount
+_scratch_metadump $METADUMP_FILE
+
+# Now restore the obfuscated one back and take a look around
+echo "Restore metadump"
+xfs_mdrestore "${METADUMP_FILE}" "${SCRATCH_DEV}"
+_scratch_mount
+_scratch_unmount
+
+echo "Check restored fs"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/802.out b/tests/xfs/802.out
new file mode 100644
index 0000000..ad2ef03
--- /dev/null
+++ b/tests/xfs/802.out
@@ -0,0 +1,6 @@
+QA output created by 802
+Create the original file blocks
+Reflink every other block
+Create metadump file
+Restore metadump
+Check restored fs
diff --git a/tests/xfs/803 b/tests/xfs/803
new file mode 100755
index 0000000..62a9246
--- /dev/null
+++ b/tests/xfs/803
@@ -0,0 +1,104 @@
+#! /bin/bash
+# FS QA Test No. 803
+#
+# Create and populate an XFS filesystem, corrupt the refcount btree,
+# then see how the kernel and xfs_repair deal with it.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+    cd /
+    #rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_scratch_reflink
+test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
+_require_attrs
+
+rm -f $seqres.full
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+
+echo "+ make some files"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * 64))" "${SCRATCH_MNT}/file0" >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((blksz * 64))" "${SCRATCH_MNT}/file1" >> $seqres.full
+cp --reflink=always "${SCRATCH_MNT}/file0" "${SCRATCH_MNT}/file2"
+cp --reflink=always "${SCRATCH_MNT}/file1" "${SCRATCH_MNT}/file3"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+for ag in $(seq 1 $((agcount - 1))) 0; do
+	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr refcntroot" -c "stack" -c "blocktrash -x 4096 -y 4096 -z -n 8 -3" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ reflink more"
+cp --reflink=always "${SCRATCH_MNT}/file1" "${SCRATCH_MNT}/file4" 2> /dev/null && _fail "should not be able to reflink with busted refcount btree"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ reflink more (2)"
+cp --reflink=always "${SCRATCH_MNT}/file1" "${SCRATCH_MNT}/file5" || _fail "modified refcount tree"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/803.out b/tests/xfs/803.out
new file mode 100644
index 0000000..582682d
--- /dev/null
+++ b/tests/xfs/803.out
@@ -0,0 +1,13 @@
+QA output created by 803
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ reflink more
++ repair fs
++ mount image (2)
++ chattr -R -i
++ reflink more (2)
++ check fs (2)
diff --git a/tests/xfs/group b/tests/xfs/group
index 8261f86..cbbd810 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -220,3 +220,7 @@
 303 auto quick quota
 304 auto quick quota
 305 auto quota
+800 auto quick clone
+801 auto quick clone
+802 auto quick clone
+803 fuzzers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
