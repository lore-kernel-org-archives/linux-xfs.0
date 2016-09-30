Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37132 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755752AbcI3CXv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 22:23:51 -0400
Subject: [PATCH 6/9] xfs: fix $XFS_DB_PROG usage
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 19:23:41 -0700
Message-ID: <147520222110.26891.18259521392775976412.stgit@birch.djwong.org>
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

xfs_db requires us to pass in the log device, if any; this can be
accomplished via _scratch_xfs_db_options (if we're operating on the
scratch device, anyway).  However, many of the tests/xfs/ scripts
pass only $SCRATCH_DEV directly, so they'll fail if we test with an
external log.  Fix that by adding a new _scratch_xfs_db helper.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/populate |  100 ++++++++++++++++++++++++++-----------------------------
 common/rc       |   11 ++++--
 tests/xfs/001   |   16 ++++-----
 tests/xfs/002   |    4 +-
 tests/xfs/070   |    4 +-
 tests/xfs/077   |    6 ++-
 tests/xfs/086   |    2 +
 tests/xfs/087   |    2 +
 tests/xfs/088   |    2 +
 tests/xfs/089   |    2 +
 tests/xfs/091   |    2 +
 tests/xfs/093   |    2 +
 tests/xfs/097   |    2 +
 tests/xfs/098   |    4 +-
 tests/xfs/099   |    2 +
 tests/xfs/100   |    4 +-
 tests/xfs/101   |    2 +
 tests/xfs/102   |    4 +-
 tests/xfs/105   |    4 +-
 tests/xfs/111   |    2 +
 tests/xfs/112   |    4 +-
 tests/xfs/113   |    4 +-
 tests/xfs/117   |    2 +
 tests/xfs/120   |    2 +
 tests/xfs/123   |    2 +
 tests/xfs/124   |   10 +++---
 tests/xfs/125   |    8 ++--
 tests/xfs/126   |   10 +++---
 tests/xfs/130   |    4 +-
 tests/xfs/135   |    2 +
 tests/xfs/137   |    6 ++-
 tests/xfs/179   |   10 +++---
 tests/xfs/186   |    8 ++--
 tests/xfs/187   |   14 ++++----
 tests/xfs/235   |    4 +-
 tests/xfs/287   |    5 +--
 tests/xfs/298   |    2 +
 37 files changed, 137 insertions(+), 137 deletions(-)


diff --git a/common/populate b/common/populate
index aa6ed79..d0003c5 100644
--- a/common/populate
+++ b/common/populate
@@ -275,38 +275,35 @@ __populate_find_inode() {
 
 # Check data fork format of XFS file
 __populate_check_xfs_dformat() {
-	dev="$1"
-	inode="$2"
-	format="$3"
+	inode="$1"
+	format="$2"
 
-	fmt="$($XFS_DB_PROG -c "inode ${inode}" -c 'p core.format' "${dev}" | sed -e 's/^.*(\([a-z]*\)).*$/\1/g')"
+	fmt="$(_scratch_xfs_db -c "inode ${inode}" -c 'p core.format' | sed -e 's/^.*(\([a-z]*\)).*$/\1/g')"
 	test "${format}" = "${fmt}" || _fail "failed to create ino ${inode} dformat expected ${format} saw ${fmt}"
 }
 
 # Check attr fork format of XFS file
 __populate_check_xfs_aformat() {
-	dev="$1"
-	inode="$2"
-	format="$3"
+	inode="$1"
+	format="$2"
 
-	fmt="$($XFS_DB_PROG -c "inode ${inode}" -c 'p core.aformat' "${dev}" | sed -e 's/^.*(\([a-z]*\)).*$/\1/g')"
+	fmt="$(_scratch_xfs_db -c "inode ${inode}" -c 'p core.aformat' | sed -e 's/^.*(\([a-z]*\)).*$/\1/g')"
 	test "${format}" = "${fmt}" || _fail "failed to create ino ${inode} aformat expected ${format} saw ${fmt}"
 }
 
 # Check structure of XFS directory
 __populate_check_xfs_dir() {
-	dev="$1"
-	inode="$2"
-	dtype="$3"
+	inode="$1"
+	dtype="$2"
 
 	(test -n "${leaf_lblk}" && test -n "${node_lblk}") || _fail "must define leaf_lblk and node_lblk before calling __populate_check_xfs_dir"
 	datab=0
 	leafb=0
 	freeb=0
-	#echo "== check dir ${inode} type ${dtype}" ; $XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" "${SCRATCH_DEV}"
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock 0" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' || datab=1
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' || leafb=1
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${node_lblk}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' || freeb=1
+	#echo "== check dir ${inode} type ${dtype}" ; _scratch_xfs_db -x -c "inode ${inode}" -c "bmap"
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock 0" -c "stack" | grep -q 'file data block is unmapped' || datab=1
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "stack" | grep -q 'file data block is unmapped' || leafb=1
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${node_lblk}" -c "stack" | grep -q 'file data block is unmapped' || freeb=1
 
 	case "${dtype}" in
 	"shortform"|"inline"|"local")
@@ -328,15 +325,14 @@ __populate_check_xfs_dir() {
 
 # Check structure of XFS attr
 __populate_check_xfs_attr() {
-	dev="$1"
-	inode="$2"
-	atype="$3"
+	inode="$1"
+	atype="$2"
 
 	datab=0
 	leafb=0
-	#echo "== check attr ${inode} type ${dtype}" ; $XFS_DB_PROG -x -c "inode ${inode}" -c "bmap -a" "${SCRATCH_DEV}"
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' || datab=1
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 1" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' || leafb=1
+	#echo "== check attr ${inode} type ${dtype}" ; _scratch_xfs_db -x -c "inode ${inode}" -c "bmap -a"
+	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock 0" -c "stack" | grep -q 'file attr block is unmapped' || datab=1
+	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock 1" -c "stack" | grep -q 'file attr block is unmapped' || leafb=1
 
 	case "${atype}" in
 	"shortform"|"inline"|"local")
@@ -378,28 +374,28 @@ _scratch_xfs_populate_check() {
 	node_lblk="$((64 * 1073741824 / blksz))"
 	umount "${SCRATCH_MNT}"
 
-	__populate_check_xfs_dformat "${SCRATCH_DEV}" "${extents_file}" "extents"
-	__populate_check_xfs_dformat "${SCRATCH_DEV}" "${btree_file}" "btree"
-	__populate_check_xfs_dir "${SCRATCH_DEV}" "${inline_dir}" "inline"
-	__populate_check_xfs_dir "${SCRATCH_DEV}" "${block_dir}" "block"
-	__populate_check_xfs_dir "${SCRATCH_DEV}" "${leaf_dir}" "leaf"
-	__populate_check_xfs_dir "${SCRATCH_DEV}" "${node_dir}" "node"
-	__populate_check_xfs_dir "${SCRATCH_DEV}" "${btree_dir}" "btree"
-	__populate_check_xfs_dformat "${SCRATCH_DEV}" "${btree_dir}" "btree"
-	__populate_check_xfs_dformat "${SCRATCH_DEV}" "${bdev}" "dev"
-	__populate_check_xfs_dformat "${SCRATCH_DEV}" "${cdev}" "dev"
-	__populate_check_xfs_attr "${SCRATCH_DEV}" "${local_attr}" "local"
-	__populate_check_xfs_attr "${SCRATCH_DEV}" "${leaf_attr}" "leaf"
-	__populate_check_xfs_attr "${SCRATCH_DEV}" "${node_attr}" "node"
-	__populate_check_xfs_attr "${SCRATCH_DEV}" "${btree_attr}" "btree"
-	__populate_check_xfs_aformat "${SCRATCH_DEV}" "${btree_attr}" "btree"
+	__populate_check_xfs_dformat "${extents_file}" "extents"
+	__populate_check_xfs_dformat "${btree_file}" "btree"
+	__populate_check_xfs_dir "${inline_dir}" "inline"
+	__populate_check_xfs_dir "${block_dir}" "block"
+	__populate_check_xfs_dir "${leaf_dir}" "leaf"
+	__populate_check_xfs_dir "${node_dir}" "node"
+	__populate_check_xfs_dir "${btree_dir}" "btree"
+	__populate_check_xfs_dformat "${btree_dir}" "btree"
+	__populate_check_xfs_dformat "${bdev}" "dev"
+	__populate_check_xfs_dformat "${cdev}" "dev"
+	__populate_check_xfs_attr "${local_attr}" "local"
+	__populate_check_xfs_attr "${leaf_attr}" "leaf"
+	__populate_check_xfs_attr "${node_attr}" "node"
+	__populate_check_xfs_attr "${btree_attr}" "btree"
+	__populate_check_xfs_aformat "${btree_attr}" "btree"
 }
 
 # Check data fork format of ext4 file
 __populate_check_ext4_dformat() {
-	dev="$1"
-	inode="$2"
-	format="$3"
+	dev="${SCRATCH_DEV}"
+	inode="$1"
+	format="$2"
 
 	extents=0
 	etree=0
@@ -424,9 +420,9 @@ __populate_check_ext4_dformat() {
 
 # Check attr fork format of ext4 file
 __populate_check_ext4_aformat() {
-	dev="$1"
-	inode="$2"
-	format="$3"
+	dev="${SCRATCH_DEV}"
+	inode="$1"
+	format="$2"
 
 	ablock=1
 	debugfs -R "stat <${inode}>" "${dev}" 2> /dev/null | grep 'File ACL: 0' -q && ablock=0
@@ -445,9 +441,9 @@ __populate_check_ext4_aformat() {
 
 # Check structure of ext4 dir
 __populate_check_ext4_dir() {
-	dev="$1"
-	inode="$2"
-	dtype="$3"
+	dev="${SCRATCH_DEV}"
+	inode="$1"
+	dtype="$2"
 
 	htree=0
 	inline=0
@@ -483,13 +479,13 @@ _scratch_ext4_populate_check() {
 	block_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_BLOCK")"
 	umount "${SCRATCH_MNT}"
 
-	__populate_check_ext4_dformat "${SCRATCH_DEV}" "${extents_file}" "extents"
-	__populate_check_ext4_dformat "${SCRATCH_DEV}" "${etree_file}" "etree"
-	__populate_check_ext4_dir "${SCRATCH_DEV}" "${block_dir}" "block"
-	__populate_check_ext4_dir "${SCRATCH_DEV}" "${htree_dir}" "htree"
-	__populate_check_ext4_dformat "${SCRATCH_DEV}" "${extents_slink}" "extents"
-	__populate_check_ext4_aformat "${SCRATCH_DEV}" "${local_attr}" "local"
-	__populate_check_ext4_aformat "${SCRATCH_DEV}" "${block_attr}" "block"
+	__populate_check_ext4_dformat "${extents_file}" "extents"
+	__populate_check_ext4_dformat "${etree_file}" "etree"
+	__populate_check_ext4_dir "${block_dir}" "block"
+	__populate_check_ext4_dir "${htree_dir}" "htree"
+	__populate_check_ext4_dformat "${extents_slink}" "extents"
+	__populate_check_ext4_aformat "${local_attr}" "local"
+	__populate_check_ext4_aformat "${block_attr}" "block"
 }
 
 # Populate a scratch FS and check the contents to make sure we got that
diff --git a/common/rc b/common/rc
index cd0810a..53f5560 100644
--- a/common/rc
+++ b/common/rc
@@ -1106,6 +1106,11 @@ _scratch_xfs_db_options()
     echo $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
+_scratch_xfs_db()
+{
+	$XFS_DB_PROG "$@" $(_scratch_xfs_db_options)
+}
+
 _scratch_xfs_logprint()
 {
     SCRATCH_OPTIONS=""
@@ -2083,7 +2088,7 @@ _require_xfs_db_command()
 	fi
 	command=$1
 
-	$XFS_DB_PROG -x -c "help" $SCRATCH_DEV | grep $command > /dev/null || \
+	_scratch_xfs_db -x -c "help" | grep $command > /dev/null || \
 		_notrun "xfs_db $command support is missing"
 }
 
@@ -3368,11 +3373,11 @@ _require_meta_uuid()
 	# This will create a crc fs on $SCRATCH_DEV
 	_require_xfs_crc
 
-	$XFS_DB_PROG -x -c "uuid restore" $SCRATCH_DEV 2>&1 \
+	_scratch_xfs_db -x -c "uuid restore" 2>&1 \
 	   | grep -q "invalid UUID\|supported on V5 fs" \
 	   && _notrun "Userspace doesn't support meta_uuid feature"
 
-	$XFS_DB_PROG -x -c "uuid generate" $SCRATCH_DEV >/dev/null 2>&1
+	_scratch_xfs_db -x -c "uuid generate" >/dev/null 2>&1
 
 	_scratch_mount >/dev/null 2>&1 \
 	   || _notrun "Kernel doesn't support meta_uuid feature"
diff --git a/tests/xfs/001 b/tests/xfs/001
index c33adae..2c205f0 100755
--- a/tests/xfs/001
+++ b/tests/xfs/001
@@ -44,11 +44,11 @@ _do_bit_test()
 	bits="$2"
 
 	echo "testing $field with $bits bits"
-	$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write $field 0" $SCRATCH_DEV
+	_scratch_xfs_db -x -c "inode $FILE_INO" -c "write $field 0"
 	num=1
 	for n in `seq 0 1 $bits`; do
-		$XFS_DB_PROG -x -c "inode $FILE_INO" \
-			  -c "write $field $num" $SCRATCH_DEV
+		_scratch_xfs_db -x -c "inode $FILE_INO" \
+			  -c "write $field $num"
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
+_scratch_xfs_db -x -c "inode $FILE_INO" -c "write core.gen 0x5a"
+_scratch_xfs_db -x -c "inode $FILE_INO" -c "write core.gen 0xa5"
+_scratch_xfs_db -x -c "inode $FILE_INO" -c "write core.gen 0"
+_scratch_xfs_db -x -c "inode $FILE_INO" -c "write core.gen #5a5a"
+_scratch_xfs_db -x -c "inode $FILE_INO" -c "write core.gen #a5a5"
 status=0
 exit
diff --git a/tests/xfs/002 b/tests/xfs/002
index 6dfdd6c..741117b 100755
--- a/tests/xfs/002
+++ b/tests/xfs/002
@@ -62,8 +62,8 @@ _scratch_mkfs_xfs -m crc=0 -d size=128m >> $seqres.full 2>&1 || _fail "mkfs fail
 # Scribble past a couple V4 secondary superblocks to populate sb_crc
 # (We can't write to the structure member because it doesn't exist
 # on a v4 superblock, so we use the data type & "write fill")
-$XFS_DB_PROG -x -c "sb 1" -c "type data" -c "write fill 0xff 224 4" $SCRATCH_DEV
-$XFS_DB_PROG -x -c "sb 2" -c "type data" -c "write fill 0xff 224 4" $SCRATCH_DEV
+_scratch_xfs_db -x -c "sb 1" -c "type data" -c "write fill 0xff 224 4"
+_scratch_xfs_db -x -c "sb 2" -c "type data" -c "write fill 0xff 224 4"
 
 _scratch_mount
 
diff --git a/tests/xfs/070 b/tests/xfs/070
index e3a48b3..0ae6eff 100755
--- a/tests/xfs/070
+++ b/tests/xfs/070
@@ -100,8 +100,8 @@ _scratch_mkfs | _filter_mkfs > /dev/null 2> $tmp.mkfs || _fail "mkfs failed"
 . $tmp.mkfs # import agcount
 
 # corrupt the last secondary sb in the fs
-$XFS_DB_PROG -x -c "sb $((agcount - 1))" -c "type data" \
-	-c "write fill 0xff 0 512" $SCRATCH_DEV
+_scratch_xfs_db -x -c "sb $((agcount - 1))" -c "type data" \
+	-c "write fill 0xff 0 512"
 
 # attempt to repair
 _xfs_repair_noscan
diff --git a/tests/xfs/077 b/tests/xfs/077
index 007d05d..eba4f08 100755
--- a/tests/xfs/077
+++ b/tests/xfs/077
@@ -64,9 +64,9 @@ _test_uuid()
 	ACTION=$1
 	EXPECTED_UUID=$2
 
-	$XFS_DB_PROG -x -c "uuid $ACTION" $SCRATCH_DEV \
+	_scratch_xfs_db -x -c "uuid $ACTION" \
 					| _filter_uuid $EXPECTED_UUID
-	NEW_UUID=`$XFS_DB_PROG -c "uuid"  $SCRATCH_DEV | awk '{print $NF}'`
+	NEW_UUID=`_scratch_xfs_db -c "uuid"  | awk '{print $NF}'`
 	_check_scratch_fs
 	_scratch_mount || _fail "Mount failed after UUID $ACTION"
 	_scratch_unmount
@@ -83,7 +83,7 @@ rm -f $seqres.full
 
 _scratch_mkfs_xfs -m crc=1 >> $seqres.full 2>&1 || _fail "mkfs failed"
 
-ORIG_UUID=`$XFS_DB_PROG -c "uuid" $SCRATCH_DEV | awk '{print $NF}'`
+ORIG_UUID=`_scratch_xfs_db -c "uuid" | awk '{print $NF}'`
 
 _scratch_mount
 # Put some stuff on the fs
diff --git a/tests/xfs/086 b/tests/xfs/086
index 143915b..cf0a71a 100755
--- a/tests/xfs/086
+++ b/tests/xfs/086
@@ -87,7 +87,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	_scratch_xfs_db -x -c "agf ${ag}" -c "agf ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
 done
 
 # Try to append to files; this should fail
diff --git a/tests/xfs/087 b/tests/xfs/087
index 97c6680..0bb3ec1 100755
--- a/tests/xfs/087
+++ b/tests/xfs/087
@@ -86,7 +86,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agi ${ag}" -c "agi ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	_scratch_xfs_db -x -c "agi ${ag}" -c "agi ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
 done
 
 echo "+ mount image"
diff --git a/tests/xfs/088 b/tests/xfs/088
index 18bf6ad..d6972a4 100755
--- a/tests/xfs/088
+++ b/tests/xfs/088
@@ -86,7 +86,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agfl ${ag}" -c "agfl ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	_scratch_xfs_db -x -c "agfl ${ag}" -c "agfl ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
 done
 
 # Try to append to files; this should fail
diff --git a/tests/xfs/089 b/tests/xfs/089
index b6e512f..06996a5 100755
--- a/tests/xfs/089
+++ b/tests/xfs/089
@@ -86,7 +86,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr bnoroot" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	_scratch_xfs_db -x -c "agf ${ag}" -c "agf ${ag}" -c "addr bnoroot" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
 done
 
 # Try to append to files; this should fail
diff --git a/tests/xfs/091 b/tests/xfs/091
index f995d9c..a263cb0 100755
--- a/tests/xfs/091
+++ b/tests/xfs/091
@@ -86,7 +86,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr cntroot" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	_scratch_xfs_db -x -c "agf ${ag}" -c "agf ${ag}" -c "addr cntroot" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
 done
 
 # Try to append to files; this should fail
diff --git a/tests/xfs/093 b/tests/xfs/093
index 7d4d9b8..753231e 100755
--- a/tests/xfs/093
+++ b/tests/xfs/093
@@ -86,7 +86,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agi ${ag}" -c "agi ${ag}" -c "addr root" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	_scratch_xfs_db -x -c "agi ${ag}" -c "agi ${ag}" -c "addr root" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
 done
 
 echo "+ mount image"
diff --git a/tests/xfs/097 b/tests/xfs/097
index f5a8178..a75f06a 100755
--- a/tests/xfs/097
+++ b/tests/xfs/097
@@ -89,7 +89,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 for ag in $(seq 1 $((agcount - 1))) 0; do
-	$XFS_DB_PROG -x -c "agi ${ag}" -c "agi ${ag}" -c "addr free_root" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	_scratch_xfs_db -x -c "agi ${ag}" -c "agi ${ag}" -c "addr free_root" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
 done
 
 echo "+ mount image"
diff --git a/tests/xfs/098 b/tests/xfs/098
index 86ec62c..581377e 100755
--- a/tests/xfs/098
+++ b/tests/xfs/098
@@ -95,8 +95,8 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ corrupt image"
-logstart="$($XFS_DB_PROG -c 'sb 0' -c 'p' "${SCRATCH_DEV}" | grep '^logstart =' | cut -d ' ' -f 3)"
-logstart="$($XFS_DB_PROG -c "convert fsblock ${logstart} byte" "${SCRATCH_DEV}" | sed -e 's/^.*(\([0-9]*\).*$/\1/g')"
+logstart="$(_scratch_xfs_db -c 'sb 0' -c 'p' | grep '^logstart =' | cut -d ' ' -f 3)"
+logstart="$(_scratch_xfs_db -c "convert fsblock ${logstart} byte" | sed -e 's/^.*(\([0-9]*\).*$/\1/g')"
 logblocks="$(xfs_db -c 'sb 0' -c 'p' "${SCRATCH_DEV}" | grep '^logblocks =' | cut -d ' ' -f 3)"
 $XFS_IO_PROG -f -c "pwrite -S 0x62 ${logstart} $((logblocks * blksz))" "${SCRATCH_DEV}" >> $seqres.full
 
diff --git a/tests/xfs/099 b/tests/xfs/099
index 36cf893..ebc02dd 100755
--- a/tests/xfs/099
+++ b/tests/xfs/099
@@ -78,7 +78,7 @@ echo "+ check dir"
 __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" block
 
 echo "+ corrupt dir"
-$XFS_DB_PROG -x -c "inode ${inode}" -c 'dblock 0' -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+_scratch_xfs_db -x -c "inode ${inode}" -c 'dblock 0' -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/100 b/tests/xfs/100
index 397c613..2412c81 100755
--- a/tests/xfs/100
+++ b/tests/xfs/100
@@ -80,8 +80,8 @@ __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" leaf
 echo "+ corrupt dir"
 loff=0
 while true; do
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" | grep -q 'file data block is unmapped' && break
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 	loff="$((loff + 1))"
 done
 
diff --git a/tests/xfs/101 b/tests/xfs/101
index 09af649..679940f 100755
--- a/tests/xfs/101
+++ b/tests/xfs/101
@@ -78,7 +78,7 @@ echo "+ check dir"
 __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" leaf
 
 echo "+ corrupt dir"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/102 b/tests/xfs/102
index 5d1965e..8018a9e 100755
--- a/tests/xfs/102
+++ b/tests/xfs/102
@@ -80,8 +80,8 @@ __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" node
 echo "+ corrupt dir"
 loff=0
 while true; do
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" | grep -q 'file data block is unmapped' && break
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 	loff="$((loff + 1))"
 done
 
diff --git a/tests/xfs/105 b/tests/xfs/105
index 516639a..27ee4b3 100755
--- a/tests/xfs/105
+++ b/tests/xfs/105
@@ -80,8 +80,8 @@ __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" node
 echo "+ corrupt dir"
 loff="${leaf_lblk}"
 while true; do
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" | grep -q 'file data block is unmapped' && break
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 	loff="$((loff + 1))"
 done
 
diff --git a/tests/xfs/111 b/tests/xfs/111
index f6a41a8..d5a09bb 100755
--- a/tests/xfs/111
+++ b/tests/xfs/111
@@ -64,7 +64,7 @@ INO=`ls -i $SCRATCH_MNT/512 | awk '{print $1}'`
 _scratch_unmount
 
 # Figure out where that middle inode starts
-BYTE=`$XFS_DB_PROG -c "convert inode $INO byte" $SCRATCH_DEV \
+BYTE=`_scratch_xfs_db -c "convert inode $INO byte" \
 	| awk '{print $2}' | sed s/[\(\)]//g`
 
 echo Blat inode clusters
diff --git a/tests/xfs/112 b/tests/xfs/112
index aa7561e..c237f03 100755
--- a/tests/xfs/112
+++ b/tests/xfs/112
@@ -80,8 +80,8 @@ __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" node
 echo "+ corrupt dir"
 loff="${node_lblk}"
 while true; do
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" | grep -q 'file data block is unmapped' && break
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 	loff="$((loff + 1))"
 done
 
diff --git a/tests/xfs/113 b/tests/xfs/113
index 8aa3395..6d6e6fd 100755
--- a/tests/xfs/113
+++ b/tests/xfs/113
@@ -80,8 +80,8 @@ __populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" btree
 echo "+ corrupt dir"
 loff=0
 while true; do
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" | grep -q 'file data block is unmapped' && break
+	_scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 	loff="$((loff + 1))"
 done
 
diff --git a/tests/xfs/117 b/tests/xfs/117
index 27dafd9..f251fb3 100755
--- a/tests/xfs/117
+++ b/tests/xfs/117
@@ -85,7 +85,7 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail
 
 echo "+ corrupt image"
 seq "${inode}" "$((inode + 64))" | while read ino; do
-	$XFS_DB_PROG -x -c "inode ${ino}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+	_scratch_xfs_db -x -c "inode ${ino}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full 2>&1
 done
 
 echo "+ mount image"
diff --git a/tests/xfs/120 b/tests/xfs/120
index 08a4615..3deece6 100755
--- a/tests/xfs/120
+++ b/tests/xfs/120
@@ -75,7 +75,7 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ corrupt image"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "addr u.bmbt.ptrs[1]" -c "addr u3.bmbt.ptrs[1]" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+_scratch_xfs_db -x -c "inode ${inode}" -c "addr u.bmbt.ptrs[1]" -c "addr u3.bmbt.ptrs[1]" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/123 b/tests/xfs/123
index a746d5c..e6cd8e7 100755
--- a/tests/xfs/123
+++ b/tests/xfs/123
@@ -74,7 +74,7 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ corrupt image"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock 0" -c "stack" -c "blocktrash -x 32 -o 256 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+_scratch_xfs_db -x -c "inode ${inode}" -c "dblock 0" -c "stack" -c "blocktrash -x 32 -o 256 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/124 b/tests/xfs/124
index 239c246..cfea2e6 100755
--- a/tests/xfs/124
+++ b/tests/xfs/124
@@ -77,13 +77,13 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ check xattr"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" "${SCRATCH_DEV}" >> $seqres.full
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a block xattr (data)"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${leaf_lblk}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' || _fail "failed to create a block xattr (leaf)"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${node_lblk}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' || _fail "failed to create a block xattr (free)"
+_scratch_xfs_db -x -c "inode ${inode}" -c "bmap" >> $seqres.full
+_scratch_xfs_db -x -c "inode ${inode}" -c "ablock 0" -c "stack" | grep -q 'file attr block is unmapped' && _fail "failed to create a block xattr (data)"
+_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${leaf_lblk}" -c "stack" | grep -q 'file attr block is unmapped' || _fail "failed to create a block xattr (leaf)"
+_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${node_lblk}" -c "stack" | grep -q 'file attr block is unmapped' || _fail "failed to create a block xattr (free)"
 
 echo "+ corrupt xattr"
-$XFS_DB_PROG -x -c "inode ${inode}" -c 'ablock 0' -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+_scratch_xfs_db -x -c "inode ${inode}" -c 'ablock 0' -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/125 b/tests/xfs/125
index cf61e02..3f2f6f0 100755
--- a/tests/xfs/125
+++ b/tests/xfs/125
@@ -78,12 +78,12 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ check xattr"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" "${SCRATCH_DEV}" >> $seqres.full
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (index)"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 1" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (data)"
+_scratch_xfs_db -x -c "inode ${inode}" -c "bmap" >> $seqres.full
+_scratch_xfs_db -x -c "inode ${inode}" -c "ablock 0" -c "stack" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (index)"
+_scratch_xfs_db -x -c "inode ${inode}" -c "ablock 1" -c "stack" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (data)"
 
 echo "+ corrupt xattr"
-$XFS_DB_PROG -x -c "inode ${inode}" -c 'ablock 0' -c "stack" -c "blocktrash -x 32 -o +32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+_scratch_xfs_db -x -c "inode ${inode}" -c 'ablock 0' -c "stack" -c "blocktrash -x 32 -o +32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
 _scratch_mount
diff --git a/tests/xfs/126 b/tests/xfs/126
index ebe84fc..77779e0 100755
--- a/tests/xfs/126
+++ b/tests/xfs/126
@@ -78,15 +78,15 @@ echo "+ check fs"
 _scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
 
 echo "+ check xattr"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" "${SCRATCH_DEV}" >> $seqres.full
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (index)"
-$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 1" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (data)"
+_scratch_xfs_db -x -c "inode ${inode}" -c "bmap" >> $seqres.full
+_scratch_xfs_db -x -c "inode ${inode}" -c "ablock 0" -c "stack" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (index)"
+_scratch_xfs_db -x -c "inode ${inode}" -c "ablock 1" -c "stack" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (data)"
 
 echo "+ corrupt xattr"
 loff=1
 while true; do
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && break
-	$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" | grep -q 'file attr block is unmapped' && break
+	_scratch_xfs_db -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 	loff="$((loff + 1))"
 done
 
diff --git a/tests/xfs/130 b/tests/xfs/130
index 48f6a84..1c3d642 100755
--- a/tests/xfs/130
+++ b/tests/xfs/130
@@ -73,9 +73,9 @@ _scratch_xfs_repair -n >> "$seqres.full" 2>&1 || \
 
 echo "+ corrupt image"
 seq 0 $((agcount - 1)) | while read ag; do
-	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr refcntroot" \
+	_scratch_xfs_db -x -c "agf ${ag}" -c "agf ${ag}" -c "addr refcntroot" \
 		-c "stack" -c "blocktrash -x 4096 -y 4096 -z -n 8 -3" \
-		"${SCRATCH_DEV}" >> "$seqres.full" 2>&1
+		>> "$seqres.full" 2>&1
 done
 
 echo "+ mount image"
diff --git a/tests/xfs/135 b/tests/xfs/135
index 0487f0e..01fa4a6 100755
--- a/tests/xfs/135
+++ b/tests/xfs/135
@@ -60,7 +60,7 @@ _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 # (the log is zeroed when cycle == 1).
 for i in 16 32 64 128 256; do
 	lsunit=$((i * 1024))
-	$XFS_DB_PROG -x -c "logformat -c 3 -s $lsunit" $SCRATCH_DEV | \
+	_scratch_xfs_db -x -c "logformat -c 3 -s $lsunit" | \
 		tee -a $seqres.full
 	# don't redirect error output so it causes test failure
 	$XFS_LOGPRINT_PROG $SCRATCH_DEV >> $seqres.full
diff --git a/tests/xfs/137 b/tests/xfs/137
index dec9fc9..093ef00 100755
--- a/tests/xfs/137
+++ b/tests/xfs/137
@@ -58,7 +58,7 @@ _require_xfs_db_command "logformat"
 _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 
 # push the log cycle ahead so we have room to move it backwards later
-$XFS_DB_PROG -x -c "logformat -c 3" $SCRATCH_DEV >> $seqres.full 2>&1
+_scratch_xfs_db -x -c "logformat -c 3" >> $seqres.full 2>&1
 
 # do some work on the fs to update metadata LSNs
 _scratch_mount
@@ -68,13 +68,13 @@ _scratch_unmount
 # Reformat to the current cycle and try to mount. This fails in most cases
 # because the sb LSN is ahead of the current LSN. If it doesn't fail, push the
 # cycle back further and try again.
-$XFS_DB_PROG -x -c "logformat" $SCRATCH_DEV >> $seqres.full 2>&1
+_scratch_xfs_db -x -c "logformat" >> $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 if [ $? != 0 ]; then
 	echo mount failure detected
 else
 	_scratch_unmount
-	$XFS_DB_PROG -x -c "logformat -c 2" $SCRATCH_DEV >> $seqres.full 2>&1
+	_scratch_xfs_db -x -c "logformat -c 2" >> $seqres.full 2>&1
 	_scratch_mount >> $seqres.full 2>&1 || echo mount failure detected
 fi
 
diff --git a/tests/xfs/179 b/tests/xfs/179
index 18459cb..4aeabb2 100755
--- a/tests/xfs/179
+++ b/tests/xfs/179
@@ -67,9 +67,9 @@ _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
 echo "Change reference count"
 _scratch_unmount
 echo "set refcount to -4" >> $seqres.full
-$XFS_DB_PROG -x -c 'agf 0' -c 'addr refcntroot' -c 'write recs[1].refcount 4294967292' $SCRATCH_DEV >> $seqres.full
+_scratch_xfs_db -x -c 'agf 0' -c 'addr refcntroot' -c 'write recs[1].refcount 4294967292' >> $seqres.full
 echo "check refcount after setting to -4" >> $seqres.full
-$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' $SCRATCH_DEV >> $seqres.full
+_scratch_xfs_db -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' >> $seqres.full
 _scratch_mount >> $seqres.full
 
 echo "Reflink the overlinked file"
@@ -82,7 +82,7 @@ _cp_reflink $testdir/file1 $testdir/file7 >> $seqres.full
 echo "Check scratch fs"
 _scratch_unmount
 echo "check refcount after reflinking 5 more times" >> $seqres.full
-$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' $SCRATCH_DEV >> $seqres.full
+_scratch_xfs_db -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' >> $seqres.full
 _scratch_mount >> $seqres.full
 
 echo "CoW a couple files"
@@ -93,7 +93,7 @@ _pwrite_byte 0x62 0 $blksz $testdir/file7 >> $seqres.full
 echo "Check scratch fs"
 _scratch_unmount
 echo "check refcount after cowing 3 files" >> $seqres.full
-$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' $SCRATCH_DEV >> $seqres.full
+_scratch_xfs_db -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' >> $seqres.full
 _scratch_mount >> $seqres.full
 
 echo "Remove reflinked files"
@@ -102,7 +102,7 @@ rm -rf $testdir/file*
 echo "Check scratch fs"
 _scratch_unmount
 echo "check refcount after removing all files" >> $seqres.full
-$XFS_DB_PROG -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' $SCRATCH_DEV >> $seqres.full
+_scratch_xfs_db -c 'agf 0' -c 'addr refcntroot' -c 'p recs[1]' >> $seqres.full
 _scratch_xfs_repair -o force_geometry -n >> $seqres.full 2>&1
 res=$?
 if [ $res -eq 0 ]; then
diff --git a/tests/xfs/186 b/tests/xfs/186
index 192a8c8..4b36ae6 100755
--- a/tests/xfs/186
+++ b/tests/xfs/186
@@ -98,8 +98,8 @@ _print_inode()
 {
 	echo ""
 	echo "================================="
-	$XFS_DB_PROG -c "version" $SCRATCH_DEV 2>&1 | _filter_version
-	$XFS_DB_PROG -c "inode $inum" -c p $SCRATCH_DEV 2>&1 | _filter_inode
+	_scratch_xfs_db -c "version" 2>&1 | _filter_version
+	_scratch_xfs_db -c "inode $inum" -c p 2>&1 | _filter_inode
 	echo "================================="
 }
 
@@ -136,7 +136,7 @@ _changeto_attr1()
 	echo ""
 	echo "Try setting attr1 by db"
 	echo ""
-	$XFS_DB_PROG -x -c "version attr1" $SCRATCH_DEV | _filter_version
+	_scratch_xfs_db -x -c "version attr1" | _filter_version
 }
 
 # get standard environment, filters and checks
@@ -173,7 +173,7 @@ fi
 
 # set inum to root dir ino
 # we'll add in dirents and EAs into the root directory
-eval `$XFS_DB_PROG -r -c 'sb 0' -c 'p rootino' $SCRATCH_DEV | $SED_PROG 's/ //g'`
+eval `_scratch_xfs_db -r -c 'sb 0' -c 'p rootino' | $SED_PROG 's/ //g'`
 inum=$rootino
 fork_dir=$SCRATCH_MNT
 _print_inode
diff --git a/tests/xfs/187 b/tests/xfs/187
index 836b924..07ef3ae 100755
--- a/tests/xfs/187
+++ b/tests/xfs/187
@@ -76,7 +76,7 @@ export MKFS_LAZY="-m crc=0 -l lazy-count=1 -i projid32bit=0"
 # Make sure that when we think we are testing with morebits off
 # that we really are.
 _scratch_mkfs -i attr=1 $MKFS_NO_LAZY  >/dev/null 2>&1
-$XFS_DB_PROG -c version $SCRATCH_DEV 2>&1 >$tmp.db
+_scratch_xfs_db -c version 2>&1 >$tmp.db
 if grep -i morebits $tmp.db
 then
 	echo ""
@@ -91,13 +91,13 @@ echo ""
 echo "attr2 fs"
 echo ""
 _scratch_mkfs -i attr=2 $MKFS_NO_LAZY >/dev/null 2>&1
-$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
+_scratch_xfs_db -r -c version 2>&1 | _filter_version
 echo ""
 echo "noattr2 fs"
 echo ""
 _scratch_mount -o noattr2
 $UMOUNT_PROG $SCRATCH_MNT
-$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
+_scratch_xfs_db -r -c version 2>&1 | _filter_version
 
 # adding an EA will ensure the ATTR1 flag is turned on
 echo ""
@@ -106,7 +106,7 @@ echo ""
 echo "attr2 fs"
 echo ""
 _scratch_mkfs -i attr=2 $MKFS_NO_LAZY >/dev/null 2>&1
-$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
+_scratch_xfs_db -r -c version 2>&1 | _filter_version
 echo ""
 echo "noattr2 fs"
 echo ""
@@ -117,7 +117,7 @@ $SETFATTR_PROG -n user.test -v 0xbabe testfile
 $GETFATTR_PROG testfile
 cd $here
 $UMOUNT_PROG $SCRATCH_MNT
-$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
+_scratch_xfs_db -r -c version 2>&1 | _filter_version
 
 echo ""
 echo "*** 3. test noattr2 mount and lazy sb ***"
@@ -126,7 +126,7 @@ echo ""
 echo "attr2 fs"
 echo ""
 _scratch_mkfs -i attr=2 $MKFS_LAZY >/dev/null 2>&1
-$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
+_scratch_xfs_db -r -c version 2>&1 | _filter_version
 echo ""
 echo "noattr2 fs"
 echo ""
@@ -135,7 +135,7 @@ cd $SCRATCH_MNT
 touch testfile
 cd $here
 $UMOUNT_PROG $SCRATCH_MNT
-$XFS_DB_PROG -r -c version $SCRATCH_DEV 2>&1 | _filter_version
+_scratch_xfs_db -r -c version 2>&1 | _filter_version
 
 # success, all done
 status=0
diff --git a/tests/xfs/235 b/tests/xfs/235
index ef51d22..88101f2 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -71,9 +71,9 @@ _scratch_xfs_repair -n >> $seqres.full 2>&1 || \
 
 echo "+ corrupt image"
 seq 0 $((agcount - 1)) | while read ag; do
-	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr rmaproot" \
+	_scratch_xfs_db -x -c "agf ${ag}" -c "agf ${ag}" -c "addr rmaproot" \
 		-c "stack" -c "blocktrash -x 4096 -y 4096 -z -n 8 -3" \
-		${SCRATCH_DEV} >> $seqres.full 2>&1
+		>> $seqres.full 2>&1
 done
 
 echo "+ mount image"
diff --git a/tests/xfs/287 b/tests/xfs/287
index aca410a..e718df8 100755
--- a/tests/xfs/287
+++ b/tests/xfs/287
@@ -46,10 +46,9 @@ _cleanup()
 
 _print_projid()
 {
-	$XFS_DB_PROG -r -c "inode $1" \
+	_scratch_xfs_db -r -c "inode $1" \
 		-c "print core.projid_lo" \
-		-c "print core.projid_hi" \
-		$SCRATCH_DEV
+		-c "print core.projid_hi"
 }
 
 # real QA test starts here
diff --git a/tests/xfs/298 b/tests/xfs/298
index bb836a0..7702526 100755
--- a/tests/xfs/298
+++ b/tests/xfs/298
@@ -82,7 +82,7 @@ while [ $SIZE -lt 1024 ];do
 # umount and check the number of extents on the inode. Should be 0.
 	cd
 	_scratch_unmount >/dev/null 2>&1
-	$XFS_DB_PROG  -c "inode $inode" -c "p core.nextents" $SCRATCH_DEV
+	_scratch_xfs_db  -c "inode $inode" -c "p core.nextents"
 
 	let SIZE=$SIZE+32
 done

