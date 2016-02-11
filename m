Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C5B27CBB
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:40:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8DAE2304059
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:40:21 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id VsslWDKGELitvuiN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:40:18 -0800 (PST)
Subject: [PATCH 09/32] reflink: refactor mixed block creation code
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:40:15 -0800
Message-ID: <20160211234015.2202.41362.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Refactor the code that creates files with mixed block types that we feed
into CoW tests to make sure that we can tiptoe around that kind of stuff.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/reflink        |  108 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/188     |    8 ----
 tests/generic/189     |    8 ----
 tests/generic/190     |    8 ----
 tests/generic/191     |    8 ----
 tests/generic/194     |   13 +-----
 tests/generic/195     |   13 +-----
 tests/generic/196     |    8 ----
 tests/generic/197     |    8 ----
 tests/generic/199     |   31 +-------------
 tests/generic/199.out |    4 +-
 tests/generic/200     |   31 +-------------
 tests/generic/200.out |    4 +-
 13 files changed, 126 insertions(+), 126 deletions(-)


diff --git a/common/reflink b/common/reflink
index 3d6a8c1..b92f664 100644
--- a/common/reflink
+++ b/common/reflink
@@ -187,3 +187,111 @@ _dedupe_range() {
 
 	"$XFS_IO_PROG" $xfs_io_args -f -c "dedupe $file1 $offset1 $offset2 $len" "$file2"
 }
+
+# Create a file of interleaved unwritten and reflinked blocks
+_weave_reflink_unwritten() {
+	blksz=$1
+	nr=$2
+	sfile=$3
+	dfile=$4
+
+	_pwrite_byte 0x61 0 $((blksz * nr)) $sfile
+	$XFS_IO_PROG -f -c "falloc 0 $((blksz * nr))" $dfile
+	_pwrite_byte 0x00 0 $((blksz * nr)) $dfile.chk
+	seq 0 2 $((nr - 1)) | while read i; do
+		_reflink_range $sfile $((blksz * i)) $dfile $((blksz * i)) $blksz
+		_pwrite_byte 0x61 $((blksz * i)) $blksz $dfile.chk
+	done
+}
+
+# Create a file of interleaved holes and reflinked blocks
+_weave_reflink_holes() {
+	blksz=$1
+	nr=$2
+	sfile=$3
+	dfile=$4
+
+	_pwrite_byte 0x61 0 $((blksz * nr)) $sfile
+	$XFS_IO_PROG -f -c "truncate $((blksz * nr))" $dfile
+	_pwrite_byte 0x00 0 $((blksz * nr)) $dfile.chk
+	seq 0 2 $((nr - 1)) | while read i; do
+		_reflink_range $sfile $((blksz * i)) $dfile $((blksz * i)) $blksz
+		_pwrite_byte 0x61 $((blksz * i)) $blksz $dfile.chk
+	done
+}
+
+# For a file created with _weave_reflink_holes, fill the holes with delalloc
+# extents
+_weave_reflink_holes_delalloc() {
+	blksz=$1
+	nr=$2
+	dfile=$3
+
+	seq 1 2 $((nr - 1)) | while read i; do
+		_pwrite_byte 0x62 $((blksz * i)) $blksz $dfile
+		_pwrite_byte 0x62 $((blksz * i)) $blksz $dfile.chk
+	done
+}
+
+# Create a file of interleaved regular blocks and reflinked blocks
+_weave_reflink_regular() {
+	blksz=$1
+	nr=$2
+	sfile=$3
+	dfile=$4
+
+	_pwrite_byte 0x61 0 $((blksz * nr)) $sfile
+	_pwrite_byte 0x62 0 $((blksz * nr)) $dfile
+	_pwrite_byte 0x62 0 $((blksz * nr)) $dfile.chk
+	seq 0 2 $((nr - 1)) | while read i; do
+		_reflink_range $sfile $((blksz * i)) $dfile $((blksz * i)) $blksz
+		_pwrite_byte 0x61 $((blksz * i)) $blksz $dfile.chk
+	done
+}
+
+# Create a file of interleaved holes, unwritten blocks, regular blocks, and
+# reflinked blocks
+_weave_reflink_rainbow() {
+	blksz=$1
+	nr=$2
+	sfile=$3
+	dfile=$4
+
+	_pwrite_byte 0x61 0 $((blksz * nr)) $sfile
+	$XFS_IO_PROG -f -c "truncate $((blksz * nr))" $dfile
+	_pwrite_byte 0x00 0 $((blksz * nr)) $dfile.chk
+	# 0 blocks are reflinked
+	seq 0 5 $((nr - 1)) | while read i; do
+		_reflink_range $sfile $((blksz * i)) $dfile $((blksz * i)) $blksz
+		_pwrite_byte 0x61 $((blksz * i)) $blksz $dfile.chk
+	done
+	# 1 blocks are unwritten
+	seq 1 5 $((nr - 1)) | while read i; do
+		$XFS_IO_PROG -f -c "falloc $((blksz * i)) $blksz" $dfile
+		_pwrite_byte 0x00 $((blksz * i)) $blksz $dfile.chk
+	done
+	# 2 blocks are holes
+	seq 2 5 $((nr - 1)) | while read i; do
+		_pwrite_byte 0x00 $((blksz * i)) $blksz $dfile.chk
+	done
+	# 3 blocks are regular
+	seq 3 5 $((nr - 1)) | while read i; do
+		_pwrite_byte 0x71 $((blksz * i)) $blksz $dfile
+		_pwrite_byte 0x71 $((blksz * i)) $blksz $dfile.chk
+	done
+	# 4 blocks will be delalloc later
+}
+
+# For a file created with _weave_reflink_rainbow, fill the holes with delalloc
+# extents
+_weave_reflink_rainbow_delalloc() {
+	blksz=$1
+	nr=$2
+	dfile=$3
+
+	# 4 blocks are delalloc (do later)
+	seq 4 5 $((nr - 1)) | while read i; do
+		_pwrite_byte 0x62 $((blksz * i)) $blksz $dfile
+		_pwrite_byte 0x62 $((blksz * i)) $blksz $dfile.chk
+	done
+}
diff --git a/tests/generic/188 b/tests/generic/188
index 7596c4b..86980cc 100755
--- a/tests/generic/188
+++ b/tests/generic/188
@@ -63,13 +63,7 @@ mkdir $testdir
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "falloc 0 $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
-seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
+_weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
diff --git a/tests/generic/189 b/tests/generic/189
index 130dc58..8f5a338 100755
--- a/tests/generic/189
+++ b/tests/generic/189
@@ -63,13 +63,7 @@ mkdir $testdir
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "falloc 0 $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
-seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
+_weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
diff --git a/tests/generic/190 b/tests/generic/190
index 0171475..8edfeb7 100755
--- a/tests/generic/190
+++ b/tests/generic/190
@@ -63,13 +63,7 @@ mkdir $testdir
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
-seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
+_weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
diff --git a/tests/generic/191 b/tests/generic/191
index 34d96f9..dd97baa 100755
--- a/tests/generic/191
+++ b/tests/generic/191
@@ -63,13 +63,7 @@ mkdir $testdir
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
-seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
+_weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
diff --git a/tests/generic/194 b/tests/generic/194
index e9feaad..82b3100 100755
--- a/tests/generic/194
+++ b/tests/generic/194
@@ -64,13 +64,7 @@ mkdir $testdir
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
-seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
+_weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
@@ -79,10 +73,7 @@ md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "directio CoW across the transition"
-seq 1 2 $((nr-1)) | while read f; do
-	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
-	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
+_weave_reflink_holes_delalloc $blksz $nr $testdir/file3 >> $seqres.full
 "$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
 _pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
diff --git a/tests/generic/195 b/tests/generic/195
index 32548ba..ce4c0a9 100755
--- a/tests/generic/195
+++ b/tests/generic/195
@@ -64,13 +64,7 @@ mkdir $testdir
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
-seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
+_weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
@@ -79,10 +73,7 @@ md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "CoW across the transition"
-seq 1 2 $((nr-1)) | while read f; do
-	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
-	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
+_weave_reflink_holes_delalloc $blksz $nr $testdir/file3 >> $seqres.full
 "$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
 _pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
 _scratch_remount
diff --git a/tests/generic/196 b/tests/generic/196
index 4ec2cff..a7a0035 100755
--- a/tests/generic/196
+++ b/tests/generic/196
@@ -63,13 +63,7 @@ mkdir $testdir
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
-seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
+_weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
diff --git a/tests/generic/197 b/tests/generic/197
index 356a587..84a14ff 100755
--- a/tests/generic/197
+++ b/tests/generic/197
@@ -63,13 +63,7 @@ mkdir $testdir
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
-_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3.chk" >> "$seqres.full"
-seq 0 2 $((nr-1)) | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
+_weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
diff --git a/tests/generic/199 b/tests/generic/199
index 03b8fda..6a65533 100755
--- a/tests/generic/199
+++ b/tests/generic/199
@@ -69,30 +69,7 @@ mkdir $testdir
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
-# 0 blocks are reflinked
-seq 0 5 $nr | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
-sync
-# 1 blocks are unwritten
-seq 1 5 $nr | while read f; do
-	$XFS_IO_PROG -f -c "falloc $((blksz * f)) $blksz" "$testdir/file3" >> "$seqres.full"
-	_pwrite_byte 0x00 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
-sync
-# 2 blocks are holes
-seq 2 5 $nr | while read f; do
-	_pwrite_byte 0x00 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
-# 3 blocks are regular
-seq 3 5 $nr | while read f; do
-	_pwrite_byte 0x71 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
-	_pwrite_byte 0x71 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
-sync
+_weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
@@ -101,11 +78,7 @@ md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "directio CoW across the transition"
-# 4 blocks are delalloc (do later)
-seq 4 5 $nr | while read f; do
-	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
-	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
+_weave_reflink_rainbow_delalloc $blksz $nr $testdir/file3 >> $seqres.full
 # now cow
 "$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
 _pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
diff --git a/tests/generic/199.out b/tests/generic/199.out
index b35c135..a1016ac 100644
--- a/tests/generic/199.out
+++ b/tests/generic/199.out
@@ -8,5 +8,5 @@ bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-199/file1
 directio CoW across the transition
 Compare files
 bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-199/file1
-36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-199/file3
-36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-199/file3.chk
+26aa3a0749b867ec58363c8539ee5471  SCRATCH_MNT/test-199/file3
+26aa3a0749b867ec58363c8539ee5471  SCRATCH_MNT/test-199/file3.chk
diff --git a/tests/generic/200 b/tests/generic/200
index e71eedc..541d16d 100755
--- a/tests/generic/200
+++ b/tests/generic/200
@@ -69,30 +69,7 @@ mkdir $testdir
 echo "Create the original files"
 blksz=65536
 nr=64
-_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
-$XFS_IO_PROG -f -c "truncate $((blksz * nr))" "$testdir/file3" >> "$seqres.full"
-# 0 blocks are reflinked
-seq 0 5 $nr | while read f; do
-	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
-	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
-sync
-# 1 blocks are unwritten
-seq 1 5 $nr | while read f; do
-	$XFS_IO_PROG -f -c "falloc $((blksz * f)) $blksz" "$testdir/file3" >> "$seqres.full"
-	_pwrite_byte 0x00 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
-sync
-# 2 blocks are holes
-seq 2 5 $nr | while read f; do
-	_pwrite_byte 0x00 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
-# 3 blocks are regular
-seq 3 5 $nr | while read f; do
-	_pwrite_byte 0x71 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
-	_pwrite_byte 0x71 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
-sync
+_weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
 _scratch_remount
 
 echo "Compare files"
@@ -101,11 +78,7 @@ md5sum "$testdir/file3" | _filter_scratch
 md5sum "$testdir/file3.chk" | _filter_scratch
 
 echo "directio CoW across the transition"
-# 4 blocks are delalloc (do later)
-seq 4 5 $nr | while read f; do
-	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3" >> "$seqres.full"
-	_pwrite_byte 0x62 $((blksz * f)) $blksz "$testdir/file3.chk" >> "$seqres.full"
-done
+_weave_reflink_rainbow_delalloc $blksz $nr $testdir/file3 >> $seqres.full
 # now cow
 "$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file3" >> "$seqres.full"
 _pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file3.chk" >> "$seqres.full"
diff --git a/tests/generic/200.out b/tests/generic/200.out
index 140eff9..76c01c7 100644
--- a/tests/generic/200.out
+++ b/tests/generic/200.out
@@ -8,5 +8,5 @@ bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-200/file1
 directio CoW across the transition
 Compare files
 bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-200/file1
-36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-200/file3
-36f6b5317a9a921fc91175390ccf7f69  SCRATCH_MNT/test-200/file3.chk
+26aa3a0749b867ec58363c8539ee5471  SCRATCH_MNT/test-200/file3
+26aa3a0749b867ec58363c8539ee5471  SCRATCH_MNT/test-200/file3.chk

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
