Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A8B17F8A
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 23:16:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 686BB8F8039
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 21:16:34 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id BWJNUnWd7qOvVWp7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 21:16:32 -0700 (PDT)
Subject: [PATCH 10/11] test xfs-specific reflink pieces
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 21:16:28 -0700
Message-ID: <20150630041628.2476.50781.stgit@birch.djwong.org>
In-Reply-To: <20150630041519.2476.23059.stgit@birch.djwong.org>
References: <20150630041519.2476.23059.stgit@birch.djwong.org>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Check that growfs and xfs_fsr still work properly on reflinked fses.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/800     |   77 ++++++++++++++++++++++++++++++++++++
 tests/xfs/800.out |    5 ++
 tests/xfs/801     |  114 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/801.out |   15 +++++++
 tests/xfs/group   |    2 +
 5 files changed, 213 insertions(+)
 create mode 100755 tests/xfs/800
 create mode 100644 tests/xfs/800.out
 create mode 100755 tests/xfs/801
 create mode 100644 tests/xfs/801.out


diff --git a/tests/xfs/800 b/tests/xfs/800
new file mode 100755
index 0000000..62b431a
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
+_require_xfs_io_command "fiemap"
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
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR/original \
+    >> $seqres.full 2>&1
+cp --reflink $TESTDIR/original $TESTDIR/copy1
+cp --reflink $TESTDIR/copy1 $TESTDIR/copy2
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
index 0000000..5a75e5f
--- /dev/null
+++ b/tests/xfs/801
@@ -0,0 +1,114 @@
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
+_require_xfs_io_command "fiemap"
+_require_cp_reflink
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file and reflink to copy1, copy2"
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 66000' $TESTDIR/original \
+    >> $seqres.full 2>&1
+cp --reflink $TESTDIR/original $TESTDIR/copy1
+cp --reflink $TESTDIR/copy1 $TESTDIR/copy2
+cp --reflink $TESTDIR/copy2 $TESTDIR/copy3
+
+echo "CoW the reflink copies"
+$XFS_IO_PROG -f -c 'pwrite -S 0x62 0 4096' $TESTDIR/copy1 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x63 0 4096' $TESTDIR/copy2 >> $seqres.full
+sync
+
+echo "Defragment"
+$XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/original >> $seqres.full
+$XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy1 >> $seqres.full
+$XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy2 >> $seqres.full
+$XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy3 >> $seqres.full
+lsattr -l $TESTDIR/ | sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
+xfs_fsr -v -d $TESTDIR/original >> $seqres.full
+xfs_fsr -v -d $TESTDIR/copy1 >> $seqres.full
+xfs_fsr -v -d $TESTDIR/copy2 >> $seqres.full
+xfs_fsr -v -d $TESTDIR/copy3 >> $seqres.full
+
+echo "Check fiemap"
+lsattr -l $TESTDIR/ | sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
+cmp -s <($XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/original | tail -n +2) \
+       <($XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy3 | tail -n +2) \
+       || echo "Sections should match"
+cmp -s <($XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/original | tail -n +2) \
+       <($XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy1 | tail -n +2) \
+       && echo "Sections shouldn't match"
+cmp -s <($XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/original | tail -n +2) \
+       <($XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy2 | tail -n +2) \
+       && echo "Sections shouldn't match"
+cmp -s <($XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy2 | tail -n +2) \
+       && echo "Sections shouldn't match"
+cmp -s <($XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy3 | tail -n +2) \
+       && echo "Sections shouldn't match"
+cmp -s <($XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy2 | tail -n +2) \
+       <($XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy3 | tail -n +2) \
+       && echo "Sections shouldn't match"
+$XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/original >> $seqres.full
+$XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy1 >> $seqres.full
+$XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy2 >> $seqres.full
+$XFS_IO_PROG -f -c 'fiemap -v' $TESTDIR/copy3 >> $seqres.full
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
index 0000000..74e7757
--- /dev/null
+++ b/tests/xfs/801.out
@@ -0,0 +1,15 @@
+QA output created by 801
+Format and mount
+Create the original file and reflink to copy1, copy2
+CoW the reflink copies
+Defragment
+SCRATCH_MNT/test-801/original       ---
+SCRATCH_MNT/test-801/copy1          ---
+SCRATCH_MNT/test-801/copy2          ---
+SCRATCH_MNT/test-801/copy3          ---
+Check fiemap
+SCRATCH_MNT/test-801/original       ---
+SCRATCH_MNT/test-801/copy1          No_COW
+SCRATCH_MNT/test-801/copy2          No_COW
+SCRATCH_MNT/test-801/copy3          ---
+Check scratch fs
diff --git a/tests/xfs/group b/tests/xfs/group
index c12b90a..db0694e 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -193,3 +193,5 @@
 304 auto quick quota
 305 auto quota
 700 fuzzers
+800 auto quick clone
+801 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
