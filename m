Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 871AA7FEF
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 14:46:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD531AC005
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 12:46:41 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Igd7gJE3RS5Ahzuc (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 07 Nov 2013 12:46:36 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VeWTL-0005yb-TG
	for xfs@oss.sgi.com; Thu, 07 Nov 2013 20:46:35 +0000
Date: Thu, 7 Nov 2013 12:46:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: stop special casing nfs and udf
Message-ID: <20131107204635.GA22954@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

For historical reasons beyond my knowledge xfstests tries to abuse the
scratch device as test device for nfs and udf.  Because not all test
have inherited the right usage of the _setup_testdir and _cleanup_testdir
helpers this leads to lots of unessecary test failures.

Remove the special casing, which gets nfs down to a minimal number of
failures.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/common/rc b/common/rc
index ea3af12..c64933a 100644
--- a/common/rc
+++ b/common/rc
@@ -975,11 +975,7 @@ _require_scratch()
 {
     case "$FSTYP" in
 	nfs*)
-		 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
-		 if [ -z "$SCRATCH_DEV" -o "$?" != "0" ]
-		 then
-		     _notrun "this test requires a valid \$SCRATCH_DEV"
-		 fi
+                 _notrun "requires a scratch device"
 		 ;;
 	*)
 		 if [ -z "$SCRATCH_DEV" -o "`_is_block_dev $SCRATCH_DEV`" = "" ]
@@ -1773,100 +1769,6 @@ _full_platform_details()
      echo "$os/$platform $host $kernel"
 }
 
-_setup_udf_scratchdir()
-{
-    [ "$FSTYP" != "udf" ] \
-	&& _fail "setup_udf_testdir: \$FSTYP is not udf"
-    [ -z "$SCRATCH_DEV" -o ! -b "$SCRATCH_DEV" ] \
-	&& _notrun "this test requires a valid \$SCRATCH_DEV"
-    [ -z "$SCRATCH_MNT" ] \
-	&& _notrun "this test requires a valid \$SCRATCH_MNT"
-
-    # mounted?
-    if _mount | grep -q $SCRATCH_DEV
-    then
-        # if it's mounted, make sure its on $TEST_RW_DIR
-        if ! _mount | grep $SCRATCH_DEV | grep -q $SCRATCH_MNT
-        then
-            _fail "\$SCRATCH_DEV is mounted but not on \$SCRATCH_MNT - aborting"
-        fi
-    	$UMOUNT_PROG $SCRATCH_DEV
-    fi
-
-    _scratch_mkfs
-    _scratch_mount
-
-    testdir=$SCRATCH_MNT
-}
-
-_setup_nfs_scratchdir()
-{
-    [ "$FSTYP" != "nfs" ] \
-	&& _fail "setup_nfs_testdir: \$FSTYP is not nfs"
-    [ -z "$SCRATCH_DEV" ] \
-	&& _notrun "this test requires a valid host fs for \$SCRATCH_DEV"
-    [ -z "$SCRATCH_MNT" ] \
-	&& _notrun "this test requires a valid \$SCRATCH_MNT"
-
-    # mounted?
-    if _mount | grep -q $SCRATCH_DEV
-    then
-        # if it's mounted, make sure its on $SCRATCH_MNT
-        if ! _mount | grep $SCRATCH_DEV | grep -q $SCRATCH_MNT
-        then
-            _fail "\$SCRATCH_DEV is mounted but not on \$SCRATCH_MNT - aborting"
-        fi
-    	$UMOUNT_PROG $SCRATCH_DEV
-    fi
-
-    _scratch_mkfs
-    _scratch_mount
-
-    testdir=$SCRATCH_MNT
-}
-
-#
-# Warning for UDF and NFS:
-# this function calls _setup_udf_scratchdir and _setup_udf_scratchdir
-# which actually uses the scratch dir for the test dir.
-#
-# This was done because testdir was intended to be a persistent
-# XFS only partition.  This should eventually change, and treat
-# at least local filesystems all the same.
-#
-_setup_testdir()
-{
-    case $FSTYP in
-    udf)
-	_setup_udf_scratchdir
-	;;
-    nfs*)
-	_setup_nfs_scratchdir
-	;;
-    *)
-	testdir=$TEST_DIR
-	;;
-    esac
-}
-
-_cleanup_testdir()
-{
-    case $FSTYP in
-    udf)
-	# umount testdir as it is $SCRATCH_MNT which could be used by xfs next
-	[ -n "$testdir" ] && $UMOUNT_PROG $testdir
-	;;
-    nfs*)
-	# umount testdir as it is $SCRATCH_MNT which could be used by xfs next
-	[ -n "$testdir" ] && $UMOUNT_PROG $testdir
-	;;
-    *)
-	# do nothing, testdir is $TEST_DIR
-	:
-	;;
-    esac
-}
-
 _link_out_file()
 {
 	if [ -z "$1" -o -z "$2" ]; then
diff --git a/tests/btrfs/005 b/tests/btrfs/005
index 81badf6..c364e11 100755
--- a/tests/btrfs/005
+++ b/tests/btrfs/005
@@ -135,7 +135,6 @@ _rundefrag()
 _supported_fs btrfs
 _supported_os Linux
 
-_setup_testdir
 ## We require scratch so that we'll have free contiguous space
 _require_scratch
 _scratch_mkfs >/dev/null 2>&1
diff --git a/tests/btrfs/014 b/tests/btrfs/014
index a49cf06..aa3edbb 100755
--- a/tests/btrfs/014
+++ b/tests/btrfs/014
@@ -54,7 +54,6 @@ _balance()
 _supported_fs btrfs
 _supported_os Linux
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/generic/001 b/tests/generic/001
index aa82441..6e5f3dd 100755
--- a/tests/generic/001
+++ b/tests/generic/001
@@ -118,14 +118,14 @@ udf_fsize=20240		# number of sectors for UDF
 
 _setup()
 {
-    if mkdir -p $testdir/$$
+    if mkdir -p $TEST_DIR/$$
     then
 	:
     else
-	echo "Error: cannot mkdir \"$testdir/$$\""
+	echo "Error: cannot mkdir \"$TEST_DIR/$$\""
 	exit 1
     fi
-    cd $testdir/$$
+    cd $TEST_DIR/$$
 
     $verbose && echo -n "setup "
     sed -e '/^#/d' $tmp.config \
@@ -286,8 +286,7 @@ _cleanup()
     then
 	$verbose && echo "cleanup"
 	cd /
-	rm -rf $testdir/$$
-	_cleanup_testdir
+	rm -rf $TEST_DIR/$$
 	done_cleanup=true
     fi
 }
@@ -298,7 +297,6 @@ _cleanup
 status=1
 done_cleanup=false
 
-_setup_testdir
 _setup
 
 # do the test
diff --git a/tests/generic/002 b/tests/generic/002
index 2aeebb1..656d29f 100755
--- a/tests/generic/002
+++ b/tests/generic/002
@@ -38,43 +38,40 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     rm -f $tmp.*
-    _cleanup_testdir
 }
 
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
 
-_setup_testdir
-
 echo "Silence is goodness ..."
 
 # ensure target directory exists
-mkdir `dirname $testdir/$tmp` 2>/dev/null
+mkdir `dirname $TEST_DIR/$tmp` 2>/dev/null
 
-touch $testdir/$tmp.1
+touch $TEST_DIR/$tmp.1
 for l in 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
 do
-    ln $testdir/$tmp.1 $testdir/$tmp.$l
-    x=`src/lstat64 $testdir/$tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
+    ln $TEST_DIR/$tmp.1 $TEST_DIR/$tmp.$l
+    x=`src/lstat64 $TEST_DIR/$tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
     if [ "$l" -ne $x ]
     then
 	echo "Arrgh, created link #$l and lstat64 looks like ..."
-	src/lstat64 $testdir/$tmp.1
+	src/lstat64 $TEST_DIR/$tmp.1
 	status=1
     fi
 done
 
 for l in 20 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
 do
-    x=`src/lstat64 $testdir/$tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
+    x=`src/lstat64 $TEST_DIR/$tmp.1 | sed -n -e '/ Links: /s/.*Links: *//p'`
     if [ "$l" -ne $x ]
     then
 	echo "Arrgh, about to remove link #$l and lstat64 looks like ..."
-	src/lstat64 $testdir/$tmp.1
+	src/lstat64 $TEST_DIR/$tmp.1
 	status=1
     fi
-    rm -f $testdir/$tmp.$l
+    rm -f $TEST_DIR/$tmp.$l
 done
 
 # success, all done
diff --git a/tests/generic/005 b/tests/generic/005
index de68b0d..544af14 100755
--- a/tests/generic/005
+++ b/tests/generic/005
@@ -43,10 +43,9 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-    cd $testdir
+    cd $TEST_DIR
     rm -f symlink_{0,1,2,3,4}{0,1,2,3,4,5,6,7,8,9} symlink_self empty_file
     cd /
-    _cleanup_testdir
 }
 
 _touch()
@@ -75,9 +74,7 @@ else
     _supported_os Linux IRIX
 fi
 
-_setup_testdir
-
-cd $testdir
+cd $TEST_DIR
 
 o=empty_file
 touch $o
diff --git a/tests/generic/006 b/tests/generic/006
index 62cc0c8..481e1f1 100755
--- a/tests/generic/006
+++ b/tests/generic/006
@@ -35,8 +35,7 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    rm -rf $testdir/permname.$$
-    _cleanup_testdir
+    rm -rf $TEST_DIR/permname.$$
 }
 
 _count()
@@ -56,23 +55,21 @@ _count()
 _supported_fs generic
 _supported_os IRIX Linux
 
-_setup_testdir
-
-mkdir $testdir/permname.$$
+mkdir $TEST_DIR/permname.$$
 
 echo ""
 echo "single thread permname"
 echo "----------------------"
-mkdir $testdir/permname.$$/a
-cd $testdir/permname.$$/a
+mkdir $TEST_DIR/permname.$$/a
+cd $TEST_DIR/permname.$$/a
 $here/src/permname -c 4 -l 6 -p 1 || echo "permname returned $?"
 find . | _count
 
 echo ""
 echo "multi thread permname"
 echo "----------------------"
-mkdir $testdir/permname.$$/b
-cd $testdir/permname.$$/b
+mkdir $TEST_DIR/permname.$$/b
+cd $TEST_DIR/permname.$$/b
 $here/src/permname -c 4 -l 6 -p 4 || echo "permname returned $?"
 find . | _count
 
diff --git a/tests/generic/007 b/tests/generic/007
index 4947da6..abbee74 100755
--- a/tests/generic/007
+++ b/tests/generic/007
@@ -38,8 +38,7 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    rm -rf $testdir/$seq
-    _cleanup_testdir
+    rm -rf $TEST_DIR/$seq
 }
 
 # get standard environment, filters and checks
@@ -50,8 +49,6 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 
-_setup_testdir
-
 status=1 # default failure 
 sourcefile=$tmp.nametest
 seed=1
@@ -66,8 +63,8 @@ while [ $i -le $num_filenames ]; do
   let i=$i+1
 done
 
-mkdir $testdir/$seq
-cd $testdir/$seq
+mkdir $TEST_DIR/$seq
+cd $TEST_DIR/$seq
 $here/src/nametest -l $sourcefile -s $seed -i $iterations -z
 
 # success, all done
diff --git a/tests/generic/010 b/tests/generic/010
index 0bdfdd5..9d2e76a 100755
--- a/tests/generic/010
+++ b/tests/generic/010
@@ -35,8 +35,7 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    rm -f $testdir/DBtest*.{pag,dir}
-    _cleanup_testdir
+    rm -f $TEST_DIR/DBtest*.{pag,dir}
 }
 
 # filter random number output from dbtest
@@ -58,11 +57,9 @@ _filter_dbtest()
 _supported_fs generic
 _supported_os IRIX Linux
 
-_setup_testdir
-
 rm -f $seqres.full
 
-cd $testdir
+cd $TEST_DIR
 
 $here/src/dbtest -l 5 -n 1000 2>&1 | tee -a $seqres.full | _filter_dbtest
 
diff --git a/tests/generic/011 b/tests/generic/011
index cad09ed..bed23aa 100755
--- a/tests/generic/011
+++ b/tests/generic/011
@@ -37,7 +37,6 @@ _cleanup()
     cd /
     rm -f $tmp.*
     [ -n "$out" ] && rm -rf $out
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -48,9 +47,7 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 
-_setup_testdir
-
-out=$testdir/dirstress.$$
+out=$TEST_DIR/dirstress.$$
 
 rm -f $seqres.full
 
diff --git a/tests/generic/013 b/tests/generic/013
index f66cade..8e76d3d 100755
--- a/tests/generic/013
+++ b/tests/generic/013
@@ -41,8 +41,7 @@ _cleanup()
     # such that what it has is greater the 1024 chars and will
     # stop and complain - so get rid of complaint
     # Ref. pv#935754
-    rm -rf $testdir/fsstress.$$.* 2>&1 | grep -v 'Path too long'
-    _cleanup_testdir
+    rm -rf $TEST_DIR/fsstress.$$.* 2>&1 | grep -v 'Path too long'
 }
 
 _filesize()
@@ -60,7 +59,7 @@ _do_test()
     _param="$2"
     _count="$3"
 
-    out=$testdir/fsstress.$$.$_n
+    out=$TEST_DIR/fsstress.$$.$_n
     rm -rf $out
     if ! mkdir $out
     then
@@ -93,8 +92,6 @@ _do_test()
 _supported_fs generic
 _supported_os IRIX Linux
 
-_setup_testdir
-
 rm -f $seqres.full
 echo "brevity is wit..."
 
diff --git a/tests/generic/014 b/tests/generic/014
index d7da9ab..a9c2638 100755
--- a/tests/generic/014
+++ b/tests/generic/014
@@ -35,8 +35,7 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    rm -rf $testdir/truncfile.$$.*
-    _cleanup_testdir
+    rm -rf $TEST_DIR/truncfile.$$.*
 }
 
 # get standard environment, filters and checks
@@ -47,7 +46,6 @@ _supported_fs generic
 _supported_os IRIX Linux
 
 _require_sparse_files
-_setup_testdir
 
 # ensure EOF preallocation doesn't massively extend the runtime of this test
 # by limiting the amount of preallocation and therefore the amount of blocks
@@ -62,7 +60,7 @@ echo "brevity is wit..."
 echo "------"
 echo "test 1"
 echo "------"
-if ! src/truncfile -c 10000 $testdir/truncfile.$$.0 >$tmp.out 2>&1
+if ! src/truncfile -c 10000 $TEST_DIR/truncfile.$$.0 >$tmp.out 2>&1
 then
     out=`cat $tmp.out`
     echo "truncfile returned $? : \"$out\""
diff --git a/tests/generic/020 b/tests/generic/020
index f004be5..a9bd17a 100755
--- a/tests/generic/020
+++ b/tests/generic/020
@@ -29,21 +29,16 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "_cleanup; rm -f $tmp.* $testfile; exit \$status" 0 1 2 3 15
+trap "rm -f $tmp.* $testfile; exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
 . ./common/attr
 
-_cleanup()
-{
-    _cleanup_testdir
-}
-
 _filter()
 {
-    sed "s#$testdir[^ :]*#<TESTFILE>#g; 
+    sed "s#$TEST_DIR[^ :]*#<TESTFILE>#g; 
             s#$tmp[^ :]*#<TMPFILE>#g" $1
 }
 
@@ -83,11 +78,9 @@ _supported_os Linux
 
 _require_attrs
 
-_setup_testdir
-
 rm -f $seqres.full
 
-testfile=$testdir/attribute_$$
+testfile=$TEST_DIR/attribute_$$
 
 echo "*** list non-existant file"
 _attr_list $testfile
diff --git a/tests/generic/068 b/tests/generic/068
index b160766..a764019 100755
--- a/tests/generic/068
+++ b/tests/generic/068
@@ -36,7 +36,6 @@ ITERATIONS=10
 _cleanup()
 {
     cd /
-    _cleanup_testdir
 
     trap 0 1 2 3 15
     exit $status
diff --git a/tests/generic/070 b/tests/generic/070
index ad9031e..3c88df0 100755
--- a/tests/generic/070
+++ b/tests/generic/070
@@ -35,7 +35,6 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -49,10 +48,8 @@ _supported_os IRIX Linux
 
 _require_attrs
 
-_setup_testdir
-
 FSSTRESS_ARGS=`_scale_fsstress_args \
-	-d $testdir/fsstress \
+	-d $TEST_DIR/fsstress \
 	-f allocsp=0 \
 	-f freesp=0 \
 	-f bulkstat=0 \
diff --git a/tests/generic/074 b/tests/generic/074
index 55f72c2..668132e 100755
--- a/tests/generic/074
+++ b/tests/generic/074
@@ -34,8 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf $testdir/fstest.$$.* $tmp.*
-    _cleanup_testdir
+    rm -rf $TEST_DIR/fstest.$$.* $tmp.*
 }
 
 # get standard environment, filters and checks
@@ -47,7 +46,7 @@ _do_test()
     _n="$1"
     _param="$2"
 
-    out=$testdir/fstest.$$.$_n
+    out=$TEST_DIR/fstest.$$.$_n
     rm -rf $out
     if ! mkdir $out
     then
@@ -156,8 +155,6 @@ _process_args "$@"
 echo "Params are for $param_type" >>$seqres.full
 echo "Params: n = $numchildren l = $numloops f = $numfiles" >>$seqres.full
 
-_setup_testdir
-
 _check_test_fs
 
 # Options:
diff --git a/tests/generic/075 b/tests/generic/075
index e806dea..8b4ab39 100755
--- a/tests/generic/075
+++ b/tests/generic/075
@@ -34,8 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf $testdir/fsx.* $tmp.*
-    _cleanup_testdir
+    rm -rf $TEST_DIR/fsx.* $tmp.*
 }
 
 # get standard environment, filters and checks
@@ -47,7 +46,7 @@ _do_test()
     _n="$1"
     _param="$2"
 
-    out=$testdir/fsx
+    out=$TEST_DIR/fsx
     rm -rf $out
     if ! mkdir $out
     then
@@ -136,8 +135,6 @@ _process_args "$@"
 echo "Params are for $param_type" >>$seqres.full
 echo "Params: n = $numops1 N = $numops2 l = $filelen" >>$seqres.full
 
-_setup_testdir
-
 rm -f $seqres.full
 echo "brevity is wit..."
 
diff --git a/tests/generic/093 b/tests/generic/093
index a8ef52e..fe20f38 100755
--- a/tests/generic/093
+++ b/tests/generic/093
@@ -41,13 +41,12 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-    [ -n "$testdir" ] && rm -f $file
-    _cleanup_testdir
+    [ -n "$TEST_DIR" ] && rm -f $file
 }
 
 _testfilter()
 {
-    sed -e "s#$testdir#TESTDIR#g"
+    sed -e "s#$TEST_DIR#TESTDIR#g"
 }
 
 _filefilter()
@@ -65,12 +64,11 @@ _require_attrs
 
 rm -f $seqres.full
 
-_setup_testdir
 _need_to_be_root
 
 echo "QA output created by $seq"
 echo ""
-file=$testdir/$seq.file
+file=$TEST_DIR/$seq.file
 
 user=`grep ':all=:all=' /etc/capability | tail -1 | $AWK_PROG -F: '{print $1}'`
 uid=`_cat_passwd | grep $user | $AWK_PROG -F: '{print $3}'`
@@ -149,7 +147,7 @@ echo "list EA on file"
 ${ATTR_PROG} -R -l $file | _filefilter
 
 chown $uid $file
-chmod ugo+w $testdir
+chmod ugo+w $TEST_DIR
 echo "as non-root call writemod"
 $runas -u $uid src/writemod $file 2>&1 | _filefilter
 
diff --git a/tests/generic/097 b/tests/generic/097
index d7f6ec1..c120422 100755
--- a/tests/generic/097
+++ b/tests/generic/097
@@ -78,8 +78,6 @@ _supported_os IRIX
 _require_scratch
 _require_attrs
 
-_setup_testdir 
-
 TARGET_DIR=$SCRATCH_MNT
 [ "$FSTYP" == "xfs" ] && TARGET_DIR=$TEST_DIR
 cd $TARGET_DIR
@@ -245,7 +243,6 @@ echo "list root EAs: none"
 ${ATTR_PROG} -R -l foo
 
 cd /
-_cleanup_testdir
 
 # Check the filesystem
 _check_scratch_fs
diff --git a/tests/generic/099 b/tests/generic/099
index 03fdded..7351966 100755
--- a/tests/generic/099
+++ b/tests/generic/099
@@ -88,7 +88,6 @@ _require_acls
 # get dir
 #export FILE_SYS=xfs
 _require_scratch
-_setup_testdir
 
 cd $TARGET_DIR
 rm -rf $seq.dir1 # in case file is left over from previous runs.
diff --git a/tests/generic/100 b/tests/generic/100
index dfb5252..05d766f 100755
--- a/tests/generic/100
+++ b/tests/generic/100
@@ -69,19 +69,17 @@ tar -cvf $TEMP_DIR/$TAR_FILE $POPULATED_DIR >>$seqres.full 2>&1
 
 # create f/s
 _require_scratch
-_setup_testdir
 
 # untar on f/s
-cd $testdir
+cd $TEST_DIR
 tar -xRvf $TEMP_DIR/$TAR_FILE >>$seqres.full 2>&1
 cd $here
 
 # use diff -qr to compare
-ls -R -l ${testdir}${POPULATED_DIR} >>$seqres.full 2>&1
-diff -qr $POPULATED_DIR ${testdir}${POPULATED_DIR}
+ls -R -l ${TEST_DIR}${POPULATED_DIR} >>$seqres.full 2>&1
+diff -qr $POPULATED_DIR ${TEST_DIR}${POPULATED_DIR}
 
 cd /
-_cleanup_testdir
 _check_scratch_fs
 
 status=0
diff --git a/tests/generic/112 b/tests/generic/112
index 65b3484..4918f75 100755
--- a/tests/generic/112
+++ b/tests/generic/112
@@ -34,8 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -rf $testdir/fsx.* $tmp.*
-    _cleanup_testdir
+    rm -rf $TEST_DIR/fsx.* $tmp.*
 }
 
 # get standard environment, filters and checks
@@ -47,7 +46,7 @@ _do_test()
     _n="$1"
     _param="$2"
 
-    out=$testdir/fsx
+    out=$TEST_DIR/fsx
     rm -rf $out
     if ! mkdir $out
     then
@@ -137,8 +136,6 @@ _process_args "$@"
 echo "Params are for $param_type" >>$seqres.full
 echo "Params: n = $numops1 N = $numops2 l = $filelen" >>$seqres.full
 
-_setup_testdir
-
 rm -f $seqres.full
 echo "brevity is wit..."
 
diff --git a/tests/generic/113 b/tests/generic/113
index 5e9f5fe..56672f0 100755
--- a/tests/generic/113
+++ b/tests/generic/113
@@ -34,8 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    rm -f $testdir/aio-stress.$$.*
-    _cleanup_testdir
+    rm -f $TEST_DIR/aio-stress.$$.*
 }
 
 # get standard environment, filters and checks
@@ -49,11 +48,11 @@ _do_test()
     _count="$3"
     _nproc="$4"
 
-    _files="$testdir/aiostress.$$.$_n"
+    _files="$TEST_DIR/aiostress.$$.$_n"
     __proc=$_nproc
     [ $__proc -gt 1 ] && _param="-t $__proc $_param"
     while [ $__proc -gt 1 ]; do
-        _files="$_files $testdir/aiostress.$$.$_n.$__proc"
+        _files="$_files $TEST_DIR/aiostress.$$.$_n.$__proc"
 	let __proc=$__proc-1
     done
     rm -f $_files
@@ -80,8 +79,6 @@ _supported_os Linux
 
 [ -x $here/ltp/aio-stress ] || _notrun "aio-stress not built for this platform"
 
-_setup_testdir
-
 echo "brevity is wit..."
 
 count=1000
diff --git a/tests/generic/117 b/tests/generic/117
index 87e6987..f81265b 100755
--- a/tests/generic/117
+++ b/tests/generic/117
@@ -67,7 +67,6 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -79,7 +78,6 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 
-_setup_testdir
 _require_scratch
 _require_attrs
 
diff --git a/tests/generic/123 b/tests/generic/123
index 41b9d3b..911e9d2 100755
--- a/tests/generic/123
+++ b/tests/generic/123
@@ -35,10 +35,9 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
-    cd $testdir
+    cd $TEST_DIR
     rm -rf $my_test_subdir
     cd /
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -51,8 +50,7 @@ _supported_os Linux IRIX
 
 _require_user
 
-_setup_testdir
-my_test_subdir=$testdir/123subdir
+my_test_subdir=$TEST_DIR/123subdir
 
 # create subdir with required permissions
 mkdir -m 755 $my_test_subdir
diff --git a/tests/generic/124 b/tests/generic/124
index 92e7619..93ec4a1 100755
--- a/tests/generic/124
+++ b/tests/generic/124
@@ -38,7 +38,6 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -49,13 +48,12 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
 # Run preallo_rw_pattern on both test and scratch partitions
-for TESTFILE in $testdir/rw_pattern.tmp $SCRATCH_MNT/rw_pattern.tmp
+for TESTFILE in $TEST_DIR/rw_pattern.tmp $SCRATCH_MNT/rw_pattern.tmp
   do
   count=1
   while (( count < 101 ))
diff --git a/tests/generic/125 b/tests/generic/125
index 18f5cb1..f4ffea5 100755
--- a/tests/generic/125
+++ b/tests/generic/125
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -46,9 +41,7 @@ _supported_os Linux
 
 _require_user
 
-_setup_testdir
-
-TESTDIR=$testdir/ftrunc
+TESTDIR=$TEST_DIR/ftrunc
 TESTFILE=$TESTDIR/ftrunc.tmp
 
 [ -d $TESTDIR ] && rm -r $TESTDIR
diff --git a/tests/generic/126 b/tests/generic/126
index 7fe5bc6..1796527 100755
--- a/tests/generic/126
+++ b/tests/generic/126
@@ -34,7 +34,6 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     cd /
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -45,11 +44,9 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-_setup_testdir
-
 QA_FS_PERMS=$here/src/fs_perms
 
-cd $testdir
+cd $TEST_DIR
 cp $here/src/testx ./testx.file
 
 # file_perm owner_uid owner_gid tester_uid tester_gid perm_to_test expected_result pass=1
diff --git a/tests/generic/127 b/tests/generic/127
index 373bf20..58ca91e 100755
--- a/tests/generic/127
+++ b/tests/generic/127
@@ -38,7 +38,6 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     rm -f $tmp.output
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -51,10 +50,10 @@ FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -S 191110531 -N 100000"
 _fsx_lite_nommap()
 {
     echo "=== FSX Light Mode, No Memory Mapping ==="
-    dd if=/dev/zero of=$testdir/fsx_lite_nommap bs=${FSX_FILE_SIZE} count=1 > /dev/null 2>&1
-    if ! ltp/fsx $FSX_ARGS -L -R -W $testdir/fsx_lite_nommap > $tmp.output 2>&1
+    dd if=/dev/zero of=$TEST_DIR/fsx_lite_nommap bs=${FSX_FILE_SIZE} count=1 > /dev/null 2>&1
+    if ! ltp/fsx $FSX_ARGS -L -R -W $TEST_DIR/fsx_lite_nommap > $tmp.output 2>&1
     then
-        echo "ltp/fsx $FSX_ARGS -L -R -W $testdir/fsx_lite_nommap"
+        echo "ltp/fsx $FSX_ARGS -L -R -W $TEST_DIR/fsx_lite_nommap"
         cat $tmp.output
         return 1
     fi
@@ -65,8 +64,8 @@ _fsx_lite_nommap()
 _fsx_lite_mmap()
 {
     echo "=== FSX Light Mode, Memory Mapping ==="
-    dd if=/dev/zero of=$testdir/fsx_lite_mmap bs=${FSX_FILE_SIZE} count=1 > /dev/null 2>&1
-    if ! ltp/fsx $FSX_ARGS -L $testdir/fsx_lite_mmap > $tmp.output 2>&1
+    dd if=/dev/zero of=$TEST_DIR/fsx_lite_mmap bs=${FSX_FILE_SIZE} count=1 > /dev/null 2>&1
+    if ! ltp/fsx $FSX_ARGS -L $TEST_DIR/fsx_lite_mmap > $tmp.output 2>&1
     then
     	echo "ltp/fsx $FSX_ARGS -L fsx_lite_mmap"
 	cat $tmp.output
@@ -79,7 +78,7 @@ _fsx_lite_mmap()
 _fsx_std_nommap()
 {
     echo "=== FSX Standard Mode, No Memory Mapping ==="
-    if ! ltp/fsx $FSX_ARGS -R -W $testdir/fsx_std_nommap > $tmp.output 2>&1
+    if ! ltp/fsx $FSX_ARGS -R -W $TEST_DIR/fsx_std_nommap > $tmp.output 2>&1
     then
         echo "ltp/fsx $FSX_ARGS -R -W fsx_std_nommap"
         cat $tmp.output
@@ -92,7 +91,7 @@ _fsx_std_nommap()
 _fsx_std_mmap()
 {
     echo "=== FSX Standard Mode, Memory Mapping ==="
-    if ! ltp/fsx $FSX_ARGS $testdir/fsx_std_mmap > $tmp.output 2>&1
+    if ! ltp/fsx $FSX_ARGS $TEST_DIR/fsx_std_mmap > $tmp.output 2>&1
     then
     	echo "ltp/fsx $FSX_ARGS fsx_std_mmap"
 	cat $tmp.output
@@ -106,8 +105,6 @@ _fsx_std_mmap()
 _supported_fs generic
 _supported_os Linux
 
-_setup_testdir
-
 _fsx_lite_nommap
 _fsx_lite_mmap
 
diff --git a/tests/generic/128 b/tests/generic/128
index c9c809f..22e4f71 100755
--- a/tests/generic/128
+++ b/tests/generic/128
@@ -29,13 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    cd /
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -45,7 +39,6 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-_setup_testdir
 _require_scratch
 _require_user
 
diff --git a/tests/generic/129 b/tests/generic/129
index fe763df..9a10d76 100755
--- a/tests/generic/129
+++ b/tests/generic/129
@@ -29,13 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    cd /
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -54,8 +48,6 @@ _supported_os Linux
 _require_scratch
 _require_sparse_files
 
-_setup_testdir
-
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount "-o nosuid"
 
diff --git a/tests/generic/130 b/tests/generic/130
index cfc2c32..8367dc7 100755
--- a/tests/generic/130
+++ b/tests/generic/130
@@ -38,13 +38,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    cd /
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -57,8 +51,6 @@ _supported_os Linux IRIX
 _require_scratch
 _require_sparse_files
 
-_setup_testdir
-
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
diff --git a/tests/generic/131 b/tests/generic/131
index 6c3131c..ce3e490 100755
--- a/tests/generic/131
+++ b/tests/generic/131
@@ -35,7 +35,6 @@ _cleanup()
 {
     kill $locktest_pid2 > /dev/null 2>&1
     kill $locktest_pid1 > /dev/null 2>&1
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -46,9 +45,7 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-_setup_testdir
-
-TESTFILE=$testdir/lock_file
+TESTFILE=$TEST_DIR/lock_file
 
 # Grab a port which is hopefully unused
 if [ $$ -gt 1024 -a $$ -lt 32000 ]; then
@@ -60,13 +57,13 @@ elif [ $$ -gt 32000 ]; then
 fi
 
 # Start the server
-src/locktest -p $PORT $TESTFILE 2>&1 > $testdir/server.out &
+src/locktest -p $PORT $TESTFILE 2>&1 > $TEST_DIR/server.out &
 locktest_pid1=$!
 
 sleep 1
 
 # Start the client
-src/locktest -p $PORT -h localhost $TESTFILE 2>&1 > $testdir/client.out
+src/locktest -p $PORT -h localhost $TESTFILE 2>&1 > $TEST_DIR/client.out
 locktest_pid2=$!
 result=$?
 if [ $result -eq 0 ]; then
@@ -74,7 +71,7 @@ if [ $result -eq 0 ]; then
 	status=0
 else
 	echo "Client reported failure ($result)"
-	cat $testdir/*.out
+	cat $TEST_DIR/*.out
 fi
 
 exit
diff --git a/tests/generic/132 b/tests/generic/132
index 42ab909..aa52c7d 100755
--- a/tests/generic/132
+++ b/tests/generic/132
@@ -30,13 +30,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    cd /
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -46,7 +40,6 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux IRIX
 
-_setup_testdir
 _require_scratch
 
 _scratch_mkfs >/dev/null 2>&1
diff --git a/tests/generic/133 b/tests/generic/133
index 65ab822..7fb1695 100755
--- a/tests/generic/133
+++ b/tests/generic/133
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -44,35 +39,33 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux IRIX
 
-_setup_testdir
-
 echo "Buffered writer, buffered reader"
-$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
-$XFS_IO_PROG -f -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
-$XFS_IO_PROG -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $TEST_DIR/io_test > /dev/null
+$XFS_IO_PROG -f -c 'pwrite -b 64k 0 512m' $TEST_DIR/io_test >/dev/null &
+$XFS_IO_PROG -c 'pread -b 64k 0 512m' $TEST_DIR/io_test > /dev/null
 wait
-rm $testdir/io_test
+rm $TEST_DIR/io_test
 
 echo "Direct writer, buffered reader"
-$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
-$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
-$XFS_IO_PROG -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $TEST_DIR/io_test > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $TEST_DIR/io_test >/dev/null &
+$XFS_IO_PROG -c 'pread -b 64k 0 512m' $TEST_DIR/io_test > /dev/null
 wait
-rm $testdir/io_test
+rm $TEST_DIR/io_test
 
 echo "Buffered writer, direct reader"
-$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
-$XFS_IO_PROG -f -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
-$XFS_IO_PROG -d -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $TEST_DIR/io_test > /dev/null
+$XFS_IO_PROG -f -c 'pwrite -b 64k 0 512m' $TEST_DIR/io_test >/dev/null &
+$XFS_IO_PROG -d -c 'pread -b 64k 0 512m' $TEST_DIR/io_test > /dev/null
 wait
-rm $testdir/io_test
+rm $TEST_DIR/io_test
 
 echo "Direct writer, direct reader"
-$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test > /dev/null
-$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $testdir/io_test >/dev/null &
-$XFS_IO_PROG -d -c 'pread -b 64k 0 512m' $testdir/io_test > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $TEST_DIR/io_test > /dev/null
+$XFS_IO_PROG -f -d -c 'pwrite -b 64k 0 512m' $TEST_DIR/io_test >/dev/null &
+$XFS_IO_PROG -d -c 'pread -b 64k 0 512m' $TEST_DIR/io_test > /dev/null
 wait
-rm $testdir/io_test
+rm $TEST_DIR/io_test
 
 status=0
 exit 
diff --git a/tests/generic/135 b/tests/generic/135
index 783a106..e3b827a 100755
--- a/tests/generic/135
+++ b/tests/generic/135
@@ -29,13 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    cd /
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -45,7 +39,6 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux IRIX
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs >/dev/null 2>&1
 
diff --git a/tests/generic/141 b/tests/generic/141
index 83b5486..fa08484 100755
--- a/tests/generic/141
+++ b/tests/generic/141
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -44,7 +39,6 @@ _cleanup()
 _supported_fs generic
 _supported_os Linux
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/generic/184 b/tests/generic/184
index 5d74fa3..dcc8b4e 100755
--- a/tests/generic/184
+++ b/tests/generic/184
@@ -35,7 +35,6 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -46,12 +45,10 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 
-_setup_testdir
-
-rm -f $testdir/null
-mknod $testdir/null c 1 3
-chmod 666 $testdir/null
-echo fred > $testdir/null
+rm -f $TEST_DIR/null
+mknod $TEST_DIR/null c 1 3
+chmod 666 $TEST_DIR/null
+echo fred > $TEST_DIR/null
 
 status=$?
 exit
diff --git a/tests/generic/225 b/tests/generic/225
index faa542a..73b125a 100755
--- a/tests/generic/225
+++ b/tests/generic/225
@@ -34,7 +34,6 @@ _cleanup()
 {
 	cd /
 	rm -f $tmp.*
-	_cleanup_testdir
 }
 
 # get standard environment, filters and checks
diff --git a/tests/generic/237 b/tests/generic/237
index e5c5a79..6a61ec8 100755
--- a/tests/generic/237
+++ b/tests/generic/237
@@ -42,8 +42,7 @@ _cleanup()
 {
 	cd /
 	rm -f $tmp.*
-	[ -n "$testdir" ] && rm -rf $testdir/$seq.dir1
-	_cleanup_testdir
+	[ -n "$TEST_DIR" ] && rm -rf $TEST_DIR/$seq.dir1
 }
 
 # real QA test starts here
@@ -55,14 +54,12 @@ _supported_os Linux
 
 rm -f $seqres.full
 
-_setup_testdir
-
 _need_to_be_root
 _acl_setup_ids
 _require_acls
 
 # get dir
-cd $testdir
+cd $TEST_DIR
 rm -rf $seq.dir1
 mkdir $seq.dir1
 cd $seq.dir1
diff --git a/tests/generic/249 b/tests/generic/249
index 1f25edb..306e820 100755
--- a/tests/generic/249
+++ b/tests/generic/249
@@ -35,7 +35,6 @@ _cleanup()
 	cd /
 	rm -f $tmp.*
 	rm -f $SRC $DST
-	_cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -45,7 +44,6 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _supported_os Linux
-_setup_testdir
 
 echo "Feel the serenity."
 
diff --git a/tests/shared/051 b/tests/shared/051
index 07399cc..e957f86 100755
--- a/tests/shared/051
+++ b/tests/shared/051
@@ -40,8 +40,7 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    [ -n "$testdir" ] && rm -rf $testdir/$seq.dir1
-    _cleanup_testdir
+    [ -n "$TEST_DIR" ] && rm -rf $TEST_DIR/$seq.dir1
 }
 
 # -----
@@ -76,14 +75,12 @@ _supported_os Linux
 
 rm -f $seqres.full
 
-_setup_testdir
-
 _need_to_be_root
 _acl_setup_ids
 _require_acls
 
 # get dir
-cd $testdir
+cd $TEST_DIR
 rm -rf $seq.dir1
 mkdir $seq.dir1
 cd $seq.dir1
diff --git a/tests/shared/218 b/tests/shared/218
index f21b8b2..cd2076e 100755
--- a/tests/shared/218
+++ b/tests/shared/218
@@ -34,7 +34,6 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -46,7 +45,6 @@ _cleanup()
 _supported_fs xfs ext4 btrfs
 _supported_os Linux
 
-_setup_testdir
 # We require scratch so that we'll have free contiguous space
 _require_scratch
 _scratch_mkfs >/dev/null 2>&1
diff --git a/tests/udf/098 b/tests/udf/098
index 91e8a22..3a5db39 100755
--- a/tests/udf/098
+++ b/tests/udf/098
@@ -81,8 +81,6 @@ _supported_os IRIX
 _require_scratch
 _require_attrs
 
-_setup_testdir
-
 cd $SCRATCH_MNT
 
 echo "create file foo"
diff --git a/tests/udf/102 b/tests/udf/102
index e27c086..8fd4697 100755
--- a/tests/udf/102
+++ b/tests/udf/102
@@ -36,7 +36,6 @@ _cleanup()
 {
     rm -f $tmp.*
     cd /
-    _cleanup_testdir
 }
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/008 b/tests/xfs/008
index e7a1768..56be923 100755
--- a/tests/xfs/008
+++ b/tests/xfs/008
@@ -35,8 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
     rm -f $tmp.*
-    rm -rf $testdir/randholes.$$.*
-    _cleanup_testdir
+    rm -rf $TEST_DIR/randholes.$$.*
 }
 
 _filter()
@@ -55,7 +54,7 @@ _do_test()
     _holes="$2"
     _param="$3"
 
-    out=$testdir/randholes.$$.$_n
+    out=$TEST_DIR/randholes.$$.$_n
     echo ""
     echo "randholes.$_n : $_param" | _filter
     echo "------------------------------------------"
@@ -89,8 +88,6 @@ _do_test()
 _supported_fs xfs
 _supported_os IRIX Linux
 
-_setup_testdir
-
 rm -f $seqres.full
 
 # Note on special numbers here.
diff --git a/tests/xfs/012 b/tests/xfs/012
index cd9c485..4127222 100755
--- a/tests/xfs/012
+++ b/tests/xfs/012
@@ -35,8 +35,7 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    rm -rf $testdir/holes.$$.*
-    _cleanup_testdir
+    rm -rf $TEST_DIR/holes.$$.*
 }
 
 _filesize()
@@ -56,7 +55,7 @@ _do_test()
     
     failed=0
     
-    out=$testdir/holes.$$.$_n
+    out=$TEST_DIR/holes.$$.$_n
     echo ""
     echo "holes.$_n : $_param"
     echo "-----------------------------------------------"
@@ -106,8 +105,6 @@ _do_test()
 _supported_fs xfs
 _supported_os IRIX Linux
 
-_setup_testdir
-
 rm -f $seqres.full
 
 # small & fairly dense
diff --git a/tests/xfs/048 b/tests/xfs/048
index 40667e0..f9fb16f 100755
--- a/tests/xfs/048
+++ b/tests/xfs/048
@@ -39,16 +39,13 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    _cleanup_testdir
 }
 
 # real QA test starts here
 _supported_fs xfs
 _supported_os IRIX Linux
 
-_setup_testdir
-
-src/fault $testdir || exit
+src/fault $TEST_DIR || exit
 
 # success, all done
 status=0
diff --git a/tests/xfs/066 b/tests/xfs/066
index 6d4e1c2..d521ada 100755
--- a/tests/xfs/066
+++ b/tests/xfs/066
@@ -40,22 +40,19 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    _cleanup_testdir
 }
 
 # real QA test starts here
 _supported_fs xfs
 _supported_os IRIX Linux
 
-_setup_testdir
-
 _my_stat_filter()
 {
     grep "[sS]ize" | sed "s/.*[sS]ize[: ]*\([[:digit:]]*\).*/\1 largefile/g"
 }
 
-rm -f $testdir/testfile
-if src/feature -t $testdir/testfile; then
+rm -f $TEST_DIR/testfile
+if src/feature -t $TEST_DIR/testfile; then
 	:
 else
 	_notrun "Installed libc doesn't correctly handle setrlimit/ftruncate64"
diff --git a/tests/xfs/078 b/tests/xfs/078
index f2b674a..e04c6cc 100755
--- a/tests/xfs/078
+++ b/tests/xfs/078
@@ -38,7 +38,6 @@ _cleanup()
     rm -f $tmp.*
     umount -d $LOOP_MNT 2>/dev/null
     rmdir $LOOP_MNT
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
diff --git a/tests/xfs/080 b/tests/xfs/080
index b1cd0cb..59c6104 100755
--- a/tests/xfs/080
+++ b/tests/xfs/080
@@ -39,7 +39,6 @@ _cleanup()
 { 
     cd /
     rm -f $tmp.*
-   _cleanup_testdir
 }
 
 _supported_fs xfs
@@ -48,13 +47,11 @@ _supported_fs xfs
 # but not at the moment.
 _supported_os Linux
 
-_setup_testdir
-
 quiet=-q
 clean=-c
 
 export here
-cd $testdir
+cd $TEST_DIR
 echo
 
 # real QA test starts here
diff --git a/tests/xfs/137 b/tests/xfs/137
index 90dc1f5..79b3b89 100755
--- a/tests/xfs/137
+++ b/tests/xfs/137
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -44,7 +39,6 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux IRIX
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/xfs/138 b/tests/xfs/138
index d3c1009..1b11cf6 100755
--- a/tests/xfs/138
+++ b/tests/xfs/138
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -44,7 +39,6 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux IRIX
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/xfs/139 b/tests/xfs/139
index 1fbde58..e5296f7 100755
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -44,7 +39,6 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux IRIX
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/xfs/140 b/tests/xfs/140
index ce52272..cccf262 100755
--- a/tests/xfs/140
+++ b/tests/xfs/140
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -44,7 +39,6 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux IRIX
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/xfs/142 b/tests/xfs/142
index 5a2ef9e..a1efcc2 100755
--- a/tests/xfs/142
+++ b/tests/xfs/142
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/143 b/tests/xfs/143
index c86cc0a..c389a2b 100755
--- a/tests/xfs/143
+++ b/tests/xfs/143
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/144 b/tests/xfs/144
index 0b5b21d..41041c4 100755
--- a/tests/xfs/144
+++ b/tests/xfs/144
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/145 b/tests/xfs/145
index c8444f0..44b3e4e 100755
--- a/tests/xfs/145
+++ b/tests/xfs/145
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/146 b/tests/xfs/146
index 1e13d95..c6343f8 100755
--- a/tests/xfs/146
+++ b/tests/xfs/146
@@ -30,12 +30,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 _report_filter () {
     $PERL_PROG -ne "s/Report: \"0x[0-f]+\" was written and \"0x[0-f]+\" was read at/Report: \"HEX\" was written and \"HEX\" was read at/g ;
diff --git a/tests/xfs/147 b/tests/xfs/147
index c22f24a..73ff7f9 100755
--- a/tests/xfs/147
+++ b/tests/xfs/147
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/150 b/tests/xfs/150
index 3bf1c8b..f9e690a 100755
--- a/tests/xfs/150
+++ b/tests/xfs/150
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 _filter_fs_handle()
 {
diff --git a/tests/xfs/151 b/tests/xfs/151
index d2e21f3..bba7094 100755
--- a/tests/xfs/151
+++ b/tests/xfs/151
@@ -31,12 +31,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 _dm_create_session()
 {
diff --git a/tests/xfs/152 b/tests/xfs/152
index 310f0dc..72bdabf 100755
--- a/tests/xfs/152
+++ b/tests/xfs/152
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 _filter_handles()
 {
diff --git a/tests/xfs/153 b/tests/xfs/153
index 7b9a316..cac7722 100755
--- a/tests/xfs/153
+++ b/tests/xfs/153
@@ -30,12 +30,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/154 b/tests/xfs/154
index c281b37..810a6ac 100755
--- a/tests/xfs/154
+++ b/tests/xfs/154
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/155 b/tests/xfs/155
index 23316f2..1a1631e 100755
--- a/tests/xfs/155
+++ b/tests/xfs/155
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/156 b/tests/xfs/156
index 88b8cbf..d6e22b6 100755
--- a/tests/xfs/156
+++ b/tests/xfs/156
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/157 b/tests/xfs/157
index a1243dc..bf65590 100755
--- a/tests/xfs/157
+++ b/tests/xfs/157
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/158 b/tests/xfs/158
index 5c4dfcd..596f4c2 100755
--- a/tests/xfs/158
+++ b/tests/xfs/158
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/159 b/tests/xfs/159
index 8d15162..fc5193f 100755
--- a/tests/xfs/159
+++ b/tests/xfs/159
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/160 b/tests/xfs/160
index 44e9f2f..9a2e2d0 100755
--- a/tests/xfs/160
+++ b/tests/xfs/160
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/161 b/tests/xfs/161
index 74d6dbe..11e53de 100755
--- a/tests/xfs/161
+++ b/tests/xfs/161
@@ -30,12 +30,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 _filter_get_allocinfo()
 {
diff --git a/tests/xfs/162 b/tests/xfs/162
index 64d001c..4edb68f 100755
--- a/tests/xfs/162
+++ b/tests/xfs/162
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/163 b/tests/xfs/163
index 3a2d3b9..e283545 100755
--- a/tests/xfs/163
+++ b/tests/xfs/163
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 _filter_paths()
 {
diff --git a/tests/xfs/166 b/tests/xfs/166
index 02b3237..2a96f8a 100755
--- a/tests/xfs/166
+++ b/tests/xfs/166
@@ -29,14 +29,9 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
+trap "exit \$status" 0 1 2 3 15
 rm -f $seqres.full
 
-_cleanup()
-{
-    _cleanup_testdir
-}
-
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
@@ -80,7 +75,6 @@ _filter_blocks()
 _supported_fs xfs
 _supported_os Linux
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/xfs/167 b/tests/xfs/167
index d75de23..ab0156f 100755
--- a/tests/xfs/167
+++ b/tests/xfs/167
@@ -36,7 +36,6 @@ _cleanup()
 {
 	$KILLALL_PROG -r -q -TERM fsstress 2> /dev/null
 	sync	# ensures all fsstress processes died
-	_cleanup_testdir
 }
 
 workout()
@@ -59,7 +58,6 @@ _supported_os Linux
 
 [ -n "$KILLALL_PROG" ] || _notrun "killall executable not found"
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/xfs/168 b/tests/xfs/168
index 901125a..6fc4540 100755
--- a/tests/xfs/168
+++ b/tests/xfs/168
@@ -31,12 +31,7 @@ here=`pwd`
 tmp=/tmp/$$
 rm -f $seqres.full
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 _filter_dmapi_print_event() {
     $PERL_PROG -ne '
diff --git a/tests/xfs/179 b/tests/xfs/179
index 6402eda..ce50d99 100755
--- a/tests/xfs/179
+++ b/tests/xfs/179
@@ -30,12 +30,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -45,7 +40,6 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux IRIX
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/xfs/180 b/tests/xfs/180
index 404f352..a0fb69a 100755
--- a/tests/xfs/180
+++ b/tests/xfs/180
@@ -30,12 +30,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -45,7 +40,6 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux IRIX
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/xfs/182 b/tests/xfs/182
index f55e018..b75e4fc 100755
--- a/tests/xfs/182
+++ b/tests/xfs/182
@@ -30,12 +30,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
@@ -45,7 +40,6 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux IRIX
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/xfs/185 b/tests/xfs/185
index 6de0ca9..17334de 100755
--- a/tests/xfs/185
+++ b/tests/xfs/185
@@ -29,12 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    _cleanup_testdir
-}
+trap "exit \$status" 0 1 2 3 15
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/216 b/tests/xfs/216
index a21df9d..8513479 100755
--- a/tests/xfs/216
+++ b/tests/xfs/216
@@ -34,7 +34,6 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -45,7 +44,6 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/xfs/217 b/tests/xfs/217
index 25a6c01..6c439c0 100755
--- a/tests/xfs/217
+++ b/tests/xfs/217
@@ -34,7 +34,6 @@ _cleanup()
 {
     cd /
     rm -f $tmp.*
-    _cleanup_testdir
 }
 
 # get standard environment, filters and checks
@@ -45,7 +44,6 @@ _cleanup()
 _supported_fs xfs
 _supported_os Linux
 
-_setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
diff --git a/tests/xfs/250 b/tests/xfs/250
index b9953f7..3b67c3f 100755
--- a/tests/xfs/250
+++ b/tests/xfs/250
@@ -36,7 +36,6 @@ _cleanup()
 	umount -d $LOOP_MNT 2>/dev/null
 	rm -f $LOOP_DEV
 	rmdir $LOOP_MNT
-	_cleanup_testdir
 }
 
 # get standard environment, filters and checks

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
