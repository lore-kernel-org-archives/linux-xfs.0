Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0EAEE7FF8
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E17C3304066
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id AgqX1ARm3loI8DHl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:26 -0800 (PST)
Message-Id: <20131211073626.306302766@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:46 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/12] 062: use TEST_DIR instead of a SCRATCH_DEV
References: <20131211073445.353655850@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0001-062-use-TEST_DIR-instead-of-a-SCRATCH_DEV.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>

The test does not require a fresh file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/062     |   95 ++++++------
 tests/generic/062.out |  384 ++++++++++++++++++++++++-------------------------
 2 files changed, 239 insertions(+), 240 deletions(-)

diff --git a/tests/generic/062 b/tests/generic/062
index 047c930..fa2fce0 100755
--- a/tests/generic/062
+++ b/tests/generic/062
@@ -40,47 +40,46 @@ _cleanup()
 {
         cd /
 	echo; echo "*** unmount"
-	umount $SCRATCH_MNT 2>/dev/null
 	rm -f $tmp.*
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
 getfattr()
 {
-    $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_scratch
+    $GETFATTR_PROG --absolute-names -dh $@ 2>&1 | _filter_test_dir
 }
 
 setfattr()
 {
-    $SETFATTR_PROG $@ 2>&1 | _filter_scratch
+    $SETFATTR_PROG $@ 2>&1 | _filter_test_dir
 }
 
 _create_test_bed()
 {
 	echo "*** create test bed"
-	touch $SCRATCH_MNT/reg
-	mkdir -p $SCRATCH_MNT/dir
-	ln -s $SCRATCH_MNT/dir $SCRATCH_MNT/lnk
-	mkdir $SCRATCH_MNT/dev
-	mknod $SCRATCH_MNT/dev/b b 0 0
-	mknod $SCRATCH_MNT/dev/c c 0 0
-	mknod $SCRATCH_MNT/dev/p p
+	touch $testdir/reg
+	mkdir -p $testdir/dir
+	ln -s $testdir/dir $testdir/lnk
+	mkdir $testdir/dev
+	mknod $testdir/dev/b b 0 0
+	mknod $testdir/dev/c c 0 0
+	mknod $testdir/dev/p p
 	# sanity check
-	find $SCRATCH_MNT | LC_COLLATE=POSIX sort | _filter_scratch | grep -v "lost+found"
+	find $testdir | LC_COLLATE=POSIX sort | _filter_test_dir | grep -v "lost+found"
 }
 
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
 
-_require_scratch
 _require_attrs
 
 rm -f $tmp.backup1 $tmp.backup2 $seqres.full
 
-# real QA test starts here
-_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
-_scratch_mount || _fail "mount failed"
+testdir="$TEST_DIR/attr062"
+rm -rf $testdir
+mkdir $testdir
+
 _create_test_bed
 
 # In kernels before 3.0, getxattr() fails with EPERM for an attribute which
@@ -100,42 +99,42 @@ for nsp in $ATTR_MODES; do
 		echo; echo "=== TYPE $inode; NAMESPACE $nsp"; echo
 		echo "*** set/get one initially empty attribute"
     
-		setfattr -h -n $nsp.name $SCRATCH_MNT/$inode
-		getfattr -m $nsp $SCRATCH_MNT/$inode
+		setfattr -h -n $nsp.name $testdir/$inode
+		getfattr -m $nsp $testdir/$inode
 
 		echo "*** overwrite empty, set several new attributes"
-		setfattr -h -n $nsp.name -v 0xbabe $SCRATCH_MNT/$inode
-		setfattr -h -n $nsp.name2 -v 0xdeadbeef $SCRATCH_MNT/$inode
-		setfattr -h -n $nsp.name3 -v 0xdeface $SCRATCH_MNT/$inode
+		setfattr -h -n $nsp.name -v 0xbabe $testdir/$inode
+		setfattr -h -n $nsp.name2 -v 0xdeadbeef $testdir/$inode
+		setfattr -h -n $nsp.name3 -v 0xdeface $testdir/$inode
 
 		echo "*** fetch several attribute names and values (hex)"
-		getfattr -m $nsp -e hex $SCRATCH_MNT/$inode
+		getfattr -m $nsp -e hex $testdir/$inode
 
 		echo "*** fetch several attribute names and values (base64)"
-		getfattr -m $nsp -e base64 $SCRATCH_MNT/$inode
+		getfattr -m $nsp -e base64 $testdir/$inode
 		
 		echo "*** shrink value of an existing attribute"
-		setfattr -h -n $nsp.name2 -v 0xdeaf $SCRATCH_MNT/$inode
-		getfattr -m $nsp -e hex $SCRATCH_MNT/$inode
+		setfattr -h -n $nsp.name2 -v 0xdeaf $testdir/$inode
+		getfattr -m $nsp -e hex $testdir/$inode
 
 		echo "*** grow value of existing attribute"
-		setfattr -h -n $nsp.name2 -v 0xdecade $SCRATCH_MNT/$inode
-		getfattr -m $nsp -e hex $SCRATCH_MNT/$inode
+		setfattr -h -n $nsp.name2 -v 0xdecade $testdir/$inode
+		getfattr -m $nsp -e hex $testdir/$inode
 		
 		echo "*** set an empty value for second attribute"
-		setfattr -h -n $nsp.name2 $SCRATCH_MNT/$inode
-		getfattr -m $nsp -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter
+		setfattr -h -n $nsp.name2 $testdir/$inode
+		getfattr -m $nsp -n $nsp.name2 $testdir/$inode 2>&1 | invalid_attribute_filter
 
 		echo "*** overwrite empty value"
-		setfattr -h -n $nsp.name2 -v 0xcafe $SCRATCH_MNT/$inode
-		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter
+		setfattr -h -n $nsp.name2 -v 0xcafe $testdir/$inode
+		getfattr -m $nsp -e hex -n $nsp.name2 $testdir/$inode 2>&1 | invalid_attribute_filter
 
 		echo "*** remove attribute"
-		setfattr -h -x $nsp.name2 $SCRATCH_MNT/$inode
-		getfattr -m $nsp -e hex -n $nsp.name2 $SCRATCH_MNT/$inode 2>&1 | invalid_attribute_filter
+		setfattr -h -x $nsp.name2 $testdir/$inode
+		getfattr -m $nsp -e hex -n $nsp.name2 $testdir/$inode 2>&1 | invalid_attribute_filter
 
 		echo "*** final list (strings, type=$inode, nsp=$nsp)"
-		getfattr -m '.' -e hex $SCRATCH_MNT/$inode
+		getfattr -m '.' -e hex $testdir/$inode
 	
 	done
 done
@@ -149,27 +148,27 @@ _extend_test_bed()
 {
 	echo "*** extend test bed"
 	# must set some descents' attributes to be useful
-	mkdir -p $SCRATCH_MNT/here/up/ascend
-	mkdir -p $SCRATCH_MNT/descend/down/here
-	find $SCRATCH_MNT/descend | xargs setfattr -n user.x -v yz
-	find $SCRATCH_MNT/descend | xargs setfattr -n user.1 -v 23
-	find $SCRATCH_MNT/here | xargs setfattr -n trusted.a -v bc
-	find $SCRATCH_MNT/here | xargs setfattr -n trusted.9 -v 87
+	mkdir -p $testdir/here/up/ascend
+	mkdir -p $testdir/descend/down/here
+	find $testdir/descend | xargs setfattr -n user.x -v yz
+	find $testdir/descend | xargs setfattr -n user.1 -v 23
+	find $testdir/here | xargs setfattr -n trusted.a -v bc
+	find $testdir/here | xargs setfattr -n trusted.9 -v 87
 	# whack a symlink in the middle, just to be difficult
-	ln -s $SCRATCH_MNT/here/up $SCRATCH_MNT/descend/and
+	ln -s $testdir/here/up $testdir/descend/and
 	# dump out our new starting point
-	find $SCRATCH_MNT | LC_COLLATE=POSIX sort | _filter_scratch | grep -v "lost+found"
+	find $testdir | LC_COLLATE=POSIX sort | _filter_test_dir | grep -v "lost+found"
 }
 
 _extend_test_bed
 
 echo
 echo "*** directory descent with us following symlinks"
-getfattr -h -L -R -m '.' -e hex $SCRATCH_MNT | _sort_getfattr_output
+getfattr -h -L -R -m '.' -e hex $testdir | _sort_getfattr_output
 
 echo
 echo "*** directory descent without following symlinks"
-getfattr -h -P -R -m '.' -e hex $SCRATCH_MNT | _sort_getfattr_output
+getfattr -h -P -R -m '.' -e hex $testdir | _sort_getfattr_output
 
 # 
 # Test the backup/restore code
@@ -179,7 +178,7 @@ echo; echo
 _backup()
 {
 	# NB: no filtering of scratch here... (need to restore too)
-	$GETFATTR_PROG --absolute-names -dh -R -m '.' $SCRATCH_MNT >$1
+	$GETFATTR_PROG --absolute-names -dh -R -m '.' $testdir >$1
 	echo BACKUP $1 >>$seqres.full
 	cat $1 >> $seqres.full
 	[ ! -s $1 ] && echo "warning: $1 (backup file) is empty"
@@ -188,10 +187,10 @@ _backup()
 echo "*** backup everything"
 _backup $tmp.backup1
 
-echo "*** clear out the scratch device"
-rm -fr $SCRATCH_MNT/*
+echo "*** clear out the test dir"
+rm -fr $testdir/*
 echo "AFTER REMOVE" >>$seqres.full
-getfattr -L -R -m '.' $SCRATCH_MNT >>$seqres.full
+getfattr -L -R -m '.' $testdir >>$seqres.full
 
 echo "*** reset test bed with no extended attributes"
 _create_test_bed
@@ -202,7 +201,7 @@ setfattr -h --restore=$tmp.backup1
 _backup $tmp.backup2
 
 echo "AFTER RESTORE" >>$seqres.full
-getfattr -L -R -m '.' $SCRATCH_MNT >>$seqres.full
+getfattr -L -R -m '.' $testdir >>$seqres.full
 
 echo "*** compare before and after backups"
 diff $tmp.backup1 $tmp.backup2
diff --git a/tests/generic/062.out b/tests/generic/062.out
index 8cc3c65..042e6e0 100644
--- a/tests/generic/062.out
+++ b/tests/generic/062.out
@@ -1,57 +1,57 @@
 QA output created by 062
 *** create test bed
-SCRATCH_MNT
-SCRATCH_MNT/dev
-SCRATCH_MNT/dev/b
-SCRATCH_MNT/dev/c
-SCRATCH_MNT/dev/p
-SCRATCH_MNT/dir
-SCRATCH_MNT/lnk
-SCRATCH_MNT/reg
+TEST_DIR/attr062
+TEST_DIR/attr062/dev
+TEST_DIR/attr062/dev/b
+TEST_DIR/attr062/dev/c
+TEST_DIR/attr062/dev/p
+TEST_DIR/attr062/dir
+TEST_DIR/attr062/lnk
+TEST_DIR/attr062/reg
 
 === TYPE reg; NAMESPACE user
 
 *** set/get one initially empty attribute
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 user.name
 
 *** overwrite empty, set several new attributes
 *** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 user.name=0xbabe
 user.name2=0xdeadbeef
 user.name3=0xdeface
 
 *** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 user.name=0sur4=
 user.name2=0s3q2+7w==
 user.name3=0s3vrO
 
 *** shrink value of an existing attribute
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 user.name=0xbabe
 user.name2=0xdeaf
 user.name3=0xdeface
 
 *** grow value of existing attribute
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 user.name=0xbabe
 user.name2=0xdecade
 user.name3=0xdeface
 
 *** set an empty value for second attribute
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 user.name2
 
 *** overwrite empty value
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 user.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/reg: user.name2: No such attribute or operation not permitted
+TEST_DIR/attr062/reg: user.name2: No such attribute or operation not permitted
 *** final list (strings, type=reg, nsp=user)
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 user.name=0xbabe
 user.name3=0xdeface
 
@@ -59,46 +59,46 @@ user.name3=0xdeface
 === TYPE dir; NAMESPACE user
 
 *** set/get one initially empty attribute
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 user.name
 
 *** overwrite empty, set several new attributes
 *** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 user.name=0xbabe
 user.name2=0xdeadbeef
 user.name3=0xdeface
 
 *** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 user.name=0sur4=
 user.name2=0s3q2+7w==
 user.name3=0s3vrO
 
 *** shrink value of an existing attribute
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 user.name=0xbabe
 user.name2=0xdeaf
 user.name3=0xdeface
 
 *** grow value of existing attribute
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 user.name=0xbabe
 user.name2=0xdecade
 user.name3=0xdeface
 
 *** set an empty value for second attribute
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 user.name2
 
 *** overwrite empty value
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 user.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/dir: user.name2: No such attribute or operation not permitted
+TEST_DIR/attr062/dir: user.name2: No such attribute or operation not permitted
 *** final list (strings, type=dir, nsp=user)
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 user.name=0xbabe
 user.name3=0xdeface
 
@@ -106,146 +106,146 @@ user.name3=0xdeface
 === TYPE lnk; NAMESPACE user
 
 *** set/get one initially empty attribute
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
+setfattr: TEST_DIR/attr062/lnk: Operation not permitted
 *** overwrite empty, set several new attributes
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
+setfattr: TEST_DIR/attr062/lnk: Operation not permitted
+setfattr: TEST_DIR/attr062/lnk: Operation not permitted
+setfattr: TEST_DIR/attr062/lnk: Operation not permitted
 *** fetch several attribute names and values (hex)
 *** fetch several attribute names and values (base64)
 *** shrink value of an existing attribute
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
+setfattr: TEST_DIR/attr062/lnk: Operation not permitted
 *** grow value of existing attribute
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
+setfattr: TEST_DIR/attr062/lnk: Operation not permitted
 *** set an empty value for second attribute
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-SCRATCH_MNT/lnk: user.name2: No such attribute or operation not permitted
+setfattr: TEST_DIR/attr062/lnk: Operation not permitted
+TEST_DIR/attr062/lnk: user.name2: No such attribute or operation not permitted
 *** overwrite empty value
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-SCRATCH_MNT/lnk: user.name2: No such attribute or operation not permitted
+setfattr: TEST_DIR/attr062/lnk: Operation not permitted
+TEST_DIR/attr062/lnk: user.name2: No such attribute or operation not permitted
 *** remove attribute
-setfattr: SCRATCH_MNT/lnk: Operation not permitted
-SCRATCH_MNT/lnk: user.name2: No such attribute or operation not permitted
+setfattr: TEST_DIR/attr062/lnk: Operation not permitted
+TEST_DIR/attr062/lnk: user.name2: No such attribute or operation not permitted
 *** final list (strings, type=lnk, nsp=user)
 
 === TYPE dev/b; NAMESPACE user
 
 *** set/get one initially empty attribute
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/b: Operation not permitted
 *** overwrite empty, set several new attributes
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/b: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/b: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/b: Operation not permitted
 *** fetch several attribute names and values (hex)
 *** fetch several attribute names and values (base64)
 *** shrink value of an existing attribute
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/b: Operation not permitted
 *** grow value of existing attribute
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/b: Operation not permitted
 *** set an empty value for second attribute
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-SCRATCH_MNT/dev/b: user.name2: No such attribute or operation not permitted
+setfattr: TEST_DIR/attr062/dev/b: Operation not permitted
+TEST_DIR/attr062/dev/b: user.name2: No such attribute or operation not permitted
 *** overwrite empty value
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-SCRATCH_MNT/dev/b: user.name2: No such attribute or operation not permitted
+setfattr: TEST_DIR/attr062/dev/b: Operation not permitted
+TEST_DIR/attr062/dev/b: user.name2: No such attribute or operation not permitted
 *** remove attribute
-setfattr: SCRATCH_MNT/dev/b: Operation not permitted
-SCRATCH_MNT/dev/b: user.name2: No such attribute or operation not permitted
+setfattr: TEST_DIR/attr062/dev/b: Operation not permitted
+TEST_DIR/attr062/dev/b: user.name2: No such attribute or operation not permitted
 *** final list (strings, type=dev/b, nsp=user)
 
 === TYPE dev/c; NAMESPACE user
 
 *** set/get one initially empty attribute
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/c: Operation not permitted
 *** overwrite empty, set several new attributes
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/c: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/c: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/c: Operation not permitted
 *** fetch several attribute names and values (hex)
 *** fetch several attribute names and values (base64)
 *** shrink value of an existing attribute
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/c: Operation not permitted
 *** grow value of existing attribute
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/c: Operation not permitted
 *** set an empty value for second attribute
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-SCRATCH_MNT/dev/c: user.name2: No such attribute or operation not permitted
+setfattr: TEST_DIR/attr062/dev/c: Operation not permitted
+TEST_DIR/attr062/dev/c: user.name2: No such attribute or operation not permitted
 *** overwrite empty value
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-SCRATCH_MNT/dev/c: user.name2: No such attribute or operation not permitted
+setfattr: TEST_DIR/attr062/dev/c: Operation not permitted
+TEST_DIR/attr062/dev/c: user.name2: No such attribute or operation not permitted
 *** remove attribute
-setfattr: SCRATCH_MNT/dev/c: Operation not permitted
-SCRATCH_MNT/dev/c: user.name2: No such attribute or operation not permitted
+setfattr: TEST_DIR/attr062/dev/c: Operation not permitted
+TEST_DIR/attr062/dev/c: user.name2: No such attribute or operation not permitted
 *** final list (strings, type=dev/c, nsp=user)
 
 === TYPE dev/p; NAMESPACE user
 
 *** set/get one initially empty attribute
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/p: Operation not permitted
 *** overwrite empty, set several new attributes
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/p: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/p: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/p: Operation not permitted
 *** fetch several attribute names and values (hex)
 *** fetch several attribute names and values (base64)
 *** shrink value of an existing attribute
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/p: Operation not permitted
 *** grow value of existing attribute
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
+setfattr: TEST_DIR/attr062/dev/p: Operation not permitted
 *** set an empty value for second attribute
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-SCRATCH_MNT/dev/p: user.name2: No such attribute or operation not permitted
+setfattr: TEST_DIR/attr062/dev/p: Operation not permitted
+TEST_DIR/attr062/dev/p: user.name2: No such attribute or operation not permitted
 *** overwrite empty value
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-SCRATCH_MNT/dev/p: user.name2: No such attribute or operation not permitted
+setfattr: TEST_DIR/attr062/dev/p: Operation not permitted
+TEST_DIR/attr062/dev/p: user.name2: No such attribute or operation not permitted
 *** remove attribute
-setfattr: SCRATCH_MNT/dev/p: Operation not permitted
-SCRATCH_MNT/dev/p: user.name2: No such attribute or operation not permitted
+setfattr: TEST_DIR/attr062/dev/p: Operation not permitted
+TEST_DIR/attr062/dev/p: user.name2: No such attribute or operation not permitted
 *** final list (strings, type=dev/p, nsp=user)
 
 === TYPE reg; NAMESPACE trusted
 
 *** set/get one initially empty attribute
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 trusted.name
 
 *** overwrite empty, set several new attributes
 *** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 trusted.name=0xbabe
 trusted.name2=0xdeadbeef
 trusted.name3=0xdeface
 
 *** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 trusted.name=0sur4=
 trusted.name2=0s3q2+7w==
 trusted.name3=0s3vrO
 
 *** shrink value of an existing attribute
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 trusted.name=0xbabe
 trusted.name2=0xdeaf
 trusted.name3=0xdeface
 
 *** grow value of existing attribute
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 trusted.name=0xbabe
 trusted.name2=0xdecade
 trusted.name3=0xdeface
 
 *** set an empty value for second attribute
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 trusted.name2
 
 *** overwrite empty value
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 trusted.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/reg: trusted.name2: No such attribute or operation not permitted
+TEST_DIR/attr062/reg: trusted.name2: No such attribute or operation not permitted
 *** final list (strings, type=reg, nsp=trusted)
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 trusted.name=0xbabe
 trusted.name3=0xdeface
 user.name=0xbabe
@@ -255,46 +255,46 @@ user.name3=0xdeface
 === TYPE dir; NAMESPACE trusted
 
 *** set/get one initially empty attribute
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 trusted.name
 
 *** overwrite empty, set several new attributes
 *** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 trusted.name=0xbabe
 trusted.name2=0xdeadbeef
 trusted.name3=0xdeface
 
 *** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 trusted.name=0sur4=
 trusted.name2=0s3q2+7w==
 trusted.name3=0s3vrO
 
 *** shrink value of an existing attribute
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 trusted.name=0xbabe
 trusted.name2=0xdeaf
 trusted.name3=0xdeface
 
 *** grow value of existing attribute
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 trusted.name=0xbabe
 trusted.name2=0xdecade
 trusted.name3=0xdeface
 
 *** set an empty value for second attribute
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 trusted.name2
 
 *** overwrite empty value
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 trusted.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/dir: trusted.name2: No such attribute or operation not permitted
+TEST_DIR/attr062/dir: trusted.name2: No such attribute or operation not permitted
 *** final list (strings, type=dir, nsp=trusted)
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 trusted.name=0xbabe
 trusted.name3=0xdeface
 user.name=0xbabe
@@ -304,46 +304,46 @@ user.name3=0xdeface
 === TYPE lnk; NAMESPACE trusted
 
 *** set/get one initially empty attribute
-# file: SCRATCH_MNT/lnk
+# file: TEST_DIR/attr062/lnk
 trusted.name
 
 *** overwrite empty, set several new attributes
 *** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/lnk
+# file: TEST_DIR/attr062/lnk
 trusted.name=0xbabe
 trusted.name2=0xdeadbeef
 trusted.name3=0xdeface
 
 *** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/lnk
+# file: TEST_DIR/attr062/lnk
 trusted.name=0sur4=
 trusted.name2=0s3q2+7w==
 trusted.name3=0s3vrO
 
 *** shrink value of an existing attribute
-# file: SCRATCH_MNT/lnk
+# file: TEST_DIR/attr062/lnk
 trusted.name=0xbabe
 trusted.name2=0xdeaf
 trusted.name3=0xdeface
 
 *** grow value of existing attribute
-# file: SCRATCH_MNT/lnk
+# file: TEST_DIR/attr062/lnk
 trusted.name=0xbabe
 trusted.name2=0xdecade
 trusted.name3=0xdeface
 
 *** set an empty value for second attribute
-# file: SCRATCH_MNT/lnk
+# file: TEST_DIR/attr062/lnk
 trusted.name2
 
 *** overwrite empty value
-# file: SCRATCH_MNT/lnk
+# file: TEST_DIR/attr062/lnk
 trusted.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/lnk: trusted.name2: No such attribute or operation not permitted
+TEST_DIR/attr062/lnk: trusted.name2: No such attribute or operation not permitted
 *** final list (strings, type=lnk, nsp=trusted)
-# file: SCRATCH_MNT/lnk
+# file: TEST_DIR/attr062/lnk
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
@@ -351,46 +351,46 @@ trusted.name3=0xdeface
 === TYPE dev/b; NAMESPACE trusted
 
 *** set/get one initially empty attribute
-# file: SCRATCH_MNT/dev/b
+# file: TEST_DIR/attr062/dev/b
 trusted.name
 
 *** overwrite empty, set several new attributes
 *** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/dev/b
+# file: TEST_DIR/attr062/dev/b
 trusted.name=0xbabe
 trusted.name2=0xdeadbeef
 trusted.name3=0xdeface
 
 *** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/dev/b
+# file: TEST_DIR/attr062/dev/b
 trusted.name=0sur4=
 trusted.name2=0s3q2+7w==
 trusted.name3=0s3vrO
 
 *** shrink value of an existing attribute
-# file: SCRATCH_MNT/dev/b
+# file: TEST_DIR/attr062/dev/b
 trusted.name=0xbabe
 trusted.name2=0xdeaf
 trusted.name3=0xdeface
 
 *** grow value of existing attribute
-# file: SCRATCH_MNT/dev/b
+# file: TEST_DIR/attr062/dev/b
 trusted.name=0xbabe
 trusted.name2=0xdecade
 trusted.name3=0xdeface
 
 *** set an empty value for second attribute
-# file: SCRATCH_MNT/dev/b
+# file: TEST_DIR/attr062/dev/b
 trusted.name2
 
 *** overwrite empty value
-# file: SCRATCH_MNT/dev/b
+# file: TEST_DIR/attr062/dev/b
 trusted.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/dev/b: trusted.name2: No such attribute or operation not permitted
+TEST_DIR/attr062/dev/b: trusted.name2: No such attribute or operation not permitted
 *** final list (strings, type=dev/b, nsp=trusted)
-# file: SCRATCH_MNT/dev/b
+# file: TEST_DIR/attr062/dev/b
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
@@ -398,46 +398,46 @@ trusted.name3=0xdeface
 === TYPE dev/c; NAMESPACE trusted
 
 *** set/get one initially empty attribute
-# file: SCRATCH_MNT/dev/c
+# file: TEST_DIR/attr062/dev/c
 trusted.name
 
 *** overwrite empty, set several new attributes
 *** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/dev/c
+# file: TEST_DIR/attr062/dev/c
 trusted.name=0xbabe
 trusted.name2=0xdeadbeef
 trusted.name3=0xdeface
 
 *** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/dev/c
+# file: TEST_DIR/attr062/dev/c
 trusted.name=0sur4=
 trusted.name2=0s3q2+7w==
 trusted.name3=0s3vrO
 
 *** shrink value of an existing attribute
-# file: SCRATCH_MNT/dev/c
+# file: TEST_DIR/attr062/dev/c
 trusted.name=0xbabe
 trusted.name2=0xdeaf
 trusted.name3=0xdeface
 
 *** grow value of existing attribute
-# file: SCRATCH_MNT/dev/c
+# file: TEST_DIR/attr062/dev/c
 trusted.name=0xbabe
 trusted.name2=0xdecade
 trusted.name3=0xdeface
 
 *** set an empty value for second attribute
-# file: SCRATCH_MNT/dev/c
+# file: TEST_DIR/attr062/dev/c
 trusted.name2
 
 *** overwrite empty value
-# file: SCRATCH_MNT/dev/c
+# file: TEST_DIR/attr062/dev/c
 trusted.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/dev/c: trusted.name2: No such attribute or operation not permitted
+TEST_DIR/attr062/dev/c: trusted.name2: No such attribute or operation not permitted
 *** final list (strings, type=dev/c, nsp=trusted)
-# file: SCRATCH_MNT/dev/c
+# file: TEST_DIR/attr062/dev/c
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
@@ -445,120 +445,120 @@ trusted.name3=0xdeface
 === TYPE dev/p; NAMESPACE trusted
 
 *** set/get one initially empty attribute
-# file: SCRATCH_MNT/dev/p
+# file: TEST_DIR/attr062/dev/p
 trusted.name
 
 *** overwrite empty, set several new attributes
 *** fetch several attribute names and values (hex)
-# file: SCRATCH_MNT/dev/p
+# file: TEST_DIR/attr062/dev/p
 trusted.name=0xbabe
 trusted.name2=0xdeadbeef
 trusted.name3=0xdeface
 
 *** fetch several attribute names and values (base64)
-# file: SCRATCH_MNT/dev/p
+# file: TEST_DIR/attr062/dev/p
 trusted.name=0sur4=
 trusted.name2=0s3q2+7w==
 trusted.name3=0s3vrO
 
 *** shrink value of an existing attribute
-# file: SCRATCH_MNT/dev/p
+# file: TEST_DIR/attr062/dev/p
 trusted.name=0xbabe
 trusted.name2=0xdeaf
 trusted.name3=0xdeface
 
 *** grow value of existing attribute
-# file: SCRATCH_MNT/dev/p
+# file: TEST_DIR/attr062/dev/p
 trusted.name=0xbabe
 trusted.name2=0xdecade
 trusted.name3=0xdeface
 
 *** set an empty value for second attribute
-# file: SCRATCH_MNT/dev/p
+# file: TEST_DIR/attr062/dev/p
 trusted.name2
 
 *** overwrite empty value
-# file: SCRATCH_MNT/dev/p
+# file: TEST_DIR/attr062/dev/p
 trusted.name2=0xcafe
 
 *** remove attribute
-SCRATCH_MNT/dev/p: trusted.name2: No such attribute or operation not permitted
+TEST_DIR/attr062/dev/p: trusted.name2: No such attribute or operation not permitted
 *** final list (strings, type=dev/p, nsp=trusted)
-# file: SCRATCH_MNT/dev/p
+# file: TEST_DIR/attr062/dev/p
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
 
 
 *** extend test bed
-SCRATCH_MNT
-SCRATCH_MNT/descend
-SCRATCH_MNT/descend/and
-SCRATCH_MNT/descend/down
-SCRATCH_MNT/descend/down/here
-SCRATCH_MNT/dev
-SCRATCH_MNT/dev/b
-SCRATCH_MNT/dev/c
-SCRATCH_MNT/dev/p
-SCRATCH_MNT/dir
-SCRATCH_MNT/here
-SCRATCH_MNT/here/up
-SCRATCH_MNT/here/up/ascend
-SCRATCH_MNT/lnk
-SCRATCH_MNT/reg
+TEST_DIR/attr062
+TEST_DIR/attr062/descend
+TEST_DIR/attr062/descend/and
+TEST_DIR/attr062/descend/down
+TEST_DIR/attr062/descend/down/here
+TEST_DIR/attr062/dev
+TEST_DIR/attr062/dev/b
+TEST_DIR/attr062/dev/c
+TEST_DIR/attr062/dev/p
+TEST_DIR/attr062/dir
+TEST_DIR/attr062/here
+TEST_DIR/attr062/here/up
+TEST_DIR/attr062/here/up/ascend
+TEST_DIR/attr062/lnk
+TEST_DIR/attr062/reg
 
 *** directory descent with us following symlinks
-# file: SCRATCH_MNT/descend
+# file: TEST_DIR/attr062/descend
 user.1=0x3233
 user.x=0x797a
 
-# file: SCRATCH_MNT/descend/and/ascend
+# file: TEST_DIR/attr062/descend/and/ascend
 trusted.9=0x3837
 trusted.a=0x6263
 
-# file: SCRATCH_MNT/descend/down
+# file: TEST_DIR/attr062/descend/down
 user.1=0x3233
 user.x=0x797a
 
-# file: SCRATCH_MNT/descend/down/here
+# file: TEST_DIR/attr062/descend/down/here
 user.1=0x3233
 user.x=0x797a
 
-# file: SCRATCH_MNT/dev/b
+# file: TEST_DIR/attr062/dev/b
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
-# file: SCRATCH_MNT/dev/c
+# file: TEST_DIR/attr062/dev/c
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
-# file: SCRATCH_MNT/dev/p
+# file: TEST_DIR/attr062/dev/p
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 trusted.name=0xbabe
 trusted.name3=0xdeface
 user.name=0xbabe
 user.name3=0xdeface
 
-# file: SCRATCH_MNT/here
+# file: TEST_DIR/attr062/here
 trusted.9=0x3837
 trusted.a=0x6263
 
-# file: SCRATCH_MNT/here/up
+# file: TEST_DIR/attr062/here/up
 trusted.9=0x3837
 trusted.a=0x6263
 
-# file: SCRATCH_MNT/here/up/ascend
+# file: TEST_DIR/attr062/here/up/ascend
 trusted.9=0x3837
 trusted.a=0x6263
 
-# file: SCRATCH_MNT/lnk
+# file: TEST_DIR/attr062/lnk
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 trusted.name=0xbabe
 trusted.name3=0xdeface
 user.name=0xbabe
@@ -566,53 +566,53 @@ user.name3=0xdeface
 
 
 *** directory descent without following symlinks
-# file: SCRATCH_MNT/descend
+# file: TEST_DIR/attr062/descend
 user.1=0x3233
 user.x=0x797a
 
-# file: SCRATCH_MNT/descend/down
+# file: TEST_DIR/attr062/descend/down
 user.1=0x3233
 user.x=0x797a
 
-# file: SCRATCH_MNT/descend/down/here
+# file: TEST_DIR/attr062/descend/down/here
 user.1=0x3233
 user.x=0x797a
 
-# file: SCRATCH_MNT/dev/b
+# file: TEST_DIR/attr062/dev/b
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
-# file: SCRATCH_MNT/dev/c
+# file: TEST_DIR/attr062/dev/c
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
-# file: SCRATCH_MNT/dev/p
+# file: TEST_DIR/attr062/dev/p
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
-# file: SCRATCH_MNT/dir
+# file: TEST_DIR/attr062/dir
 trusted.name=0xbabe
 trusted.name3=0xdeface
 user.name=0xbabe
 user.name3=0xdeface
 
-# file: SCRATCH_MNT/here
+# file: TEST_DIR/attr062/here
 trusted.9=0x3837
 trusted.a=0x6263
 
-# file: SCRATCH_MNT/here/up
+# file: TEST_DIR/attr062/here/up
 trusted.9=0x3837
 trusted.a=0x6263
 
-# file: SCRATCH_MNT/here/up/ascend
+# file: TEST_DIR/attr062/here/up/ascend
 trusted.9=0x3837
 trusted.a=0x6263
 
-# file: SCRATCH_MNT/lnk
+# file: TEST_DIR/attr062/lnk
 trusted.name=0xbabe
 trusted.name3=0xdeface
 
-# file: SCRATCH_MNT/reg
+# file: TEST_DIR/attr062/reg
 trusted.name=0xbabe
 trusted.name3=0xdeface
 user.name=0xbabe
@@ -621,33 +621,33 @@ user.name3=0xdeface
 
 
 *** backup everything
-*** clear out the scratch device
+*** clear out the test dir
 *** reset test bed with no extended attributes
 *** create test bed
-SCRATCH_MNT
-SCRATCH_MNT/dev
-SCRATCH_MNT/dev/b
-SCRATCH_MNT/dev/c
-SCRATCH_MNT/dev/p
-SCRATCH_MNT/dir
-SCRATCH_MNT/lnk
-SCRATCH_MNT/reg
+TEST_DIR/attr062
+TEST_DIR/attr062/dev
+TEST_DIR/attr062/dev/b
+TEST_DIR/attr062/dev/c
+TEST_DIR/attr062/dev/p
+TEST_DIR/attr062/dir
+TEST_DIR/attr062/lnk
+TEST_DIR/attr062/reg
 *** extend test bed
-SCRATCH_MNT
-SCRATCH_MNT/descend
-SCRATCH_MNT/descend/and
-SCRATCH_MNT/descend/down
-SCRATCH_MNT/descend/down/here
-SCRATCH_MNT/dev
-SCRATCH_MNT/dev/b
-SCRATCH_MNT/dev/c
-SCRATCH_MNT/dev/p
-SCRATCH_MNT/dir
-SCRATCH_MNT/here
-SCRATCH_MNT/here/up
-SCRATCH_MNT/here/up/ascend
-SCRATCH_MNT/lnk
-SCRATCH_MNT/reg
+TEST_DIR/attr062
+TEST_DIR/attr062/descend
+TEST_DIR/attr062/descend/and
+TEST_DIR/attr062/descend/down
+TEST_DIR/attr062/descend/down/here
+TEST_DIR/attr062/dev
+TEST_DIR/attr062/dev/b
+TEST_DIR/attr062/dev/c
+TEST_DIR/attr062/dev/p
+TEST_DIR/attr062/dir
+TEST_DIR/attr062/here
+TEST_DIR/attr062/here/up
+TEST_DIR/attr062/here/up/ascend
+TEST_DIR/attr062/lnk
+TEST_DIR/attr062/reg
 *** restore everything
 *** compare before and after backups
 
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
