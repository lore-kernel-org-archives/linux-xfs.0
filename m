Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 500BC7F84
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:42:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A38F9AC003
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:05 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id rE06CVnDBj3Ga20h (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:59 -0800 (PST)
Subject: [PATCH 23/32] reflink: test CoW across a mixed range of block types
	with cowextsize set
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:41:55 -0800
Message-ID: <20160211234155.2202.25679.stgit@birch.djwong.org>
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
 tests/xfs/215     |  102 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/215.out |   13 ++++++
 tests/xfs/218     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/218.out |   13 ++++++
 tests/xfs/219     |  102 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/219.out |   13 ++++++
 tests/xfs/221     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/221.out |   13 ++++++
 tests/xfs/223     |  104 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/223.out |   13 ++++++
 tests/xfs/224     |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/224.out |   13 ++++++
 tests/xfs/225     |  102 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/225.out |   13 ++++++
 tests/xfs/226     |  101 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/226.out |   13 ++++++
 tests/xfs/228     |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/228.out |   13 ++++++
 tests/xfs/230     |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/230.out |   13 ++++++
 tests/xfs/group   |   10 +++++
 21 files changed, 1176 insertions(+)
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
index 0000000..9ed842e
--- /dev/null
+++ b/tests/xfs/215
@@ -0,0 +1,102 @@
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
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+_require_odirect
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "directio CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file3)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/215.out b/tests/xfs/215.out
new file mode 100644
index 0000000..ce3a08b
--- /dev/null
+++ b/tests/xfs/215.out
@@ -0,0 +1,13 @@
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
diff --git a/tests/xfs/218 b/tests/xfs/218
new file mode 100755
index 0000000..e98b14e
--- /dev/null
+++ b/tests/xfs/218
@@ -0,0 +1,101 @@
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
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file3)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/218.out b/tests/xfs/218.out
new file mode 100644
index 0000000..ad1efda
--- /dev/null
+++ b/tests/xfs/218.out
@@ -0,0 +1,13 @@
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
diff --git a/tests/xfs/219 b/tests/xfs/219
new file mode 100755
index 0000000..25c0bb4
--- /dev/null
+++ b/tests/xfs/219
@@ -0,0 +1,102 @@
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
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+_require_odirect
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "directio CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file3)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/219.out b/tests/xfs/219.out
new file mode 100644
index 0000000..9052f1f
--- /dev/null
+++ b/tests/xfs/219.out
@@ -0,0 +1,13 @@
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
diff --git a/tests/xfs/221 b/tests/xfs/221
new file mode 100755
index 0000000..dc00331
--- /dev/null
+++ b/tests/xfs/221
@@ -0,0 +1,101 @@
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
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file3)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/221.out b/tests/xfs/221.out
new file mode 100644
index 0000000..63963ec
--- /dev/null
+++ b/tests/xfs/221.out
@@ -0,0 +1,13 @@
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
diff --git a/tests/xfs/223 b/tests/xfs/223
new file mode 100755
index 0000000..2bb1fcb
--- /dev/null
+++ b/tests/xfs/223
@@ -0,0 +1,104 @@
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
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+_require_odirect
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "directio CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+_weave_reflink_holes_delalloc $blksz $nr $testdir/file3 >> $seqres.full
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file3)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/223.out b/tests/xfs/223.out
new file mode 100644
index 0000000..e07b33e
--- /dev/null
+++ b/tests/xfs/223.out
@@ -0,0 +1,13 @@
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
diff --git a/tests/xfs/224 b/tests/xfs/224
new file mode 100755
index 0000000..92d3b05
--- /dev/null
+++ b/tests/xfs/224
@@ -0,0 +1,103 @@
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
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+_weave_reflink_holes_delalloc $blksz $nr $testdir/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file3)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/224.out b/tests/xfs/224.out
new file mode 100644
index 0000000..749b3c9
--- /dev/null
+++ b/tests/xfs/224.out
@@ -0,0 +1,13 @@
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
diff --git a/tests/xfs/225 b/tests/xfs/225
new file mode 100755
index 0000000..b8e7712
--- /dev/null
+++ b/tests/xfs/225
@@ -0,0 +1,102 @@
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
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+_require_odirect
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "directio CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file3)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/225.out b/tests/xfs/225.out
new file mode 100644
index 0000000..da70fbc
--- /dev/null
+++ b/tests/xfs/225.out
@@ -0,0 +1,13 @@
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
diff --git a/tests/xfs/226 b/tests/xfs/226
new file mode 100755
index 0000000..ef4226e
--- /dev/null
+++ b/tests/xfs/226
@@ -0,0 +1,101 @@
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
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file3)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/226.out b/tests/xfs/226.out
new file mode 100644
index 0000000..d413e8b
--- /dev/null
+++ b/tests/xfs/226.out
@@ -0,0 +1,13 @@
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
diff --git a/tests/xfs/228 b/tests/xfs/228
new file mode 100755
index 0000000..ecbe35f
--- /dev/null
+++ b/tests/xfs/228
@@ -0,0 +1,110 @@
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
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_cp_reflink
+_require_odirect
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "directio CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+_weave_reflink_rainbow_delalloc $blksz $nr $testdir/file3 >> $seqres.full
+# now cow
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file3)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/228.out b/tests/xfs/228.out
new file mode 100644
index 0000000..13b0aee
--- /dev/null
+++ b/tests/xfs/228.out
@@ -0,0 +1,13 @@
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
+26aa3a0749b867ec58363c8539ee5471  SCRATCH_MNT/test-228/file3
+26aa3a0749b867ec58363c8539ee5471  SCRATCH_MNT/test-228/file3.chk
+Check extent counts
diff --git a/tests/xfs/230 b/tests/xfs/230
new file mode 100755
index 0000000..e09b52e
--- /dev/null
+++ b/tests/xfs/230
@@ -0,0 +1,110 @@
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
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_cp_reflink
+_require_odirect
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "directio CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+_weave_reflink_rainbow_delalloc $blksz $nr $testdir/file3 >> $seqres.full
+# now cow
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file3.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file3)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || echo "file3 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/230.out b/tests/xfs/230.out
new file mode 100644
index 0000000..439427c
--- /dev/null
+++ b/tests/xfs/230.out
@@ -0,0 +1,13 @@
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
+26aa3a0749b867ec58363c8539ee5471  SCRATCH_MNT/test-230/file3
+26aa3a0749b867ec58363c8539ee5471  SCRATCH_MNT/test-230/file3.chk
+Check extent counts
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
