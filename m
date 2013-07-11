Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 59E107F3F
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 05:38:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 40D5D8F8037
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:38:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MRoI0HGrvONKejAY for
	<xfs@oss.sgi.com>; Thu, 11 Jul 2013 03:38:20 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r6BAcJ8D002451
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 06:38:20 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 07/10 v2] xfstests: Prepare for config section
Date: Thu, 11 Jul 2013 12:38:02 +0200
Message-Id: <1373539085-8577-8-git-send-email-lczerner@redhat.com>
In-Reply-To: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
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
Cc: lczerner@redhat.com

This stupid patch only put the indentation in place so we will be able
to clearly see and review changes made in the second patch which will
add a loop (instead of allways-true condition introduced in this patch)
adding support for config sections. There are no changes in the logic,
only indentation changes.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check | 314 +++++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 157 insertions(+), 157 deletions(-)

diff --git a/check b/check
index 428eba1..677650c 100755
--- a/check
+++ b/check
@@ -356,186 +356,186 @@ END	{ if (NR > 0) {
 
 trap "_wrapup; exit \$status" 0 1 2 3 15
 
-mkdir -p $RESULT_BASE
-if [ ! -d $RESULT_BASE ]; then
-	echo "failed to create results directory $RESULTS_BASE"
-	exit 1;
-fi
+if true; then
+	mkdir -p $RESULT_BASE
+	if [ ! -d $RESULT_BASE ]; then
+		echo "failed to create results directory $RESULTS_BASE"
+		exit 1;
+	fi
 
-seq="check"
-check="$RESULT_BASE/check"
+	seq="check"
+	check="$RESULT_BASE/check"
 
 # don't leave old full output behind on a clean run
-rm -f $check.full
+	rm -f $check.full
 
-[ -f $check.time ] || touch $check.time
+	[ -f $check.time ] || touch $check.time
 
 # print out our test configuration
-echo "FSTYP         -- `_full_fstyp_details`"
-echo "PLATFORM      -- `_full_platform_details`"
-if [ ! -z "$SCRATCH_DEV" ]; then
-  echo "MKFS_OPTIONS  -- `_scratch_mkfs_options`"
-  echo "MOUNT_OPTIONS -- `_scratch_mount_options`"
-fi
-echo
-
-
-if [ ! -z "$SCRATCH_DEV" ]; then
-  umount $SCRATCH_DEV 2>/dev/null
-  # call the overridden mkfs - make sure the FS is built
-  # the same as we'll create it later.
-
-  if ! _scratch_mkfs $flag >$tmp.err 2>&1
-  then
-      echo "our local _scratch_mkfs routine ..."
-      cat $tmp.err
-      echo "check: failed to mkfs \$SCRATCH_DEV using specified options"
-      exit 1
-  fi
-
-  # call the overridden mount - make sure the FS mounts with
-  # the same options that we'll mount with later.
-  if ! _scratch_mount >$tmp.err 2>&1
-  then
-      echo "our local mount routine ..."
-      cat $tmp.err
-      echo "check: failed to mount \$SCRATCH_DEV using specified options"
-      exit 1
-  fi
-fi
-
-seqres="$check"
-_check_test_fs
-
-for seq in $list
-do
-    err=false
+	echo "FSTYP         -- `_full_fstyp_details`"
+	echo "PLATFORM      -- `_full_platform_details`"
+	if [ ! -z "$SCRATCH_DEV" ]; then
+		echo "MKFS_OPTIONS  -- `_scratch_mkfs_options`"
+		echo "MOUNT_OPTIONS -- `_scratch_mount_options`"
+	fi
+	echo
 
-    # the filename for the test and the name output are different.
-    # we don't include the tests/ directory in the name output.
-    seqnum=`echo $seq | sed -e "s;$SRC_DIR/;;"`
 
-    # Similarly, the result directory needs to replace the tests/
-    # part of the test location.
-    group=`dirname $seq`
-    export RESULT_DIR=`echo $group | sed -e "s;$SRC_DIR;$RESULT_BASE;"`
-    mkdir -p $RESULT_DIR
-    seqres="$RESULT_BASE/$seqnum"
+	if [ ! -z "$SCRATCH_DEV" ]; then
+		umount $SCRATCH_DEV 2>/dev/null
+		# call the overridden mkfs - make sure the FS is built
+		# the same as we'll create it later.
 
-    echo -n "$seqnum"
+		if ! _scratch_mkfs $flag >$tmp.err 2>&1
+		then
+			echo "our local _scratch_mkfs routine ..."
+			cat $tmp.err
+			echo "check: failed to mkfs \$SCRATCH_DEV using specified options"
+			exit 1
+		fi
 
-    if $showme
-    then
-	echo
-	continue
-    elif [ ! -f $seq ]
-    then
-	echo " - no such test?"
-    else
-	# really going to try and run this one
-	#
-	rm -f $seqres.out.bad
-
-	# check if we really should run it
-	if [ -s $tmp.xlist ]; then
-		if grep $seqnum $tmp.xlist > /dev/null 2>&1 ; then
-			echo "       [expunged]"
-			continue
+		# call the overridden mount - make sure the FS mounts with
+		# the same options that we'll mount with later.
+		if ! _scratch_mount >$tmp.err 2>&1
+		then
+			echo "our local mount routine ..."
+			cat $tmp.err
+			echo "check: failed to mount \$SCRATCH_DEV using specified options"
+			exit 1
 		fi
 	fi
 
-	# slashes now in names, sed barfs on them so use grep
-	lasttime=`grep -w ^$seqnum $check.time | awk '// {print $2}'`
-	if [ "X$lasttime" != X ]; then
-		echo -n " ${lasttime}s ..."
-	else
-		echo -n "	"	# prettier output with timestamps.
-	fi
-	rm -f core $seqres.notrun
+	seqres="$check"
+	_check_test_fs
 
-	start=`_wallclock`
-	$timestamp && echo -n "	["`date "+%T"`"]"
-	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
-	$LOGGER_PROG "run xfstest $seqnum"
-	./$seq >$tmp.rawout 2>&1
-	sts=$?
-	$timestamp && _timestamp
-	stop=`_wallclock`
+	for seq in $list
+	do
+		err=false
 
-	_fix_malloc <$tmp.rawout >$tmp.out
-	rm -f $tmp.rawout
+		# the filename for the test and the name output are different.
+		# we don't include the tests/ directory in the name output.
+		seqnum=`echo $seq | sed -e "s;$SRC_DIR/;;"`
 
-	if [ -f core ]
-	then
-	    echo -n " [dumped core]"
-	    mv core $RESULT_BASE/$seqnum.core
-	    err=true
-	fi
+		# Similarly, the result directory needs to replace the tests/
+		# part of the test location.
+		group=`dirname $seq`
+		export RESULT_DIR=`echo $group | sed -e "s;$SRC_DIR;$RESULT_BASE;"`
+		mkdir -p $RESULT_DIR
+		seqres="$RESULT_BASE/$seqnum"
 
-	if [ -f $seqres.notrun ]
-	then
-	    $timestamp || echo -n " [not run] "
-	    $timestamp && echo " [not run]" && echo -n "	$seqnum -- "
-	    cat $seqres.notrun
-	    notrun="$notrun $seqnum"
-	else
-	    if [ $sts -ne 0 ]
-	    then
-		echo -n " [failed, exit status $sts]"
-		err=true
-	    fi
-	    if [ ! -f $seq.out ]
-	    then
-		echo " - no qualified output"
-		err=true
-	    else
-		if diff $seq.out $tmp.out >/dev/null 2>&1
+		echo -n "$seqnum"
+
+		if $showme
+		then
+			echo
+			continue
+		elif [ ! -f $seq ]
 		then
-		    if $err
-		    then
-			:
-		    else
-			echo "$seqnum `expr $stop - $start`" >>$tmp.time
-			echo -n " `expr $stop - $start`s"
-		    fi
-		    echo ""
+			echo " - no such test?"
 		else
-		    echo " - output mismatch (see $seqres.out.bad)"
-		    mv $tmp.out $seqres.out.bad
-		    $diff $seq.out $seqres.out.bad | {
-		        if test "$DIFF_LENGTH" -le 0; then
-				cat
+			# really going to try and run this one
+			#
+			rm -f $seqres.out.bad
+
+			# check if we really should run it
+			if [ -s $tmp.xlist ]; then
+				if grep $seqnum $tmp.xlist > /dev/null 2>&1 ; then
+					echo "       [expunged]"
+					continue
+				fi
+			fi
+
+			# slashes now in names, sed barfs on them so use grep
+			lasttime=`grep -w ^$seqnum $check.time | awk '// {print $2}'`
+			if [ "X$lasttime" != X ]; then
+				echo -n " ${lasttime}s ..."
 			else
-				head -n "$DIFF_LENGTH"
-			fi; } | \
-			sed -e 's/^\(.\)/    \1/'
-		    echo "     ..."
-		    echo "     (Run '$diff $seq.out $seqres.out.bad' to see the" \
-			 "entire diff)"
-		    err=true
-		fi
-	    fi
-	fi
+				echo -n "	"	# prettier output with timestamps.
+			fi
+			rm -f core $seqres.notrun
+
+			start=`_wallclock`
+			$timestamp && echo -n "	["`date "+%T"`"]"
+			[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
+			$LOGGER_PROG "run xfstest $seqnum"
+			./$seq >$tmp.rawout 2>&1
+			sts=$?
+			$timestamp && _timestamp
+			stop=`_wallclock`
+
+			_fix_malloc <$tmp.rawout >$tmp.out
+			rm -f $tmp.rawout
+
+			if [ -f core ]
+			then
+				echo -n " [dumped core]"
+				mv core $RESULT_BASE/$seqnum.core
+			    err=true
+			fi
 
-    fi
+			if [ -f $seqres.notrun ]
+			then
+				$timestamp || echo -n " [not run] "
+				$timestamp && echo " [not run]" && echo -n "	$seqnum -- "
+				cat $seqres.notrun
+				notrun="$notrun $seqnum"
+			else
+				if [ $sts -ne 0 ]
+				then
+					echo -n " [failed, exit status $sts]"
+					err=true
+				fi
+				if [ ! -f $seq.out ]
+				then
+					echo " - no qualified output"
+					err=true
+				else
+					if diff $seq.out $tmp.out >/dev/null 2>&1
+					then
+						if $err
+						then
+							:
+						else
+							echo "$seqnum `expr $stop - $start`" >>$tmp.time
+							echo -n " `expr $stop - $start`s"
+						fi
+						echo ""
+					else
+						echo " - output mismatch (see $seqres.out.bad)"
+						mv $tmp.out $seqres.out.bad
+						$diff $seq.out $seqres.out.bad | {
+						if test "$DIFF_LENGTH" -le 0; then
+							cat
+						else
+							head -n "$DIFF_LENGTH"
+						fi; } | \
+						sed -e 's/^\(.\)/    \1/'
+						echo "     ..."
+						echo "     (Run '$diff $seq.out $seqres.out.bad' to see the entire diff)"
+						err=true
+					fi
+				fi
+			fi
+		fi
 
-    # come here for each test, except when $showme is true
-    #
-    if $err
-    then
-	bad="$bad $seqnum"
-	n_bad=`expr $n_bad + 1`
-	quick=false
-    fi
-    if [ ! -f $seqres.notrun ]
-    then
-	try="$try $seqnum"
-	n_try=`expr $n_try + 1`
-        _check_test_fs
-    fi
+		# come here for each test, except when $showme is true
+		#
+		if $err
+		then
+			bad="$bad $seqnum"
+			n_bad=`expr $n_bad + 1`
+			quick=false
+		fi
+		if [ ! -f $seqres.notrun ]
+		then
+			try="$try $seqnum"
+			n_try=`expr $n_try + 1`
+			_check_test_fs
+		fi
 
-    seq="after_$seqnum"
-done
+		 seq="after_$seqnum"
+	done
+fi
 
 interrupt=false
 status=`expr $n_bad`
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
