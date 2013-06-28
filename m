Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 407D37F5E
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 08:32:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 01B738F8050
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 06:32:15 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xjP7GQSewkg9iMNK for
	<xfs@oss.sgi.com>; Fri, 28 Jun 2013 06:32:14 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5SDWCWY008575
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 09:32:13 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/3 v2] xfstests: Add support for sections in config file
Date: Fri, 28 Jun 2013 15:32:00 +0200
Message-Id: <1372426320-19902-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1372426320-19902-1-git-send-email-lczerner@redhat.com>
References: <1372426320-19902-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

This patch add support for sections in the config file. Each section can
contain configuration options in the format

OPTION=value

when one section is processed xfstests will proceed to next section
until all secitons are processed, or an error occur.

The name of the section can consist of alphanumeric characters + '_',
nothing else is allowed. Name of the section is also used to create
results subdirectory for each section. After all the sections are
processed summary of all runs is printed out.

If the config file does not contain sections, or we're not using config
file at all, nothing is changed and xfstests will work the same way as
it used to.

This is very useful for testing file system with different options. Here
is an example of the config file with sections:

[ext4_4k_block_size]
TEST_DEV=/dev/sda
TEST_DIR=/mnt/test
SCRATCH_DEV=/dev/sdb
SCRATCH_MNT=/mnt/test1
MKFS_OPTIONS="-q -F -b4096"
FSTYP=ext4

[ext4_1k_block_size]
MKFS_OPTIONS="-q -F -b1024"

[ext4_nojournal]
MKFS_OPTIONS="-q -F -b4096 -O ^has_journal"

[ext4_discard_ssd]
MKFS_OPTIONS="-q -F -b4096"
TEST_DEV=/dev/sdc
SCRATCH_DEV=/dev/sdd
MOUNT_OPTIONS="-o discard"

Note that once the variable is set it remains set across the sections, so
you do not have to specify all the options in all sections. However one
have to make sure that unwanted options are not set from previous
sections.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check         | 371 +++++++++++++++++++++++++++++++++-------------------------
 common/config | 126 ++++++++++++--------
 common/rc     |  63 +++++-----
 3 files changed, 326 insertions(+), 234 deletions(-)

diff --git a/check b/check
index 1fded37..e8519a5 100755
--- a/check
+++ b/check
@@ -22,9 +22,11 @@
 tmp=/tmp/$$
 status=0
 needwrap=true
+needsum=true
 n_try=0
 try=""
 n_bad=0
+sum_bad=0
 bad=""
 notrun=""
 interrupt=true
@@ -66,7 +68,6 @@ export FSTYP
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
 SRC_GROUPS="generic shared"
 export SRC_DIR="tests"
-export RESULT_BASE=${RESULT_BASE:="$here/results"}
 
 usage()
 {
@@ -296,7 +297,12 @@ then
     exit 1
 fi
 
-# Ok, time to start running...
+_wipe_counters()
+{
+	n_try="0"
+	n_bad="0"
+	unset try notrun bad
+}
 
 _wrapup()
 {
@@ -325,16 +331,20 @@ END	{ if (NR > 0) {
 	date >>$check.log
 	echo $list | fmt | sed -e 's/^/    /' -e "s;$SRC_DIR/;;g" >>$check.log
 	$interrupt && echo "Interrupted!" >>$check.log
-        
+
+	echo "SECTION       -- $section" >>$tmp.summary
+	echo "=========================" >>$tmp.summary
         if [ ! -z "$n_try" -a $n_try != 0 ]
 	then
 	    echo "Ran:$try"
+	    echo "Ran:$try" >>$tmp.summary
 	fi
 
 	if [ ! -z "$notrun" ]
 	then
 	    echo "Not run:$notrun"
 	    echo "Not run:$notrun" >>$check.log
+	    echo "Not run:$notrun" >>$tmp.summary
 	fi
 
         if [ ! -z "$n_bad" -a $n_bad != 0 ]
@@ -343,200 +353,245 @@ END	{ if (NR > 0) {
 	    echo "Failed $n_bad of $n_try tests"
 	    echo "Failures:$bad" | fmt >>$check.log
 	    echo "Failed $n_bad of $n_try tests" >>$check.log
+	    echo "Failures:$bad" >>$tmp.summary
+	    echo "Failed $n_bad of $n_try tests" >>$tmp.summary
 	else
 	    echo "Passed all $n_try tests"
 	    echo "Passed all $n_try tests" >>$check.log
+	    echo "Passed all $n_try tests" >>$tmp.summary
 	fi
+	echo "" >>$tmp.summary
 	needwrap=false
     fi
 
+    sum_bad=`expr $sum_bad + $n_bad`
+    _wipe_counters
     rm -f /tmp/*.rawout /tmp/*.out /tmp/*.err /tmp/*.time
-    rm -f $tmp.*
+    if ! $OPTIONS_HAVE_SECTIONS; then
+        rm -f $tmp.*
+    fi
 }
 
-trap "_wrapup; exit \$status" 0 1 2 3 15
-
-mkdir -p $RESULT_BASE
-if [ ! -d $RESULT_BASE ]; then
-	echo "failed to create results directory $RESULTS_BASE"
-	exit 1;
-fi
+_summary()
+{
+	_wrapup
+	if $showme; then
+		:
+	elif $needsum; then
+		count=`wc -L $tmp.summary | cut -f1 -d" "`
+		cat $tmp.summary
+		needsum=false
+	fi
+	rm -f $tmp.*
+}
 
-seq="check"
-check="$RESULT_BASE/check"
+# Ok, time to start running...
 
-# don't leave old full output behind on a clean run
-rm -f $check.full
+if $OPTIONS_HAVE_SECTIONS; then
+	trap "_summary; exit \$status" 0 1 2 3 15
+else
+	trap "_wrapup; exit \$status" 0 1 2 3 15
+fi
 
-[ -f $check.time ] || touch $check.time
+for section in $HOST_OPTIONS_SECTIONS; do
 
-# print out our test configuration
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
+	if $OPTIONS_HAVE_SECTIONS; then
+		export RESULT_BASE="$here/results/$section"
+	else
+		export RESULT_BASE="$here/results/"
+	fi
 
-seqres="$check"
-_check_test_fs
+	get_next_config $section
+	init_rc
 
-for seq in $list
-do
-    err=false
+	mkdir -p $RESULT_BASE
+	if [ ! -d $RESULT_BASE ]; then
+		echo "failed to create results directory $RESULTS_BASE"
+		exit 1;
+	fi
 
-    # the filename for the test and the name output are different.
-    # we don't include the tests/ directory in the name output.
-    seqnum=`echo $seq | sed -e "s;$SRC_DIR/;;"`
+	seq="check"
+	check="$RESULT_BASE/check"
 
-    # Similarly, the result directory needs to replace the tests/
-    # part of the test location.
-    group=`dirname $seq`
-    export RESULT_DIR=`echo $group | sed -e "s;$SRC_DIR;$RESULT_BASE;"`
-    mkdir -p $RESULT_DIR
-    seqres="$RESULT_BASE/$seqnum"
+	# don't leave old full output behind on a clean run
+	rm -f $check.full
 
-    echo -n "$seqnum"
+	[ -f $check.time ] || touch $check.time
 
-    if $showme
-    then
+	# print out our test configuration
+	if $OPTIONS_HAVE_SECTIONS; then
+		echo "SECTION       -- $section"
+	fi
+	echo "FSTYP         -- `_full_fstyp_details`"
+	echo "PLATFORM      -- `_full_platform_details`"
+	if [ ! -z "$SCRATCH_DEV" ]; then
+	  echo "MKFS_OPTIONS  -- `_scratch_mkfs_options`"
+	  echo "MOUNT_OPTIONS -- `_scratch_mount_options`"
+	fi
 	echo
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
-		fi
+	needwrap=true
+
+
+	if [ ! -z "$SCRATCH_DEV" ]; then
+	  umount $SCRATCH_DEV 2>/dev/null
+	  # call the overridden mkfs - make sure the FS is built
+	  # the same as we'll create it later.
+
+	  if ! _scratch_mkfs $flag >$tmp.err 2>&1
+	  then
+	      echo "our local _scratch_mkfs routine ..."
+	      cat $tmp.err
+	      echo "check: failed to mkfs \$SCRATCH_DEV using specified options"
+	      exit 1
+	  fi
+
+	  # call the overridden mount - make sure the FS mounts with
+	  # the same options that we'll mount with later.
+	  if ! _scratch_mount >$tmp.err 2>&1
+	  then
+	      echo "our local mount routine ..."
+	      cat $tmp.err
+	      echo "check: failed to mount \$SCRATCH_DEV using specified options"
+	      exit 1
+	  fi
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
+	    err=false
 
-	_fix_malloc <$tmp.rawout >$tmp.out
-	rm -f $tmp.rawout
+	    # the filename for the test and the name output are different.
+	    # we don't include the tests/ directory in the name output.
+	    seqnum=`echo $seq | sed -e "s;$SRC_DIR/;;"`
 
-	if [ -f core ]
-	then
-	    echo -n " [dumped core]"
-	    mv core $RESULT_BASE/$seqnum.core
-	    err=true
-	fi
+	    # Similarly, the result directory needs to replace the tests/
+	    # part of the test location.
+	    group=`dirname $seq`
+	    export RESULT_DIR=`echo $group | sed -e "s;$SRC_DIR;$RESULT_BASE;"`
+	    mkdir -p $RESULT_DIR
+	    seqres="$RESULT_BASE/$seqnum"
 
-	if [ -f $seqres.notrun ]
-	then
-	    $timestamp || echo -n " [not run] "
-	    $timestamp && echo " [not run]" && echo -n "	$seqnum -- "
-	    cat $seqres.notrun
-	    notrun="$notrun $seqnum"
-	else
-	    if [ $sts -ne 0 ]
+	    echo -n "$seqnum"
+
+	    if $showme
 	    then
-		echo -n " [failed, exit status $sts]"
-		err=true
-	    fi
-	    if [ ! -f $seq.out ]
+		echo
+		continue
+	    elif [ ! -f $seq ]
 	    then
-		echo " - no qualified output"
-		err=true
+		echo " - no such test?"
 	    else
-		if diff $seq.out $tmp.out >/dev/null 2>&1
+		# really going to try and run this one
+		#
+		rm -f $seqres.out.bad
+
+		# check if we really should run it
+		if [ -s $tmp.xlist ]; then
+			if grep $seqnum $tmp.xlist > /dev/null 2>&1 ; then
+				echo "       [expunged]"
+				continue
+			fi
+		fi
+
+		# slashes now in names, sed barfs on them so use grep
+		lasttime=`grep -w ^$seqnum $check.time | awk '// {print $2}'`
+		if [ "X$lasttime" != X ]; then
+			echo -n " ${lasttime}s ..."
+		else
+			echo -n "	"	# prettier output with timestamps.
+		fi
+		rm -f core $seqres.notrun
+
+		start=`_wallclock`
+		$timestamp && echo -n "	["`date "+%T"`"]"
+		[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
+		$LOGGER_PROG "run xfstest $seqnum"
+		./$seq >$tmp.rawout 2>&1
+		sts=$?
+		$timestamp && _timestamp
+		stop=`_wallclock`
+
+		_fix_malloc <$tmp.rawout >$tmp.out
+		rm -f $tmp.rawout
+
+		if [ -f core ]
+		then
+		    echo -n " [dumped core]"
+		    mv core $RESULT_BASE/$seqnum.core
+		    err=true
+		fi
+
+		if [ -f $seqres.notrun ]
 		then
-		    if $err
+		    $timestamp || echo -n " [not run] "
+		    $timestamp && echo " [not run]" && echo -n "	$seqnum -- "
+		    cat $seqres.notrun
+		    notrun="$notrun $seqnum"
+		else
+		    if [ $sts -ne 0 ]
 		    then
-			:
-		    else
-			echo "$seqnum `expr $stop - $start`" >>$tmp.time
-			echo -n " `expr $stop - $start`s"
+			echo -n " [failed, exit status $sts]"
+			err=true
 		    fi
-		    echo ""
-		else
-		    echo " - output mismatch (see $seqres.out.bad)"
-		    mv $tmp.out $seqres.out.bad
-		    $diff $seq.out $seqres.out.bad | {
-		        if test "$DIFF_LENGTH" -le 0; then
-				cat
+		    if [ ! -f $seq.out ]
+		    then
+			echo " - no qualified output"
+			err=true
+		    else
+			if diff $seq.out $tmp.out >/dev/null 2>&1
+			then
+			    if $err
+			    then
+				:
+			    else
+				echo "$seqnum `expr $stop - $start`" >>$tmp.time
+				echo -n " `expr $stop - $start`s"
+			    fi
+			    echo ""
 			else
-				head -n "$DIFF_LENGTH"
-			fi; } | \
-			sed -e 's/^\(.\)/    \1/'
-		    echo "     ..."
-		    echo "     (Run '$diff $seq.out $seqres.out.bad' to see the" \
-			 "entire diff)"
-		    err=true
+			    echo " - output mismatch (see $seqres.out.bad)"
+			    mv $tmp.out $seqres.out.bad
+			    $diff $seq.out $seqres.out.bad | {
+				if test "$DIFF_LENGTH" -le 0; then
+					cat
+				else
+					head -n "$DIFF_LENGTH"
+				fi; } | \
+				sed -e 's/^\(.\)/    \1/'
+			    echo "     ..."
+			    echo "     (Run '$diff $seq.out $seqres.out.bad' to see the" \
+				 "entire diff)"
+			    err=true
+			fi
+		    fi
 		fi
-	    fi
-	fi
 
-    fi
+	    fi
 
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
+	    # come here for each test, except when $showme is true
+	    #
+	    if $err
+	    then
+		bad="$bad $seqnum"
+		n_bad=`expr $n_bad + 1`
+		quick=false
+	    fi
+	    if [ ! -f $seqres.notrun ]
+	    then
+		try="$try $seqnum"
+		n_try=`expr $n_try + 1`
+		_check_test_fs
+	    fi
 
-    seq="after_$seqnum"
+	    seq="after_$seqnum"
+	done
+	_wrapup
+        echo
 done
 
 interrupt=false
-status=`expr $n_bad`
+status=`expr $sum_bad`
 exit
diff --git a/common/config b/common/config
index 67c1498..87488f7 100644
--- a/common/config
+++ b/common/config
@@ -216,62 +216,96 @@ known_hosts()
 {
   [ "$HOST_CONFIG_DIR" ] || HOST_CONFIG_DIR=`pwd`/configs
 
-  [ -f /etc/xfsqa.config ]             && . /etc/xfsqa.config
-  [ -f $HOST_CONFIG_DIR/$HOST ]        && . $HOST_CONFIG_DIR/$HOST
-  [ -f $HOST_CONFIG_DIR/$HOST.config ] && . $HOST_CONFIG_DIR/$HOST.config
-
-  #  Mandatory Config values.
-  MC=""
-  [ -z "$EMAIL" ]          && MC="$MC EMAIL"
-  [ -z "$TEST_DIR" ]       && MC="$MC TEST_DIR"
-  [ -z "$TEST_DEV" ]       && MC="$MC TEST_DEV"
-
-  if [ -n "$MC" ]; then
-    echo "Warning: need to define parameters for host $HOST"
-    echo "       or set variables:"
-    echo "       $MC"
-    exit 1
-  fi
+  [ -f /etc/xfsqa.config ]             && export HOST_OPTIONS=/etc/xfsqa.config
+  [ -f $HOST_CONFIG_DIR/$HOST ]        && export HOST_OPTIONS=$HOST_CONFIG_DIR/$HOST
+  [ -f $HOST_CONFIG_DIR/$HOST.config ] && export HOST_OPTIONS=$HOST_CONFIG_DIR/$HOST.config
 }
 
-if [ -f "$HOST_OPTIONS" ]; then
-    . "$HOST_OPTIONS"
-else
-    known_hosts
-fi
+get_config_sections() {
+    sed -n -e "s/^\[\([[:alnum:]_]*\)\]/\1/p" < $1
+}
 
-echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
-if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
-    echo "common/config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
-    exit 1
-fi
 
-if [ ! -d "$TEST_DIR" ]; then
-    echo "common/config: Error: \$TEST_DIR ($TEST_DIR) is not a directory"
-    exit 1
+if [ ! -f "$HOST_OPTIONS" ]; then
+    known_hosts
 fi
 
-# a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of its dev
-# to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
-if [ ! -z "$SCRATCH_DEV_POOL" ]; then
-    if [ ! -z "$SCRATCH_DEV" ]; then
-        echo "common/config: Error: \$SCRATCH_DEV should be unset when \$SCRATCH_DEV_POOL is set"
-        exit 1
+export HOST_OPTIONS_SECTIONS="__already_configured__"
+export OPTIONS_HAVE_SECTIONS=false
+if [ -f "$HOST_OPTIONS" ]; then
+    export HOST_OPTIONS_SECTIONS=`get_config_sections $HOST_OPTIONS`
+    if [ -z "$HOST_OPTIONS_SECTIONS" ]; then
+        . $HOST_OPTIONS
+        export HOST_OPTIONS_SECTIONS="__already_configured__"
+    else
+        export OPTIONS_HAVE_SECTIONS=true
     fi
-    SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
-    SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ ORS=" "; for (i = 2; i <= NF; i++) print $i}'`
 fi
 
-echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
-if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then
-    echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS filesystem"
-    exit 1
-fi
+parse_config_section() {
+	SECTION=$1
+	if ! $OPTIONS_HAVE_SECTIONS; then
+		return 0
+	fi
+	eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
+		-e 's/#.*$//' \
+		-e 's/[[:space:]]*$//' \
+		-e 's/^[[:space:]]*//' \
+		-e "s/^\(.*\)=\([^\"']*\)$/export \1=\"\2\"/" \
+		< $HOST_OPTIONS \
+		| sed -n -e "/^\[$SECTION\]/,/^\s*\[/{/^[^;].*\=.*/p;}"`
+}
 
-if [ ! -z "$SCRATCH_MNT" -a ! -d "$SCRATCH_MNT" ]; then
-    echo "common/config: Error: \$SCRATCH_MNT ($SCRATCH_MNT) is not a directory"
-    exit 1
-fi
+get_next_config() {
+	parse_config_section $1
+	#  Mandatory Config values.
+	MC=""
+	[ -z "$EMAIL" ]          && MC="$MC EMAIL"
+	[ -z "$TEST_DIR" ]       && MC="$MC TEST_DIR"
+	[ -z "$TEST_DEV" ]       && MC="$MC TEST_DEV"
+
+	if [ -n "$MC" ]; then
+		echo "Warning: need to define parameters for host $HOST"
+		echo "       or set variables:"
+		echo "       $MC"
+		exit 1
+	fi
+
+	echo $TEST_DEV | grep -q ":" > /dev/null 2>&1
+	if [ ! -b "$TEST_DEV" -a "$?" != "0" ]; then
+	    echo "common/config: Error: \$TEST_DEV ($TEST_DEV) is not a block device or a NFS filesystem"
+	    exit 1
+	fi
+
+	if [ ! -d "$TEST_DIR" ]; then
+	    echo "common/config: Error: \$TEST_DIR ($TEST_DIR) is not a directory"
+	    exit 1
+	fi
+
+	# a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of its dev
+	# to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
+	if [ ! -z "$SCRATCH_DEV_POOL" ]; then
+	    if [ ! -z "$SCRATCH_DEV" ]; then
+		echo "common/config: Error: \$SCRATCH_DEV should be unset when \$SCRATCH_DEV_POOL is set"
+		exit 1
+	    fi
+	    SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
+	    SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ ORS=" "; for (i = 2; i <= NF; i++) print $i}'`
+	fi
+
+	echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
+	if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then
+	    echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS filesystem"
+	    exit 1
+	fi
+
+	if [ ! -z "$SCRATCH_MNT" -a ! -d "$SCRATCH_MNT" ]; then
+	    echo "common/config: Error: \$SCRATCH_MNT ($SCRATCH_MNT) is not a directory"
+	    exit 1
+	fi
+}
+
+get_next_config `echo $HOST_OPTIONS_SECTIONS | cut -f1 -d" "`
 
 # make sure this script returns success
 /bin/true
diff --git a/common/rc b/common/rc
index fe6bbfc..7b9349e 100644
--- a/common/rc
+++ b/common/rc
@@ -2131,46 +2131,49 @@ run_check()
 	"$@" >> $seqres.full 2>&1 || _fail "failed: '$@'"
 }
 
-################################################################################
-
-if [ "$iam" != new ]
-then
-    # make some further configuration checks here
-
-    if [ "$TEST_DEV" = ""  ]
+init_rc()
+{
+    if [ "$iam" != new ]
     then
-        echo "common/rc: Error: \$TEST_DEV is not set"
-        exit 1
-    fi
+        # make some further configuration checks here
 
-    # if $TEST_DEV is not mounted, mount it now as XFS
-    if [ -z "`_fs_type $TEST_DEV`" ]
-    then
-        # $TEST_DEV is not mounted
-        if ! _test_mount
+        if [ "$TEST_DEV" = ""  ]
+        then
+            echo "common/rc: Error: \$TEST_DEV is not set"
+            exit 1
+        fi
+
+        # if $TEST_DEV is not mounted, mount it now as XFS
+        if [ -z "`_fs_type $TEST_DEV`" ]
         then
-            echo "common/rc: retrying test device mount with external set"
-            [ "$USE_EXTERNAL" != "yes" ] && export USE_EXTERNAL=yes
+            # $TEST_DEV is not mounted
             if ! _test_mount
             then
-                echo "common/rc: could not mount $TEST_DEV on $TEST_DIR"
-                exit 1
+                echo "common/rc: retrying test device mount with external set"
+                [ "$USE_EXTERNAL" != "yes" ] && export USE_EXTERNAL=yes
+                if ! _test_mount
+                then
+                    echo "common/rc: could not mount $TEST_DEV on $TEST_DIR"
+                    exit 1
+                fi
             fi
         fi
-    fi
 
-    if [ "`_fs_type $TEST_DEV`" != "$FSTYP" ]
-    then
-        echo "common/rc: Error: \$TEST_DEV ($TEST_DEV) is not a MOUNTED $FSTYP filesystem"
-        $DF_PROG $TEST_DEV
-        exit 1
-    fi
+        if [ "`_fs_type $TEST_DEV`" != "$FSTYP" ]
+        then
+            echo "common/rc: Error: \$TEST_DEV ($TEST_DEV) is not a MOUNTED $FSTYP filesystem"
+            $DF_PROG $TEST_DEV
+            exit 1
+        fi
+        # Figure out if we need to add -F ("foreign", deprecated) option to xfs_io
+        xfs_io -c stat $TEST_DIR 2>&1 | grep -q "is not on an XFS filesystem" && \
+        export XFS_IO_PROG="$XFS_IO_PROG -F"
 
-    # Figure out if we need to add -F ("foreign", deprecated) option to xfs_io
-    xfs_io -c stat $TEST_DIR 2>&1 | grep -q "is not on an XFS filesystem" && \
-	export XFS_IO_PROG="$XFS_IO_PROG -F"
+    fi
+}
 
-fi
+init_rc
 
+################################################################################
 # make sure this script returns success
 /bin/true
-- 
1.8.2.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
