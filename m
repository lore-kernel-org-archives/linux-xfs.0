Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 374DE7F58
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 18:37:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5BCBFAC002
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:37:49 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id FQVAyRIBgfSFRteE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 16:37:18 -0800 (PST)
Subject: [PATCH 5/5] tests: use lowercase variables for all the new reflink
	tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Jan 2016 16:37:13 -0800
Message-ID: <20160123003713.2666.80882.stgit@birch.djwong.org>
In-Reply-To: <20160123003648.2666.37062.stgit@birch.djwong.org>
References: <20160123003648.2666.37062.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com

Since $TESTDIR is a local variable, make it lowercase to avoid
confusion with $TEST_DIR.  While we're at it, make all the local
variables lowercase.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/110 |   24 ++++-----
 tests/generic/111 |   42 ++++++++-------
 tests/generic/115 |   34 ++++++------
 tests/generic/116 |   42 ++++++++-------
 tests/generic/118 |   42 ++++++++-------
 tests/generic/119 |  112 ++++++++++++++++++++---------------------
 tests/generic/121 |   42 ++++++++-------
 tests/generic/122 |   42 ++++++++-------
 tests/generic/134 |   90 ++++++++++++++++-----------------
 tests/generic/136 |   90 ++++++++++++++++-----------------
 tests/generic/137 |   54 ++++++++++----------
 tests/generic/138 |  100 ++++++++++++++++++------------------
 tests/generic/139 |  100 ++++++++++++++++++------------------
 tests/generic/140 |  100 ++++++++++++++++++------------------
 tests/generic/142 |   34 ++++++------
 tests/generic/143 |   34 ++++++------
 tests/generic/144 |  124 +++++++++++++++++++++++----------------------
 tests/generic/145 |  146 +++++++++++++++++++++++++++--------------------------
 tests/generic/146 |  136 +++++++++++++++++++++++++------------------------
 tests/generic/147 |  142 ++++++++++++++++++++++++++--------------------------
 tests/generic/148 |   80 +++++++++++++++--------------
 tests/generic/149 |  136 +++++++++++++++++++++++++------------------------
 tests/generic/150 |   30 +++++------
 tests/generic/151 |   46 ++++++++---------
 tests/generic/152 |   52 +++++++++----------
 tests/generic/153 |   52 +++++++++----------
 tests/generic/154 |   60 +++++++++++-----------
 tests/generic/155 |   60 +++++++++++-----------
 tests/generic/156 |   58 +++++++++++----------
 tests/generic/157 |   68 ++++++++++++-------------
 tests/generic/158 |   70 +++++++++++++------------
 tests/generic/159 |   30 +++++------
 tests/generic/160 |   30 +++++------
 tests/generic/161 |   16 +++---
 tests/generic/162 |   22 ++++----
 tests/generic/163 |   22 ++++----
 tests/generic/164 |   28 +++++-----
 tests/generic/165 |   28 +++++-----
 tests/generic/166 |   18 +++----
 tests/generic/167 |   18 +++----
 tests/generic/168 |   22 ++++----
 tests/generic/170 |   22 ++++----
 tests/generic/171 |   42 ++++++++-------
 tests/generic/172 |   42 ++++++++-------
 tests/generic/173 |   42 ++++++++-------
 tests/generic/174 |   42 ++++++++-------
 tests/generic/175 |   24 ++++-----
 tests/generic/176 |   24 ++++-----
 tests/generic/178 |   28 +++++-----
 tests/generic/179 |   46 ++++++++---------
 tests/generic/180 |   46 ++++++++---------
 tests/generic/181 |   34 ++++++------
 tests/generic/182 |   76 ++++++++++++++--------------
 tests/generic/183 |   48 +++++++++--------
 tests/generic/185 |   48 +++++++++--------
 tests/generic/186 |   54 ++++++++++----------
 tests/generic/187 |   54 ++++++++++----------
 tests/generic/188 |   40 +++++++--------
 tests/generic/189 |   40 +++++++--------
 tests/generic/190 |   40 +++++++--------
 tests/generic/191 |   40 +++++++--------
 tests/generic/194 |   46 ++++++++---------
 tests/generic/195 |   46 ++++++++---------
 tests/generic/196 |   40 +++++++--------
 tests/generic/197 |   40 +++++++--------
 tests/generic/199 |   60 +++++++++++-----------
 tests/generic/200 |   60 +++++++++++-----------
 tests/generic/201 |   34 ++++++------
 tests/generic/202 |   32 ++++++------
 tests/generic/203 |   32 ++++++------
 tests/generic/205 |   48 +++++++++--------
 tests/generic/206 |   48 +++++++++--------
 tests/generic/216 |   48 +++++++++--------
 tests/generic/217 |   48 +++++++++--------
 tests/generic/218 |   40 +++++++--------
 tests/generic/220 |   40 +++++++--------
 tests/generic/222 |   48 +++++++++--------
 tests/generic/227 |   48 +++++++++--------
 tests/generic/229 |   94 +++++++++++++++++-----------------
 tests/generic/238 |   94 +++++++++++++++++-----------------
 tests/generic/242 |   46 ++++++++---------
 tests/generic/243 |   46 ++++++++---------
 tests/xfs/127     |   16 +++---
 tests/xfs/128     |  140 +++++++++++++++++++++++++--------------------------
 tests/xfs/129     |   28 +++++-----
 tests/xfs/131     |   16 +++---
 tests/xfs/132     |   68 ++++++++++++-------------
 tests/xfs/139     |   26 +++++----
 tests/xfs/140     |   34 ++++++------
 89 files changed, 2337 insertions(+), 2337 deletions(-)


diff --git a/tests/generic/110 b/tests/generic/110
index fffadbc..a43f02d 100755
--- a/tests/generic/110
+++ b/tests/generic/110
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $tmp.* "$TESTDIR"
+    rm -f $tmp.* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -53,37 +53,37 @@ _require_xfs_io_command "fiemap"
 _require_cp_reflink
 _require_test
 
-TESTDIR1=$TEST_DIR/test-$seq
-rm -rf $TESTDIR1
-mkdir $TESTDIR1
+testdir1=$TEST_DIR/test-$seq
+rm -rf $testdir1
+mkdir $testdir1
 
 _checksum_files() {
     for F in original copy1 copy2
     do
-        md5sum $TESTDIR1/$F | _filter_test_dir
+        md5sum $testdir1/$F | _filter_test_dir
     done
 }
 
 rm -f $seqres.full
 
 echo "Create the original file and reflink to copy1, copy2"
-$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original \
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $testdir1/original \
     >> $seqres.full 2>&1
-cp --reflink $TESTDIR1/original $TESTDIR1/copy1
-cp --reflink $TESTDIR1/copy1 $TESTDIR1/copy2
-_verify_reflink $TESTDIR1/original $TESTDIR1/copy1
-_verify_reflink $TESTDIR1/original $TESTDIR1/copy2
+cp --reflink $testdir1/original $testdir1/copy1
+cp --reflink $testdir1/copy1 $testdir1/copy2
+_verify_reflink $testdir1/original $testdir1/copy1
+_verify_reflink $testdir1/original $testdir1/copy2
 echo "Original md5sums:"
 _checksum_files
 
 echo "Overwrite original file with new data"
-$XFS_IO_PROG -c 'pwrite -S 0x62 0 9000' $TESTDIR1/original \
+$XFS_IO_PROG -c 'pwrite -S 0x62 0 9000' $testdir1/original \
     >> $seqres.full 2>&1
 echo "md5sums after overwriting original:"
 _checksum_files
 
 echo "Overwrite copy1 with different new data"
-$XFS_IO_PROG -c 'pwrite -S 0x63 0 9000' $TESTDIR1/copy1 \
+$XFS_IO_PROG -c 'pwrite -S 0x63 0 9000' $testdir1/copy1 \
     >> $seqres.full 2>&1
 echo "md5sums after overwriting copy1:"
 _checksum_files
diff --git a/tests/generic/111 b/tests/generic/111
index 98077d8..ef9c424 100755
--- a/tests/generic/111
+++ b/tests/generic/111
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $tmp.* "$TESTDIR"
+    rm -f $tmp.* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -53,55 +53,55 @@ _require_xfs_io_command "fiemap"
 _require_cp_reflink
 _require_test
 
-TESTDIR1=$TEST_DIR/test-$seq
-rm -rf $TESTDIR1
-mkdir $TESTDIR1
+testdir1=$TEST_DIR/test-$seq
+rm -rf $testdir1
+mkdir $testdir1
 
 _checksum_files() {
     for F in original/file1 original/subdir/file2 \
                  copy1/file1 copy1/subdir/file2 \
                  copy2/file1 copy2/subdir/file2
         do
-            md5sum $TESTDIR1/$F | _filter_test_dir
+            md5sum $testdir1/$F | _filter_test_dir
         done
 }
 
 rm -f $seqres.full
 
-mkdir $TESTDIR1/original
-mkdir $TESTDIR1/original/subdir
+mkdir $testdir1/original
+mkdir $testdir1/original/subdir
 
 echo "Create the original files and reflink dirs"
-$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original/file1 \
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $testdir1/original/file1 \
     >> $seqres.full 2>&1
 $XFS_IO_PROG -f -c 'pwrite -S 0x62 0 11000' \
-    $TESTDIR1/original/subdir/file2 >> $seqres.full 2>&1
-cp --recursive --reflink $TESTDIR1/original $TESTDIR1/copy1
-cp --recursive --reflink $TESTDIR1/copy1 $TESTDIR1/copy2
+    $testdir1/original/subdir/file2 >> $seqres.full 2>&1
+cp --recursive --reflink $testdir1/original $testdir1/copy1
+cp --recursive --reflink $testdir1/copy1 $testdir1/copy2
 
-_verify_reflink $TESTDIR1/original/file1 $TESTDIR1/copy1/file1
-_verify_reflink $TESTDIR1/original/subdir/file2 \
-    $TESTDIR1/copy1/subdir/file2
-_verify_reflink $TESTDIR1/original/file1 $TESTDIR1/copy2/file1
-_verify_reflink $TESTDIR1/original/subdir/file2 \
-    $TESTDIR1/copy2/subdir/file2
+_verify_reflink $testdir1/original/file1 $testdir1/copy1/file1
+_verify_reflink $testdir1/original/subdir/file2 \
+    $testdir1/copy1/subdir/file2
+_verify_reflink $testdir1/original/file1 $testdir1/copy2/file1
+_verify_reflink $testdir1/original/subdir/file2 \
+    $testdir1/copy2/subdir/file2
 
 echo "Original md5sums:"
 _checksum_files
 
 echo "Overwrite original/file1 and original/subdir/file2 with new data"
-$XFS_IO_PROG -c 'pwrite -S 0x63 0 13000' $TESTDIR1/original/file1 \
+$XFS_IO_PROG -c 'pwrite -S 0x63 0 13000' $testdir1/original/file1 \
     >> $seqres.full 2>&1
 $XFS_IO_PROG -c 'pwrite -S 0x64 5000 1000' \
-    $TESTDIR1/original/subdir/file2 >> $seqres.full 2>&1
+    $testdir1/original/subdir/file2 >> $seqres.full 2>&1
 echo "md5sums now:"
 _checksum_files
 
 echo "Overwrite copy1/file1 and copy1/subdir/file2 with new data"
-$XFS_IO_PROG -c 'pwrite -S 0x65 0 9000' $TESTDIR1/copy1/file1 \
+$XFS_IO_PROG -c 'pwrite -S 0x65 0 9000' $testdir1/copy1/file1 \
     >> $seqres.full 2>&1
 $XFS_IO_PROG -c 'pwrite -S 0x66 5000 25000' \
-    $TESTDIR1/copy1/subdir/file2 >> $seqres.full 2>&1
+    $testdir1/copy1/subdir/file2 >> $seqres.full 2>&1
 echo "md5sums now:"
 _checksum_files
 
diff --git a/tests/generic/115 b/tests/generic/115
index 6c8d92d..578d5bd 100755
--- a/tests/generic/115
+++ b/tests/generic/115
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $tmp.* "$TESTDIR"
+    rm -f $tmp.* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -53,31 +53,31 @@ _require_test
 
 rm -f $seqres.full
 
-TESTDIR1=$TEST_DIR/test-$seq
-rm -rf $TESTDIR1
-mkdir $TESTDIR1
+testdir1=$TEST_DIR/test-$seq
+rm -rf $testdir1
+mkdir $testdir1
 
 echo "Create the original files and reflink dirs"
-$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original \
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $testdir1/original \
     >> $seqres.full
-cp --reflink $TESTDIR1/original $TESTDIR1/copy
+cp --reflink $testdir1/original $testdir1/copy
 
-_verify_reflink $TESTDIR1/original $TESTDIR1/copy
+_verify_reflink $testdir1/original $testdir1/copy
 
 echo "Move orig & reflink copy to subdir and md5sum:"
-mkdir $TESTDIR1/subdir
-mv $TESTDIR1/original $TESTDIR1/subdir/original_moved
-mv $TESTDIR1/copy $TESTDIR1/subdir/copy_moved
-_verify_reflink $TESTDIR1/subdir/original_moved \
-    $TESTDIR1/subdir/copy_moved
+mkdir $testdir1/subdir
+mv $testdir1/original $testdir1/subdir/original_moved
+mv $testdir1/copy $testdir1/subdir/copy_moved
+_verify_reflink $testdir1/subdir/original_moved \
+    $testdir1/subdir/copy_moved
 
-md5sum $TESTDIR1/subdir/original_moved | _filter_test_dir
-md5sum $TESTDIR1/subdir/copy_moved | _filter_test_dir
+md5sum $testdir1/subdir/original_moved | _filter_test_dir
+md5sum $testdir1/subdir/copy_moved | _filter_test_dir
 
 echo "remove orig from subdir and md5sum reflink copy:"
-rm $TESTDIR1/subdir/original_moved
-md5sum $TESTDIR1/subdir/copy_moved | _filter_test_dir
-rm -rf $TESTDIR1/subdir
+rm $testdir1/subdir/original_moved
+md5sum $testdir1/subdir/copy_moved | _filter_test_dir
+rm -rf $testdir1/subdir
 
 # success, all done
 status=0
diff --git a/tests/generic/116 b/tests/generic/116
index 2b4b505..5c361e2 100755
--- a/tests/generic/116
+++ b/tests/generic/116
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -48,43 +48,43 @@ _require_test_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file2" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) "$testdir/file2" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 8)) \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 8)) \
        || echo "Files do not match"
 
 echo "Reflink the middle blocks together"
-free_before="$(stat -f -c '%a' "$TESTDIR")"
-_reflink_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
-		$((BLKSZ * 4)) $((BLKSZ * 2)) >> "$seqres.full"
+free_before="$(stat -f -c '%a' "$testdir")"
+_reflink_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
+		$((blksz * 4)) $((blksz * 2)) >> "$seqres.full"
 _test_remount
-free_after="$(stat -f -c '%a' "$TESTDIR")"
+free_after="$(stat -f -c '%a' "$testdir")"
 echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
 
 echo "Compare sections"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 4)) \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 4)) \
        || echo "Start sections do not match"
 
-_compare_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
-		$((BLKSZ * 4)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
+		$((blksz * 4)) $((blksz * 2)) \
        || echo "Middle sections do not match"
 
-_compare_range "$TESTDIR/file1" $((BLKSZ * 6)) "$TESTDIR/file2" \
-		$((BLKSZ * 6)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" $((blksz * 6)) "$testdir/file2" \
+		$((blksz * 6)) $((blksz * 2)) \
        || echo "End sections do not match"
 
 # success, all done
diff --git a/tests/generic/118 b/tests/generic/118
index 651b72c..41e525c 100755
--- a/tests/generic/118
+++ b/tests/generic/118
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -49,43 +49,43 @@ _require_test_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file2" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 2)) $((blksz * 6)) "$testdir/file2" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 8)) \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 8)) \
        || echo "Files do not match (intentional)"
 
 echo "Reflink the middle blocks together"
-free_before="$(stat -f -c '%a' "$TESTDIR")"
-_reflink_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
-		$((BLKSZ * 4)) $((BLKSZ * 2)) >> "$seqres.full"
+free_before="$(stat -f -c '%a' "$testdir")"
+_reflink_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
+		$((blksz * 4)) $((blksz * 2)) >> "$seqres.full"
 _test_remount
-free_after="$(stat -f -c '%a' "$TESTDIR")"
+free_after="$(stat -f -c '%a' "$testdir")"
 echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
 
 echo "Compare sections"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 4)) \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 4)) \
        || echo "Start sections do not match (intentional)"
 
-_compare_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
-		$((BLKSZ * 4)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
+		$((blksz * 4)) $((blksz * 2)) \
        || echo "Middle sections do not match"
 
-_compare_range "$TESTDIR/file1" $((BLKSZ * 6)) "$TESTDIR/file2" \
-		$((BLKSZ * 6)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" $((blksz * 6)) "$testdir/file2" \
+		$((blksz * 6)) $((blksz * 2)) \
        || echo "End sections do not match (intentional)"
 
 # success, all done
diff --git a/tests/generic/119 b/tests/generic/119
index 9d57379..27e7604 100755
--- a/tests/generic/119
+++ b/tests/generic/119
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -50,119 +50,119 @@ _require_test_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR=$TEST_DIR/test-$seq
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ * 8)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * 8)) "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x63 0 $((BLKSZ * 8)) "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x64 0 $((BLKSZ * 8)) "$TESTDIR/file4" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz * 8)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * 8)) "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x63 0 $((blksz * 8)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x64 0 $((blksz * 8)) "$testdir/file4" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 8)) \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 8)) \
        || echo "Files 1-2 do not match (intentional)"
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file3" 0 $((BLKSZ * 8)) \
+_compare_range "$testdir/file1" 0 "$testdir/file3" 0 $((blksz * 8)) \
        || echo "Files 1-3 do not match (intentional)"
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file4" 0 $((BLKSZ * 8)) \
+_compare_range "$testdir/file1" 0 "$testdir/file4" 0 $((blksz * 8)) \
        || echo "Files 1-4 do not match (intentional)"
 
 echo "Reflink the first four blocks together, 1-2 3-4"
-free_before="$(stat -f -c '%a' "$TESTDIR")"
-_reflink_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 4)) >> "$seqres.full"
-_reflink_range "$TESTDIR/file3" 0 "$TESTDIR/file4" 0 $((BLKSZ * 4)) >> "$seqres.full"
+free_before="$(stat -f -c '%a' "$testdir")"
+_reflink_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 4)) >> "$seqres.full"
+_reflink_range "$testdir/file3" 0 "$testdir/file4" 0 $((blksz * 4)) >> "$seqres.full"
 _test_remount
-free_after="$(stat -f -c '%a' "$TESTDIR")"
+free_after="$(stat -f -c '%a' "$testdir")"
 echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
 
 echo "Compare sections"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 4)) \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 4)) \
        || echo "Sections of file 1-2 do not match"
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file3" 0 $((BLKSZ * 4)) \
+_compare_range "$testdir/file1" 0 "$testdir/file3" 0 $((blksz * 4)) \
        || echo "Sections of file 1-3 do not match (intentional)"
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file4" 0 $((BLKSZ * 4)) \
+_compare_range "$testdir/file1" 0 "$testdir/file4" 0 $((blksz * 4)) \
        || echo "Sections of file 1-4 do not match (intentional)"
 
-_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file3" 0 $((BLKSZ * 4)) \
+_compare_range "$testdir/file2" 0 "$testdir/file3" 0 $((blksz * 4)) \
        || echo "Sections of file 2-3 do not match (intentional)"
 
-_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file4" 0 $((BLKSZ * 4)) \
+_compare_range "$testdir/file2" 0 "$testdir/file4" 0 $((blksz * 4)) \
        || echo "Sections of file 2-4 do not match (intentional)"
 
-_compare_range "$TESTDIR/file3" 0 "$TESTDIR/file4" 0 $((BLKSZ * 4)) \
+_compare_range "$testdir/file3" 0 "$testdir/file4" 0 $((blksz * 4)) \
        || echo "Sections of file 3-4 do not match"
 
 echo "Reflink the first two blocks together, 1-3 1-4"
-free_before="$(stat -f -c '%a' $TESTDIR)"
-_reflink_range "$TESTDIR/file1" 0 "$TESTDIR/file3" 0 $((BLKSZ * 2)) >> "$seqres.full"
-_reflink_range "$TESTDIR/file1" 0 "$TESTDIR/file4" 0 $((BLKSZ * 2)) >> "$seqres.full"
+free_before="$(stat -f -c '%a' $testdir)"
+_reflink_range "$testdir/file1" 0 "$testdir/file3" 0 $((blksz * 2)) >> "$seqres.full"
+_reflink_range "$testdir/file1" 0 "$testdir/file4" 0 $((blksz * 2)) >> "$seqres.full"
 _test_remount
-free_after="$(stat -f -c '%a' $TESTDIR)"
+free_after="$(stat -f -c '%a' $testdir)"
 echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
 
 echo "Compare sections"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 2)) \
        || echo "Sections of files 1-2 do not match"
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file3" 0 $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" 0 "$testdir/file3" 0 $((blksz * 2)) \
        || echo "Sections of files 1-3 do not match"
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file4" 0 $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" 0 "$testdir/file4" 0 $((blksz * 2)) \
        || echo "Sections of files 1-4 do not match"
 
-_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file3" 0 $((BLKSZ * 2)) \
+_compare_range "$testdir/file2" 0 "$testdir/file3" 0 $((blksz * 2)) \
        || echo "Sections of files 2-3 do not match"
 
-_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file4" 0 $((BLKSZ * 2)) \
+_compare_range "$testdir/file2" 0 "$testdir/file4" 0 $((blksz * 2)) \
        || echo "Sections of files 2-4 do not match"
 
-_compare_range "$TESTDIR/file3" 0 "$TESTDIR/file4" 0 $((BLKSZ * 2)) \
+_compare_range "$testdir/file3" 0 "$testdir/file4" 0 $((blksz * 2)) \
        || echo "Sections of files 3-4 do not match"
 
 echo "Compare previously reflinked sections"
-_compare_range "$TESTDIR/file1" $((BLKSZ * 2)) "$TESTDIR/file2" \
-		$((BLKSZ * 2)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" $((blksz * 2)) "$testdir/file2" \
+		$((blksz * 2)) $((blksz * 2)) \
        || echo "Sections of file 1-2 do not match"
 
-_compare_range "$TESTDIR/file1" $((BLKSZ * 2)) "$TESTDIR/file3" \
-		$((BLKSZ * 2)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" $((blksz * 2)) "$testdir/file3" \
+		$((blksz * 2)) $((blksz * 2)) \
        || echo "Sections of file 1-3 do not match (intentional)"
 
-_compare_range "$TESTDIR/file1" $((BLKSZ * 2)) "$TESTDIR/file4" \
-		$((BLKSZ * 2)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" $((blksz * 2)) "$testdir/file4" \
+		$((blksz * 2)) $((blksz * 2)) \
        || echo "Sections of file 1-4 do not match (intentional)"
 
-_compare_range "$TESTDIR/file2" $((BLKSZ * 2)) "$TESTDIR/file3" \
-		$((BLKSZ * 2)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file2" $((blksz * 2)) "$testdir/file3" \
+		$((blksz * 2)) $((blksz * 2)) \
        || echo "Sections of file 2-3 do not match (intentional)"
 
-_compare_range "$TESTDIR/file2" $((BLKSZ * 2)) "$TESTDIR/file4" \
-		$((BLKSZ * 2)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file2" $((blksz * 2)) "$testdir/file4" \
+		$((blksz * 2)) $((blksz * 2)) \
        || echo "Sections of file 2-4 do not match (intentional)"
 
-_compare_range "$TESTDIR/file3" $((BLKSZ * 2)) "$TESTDIR/file4" \
-		$((BLKSZ * 2)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file3" $((blksz * 2)) "$testdir/file4" \
+		$((blksz * 2)) $((blksz * 2)) \
        || echo "Sections of file 3-4 do not match"
 
 # success, all done
diff --git a/tests/generic/121 b/tests/generic/121
index 9a5b383..0e15e8d 100755
--- a/tests/generic/121
+++ b/tests/generic/121
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -48,43 +48,43 @@ _require_test_dedupe
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file2" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) "$testdir/file2" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 8)) \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 8)) \
        || echo "Files 1-2 do not match (intentional)"
 
 echo "Dedupe the middle blocks together"
-free_before="$(stat -f -c '%a' "$TESTDIR")"
-_dedupe_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
-		$((BLKSZ * 4)) $((BLKSZ * 2)) >> "$seqres.full"
+free_before="$(stat -f -c '%a' "$testdir")"
+_dedupe_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
+		$((blksz * 4)) $((blksz * 2)) >> "$seqres.full"
 _test_remount
-free_after="$(stat -f -c '%a' "$TESTDIR")"
+free_after="$(stat -f -c '%a' "$testdir")"
 echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
 
 echo "Compare sections"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 4)) \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 4)) \
        || echo "Start sections do not match"
 
-_compare_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
-		$((BLKSZ * 4)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
+		$((blksz * 4)) $((blksz * 2)) \
        || echo "Middle sections do not match"
 
-_compare_range "$TESTDIR/file1" $((BLKSZ * 6)) "$TESTDIR/file2" \
-		$((BLKSZ * 6)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" $((blksz * 6)) "$testdir/file2" \
+		$((blksz * 6)) $((blksz * 2)) \
        || echo "End sections do not match"
 
 # success, all done
diff --git a/tests/generic/122 b/tests/generic/122
index 0edb48d..e7585f7 100755
--- a/tests/generic/122
+++ b/tests/generic/122
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -48,43 +48,43 @@ _require_test_dedupe
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $((BLKSZ * 2)) $((BLKSZ * 6)) "$TESTDIR/file2" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 6)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 2)) $((blksz * 6)) "$testdir/file2" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 "$((BLKSZ * 8))" \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 "$((blksz * 8))" \
        || echo "Files 1-2 do not match (intentional)"
 
 echo "(Fail to) dedupe the middle blocks together"
-free_before="$(stat -f -c '%a' "$TESTDIR")"
-_dedupe_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
-		$((BLKSZ * 4)) $((BLKSZ * 2)) >> "$seqres.full"
+free_before="$(stat -f -c '%a' "$testdir")"
+_dedupe_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
+		$((blksz * 4)) $((blksz * 2)) >> "$seqres.full"
 _test_remount
-free_after="$(stat -f -c '%a' "$TESTDIR")"
+free_after="$(stat -f -c '%a' "$testdir")"
 echo "freesp changed by $free_before -> $free_after" >> "$seqres.full"
 
 echo "Compare sections"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $((BLKSZ * 4)) \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $((blksz * 4)) \
        || echo "Start sections do not match (intentional)"
 
-_compare_range "$TESTDIR/file1" $((BLKSZ * 4)) "$TESTDIR/file2" \
-		$((BLKSZ * 4)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" $((blksz * 4)) "$testdir/file2" \
+		$((blksz * 4)) $((blksz * 2)) \
        || echo "Middle sections do not match (intentional)"
 
-_compare_range "$TESTDIR/file1" $((BLKSZ * 6)) "$TESTDIR/file2" \
-		$((BLKSZ * 6)) $((BLKSZ * 2)) \
+_compare_range "$testdir/file1" $((blksz * 6)) "$testdir/file2" \
+		$((blksz * 6)) $((blksz * 2)) \
        || echo "End sections do not match (intentional)"
 
 # success, all done
diff --git a/tests/generic/134 b/tests/generic/134
index 4dc710c..1dda839 100755
--- a/tests/generic/134
+++ b/tests/generic/134
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -52,75 +52,75 @@ _require_test_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ + 37)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((BLKSZ + 37)) "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ + 37)) "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ + 37)) "$TESTDIR/file4" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz + 37)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz + 37)) "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz + 37)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz + 37)) "$testdir/file4" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
 
-C1="$(_md5_checksum $TESTDIR/file1)"
-C2="$(_md5_checksum $TESTDIR/file2)"
-C3="$(_md5_checksum $TESTDIR/file3)"
-C4="$(_md5_checksum $TESTDIR/file4)"
+c1="$(_md5_checksum $testdir/file1)"
+c2="$(_md5_checksum $testdir/file2)"
+c3="$(_md5_checksum $testdir/file3)"
+c4="$(_md5_checksum $testdir/file4)"
 
-test "${C1}" = "${C2}" || echo "file1 and file2 should match"
-test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
-test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
-test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
-test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
-test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+test "${c1}" = "${c2}" || echo "file1 and file2 should match"
+test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
+test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
+test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
+test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
+test "${c3}" = "${c4}" || echo "file3 and file4 should match"
 
 echo "Reflink the last blocks together, 1-2 1-3"
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ 37 >> "$seqres.full"
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file2" $blksz 37 >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file3" $blksz 37 >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
 
-C1="$(_md5_checksum $TESTDIR/file1)"
-C2="$(_md5_checksum $TESTDIR/file2)"
-C3="$(_md5_checksum $TESTDIR/file3)"
-C4="$(_md5_checksum $TESTDIR/file4)"
+c1="$(_md5_checksum $testdir/file1)"
+c2="$(_md5_checksum $testdir/file2)"
+c3="$(_md5_checksum $testdir/file3)"
+c4="$(_md5_checksum $testdir/file4)"
 
 echo "Compare files"
-test "${C1}" = "${C2}" || echo "file1 and file2 should match"
-test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
-test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
-test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
-test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
-test "${C3}" != "${C4}" || echo "file3 and file4 should match"
+test "${c1}" = "${c2}" || echo "file1 and file2 should match"
+test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
+test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
+test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
+test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
+test "${c3}" != "${c4}" || echo "file3 and file4 should match"
 
 echo "Compare sections"
-_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ 37 \
+_compare_range "$testdir/file1" $blksz "$testdir/file2" $blksz 37 \
        || echo "End sections of files 1-2 do not match"
 
-_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 \
+_compare_range "$testdir/file1" $blksz "$testdir/file3" $blksz 37 \
        || echo "End sections of files 1-3 do not match"
 
-_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file4" $BLKSZ 37 \
+_compare_range "$testdir/file1" $blksz "$testdir/file4" $blksz 37 \
        || echo "End sections of files 1-4 do not match (intentional)"
 
-_compare_range "$TESTDIR/file2" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 \
+_compare_range "$testdir/file2" $blksz "$testdir/file3" $blksz 37 \
        || echo "End sections of files 2-3 do not match"
 
-_compare_range "$TESTDIR/file2" $BLKSZ "$TESTDIR/file4" $BLKSZ 37 \
+_compare_range "$testdir/file2" $blksz "$testdir/file4" $blksz 37 \
        || echo "End sections of files 2-4 do not match (intentional)"
 
-_compare_range "$TESTDIR/file3" $BLKSZ "$TESTDIR/file4" $BLKSZ 37 \
+_compare_range "$testdir/file3" $blksz "$testdir/file4" $blksz 37 \
        || echo "End sections of files 3-4 do not match (intentional)"
 
 # success, all done
diff --git a/tests/generic/136 b/tests/generic/136
index 5d021f8..6bd6b14 100755
--- a/tests/generic/136
+++ b/tests/generic/136
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -52,77 +52,77 @@ _require_test_dedupe
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ + 37)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((BLKSZ + 37)) "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ + 37)) "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ + 37)) "$TESTDIR/file4" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz + 37)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz + 37)) "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz + 37)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz + 37)) "$testdir/file4" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
 
-C1="$(_md5_checksum $TESTDIR/file1)"
-C2="$(_md5_checksum $TESTDIR/file2)"
-C3="$(_md5_checksum $TESTDIR/file3)"
-C4="$(_md5_checksum $TESTDIR/file4)"
+c1="$(_md5_checksum $testdir/file1)"
+c2="$(_md5_checksum $testdir/file2)"
+c3="$(_md5_checksum $testdir/file3)"
+c4="$(_md5_checksum $testdir/file4)"
 
-test "${C1}" = "${C2}" || echo "file1 and file2 should match"
-test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
-test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
-test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
-test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
-test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+test "${c1}" = "${c2}" || echo "file1 and file2 should match"
+test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
+test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
+test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
+test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
+test "${c3}" = "${c4}" || echo "file3 and file4 should match"
 
 echo "Dedupe the last blocks together"
 echo "1->2"
-_dedupe_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ 37 >> "$seqres.full"
+_dedupe_range "$testdir/file1" $blksz "$testdir/file2" $blksz 37 >> "$seqres.full"
 echo "1->3"
-_dedupe_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 >> "$seqres.full"
+_dedupe_range "$testdir/file1" $blksz "$testdir/file3" $blksz 37 >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
 
-C1="$(_md5_checksum $TESTDIR/file1)"
-C2="$(_md5_checksum $TESTDIR/file2)"
-C3="$(_md5_checksum $TESTDIR/file3)"
-C4="$(_md5_checksum $TESTDIR/file4)"
+c1="$(_md5_checksum $testdir/file1)"
+c2="$(_md5_checksum $testdir/file2)"
+c3="$(_md5_checksum $testdir/file3)"
+c4="$(_md5_checksum $testdir/file4)"
 
 echo "Compare files"
-test "${C1}" = "${C2}" || echo "file1 and file2 should match"
-test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
-test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
-test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
-test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
-test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+test "${c1}" = "${c2}" || echo "file1 and file2 should match"
+test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
+test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
+test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
+test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
+test "${c3}" = "${c4}" || echo "file3 and file4 should match"
 
 echo "Compare sections"
-_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ 37 \
+_compare_range "$testdir/file1" $blksz "$testdir/file2" $blksz 37 \
        || echo "End sections of files 1-2 do not match"
 
-_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 \
+_compare_range "$testdir/file1" $blksz "$testdir/file3" $blksz 37 \
        || echo "End sections of files 1-3 do not match (intentional)"
 
-_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file4" $BLKSZ 37 \
+_compare_range "$testdir/file1" $blksz "$testdir/file4" $blksz 37 \
        || echo "End sections of files 1-4 do not match (intentional)"
 
-_compare_range "$TESTDIR/file2" $BLKSZ "$TESTDIR/file3" $BLKSZ 37 \
+_compare_range "$testdir/file2" $blksz "$testdir/file3" $blksz 37 \
        || echo "End sections of files 2-3 do not match (intentional)"
 
-_compare_range "$TESTDIR/file2" $BLKSZ "$TESTDIR/file4" $BLKSZ 37 \
+_compare_range "$testdir/file2" $blksz "$testdir/file4" $blksz 37 \
        || echo "End sections of files 2-4 do not match (intentional)"
 
-_compare_range "$TESTDIR/file3" $BLKSZ "$TESTDIR/file4" $BLKSZ 37 \
+_compare_range "$testdir/file3" $blksz "$testdir/file4" $blksz 37 \
        || echo "End sections of files 3-4 do not match"
 
 # success, all done
diff --git a/tests/generic/137 b/tests/generic/137
index 9cc7948..dcfd90d 100755
--- a/tests/generic/137
+++ b/tests/generic/137
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -54,47 +54,47 @@ _require_xfs_io_command "falloc"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original file blocks"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ $((BLKSZ * 2)) "$TESTDIR/file1" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $((blksz * 2)) "$testdir/file1" >> "$seqres.full"
 
-NR_BLKS=1024
+nr_blks=1024
 
 echo "fallocate half the file"
-"$XFS_IO_PROG" -f -c "falloc $((NR_BLKS * BLKSZ / 2)) $((NR_BLKS * BLKSZ / 2))" "$TESTDIR/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc $((nr_blks * blksz / 2)) $((nr_blks * blksz / 2))" "$testdir/file1" >> "$seqres.full"
 
 echo "Reflink block zero to the threes"
-seq 1 $((NR_BLKS / 3)) | while read nr; do
-	_reflink_range "$TESTDIR/file1" 0 "$TESTDIR/file1" $((nr * 3 * BLKSZ)) \
-			$BLKSZ >> "$seqres.full"
+seq 1 $((nr_blks / 3)) | while read nr; do
+	_reflink_range "$testdir/file1" 0 "$testdir/file1" $((nr * 3 * blksz)) \
+			$blksz >> "$seqres.full"
 done
 
 echo "Reflink block one to the fives"
-seq 1 $((NR_BLKS / 5)) | while read nr; do
-	_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file1" \
-			$((nr * 5 * BLKSZ)) $BLKSZ >> "$seqres.full"
+seq 1 $((nr_blks / 5)) | while read nr; do
+	_reflink_range "$testdir/file1" $blksz "$testdir/file1" \
+			$((nr * 5 * blksz)) $blksz >> "$seqres.full"
 done
 
 echo "Dedupe block two to the sevens"
-seq 1 $((NR_BLKS / 7)) | while read nr; do
-	_dedupe_range "$TESTDIR/file1" $((BLKSZ * 2)) "$TESTDIR/file1" \
-			$((nr * 7 * BLKSZ)) $BLKSZ >> "$seqres.full" 2>&1
+seq 1 $((nr_blks / 7)) | while read nr; do
+	_dedupe_range "$testdir/file1" $((blksz * 2)) "$testdir/file1" \
+			$((nr * 7 * blksz)) $blksz >> "$seqres.full" 2>&1
 done
 
 _test_remount
 
 echo "Check block mappings"
-md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
 
-crcZ=$(_md5_range_checksum /dev/zero 0 $BLKSZ)
-crc0=$(_md5_range_checksum "$TESTDIR/file1" 0 $BLKSZ)
-crc1=$(_md5_range_checksum "$TESTDIR/file1" $BLKSZ $BLKSZ)
-crc2=$(_md5_range_checksum "$TESTDIR/file1" $((BLKSZ * 2)) $BLKSZ)
+crcZ=$(_md5_range_checksum /dev/zero 0 $blksz)
+crc0=$(_md5_range_checksum "$testdir/file1" 0 $blksz)
+crc1=$(_md5_range_checksum "$testdir/file1" $blksz $blksz)
+crc2=$(_md5_range_checksum "$testdir/file1" $((blksz * 2)) $blksz)
 
 check_block() {
 	lblk="$1"
@@ -102,26 +102,26 @@ check_block() {
 	rem5=$((lblk % 5))
 	rem3=$((lblk % 3))
 
-	crc=$(_md5_range_checksum "$TESTDIR/file1" $((lblk * BLKSZ)) $BLKSZ)
+	crc=$(_md5_range_checksum "$testdir/file1" $((lblk * blksz)) $blksz)
 
 	if [ $rem7 -eq 0 ]; then
 		if [ $rem5 -eq 0 ]; then
 			test $crc2 = $crc || echo "lblk $lblk doesn't match block 2"
 		elif [ $rem3 -eq 0 ]; then
 			test $crc0 = $crc || echo "lblk $lblk doesn't match block 0"
-		elif [ $lblk -lt $((NR_BLKS / 2)) ]; then
+		elif [ $lblk -lt $((nr_blks / 2)) ]; then
 			test $crcZ = $crc || echo "lblk $lblk isn't zeroed"
 		fi
 	elif [ $rem5 -eq 0 ]; then
 		test $crc1 = $crc || echo "lblk $lblk doesn't match block 1"
 	elif [ $rem3 -eq 0 ]; then
 		test $crc0 = $crc || echo "lblk $lblk doesn't match block 0"
-	elif [ $lblk -lt $((NR_BLKS / 2)) ]; then
+	elif [ $lblk -lt $((nr_blks / 2)) ]; then
 		test $crcZ = $crc || echo "lblk $lblk isn't zeroed"
 	fi
 }
 
-seq 3 $((NR_BLKS - 1)) | while read lblk; do
+seq 3 $((nr_blks - 1)) | while read lblk; do
 	err="$(check_block $lblk)"
 	test -n "$err" && echo "$lblk: $err"
 done
diff --git a/tests/generic/138 b/tests/generic/138
index c084679..59d23e9 100755
--- a/tests/generic/138
+++ b/tests/generic/138
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -50,101 +50,101 @@ _require_cp_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ * 48 - 3)) "$TESTDIR/file1" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((BLKSZ * 48 - 3)) "$TESTDIR/file3" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz * 48 - 3)) "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 48 - 3)) "$testdir/file3" >> "$seqres.full"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
 
-cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "Files 1-2 do not match"
-cmp -s "$TESTDIR/file1" "$TESTDIR/file3" || echo "Files 1-3 do not match"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file3" || echo "Files 2-3 do not match"
+cmp -s "$testdir/file1" "$testdir/file2" || echo "Files 1-2 do not match"
+cmp -s "$testdir/file1" "$testdir/file3" || echo "Files 1-3 do not match"
+cmp -s "$testdir/file2" "$testdir/file3" || echo "Files 2-3 do not match"
 
 echo "pagecache CoW the second file"
-_pwrite_byte 0x62 0 17 "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x62 0 17 "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 17 "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x62 0 17 "$testdir/file3" >> "$seqres.full"
 
-_pwrite_byte 0x62 $((BLKSZ * 16 - 34)) 17 "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x62 $((BLKSZ * 16 - 34)) 17 "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 16 - 34)) 17 "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 16 - 34)) 17 "$testdir/file3" >> "$seqres.full"
 
-_pwrite_byte 0x62 $((BLKSZ * 48 - 8)) 17 "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x62 $((BLKSZ * 48 - 8)) 17 "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 48 - 8)) 17 "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 48 - 8)) 17 "$testdir/file3" >> "$seqres.full"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
 
-cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "Files 1-2 do not match (intentional)"
-cmp -s "$TESTDIR/file1" "$TESTDIR/file3" || echo "Files 1-3 do not match (intentional)"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file3" || echo "Files 2-3 do not match"
+cmp -s "$testdir/file1" "$testdir/file2" || echo "Files 1-2 do not match (intentional)"
+cmp -s "$testdir/file1" "$testdir/file3" || echo "Files 1-3 do not match (intentional)"
+cmp -s "$testdir/file2" "$testdir/file3" || echo "Files 2-3 do not match"
 
 echo "Compare the CoW'd section to the before file"
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 17 \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 17 \
        || echo "Start sections do not match (intentional)"
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 16 - 34)) \
-		"$TESTDIR/file2" $((BLKSZ * 16 - 34)) 17 \
+_compare_range  "$testdir/file1" $((blksz * 16 - 34)) \
+		"$testdir/file2" $((blksz * 16 - 34)) 17 \
        || echo "Middle sections do not match (intentional)"
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 48 - 8)) \
-		"$TESTDIR/file2" $((BLKSZ * 48 - 8)) 17 \
+_compare_range  "$testdir/file1" $((blksz * 48 - 8)) \
+		"$testdir/file2" $((blksz * 48 - 8)) 17 \
        || echo "End sections do not match (intentional)"
 
 echo "Compare the CoW'd section to the after file"
-_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file3" 0 17 \
+_compare_range "$testdir/file2" 0 "$testdir/file3" 0 17 \
        || echo "Start sections do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 16 - 34)) \
-		"$TESTDIR/file3" $((BLKSZ * 16 - 34)) 17 \
+_compare_range  "$testdir/file2" $((blksz * 16 - 34)) \
+		"$testdir/file3" $((blksz * 16 - 34)) 17 \
        || echo "Middle sections do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 48 - 8)) \
-		"$TESTDIR/file3" $((BLKSZ * 48 - 8)) 17 \
+_compare_range  "$testdir/file2" $((blksz * 48 - 8)) \
+		"$testdir/file3" $((blksz * 48 - 8)) 17 \
        || echo "End sections do not match"
 
 echo "Compare the not CoW'd sections"
-_compare_range "$TESTDIR/file1" 18 "$TESTDIR/file2" 18 17 \
+_compare_range "$testdir/file1" 18 "$testdir/file2" 18 17 \
        || echo "Start sections of 1-2 do not match"
 
-_compare_range "$TESTDIR/file2" 18 "$TESTDIR/file3" 18 17 \
+_compare_range "$testdir/file2" 18 "$testdir/file3" 18 17 \
        || echo "Start sections of 2-3 do not match"
 
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 16 - 17)) \
-		"$TESTDIR/file2" $((BLKSZ * 16 - 17)) 82 \
+_compare_range  "$testdir/file1" $((blksz * 16 - 17)) \
+		"$testdir/file2" $((blksz * 16 - 17)) 82 \
        || echo "Middle sections of 1-2 do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 16 - 17)) \
-		"$TESTDIR/file3" $((BLKSZ * 16 - 17)) 82 \
+_compare_range  "$testdir/file2" $((blksz * 16 - 17)) \
+		"$testdir/file3" $((blksz * 16 - 17)) 82 \
        || echo "Middle sections of 2-3 do not match"
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 48 - 108)) \
-		"$TESTDIR/file2" $((BLKSZ * 48 - 108)) 100 \
+_compare_range  "$testdir/file1" $((blksz * 48 - 108)) \
+		"$testdir/file2" $((blksz * 48 - 108)) 100 \
        || echo "End sections of 1-2 do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 48 - 108)) \
-		"$TESTDIR/file3" $((BLKSZ * 48 - 108)) 100 \
+_compare_range  "$testdir/file2" $((blksz * 48 - 108)) \
+		"$testdir/file3" $((blksz * 48 - 108)) 100 \
        || echo "End sections of 2-3 do not match"
 
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 14)) \
-		"$TESTDIR/file2" $((BLKSZ * 14)) $BLKSZ \
+_compare_range  "$testdir/file1" $((blksz * 14)) \
+		"$testdir/file2" $((blksz * 14)) $blksz \
        || echo "Untouched sections of 1-2 do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 14)) \
-		"$TESTDIR/file3" $((BLKSZ * 14)) $BLKSZ \
+_compare_range  "$testdir/file2" $((blksz * 14)) \
+		"$testdir/file3" $((blksz * 14)) $blksz \
        || echo "Untouched sections of 2-3 do not match"
 
 # success, all done
diff --git a/tests/generic/139 b/tests/generic/139
index 54c68fb..59e5bff 100755
--- a/tests/generic/139
+++ b/tests/generic/139
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -50,100 +50,100 @@ _require_cp_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR=$TEST_DIR/test-$seq
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ * 48 - 3)) "$TESTDIR/file1" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((BLKSZ * 48 - 3)) "$TESTDIR/file3" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz * 48 - 3)) "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 48 - 3)) "$testdir/file3" >> "$seqres.full"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
 
-cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "Files 1-2 should match"
-cmp -s "$TESTDIR/file1" "$TESTDIR/file3" || echo "Files 1-3 should match"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file3" || echo "Files 2-3 should match"
+cmp -s "$testdir/file1" "$testdir/file2" || echo "Files 1-2 should match"
+cmp -s "$testdir/file1" "$testdir/file3" || echo "Files 1-3 should match"
+cmp -s "$testdir/file2" "$testdir/file3" || echo "Files 2-3 should match"
 
 echo "directio CoW the second file"
-_pwrite_byte 0x62 0 $BLKSZ "$TESTDIR/file2" -d >> "$seqres.full"
-_pwrite_byte 0x62 0 $BLKSZ "$TESTDIR/file3" -d >> "$seqres.full"
+_pwrite_byte 0x62 0 $blksz "$testdir/file2" -d >> "$seqres.full"
+_pwrite_byte 0x62 0 $blksz "$testdir/file3" -d >> "$seqres.full"
 
-_pwrite_byte 0x62 $((BLKSZ * 16 - 512)) 512 "$TESTDIR/file2" -d >> "$seqres.full"
-_pwrite_byte 0x62 $((BLKSZ * 16 - 512)) 512 "$TESTDIR/file3" -d >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 16 - 512)) 512 "$testdir/file2" -d >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 16 - 512)) 512 "$testdir/file3" -d >> "$seqres.full"
 
-_pwrite_byte 0x62 $((BLKSZ * 48)) $BLKSZ "$TESTDIR/file2" -d >> "$seqres.full"
-_pwrite_byte 0x62 $((BLKSZ * 48)) $BLKSZ "$TESTDIR/file3" -d >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 48)) $blksz "$testdir/file2" -d >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 48)) $blksz "$testdir/file3" -d >> "$seqres.full"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
 
-cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "Files 1-2 should not match (intentional)"
-cmp -s "$TESTDIR/file1" "$TESTDIR/file3" || echo "Files 1-3 should not match (intentional)"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file3" || echo "Files 2-3 should match"
+cmp -s "$testdir/file1" "$testdir/file2" || echo "Files 1-2 should not match (intentional)"
+cmp -s "$testdir/file1" "$testdir/file3" || echo "Files 1-3 should not match (intentional)"
+cmp -s "$testdir/file2" "$testdir/file3" || echo "Files 2-3 should match"
 
 echo "Compare the CoW'd section to the before file"
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 $BLKSZ \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 $blksz \
        || echo "Start sections do not match (intentional)"
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 16 - 512)) \
-		"$TESTDIR/file2" $((BLKSZ * 16 - 512)) 512 \
+_compare_range  "$testdir/file1" $((blksz * 16 - 512)) \
+		"$testdir/file2" $((blksz * 16 - 512)) 512 \
        || echo "Middle sections do not match (intentional)"
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 48 - 512)) \
-		"$TESTDIR/file2" $((BLKSZ * 48 - 512)) $BLKSZ \
+_compare_range  "$testdir/file1" $((blksz * 48 - 512)) \
+		"$testdir/file2" $((blksz * 48 - 512)) $blksz \
        || echo "End sections do not match (intentional)"
 
 echo "Compare the CoW'd section to the after file"
-_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file3" 0 $BLKSZ \
+_compare_range "$testdir/file2" 0 "$testdir/file3" 0 $blksz \
        || echo "Start sections do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 16 - 512)) \
-		"$TESTDIR/file3" $((BLKSZ * 16 - 512)) 512 \
+_compare_range  "$testdir/file2" $((blksz * 16 - 512)) \
+		"$testdir/file3" $((blksz * 16 - 512)) 512 \
        || echo "Middle sections do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 48 - 512)) \
-		"$TESTDIR/file3" $((BLKSZ * 48 - 512)) $BLKSZ \
+_compare_range  "$testdir/file2" $((blksz * 48 - 512)) \
+		"$testdir/file3" $((blksz * 48 - 512)) $blksz \
        || echo "End sections do not match"
 
 echo "Compare the not CoW'd sections"
-_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ 512 \
+_compare_range "$testdir/file1" $blksz "$testdir/file2" $blksz 512 \
        || echo "Start sections of 1-2 do not match"
-_compare_range "$TESTDIR/file2" $BLKSZ "$TESTDIR/file3" $BLKSZ 512 \
+_compare_range "$testdir/file2" $blksz "$testdir/file3" $blksz 512 \
        || echo "Start sections of 2-3 do not match"
 
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 16 - 1024)) \
-		"$TESTDIR/file2" $((BLKSZ * 16 - 1024)) 512 \
+_compare_range  "$testdir/file1" $((blksz * 16 - 1024)) \
+		"$testdir/file2" $((blksz * 16 - 1024)) 512 \
        || echo "Middle sections of 1-2 do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 16 - 1024)) \
-		"$TESTDIR/file3" $((BLKSZ * 16 - 1024)) 512 \
+_compare_range  "$testdir/file2" $((blksz * 16 - 1024)) \
+		"$testdir/file3" $((blksz * 16 - 1024)) 512 \
        || echo "Middle sections of 2-3 do not match"
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 48 - 1024)) \
-		"$TESTDIR/file2" $((BLKSZ * 48 - 1024)) 512 \
+_compare_range  "$testdir/file1" $((blksz * 48 - 1024)) \
+		"$testdir/file2" $((blksz * 48 - 1024)) 512 \
        || echo "End sections of 1-2 do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 48 - 1024)) \
-		"$TESTDIR/file3" $((BLKSZ * 48 - 1024)) 512 \
+_compare_range  "$testdir/file2" $((blksz * 48 - 1024)) \
+		"$testdir/file3" $((blksz * 48 - 1024)) 512 \
        || echo "End sections of 2-3 do not match"
 
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 16)) \
-		"$TESTDIR/file2" $((BLKSZ * 16)) 512 \
+_compare_range  "$testdir/file1" $((blksz * 16)) \
+		"$testdir/file2" $((blksz * 16)) 512 \
        || echo "Untouched sections of 1-2 do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 16)) \
-		"$TESTDIR/file3" $((BLKSZ * 16)) 512 \
+_compare_range  "$testdir/file2" $((blksz * 16)) \
+		"$testdir/file3" $((blksz * 16)) 512 \
        || echo "Untouched sections of 2-3 do not match"
 
 # success, all done
diff --git a/tests/generic/140 b/tests/generic/140
index 6299d8e..e8e7655 100755
--- a/tests/generic/140
+++ b/tests/generic/140
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -50,101 +50,101 @@ _require_cp_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ * 48 - 3)) "$TESTDIR/file1" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((BLKSZ * 48 - 3)) "$TESTDIR/file3" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz * 48 - 3)) "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 48 - 3)) "$testdir/file3" >> "$seqres.full"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
 
-cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "Files 1-2 do not match"
-cmp -s "$TESTDIR/file1" "$TESTDIR/file3" || echo "Files 1-3 do not match"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file3" || echo "Files 2-3 do not match"
+cmp -s "$testdir/file1" "$testdir/file2" || echo "Files 1-2 do not match"
+cmp -s "$testdir/file1" "$testdir/file3" || echo "Files 1-3 do not match"
+cmp -s "$testdir/file2" "$testdir/file3" || echo "Files 2-3 do not match"
 
 echo "mmap CoW the second file"
-_mwrite_byte 0x62 0 17 $((BLKSZ * 48 - 3)) "$TESTDIR/file2" >> "$seqres.full"
-_mwrite_byte 0x62 0 17 $((BLKSZ * 48 - 3)) "$TESTDIR/file3" >> "$seqres.full"
+_mwrite_byte 0x62 0 17 $((blksz * 48 - 3)) "$testdir/file2" >> "$seqres.full"
+_mwrite_byte 0x62 0 17 $((blksz * 48 - 3)) "$testdir/file3" >> "$seqres.full"
 
-_mwrite_byte 0x62 $((BLKSZ * 16 - 34)) 17 $((BLKSZ * 48 - 3)) "$TESTDIR/file2" >> "$seqres.full"
-_mwrite_byte 0x62 $((BLKSZ * 16 - 34)) 17 $((BLKSZ * 48 - 3)) "$TESTDIR/file3" >> "$seqres.full"
+_mwrite_byte 0x62 $((blksz * 16 - 34)) 17 $((blksz * 48 - 3)) "$testdir/file2" >> "$seqres.full"
+_mwrite_byte 0x62 $((blksz * 16 - 34)) 17 $((blksz * 48 - 3)) "$testdir/file3" >> "$seqres.full"
 
-_mwrite_byte 0x62 $((BLKSZ * 48 - 20)) 17 $((BLKSZ * 48 - 3)) "$TESTDIR/file2" >> "$seqres.full"
-_mwrite_byte 0x62 $((BLKSZ * 48 - 20)) 17 $((BLKSZ * 48 - 3)) "$TESTDIR/file3" >> "$seqres.full"
+_mwrite_byte 0x62 $((blksz * 48 - 20)) 17 $((blksz * 48 - 3)) "$testdir/file2" >> "$seqres.full"
+_mwrite_byte 0x62 $((blksz * 48 - 20)) 17 $((blksz * 48 - 3)) "$testdir/file3" >> "$seqres.full"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
 
-cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "Files 1-2 do not match (intentional)"
-cmp -s "$TESTDIR/file1" "$TESTDIR/file3" || echo "Files 1-3 do not match (intentional)"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file3" || echo "Files 2-3 do not match"
+cmp -s "$testdir/file1" "$testdir/file2" || echo "Files 1-2 do not match (intentional)"
+cmp -s "$testdir/file1" "$testdir/file3" || echo "Files 1-3 do not match (intentional)"
+cmp -s "$testdir/file2" "$testdir/file3" || echo "Files 2-3 do not match"
 
 echo "Compare the CoW'd section to the before file"
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file2" 0 17 \
+_compare_range "$testdir/file1" 0 "$testdir/file2" 0 17 \
        || echo "Start sections do not match (intentional)"
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 16 - 34)) \
-		"$TESTDIR/file2" $((BLKSZ * 16 - 34)) 17 \
+_compare_range  "$testdir/file1" $((blksz * 16 - 34)) \
+		"$testdir/file2" $((blksz * 16 - 34)) 17 \
        || echo "Middle sections do not match (intentional)"
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 48 - 20)) \
-		"$TESTDIR/file2" $((BLKSZ * 48 - 20)) 17 \
+_compare_range  "$testdir/file1" $((blksz * 48 - 20)) \
+		"$testdir/file2" $((blksz * 48 - 20)) 17 \
        || echo "End sections do not match (intentional)"
 
 echo "Compare the CoW'd section to the after file"
-_compare_range "$TESTDIR/file2" 0 "$TESTDIR/file3" 0 17 \
+_compare_range "$testdir/file2" 0 "$testdir/file3" 0 17 \
        || echo "Start sections do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 16 - 34)) \
-		"$TESTDIR/file3" $((BLKSZ * 16 - 34)) 17 \
+_compare_range  "$testdir/file2" $((blksz * 16 - 34)) \
+		"$testdir/file3" $((blksz * 16 - 34)) 17 \
        || echo "Middle sections do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 48 - 20)) \
-		"$TESTDIR/file3" $((BLKSZ * 48 - 20)) 17 \
+_compare_range  "$testdir/file2" $((blksz * 48 - 20)) \
+		"$testdir/file3" $((blksz * 48 - 20)) 17 \
        || echo "End sections do not match"
 
 echo "Compare the not CoW'd sections"
-_compare_range "$TESTDIR/file1" 18 "$TESTDIR/file2" 18 17 \
+_compare_range "$testdir/file1" 18 "$testdir/file2" 18 17 \
        || echo "Start sections of 1-2 do not match"
 
-_compare_range "$TESTDIR/file2" 18 "$TESTDIR/file3" 18 17 \
+_compare_range "$testdir/file2" 18 "$testdir/file3" 18 17 \
        || echo "Start sections of 2-3 do not match"
 
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 16 - 17)) \
-		"$TESTDIR/file2" $((BLKSZ * 16 - 17)) 82 \
+_compare_range  "$testdir/file1" $((blksz * 16 - 17)) \
+		"$testdir/file2" $((blksz * 16 - 17)) 82 \
        || echo "Middle sections of 1-2 do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 16 - 17)) \
-		"$TESTDIR/file3" $((BLKSZ * 16 - 17)) 82 \
+_compare_range  "$testdir/file2" $((blksz * 16 - 17)) \
+		"$testdir/file3" $((blksz * 16 - 17)) 82 \
        || echo "Middle sections of 2-3 do not match"
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 48 - 120)) \
-		"$TESTDIR/file2" $((BLKSZ * 48 - 120)) 100 \
+_compare_range  "$testdir/file1" $((blksz * 48 - 120)) \
+		"$testdir/file2" $((blksz * 48 - 120)) 100 \
        || echo "End sections of 1-2 do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 48 - 120)) \
-		"$TESTDIR/file3" $((BLKSZ * 48 - 120)) 100 \
+_compare_range  "$testdir/file2" $((blksz * 48 - 120)) \
+		"$testdir/file3" $((blksz * 48 - 120)) 100 \
        || echo "End sections of 2-3 do not match"
 
 
-_compare_range  "$TESTDIR/file1" $((BLKSZ * 14)) \
-		"$TESTDIR/file2" $((BLKSZ * 14)) $BLKSZ \
+_compare_range  "$testdir/file1" $((blksz * 14)) \
+		"$testdir/file2" $((blksz * 14)) $blksz \
        || echo "Untouched sections of 1-2 do not match"
 
-_compare_range  "$TESTDIR/file2" $((BLKSZ * 14)) \
-		"$TESTDIR/file3" $((BLKSZ * 14)) $BLKSZ \
+_compare_range  "$testdir/file2" $((blksz * 14)) \
+		"$testdir/file3" $((blksz * 14)) $blksz \
        || echo "Untouched sections of 2-3 do not match"
 
 # success, all done
diff --git a/tests/generic/142 b/tests/generic/142
index cf6d634..2ac4d10 100755
--- a/tests/generic/142
+++ b/tests/generic/142
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -52,37 +52,37 @@ _require_cp_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original file blocks"
-BLKSZ=65536
-NR=9
-_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file1" >> "$seqres.full"
+blksz=65536
+nr=9
+_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file1" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-csum="$(_md5_checksum "$TESTDIR/file1")"
+md5sum "$testdir/file1" | _filter_test_dir
+csum="$(_md5_checksum "$testdir/file1")"
 
 echo "Create the reflink copies"
-seq 2 $NR | while read i; do
-	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+seq 2 $nr | while read i; do
+	_cp_reflink "$testdir/file1" "$testdir/file$i"
 done
 _test_remount
 
 echo "Rewrite the copies"
-seq 2 $NR | while read i; do
-	_pwrite_byte 0x62 0 $((BLKSZ * 256)) "$TESTDIR/file$i" >> "$seqres.full"
+seq 2 $nr | while read i; do
+	_pwrite_byte 0x62 0 $((blksz * 256)) "$testdir/file$i" >> "$seqres.full"
 done
 _test_remount
 
 echo "Examine original file"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
 
-mod_csum="$(_md5_checksum "$TESTDIR/file2")"
-new_csum="$(_md5_checksum "$TESTDIR/file1")"
+mod_csum="$(_md5_checksum "$testdir/file2")"
+new_csum="$(_md5_checksum "$testdir/file1")"
 test "${csum}" != "${mod_csum}" || echo "checksums do not match"
 test "${csum}" = "${new_csum}" || echo "checksums do not match"
 
diff --git a/tests/generic/143 b/tests/generic/143
index d2ccb94..c0bc672 100755
--- a/tests/generic/143
+++ b/tests/generic/143
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -52,37 +52,37 @@ _require_cp_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original file blocks"
-BLKSZ=65536
-NR=9
-_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file1" >> "$seqres.full"
+blksz=65536
+nr=9
+_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file1" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-csum="$(_md5_checksum "$TESTDIR/file1")"
+md5sum "$testdir/file1" | _filter_test_dir
+csum="$(_md5_checksum "$testdir/file1")"
 
 echo "Create the reflink copies"
-seq 2 $NR | while read i; do
-	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+seq 2 $nr | while read i; do
+	_cp_reflink "$testdir/file1" "$testdir/file$i"
 done
 _test_remount
 
 echo "Rewrite the copies"
-seq 2 $NR | while read i; do
-	_pwrite_byte 0x62 0 $((BLKSZ * 256)) "$TESTDIR/file$i" -d >> "$seqres.full"
+seq 2 $nr | while read i; do
+	_pwrite_byte 0x62 0 $((blksz * 256)) "$testdir/file$i" -d >> "$seqres.full"
 done
 _test_remount
 
 echo "Examine original file"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
 
-mod_csum="$(_md5_checksum "$TESTDIR/file2")"
-new_csum="$(_md5_checksum "$TESTDIR/file1")"
+mod_csum="$(_md5_checksum "$testdir/file2")"
+new_csum="$(_md5_checksum "$testdir/file1")"
 test "${csum}" != "${mod_csum}" || echo "checksums do not match"
 test "${csum}" = "${new_csum}" || echo "checksums do not match"
 
diff --git a/tests/generic/144 b/tests/generic/144
index bee0893..631fa33 100755
--- a/tests/generic/144
+++ b/tests/generic/144
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -52,90 +52,90 @@ _require_xfs_io_command "truncate"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ * 5 + 37)) "$TESTDIR/file1" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz * 5 + 37)) "$testdir/file1" >> "$seqres.full"
 
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ \
-		$((BLKSZ * 4 + 37)) >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file2" $blksz \
+		$((blksz * 4 + 37)) >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "truncate $((BLKSZ * 5 + 37))" "$TESTDIR/file3" >> "$seqres.full"
-_reflink_range "$TESTDIR/file1" 0 "$TESTDIR/file3" 0 $BLKSZ >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $((blksz * 5 + 37))" "$testdir/file3" >> "$seqres.full"
+_reflink_range "$testdir/file1" 0 "$testdir/file3" 0 $blksz >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "truncate $((BLKSZ * 5 + 37))" "$TESTDIR/file4" >> "$seqres.full"
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file4" $BLKSZ $BLKSZ >> "$seqres.full"
-_reflink_range "$TESTDIR/file1" $((BLKSZ * 3)) "$TESTDIR/file4" $((BLKSZ * 3)) \
-		$BLKSZ >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $((blksz * 5 + 37))" "$testdir/file4" >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file4" $blksz $blksz >> "$seqres.full"
+_reflink_range "$testdir/file1" $((blksz * 3)) "$testdir/file4" $((blksz * 3)) \
+		$blksz >> "$seqres.full"
 
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file5"
+_cp_reflink "$testdir/file1" "$testdir/file5"
 _test_remount
 
 echo "Compare sections"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
-md5sum "$TESTDIR/file5" | _filter_test_dir
-
-_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $BLKSZ \
-		$((BLKSZ * 4 + 37)) \
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
+md5sum "$testdir/file5" | _filter_test_dir
+
+_compare_range "$testdir/file1" $blksz "$testdir/file2" $blksz \
+		$((blksz * 4 + 37)) \
 	|| echo "shared parts of files 1-2 changed"
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file3" 0 $BLKSZ \
+_compare_range "$testdir/file1" 0 "$testdir/file3" 0 $blksz \
 	|| echo "shared parts of files 1-3 changed"
 
-_compare_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file4" $BLKSZ $BLKSZ \
+_compare_range "$testdir/file1" $blksz "$testdir/file4" $blksz $blksz \
 	|| echo "shared parts of files 1-4 changed"
 
-_compare_range "$TESTDIR/file1" 0 "$TESTDIR/file5" 0 $((BLKSZ * 5 + 37)) \
+_compare_range "$testdir/file1" 0 "$testdir/file5" 0 $((blksz * 5 + 37)) \
 	|| echo "shared parts of files 1-5 changed"
 
 echo "Compare files"
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
-C3="$(_md5_checksum "$TESTDIR/file3")"
-C4="$(_md5_checksum "$TESTDIR/file4")"
-C5="$(_md5_checksum "$TESTDIR/file5")"
-
-test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
-test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
-test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
-test "${C1}"  = "${C5}" || echo "file1 and file5 should match"
-test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
-test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
-test "${C2}" != "${C5}" || echo "file2 and file5 should not match"
-test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
-test "${C3}" != "${C5}" || echo "file3 and file5 should not match"
-test "${C4}" != "${C5}" || echo "file4 and file5 should not match"
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
+c3="$(_md5_checksum "$testdir/file3")"
+c4="$(_md5_checksum "$testdir/file4")"
+c5="$(_md5_checksum "$testdir/file5")"
+
+test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
+test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
+test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
+test "${c1}"  = "${c5}" || echo "file1 and file5 should match"
+test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
+test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
+test "${c2}" != "${c5}" || echo "file2 and file5 should not match"
+test "${c3}" != "${c4}" || echo "file3 and file4 should not match"
+test "${c3}" != "${c5}" || echo "file3 and file5 should not match"
+test "${c4}" != "${c5}" || echo "file4 and file5 should not match"
 
 echo "falloc everything"
-"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 5))" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 5))" "$TESTDIR/file3" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 5))" "$TESTDIR/file4" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 5))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 5))" "$testdir/file3" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 5))" "$testdir/file4" >> "$seqres.full"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
-md5sum "$TESTDIR/file5" | _filter_test_dir
-
-D1="$(_md5_checksum "$TESTDIR/file1")"
-D2="$(_md5_checksum "$TESTDIR/file2")"
-D3="$(_md5_checksum "$TESTDIR/file3")"
-D4="$(_md5_checksum "$TESTDIR/file4")"
-D5="$(_md5_checksum "$TESTDIR/file5")"
-
-test "${C1}" = "${D1}" || echo "file1 should not change"
-test "${C2}" = "${D2}" || echo "file2 should not change"
-test "${C3}" = "${D3}" || echo "file3 should not change"
-test "${C4}" = "${D4}" || echo "file4 should not change"
-test "${C5}" = "${D5}" || echo "file2 should not change"
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
+md5sum "$testdir/file5" | _filter_test_dir
+
+d1="$(_md5_checksum "$testdir/file1")"
+d2="$(_md5_checksum "$testdir/file2")"
+d3="$(_md5_checksum "$testdir/file3")"
+d4="$(_md5_checksum "$testdir/file4")"
+d5="$(_md5_checksum "$testdir/file5")"
+
+test "${c1}" = "${d1}" || echo "file1 should not change"
+test "${c2}" = "${d2}" || echo "file2 should not change"
+test "${c3}" = "${d3}" || echo "file3 should not change"
+test "${c4}" = "${d4}" || echo "file4 should not change"
+test "${c5}" = "${d5}" || echo "file2 should not change"
 
 # success, all done
 status=0
diff --git a/tests/generic/145 b/tests/generic/145
index 8a14f82..2b8d74f 100755
--- a/tests/generic/145
+++ b/tests/generic/145
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -53,89 +53,89 @@ _require_xfs_io_command "fcollapse"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file3"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file4"
-
-"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 4))" "$TESTDIR/file1"
-"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 4))" "$TESTDIR/file2"
-"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 4))" "$TESTDIR/file3"
-"$XFS_IO_PROG" -f -c "falloc 0 $((BLKSZ * 4))" "$TESTDIR/file4"
-
-_pwrite_byte 0x62 0 $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $BLKSZ $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file1" >> "$seqres.full"
+
+_cp_reflink "$testdir/file1" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file3"
+_cp_reflink "$testdir/file1" "$testdir/file4"
+
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 4))" "$testdir/file1"
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 4))" "$testdir/file2"
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 4))" "$testdir/file3"
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * 4))" "$testdir/file4"
+
+_pwrite_byte 0x62 0 $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $blksz "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $blksz $blksz "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((blksz * 2)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((blksz * 2)) $blksz "$testdir/file4.chk" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
-md5sum "$TESTDIR/file3.chk" | _filter_test_dir
-md5sum "$TESTDIR/file4.chk" | _filter_test_dir
-
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
-C3="$(_md5_checksum "$TESTDIR/file3")"
-C4="$(_md5_checksum "$TESTDIR/file4")"
-
-test "${C1}" = "${C2}" || echo "file1 and file2 should match"
-test "${C1}" = "${C3}" || echo "file1 and file3 should match"
-test "${C1}" = "${C4}" || echo "file1 and file4 should match"
-test "${C2}" = "${C3}" || echo "file2 and file3 should match"
-test "${C2}" = "${C4}" || echo "file2 and file4 should match"
-test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum "$testdir/file3.chk" | _filter_test_dir
+md5sum "$testdir/file4.chk" | _filter_test_dir
+
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
+c3="$(_md5_checksum "$testdir/file3")"
+c4="$(_md5_checksum "$testdir/file4")"
+
+test "${c1}" = "${c2}" || echo "file1 and file2 should match"
+test "${c1}" = "${c3}" || echo "file1 and file3 should match"
+test "${c1}" = "${c4}" || echo "file1 and file4 should match"
+test "${c2}" = "${c3}" || echo "file2 and file3 should match"
+test "${c2}" = "${c4}" || echo "file2 and file4 should match"
+test "${c3}" = "${c4}" || echo "file3 and file4 should match"
 
 echo "fcollapse files"
-"$XFS_IO_PROG" -f -c "fcollapse 0 $BLKSZ" "$TESTDIR/file2"
-"$XFS_IO_PROG" -f -c "fcollapse $BLKSZ $BLKSZ" "$TESTDIR/file3"
-"$XFS_IO_PROG" -f -c "fcollapse $((BLKSZ * 2)) $BLKSZ" "$TESTDIR/file4"
+"$XFS_IO_PROG" -f -c "fcollapse 0 $blksz" "$testdir/file2"
+"$XFS_IO_PROG" -f -c "fcollapse $blksz $blksz" "$testdir/file3"
+"$XFS_IO_PROG" -f -c "fcollapse $((blksz * 2)) $blksz" "$testdir/file4"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
-md5sum "$TESTDIR/file3.chk" | _filter_test_dir
-md5sum "$TESTDIR/file4.chk" | _filter_test_dir
-
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
-C3="$(_md5_checksum "$TESTDIR/file3")"
-C4="$(_md5_checksum "$TESTDIR/file4")"
-
-test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
-test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
-test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
-test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
-test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
-test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum "$testdir/file3.chk" | _filter_test_dir
+md5sum "$testdir/file4.chk" | _filter_test_dir
+
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
+c3="$(_md5_checksum "$testdir/file3")"
+c4="$(_md5_checksum "$testdir/file4")"
+
+test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
+test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
+test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
+test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
+test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
+test "${c3}" != "${c4}" || echo "file3 and file4 should not match"
 
 echo "Compare against check files"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
-cmp -s "$TESTDIR/file3" "$TESTDIR/file3.chk" || echo "file3 and file3.chk do not match"
-cmp -s "$TESTDIR/file4" "$TESTDIR/file4.chk" || echo "file4 and file4.chk do not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$testdir/file3" "$testdir/file3.chk" || echo "file3 and file3.chk do not match"
+cmp -s "$testdir/file4" "$testdir/file4.chk" || echo "file4 and file4.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/146 b/tests/generic/146
index 9e3eff6..17dc306 100755
--- a/tests/generic/146
+++ b/tests/generic/146
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -52,84 +52,84 @@ _require_xfs_io_command "fpunch"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file3"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file4"
-
-_pwrite_byte 0x00 0 $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $BLKSZ $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file1" >> "$seqres.full"
+
+_cp_reflink "$testdir/file1" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file3"
+_cp_reflink "$testdir/file1" "$testdir/file4"
+
+_pwrite_byte 0x00 0 $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $blksz "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $blksz $blksz "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((blksz * 2)) $blksz "$testdir/file4.chk" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
-md5sum "$TESTDIR/file3.chk" | _filter_test_dir
-md5sum "$TESTDIR/file4.chk" | _filter_test_dir
-
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
-C3="$(_md5_checksum "$TESTDIR/file3")"
-C4="$(_md5_checksum "$TESTDIR/file4")"
-
-test "${C1}" = "${C2}" || echo "file1 and file2 should match"
-test "${C1}" = "${C3}" || echo "file1 and file3 should match"
-test "${C1}" = "${C4}" || echo "file1 and file4 should match"
-test "${C2}" = "${C3}" || echo "file2 and file3 should match"
-test "${C2}" = "${C4}" || echo "file2 and file4 should match"
-test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum "$testdir/file3.chk" | _filter_test_dir
+md5sum "$testdir/file4.chk" | _filter_test_dir
+
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
+c3="$(_md5_checksum "$testdir/file3")"
+c4="$(_md5_checksum "$testdir/file4")"
+
+test "${c1}" = "${c2}" || echo "file1 and file2 should match"
+test "${c1}" = "${c3}" || echo "file1 and file3 should match"
+test "${c1}" = "${c4}" || echo "file1 and file4 should match"
+test "${c2}" = "${c3}" || echo "file2 and file3 should match"
+test "${c2}" = "${c4}" || echo "file2 and file4 should match"
+test "${c3}" = "${c4}" || echo "file3 and file4 should match"
 
 echo "fpunch files"
-"$XFS_IO_PROG" -f -c "fpunch 0 $BLKSZ" "$TESTDIR/file2"
-"$XFS_IO_PROG" -f -c "fpunch $BLKSZ $BLKSZ" "$TESTDIR/file3"
-"$XFS_IO_PROG" -f -c "fpunch $((BLKSZ * 2)) $BLKSZ" "$TESTDIR/file4"
+"$XFS_IO_PROG" -f -c "fpunch 0 $blksz" "$testdir/file2"
+"$XFS_IO_PROG" -f -c "fpunch $blksz $blksz" "$testdir/file3"
+"$XFS_IO_PROG" -f -c "fpunch $((blksz * 2)) $blksz" "$testdir/file4"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
-md5sum "$TESTDIR/file3.chk" | _filter_test_dir
-md5sum "$TESTDIR/file4.chk" | _filter_test_dir
-
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
-C3="$(_md5_checksum "$TESTDIR/file3")"
-C4="$(_md5_checksum "$TESTDIR/file4")"
-
-test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
-test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
-test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
-test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
-test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
-test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum "$testdir/file3.chk" | _filter_test_dir
+md5sum "$testdir/file4.chk" | _filter_test_dir
+
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
+c3="$(_md5_checksum "$testdir/file3")"
+c4="$(_md5_checksum "$testdir/file4")"
+
+test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
+test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
+test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
+test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
+test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
+test "${c3}" != "${c4}" || echo "file3 and file4 should not match"
 
 echo "Compare against check files"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
-cmp -s "$TESTDIR/file3" "$TESTDIR/file3.chk" || echo "file3 and file3.chk do not match"
-cmp -s "$TESTDIR/file4" "$TESTDIR/file4.chk" || echo "file4 and file4.chk do not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$testdir/file3" "$testdir/file3.chk" || echo "file3 and file3.chk do not match"
+cmp -s "$testdir/file4" "$testdir/file4.chk" || echo "file4 and file4.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/147 b/tests/generic/147
index c35bdd9..b160131 100755
--- a/tests/generic/147
+++ b/tests/generic/147
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -52,87 +52,87 @@ _require_xfs_io_command "finsert"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file3"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file4"
-
-_pwrite_byte 0x00 0 $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $BLKSZ $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file1" >> "$seqres.full"
+
+_cp_reflink "$testdir/file1" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file3"
+_cp_reflink "$testdir/file1" "$testdir/file4"
+
+_pwrite_byte 0x00 0 $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $blksz "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $blksz $blksz "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $((blksz * 2)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * 3)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((blksz * 2)) $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * 3)) $blksz "$testdir/file4.chk" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
-md5sum "$TESTDIR/file3.chk" | _filter_test_dir
-md5sum "$TESTDIR/file4.chk" | _filter_test_dir
-
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
-C3="$(_md5_checksum "$TESTDIR/file3")"
-C4="$(_md5_checksum "$TESTDIR/file4")"
-
-test "${C1}" = "${C2}" || echo "file1 and file2 should match"
-test "${C1}" = "${C3}" || echo "file1 and file3 should match"
-test "${C1}" = "${C4}" || echo "file1 and file4 should match"
-test "${C2}" = "${C3}" || echo "file2 and file3 should match"
-test "${C2}" = "${C4}" || echo "file2 and file4 should match"
-test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum "$testdir/file3.chk" | _filter_test_dir
+md5sum "$testdir/file4.chk" | _filter_test_dir
+
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
+c3="$(_md5_checksum "$testdir/file3")"
+c4="$(_md5_checksum "$testdir/file4")"
+
+test "${c1}" = "${c2}" || echo "file1 and file2 should match"
+test "${c1}" = "${c3}" || echo "file1 and file3 should match"
+test "${c1}" = "${c4}" || echo "file1 and file4 should match"
+test "${c2}" = "${c3}" || echo "file2 and file3 should match"
+test "${c2}" = "${c4}" || echo "file2 and file4 should match"
+test "${c3}" = "${c4}" || echo "file3 and file4 should match"
 
 echo "finsert files"
-"$XFS_IO_PROG" -f -c "finsert 0 $BLKSZ" "$TESTDIR/file2"
-"$XFS_IO_PROG" -f -c "finsert $BLKSZ $BLKSZ" "$TESTDIR/file3"
-"$XFS_IO_PROG" -f -c "finsert $((BLKSZ * 2)) $BLKSZ" "$TESTDIR/file4"
+"$XFS_IO_PROG" -f -c "finsert 0 $blksz" "$testdir/file2"
+"$XFS_IO_PROG" -f -c "finsert $blksz $blksz" "$testdir/file3"
+"$XFS_IO_PROG" -f -c "finsert $((blksz * 2)) $blksz" "$testdir/file4"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
-md5sum "$TESTDIR/file3.chk" | _filter_test_dir
-md5sum "$TESTDIR/file4.chk" | _filter_test_dir
-
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
-C3="$(_md5_checksum "$TESTDIR/file3")"
-C4="$(_md5_checksum "$TESTDIR/file4")"
-
-test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
-test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
-test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
-test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
-test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
-test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum "$testdir/file3.chk" | _filter_test_dir
+md5sum "$testdir/file4.chk" | _filter_test_dir
+
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
+c3="$(_md5_checksum "$testdir/file3")"
+c4="$(_md5_checksum "$testdir/file4")"
+
+test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
+test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
+test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
+test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
+test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
+test "${c3}" != "${c4}" || echo "file3 and file4 should not match"
 
 echo "Compare against check files"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
-cmp -s "$TESTDIR/file3" "$TESTDIR/file3.chk" || echo "file3 and file3.chk do not match"
-cmp -s "$TESTDIR/file4" "$TESTDIR/file4.chk" || echo "file4 and file4.chk do not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$testdir/file3" "$testdir/file3.chk" || echo "file3 and file3.chk do not match"
+cmp -s "$testdir/file4" "$testdir/file4.chk" || echo "file4 and file4.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/148 b/tests/generic/148
index 3d7a762..cf5567b 100755
--- a/tests/generic/148
+++ b/tests/generic/148
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -53,63 +53,63 @@ _require_xfs_io_command "truncate"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ 37 "$TESTDIR/file1" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz 37 "$testdir/file1" >> "$seqres.full"
 
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file3"
+_cp_reflink "$testdir/file1" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file3"
 
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ 34 "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz 34 "$testdir/file2.chk" >> "$seqres.full"
 
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ 37 "$TESTDIR/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((BLKSZ + 37)) 3 "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $blksz "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz 37 "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((blksz + 37)) 3 "$testdir/file3.chk" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
-md5sum "$TESTDIR/file3.chk" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum "$testdir/file3.chk" | _filter_test_dir
 
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
-C3="$(_md5_checksum "$TESTDIR/file3")"
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
+c3="$(_md5_checksum "$testdir/file3")"
 
-test "${C1}" = "${C2}" || echo "file1 and file2 should match"
-test "${C1}" = "${C3}" || echo "file1 and file3 should match"
-test "${C2}" = "${C3}" || echo "file2 and file3 should match"
+test "${c1}" = "${c2}" || echo "file1 and file2 should match"
+test "${c1}" = "${c3}" || echo "file1 and file3 should match"
+test "${c2}" = "${c3}" || echo "file2 and file3 should match"
 
 echo "truncate files"
-"$XFS_IO_PROG" -f -c "truncate $((BLKSZ + 34))" "$TESTDIR/file2"
-"$XFS_IO_PROG" -f -c "truncate $((BLKSZ + 40))" "$TESTDIR/file3"
+"$XFS_IO_PROG" -f -c "truncate $((blksz + 34))" "$testdir/file2"
+"$XFS_IO_PROG" -f -c "truncate $((blksz + 40))" "$testdir/file3"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
-md5sum "$TESTDIR/file3.chk" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum "$testdir/file3.chk" | _filter_test_dir
 
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
-C3="$(_md5_checksum "$TESTDIR/file3")"
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
+c3="$(_md5_checksum "$testdir/file3")"
 
-test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
-test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
-test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
+test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
+test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
 
 echo "Compare against check files"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
-cmp -s "$TESTDIR/file3" "$TESTDIR/file3.chk" || echo "file3 and file3.chk do not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$testdir/file3" "$testdir/file3.chk" || echo "file3 and file3.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/149 b/tests/generic/149
index 44b5ae4..7d3189e 100755
--- a/tests/generic/149
+++ b/tests/generic/149
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -52,84 +52,84 @@ _require_xfs_io_command "fzero"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file3"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file4"
-
-_pwrite_byte 0x00 0 $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
-
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $BLKSZ $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
-
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file4.chk" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file1" >> "$seqres.full"
+
+_cp_reflink "$testdir/file1" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file3"
+_cp_reflink "$testdir/file1" "$testdir/file4"
+
+_pwrite_byte 0x00 0 $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $blksz "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $blksz $blksz "$testdir/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * 2)) $blksz "$testdir/file3.chk" >> "$seqres.full"
+
+_pwrite_byte 0x61 0 $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $blksz "$testdir/file4.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((blksz * 2)) $blksz "$testdir/file4.chk" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
-md5sum "$TESTDIR/file3.chk" | _filter_test_dir
-md5sum "$TESTDIR/file4.chk" | _filter_test_dir
-
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
-C3="$(_md5_checksum "$TESTDIR/file3")"
-C4="$(_md5_checksum "$TESTDIR/file4")"
-
-test "${C1}" = "${C2}" || echo "file1 and file2 should match"
-test "${C1}" = "${C3}" || echo "file1 and file3 should match"
-test "${C1}" = "${C4}" || echo "file1 and file4 should match"
-test "${C2}" = "${C3}" || echo "file2 and file3 should match"
-test "${C2}" = "${C4}" || echo "file2 and file4 should match"
-test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum "$testdir/file3.chk" | _filter_test_dir
+md5sum "$testdir/file4.chk" | _filter_test_dir
+
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
+c3="$(_md5_checksum "$testdir/file3")"
+c4="$(_md5_checksum "$testdir/file4")"
+
+test "${c1}" = "${c2}" || echo "file1 and file2 should match"
+test "${c1}" = "${c3}" || echo "file1 and file3 should match"
+test "${c1}" = "${c4}" || echo "file1 and file4 should match"
+test "${c2}" = "${c3}" || echo "file2 and file3 should match"
+test "${c2}" = "${c4}" || echo "file2 and file4 should match"
+test "${c3}" = "${c4}" || echo "file3 and file4 should match"
 
 echo "fzero files"
-"$XFS_IO_PROG" -f -c "fzero 0 $BLKSZ" "$TESTDIR/file2"
-"$XFS_IO_PROG" -f -c "fzero $BLKSZ $BLKSZ" "$TESTDIR/file3"
-"$XFS_IO_PROG" -f -c "fzero $((BLKSZ * 2)) $BLKSZ" "$TESTDIR/file4"
+"$XFS_IO_PROG" -f -c "fzero 0 $blksz" "$testdir/file2"
+"$XFS_IO_PROG" -f -c "fzero $blksz $blksz" "$testdir/file3"
+"$XFS_IO_PROG" -f -c "fzero $((blksz * 2)) $blksz" "$testdir/file4"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file3" | _filter_test_dir
-md5sum "$TESTDIR/file4" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
-md5sum "$TESTDIR/file3.chk" | _filter_test_dir
-md5sum "$TESTDIR/file4.chk" | _filter_test_dir
-
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
-C3="$(_md5_checksum "$TESTDIR/file3")"
-C4="$(_md5_checksum "$TESTDIR/file4")"
-
-test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
-test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
-test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
-test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
-test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
-test "${C3}" != "${C4}" || echo "file3 and file4 should not match"
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file3" | _filter_test_dir
+md5sum "$testdir/file4" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
+md5sum "$testdir/file3.chk" | _filter_test_dir
+md5sum "$testdir/file4.chk" | _filter_test_dir
+
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
+c3="$(_md5_checksum "$testdir/file3")"
+c4="$(_md5_checksum "$testdir/file4")"
+
+test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
+test "${c1}" != "${c3}" || echo "file1 and file3 should not match"
+test "${c1}" != "${c4}" || echo "file1 and file4 should not match"
+test "${c2}" != "${c3}" || echo "file2 and file3 should not match"
+test "${c2}" != "${c4}" || echo "file2 and file4 should not match"
+test "${c3}" != "${c4}" || echo "file3 and file4 should not match"
 
 echo "Compare against check files"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
-cmp -s "$TESTDIR/file3" "$TESTDIR/file3.chk" || echo "file3 and file3.chk do not match"
-cmp -s "$TESTDIR/file4" "$TESTDIR/file4.chk" || echo "file4 and file4.chk do not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$testdir/file3" "$testdir/file3.chk" || echo "file3 and file3.chk do not match"
+cmp -s "$testdir/file4" "$testdir/file4.chk" || echo "file4 and file4.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/150 b/tests/generic/150
index 3046e92..f3a6311 100755
--- a/tests/generic/150
+++ b/tests/generic/150
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -50,28 +50,28 @@ _require_cp_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original file blocks"
-BLKSZ="$(stat -f $TESTDIR -c '%S')"
-BLKS=2000
-MARGIN=100
-SZ=$((BLKSZ * BLKS))
-NR=7
-_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+blksz="$(stat -f $testdir -c '%S')"
+blks=2000
+margin=100
+sz=$((blksz * blks))
+nr=7
+_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
 sync
-FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
+free_blocks0=$(stat -f "$testdir" -c '%f')
 
 echo "Create the reflink copies"
-for i in `seq 2 $NR`; do
-	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file.$i"
+for i in `seq 2 $nr`; do
+	_cp_reflink "$testdir/file1" "$testdir/file.$i"
 done
 _test_remount
-FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+free_blocks1=$(stat -f "$testdir" -c '%f')
 
-_within_tolerance "free blocks after reflink" $FREE_BLOCKS1 $FREE_BLOCKS0 $MARGIN -v
+_within_tolerance "free blocks after reflink" $free_blocks1 $free_blocks0 $margin -v
 
 # success, all done
 status=0
diff --git a/tests/generic/151 b/tests/generic/151
index c42ca1d..286b9ec 100755
--- a/tests/generic/151
+++ b/tests/generic/151
@@ -39,7 +39,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -54,44 +54,44 @@ _require_cp_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original file blocks"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-BLKS=2000
-MARGIN=100
-SZ=$((BLKSZ * BLKS))
-FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
-NR=7
-_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+blksz="$(stat -f "$testdir" -c '%S')"
+blks=2000
+margin=100
+sz=$((blksz * blks))
+free_blocks0=$(stat -f "$testdir" -c '%f')
+nr=7
+_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
 sync
 
 echo "Create the reflink copies"
-for i in `seq 2 $NR`; do
-	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file.$i"
+for i in `seq 2 $nr`; do
+	_cp_reflink "$testdir/file1" "$testdir/file.$i"
 done
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/survivor"
+_cp_reflink "$testdir/file1" "$testdir/survivor"
 _test_remount
-FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+free_blocks1=$(stat -f "$testdir" -c '%f')
 
 echo "Delete most of the files"
-rm -rf "$TESTDIR"/file*
+rm -rf "$testdir"/file*
 _test_remount
-FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+free_blocks2=$(stat -f "$testdir" -c '%f')
 
 echo "Delete all the files"
-rm -rf "$TESTDIR"/*
+rm -rf "$testdir"/*
 _test_remount
-FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
-#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3
+free_blocks3=$(stat -f "$testdir" -c '%f')
+#echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3
 
-_within_tolerance "free blocks after reflink" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+_within_tolerance "free blocks after reflink" $free_blocks1 $((free_blocks0 - blks)) $margin -v
 
-_within_tolerance "free blocks after deleting some reflink copies" $FREE_BLOCKS2 $FREE_BLOCKS1 $MARGIN -v
+_within_tolerance "free blocks after deleting some reflink copies" $free_blocks2 $free_blocks1 $margin -v
 
-_within_tolerance "free blocks after deleting all copies" $FREE_BLOCKS3 $FREE_BLOCKS0 $MARGIN -v
+_within_tolerance "free blocks after deleting all copies" $free_blocks3 $free_blocks0 $margin -v
 
 # success, all done
 status=0
diff --git a/tests/generic/152 b/tests/generic/152
index 95ffe40..506a754 100755
--- a/tests/generic/152
+++ b/tests/generic/152
@@ -39,7 +39,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -55,48 +55,48 @@ _require_xfs_io_command "fpunch"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original file blocks"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-BLKS=2000
-MARGIN=100
-SZ=$((BLKSZ * BLKS))
-FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
-NR=4
-_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+blksz="$(stat -f "$testdir" -c '%S')"
+blks=2000
+margin=100
+sz=$((blksz * blks))
+free_blocks0=$(stat -f "$testdir" -c '%f')
+nr=4
+_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
 sync
 
 echo "Create the reflink copies"
-for i in `seq 2 $NR`; do
-	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+for i in `seq 2 $nr`; do
+	_cp_reflink "$testdir/file1" "$testdir/file$i"
 done
 _test_remount
-FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+free_blocks1=$(stat -f "$testdir" -c '%f')
 
 echo "Punch most of the blocks"
-"$XFS_IO_PROG" -f -c "fpunch 0 $SZ" "$TESTDIR/file2"
-"$XFS_IO_PROG" -f -c "fpunch 0 $((SZ / 2))" "$TESTDIR/file3"
-"$XFS_IO_PROG" -f -c "fpunch $((SZ / 2)) $((SZ / 2))" "$TESTDIR/file4"
+"$XFS_IO_PROG" -f -c "fpunch 0 $sz" "$testdir/file2"
+"$XFS_IO_PROG" -f -c "fpunch 0 $((sz / 2))" "$testdir/file3"
+"$XFS_IO_PROG" -f -c "fpunch $((sz / 2)) $((sz / 2))" "$testdir/file4"
 _test_remount
-FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+free_blocks2=$(stat -f "$testdir" -c '%f')
 
 echo "Punch all the files"
-for i in `seq 2 $NR`; do
-	"$XFS_IO_PROG" -f -c "fpunch 0 $SZ" "$TESTDIR/file$i"
+for i in `seq 2 $nr`; do
+	"$XFS_IO_PROG" -f -c "fpunch 0 $sz" "$testdir/file$i"
 done
-"$XFS_IO_PROG" -f -c "fpunch 0 $SZ" "$TESTDIR/file1"
+"$XFS_IO_PROG" -f -c "fpunch 0 $sz" "$testdir/file1"
 _test_remount
-FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
-#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3
+free_blocks3=$(stat -f "$testdir" -c '%f')
+#echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3
 
-_within_tolerance "free blocks after reflink" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+_within_tolerance "free blocks after reflink" $free_blocks1 $((free_blocks0 - blks)) $margin -v
 
-_within_tolerance "free blocks after punching some reflink copies" $FREE_BLOCKS2 $FREE_BLOCKS1 $MARGIN -v
+_within_tolerance "free blocks after punching some reflink copies" $free_blocks2 $free_blocks1 $margin -v
 
-_within_tolerance "free blocks after punching all copies" $FREE_BLOCKS3 $FREE_BLOCKS0 $MARGIN -v
+_within_tolerance "free blocks after punching all copies" $free_blocks3 $free_blocks0 $margin -v
 
 # success, all done
 status=0
diff --git a/tests/generic/153 b/tests/generic/153
index 2deee20..011879e 100755
--- a/tests/generic/153
+++ b/tests/generic/153
@@ -39,7 +39,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -55,47 +55,47 @@ _require_xfs_io_command "fcollapse"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original file blocks"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-BLKS=2000
-MARGIN=100
-SZ=$((BLKSZ * BLKS))
-FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
-NR=4
-_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+blksz="$(stat -f "$testdir" -c '%S')"
+blks=2000
+margin=100
+sz=$((blksz * blks))
+free_blocks0=$(stat -f "$testdir" -c '%f')
+nr=4
+_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
 _test_remount
 
 echo "Create the reflink copies"
-for i in `seq 2 $NR`; do
-	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+for i in `seq 2 $nr`; do
+	_cp_reflink "$testdir/file1" "$testdir/file$i"
 done
 _test_remount
-FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+free_blocks1=$(stat -f "$testdir" -c '%f')
 
 echo "Collapse most of the blocks"
-"$XFS_IO_PROG" -f -c "fcollapse 0 $(((BLKS - 1) * BLKSZ))" $TESTDIR/file2
-"$XFS_IO_PROG" -f -c "fcollapse 0 $((SZ / 2))" $TESTDIR/file3
-"$XFS_IO_PROG" -f -c "fcollapse $((SZ / 2)) $(( ((BLKS / 2) - 1) * BLKSZ))" $TESTDIR/file4
+"$XFS_IO_PROG" -f -c "fcollapse 0 $(((blks - 1) * blksz))" $testdir/file2
+"$XFS_IO_PROG" -f -c "fcollapse 0 $((sz / 2))" $testdir/file3
+"$XFS_IO_PROG" -f -c "fcollapse $((sz / 2)) $(( ((blks / 2) - 1) * blksz))" $testdir/file4
 _test_remount
-FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+free_blocks2=$(stat -f "$testdir" -c '%f')
 
 echo "Collpase nearly all the files"
-"$XFS_IO_PROG" -f -c "fcollapse 0 $(( ((BLKS / 2) - 1) * BLKSZ))" $TESTDIR/file3
-"$XFS_IO_PROG" -f -c "fcollapse 0 $((SZ / 2))" $TESTDIR/file4
-"$XFS_IO_PROG" -f -c "fcollapse 0 $(( (BLKS - 1) * BLKSZ))" $TESTDIR/file1
+"$XFS_IO_PROG" -f -c "fcollapse 0 $(( ((blks / 2) - 1) * blksz))" $testdir/file3
+"$XFS_IO_PROG" -f -c "fcollapse 0 $((sz / 2))" $testdir/file4
+"$XFS_IO_PROG" -f -c "fcollapse 0 $(( (blks - 1) * blksz))" $testdir/file1
 _test_remount
-FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
-#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3
+free_blocks3=$(stat -f "$testdir" -c '%f')
+#echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3
 
-_within_tolerance "free blocks after reflink" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+_within_tolerance "free blocks after reflink" $free_blocks1 $((free_blocks0 - blks)) $margin -v
 
-_within_tolerance "free blocks after fcollapsing some reflink copies" $FREE_BLOCKS2 $FREE_BLOCKS1 $MARGIN -v
+_within_tolerance "free blocks after fcollapsing some reflink copies" $free_blocks2 $free_blocks1 $margin -v
 
-_within_tolerance "free blocks after fcollapsing all copies" $FREE_BLOCKS3 $FREE_BLOCKS0 $MARGIN -v
+_within_tolerance "free blocks after fcollapsing all copies" $free_blocks3 $free_blocks0 $margin -v
 
 # success, all done
 status=0
diff --git a/tests/generic/154 b/tests/generic/154
index 173b981..474c578 100755
--- a/tests/generic/154
+++ b/tests/generic/154
@@ -39,7 +39,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -54,56 +54,56 @@ _require_cp_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original file blocks"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-BLKS=2000
-MARGIN=100
-FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
-NR=4
-SZ=$((BLKS * BLKSZ))
-_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+blksz="$(stat -f "$testdir" -c '%S')"
+blks=2000
+margin=100
+free_blocks0=$(stat -f "$testdir" -c '%f')
+nr=4
+sz=$((blks * blksz))
+_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
 _test_remount
 
 echo "Create the reflink copies"
-for i in `seq 2 $NR`; do
-	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+for i in `seq 2 $nr`; do
+	_cp_reflink "$testdir/file1" "$testdir/file$i"
 done
 _test_remount
-FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+free_blocks1=$(stat -f "$testdir" -c '%f')
 
 echo "Rewrite some of the blocks"
-_pwrite_byte 0x62 0 $SZ "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x63 0 $((SZ / 2)) "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x64 $((SZ / 2)) $((SZ / 2)) "$TESTDIR/file4" >> "$seqres.full"
+_pwrite_byte 0x62 0 $sz "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x63 0 $((sz / 2)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x64 $((sz / 2)) $((sz / 2)) "$testdir/file4" >> "$seqres.full"
 _test_remount
-FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+free_blocks2=$(stat -f "$testdir" -c '%f')
 
 echo "Rewrite all the files"
-_pwrite_byte 0x62 0 $SZ "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x63 0 $SZ "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x64 0 $SZ "$TESTDIR/file4" >> "$seqres.full"
+_pwrite_byte 0x62 0 $sz "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x63 0 $sz "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x64 0 $sz "$testdir/file4" >> "$seqres.full"
 _test_remount
-FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
+free_blocks3=$(stat -f "$testdir" -c '%f')
 
 echo "Rewrite the original file"
-_pwrite_byte 0x65 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x65 0 $sz "$testdir/file1" >> "$seqres.full"
 _test_remount
-FREE_BLOCKS4=$(stat -f "$TESTDIR" -c '%f')
-#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3 $FREE_BLOCKS4
+free_blocks4=$(stat -f "$testdir" -c '%f')
+#echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3 $free_blocks4
 
-_within_tolerance "free blocks after reflinking" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+_within_tolerance "free blocks after reflinking" $free_blocks1 $((free_blocks0 - blks)) $margin -v
 
-_within_tolerance "free blocks after partially CoWing some copies" $FREE_BLOCKS2 $((FREE_BLOCKS1 - (2 * BLKS))) $MARGIN -v
+_within_tolerance "free blocks after partially CoWing some copies" $free_blocks2 $((free_blocks1 - (2 * blks))) $margin -v
 
-_within_tolerance "free blocks after CoWing all copies" $FREE_BLOCKS3 $((FREE_BLOCKS2 - BLKS)) $MARGIN -v
+_within_tolerance "free blocks after CoWing all copies" $free_blocks3 $((free_blocks2 - blks)) $margin -v
 
-_within_tolerance "free blocks after overwriting original" $FREE_BLOCKS4 $FREE_BLOCKS3 $MARGIN -v
+_within_tolerance "free blocks after overwriting original" $free_blocks4 $free_blocks3 $margin -v
 
-_within_tolerance "free blocks after all tests" $FREE_BLOCKS4 $((FREE_BLOCKS0 - (4 * BLKS))) $MARGIN -v
+_within_tolerance "free blocks after all tests" $free_blocks4 $((free_blocks0 - (4 * blks))) $margin -v
 
 # success, all done
 status=0
diff --git a/tests/generic/155 b/tests/generic/155
index 2551295..611cf1a 100755
--- a/tests/generic/155
+++ b/tests/generic/155
@@ -42,7 +42,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -58,56 +58,56 @@ _require_xfs_io_command "fzero"
 
 rm -f "$seqres.full"
 
-TESTDIR=$TEST_DIR/test-$seq
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir=$TEST_DIR/test-$seq
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original file blocks"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-BLKS=2000
-MARGIN=100
-SZ=$((BLKSZ * BLKS))
-FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
-NR=4
-_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+blksz="$(stat -f "$testdir" -c '%S')"
+blks=2000
+margin=100
+sz=$((blksz * blks))
+free_blocks0=$(stat -f "$testdir" -c '%f')
+nr=4
+_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
 _test_remount
 
 echo "Create the reflink copies"
-for i in `seq 2 $NR`; do
-	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+for i in `seq 2 $nr`; do
+	_cp_reflink "$testdir/file1" "$testdir/file$i"
 done
 _test_remount
-FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+free_blocks1=$(stat -f "$testdir" -c '%f')
 
 echo "Rewrite some of the blocks"
-"$XFS_IO_PROG" -f -c "fzero 0 $SZ" "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x63 0 $((SZ / 2)) "$TESTDIR/file3" -d >> "$seqres.full"
-_mwrite_byte 0x64 $((SZ / 2)) $((SZ / 2)) $SZ "$TESTDIR/file4" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "fzero 0 $sz" "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x63 0 $((sz / 2)) "$testdir/file3" -d >> "$seqres.full"
+_mwrite_byte 0x64 $((sz / 2)) $((sz / 2)) $sz "$testdir/file4" >> "$seqres.full"
 _test_remount
-FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+free_blocks2=$(stat -f "$testdir" -c '%f')
 
 echo "Rewrite all the files"
-_pwrite_byte 0x62 0 $SZ "$TESTDIR/file2" -d >> "$seqres.full"
-_mwrite_byte 0x63 0 $SZ $SZ "$TESTDIR/file3" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "fzero 0 $SZ" $TESTDIR/file4 >> "$seqres.full"
+_pwrite_byte 0x62 0 $sz "$testdir/file2" -d >> "$seqres.full"
+_mwrite_byte 0x63 0 $sz $sz "$testdir/file3" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "fzero 0 $sz" $testdir/file4 >> "$seqres.full"
 _test_remount
-FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
+free_blocks3=$(stat -f "$testdir" -c '%f')
 
 echo "Rewrite the original file"
-_pwrite_byte 0x65 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x65 0 $sz "$testdir/file1" >> "$seqres.full"
 _test_remount
-FREE_BLOCKS4=$(stat -f "$TESTDIR" -c '%f')
-#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3 $FREE_BLOCKS4
+free_blocks4=$(stat -f "$testdir" -c '%f')
+#echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3 $free_blocks4
 
-_within_tolerance "free blocks after reflinking" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+_within_tolerance "free blocks after reflinking" $free_blocks1 $((free_blocks0 - blks)) $margin -v
 
-_within_tolerance "free blocks after partially CoWing some copies" $FREE_BLOCKS2 $((FREE_BLOCKS1 - (2 * BLKS))) $MARGIN -v
+_within_tolerance "free blocks after partially CoWing some copies" $free_blocks2 $((free_blocks1 - (2 * blks))) $margin -v
 
-_within_tolerance "free blocks after CoWing all copies" $FREE_BLOCKS3 $((FREE_BLOCKS2 - BLKS)) $MARGIN -v
+_within_tolerance "free blocks after CoWing all copies" $free_blocks3 $((free_blocks2 - blks)) $margin -v
 
-_within_tolerance "free blocks after overwriting original" $FREE_BLOCKS4 $FREE_BLOCKS3 $MARGIN -v
+_within_tolerance "free blocks after overwriting original" $free_blocks4 $free_blocks3 $margin -v
 
-_within_tolerance "free blocks after all tests" $FREE_BLOCKS4 $((FREE_BLOCKS0 - (4 * BLKS))) $MARGIN -v
+_within_tolerance "free blocks after all tests" $free_blocks4 $((free_blocks0 - (4 * blks))) $margin -v
 
 # success, all done
 status=0
diff --git a/tests/generic/156 b/tests/generic/156
index 78b7e8c..7194e87 100755
--- a/tests/generic/156
+++ b/tests/generic/156
@@ -45,7 +45,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -66,58 +66,58 @@ _require_xfs_io_command "falloc"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original file blocks"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-BLKS=2000
-MARGIN=100
-SZ=$((BLKSZ * BLKS))
-FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
-NR=4
-_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+blksz="$(stat -f "$testdir" -c '%S')"
+blks=2000
+margin=100
+sz=$((blksz * blks))
+free_blocks0=$(stat -f "$testdir" -c '%f')
+nr=4
+_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
 _test_remount
 
 echo "Create the reflink copies"
-for i in `seq 2 $NR`; do
-	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+for i in `seq 2 $nr`; do
+	_cp_reflink "$testdir/file1" "$testdir/file$i"
 done
 _test_remount
-FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+free_blocks1=$(stat -f "$testdir" -c '%f')
 
 echo "funshare part of a file"
-"$XFS_IO_PROG" -f -c "falloc 0 $((SZ / 2))" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "falloc 0 $((sz / 2))" "$testdir/file2"
 _test_remount
 
 echo "funshare some of the copies"
-"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file2"
-"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file3"
+"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file2"
+"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file3"
 _test_remount
-FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+free_blocks2=$(stat -f "$testdir" -c '%f')
 
 echo "funshare the rest of the files"
-"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file4"
-"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file1"
+"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file4"
+"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file1"
 _test_remount
-FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
+free_blocks3=$(stat -f "$testdir" -c '%f')
 
 echo "Rewrite the original file"
-_pwrite_byte 0x65 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x65 0 $sz "$testdir/file1" >> "$seqres.full"
 _test_remount
-FREE_BLOCKS4=$(stat -f "$TESTDIR" -c '%f')
-#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3 $FREE_BLOCKS4
+free_blocks4=$(stat -f "$testdir" -c '%f')
+#echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3 $free_blocks4
 
-_within_tolerance "free blocks after reflinking" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+_within_tolerance "free blocks after reflinking" $free_blocks1 $((free_blocks0 - blks)) $margin -v
 
-_within_tolerance "free blocks after nocow'ing some copies" $FREE_BLOCKS2 $((FREE_BLOCKS1 - (2 * BLKS))) $MARGIN -v
+_within_tolerance "free blocks after nocow'ing some copies" $free_blocks2 $((free_blocks1 - (2 * blks))) $margin -v
 
-_within_tolerance "free blocks after nocow'ing all copies" $FREE_BLOCKS3 $((FREE_BLOCKS2 - BLKS)) $MARGIN -v
+_within_tolerance "free blocks after nocow'ing all copies" $free_blocks3 $((free_blocks2 - blks)) $margin -v
 
-_within_tolerance "free blocks after overwriting original" $FREE_BLOCKS4 $FREE_BLOCKS3 $MARGIN -v
+_within_tolerance "free blocks after overwriting original" $free_blocks4 $free_blocks3 $margin -v
 
-_within_tolerance "free blocks after all tests" $FREE_BLOCKS4 $((FREE_BLOCKS0 - (4 * BLKS))) $MARGIN -v
+_within_tolerance "free blocks after all tests" $free_blocks4 $((free_blocks0 - (4 * blks))) $margin -v
 
 # success, all done
 status=0
diff --git a/tests/generic/157 b/tests/generic/157
index 67f3ea5..a5b84fc 100755
--- a/tests/generic/157
+++ b/tests/generic/157
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$testdir1"
 }
 
 # get standard environment, filters and checks
@@ -52,31 +52,31 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR1="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR1"
-mkdir "$TESTDIR1"
+testdir1="$TEST_DIR/test-$seq"
+rm -rf "$testdir1"
+mkdir "$testdir1"
 
-TESTDIR2=$SCRATCH_MNT/test-$seq
-rm -rf "$TESTDIR2"
-mkdir "$TESTDIR2"
+testdir2=$SCRATCH_MNT/test-$seq
+rm -rf "$testdir2"
+mkdir "$testdir2"
 
 echo "Create the original files"
-BLKSZ="$(stat -f $TESTDIR1 -c '%S')"
-BLKS=1000
-MARGIN=50
-SZ=$((BLKSZ * BLKS))
-FREE_BLOCKS0=$(stat -f $TESTDIR1 -c '%f')
-NR=4
-_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $SZ "$TESTDIR2/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $SZ "$TESTDIR2/file2" >> "$seqres.full"
-mkdir "$TESTDIR1/dir1"
-seq 1 $((2 * BLKSZ / 250)) | while read f; do
-	touch "$TESTDIR1/dir1/$f"
+blksz="$(stat -f $testdir1 -c '%S')"
+blks=1000
+margin=50
+sz=$((blksz * blks))
+free_blocks0=$(stat -f $testdir1 -c '%f')
+nr=4
+_pwrite_byte 0x61 0 $sz "$testdir1/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz "$testdir1/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz "$testdir2/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz "$testdir2/file2" >> "$seqres.full"
+mkdir "$testdir1/dir1"
+seq 1 $((2 * blksz / 250)) | while read f; do
+	touch "$testdir1/dir1/$f"
 done
-mknod "$TESTDIR1/dev1" c 1 3
-mkfifo "$TESTDIR1/fifo1"
+mknod "$testdir1/dev1" c 1 3
+mkfifo "$testdir1/fifo1"
 sync
 
 _filter_enotty() {
@@ -88,38 +88,38 @@ _filter_einval() {
 }
 
 echo "Try cross-device reflink"
-_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR2/file1" 0 $BLKSZ
+_reflink_range "$testdir1/file1" 0 "$testdir2/file1" 0 $blksz
 
 echo "Try unaligned reflink"
-_reflink_range "$TESTDIR1/file1" 37 "$TESTDIR1/file1" 59 23
+_reflink_range "$testdir1/file1" 37 "$testdir1/file1" 59 23
 
 echo "Try overlapping reflink"
-_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file1" 1 $((BLKSZ * 2))
+_reflink_range "$testdir1/file1" 0 "$testdir1/file1" 1 $((blksz * 2))
 
 echo "Try reflink past EOF"
-_reflink_range "$TESTDIR1/file1" $(( (BLKS + 10) * BLKSZ)) "$TESTDIR1/file1" 0 $BLKSZ
+_reflink_range "$testdir1/file1" $(( (blks + 10) * blksz)) "$testdir1/file1" 0 $blksz
 
 echo "Try to reflink a dir"
-_reflink_range "$TESTDIR1/dir1" 0 "$TESTDIR1/file2" 0 $BLKSZ
+_reflink_range "$testdir1/dir1" 0 "$testdir1/file2" 0 $blksz
 
 echo "Try to reflink a device"
-_reflink_range "$TESTDIR1/dev1" 0 "$TESTDIR1/file2" 0 $BLKSZ
+_reflink_range "$testdir1/dev1" 0 "$testdir1/file2" 0 $blksz
 
 echo "Try to reflink to a dir"
-_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/dir1" 0 $BLKSZ 2>&1 | _filter_test_dir
+_reflink_range "$testdir1/file1" 0 "$testdir1/dir1" 0 $blksz 2>&1 | _filter_test_dir
 
 echo "Try to reflink to a device"
-_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/dev1" 0 $BLKSZ 2>&1 | _filter_enotty
+_reflink_range "$testdir1/file1" 0 "$testdir1/dev1" 0 $blksz 2>&1 | _filter_enotty
 
 echo "Try to reflink to a fifo"
-_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/fifo1" 0 $BLKSZ -n 2>&1 | _filter_enotty
+_reflink_range "$testdir1/file1" 0 "$testdir1/fifo1" 0 $blksz -n 2>&1 | _filter_enotty
 
 echo "Try to reflink an append-only file"
-_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file3" 0 $BLKSZ -a 2>&1 | _filter_einval
+_reflink_range "$testdir1/file1" 0 "$testdir1/file3" 0 $blksz -a 2>&1 | _filter_einval
 
 echo "Reflink two files"
-_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ >> "$seqres.full"
-_reflink_range "$TESTDIR2/file1" 0 "$TESTDIR2/file2" 0 $BLKSZ >> "$seqres.full"
+_reflink_range "$testdir1/file1" 0 "$testdir1/file2" 0 $blksz >> "$seqres.full"
+_reflink_range "$testdir2/file1" 0 "$testdir2/file2" 0 $blksz >> "$seqres.full"
 
 echo "Check scratch fs"
 _scratch_unmount
diff --git a/tests/generic/158 b/tests/generic/158
index 18bda38..58b7090 100755
--- a/tests/generic/158
+++ b/tests/generic/158
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$testdir1"
 }
 
 # get standard environment, filters and checks
@@ -52,32 +52,32 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR1="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR1"
-mkdir "$TESTDIR1"
+testdir1="$TEST_DIR/test-$seq"
+rm -rf "$testdir1"
+mkdir "$testdir1"
 
-TESTDIR2=$SCRATCH_MNT/test-$seq
-rm -rf "$TESTDIR2"
-mkdir "$TESTDIR2"
+testdir2=$SCRATCH_MNT/test-$seq
+rm -rf "$testdir2"
+mkdir "$testdir2"
 
 echo "Create the original files"
-BLKSZ="$(stat -f $TESTDIR1 -c '%S')"
-BLKS=1000
-MARGIN=50
-SZ=$((BLKSZ * BLKS))
-FREE_BLOCKS0=$(stat -f $TESTDIR1 -c '%f')
-NR=4
-_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file3" >> "$seqres.full"
-_pwrite_byte 0x61 0 $SZ "$TESTDIR2/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $SZ "$TESTDIR2/file2" >> "$seqres.full"
-mkdir "$TESTDIR1/dir1"
-seq 1 $((2 * BLKSZ / 250)) | while read f; do
-	touch "$TESTDIR1/dir1/$f"
+blksz="$(stat -f $testdir1 -c '%S')"
+blks=1000
+margin=50
+sz=$((blksz * blks))
+free_blocks0=$(stat -f $testdir1 -c '%f')
+nr=4
+_pwrite_byte 0x61 0 $sz "$testdir1/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz "$testdir1/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz "$testdir1/file3" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz "$testdir2/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz "$testdir2/file2" >> "$seqres.full"
+mkdir "$testdir1/dir1"
+seq 1 $((2 * blksz / 250)) | while read f; do
+	touch "$testdir1/dir1/$f"
 done
-mknod "$TESTDIR1/dev1" c 1 3
-mkfifo "$TESTDIR1/fifo1"
+mknod "$testdir1/dev1" c 1 3
+mkfifo "$testdir1/fifo1"
 sync
 
 _filter_enotty() {
@@ -89,38 +89,38 @@ _filter_eperm() {
 }
 
 echo "Try cross-device dedupe"
-_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR2/file1" 0 $BLKSZ
+_dedupe_range "$testdir1/file1" 0 "$testdir2/file1" 0 $blksz
 
 echo "Try unaligned dedupe"
-_dedupe_range "$TESTDIR1/file1" 37 "$TESTDIR1/file1" 59 23
+_dedupe_range "$testdir1/file1" 37 "$testdir1/file1" 59 23
 
 echo "Try overlapping dedupe"
-_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/file1" 1 $((BLKSZ * 2))
+_dedupe_range "$testdir1/file1" 0 "$testdir1/file1" 1 $((blksz * 2))
 
 echo "Try dedupe past EOF"
-_dedupe_range "$TESTDIR1/file1" $(( (BLKS + 10) * BLKSZ)) "$TESTDIR1/file1" 0 $BLKSZ
+_dedupe_range "$testdir1/file1" $(( (blks + 10) * blksz)) "$testdir1/file1" 0 $blksz
 
 echo "Try to dedupe a dir"
-_dedupe_range "$TESTDIR1/dir1" 0 "$TESTDIR1/file2" 0 $BLKSZ
+_dedupe_range "$testdir1/dir1" 0 "$testdir1/file2" 0 $blksz
 
 echo "Try to dedupe a device"
-_dedupe_range "$TESTDIR1/dev1" 0 "$TESTDIR1/file2" 0 $BLKSZ 2>&1 | _filter_enotty
+_dedupe_range "$testdir1/dev1" 0 "$testdir1/file2" 0 $blksz 2>&1 | _filter_enotty
 
 echo "Try to dedupe to a dir"
-_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/dir1" 0 $BLKSZ 2>&1 | _filter_test_dir
+_dedupe_range "$testdir1/file1" 0 "$testdir1/dir1" 0 $blksz 2>&1 | _filter_test_dir
 
 echo "Try to dedupe to a device"
-_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/dev1" 0 $BLKSZ 2>&1 | _filter_eperm
+_dedupe_range "$testdir1/file1" 0 "$testdir1/dev1" 0 $blksz 2>&1 | _filter_eperm
 
 echo "Try to dedupe to a fifo"
-_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/fifo1" 0 $BLKSZ -n 2>&1 | _filter_eperm
+_dedupe_range "$testdir1/file1" 0 "$testdir1/fifo1" 0 $blksz -n 2>&1 | _filter_eperm
 
 echo "Try to dedupe an append-only file"
-_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/file3" 0 $BLKSZ -a >> "$seqres.full"
+_dedupe_range "$testdir1/file1" 0 "$testdir1/file3" 0 $blksz -a >> "$seqres.full"
 
 echo "Dedupe two files"
-_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ >> "$seqres.full"
-_dedupe_range "$TESTDIR2/file1" 0 "$TESTDIR2/file2" 0 $BLKSZ >> "$seqres.full"
+_dedupe_range "$testdir1/file1" 0 "$testdir1/file2" 0 $blksz >> "$seqres.full"
+_dedupe_range "$testdir2/file1" 0 "$testdir2/file2" 0 $blksz >> "$seqres.full"
 
 echo "Check scratch fs"
 _scratch_unmount
diff --git a/tests/generic/159 b/tests/generic/159
index 369663d..14baf64 100755
--- a/tests/generic/159
+++ b/tests/generic/159
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$testdir1"
 }
 
 # get standard environment, filters and checks
@@ -49,25 +49,25 @@ _require_test_reflink
 rm -f "$seqres.full"
 
 echo "Format and mount"
-TESTDIR1="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR1"
-mkdir "$TESTDIR1"
+testdir1="$TEST_DIR/test-$seq"
+rm -rf "$testdir1"
+mkdir "$testdir1"
 
 echo "Create the original files"
-BLKSZ="$(stat -f $TESTDIR1 -c '%S')"
-BLKS=1000
-MARGIN=50
-SZ=$((BLKSZ * BLKS))
-FREE_BLOCKS0=$(stat -f $TESTDIR1 -c '%f')
-NR=4
-_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file2" >> "$seqres.full"
+blksz="$(stat -f $testdir1 -c '%S')"
+blks=1000
+margin=50
+sz=$((blksz * blks))
+free_blocks0=$(stat -f $testdir1 -c '%f')
+nr=4
+_pwrite_byte 0x61 0 $sz "$testdir1/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz "$testdir1/file2" >> "$seqres.full"
 sync
 
 echo "Try reflink on immutable files"
-$CHATTR_PROG +i $TESTDIR1/file1 $TESTDIR1/file2
-_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ 2>&1 | _filter_test_dir
-$CHATTR_PROG -i $TESTDIR1/file1 $TESTDIR1/file2
+$CHATTR_PROG +i $testdir1/file1 $testdir1/file2
+_reflink_range "$testdir1/file1" 0 "$testdir1/file2" 0 $blksz 2>&1 | _filter_test_dir
+$CHATTR_PROG -i $testdir1/file1 $testdir1/file2
 
 # success, all done
 status=0
diff --git a/tests/generic/160 b/tests/generic/160
index 4dfee12..acd2c4e 100755
--- a/tests/generic/160
+++ b/tests/generic/160
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$testdir1"
 }
 
 # get standard environment, filters and checks
@@ -49,25 +49,25 @@ _require_test_dedupe
 rm -f "$seqres.full"
 
 echo "Format and mount"
-TESTDIR1="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR1"
-mkdir "$TESTDIR1"
+testdir1="$TEST_DIR/test-$seq"
+rm -rf "$testdir1"
+mkdir "$testdir1"
 
 echo "Create the original files"
-BLKSZ="$(stat -f $TESTDIR1 -c '%S')"
-BLKS=1000
-MARGIN=50
-SZ=$((BLKSZ * BLKS))
-FREE_BLOCKS0=$(stat -f $TESTDIR1 -c '%f')
-NR=4
-_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file2" >> "$seqres.full"
+blksz="$(stat -f $testdir1 -c '%S')"
+blks=1000
+margin=50
+sz=$((blksz * blks))
+free_blocks0=$(stat -f $testdir1 -c '%f')
+nr=4
+_pwrite_byte 0x61 0 $sz "$testdir1/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz "$testdir1/file2" >> "$seqres.full"
 sync
 
 echo "Try dedupe on immutable files"
-$CHATTR_PROG +i $TESTDIR1/file1 $TESTDIR1/file2
-_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ 2>&1 | _filter_test_dir
-$CHATTR_PROG -i $TESTDIR1/file1 $TESTDIR1/file2
+$CHATTR_PROG +i $testdir1/file1 $testdir1/file2
+_dedupe_range "$testdir1/file1" 0 "$testdir1/file2" 0 $blksz 2>&1 | _filter_test_dir
+$CHATTR_PROG -i $testdir1/file1 $testdir1/file2
 
 # success, all done
 status=0
diff --git a/tests/generic/161 b/tests/generic/161
index efb137c..7fb8963 100755
--- a/tests/generic/161
+++ b/tests/generic/161
@@ -51,22 +51,22 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 loops=4096
-BLKSZ=65536
+blksz=65536
 
 echo "Initialize files"
 echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2"
 _scratch_remount
 
 echo "Delete while rewriting"
-rm -rf "$TESTDIR/file1" &
-_pwrite_byte 0x62 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+rm -rf "$testdir/file1" &
+_pwrite_byte 0x62 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
 wait
 
 echo "Check fs"
diff --git a/tests/generic/162 b/tests/generic/162
index 6bd3a33..2fb947a 100755
--- a/tests/generic/162
+++ b/tests/generic/162
@@ -50,24 +50,24 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 loops=512
 nr_loops=$((loops - 1))
-BLKSZ=65536
+blksz=65536
 
 echo "Initialize files"
 echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file2" >> "$seqres.full"
 _scratch_remount
 
 overwrite() {
-	while [ ! -e "$TESTDIR/finished" ]; do
+	while [ ! -e "$testdir/finished" ]; do
 		seq $nr_loops -1 0 | while read i; do
-			_pwrite_byte 0x61 $((i * BLKSZ)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+			_pwrite_byte 0x61 $((i * blksz)) $blksz "$testdir/file2" >> "$seqres.full"
 		done
 	done
 }
@@ -76,13 +76,13 @@ echo "Dedupe and rewrite the file!"
 overwrite &
 for i in `seq 1 2`; do
 	seq $nr_loops -1 0 | while read i; do
-		_dedupe_range   "$TESTDIR/file1" $((i * BLKSZ)) \
-				"$TESTDIR/file2" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		_dedupe_range   "$testdir/file1" $((i * blksz)) \
+				"$testdir/file2" $((i * blksz)) $blksz >> "$seqres.full"
 		[ $? -ne 0 ] && break
 	done
 done
 echo "Finished dedupeing"
-touch "$TESTDIR/finished"
+touch "$testdir/finished"
 wait
 
 echo "Check fs"
diff --git a/tests/generic/163 b/tests/generic/163
index 1f5042f..0186443 100755
--- a/tests/generic/163
+++ b/tests/generic/163
@@ -50,24 +50,24 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 loops=512
 nr_loops=$((loops - 1))
-BLKSZ=65536
+blksz=65536
 
 echo "Initialize files"
 echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file2" >> "$seqres.full"
 _scratch_remount
 
 overwrite() {
-	while [ ! -e "$TESTDIR/finished" ]; do
+	while [ ! -e "$testdir/finished" ]; do
 		seq $nr_loops -1 0 | while read i; do
-			_pwrite_byte 0x61 $((i * BLKSZ)) $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+			_pwrite_byte 0x61 $((i * blksz)) $blksz "$testdir/file1" >> "$seqres.full"
 		done
 	done
 }
@@ -76,13 +76,13 @@ echo "Dedupe and rewrite the file!"
 overwrite &
 for i in `seq 1 2`; do
 	seq $nr_loops -1 0 | while read i; do
-		_dedupe_range   "$TESTDIR/file1" $((i * BLKSZ)) \
-				"$TESTDIR/file2" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		_dedupe_range   "$testdir/file1" $((i * blksz)) \
+				"$testdir/file2" $((i * blksz)) $blksz >> "$seqres.full"
 		[ $? -ne 0 ] && break
 	done
 done
 echo "Finished dedupeing"
-touch "$TESTDIR/finished"
+touch "$testdir/finished"
 wait
 
 echo "Check fs"
diff --git a/tests/generic/164 b/tests/generic/164
index 4df953d..087c6ba 100755
--- a/tests/generic/164
+++ b/tests/generic/164
@@ -52,19 +52,19 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 loops=512
 nr_loops=$((loops - 1))
-BLKSZ=65536
+blksz=65536
 
 echo "Initialize files"
 echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((loops * BLKSZ)) "$TESTDIR/file2" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file3"
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((loops * blksz)) "$testdir/file2" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file3"
 _scratch_remount
 
 fbytes() {
@@ -72,8 +72,8 @@ fbytes() {
 }
 
 reader() {
-	while [ ! -e "$TESTDIR/finished" ]; do
-		_read_range "$TESTDIR/file3" 0 $((loops * BLKSZ)) | fbytes
+	while [ ! -e "$testdir/finished" ]; do
+		_read_range "$testdir/file3" 0 $((loops * blksz)) | fbytes
 	done
 }
 
@@ -81,18 +81,18 @@ echo "Reflink and reread the files!"
 reader &
 for i in `seq 1 2`; do
 	seq $nr_loops -1 0 | while read i; do
-		_reflink_range  "$TESTDIR/file1" $((i * BLKSZ)) \
-				"$TESTDIR/file3" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		_reflink_range  "$testdir/file1" $((i * blksz)) \
+				"$testdir/file3" $((i * blksz)) $blksz >> "$seqres.full"
 		[ $? -ne 0 ] && break
 	done
 	seq $nr_loops -1 0 | while read i; do
-		_reflink_range  "$TESTDIR/file2" $((i * BLKSZ)) \
-				"$TESTDIR/file3" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		_reflink_range  "$testdir/file2" $((i * blksz)) \
+				"$testdir/file3" $((i * blksz)) $blksz >> "$seqres.full"
 		[ $? -ne 0 ] && break
 	done
 done
 echo "Finished reflinking"
-touch "$TESTDIR/finished"
+touch "$testdir/finished"
 wait
 
 echo "Check fs"
diff --git a/tests/generic/165 b/tests/generic/165
index 49187ec..6bd15e1 100755
--- a/tests/generic/165
+++ b/tests/generic/165
@@ -52,19 +52,19 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 loops=512
 nr_loops=$((loops - 1))
-BLKSZ=65536
+blksz=65536
 
 echo "Initialize files"
 echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((loops * BLKSZ)) "$TESTDIR/file2" >> "$seqres.full"
-_cp_reflink $TESTDIR/file1 $TESTDIR/file3
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((loops * blksz)) "$testdir/file2" >> "$seqres.full"
+_cp_reflink $testdir/file1 $testdir/file3
 _scratch_remount
 
 fbytes() {
@@ -72,8 +72,8 @@ fbytes() {
 }
 
 reader() {
-	while [ ! -e "$TESTDIR/finished" ]; do
-		_read_range "$TESTDIR/file3" 0 $((loops * BLKSZ)) -d | fbytes
+	while [ ! -e "$testdir/finished" ]; do
+		_read_range "$testdir/file3" 0 $((loops * blksz)) -d | fbytes
 	done
 }
 
@@ -81,18 +81,18 @@ echo "Reflink and dio reread the files!"
 reader &
 for i in `seq 1 2`; do
 	seq $nr_loops -1 0 | while read i; do
-		_reflink_range  "$TESTDIR/file1" $((i * BLKSZ)) \
-				"$TESTDIR/file3" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		_reflink_range  "$testdir/file1" $((i * blksz)) \
+				"$testdir/file3" $((i * blksz)) $blksz >> "$seqres.full"
 		[ $? -ne 0 ] && break
 	done
 	seq $nr_loops -1 0 | while read i; do
-		_reflink_range  "$TESTDIR/file2" $((i * BLKSZ)) \
-				"$TESTDIR/file3" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		_reflink_range  "$testdir/file2" $((i * blksz)) \
+				"$testdir/file3" $((i * blksz)) $blksz >> "$seqres.full"
 		[ $? -ne 0 ] && break
 	done
 done
 echo "Finished reflinking"
-touch "$TESTDIR/finished"
+touch "$testdir/finished"
 wait
 
 echo "Check fs"
diff --git a/tests/generic/166 b/tests/generic/166
index 93c4bc9..6cfb821 100755
--- a/tests/generic/166
+++ b/tests/generic/166
@@ -52,24 +52,24 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 loops=1024
 nr_loops=$((loops - 1))
-BLKSZ=65536
+blksz=65536
 
 echo "Initialize file"
 echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
 _scratch_remount
 
 # Snapshot creator...
 snappy() {
 	n=0
-	while [ ! -e "$TESTDIR/finished" ]; do
-		_cp_reflink "$TESTDIR/file1" "$TESTDIR/snap_$n" || break
+	while [ ! -e "$testdir/finished" ]; do
+		_cp_reflink "$testdir/file1" "$testdir/snap_$n" || break
 		n=$((n + 1))
 	done
 }
@@ -77,9 +77,9 @@ snappy() {
 echo "Snapshot a file undergoing directio rewrite"
 snappy &
 seq $nr_loops -1 0 | while read i; do
-	_pwrite_byte 0x63 $((i * BLKSZ)) $BLKSZ -d "$TESTDIR/file1" >> "$seqres.full"
+	_pwrite_byte 0x63 $((i * blksz)) $blksz -d "$testdir/file1" >> "$seqres.full"
 done
-touch $TESTDIR/finished
+touch $testdir/finished
 wait
 
 echo "Check for damage"
diff --git a/tests/generic/167 b/tests/generic/167
index 6d70737..fc5a86c 100755
--- a/tests/generic/167
+++ b/tests/generic/167
@@ -52,24 +52,24 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 loops=1024
 nr_loops=$((loops - 1))
-BLKSZ=65536
+blksz=65536
 
 echo "Initialize file"
 echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
 _scratch_remount
 
 # Snapshot creator...
 snappy() {
 	n=0
-	while [ ! -e "$TESTDIR/finished" ]; do
-		_cp_reflink "$TESTDIR/file1" "$TESTDIR/snap_$n" || break
+	while [ ! -e "$testdir/finished" ]; do
+		_cp_reflink "$testdir/file1" "$testdir/snap_$n" || break
 		n=$((n + 1))
 	done
 }
@@ -77,9 +77,9 @@ snappy() {
 echo "Snapshot a file undergoing buffered rewrite"
 snappy &
 seq $nr_loops -1 0 | while read i; do
-	_pwrite_byte 0x63 $((i * BLKSZ)) $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+	_pwrite_byte 0x63 $((i * blksz)) $blksz "$testdir/file1" >> "$seqres.full"
 done
-touch $TESTDIR/finished
+touch $testdir/finished
 wait
 
 echo "Check for damage"
diff --git a/tests/generic/168 b/tests/generic/168
index 414dcb0..ee3848d 100755
--- a/tests/generic/168
+++ b/tests/generic/168
@@ -51,25 +51,25 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 loops=1024
 nr_loops=$((loops - 1))
-BLKSZ=65536
+blksz=65536
 
 echo "Initialize files"
 echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((loops * BLKSZ)) "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((loops * blksz)) "$testdir/file2" >> "$seqres.full"
 _scratch_remount
 
 # Direct I/O overwriter...
 overwrite() {
-	while [ ! -e "$TESTDIR/finished" ]; do
+	while [ ! -e "$testdir/finished" ]; do
 		seq $nr_loops -1 0 | while read i; do
-			_pwrite_byte 0x63 $((i * BLKSZ)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+			_pwrite_byte 0x63 $((i * blksz)) $blksz "$testdir/file2" >> "$seqres.full"
 		done
 	done
 }
@@ -78,12 +78,12 @@ echo "Reflink and write the target"
 overwrite &
 seq 1 10 | while read j; do
 	seq 0 $nr_loops | while read i; do
-		_reflink_range  "$TESTDIR/file1" $((i * BLKSZ)) \
-				"$TESTDIR/file2" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		_reflink_range  "$testdir/file1" $((i * blksz)) \
+				"$testdir/file2" $((i * blksz)) $blksz >> "$seqres.full"
 		[ $? -ne 0 ] && exit
 	done
 done
-touch "$TESTDIR/finished"
+touch "$testdir/finished"
 wait
 
 echo "Check for damage"
diff --git a/tests/generic/170 b/tests/generic/170
index 704b646..6d27810 100755
--- a/tests/generic/170
+++ b/tests/generic/170
@@ -51,25 +51,25 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 loops=1024
 nr_loops=$((loops - 1))
-BLKSZ=65536
+blksz=65536
 
 echo "Initialize files"
 echo > "$seqres.full"
-_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((loops * BLKSZ)) "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((loops * blksz)) "$testdir/file2" >> "$seqres.full"
 _scratch_remount
 
 # Direct I/O overwriter...
 overwrite() {
-	while [ ! -e "$TESTDIR/finished" ]; do
+	while [ ! -e "$testdir/finished" ]; do
 		seq $nr_loops -1 0 | while read i; do
-			_pwrite_byte 0x63 $((i * BLKSZ)) $BLKSZ -d "$TESTDIR/file2" >> "$seqres.full"
+			_pwrite_byte 0x63 $((i * blksz)) $blksz -d "$testdir/file2" >> "$seqres.full"
 		done
 	done
 }
@@ -78,12 +78,12 @@ echo "Reflink and dio write the target"
 overwrite &
 seq 1 10 | while read j; do
 	seq 0 $nr_loops | while read i; do
-		_reflink_range  "$TESTDIR/file1" $((i * BLKSZ)) \
-				"$TESTDIR/file2" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		_reflink_range  "$testdir/file1" $((i * blksz)) \
+				"$testdir/file2" $((i * blksz)) $blksz >> "$seqres.full"
 		[ $? -ne 0 ] && exit
 	done
 done
-touch "$TESTDIR/finished"
+touch "$testdir/finished"
 wait
 
 echo "Check for damage"
diff --git a/tests/generic/171 b/tests/generic/171
index 99e4d5e..ec3729d 100755
--- a/tests/generic/171
+++ b/tests/generic/171
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$testdir1"
 }
 
 # get standard environment, filters and checks
@@ -53,36 +53,36 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Reformat with appropriate size"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-NR_BLKS=10240
+blksz="$(stat -f "$testdir" -c '%S')"
+nr_blks=10240
 umount "$SCRATCH_MNT"
-SZ_BYTES=$((NR_BLKS * 8 * BLKSZ))
-if [ $SZ_BYTES -lt $((32 * 1048576)) ]; then
-	SZ_BYTES=$((32 * 1048576))
+sz_bytes=$((nr_blks * 8 * blksz))
+if [ $sz_bytes -lt $((32 * 1048576)) ]; then
+	sz_bytes=$((32 * 1048576))
 fi
-_scratch_mkfs_sized $SZ_BYTES >> "$seqres.full" 2>&1
+_scratch_mkfs_sized $sz_bytes >> "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create a big file and reflink it"
-_pwrite_byte 0x61 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
-_cp_reflink "$TESTDIR/bigfile" "$TESTDIR/clonefile"
+_pwrite_byte 0x61 0 $((blksz * nr_blks)) "$testdir/bigfile" >> "$seqres.full" 2>&1
+_cp_reflink "$testdir/bigfile" "$testdir/clonefile"
 sync
 
 echo "Allocate the rest of the space"
-NR_FREE="$(stat -f -c '%f' "$TESTDIR")"
-touch "$TESTDIR/file0" "$TESTDIR/file1"
-_pwrite_byte 0x61 0 $((BLKSZ * NR_FREE)) "$TESTDIR/eat_my_space" >> "$seqres.full" 2>&1
+nr_free="$(stat -f -c '%f' "$testdir")"
+touch "$testdir/file0" "$testdir/file1"
+_pwrite_byte 0x61 0 $((blksz * nr_free)) "$testdir/eat_my_space" >> "$seqres.full" 2>&1
 sync
 
 echo "CoW the big file"
-out="$(_pwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" 2>&1)"
+out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) "$testdir/bigfile" 2>&1)"
 echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
 echo "${out}" >> "$seqres.full" 2>&1
 echo "${out}"
@@ -90,13 +90,13 @@ echo "${out}"
 echo "Remount and try CoW again"
 _scratch_remount
 
-out="$(_pwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" 2>&1)"
+out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) "$testdir/bigfile" 2>&1)"
 echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
 echo "${out}" >> "$seqres.full" 2>&1
 echo "${out}"
 
-#filefrag -v $TESTDIR/bigfile
-#filefrag -v $TESTDIR/clonefile
+#filefrag -v $testdir/bigfile
+#filefrag -v $testdir/clonefile
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/172 b/tests/generic/172
index eb00f0a..1988c8d 100755
--- a/tests/generic/172
+++ b/tests/generic/172
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$testdir1"
 }
 
 # get standard environment, filters and checks
@@ -53,36 +53,36 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Reformat with appropriate size"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-NR_BLKS=10240
+blksz="$(stat -f "$testdir" -c '%S')"
+nr_blks=10240
 umount "$SCRATCH_MNT"
-SZ_BYTES=$((NR_BLKS * 3 / 2 * BLKSZ))
-if [ $SZ_BYTES -lt $((32 * 1048576)) ]; then
-	SZ_BYTES=$((32 * 1048576))
+sz_bytes=$((nr_blks * 3 / 2 * blksz))
+if [ $sz_bytes -lt $((32 * 1048576)) ]; then
+	sz_bytes=$((32 * 1048576))
 fi
-_scratch_mkfs_sized $SZ_BYTES >> "$seqres.full" 2>&1
+_scratch_mkfs_sized $sz_bytes >> "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create a big file and reflink it"
-_pwrite_byte 0x61 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
-_cp_reflink "$TESTDIR/bigfile" "$TESTDIR/clonefile"
+_pwrite_byte 0x61 0 $((blksz * nr_blks)) "$testdir/bigfile" >> "$seqres.full" 2>&1
+_cp_reflink "$testdir/bigfile" "$testdir/clonefile"
 sync
 
 echo "Allocate the rest of the space"
-NR_FREE="$(stat -f -c '%f' "$TESTDIR")"
-touch "$TESTDIR/file0" "$TESTDIR/file1"
-_pwrite_byte 0x61 0 $((BLKSZ * NR_FREE)) "$TESTDIR/eat_my_space" >> "$seqres.full" 2>&1
+nr_free="$(stat -f -c '%f' "$testdir")"
+touch "$testdir/file0" "$testdir/file1"
+_pwrite_byte 0x61 0 $((blksz * nr_free)) "$testdir/eat_my_space" >> "$seqres.full" 2>&1
 sync
 
 echo "CoW the big file"
-out="$(_pwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" 2>&1)"
+out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) "$testdir/bigfile" 2>&1)"
 echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
 echo "${out}" >> "$seqres.full" 2>&1
 echo "${out}"
@@ -90,13 +90,13 @@ echo "${out}"
 echo "Remount and try CoW again"
 _scratch_remount
 
-out="$(_pwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" 2>&1)"
+out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) "$testdir/bigfile" 2>&1)"
 echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
 echo "${out}" >> "$seqres.full" 2>&1
 echo "${out}"
 
-#filefrag -v $TESTDIR/bigfile
-#filefrag -v $TESTDIR/clonefile
+#filefrag -v $testdir/bigfile
+#filefrag -v $testdir/clonefile
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/173 b/tests/generic/173
index 76463d2..5bb9ce6 100755
--- a/tests/generic/173
+++ b/tests/generic/173
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$testdir1"
 }
 
 # get standard environment, filters and checks
@@ -53,36 +53,36 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Reformat with appropriate size"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-NR_BLKS=10240
+blksz="$(stat -f "$testdir" -c '%S')"
+nr_blks=10240
 umount "$SCRATCH_MNT"
-SZ_BYTES=$((NR_BLKS * 8 * BLKSZ))
-if [ $SZ_BYTES -lt $((32 * 1048576)) ]; then
-	SZ_BYTES=$((32 * 1048576))
+sz_bytes=$((nr_blks * 8 * blksz))
+if [ $sz_bytes -lt $((32 * 1048576)) ]; then
+	sz_bytes=$((32 * 1048576))
 fi
-_scratch_mkfs_sized $SZ_BYTES >> "$seqres.full" 2>&1
+_scratch_mkfs_sized $sz_bytes >> "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create a big file and reflink it"
-_pwrite_byte 0x61 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
-_cp_reflink "$TESTDIR/bigfile" "$TESTDIR/clonefile"
+_pwrite_byte 0x61 0 $((blksz * nr_blks)) "$testdir/bigfile" >> "$seqres.full" 2>&1
+_cp_reflink "$testdir/bigfile" "$testdir/clonefile"
 sync
 
 echo "Allocate the rest of the space"
-NR_FREE="$(stat -f -c '%f' "$TESTDIR")"
-touch "$TESTDIR/file0" "$TESTDIR/file1"
-_pwrite_byte 0x61 0 $((BLKSZ * NR_FREE)) "$TESTDIR/eat_my_space" >> "$seqres.full" 2>&1
+nr_free="$(stat -f -c '%f' "$testdir")"
+touch "$testdir/file0" "$testdir/file1"
+_pwrite_byte 0x61 0 $((blksz * nr_free)) "$testdir/eat_my_space" >> "$seqres.full" 2>&1
 sync
 
 echo "mmap CoW the big file"
-out="$(_mwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" 2>&1)"
+out="$(_mwrite_byte 0x62 0 $((blksz * nr_blks)) $((blksz * nr_blks)) "$testdir/bigfile" 2>&1)"
 err="$?"
 if [ "$err" -lt 128 ]; then
 	echo "mmap CoW should have failed with SIGBUS, got SIG$(kill -l $err)"
@@ -91,14 +91,14 @@ fi
 echo "Remount and try CoW again"
 _scratch_remount
 
-out="$(_mwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" 2>&1)"
+out="$(_mwrite_byte 0x62 0 $((blksz * nr_blks)) $((blksz * nr_blks)) "$testdir/bigfile" 2>&1)"
 err="$?"
 if [ "$err" -lt 128 ]; then
 	echo "mmap CoW should have failed with SIGBUS, got SIG$(kill -l $err)"
 fi
 
-#filefrag -v $TESTDIR/bigfile
-#filefrag -v $TESTDIR/clonefile
+#filefrag -v $testdir/bigfile
+#filefrag -v $testdir/clonefile
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/174 b/tests/generic/174
index 8df292a..a8e0bb5 100755
--- a/tests/generic/174
+++ b/tests/generic/174
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$testdir1"
 }
 
 # get standard environment, filters and checks
@@ -53,36 +53,36 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Reformat with appropriate size"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-NR_BLKS=10240
+blksz="$(stat -f "$testdir" -c '%S')"
+nr_blks=10240
 umount "$SCRATCH_MNT"
-SZ_BYTES=$((NR_BLKS * 8 * BLKSZ))
-if [ $SZ_BYTES -lt $((32 * 1048576)) ]; then
-	SZ_BYTES=$((32 * 1048576))
+sz_bytes=$((nr_blks * 8 * blksz))
+if [ $sz_bytes -lt $((32 * 1048576)) ]; then
+	sz_bytes=$((32 * 1048576))
 fi
-_scratch_mkfs_sized $SZ_BYTES >> "$seqres.full" 2>&1
+_scratch_mkfs_sized $sz_bytes >> "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create a big file and reflink it"
-_pwrite_byte 0x61 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
-_cp_reflink "$TESTDIR/bigfile" "$TESTDIR/clonefile"
+_pwrite_byte 0x61 0 $((blksz * nr_blks)) "$testdir/bigfile" >> "$seqres.full" 2>&1
+_cp_reflink "$testdir/bigfile" "$testdir/clonefile"
 sync
 
 echo "Allocate the rest of the space"
-NR_FREE="$(stat -f -c '%f' "$TESTDIR")"
-touch "$TESTDIR/file0" "$TESTDIR/file1"
-_pwrite_byte 0x61 0 $((BLKSZ * NR_FREE)) "$TESTDIR/eat_my_space" >> "$seqres.full" 2>&1
+nr_free="$(stat -f -c '%f' "$testdir")"
+touch "$testdir/file0" "$testdir/file1"
+_pwrite_byte 0x61 0 $((blksz * nr_free)) "$testdir/eat_my_space" >> "$seqres.full" 2>&1
 sync
 
 echo "CoW the big file"
-out="$(_pwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" -d 2>&1)"
+out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) "$testdir/bigfile" -d 2>&1)"
 echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
 echo "${out}" >> "$seqres.full" 2>&1
 echo "${out}"
@@ -90,13 +90,13 @@ echo "${out}"
 echo "Remount and try CoW again"
 _scratch_remount
 
-out="$(_pwrite_byte 0x62 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/bigfile" -d 2>&1)"
+out="$(_pwrite_byte 0x62 0 $((blksz * nr_blks)) "$testdir/bigfile" -d 2>&1)"
 echo "${out}" | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
 echo "${out}" >> "$seqres.full" 2>&1
 echo "${out}"
 
-#filefrag -v $TESTDIR/bigfile
-#filefrag -v $TESTDIR/clonefile
+#filefrag -v $testdir/bigfile
+#filefrag -v $testdir/clonefile
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/175 b/tests/generic/175
index a7da533..b37ff66 100755
--- a/tests/generic/175
+++ b/tests/generic/175
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$testdir1"
 }
 
 # get standard environment, filters and checks
@@ -54,30 +54,30 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 # Well let's hope the maximum reflink count is (less than (ha!)) 2^32...
 
 echo "Create a one block file"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-_pwrite_byte 0x61 0 $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
+blksz="$(stat -f "$testdir" -c '%S')"
+_pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $blksz "$testdir/file2" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
 
 nr=32
 fnr=32
 for i in $(seq 0 $fnr); do
-	echo " ++ Reflink size $i, $(( (2 ** i) * BLKSZ)) bytes" | tee -a "$seqres.full"
-	n=$(( (2 ** i) * BLKSZ))
-	_reflink_range "$TESTDIR/file1" 0 "$TESTDIR/file1" $n $n >> "$seqres.full" || break
+	echo " ++ Reflink size $i, $(( (2 ** i) * blksz)) bytes" | tee -a "$seqres.full"
+	n=$(( (2 ** i) * blksz))
+	_reflink_range "$testdir/file1" 0 "$testdir/file1" $n $n >> "$seqres.full" || break
 done
 
 nrf=$((nr - fnr))
 echo "Clone $((2 ** nrf)) files"
 seq 0 $((2 ** nrf)) | while read i; do
-	_cp-reflink "$TESTDIR/file1" "$TESTDIR/file1-$i"
+	_cp-reflink "$testdir/file1" "$testdir/file1-$i"
 done
 
 echo "Check scratch fs"
diff --git a/tests/generic/176 b/tests/generic/176
index bf930b7..0ca0b17 100755
--- a/tests/generic/176
+++ b/tests/generic/176
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR1"
+    rm -rf "$tmp".* "$testdir1"
 }
 
 # get standard environment, filters and checks
@@ -51,23 +51,23 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-NR_FREE="$(stat -f -c '%f' "$TESTDIR")"
+blksz="$(stat -f "$testdir" -c '%S')"
+nr_free="$(stat -f -c '%f' "$testdir")"
 echo "Create a big file"
-touch "$TESTDIR/file0" "$TESTDIR/file1"
-_pwrite_byte 0x61 0 $((BLKSZ * NR_FREE)) "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
+touch "$testdir/file0" "$testdir/file1"
+_pwrite_byte 0x61 0 $((blksz * nr_free)) "$testdir/bigfile" >> "$seqres.full" 2>&1
 _scratch_remount
-sz="$(stat -c '%s' "$TESTDIR/bigfile")"
+sz="$(stat -c '%s' "$testdir/bigfile")"
 
-blks="$((sz / BLKSZ))"
+blks="$((sz / blksz))"
 echo "Try to reflink"
 seq 0 $blks | while read lblk; do
-	fname="$TESTDIR/file$((lblk % 2))"
-	out="$(_reflink_range "$TESTDIR/bigfile" $((lblk * BLKSZ)) "$fname" $((lblk * BLKSZ)) $BLKSZ 2>&1)"
+	fname="$testdir/file$((lblk % 2))"
+	out="$(_reflink_range "$testdir/bigfile" $((lblk * blksz)) "$fname" $((lblk * blksz)) $blksz 2>&1)"
 	echo "$fname: $out" >> "$seqres.full"
 	echo "$out" | grep -q "No space left on device" && break
 done
diff --git a/tests/generic/178 b/tests/generic/178
index 9828dac..f1bc963 100755
--- a/tests/generic/178
+++ b/tests/generic/178
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -48,29 +48,29 @@ _require_xfs_io_command "fpunch"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-NR=512
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
+blksz=65536
+nr=512
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
 
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
 
 echo "Write and punch"
-_pwrite_byte 0x62 0 $((BLKSZ * 256)) "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "fpunch $BLKSZ $((BLKSZ * 254))" "$TESTDIR/file2"
+_pwrite_byte 0x62 0 $((blksz * 256)) "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "fpunch $blksz $((blksz * 254))" "$testdir/file2"
 _test_remount
 
 echo "Compare results"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
 
 # success, all done
 status=0
diff --git a/tests/generic/179 b/tests/generic/179
index 9312d4d..8e1e059 100755
--- a/tests/generic/179
+++ b/tests/generic/179
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -51,45 +51,45 @@ _require_xfs_io_command "fpunch"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ * 3)) "$TESTDIR/file1" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz * 3)) "$testdir/file1" >> "$seqres.full"
 
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2"
 
-_pwrite_byte 0x61 0 $((BLKSZ * 3)) "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((BLKSZ - 17)) $((BLKSZ + 17)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 3)) "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((blksz - 17)) $((blksz + 17)) "$testdir/file2.chk" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
 
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
 
-test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${c1}" = "${c2}" || echo "file1 and file2 should match"
 
 echo "fpunch files"
-"$XFS_IO_PROG" -f -c "fpunch $((BLKSZ - 17)) $((BLKSZ + 17))" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "fpunch $((blksz - 17)) $((blksz + 17))" "$testdir/file2"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
 
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
 
-test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
 
 echo "Compare against check files"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/180 b/tests/generic/180
index af6f2ae..dc6cbbb 100755
--- a/tests/generic/180
+++ b/tests/generic/180
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -51,45 +51,45 @@ _require_xfs_io_command "fzero"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ * 3)) "$TESTDIR/file1" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz * 3)) "$testdir/file1" >> "$seqres.full"
 
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2"
 
-_pwrite_byte 0x61 0 $((BLKSZ * 3)) "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x00 $((BLKSZ - 17)) $((BLKSZ + 17)) "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 3)) "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x00 $((blksz - 17)) $((blksz + 17)) "$testdir/file2.chk" >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
 
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
 
-test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${c1}" = "${c2}" || echo "file1 and file2 should match"
 
 echo "fzero files"
-"$XFS_IO_PROG" -f -c "fzero $((BLKSZ - 17)) $((BLKSZ + 17))" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "fzero $((blksz - 17)) $((blksz + 17))" "$testdir/file2"
 _test_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
 
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
 
-test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
 
 echo "Compare against check files"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/181 b/tests/generic/181
index 03c9ccc..cb6639f 100755
--- a/tests/generic/181
+++ b/tests/generic/181
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -50,30 +50,30 @@ _require_cp_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * 256)) "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * 2)) "$TESTDIR/file2.chk" >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 2)) $((BLKSZ * 255)) "$TESTDIR/file2.chk" >> "$seqres.full"
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) 0 >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * 256)) "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * 2)) "$testdir/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $((blksz * 255)) "$testdir/file2.chk" >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) 0 >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
 
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
 
-test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
 
 echo "Compare against check files"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/182 b/tests/generic/182
index 885159e..bf5cd38 100755
--- a/tests/generic/182
+++ b/tests/generic/182
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -50,67 +50,67 @@ _require_cp_reflink
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * 257)) "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * 257)) "$TESTDIR/file2.chk" >> "$seqres.full"
-_dedupe_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) 0 >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * 257)) "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * 257)) "$testdir/file2.chk" >> "$seqres.full"
+_dedupe_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) 0 >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
 
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
 
-test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
 
 echo "Compare against check files"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
 
 echo "Make the original file almost dedup-able"
-_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file2.chk" >> "$seqres.full"
-_dedupe_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) 0 >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file2.chk" >> "$seqres.full"
+_dedupe_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) 0 >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
 
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
 
-test "${C1}" != "${C2}" || echo "file1 and file2 should not match"
+test "${c1}" != "${c2}" || echo "file1 and file2 should not match"
 
 echo "Compare against check files"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
 
 echo "Make the original file dedup-able"
-_pwrite_byte 0x61 0 $((BLKSZ * 256)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((BLKSZ * 257)) "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $((BLKSZ * 257)) "$TESTDIR/file2.chk" >> "$seqres.full"
-_dedupe_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) 0 >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 256)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 257)) "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * 257)) "$testdir/file2.chk" >> "$seqres.full"
+_dedupe_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) 0 >> "$seqres.full"
 _test_remount
 
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-md5sum "$TESTDIR/file2.chk" | _filter_test_dir
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+md5sum "$testdir/file2.chk" | _filter_test_dir
 
-C1="$(_md5_checksum "$TESTDIR/file1")"
-C2="$(_md5_checksum "$TESTDIR/file2")"
+c1="$(_md5_checksum "$testdir/file1")"
+c2="$(_md5_checksum "$testdir/file2")"
 
-test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${c1}" = "${c2}" || echo "file1 and file2 should match"
 
 echo "Compare against check files"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
 
 # success, all done
 status=0
diff --git a/tests/generic/183 b/tests/generic/183
index 2cf9ce4..8141f38 100755
--- a/tests/generic/183
+++ b/tests/generic/183
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -56,41 +56,41 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file2" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file2" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
-seq 1 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file2" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file2" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "directio CoW across the transition"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/185 b/tests/generic/185
index 55c54ac..1d6dff2 100755
--- a/tests/generic/185
+++ b/tests/generic/185
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -56,41 +56,41 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file2" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file2" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
-seq 1 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file2" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file2" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "CoW across the transition"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/186 b/tests/generic/186
index f1c0e6b..9aac966 100755
--- a/tests/generic/186
+++ b/tests/generic/186
@@ -40,7 +40,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-#    rm -rf "$tmp".* "$TESTDIR"
+#    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -90,8 +90,8 @@ _fragment_freesp()
 	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" "${file}.${i}"
 
 	# Punch out whatever we need
-	seq 1 $((NR * 4)) | while read f; do
-		$XFS_IO_PROG -f -c "fpunch $((f * 2 * BLKSZ)) $BLKSZ" "$file"
+	seq 1 $((nr * 4)) | while read f; do
+		$XFS_IO_PROG -f -c "fpunch $((f * 2 * blksz)) $blksz" "$file"
 	done
 }
 
@@ -99,43 +99,43 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=1024
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file2" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=1024
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file2" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
-seq 1 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file2" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file2" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
-_fragment_freesp "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
+_fragment_freesp "$testdir/bigfile" >> "$seqres.full" 2>&1
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "CoW with multiple extents?"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/187 b/tests/generic/187
index ce35ec0..b3f1542 100755
--- a/tests/generic/187
+++ b/tests/generic/187
@@ -40,7 +40,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-#    rm -rf "$tmp".* "$TESTDIR"
+#    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -90,8 +90,8 @@ _fragment_freesp()
 	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" "${file}.${i}"
 
 	# Punch out whatever we need
-	seq 1 $((NR * 4)) | while read f; do
-		$XFS_IO_PROG -f -c "fpunch $((f * 2 * BLKSZ)) $BLKSZ" "$file"
+	seq 1 $((nr * 4)) | while read f; do
+		$XFS_IO_PROG -f -c "fpunch $((f * 2 * blksz)) $blksz" "$file"
 	done
 }
 
@@ -99,43 +99,43 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=1024
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file2" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=1024
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file2" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
-seq 1 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file2" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file2" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
-_fragment_freesp "$TESTDIR/bigfile" >> "$seqres.full" 2>&1
+_fragment_freesp "$testdir/bigfile" >> "$seqres.full" 2>&1
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "CoW with multiple extents?"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/188 b/tests/generic/188
index 8e715ec..c67b847 100755
--- a/tests/generic/188
+++ b/tests/generic/188
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -56,36 +56,36 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x00 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "directio CoW across the transition"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/189 b/tests/generic/189
index a4b984f..1954235 100755
--- a/tests/generic/189
+++ b/tests/generic/189
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -56,36 +56,36 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x00 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "CoW across the transition"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/190 b/tests/generic/190
index ee53bfd..d3d573b 100755
--- a/tests/generic/190
+++ b/tests/generic/190
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -56,36 +56,36 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "truncate $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x00 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "directio CoW across the transition"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/191 b/tests/generic/191
index 6174a79..8b19084 100755
--- a/tests/generic/191
+++ b/tests/generic/191
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -56,36 +56,36 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "truncate $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x00 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "CoW across the transition"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/194 b/tests/generic/194
index b88297e..1fc2cd7 100755
--- a/tests/generic/194
+++ b/tests/generic/194
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -57,40 +57,40 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "truncate $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x00 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "directio CoW across the transition"
-seq 1 2 $((NR-1)) | while read f; do
-	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
-	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/195 b/tests/generic/195
index 464a4d4..087275c 100755
--- a/tests/generic/195
+++ b/tests/generic/195
@@ -38,7 +38,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -57,40 +57,40 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "truncate $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x00 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "CoW across the transition"
-seq 1 2 $((NR-1)) | while read f; do
-	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
-	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/196 b/tests/generic/196
index 48be50c..d815232 100755
--- a/tests/generic/196
+++ b/tests/generic/196
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -56,36 +56,36 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "directio CoW across the transition"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/197 b/tests/generic/197
index 9bffffe..54005ae 100755
--- a/tests/generic/197
+++ b/tests/generic/197
@@ -37,7 +37,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -56,36 +56,36 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "CoW across the transition"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/199 b/tests/generic/199
index a67c04a..eb567e4 100755
--- a/tests/generic/199
+++ b/tests/generic/199
@@ -41,7 +41,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -62,59 +62,59 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "truncate $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
 # 0 blocks are reflinked
-seq 0 5 $NR | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 0 5 $nr | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 sync
 # 1 blocks are unwritten
-seq 1 5 $NR | while read f; do
-	$XFS_IO_PROG -f -c "falloc $((BLKSZ * f)) $BLKSZ" "$TESTDIR/file3" >> "$seqres.full"
-	_pwrite_byte 0x00 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 1 5 $nr | while read f; do
+	$XFS_IO_PROG -f -c "falloc $((blksz * f)) $blksz" "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x00 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 sync
 # 2 blocks are holes
-seq 2 5 $NR | while read f; do
-	_pwrite_byte 0x00 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 2 5 $nr | while read f; do
+	_pwrite_byte 0x00 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 # 3 blocks are regular
-seq 3 5 $NR | while read f; do
-	_pwrite_byte 0x71 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
-	_pwrite_byte 0x71 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 3 5 $nr | while read f; do
+	_pwrite_byte 0x71 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x71 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 sync
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "directio CoW across the transition"
 # 4 blocks are delalloc (do later)
-seq 4 5 $NR | while read f; do
-	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
-	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 4 5 $nr | while read f; do
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 # now cow
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/200 b/tests/generic/200
index 9ef533e..991fed0 100755
--- a/tests/generic/200
+++ b/tests/generic/200
@@ -41,7 +41,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -62,59 +62,59 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "truncate $((BLKSZ * NR))" "$TESTDIR/file3" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
 # 0 blocks are reflinked
-seq 0 5 $NR | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 0 5 $nr | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 sync
 # 1 blocks are unwritten
-seq 1 5 $NR | while read f; do
-	$XFS_IO_PROG -f -c "falloc $((BLKSZ * f)) $BLKSZ" "$TESTDIR/file3" >> "$seqres.full"
-	_pwrite_byte 0x00 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 1 5 $nr | while read f; do
+	$XFS_IO_PROG -f -c "falloc $((blksz * f)) $blksz" "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x00 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 sync
 # 2 blocks are holes
-seq 2 5 $NR | while read f; do
-	_pwrite_byte 0x00 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 2 5 $nr | while read f; do
+	_pwrite_byte 0x00 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 # 3 blocks are regular
-seq 3 5 $NR | while read f; do
-	_pwrite_byte 0x71 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
-	_pwrite_byte 0x71 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 3 5 $nr | while read f; do
+	_pwrite_byte 0x71 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x71 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 sync
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "directio CoW across the transition"
 # 4 blocks are delalloc (do later)
-seq 4 5 $NR | while read f; do
-	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
-	_pwrite_byte 0x62 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+seq 4 5 $nr | while read f; do
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
+	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 # now cow
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x63 $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2)) "$TESTDIR/file3.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/201 b/tests/generic/201
index fa81b5a..ffc1ce4 100755
--- a/tests/generic/201
+++ b/tests/generic/201
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -52,30 +52,30 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-NR=64
-_pwrite_byte 0x61 0 $((BLKSZ * NR)) "$TESTDIR/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file3" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((BLKSZ * NR)) "$TESTDIR/file3.chk" >> "$seqres.full"
-seq 0 2 $((NR-1)) | while read f; do
-	_reflink_range "$TESTDIR/file1" $((BLKSZ * f)) "$TESTDIR/file3" $((BLKSZ * f)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * f)) $BLKSZ "$TESTDIR/file3.chk" >> "$seqres.full"
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
+seq 0 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
 done
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file3.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * NR / 2)) $((BLKSZ * NR / 4)) $((BLKSZ * NR / 2))" "$TESTDIR/file3" >> "$seqres.full"
-rm "$TESTDIR/file3"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
+rm "$testdir/file3"
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/202 b/tests/generic/202
index 2d03b55..375b65f 100755
--- a/tests/generic/202
+++ b/tests/generic/202
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -51,31 +51,31 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ + 17)) "$TESTDIR/file1" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
-_pwrite_byte 0x61 0 $((BLKSZ + 17)) "$TESTDIR/file2.chk" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz + 17)) "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2"
+_pwrite_byte 0x61 0 $((blksz + 17)) "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file2.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file2.chk" | _filter_scratch
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) 17" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) 17" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) 17" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) 17" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file2.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file2.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/203 b/tests/generic/203
index 8ed765e..549f2ba 100755
--- a/tests/generic/203
+++ b/tests/generic/203
@@ -32,7 +32,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -51,31 +51,31 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
 echo "Create the original files"
-BLKSZ=65536
-_pwrite_byte 0x61 0 $((BLKSZ + 17)) "$TESTDIR/file1" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
-_pwrite_byte 0x61 0 $((BLKSZ + 17)) "$TESTDIR/file2.chk" >> "$seqres.full"
+blksz=65536
+_pwrite_byte 0x61 0 $((blksz + 17)) "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2"
+_pwrite_byte 0x61 0 $((blksz + 17)) "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file2.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file2.chk" | _filter_scratch
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $BLKSZ $BLKSZ" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $BLKSZ $BLKSZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $blksz $blksz" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $blksz $blksz" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file2.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file2.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/205 b/tests/generic/205
index 525138a..8f0ec45 100755
--- a/tests/generic/205
+++ b/tests/generic/205
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -50,48 +50,48 @@ _require_scratch_reflink
 
 rm -f "$seqres.full"
 
-PAGESZ=$(getconf PAGE_SIZE)
-BLKSZ=$((PAGESZ / 4))
+pagesz=$(getconf PAGE_SIZE)
+blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
-REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
-test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+real_blksz=$(stat -f -c '%S' $testdir)
+test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
 
-_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
 
-_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/206 b/tests/generic/206
index 0a734a5..f2c4ecc 100755
--- a/tests/generic/206
+++ b/tests/generic/206
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -50,48 +50,48 @@ _require_scratch_reflink
 
 rm -f "$seqres.full"
 
-PAGESZ=$(getconf PAGE_SIZE)
-BLKSZ=$((PAGESZ / 4))
+pagesz=$(getconf PAGE_SIZE)
+blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
-REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
-test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+real_blksz=$(stat -f -c '%S' $testdir)
+test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
 
-_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
 
-_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/216 b/tests/generic/216
index d4ab7aa..3789cb0 100755
--- a/tests/generic/216
+++ b/tests/generic/216
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -51,48 +51,48 @@ _require_xfs_io_command "falloc"
 
 rm -f "$seqres.full"
 
-PAGESZ=$(getconf PAGE_SIZE)
-BLKSZ=$((PAGESZ / 4))
+pagesz=$(getconf PAGE_SIZE)
+blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
-REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
-test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+real_blksz=$(stat -f -c '%S' $testdir)
+test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "falloc -k $BLKSZ $BLKSZ" "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x00 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc -k $blksz $blksz" "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x00 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "falloc -k $((BLKSZ * 3)) $BLKSZ" "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x00 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc -k $((blksz * 3)) $blksz" "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x00 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/217 b/tests/generic/217
index 5e5c831..4ae603f 100755
--- a/tests/generic/217
+++ b/tests/generic/217
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -51,48 +51,48 @@ _require_xfs_io_command "falloc"
 
 rm -f "$seqres.full"
 
-PAGESZ=$(getconf PAGE_SIZE)
-BLKSZ=$((PAGESZ / 4))
+pagesz=$(getconf PAGE_SIZE)
+blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
-REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
-test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+real_blksz=$(stat -f -c '%S' $testdir)
+test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "falloc -k $BLKSZ $BLKSZ" "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x00 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc -k $blksz $blksz" "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x00 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "falloc -k $((BLKSZ * 3)) $BLKSZ" "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x00 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc -k $((blksz * 3)) $blksz" "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x00 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/218 b/tests/generic/218
index 7c31092..d63c06f 100755
--- a/tests/generic/218
+++ b/tests/generic/218
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -51,42 +51,42 @@ _require_xfs_io_command "falloc"
 
 rm -f "$seqres.full"
 
-PAGESZ=$(getconf PAGE_SIZE)
-BLKSZ=$((PAGESZ / 4))
+pagesz=$(getconf PAGE_SIZE)
+blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
-REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
-test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+real_blksz=$(stat -f -c '%S' $testdir)
+test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
 
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/220 b/tests/generic/220
index 3ab9881..ccdb32e 100755
--- a/tests/generic/220
+++ b/tests/generic/220
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -51,42 +51,42 @@ _require_xfs_io_command "falloc"
 
 rm -f "$seqres.full"
 
-PAGESZ=$(getconf PAGE_SIZE)
-BLKSZ=$((PAGESZ / 4))
+pagesz=$(getconf PAGE_SIZE)
+blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
-REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
-test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+real_blksz=$(stat -f -c '%S' $testdir)
+test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
 
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/222 b/tests/generic/222
index 3e344dc..cb5a788 100755
--- a/tests/generic/222
+++ b/tests/generic/222
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -51,48 +51,48 @@ _require_xfs_io_command "falloc"
 
 rm -f "$seqres.full"
 
-PAGESZ=$(getconf PAGE_SIZE)
-BLKSZ=$((PAGESZ / 4))
+pagesz=$(getconf PAGE_SIZE)
+blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
-REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
-test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+real_blksz=$(stat -f -c '%S' $testdir)
+test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
 
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
 
-_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/227 b/tests/generic/227
index ad52997..d200424 100755
--- a/tests/generic/227
+++ b/tests/generic/227
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -51,48 +51,48 @@ _require_xfs_io_command "falloc"
 
 rm -f "$seqres.full"
 
-PAGESZ=$(getconf PAGE_SIZE)
-BLKSZ=$((PAGESZ / 4))
+pagesz=$(getconf PAGE_SIZE)
+blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
-REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
-test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+real_blksz=$(stat -f -c '%S' $testdir)
+test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
-_pwrite_byte 0x61 0 $PAGESZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $pagesz "$testdir/file1" >> "$seqres.full"
 
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "truncate $pagesz" "$testdir/file2.chk" >> "$seqres.full"
 
-_reflink_range "$TESTDIR/file1" $BLKSZ "$TESTDIR/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_reflink_range "$testdir/file1" $blksz "$testdir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 2)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "CoW and unmount"
-_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $BLKSZ $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $blksz $blksz "$testdir/file2.chk" >> "$seqres.full"
 
-_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 $((blksz * 3)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || _fail "file1 and file2 don't match."
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || _fail "file2 and file2.chk don't match."
+! cmp -s "$testdir/file1" "$testdir/file2" || _fail "file1 and file2 don't match."
+cmp -s "$testdir/file2" "$testdir/file2.chk" || _fail "file2 and file2.chk don't match."
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/229 b/tests/generic/229
index 4a65135..cdaddaf 100755
--- a/tests/generic/229
+++ b/tests/generic/229
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -51,19 +51,19 @@ _require_xfs_io_command "falloc"
 
 rm -f "$seqres.full"
 
-PAGESZ=$(getconf PAGE_SIZE)
-BLKSZ=$((PAGESZ / 4))
+pagesz=$(getconf PAGE_SIZE)
+blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
-REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
-test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+real_blksz=$(stat -f -c '%S' $testdir)
+test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
 
 runtest() {
 	echo "runtest $1 $2"
@@ -73,19 +73,19 @@ runtest() {
 
 	echo "Create the original files"
 	mkdir -p "$dir"
-	_pwrite_byte 0x61 0 $PAGESZ "$dir/file1" >> "$seqres.full"
+	_pwrite_byte 0x61 0 $pagesz "$dir/file1" >> "$seqres.full"
 
-	"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$dir/file2" >> "$seqres.full"
-	"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$dir/file2.chk" >> "$seqres.full"
+	"$XFS_IO_PROG" -f -c "truncate $pagesz" "$dir/file2" >> "$seqres.full"
+	"$XFS_IO_PROG" -f -c "truncate $pagesz" "$dir/file2.chk" >> "$seqres.full"
 
 	case "$b2" in
 	"regular")
-		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		_pwrite_byte 0x61 $blksz $blksz "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $blksz $blksz "$dir/file2.chk" >> "$seqres.full"
 		;;
 	"unwritten")
-		"$XFS_IO_PROG" -f -c "falloc -k $BLKSZ $BLKSZ" "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x00 $BLKSZ $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		"$XFS_IO_PROG" -f -c "falloc -k $blksz $blksz" "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x00 $blksz $blksz "$dir/file2.chk" >> "$seqres.full"
 		;;
 	"hole")
 		;;
@@ -95,19 +95,19 @@ runtest() {
 
 	case "$b4" in
 	"regular")
-		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2.chk" >> "$seqres.full"
 		;;
 	"unwritten")
-		"$XFS_IO_PROG" -f -c "falloc -k $((BLKSZ * 3)) $BLKSZ" "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x00 $((BLKSZ * 3)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		"$XFS_IO_PROG" -f -c "falloc -k $((blksz * 3)) $blksz" "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x00 $((blksz * 3)) $blksz "$dir/file2.chk" >> "$seqres.full"
 		;;
 	"hole")
 		;;
 	esac
 
-	_reflink_range "$dir/file1" $BLKSZ "$dir/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+	_reflink_range "$dir/file1" $blksz "$dir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * 2)) $blksz "$dir/file2.chk" >> "$seqres.full"
 	_scratch_remount
 
 	echo "Compare files"
@@ -116,17 +116,17 @@ runtest() {
 
 	echo "CoW and unmount"
 	if [ "$b2" = "delalloc" ]; then
-		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		_pwrite_byte 0x61 $blksz $blksz "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $blksz $blksz "$dir/file2.chk" >> "$seqres.full"
 	fi
 
 	if [ "$b4" = "delalloc" ]; then
-		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2.chk" >> "$seqres.full"
 	fi
 
-	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$dir/file2" >> "$seqres.full"
-	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((BLKSZ + 17)) $((BLKSZ * 3 - 34))" "$dir/file2.chk" >> "$seqres.full"
+	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$dir/file2" >> "$seqres.full"
+	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz + 17)) $((blksz * 3 - 34))" "$dir/file2.chk" >> "$seqres.full"
 	_scratch_remount
 
 	echo "Compare files"
@@ -134,25 +134,25 @@ runtest() {
 	cmp -s "$dir/file2" "$dir/file2.chk" || _fail "file2 and file2.chk don't match."
 }
 
-runtest regular delalloc "$TESTDIR/r-d"
-runtest regular unwritten "$TESTDIR/r-u"
-runtest regular hole "$TESTDIR/r-h"
-runtest regular regular "$TESTDIR/r-r"
-
-runtest hole delalloc "$TESTDIR/h-d"
-runtest hole unwritten "$TESTDIR/h-u"
-runtest hole hole "$TESTDIR/h-h"
-runtest hole regular "$TESTDIR/h-r"
-
-runtest unwritten delalloc "$TESTDIR/u-d"
-runtest unwritten unwritten "$TESTDIR/u-u"
-runtest unwritten hole "$TESTDIR/u-h"
-runtest unwritten regular "$TESTDIR/u-r"
-
-runtest delalloc delalloc "$TESTDIR/d-d"
-runtest delalloc unwritten "$TESTDIR/d-u"
-runtest delalloc hole "$TESTDIR/d-h"
-runtest delalloc regular "$TESTDIR/d-r"
+runtest regular delalloc "$testdir/r-d"
+runtest regular unwritten "$testdir/r-u"
+runtest regular hole "$testdir/r-h"
+runtest regular regular "$testdir/r-r"
+
+runtest hole delalloc "$testdir/h-d"
+runtest hole unwritten "$testdir/h-u"
+runtest hole hole "$testdir/h-h"
+runtest hole regular "$testdir/h-r"
+
+runtest unwritten delalloc "$testdir/u-d"
+runtest unwritten unwritten "$testdir/u-u"
+runtest unwritten hole "$testdir/u-h"
+runtest unwritten regular "$testdir/u-r"
+
+runtest delalloc delalloc "$testdir/d-d"
+runtest delalloc unwritten "$testdir/d-u"
+runtest delalloc hole "$testdir/d-h"
+runtest delalloc regular "$testdir/d-r"
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/238 b/tests/generic/238
index e02396b..98530e0 100755
--- a/tests/generic/238
+++ b/tests/generic/238
@@ -36,7 +36,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -51,19 +51,19 @@ _require_xfs_io_command "falloc"
 
 rm -f "$seqres.full"
 
-PAGESZ=$(getconf PAGE_SIZE)
-BLKSZ=$((PAGESZ / 4))
+pagesz=$(getconf PAGE_SIZE)
+blksz=$((pagesz / 4))
 
 echo "Format and mount"
-_scratch_mkfs_blocksized $BLKSZ > "$seqres.full" 2>&1
+_scratch_mkfs_blocksized $blksz > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
-REAL_BLKSZ=$(stat -f -c '%S' $TESTDIR)
-test "$REAL_BLKSZ" != "$BLKSZ" && _notrun "Failed to format with small blocksize."
+real_blksz=$(stat -f -c '%S' $testdir)
+test "$real_blksz" != "$blksz" && _notrun "Failed to format with small blocksize."
 
 runtest() {
 	echo "runtest $1 $2"
@@ -73,19 +73,19 @@ runtest() {
 
 	echo "Create the original files"
 	mkdir -p "$dir"
-	_pwrite_byte 0x61 0 $PAGESZ "$dir/file1" >> "$seqres.full"
+	_pwrite_byte 0x61 0 $pagesz "$dir/file1" >> "$seqres.full"
 
-	"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$dir/file2" >> "$seqres.full"
-	"$XFS_IO_PROG" -f -c "truncate $PAGESZ" "$dir/file2.chk" >> "$seqres.full"
+	"$XFS_IO_PROG" -f -c "truncate $pagesz" "$dir/file2" >> "$seqres.full"
+	"$XFS_IO_PROG" -f -c "truncate $pagesz" "$dir/file2.chk" >> "$seqres.full"
 
 	case "$b2" in
 	"regular")
-		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		_pwrite_byte 0x61 $blksz $blksz "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $blksz $blksz "$dir/file2.chk" >> "$seqres.full"
 		;;
 	"unwritten")
-		"$XFS_IO_PROG" -f -c "falloc -k $BLKSZ $BLKSZ" "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x00 $BLKSZ $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		"$XFS_IO_PROG" -f -c "falloc -k $blksz $blksz" "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x00 $blksz $blksz "$dir/file2.chk" >> "$seqres.full"
 		;;
 	"hole")
 		;;
@@ -95,19 +95,19 @@ runtest() {
 
 	case "$b4" in
 	"regular")
-		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2.chk" >> "$seqres.full"
 		;;
 	"unwritten")
-		"$XFS_IO_PROG" -f -c "falloc -k $((BLKSZ * 3)) $BLKSZ" "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x00 $((BLKSZ * 3)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		"$XFS_IO_PROG" -f -c "falloc -k $((blksz * 3)) $blksz" "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x00 $((blksz * 3)) $blksz "$dir/file2.chk" >> "$seqres.full"
 		;;
 	"hole")
 		;;
 	esac
 
-	_reflink_range "$dir/file1" $BLKSZ "$dir/file2" $((BLKSZ * 2)) $BLKSZ >> "$seqres.full"
-	_pwrite_byte 0x61 $((BLKSZ * 2)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+	_reflink_range "$dir/file1" $blksz "$dir/file2" $((blksz * 2)) $blksz >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * 2)) $blksz "$dir/file2.chk" >> "$seqres.full"
 	_scratch_remount
 
 	echo "Compare files"
@@ -116,17 +116,17 @@ runtest() {
 
 	echo "CoW and unmount"
 	if [ "$b2" = "delalloc" ]; then
-		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $BLKSZ $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		_pwrite_byte 0x61 $blksz $blksz "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $blksz $blksz "$dir/file2.chk" >> "$seqres.full"
 	fi
 
 	if [ "$b4" = "delalloc" ]; then
-		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2" >> "$seqres.full"
-		_pwrite_byte 0x61 $((BLKSZ * 3)) $BLKSZ "$dir/file2.chk" >> "$seqres.full"
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2" >> "$seqres.full"
+		_pwrite_byte 0x61 $((blksz * 3)) $blksz "$dir/file2.chk" >> "$seqres.full"
 	fi
 
-	"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$dir/file2" >> "$seqres.full"
-	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $BLKSZ $((BLKSZ * 3))" "$dir/file2.chk" >> "$seqres.full"
+	"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$dir/file2" >> "$seqres.full"
+	"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $blksz $((blksz * 3))" "$dir/file2.chk" >> "$seqres.full"
 	_scratch_remount
 
 	echo "Compare files"
@@ -134,25 +134,25 @@ runtest() {
 	cmp -s "$dir/file2" "$dir/file2.chk" || _fail "file2 and file2.chk don't match."
 }
 
-runtest regular delalloc "$TESTDIR/r-d"
-runtest regular unwritten "$TESTDIR/r-u"
-runtest regular hole "$TESTDIR/r-h"
-runtest regular regular "$TESTDIR/r-r"
-
-runtest hole delalloc "$TESTDIR/h-d"
-runtest hole unwritten "$TESTDIR/h-u"
-runtest hole hole "$TESTDIR/h-h"
-runtest hole regular "$TESTDIR/h-r"
-
-runtest unwritten delalloc "$TESTDIR/u-d"
-runtest unwritten unwritten "$TESTDIR/u-u"
-runtest unwritten hole "$TESTDIR/u-h"
-runtest unwritten regular "$TESTDIR/u-r"
-
-runtest delalloc delalloc "$TESTDIR/d-d"
-runtest delalloc unwritten "$TESTDIR/d-u"
-runtest delalloc hole "$TESTDIR/d-h"
-runtest delalloc regular "$TESTDIR/d-r"
+runtest regular delalloc "$testdir/r-d"
+runtest regular unwritten "$testdir/r-u"
+runtest regular hole "$testdir/r-h"
+runtest regular regular "$testdir/r-r"
+
+runtest hole delalloc "$testdir/h-d"
+runtest hole unwritten "$testdir/h-u"
+runtest hole hole "$testdir/h-h"
+runtest hole regular "$testdir/h-r"
+
+runtest unwritten delalloc "$testdir/u-d"
+runtest unwritten unwritten "$testdir/u-u"
+runtest unwritten hole "$testdir/u-h"
+runtest unwritten regular "$testdir/u-r"
+
+runtest delalloc delalloc "$testdir/d-d"
+runtest delalloc unwritten "$testdir/d-u"
+runtest delalloc hole "$testdir/d-h"
+runtest delalloc regular "$testdir/d-r"
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/242 b/tests/generic/242
index 5f1f502..a5a17c3 100755
--- a/tests/generic/242
+++ b/tests/generic/242
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -55,40 +55,40 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
-BLKSZ=65536
-NR=6400
-BSZ=1280
+blksz=65536
+nr=6400
+bsz=1280
 
-FREE_BLOCKS=$(stat -f -c '%a' "$TESTDIR")
-REAL_BLKSZ=$(stat -f -c '%S' "$TESTDIR")
-SPACE_NEEDED=$(((BLKSZ * NR * 3) * 5 / 4))
-SPACE_AVAIL=$((FREE_BLOCKS * REAL_BLKSZ))
-test $SPACE_NEEDED -gt $SPACE_AVAIL && _notrun "Not enough space. $SPACE_AVAIL < $SPACE_NEEDED"
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
 
 echo "Create the original files"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file1" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file2.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file2.chk" | _filter_scratch
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file2.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file2.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/generic/243 b/tests/generic/243
index 2162eb7..b7ca466 100755
--- a/tests/generic/243
+++ b/tests/generic/243
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -55,40 +55,40 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf $TESTDIR
-mkdir $TESTDIR
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
 
-BLKSZ=65536
-NR=6400
-BSZ=1280
+blksz=65536
+nr=6400
+bsz=1280
 
-FREE_BLOCKS=$(stat -f -c '%a' "$TESTDIR")
-REAL_BLKSZ=$(stat -f -c '%S' "$TESTDIR")
-SPACE_NEEDED=$(((BLKSZ * NR * 3) * 5 / 4))
-SPACE_AVAIL=$((FREE_BLOCKS * REAL_BLKSZ))
-test $SPACE_NEEDED -gt $SPACE_AVAIL && _notrun "Not enough space. $SPACE_AVAIL < $SPACE_NEEDED"
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
 
 echo "Create the original files"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file1" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file2.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file2.chk" | _filter_scratch
 
 echo "CoW and unmount"
-"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file2" >> "$seqres.full"
-"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file2.chk" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file2.chk" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file2.chk" | _filter_scratch
 
 echo "Check for damage"
 umount "$SCRATCH_MNT"
diff --git a/tests/xfs/127 b/tests/xfs/127
index 61301de..c31cd17 100755
--- a/tests/xfs/127
+++ b/tests/xfs/127
@@ -51,22 +51,22 @@ echo "Format and mount"
 _scratch_mkfs -d size=$((2 * 4096 * 4096)) -l size=4194304 > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original file and reflink to copy1, copy2"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-_pwrite_byte 0x61 0 $((BLKSZ * 14 + 71)) "$TESTDIR/original" >> "$seqres.full"
-_cp_reflink "$TESTDIR/original" "$TESTDIR/copy1"
-_cp_reflink "$TESTDIR/copy1" "$TESTDIR/copy2"
+blksz="$(stat -f "$testdir" -c '%S')"
+_pwrite_byte 0x61 0 $((blksz * 14 + 71)) "$testdir/original" >> "$seqres.full"
+_cp_reflink "$testdir/original" "$testdir/copy1"
+_cp_reflink "$testdir/copy1" "$testdir/copy2"
 
 echo "Grow fs"
 "$XFS_GROWFS_PROG" "$SCRATCH_MNT" 2>&1 |  _filter_growfs >> "$seqres.full"
 _scratch_remount
 
 echo "Create more reflink copies"
-_cp_reflink "$TESTDIR/original" "$TESTDIR/copy3"
+_cp_reflink "$testdir/original" "$testdir/copy3"
 
 xfs_info "$SCRATCH_MNT" >> "$seqres.full"
 
diff --git a/tests/xfs/128 b/tests/xfs/128
index f461c1a..a96291a 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -52,93 +52,93 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
-FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
+free_blocks0=$(stat -f "$testdir" -c '%f')
 
 echo "Create the original file and reflink to file2, file3"
-BLKS=2000
-MARGIN=160
-BLKSZ=65536
-REAL_BLKSZ="$(stat -f $TESTDIR -c '%S')"
-BLKSZ_FACTOR=$((BLKSZ / REAL_BLKSZ))
-_pwrite_byte 0x61 0 $((BLKS * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
-_cp_reflink "$TESTDIR/file2" "$TESTDIR/file3"
-_cp_reflink "$TESTDIR/file3" "$TESTDIR/file4"
+blks=2000
+margin=160
+blksz=65536
+real_blksz="$(stat -f $testdir -c '%S')"
+blksz_factor=$((blksz / real_blksz))
+_pwrite_byte 0x61 0 $((blks * blksz)) "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2"
+_cp_reflink "$testdir/file2" "$testdir/file3"
+_cp_reflink "$testdir/file3" "$testdir/file4"
 _test_remount
-FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+free_blocks1=$(stat -f "$testdir" -c '%f')
 
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file4" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file4" | _filter_scratch
 
-C01=$(_md5_checksum "$TESTDIR/file1")
-C02=$(_md5_checksum "$TESTDIR/file2")
-C03=$(_md5_checksum "$TESTDIR/file3")
-C04=$(_md5_checksum "$TESTDIR/file4")
+c01=$(_md5_checksum "$testdir/file1")
+c02=$(_md5_checksum "$testdir/file2")
+c03=$(_md5_checksum "$testdir/file3")
+c04=$(_md5_checksum "$testdir/file4")
 
 echo "CoW the reflink copies"
-_pwrite_byte 0x62 $BLKSZ $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x63 $(( BLKSZ * (BLKS - 1) )) $BLKSZ "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x62 $blksz $blksz "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x63 $(( blksz * (blks - 1) )) $blksz "$testdir/file3" >> "$seqres.full"
 _test_remount
-FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+free_blocks2=$(stat -f "$testdir" -c '%f')
 
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file4" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file4" | _filter_scratch
 
-C11=$(_md5_checksum "$TESTDIR/file1")
-C12=$(_md5_checksum "$TESTDIR/file2")
-C13=$(_md5_checksum "$TESTDIR/file3")
-C14=$(_md5_checksum "$TESTDIR/file4")
+c11=$(_md5_checksum "$testdir/file1")
+c12=$(_md5_checksum "$testdir/file2")
+c13=$(_md5_checksum "$testdir/file3")
+c14=$(_md5_checksum "$testdir/file4")
 
 echo "Defragment"
-lsattr -l "$TESTDIR/" | _filter_scratch
-xfs_fsr -v -d "$TESTDIR/file1" >> "$seqres.full"
-xfs_fsr -v -d "$TESTDIR/file2" >> "$seqres.full" # fsr probably breaks the link
-xfs_fsr -v -d "$TESTDIR/file3" >> "$seqres.full" # fsr probably breaks the link
-xfs_fsr -v -d "$TESTDIR/file4" >> "$seqres.full" # fsr probably ignores this file
+lsattr -l "$testdir/" | _filter_scratch
+xfs_fsr -v -d "$testdir/file1" >> "$seqres.full"
+xfs_fsr -v -d "$testdir/file2" >> "$seqres.full" # fsr probably breaks the link
+xfs_fsr -v -d "$testdir/file3" >> "$seqres.full" # fsr probably breaks the link
+xfs_fsr -v -d "$testdir/file4" >> "$seqres.full" # fsr probably ignores this file
 _test_remount
-FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
+free_blocks3=$(stat -f "$testdir" -c '%f')
 
-md5sum "$TESTDIR/file1" | _filter_scratch
-md5sum "$TESTDIR/file2" | _filter_scratch
-md5sum "$TESTDIR/file3" | _filter_scratch
-md5sum "$TESTDIR/file4" | _filter_scratch
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file4" | _filter_scratch
 
-C21=$(_md5_checksum "$TESTDIR/file1")
-C22=$(_md5_checksum "$TESTDIR/file2")
-C23=$(_md5_checksum "$TESTDIR/file3")
-C24=$(_md5_checksum "$TESTDIR/file4")
+c21=$(_md5_checksum "$testdir/file1")
+c22=$(_md5_checksum "$testdir/file2")
+c23=$(_md5_checksum "$testdir/file3")
+c24=$(_md5_checksum "$testdir/file4")
 
 echo "Check files"
-test $C01 = $C02 || echo "Files 1-2 do not match"
-test $C01 = $C03 || echo "Files 1-3 do not match"
-test $C01 = $C04 || echo "Files 1-4 do not match"
-test $C02 = $C03 || echo "Files 2-3 do not match"
-test $C02 = $C04 || echo "Files 2-4 do not match"
-test $C03 = $C04 || echo "Files 3-4 do not match"
-
-test $C01 = $C11 || echo "File1 should not be different after CoW"
-test $C02 != $C12 || echo "File2 should be different after CoW"
-test $C03 != $C13 || echo "File3 should be different after CoW"
-test $C04 = $C14 || echo "File4 should not be different after CoW"
-
-test $C11 = $C21 || echo "File1 changed by defrag"
-test $C12 = $C22 || echo "File2 changed by defrag"
-test $C13 = $C23 || echo "File3 changed by defrag"
-test $C14 = $C24 || echo "File4 changed by defrag"
-
-#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3
-
-_within_tolerance "free blocks after creating some reflink copies" $FREE_BLOCKS1 $((FREE_BLOCKS0 - (BLKS * BLKSZ_FACTOR) )) $MARGIN -v
-_within_tolerance "free blocks after CoW some reflink copies" $FREE_BLOCKS2 $((FREE_BLOCKS1 - 2)) $MARGIN -v
-_within_tolerance "free blocks after defragging all reflink copies" $FREE_BLOCKS3 $((FREE_BLOCKS2 - (BLKS * 2 * BLKSZ_FACTOR))) $MARGIN -v
-_within_tolerance "free blocks after all tests" $FREE_BLOCKS3 $((FREE_BLOCKS0 - (BLKS * 3 * BLKSZ_FACTOR))) $MARGIN -v
+test $c01 = $c02 || echo "Files 1-2 do not match"
+test $c01 = $c03 || echo "Files 1-3 do not match"
+test $c01 = $c04 || echo "Files 1-4 do not match"
+test $c02 = $c03 || echo "Files 2-3 do not match"
+test $c02 = $c04 || echo "Files 2-4 do not match"
+test $c03 = $c04 || echo "Files 3-4 do not match"
+
+test $c01 = $c11 || echo "File1 should not be different after CoW"
+test $c02 != $c12 || echo "File2 should be different after CoW"
+test $c03 != $c13 || echo "File3 should be different after CoW"
+test $c04 = $c14 || echo "File4 should not be different after CoW"
+
+test $c11 = $c21 || echo "File1 changed by defrag"
+test $c12 = $c22 || echo "File2 changed by defrag"
+test $c13 = $c23 || echo "File3 changed by defrag"
+test $c14 = $c24 || echo "File4 changed by defrag"
+
+#echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3
+
+_within_tolerance "free blocks after creating some reflink copies" $free_blocks1 $((free_blocks0 - (blks * blksz_factor) )) $margin -v
+_within_tolerance "free blocks after CoW some reflink copies" $free_blocks2 $((free_blocks1 - 2)) $margin -v
+_within_tolerance "free blocks after defragging all reflink copies" $free_blocks3 $((free_blocks2 - (blks * 2 * blksz_factor))) $margin -v
+_within_tolerance "free blocks after all tests" $free_blocks3 $((free_blocks0 - (blks * 3 * blksz_factor))) $margin -v
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
diff --git a/tests/xfs/129 b/tests/xfs/129
index 3b7c59c..8d608f2 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -35,7 +35,7 @@ _cleanup()
 {
     cd /
     umount "$SCRATCH_MNT" > /dev/null 2>&1
-    rm -rf "$tmp".* "$TESTDIR" "$METADUMP_FILE" "$TEST_DIR/image"
+    rm -rf "$tmp".* "$testdir" "$metadump_file" "$TEST_DIR/image"
 }
 
 # get standard environment, filters and checks
@@ -54,34 +54,34 @@ rm -f "$seqres.full"
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
-METADUMP_FILE="$TEST_DIR/${seq}_metadump"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
+metadump_file="$TEST_DIR/${seq}_metadump"
 
 echo "Create the original file blocks"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-NR_BLKS=$((4 * BLKSZ / 12))
-_pwrite_byte 0x61 0 $((BLKSZ * NR_BLKS)) "$TESTDIR/file1" >> "$seqres.full"
+blksz="$(stat -f "$testdir" -c '%S')"
+nr_blks=$((4 * blksz / 12))
+_pwrite_byte 0x61 0 $((blksz * nr_blks)) "$testdir/file1" >> "$seqres.full"
 
 echo "Reflink every other block"
-seq 1 2 $((NR_BLKS - 1)) | while read nr; do
-	_reflink_range  "$TESTDIR/file1" $((nr * BLKSZ)) \
-			"$TESTDIR/file2" $((nr * BLKSZ)) $BLKSZ >> "$seqres.full"
+seq 1 2 $((nr_blks - 1)) | while read nr; do
+	_reflink_range  "$testdir/file1" $((nr * blksz)) \
+			"$testdir/file2" $((nr * blksz)) $blksz >> "$seqres.full"
 done
 
 echo "Create metadump file"
 _scratch_unmount
-_scratch_metadump "$METADUMP_FILE"
+_scratch_metadump "$metadump_file"
 
 # Now restore the obfuscated one back and take a look around
 echo "Restore metadump"
-xfs_mdrestore "$METADUMP_FILE" "$TEST_DIR/image"
+xfs_mdrestore "$metadump_file" "$TEST_DIR/image"
 _mount -t $FSTYP "$TEST_DIR/image" "$SCRATCH_MNT"
 umount "$SCRATCH_MNT"
 
 echo "Check restored fs"
-_check_generic_filesystem "$METADUMP_FILE"
+_check_generic_filesystem "$metadump_file"
 
 # success, all done
 status=0
diff --git a/tests/xfs/131 b/tests/xfs/131
index 5d092f1..8442821 100755
--- a/tests/xfs/131
+++ b/tests/xfs/131
@@ -33,7 +33,7 @@ _cleanup()
 {
     cd /
     umount "$SCRATCH_MNT" > /dev/null 2>&1
-    rm -rf "$tmp".* "$TESTDIR" "$METADUMP_FILE"
+    rm -rf "$tmp".* "$testdir" "$metadump_file"
 }
 
 # get standard environment, filters and checks
@@ -54,18 +54,18 @@ echo "Format and mount scratch device"
 _scratch_mkfs >> "$seqres.full"
 _scratch_mount
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original file blocks"
-BLKSZ=65536
-$XFS_IO_PROG -R -f -c "truncate $BLKSZ" "$TESTDIR/file1"
+blksz=65536
+$XFS_IO_PROG -R -f -c "truncate $blksz" "$testdir/file1"
 
 echo "Reflink every block"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" 2>&1 | _filter_scratch
+_cp_reflink "$testdir/file1" "$testdir/file2" 2>&1 | _filter_scratch
 
-test -s "$TESTDIR/file2" && _fail "Should not be able to reflink a realtime file."
+test -s "$testdir/file2" && _fail "Should not be able to reflink a realtime file."
 
 echo "Check restored fs"
 umount "$SCRATCH_MNT"
diff --git a/tests/xfs/132 b/tests/xfs/132
index ec7b178..79a6d57 100755
--- a/tests/xfs/132
+++ b/tests/xfs/132
@@ -49,7 +49,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -67,63 +67,63 @@ _require_xfs_io_command "falloc"
 
 rm -f "$seqres.full"
 
-TESTDIR="$TEST_DIR/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
+testdir="$TEST_DIR/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
 
 echo "Create the original file blocks"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
-BLKS=2000
-MARGIN=100
-SZ=$((BLKSZ * BLKS))
-FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
-NR=4
-_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+blksz="$(stat -f "$testdir" -c '%S')"
+blks=2000
+margin=100
+sz=$((blksz * blks))
+free_blocks0=$(stat -f "$testdir" -c '%f')
+nr=4
+_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
 _test_remount
 
 echo "Create the reflink copies"
-for i in `seq 2 $NR`; do
-	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+for i in `seq 2 $nr`; do
+	_cp_reflink "$testdir/file1" "$testdir/file$i"
 done
 _test_remount
-FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
-lsattr -l $TESTDIR/ | _filter_test_dir
+free_blocks1=$(stat -f "$testdir" -c '%f')
+lsattr -l $testdir/ | _filter_test_dir
 
 echo "funshare part of a file"
-"$XFS_IO_PROG" -f -c "falloc 0 $((SZ / 2))" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "falloc 0 $((sz / 2))" "$testdir/file2"
 _test_remount
-lsattr -l $TESTDIR/ | _filter_test_dir
+lsattr -l $testdir/ | _filter_test_dir
 
 echo "funshare some of the copies"
-"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file2"
-"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file3"
+"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file2"
+"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file3"
 _test_remount
-FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
-lsattr -l $TESTDIR/ | _filter_test_dir
+free_blocks2=$(stat -f "$testdir" -c '%f')
+lsattr -l $testdir/ | _filter_test_dir
 
 echo "funshare the rest of the files"
-"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file4"
-"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file1"
+"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file4"
+"$XFS_IO_PROG" -f -c "falloc 0 $sz" "$testdir/file1"
 _test_remount
-FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
-lsattr -l $TESTDIR/ | _filter_test_dir
+free_blocks3=$(stat -f "$testdir" -c '%f')
+lsattr -l $testdir/ | _filter_test_dir
 
 echo "Rewrite the original file"
-_pwrite_byte 0x65 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x65 0 $sz "$testdir/file1" >> "$seqres.full"
 _test_remount
-FREE_BLOCKS4=$(stat -f "$TESTDIR" -c '%f')
-lsattr -l $TESTDIR/ | _filter_test_dir
-#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3 $FREE_BLOCKS4
+free_blocks4=$(stat -f "$testdir" -c '%f')
+lsattr -l $testdir/ | _filter_test_dir
+#echo $free_blocks0 $free_blocks1 $free_blocks2 $free_blocks3 $free_blocks4
 
-_within_tolerance "free blocks after reflinking" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+_within_tolerance "free blocks after reflinking" $free_blocks1 $((free_blocks0 - blks)) $margin -v
 
-_within_tolerance "free blocks after nocow'ing some copies" $FREE_BLOCKS2 $((FREE_BLOCKS1 - (2 * BLKS))) $MARGIN -v
+_within_tolerance "free blocks after nocow'ing some copies" $free_blocks2 $((free_blocks1 - (2 * blks))) $margin -v
 
-_within_tolerance "free blocks after nocow'ing all copies" $FREE_BLOCKS3 $((FREE_BLOCKS2 - BLKS)) $MARGIN -v
+_within_tolerance "free blocks after nocow'ing all copies" $free_blocks3 $((free_blocks2 - blks)) $margin -v
 
-_within_tolerance "free blocks after overwriting original" $FREE_BLOCKS4 $FREE_BLOCKS3 $MARGIN -v
+_within_tolerance "free blocks after overwriting original" $free_blocks4 $free_blocks3 $margin -v
 
-_within_tolerance "free blocks after all tests" $FREE_BLOCKS4 $((FREE_BLOCKS0 - (4 * BLKS))) $MARGIN -v
+_within_tolerance "free blocks after all tests" $free_blocks4 $((free_blocks0 - (4 * blks))) $margin -v
 
 # success, all done
 status=0
diff --git a/tests/xfs/139 b/tests/xfs/139
index 152c6bd..7400cf8 100644
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -52,26 +52,26 @@ echo "Format and mount"
 _scratch_mkfs -d agsize=$((32 * 1048576)) > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
-BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
+blksz="$(stat -f "$testdir" -c '%S')"
 
 echo "Create the original files"
-SZ=$((48 * 1048576))
-NR=$((SZ / BLKSZ))
-_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
+sz=$((48 * 1048576))
+nr=$((sz / blksz))
+_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
 _scratch_remount
 
 echo "CoW every other block"
-_pwrite_byte 0x62 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $sz "$testdir/file1" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-md5sum "$TESTDIR/file1" | _filter_test_dir
-md5sum "$TESTDIR/file2" | _filter_test_dir
-#filefrag -v "$TESTDIR/file1" "$TESTDIR/file2"
+md5sum "$testdir/file1" | _filter_test_dir
+md5sum "$testdir/file2" | _filter_test_dir
+#filefrag -v "$testdir/file1" "$testdir/file2"
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"
diff --git a/tests/xfs/140 b/tests/xfs/140
index 45be9f4..133bb72 100644
--- a/tests/xfs/140
+++ b/tests/xfs/140
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf "$tmp".* "$TESTDIR"
+    rm -rf "$tmp".* "$testdir"
 }
 
 # get standard environment, filters and checks
@@ -52,33 +52,33 @@ echo "Format and mount"
 _scratch_mkfs -d agsize=$((32 * 1048576)) > "$seqres.full" 2>&1
 _scratch_mount >> "$seqres.full" 2>&1
 
-TESTDIR="$SCRATCH_MNT/test-$seq"
-rm -rf "$TESTDIR"
-mkdir "$TESTDIR"
-BLKSZ="$(stat -f -c '%S' "$TESTDIR")"
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
+blksz="$(stat -f -c '%S' "$testdir")"
 
 echo "Create the original files"
-SZ=$((48 * 1048576))
-NR=$((SZ / BLKSZ))
-_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
-_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
-_pwrite_byte 0x61 0 $SZ "$TESTDIR/file2.chk" >> "$seqres.full"
+sz=$((48 * 1048576))
+nr=$((sz / blksz))
+_pwrite_byte 0x61 0 $sz "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $sz "$testdir/file2.chk" >> "$seqres.full"
 _scratch_remount
 
 echo "Compare files"
-cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "file1 and file2 do not match"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+cmp -s "$testdir/file1" "$testdir/file2" || echo "file1 and file2 do not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
 
 echo "CoW every other block"
-seq 1 2 $((NR - 1)) | while read f; do
-	_pwrite_byte 0x62 $((f * BLKSZ)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
-	_pwrite_byte 0x62 $((f * BLKSZ)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+seq 1 2 $((nr - 1)) | while read f; do
+	_pwrite_byte 0x62 $((f * blksz)) $blksz "$testdir/file2" >> "$seqres.full"
+	_pwrite_byte 0x62 $((f * blksz)) $blksz "$testdir/file2.chk" >> "$seqres.full"
 done
 _scratch_remount
 
 echo "Compare files"
-! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "file1 and file2 must not match"
-cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+! cmp -s "$testdir/file1" "$testdir/file2" || echo "file1 and file2 must not match"
+cmp -s "$testdir/file2" "$testdir/file2.chk" || echo "file2 and file2.chk do not match"
 
 echo "Check scratch fs"
 umount "$SCRATCH_MNT"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
