Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2602C7CCB
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 18:48:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id ECE768F8033
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:48:18 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id dBUFinnmLMZC0z7C (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2016 16:48:12 -0700 (PDT)
Subject: [PATCH 17/17] xfs: test realtime rmapbt code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jul 2016 16:48:07 -0700
Message-ID: <146914488713.11762.7958985131932985171.stgit@birch.djwong.org>
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

Test the realtime rmap btree code by exercising various IO patterns
on realtime files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/878     |   88 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/878.out |    9 ++++
 tests/xfs/879     |   67 +++++++++++++++++++++++++++++++++
 tests/xfs/879.out |    7 +++
 tests/xfs/880     |   86 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/880.out |    7 +++
 tests/xfs/881     |   95 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/881.out |    8 ++++
 tests/xfs/882     |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/882.out |   11 +++++
 tests/xfs/883     |   89 ++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/883.out |   10 +++++
 tests/xfs/884     |   91 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/884.out |    9 ++++
 tests/xfs/885     |   94 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/885.out |   10 +++++
 tests/xfs/886     |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/886.out |    7 +++
 tests/xfs/887     |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/887.out |    7 +++
 tests/xfs/888     |   76 +++++++++++++++++++++++++++++++++++++
 tests/xfs/888.out |    6 +++
 tests/xfs/group   |   11 +++++
 23 files changed, 1107 insertions(+)
 create mode 100644 tests/xfs/878
 create mode 100644 tests/xfs/878.out
 create mode 100755 tests/xfs/879
 create mode 100644 tests/xfs/879.out
 create mode 100755 tests/xfs/880
 create mode 100644 tests/xfs/880.out
 create mode 100755 tests/xfs/881
 create mode 100644 tests/xfs/881.out
 create mode 100755 tests/xfs/882
 create mode 100644 tests/xfs/882.out
 create mode 100755 tests/xfs/883
 create mode 100644 tests/xfs/883.out
 create mode 100755 tests/xfs/884
 create mode 100644 tests/xfs/884.out
 create mode 100755 tests/xfs/885
 create mode 100644 tests/xfs/885.out
 create mode 100755 tests/xfs/886
 create mode 100644 tests/xfs/886.out
 create mode 100755 tests/xfs/887
 create mode 100644 tests/xfs/887.out
 create mode 100755 tests/xfs/888
 create mode 100644 tests/xfs/888.out


diff --git a/tests/xfs/878 b/tests/xfs/878
new file mode 100644
index 0000000..b1f2672
--- /dev/null
+++ b/tests/xfs/878
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 878
+#
+# Set rrmapino to another inode on an non-rt rmap fs and see if repair fixes it.
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
+SCRATCH_RTDEV= USE_EXTERNAL= _scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+echo "Create some files"
+$XFS_IO_PROG -f -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f2 >> $seqres.full
+echo garbage > $SCRATCH_MNT/f3
+ino=$(stat -c '%i' $SCRATCH_MNT/f3)
+_scratch_unmount
+
+echo "Corrupt fs"
+$XFS_DB_PROG -x -c 'sb 0' -c "write rrmapino $ino" $SCRATCH_DEV >> $seqres.full
+_scratch_mount
+
+echo "Check files"
+md5sum $SCRATCH_MNT/f1 2>&1 | _filter_scratch
+
+echo "Try to create more files"
+$XFS_IO_PROG -f -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f3 >> $seqres.full 2>&1
+
+echo "Repair fs"
+_scratch_unmount 2>&1 | _filter_scratch
+$XFS_LOGPRINT_PROG -t $extra_log_options $device 2>&1 \
+		| tee $tmp.logprint | grep -q "<CLEAN>"
+if [ $? -ne 0 ]; then
+	echo "Dirty log, zeroing..." >> $seqres.full
+	_scratch_xfs_repair -L >> $seqres.full 2>&1
+else
+	_scratch_xfs_repair >> $seqres.full 2>&1
+fi
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "Try to create more files (again)"
+_scratch_mount
+$XFS_IO_PROG -f -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f4 >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/878.out b/tests/xfs/878.out
new file mode 100644
index 0000000..e134506
--- /dev/null
+++ b/tests/xfs/878.out
@@ -0,0 +1,9 @@
+QA output created by 878
+Format and mount
+Create some files
+Corrupt fs
+Check files
+8f27047948255cb84872e2dd7c0bc56d  SCRATCH_MNT/f1
+Try to create more files
+Repair fs
+Try to create more files (again)
diff --git a/tests/xfs/879 b/tests/xfs/879
new file mode 100755
index 0000000..0cbaf09
--- /dev/null
+++ b/tests/xfs/879
@@ -0,0 +1,67 @@
+#! /bin/bash
+# FS QA Test No. 879
+#
+# Ensure that we can create a few realtime files on a rmapbt filesystem.
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
+
+# real QA test starts here
+_supported_os Linux
+_require_realtime
+_require_xfs_scratch_rmapbt
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+echo "Create a few files"
+$XFS_IO_PROG -f -R -c 'pwrite -S 0x67 0 50000' -c fsync $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f -R -c 'pwrite -S 0x67 0 50000' -c fsync $SCRATCH_MNT/f2 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Grab contents"
+md5sum $SCRATCH_MNT/f1 $SCRATCH_MNT/f2 | _filter_scratch
+
+echo "Remove one file"
+rm -rf $SCRATCH_MNT/f2
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/879.out b/tests/xfs/879.out
new file mode 100644
index 0000000..9dfe48b
--- /dev/null
+++ b/tests/xfs/879.out
@@ -0,0 +1,7 @@
+QA output created by 879
+Format and mount
+Create a few files
+Grab contents
+10abe2628d19eb1c2ebe18aad7b14820  SCRATCH_MNT/f1
+10abe2628d19eb1c2ebe18aad7b14820  SCRATCH_MNT/f2
+Remove one file
diff --git a/tests/xfs/880 b/tests/xfs/880
new file mode 100755
index 0000000..2056097
--- /dev/null
+++ b/tests/xfs/880
@@ -0,0 +1,86 @@
+#! /bin/bash
+# FS QA Test No. 880
+#
+# Exercise expanding and shrinking the realtime rmap btree.
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
+
+# real QA test starts here
+_supported_os Linux
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_test_program "punch-alternating"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+blksz="$(stat -f $SCRATCH_MNT -c '%S')"
+isize=$(xfs_info $SCRATCH_MNT | grep isize | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g')
+
+echo "Create a three-level rtrmapbt"
+i_ptrs=$(( (isize - 176) / 56 ))
+bt_ptrs=$(( (blksz - 56) / 56 ))
+bt_recs=$(( (blksz - 56) / 32 ))
+
+blocks=$((i_ptrs * bt_ptrs * bt_recs))
+_require_fs_space $SCRATCH_MNT $(( (2 * blocks * blksz) * 5 / 4096 ))
+rtblksz=$(xfs_info $SCRATCH_MNT | grep '^realtime' | \
+		sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
+len=$((blocks * rtblksz))
+
+echo "Create big file"
+$XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f2 >> $seqres.full
+
+echo "Explode the rtrmapbt"
+./src/punch-alternating $SCRATCH_MNT/f1 >> "$seqres.full"
+./src/punch-alternating $SCRATCH_MNT/f2 >> "$seqres.full"
+_scratch_cycle_mount
+
+echo "Remove half the records"
+rm -rf $SCRATCH_MNT/f1
+_scratch_cycle_mount
+
+echo "Remove the rest of the records"
+rm -rf $SCRATCH_MNT/f2
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/880.out b/tests/xfs/880.out
new file mode 100644
index 0000000..b87665b
--- /dev/null
+++ b/tests/xfs/880.out
@@ -0,0 +1,7 @@
+QA output created by 880
+Format and mount
+Create a three-level rtrmapbt
+Create big file
+Explode the rtrmapbt
+Remove half the records
+Remove the rest of the records
diff --git a/tests/xfs/881 b/tests/xfs/881
new file mode 100755
index 0000000..c7474f5
--- /dev/null
+++ b/tests/xfs/881
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 881
+#
+# Exercise metadump on realtime rmapbt preservation.
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
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_test_program "punch-alternating"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+blksz="$(stat -f $SCRATCH_MNT -c '%S')"
+isize=$(xfs_info $SCRATCH_MNT | grep isize | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g')
+
+metadump_file=$TEST_DIR/${seq}_metadump
+rm -rf $metadump_file
+
+echo "Create a three-level rtrmapbt"
+i_ptrs=$(( (isize - 176) / 56 ))
+bt_ptrs=$(( (blksz - 56) / 56 ))
+bt_recs=$(( (blksz - 56) / 32 ))
+
+blocks=$((i_ptrs * bt_ptrs * bt_recs))
+_require_fs_space $SCRATCH_MNT $(( (2 * blocks * blksz) * 5 / 4096 ))
+rtblksz=$(xfs_info $SCRATCH_MNT | grep '^realtime' | \
+		sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
+len=$((blocks * rtblksz))
+
+echo "Create big file"
+$XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f2 >> $seqres.full
+
+echo "Explode the rtrmapbt"
+./src/punch-alternating $SCRATCH_MNT/f1 >> "$seqres.full"
+./src/punch-alternating $SCRATCH_MNT/f2 >> "$seqres.full"
+_scratch_cycle_mount
+
+echo "Create metadump file"
+_scratch_unmount
+_scratch_metadump $metadump_file
+
+# Now restore the obfuscated one back and take a look around
+echo "Restore metadump"
+xfs_mdrestore $metadump_file $TEST_DIR/image
+SCRATCH_DEV=$TEST_DIR/image _scratch_mount
+SCRATCH_DEV=$TEST_DIR/image _scratch_unmount
+
+echo "Check restored fs"
+_check_generic_filesystem $metadump_file
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/881.out b/tests/xfs/881.out
new file mode 100644
index 0000000..6ad156c
--- /dev/null
+++ b/tests/xfs/881.out
@@ -0,0 +1,8 @@
+QA output created by 881
+Format and mount
+Create a three-level rtrmapbt
+Create big file
+Explode the rtrmapbt
+Create metadump file
+Restore metadump
+Check restored fs
diff --git a/tests/xfs/882 b/tests/xfs/882
new file mode 100755
index 0000000..569a560
--- /dev/null
+++ b/tests/xfs/882
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 882
+#
+# Corrupt the realtime rmapbt and see how the kernel and xfs_repair deal.
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
+
+# real QA test starts here
+_supported_os Linux
+_require_realtime
+_require_xfs_scratch_rmapbt
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
+i_ptrs=$(( (isize - 176) / 56 ))
+bt_ptrs=$(( (blksz - 56) / 56 ))
+bt_recs=$(( (blksz - 56) / 32 ))
+
+blocks=$((i_ptrs * bt_ptrs * bt_recs + 1))
+_require_fs_space $SCRATCH_MNT $(( (2 * blocks * blksz) * 5 / 4096 ))
+len=$((blocks * blksz))
+
+echo "+ make some files"
+$XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f2 >> $seqres.full
+./src/punch-alternating $SCRATCH_MNT/f1 >> "$seqres.full"
+./src/punch-alternating $SCRATCH_MNT/f2 >> "$seqres.full"
+_scratch_unmount
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || echo "xfs_repair should not fail"
+
+echo "+ corrupt image"
+$XFS_DB_PROG -x -c "sb" -c "addr rrmapino" -c "addr u3.rtrmapbt.ptrs[1]" -c "stack" \
+	-c "blocktrash -x 4096 -y 4096 -n 8 -3 -z" $SCRATCH_DEV >> $seqres.full 2>&1
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ copy more"
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 1" $SCRATCH_MNT/e3 >> $seqres.full 2>&1
+test -s ${SCRATCH_MNT}/f3 && echo "should not be able to copy with busted rtrmap btree"
+_scratch_unmount
+
+echo "+ repair fs"
+$XFS_LOGPRINT_PROG -t $extra_log_options $device 2>&1 \
+		| tee $tmp.logprint | grep -q "<CLEAN>"
+if [ $? -ne 0 ]; then
+	echo "Dirty log, zeroing..." >> $seqres.full
+	_scratch_xfs_repair -L >> $seqres.full 2>&1
+else
+	_scratch_xfs_repair >> $seqres.full 2>&1
+fi
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ copy more (2)"
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 1" $SCRATCH_MNT/e4 >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/882.out b/tests/xfs/882.out
new file mode 100644
index 0000000..5ebe620
--- /dev/null
+++ b/tests/xfs/882.out
@@ -0,0 +1,11 @@
+QA output created by 882
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ copy more
++ repair fs
++ mount image (2)
++ copy more (2)
diff --git a/tests/xfs/883 b/tests/xfs/883
new file mode 100755
index 0000000..403ef35
--- /dev/null
+++ b/tests/xfs/883
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 883
+#
+# Set rrmapino to zero on an rtrmap fs and see if repair fixes it.
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
+_require_realtime
+_require_xfs_scratch_rmapbt
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+echo "Create some files"
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f2 >> $seqres.full
+_scratch_unmount
+
+echo "Corrupt fs"
+$XFS_DB_PROG -x -c 'sb 0' -c 'addr rrmapino' -c 'write core.nlinkv2 0' \
+	-c 'write core.mode 0' -c 'sb 0' -c 'write rrmapino 0' $SCRATCH_DEV >> $seqres.full
+_scratch_mount >> $seqres.full 2>&1 && echo "mount should have failed"
+
+echo "Check files"
+md5sum $SCRATCH_MNT/f1 2>&1 | _filter_scratch
+
+echo "Try to create more files"
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f3 >> $seqres.full 2>&1
+test -e $SCRATCH_MNT/f3 && echo "should not have been able to write f3"
+
+echo "Repair fs"
+_scratch_unmount 2>&1 | _filter_scratch
+$XFS_LOGPRINT_PROG -t $extra_log_options $device 2>&1 \
+		| tee $tmp.logprint | grep -q "<CLEAN>"
+if [ $? -ne 0 ]; then
+	echo "Dirty log, zeroing..." >> $seqres.full
+	_scratch_xfs_repair -L >> $seqres.full 2>&1
+else
+	_scratch_xfs_repair >> $seqres.full 2>&1
+fi
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "Try to create more files (again)"
+_scratch_mount
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f4 >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/883.out b/tests/xfs/883.out
new file mode 100644
index 0000000..6e75ac1
--- /dev/null
+++ b/tests/xfs/883.out
@@ -0,0 +1,10 @@
+QA output created by 883
+Format and mount
+Create some files
+Corrupt fs
+Check files
+md5sum: SCRATCH_MNT/f1: No such file or directory
+Try to create more files
+Repair fs
+umount: SCRATCH_DEV: not mounted
+Try to create more files (again)
diff --git a/tests/xfs/884 b/tests/xfs/884
new file mode 100755
index 0000000..ad648b8
--- /dev/null
+++ b/tests/xfs/884
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FS QA Test No. 884
+#
+# Link rrmapino into the rootdir on an rtrmap fs and see if repair fixes it.
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
+_require_realtime
+_require_xfs_scratch_rmapbt
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+echo "Create some files"
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f2 >> $seqres.full
+echo garbage > $SCRATCH_MNT/f3
+ln $SCRATCH_MNT/f3 $SCRATCH_MNT/f4
+_scratch_unmount
+
+echo "Corrupt fs"
+rrmapino=$($XFS_DB_PROG -c 'sb 0' -c 'p rrmapino' $SCRATCH_DEV | awk '{print $3}')
+$XFS_DB_PROG -x -c 'sb 0' -c 'addr rootino' \
+	-c "write u3.sfdir3.list[3].inumber.i4 $rrmapino" $SCRATCH_DEV >> $seqres.full
+_scratch_mount
+
+echo "Check files"
+md5sum $SCRATCH_MNT/f1 2>&1 | _filter_scratch
+
+echo "Try to create more files"
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f5 >> $seqres.full 2>&1
+
+echo "Repair fs"
+_scratch_unmount 2>&1 | _filter_scratch
+$XFS_LOGPRINT_PROG -t $extra_log_options $device 2>&1 \
+		| tee $tmp.logprint | grep -q "<CLEAN>"
+if [ $? -ne 0 ]; then
+	echo "Dirty log, zeroing..." >> $seqres.full
+	_scratch_xfs_repair -L >> $seqres.full 2>&1
+else
+	_scratch_xfs_repair >> $seqres.full 2>&1
+fi
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "Try to create more files (again)"
+_scratch_mount
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f4 >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/884.out b/tests/xfs/884.out
new file mode 100644
index 0000000..17a73ef
--- /dev/null
+++ b/tests/xfs/884.out
@@ -0,0 +1,9 @@
+QA output created by 884
+Format and mount
+Create some files
+Corrupt fs
+Check files
+8f27047948255cb84872e2dd7c0bc56d  SCRATCH_MNT/f1
+Try to create more files
+Repair fs
+Try to create more files (again)
diff --git a/tests/xfs/885 b/tests/xfs/885
new file mode 100755
index 0000000..b5880bd
--- /dev/null
+++ b/tests/xfs/885
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 885
+#
+# Set rrmapino to another inode on an rtrmap fs and see if repair fixes it.
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
+_require_realtime
+_require_xfs_scratch_rmapbt
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+echo "Create some files"
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f2 >> $seqres.full
+echo garbage > $SCRATCH_MNT/f3
+ino=$(stat -c '%i' $SCRATCH_MNT/f3)
+_scratch_unmount
+
+echo "Corrupt fs"
+rrmapino=$($XFS_DB_PROG -c 'sb 0' -c 'p rrmapino' $SCRATCH_DEV | awk '{print $3}')
+$XFS_DB_PROG -x -c "inode $rrmapino" -c 'write core.format 2' \
+	-c 'write core.size 0' -c 'write core.nblocks 0' \
+	-c 'sb 0' -c 'addr rootino' -c "write u3.sfdir3.list[2].inumber.i4 $rrmapino" \
+	-c 'sb 0' -c "write rrmapino $ino" $SCRATCH_DEV >> $seqres.full
+_scratch_mount >> $seqres.full 2>&1 && echo "mount should have failed"
+
+echo "Check files"
+md5sum $SCRATCH_MNT/f1 2>&1 | _filter_scratch
+
+echo "Try to create more files"
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f3 >> $seqres.full 2>&1
+test -e $SCRATCH_MNT/f3 && echo "should not have been able to write f3"
+
+echo "Repair fs"
+_scratch_unmount 2>&1 | _filter_scratch
+$XFS_LOGPRINT_PROG -t $extra_log_options $device 2>&1 \
+		| tee $tmp.logprint | grep -q "<CLEAN>"
+if [ $? -ne 0 ]; then
+	echo "Dirty log, zeroing..." >> $seqres.full
+	_scratch_xfs_repair -L >> $seqres.full 2>&1
+else
+	_scratch_xfs_repair >> $seqres.full 2>&1
+fi
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "Try to create more files (again)"
+_scratch_mount
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f4 >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/885.out b/tests/xfs/885.out
new file mode 100644
index 0000000..df04f79
--- /dev/null
+++ b/tests/xfs/885.out
@@ -0,0 +1,10 @@
+QA output created by 885
+Format and mount
+Create some files
+Corrupt fs
+Check files
+md5sum: SCRATCH_MNT/f1: No such file or directory
+Try to create more files
+Repair fs
+umount: SCRATCH_DEV: not mounted
+Try to create more files (again)
diff --git a/tests/xfs/886 b/tests/xfs/886
new file mode 100755
index 0000000..57edb3d
--- /dev/null
+++ b/tests/xfs/886
@@ -0,0 +1,104 @@
+#! /bin/bash
+# FS QA Test No. 886
+#
+# Cross-link rrmapino to another inode on an rtrmap fs and see if repair fixes it.
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
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_test_program "punch-alternating"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+blksz="$(stat -f $SCRATCH_MNT -c '%S')"
+isize=$(xfs_info $SCRATCH_MNT | grep isize | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g')
+
+i_ptrs=$(( (isize - 176) / 56 ))
+bt_recs=$(( (blksz - 56) / 32 ))
+
+blocks=$((i_ptrs * bt_recs + 1))
+rtblksz=$(xfs_info $SCRATCH_MNT | grep '^realtime' | \
+		sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
+len=$((blocks * rtblksz))
+
+echo "Create some files"
+$XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f2 >> $seqres.full
+./src/punch-alternating $SCRATCH_MNT/f1 >> "$seqres.full"
+./src/punch-alternating $SCRATCH_MNT/f2 >> "$seqres.full"
+echo garbage > $SCRATCH_MNT/f3
+ino=$(stat -c '%i' $SCRATCH_MNT/f3)
+_scratch_unmount
+
+echo "Corrupt fs"
+fsbno=$($XFS_DB_PROG -c "inode $ino" -c 'bmap' $SCRATCH_DEV | \
+	sed -e 's/^.*startblock \([0-9]*\) .*$/\1/g')
+
+$XFS_DB_PROG -x -c 'sb 0' -c 'addr rrmapino' -c "write u3.rtrmapbt.ptrs[1] $fsbno" \
+	-c 'p' $SCRATCH_DEV >> $seqres.full
+_scratch_mount
+
+echo "Try to create more files"
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f5 >> $seqres.full 2>&1
+test -e $SCRATCH_MNT/f5 && echo "should not have been able to write f5"
+
+echo "Repair fs"
+_scratch_unmount 2>&1 | _filter_scratch
+$XFS_LOGPRINT_PROG -t $extra_log_options $device 2>&1 \
+		| tee $tmp.logprint | grep -q "<CLEAN>"
+if [ $? -ne 0 ]; then
+	echo "Dirty log, zeroing..." >> $seqres.full
+	_scratch_xfs_repair -L >> $seqres.full 2>&1
+else
+	_scratch_xfs_repair >> $seqres.full 2>&1
+fi
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "Try to create more files (again)"
+_scratch_mount
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f4 >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/886.out b/tests/xfs/886.out
new file mode 100644
index 0000000..7f00c5d
--- /dev/null
+++ b/tests/xfs/886.out
@@ -0,0 +1,7 @@
+QA output created by 886
+Format and mount
+Create some files
+Corrupt fs
+Try to create more files
+Repair fs
+Try to create more files (again)
diff --git a/tests/xfs/887 b/tests/xfs/887
new file mode 100755
index 0000000..cdf2707
--- /dev/null
+++ b/tests/xfs/887
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 887
+#
+# Cross-link rrmapino to another inode on an rtrmap fs and see if repair fixes it.
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
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_test_program "punch-alternating"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+blksz="$(stat -f $SCRATCH_MNT -c '%S')"
+isize=$(xfs_info $SCRATCH_MNT | grep isize | sed -e 's/^.*isize=\([0-9]*\).*$/\1/g')
+
+i_ptrs=$(( (isize - 176) / 56 ))
+bt_recs=$(( (blksz - 56) / 32 ))
+
+blocks=$((i_ptrs * bt_recs + 1))
+rtblksz=$(xfs_info $SCRATCH_MNT | grep '^realtime' | \
+		sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g')
+len=$((blocks * rtblksz))
+
+echo "Create some files"
+$XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f2 >> $seqres.full
+./src/punch-alternating $SCRATCH_MNT/f1 >> "$seqres.full"
+./src/punch-alternating $SCRATCH_MNT/f2 >> "$seqres.full"
+echo garbage > $SCRATCH_MNT/f3
+ino=$(stat -c '%i' $SCRATCH_MNT/f3)
+_scratch_unmount
+
+echo "Corrupt fs"
+$XFS_DB_PROG -c 'sb 0' -c 'addr rrmapino' -c 'p u3.rtrmapbt.ptrs[1]' $SCRATCH_DEV >> $seqres.full
+
+fsbno=$($XFS_DB_PROG -c 'sb 0' -c 'addr rrmapino' -c 'p u3.rtrmapbt.ptrs[1]' \
+	$SCRATCH_DEV | sed -e 's/^.*://g')
+$XFS_DB_PROG -x -c "inode $ino" -c "write u3.bmx[0].startblock $fsbno" \
+	$SCRATCH_DEV >> $seqres.full
+_scratch_mount
+
+od -tx1 -Ad -c $SCRATCH_MNT/f3 >> $seqres.full
+
+echo "Try to create more files"
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f5 >> $seqres.full 2>&1
+test ! -e $SCRATCH_MNT/f5 && echo "should have been able to write f5"
+
+echo "Repair fs"
+_scratch_unmount 2>&1 | _filter_scratch
+$XFS_LOGPRINT_PROG -t $extra_log_options $device 2>&1 \
+		| tee $tmp.logprint | grep -q "<CLEAN>"
+if [ $? -ne 0 ]; then
+	echo "Dirty log, zeroing..." >> $seqres.full
+	_scratch_xfs_repair -L >> $seqres.full 2>&1
+else
+	_scratch_xfs_repair >> $seqres.full 2>&1
+fi
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "Try to create more files (again)"
+_scratch_mount
+$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 9999" $SCRATCH_MNT/f4 >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/887.out b/tests/xfs/887.out
new file mode 100644
index 0000000..30cf032
--- /dev/null
+++ b/tests/xfs/887.out
@@ -0,0 +1,7 @@
+QA output created by 887
+Format and mount
+Create some files
+Corrupt fs
+Try to create more files
+Repair fs
+Try to create more files (again)
diff --git a/tests/xfs/888 b/tests/xfs/888
new file mode 100755
index 0000000..15bec80
--- /dev/null
+++ b/tests/xfs/888
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test No. 888
+#
+# Basic rmap manipulation tests for realtime files.
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
+_require_realtime
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
+$XFS_IO_PROG -f -R -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
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
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/888.out b/tests/xfs/888.out
new file mode 100644
index 0000000..2587697
--- /dev/null
+++ b/tests/xfs/888.out
@@ -0,0 +1,6 @@
+QA output created by 888
+Format and mount
+Create some files
+Manipulate file
+Check file
+e45c5707fcf6817e914ffb6ce37a0ac7  SCRATCH_MNT/f1
diff --git a/tests/xfs/group b/tests/xfs/group
index f81f899..6fa2eb6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -311,3 +311,14 @@
 875 auto quick clone fsr quota
 876 auto quick rmap clone
 877 auto quick rmap clone
+878 auto quick rmap
+879 auto quick rmap
+880 auto quick rmap
+881 auto quick rmap
+882 fuzzers rmap
+883 auto quick rmap
+884 auto quick rmap
+885 auto quick rmap
+886 auto quick rmap
+887 auto quick rmap
+888 auto quick rmap

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
