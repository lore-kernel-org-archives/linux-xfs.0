Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33045 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbdAEBE4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 20:04:56 -0500
Subject: [PATCH 2/7] common: add leading underscore to get_block_size
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 04 Jan 2017 17:04:48 -0800
Message-ID: <148357828858.7677.1046746692994559684.stgit@birch.djwong.org>
In-Reply-To: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
References: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Add a leading underscore to the get_block_size helper since it's a
common function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/attr       |    4 ++--
 common/defrag     |    2 +-
 common/filter     |    4 ++--
 common/punch      |    2 +-
 common/rc         |    4 ++--
 tests/btrfs/017   |    2 +-
 tests/btrfs/052   |    2 +-
 tests/btrfs/055   |    2 +-
 tests/btrfs/056   |    2 +-
 tests/btrfs/094   |    2 +-
 tests/btrfs/095   |    2 +-
 tests/btrfs/096   |    2 +-
 tests/btrfs/097   |    2 +-
 tests/btrfs/098   |    2 +-
 tests/btrfs/103   |    2 +-
 tests/generic/017 |    2 +-
 tests/generic/064 |    2 +-
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
 tests/generic/172 |    2 +-
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
 tests/generic/240 |    2 +-
 tests/generic/242 |    2 +-
 tests/generic/243 |    2 +-
 tests/generic/256 |    2 +-
 tests/generic/273 |    2 +-
 tests/generic/296 |    2 +-
 tests/generic/297 |    2 +-
 tests/generic/298 |    2 +-
 tests/generic/301 |    2 +-
 tests/generic/302 |    2 +-
 tests/generic/308 |    2 +-
 tests/generic/391 |    2 +-
 tests/shared/298  |    2 +-
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
 tests/xfs/331     |    2 +-
 tests/xfs/335     |    2 +-
 tests/xfs/336     |    2 +-
 tests/xfs/337     |    2 +-
 tests/xfs/341     |    2 +-
 tests/xfs/342     |    2 +-
 tests/xfs/344     |    2 +-
 tests/xfs/345     |    2 +-
 tests/xfs/346     |    2 +-
 tests/xfs/347     |    2 +-
 103 files changed, 107 insertions(+), 107 deletions(-)


diff --git a/common/attr b/common/attr
index ce2d76a..08643e6 100644
--- a/common/attr
+++ b/common/attr
@@ -257,7 +257,7 @@ _sort_getfattr_output()
 if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" ]; then
 	MAX_ATTRS=1000
 else # Assume max ~1 block of attrs
-	BLOCK_SIZE=`get_block_size $TEST_DIR`
+	BLOCK_SIZE=`_get_block_size $TEST_DIR`
 	# user.attribute_XXX="value.XXX" is about 32 bytes; leave some overhead
 	let MAX_ATTRS=$BLOCK_SIZE/40
 fi
@@ -268,7 +268,7 @@ export MAX_ATTRS
 if [ "$FSTYP" == "xfs" -o "$FSTYP" == "udf" -o "$FSTYP" == "btrfs" ]; then
 	MAX_ATTRVAL_SIZE=64
 else # Assume max ~1 block of attrs
-	BLOCK_SIZE=`get_block_size $TEST_DIR`
+	BLOCK_SIZE=`_get_block_size $TEST_DIR`
 	# leave a little overhead
 	let MAX_ATTRVAL_SIZE=$BLOCK_SIZE-256
 fi
diff --git a/common/defrag b/common/defrag
index 986b4bf..d279382 100644
--- a/common/defrag
+++ b/common/defrag
@@ -29,7 +29,7 @@ _require_defrag()
     ext4|ext4dev)
 	testfile="$TEST_DIR/$$-test.defrag"
 	donorfile="$TEST_DIR/$$-donor.defrag"
-	bsize=`get_block_size $TEST_DIR`
+	bsize=`_get_block_size $TEST_DIR`
 	$XFS_IO_PROG -f -c "pwrite -b $bsize 0 $bsize" $testfile > /dev/null
 	cp $testfile $donorfile
 	echo $testfile | $here/src/e4compact -v -f $donorfile | \
diff --git a/common/filter b/common/filter
index 397b456..3666a68 100644
--- a/common/filter
+++ b/common/filter
@@ -265,7 +265,7 @@ _filter_xfs_io_units_modified()
 
 _filter_xfs_io_blocks_modified()
 {
-	BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+	BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 
 	_filter_xfs_io_units_modified "Block" $BLOCK_SIZE
 }
@@ -383,7 +383,7 @@ _filter_ro_mount() {
 
 _filter_od()
 {
-	BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+	BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 	$AWK_PROG -v block_size=$BLOCK_SIZE '
 		/^[0-9]+/ {
 			offset = strtonum("0"$1);
diff --git a/common/punch b/common/punch
index 44c6e1c..c4ed261 100644
--- a/common/punch
+++ b/common/punch
@@ -584,7 +584,7 @@ _test_generic_punch()
 	if [ "$remove_testfile" ]; then
 		rm -f $testfile
 	fi
-	block_size=`get_block_size $TEST_DIR`
+	block_size=`_get_block_size $TEST_DIR`
 	$XFS_IO_PROG -f -c "truncate $block_size" \
 		-c "pwrite 0 $block_size" $sync_cmd \
 		-c "$zero_cmd 128 128" \
diff --git a/common/rc b/common/rc
index c3ab658..7b62a18 100644
--- a/common/rc
+++ b/common/rc
@@ -3077,10 +3077,10 @@ _sysfs_dev()
 	echo /sys/dev/block/$_maj:$_min
 }
 
-get_block_size()
+_get_block_size()
 {
 	if [ -z $1 ] || [ ! -d $1 ]; then
-		echo "Missing mount point argument for get_block_size"
+		echo "Missing mount point argument for _get_block_size"
 		exit 1
 	fi
 	echo `stat -f -c %S $1`
diff --git a/tests/btrfs/017 b/tests/btrfs/017
index 3f409d3..1041957 100755
--- a/tests/btrfs/017
+++ b/tests/btrfs/017
@@ -62,7 +62,7 @@ rm -f $seqres.full
 _scratch_mkfs "--nodesize 65536" >>$seqres.full 2>&1
 _scratch_mount
 
-BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 EXTENT_SIZE=$((2 * $BLOCK_SIZE))
 
 $XFS_IO_PROG -f -d -c "pwrite 0 $EXTENT_SIZE" $SCRATCH_MNT/foo \
diff --git a/tests/btrfs/052 b/tests/btrfs/052
index 599d261..c76d245 100755
--- a/tests/btrfs/052
+++ b/tests/btrfs/052
@@ -58,7 +58,7 @@ test_btrfs_clone_same_file()
 	_scratch_mkfs >/dev/null 2>&1
 	_scratch_mount $MOUNT_OPTIONS
 
-	BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+	BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 
 	EXTENT_SIZE=$((2 * $BLOCK_SIZE))
 
diff --git a/tests/btrfs/055 b/tests/btrfs/055
index 29afdba..481d5c8 100755
--- a/tests/btrfs/055
+++ b/tests/btrfs/055
@@ -59,7 +59,7 @@ test_btrfs_clone_with_holes()
 	_scratch_mkfs "$1" >/dev/null 2>&1
 	_scratch_mount
 
-	BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+	BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 
 	EXTENT_SIZE=$((2 * $BLOCK_SIZE))
 
diff --git a/tests/btrfs/056 b/tests/btrfs/056
index ef515a1..d9b6fd7 100755
--- a/tests/btrfs/056
+++ b/tests/btrfs/056
@@ -67,7 +67,7 @@ test_btrfs_clone_fsync_log_recover()
 	MOUNT_OPTIONS="$MOUNT_OPTIONS $2"
 	_mount_flakey
 
-	BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+	BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 
 	EXTENT_SIZE=$((2 * $BLOCK_SIZE))
 
diff --git a/tests/btrfs/094 b/tests/btrfs/094
index 52b7ed2..452c008 100755
--- a/tests/btrfs/094
+++ b/tests/btrfs/094
@@ -66,7 +66,7 @@ mkdir $send_files_dir
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount "-o compress"
 
-BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 
 # Create the file with a single extent of 32 blocks. This creates a metadata
 # file extent item with a data start offset of 0 and a logical length of
diff --git a/tests/btrfs/095 b/tests/btrfs/095
index b477b57..f256e88 100755
--- a/tests/btrfs/095
+++ b/tests/btrfs/095
@@ -62,7 +62,7 @@ _scratch_mkfs >>$seqres.full 2>&1
 _init_flakey
 _mount_flakey
 
-BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 
 # Create prealloc extent covering file block range [40, 155[
 $XFS_IO_PROG -f -c "falloc $((40 * $BLOCK_SIZE)) $((115 * $BLOCK_SIZE))" \
diff --git a/tests/btrfs/096 b/tests/btrfs/096
index 039e09d..fd13cf7 100755
--- a/tests/btrfs/096
+++ b/tests/btrfs/096
@@ -50,7 +50,7 @@ rm -f $seqres.full
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount
 
-BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 
 # Create our test files. File foo has the same 2k of data at offset $BLOCK_SIZE
 # as file bar has at its offset 0.
diff --git a/tests/btrfs/097 b/tests/btrfs/097
index 4b4dd18..d83cc46 100755
--- a/tests/btrfs/097
+++ b/tests/btrfs/097
@@ -56,7 +56,7 @@ mkdir $send_files_dir
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount
 
-BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 
 # Create our test file with a single extent of 16 blocks starting at a file
 # offset mapped by 32nd block.
diff --git a/tests/btrfs/098 b/tests/btrfs/098
index f916c37..ba95fd3 100755
--- a/tests/btrfs/098
+++ b/tests/btrfs/098
@@ -57,7 +57,7 @@ _scratch_mkfs >>$seqres.full 2>&1
 _init_flakey
 _mount_flakey
 
-BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 
 # Create our test file with a single 25 block extent starting at file offset
 # mapped by 200th block We fsync the file here to make the fsync log tree get a
diff --git a/tests/btrfs/103 b/tests/btrfs/103
index caa979a..b672d62 100755
--- a/tests/btrfs/103
+++ b/tests/btrfs/103
@@ -55,7 +55,7 @@ test_clone_and_read_compressed_extent()
 	_scratch_mkfs >>$seqres.full 2>&1
 	_scratch_mount $mount_opts
 
-	BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+	BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 
 	# Create a test file with a single extent that is compressed (the
 	# data we write into it is highly compressible no matter which
diff --git a/tests/generic/017 b/tests/generic/017
index 5fe4628..419e762 100755
--- a/tests/generic/017
+++ b/tests/generic/017
@@ -53,7 +53,7 @@ _scratch_mount
 testfile=$SCRATCH_MNT/$seq.$$
 BLOCKS=10240
 
-BSIZE=`get_block_size $SCRATCH_MNT`
+BSIZE=`_get_block_size $SCRATCH_MNT`
 
 length=$(($BLOCKS * $BSIZE))
 
diff --git a/tests/generic/064 b/tests/generic/064
index d384a9a..8cd31b3 100755
--- a/tests/generic/064
+++ b/tests/generic/064
@@ -49,7 +49,7 @@ _require_xfs_io_command "fcollapse"
 src=$SCRATCH_MNT/testfile
 dest=$SCRATCH_MNT/testfile.dest
 BLOCKS=100
-BSIZE=`get_block_size $SCRATCH_MNT`
+BSIZE=`_get_block_size $SCRATCH_MNT`
 rm -f $seqres.full
 
 _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
diff --git a/tests/generic/150 b/tests/generic/150
index fadbb42..b57db51 100755
--- a/tests/generic/150
+++ b/tests/generic/150
@@ -55,7 +55,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/151 b/tests/generic/151
index b0f0521..efb93ed 100755
--- a/tests/generic/151
+++ b/tests/generic/151
@@ -59,7 +59,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/152 b/tests/generic/152
index aa10bcf..ee009ea 100755
--- a/tests/generic/152
+++ b/tests/generic/152
@@ -60,7 +60,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/153 b/tests/generic/153
index 2ddb48d..fb5d552 100755
--- a/tests/generic/153
+++ b/tests/generic/153
@@ -60,7 +60,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/154 b/tests/generic/154
index f270ccb..9daee70 100755
--- a/tests/generic/154
+++ b/tests/generic/154
@@ -59,7 +59,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 blks=2000
 margin='15%'
 free_blocks0=$(stat -f $testdir -c '%f')
diff --git a/tests/generic/155 b/tests/generic/155
index 23057c0..9eead24 100755
--- a/tests/generic/155
+++ b/tests/generic/155
@@ -64,7 +64,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/156 b/tests/generic/156
index e062b56..a81b91a 100755
--- a/tests/generic/156
+++ b/tests/generic/156
@@ -67,7 +67,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 blks=2000
 margin='15%'
 sz=$((blksz * blks))
diff --git a/tests/generic/157 b/tests/generic/157
index 9284c55..722dc22 100755
--- a/tests/generic/157
+++ b/tests/generic/157
@@ -60,7 +60,7 @@ testdir2=$SCRATCH_MNT/test-$seq
 mkdir $testdir2
 
 echo "Create the original files"
-blksz="$(get_block_size $testdir1)"
+blksz="$(_get_block_size $testdir1)"
 blks=1000
 margin='7%'
 sz=$((blksz * blks))
diff --git a/tests/generic/158 b/tests/generic/158
index 086c522..1e16f5d 100755
--- a/tests/generic/158
+++ b/tests/generic/158
@@ -60,7 +60,7 @@ testdir2=$SCRATCH_MNT/test-$seq
 mkdir $testdir2
 
 echo "Create the original files"
-blksz="$(get_block_size $testdir1)"
+blksz="$(_get_block_size $testdir1)"
 blks=1000
 margin='7%'
 sz=$((blksz * blks))
diff --git a/tests/generic/159 b/tests/generic/159
index 6f75b73..7e52d5c 100755
--- a/tests/generic/159
+++ b/tests/generic/159
@@ -54,7 +54,7 @@ rm -rf $testdir1
 mkdir $testdir1
 
 echo "Create the original files"
-blksz="$(get_block_size $testdir1)"
+blksz="$(_get_block_size $testdir1)"
 blks=1000
 margin='7%'
 sz=$((blksz * blks))
diff --git a/tests/generic/160 b/tests/generic/160
index 066bf5e..409b15e 100755
--- a/tests/generic/160
+++ b/tests/generic/160
@@ -54,7 +54,7 @@ rm -rf $testdir1
 mkdir $testdir1
 
 echo "Create the original files"
-blksz="$(get_block_size $testdir1)"
+blksz="$(_get_block_size $testdir1)"
 blks=1000
 margin='7%'
 sz=$((blksz * blks))
diff --git a/tests/generic/171 b/tests/generic/171
index 916d663..0942ac3 100755
--- a/tests/generic/171
+++ b/tests/generic/171
@@ -58,7 +58,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Reformat with appropriate size"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 nr_blks=10240
 umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 8 * blksz))
diff --git a/tests/generic/172 b/tests/generic/172
index 2727836..d8ab882 100755
--- a/tests/generic/172
+++ b/tests/generic/172
@@ -58,7 +58,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Reformat with appropriate size"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 umount $SCRATCH_MNT
 
 file_size=$((168 * 1024 * 1024))
diff --git a/tests/generic/173 b/tests/generic/173
index a414c8e..ad4e5da 100755
--- a/tests/generic/173
+++ b/tests/generic/173
@@ -58,7 +58,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Reformat with appropriate size"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 nr_blks=10240
 umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 8 * blksz))
diff --git a/tests/generic/174 b/tests/generic/174
index 1eeff69..d230577 100755
--- a/tests/generic/174
+++ b/tests/generic/174
@@ -59,7 +59,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Reformat with appropriate size"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 nr_blks=10240
 umount $SCRATCH_MNT
 sz_bytes=$((nr_blks * 8 * blksz))
diff --git a/tests/generic/175 b/tests/generic/175
index f4f19f8..df25f0a 100755
--- a/tests/generic/175
+++ b/tests/generic/175
@@ -56,7 +56,7 @@ testdir="$SCRATCH_MNT/test-$seq"
 mkdir "$testdir"
 
 echo "Create a one block file"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 _pwrite_byte 0x61 0 $blksz "$testdir/file1" >> "$seqres.full"
 
 fnr=19
diff --git a/tests/generic/176 b/tests/generic/176
index 76e923a..3e61b68 100755
--- a/tests/generic/176
+++ b/tests/generic/176
@@ -60,7 +60,7 @@ mkdir "$testdir"
 # 2^17 blocks... that should be plenty for anyone.
 fnr=20
 free_blocks=$(stat -f -c '%a' "$testdir")
-blksz=$(get_block_size "$testdir")
+blksz=$(_get_block_size "$testdir")
 space_avail=$((free_blocks * blksz))
 calc_space() {
 	blocks_needed=$(( 2 ** (fnr + 1) ))
diff --git a/tests/generic/205 b/tests/generic/205
index cfda8c3..65e345a 100755
--- a/tests/generic/205
+++ b/tests/generic/205
@@ -60,7 +60,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/206 b/tests/generic/206
index 909956f..1816502 100755
--- a/tests/generic/206
+++ b/tests/generic/206
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/216 b/tests/generic/216
index d9b868a..d85c1e6 100755
--- a/tests/generic/216
+++ b/tests/generic/216
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/217 b/tests/generic/217
index 65113d9..19d6f00 100755
--- a/tests/generic/217
+++ b/tests/generic/217
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/218 b/tests/generic/218
index 21029ef..f69c02a 100755
--- a/tests/generic/218
+++ b/tests/generic/218
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/220 b/tests/generic/220
index c54bf06..0678b5f 100755
--- a/tests/generic/220
+++ b/tests/generic/220
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/222 b/tests/generic/222
index d7ee57e..24c54bb 100755
--- a/tests/generic/222
+++ b/tests/generic/222
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/227 b/tests/generic/227
index fa6a33e..eb79bac 100755
--- a/tests/generic/227
+++ b/tests/generic/227
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 echo "Create the original files"
diff --git a/tests/generic/229 b/tests/generic/229
index 3e2c6f4..332e69c 100755
--- a/tests/generic/229
+++ b/tests/generic/229
@@ -61,7 +61,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 runtest() {
diff --git a/tests/generic/238 b/tests/generic/238
index a2f44e8..df13c63 100755
--- a/tests/generic/238
+++ b/tests/generic/238
@@ -62,7 +62,7 @@ _scratch_mount >> $seqres.full 2>&1
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 test $real_blksz != $blksz && _notrun "Failed to format with small blocksize."
 
 runtest() {
diff --git a/tests/generic/240 b/tests/generic/240
index e32f15a..7fbd4b3 100755
--- a/tests/generic/240
+++ b/tests/generic/240
@@ -62,7 +62,7 @@ rm -f $seqres.full
 rm -f $TEST_DIR/aiodio_sparse
 
 logical_block_size=`_min_dio_alignment $TEST_DEV`
-fs_block_size=`get_block_size $TEST_DIR`
+fs_block_size=`_get_block_size $TEST_DIR`
 file_size=$((8 * $fs_block_size))
 
 if [ $fs_block_size -le $logical_block_size ]; then
diff --git a/tests/generic/242 b/tests/generic/242
index 2b07067..1bfeb77 100755
--- a/tests/generic/242
+++ b/tests/generic/242
@@ -65,7 +65,7 @@ bufnr=1280
 bufsize=$((blksz * bufnr))
 
 free_blocks=$(stat -f -c '%a' $testdir)
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 space_needed=$(((filesize * 3) * 5 / 4))
 space_avail=$((free_blocks * real_blksz))
 test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
diff --git a/tests/generic/243 b/tests/generic/243
index 1ba3e8a..59ae6e8 100755
--- a/tests/generic/243
+++ b/tests/generic/243
@@ -66,7 +66,7 @@ bufnr=1280
 bufsize=$((blksz * bufnr))
 
 free_blocks=$(stat -f -c '%a' $testdir)
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 space_needed=$(((filesize * 3) * 5 / 4))
 space_avail=$((free_blocks * real_blksz))
 test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
diff --git a/tests/generic/256 b/tests/generic/256
index 63f2d4f..3b00d56 100755
--- a/tests/generic/256
+++ b/tests/generic/256
@@ -117,7 +117,7 @@ _scratch_mount
 # Test must be able to write files with non-root permissions
 chmod 777 $SCRATCH_MNT
 
-block_size=`get_block_size $SCRATCH_MNT`
+block_size=`_get_block_size $SCRATCH_MNT`
 _test_full_fs_punch $(( $block_size * 2 )) $block_size 500 $SCRATCH_MNT/252.$$ $block_size
 
 status=0 ; exit
diff --git a/tests/generic/273 b/tests/generic/273
index d90212e..578b1da 100755
--- a/tests/generic/273
+++ b/tests/generic/273
@@ -106,7 +106,7 @@ _do_workload()
 {
 	_pids=""
 	_pid=1
-	block_size=$(get_block_size $SCRATCH_MNT)
+	block_size=$(_get_block_size $SCRATCH_MNT)
 	
 	_threads_set
 	_file_create $block_size
diff --git a/tests/generic/296 b/tests/generic/296
index 9199006..31c8e89 100755
--- a/tests/generic/296
+++ b/tests/generic/296
@@ -61,7 +61,7 @@ filesize=$((blksz * nr))
 bufnr=16
 bufsize=$((blksz * bufnr))
 
-real_blksz=$(get_block_size "$testdir")
+real_blksz=$(_get_block_size "$testdir")
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
 
 echo "Create the original files"
diff --git a/tests/generic/297 b/tests/generic/297
index 8dfc342..f7eb37b 100755
--- a/tests/generic/297
+++ b/tests/generic/297
@@ -59,7 +59,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create a one block file"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 _pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
 
 fnr=26		# 2^26 reflink extents should be enough to find a slow op?
diff --git a/tests/generic/298 b/tests/generic/298
index 3f6446c..b518da1 100755
--- a/tests/generic/298
+++ b/tests/generic/298
@@ -59,7 +59,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create a one block file"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 _pwrite_byte 0x61 0 $blksz $testdir/file1 >> $seqres.full
 
 fnr=26		# 2^26 reflink extents should be enough to find a slow op?
diff --git a/tests/generic/301 b/tests/generic/301
index a196cd4..67b1a0c 100755
--- a/tests/generic/301
+++ b/tests/generic/301
@@ -65,7 +65,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/generic/302 b/tests/generic/302
index b2298cb..3834f98 100755
--- a/tests/generic/302
+++ b/tests/generic/302
@@ -66,7 +66,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/generic/308 b/tests/generic/308
index e639da1..afc9bf5 100755
--- a/tests/generic/308
+++ b/tests/generic/308
@@ -49,7 +49,7 @@ _require_test
 rm -f $seqres.full
 echo "Silence is golden"
 
-block_size=`get_block_size $TEST_DIR`
+block_size=`_get_block_size $TEST_DIR`
 
 # On unpatched ext4, if an extent exists which includes the block right
 # before the maximum file offset, and the block for the maximum file offset
diff --git a/tests/generic/391 b/tests/generic/391
index 5db8587..6da1781 100755
--- a/tests/generic/391
+++ b/tests/generic/391
@@ -54,7 +54,7 @@ _require_test
 _require_xfs_io_command "falloc"
 _require_test_program "dio-interleaved"
 
-extent_size="$(($(get_block_size "$TEST_DIR") * 2))"
+extent_size="$(($(_get_block_size "$TEST_DIR") * 2))"
 num_extents=1024
 testfile="$TEST_DIR/$$-testfile"
 
diff --git a/tests/shared/298 b/tests/shared/298
index 2ed7eab..0a11300 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -165,7 +165,7 @@ echo "done."
 
 echo -n "Comparing holes to the reported space from FS..."
 # Get block size
-block_size=$(get_block_size $loop_mnt/)
+block_size=$(_get_block_size $loop_mnt/)
 sectors_per_block=`expr $block_size / 512`
 
 # Obtain free space from filesystem
diff --git a/tests/xfs/127 b/tests/xfs/127
index 8212ec3..9df9990 100755
--- a/tests/xfs/127
+++ b/tests/xfs/127
@@ -55,7 +55,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original file and reflink to copy1, copy2"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 _pwrite_byte 0x61 0 $((blksz * 14 + 71)) $testdir/original >> $seqres.full
 _cp_reflink $testdir/original $testdir/copy1
 _cp_reflink $testdir/copy1 $testdir/copy2
diff --git a/tests/xfs/128 b/tests/xfs/128
index 6bb6282..8e29b8d 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -60,7 +60,7 @@ echo "Create the original file and reflink to file2, file3"
 blks=2000
 margin=160
 blksz=65536
-real_blksz="$(get_block_size $testdir)"
+real_blksz="$(_get_block_size $testdir)"
 blksz_factor=$((blksz / real_blksz))
 _pwrite_byte 0x61 0 $((blks * blksz)) $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2
diff --git a/tests/xfs/129 b/tests/xfs/129
index 10880e5..687d627 100755
--- a/tests/xfs/129
+++ b/tests/xfs/129
@@ -59,7 +59,7 @@ mkdir $testdir
 metadump_file=$TEST_DIR/${seq}_metadump
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 nr_blks=$((4 * blksz / 12))
 _pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/file1 >> $seqres.full
 
diff --git a/tests/xfs/132 b/tests/xfs/132
index ac8dc25..178e268 100755
--- a/tests/xfs/132
+++ b/tests/xfs/132
@@ -72,7 +72,7 @@ rm -rf $testdir
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 blks=2000
 margin=100
 sz=$((blksz * blks))
diff --git a/tests/xfs/139 b/tests/xfs/139
index b62ef1b..4ee7ea2 100755
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -54,7 +54,7 @@ _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 
 echo "Create the original files"
 sz=$((48 * 1048576))
diff --git a/tests/xfs/140 b/tests/xfs/140
index a87357b..74d8f12 100755
--- a/tests/xfs/140
+++ b/tests/xfs/140
@@ -54,7 +54,7 @@ _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
-blksz=$(get_block_size $testdir)
+blksz=$(_get_block_size $testdir)
 
 echo "Create the original files"
 sz=$((48 * 1048576))
diff --git a/tests/xfs/169 b/tests/xfs/169
index acd4b89..96f7c5e 100755
--- a/tests/xfs/169
+++ b/tests/xfs/169
@@ -57,7 +57,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 nr_blks=$((8 * blksz / 12))
 
 for i in 1 2 x; do
diff --git a/tests/xfs/180 b/tests/xfs/180
index e2d3369..ce2ac26 100755
--- a/tests/xfs/180
+++ b/tests/xfs/180
@@ -68,7 +68,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/182 b/tests/xfs/182
index f48a8c7..4413c7d 100755
--- a/tests/xfs/182
+++ b/tests/xfs/182
@@ -69,7 +69,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/184 b/tests/xfs/184
index 0860701..54eb115 100755
--- a/tests/xfs/184
+++ b/tests/xfs/184
@@ -69,7 +69,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/192 b/tests/xfs/192
index e56c860..d8bdb25 100755
--- a/tests/xfs/192
+++ b/tests/xfs/192
@@ -70,7 +70,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/193 b/tests/xfs/193
index 2cd8880..76cb143 100755
--- a/tests/xfs/193
+++ b/tests/xfs/193
@@ -67,7 +67,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/198 b/tests/xfs/198
index f55ed23..d185ca2 100755
--- a/tests/xfs/198
+++ b/tests/xfs/198
@@ -68,7 +68,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/200 b/tests/xfs/200
index d4363a4..e70fda3 100755
--- a/tests/xfs/200
+++ b/tests/xfs/200
@@ -71,7 +71,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/204 b/tests/xfs/204
index 3dbaf95..c0b69cf 100755
--- a/tests/xfs/204
+++ b/tests/xfs/204
@@ -72,7 +72,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/208 b/tests/xfs/208
index e64106a..62192cb 100755
--- a/tests/xfs/208
+++ b/tests/xfs/208
@@ -71,7 +71,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/211 b/tests/xfs/211
index 68abaf7..0d150f1 100755
--- a/tests/xfs/211
+++ b/tests/xfs/211
@@ -69,7 +69,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 2 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/215 b/tests/xfs/215
index c4bb322..c2b9c0e 100755
--- a/tests/xfs/215
+++ b/tests/xfs/215
@@ -66,7 +66,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/218 b/tests/xfs/218
index 7fcca82..31cac44 100755
--- a/tests/xfs/218
+++ b/tests/xfs/218
@@ -65,7 +65,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/219 b/tests/xfs/219
index f02cc2d..2a8d966 100755
--- a/tests/xfs/219
+++ b/tests/xfs/219
@@ -66,7 +66,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/221 b/tests/xfs/221
index 1dfcd96..405d2d5 100755
--- a/tests/xfs/221
+++ b/tests/xfs/221
@@ -65,7 +65,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/223 b/tests/xfs/223
index d93b311..6654872 100755
--- a/tests/xfs/223
+++ b/tests/xfs/223
@@ -67,7 +67,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/224 b/tests/xfs/224
index 7a59dba..376abe1 100755
--- a/tests/xfs/224
+++ b/tests/xfs/224
@@ -66,7 +66,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/225 b/tests/xfs/225
index 596cdb8..5864677 100755
--- a/tests/xfs/225
+++ b/tests/xfs/225
@@ -66,7 +66,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/226 b/tests/xfs/226
index d3a0dc0..44605b1 100755
--- a/tests/xfs/226
+++ b/tests/xfs/226
@@ -65,7 +65,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/228 b/tests/xfs/228
index 994f501..9d8e9a9 100755
--- a/tests/xfs/228
+++ b/tests/xfs/228
@@ -72,7 +72,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/230 b/tests/xfs/230
index f4b9f15..e42013f 100755
--- a/tests/xfs/230
+++ b/tests/xfs/230
@@ -72,7 +72,7 @@ echo "Create the original files"
 blksz=65536
 nr=64
 filesize=$((blksz * nr))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 $XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
 _weave_reflink_rainbow $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
diff --git a/tests/xfs/231 b/tests/xfs/231
index 54fc46d..f0b64c0 100755
--- a/tests/xfs/231
+++ b/tests/xfs/231
@@ -72,7 +72,7 @@ bufnr=2
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/232 b/tests/xfs/232
index 0ffa198..6b74997 100755
--- a/tests/xfs/232
+++ b/tests/xfs/232
@@ -73,7 +73,7 @@ bufnr=2
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/233 b/tests/xfs/233
index a0c1612..e61c444 100755
--- a/tests/xfs/233
+++ b/tests/xfs/233
@@ -53,7 +53,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 _pwrite_byte 0x61 0 $((blksz * 14 + 71)) $testdir/original >> $seqres.full
 cp -p $testdir/original $testdir/copy1
 cp -p $testdir/copy1 $testdir/copy2
diff --git a/tests/xfs/234 b/tests/xfs/234
index 9a60ec6..3480758 100755
--- a/tests/xfs/234
+++ b/tests/xfs/234
@@ -59,7 +59,7 @@ mkdir $testdir
 metadump_file=$TEST_DIR/${seq}_metadump
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 nr_blks=$((4 * blksz / 12))
 _pwrite_byte 0x61 0 $((blksz * nr_blks)) $testdir/file1 >> $seqres.full
 sync
diff --git a/tests/xfs/236 b/tests/xfs/236
index e5840cb..3ce4de8 100755
--- a/tests/xfs/236
+++ b/tests/xfs/236
@@ -57,7 +57,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 nr_blks=$((8 * blksz / 12))
 
 for i in 1 2 x; do
diff --git a/tests/xfs/265 b/tests/xfs/265
index c8fb527..3dfeb70 100755
--- a/tests/xfs/265
+++ b/tests/xfs/265
@@ -59,7 +59,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 nr_blks=$((2 * blksz / 12))
 
 for i in 1 2 x; do
diff --git a/tests/xfs/309 b/tests/xfs/309
index 38c0452..0dd2dcf 100755
--- a/tests/xfs/309
+++ b/tests/xfs/309
@@ -59,7 +59,7 @@ testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original file blocks"
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 nr_blks=$((2 * blksz / 12))
 
 for i in 1 2 x; do
diff --git a/tests/xfs/310 b/tests/xfs/310
index cce21be..c78f6f1 100755
--- a/tests/xfs/310
+++ b/tests/xfs/310
@@ -58,7 +58,7 @@ _scratch_mkfs >/dev/null 2>&1
 _scratch_mount >> $seqres.full
 
 testdir=$SCRATCH_MNT/test-$seq
-blksz="$(get_block_size $SCRATCH_MNT)"
+blksz="$(_get_block_size $SCRATCH_MNT)"
 
 umount $SCRATCH_MNT
 
@@ -72,7 +72,7 @@ xfs_info $SCRATCH_MNT >> $seqres.full
 
 echo "Create the original file blocks"
 mkdir $testdir
-blksz="$(get_block_size $testdir)"
+blksz="$(_get_block_size $testdir)"
 $XFS_IO_PROG -f -c "falloc 0 $((nr_blks * blksz))" $testdir/file1 >> $seqres.full
 
 echo "Check extent count"
diff --git a/tests/xfs/328 b/tests/xfs/328
index 8518456..90c5f2b 100755
--- a/tests/xfs/328
+++ b/tests/xfs/328
@@ -62,7 +62,7 @@ mkdir "$testdir"
 # 2^10 blocks... that should be plenty for anyone.
 fnr=$((12 + LOAD_FACTOR))
 free_blocks=$(stat -f -c '%a' "$testdir")
-blksz=$(get_block_size $testdir)
+blksz=$(_get_block_size $testdir)
 space_avail=$((free_blocks * blksz))
 calc_space()
 {
diff --git a/tests/xfs/331 b/tests/xfs/331
index 8a7692d..8a1367c 100755
--- a/tests/xfs/331
+++ b/tests/xfs/331
@@ -55,7 +55,7 @@ _scratch_mkfs > "$seqres.full" 2>&1
 
 echo "+ mount fs image"
 _scratch_mount
-blksz="$(get_block_size $SCRATCH_MNT)"
+blksz="$(_get_block_size $SCRATCH_MNT)"
 
 # btree header is 56 bytes; an rmapbt record is 24 bytes; and
 # a rmapbt key/pointer pair is 44 bytes.
diff --git a/tests/xfs/335 b/tests/xfs/335
index 5e48f59..5afeaa8 100755
--- a/tests/xfs/335
+++ b/tests/xfs/335
@@ -54,7 +54,7 @@ _scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs
 cat $tmp.mkfs > "$seqres.full" 2>&1
 _scratch_mount
-blksz="$(get_block_size $SCRATCH_MNT)"
+blksz="$(_get_block_size $SCRATCH_MNT)"
 
 echo "Create a three-level rtrmapbt"
 # inode core size is at least 176 bytes; btree header is 56 bytes;
diff --git a/tests/xfs/336 b/tests/xfs/336
index b3b703d..39838e9 100755
--- a/tests/xfs/336
+++ b/tests/xfs/336
@@ -54,7 +54,7 @@ _scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs
 cat $tmp.mkfs > "$seqres.full" 2>&1
 _scratch_mount
-blksz="$(get_block_size $SCRATCH_MNT)"
+blksz="$(_get_block_size $SCRATCH_MNT)"
 
 metadump_file=$TEST_DIR/${seq}_metadump
 rm -rf $metadump_file
diff --git a/tests/xfs/337 b/tests/xfs/337
index 96a7be0..b61e722 100755
--- a/tests/xfs/337
+++ b/tests/xfs/337
@@ -57,7 +57,7 @@ cat $tmp.mkfs > "$seqres.full" 2>&1
 
 echo "+ mount fs image"
 _scratch_mount
-blksz="$(get_block_size $SCRATCH_MNT)"
+blksz="$(_get_block_size $SCRATCH_MNT)"
 
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
diff --git a/tests/xfs/341 b/tests/xfs/341
index 8a47b77..058e98e 100755
--- a/tests/xfs/341
+++ b/tests/xfs/341
@@ -54,7 +54,7 @@ _scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs
 cat $tmp.mkfs > "$seqres.full" 2>&1
 _scratch_mount
-blksz="$(get_block_size $SCRATCH_MNT)"
+blksz="$(_get_block_size $SCRATCH_MNT)"
 
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
diff --git a/tests/xfs/342 b/tests/xfs/342
index e0d2f33..a95b49d 100755
--- a/tests/xfs/342
+++ b/tests/xfs/342
@@ -53,7 +53,7 @@ _scratch_mkfs | _filter_mkfs 2>$tmp.mkfs >/dev/null
 . $tmp.mkfs
 cat $tmp.mkfs > "$seqres.full" 2>&1
 _scratch_mount
-blksz="$(get_block_size $SCRATCH_MNT)"
+blksz="$(_get_block_size $SCRATCH_MNT)"
 
 # inode core size is at least 176 bytes; btree header is 56 bytes;
 # rtrmap record is 32 bytes; and rtrmap key/pointer are 56 bytes.
diff --git a/tests/xfs/344 b/tests/xfs/344
index 229e22a..806f7ab 100755
--- a/tests/xfs/344
+++ b/tests/xfs/344
@@ -70,7 +70,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/345 b/tests/xfs/345
index 4e31324..1684297 100755
--- a/tests/xfs/345
+++ b/tests/xfs/345
@@ -68,7 +68,7 @@ bufnr=16
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/346 b/tests/xfs/346
index 7d7075a..90fe5eb 100755
--- a/tests/xfs/346
+++ b/tests/xfs/346
@@ -70,7 +70,7 @@ bufnr=8
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"
diff --git a/tests/xfs/347 b/tests/xfs/347
index e4f9635..2a13977 100755
--- a/tests/xfs/347
+++ b/tests/xfs/347
@@ -69,7 +69,7 @@ bufnr=8
 bufsize=$((blksz * bufnr))
 
 _require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
-real_blksz=$(get_block_size $testdir)
+real_blksz=$(_get_block_size $testdir)
 internal_blks=$((filesize / real_blksz))
 
 echo "Create the original files"

