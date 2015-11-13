Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 01CC27F5E
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 15:38:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BA5F1304039
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:38:12 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id qcKm0ffJJHoXUTTh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:38:08 -0800 (PST)
Subject: [PATCH 09/12] xfs: test xfs-specific reflink pieces
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 13 Nov 2015 13:37:42 -0800
Message-ID: <20151113213742.31124.28249.stgit@birch.djwong.org>
In-Reply-To: <20151113213643.31124.80975.stgit@birch.djwong.org>
References: <20151113213643.31124.80975.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

Check that the various XFS tools still work properly on reflinked XFSes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/127     |   79 ++++++++++++++++++++++++++++
 tests/xfs/127.out |    6 ++
 tests/xfs/128     |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/128.out |   27 ++++++++++
 tests/xfs/129     |   87 +++++++++++++++++++++++++++++++
 tests/xfs/129.out |    6 ++
 tests/xfs/130     |  109 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/130.out |   13 +++++
 tests/xfs/131     |   76 +++++++++++++++++++++++++++
 tests/xfs/131.out |    6 ++
 tests/xfs/132     |  130 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/132.out |   32 +++++++++++
 tests/xfs/group   |    6 ++
 13 files changed, 726 insertions(+)
 create mode 100755 tests/xfs/127
 create mode 100644 tests/xfs/127.out
 create mode 100755 tests/xfs/128
 create mode 100644 tests/xfs/128.out
 create mode 100755 tests/xfs/129
 create mode 100644 tests/xfs/129.out
 create mode 100755 tests/xfs/130
 create mode 100644 tests/xfs/130.out
 create mode 100755 tests/xfs/131
 create mode 100644 tests/xfs/131.out
 create mode 100755 tests/xfs/132
 create mode 100644 tests/xfs/132.out


diff --git a/tests/xfs/127 b/tests/xfs/127
new file mode 100755
index 0000000..61301de
--- /dev/null
+++ b/tests/xfs/127
@@ -0,0 +1,79 @@
+#! /bin/bash
+# FS QA Test No. 127
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -f "$tmp".*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+
+echo "Format and mount"
+_scratch_mkfs -d size=$((2 * 4096 * 4096)) -l size=4194304 > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original file and reflink to copy1, copy2"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+_pwrite_byte 0x61 0 $((BLKSZ * 14 + 71)) "$TESTDIR/original" >> "$seqres.full"
+_cp_reflink "$TESTDIR/original" "$TESTDIR/copy1"
+_cp_reflink "$TESTDIR/copy1" "$TESTDIR/copy2"
+
+echo "Grow fs"
+"$XFS_GROWFS_PROG" "$SCRATCH_MNT" 2>&1 |  _filter_growfs >> "$seqres.full"
+_scratch_remount
+
+echo "Create more reflink copies"
+_cp_reflink "$TESTDIR/original" "$TESTDIR/copy3"
+
+xfs_info "$SCRATCH_MNT" >> "$seqres.full"
+
+echo "Check scratch fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/127.out b/tests/xfs/127.out
new file mode 100644
index 0000000..e4e76e2
--- /dev/null
+++ b/tests/xfs/127.out
@@ -0,0 +1,6 @@
+QA output created by 127
+Format and mount
+Create the original file and reflink to copy1, copy2
+Grow fs
+Create more reflink copies
+Check scratch fs
diff --git a/tests/xfs/128 b/tests/xfs/128
new file mode 100755
index 0000000..49652cb
--- /dev/null
+++ b/tests/xfs/128
@@ -0,0 +1,149 @@
+#! /bin/bash
+# FS QA Test No. 128
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -f "$tmp".*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_test_lsattr
+_require_scratch_reflink
+_require_cp_reflink
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Create the original file and reflink to file2, file3"
+BLKS=2000
+MARGIN=100
+BLKSZ=65536
+REAL_BLKSZ="$(stat -f $TESTDIR -c '%S')"
+BLKSZ_FACTOR=$((BLKSZ / REAL_BLKSZ))
+_pwrite_byte 0x61 0 $((BLKS * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_cp_reflink "$TESTDIR/file2" "$TESTDIR/file3"
+_cp_reflink "$TESTDIR/file3" "$TESTDIR/file4"
+_test_remount
+FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file4" | _filter_scratch
+
+C01=$(_md5_checksum "$TESTDIR/file1")
+C02=$(_md5_checksum "$TESTDIR/file2")
+C03=$(_md5_checksum "$TESTDIR/file3")
+C04=$(_md5_checksum "$TESTDIR/file4")
+
+echo "CoW the reflink copies"
+_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x63 $(( BLKSZ * (BLKS - 1) )) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
+_test_remount
+FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file4" | _filter_scratch
+
+C11=$(_md5_checksum "$TESTDIR/file1")
+C12=$(_md5_checksum "$TESTDIR/file2")
+C13=$(_md5_checksum "$TESTDIR/file3")
+C14=$(_md5_checksum "$TESTDIR/file4")
+
+echo "Defragment"
+lsattr -l "$TESTDIR/" | _filter_scratch
+xfs_fsr -v -d "$TESTDIR/file1" >> "$seqres.full"
+xfs_fsr -v -d "$TESTDIR/file2" >> "$seqres.full" # fsr probably breaks the link
+xfs_fsr -v -d "$TESTDIR/file3" >> "$seqres.full" # fsr probably breaks the link
+xfs_fsr -v -d "$TESTDIR/file4" >> "$seqres.full" # fsr probably ignores this file
+_test_remount
+FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
+
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file3" | _filter_scratch
+md5sum "$TESTDIR/file4" | _filter_scratch
+
+C21=$(_md5_checksum "$TESTDIR/file1")
+C22=$(_md5_checksum "$TESTDIR/file2")
+C23=$(_md5_checksum "$TESTDIR/file3")
+C24=$(_md5_checksum "$TESTDIR/file4")
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
+_within_tolerance "free blocks after creating some reflink copies" $FREE_BLOCKS1 $((FREE_BLOCKS0 - (BLKS * BLKSZ_FACTOR) )) $MARGIN -v
+_within_tolerance "free blocks after CoW some reflink copies" $FREE_BLOCKS2 $((FREE_BLOCKS1 - 2)) $MARGIN -v
+_within_tolerance "free blocks after defragging all reflink copies" $FREE_BLOCKS3 $((FREE_BLOCKS2 - (BLKS * 2 * BLKSZ_FACTOR))) $MARGIN -v
+_within_tolerance "free blocks after all tests" $FREE_BLOCKS3 $((FREE_BLOCKS0 - (BLKS * 3 * BLKSZ_FACTOR))) $MARGIN -v
+
+echo "Check scratch fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/128.out b/tests/xfs/128.out
new file mode 100644
index 0000000..7e72dcd
--- /dev/null
+++ b/tests/xfs/128.out
@@ -0,0 +1,27 @@
+QA output created by 128
+Format and mount
+Create the original file and reflink to file2, file3
+b81534f439aac5c34ce3ed60a03eba70  SCRATCH_MNT/test-128/file1
+b81534f439aac5c34ce3ed60a03eba70  SCRATCH_MNT/test-128/file2
+b81534f439aac5c34ce3ed60a03eba70  SCRATCH_MNT/test-128/file3
+b81534f439aac5c34ce3ed60a03eba70  SCRATCH_MNT/test-128/file4
+CoW the reflink copies
+b81534f439aac5c34ce3ed60a03eba70  SCRATCH_MNT/test-128/file1
+c650f1cf6c9f07b22e3e21ec7d49ded5  SCRATCH_MNT/test-128/file2
+56ed2f712c91e035adeeb26ed105a982  SCRATCH_MNT/test-128/file3
+b81534f439aac5c34ce3ed60a03eba70  SCRATCH_MNT/test-128/file4
+Defragment
+SCRATCH_MNT/test-128/file1          ---
+SCRATCH_MNT/test-128/file2          ---
+SCRATCH_MNT/test-128/file3          ---
+SCRATCH_MNT/test-128/file4          ---
+b81534f439aac5c34ce3ed60a03eba70  SCRATCH_MNT/test-128/file1
+c650f1cf6c9f07b22e3e21ec7d49ded5  SCRATCH_MNT/test-128/file2
+56ed2f712c91e035adeeb26ed105a982  SCRATCH_MNT/test-128/file3
+b81534f439aac5c34ce3ed60a03eba70  SCRATCH_MNT/test-128/file4
+Check files
+free blocks after creating some reflink copies is in range
+free blocks after CoW some reflink copies is in range
+free blocks after defragging all reflink copies is in range
+free blocks after all tests is in range
+Check scratch fs
diff --git a/tests/xfs/129 b/tests/xfs/129
new file mode 100755
index 0000000..6279d69
--- /dev/null
+++ b/tests/xfs/129
@@ -0,0 +1,87 @@
+#! /bin/bash
+# FS QA Test No. 129
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
+seq=`basename "$0"`
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
+    umount "$SCRATCH_MNT" > /dev/null 2>&1
+    rm -rf "$tmp".* "$TESTDIR" "$METADUMP_FILE"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+
+rm -f "$seqres.full"
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+METADUMP_FILE="$TEST_DIR/${seq}_metadump"
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+NR_BLKS=$((4 * BLKSZ / 12))
+_pwrite_byte 0x61 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/file1" >> "$seqres.full"
+
+echo "Reflink every other block"
+seq 1 $((NR_BLKS / 2)) | while read nr; do
+	_reflink_range  "$TESTDIR/file1" $((nr * 2 * BLKSZ)) \
+			"$TESTDIR/file2" $((nr * 2 * BLKSZ)) $BLKSZ >> "$seqres.full"
+done
+
+echo "Create metadump file"
+_scratch_unmount
+_scratch_metadump "$METADUMP_FILE"
+
+# Now restore the obfuscated one back and take a look around
+echo "Restore metadump"
+xfs_mdrestore "$METADUMP_FILE" "$TEST_DIR/image"
+_mount -t $FSTYP "$TEST_DIR/image" "$SCRATCH_MNT"
+umount "$SCRATCH_MNT"
+
+echo "Check restored fs"
+_check_generic_filesystem "$METADUMP_FILE"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/129.out b/tests/xfs/129.out
new file mode 100644
index 0000000..da6f43f
--- /dev/null
+++ b/tests/xfs/129.out
@@ -0,0 +1,6 @@
+QA output created by 129
+Create the original file blocks
+Reflink every other block
+Create metadump file
+Restore metadump
+Check restored fs
diff --git a/tests/xfs/130 b/tests/xfs/130
new file mode 100755
index 0000000..b64ea8c
--- /dev/null
+++ b/tests/xfs/130
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. 130
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
+
+rm -f "$seqres.full"
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
+_pwrite_byte 0x62 0 $((blksz * 64)) "${SCRATCH_MNT}/file0" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 64)) "${SCRATCH_MNT}/file1" >> "$seqres.full"
+_cp_reflink "${SCRATCH_MNT}/file0" "${SCRATCH_MNT}/file2"
+_cp_reflink "${SCRATCH_MNT}/file1" "${SCRATCH_MNT}/file3"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> "$seqres.full" 2>&1 || \
+	_fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+seq 0 $((agcount - 1)) | while read ag; do
+	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr refcntroot" \
+		-c "stack" -c "blocktrash -x 4096 -y 4096 -z -n 8 -3" \
+		"${SCRATCH_DEV}" >> "$seqres.full" 2>&1
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ reflink more"
+_cp_reflink "${SCRATCH_MNT}/file1" "${SCRATCH_MNT}/file4" 2> /dev/null && \
+	_fail "should not be able to reflink with busted refcount btree"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> "$seqres.full" 2>&1
+_scratch_xfs_repair >> "$seqres.full" 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ reflink more (2)"
+_cp_reflink "${SCRATCH_MNT}/file1" "${SCRATCH_MNT}/file5" || \
+	_fail "modified refcount tree"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> "$seqres.full" 2>&1 || \
+	_fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/130.out b/tests/xfs/130.out
new file mode 100644
index 0000000..58d153b
--- /dev/null
+++ b/tests/xfs/130.out
@@ -0,0 +1,13 @@
+QA output created by 130
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
diff --git a/tests/xfs/131 b/tests/xfs/131
new file mode 100755
index 0000000..5d092f1
--- /dev/null
+++ b/tests/xfs/131
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test No. 131
+#
+# Ensure that we can't reflink realtime files.
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
+seq=`basename "$0"`
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
+    umount "$SCRATCH_MNT" > /dev/null 2>&1
+    rm -rf "$tmp".* "$TESTDIR" "$METADUMP_FILE"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_realtime
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount scratch device"
+_scratch_mkfs >> "$seqres.full"
+_scratch_mount
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original file blocks"
+BLKSZ=65536
+$XFS_IO_PROG -R -f -c "truncate $BLKSZ" "$TESTDIR/file1"
+
+echo "Reflink every block"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" 2>&1 | _filter_scratch
+
+test -s "$TESTDIR/file2" && _fail "Should not be able to reflink a realtime file."
+
+echo "Check restored fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/131.out b/tests/xfs/131.out
new file mode 100644
index 0000000..7b700c9
--- /dev/null
+++ b/tests/xfs/131.out
@@ -0,0 +1,6 @@
+QA output created by 131
+Format and mount scratch device
+Create the original file blocks
+Reflink every block
+cp: failed to clone 'SCRATCH_MNT/test-131/file2' from 'SCRATCH_MNT/test-131/file1': Invalid argument
+Check restored fs
diff --git a/tests/xfs/132 b/tests/xfs/132
new file mode 100755
index 0000000..ec7b178
--- /dev/null
+++ b/tests/xfs/132
@@ -0,0 +1,130 @@
+#! /bin/bash
+# FS QA Test No. 132
+#
+# Ensure that fallocate on reflinked files actually CoWs the shared blocks.
+#   - Record fs block usage (0)
+#   - Create a file and some reflink copies
+#   - Record fs block usage (1)
+#   - funshare half of one of the copies
+#   - Record fs block usage (2)
+#   - funshare all of the copies
+#   - Record fs block usage (3)
+#   - rewrite the original file
+#   - Record fs block usage (4)
+#   - Compare fs block usage of 0-4 to ensure that block usage behaves as
+#     we expect.
+#   - Compare the status of the inode reflink flag at each step.
+#
+# "funshare" refers to fallocate copy-on-writing the shared blocks
+#
+# This is the same test as generic/156 except that we also check the inode
+# reflink flag.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_reflink
+_require_test_lsattr
+_require_cp_reflink
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+BLKS=2000
+MARGIN=100
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
+NR=4
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_test_remount
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+done
+_test_remount
+FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+lsattr -l $TESTDIR/ | _filter_test_dir
+
+echo "funshare part of a file"
+"$XFS_IO_PROG" -f -c "falloc 0 $((SZ / 2))" "$TESTDIR/file2"
+_test_remount
+lsattr -l $TESTDIR/ | _filter_test_dir
+
+echo "funshare some of the copies"
+"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file3"
+_test_remount
+FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+lsattr -l $TESTDIR/ | _filter_test_dir
+
+echo "funshare the rest of the files"
+"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file4"
+"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file1"
+_test_remount
+FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
+lsattr -l $TESTDIR/ | _filter_test_dir
+
+echo "Rewrite the original file"
+_pwrite_byte 0x65 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_test_remount
+FREE_BLOCKS4=$(stat -f "$TESTDIR" -c '%f')
+lsattr -l $TESTDIR/ | _filter_test_dir
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3 $FREE_BLOCKS4
+
+_within_tolerance "free blocks after reflinking" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+
+_within_tolerance "free blocks after nocow'ing some copies" $FREE_BLOCKS2 $((FREE_BLOCKS1 - (2 * BLKS))) $MARGIN -v
+
+_within_tolerance "free blocks after nocow'ing all copies" $FREE_BLOCKS3 $((FREE_BLOCKS2 - BLKS)) $MARGIN -v
+
+_within_tolerance "free blocks after overwriting original" $FREE_BLOCKS4 $FREE_BLOCKS3 $MARGIN -v
+
+_within_tolerance "free blocks after all tests" $FREE_BLOCKS4 $((FREE_BLOCKS0 - (4 * BLKS))) $MARGIN -v
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/132.out b/tests/xfs/132.out
new file mode 100644
index 0000000..fd2b7bd
--- /dev/null
+++ b/tests/xfs/132.out
@@ -0,0 +1,32 @@
+QA output created by 132
+Create the original file blocks
+Create the reflink copies
+TEST_DIR/test-132/file1          ---
+TEST_DIR/test-132/file2          ---
+TEST_DIR/test-132/file3          ---
+TEST_DIR/test-132/file4          ---
+funshare part of a file
+TEST_DIR/test-132/file1          ---
+TEST_DIR/test-132/file2          ---
+TEST_DIR/test-132/file3          ---
+TEST_DIR/test-132/file4          ---
+funshare some of the copies
+TEST_DIR/test-132/file1          ---
+TEST_DIR/test-132/file2          No_COW
+TEST_DIR/test-132/file3          No_COW
+TEST_DIR/test-132/file4          ---
+funshare the rest of the files
+TEST_DIR/test-132/file1          No_COW
+TEST_DIR/test-132/file2          No_COW
+TEST_DIR/test-132/file3          No_COW
+TEST_DIR/test-132/file4          No_COW
+Rewrite the original file
+TEST_DIR/test-132/file1          No_COW
+TEST_DIR/test-132/file2          No_COW
+TEST_DIR/test-132/file3          No_COW
+TEST_DIR/test-132/file4          No_COW
+free blocks after reflinking is in range
+free blocks after nocow'ing some copies is in range
+free blocks after nocow'ing all copies is in range
+free blocks after overwriting original is in range
+free blocks after all tests is in range
diff --git a/tests/xfs/group b/tests/xfs/group
index 8261f86..9884329 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -124,6 +124,12 @@
 124 fuzzers
 125 fuzzers
 126 fuzzers
+127 auto quick clone
+128 auto quick clone
+129 auto quick clone
+130 fuzzers
+131 auto quick clone
+132 auto quick clone
 134 quota auto quick
 136 attr2
 142 dmapi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
