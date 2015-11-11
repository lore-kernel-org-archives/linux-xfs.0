Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 369ED29E1F
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:28:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D9FEAAC002
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:28:04 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id FZpo7EvHwXSMMGiI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:28:02 -0800 (PST)
Subject: [PATCH 10/11] reflink: test what happens when we hit resource limits
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:27:37 -0800
Message-ID: <20151111192737.15056.44475.stgit@birch.djwong.org>
In-Reply-To: <20151111192628.15056.6451.stgit@birch.djwong.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
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
To: hch@infradead.org, david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

Add a few horrible opt-in stress tests to see what happens if we try
to reflink the same block billions of times, and what happens if we
run out of space while reflinking a file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/840     |   99 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/840.out |    0 
 tests/generic/841     |   81 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/841.out |    5 ++
 tests/generic/group   |    2 +
 5 files changed, 187 insertions(+)
 create mode 100755 tests/generic/840
 create mode 100644 tests/generic/840.out
 create mode 100755 tests/generic/841
 create mode 100644 tests/generic/841.out


diff --git a/tests/generic/840 b/tests/generic/840
new file mode 100755
index 0000000..137cc3d
--- /dev/null
+++ b/tests/generic/840
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. 840
+#
+# Try to hit the maximum reference count (eek!)
+#
+# This test runs extremely slowly, so it's not automatically run anywhere.
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
+    rm -rf "$tmp".* "$TESTDIR1"
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
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+# Well let's hope the maximum reflink count is (less than (ha!)) 2^32...
+
+echo "Create a one block file"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
+
+nr=32
+fnr=32
+for i in $(seq 0 $fnr); do
+	echo " ++ Reflink size $i, $(( (2 ** i) * BLKSZ)) bytes" | tee -a "$seqres.full"
+	n=$(( (2 ** i) * BLKSZ))
+	_reflink_range "$TESTDIR/file1" 0 "$TESTDIR/file1" $n $n >> "$seqres.full" || break
+done
+
+nrf=$((nr - fnr))
+echo "Clone $((2 ** nrf)) files"
+seq 0 $((2 ** nrf)) | while read i; do
+	_cp-reflink "$TESTDIR/file1" "$TESTDIR/file1-$i"
+done
+
+echo "Check scratch fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+echo "Remove big file and recheck"
+_scratch_mount >> "$seqres.full" 2>&1
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+echo "Remove all files and recheck"
+_scratch_mount >> "$seqres.full" 2>&1
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/840.out b/tests/generic/840.out
new file mode 100644
index 0000000..e69de29
diff --git a/tests/generic/841 b/tests/generic/841
new file mode 100755
index 0000000..b89dba4
--- /dev/null
+++ b/tests/generic/841
@@ -0,0 +1,81 @@
+#! /bin/bash
+# FS QA Test No. 841
+#
+# Try to run out of space while cloning?
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
+    rm -rf "$tmp".* "$TESTDIR1"
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
+_require_scratch_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+NR_FREE="$(stat -f -c '%f' "$TESTDIR")"
+echo "Create a big file"
+touch "$TESTDIR/file0" "$TESTDIR/file1"
+_pwrite_byte 0x61 0 $((BLKSZ * NR_FREE)) "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
+_scratch_remount
+sz="$(stat -c '%s' "$TESTDIR/bigfile")"
+
+blks="$((sz / BLKSZ))"
+echo "Try to reflink"
+seq 0 $blks | while read lblk; do
+	fname="$TESTDIR/file$((lblk % 2))"
+	out="$(_reflink_range "$TESTDIR/bigfile" $((lblk * BLKSZ)) "$fname" $((lblk * BLKSZ)) $BLKSZ 2>&1)"
+	echo "$fname: $out" >> "$seqres.full"
+	echo "$out" | grep -q "No space left on device" && break
+done
+
+echo "Check scratch fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/841.out b/tests/generic/841.out
new file mode 100644
index 0000000..33c46fd
--- /dev/null
+++ b/tests/generic/841.out
@@ -0,0 +1,5 @@
+QA output created by 841
+Format and mount
+Create a big file
+Try to reflink
+Check scratch fs
diff --git a/tests/generic/group b/tests/generic/group
index 90f28aa..eef608f 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -247,4 +247,6 @@
 837 auto quick clone
 838 auto quick clone
 839 auto quick clone
+840 clone_stress
+841 clone_stress
 846 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
