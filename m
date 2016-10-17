Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16524 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933751AbcJQWKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 18:10:07 -0400
Subject: [PATCH 3/3] misc: fix more xfs_db open-coding instances
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 17 Oct 2016 15:09:34 -0700
Message-ID: <147674217475.23842.9304657231302422666.stgit@birch.djwong.org>
In-Reply-To: <147674215521.23842.13841682595738466897.stgit@birch.djwong.org>
References: <147674215521.23842.13841682595738466897.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org

Convert some more cases of 'xfs_db $SCRATCH_DEV' to _scratch_xfs_db
that were left out of the initial cleanup patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 tests/xfs/004 |    2 +-
 tests/xfs/007 |    8 ++++----
 tests/xfs/021 |    4 ++--
 tests/xfs/044 |    2 +-
 tests/xfs/052 |    2 +-
 tests/xfs/116 |    4 ++--
 tests/xfs/136 |    6 +++---
 tests/xfs/199 |    6 +++---
 tests/xfs/278 |   16 ++++++++--------
 tests/xfs/291 |    2 +-
 tests/xfs/307 |   20 ++++++++++----------
 tests/xfs/308 |   20 ++++++++++----------
 12 files changed, 46 insertions(+), 46 deletions(-)


diff --git a/tests/xfs/004 b/tests/xfs/004
index 59b8997..09da2fe 100755
--- a/tests/xfs/004
+++ b/tests/xfs/004
@@ -74,7 +74,7 @@ eval `$DF_PROG $SCRATCH_MNT 2>&1 \
 echo "df gave: blocks=$blocks used=$used avail=$avail" >>$seqres.full
 echo "blocksize from mkfs is '$dbsize'" >>$seqres.full
 
-xfs_db -r -c "freesp -s" $SCRATCH_DEV >$tmp.xfs_db
+_scratch_xfs_db -r -c "freesp -s"  >$tmp.xfs_db
 echo "xfs_db for $SCRATCH_DEV" >>$seqres.full
 cat $tmp.xfs_db >>$seqres.full
 
diff --git a/tests/xfs/007 b/tests/xfs/007
index f2e3584..eb2c9b3 100755
--- a/tests/xfs/007
+++ b/tests/xfs/007
@@ -68,8 +68,8 @@ do_test()
 			grep $qino_2 | awk '{print $NF}'`
 
 	echo "*** Usage before quotarm ***"
-	xfs_db -c "inode $QINO_1" -c "p core.nblocks" $SCRATCH_DEV
-	xfs_db -c "inode $QINO_2" -c "p core.nblocks" $SCRATCH_DEV
+	_scratch_xfs_db -c "inode $QINO_1" -c "p core.nblocks" 
+	_scratch_xfs_db -c "inode $QINO_2" -c "p core.nblocks" 
 
 	_qmount
 	echo "*** turn off $off_opts quotas"
@@ -79,8 +79,8 @@ do_test()
 	_scratch_unmount
 
 	echo "*** Usage after quotarm ***"
-	xfs_db -c "inode $QINO_1" -c "p core.nblocks" $SCRATCH_DEV
-	xfs_db -c "inode $QINO_2" -c "p core.nblocks" $SCRATCH_DEV
+	_scratch_xfs_db -c "inode $QINO_1" -c "p core.nblocks" 
+	_scratch_xfs_db -c "inode $QINO_2" -c "p core.nblocks" 
 }
 
 
diff --git a/tests/xfs/021 b/tests/xfs/021
index 795b71c..67a4346 100755
--- a/tests/xfs/021
+++ b/tests/xfs/021
@@ -130,14 +130,14 @@ _scratch_unmount >>$seqres.full 2>&1 \
 
 echo "*** dump attributes (1)"
 
-xfs_db -r -c "inode $inum_1" -c "print a.sfattr" $SCRATCH_DEV | \
+_scratch_xfs_db -r -c "inode $inum_1" -c "print a.sfattr"  | \
 	sed -e '/secure = /d' | sed -e '/parent = /d'
 
 echo "*** dump attributes (2)"
 
 # There is a fair bit of filtering here to convert v5 filesystem output
 # into the v4 format that holds the meaningful information for the test.
-xfs_db -r -c "inode $inum_2" -c "a a.bmx[0].startblock" -c print $SCRATCH_DEV \
+_scratch_xfs_db -r -c "inode $inum_2" -c "a a.bmx[0].startblock" -c print  \
 	| perl -ne '
 s/,secure//;
 s/,parent//;
diff --git a/tests/xfs/044 b/tests/xfs/044
index ea58c07..fc5dae0 100755
--- a/tests/xfs/044
+++ b/tests/xfs/044
@@ -130,7 +130,7 @@ _check_mount
 _check_require_logdev
 
 echo "*** set uuid"
-xfs_db -x $SCRATCH_DEV -l $SCRATCH_LOGDEV -c "uuid 02020202-0202-0202-0202-020202020202"
+_scratch_xfs_db -x  -l $SCRATCH_LOGDEV -c "uuid 02020202-0202-0202-0202-020202020202"
 [ $? -ne 0 ] && _unexpected
 _check_mount
 
diff --git a/tests/xfs/052 b/tests/xfs/052
index 18cf037..56231f3 100755
--- a/tests/xfs/052
+++ b/tests/xfs/052
@@ -110,7 +110,7 @@ cat $tmp.quota >> $seqres.full
 _scratch_unmount
 
 # note - does (insitu) conversion from fs blocks to 1K blocks
-xfs_db -rc "dquot -$type $id" -c p $SCRATCH_DEV | tee -a $seqres.full | perl -ne '
+_scratch_xfs_db -rc "dquot -$type $id" -c p  | tee -a $seqres.full | perl -ne '
 	if (/^diskdq.bcount = (\d+)$/) {
 		 print "used_blocks=", $1 * '$dbsize' / 1024, "\n";
 	}
diff --git a/tests/xfs/116 b/tests/xfs/116
index 2dabde9..1d13d15 100755
--- a/tests/xfs/116
+++ b/tests/xfs/116
@@ -55,10 +55,10 @@ _require_xfs_quota
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount "-o uquota"
 _scratch_unmount
-xfs_db -r -c sb -c print $SCRATCH_DEV | grep qflags
+_scratch_xfs_db -r -c sb -c print  | grep qflags
 _scratch_mount
 _scratch_unmount
-xfs_db -r -c sb -c print $SCRATCH_DEV | grep qflags
+_scratch_xfs_db -r -c sb -c print  | grep qflags
 
 # success, all done
 status=0
diff --git a/tests/xfs/136 b/tests/xfs/136
index 679fa9f..6256215 100755
--- a/tests/xfs/136
+++ b/tests/xfs/136
@@ -103,7 +103,7 @@ do_extents()
 _print_inode()
 {
     _scratch_unmount
-    xfs_db -r -c "inode $inum" -c "print" $SCRATCH_DEV |\
+    _scratch_xfs_db -r -c "inode $inum" -c "print"  |\
     awk '
 	/nextents/ { print; next }
 	/naextents/ { print; next }
@@ -119,14 +119,14 @@ _print_inode()
 _print_inode_u()
 {
     _scratch_unmount
-    xfs_db -r -c "inode $inum" -c "print u" $SCRATCH_DEV
+    _scratch_xfs_db -r -c "inode $inum" -c "print u" 
     _scratch_mount
 }
 
 _print_inode_a()
 {
     _scratch_unmount
-    xfs_db -r -c "inode $inum" -c "print a" $SCRATCH_DEV
+    _scratch_xfs_db -r -c "inode $inum" -c "print a" 
     _scratch_mount
 }
 
diff --git a/tests/xfs/199 b/tests/xfs/199
index 3133893..ee26439 100755
--- a/tests/xfs/199
+++ b/tests/xfs/199
@@ -51,7 +51,7 @@ _require_scratch
 
 get_features()
 {
-	xfs_db -x $SCRATCH_DEV -c "sb" -c "print $1" | awk '// {print $3}'
+	_scratch_xfs_db -x  -c "sb" -c "print $1" | awk '// {print $3}'
 }
 
 # clear any mkfs options so that we can directly specify the options we need to
@@ -70,7 +70,7 @@ bf2=`get_features bad_features2`
 # Now clear the normal flags
 #
 echo "Clearing features2:"
-xfs_db -x $SCRATCH_DEV -c 'sb' -c 'write features2 0'
+_scratch_xfs_db -x  -c 'sb' -c 'write features2 0'
 
 _scratch_mount
 _scratch_unmount
@@ -80,7 +80,7 @@ rwf2=`get_features features2`
 # Clear the normal flags again for the second rount.
 #
 echo "Clearing features2:"
-xfs_db -x $SCRATCH_DEV -c 'sb' -c 'write features2 0'
+_scratch_xfs_db -x  -c 'sb' -c 'write features2 0'
 
 #
 # And print the flags after a mount ro and remount rw
diff --git a/tests/xfs/278 b/tests/xfs/278
index caf2622..b94ee9c 100755
--- a/tests/xfs/278
+++ b/tests/xfs/278
@@ -62,16 +62,16 @@ _scratch_unmount
 echo "Silence is goodness..."
 
 # Corrupt DIR
-xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].inumber.i4 0" $SCRATCH_DEV >> $seqres.full
-xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].name 0" $SCRATCH_DEV >> $seqres.full
-xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].offset 0" $SCRATCH_DEV >> $seqres.full
-xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].namelen 0" $SCRATCH_DEV >> $seqres.full
-xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >> $seqres.full
-xfs_db -x -c "inode $DIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >> $seqres.full
+_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].inumber.i4 0"  >> $seqres.full
+_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].name 0"  >> $seqres.full
+_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].offset 0"  >> $seqres.full
+_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].namelen 0"  >> $seqres.full
+_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.hdr.parent.i4 0"  >> $seqres.full
+_scratch_xfs_db -x -c "inode $DIR_INO" -c "write core.nlinkv2 0"  >> $seqres.full
 
 # Corrupt SUBDIR
-xfs_db -x -c "inode $SUBDIR_INO" -c "write u.sfdir2.hdr.parent.i4 0" $SCRATCH_DEV >> $seqres.full
-xfs_db -x -c "inode $SUBDIR_INO" -c "write core.nlinkv2 0" $SCRATCH_DEV >> $seqres.full
+_scratch_xfs_db -x -c "inode $SUBDIR_INO" -c "write u.sfdir2.hdr.parent.i4 0"  >> $seqres.full
+_scratch_xfs_db -x -c "inode $SUBDIR_INO" -c "write core.nlinkv2 0"  >> $seqres.full
 
 echo "===== BEGIN of xfs_repair =====" >> $seqres.full
 echo "" >>$seqres.full
diff --git a/tests/xfs/291 b/tests/xfs/291
index c226e65..808f333 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -73,7 +73,7 @@ xfs_io -f -c "pwrite 0 16m" -c "fsync" $SCRATCH_MNT/space_file.large >> $seqres.
 
 # Take a look at freespace for any post-mortem on the test
 _scratch_unmount
-xfs_db -r -c freesp $SCRATCH_DEV >> $seqres.full 2>&1
+_scratch_xfs_db -r -c freesp  >> $seqres.full 2>&1
 _scratch_mount
 
 # Step 2: Make a bunch of (hopefully fragmented) multiblock
diff --git a/tests/xfs/307 b/tests/xfs/307
index 2a99459..427d2fe 100755
--- a/tests/xfs/307
+++ b/tests/xfs/307
@@ -59,7 +59,7 @@ _get_agf_data() {
 	field="$1"
 	shift
 
-	xfs_db -c 'agf 1' "$@" -c "p $field" $SCRATCH_DEV | awk '{print $3}'
+	_scratch_xfs_db -c 'agf 1' "$@" -c "p $field"  | awk '{print $3}'
 }
 
 _set_agf_data() {
@@ -67,14 +67,14 @@ _set_agf_data() {
 	value="$2"
 	shift; shift
 
-	xfs_db -x -c 'agf 1' "$@" -c "write $field -- $value" $SCRATCH_DEV >> $seqres.full
+	_scratch_xfs_db -x -c 'agf 1' "$@" -c "write $field -- $value"  >> $seqres.full
 }
 
 _get_sb_data() {
 	field="$1"
 	shift
 
-	xfs_db -c 'sb 0' "$@" -c "p $field" $SCRATCH_DEV | awk '{print $3}'
+	_scratch_xfs_db -c 'sb 0' "$@" -c "p $field"  | awk '{print $3}'
 }
 
 _set_sb_data() {
@@ -82,7 +82,7 @@ _set_sb_data() {
 	value="$2"
 	shift; shift
 
-	xfs_db -x -c 'sb 0' "$@" -c "write $field -- $value" $SCRATCH_DEV >> $seqres.full
+	_scratch_xfs_db -x -c 'sb 0' "$@" -c "write $field -- $value"  >> $seqres.full
 }
 
 _filter_leftover() {
@@ -91,17 +91,17 @@ _filter_leftover() {
 
 _dump_status() {
 	echo "** " "$@"
-	xfs_db -c 'sb 0' -c p $SCRATCH_DEV
+	_scratch_xfs_db -c 'sb 0' -c p 
 	echo "** agf header"
-	xfs_db -c 'agf 1' -c p $SCRATCH_DEV
+	_scratch_xfs_db -c 'agf 1' -c p 
 	echo "** refcntbt"
-	xfs_db -c 'agf 1' -c 'addr refcntroot' -c p $SCRATCH_DEV
+	_scratch_xfs_db -c 'agf 1' -c 'addr refcntroot' -c p 
 	echo "** rmapbt"
-	test $is_rmap -gt 0 && xfs_db -c 'agf 1' -c 'addr rmaproot' -c p $SCRATCH_DEV
+	test $is_rmap -gt 0 && _scratch_xfs_db -c 'agf 1' -c 'addr rmaproot' -c p 
 	echo "** bnobt"
-	xfs_db -c 'agf 1' -c 'addr bnoroot' -c p $SCRATCH_DEV
+	_scratch_xfs_db -c 'agf 1' -c 'addr bnoroot' -c p 
 	echo "** cntbt"
-	xfs_db -c 'agf 1' -c 'addr cntroot' -c p $SCRATCH_DEV
+	_scratch_xfs_db -c 'agf 1' -c 'addr cntroot' -c p 
 }
 
 echo "We need AG1 to have a single free extent"
diff --git a/tests/xfs/308 b/tests/xfs/308
index 5bfa432..e14586d 100755
--- a/tests/xfs/308
+++ b/tests/xfs/308
@@ -59,7 +59,7 @@ _get_agf_data() {
 	field="$1"
 	shift
 
-	xfs_db -c 'agf 1' "$@" -c "p $field" $SCRATCH_DEV | awk '{print $3}'
+	_scratch_xfs_db -c 'agf 1' "$@" -c "p $field"  | awk '{print $3}'
 }
 
 _set_agf_data() {
@@ -67,14 +67,14 @@ _set_agf_data() {
 	value="$2"
 	shift; shift
 
-	xfs_db -x -c 'agf 1' "$@" -c "write $field -- $value" $SCRATCH_DEV >> $seqres.full
+	_scratch_xfs_db -x -c 'agf 1' "$@" -c "write $field -- $value"  >> $seqres.full
 }
 
 _get_sb_data() {
 	field="$1"
 	shift
 
-	xfs_db -c 'sb 0' "$@" -c "p $field" $SCRATCH_DEV | awk '{print $3}'
+	_scratch_xfs_db -c 'sb 0' "$@" -c "p $field"  | awk '{print $3}'
 }
 
 _set_sb_data() {
@@ -82,7 +82,7 @@ _set_sb_data() {
 	value="$2"
 	shift; shift
 
-	xfs_db -x -c 'sb 0' "$@" -c "write $field -- $value" $SCRATCH_DEV >> $seqres.full
+	_scratch_xfs_db -x -c 'sb 0' "$@" -c "write $field -- $value"  >> $seqres.full
 }
 
 _filter_leftover() {
@@ -91,17 +91,17 @@ _filter_leftover() {
 
 _dump_status() {
 	echo "** " "$@"
-	xfs_db -c 'sb 0' -c p $SCRATCH_DEV
+	_scratch_xfs_db -c 'sb 0' -c p 
 	echo "** agf header"
-	xfs_db -c 'agf 1' -c p $SCRATCH_DEV
+	_scratch_xfs_db -c 'agf 1' -c p 
 	echo "** refcntbt"
-	xfs_db -c 'agf 1' -c 'addr refcntroot' -c p $SCRATCH_DEV
+	_scratch_xfs_db -c 'agf 1' -c 'addr refcntroot' -c p 
 	echo "** rmapbt"
-	test $is_rmap -gt 0 && xfs_db -c 'agf 1' -c 'addr rmaproot' -c p $SCRATCH_DEV
+	test $is_rmap -gt 0 && _scratch_xfs_db -c 'agf 1' -c 'addr rmaproot' -c p 
 	echo "** bnobt"
-	xfs_db -c 'agf 1' -c 'addr bnoroot' -c p $SCRATCH_DEV
+	_scratch_xfs_db -c 'agf 1' -c 'addr bnoroot' -c p 
 	echo "** cntbt"
-	xfs_db -c 'agf 1' -c 'addr cntroot' -c p $SCRATCH_DEV
+	_scratch_xfs_db -c 'agf 1' -c 'addr cntroot' -c p 
 }
 
 echo "We need AG1 to have a single free extent"

