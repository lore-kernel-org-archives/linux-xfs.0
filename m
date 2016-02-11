Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3574B7F51
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:41:14 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5180AC006
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:13 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id WqM4xXAbNw15k46G (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:10 -0800 (PST)
Subject: [PATCH 16/32] reflink: ensure that we can handle reflinking a lot
	of extents
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:41:04 -0800
Message-ID: <20160211234104.2202.3715.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Update the existing stress tests to ensure that we can handle
reflinking the same block a million times, and that we can handle
reflinking million different extents.  Add a couple of tests to ensure
that we can ^C and SIGKILL our way out of long-running reflinks.

v2: Don't run the signal tests on NFS, as we cannot interrupt NFS
clone operations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch@lst.de: don't run on NFS]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 .gitignore              |    1 
 src/Makefile            |    2 -
 src/punch-alternating.c |   59 ++++++++++++++++++++++++++++
 tests/generic/175       |   46 +++++++---------------
 tests/generic/175.out   |    5 ++
 tests/generic/176       |   53 +++++++++++++++----------
 tests/generic/176.out   |    5 +-
 tests/generic/297       |   99 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/297.out   |    6 +++
 tests/generic/298       |   99 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/298.out   |    6 +++
 tests/generic/group     |    6 ++-
 12 files changed, 328 insertions(+), 59 deletions(-)
 create mode 100644 src/punch-alternating.c
 create mode 100755 tests/generic/297
 create mode 100644 tests/generic/297.out
 create mode 100755 tests/generic/298
 create mode 100644 tests/generic/298.out


diff --git a/.gitignore b/.gitignore
index bbe7c1a..c98c7bf 100644
--- a/.gitignore
+++ b/.gitignore
@@ -115,6 +115,7 @@
 /src/aio-dio-regress/aiocp
 /src/aio-dio-regress/aiodio_sparse2
 /src/aio-dio-regress/aio-dio-eof-race
+/src/punch-alternating
 /src/cloner
 /src/renameat2
 /src/t_rename_overwrite
diff --git a/src/Makefile b/src/Makefile
index 48e6765..3110208 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -19,7 +19,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
-	renameat2 t_getcwd e4compact test-nextquota
+	renameat2 t_getcwd e4compact test-nextquota punch-alternating
 
 SUBDIRS =
 
diff --git a/src/punch-alternating.c b/src/punch-alternating.c
new file mode 100644
index 0000000..9566310
--- /dev/null
+++ b/src/punch-alternating.c
@@ -0,0 +1,59 @@
+/*
+ * Punch out every other block in a file.
+ * Copyright (C) 2016 Oracle.
+ */
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <string.h>
+#include "global.h"
+
+int main(int argc, char *argv[])
+{
+	struct stat	s;
+	off_t		offset;
+	int		fd;
+	blksize_t	blksz;
+	off_t		sz;
+	int		mode;
+	int		error;
+
+	if (argc != 2) {
+		printf("Usage: %s file\n", argv[0]);
+		printf("Punches every other block in the file.\n");
+		return 1;
+	}
+
+	fd = open(argv[1], O_WRONLY);
+	if (fd < 0)
+		goto err;
+
+	error = fstat(fd, &s);
+	if (error)
+		goto err;
+
+	sz = s.st_size;
+	blksz = s.st_blksize;
+
+	mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
+	for (offset = 0; offset < sz; offset += blksz * 2) {
+		error = fallocate(fd, mode, offset, blksz);
+		if (error)
+			goto err;
+	}
+
+	error = fsync(fd);
+	if (error)
+		goto err;
+
+	error = close(fd);
+	if (error)
+		goto err;
+	return 0;
+err:
+	perror(argv[1]);
+	return 2;
+}
diff --git a/tests/generic/175 b/tests/generic/175
index ac2f54f..56e9919 100755
--- a/tests/generic/175
+++ b/tests/generic/175
@@ -1,12 +1,10 @@
 #! /bin/bash
 # FS QA Test No. 175
 #
-# Try to hit the maximum reference count (eek!)
-#
-# This test runs extremely slowly, so it's not automatically run anywhere.
+# See how well reflink handles reflinking the same block a million times.
 #
 #-----------------------------------------------------------------------
-# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
 #
 # This program is free software; you can redistribute it and/or
 # modify it under the terms of the GNU General Public License as
@@ -34,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir1"
+    rm -rf "$tmp".*
 }
 
 # get standard environment, filters and checks
@@ -55,43 +53,27 @@ _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
 testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
 mkdir "$testdir"
 
-# Well let's hope the maximum reflink count is (less than (ha!)) 2^32...
-
 echo "Create a one block file"
 blksz="$(stat -f "$testdir" -c '%S')"
 _pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $blksz "$testdir/file2" >> "$seqres.full"
-_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
 
-nr=32
-fnr=32
+fnr=19
+echo "Create extents"
+truncate -s $(( (2 ** i) * blksz)) "$testdir/file1"
 for i in $(seq 0 $fnr); do
-	echo " ++ Reflink size $i, $(( (2 ** i) * blksz)) bytes" | tee -a "$seqres.full"
+	echo " ++ Reflink size $i, $((2 ** i)) blocks" >> "$seqres.full"
 	n=$(( (2 ** i) * blksz))
-	_reflink_range "$testdir/file1" 0 "$testdir/file1" $n $n >> "$seqres.full" || break
-done
-
-nrf=$((nr - fnr))
-echo "Clone $((2 ** nrf)) files"
-seq 0 $((2 ** nrf)) | while read i; do
-	_cp-reflink "$testdir/file1" "$testdir/file1-$i"
+	_reflink_range "$testdir/file1" 0 "$testdir/file1" $n $n >> "$seqres.full"
 done
+_scratch_remount
 
-echo "Check scratch fs"
-umount "$SCRATCH_MNT"
-_check_scratch_fs
-
-echo "Remove big file and recheck"
-_scratch_mount >> "$seqres.full" 2>&1
-umount "$SCRATCH_MNT"
-_check_scratch_fs
-
-echo "Remove all files and recheck"
-_scratch_mount >> "$seqres.full" 2>&1
-umount "$SCRATCH_MNT"
+echo "Reflink the big file"
+blks=$((2 ** (fnr + 1) ))
+bytes=$((blks * blksz))
+echo "reflinking $blks blocks, $bytes bytes" >> "$seqres.full"
+_reflink_range "$testdir/file1" 0 "$testdir/file2" 0 $bytes >> "$seqres.full"
 
 # success, all done
 status=0
diff --git a/tests/generic/175.out b/tests/generic/175.out
index e69de29..78031a5 100644
--- a/tests/generic/175.out
+++ b/tests/generic/175.out
@@ -0,0 +1,5 @@
+QA output created by 175
+Format and mount
+Create a one block file
+Create extents
+Reflink the big file
diff --git a/tests/generic/176 b/tests/generic/176
index e32f94f..a77a16d 100755
--- a/tests/generic/176
+++ b/tests/generic/176
@@ -1,10 +1,10 @@
 #! /bin/bash
 # FS QA Test No. 176
 #
-# Try to run out of space while cloning?
+# See how well reflink handles reflinking a file with a million extents.
 #
 #-----------------------------------------------------------------------
-# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
 #
 # This program is free software; you can redistribute it and/or
 # modify it under the terms of the GNU General Public License as
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$testdir1"
+    rm -rf "$tmp".*
 }
 
 # get standard environment, filters and checks
@@ -44,6 +44,8 @@ _cleanup()
 # real QA test starts here
 _supported_os Linux
 _require_scratch_reflink
+_require_cp_reflink
+_require_test_program "punch-alternating"
 
 rm -f "$seqres.full"
 
@@ -52,28 +54,37 @@ _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
 testdir="$SCRATCH_MNT/test-$seq"
-rm -rf "$testdir"
 mkdir "$testdir"
 
-blksz="$(stat -f "$testdir" -c '%S')"
-nr_free="$(stat -f -c '%f' "$testdir")"
-echo "Create a big file"
-touch "$testdir/file0" "$testdir/file1"
-_pwrite_byte 0x61 0 $((blksz * nr_free)) "$testdir/bigfile" >> "$seqres.full" 2>&1
-_scratch_remount
-sz="$(stat -c '%s' "$testdir/bigfile")"
-
-blks="$((sz / blksz))"
-echo "Try to reflink"
-seq 0 $blks | while read lblk; do
-	fname="$testdir/file$((lblk % 2))"
-	out="$(_reflink_range "$testdir/bigfile" $((lblk * blksz)) "$fname" $((lblk * blksz)) $blksz 2>&1)"
-	echo "$fname: $out" >> "$seqres.full"
-	echo "$out" | grep -q "No space left on device" && break
+# Setup for one million blocks, but we'll accept stress testing down to
+# 2^17 blocks... that should be plenty for anyone.
+fnr=20
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
 done
+test $fnr -lt 17 && _notrun "Insufficient space for stress test; would only create $blocks_needed extents."
+
+echo "Create a many-block file"
+echo "creating $blocks_needed blocks..." >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b 4194304 0 $((2 ** (fnr + 1) * blksz))" "$testdir/file1" >> "$seqres.full"
+echo "punching..." >> "$seqres.full"
+"$here/src/punch-alternating" "$testdir/file1" >> "$seqres.full"
+echo "...done" >> "$seqres.full"
+_scratch_remount
 
-echo "Check scratch fs"
-umount "$SCRATCH_MNT"
+echo "Reflink the big file"
+bytes=$((blocks_needed * blksz))
+echo "reflinking $((blocks_needed / 2)) blocks, $((bytes / 2)) bytes" >> "$seqres.full"
+_reflink_range "$testdir/file1" 0 "$testdir/file2" 0 $bytes >> "$seqres.full"
 
 # success, all done
 status=0
diff --git a/tests/generic/176.out b/tests/generic/176.out
index eec98eb..538cc17 100644
--- a/tests/generic/176.out
+++ b/tests/generic/176.out
@@ -1,5 +1,4 @@
 QA output created by 176
 Format and mount
-Create a big file
-Try to reflink
-Check scratch fs
+Create a many-block file
+Reflink the big file
diff --git a/tests/generic/297 b/tests/generic/297
new file mode 100755
index 0000000..4ae2b9c
--- /dev/null
+++ b/tests/generic/297
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. 297
+#
+# See how well reflink handles ^C in the middle of a slow reflink.
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
+    rm -rf $tmp.* $TEST_DIR/before $TEST_DIR/after
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
+_require_command "$(which timeout)" "timeout"
+
+test $FSTYP == "nfs"  && _notrun "NFS can't interrupt clone operations"
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
+echo "Create a one block file"
+blksz="$(stat -f $testdir -c '%S')"
+_pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
+
+fnr=26		# 2^26 reflink extents should be enough to find a slow op?
+timeout=8	# guarantee a good long run...
+echo "Find a reflink size that takes a long time"
+truncate -s $(( (2 ** i) * blksz)) $testdir/file1
+for i in $(seq 0 $fnr); do
+	echo " ++ Reflink size $i, $((2 ** i)) blocks" >> $seqres.full
+	n=$(( (2 ** i) * blksz))
+	touch $TEST_DIR/before
+	$XFS_IO_PROG -f -c "reflink $testdir/file1 0 $n $n" $testdir/file1 >> $seqres.full 2>&1
+	touch $TEST_DIR/after
+	before=$(stat -c '%Y' $TEST_DIR/before)
+	after=$(stat -c '%Y' $TEST_DIR/after)
+	delta=$((after - before))
+	test $delta -gt $timeout && break
+done
+
+echo "Try to kill reflink after a shorter period of time"
+kill_after=2	# give us a shorter time to die
+n=$(stat -c '%s' $testdir/file1)
+echo "performing kill test on $n bytes..." >> $seqres.full
+touch $TEST_DIR/before
+timeout -s INT ${kill_after}s $XFS_IO_PROG -f -c "reflink $testdir/file1 0 $n $n" $testdir/file1 >> $seqres.full 2>&1
+touch $TEST_DIR/after
+before=$(stat -c '%Y' $TEST_DIR/before)
+after=$(stat -c '%Y' $TEST_DIR/after)
+delta=$((after - before))
+echo "reflink of $n bytes took $delta seconds" >> $seqres.full
+test $delta -gt $timeout && _fail "reflink didn't stop in time, n=$n t=$delta"
+
+echo "Check scratch fs"
+sleep 2		# give it a few seconds to actually die...
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/297.out b/tests/generic/297.out
new file mode 100644
index 0000000..cfe5b96
--- /dev/null
+++ b/tests/generic/297.out
@@ -0,0 +1,6 @@
+QA output created by 297
+Format and mount
+Create a one block file
+Find a reflink size that takes a long time
+Try to kill reflink after a shorter period of time
+Check scratch fs
diff --git a/tests/generic/298 b/tests/generic/298
new file mode 100755
index 0000000..e85db12
--- /dev/null
+++ b/tests/generic/298
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. 298
+#
+# See how well reflink handles SIGKILL in the middle of a slow reflink.
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
+    rm -rf $tmp.* $TEST_DIR/before $TEST_DIR/after
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
+_require_command "$(which timeout)" "timeout"
+
+test $FSTYP == "nfs"  && _notrun "NFS can't interrupt clone operations"
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
+echo "Create a one block file"
+blksz="$(stat -f $testdir -c '%S')"
+_pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
+
+fnr=26		# 2^26 reflink extents should be enough to find a slow op?
+timeout=8	# guarantee a good long run...
+echo "Find a reflink size that takes a long time"
+truncate -s $(( (2 ** i) * blksz)) $testdir/file1
+for i in $(seq 0 $fnr); do
+	echo " ++ Reflink size $i, $((2 ** i)) blocks" >> $seqres.full
+	n=$(( (2 ** i) * blksz))
+	touch $TEST_DIR/before
+	$XFS_IO_PROG -f -c "reflink $testdir/file1 0 $n $n" $testdir/file1 >> $seqres.full 2>&1
+	touch $TEST_DIR/after
+	before=$(stat -c '%Y' $TEST_DIR/before)
+	after=$(stat -c '%Y' $TEST_DIR/after)
+	delta=$((after - before))
+	test $delta -gt $timeout && break
+done
+
+echo "Try to kill reflink after a shorter period of time"
+kill_after=2	# give us a shorter time to die
+n=$(stat -c '%s' $testdir/file1)
+echo "performing kill test on $n bytes..." >> $seqres.full
+touch $TEST_DIR/before
+urk=$(timeout -s KILL ${kill_after}s $XFS_IO_PROG -f -c "reflink $testdir/file1 0 $n $n" $testdir/file1 >> $seqres.full 2>&1)
+touch $TEST_DIR/after
+before=$(stat -c '%Y' $TEST_DIR/before)
+after=$(stat -c '%Y' $TEST_DIR/after)
+delta=$((after - before))
+echo "reflink of $n bytes took $delta seconds" >> $seqres.full
+test $delta -gt $timeout && _fail "reflink didn't stop in time, n=$n t=$delta"
+
+echo "Check scratch fs"
+sleep 2		# give it a few seconds to actually die...
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/298.out b/tests/generic/298.out
new file mode 100644
index 0000000..c1cdc7d
--- /dev/null
+++ b/tests/generic/298.out
@@ -0,0 +1,6 @@
+QA output created by 298
+Format and mount
+Create a one block file
+Find a reflink size that takes a long time
+Try to kill reflink after a shorter period of time
+Check scratch fs
diff --git a/tests/generic/group b/tests/generic/group
index c256617..f1a398c 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -177,8 +177,8 @@
 172 auto quick clone
 173 auto quick clone
 174 auto quick clone
-175 clone_stress
-176 clone_stress
+175 auto quick clone
+176 auto quick clone
 177 auto quick prealloc metadata
 178 auto quick clone
 179 auto quick clone
@@ -299,6 +299,8 @@
 294 auto quick
 295 auto quick clone
 296 auto quick clone
+297 auto quick clone
+298 auto quick clone
 299 auto aio enospc rw stress
 300 auto aio enospc preallocrw stress
 306 auto quick rw

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
