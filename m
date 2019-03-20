Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:57646 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCTAps (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 20:45:48 -0400
Subject: [PATCH 09/12] clonerange: test remapping the rainbow
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 19 Mar 2019 17:45:41 -0700
Message-ID: <155304274130.31707.14030747488293662594.stgit@magnolia>
In-Reply-To: <155304267647.31707.14180452399822113095.stgit@magnolia>
References: <155304267647.31707.14180452399822113095.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add some more clone range tests that missed various "wacky" combinations
of file state.  Specifically, we test reflinking into and out of rainbow
ranges (a mix of real, unwritten, hole, delalloc, and shared extents),
and also we test that we can correctly handle double-inode locking no
matter what order of inodes or the filesystem's locking rules.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/reflink        |    7 ++
 tests/generic/940     |   94 ++++++++++++++++++++++++
 tests/generic/940.out |   14 ++++
 tests/generic/941     |   99 +++++++++++++++++++++++++
 tests/generic/941.out |   16 ++++
 tests/generic/942     |   95 ++++++++++++++++++++++++
 tests/generic/942.out |   14 ++++
 tests/generic/943     |   99 +++++++++++++++++++++++++
 tests/generic/943.out |   16 ++++
 tests/generic/944     |  196 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/944.out |   62 ++++++++++++++++
 tests/generic/group   |    5 +
 12 files changed, 716 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/940
 create mode 100644 tests/generic/940.out
 create mode 100755 tests/generic/941
 create mode 100644 tests/generic/941.out
 create mode 100755 tests/generic/942
 create mode 100644 tests/generic/942.out
 create mode 100755 tests/generic/943
 create mode 100644 tests/generic/943.out
 create mode 100755 tests/generic/944
 create mode 100644 tests/generic/944.out


diff --git a/common/reflink b/common/reflink
index 11561a76..598f0877 100644
--- a/common/reflink
+++ b/common/reflink
@@ -14,9 +14,14 @@ _require_cp_reflink()
 # Can we reflink between arbitrary file sets?
 # i.e. if we reflink a->b and c->d, can we later share
 # blocks between b & c?
+_supports_arbitrary_fileset_reflink()
+{
+	test "$FSTYP" != "ocfs2"
+}
+
 _require_arbitrary_fileset_reflink()
 {
-	test "$FSTYP" = "ocfs2" && \
+	_supports_arbitrary_fileset_reflink ||
 		_notrun "reflink between arbitrary file groups not supported in $FSTYP"
 }
 
diff --git a/tests/generic/940 b/tests/generic/940
new file mode 100755
index 00000000..4573cbae
--- /dev/null
+++ b/tests/generic/940
@@ -0,0 +1,94 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 940
+#
+# Ensuring that reflinking works when the destination range covers multiple
+# extents, some unwritten, some not:
+#
+#   - Create a file with the following repeating sequence of blocks:
+#     1. reflinked
+#     2. unwritten
+#     3. hole
+#     4. regular block
+#     5. delalloc
+#   - reflink across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
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
+    rm -rf $tmp.* $testdir
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
+_pwrite_byte 0x64 0 $((blksz * nr)) $testdir/file2 >> $seqres.full
+_weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "reflink across the transition"
+roff=$((filesize / 4))
+rsz=$((filesize / 2))
+_weave_reflink_rainbow_delalloc $blksz $nr $testdir/file3 >> $seqres.full
+
+# now reflink into the rainbow
+echo "before reflink" >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file2 >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "reflink $testdir/file2 $roff $roff $rsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x64 $roff $rsz $testdir/file3.chk >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+echo "after reflink" >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file2 >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file3 >> $seqres.full
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/940.out b/tests/generic/940.out
new file mode 100644
index 00000000..d34c7b50
--- /dev/null
+++ b/tests/generic/940.out
@@ -0,0 +1,14 @@
+QA output created by 940
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-940/file1
+5a5221017d3ab8fd7583312a14d2ba80  SCRATCH_MNT/test-940/file2
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-940/file3
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-940/file3.chk
+reflink across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-940/file1
+5a5221017d3ab8fd7583312a14d2ba80  SCRATCH_MNT/test-940/file2
+5d47954e2336b2547afde6e44d2f13cc  SCRATCH_MNT/test-940/file3
+5d47954e2336b2547afde6e44d2f13cc  SCRATCH_MNT/test-940/file3.chk
diff --git a/tests/generic/941 b/tests/generic/941
new file mode 100755
index 00000000..145b8585
--- /dev/null
+++ b/tests/generic/941
@@ -0,0 +1,99 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 941
+#
+# Ensuring that reflinking works when the source range covers multiple
+# extents, some unwritten, some not:
+#
+#   - Create a file with the following repeating sequence of blocks:
+#     1. reflinked
+#     2. unwritten
+#     3. hole
+#     4. regular block
+#     5. delalloc
+#   - reflink across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
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
+    rm -rf $tmp.* $testdir
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
+_pwrite_byte 0x64 0 $((blksz * nr)) $testdir/file2 >> $seqres.full
+_pwrite_byte 0x64 0 $((blksz * nr)) $testdir/file2.chk >> $seqres.full
+_weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "reflink across the transition"
+roff=$((filesize / 4))
+rsz=$((filesize / 2))
+_weave_reflink_rainbow_delalloc $blksz $nr $testdir/file3 >> $seqres.full
+
+# now reflink the rainbow
+echo "before reflink" >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file2 >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "reflink $testdir/file3 $roff $roff $rsz" $testdir/file2 >> $seqres.full
+cp $testdir/file3.chk $testdir/file2.chk
+_pwrite_byte 0x64 0 $roff $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x64 $((roff + rsz)) $((filesize - (roff + rsz) )) $testdir/file2.chk >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+echo "after reflink" >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file2 >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file3 >> $seqres.full
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/941.out b/tests/generic/941.out
new file mode 100644
index 00000000..a76e6c62
--- /dev/null
+++ b/tests/generic/941.out
@@ -0,0 +1,16 @@
+QA output created by 941
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-941/file1
+5a5221017d3ab8fd7583312a14d2ba80  SCRATCH_MNT/test-941/file2
+5a5221017d3ab8fd7583312a14d2ba80  SCRATCH_MNT/test-941/file2.chk
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-941/file3
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-941/file3.chk
+reflink across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-941/file1
+51a300aae3a4b4eaa023876a397e01ef  SCRATCH_MNT/test-941/file2
+51a300aae3a4b4eaa023876a397e01ef  SCRATCH_MNT/test-941/file2.chk
+7bf7a779a0a54647b41753206c5218b1  SCRATCH_MNT/test-941/file3
+7bf7a779a0a54647b41753206c5218b1  SCRATCH_MNT/test-941/file3.chk
diff --git a/tests/generic/942 b/tests/generic/942
new file mode 100755
index 00000000..92b0f298
--- /dev/null
+++ b/tests/generic/942
@@ -0,0 +1,95 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 942
+#
+# Ensuring that reflinking works when the destination range covers multiple
+# extents, some unwritten, some not:
+#
+#   - Create a file with the following repeating sequence of blocks:
+#     1. reflinked
+#     2. unwritten
+#     3. hole
+#     4. regular block
+#     5. delalloc
+#   - reflink across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
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
+    rm -rf $tmp.* $testdir
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
+_pwrite_byte 0x64 0 $((blksz * nr)) $testdir/file2 >> $seqres.full
+_weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "reflink across the transition"
+soff=$((filesize / 4))
+doff=$((filesize / 2))
+rsz=$((filesize / 2))
+_weave_reflink_rainbow_delalloc $blksz $nr $testdir/file3 >> $seqres.full
+
+# now reflink into the rainbow
+echo "before reflink" >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file2 >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "reflink $testdir/file2 $soff $doff $rsz" $testdir/file3 >> $seqres.full
+_pwrite_byte 0x64 $doff $rsz $testdir/file3.chk >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+echo "after reflink" >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file2 >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file3 >> $seqres.full
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/942.out b/tests/generic/942.out
new file mode 100644
index 00000000..529ecff2
--- /dev/null
+++ b/tests/generic/942.out
@@ -0,0 +1,14 @@
+QA output created by 942
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-942/file1
+5a5221017d3ab8fd7583312a14d2ba80  SCRATCH_MNT/test-942/file2
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-942/file3
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-942/file3.chk
+reflink across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-942/file1
+5a5221017d3ab8fd7583312a14d2ba80  SCRATCH_MNT/test-942/file2
+52bb341f992de6ef4bf5e5d61177eddc  SCRATCH_MNT/test-942/file3
+52bb341f992de6ef4bf5e5d61177eddc  SCRATCH_MNT/test-942/file3.chk
diff --git a/tests/generic/943 b/tests/generic/943
new file mode 100755
index 00000000..91dfa75b
--- /dev/null
+++ b/tests/generic/943
@@ -0,0 +1,99 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 943
+#
+# Ensuring that reflinking works when the source range covers multiple
+# extents, some unwritten, some not:
+#
+#   - Create a file with the following repeating sequence of blocks:
+#     1. reflinked
+#     2. unwritten
+#     3. hole
+#     4. regular block
+#     5. delalloc
+#   - reflink across the halfway mark, starting with the unwritten extent.
+#   - Check that the files are now different where we say they're different.
+#
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
+    rm -rf $tmp.* $testdir
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
+_pwrite_byte 0x64 0 $((blksz * nr)) $testdir/file2 >> $seqres.full
+_pwrite_byte 0x64 0 $((blksz * nr)) $testdir/file2.chk >> $seqres.full
+_weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+echo "reflink across the transition"
+soff=$((filesize / 4))
+doff=$((filesize / 2))
+rsz=$((filesize / 2))
+_weave_reflink_rainbow_delalloc $blksz $nr $testdir/file3 >> $seqres.full
+
+# now reflink the rainbow
+echo "before reflink" >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file2 >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "reflink $testdir/file3 $soff $doff $rsz" $testdir/file2 >> $seqres.full
+truncate -s $doff $testdir/file2.chk
+dd if=$testdir/file3.chk skip=$((soff / blksz)) count=$((rsz / blksz)) bs=$blksz >> $testdir/file2.chk 2> /dev/null
+_scratch_cycle_mount
+
+echo "Compare files"
+echo "after reflink" >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file2 >> $seqres.full
+$FILEFRAG_PROG -v $testdir/file3 >> $seqres.full
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file3.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/943.out b/tests/generic/943.out
new file mode 100644
index 00000000..471c3f34
--- /dev/null
+++ b/tests/generic/943.out
@@ -0,0 +1,16 @@
+QA output created by 943
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-943/file1
+5a5221017d3ab8fd7583312a14d2ba80  SCRATCH_MNT/test-943/file2
+5a5221017d3ab8fd7583312a14d2ba80  SCRATCH_MNT/test-943/file2.chk
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-943/file3
+6366fd359371414186688a0ef6988893  SCRATCH_MNT/test-943/file3.chk
+reflink across the transition
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-943/file1
+d93123af536c8c012f866ea383a905ce  SCRATCH_MNT/test-943/file2
+d93123af536c8c012f866ea383a905ce  SCRATCH_MNT/test-943/file2.chk
+7bf7a779a0a54647b41753206c5218b1  SCRATCH_MNT/test-943/file3
+7bf7a779a0a54647b41753206c5218b1  SCRATCH_MNT/test-943/file3.chk
diff --git a/tests/generic/944 b/tests/generic/944
new file mode 100755
index 00000000..237cd2da
--- /dev/null
+++ b/tests/generic/944
@@ -0,0 +1,196 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0+
+# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
+#
+# FS QA Test No. 944
+#
+# Ensure that we can reflink from a file with a higher inode number to a lower
+# inode number and vice versa.  Mix it up by doing this test with inodes that
+# already share blocks and inodes that don't share blocks.  This tests both
+# double-inode locking order correctness as well as stressing things like ocfs2
+# which have per-inode sharing groups and therefore have to check that we don't
+# try to link data between disjoint sharing groups.
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
+    rm -rf $tmp.* $testdir
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
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+blksz=65536
+nr=2
+filesize=$((blksz * nr))
+testdir=$SCRATCH_MNT/test-$seq
+dummy_file=$testdir/dummy
+low_file=$testdir/low
+high_file=$testdir/high
+scenario=1
+mkdir $testdir
+
+# Return inode number
+inum() {
+	stat -c '%i' $1
+}
+
+# Create two test files, make $low_file the file with the lower inode
+# number, and make $high_file the file with the higher inode number.
+create_files() {
+	_pwrite_byte 0x60 0 $filesize $testdir/file1 >> $seqres.full
+	_pwrite_byte 0x61 0 $filesize $testdir/file2 >> $seqres.full
+	if [ "$(inum $testdir/file1)" -lt "$(inum $testdir/file2)" ]; then
+		mv $testdir/file1 $low_file
+		mv $testdir/file2 $high_file
+	else
+		mv $testdir/file2 $low_file
+		mv $testdir/file1 $high_file
+	fi
+}
+
+# Check md5sum of both files, but keep results sorted by inode order
+check_files() {
+	md5sum $low_file | _filter_scratch
+	md5sum $high_file | _filter_scratch
+}
+
+# Test reflinking data from the first file to the second file
+test_files() {
+	local src="$1"
+	local dest="$2"
+	local off=$((filesize / 2))
+	local sz=$((filesize / 2))
+
+	check_files
+	_reflink_range $src $off $dest $off $sz >> $seqres.full
+	_scratch_cycle_mount
+	check_files
+}
+
+# Make a file shared with a dummy file
+dummy_share() {
+	local which="$2"
+	test -z "$which" && which=1
+	local dummy=$dummy_file.$which
+
+	rm -f $dummy
+	_cp_reflink $1 $dummy
+}
+
+# Make two files share (different ranges) with a dummy file
+mutual_dummy_share() {
+	rm -f $dummy_file
+	_cp_reflink $1 $dummy_file
+	_reflink_range $2 0 $dummy_file $blksz $blksz >> $seqres.full
+}
+
+# Announce ourselves, remembering which scenario we've tried
+ann() {
+	echo "$scenario: $@" | tee -a $seqres.full
+	scenario=$((scenario + 1))
+}
+
+# Scenario 1: low to high, neither file shares
+ann "low to high, neither share"
+create_files
+test_files $low_file $high_file
+
+# Scenario 2: high to low, neither file shares
+ann "high to low, neither share"
+create_files
+test_files $high_file $low_file
+
+# Scenario 3: low to high, only source file shares
+ann "low to high, only source shares"
+create_files
+dummy_share $low_file
+test_files $low_file $high_file
+
+# Scenario 4: high to low, only source file shares
+ann "high to low, only source shares"
+create_files
+dummy_share $high_file
+test_files $high_file $low_file
+
+# Scenario 5: low to high, only dest file shares
+ann "low to high, only dest shares"
+create_files
+dummy_share $high_file
+test_files $low_file $high_file
+
+# Scenario 6: high to low, only dest file shares
+ann "high to low, only dest shares"
+create_files
+dummy_share $low_file
+test_files $high_file $low_file
+
+# Scenario 7: low to high, both files share with each other
+ann "low to high, both files share with each other"
+create_files
+_reflink_range $low_file 0 $high_file 0 $blksz >> $seqres.full
+test_files $low_file $high_file
+
+# Scenario 8: high to low, both files share with each other
+ann "high to low, both files share with each other"
+create_files
+_reflink_range $low_file 0 $high_file 0 $blksz >> $seqres.full
+test_files $high_file $low_file
+
+# Scenario 9: low to high, both files share but not with each other
+ann "low to high, both files share but not with each other"
+create_files
+# ocfs2 can only reflink between files sharing a refcount tree, so for
+# this test (and #10) we skip the dummy file because we'd rather not split
+# the test code just to mask off the /one/ weird fs like this...
+if _supports_arbitrary_fileset_reflink; then
+	dummy_share $low_file 1
+	dummy_share $high_file 2
+fi
+test_files $low_file $high_file
+
+# Scenario 10: high to low, both files share but not with each other
+ann "high to low, both files share but not with each other"
+create_files
+if _supports_arbitrary_fileset_reflink; then
+	dummy_share $low_file 1
+	dummy_share $high_file 2
+fi
+test_files $high_file $low_file
+
+# Scenario 11: low to high, both files share mutually
+ann "low to high, both files share mutually"
+create_files
+mutual_dummy_share $low_file $high_file
+test_files $low_file $high_file
+
+# Scenario 12: high to low, both files share mutually
+ann "high to low, both files share mutually"
+create_files
+mutual_dummy_share $low_file $high_file
+test_files $high_file $low_file
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/944.out b/tests/generic/944.out
new file mode 100644
index 00000000..aa53fdce
--- /dev/null
+++ b/tests/generic/944.out
@@ -0,0 +1,62 @@
+QA output created by 944
+Format and mount
+1: low to high, neither share
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+de1d43fbed633326daed6f71912e09e1  SCRATCH_MNT/test-944/high
+2: high to low, neither share
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+0d2ce48b6a4527783bd30ce21f09fec0  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+3: low to high, only source shares
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+de1d43fbed633326daed6f71912e09e1  SCRATCH_MNT/test-944/high
+4: high to low, only source shares
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+0d2ce48b6a4527783bd30ce21f09fec0  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+5: low to high, only dest shares
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+de1d43fbed633326daed6f71912e09e1  SCRATCH_MNT/test-944/high
+6: high to low, only dest shares
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+0d2ce48b6a4527783bd30ce21f09fec0  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+7: low to high, both files share with each other
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+0d2ce48b6a4527783bd30ce21f09fec0  SCRATCH_MNT/test-944/high
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/high
+8: high to low, both files share with each other
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+0d2ce48b6a4527783bd30ce21f09fec0  SCRATCH_MNT/test-944/high
+0d2ce48b6a4527783bd30ce21f09fec0  SCRATCH_MNT/test-944/low
+0d2ce48b6a4527783bd30ce21f09fec0  SCRATCH_MNT/test-944/high
+9: low to high, both files share but not with each other
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+de1d43fbed633326daed6f71912e09e1  SCRATCH_MNT/test-944/high
+10: high to low, both files share but not with each other
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+0d2ce48b6a4527783bd30ce21f09fec0  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+11: low to high, both files share mutually
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+de1d43fbed633326daed6f71912e09e1  SCRATCH_MNT/test-944/high
+12: high to low, both files share mutually
+07d9f5b0e07f22bff26e39f929cfc460  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
+0d2ce48b6a4527783bd30ce21f09fec0  SCRATCH_MNT/test-944/low
+81615449a98aaaad8dc179b3bec87f38  SCRATCH_MNT/test-944/high
diff --git a/tests/generic/group b/tests/generic/group
index 78b9b45d..2e4341fb 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -538,3 +538,8 @@
 533 auto quick attr
 534 auto quick log
 535 auto quick log
+940 auto quick clone punch
+941 auto quick clone punch
+942 auto quick clone punch
+943 auto quick clone punch
+944 auto quick clone punch
