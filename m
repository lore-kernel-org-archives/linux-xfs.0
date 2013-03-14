Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 93D6E7F61
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:06:12 -0500 (CDT)
Received: from polaris-admin.engr.sgi.com (polaris-admin.engr.sgi.com
	[150.166.41.54])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	r2ED6Bx7007473 for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:06:11 -0700
Date: Thu, 14 Mar 2013 06:06:11 -0700
Subject: [PATCH 15/18] xfstests: implement a result directory for tests
MIME-Version: 1.0
Message-Id: <20130314130611.A852B53DEAF1@polaris-admin.engr.sgi.com>
From: pwhite@sgi.com (Philip White)
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

From: Phil White <pwhite@sgi.com>


This is a rebasing & resubmit of a dchinner patch.  His comments on the
original:
-----------------
Currently each test gets it's sequence number from it's name. It
separates this from the path via basename, and uses it for
outputting full, notrun an dother status/log files. Hence these end
up in the top level directory.

All these output files need to go somewhere other than the top level
directory. Right now the check script is looking for them in the new
test directories (e.g. for the notrun files), but it woul dbe good
to be able to separate the test source form the test output.

Hence create an output directory which has a similar heirarchy to
the test source directory. Create it on demand when we build the
list of tests to run if it doesn't already exist.

Change the high level check script to set up this variable
appropriately for each test that is being run, and to use this new
output directory for it's result files as well. The next commit will
change all the tests themselves to use the new

This is the first (small) step in being able to store test results
in an external location for archival/data mining purposes
-----------------

Signed-off-by: Phil White <pwhite@sgi.com>
---
 check              |   31 +++++++++++++-----
 common             |    4 ++-
 common.attr        |    4 +-
 common.defrag      |    4 +-
 common.dump        |   74 ++++++++++++++++++++++----------------------
 common.filestreams |    4 +-
 common.log         |    4 +-
 common.quota       |   18 +++++-----
 common.rc          |   88 ++++++++++++++++++++++++++--------------------------
 common.scsi_debug  |    2 +-
 10 files changed, 124 insertions(+), 109 deletions(-)

diff --git a/check b/check
index 25f6c7e..80f748a 100755
--- a/check
+++ b/check
@@ -168,6 +168,12 @@ if [ ! -z "$SCRATCH_DEV" ]; then
   fi
 fi
 
+mkdir -p $RESULT_BASE
+if [ ! -d $RESULT_BASE ]; then
+	echo "failed to create results directory $RESULTS_BASE"
+	exit 1;
+fi
+
 seq="check"
 _check_test_fs
 
@@ -179,6 +185,13 @@ do
     # we don't include the tests/ directory in the name output.
     seqnum=`echo $seq | sed -e 's;$SRC_DIR/;;'`
 
+    # Similarly, the result directory needs to replace the tests/
+    # part of the test location.
+    group=`dirname $seq`
+    export RESULT_DIR=`echo $group | sed -e "s;$SRC_DIR;$RESULT_BASE;"`
+    mkdir -p $RESULT_DIR
+    seqres="$RESULT_BASE/$seqnum"
+
     echo -n "$seqnum"
 
     if $showme
@@ -191,7 +204,7 @@ do
     else
 	# really going to try and run this one
 	#
-	rm -f $seq.out.bad
+	rm -f $seqres.out.bad
 
 	# slashes now in names, sed barfs on them so use grep
 	lasttime=`grep -w ^$seq check.time | awk '// {print $2}'`
@@ -201,7 +214,7 @@ do
 	else
 		echo -n "	"	# prettier output with timestamps.
 	fi
-	rm -f core $seq.notrun
+	rm -f core $seqres.notrun
 
 	start=`_wallclock`
 	$timestamp && echo -n "	["`date "+%T"`"]"
@@ -222,11 +235,11 @@ do
 	    err=true
 	fi
 
-	if [ -f $seq.notrun ]
+	if [ -f $seqres.notrun ]
 	then
 	    $timestamp || echo -n " [not run] "
 	    $timestamp && echo " [not run]" && echo -n "	$seqnum -- "
-	    cat $seq.notrun
+	    cat $seqres.notrun
 	    notrun="$notrun $seqnum"
 	else
 	    if [ $sts -ne 0 ]
@@ -250,9 +263,9 @@ do
 		    fi
 		    echo ""
 		else
-		    echo " - output mismatch (see $seq.out.bad)"
-		    mv $tmp.out $seq.out.bad
-		    $diff $seq.out $seq.out.bad | {
+		    echo " - output mismatch (see $seqres.out.bad)"
+		    mv $tmp.out $seqres.out.bad
+		    $diff $seq.out $seqres.out.bad | {
 		        if test "$DIFF_LENGTH" -le 0; then
 				cat
 			else
@@ -260,7 +273,7 @@ do
 			fi; } | \
 			sed -e 's/^\(.\)/    \1/'
 		    echo "     ..."
-		    echo "     (Run '$diff $seq.out $seq.out.bad' to see the" \
+		    echo "     (Run '$diff $seq.out $seqres.out.bad' to see the" \
 			 "entire diff)"
 		    err=true
 		fi
@@ -277,7 +290,7 @@ do
 	n_bad=`expr $n_bad + 1`
 	quick=false
     fi
-    if [ ! -f $seq.notrun ]
+    if [ ! -f $seqres.notrun ]
     then
 	try="$try $seqnum"
 	n_try=`expr $n_try + 1`
diff --git a/common b/common
index 4732a66..ab6a11b 100644
--- a/common
+++ b/common
@@ -33,9 +33,11 @@ have_test_arg=false
 randomize=false
 timestamp=${TIMESTAMP:=false}
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
-SRC_DIR="tests"
 SRC_GROUPS="generic shared"
 
+export SRC_DIR="tests"
+export RESULT_BASE=${RESULT_BASE:="results"}
+
 _setenvironment()
 {
     MSGVERB="text:action"
diff --git a/common.attr b/common.attr
index 6e2c004..69bcb01 100644
--- a/common.attr
+++ b/common.attr
@@ -129,7 +129,7 @@ _require_acls()
     #
     touch $TEST_DIR/syscalltest
     chacl -l $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
-    cat $TEST_DIR/syscalltest.out >> $here/$seq.full
+    cat $TEST_DIR/syscalltest.out >> $RESULT_DIR/$seq.full
 
     if grep -q 'Function not implemented' $TEST_DIR/syscalltest.out; then
       _notrun "kernel does not support ACLs"
@@ -164,7 +164,7 @@ _require_attrs()
     #
     touch $TEST_DIR/syscalltest
     attr -s "user.xfstests" -V "attr" $TEST_DIR > $TEST_DIR/syscalltest.out 2>&1
-    cat $TEST_DIR/syscalltest.out >> $here/$seq.full
+    cat $TEST_DIR/syscalltest.out >> $RESULT_DIR/$seq.full
 
     if grep -q 'Function not implemented' $TEST_DIR/syscalltest.out; then
       _notrun "kernel does not support attrs"
diff --git a/common.defrag b/common.defrag
index 9c9eb9b..13405a4 100644
--- a/common.defrag
+++ b/common.defrag
@@ -44,7 +44,7 @@ _require_defrag()
 _extent_count()
 {
 	$FILEFRAG_PROG $1 | awk '{print $2}'
-	$FILEFRAG_PROG -v $1  >> $seq.full 2>&1
+	$FILEFRAG_PROG -v $1  >> $RESULT_DIR/$seq.full 2>&1
 }
 
 # Defrag file, check it, and remove it.
@@ -54,7 +54,7 @@ _defrag()
 	_extent_count $1
 	CSUM_BEFORE=`md5sum $1`
 	STAT_BEFORE=`stat -c "a: %x m: %y c: %z" $1`
-	$DEFRAG_PROG -v $1 >> $seq.full 2>&1
+	$DEFRAG_PROG -v $1 >> $RESULT_DIR/$seq.full 2>&1
 	_scratch_remount
 	STAT_AFTER=`stat -c "a: %x m: %y c: %z" $1`
 	CSUM_AFTER=`md5sum $1`
diff --git a/common.dump b/common.dump
index e89dedc..6169ae2 100644
--- a/common.dump
+++ b/common.dump
@@ -20,7 +20,7 @@
 #
 
 # --- initializations ---
-rm -f $here/$seq.full
+rm -f $RESULT_DIR/$seq.full
 
 if [ -n "$DEBUGDUMP" ]; then
 	_dump_debug=-v4
@@ -124,7 +124,7 @@ _check_onl()
     _limit=10
     i=0
     while [ $i -lt $_limit ]; do
-        echo "Checking online..." >>$here/$seq.full
+        echo "Checking online..." >>$RESULT_DIR/$seq.full
 	if _mt status >$tmp.status 2>&1; then
 	    break;
 	else
@@ -158,12 +158,12 @@ _check_onl()
 
 _wait_tape()
 {
-    echo "Wait for tape, $dumptape, ..." >>$here/$seq.full
+    echo "Wait for tape, $dumptape, ..." >>$RESULT_DIR/$seq.full
 
     i=0
     while [ $i -lt 20 ]; do
-        echo "Checking status..." >>$here/$seq.full
-	if _mt status 2>&1 | tee -a $here/$seq.full | egrep -i "onl|ready" >/dev/null; then
+        echo "Checking status..." >>$RESULT_DIR/$seq.full
+	if _mt status 2>&1 | tee -a $RESULT_DIR/$seq.full | egrep -i "onl|ready" >/dev/null; then
 	    break;
 	else
 	    sleep 1
@@ -177,7 +177,7 @@ _wait_tape()
 #
 _rewind()
 {
-    echo "Initiate rewind..." >>$here/$seq.full
+    echo "Initiate rewind..." >>$RESULT_DIR/$seq.full
     _wait_tape
     _mt rewind >/dev/null
     _wait_tape
@@ -190,7 +190,7 @@ _rewind()
 #
 _erase_soft()
 {
-    echo "Erasing tape" | tee -a $here/$seq.full
+    echo "Erasing tape" | tee -a $RESULT_DIR/$seq.full
     _rewind
     _mt weof 3
     _rewind
@@ -198,7 +198,7 @@ _erase_soft()
 
 _erase_hard()
 {
-    echo "Erasing tape" | tee -a $here/$seq.full
+    echo "Erasing tape" | tee -a $RESULT_DIR/$seq.full
     _mt erase
 }
 
@@ -242,8 +242,8 @@ _wipe_fs()
 {
     _require_scratch
 
-    _scratch_mkfs_xfs >>$here/$seq.full || _fail "mkfs failed"
-    _scratch_mount >>$here/$seq.full || _fail "mount failed"
+    _scratch_mkfs_xfs >>$RESULT_DIR/$seq.full || _fail "mkfs failed"
+    _scratch_mount >>$RESULT_DIR/$seq.full || _fail "mount failed"
 }
 
 #
@@ -294,8 +294,8 @@ _cleanup()
 _stable_fs()
 {
     _saveddir=`pwd`; cd /
-    umount $SCRATCH_MNT >>$here/$seq.full || _fail "unmount failed"
-    _scratch_mount >>$here/$seq.full || _fail "mount failed"
+    umount $SCRATCH_MNT >>$RESULT_DIR/$seq.full || _fail "unmount failed"
+    _scratch_mount >>$RESULT_DIR/$seq.full || _fail "mount failed"
     cd $_saveddir
 }
 
@@ -325,12 +325,12 @@ _create_dumpdir_stress()
     echo "-----------------------------------------------"
     if ! $here/ltp/fsstress $_param -s 1 $FSSTRESS_AVOID -n $_count -d $dump_dir >$tmp.out 2>&1
     then
-        echo "    fsstress (count=$_count) returned $? - see $here/$seq.full"
+        echo "    fsstress (count=$_count) returned $? - see $RESULT_DIR/$seq.full"
 
-        echo "--------------------------------------"       >>$here/$seq.full
-        echo "output from fsstress:"                        >>$here/$seq.full
-        echo "--------------------------------------"       >>$here/$seq.full
-        cat $tmp.out                                        >>$here/$seq.full
+        echo "--------------------------------------"       >>$RESULT_DIR/$seq.full
+        echo "output from fsstress:"                        >>$RESULT_DIR/$seq.full
+        echo "--------------------------------------"       >>$RESULT_DIR/$seq.full
+        cat $tmp.out                                        >>$RESULT_DIR/$seq.full
         status=1
     fi
 
@@ -1025,7 +1025,7 @@ _do_dump_sub()
     echo "Dumping to tape..."
     opts="$_dump_debug$dump_args -s $dump_sdir -f $dumptape -M $media_label -L $session_label $SCRATCH_MNT"
     echo "xfsdump $opts" | _dir_filter
-    $XFSDUMP_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSDUMP_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
 }
 
 #
@@ -1038,7 +1038,7 @@ _do_dump()
     echo "Dumping to tape..."
     opts="$_dump_debug$dump_args -f $dumptape -M $media_label -L $session_label $SCRATCH_MNT"
     echo "xfsdump $opts" | _dir_filter
-    $XFSDUMP_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSDUMP_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
 }
 
 
@@ -1053,7 +1053,7 @@ _do_dump_min()
     onemeg=1048576
     opts="$_dump_debug$dump_args -m -b $onemeg -l0 -f $dumptape -M $media_label -L $session_label $SCRATCH_MNT"
     echo "xfsdump $opts" | _dir_filter
-    $XFSDUMP_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSDUMP_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
 }
 
 
@@ -1067,7 +1067,7 @@ _do_dump_file()
     echo "Dumping to file..."
     opts="$_dump_debug$dump_args -f $dump_file -M $media_label -L $session_label $SCRATCH_MNT"
     echo "xfsdump $opts" | _dir_filter
-    $XFSDUMP_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSDUMP_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
 }
 
 #
@@ -1089,7 +1089,7 @@ _do_dump_multi_file()
     echo "Dumping to files..."
     opts="$_dump_debug$dump_args $multi_args -L $session_label $SCRATCH_MNT"
     echo "xfsdump $opts" | _dir_filter
-    $XFSDUMP_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSDUMP_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
 }
 
 
@@ -1122,7 +1122,7 @@ _do_restore()
     echo "Restoring from tape..."
     opts="$_restore_debug$restore_args -f $dumptape  -L $session_label $restore_dir"
     echo "xfsrestore $opts" | _dir_filter
-    $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSRESTORE_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
 }
 
 #
@@ -1137,7 +1137,7 @@ _do_restore_min()
     onemeg=1048576
     opts="$_restore_debug$restore_args -m -b $onemeg -f $dumptape  -L $session_label $restore_dir"
     echo "xfsrestore $opts" | _dir_filter
-    $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSRESTORE_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
 }
 
 #
@@ -1151,7 +1151,7 @@ _do_restore_file()
     echo "Restoring from file..."
     opts="$_restore_debug$restore_args -f $dump_file  -L $session_label $restore_dir"
     echo "xfsrestore $opts" | _dir_filter
-    $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSRESTORE_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
 }
 
 #
@@ -1166,7 +1166,7 @@ _do_restore_file_cum()
     echo "Restoring cumumlative from file..."
     opts="$_restore_debug$restore_args -f $dump_file -r $restore_dir"
     echo "xfsrestore $opts" | _dir_filter
-    $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSRESTORE_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
 }
 
 _do_restore_toc()
@@ -1177,7 +1177,7 @@ _do_restore_toc()
     opts="$_restore_debug$restore_args -f $dump_file -t"
     echo "xfsrestore $opts" | _dir_filter
     cd $SCRATCH_MNT # for IRIX which needs xfs cwd
-    $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter_main |\
+    $XFSRESTORE_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter_main |\
     _check_quota_file |\
     _check_quota_entries |\
     $AWK_PROG 'NF != 1 { print; next }
@@ -1208,7 +1208,7 @@ _do_restore_multi_file()
     echo "Restoring from file..."
     opts="$_restore_debug$restore_args $multi_args -L $session_label $restore_dir"
     echo "xfsrestore $opts" | _dir_filter
-    $XFSRESTORE_PROG $opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSRESTORE_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
 }
 
 #
@@ -1228,7 +1228,7 @@ _do_dump_restore()
     restore_opts="$_restore_debug$restore_args - $restore_dir"
     dump_opts="$_dump_debug$dump_args -s $dump_sdir - $SCRATCH_MNT"
     echo "xfsdump $dump_opts | xfsrestore $restore_opts" | _dir_filter
-    $XFSDUMP_PROG $dump_opts 2>$tmp.dump.mlog | $XFSRESTORE_PROG $restore_opts 2>&1 | tee -a $here/$seq.full | _dump_filter
+    $XFSDUMP_PROG $dump_opts 2>$tmp.dump.mlog | $XFSRESTORE_PROG $restore_opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
     _dump_filter <$tmp.dump.mlog
 }
 
@@ -1244,8 +1244,8 @@ _ls_compare_sub()
     # verify we got back what we dumped
     #
     echo "Comparing listing of dump directory with restore directory"
-    ls -nR $dump_dir | tee -a $here/$seq.full | _ls_filter >$tmp.dump_dir
-    ls -nR $restore_dir/$dump_sdir | tee -a $here/$seq.full | _ls_filter \
+    ls -nR $dump_dir | tee -a $RESULT_DIR/$seq.full | _ls_filter >$tmp.dump_dir
+    ls -nR $restore_dir/$dump_sdir | tee -a $RESULT_DIR/$seq.full | _ls_filter \
     | sed -e "s#$restore_sdir\/##" >$tmp.restore_dir
 
     diff -bcs $tmp.dump_dir $tmp.restore_dir | sed -e "s#$tmp#TMP#g"
@@ -1267,8 +1267,8 @@ _ls_nodate_compare_sub()
     # verify we got back what we dumped
     #
     echo "Comparing listing of dump directory with restore directory"
-    ls -nR $dump_dir | tee -a $here/$seq.full | _ls_filter | _ls_nodate_filter >$tmp.dump_dir
-    ls -nR $restore_dir/$dump_sdir | tee -a $here/$seq.full | _ls_filter \
+    ls -nR $dump_dir | tee -a $RESULT_DIR/$seq.full | _ls_filter | _ls_nodate_filter >$tmp.dump_dir
+    ls -nR $restore_dir/$dump_sdir | tee -a $RESULT_DIR/$seq.full | _ls_filter \
     | _ls_nodate_filter | sed -e "s#$restore_sdir\/##" >$tmp.restore_dir
 
     diff -bcs $tmp.dump_dir $tmp.restore_dir | sed -e "s#$tmp#TMP#g"
@@ -1366,7 +1366,7 @@ _diff_compare()
 #
 _dump_inventory()
 {
-    $XFSDUMP_PROG $_dump_debug -I | tee -a $here/$seq.full | _dump_filter_main
+    $XFSDUMP_PROG $_dump_debug -I | tee -a $RESULT_DIR/$seq.full | _dump_filter_main
 }
 
 #
@@ -1376,9 +1376,9 @@ _dump_inventory()
 _do_invutil()
 {
     host=`hostname`
-    echo "xfsinvutil $_invutil_debug -M $host:$SCRATCH_MNT \"$middate\" $*" >$here/$seq.full
+    echo "xfsinvutil $_invutil_debug -M $host:$SCRATCH_MNT \"$middate\" $*" >$RESULT_DIR/$seq.full
     $XFSINVUTIL_PROG $_invutil_debug $* -M $host:$SCRATCH_MNT "$middate" \
-    | tee -a $here/$seq.full | _invutil_filter
+    | tee -a $RESULT_DIR/$seq.full | _invutil_filter
 }
 
 #
@@ -1398,7 +1398,7 @@ _check_quota()
     $here/src/feature -P $SCRATCH_DEV && pquota=1
 
     $AWK_PROG -v uquota=$uquota -v gquota=$gquota -v pquota=$pquota \
-	      -v full=$here/$seq.full -v usermsg="$usermsg" \
+	      -v full=$RESULT_DIR/$seq.full -v usermsg="$usermsg" \
 	      -v groupmsg="$groupmsg" -v projectmsg="$projectmsg" '
 	$0 ~ projectmsg {
 			print "Found project quota:", $0 >>full
diff --git a/common.filestreams b/common.filestreams
index 08eaf90..b3aee27 100644
--- a/common.filestreams
+++ b/common.filestreams
@@ -116,7 +116,7 @@ _check_for_dupes()
                 for this_num_two in $num_str_two; do
                         if [ "$this_num_one" == "$this_num_two" ]; then
 				echo "duplicate AG $this_num_one found" \
-					>> $here/$seq.full
+					>> $RESULT_DIR/$seq.full
 				return 1
 			fi
                 done
@@ -189,7 +189,7 @@ _test_streams() {
 	stream_index=1
 	while [ $stream_index -le $stream_count ]; do
 		this_stream_ags=`_get_stream_ags stream${stream_index}-dir`
-		echo "stream $stream_index AGs: $this_stream_ags" >> $here/$seq.full
+		echo "stream $stream_index AGs: $this_stream_ags" >> $RESULT_DIR/$seq.full
 		_check_for_dupes "$ags_seen" "$this_stream_ags"
 		if [ $? -ne 0 ]; then
 			# this stream is not in seperate AGs to previous streams
diff --git a/common.log b/common.log
index 3958c48..c50f4a8 100644
--- a/common.log
+++ b/common.log
@@ -33,14 +33,14 @@ _cleanup_logfiles()
 
 _full()
 {
-    echo ""            >>$seq.full      
+    echo ""            >>$seq.full
     echo "*** $* ***"  >>$seq.full
     echo ""            >>$seq.full
 }
 
 _echofull()
 {
-    echo ""            | tee -a $seq.full      
+    echo ""            | tee -a $seq.full
     echo "*** $* ***"  | tee -a $seq.full
     echo ""            | tee -a $seq.full
 }
diff --git a/common.quota b/common.quota
index 2fa784b..ff80382 100644
--- a/common.quota
+++ b/common.quota
@@ -96,8 +96,8 @@ _file_as_id()
 
     parent=`dirname $1`
     if [ $3 = p ]; then
-	echo PARENT: xfs_io -r -c "chproj $2" -c "chattr +P" $parent >>$seq.full
-	$XFS_IO_PROG -r -c "chproj $2" -c "chattr +P" $parent >>$seq.full 2>&1
+	echo PARENT: xfs_io -r -c "chproj $2" -c "chattr +P" $parent >>$RESULT_DIR/$seq.full
+	$XFS_IO_PROG -r -c "chproj $2" -c "chattr +P" $parent >>$RESULT_DIR/$seq.full 2>&1
 	magik='$>'	# (irrelevent, above set projid-inherit-on-parent)
     elif [ $3 = u ]; then
 	magik='$>'	# perlspeak for effective uid
@@ -107,7 +107,7 @@ _file_as_id()
 	_notrun "broken type in call to _file_as_id in test $seq"
     fi
 
-    perl <<EOF >>$seq.full 2>&1
+    perl <<EOF >>$RESULT_DIR/$seq.full 2>&1
 	\$| = 1;
 	$magik = $2;
 	if ($5 == 0) {
@@ -119,11 +119,11 @@ _file_as_id()
 	}
 EOF
 # for debugging the above euid change, try... [need write in cwd]
-#	exec "dd if=/dev/zero of=$1 bs=$4 count=$5 >>$seq.full 2>&1";
+#	exec "dd if=/dev/zero of=$1 bs=$4 count=$5 >>$RESULT_DIR/$seq.full 2>&1";
 
     if [ $3 = p ]; then
-	echo PARENT: xfs_io -r -c "chproj 0" -c "chattr -P" $parent >>$seq.full
-	$XFS_IO_PROG -r -c "chproj 0" -c "chattr -P" $parent >>$seq.full 2>&1
+	echo PARENT: xfs_io -r -c "chproj 0" -c "chattr -P" $parent >>$RESULT_DIR/$seq.full
+	$XFS_IO_PROG -r -c "chproj 0" -c "chattr -P" $parent >>$RESULT_DIR/$seq.full 2>&1
     fi
 }
 
@@ -198,8 +198,8 @@ _qsetup()
 	_notrun "No quota support at mount time"
     fi
 
-    echo "Using output from '" `ls -l $seq.out` "'" >>$seq.full
-    echo "and using type=$type id=$id" >>$seq.full
+    echo "Using output from '" `ls -l $seq.out` "'" >>$RESULT_DIR/$seq.full
+    echo "and using type=$type id=$id" >>$RESULT_DIR/$seq.full
 }
 
 #
@@ -229,7 +229,7 @@ _qmount_option()
 
 	# Ensure we have the given quota option - duplicates are fine
 	export MOUNT_OPTIONS="$MOUNT_OPTIONS -o $1"
-	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seq.full
+	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$RESULT_DIR/$seq.full
 }
 
 _check_quota_usage()
diff --git a/common.rc b/common.rc
index 4214b3c..1ab736c 100644
--- a/common.rc
+++ b/common.rc
@@ -296,9 +296,9 @@ _scratch_mkfs_xfs()
 
     if [ $mkfs_status -ne 0 -a ! -z "$extra_mkfs_options" ]; then
         echo "** mkfs failed with extra mkfs options added to \"$MKFS_OPTIONS\" by test $seq **" \
-            >>$here/$seq.full
+            >>$RESULT_DIR/$seq.full
         echo "** attempting to mkfs using only test $seq options: $extra_mkfs_options **" \
-            >>$here/$seq.full
+            >>$RESULT_DIR/$seq.full
         # running mkfs again. overwrite previous mkfs output files
         $MKFS_XFS_PROG $SCRATCH_OPTIONS $extra_mkfs_options $SCRATCH_DEV \
             2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
@@ -634,7 +634,7 @@ _is_block_dev()
     fi
 }
 
-# Do a command, log it to $seq.full, optionally test return status
+# Do a command, log it to $RESULT_DIR/$seq.full, optionally test return status
 # and die if command fails. If called with one argument _do executes the
 # command, logs it, and returns its exit status. With two arguments _do
 # first prints the message passed in the first argument, and then "done"
@@ -657,9 +657,9 @@ _do()
 	status=1; exit
     fi
 
-    (eval "echo '---' \"$_cmd\"") >>$here/$seq.full
+    (eval "echo '---' \"$_cmd\"") >>$RESULT_DIR/$seq.full
     (eval "$_cmd") >$tmp._out 2>&1; ret=$?
-    cat $tmp._out | _fix_malloc >>$here/$seq.full
+    cat $tmp._out | _fix_malloc >>$RESULT_DIR/$seq.full
     if [ $# -eq 2 ]; then
 	if [ $ret -eq 0 ]; then
 	    echo "done"
@@ -672,7 +672,7 @@ _do()
 	    -o \( $# -eq 2 -a "$_do_die_on_error" = "message_only" \) ]
     then
 	[ $# -ne 2 ] && echo
-	eval "echo \"$_cmd\" failed \(returned $ret\): see $seq.full"
+	eval "echo \"$_cmd\" failed \(returned $ret\): see $RESULT_DIR/$seq.full"
 	status=1; exit
     fi
 
@@ -693,8 +693,8 @@ _notrun()
 #
 _fail()
 {
-    echo "$*" | tee -a $here/$seq.full
-    echo "(see $seq.full for details)"
+    echo "$*" | tee -a $RESULT_DIR/$seq.full
+    echo "(see $RESULT_DIR/$seq.full for details)"
     status=1
     exit 1
 }
@@ -1181,12 +1181,12 @@ _check_generic_filesystem()
     fsck -t $FSTYP $FSCK_OPTIONS $device >$tmp.fsck 2>&1
     if [ $? -ne 0 ]
     then
-        echo "_check_generic_filesystem: filesystem on $device is inconsistent (see $seq.full)"
+        echo "_check_generic_filesystem: filesystem on $device is inconsistent (see $RESULT_DIR/$seq.full)"
 
-        echo "_check_generic filesystem: filesystem on $device is inconsistent" >>$here/$seq.full
-        echo "*** fsck.$FSTYP output ***"                     >>$here/$seq.full
-        cat $tmp.fsck                                         >>$here/$seq.full
-        echo "*** end fsck.$FSTYP output"                     >>$here/$seq.full
+        echo "_check_generic filesystem: filesystem on $device is inconsistent" >>$RESULT_DIR/$seq.full
+        echo "*** fsck.$FSTYP output ***"                     >>$RESULT_DIR/$seq.full
+        cat $tmp.fsck                                         >>$RESULT_DIR/$seq.full
+        echo "*** end fsck.$FSTYP output"                     >>$RESULT_DIR/$seq.full
 
         ok=0
     fi
@@ -1194,9 +1194,9 @@ _check_generic_filesystem()
 
     if [ $ok -eq 0 ]
     then
-        echo "*** mount output ***"                             >>$here/$seq.full
-        _mount                                                  >>$here/$seq.full
-        echo "*** end mount output"                             >>$here/$seq.full
+        echo "*** mount output ***"                             >>$RESULT_DIR/$seq.full
+        _mount                                                  >>$RESULT_DIR/$seq.full
+        echo "*** end mount output"                             >>$RESULT_DIR/$seq.full
     elif [ "$type" = "$FSTYP" ]
     then
 	# was mounted ...
@@ -1252,12 +1252,12 @@ _check_xfs_filesystem()
                 | tee $tmp.logprint | grep -q "<CLEAN>"
     if [ $? -ne 0 -a "$HOSTOS" = "Linux" ]
     then
-        echo "_check_xfs_filesystem: filesystem on $device has dirty log (see $seq.full)"
+        echo "_check_xfs_filesystem: filesystem on $device has dirty log (see $RESULT_DIR/$seq.full)"
 
-        echo "_check_xfs_filesystem: filesystem on $device has dirty log"   >>$here/$seq.full
-        echo "*** xfs_logprint -t output ***"                   >>$here/$seq.full
-        cat $tmp.logprint                                       >>$here/$seq.full
-        echo "*** end xfs_logprint output"                      >>$here/$seq.full
+        echo "_check_xfs_filesystem: filesystem on $device has dirty log"   >>$RESULT_DIR/$seq.full
+        echo "*** xfs_logprint -t output ***"                   >>$RESULT_DIR/$seq.full
+        cat $tmp.logprint                                       >>$RESULT_DIR/$seq.full
+        echo "*** end xfs_logprint output"                      >>$RESULT_DIR/$seq.full
 
         ok=0
     fi
@@ -1266,12 +1266,12 @@ _check_xfs_filesystem()
 	 _fix_malloc >$tmp.fs_check
     if [ -s $tmp.fs_check ]
     then
-        echo "_check_xfs_filesystem: filesystem on $device is inconsistent (c) (see $seq.full)"
+        echo "_check_xfs_filesystem: filesystem on $device is inconsistent (c) (see $RESULT_DIR/$seq.full)"
 
-        echo "_check_xfs_filesystem: filesystem on $device is inconsistent" >>$here/$seq.full
-        echo "*** xfs_check output ***"                         >>$here/$seq.full
-        cat $tmp.fs_check                                       >>$here/$seq.full
-        echo "*** end xfs_check output"                         >>$here/$seq.full
+        echo "_check_xfs_filesystem: filesystem on $device is inconsistent" >>$RESULT_DIR/$seq.full
+        echo "*** xfs_check output ***"                         >>$RESULT_DIR/$seq.full
+        cat $tmp.fs_check                                       >>$RESULT_DIR/$seq.full
+        echo "*** end xfs_check output"                         >>$RESULT_DIR/$seq.full
 
         ok=0
     fi
@@ -1280,12 +1280,12 @@ _check_xfs_filesystem()
     $XFS_REPAIR_PROG -n $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
     if [ $? -ne 0 ]
     then
-        echo "_check_xfs_filesystem: filesystem on $device is inconsistent (r) (see $seq.full)"
+        echo "_check_xfs_filesystem: filesystem on $device is inconsistent (r) (see $RESULT_DIR/$seq.full)"
 
-        echo "_check_xfs_filesystem: filesystem on $device is inconsistent" >>$here/$seq.full
-        echo "*** xfs_repair -n output ***"                     >>$here/$seq.full
-        cat $tmp.repair | _fix_malloc                           >>$here/$seq.full
-        echo "*** end xfs_repair output"                        >>$here/$seq.full
+        echo "_check_xfs_filesystem: filesystem on $device is inconsistent" >>$RESULT_DIR/$seq.full
+        echo "*** xfs_repair -n output ***"                     >>$RESULT_DIR/$seq.full
+        cat $tmp.repair | _fix_malloc                           >>$RESULT_DIR/$seq.full
+        echo "*** end xfs_repair output"                        >>$RESULT_DIR/$seq.full
 
         ok=0
     fi
@@ -1293,9 +1293,9 @@ _check_xfs_filesystem()
 
     if [ $ok -eq 0 ]
     then
-        echo "*** mount output ***"                             >>$here/$seq.full
-        _mount                                                  >>$here/$seq.full
-        echo "*** end mount output"                             >>$here/$seq.full
+        echo "*** mount output ***"                             >>$RESULT_DIR/$seq.full
+        _mount                                                  >>$RESULT_DIR/$seq.full
+        echo "*** end mount output"                             >>$RESULT_DIR/$seq.full
     elif [ "$type" = "xfs" ]
     then
 	_mount_or_remount_rw "$extra_mount_options" $device $mountpoint
@@ -1389,12 +1389,12 @@ _check_btrfs_filesystem()
     btrfsck $device >$tmp.fsck 2>&1
     if [ $? -ne 0 ]
     then
-        echo "_check_btrfs_filesystem: filesystem on $device is inconsistent (see $seq.full)"
+        echo "_check_btrfs_filesystem: filesystem on $device is inconsistent (see $RESULT_DIR/$seq.full)"
 
-        echo "_check_btrfs_filesystem: filesystem on $device is inconsistent" >>$here/$seq.full
-        echo "*** fsck.$FSTYP output ***"                     >>$here/$seq.full
-        cat $tmp.fsck                                         >>$here/$seq.full
-        echo "*** end fsck.$FSTYP output"                     >>$here/$seq.full
+        echo "_check_btrfs_filesystem: filesystem on $device is inconsistent" >>$RESULT_DIR/$seq.full
+        echo "*** fsck.$FSTYP output ***"                     >>$RESULT_DIR/$seq.full
+        cat $tmp.fsck                                         >>$RESULT_DIR/$seq.full
+        echo "*** end fsck.$FSTYP output"                     >>$RESULT_DIR/$seq.full
 
         ok=0
     fi
@@ -1402,9 +1402,9 @@ _check_btrfs_filesystem()
 
     if [ $ok -eq 0 ]
     then
-        echo "*** mount output ***"                             >>$here/$seq.full
-        _mount                                                  >>$here/$seq.full
-        echo "*** end mount output"                             >>$here/$seq.full
+        echo "*** mount output ***"                             >>$RESULT_DIR/$seq.full
+        _mount                                                  >>$RESULT_DIR/$seq.full
+        echo "*** end mount output"                             >>$RESULT_DIR/$seq.full
     elif [ "$type" = "$FSTYP" ]
     then
 	# was mounted ...
@@ -1889,8 +1889,8 @@ _scale_fsstress_args()
 
 run_check()
 {
-	echo "# $@" >> $seq.full 2>&1
-	"$@" >> $seq.full 2>&1 || _fail "failed: '$@'"
+	echo "# $@" >> $RESULT_DIR/$seq.full 2>&1
+	"$@" >> $RESULT_DIR/$seq.full 2>&1 || _fail "failed: '$@'"
 }
 
 ################################################################################
diff --git a/common.scsi_debug b/common.scsi_debug
index a085a67..f05c8db 100644
--- a/common.scsi_debug
+++ b/common.scsi_debug
@@ -47,7 +47,7 @@ _get_scsi_debug_dev()
 		let phys_exp=phys_exp+1
 	done
 	opts="sector_size=$logical physblk_exp=$phys_exp lowest_aligned=$unaligned dev_size_mb=$size"
-	echo "scsi_debug options $opts" >> $seq.full
+	echo "scsi_debug options $opts" >> $RESULT_DIR/$seq.full
 	modprobe scsi_debug $opts
 	[ $? -eq 0 ] || _fail "scsi_debug modprobe failed"
 	sleep 1
-- 
1.5.3.8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
