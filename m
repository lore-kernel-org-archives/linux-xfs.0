Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6A6267CD8
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:29:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E13C5AC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:29:05 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id AWn6vujIqvkmilvU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:29:02 -0700 (PDT)
Subject: [PATCH 06/13] xfs: fix $XFS_DB_PROG usage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:28:57 -0700
Message-ID: <147216773738.32641.691363173215857168.stgit@birch.djwong.org>
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

xfs_db requires us to pass in the log device, if any; this can be
accomplished via _scratch_xfs_db_options (if we're operating on the
scratch device, anyway).  However, many of the tests/xfs/ scripts
pass only $SCRATCH_DEV directly, so they'll fail if we test with an
external log.  So, fix that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/001 |   14 +++++++-------
 tests/xfs/002 |    4 ++--
 tests/xfs/070 |    2 +-
 tests/xfs/077 |    6 +++---
 tests/xfs/086 |    2 +-
 tests/xfs/087 |    2 +-
 tests/xfs/088 |    2 +-
 tests/xfs/089 |    2 +-
 tests/xfs/091 |    2 +-
 tests/xfs/093 |    2 +-
 tests/xfs/097 |    2 +-
 tests/xfs/098 |    6 +++---
 tests/xfs/099 |    2 +-
 tests/xfs/100 |    4 ++--
 tests/xfs/101 |    2 +-
 tests/xfs/102 |    4 ++--
 tests/xfs/105 |    4 ++--
 tests/xfs/111 |    2 +-
 tests/xfs/112 |    4 ++--
 tests/xfs/113 |    4 ++--
 tests/xfs/117 |    2 +-
 tests/xfs/120 |    2 +-
 tests/xfs/123 |    2 +-
 tests/xfs/124 |   10 +++++-----
 tests/xfs/125 |    8 ++++----
 tests/xfs/126 |   10 +++++-----
 tests/xfs/130 |    2 +-
 tests/xfs/135 |    2 +-
 tests/xfs/137 |    6 +++---
 tests/xfs/179 |   10 +++++-----
 tests/xfs/186 |    8 ++++----
 tests/xfs/187 |   14 +++++++-------
 tests/xfs/235 |    2 +-
 tests/xfs/287 |    2 +-
 tests/xfs/298 |    2 +-
 35 files changed, 77 insertions(+), 77 deletions(-)


diff --git a/tests/xfs/001 b/tests/xfs/001
index c33adae..e1e1411 100755
--- a/tests/xfs/001
+++ b/tests/xfs/001
@@ -44,11 +44,11 @@ _do_bit_test()
 	bits="$2"
 
 	echo "testing $field with $bits bits"
-	$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write $field 0" $SCRATCH_DEV
+	$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write $field 0" `_scratch_xfs_db_options`
 	num=1
 	for n in `seq 0 1 $bits`; do
 		$XFS_DB_PROG -x -c "inode $FILE_INO" \
-			  -c "write $field $num" $SCRATCH_DEV
+			  -c "write $field $num" `_scratch_xfs_db_options`
 		let num=$num*2
 	done
 	echo
@@ -89,10 +89,10 @@ _do_bit_test "u.bmx[0].startoff" $BMBT_STARTOFF_BITLEN
 _do_bit_test "u.bmx[0].startblock" $BMBT_STARTBLOCK_BITLEN
 _do_bit_test "u.bmx[0].blockcount" $BMBT_BLOCKCOUNT_BITLEN
 # test setting the 32 bit generation number
-$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen 0x5a" $SCRATCH_DEV
-$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen 0xa5" $SCRATCH_DEV
-$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen 0" $SCRATCH_DEV
-$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen #5a5a" $SCRATCH_DEV
-$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen #a5a5" $SCRATCH_DEV
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen 0x5a" `_scratch_xfs_db_options`
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen 0xa5" `_scratch_xfs_db_options`
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen 0" `_scratch_xfs_db_options`
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen #5a5a" `_scratch_xfs_db_options`
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen #a5a5" `_scratch_xfs_db_options`
 status=0
 exit
diff --git a/tests/xfs/002 b/tests/xfs/002
index 6dfdd6c..e9805e9 100755
--- a/tests/xfs/002
+++ b/tests/xfs/002
@@ -62,8 +62,8 @@ _scratch_mkfs_xfs -m crc=0 -d size=128m >> $seqres.full 2>&1 || _fail "mkfs fail
 # Scribble past a couple V4 secondary superblocks to populate sb_crc
 # (We can't write to the structure member because it doesn't exist
 # on a v4 superblock, so we use the data type & "write fill")
-$XFS_DB_PROG -x -c "sb 1" -c "type data" -c "write fill 0xff 224 4" $SCRATCH_DEV
-$XFS_DB_PROG -x -c "sb 2" -c "type data" -c "write fill 0xff 224 4" $SCRATCH_DEV
+$XFS_DB_PROG -x -c "sb 1" -c "type data" -c "write fill 0xff 224 4" `_scratch_xfs_db_options`
+$XFS_DB_PROG -x -c "sb 2" -c "type data" -c "write fill 0xff 224 4" `_scratch_xfs_db_options`
 
 _scratch_mount
 
diff --git a/tests/xfs/070 b/tests/xfs/070
index e3a48b3..e0deb18 100755
--- a/tests/xfs/070
+++ b/tests/xfs/070
@@ -101,7 +101,7 @@ _scratch_mkfs | _filter_mkfs > /dev/null 2> $tmp.mkfs || _fail "mkfs failed"
 
 # corrupt the last secondary sb in the fs
 $XFS_DB_PROG -x -c "sb $((agcount - 1))" -c "type data" \
-	-c "write fill 0xff 0 512" $SCRATCH_DEV
+	-c "write fill 0xff 0 512" `_scratch_xfs_db_options`
 
 # attempt to repair
 _xfs_repair_noscan
diff --git a/tests/xfs/077 b/tests/xfs/077
index 007d05d..0ddb3f6 100755
--- a/tests/xfs/077
+++ b/tests/xfs/077
@@ -64,9 +64,9 @@ _test_uuid()
 	ACTION=$1
 	EXPECTED_UUID=$2
 
-	$XFS_DB_PROG -x -c "uuid $ACTION" $SCRATCH_DEV \
+	$XFS_DB_PROG -x -c "uuid $ACTION" `_scratch_xfs_db_options` \
 					| _filter_uuid $EXPECTED_UUID
-	NEW_UUID=`$XFS_DB_PROG -c "uuid"  $SCRATCH_DEV | awk '{print $NF}'`
+	NEW_UUID=`$XFS_DB_PROG -c "uuid"  $(_scratch_xfs_db_options) | awk '{print $NF}'`
 	_check_scratch_fs
 	_scratch_mount || _fail "Mount failed after UUID $ACTION"
 	_scratch_unmount
@@ -83,7 +83,7 @@ rm -f $seqres.full
 
 _scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
 
-ORIG_UUID=`$XFS_DB_PROG -c "uuid" $SCRATCH_DEV | awk '{print $NF}'`
+ORIG_UUID=`$XFS_DB_PROG -c "uuid" $(_scratch_xfs_db_options) | awk '{print $NF}'`
 
 _scratch_mount
 # Put some stuff on the fs
diff --git a/tests/xfs/086 b/tests/xfs/086
index 143915b..57a5ad5 100755
--- a/tests/xfs/086
+++ b/tests/xfs/086
@@ -87,7 +87,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full 2>&1
 done
 
 # Try to append to files; this should fail
diff --git a/tests/xfs/087 b/tests/xfs/087
index 97c6680..2efe6f7 100755
--- a/tests/xfs/087
+++ b/tests/xfs/087
@@ -86,7 +86,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agi ${ag}" -c "agi ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	$XFS_DB_PROG -x -c "agi ${ag}" -c "agi ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full 2>&1
 done
 
 echo "+ mount image"
diff --git a/tests/xfs/088 b/tests/xfs/088
index 18bf6ad..ac9c7da 100755
--- a/tests/xfs/088
+++ b/tests/xfs/088
@@ -86,7 +86,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agfl ${ag}" -c "agfl ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	$XFS_DB_PROG -x -c "agfl ${ag}" -c "agfl ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full 2>&1
 done
 
 # Try to append to files; this should fail
diff --git a/tests/xfs/089 b/tests/xfs/089
index b6e512f..496a4cd 100755
--- a/tests/xfs/089
+++ b/tests/xfs/089
@@ -86,7 +86,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr bnoroot" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr bnoroot" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full 2>&1
 done
 
 # Try to append to files; this should fail
diff --git a/tests/xfs/091 b/tests/xfs/091
index f995d9c..3943474 100755
--- a/tests/xfs/091
+++ b/tests/xfs/091
@@ -86,7 +86,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr cntroot" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr cntroot" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full 2>&1
 done
 
 # Try to append to files; this should fail
diff --git a/tests/xfs/093 b/tests/xfs/093
index 7d4d9b8..790fdbe 100755
--- a/tests/xfs/093
+++ b/tests/xfs/093
@@ -86,7 +86,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agi ${ag}" -c "agi ${ag}" -c "addr root" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	$XFS_DB_PROG -x -c "agi ${ag}" -c "agi ${ag}" -c "addr root" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full 2>&1
 done
 
 echo "+ mount image"
diff --git a/tests/xfs/097 b/tests/xfs/097
index f5a8178..4dac34f 100755
--- a/tests/xfs/097
+++ b/tests/xfs/097
@@ -89,7 +89,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agi ${ag}" -c "agi ${ag}" -c "addr free_root" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	$XFS_DB_PROG -x -c "agi ${ag}" -c "agi ${ag}" -c "addr free_root" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full 2>&1
 done
 
 echo "+ mount image"
diff --git a/tests/xfs/098 b/tests/xfs/098
index d91d617..4851618 100755
--- a/tests/xfs/098
+++ b/tests/xfs/098
@@ -84,9 +84,9 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ corrupt image"
-logstart="$($XFS_DB_PROG -c 'sb 0' -c 'p' "${SCRATCH_DEV}" | grep '^logstart =' | cut -d ' ' -f 3)"
-logstart="$($XFS_DB_PROG -c "convert fsblock ${logstart} byte" "${SCRATCH_DEV}" | sed -e 's/^.*(\([0-9]*\).*$/\1/g')"
-logblocks="$(xfs_db -c 'sb 0' -c 'p' "${SCRATCH_DEV}" | grep '^logblocks =' | cut -d ' ' -f 3)"
+logstart="$($XFS_DB_PROG -c 'sb 0' -c 'p' `_scratch_xfs_db_options` | grep '^logstart =' | cut -d ' ' -f 3)"
+logstart="$($XFS_DB_PROG -c "convert fsblock ${logstart} byte" `_scratch_xfs_db_options` | sed -e 's/^.*(\([0-9]*\).*$/\1/g')"
+logblocks="$($XFS_DB_PROG -c 'sb 0' -c 'p' `_scratch_xfs_db_options` | grep '^logblocks =' | cut -d ' ' -f 3)"
 $XFS_IO_PROG -f -c "pwrite -S 0x62 ${logstart} $((logblocks * blksz))" "${SCRATCH_DEV}" >> $seqres.full
 
 echo "+ mount image"
diff --git a/tests/xfs/099 b/tests/xfs/099
index 36cf893..6c37160 100755
--- a/tests/xfs/099
+++ b/tests/xfs/099
@@ -78,7 +78,7 @@ echo "+ check dir"
 __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" block
 
 echo "+ corrupt dir"
-$XFS_DB_PROG -x -c "inode ${inode}" -c 'dblock 0' -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+$XFS_DB_PROG -x -c "inode ${inode}" -c 'dblock 0' -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/100 b/tests/xfs/100
index 397c613..19ab43b 100755
--- a/tests/xfs/100
+++ b/tests/xfs/100
@@ -80,8 +80,8 @@ __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" leaf
 echo "+ corrupt dir"
 loff=0
 while true; do
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" `_scratch_xfs_db_options` | grep -q 'file data block is unmapped' && break
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full
 	loff="$((loff + 1))"
 done
 
diff --git a/tests/xfs/101 b/tests/xfs/101
index 09af649..61a85d2 100755
--- a/tests/xfs/101
+++ b/tests/xfs/101
@@ -78,7 +78,7 @@ echo "+ check dir"
 __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" leaf
 
 echo "+ corrupt dir"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/102 b/tests/xfs/102
index 5d1965e..8c4db3e 100755
--- a/tests/xfs/102
+++ b/tests/xfs/102
@@ -80,8 +80,8 @@ __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" node
 echo "+ corrupt dir"
 loff=0
 while true; do
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" `_scratch_xfs_db_options` | grep -q 'file data block is unmapped' && break
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full
 	loff="$((loff + 1))"
 done
 
diff --git a/tests/xfs/105 b/tests/xfs/105
index 516639a..682e8d5 100755
--- a/tests/xfs/105
+++ b/tests/xfs/105
@@ -80,8 +80,8 @@ __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" node
 echo "+ corrupt dir"
 loff="${leaf_lblk}"
 while true; do
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" `_scratch_xfs_db_options` | grep -q 'file data block is unmapped' && break
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full
 	loff="$((loff + 1))"
 done
 
diff --git a/tests/xfs/111 b/tests/xfs/111
index f6a41a8..4899020 100755
--- a/tests/xfs/111
+++ b/tests/xfs/111
@@ -64,7 +64,7 @@ INO=`ls -i $SCRATCH_MNT/512 | awk '{print $1}'`
 _scratch_unmount
 
 # Figure out where that middle inode starts
-BYTE=`$XFS_DB_PROG -c "convert inode $INO byte" $SCRATCH_DEV \
+BYTE=`$XFS_DB_PROG -c "convert inode $INO byte" `_scratch_xfs_db_options` \
 	| awk '{print $2}' | sed s/[\(\)]//g`
 
 echo Blat inode clusters
diff --git a/tests/xfs/112 b/tests/xfs/112
index aa7561e..8893e79 100755
--- a/tests/xfs/112
+++ b/tests/xfs/112
@@ -80,8 +80,8 @@ __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" node
 echo "+ corrupt dir"
 loff="${node_lblk}"
 while true; do
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" `_scratch_xfs_db_options` | grep -q 'file data block is unmapped' && break
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full
 	loff="$((loff + 1))"
 done
 
diff --git a/tests/xfs/113 b/tests/xfs/113
index 8aa3395..e56927f 100755
--- a/tests/xfs/113
+++ b/tests/xfs/113
@@ -80,8 +80,8 @@ __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" btree
 echo "+ corrupt dir"
 loff=0
 while true; do
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" `_scratch_xfs_db_options` | grep -q 'file data block is unmapped' && break
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full
 	loff="$((loff + 1))"
 done
 
diff --git a/tests/xfs/117 b/tests/xfs/117
index 27dafd9..3aeb555 100755
--- a/tests/xfs/117
+++ b/tests/xfs/117
@@ -85,7 +85,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 seq "${inode}" "$((inode + 64))" | while read ino; do
-	$XFS_DB_PROG -x -c "inode ${ino}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	$XFS_DB_PROG -x -c "inode ${ino}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full 2>&1
 done
 
 echo "+ mount image"
diff --git a/tests/xfs/120 b/tests/xfs/120
index 08a4615..b4b5f8b 100755
--- a/tests/xfs/120
+++ b/tests/xfs/120
@@ -75,7 +75,7 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ corrupt image"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "addr u.bmbt.ptrs[1]" -c "addr u3.bmbt.ptrs[1]" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+$XFS_DB_PROG -x -c "inode ${inode}" -c "addr u.bmbt.ptrs[1]" -c "addr u3.bmbt.ptrs[1]" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/123 b/tests/xfs/123
index a746d5c..bc6cb64 100755
--- a/tests/xfs/123
+++ b/tests/xfs/123
@@ -74,7 +74,7 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ corrupt image"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock 0" -c "stack" -c "blocktrash -x 32 -o 256 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock 0" -c "stack" -c "blocktrash -x 32 -o 256 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/124 b/tests/xfs/124
index 239c246..f436ba5 100755
--- a/tests/xfs/124
+++ b/tests/xfs/124
@@ -77,13 +77,13 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ check xattr"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" "${SCRATCH_DEV}" >> $seqres.full
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a block xattr (data)"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${leaf_lblk}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' || _fail "failed to create a block xattr (leaf)"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${node_lblk}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' || _fail "failed to create a block xattr (free)"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" `_scratch_xfs_db_options` >> $seqres.full
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" `_scratch_xfs_db_options` | grep -q 'file attr block is unmapped' && _fail "failed to create a block xattr (data)"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${leaf_lblk}" -c "stack" `_scratch_xfs_db_options` | grep -q 'file attr block is unmapped' || _fail "failed to create a block xattr (leaf)"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${node_lblk}" -c "stack" `_scratch_xfs_db_options` | grep -q 'file attr block is unmapped' || _fail "failed to create a block xattr (free)"
 
 echo "+ corrupt xattr"
-$XFS_DB_PROG -x -c "inode ${inode}" -c 'ablock 0' -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+$XFS_DB_PROG -x -c "inode ${inode}" -c 'ablock 0' -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/125 b/tests/xfs/125
index cf61e02..1779152 100755
--- a/tests/xfs/125
+++ b/tests/xfs/125
@@ -78,12 +78,12 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ check xattr"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" "${SCRATCH_DEV}" >> $seqres.full
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (index)"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 1" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (data)"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" `_scratch_xfs_db_options` >> $seqres.full
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" `_scratch_xfs_db_options` | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (index)"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 1" -c "stack" `_scratch_xfs_db_options` | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (data)"
 
 echo "+ corrupt xattr"
-$XFS_DB_PROG -x -c "inode ${inode}" -c 'ablock 0' -c "stack" -c "blocktrash -x 32 -o +32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+$XFS_DB_PROG -x -c "inode ${inode}" -c 'ablock 0' -c "stack" -c "blocktrash -x 32 -o +32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/126 b/tests/xfs/126
index ebe84fc..107ff79 100755
--- a/tests/xfs/126
+++ b/tests/xfs/126
@@ -78,15 +78,15 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ check xattr"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" "${SCRATCH_DEV}" >> $seqres.full
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (index)"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 1" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (data)"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" `_scratch_xfs_db_options` >> $seqres.full
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" `_scratch_xfs_db_options` | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (index)"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 1" -c "stack" `_scratch_xfs_db_options` | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (data)"
 
 echo "+ corrupt xattr"
 loff=1
 while true; do
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && break
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" `_scratch_xfs_db_options` | grep -q 'file attr block is unmapped' && break
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" `_scratch_xfs_db_options` >> $seqres.full
 	loff="$((loff + 1))"
 done
 
diff --git a/tests/xfs/130 b/tests/xfs/130
index 554d078..4078809 100755
--- a/tests/xfs/130
+++ b/tests/xfs/130
@@ -75,7 +75,7 @@ echo "+ corrupt image"
 seq 0 $((agcount - 1)) | while read ag; do
 	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr refcntroot" \
 		-c "stack" -c "blocktrash -x 4096 -y 4096 -z -n 8 -3" \
-		"${SCRATCH_DEV}" >> "$seqres.full" 2>&1
+		`_scratch_xfs_db_options` >> "$seqres.full" 2>&1
 done
 
 echo "+ mount image"
diff --git a/tests/xfs/135 b/tests/xfs/135
index 0487f0e..8cc8249 100755
--- a/tests/xfs/135
+++ b/tests/xfs/135
@@ -60,7 +60,7 @@ _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 # (the log is zeroed when cycle == 1).
 for i in 16 32 64 128 256; do
 	lsunit=$((i * 1024))
-	$XFS_DB_PROG -x -c "logformat -c 3 -s $lsunit" $SCRATCH_DEV | \
+	$XFS_DB_PROG -x -c "logformat -c 3 -s $lsunit" `_scratch_xfs_db_options` | \
 		tee -a $seqres.full
 	# don't redirect error output so it causes test failure
 	$XFS_LOGPRINT_PROG $SCRATCH_DEV >> $seqres.full
diff --git a/tests/xfs/137 b/tests/xfs/137
index dec9fc9..aab306b 100755
--- a/tests/xfs/137
+++ b/tests/xfs/137
@@ -58,7 +58,7 @@ _require_xfs_db_command "logformat"
 _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 
 # push the log cycle ahead so we have room to move it backwards later
-$XFS_DB_PROG -x -c "logformat -c 3" $SCRATCH_DEV >> $seqres.full 2>&1
+$XFS_DB_PROG -x -c "logformat -c 3" `_scratch_xfs_db_options` >> $seqres.full 2>&1
 
 # do some work on the fs to update metadata LSNs
 _scratch_mount
@@ -68,13 +68,13 @@ _scratch_unmount
 # Reformat to the current cycle and try to mount. This fails in most cases
 # because the sb LSN is ahead of the current LSN. If it doesn't fail, push the
 # cycle back further and try again.
-$XFS_DB_PROG -x -c "logformat" $SCRATCH_DEV >> $seqres.full 2>&1
+$XFS_DB_PROG -x -c "logformat" `_scratch_xfs_db_options` >> $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 if [ $? != 0 ]; then
 	echo mount failure detected
 else
 	_scratch_unmount
-	$XFS_DB_PROG -x -c "logformat -c 2" $SCRATCH_DEV >> $seqres.full 2>&1
+	$XFS_DB_PROG -x -c "logformat -c 2" `_scratch_xfs_db_options` >> $seqres.full 2>&1
 	_scratch_mount >> $seqres.full 2>&1 || echo mount failure detected
 fi
 
diff --git a/tests/xfs/179 b/tests/xfs/179
index 18459cb..8cb3ddd 100755
--- a/tests/xfs/179
+++ b/tests/xfs/179
@@ -67,9 +67,9 @@ _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
 echo "Change reference count"
 _scratch_unmount
 echo "set refcount to -4" >> $seqres.full
-$XFS_DB_PROG -x -c 'agf 0' -c 'addr refcntroot' -c 'write recs[1].refcount 4294967292' $SCRATCH_DEV >> $seqres.full
+$XFS_DB_PROG -x -c 'agf 0' -c 'addr refcntroot' -c 'write recs[1].refcount 4294967292' `_scratch_xfs_db_options` >> $seqres.full
 echo "check refcount after setting to -4" >> $seqres.full
-$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' $SCRATCH_DEV >> $seqres.full
+$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' `_scratch_xfs_db_options` >> $seqres.full
 _scratch_mount >> $seqres.full
 
 echo "Reflink the overlinked file"
@@ -82,7 +82,7 @@ _cp_reflink $testdir/file1 $testdir/file7 >> $seqres.full
 echo "Check scratch fs"
 _scratch_unmount
 echo "check refcount after reflinking 5 more times" >> $seqres.full
-$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' $SCRATCH_DEV >> $seqres.full
+$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' `_scratch_xfs_db_options` >> $seqres.full
 _scratch_mount >> $seqres.full
 
 echo "CoW a couple files"
@@ -93,7 +93,7 @@ _pwrite_byte 0x62 0 $blksz $testdir/file7 >> $seqres.full
 echo "Check scratch fs"
 _scratch_unmount
 echo "check refcount after cowing 3 files" >> $seqres.full
-$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' $SCRATCH_DEV >> $seqres.full
+$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' `_scratch_xfs_db_options` >> $seqres.full
 _scratch_mount >> $seqres.full
 
 echo "Remove reflinked files"
@@ -102,7 +102,7 @@ rm -rf $testdir/file*
 echo "Check scratch fs"
 _scratch_unmount
 echo "check refcount after removing all files" >> $seqres.full
-$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' $SCRATCH_DEV >> $seqres.full
+$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' `_scratch_xfs_db_options` >> $seqres.full
 _scratch_xfs_repair -o force_geometry -n >> $seqres.full 2>&1
 res=$?
 if [ $res -eq 0 ]; then
diff --git a/tests/xfs/186 b/tests/xfs/186
index 192a8c8..347db0d 100755
--- a/tests/xfs/186
+++ b/tests/xfs/186
@@ -98,8 +98,8 @@ _print_inode()
 {
 	echo ""
 	echo "================================="
-	$XFS_DB_PROG -c "version" $SCRATCH_DEV 2>&1 | _filter_version
-	$XFS_DB_PROG -c "inode $inum" -c p $SCRATCH_DEV 2>&1 | _filter_inode
+	$XFS_DB_PROG -c "version" `_scratch_xfs_db_options` 2>&1 | _filter_version
+	$XFS_DB_PROG -c "inode $inum" -c p `_scratch_xfs_db_options` 2>&1 | _filter_inode
 	echo "================================="
 }
 
@@ -136,7 +136,7 @@ _changeto_attr1()
 	echo ""
 	echo "Try setting attr1 by db"
 	echo ""
-	$XFS_DB_PROG -x -c "version attr1" $SCRATCH_DEV | _filter_version
+	$XFS_DB_PROG -x -c "version attr1" `_scratch_xfs_db_options` | _filter_version
 }
 
 # get standard environment, filters and checks
@@ -173,7 +173,7 @@ fi
 
 # set inum to root dir ino
 # we'll add in dirents and EAs into the root directory
-eval `$XFS_DB_PROG -r -c 'sb 0' -c 'p rootino' $SCRATCH_DEV | $SED_PROG 's/ //g'`
+eval `$XFS_DB_PROG -r -c 'sb 0' -c 'p rootino' `_scratch_xfs_db_options` | $SED_PROG 's/ //g'`
 inum=$rootino
 fork_dir=$SCRATCH_MNT
 _print_inode
diff --git a/tests/xfs/187 b/tests/xfs/187
index 836b924..68a00c9 100755
--- a/tests/xfs/187
+++ b/tests/xfs/187
@@ -76,7 +76,7 @@ export MKFS_LAZY="-m crc=0 -l lazy-count=1 -i projid32bit=0"
 # Make sure that when we think we are testing with morebits off
 # that we really are.
 _scratch_mkfs -i attr=1 $MKFS_NO_LAZY  >/dev/null 2>&1
-$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 >$tmp.db
+$XFS_DB_PROG -c version `_scratch_xfs_db_options` 2>&1 >$tmp.db
 if grep -i morebits $tmp.db
 then
 	echo ""
@@ -91,13 +91,13 @@ echo ""
 echo "attr2 fs"
 echo ""
 _scratch_mkfs -i attr=2 $MKFS_NO_LAZY >/dev/null 2>&1
-$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
+$XFS_DB_PROG -r -c version `_scratch_xfs_db_options` 2>&1 | _filter_version
 echo ""
 echo "noattr2 fs"
 echo ""
 _scratch_mount -o noattr2
 $UMOUNT_PROG $SCRATCH_MNT
-$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
+$XFS_DB_PROG -r -c version `_scratch_xfs_db_options` 2>&1 | _filter_version
 
 # adding an EA will ensure the ATTR1 flag is turned on
 echo ""
@@ -106,7 +106,7 @@ echo ""
 echo "attr2 fs"
 echo ""
 _scratch_mkfs -i attr=2 $MKFS_NO_LAZY >/dev/null 2>&1
-$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
+$XFS_DB_PROG -r -c version `_scratch_xfs_db_options` 2>&1 | _filter_version
 echo ""
 echo "noattr2 fs"
 echo ""
@@ -117,7 +117,7 @@ $SETFATTR_PROG -n user.test -v 0xbabe testfile
 $GETFATTR_PROG testfile
 cd $here
 $UMOUNT_PROG $SCRATCH_MNT
-$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
+$XFS_DB_PROG -r -c version `_scratch_xfs_db_options` 2>&1 | _filter_version
 
 echo ""
 echo "*** 3. test noattr2 mount and lazy sb ***"
@@ -126,7 +126,7 @@ echo ""
 echo "attr2 fs"
 echo ""
 _scratch_mkfs -i attr=2 $MKFS_LAZY >/dev/null 2>&1
-$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
+$XFS_DB_PROG -r -c version `_scratch_xfs_db_options` 2>&1 | _filter_version
 echo ""
 echo "noattr2 fs"
 echo ""
@@ -135,7 +135,7 @@ cd $SCRATCH_MNT
 touch testfile
 cd $here
 $UMOUNT_PROG $SCRATCH_MNT
-$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
+$XFS_DB_PROG -r -c version `_scratch_xfs_db_options` 2>&1 | _filter_version
 
 # success, all done
 status=0
diff --git a/tests/xfs/235 b/tests/xfs/235
index ef51d22..1329c28 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -73,7 +73,7 @@ echo "+ corrupt image"
 seq 0 $((agcount - 1)) | while read ag; do
 	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr rmaproot" \
 		-c "stack" -c "blocktrash -x 4096 -y 4096 -z -n 8 -3" \
-		${SCRATCH_DEV} >> $seqres.full 2>&1
+		`_scratch_xfs_db_options` >> $seqres.full 2>&1
 done
 
 echo "+ mount image"
diff --git a/tests/xfs/287 b/tests/xfs/287
index aca410a..14fa51b 100755
--- a/tests/xfs/287
+++ b/tests/xfs/287
@@ -49,7 +49,7 @@ _print_projid()
 	$XFS_DB_PROG -r -c "inode $1" \
 		-c "print core.projid_lo" \
 		-c "print core.projid_hi" \
-		$SCRATCH_DEV
+		`_scratch_xfs_db_options`
 }
 
 # real QA test starts here
diff --git a/tests/xfs/298 b/tests/xfs/298
index bb836a0..18781ad 100755
--- a/tests/xfs/298
+++ b/tests/xfs/298
@@ -82,7 +82,7 @@ while [ $SIZE -lt 1024 ];do
 # umount and check the number of extents on the inode. Should be 0.
 	cd
 	_scratch_unmount >/dev/null 2>&1
-	$XFS_DB_PROG  -c "inode $inode" -c "p core.nextents" $SCRATCH_DEV
+	$XFS_DB_PROG  -c "inode $inode" -c "p core.nextents" `_scratch_xfs_db_options`
 
 	let SIZE=$SIZE+32
 done

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
