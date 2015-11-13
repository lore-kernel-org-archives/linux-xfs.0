Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECAFC7F5E
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 15:38:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 958358F8033
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:38:30 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id LAknARALzYLmMuoa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:38:27 -0800 (PST)
Subject: [PATCH 11/12] reflink: test that CoW writes fail when we're out of
	space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 13 Nov 2015 13:37:55 -0800
Message-ID: <20151113213755.31124.31309.stgit@birch.djwong.org>
In-Reply-To: <20151113213643.31124.80975.stgit@birch.djwong.org>
References: <20151113213643.31124.80975.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

Ensure that copy-on-writing a reflinked file when there's no free disk
space reflects the desired ENOSPC back to userspace during the write
call.  Tests the buffered IO, direct IO, and mmap write paths.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/171     |  107 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/171.out |   10 ++++
 tests/generic/172     |  107 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/172.out |   10 ++++
 tests/generic/173     |  109 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/173.out |    8 ++++
 tests/generic/174     |  107 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/174.out |   10 ++++
 tests/generic/group   |    4 ++
 9 files changed, 472 insertions(+)
 create mode 100755 tests/generic/171
 create mode 100644 tests/generic/171.out
 create mode 100755 tests/generic/172
 create mode 100644 tests/generic/172.out
 create mode 100755 tests/generic/173
 create mode 100644 tests/generic/173.out
 create mode 100755 tests/generic/174
 create mode 100644 tests/generic/174.out


diff --git a/tests/generic/171 b/tests/generic/171
new file mode 100755
index 0000000..99e4d5e
--- /dev/null
+++ b/tests/generic/171
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 171
+#
+# Reflink a file, use up the rest of the space, then try to observe ENOSPC
+# while copy-on-writing the file via the page cache.
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
+echo "Reformat with appropriate size"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+NR_BLKS=10240
+umount "$SCRATCH_MNT"
+SZ_BYTES=$((NR_BLKS * 8 * BLKSZ))
+if [ $SZ_BYTES -lt $((32 * 1048576)) ]; then
+	SZ_BYTES=$((32 * 1048576))
+fi
+_scratch_mkfs_sized $SZ_BYTES >> "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create a big file and reflink it"
+_pwrite_byte 0x61 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
+_cp_reflink "$TESTDIR/bigfile" "$TESTDIR/clonefile"
+sync
+
+echo "Allocate the rest of the space"
+NR_FREE="$(stat -f -c '%f' "$TESTDIR")"
+touch "$TESTDIR/file0" "$TESTDIR/file1"
+_pwrite_byte 0x61 0 $((BLKSZ * NR_FREE)) "$TESTDIR/eat_my_space" >> "$seqres.full" 2>&1
+sync
+
+echo "CoW the big file"
+out="$(_pwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" 2>&1)"
+echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> "$seqres.full" 2>&1
+echo "${out}"
+
+echo "Remount and try CoW again"
+_scratch_remount
+
+out="$(_pwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" 2>&1)"
+echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> "$seqres.full" 2>&1
+echo "${out}"
+
+#filefrag -v $TESTDIR/bigfile
+#filefrag -v $TESTDIR/clonefile
+
+echo "Check scratch fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/171.out b/tests/generic/171.out
new file mode 100644
index 0000000..c2b0ddd
--- /dev/null
+++ b/tests/generic/171.out
@@ -0,0 +1,10 @@
+QA output created by 171
+Format and mount
+Reformat with appropriate size
+Create a big file and reflink it
+Allocate the rest of the space
+CoW the big file
+pwrite64: No space left on device
+Remount and try CoW again
+pwrite64: No space left on device
+Check scratch fs
diff --git a/tests/generic/172 b/tests/generic/172
new file mode 100755
index 0000000..eb00f0a
--- /dev/null
+++ b/tests/generic/172
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 172
+#
+# Reflink a file that uses more than half of the space, then try to observe
+# ENOSPC while copy-on-writing the file via the page cache.
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
+echo "Reformat with appropriate size"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+NR_BLKS=10240
+umount "$SCRATCH_MNT"
+SZ_BYTES=$((NR_BLKS * 3 / 2 * BLKSZ))
+if [ $SZ_BYTES -lt $((32 * 1048576)) ]; then
+	SZ_BYTES=$((32 * 1048576))
+fi
+_scratch_mkfs_sized $SZ_BYTES >> "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create a big file and reflink it"
+_pwrite_byte 0x61 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
+_cp_reflink "$TESTDIR/bigfile" "$TESTDIR/clonefile"
+sync
+
+echo "Allocate the rest of the space"
+NR_FREE="$(stat -f -c '%f' "$TESTDIR")"
+touch "$TESTDIR/file0" "$TESTDIR/file1"
+_pwrite_byte 0x61 0 $((BLKSZ * NR_FREE)) "$TESTDIR/eat_my_space" >> "$seqres.full" 2>&1
+sync
+
+echo "CoW the big file"
+out="$(_pwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" 2>&1)"
+echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> "$seqres.full" 2>&1
+echo "${out}"
+
+echo "Remount and try CoW again"
+_scratch_remount
+
+out="$(_pwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" 2>&1)"
+echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> "$seqres.full" 2>&1
+echo "${out}"
+
+#filefrag -v $TESTDIR/bigfile
+#filefrag -v $TESTDIR/clonefile
+
+echo "Check scratch fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/172.out b/tests/generic/172.out
new file mode 100644
index 0000000..3913dd7
--- /dev/null
+++ b/tests/generic/172.out
@@ -0,0 +1,10 @@
+QA output created by 172
+Format and mount
+Reformat with appropriate size
+Create a big file and reflink it
+Allocate the rest of the space
+CoW the big file
+pwrite64: No space left on device
+Remount and try CoW again
+pwrite64: No space left on device
+Check scratch fs
diff --git a/tests/generic/173 b/tests/generic/173
new file mode 100755
index 0000000..76463d2
--- /dev/null
+++ b/tests/generic/173
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. 173
+#
+# Reflink a file, use up the rest of the space, then try to observe ENOSPC
+# while copy-on-writing the file via mmap.
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
+echo "Reformat with appropriate size"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+NR_BLKS=10240
+umount "$SCRATCH_MNT"
+SZ_BYTES=$((NR_BLKS * 8 * BLKSZ))
+if [ $SZ_BYTES -lt $((32 * 1048576)) ]; then
+	SZ_BYTES=$((32 * 1048576))
+fi
+_scratch_mkfs_sized $SZ_BYTES >> "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create a big file and reflink it"
+_pwrite_byte 0x61 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
+_cp_reflink "$TESTDIR/bigfile" "$TESTDIR/clonefile"
+sync
+
+echo "Allocate the rest of the space"
+NR_FREE="$(stat -f -c '%f' "$TESTDIR")"
+touch "$TESTDIR/file0" "$TESTDIR/file1"
+_pwrite_byte 0x61 0 $((BLKSZ * NR_FREE)) "$TESTDIR/eat_my_space" >> "$seqres.full" 2>&1
+sync
+
+echo "mmap CoW the big file"
+out="$(_mwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" 2>&1)"
+err="$?"
+if [ "$err" -lt 128 ]; then
+	echo "mmap CoW should have failed with SIGBUS, got SIG$(kill -l $err)"
+fi
+
+echo "Remount and try CoW again"
+_scratch_remount
+
+out="$(_mwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" 2>&1)"
+err="$?"
+if [ "$err" -lt 128 ]; then
+	echo "mmap CoW should have failed with SIGBUS, got SIG$(kill -l $err)"
+fi
+
+#filefrag -v $TESTDIR/bigfile
+#filefrag -v $TESTDIR/clonefile
+
+echo "Check scratch fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/173.out b/tests/generic/173.out
new file mode 100644
index 0000000..49abb17
--- /dev/null
+++ b/tests/generic/173.out
@@ -0,0 +1,8 @@
+QA output created by 173
+Format and mount
+Reformat with appropriate size
+Create a big file and reflink it
+Allocate the rest of the space
+mmap CoW the big file
+Remount and try CoW again
+Check scratch fs
diff --git a/tests/generic/174 b/tests/generic/174
new file mode 100755
index 0000000..8df292a
--- /dev/null
+++ b/tests/generic/174
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 174
+#
+# Reflink a file, use up the rest of the space, then try to observe ENOSPC
+# while copy-on-writing the file via direct-io.
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
+echo "Reformat with appropriate size"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+NR_BLKS=10240
+umount "$SCRATCH_MNT"
+SZ_BYTES=$((NR_BLKS * 8 * BLKSZ))
+if [ $SZ_BYTES -lt $((32 * 1048576)) ]; then
+	SZ_BYTES=$((32 * 1048576))
+fi
+_scratch_mkfs_sized $SZ_BYTES >> "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create a big file and reflink it"
+_pwrite_byte 0x61 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
+_cp_reflink "$TESTDIR/bigfile" "$TESTDIR/clonefile"
+sync
+
+echo "Allocate the rest of the space"
+NR_FREE="$(stat -f -c '%f' "$TESTDIR")"
+touch "$TESTDIR/file0" "$TESTDIR/file1"
+_pwrite_byte 0x61 0 $((BLKSZ * NR_FREE)) "$TESTDIR/eat_my_space" >> "$seqres.full" 2>&1
+sync
+
+echo "CoW the big file"
+out="$(_pwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" -d 2>&1)"
+echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> "$seqres.full" 2>&1
+echo "${out}"
+
+echo "Remount and try CoW again"
+_scratch_remount
+
+out="$(_pwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" -d 2>&1)"
+echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> "$seqres.full" 2>&1
+echo "${out}"
+
+#filefrag -v $TESTDIR/bigfile
+#filefrag -v $TESTDIR/clonefile
+
+echo "Check scratch fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/174.out b/tests/generic/174.out
new file mode 100644
index 0000000..702d067
--- /dev/null
+++ b/tests/generic/174.out
@@ -0,0 +1,10 @@
+QA output created by 174
+Format and mount
+Reformat with appropriate size
+Create a big file and reflink it
+Allocate the rest of the space
+CoW the big file
+pwrite64: No space left on device
+Remount and try CoW again
+pwrite64: No space left on device
+Check scratch fs
diff --git a/tests/generic/group b/tests/generic/group
index 6ae3105..09a7828 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -173,6 +173,10 @@
 168 auto quick clone
 169 rw metadata auto quick
 170 auto quick clone
+171 auto quick clone
+172 auto quick clone
+173 auto quick clone
+174 auto quick clone
 184 metadata auto quick
 192 atime auto
 193 metadata auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
