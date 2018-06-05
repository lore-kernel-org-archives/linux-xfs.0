Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47388 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbeFEQnc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 12:43:32 -0400
Subject: [PATCH 5/6] xfs: abstract xfs_info into $XFS_INFO_PROG
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 05 Jun 2018 09:43:27 -0700
Message-ID: <152821700731.24976.1667061625518547754.stgit@magnolia>
In-Reply-To: <152821697018.24976.12939094615403004592.stgit@magnolia>
References: <152821697018.24976.12939094615403004592.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Abstract calls to xfs_info into $XFS_INFO_PROG like we do for all other
xfs utilities.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/attr      |    2 +-
 common/config    |    1 +
 common/populate  |   18 +++++++++---------
 common/rc        |    2 +-
 common/xfs       |    6 +++---
 tests/shared/298 |    2 +-
 tests/xfs/067    |    2 +-
 tests/xfs/073    |    4 ++--
 tests/xfs/085    |    2 +-
 tests/xfs/086    |    2 +-
 tests/xfs/087    |    2 +-
 tests/xfs/088    |    2 +-
 tests/xfs/089    |    2 +-
 tests/xfs/091    |    2 +-
 tests/xfs/093    |    2 +-
 tests/xfs/097    |    4 ++--
 tests/xfs/099    |    2 +-
 tests/xfs/100    |    2 +-
 tests/xfs/101    |    2 +-
 tests/xfs/102    |    2 +-
 tests/xfs/105    |    2 +-
 tests/xfs/112    |    2 +-
 tests/xfs/113    |    2 +-
 tests/xfs/127    |    2 +-
 tests/xfs/130    |    2 +-
 tests/xfs/190    |    2 +-
 tests/xfs/206    |    2 +-
 tests/xfs/233    |    2 +-
 tests/xfs/235    |    2 +-
 tests/xfs/271    |    2 +-
 tests/xfs/307    |    2 +-
 tests/xfs/308    |    2 +-
 tests/xfs/310    |    2 +-
 tests/xfs/348    |    2 +-
 34 files changed, 46 insertions(+), 45 deletions(-)


diff --git a/common/attr b/common/attr
index 3d1385a4..49679d3c 100644
--- a/common/attr
+++ b/common/attr
@@ -30,7 +30,7 @@ _acl_get_max()
 		# CRC format filesystems have much larger ACL counts. The actual
 		# number is into the thousands, but testing that meany takes too
 		# long, so just test well past the old limit of 25.
-		xfs_info $TEST_DIR | _filter_mkfs > /dev/null 2> $tmp.info
+		$XFS_INFO_PROG $TEST_DIR | _filter_mkfs > /dev/null 2> $tmp.info
 		. $tmp.info
 		rm $tmp.info
 		if [ $_fs_has_crcs -eq 0 ]; then
diff --git a/common/config b/common/config
index 221581de..d5150050 100644
--- a/common/config
+++ b/common/config
@@ -205,6 +205,7 @@ export TIMEOUT_PROG="$(type -P timeout)"
 export SETCAP_PROG="$(type -P setcap)"
 export GETCAP_PROG="$(type -P getcap)"
 export CHECKBASHISMS_PROG="$(type -P checkbashisms)"
+export XFS_INFO_PROG="$(type -P xfs_info)"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/common/populate b/common/populate
index 07ea7e60..b2dd053f 100644
--- a/common/populate
+++ b/common/populate
@@ -117,7 +117,7 @@ _populate_xfs_qmount_option()
 	fi
 
 	# Turn on all the quotas
-	if xfs_info "${TEST_DIR}" | grep -q 'crc=1'; then
+	if $XFS_INFO_PROG "${TEST_DIR}" | grep -q 'crc=1'; then
 		# v5 filesystems can have group & project quotas
 		quota="usrquota,grpquota,prjquota"
 	else
@@ -151,7 +151,7 @@ _scratch_xfs_populate() {
 	_populate_xfs_qmount_option
 	_scratch_mount
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
-	dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
 	leaf_lblk="$((32 * 1073741824 / blksz))"
 	node_lblk="$((64 * 1073741824 / blksz))"
 
@@ -267,7 +267,7 @@ _scratch_xfs_populate() {
 	./src/punch-alternating "${SCRATCH_MNT}/BNOBT"
 
 	# Reverse-mapping btree
-	is_rmapbt="$(xfs_info "${SCRATCH_MNT}" | grep -c 'rmapbt=1')"
+	is_rmapbt="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'rmapbt=1')"
 	if [ $is_rmapbt -gt 0 ]; then
 		echo "+ rmapbt btree"
 		nr="$((blksz * 2 / 24))"
@@ -276,7 +276,7 @@ _scratch_xfs_populate() {
 	fi
 
 	# Realtime Reverse-mapping btree
-	is_rt="$(xfs_info "${SCRATCH_MNT}" | grep -c 'rtextents=[1-9]')"
+	is_rt="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'rtextents=[1-9]')"
 	if [ $is_rmapbt -gt 0 ] && [ $is_rt -gt 0 ]; then
 		echo "+ rtrmapbt btree"
 		nr="$((blksz * 2 / 32))"
@@ -285,7 +285,7 @@ _scratch_xfs_populate() {
 	fi
 
 	# Reference-count btree
-	is_reflink="$(xfs_info "${SCRATCH_MNT}" | grep -c 'reflink=1')"
+	is_reflink="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'reflink=1')"
 	if [ $is_reflink -gt 0 ]; then
 		echo "+ reflink btree"
 		nr="$((blksz * 2 / 12))"
@@ -534,12 +534,12 @@ _scratch_xfs_populate_check() {
 	leaf_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_LEAF")"
 	node_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_NODE")"
 	btree_attr="$(__populate_find_inode "${SCRATCH_MNT}/ATTR.FMT_BTREE")"
-	is_finobt=$(xfs_info "${SCRATCH_MNT}" | grep -c 'finobt=1')
-	is_rmapbt=$(xfs_info "${SCRATCH_MNT}" | grep -c 'rmapbt=1')
-	is_reflink=$(xfs_info "${SCRATCH_MNT}" | grep -c 'reflink=1')
+	is_finobt=$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'finobt=1')
+	is_rmapbt=$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'rmapbt=1')
+	is_reflink=$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep -c 'reflink=1')
 
 	blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
-	dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+	dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
 	leaf_lblk="$((32 * 1073741824 / blksz))"
 	node_lblk="$((64 * 1073741824 / blksz))"
 	umount "${SCRATCH_MNT}"
diff --git a/common/rc b/common/rc
index 9c2c0062..8cf6c373 100644
--- a/common/rc
+++ b/common/rc
@@ -328,7 +328,7 @@ _supports_filetype()
 	local fstyp=`$DF_PROG $dir | tail -1 | $AWK_PROG '{print $2}'`
 	case "$fstyp" in
 	xfs)
-		xfs_info $dir | grep -q "ftype=1"
+		$XFS_INFO_PROG $dir | grep -q "ftype=1"
 		;;
 	ext2|ext3|ext4)
 		local dev=`$DF_PROG $dir | tail -1 | $AWK_PROG '{print $1}'`
diff --git a/common/xfs b/common/xfs
index 5d68b5ca..3e34b118 100644
--- a/common/xfs
+++ b/common/xfs
@@ -236,7 +236,7 @@ _require_scratch_xfs_crc()
 	_scratch_mkfs_xfs >/dev/null 2>&1
 	_try_scratch_mount >/dev/null 2>&1 \
 	   || _notrun "Kernel doesn't support crc feature"
-	xfs_info $SCRATCH_MNT | grep -q 'crc=1' || _notrun "crc feature not supported by this filesystem"
+	$XFS_INFO_PROG $SCRATCH_MNT | grep -q 'crc=1' || _notrun "crc feature not supported by this filesystem"
 	_scratch_unmount
 }
 
@@ -467,7 +467,7 @@ _require_xfs_test_rmapbt()
 {
 	_require_test
 
-	if [ "$(xfs_info "$TEST_DIR" | grep -c "rmapbt=1")" -ne 1 ]; then
+	if [ "$($XFS_INFO_PROG "$TEST_DIR" | grep -c "rmapbt=1")" -ne 1 ]; then
 		_notrun "rmapbt not supported by test filesystem type: $FSTYP"
 	fi
 }
@@ -478,7 +478,7 @@ _require_xfs_scratch_rmapbt()
 
 	_scratch_mkfs > /dev/null
 	_scratch_mount
-	if [ "$(xfs_info "$SCRATCH_MNT" | grep -c "rmapbt=1")" -ne 1 ]; then
+	if [ "$($XFS_INFO_PROG "$SCRATCH_MNT" | grep -c "rmapbt=1")" -ne 1 ]; then
 		_scratch_unmount
 		_notrun "rmapbt not supported by scratch filesystem type: $FSTYP"
 	fi
diff --git a/tests/shared/298 b/tests/shared/298
index 0a11300b..9c8e0966 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -69,7 +69,7 @@ get_free_sectors()
 		     }'
 	;;
 	xfs)
-	agsize=`xfs_info $loop_mnt | $SED_PROG -n 's/.*agsize=\(.*\) blks.*/\1/p'`
+	agsize=`$XFS_INFO_PROG $loop_mnt | $SED_PROG -n 's/.*agsize=\(.*\) blks.*/\1/p'`
 	# Convert free space (agno, block, length) to (start sector, end sector)
 	$UMOUNT_PROG $loop_mnt
 	$XFS_DB_PROG -r -c "freesp -d" $img_file | $SED_PROG '/^.*from/,$d'| \
diff --git a/tests/xfs/067 b/tests/xfs/067
index 743d94bb..4aa8966d 100755
--- a/tests/xfs/067
+++ b/tests/xfs/067
@@ -53,7 +53,7 @@ if [ "$isize" -lt 1024 ]; then
 	|| _notrun "Cannot mkfs for this test using MKFS_OPTIONS specified"
 fi
 _scratch_mount
-xfs_info $SCRATCH_MNT >>$seqres.full
+$XFS_INFO_PROG $SCRATCH_MNT >>$seqres.full
 cd $SCRATCH_MNT
 
 echo ""
diff --git a/tests/xfs/073 b/tests/xfs/073
index 9bcc95dd..c1870be2 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -107,11 +107,11 @@ _verify_copy()
 	diff -u $tmp.manifest1 $tmp.manifest2
 
 	echo comparing new image geometry to old
-	xfs_info $source_dir \
+	$XFS_INFO_PROG $source_dir \
 		| _filter_copy $source $source_dir '/dev/loop.' '#' \
 		| tr -s ' ' \
 		> $tmp.geometry1
-	xfs_info $target_dir \
+	$XFS_INFO_PROG $target_dir \
 		| _filter_copy $target $target_dir '/dev/loop.' '#' \
 		| tr -s ' ' \
 		> $tmp.geometry2
diff --git a/tests/xfs/085 b/tests/xfs/085
index 57fc47c9..8f932292 100755
--- a/tests/xfs/085
+++ b/tests/xfs/085
@@ -78,7 +78,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/086 b/tests/xfs/086
index 98b45dde..d05b0619 100755
--- a/tests/xfs/086
+++ b/tests/xfs/086
@@ -79,7 +79,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
 test "${agcount}" -gt 1 || _notrun "Single-AG XFS not supported"
 umount "${SCRATCH_MNT}"
 
diff --git a/tests/xfs/087 b/tests/xfs/087
index 65877c7c..4549597c 100755
--- a/tests/xfs/087
+++ b/tests/xfs/087
@@ -79,7 +79,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/088 b/tests/xfs/088
index 14b1f115..f46c1ead 100755
--- a/tests/xfs/088
+++ b/tests/xfs/088
@@ -79,7 +79,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/089 b/tests/xfs/089
index e47f7fef..5b808604 100755
--- a/tests/xfs/089
+++ b/tests/xfs/089
@@ -79,7 +79,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/091 b/tests/xfs/091
index 7adbdc9e..5e50e8a8 100755
--- a/tests/xfs/091
+++ b/tests/xfs/091
@@ -79,7 +79,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/093 b/tests/xfs/093
index 440cdb66..aa9c360b 100755
--- a/tests/xfs/093
+++ b/tests/xfs/093
@@ -79,7 +79,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/097 b/tests/xfs/097
index 703bd9b4..56104ee3 100755
--- a/tests/xfs/097
+++ b/tests/xfs/097
@@ -65,7 +65,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-xfs_info "${SCRATCH_MNT}" | grep -q "finobt=1" || _notrun "finobt not enabled"
+$XFS_INFO_PROG "${SCRATCH_MNT}" | grep -q "finobt=1" || _notrun "finobt not enabled"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 
 echo "+ make some files"
@@ -82,7 +82,7 @@ for x in `seq 2 64`; do
 	touch "${TESTFILE}.${x}"
 done
 inode="$(stat -c '%i' "${TESTFILE}.1")"
-agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
 umount "${SCRATCH_MNT}"
 
 echo "+ check fs"
diff --git a/tests/xfs/099 b/tests/xfs/099
index 2d63536c..d9aad7e3 100755
--- a/tests/xfs/099
+++ b/tests/xfs/099
@@ -61,7 +61,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
 nr="$((dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/100 b/tests/xfs/100
index 83146ee0..1e76fc45 100755
--- a/tests/xfs/100
+++ b/tests/xfs/100
@@ -61,7 +61,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
 nr="$((dblksz / 12))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/101 b/tests/xfs/101
index 426c3e9c..0e5ed604 100755
--- a/tests/xfs/101
+++ b/tests/xfs/101
@@ -61,7 +61,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
 nr="$((dblksz / 12))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/102 b/tests/xfs/102
index 02bc35ca..ec55c3a6 100755
--- a/tests/xfs/102
+++ b/tests/xfs/102
@@ -61,7 +61,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
 nr="$((16 * dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/105 b/tests/xfs/105
index c3a853b0..bac6e282 100755
--- a/tests/xfs/105
+++ b/tests/xfs/105
@@ -61,7 +61,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
 nr="$((16 * dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/112 b/tests/xfs/112
index cec3a168..fc2ee95d 100755
--- a/tests/xfs/112
+++ b/tests/xfs/112
@@ -61,7 +61,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
 nr="$((16 * dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/113 b/tests/xfs/113
index 17af3b66..b19d948d 100755
--- a/tests/xfs/113
+++ b/tests/xfs/113
@@ -61,7 +61,7 @@ _scratch_mkfs_xfs > /dev/null
 
 echo "+ mount fs image"
 _scratch_mount
-dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+dblksz="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
 nr="$((128 * dblksz / 40))"
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
 leaf_lblk="$((32 * 1073741824 / blksz))"
diff --git a/tests/xfs/127 b/tests/xfs/127
index 60597fbf..863581df 100755
--- a/tests/xfs/127
+++ b/tests/xfs/127
@@ -68,7 +68,7 @@ _scratch_cycle_mount
 echo "Create more reflink copies"
 _cp_reflink $testdir/original $testdir/copy3
 
-xfs_info $SCRATCH_MNT >> $seqres.full
+$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
 
 # success, all done
 status=0
diff --git a/tests/xfs/130 b/tests/xfs/130
index a9e0ff48..71df9bbd 100755
--- a/tests/xfs/130
+++ b/tests/xfs/130
@@ -58,7 +58,7 @@ _scratch_mkfs_xfs > /dev/null
 echo "+ mount fs image"
 _scratch_mount
 blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
-agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+agcount="$($XFS_INFO_PROG "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
 
 echo "+ make some files"
 _pwrite_byte 0x62 0 $((blksz * 64)) "${SCRATCH_MNT}/file0" >> "$seqres.full"
diff --git a/tests/xfs/190 b/tests/xfs/190
index d6882162..251b7283 100755
--- a/tests/xfs/190
+++ b/tests/xfs/190
@@ -54,7 +54,7 @@ _supported_os Linux
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
-fsblocksize=`xfs_info $SCRATCH_MNT|sed 's/=/ /g'|awk '/^data / { print $3 }'`
+fsblocksize=`$XFS_INFO_PROG $SCRATCH_MNT|sed 's/=/ /g'|awk '/^data / { print $3 }'`
 
 dd if=/dev/zero of=$SCRATCH_MNT/$filename bs=1024k count=10 >> $seqres.full 2>&1
 
diff --git a/tests/xfs/206 b/tests/xfs/206
index d5edf1ae..91467e90 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -104,7 +104,7 @@ xfs_growfs $tmpdir  | mkfs_filter
 
 # and double-check the new geometry
 echo "=== xfs_info ==="
-xfs_info $tmpdir | mkfs_filter
+$XFS_INFO_PROG $tmpdir | mkfs_filter
 
 # _cleanup cleans up for us
 
diff --git a/tests/xfs/233 b/tests/xfs/233
index b20dd4f1..9e7d3b32 100755
--- a/tests/xfs/233
+++ b/tests/xfs/233
@@ -66,7 +66,7 @@ _scratch_cycle_mount
 echo "Create more copies"
 cp -p $testdir/original $testdir/copy3
 
-xfs_info $SCRATCH_MNT >> $seqres.full
+$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
 
 # success, all done
 status=0
diff --git a/tests/xfs/235 b/tests/xfs/235
index 84725b0a..f7d75e78 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -56,7 +56,7 @@ _scratch_mkfs_xfs > /dev/null
 echo "+ mount fs image"
 _scratch_mount
 blksz=$(stat -f -c '%s' ${SCRATCH_MNT})
-agcount=$(xfs_info ${SCRATCH_MNT} | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')
+agcount=$($XFS_INFO_PROG ${SCRATCH_MNT} | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')
 
 echo "+ make some files"
 _pwrite_byte 0x62 0 $((blksz * 64)) ${SCRATCH_MNT}/file0 >> $seqres.full
diff --git a/tests/xfs/271 b/tests/xfs/271
index 156cfae6..d82b19b7 100755
--- a/tests/xfs/271
+++ b/tests/xfs/271
@@ -51,7 +51,7 @@ echo "Format and mount"
 _scratch_mkfs > "$seqres.full" 2>&1
 _scratch_mount
 
-agcount=$(xfs_info $SCRATCH_MNT | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')
+agcount=$($XFS_INFO_PROG $SCRATCH_MNT | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')
 
 echo "Get fsmap" | tee -a $seqres.full
 $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT > $TEST_DIR/fsmap
diff --git a/tests/xfs/307 b/tests/xfs/307
index d8295245..4d88fccd 100755
--- a/tests/xfs/307
+++ b/tests/xfs/307
@@ -52,7 +52,7 @@ rm -f $seqres.full
 echo "Format"
 _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full
-is_rmap=$(xfs_info $SCRATCH_MNT | grep -c "rmapbt=1")
+is_rmap=$($XFS_INFO_PROG $SCRATCH_MNT | grep -c "rmapbt=1")
 _scratch_unmount
 
 _get_agf_data() {
diff --git a/tests/xfs/308 b/tests/xfs/308
index 7e7adac3..3d346ec6 100755
--- a/tests/xfs/308
+++ b/tests/xfs/308
@@ -52,7 +52,7 @@ rm -f $seqres.full
 echo "Format"
 _scratch_mkfs > $seqres.full 2>&1
 _scratch_mount >> $seqres.full
-is_rmap=$(xfs_info $SCRATCH_MNT | grep -c "rmapbt=1")
+is_rmap=$($XFS_INFO_PROG $SCRATCH_MNT | grep -c "rmapbt=1")
 _scratch_unmount
 
 _get_agf_data() {
diff --git a/tests/xfs/310 b/tests/xfs/310
index f7b7e30e..f655693d 100755
--- a/tests/xfs/310
+++ b/tests/xfs/310
@@ -67,7 +67,7 @@ sectors=$(( (nr_blks * 3) * blksz / 512 )) # each AG must have > 2^21 blocks
 _dmhugedisk_init $sectors
 _mkfs_dev -d agcount=2 $DMHUGEDISK_DEV
 _mount $DMHUGEDISK_DEV $SCRATCH_MNT
-xfs_info $SCRATCH_MNT >> $seqres.full
+$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
 
 echo "Create the original file blocks"
 mkdir $testdir
diff --git a/tests/xfs/348 b/tests/xfs/348
index 9d3bcb22..4702629e 100755
--- a/tests/xfs/348
+++ b/tests/xfs/348
@@ -70,7 +70,7 @@ mknod $testdir/CHRDEV c 1 1
 mknod $testdir/BLKDEV b 1 1
 mknod $testdir/FIFO p
 
-xfs_info $SCRATCH_MNT | grep -q "ftype=1" && FTYPE_FEATURE=1
+$XFS_INFO_PROG $SCRATCH_MNT | grep -q "ftype=1" && FTYPE_FEATURE=1
 
 # Record test dir inode for xfs_repair filter
 inode_filter=$tmp.sed

