Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 67D647CB7
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:47:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7390AC005
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:47:52 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id aRnPl52ag5ylCYMJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:47:50 -0700 (PDT)
Subject: [PATCH 14/17] xfs: more rmapbt tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jul 2016 16:47:45 -0700
Message-ID: <146914486527.11762.1173224384905616811.stgit@birch.djwong.org>
In-Reply-To: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
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
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

More tests for the reverse mapping functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/876     |   76 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/876.out |    4 ++
 tests/xfs/877     |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/877.out |   10 ++++++
 tests/xfs/group   |    4 ++
 5 files changed, 178 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/876
 create mode 100644 tests/xfs/876.out
 create mode 100755 tests/xfs/877
 create mode 100644 tests/xfs/877.out


diff --git a/tests/xfs/876 b/tests/xfs/876
new file mode 100755
index 0000000..cf73d40
--- /dev/null
+++ b/tests/xfs/876
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test No. 876
+#
+# Create a big enough rmapbt that we tickle a fdblocks accounting bug.
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
+	cd /
+	rm -rf "$tmp".*
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
+_require_scratch
+_require_xfs_scratch_rmapbt
+_require_scratch_reflink
+_require_test_program "punch-alternating"
+
+rm -f "$seqres.full"
+
+echo "+ create scratch fs"
+_scratch_mkfs > "$seqres.full" 2>&1
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f $SCRATCH_MNT -c '%S')"
+isize=$(xfs_info $SCRATCH_MNT | grep isize | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g')
+
+bt_ptrs=$(( (blksz - 56) / 44 ))
+bt_recs=$(( (blksz - 56) / 24 ))
+
+blocks=$((bt_ptrs * bt_recs + 1))
+_require_fs_space $SCRATCH_MNT $(( (2 * blocks * blksz) * 5 / 4096 ))
+len=$((blocks * blksz))
+
+echo "+ make some files"
+$XFS_IO_PROG -f -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f2 >> $seqres.full
+./src/punch-alternating $SCRATCH_MNT/f1 >> "$seqres.full"
+./src/punch-alternating $SCRATCH_MNT/f2 >> "$seqres.full"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/876.out b/tests/xfs/876.out
new file mode 100644
index 0000000..96c1970
--- /dev/null
+++ b/tests/xfs/876.out
@@ -0,0 +1,4 @@
+QA output created by 876
++ create scratch fs
++ mount fs image
++ make some files
diff --git a/tests/xfs/877 b/tests/xfs/877
new file mode 100755
index 0000000..9700263
--- /dev/null
+++ b/tests/xfs/877
@@ -0,0 +1,85 @@
+#! /bin/bash
+# FS QA Test No. 877
+#
+# Make sure query_range returns -EINVAL if lowkey > highkey.
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
+	cd /
+	rm -rf "$tmp".* $metadump_file
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_os Linux
+_require_xfs_scratch_rmapbt
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+blksz=65536
+blocks=16
+len=$((blocks * blksz))
+
+echo "Create some files"
+$XFS_IO_PROG -f -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
+
+echo "Manipulate file"
+$XFS_IO_PROG -c "fpunch $blksz $blksz" \
+	-c "fzero $((3 * blksz)) $blksz" \
+	-c "pwrite -S 0x69 $((5 * blksz)) $blksz" \
+	-c "fpunch $((7 * blksz)) $blksz" \
+	-c "fsync" \
+	-c "pwrite -S 0x70 $((7 * blksz)) $blksz" \
+	-c "fcollapse $((9 * blksz)) $blksz" \
+	-c "finsert $((10 * blksz)) $blksz" $SCRATCH_MNT/f1 >> $seqres.full
+
+echo "Check file"
+md5sum $SCRATCH_MNT/f1 | _filter_scratch
+od -tx1 -Ad -c $SCRATCH_MNT/f1 >> $seqres.full
+
+echo "Unmount"
+_scratch_unmount
+
+echo "Try a regular fsmap"
+$XFS_DB_PROG -c 'fsmap' $SCRATCH_DEV >> $seqres.full
+$XFS_DB_PROG -c 'fsmap 0 5' $SCRATCH_DEV >> $seqres.full
+
+echo "Try a bad fsmap"
+$XFS_DB_PROG -c 'fsmap 5 4' $SCRATCH_DEV
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/877.out b/tests/xfs/877.out
new file mode 100644
index 0000000..4a2242f
--- /dev/null
+++ b/tests/xfs/877.out
@@ -0,0 +1,10 @@
+QA output created by 877
+Format and mount
+Create some files
+Manipulate file
+Check file
+e45c5707fcf6817e914ffb6ce37a0ac7  SCRATCH_MNT/f1
+Unmount
+Try a regular fsmap
+Try a bad fsmap
+Error 22 while querying fsmap btree.
diff --git a/tests/xfs/group b/tests/xfs/group
index 16f7947..f81f899 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -3,8 +3,8 @@
 003 db auto quick
 004 db auto quick
 005 auto quick
-007 auto quota quick
 006 auto quick mount
+007 auto quota quick
 008 rw ioctl auto quick
 009 rw ioctl auto prealloc quick
 010 auto quick repair
@@ -309,3 +309,5 @@
 873 auto quick clone fsr
 874 auto quick clone fsr
 875 auto quick clone fsr quota
+876 auto quick rmap clone
+877 auto quick rmap clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
