Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 813F87F93
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:41:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 65A718F804B
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:17 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4nVNF09n5It9nebg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:15 -0800 (PST)
Subject: [PATCH 17/32] xfs: more reflink tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:41:11 -0800
Message-ID: <20160211234111.2202.97746.stgit@birch.djwong.org>
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

Create a couple of XFS-specific tests -- one to check that growing
and shrinking the refcount btree works and a second one to check
what happens when we hit maximum refcount.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/169     |   86 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/169.out |    7 +++
 tests/xfs/179     |  118 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/179.out |   10 ++++
 tests/xfs/group   |    4 +-
 5 files changed, 224 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/169
 create mode 100644 tests/xfs/169.out
 create mode 100755 tests/xfs/179
 create mode 100644 tests/xfs/179.out


diff --git a/tests/xfs/169 b/tests/xfs/169
new file mode 100755
index 0000000..996500e
--- /dev/null
+++ b/tests/xfs/169
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FS QA Test No. 169
+#
+# Ensure that we can create enough distinct reflink entries to force creation
+# of a multi-level refcount btree.  Delete and recreate a few times to
+# exercise the refcount btree grow/shrink functions.
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
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
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
+
+	echo "$i: Reflink every other block"
+	seq 1 2 $((nr_blks - 1)) | while read nr; do
+		_reflink_range  $testdir/file1 $((nr * blksz)) \
+				$testdir/file2 $((nr * blksz)) $blksz >> $seqres.full
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
diff --git a/tests/xfs/169.out b/tests/xfs/169.out
new file mode 100644
index 0000000..1159e30
--- /dev/null
+++ b/tests/xfs/169.out
@@ -0,0 +1,7 @@
+QA output created by 169
+Create the original file blocks
+1: Reflink every other block
+1: Delete both files
+2: Reflink every other block
+2: Delete both files
+x: Reflink every other block
diff --git a/tests/xfs/179 b/tests/xfs/179
new file mode 100755
index 0000000..e0b0af8
--- /dev/null
+++ b/tests/xfs/179
@@ -0,0 +1,118 @@
+#! /bin/bash
+# FS QA Test No. 179
+#
+# See how well reflink handles overflowing reflink counts.
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
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_scratch_nocheck
+_require_cp_reflink
+_require_test_program "punch-alternating"
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs -d agcount=1 > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+
+echo "Create original files"
+_pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+
+echo "Change reference count"
+umount $SCRATCH_MNT
+echo "set refcount to -4" >> $seqres.full
+$XFS_DB_PROG -x -c 'agf 0' -c 'addr refcntroot' -c 'write recs[1].refcount 4294967292' $SCRATCH_DEV >> $seqres.full
+echo "check refcount after setting to -4" >> $seqres.full
+$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' $SCRATCH_DEV >> $seqres.full
+_scratch_mount >> $seqres.full
+
+echo "Reflink the overlinked file"
+_cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file4 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file5 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file6 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file7 >> $seqres.full
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+echo "check refcount after reflinking 5 more times" >> $seqres.full
+$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' $SCRATCH_DEV >> $seqres.full
+_scratch_mount >> $seqres.full
+
+echo "CoW a couple files"
+_pwrite_byte 0x62 0 $blksz $testdir/file3 >> $seqres.full
+_pwrite_byte 0x62 0 $blksz $testdir/file5 >> $seqres.full
+_pwrite_byte 0x62 0 $blksz $testdir/file7 >> $seqres.full
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+echo "check refcount after cowing 3 files" >> $seqres.full
+$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' $SCRATCH_DEV >> $seqres.full
+_scratch_mount >> $seqres.full
+
+echo "Remove reflinked files"
+rm -rf $testdir/file*
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+echo "check refcount after removing all files" >> $seqres.full
+$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' $SCRATCH_DEV >> $seqres.full
+$XFS_REPAIR_PROG -o force_geometry -n $SCRATCH_DEV >> $seqres.full 2>&1
+res=$?
+if [ $res -eq 0 ]; then
+	# If repair succeeds then format the device so that the post-test
+	# check doesn't fail due to the single AG.
+	_scratch_mkfs >> $seqres.full 2>&1
+else
+	_fail "xfs_repair fails"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/179.out b/tests/xfs/179.out
new file mode 100644
index 0000000..4d3e605
--- /dev/null
+++ b/tests/xfs/179.out
@@ -0,0 +1,10 @@
+QA output created by 179
+Format and mount
+Create original files
+Change reference count
+Reflink the overlinked file
+Check scratch fs
+CoW a couple files
+Check scratch fs
+Remove reflinked files
+Check scratch fs
diff --git a/tests/xfs/group b/tests/xfs/group
index 2db3520..f0c1c2b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -127,7 +127,7 @@
 127 auto quick clone
 128 auto quick clone
 129 auto quick clone
-130 fuzzers
+130 fuzzers clone
 131 auto quick clone
 132 auto quick clone
 133 auto quick quota
@@ -166,6 +166,7 @@
 166 rw metadata auto quick
 167 rw metadata auto stress
 168 dmapi
+169 auto quick clone
 170 rw filestreams auto quick
 171 rw filestreams
 172 rw filestreams
@@ -175,6 +176,7 @@
 176 dmapi
 177 dmapi
 178 mkfs other auto
+179 auto quick clone
 181 log auto quick
 183 rw other auto quick
 185 dmapi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
