Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 74E617CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 00:57:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 37454304066
	for <xfs@oss.sgi.com>; Wed, 25 May 2016 22:57:25 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id uYBwjb4EJBTAAEOs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 May 2016 22:57:22 -0700 (PDT)
Subject: [PATCH 2/7] tests: don't put loop control files on the scratch mount
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 25 May 2016 22:57:15 -0700
Message-ID: <146424223512.6278.15231849939938178494.stgit@birch.djwong.org>
In-Reply-To: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

If we're doing write/overwrite/snapshot/resource exhaustion tests on
the scratch device, use the test directory to hold the loop
termination signal files.  This way we don't run infinitely because we
can't create the flag due to ENOSPC.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/162 |    8 +++++---
 tests/generic/163 |    8 +++++---
 tests/generic/164 |    8 +++++---
 tests/generic/165 |    8 +++++---
 tests/generic/166 |    8 +++++---
 tests/generic/167 |    8 +++++---
 tests/generic/168 |    8 +++++---
 tests/generic/170 |    8 +++++---
 tests/generic/333 |   20 ++++++++++++--------
 tests/generic/334 |   20 ++++++++++++--------
 10 files changed, 64 insertions(+), 40 deletions(-)


diff --git a/tests/generic/162 b/tests/generic/162
index 5ff2ee2..9142d53 100755
--- a/tests/generic/162
+++ b/tests/generic/162
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf $tmp.*
+    rm -rf $tmp.* $finished_file
     wait
 }
 
@@ -51,6 +51,8 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
+finished_file=$TEST_DIR/finished
+rm -rf $finished_file
 mkdir $testdir
 
 loops=512
@@ -64,7 +66,7 @@ _pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
 
 overwrite() {
-	while [ ! -e $testdir/finished ]; do
+	while [ ! -e $finished_file ]; do
 		seq $nr_loops -1 0 | while read i; do
 			_pwrite_byte 0x61 $((i * blksz)) $blksz $testdir/file2 >> $seqres.full
 		done
@@ -81,7 +83,7 @@ for i in `seq 1 2`; do
 	done
 done
 echo "Finished dedupeing"
-touch $testdir/finished
+touch $finished_file
 wait
 
 # success, all done
diff --git a/tests/generic/163 b/tests/generic/163
index fcba677..ebf4831 100755
--- a/tests/generic/163
+++ b/tests/generic/163
@@ -33,7 +33,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf $tmp.*
+    rm -rf $tmp.* $finished_file
     wait
 }
 
@@ -51,6 +51,8 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
+finished_file=$TEST_DIR/finished
+rm -rf $finished_file
 mkdir $testdir
 
 loops=512
@@ -64,7 +66,7 @@ _pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
 
 overwrite() {
-	while [ ! -e $testdir/finished ]; do
+	while [ ! -e $finished_file ]; do
 		seq $nr_loops -1 0 | while read i; do
 			_pwrite_byte 0x61 $((i * blksz)) $blksz $testdir/file1 >> $seqres.full
 		done
@@ -81,7 +83,7 @@ for i in `seq 1 2`; do
 	done
 done
 echo "Finished dedupeing"
-touch $testdir/finished
+touch $finished_file
 wait
 
 # success, all done
diff --git a/tests/generic/164 b/tests/generic/164
index acacb7f..76f419f 100755
--- a/tests/generic/164
+++ b/tests/generic/164
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf $tmp.*
+    rm -rf $tmp.* $finished_file
     wait
 }
 
@@ -53,6 +53,8 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
+finished_file=$TEST_DIR/finished
+rm -rf $finished_file
 mkdir $testdir
 
 loops=512
@@ -71,7 +73,7 @@ fbytes() {
 }
 
 reader() {
-	while [ ! -e $testdir/finished ]; do
+	while [ ! -e $finished_file ]; do
 		_read_range $testdir/file3 0 $((loops * blksz)) | fbytes
 	done
 }
@@ -91,7 +93,7 @@ for i in `seq 1 2`; do
 	done
 done
 echo "Finished reflinking"
-touch $testdir/finished
+touch $finished_file
 wait
 
 # success, all done
diff --git a/tests/generic/165 b/tests/generic/165
index b742d19..326127b 100755
--- a/tests/generic/165
+++ b/tests/generic/165
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf $tmp.*
+    rm -rf $tmp.* $finished_file
     wait
 }
 
@@ -54,6 +54,8 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
+finished_file=$TEST_DIR/finished
+rm -rf $finished_file
 mkdir $testdir
 
 loops=512
@@ -72,7 +74,7 @@ fbytes() {
 }
 
 reader() {
-	while [ ! -e $testdir/finished ]; do
+	while [ ! -e $finished_file ]; do
 		_read_range $testdir/file3 0 $((loops * blksz)) -d | fbytes
 	done
 }
@@ -92,7 +94,7 @@ for i in `seq 1 2`; do
 	done
 done
 echo "Finished reflinking"
-touch $testdir/finished
+touch $finished_file
 wait
 
 # success, all done
diff --git a/tests/generic/166 b/tests/generic/166
index 0e31f2e..f4d7210 100755
--- a/tests/generic/166
+++ b/tests/generic/166
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf $tmp.*
+    rm -rf $tmp.* $finished_file
     wait
 }
 
@@ -54,6 +54,8 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
+finished_file=$TEST_DIR/finished
+rm -rf $finished_file
 mkdir $testdir
 
 loops=1024
@@ -68,7 +70,7 @@ _scratch_cycle_mount
 # Snapshot creator...
 snappy() {
 	n=0
-	while [ ! -e $testdir/finished ]; do
+	while [ ! -e $finished_file ]; do
 		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
 		res=$?
 		echo "$out" | grep -q "No space left" && break
@@ -83,7 +85,7 @@ snappy &
 seq $nr_loops -1 0 | while read i; do
 	_pwrite_byte 0x63 $((i * blksz)) $blksz -d $testdir/file1 >> $seqres.full
 done
-touch $testdir/finished
+touch $finished_file
 wait
 
 # success, all done
diff --git a/tests/generic/167 b/tests/generic/167
index b2d6c87..0db2109 100755
--- a/tests/generic/167
+++ b/tests/generic/167
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf $tmp.*
+    rm -rf $tmp.* $finished_file
     wait
 }
 
@@ -53,6 +53,8 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
+finished_file=$TEST_DIR/finished
+rm -rf $finished_file
 mkdir $testdir
 
 loops=1024
@@ -67,7 +69,7 @@ _scratch_cycle_mount
 # Snapshot creator...
 snappy() {
 	n=0
-	while [ ! -e $testdir/finished ]; do
+	while [ ! -e $finished_file ]; do
 		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
 		res=$?
 		echo "$out" | grep -q "No space left" && break
@@ -82,7 +84,7 @@ snappy &
 seq $nr_loops -1 0 | while read i; do
 	_pwrite_byte 0x63 $((i * blksz)) $blksz $testdir/file1 >> $seqres.full
 done
-touch $testdir/finished
+touch $finished_file
 wait
 
 # success, all done
diff --git a/tests/generic/168 b/tests/generic/168
index 7047d10..9d95261 100755
--- a/tests/generic/168
+++ b/tests/generic/168
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf $tmp.*
+    rm -rf $tmp.* $finished_file
     wait
 }
 
@@ -52,6 +52,8 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
+finished_file=$TEST_DIR/finished
+rm -rf $finished_file
 mkdir $testdir
 
 loops=1024
@@ -66,7 +68,7 @@ _scratch_cycle_mount
 
 # Direct I/O overwriter...
 overwrite() {
-	while [ ! -e $testdir/finished ]; do
+	while [ ! -e $finished_file ]; do
 		seq $nr_loops -1 0 | while read i; do
 			_pwrite_byte 0x63 $((i * blksz)) $blksz $testdir/file2 >> $seqres.full
 		done
@@ -82,7 +84,7 @@ seq 1 10 | while read j; do
 		[ $? -ne 0 ] && exit
 	done
 done
-touch $testdir/finished
+touch $finished_file
 wait
 
 # success, all done
diff --git a/tests/generic/170 b/tests/generic/170
index 4861052..742f03a 100755
--- a/tests/generic/170
+++ b/tests/generic/170
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf $tmp.*
+    rm -rf $tmp.* $finished_file
     wait
 }
 
@@ -53,6 +53,8 @@ _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
+finished_file=$TEST_DIR/finished
+rm -rf $finished_file
 mkdir $testdir
 
 loops=1024
@@ -67,7 +69,7 @@ _scratch_cycle_mount
 
 # Direct I/O overwriter...
 overwrite() {
-	while [ ! -e $testdir/finished ]; do
+	while [ ! -e $finished_file ]; do
 		seq $nr_loops -1 0 | while read i; do
 			_pwrite_byte 0x63 $((i * blksz)) $blksz -d $testdir/file2 >> $seqres.full
 		done
@@ -83,7 +85,7 @@ seq 1 10 | while read j; do
 		[ $? -ne 0 ] && exit
 	done
 done
-touch $testdir/finished
+touch $finished_file
 wait
 
 # success, all done
diff --git a/tests/generic/333 b/tests/generic/333
index 8db86e3..3e7b600 100755
--- a/tests/generic/333
+++ b/tests/generic/333
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf $tmp.*
+    rm -rf $tmp.* $finished_file $abort_file
     wait
 }
 
@@ -54,6 +54,10 @@ _scratch_mkfs_sized $((400 * 1048576)) > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
+finished_file=$TEST_DIR/finished
+rm -rf $finished_file
+abort_file=$TEST_DIR/abort
+rm -rf $abort_file
 mkdir $testdir
 
 loops=1024
@@ -68,7 +72,7 @@ _scratch_cycle_mount
 # Snapshot creator...
 snappy() {
 	n=0
-	while [ ! -e $testdir/finished ]; do
+	while [ ! -e $finished_file ]; do
 		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
 		res=$?
 		echo $out | grep -q "No space left" && break
@@ -76,7 +80,7 @@ snappy() {
 		test $res -ne 0 && break
 		n=$((n + 1))
 	done
-	touch $testdir/abort
+	touch $abort_file
 }
 
 echo "Snapshot a file undergoing directio rewrite"
@@ -85,13 +89,13 @@ seq 1 1000 | while read j; do
 	seq $nr_loops -1 0 | while read i; do
 		out="$(_pwrite_byte 0x63 $((i * blksz)) $blksz -d $testdir/file1 2>&1)"
 		echo $out >> $seqres.full
-		echo $out | grep -q "No space left" && touch $testdir/abort
-		echo $out | grep -qi "error" && touch $testdir/abort
-		test -e $testdir/abort && break
+		echo $out | grep -q "No space left" && touch $abort_file
+		echo $out | grep -qi "error" && touch $abort_file
+		test -e $abort_file && break
 	done
-	test -e $testdir/abort && break
+	test -e $abort_file && break
 done
-touch $testdir/finished
+touch $finished_file
 wait
 
 # success, all done
diff --git a/tests/generic/334 b/tests/generic/334
index 5714125..e45502a 100755
--- a/tests/generic/334
+++ b/tests/generic/334
@@ -34,7 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 7 15
 _cleanup()
 {
     cd /
-    rm -rf $tmp.*
+    rm -rf $tmp.* $finished_file $abort_file
     wait
 }
 
@@ -53,6 +53,10 @@ _scratch_mkfs_sized $((400 * 1048576)) > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
+finished_file=$TEST_DIR/finished
+rm -rf $finished_file
+abort_file=$TEST_DIR/abort
+rm -rf $abort_file
 mkdir $testdir
 
 loops=1024
@@ -67,7 +71,7 @@ _scratch_cycle_mount
 # Snapshot creator...
 snappy() {
 	n=0
-	while [ ! -e $testdir/finished ]; do
+	while [ ! -e $finished_file ]; do
 		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
 		res=$?
 		echo $out | grep -q "No space left" && break
@@ -75,7 +79,7 @@ snappy() {
 		test $res -ne 0 && break
 		n=$((n + 1))
 	done
-	touch $testdir/abort
+	touch $abort_file
 }
 
 echo "Snapshot a file undergoing buffered rewrite"
@@ -84,13 +88,13 @@ seq 1 1000 | while read j; do
 	seq $nr_loops -1 0 | while read i; do
 		out="$(_pwrite_byte 0x63 $((i * blksz)) $blksz $testdir/file1 2>&1)"
 		echo $out >> $seqres.full
-		echo $out | grep -q "No space left" && touch $testdir/abort
-		echo $out | grep -qi "error" && touch $testdir/abort
-		test -e $testdir/abort && break
+		echo $out | grep -q "No space left" && touch $abort_file
+		echo $out | grep -qi "error" && touch $abort_file
+		test -e $abort_file && break
 	done
-	test -e $testdir/abort && break
+	test -e $abort_file && break
 done
-touch $testdir/finished
+touch $finished_file
 wait
 
 # success, all done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
