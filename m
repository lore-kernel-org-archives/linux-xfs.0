Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 095D77CA4
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 19:13:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B4FAC8F804C
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 17:13:46 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id XcrbigL8nNojMydt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 17:13:40 -0800 (PST)
Subject: [PATCH 17/23] reflink: test CoW across a mixed range of block types
	with cowextsize set
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 08 Feb 2016 17:13:35 -0800
Message-ID: <20160209011335.23099.47260.stgit@birch.djwong.org>
In-Reply-To: <20160209011145.23099.95354.stgit@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
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
 tests/xfs/215     |  108 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/215.out |   14 +++++
 tests/xfs/218     |  108 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/218.out |   14 +++++
 tests/xfs/219     |  108 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/219.out |   14 +++++
 tests/xfs/221     |  108 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/221.out |   14 +++++
 tests/xfs/223     |  113 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/223.out |   14 +++++
 tests/xfs/224     |  113 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/224.out |   14 +++++
 tests/xfs/225     |  108 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/225.out |   14 +++++
 tests/xfs/226     |  108 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/226.out |   14 +++++
 tests/xfs/228     |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/228.out |   14 +++++
 tests/xfs/230     |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/230.out |   14 +++++
 tests/xfs/group   |   10 ++++
 21 files changed, 1298 insertions(+)
 create mode 100755 tests/xfs/215
 create mode 100644 tests/xfs/215.out
 create mode 100755 tests/xfs/218
 create mode 100644 tests/xfs/218.out
 create mode 100755 tests/xfs/219
 create mode 100644 tests/xfs/219.out
 create mode 100755 tests/xfs/221
 create mode 100644 tests/xfs/221.out
 create mode 100755 tests/xfs/223
 create mode 100644 tests/xfs/223.out
 create mode 100755 tests/xfs/224
 create mode 100644 tests/xfs/224.out
 create mode 100755 tests/xfs/225
 create mode 100644 tests/xfs/225.out
 create mode 100755 tests/xfs/226
 create mode 100644 tests/xfs/226.out
 create mode 100755 tests/xfs/228
 create mode 100644 tests/xfs/228.out
 create mode 100755 tests/xfs/230
 create mode 100644 tests/xfs/230.out


diff --git a/tests/xfs/215 b/tests/xfs/215
new file mode 100755
index 0000000..8dd5cb5
--- /dev/null
+++ b/tests/xfs/215
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 215
+#
+# Ensuring that copy on write in direct-io mode works when the CoW
+# range originally covers multiple extents, some unwritten, some not.
+#   - Set cowextsize hint.
+#   - Create a file and fallocate a second file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - directio CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
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
+    rm -rf "$tmp".*
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
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+real_blksz=$(stat -f -c '%S' "$testdir")
+internal_blks=$((blksz * nr / real_blksz))
+"$XFS_IO_PROG" -c "cowextsize $((blksz * 16))" "$testdir" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file3")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || _fail "file3 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/215.out b/tests/xfs/215.out
new file mode 100644
index 0000000..5412722
--- /dev/null
+++ b/tests/xfs/215.out
@@ -0,0 +1,14 @@
+QA output created by 215
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-215/file1
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-215/file3
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-215/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-215/file1
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-215/file3
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-215/file3.chk
+Check extent counts
+Check for damage
diff --git a/tests/xfs/218 b/tests/xfs/218
new file mode 100755
index 0000000..fb61652
--- /dev/null
+++ b/tests/xfs/218
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 218
+#
+# Ensuring that copy on write in buffered mode works when the CoW
+# range originally covers multiple extents, some unwritten, some not.
+#   - Set cowextsize hint.
+#   - Create a file and fallocate a second file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
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
+    rm -rf "$tmp".*
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
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+real_blksz=$(stat -f -c '%S' "$testdir")
+internal_blks=$((blksz * nr / real_blksz))
+"$XFS_IO_PROG" -c "cowextsize $((blksz * 16))" "$testdir" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "CoW across the transition"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file3")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || _fail "file3 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/218.out b/tests/xfs/218.out
new file mode 100644
index 0000000..4b70fb9
--- /dev/null
+++ b/tests/xfs/218.out
@@ -0,0 +1,14 @@
+QA output created by 218
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-218/file1
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-218/file3
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-218/file3.chk
+CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-218/file1
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-218/file3
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-218/file3.chk
+Check extent counts
+Check for damage
diff --git a/tests/xfs/219 b/tests/xfs/219
new file mode 100755
index 0000000..df3a3b4
--- /dev/null
+++ b/tests/xfs/219
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 219
+#
+# Ensuring that copy on write in direct-io mode works when the CoW
+# range originally covers multiple extents, some holes, some not.
+#   - Set cowextsize hint.
+#   - Create a file and truncate a second file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - directio CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
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
+    rm -rf "$tmp".*
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
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+real_blksz=$(stat -f -c '%S' "$testdir")
+internal_blks=$((blksz * nr / real_blksz))
+"$XFS_IO_PROG" -c "cowextsize $((blksz * 16))" "$testdir" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file3")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || _fail "file3 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/219.out b/tests/xfs/219.out
new file mode 100644
index 0000000..b6fc64b
--- /dev/null
+++ b/tests/xfs/219.out
@@ -0,0 +1,14 @@
+QA output created by 219
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-219/file1
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-219/file3
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-219/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-219/file1
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-219/file3
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-219/file3.chk
+Check extent counts
+Check for damage
diff --git a/tests/xfs/221 b/tests/xfs/221
new file mode 100755
index 0000000..298ecdf
--- /dev/null
+++ b/tests/xfs/221
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 221
+#
+# Ensuring that copy on write in buffered mode works when the CoW
+# range originally covers multiple extents, some holes, some not.
+#   - Set cowextsize hint.
+#   - Create a file and truncate a second file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
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
+    rm -rf "$tmp".*
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
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+real_blksz=$(stat -f -c '%S' "$testdir")
+internal_blks=$((blksz * nr / real_blksz))
+"$XFS_IO_PROG" -c "cowextsize $((blksz * 16))" "$testdir" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "CoW across the transition"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file3")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || _fail "file3 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/221.out b/tests/xfs/221.out
new file mode 100644
index 0000000..09ece61
--- /dev/null
+++ b/tests/xfs/221.out
@@ -0,0 +1,14 @@
+QA output created by 221
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-221/file1
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-221/file3
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-221/file3.chk
+CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-221/file1
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-221/file3
+09101629908f9bdd5d178e7ce20bb1bb  SCRATCH_MNT/test-221/file3.chk
+Check extent counts
+Check for damage
diff --git a/tests/xfs/223 b/tests/xfs/223
new file mode 100755
index 0000000..c9903c6
--- /dev/null
+++ b/tests/xfs/223
@@ -0,0 +1,113 @@
+#! /bin/bash
+# FS QA Test No. 223
+#
+# Ensuring that copy on write in direct-io mode works when the CoW
+# range originally covers multiple extents, some delalloc, some not.
+#   - Set cowextsize hint.
+#   - Create a file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - Buffered write the even blocks of the second file.
+#   - directio CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
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
+    rm -rf "$tmp".*
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
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+real_blksz=$(stat -f -c '%S' "$testdir")
+internal_blks=$((blksz * nr / real_blksz))
+"$XFS_IO_PROG" -c "cowextsize $((blksz * 16))" "$testdir" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+seq 1 2 $((nr-1)) | while read f; do
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file3")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || _fail "file3 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/223.out b/tests/xfs/223.out
new file mode 100644
index 0000000..4454fd8
--- /dev/null
+++ b/tests/xfs/223.out
@@ -0,0 +1,14 @@
+QA output created by 223
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-223/file1
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-223/file3
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-223/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-223/file1
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-223/file3
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-223/file3.chk
+Check extent counts
+Check for damage
diff --git a/tests/xfs/224 b/tests/xfs/224
new file mode 100755
index 0000000..cff8f5b
--- /dev/null
+++ b/tests/xfs/224
@@ -0,0 +1,113 @@
+#! /bin/bash
+# FS QA Test No. 224
+#
+# Ensuring that copy on write in buffered mode works when the CoW
+# range originally covers multiple extents, some delalloc, some not.
+#   - Set cowextsize hint.
+#   - Create a file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - Buffered write the even blocks of the second file.
+#   - CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
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
+    rm -rf "$tmp".*
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
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+real_blksz=$(stat -f -c '%S' "$testdir")
+internal_blks=$((blksz * nr / real_blksz))
+"$XFS_IO_PROG" -c "cowextsize $((blksz * 16))" "$testdir" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "CoW across the transition"
+seq 1 2 $((nr-1)) | while read f; do
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file3")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || _fail "file3 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/224.out b/tests/xfs/224.out
new file mode 100644
index 0000000..aa7d8a5
--- /dev/null
+++ b/tests/xfs/224.out
@@ -0,0 +1,14 @@
+QA output created by 224
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-224/file1
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-224/file3
+fa50dba51826899c372464a153cb2117  SCRATCH_MNT/test-224/file3.chk
+CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-224/file1
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-224/file3
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-224/file3.chk
+Check extent counts
+Check for damage
diff --git a/tests/xfs/225 b/tests/xfs/225
new file mode 100755
index 0000000..2474df7
--- /dev/null
+++ b/tests/xfs/225
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 225
+#
+# Ensuring that copy on write in direct-io mode works when the CoW
+# range originally covers multiple extents, some regular, some not.
+#   - Set cowextsize hint.
+#   - Create two files.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - directio CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
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
+    rm -rf "$tmp".*
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
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+real_blksz=$(stat -f -c '%S' "$testdir")
+internal_blks=$((blksz * nr / real_blksz))
+"$XFS_IO_PROG" -c "cowextsize $((blksz * 16))" "$testdir" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file3")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || _fail "file3 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/225.out b/tests/xfs/225.out
new file mode 100644
index 0000000..1355465
--- /dev/null
+++ b/tests/xfs/225.out
@@ -0,0 +1,14 @@
+QA output created by 225
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-225/file1
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-225/file3
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-225/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-225/file1
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-225/file3
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-225/file3.chk
+Check extent counts
+Check for damage
diff --git a/tests/xfs/226 b/tests/xfs/226
new file mode 100755
index 0000000..3cff26b
--- /dev/null
+++ b/tests/xfs/226
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 226
+#
+# Ensuring that copy on write in buffered mode works when the CoW
+# range originally covers multiple extents, some regular, some not.
+#   - Set cowextsize hint.
+#   - Create two files.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
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
+    rm -rf "$tmp".*
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
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+real_blksz=$(stat -f -c '%S' "$testdir")
+internal_blks=$((blksz * nr / real_blksz))
+"$XFS_IO_PROG" -c "cowextsize $((blksz * 16))" "$testdir" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "CoW across the transition"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file3")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || _fail "file3 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/226.out b/tests/xfs/226.out
new file mode 100644
index 0000000..120b62f
--- /dev/null
+++ b/tests/xfs/226.out
@@ -0,0 +1,14 @@
+QA output created by 226
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-226/file1
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-226/file3
+d3959a68638c50af07f0258e032cb554  SCRATCH_MNT/test-226/file3.chk
+CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-226/file1
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-226/file3
+55968a95dfc0120df4e8485576514320  SCRATCH_MNT/test-226/file3.chk
+Check extent counts
+Check for damage
diff --git a/tests/xfs/228 b/tests/xfs/228
new file mode 100755
index 0000000..f0d79ef
--- /dev/null
+++ b/tests/xfs/228
@@ -0,0 +1,137 @@
+#! /bin/bash
+# FS QA Test No. 228
+#
+# Ensuring that copy on write in direct-io mode works when the CoW
+# range originally covers multiple extents, some unwritten, some not.
+#   - Set cowextsize hint.
+#   - Create a file with the following repeating sequence of blocks:
+#     1. reflinked
+#     2. unwritten
+#     3. hole
+#     4. regular block
+#     5. delalloc
+#   - directio CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
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
+    rm -rf "$tmp".*
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
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+real_blksz=$(stat -f -c '%S' "$testdir")
+internal_blks=$((blksz * nr / real_blksz))
+"$XFS_IO_PROG" -c "cowextsize $((blksz * 16))" "$testdir" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+# 0 blocks are reflinked
+seq 0 5 $nr | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+sync
+# 1 blocks are unwritten
+seq 1 5 $nr | while read f; do
+	$XFS_IO_PROG -f -c "falloc $((blksz * f)) $blksz" "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x00 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+sync
+# 2 blocks are holes
+seq 2 5 $nr | while read f; do
+	_pwrite_byte 0x00 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+# 3 blocks are regular
+seq 3 5 $nr | while read f; do
+	_pwrite_byte 0x71 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x71 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+sync
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+# 4 blocks are delalloc (do later)
+seq 4 5 $nr | while read f; do
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+# now cow
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file3")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || _fail "file3 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/228.out b/tests/xfs/228.out
new file mode 100644
index 0000000..8fa4267
--- /dev/null
+++ b/tests/xfs/228.out
@@ -0,0 +1,14 @@
+QA output created by 228
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-228/file1
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-228/file3
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-228/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-228/file1
+36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-228/file3
+36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-228/file3.chk
+Check extent counts
+Check for damage
diff --git a/tests/xfs/230 b/tests/xfs/230
new file mode 100755
index 0000000..89cbc54
--- /dev/null
+++ b/tests/xfs/230
@@ -0,0 +1,137 @@
+#! /bin/bash
+# FS QA Test No. 230
+#
+# Ensuring that copy on write in buffered mode works when the CoW
+# range originally covers multiple extents, some unwritten, some not.
+#   - Set cowextsize hint.
+#   - Create a file with the following repeating sequence of blocks:
+#     1. reflinked
+#     2. unwritten
+#     3. hole
+#     4. regular block
+#     5. delalloc
+#   - CoW across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
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
+    rm -rf "$tmp".*
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
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+real_blksz=$(stat -f -c '%S' "$testdir")
+internal_blks=$((blksz * nr / real_blksz))
+"$XFS_IO_PROG" -c "cowextsize $((blksz * 16))" "$testdir" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+# 0 blocks are reflinked
+seq 0 5 $nr | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+sync
+# 1 blocks are unwritten
+seq 1 5 $nr | while read f; do
+	$XFS_IO_PROG -f -c "falloc $((blksz * f)) $blksz" "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x00 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+sync
+# 2 blocks are holes
+seq 2 5 $nr | while read f; do
+	_pwrite_byte 0x00 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+# 3 blocks are regular
+seq 3 5 $nr | while read f; do
+	_pwrite_byte 0x71 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x71 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+sync
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "directio CoW across the transition"
+# 4 blocks are delalloc (do later)
+seq 4 5 $nr | while read f; do
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+done
+# now cow
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file3")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || _fail "file3 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/230.out b/tests/xfs/230.out
new file mode 100644
index 0000000..32c8fd2
--- /dev/null
+++ b/tests/xfs/230.out
@@ -0,0 +1,14 @@
+QA output created by 230
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-230/file1
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-230/file3
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-230/file3.chk
+directio CoW across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-230/file1
+36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-230/file3
+36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-230/file3.chk
+Check extent counts
+Check for damage
diff --git a/tests/xfs/group b/tests/xfs/group
index afd960f..da83274 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -212,12 +212,22 @@
 212 auto quick clone
 213 auto quick clone
 214 auto quick clone
+215 auto quick clone
 216 log metadata auto quick
 217 log metadata auto
+218 auto quick clone
+219 auto quick clone
 220 auto quota quick
+221 auto quick clone
 222 auto fsr ioctl quick
+223 auto quick clone
+224 auto quick clone
+225 auto quick clone
+226 auto quick clone
 227 auto fsr
+228 auto quick clone
 229 auto rw
+230 auto quick clone
 238 auto quick metadata ioctl
 242 auto quick prealloc
 244 auto quota quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
