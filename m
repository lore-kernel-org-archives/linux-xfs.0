Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 874DC7CE8
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:29:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3EC5AC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:29:32 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id DCeU46HQmcAOpofW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:29:29 -0700 (PDT)
Subject: [PATCH 10/13] xfs: test getfsmap ioctl
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:29:24 -0700
Message-ID: <147216776414.32641.43424679167210633.stgit@birch.djwong.org>
In-Reply-To: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
References: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Add some simple tests for the new getfsmap ioctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc         |    6 +++
 tests/xfs/889     |   82 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/889.out |   13 +++++++
 tests/xfs/890     |   84 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/890.out |    6 +++
 tests/xfs/891     |   65 ++++++++++++++++++++++++++++++++++++
 tests/xfs/891.out |    3 ++
 tests/xfs/892     |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/892.out |    7 ++++
 tests/xfs/893     |   68 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/893.out |    4 ++
 tests/xfs/894     |   85 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/894.out |    6 +++
 tests/xfs/895     |   68 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/895.out |    4 ++
 tests/xfs/group   |    7 ++++
 16 files changed, 603 insertions(+)
 create mode 100755 tests/xfs/889
 create mode 100644 tests/xfs/889.out
 create mode 100755 tests/xfs/890
 create mode 100644 tests/xfs/890.out
 create mode 100755 tests/xfs/891
 create mode 100644 tests/xfs/891.out
 create mode 100755 tests/xfs/892
 create mode 100644 tests/xfs/892.out
 create mode 100755 tests/xfs/893
 create mode 100644 tests/xfs/893.out
 create mode 100755 tests/xfs/894
 create mode 100644 tests/xfs/894.out
 create mode 100755 tests/xfs/895
 create mode 100644 tests/xfs/895.out


diff --git a/common/rc b/common/rc
index 3b706dd..40e9858 100644
--- a/common/rc
+++ b/common/rc
@@ -2039,6 +2039,12 @@ _require_xfs_io_command()
 		echo $testio | egrep -q "invalid option|Is a directory" && \
 			_notrun "xfs_io $command support is missing"
 		;;
+	"fsmap" )
+		testio=`$XFS_IO_PROG -T -F -c "fsmap" \
+			$TEST_DIR 2>&1`
+		echo $testio | egrep -q "Inappropriate ioctl" && \
+			_notrun "xfs_io $command support is missing"
+		;;
 	*)
 		testio=`$XFS_IO_PROG -c "$command help" 2>&1`
 	esac
diff --git a/tests/xfs/889 b/tests/xfs/889
new file mode 100755
index 0000000..49f3a7b
--- /dev/null
+++ b/tests/xfs/889
@@ -0,0 +1,82 @@
+#! /bin/bash
+# FS QA Test No. 889
+#
+# Check that getfsmap reports the AG metadata we're expecting.
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
+	rm -rf "$tmp".* $TEST_DIR/fsmap $TEST_DIR/testout
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fsmap"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+agcount=$(xfs_info $SCRATCH_MNT | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')
+
+echo "Get fsmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT > $TEST_DIR/fsmap
+cat $TEST_DIR/fsmap >> $seqres.full
+
+echo "Check AG header" | tee -a $seqres.full
+grep 'static fs metadata[[:space:]]*[0-9]*[[:space:]]*(0\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
+_within_tolerance "AG header count" $(wc -l < $TEST_DIR/testout) $agcount 0 -v
+
+echo "Check freesp/rmap btrees" | tee -a $seqres.full
+grep 'per-AG metadata[[:space:]]*[0-9]*[[:space:]]*([0-9]*\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
+_within_tolerance "freesp extent count" $(wc -l < $TEST_DIR/testout) $((agcount * 3)) 0 999999 -v
+
+echo "Check inode btrees" | tee -a $seqres.full
+grep 'inode btree[[:space:]]*[0-9]*[[:space:]]*([0-9]*\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
+_within_tolerance "inode btree extent count" $(wc -l < $TEST_DIR/testout) $agcount 0 -v
+
+echo "Check inodes" | tee -a $seqres.full
+grep 'inodes[[:space:]]*[0-9]*[[:space:]]*([0-9]*\.\.' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
+_within_tolerance "inode extent count" $(wc -l < $TEST_DIR/testout) 1 0 999999 -v
+
+echo "Check journal" | tee -a $seqres.full
+grep 'journalling log' $TEST_DIR/fsmap | tee -a $seqres.full > $TEST_DIR/testout
+_within_tolerance "journal extent count" $(wc -l < $TEST_DIR/testout) 1 0 -v
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/889.out b/tests/xfs/889.out
new file mode 100644
index 0000000..3d2dc3e
--- /dev/null
+++ b/tests/xfs/889.out
@@ -0,0 +1,13 @@
+QA output created by 889
+Format and mount
+Get fsmap
+Check AG header
+AG header count is in range
+Check freesp/rmap btrees
+freesp extent count is in range
+Check inode btrees
+inode btree extent count is in range
+Check inodes
+inode extent count is in range
+Check journal
+journal extent count is in range
diff --git a/tests/xfs/890 b/tests/xfs/890
new file mode 100755
index 0000000..e4f83a5
--- /dev/null
+++ b/tests/xfs/890
@@ -0,0 +1,84 @@
+#! /bin/bash
+# FS QA Test No. 890
+#
+# Check that getfsmap agrees with getbmap.
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
+	rm -rf "$tmp".* $TEST_DIR/fsmap $TEST_DIR/bmap
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fsmap"
+_require_test_program "punch-alternating"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+_pwrite_byte 0x80 0 737373 $SCRATCH_MNT/urk >> $seqres.full
+sync
+./src/punch-alternating $SCRATCH_MNT/urk >> $seqres.full
+ino=$(stat -c '%i' $SCRATCH_MNT/urk)
+
+echo "Get fsmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
+
+echo "Get bmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/urk >> $seqres.full
+$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/urk | grep '^[[:space:]]*[0-9]*:' | grep -v 'hole' | tr '[]()' '    ' > $TEST_DIR/bmap
+
+echo "Check bmap and fsmap" | tee -a $seqres.full
+cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
+	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total}$"
+	echo "${qstr}" >> $seqres.full
+	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+	found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+done
+
+echo "Check device field of FS metadata and regular file"
+data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+test "${data_dev}" = "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/890.out b/tests/xfs/890.out
new file mode 100644
index 0000000..962050a
--- /dev/null
+++ b/tests/xfs/890.out
@@ -0,0 +1,6 @@
+QA output created by 890
+Format and mount
+Get fsmap
+Get bmap
+Check bmap and fsmap
+Check device field of FS metadata and regular file
diff --git a/tests/xfs/891 b/tests/xfs/891
new file mode 100755
index 0000000..c2abaaf
--- /dev/null
+++ b/tests/xfs/891
@@ -0,0 +1,65 @@
+#! /bin/bash
+# FS QA Test No. 891
+#
+# Populate filesystem, check that fsmap -n10000 matches fsmap -n1.
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
+	rm -rf "$tmp".* $TEST_DIR/a $TEST_DIR/b
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/populate
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch
+_require_xfs_io_command "fsmap"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_populate >> $seqres.full
+
+echo "Compare fsmap" | tee -a $seqres.full
+_scratch_mount
+$XFS_IO_PROG -c 'fsmap -v -n 65536' $SCRATCH_MNT | grep -v 'EXT:' > $TEST_DIR/a
+$XFS_IO_PROG -c 'fsmap -v -n 1' $SCRATCH_MNT | grep -v 'EXT:' > $TEST_DIR/b
+cat $TEST_DIR/a $TEST_DIR/b >> $seqres.full
+
+diff -uw $TEST_DIR/a $TEST_DIR/b
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/891.out b/tests/xfs/891.out
new file mode 100644
index 0000000..c0d8d42
--- /dev/null
+++ b/tests/xfs/891.out
@@ -0,0 +1,3 @@
+QA output created by 891
+Format and mount
+Compare fsmap
diff --git a/tests/xfs/892 b/tests/xfs/892
new file mode 100755
index 0000000..9241474
--- /dev/null
+++ b/tests/xfs/892
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 892
+#
+# Check that getfsmap agrees with getbmap for reflinked files.
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
+	rm -rf "$tmp".* $TEST_DIR/fsmap $TEST_DIR/bmap
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
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fsmap"
+_require_test_program "punch-alternating"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+_pwrite_byte 0x80 0 737373 $SCRATCH_MNT/f1 >> $seqres.full
+sync
+./src/punch-alternating $SCRATCH_MNT/f1 >> $seqres.full
+_cp_reflink $SCRATCH_MNT/f1 $SCRATCH_MNT/f2
+ino=$(stat -c '%i' $SCRATCH_MNT/f1)
+
+echo "Get fsmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
+
+echo "Get f1 bmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f1 | grep '^[[:space:]]*[0-9]*:' | grep -v 'hole' | tr '[]()' '    ' > $TEST_DIR/bmap
+
+echo "Check f1 bmap and fsmap" | tee -a $seqres.full
+cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
+	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 1000000$"
+	echo "${qstr}" >> $seqres.full
+	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+	found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+done
+
+echo "Get f2 bmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f2 >> $seqres.full
+$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/f2 | grep '^[[:space:]]*[0-9]*:' | grep -v 'hole' | tr '[]()' '    ' > $TEST_DIR/bmap
+
+echo "Check f2 bmap and fsmap" | tee -a $seqres.full
+cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
+	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total} 1000000$"
+	echo "${qstr}" >> $seqres.full
+	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+	found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/892.out b/tests/xfs/892.out
new file mode 100644
index 0000000..edcffb3
--- /dev/null
+++ b/tests/xfs/892.out
@@ -0,0 +1,7 @@
+QA output created by 892
+Format and mount
+Get fsmap
+Get f1 bmap
+Check f1 bmap and fsmap
+Get f2 bmap
+Check f2 bmap and fsmap
diff --git a/tests/xfs/893 b/tests/xfs/893
new file mode 100755
index 0000000..d0bcf2e
--- /dev/null
+++ b/tests/xfs/893
@@ -0,0 +1,68 @@
+#! /bin/bash
+# FS QA Test No. 893
+#
+# Check that getfsmap reports external log devices
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
+	rm -rf "$tmp".* $TEST_DIR/fsmap $TEST_DIR/testout
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch
+_require_xfs_io_command "fsmap"
+if [ "$USE_EXTERNAL" != "yes" ] || [ -z "$SCRATCH_LOGDEV" ]; then
+	_notrun "Need external log device"
+fi
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+echo "Get fsmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
+
+echo "Check device field of FS metadata and journalling log"
+data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+journal_dev=$(grep 'journalling log' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+test "${data_dev}" != "${journal_dev}" || echo "data ${data_dev} journal ${journal_dev}?"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/893.out b/tests/xfs/893.out
new file mode 100644
index 0000000..2f1ccae
--- /dev/null
+++ b/tests/xfs/893.out
@@ -0,0 +1,4 @@
+QA output created by 893
+Format and mount
+Get fsmap
+Check device field of FS metadata and journalling log
diff --git a/tests/xfs/894 b/tests/xfs/894
new file mode 100755
index 0000000..f5bb5f5
--- /dev/null
+++ b/tests/xfs/894
@@ -0,0 +1,85 @@
+#! /bin/bash
+# FS QA Test No. 894
+#
+# Check that getfsmap agrees with getbmap when realtime files are present.
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
+	rm -rf "$tmp".* $TEST_DIR/fsmap $TEST_DIR/bmap
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_realtime
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fsmap"
+_require_test_program "punch-alternating"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+$XFS_IO_PROG -f -R -c 'pwrite -S 0x80 0 737373' $SCRATCH_MNT/urk >> $seqres.full
+sync
+./src/punch-alternating $SCRATCH_MNT/urk >> $seqres.full
+ino=$(stat -c '%i' $SCRATCH_MNT/urk)
+
+echo "Get fsmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
+
+echo "Get bmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/urk >> $seqres.full
+$XFS_IO_PROG -c 'bmap -v' $SCRATCH_MNT/urk | grep '^[[:space:]]*[0-9]*:' | grep -v 'hole' | tr '[]()' '    ' > $TEST_DIR/bmap
+
+echo "Check bmap and fsmap" | tee -a $seqres.full
+cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total crap; do
+	qstr="^[[:space:]]*[0-9]*:[[:space:]]*[0-9]*:[0-9]*[[:space:]]*${blockrange} :[[:space:]]*${ino}[[:space:]]*${offrange}[[:space:]]*${ag}[[:space:]]*${agrange}[[:space:]]*${total}$"
+	echo "${qstr}" >> $seqres.full
+	grep "${qstr}" $TEST_DIR/fsmap >> $seqres.full
+	found=$(grep -c "${qstr}" $TEST_DIR/fsmap)
+	test $found -eq 1 || echo "Unexpected output for offset ${offrange}."
+done
+
+echo "Check device field of FS metadata and realtime file"
+data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+test "${data_dev}" != "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/894.out b/tests/xfs/894.out
new file mode 100644
index 0000000..a1eb886
--- /dev/null
+++ b/tests/xfs/894.out
@@ -0,0 +1,6 @@
+QA output created by 894
+Format and mount
+Get fsmap
+Get bmap
+Check bmap and fsmap
+Check device field of FS metadata and realtime file
diff --git a/tests/xfs/895 b/tests/xfs/895
new file mode 100755
index 0000000..7dc9cf4
--- /dev/null
+++ b/tests/xfs/895
@@ -0,0 +1,68 @@
+#! /bin/bash
+# FS QA Test No. 895
+#
+# Check that getfsmap reports internal log devices
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
+	rm -rf "$tmp".* $TEST_DIR/fsmap $TEST_DIR/testout
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fsmap"
+if [ "$USE_EXTERNAL" = "yes" ] && [ -n "$SCRATCH_LOGDEV" ]; then
+	_notrun "Cannot have external log device"
+fi
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+
+echo "Get fsmap" | tee -a $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
+
+echo "Check device field of FS metadata and journalling log"
+data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+journal_dev=$(grep 'journalling log' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+test "${data_dev}" = "${journal_dev}" || echo "data ${data_dev} journal ${journal_dev}?"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/895.out b/tests/xfs/895.out
new file mode 100644
index 0000000..007eeba
--- /dev/null
+++ b/tests/xfs/895.out
@@ -0,0 +1,4 @@
+QA output created by 895
+Format and mount
+Get fsmap
+Check device field of FS metadata and journalling log
diff --git a/tests/xfs/group b/tests/xfs/group
index 1b0e22a..6d349dc 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -324,3 +324,10 @@
 886 auto quick rmap
 887 auto quick rmap
 888 auto quick rmap
+889 auto quick rmap fsmap
+890 auto quick rmap fsmap
+891 auto rmap fsmap
+892 auto quick rmap fsmap
+893 auto quick rmap fsmap
+894 auto quick rmap fsmap
+895 auto quick rmap fsmap

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
