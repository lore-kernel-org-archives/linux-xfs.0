Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17393 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755136AbdDFQBh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2017 12:01:37 -0400
Date: Thu, 6 Apr 2017 09:01:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] generic: test FIEMAP on extended attribute blocks
Message-ID: <20170406160130.GX4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

Make sure that FIEMAP produces some output when we add enough xattrs
to force the xattrs to be stored in an external block.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc             |   15 +++++++-
 tests/generic/700     |   92 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/700.out |    5 +++
 tests/generic/group   |    1 +
 4 files changed, 112 insertions(+), 1 deletion(-)
 create mode 100755 tests/generic/700
 create mode 100644 tests/generic/700.out

diff --git a/common/rc b/common/rc
index 6665f8d..80597e9 100644
--- a/common/rc
+++ b/common/rc
@@ -2037,7 +2037,7 @@ _require_xfs_io_command()
 		;;
 	"fiemap")
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
-			-c "fiemap -v" $testfile 2>&1`
+			-c "fiemap -v $param" $testfile 2>&1`
 		;;
 	"flink" )
 		testio=`$XFS_IO_PROG -T -F -c "flink $testfile" \
@@ -2070,6 +2070,8 @@ _require_xfs_io_command()
 		_notrun "xfs_io $command support is missing"
 	echo $testio | grep -q "Operation not supported" && \
 		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
+	echo $testio | grep -q "Invalid" && \
+		_notrun "xfs_io $command failed (old kernel/wrong fs/bad args?)"
 	echo $testio | grep -q "foreign file active" && \
 		_notrun "xfs_io $command not supported on $FSTYP"
 
@@ -2915,6 +2917,17 @@ _count_holes()
 	$XFS_IO_PROG -c "fiemap" $1 | tail -n +2 | grep hole | wc -l
 }
 
+# Does fiemap support reporting xattr extents?
+_require_fiemap_attr()
+{
+	_require_xfs_io_command "fiemap" "-a"
+}
+
+_count_attr_extents()
+{
+	$XFS_IO_PROG -c "fiemap -a" $1 | tail -n +2 | grep -v hole | wc -l
+}
+
 # arg 1 is dev to remove and is output of the below eg.
 # ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
 _devmgt_remove()
diff --git a/tests/generic/700 b/tests/generic/700
new file mode 100755
index 0000000..157cd27
--- /dev/null
+++ b/tests/generic/700
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 700
+#
+# Check that FIEMAP produces some output when we require an external
+# block to hold extended attributes.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+	wait
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs generic
+_require_scratch
+_require_attrs
+_require_fiemap_attr
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+echo "Create the original files"
+testfile=$testdir/attrfile
+touch $testfile
+blk_sz=$(_get_file_block_size $SCRATCH_MNT)
+
+# Assume each attr eats at least 20 bytes.  Try to fill 2 fs blocks.
+max_attrs=$((2 * blk_sz / 20))
+
+i=0
+while [ $i -lt $max_attrs ]; do
+	n="$(printf "%010d" $i)"
+	$SETFATTR_PROG -n "user.$n" -v "$n" $testfile > $seqres.full 2>&1 || break
+	i=$((i + 1))
+done
+sync
+
+echo "Check attr extent counts"
+f1=$(_count_attr_extents $testfile)
+echo "$f1 xattr extents" >> $seqres.full
+$XFS_IO_PROG -c 'fiemap -a -v' $testfile >> $seqres.full
+test $f1 -gt 0 || echo "Expected at least one xattr extent."
+
+_scratch_cycle_mount
+
+echo "Check attr extent counts after remount"
+f1=$(_count_attr_extents $testfile)
+echo "$f1 xattr extents" >> $seqres.full
+$XFS_IO_PROG -c 'fiemap -a -v' $testfile >> $seqres.full
+test $f1 -gt 0 || echo "Expected at least one xattr extent."
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/700.out b/tests/generic/700.out
new file mode 100644
index 0000000..a6b0562
--- /dev/null
+++ b/tests/generic/700.out
@@ -0,0 +1,5 @@
+QA output created by 700
+Format and mount
+Create the original files
+Check attr extent counts
+Check attr extent counts after remount
diff --git a/tests/generic/group b/tests/generic/group
index 3c7c5e4..cb2a7bb 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -424,3 +424,4 @@
 419 auto quick encrypt
 420 auto quick punch
 421 auto quick encrypt dangerous
+700 auto quick attr
