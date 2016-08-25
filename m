Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A94977CB3
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:29:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2E6AAC004
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:29:11 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id yRJqpuxlPys0UMlM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:29:09 -0700 (PDT)
Subject: [PATCH 07/13] xfs: test swapext with reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:29:03 -0700
Message-ID: <147216774386.32641.14276663608220751384.stgit@birch.djwong.org>
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

Add a few tests to stress the new swapext code for reflink and rmap.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/873     |  108 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/873.out |    6 +++
 tests/xfs/874     |   97 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/874.out |   10 +++++
 tests/xfs/875     |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/875.out |   12 ++++++
 tests/xfs/group   |    3 +
 7 files changed, 338 insertions(+)
 create mode 100755 tests/xfs/873
 create mode 100644 tests/xfs/873.out
 create mode 100755 tests/xfs/874
 create mode 100644 tests/xfs/874.out
 create mode 100755 tests/xfs/875
 create mode 100644 tests/xfs/875.out


diff --git a/tests/xfs/873 b/tests/xfs/873
new file mode 100755
index 0000000..75334c6
--- /dev/null
+++ b/tests/xfs/873
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 873
+#
+# See how well xfs_fsr handles "defragging" a file with a hojillion extents.
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
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+_require_test_program "punch-alternating"
+_require_command "$XFS_FSR_PROG" "xfs_fsr"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+mkdir "$testdir"
+
+# Setup for 16000 blocks, but we'll accept stress testing down to
+# 2^10 blocks... that should be plenty for anyone.
+fnr=$((12 + LOAD_FACTOR))
+free_blocks=$(stat -f -c '%a' "$testdir")
+blksz=$(stat -f -c '%S' "$testdir")
+space_avail=$((free_blocks * blksz))
+calc_space() {
+	blocks_needed=$(( 2 ** (fnr + 1) ))
+	space_needed=$((blocks_needed * blksz * 5 / 4))
+}
+calc_space
+while test $space_needed -gt $space_avail; do
+	fnr=$((fnr - 1))
+	calc_space
+done
+test $fnr -lt 10 && _notrun "Insufficient space for stress test; would only create $blocks_needed extents."
+bytes=$((blocks_needed * blksz))
+
+echo "Create a many-block file"
+echo "creating $blocks_needed blocks..." >> "$seqres.full"
+_pwrite_byte 0x62 0 $blksz $testdir/file0 >> $seqres.full
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b 4194304 0 $bytes" "$testdir/file1" >> "$seqres.full"
+echo "punching..." >> "$seqres.full"
+"$here/src/punch-alternating" "$testdir/file1" >> "$seqres.full"
+seq 0 2 $((2 ** (fnr + 1) )) | while read lblk; do
+	_reflink_range $testdir/file0 0 $testdir/file1 $((lblk * blksz)) $blksz >> $seqres.full
+done
+echo "...done" >> "$seqres.full"
+_scratch_cycle_mount
+
+echo "Reflink the big file"
+echo "reflinking $((blocks_needed / 2)) blocks, $((bytes / 2)) bytes" >> "$seqres.full"
+_reflink_range "$testdir/file1" 0 "$testdir/file2" 0 $bytes >> "$seqres.full"
+
+echo "Defrag the big file"
+old_nextents=$(_count_extents $testdir/file1)
+$XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full
+new_nextents=$(_count_extents $testdir/file1)
+
+echo "Check extent count"
+$XFS_IO_PROG -c 'stat -v' $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -c 'stat -v' $testdir/file2 >> $seqres.full
+echo "extents: $old_nextents -> $new_nextents" >> $seqres.full
+test $old_nextents -gt $new_nextents || echo "FAIL: $old_nextents -> $new_nextents"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/873.out b/tests/xfs/873.out
new file mode 100644
index 0000000..9dddf55
--- /dev/null
+++ b/tests/xfs/873.out
@@ -0,0 +1,6 @@
+QA output created by 873
+Format and mount
+Create a many-block file
+Reflink the big file
+Defrag the big file
+Check extent count
diff --git a/tests/xfs/874 b/tests/xfs/874
new file mode 100755
index 0000000..2e799ce
--- /dev/null
+++ b/tests/xfs/874
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. 874
+#
+# Ensure that xfs_fsr handles errors correctly while defragging files.
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
+. ./common/inject
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+_require_command "$XFS_FSR_PROG" "xfs_fsr"
+_require_xfs_io_error_injection "bmap_finish_one"
+_require_xfs_scratch_rmapbt
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+blksz=65536
+blks=3
+mkdir "$testdir"
+
+echo "Create a many-block file"
+_pwrite_byte 0x62 0 $((blksz * blks)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 0 $blksz $testdir/file2 >> $seqres.full
+_reflink_range $testdir/file2 0 $testdir/file1 $blksz $blksz >> $seqres.full
+_scratch_cycle_mount
+$XFS_IO_PROG -c 'bmap -v' $testdir/file1 >> $seqres.full
+
+echo "Inject error"
+_scratch_inject_error "bmap_finish_one"
+
+echo "Defrag the file"
+old_nextents=$(_count_extents $testdir/file1)
+$XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full 2>&1
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log" | tee /dev/ttyprintk
+_scratch_inject_logprint >> $seqres.full
+new_nextents=$(_count_extents $testdir/file1)
+
+echo "Check extent count" | tee /dev/ttyprintk
+$XFS_IO_PROG -c 'stat -v' $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -c 'stat -v' $testdir/file2 >> $seqres.full
+echo "extents: $old_nextents -> $new_nextents" >> $seqres.full
+
+echo "FS should be online, touch should succeed"
+touch $SCRATCH_MNT/goodfs
+$XFS_IO_PROG -c 'bmap -v' $testdir/file1 >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/874.out b/tests/xfs/874.out
new file mode 100644
index 0000000..dbc0f49
--- /dev/null
+++ b/tests/xfs/874.out
@@ -0,0 +1,10 @@
+QA output created by 874
+Format and mount
+Create a many-block file
+Inject error
+Defrag the file
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+Check extent count
+FS should be online, touch should succeed
diff --git a/tests/xfs/875 b/tests/xfs/875
new file mode 100755
index 0000000..d579ba1
--- /dev/null
+++ b/tests/xfs/875
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 875
+#
+# Ensure that xfs_fsr handles quota correctly while defragging files.
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
+. ./common/quota
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+_require_command "$XFS_FSR_PROG" "xfs_fsr"
+_require_quota
+_require_nobody
+
+do_repquota()
+{
+	repquota $SCRATCH_MNT | egrep '^(fsgqa|root|nobody)'
+}
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+export MOUNT_OPTIONS="-o usrquota,grpquota $MOUNT_OPTIONS"
+_scratch_mount >> "$seqres.full" 2>&1
+quotacheck -u -g $SCRATCH_MNT 2> /dev/null
+quotaon $SCRATCH_MNT 2> /dev/null
+
+testdir="$SCRATCH_MNT/test-$seq"
+blksz=65536
+blks=3
+mkdir "$testdir"
+
+echo "Create a many-block file"
+touch $testdir/file1
+chown nobody $testdir/file1
+touch $testdir/file2
+chown nobody $testdir/file2
+_pwrite_byte 0x62 0 $((blksz * blks)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 0 $blksz $testdir/file2 >> $seqres.full
+_reflink_range $testdir/file2 0 $testdir/file1 $blksz $blksz >> $seqres.full
+do_repquota
+_scratch_cycle_mount
+
+echo "Defrag the file"
+old_nextents=$(_count_extents $testdir/file1)
+$XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full
+new_nextents=$(_count_extents $testdir/file1)
+do_repquota
+
+echo "Remount the FS to see if accounting changes"
+_scratch_cycle_mount
+do_repquota
+
+echo "Check extent count"
+$XFS_IO_PROG -c 'stat -v' $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -c 'stat -v' $testdir/file2 >> $seqres.full
+echo "extents: $old_nextents -> $new_nextents" >> $seqres.full
+test $old_nextents -gt $new_nextents || echo "FAIL: $old_nextents -> $new_nextents"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/875.out b/tests/xfs/875.out
new file mode 100644
index 0000000..57653e9
--- /dev/null
+++ b/tests/xfs/875.out
@@ -0,0 +1,12 @@
+QA output created by 875
+Format and mount
+Create a many-block file
+root      --       0       0       0              4     0     0       
+nobody    --     256       0       0              2     0     0       
+Defrag the file
+root      --       0       0       0              4     0     0       
+nobody    --     256       0       0              2     0     0       
+Remount the FS to see if accounting changes
+root      --       0       0       0              4     0     0       
+nobody    --     256       0       0              2     0     0       
+Check extent count
diff --git a/tests/xfs/group b/tests/xfs/group
index 6905a62..8565204 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -308,3 +308,6 @@
 325 auto quick clone
 326 auto quick clone
 327 auto quick clone
+873 auto quick clone fsr
+874 auto quick clone fsr
+875 auto quick clone fsr quota

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
