Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31024 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755752AbcI3CXl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 22:23:41 -0400
Subject: [PATCH 5/9] misc: use get_block_size helper
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 19:23:34 -0700
Message-ID: <147520221457.26891.3971727985743447930.stgit@birch.djwong.org>
In-Reply-To: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
References: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Don't open code grabbing the block size; just use the helper.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/150 |    2 +-
 tests/generic/151 |    2 +-
 tests/generic/152 |    2 +-
 tests/generic/153 |    2 +-
 tests/generic/154 |    2 +-
 tests/generic/155 |    2 +-
 tests/generic/156 |    2 +-
 tests/generic/157 |    2 +-
 tests/generic/158 |    2 +-
 tests/generic/159 |    2 +-
 tests/generic/160 |    2 +-
 tests/generic/171 |    2 +-
 tests/generic/173 |    2 +-
 tests/generic/174 |    2 +-
 tests/generic/175 |    2 +-
 tests/generic/176 |    2 +-
 tests/generic/205 |    2 +-
 tests/generic/206 |    2 +-
 tests/generic/216 |    2 +-
 tests/generic/217 |    2 +-
 tests/generic/218 |    2 +-
 tests/generic/220 |    2 +-
 tests/generic/222 |    2 +-
 tests/generic/227 |    2 +-
 tests/generic/229 |    2 +-
 tests/generic/238 |    2 +-
 tests/generic/242 |    2 +-
 tests/generic/243 |    2 +-
 tests/generic/296 |    2 +-
 tests/generic/297 |    2 +-
 tests/generic/298 |    2 +-
 tests/generic/301 |    2 +-
 tests/generic/302 |    2 +-
 tests/xfs/127     |    2 +-
 tests/xfs/128     |    2 +-
 tests/xfs/129     |    2 +-
 tests/xfs/132     |    2 +-
 tests/xfs/139     |    2 +-
 tests/xfs/140     |    2 +-
 tests/xfs/169     |    2 +-
 tests/xfs/180     |    2 +-
 tests/xfs/182     |    2 +-
 tests/xfs/184     |    2 +-
 tests/xfs/192     |    2 +-
 tests/xfs/193     |    2 +-
 tests/xfs/198     |    2 +-
 tests/xfs/200     |    2 +-
 tests/xfs/204     |    2 +-
 tests/xfs/208     |    2 +-
 tests/xfs/211     |    2 +-
 tests/xfs/215     |    2 +-
 tests/xfs/218     |    2 +-
 tests/xfs/219     |    2 +-
 tests/xfs/221     |    2 +-
 tests/xfs/223     |    2 +-
 tests/xfs/224     |    2 +-
 tests/xfs/225     |    2 +-
 tests/xfs/226     |    2 +-
 tests/xfs/228     |    2 +-
 tests/xfs/230     |    2 +-
 tests/xfs/231     |    2 +-
 tests/xfs/232     |    2 +-
 tests/xfs/233     |    2 +-
 tests/xfs/234     |    2 +-
 tests/xfs/236     |    2 +-
 tests/xfs/265     |    2 +-
 tests/xfs/309     |    2 +-
 tests/xfs/310     |    4 ++--
 tests/xfs/328     |    2 +-
 69 files changed, 70 insertions(+), 70 deletions(-)


diff --git a/tests/generic/150 b/tests/generic/150
index 2e21d37..fadbb42 100755
--- a/tests/generic/150
+++ b/tests/generic/150
@@ -55,7 +55,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/151 b/tests/generic/151
index 55e0e02..b0f0521 100755
--- a/tests/generic/151
+++ b/tests/generic/151
@@ -59,7 +59,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/152 b/tests/generic/152
index 9fe4d32..aa10bcf 100755
--- a/tests/generic/152
+++ b/tests/generic/152
@@ -60,7 +60,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/153 b/tests/generic/153
index 5d22153..2ddb48d 100755
--- a/tests/generic/153
+++ b/tests/generic/153
@@ -60,7 +60,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/154 b/tests/generic/154
index 23b626b..f270ccb 100755
--- a/tests/generic/154
+++ b/tests/generic/154
@@ -59,7 +59,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 blks=2000
 margin='15%'
 free_blocks0=$(stat -f $testdir -c '%f')
diff --git a/tests/generic/155 b/tests/generic/155
index 50083e7..23057c0 100755
--- a/tests/generic/155
+++ b/tests/generic/155
@@ -64,7 +64,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/156 b/tests/generic/156
index 7bfe7d8..4a0da3a 100755
--- a/tests/generic/156
+++ b/tests/generic/156
@@ -71,7 +71,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/157 b/tests/generic/157
index fe294c8..9284c55 100755
--- a/tests/generic/157
+++ b/tests/generic/157
@@ -60,7 +60,7 @@ testdir2=$SCRATCH_MNT/test-$seq
 mkdir $testdir2
 
 echo "Create the original files"
-blksz="$(stat -f $testdir1 -c '%S')"
+blksz="$(get_block_size $testdir1)"
 blks=1000
 margin='7%'
 sz=$((blksz * blks))
diff --git a/tests/generic/158 b/tests/generic/158
index dd64562..086c522 100755
--- a/tests/generic/158
+++ b/tests/generic/158
@@ -60,7 +60,7 @@ testdir2=$SCRATCH_MNT/test-$seq
 mkdir $testdir2
 
 echo "Create the original files"
-blksz="$(stat -f $testdir1 -c '%S')"
+blksz="$(get_block_size $testdir1)"
 blks=1000
 margin='7%'
 sz=$((blksz * blks))
diff --git a/tests/generic/159 b/tests/generic/159
index 5e1a899..6f75b73 100755
--- a/tests/generic/159
+++ b/tests/generic/159
@@ -54,7 +54,7 @@ rm -rf $testdir1
 mkdir $testdir1
 
 echo "Create the original files"
-blksz="$(stat -f $testdir1 -c '%S')"
+blksz="$(get_block_size $testdir1)"
 blks=1000
 margin='7%'
 sz=$((blksz * blks))
diff --git a/tests/generic/160 b/tests/generic/160
index 1dc5b72..066bf5e 100755
--- a/tests/generic/160
+++ b/tests/generic/160
@@ -54,7 +54,7 @@ rm -rf $testdir1
 mkdir $testdir1
 
 echo "Create the original files"
-blksz="$(stat -f $testdir1 -c '%S')"
+blksz="$(get_block_size $testdir1)"
 blks=1000
 margin='7%'
 sz=$((blksz * blks))
diff --git a/tests/generic/171 b/tests/generic/171
index f391685..a69f798 100755
--- a/tests/generic/171
+++ b/tests/generic/171
@@ -57,7 +57,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Reformat with appropriate size"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 nr_blks=10240
 umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 8 * blksz))
diff --git a/tests/generic/173 b/tests/generic/173
index c5fac9e..e35597f 100755
--- a/tests/generic/173
+++ b/tests/generic/173
@@ -57,7 +57,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Reformat with appropriate size"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 nr_blks=10240
 umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 8 * blksz))
diff --git a/tests/generic/174 b/tests/generic/174
index 8077d76..e58d64b 100755
--- a/tests/generic/174
+++ b/tests/generic/174
@@ -58,7 +58,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Reformat with appropriate size"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 nr_blks=10240
 umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 8 * blksz))
diff --git a/tests/generic/175 b/tests/generic/175
index 964580c..f4f19f8 100755
--- a/tests/generic/175
+++ b/tests/generic/175
@@ -56,7 +56,7 @@ testdir="$SCRATCH_MNT/test-$seq"
 mkdir "$testdir"
 
 echo "Create a one block file"
-blksz="$(stat -f "$testdir" -c '%S')"
+blksz="$(get_block_size $testdir)"
 _pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
 
 fnr=19
diff --git a/tests/generic/176 b/tests/generic/176
index f7d6495..b14255b 100755
--- a/tests/generic/176
+++ b/tests/generic/176
@@ -60,7 +60,7 @@ mkdir "$testdir"
 # 2^17 blocks... that should be plenty for anyone.
 fnr=20
 free_blocks=$(stat -f -c '%a' "$testdir")
-blksz=$(stat -f -c '%S' "$testdir")
+blksz=$(get_block_size "$testdir")
 space_avail=$((free_blocks * blksz))
 calc_space() {
 	blocks_needed=$(( 2 ** (fnr + 1) ))
diff --git a/tests/generic/205 b/tests/generic/205
index 65c3563..cfda8c3 100755
--- a/tests/generic/205
+++ b/tests/generic/205
@@ -60,7 +60,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/206 b/tests/generic/206
index 0d8006f..909956f 100755
--- a/tests/generic/206
+++ b/tests/generic/206
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/216 b/tests/generic/216
index 29fa6a0..d9b868a 100755
--- a/tests/generic/216
+++ b/tests/generic/216
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/217 b/tests/generic/217
index 3843a8b..65113d9 100755
--- a/tests/generic/217
+++ b/tests/generic/217
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/218 b/tests/generic/218
index 6e7f465..21029ef 100755
--- a/tests/generic/218
+++ b/tests/generic/218
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/220 b/tests/generic/220
index d3ee888..c54bf06 100755
--- a/tests/generic/220
+++ b/tests/generic/220
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/222 b/tests/generic/222
index 7de8ad6..d7ee57e 100755
--- a/tests/generic/222
+++ b/tests/generic/222
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/227 b/tests/generic/227
index daac550..fa6a33e 100755
--- a/tests/generic/227
+++ b/tests/generic/227
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/229 b/tests/generic/229
index a307408..3e2c6f4 100755
--- a/tests/generic/229
+++ b/tests/generic/229
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 runtest() {
diff --git a/tests/generic/238 b/tests/generic/238
index 38e3aac..a2f44e8 100755
--- a/tests/generic/238
+++ b/tests/generic/238
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 runtest() {
diff --git a/tests/generic/242 b/tests/generic/242
index 93fdc1d..2b07067 100755
--- a/tests/generic/242
+++ b/tests/generic/242
@@ -65,7 +65,7 @@ bufnr=1280
 bufsize=$((blksz * bufnr))
 
 free_blocks=$(stat -f -c '%a' $testdir)
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 space_needed=$(((filesize * 3) * 5 / 4))
 space_avail=$((free_blocks * real_blksz))
 test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
diff --git a/tests/generic/243 b/tests/generic/243
index ae9caa2..1ba3e8a 100755
--- a/tests/generic/243
+++ b/tests/generic/243
@@ -66,7 +66,7 @@ bufnr=1280
 bufsize=$((blksz * bufnr))
 
 free_blocks=$(stat -f -c '%a' $testdir)
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 space_needed=$(((filesize * 3) * 5 / 4))
 space_avail=$((free_blocks * real_blksz))
 test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
diff --git a/tests/generic/296 b/tests/generic/296
index 4297088..9199006 100755
--- a/tests/generic/296
+++ b/tests/generic/296
@@ -61,7 +61,7 @@ filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
 
-real_blksz=$(stat -f -c '%S' "$testdir")
+real_blksz=$(get_block_size "$testdir")
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 
 echo "Create the original files"
diff --git a/tests/generic/297 b/tests/generic/297
index 4ae2b9c..8dfc342 100755
--- a/tests/generic/297
+++ b/tests/generic/297
@@ -59,7 +59,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create a one block file"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 _pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
 
 fnr=26		# 2^26 reflink extents should be enough to find a slow op?
diff --git a/tests/generic/298 b/tests/generic/298
index e85db12..3f6446c 100755
--- a/tests/generic/298
+++ b/tests/generic/298
@@ -59,7 +59,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create a one block file"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 _pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
 
 fnr=26		# 2^26 reflink extents should be enough to find a slow op?
diff --git a/tests/generic/301 b/tests/generic/301
index a513333..a196cd4 100755
--- a/tests/generic/301
+++ b/tests/generic/301
@@ -65,7 +65,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/generic/302 b/tests/generic/302
index 1600b5a..b2298cb 100755
--- a/tests/generic/302
+++ b/tests/generic/302
@@ -66,7 +66,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/127 b/tests/xfs/127
index 6b768c9..8212ec3 100755
--- a/tests/xfs/127
+++ b/tests/xfs/127
@@ -55,7 +55,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original file and reflink to copy1, copy2"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 _pwrite_byte 0x61 0 $((blksz * 14 + 71)) $testdir/original >> $seqres.full
 _cp_reflink $testdir/original $testdir/copy1
 _cp_reflink $testdir/copy1 $testdir/copy2
diff --git a/tests/xfs/128 b/tests/xfs/128
index 04633a1..6bb6282 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -60,7 +60,7 @@ echo "Create the original file and reflink to file2, file3"
 blks=2000
 margin=160
 blksz=65536
-real_blksz="$(stat -f $testdir -c '%S')"
+real_blksz="$(get_block_size $testdir)"
 blksz_factor=$((blksz / real_blksz))
 _pwrite_byte 0x61 0 $((blks * blksz)) $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2
diff --git a/tests/xfs/129 b/tests/xfs/129
index 17ff238..10880e5 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -59,7 +59,7 @@ mkdir $testdir
 metadump_file=$TEST_DIR/${seq}_metadump
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 nr_blks=$((4 * blksz / 12))
 _pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/file1 >> $seqres.full
 
diff --git a/tests/xfs/132 b/tests/xfs/132
index 5abcf30..6b8c05c 100755
--- a/tests/xfs/132
+++ b/tests/xfs/132
@@ -72,7 +72,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 blks=2000
 margin=100
 sz=$((blksz * blks))
diff --git a/tests/xfs/139 b/tests/xfs/139
index 16193e5..b62ef1b 100755
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -54,7 +54,7 @@ _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 
 echo "Create the original files"
 sz=$((48 * 1048576))
diff --git a/tests/xfs/140 b/tests/xfs/140
index 052c539..a87357b 100755
--- a/tests/xfs/140
+++ b/tests/xfs/140
@@ -54,7 +54,7 @@ _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
-blksz=$(stat -f -c '%S' $testdir)
+blksz=$(get_block_size $testdir)
 
 echo "Create the original files"
 sz=$((48 * 1048576))
diff --git a/tests/xfs/169 b/tests/xfs/169
index 996500e..acd4b89 100755
--- a/tests/xfs/169
+++ b/tests/xfs/169
@@ -57,7 +57,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 nr_blks=$((8 * blksz / 12))
 
 for i in 1 2 x; do
diff --git a/tests/xfs/180 b/tests/xfs/180
index 00e91a4..e2d3369 100755
--- a/tests/xfs/180
+++ b/tests/xfs/180
@@ -68,7 +68,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/182 b/tests/xfs/182
index b7aa5e7..2545f00 100755
--- a/tests/xfs/182
+++ b/tests/xfs/182
@@ -69,7 +69,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/184 b/tests/xfs/184
index 01c04c3..d2e1363 100755
--- a/tests/xfs/184
+++ b/tests/xfs/184
@@ -68,7 +68,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/192 b/tests/xfs/192
index 244a2ec..a003c45 100755
--- a/tests/xfs/192
+++ b/tests/xfs/192
@@ -69,7 +69,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/193 b/tests/xfs/193
index f59b3bd..2cd8880 100755
--- a/tests/xfs/193
+++ b/tests/xfs/193
@@ -67,7 +67,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/198 b/tests/xfs/198
index c12d915..f55ed23 100755
--- a/tests/xfs/198
+++ b/tests/xfs/198
@@ -68,7 +68,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/200 b/tests/xfs/200
index 92823b5..f7e2d04 100755
--- a/tests/xfs/200
+++ b/tests/xfs/200
@@ -70,7 +70,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/204 b/tests/xfs/204
index cc1683b..7775c6a 100755
--- a/tests/xfs/204
+++ b/tests/xfs/204
@@ -71,7 +71,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/208 b/tests/xfs/208
index 4f56884..e64106a 100755
--- a/tests/xfs/208
+++ b/tests/xfs/208
@@ -71,7 +71,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/211 b/tests/xfs/211
index 9f01d08..68abaf7 100755
--- a/tests/xfs/211
+++ b/tests/xfs/211
@@ -69,7 +69,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 2 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/215 b/tests/xfs/215
index b9c9ab4..c4bb322 100755
--- a/tests/xfs/215
+++ b/tests/xfs/215
@@ -66,7 +66,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/218 b/tests/xfs/218
index 887a135..7fcca82 100755
--- a/tests/xfs/218
+++ b/tests/xfs/218
@@ -65,7 +65,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/219 b/tests/xfs/219
index 5ae0714..f02cc2d 100755
--- a/tests/xfs/219
+++ b/tests/xfs/219
@@ -66,7 +66,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/221 b/tests/xfs/221
index 3afc75f..1dfcd96 100755
--- a/tests/xfs/221
+++ b/tests/xfs/221
@@ -65,7 +65,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/223 b/tests/xfs/223
index 3f34bcf..d93b311 100755
--- a/tests/xfs/223
+++ b/tests/xfs/223
@@ -67,7 +67,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/224 b/tests/xfs/224
index 91033fa..7a59dba 100755
--- a/tests/xfs/224
+++ b/tests/xfs/224
@@ -66,7 +66,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/225 b/tests/xfs/225
index 2260441..596cdb8 100755
--- a/tests/xfs/225
+++ b/tests/xfs/225
@@ -66,7 +66,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/226 b/tests/xfs/226
index ac70239..d3a0dc0 100755
--- a/tests/xfs/226
+++ b/tests/xfs/226
@@ -65,7 +65,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/228 b/tests/xfs/228
index 65d7f51..994f501 100755
--- a/tests/xfs/228
+++ b/tests/xfs/228
@@ -72,7 +72,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/230 b/tests/xfs/230
index 73c6267..f4b9f15 100755
--- a/tests/xfs/230
+++ b/tests/xfs/230
@@ -72,7 +72,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/231 b/tests/xfs/231
index d89139a..54fc46d 100755
--- a/tests/xfs/231
+++ b/tests/xfs/231
@@ -72,7 +72,7 @@ bufnr=2
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/232 b/tests/xfs/232
index 2438f1f..0ffa198 100755
--- a/tests/xfs/232
+++ b/tests/xfs/232
@@ -73,7 +73,7 @@ bufnr=2
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(stat -f -c '%S' $testdir)
+real_blksz=$(get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/233 b/tests/xfs/233
index 8fcf766..a0c1612 100755
--- a/tests/xfs/233
+++ b/tests/xfs/233
@@ -53,7 +53,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 _pwrite_byte 0x61 0 $((blksz * 14 + 71)) $testdir/original >> $seqres.full
 cp -p $testdir/original $testdir/copy1
 cp -p $testdir/copy1 $testdir/copy2
diff --git a/tests/xfs/234 b/tests/xfs/234
index 8dadc34..9a60ec6 100755
--- a/tests/xfs/234
+++ b/tests/xfs/234
@@ -59,7 +59,7 @@ mkdir $testdir
 metadump_file=$TEST_DIR/${seq}_metadump
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 nr_blks=$((4 * blksz / 12))
 _pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/file1 >> $seqres.full
 sync
diff --git a/tests/xfs/236 b/tests/xfs/236
index c7b3a19..e5840cb 100755
--- a/tests/xfs/236
+++ b/tests/xfs/236
@@ -57,7 +57,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 nr_blks=$((8 * blksz / 12))
 
 for i in 1 2 x; do
diff --git a/tests/xfs/265 b/tests/xfs/265
index 2039d9c..c8fb527 100755
--- a/tests/xfs/265
+++ b/tests/xfs/265
@@ -59,7 +59,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 nr_blks=$((2 * blksz / 12))
 
 for i in 1 2 x; do
diff --git a/tests/xfs/309 b/tests/xfs/309
index 3578690..38c0452 100755
--- a/tests/xfs/309
+++ b/tests/xfs/309
@@ -59,7 +59,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 nr_blks=$((2 * blksz / 12))
 
 for i in 1 2 x; do
diff --git a/tests/xfs/310 b/tests/xfs/310
index 5125773..cce21be 100755
--- a/tests/xfs/310
+++ b/tests/xfs/310
@@ -58,7 +58,7 @@ _scratch_mkfs >/dev/null 2>&1
 _scratch_mount >> $seqres.full
 
 testdir=$SCRATCH_MNT/test-$seq
-blksz="$(stat -f $SCRATCH_MNT -c '%S')"
+blksz="$(get_block_size $SCRATCH_MNT)"
 
 umount $SCRATCH_MNT
 
@@ -72,7 +72,7 @@ xfs_info $SCRATCH_MNT >> $seqres.full
 
 echo "Create the original file blocks"
 mkdir $testdir
-blksz="$(stat -f $testdir -c '%S')"
+blksz="$(get_block_size $testdir)"
 $XFS_IO_PROG -f -c "falloc 0 $((nr_blks * blksz))" $testdir/file1 >> $seqres.full
 
 echo "Check extent count"
diff --git a/tests/xfs/328 b/tests/xfs/328
index 342fad5..33a0bef 100755
--- a/tests/xfs/328
+++ b/tests/xfs/328
@@ -62,7 +62,7 @@ mkdir "$testdir"
 # 2^10 blocks... that should be plenty for anyone.
 fnr=$((12 + LOAD_FACTOR))
 free_blocks=$(stat -f -c '%a' "$testdir")
-blksz=$(stat -f -c '%S' "$testdir")
+blksz=$(get_block_size $testdir)
 space_avail=$((free_blocks * blksz))
 calc_space()
 {

