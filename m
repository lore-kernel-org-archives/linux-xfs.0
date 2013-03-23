Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id BD9CE7F51
	for <xfs@oss.sgi.com>; Sat, 23 Mar 2013 05:24:31 -0500 (CDT)
Date: Sat, 23 Mar 2013 03:24:29 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 22/25] xfstests: RESULTS_DIR needs to be an absolute path
Message-ID: <20130323102429.GZ25253@caliban.engr.sgi.com>
References: <1363350489-22257-1-git-send-email-david@fromorbit.com>
	<1363350489-22257-23-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363350489-22257-23-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Looks OK.

Reviewed-by: Phil White <pwhite@sgi.com>

On Fri, Mar 15, 2013 at 11:28:06PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Some tests 'cd <somedir>' and then direct output to $RESULT_DIR,
> which fails if the current working directory is not $here.
> Regardless, if an external results directory is to be used it needs
> to have a full path specified and the use of $here as the base of
> the results files is completely incorrect.
> 
> Hence change all the $here/$seqres* references to simply be
> $seqres*, and instead encode the full path to the results in
> $RESULT_DIR.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  check              |   55 ++++++++++++-----------------
>  common/attr        |    4 +--
>  common/defrag      |    4 +--
>  common/dump        |   86 ++++++++++++++++++++++-----------------------
>  common/filestreams |    4 +--
>  common/log         |   36 +++++++++----------
>  common/quota       |   18 +++++-----
>  common/rc          |   98 ++++++++++++++++++++++++++--------------------------
>  common/scsi_debug  |    2 +-
>  tests/generic/001  |    8 ++---
>  tests/generic/010  |    2 +-
>  tests/generic/013  |   12 +++----
>  tests/generic/074  |    2 +-
>  tests/generic/075  |   10 +++---
>  tests/generic/089  |    4 +--
>  tests/generic/100  |    8 ++---
>  tests/generic/112  |    4 +--
>  tests/generic/192  |    2 +-
>  tests/generic/232  |    8 ++---
>  tests/generic/233  |    8 ++---
>  tests/generic/269  |    4 +--
>  tests/generic/270  |    4 +--
>  tests/shared/305   |   12 +++----
>  tests/xfs/008      |   18 +++++-----
>  tests/xfs/012      |   30 ++++++++--------
>  tests/xfs/024      |    4 +--
>  tests/xfs/067      |    6 ++--
>  tests/xfs/114      |   30 ++++++++--------
>  tests/xfs/115      |    8 ++---
>  tests/xfs/168      |    2 +-
>  tests/xfs/186      |    4 +--
>  tests/xfs/282      |    4 +--
>  tests/xfs/283      |    4 +--
>  33 files changed, 247 insertions(+), 258 deletions(-)
> 
> diff --git a/check b/check
> index 17bc004..18cae75 100755
> --- a/check
> +++ b/check
> @@ -36,25 +36,38 @@ here=`pwd`
>  FSTYP=xfs
>  xfile=""
>  
> -SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
> -SRC_GROUPS="generic shared"
> -export SRC_DIR="tests"
> -export RESULT_BASE=${RESULT_BASE:="results"}
> -
> -# generic initialization
> +# start the initialisation work now
>  iam=check
>  
> +export MSGVERB="text:action"
>  export QA_CHECK_FS=${QA_CHECK_FS:=true}
>  
> -# by default don't output timestamps
> -timestamp=${TIMESTAMP:=false}
> -
>  # number of diff lines from a failed test, 0 for whole output
>  export DIFF_LENGTH=${DIFF_LENGTH:=10}
>  
>  # by default don't output timestamps
>  timestamp=${TIMESTAMP:=false}
>  
> +rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.xlist
> +
> +# Autodetect fs type based on what's on $TEST_DEV
> +if [ "$HOSTOS" == "Linux" ]; then
> +    FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
> +fi
> +export FSTYP
> +
> +# we need common.config
> +if ! . ./common/config
> +then
> +    echo "$iam: failed to source common/config"
> +    exit 1
> +fi
> +
> +SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
> +SRC_GROUPS="generic shared"
> +export SRC_DIR="tests"
> +export RESULT_BASE=${RESULT_BASE:="$here/results"}
> +
>  usage()
>  {
>      echo "Usage: $0 [options] [testlist]"'
> @@ -79,12 +92,6 @@ testlist options
>  	    exit 0
>  }
>  
> -_setenvironment()
> -{
> -    MSGVERB="text:action"
> -    export MSGVERB
> -}
> -
>  get_group_list()
>  {
>  	grp=$1
> @@ -147,24 +154,6 @@ _timestamp()
>      echo -n " [$now]"
>  }
>  
> -# start the initialisation work now
> -_setenvironment
> -
> -rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out $tmp.xlist
> -
> -# Autodetect fs type based on what's on $TEST_DEV
> -if [ "$HOSTOS" == "Linux" ]; then
> -    FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
> -fi
> -export FSTYP
> -
> -# we need common.config
> -if ! . ./common/config
> -then
> -    echo "$iam: failed to source common/config"
> -    exit 1
> -fi
> -
>  # Process command arguments first.
>  while [ $# -gt 0 ]; do
>  	case "$1" in
> diff --git a/common/attr b/common/attr
> index 69bcb01..e5070bf 100644
> --- a/common/attr
> +++ b/common/attr
> @@ -129,7 +129,7 @@ _require_acls()
>      #
>      touch $TEST_DIR/syscalltest
>      chacl -l $TEST_DIR/syscalltest > $TEST_DIR/syscalltest.out 2>&1
> -    cat $TEST_DIR/syscalltest.out >> $RESULT_DIR/$seq.full
> +    cat $TEST_DIR/syscalltest.out >> $seqres.full
>  
>      if grep -q 'Function not implemented' $TEST_DIR/syscalltest.out; then
>        _notrun "kernel does not support ACLs"
> @@ -164,7 +164,7 @@ _require_attrs()
>      #
>      touch $TEST_DIR/syscalltest
>      attr -s "user.xfstests" -V "attr" $TEST_DIR > $TEST_DIR/syscalltest.out 2>&1
> -    cat $TEST_DIR/syscalltest.out >> $RESULT_DIR/$seq.full
> +    cat $TEST_DIR/syscalltest.out >> $seqres.full
>  
>      if grep -q 'Function not implemented' $TEST_DIR/syscalltest.out; then
>        _notrun "kernel does not support attrs"
> diff --git a/common/defrag b/common/defrag
> index 13405a4..f04fd42 100644
> --- a/common/defrag
> +++ b/common/defrag
> @@ -44,7 +44,7 @@ _require_defrag()
>  _extent_count()
>  {
>  	$FILEFRAG_PROG $1 | awk '{print $2}'
> -	$FILEFRAG_PROG -v $1  >> $RESULT_DIR/$seq.full 2>&1
> +	$FILEFRAG_PROG -v $1  >> $seqres.full 2>&1
>  }
>  
>  # Defrag file, check it, and remove it.
> @@ -54,7 +54,7 @@ _defrag()
>  	_extent_count $1
>  	CSUM_BEFORE=`md5sum $1`
>  	STAT_BEFORE=`stat -c "a: %x m: %y c: %z" $1`
> -	$DEFRAG_PROG -v $1 >> $RESULT_DIR/$seq.full 2>&1
> +	$DEFRAG_PROG -v $1 >> $seqres.full 2>&1
>  	_scratch_remount
>  	STAT_AFTER=`stat -c "a: %x m: %y c: %z" $1`
>  	CSUM_AFTER=`md5sum $1`
> diff --git a/common/dump b/common/dump
> index 0395ee3..3df6191 100644
> --- a/common/dump
> +++ b/common/dump
> @@ -20,7 +20,7 @@
>  #
>  
>  # --- initializations ---
> -rm -f $RESULT_DIR/$seq.full
> +rm -f $seqres.full
>  
>  if [ -n "$DEBUGDUMP" ]; then
>  	_dump_debug=-v4
> @@ -125,7 +125,7 @@ _check_onl()
>      _limit=10
>      i=0
>      while [ $i -lt $_limit ]; do
> -        echo "Checking online..." >>$RESULT_DIR/$seq.full
> +        echo "Checking online..." >>$seqres.full
>  	if _mt status >$tmp.status 2>&1; then
>  	    break;
>  	else
> @@ -159,12 +159,12 @@ _check_onl()
>  
>  _wait_tape()
>  {
> -    echo "Wait for tape, $dumptape, ..." >>$RESULT_DIR/$seq.full
> +    echo "Wait for tape, $dumptape, ..." >>$seqres.full
>  
>      i=0
>      while [ $i -lt 20 ]; do
> -        echo "Checking status..." >>$RESULT_DIR/$seq.full
> -	if _mt status 2>&1 | tee -a $RESULT_DIR/$seq.full | egrep -i "onl|ready" >/dev/null; then
> +        echo "Checking status..." >>$seqres.full
> +	if _mt status 2>&1 | tee -a $seqres.full | egrep -i "onl|ready" >/dev/null; then
>  	    break;
>  	else
>  	    sleep 1
> @@ -178,7 +178,7 @@ _wait_tape()
>  #
>  _rewind()
>  {
> -    echo "Initiate rewind..." >>$RESULT_DIR/$seq.full
> +    echo "Initiate rewind..." >>$seqres.full
>      _wait_tape
>      _mt rewind >/dev/null
>      _wait_tape
> @@ -191,7 +191,7 @@ _rewind()
>  #
>  _erase_soft()
>  {
> -    echo "Erasing tape" | tee -a $RESULT_DIR/$seq.full
> +    echo "Erasing tape" | tee -a $seqres.full
>      _rewind
>      _mt weof 3
>      _rewind
> @@ -199,7 +199,7 @@ _erase_soft()
>  
>  _erase_hard()
>  {
> -    echo "Erasing tape" | tee -a $RESULT_DIR/$seq.full
> +    echo "Erasing tape" | tee -a $seqres.full
>      _mt erase
>  }
>  
> @@ -230,7 +230,7 @@ _require_tape()
>  
>      if [ -z "$dumptape" -o "@" == "$dumptape" ]; then
>          echo "This test requires a dump tape - none was specified"
> -	echo "No dump tape specified" >$RESULT_DIR/$seq.notrun
> +	echo "No dump tape specified" >$seqres.notrun
>  	status=$NOTRUNSTS
>  	exit
>      fi
> @@ -243,8 +243,8 @@ _wipe_fs()
>  {
>      _require_scratch
>  
> -    _scratch_mkfs_xfs >>$RESULT_DIR/$seq.full || _fail "mkfs failed"
> -    _scratch_mount >>$RESULT_DIR/$seq.full || _fail "mount failed"
> +    _scratch_mkfs_xfs >>$seqres.full || _fail "mkfs failed"
> +    _scratch_mount >>$seqres.full || _fail "mount failed"
>  }
>  
>  #
> @@ -266,8 +266,8 @@ _cleanup()
>  	# save it for inspection
>  	for dir in /var/xfsdump/inventory /var/lib/xfsdump/inventory; do
>  	    [ -d $dir ] || continue
> -	    tar -cvf $RESULT_DIR/$seq.inventory.tar $dir
> -	    ls -nR $dir >$RESULT_DIR/$seq.inventory.ls
> +	    tar -cvf $seqres.inventory.tar $dir
> +	    ls -nR $dir >$seqres.inventory.ls
>  	done
>      fi
>  
> @@ -295,8 +295,8 @@ _cleanup()
>  _stable_fs()
>  {
>      _saveddir=`pwd`; cd /
> -    umount $SCRATCH_MNT >>$RESULT_DIR/$seq.full || _fail "unmount failed"
> -    _scratch_mount >>$RESULT_DIR/$seq.full || _fail "mount failed"
> +    umount $SCRATCH_MNT >>$seqres.full || _fail "unmount failed"
> +    _scratch_mount >>$seqres.full || _fail "mount failed"
>      cd $_saveddir
>  }
>  
> @@ -326,12 +326,12 @@ _create_dumpdir_stress()
>      echo "-----------------------------------------------"
>      if ! $here/ltp/fsstress $_param -s 1 $FSSTRESS_AVOID -n $_count -d $dump_dir >$tmp.out 2>&1
>      then
> -        echo "    fsstress (count=$_count) returned $? - see $RESULT_DIR/$seq.full"
> +        echo "    fsstress (count=$_count) returned $? - see $seqres.full"
>  
> -        echo "--------------------------------------"       >>$RESULT_DIR/$seq.full
> -        echo "output from fsstress:"                        >>$RESULT_DIR/$seq.full
> -        echo "--------------------------------------"       >>$RESULT_DIR/$seq.full
> -        cat $tmp.out                                        >>$RESULT_DIR/$seq.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        echo "output from fsstress:"                        >>$seqres.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        cat $tmp.out                                        >>$seqres.full
>          status=1
>      fi
>  
> @@ -1043,7 +1043,7 @@ _do_dump_sub()
>      echo "Dumping to tape..."
>      opts="$_dump_debug$dump_args -s $dump_sdir -f $dumptape -M $media_label -L $session_label $SCRATCH_MNT"
>      echo "xfsdump $opts" | _dir_filter
> -    $XFSDUMP_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
> +    $XFSDUMP_PROG $opts 2>&1 | tee -a $seqres.full | _dump_filter
>  }
>  
>  #
> @@ -1056,7 +1056,7 @@ _do_dump()
>      echo "Dumping to tape..."
>      opts="$_dump_debug$dump_args -f $dumptape -M $media_label -L $session_label $SCRATCH_MNT"
>      echo "xfsdump $opts" | _dir_filter
> -    $XFSDUMP_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
> +    $XFSDUMP_PROG $opts 2>&1 | tee -a $seqres.full | _dump_filter
>  }
>  
>  
> @@ -1071,7 +1071,7 @@ _do_dump_min()
>      onemeg=1048576
>      opts="$_dump_debug$dump_args -m -b $onemeg -l0 -f $dumptape -M $media_label -L $session_label $SCRATCH_MNT"
>      echo "xfsdump $opts" | _dir_filter
> -    $XFSDUMP_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
> +    $XFSDUMP_PROG $opts 2>&1 | tee -a $seqres.full | _dump_filter
>  }
>  
>  
> @@ -1085,7 +1085,7 @@ _do_dump_file()
>      echo "Dumping to file..."
>      opts="$_dump_debug$dump_args -f $dump_file -M $media_label -L $session_label $SCRATCH_MNT"
>      echo "xfsdump $opts" | _dir_filter
> -    $XFSDUMP_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
> +    $XFSDUMP_PROG $opts 2>&1 | tee -a $seqres.full | _dump_filter
>  }
>  
>  #
> @@ -1107,7 +1107,7 @@ _do_dump_multi_file()
>      echo "Dumping to files..."
>      opts="$_dump_debug$dump_args $multi_args -L $session_label $SCRATCH_MNT"
>      echo "xfsdump $opts" | _dir_filter
> -    $XFSDUMP_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
> +    $XFSDUMP_PROG $opts 2>&1 | tee -a $seqres.full | _dump_filter
>  }
>  
>  
> @@ -1140,7 +1140,7 @@ _do_restore()
>      echo "Restoring from tape..."
>      opts="$_restore_debug$restore_args -f $dumptape  -L $session_label $restore_dir"
>      echo "xfsrestore $opts" | _dir_filter
> -    $XFSRESTORE_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
> +    $XFSRESTORE_PROG $opts 2>&1 | tee -a $seqres.full | _dump_filter
>  }
>  
>  #
> @@ -1155,7 +1155,7 @@ _do_restore_min()
>      onemeg=1048576
>      opts="$_restore_debug$restore_args -m -b $onemeg -f $dumptape  -L $session_label $restore_dir"
>      echo "xfsrestore $opts" | _dir_filter
> -    $XFSRESTORE_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
> +    $XFSRESTORE_PROG $opts 2>&1 | tee -a $seqres.full | _dump_filter
>  }
>  
>  #
> @@ -1169,7 +1169,7 @@ _do_restore_file()
>      echo "Restoring from file..."
>      opts="$_restore_debug$restore_args -f $dump_file  -L $session_label $restore_dir"
>      echo "xfsrestore $opts" | _dir_filter
> -    $XFSRESTORE_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
> +    $XFSRESTORE_PROG $opts 2>&1 | tee -a $seqres.full | _dump_filter
>  }
>  
>  #
> @@ -1184,7 +1184,7 @@ _do_restore_file_cum()
>      echo "Restoring cumumlative from file..."
>      opts="$_restore_debug$restore_args -f $dump_file -r $restore_dir"
>      echo "xfsrestore $opts" | _dir_filter
> -    $XFSRESTORE_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
> +    $XFSRESTORE_PROG $opts 2>&1 | tee -a $seqres.full | _dump_filter
>  }
>  
>  _do_restore_toc()
> @@ -1195,7 +1195,7 @@ _do_restore_toc()
>      opts="$_restore_debug$restore_args -f $dump_file -t"
>      echo "xfsrestore $opts" | _dir_filter
>      cd $SCRATCH_MNT # for IRIX which needs xfs cwd
> -    $XFSRESTORE_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter_main |\
> +    $XFSRESTORE_PROG $opts 2>&1 | tee -a $seqres.full | _dump_filter_main |\
>      _check_quota_file |\
>      _check_quota_entries |\
>      $AWK_PROG 'NF != 1 { print; next }
> @@ -1226,7 +1226,7 @@ _do_restore_multi_file()
>      echo "Restoring from file..."
>      opts="$_restore_debug$restore_args $multi_args -L $session_label $restore_dir"
>      echo "xfsrestore $opts" | _dir_filter
> -    $XFSRESTORE_PROG $opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
> +    $XFSRESTORE_PROG $opts 2>&1 | tee -a $seqres.full | _dump_filter
>  }
>  
>  #
> @@ -1246,7 +1246,7 @@ _do_dump_restore()
>      restore_opts="$_restore_debug$restore_args - $restore_dir"
>      dump_opts="$_dump_debug$dump_args -s $dump_sdir - $SCRATCH_MNT"
>      echo "xfsdump $dump_opts | xfsrestore $restore_opts" | _dir_filter
> -    $XFSDUMP_PROG $dump_opts 2>$tmp.dump.mlog | $XFSRESTORE_PROG $restore_opts 2>&1 | tee -a $RESULT_DIR/$seq.full | _dump_filter
> +    $XFSDUMP_PROG $dump_opts 2>$tmp.dump.mlog | $XFSRESTORE_PROG $restore_opts 2>&1 | tee -a $seqres.full | _dump_filter
>      _dump_filter <$tmp.dump.mlog
>  }
>  
> @@ -1262,8 +1262,8 @@ _ls_compare_sub()
>      # verify we got back what we dumped
>      #
>      echo "Comparing listing of dump directory with restore directory"
> -    ls -nR $dump_dir | tee -a $RESULT_DIR/$seq.full | _ls_filter >$tmp.dump_dir
> -    ls -nR $restore_dir/$dump_sdir | tee -a $RESULT_DIR/$seq.full | _ls_filter \
> +    ls -nR $dump_dir | tee -a $seqres.full | _ls_filter >$tmp.dump_dir
> +    ls -nR $restore_dir/$dump_sdir | tee -a $seqres.full | _ls_filter \
>      | sed -e "s#$restore_sdir\/##" >$tmp.restore_dir
>  
>      diff -bcs $tmp.dump_dir $tmp.restore_dir | sed -e "s#$tmp#TMP#g"
> @@ -1285,8 +1285,8 @@ _ls_nodate_compare_sub()
>      # verify we got back what we dumped
>      #
>      echo "Comparing listing of dump directory with restore directory"
> -    ls -nR $dump_dir | tee -a $RESULT_DIR/$seq.full | _ls_filter | _ls_nodate_filter >$tmp.dump_dir
> -    ls -nR $restore_dir/$dump_sdir | tee -a $RESULT_DIR/$seq.full | _ls_filter \
> +    ls -nR $dump_dir | tee -a $seqres.full | _ls_filter | _ls_nodate_filter >$tmp.dump_dir
> +    ls -nR $restore_dir/$dump_sdir | tee -a $seqres.full | _ls_filter \
>      | _ls_nodate_filter | sed -e "s#$restore_sdir\/##" >$tmp.restore_dir
>  
>      diff -bcs $tmp.dump_dir $tmp.restore_dir | sed -e "s#$tmp#TMP#g"
> @@ -1359,13 +1359,13 @@ _diff_compare_eas()
>      echo "Comparing dump directory with restore directory"
>      echo "Looking at the extended attributes (EAs)"
>      echo "EAs on dump"
> -    _get_eas_on_path $dump_dir | tee $RESULT_DIR/$seq.ea1 | _dir_filter
> +    _get_eas_on_path $dump_dir | tee $seqres.ea1 | _dir_filter
>      echo "EAs on restore"
>      _get_eas_on_path $restore_dir/$dump_sdir \
>      | sed -e "s#$restore_sdir\/##" \
> -    | tee $RESULT_DIR/$seq.ea2 \
> +    | tee $seqres.ea2 \
>      | _dir_filter
> -    diff -s $RESULT_DIR/$seq.ea1 $RESULT_DIR/$seq.ea2
> +    diff -s $seqres.ea1 $seqres.ea2
>  }
>  
>  
> @@ -1384,7 +1384,7 @@ _diff_compare()
>  #
>  _dump_inventory()
>  {
> -    $XFSDUMP_PROG $_dump_debug -I | tee -a $RESULT_DIR/$seq.full | _dump_filter_main
> +    $XFSDUMP_PROG $_dump_debug -I | tee -a $seqres.full | _dump_filter_main
>  }
>  
>  #
> @@ -1394,9 +1394,9 @@ _dump_inventory()
>  _do_invutil()
>  {
>      host=`hostname`
> -    echo "xfsinvutil $_invutil_debug -M $host:$SCRATCH_MNT \"$middate\" $*" >$RESULT_DIR/$seq.full
> +    echo "xfsinvutil $_invutil_debug -M $host:$SCRATCH_MNT \"$middate\" $*" >$seqres.full
>      $XFSINVUTIL_PROG $_invutil_debug $* -M $host:$SCRATCH_MNT "$middate" \
> -    | tee -a $RESULT_DIR/$seq.full | _invutil_filter
> +    | tee -a $seqres.full | _invutil_filter
>  }
>  
>  #
> @@ -1416,7 +1416,7 @@ _check_quota()
>      $here/src/feature -P $SCRATCH_DEV && pquota=1
>  
>      $AWK_PROG -v uquota=$uquota -v gquota=$gquota -v pquota=$pquota \
> -	      -v full=$RESULT_DIR/$seq.full -v usermsg="$usermsg" \
> +	      -v full=$seqres.full -v usermsg="$usermsg" \
>  	      -v groupmsg="$groupmsg" -v projectmsg="$projectmsg" '
>  	$0 ~ projectmsg {
>  			print "Found project quota:", $0 >>full
> diff --git a/common/filestreams b/common/filestreams
> index b3aee27..590fa7f 100644
> --- a/common/filestreams
> +++ b/common/filestreams
> @@ -116,7 +116,7 @@ _check_for_dupes()
>                  for this_num_two in $num_str_two; do
>                          if [ "$this_num_one" == "$this_num_two" ]; then
>  				echo "duplicate AG $this_num_one found" \
> -					>> $RESULT_DIR/$seq.full
> +					>> $seqres.full
>  				return 1
>  			fi
>                  done
> @@ -189,7 +189,7 @@ _test_streams() {
>  	stream_index=1
>  	while [ $stream_index -le $stream_count ]; do
>  		this_stream_ags=`_get_stream_ags stream${stream_index}-dir`
> -		echo "stream $stream_index AGs: $this_stream_ags" >> $RESULT_DIR/$seq.full
> +		echo "stream $stream_index AGs: $this_stream_ags" >> $seqres.full
>  		_check_for_dupes "$ags_seen" "$this_stream_ags"
>  		if [ $? -ne 0 ]; then
>  			# this stream is not in seperate AGs to previous streams
> diff --git a/common/log b/common/log
> index e0e2bc6..88e64bc 100644
> --- a/common/log
> +++ b/common/log
> @@ -20,7 +20,7 @@
>  # Created by dxm@sgi.com & tes@sgi.com
>  #
>  
> -fulldir=$RESULT_DIR/$seq.fulldir
> +fulldir=$seqres.fulldir
>  rm -rf $fulldir
>  
>  _cleanup_logfiles()
> @@ -33,16 +33,16 @@ _cleanup_logfiles()
>  
>  _full()
>  {
> -    echo ""            >>$RESULT_DIR/$seq.full      
> -    echo "*** $* ***"  >>$RESULT_DIR/$seq.full
> -    echo ""            >>$RESULT_DIR/$seq.full
> +    echo ""            >>$seqres.full      
> +    echo "*** $* ***"  >>$seqres.full
> +    echo ""            >>$seqres.full
>  }
>  
>  _echofull()
>  {
> -    echo ""            | tee -a $RESULT_DIR/$seq.full      
> -    echo "*** $* ***"  | tee -a $RESULT_DIR/$seq.full
> -    echo ""            | tee -a $RESULT_DIR/$seq.full
> +    echo ""            | tee -a $seqres.full      
> +    echo "*** $* ***"  | tee -a $seqres.full
> +    echo ""            | tee -a $seqres.full
>  }
>  
>  # Handle the operations which get split over Log Record
> @@ -212,13 +212,13 @@ _filter_logprint()
>  _check_log()
>  {
>      _full "clean_log : xfs_logprint"
> -    _scratch_xfs_logprint -t | tee -a $RESULT_DIR/$seq.full \
> +    _scratch_xfs_logprint -t | tee -a $seqres.full \
>          | head | grep -q "<CLEAN>" || _fail "DIRTY LOG"
>  }
>  
>  _print_logstate()
>  {
> -    _scratch_xfs_logprint -t | tee -a $RESULT_DIR/$seq.full >$tmp.logprint
> +    _scratch_xfs_logprint -t | tee -a $seqres.full >$tmp.logprint
>      if grep -q "<DIRTY>" $tmp.logprint; then
>  	echo "dirty log"
>      fi
> @@ -288,7 +288,7 @@ _mkfs_log()
>      # mkfs options to append to log size otion can be specified ($*)
>      export MKFS_OPTIONS="-l size=2000b -l lazy-count=1 $*"
>      _full "mkfs"
> -    _scratch_mkfs_xfs >>$RESULT_DIR/$seq.full 2>&1
> +    _scratch_mkfs_xfs >>$seqres.full 2>&1
>      if [ $? -ne 0 ] ; then 
>  	_echofull "Cannot mkfs for this test using option specified: $MKFS_OPTIONS"
>  	return 1
> @@ -305,7 +305,7 @@ _create_log()
>  {
>      # mount the FS
>      _full "mount"
> -    _scratch_mount >>$RESULT_DIR/$seq.full 2>&1
> +    _scratch_mount >>$seqres.full 2>&1
>      if [ $? -ne 0 ] ; then 
>  	_echofull "mount failed: $MOUNT_OPTIONS"
>  	return 1
> @@ -318,7 +318,7 @@ _create_log()
>  	
>      # unmount the FS
>      _full "umount"
> -    umount $SCRATCH_DEV >>$RESULT_DIR/$seq.full 2>&1
> +    umount $SCRATCH_DEV >>$seqres.full 2>&1
>      if [ $? -ne 0 ] ; then 
>  	_echofull "umount failed"
>  	return 1
> @@ -334,7 +334,7 @@ _create_log_sync()
>  {
>      # mount the FS
>      _full " mount"
> -    _scratch_mount >>$RESULT_DIR/$seq.full 2>&1
> +    _scratch_mount >>$seqres.full 2>&1
>      if [ $? -ne 0 ] ; then 
>  	_echofull "mount failed: $MOUNT_OPTIONS"
>  	return 1
> @@ -349,7 +349,7 @@ _create_log_sync()
>  
>      # unmount the FS
>      _full "umount"
> -    umount $SCRATCH_DEV >>$RESULT_DIR/$seq.full 2>&1
> +    umount $SCRATCH_DEV >>$seqres.full 2>&1
>      if [ $? -ne 0 ] ; then 
>  	_echofull "umount failed"
>  	return 1
> @@ -448,21 +448,21 @@ _require_v2log()
>  {
>      # test out mkfs to see if it supports "-l version=2"
>      export MKFS_OPTIONS="-l version=2"
> -    if ! _scratch_mkfs_xfs >>$RESULT_DIR/$seq.full 2>&1; then
> +    if ! _scratch_mkfs_xfs >>$seqres.full 2>&1; then
>          _notrun "mkfs does not support v2 logs"
>      fi
>  
>      # test out mount to see if it mounts a v2 log fs
>      export MOUNT_OPTIONS="-o logbsize=32k"
> -    if ! _scratch_mount >>$RESULT_DIR/$seq.full 2>&1; then
> +    if ! _scratch_mount >>$seqres.full 2>&1; then
>          _notrun "mount/kernel does not support v2 logs"
>      fi
>  
>      # check after unmount to see if it is clean
>      # i.e. it is not a 6.5.25 buggy version checking kernel
>      touch $SCRATCH_MNT/file
> -    umount $SCRATCH_DEV >>$RESULT_DIR/$seq.full 2>&1
> -    if _scratch_xfs_logprint -t | tee -a $RESULT_DIR/$seq.full \
> +    umount $SCRATCH_DEV >>$seqres.full 2>&1
> +    if _scratch_xfs_logprint -t | tee -a $seqres.full \
>          | head | grep -q "<DIRTY>"; then
>          _notrun "kernel does not support v2 logs"
>      fi
> diff --git a/common/quota b/common/quota
> index ff80382..7f349ab 100644
> --- a/common/quota
> +++ b/common/quota
> @@ -96,8 +96,8 @@ _file_as_id()
>  
>      parent=`dirname $1`
>      if [ $3 = p ]; then
> -	echo PARENT: xfs_io -r -c "chproj $2" -c "chattr +P" $parent >>$RESULT_DIR/$seq.full
> -	$XFS_IO_PROG -r -c "chproj $2" -c "chattr +P" $parent >>$RESULT_DIR/$seq.full 2>&1
> +	echo PARENT: xfs_io -r -c "chproj $2" -c "chattr +P" $parent >>$seqres.full
> +	$XFS_IO_PROG -r -c "chproj $2" -c "chattr +P" $parent >>$seqres.full 2>&1
>  	magik='$>'	# (irrelevent, above set projid-inherit-on-parent)
>      elif [ $3 = u ]; then
>  	magik='$>'	# perlspeak for effective uid
> @@ -107,7 +107,7 @@ _file_as_id()
>  	_notrun "broken type in call to _file_as_id in test $seq"
>      fi
>  
> -    perl <<EOF >>$RESULT_DIR/$seq.full 2>&1
> +    perl <<EOF >>$seqres.full 2>&1
>  	\$| = 1;
>  	$magik = $2;
>  	if ($5 == 0) {
> @@ -119,11 +119,11 @@ _file_as_id()
>  	}
>  EOF
>  # for debugging the above euid change, try... [need write in cwd]
> -#	exec "dd if=/dev/zero of=$1 bs=$4 count=$5 >>$RESULT_DIR/$seq.full 2>&1";
> +#	exec "dd if=/dev/zero of=$1 bs=$4 count=$5 >>$seqres.full 2>&1";
>  
>      if [ $3 = p ]; then
> -	echo PARENT: xfs_io -r -c "chproj 0" -c "chattr -P" $parent >>$RESULT_DIR/$seq.full
> -	$XFS_IO_PROG -r -c "chproj 0" -c "chattr -P" $parent >>$RESULT_DIR/$seq.full 2>&1
> +	echo PARENT: xfs_io -r -c "chproj 0" -c "chattr -P" $parent >>$seqres.full
> +	$XFS_IO_PROG -r -c "chproj 0" -c "chattr -P" $parent >>$seqres.full 2>&1
>      fi
>  }
>  
> @@ -198,8 +198,8 @@ _qsetup()
>  	_notrun "No quota support at mount time"
>      fi
>  
> -    echo "Using output from '" `ls -l $seq.out` "'" >>$RESULT_DIR/$seq.full
> -    echo "and using type=$type id=$id" >>$RESULT_DIR/$seq.full
> +    echo "Using output from '" `ls -l $seq.out` "'" >>$seqres.full
> +    echo "and using type=$type id=$id" >>$seqres.full
>  }
>  
>  #
> @@ -229,7 +229,7 @@ _qmount_option()
>  
>  	# Ensure we have the given quota option - duplicates are fine
>  	export MOUNT_OPTIONS="$MOUNT_OPTIONS -o $1"
> -	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$RESULT_DIR/$seq.full
> +	echo "MOUNT_OPTIONS = $MOUNT_OPTIONS" >>$seqres.full
>  }
>  
>  _check_quota_usage()
> diff --git a/common/rc b/common/rc
> index 3aa8742..ca40605 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -358,9 +358,9 @@ _scratch_mkfs_xfs()
>  
>      if [ $mkfs_status -ne 0 -a ! -z "$extra_mkfs_options" ]; then
>          echo "** mkfs failed with extra mkfs options added to \"$MKFS_OPTIONS\" by test $seq **" \
> -            >>$RESULT_DIR/$seq.full
> +            >>$seqres.full
>          echo "** attempting to mkfs using only test $seq options: $extra_mkfs_options **" \
> -            >>$RESULT_DIR/$seq.full
> +            >>$seqres.full
>          # running mkfs again. overwrite previous mkfs output files
>          $MKFS_XFS_PROG $SCRATCH_OPTIONS $extra_mkfs_options $SCRATCH_DEV \
>              2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
> @@ -796,7 +796,7 @@ _is_block_dev()
>      fi
>  }
>  
> -# Do a command, log it to $RESULT_DIR/$seq.full, optionally test return status
> +# Do a command, log it to $seqres.full, optionally test return status
>  # and die if command fails. If called with one argument _do executes the
>  # command, logs it, and returns its exit status. With two arguments _do
>  # first prints the message passed in the first argument, and then "done"
> @@ -804,7 +804,7 @@ _is_block_dev()
>  # second argument. If the command fails and the variable _do_die_on_error
>  # is set to "always" or the two argument form is used and _do_die_on_error
>  # is set to "message_only" _do will print an error message to
> -# $RESULT_DIR/$seq.out and exit.
> +# $seqres.out and exit.
>  
>  _do()
>  {
> @@ -819,9 +819,9 @@ _do()
>  	status=1; exit
>      fi
>  
> -    (eval "echo '---' \"$_cmd\"") >>$RESULT_DIR/$seq.full
> +    (eval "echo '---' \"$_cmd\"") >>$seqres.full
>      (eval "$_cmd") >$tmp._out 2>&1; ret=$?
> -    cat $tmp._out | _fix_malloc >>$RESULT_DIR/$seq.full
> +    cat $tmp._out | _fix_malloc >>$seqres.full
>      if [ $# -eq 2 ]; then
>  	if [ $ret -eq 0 ]; then
>  	    echo "done"
> @@ -834,7 +834,7 @@ _do()
>  	    -o \( $# -eq 2 -a "$_do_die_on_error" = "message_only" \) ]
>      then
>  	[ $# -ne 2 ] && echo
> -	eval "echo \"$_cmd\" failed \(returned $ret\): see $RESULT_DIR/$seq.full"
> +	eval "echo \"$_cmd\" failed \(returned $ret\): see $seqres.full"
>  	status=1; exit
>      fi
>  
> @@ -845,7 +845,7 @@ _do()
>  #
>  _notrun()
>  {
> -    echo "$*" > $RESULT_DIR/$seq.notrun
> +    echo "$*" > $seqres.notrun
>      echo "$seq not run: $*"
>      status=0
>      exit
> @@ -855,8 +855,8 @@ _notrun()
>  #
>  _fail()
>  {
> -    echo "$*" | tee -a $RESULT_DIR/$seq.full
> -    echo "(see $RESULT_DIR/$seq.full for details)"
> +    echo "$*" | tee -a $seqres.full
> +    echo "(see $seqres.full for details)"
>      status=1
>      exit 1
>  }
> @@ -1343,12 +1343,12 @@ _check_generic_filesystem()
>      fsck -t $FSTYP $FSCK_OPTIONS $device >$tmp.fsck 2>&1
>      if [ $? -ne 0 ]
>      then
> -        echo "_check_generic_filesystem: filesystem on $device is inconsistent (see $RESULT_DIR/$seq.full)"
> +        echo "_check_generic_filesystem: filesystem on $device is inconsistent (see $seqres.full)"
>  
> -        echo "_check_generic filesystem: filesystem on $device is inconsistent" >>$RESULT_DIR/$seq.full
> -        echo "*** fsck.$FSTYP output ***"	>>$RESULT_DIR/$seq.full
> -        cat $tmp.fsck				>>$RESULT_DIR/$seq.full
> -        echo "*** end fsck.$FSTYP output"	>>$RESULT_DIR/$seq.full
> +        echo "_check_generic filesystem: filesystem on $device is inconsistent" >>$seqres.full
> +        echo "*** fsck.$FSTYP output ***"	>>$seqres.full
> +        cat $tmp.fsck				>>$seqres.full
> +        echo "*** end fsck.$FSTYP output"	>>$seqres.full
>  
>          ok=0
>      fi
> @@ -1356,9 +1356,9 @@ _check_generic_filesystem()
>  
>      if [ $ok -eq 0 ]
>      then
> -        echo "*** mount output ***"		>>$RESULT_DIR/$seq.full
> -        _mount					>>$RESULT_DIR/$seq.full
> -        echo "*** end mount output"		>>$RESULT_DIR/$seq.full
> +        echo "*** mount output ***"		>>$seqres.full
> +        _mount					>>$seqres.full
> +        echo "*** end mount output"		>>$seqres.full
>      elif [ "$type" = "$FSTYP" ]
>      then
>  	# was mounted ...
> @@ -1412,12 +1412,12 @@ _check_xfs_filesystem()
>                  | tee $tmp.logprint | grep -q "<CLEAN>"
>      if [ $? -ne 0 -a "$HOSTOS" = "Linux" ]
>      then
> -        echo "_check_xfs_filesystem: filesystem on $device has dirty log (see $RESULT_DIR/$seq.full)"
> +        echo "_check_xfs_filesystem: filesystem on $device has dirty log (see $seqres.full)"
>  
> -        echo "_check_xfs_filesystem: filesystem on $device has dirty log"   >>$RESULT_DIR/$seq.full
> -        echo "*** xfs_logprint -t output ***"	>>$RESULT_DIR/$seq.full
> -        cat $tmp.logprint			>>$RESULT_DIR/$seq.full
> -        echo "*** end xfs_logprint output"	>>$RESULT_DIR/$seq.full
> +        echo "_check_xfs_filesystem: filesystem on $device has dirty log"   >>$seqres.full
> +        echo "*** xfs_logprint -t output ***"	>>$seqres.full
> +        cat $tmp.logprint			>>$seqres.full
> +        echo "*** end xfs_logprint output"	>>$seqres.full
>  
>          ok=0
>      fi
> @@ -1431,12 +1431,12 @@ _check_xfs_filesystem()
>      fi
>      if [ -s $tmp.fs_check ]
>      then
> -        echo "_check_xfs_filesystem: filesystem on $device is inconsistent (c) (see $RESULT_DIR/$seq.full)"
> +        echo "_check_xfs_filesystem: filesystem on $device is inconsistent (c) (see $seqres.full)"
>  
> -        echo "_check_xfs_filesystem: filesystem on $device is inconsistent" >>$RESULT_DIR/$seq.full
> -        echo "*** xfs_check output ***"		>>$RESULT_DIR/$seq.full
> -        cat $tmp.fs_check			>>$RESULT_DIR/$seq.full
> -        echo "*** end xfs_check output"		>>$RESULT_DIR/$seq.full
> +        echo "_check_xfs_filesystem: filesystem on $device is inconsistent" >>$seqres.full
> +        echo "*** xfs_check output ***"		>>$seqres.full
> +        cat $tmp.fs_check			>>$seqres.full
> +        echo "*** end xfs_check output"		>>$seqres.full
>  
>          ok=0
>      fi
> @@ -1444,12 +1444,12 @@ _check_xfs_filesystem()
>      $XFS_REPAIR_PROG -n $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
>      if [ $? -ne 0 ]
>      then
> -        echo "_check_xfs_filesystem: filesystem on $device is inconsistent (r) (see $RESULT_DIR/$seq.full)"
> +        echo "_check_xfs_filesystem: filesystem on $device is inconsistent (r) (see $seqres.full)"
>  
> -        echo "_check_xfs_filesystem: filesystem on $device is inconsistent" >>$RESULT_DIR/$seq.full
> -        echo "*** xfs_repair -n output ***"	>>$RESULT_DIR/$seq.full
> -        cat $tmp.repair | _fix_malloc		>>$RESULT_DIR/$seq.full
> -        echo "*** end xfs_repair output"	>>$RESULT_DIR/$seq.full
> +        echo "_check_xfs_filesystem: filesystem on $device is inconsistent" >>$seqres.full
> +        echo "*** xfs_repair -n output ***"	>>$seqres.full
> +        cat $tmp.repair | _fix_malloc		>>$seqres.full
> +        echo "*** end xfs_repair output"	>>$seqres.full
>  
>          ok=0
>      fi
> @@ -1457,9 +1457,9 @@ _check_xfs_filesystem()
>  
>      if [ $ok -eq 0 ]
>      then
> -        echo "*** mount output ***"		>>$RESULT_DIR/$seq.full
> -        _mount					>>$RESULT_DIR/$seq.full
> -        echo "*** end mount output"		>>$RESULT_DIR/$seq.full
> +        echo "*** mount output ***"		>>$seqres.full
> +        _mount					>>$seqres.full
> +        echo "*** end mount output"		>>$seqres.full
>      elif [ "$type" = "xfs" ]
>      then
>  	_mount_or_remount_rw "$extra_mount_options" $device $mountpoint
> @@ -1507,12 +1507,12 @@ _check_udf_filesystem()
>          OPT_ARG="-lastvalidblock $LAST_BLOCK"
>      fi
>  
> -    rm -f $RESULT_DIR/$seq.checkfs
> +    rm -f $seqres.checkfs
>      sleep 1 # Due to a problem with time stamps in udf_test
> -    $here/src/udf_test $OPT_ARG $device | tee $RESULT_DIR/$seq.checkfs | egrep "Error|Warning" | \
> +    $here/src/udf_test $OPT_ARG $device | tee $seqres.checkfs | egrep "Error|Warning" | \
>  	_udf_test_known_error_filter | \
>  	egrep -iv "Error count:.*[0-9]+.*total occurrences:.*[0-9]+|Warning count:.*[0-9]+.*total occurrences:.*[0-9]+" | \
> -	sed "s/^.*$/Warning UDF Verifier reported errors see $RESULT_DIR/$seq.checkfs./g"
> +	sed "s/^.*$/Warning UDF Verifier reported errors see $seqres.checkfs./g"
>  
>  }
>  
> @@ -1553,12 +1553,12 @@ _check_btrfs_filesystem()
>      btrfsck $device >$tmp.fsck 2>&1
>      if [ $? -ne 0 ]
>      then
> -        echo "_check_btrfs_filesystem: filesystem on $device is inconsistent (see $RESULT_DIR/$seq.full)"
> +        echo "_check_btrfs_filesystem: filesystem on $device is inconsistent (see $seqres.full)"
>  
> -        echo "_check_btrfs_filesystem: filesystem on $device is inconsistent" >>$RESULT_DIR/$seq.full
> -        echo "*** fsck.$FSTYP output ***"	>>$RESULT_DIR/$seq.full
> -        cat $tmp.fsck				>>$RESULT_DIR/$seq.full
> -        echo "*** end fsck.$FSTYP output"	>>$RESULT_DIR/$seq.full
> +        echo "_check_btrfs_filesystem: filesystem on $device is inconsistent" >>$seqres.full
> +        echo "*** fsck.$FSTYP output ***"	>>$seqres.full
> +        cat $tmp.fsck				>>$seqres.full
> +        echo "*** end fsck.$FSTYP output"	>>$seqres.full
>  
>          ok=0
>      fi
> @@ -1566,9 +1566,9 @@ _check_btrfs_filesystem()
>  
>      if [ $ok -eq 0 ]
>      then
> -        echo "*** mount output ***"		>>$RESULT_DIR/$seq.full
> -        _mount					>>$RESULT_DIR/$seq.full
> -        echo "*** end mount output"		>>$RESULT_DIR/$seq.full
> +        echo "*** mount output ***"		>>$seqres.full
> +        _mount					>>$seqres.full
> +        echo "*** end mount output"		>>$seqres.full
>      elif [ "$type" = "$FSTYP" ]
>      then
>  	# was mounted ...
> @@ -2053,8 +2053,8 @@ _scale_fsstress_args()
>  
>  run_check()
>  {
> -	echo "# $@" >> $RESULT_DIR/$seq.full 2>&1
> -	"$@" >> $RESULT_DIR/$seq.full 2>&1 || _fail "failed: '$@'"
> +	echo "# $@" >> $seqres.full 2>&1
> +	"$@" >> $seqres.full 2>&1 || _fail "failed: '$@'"
>  }
>  
>  ################################################################################
> diff --git a/common/scsi_debug b/common/scsi_debug
> index f05c8db..d073b6d 100644
> --- a/common/scsi_debug
> +++ b/common/scsi_debug
> @@ -47,7 +47,7 @@ _get_scsi_debug_dev()
>  		let phys_exp=phys_exp+1
>  	done
>  	opts="sector_size=$logical physblk_exp=$phys_exp lowest_aligned=$unaligned dev_size_mb=$size"
> -	echo "scsi_debug options $opts" >> $RESULT_DIR/$seq.full
> +	echo "scsi_debug options $opts" >> $seqres.full
>  	modprobe scsi_debug $opts
>  	[ $? -eq 0 ] || _fail "scsi_debug modprobe failed"
>  	sleep 1
> diff --git a/tests/generic/001 b/tests/generic/001
> index 35c88f2..aa82441 100755
> --- a/tests/generic/001
> +++ b/tests/generic/001
> @@ -190,7 +190,7 @@ _mark_iteration()
>  #
>  _chain()
>  {
> -    $AWK_PROG -v full_file=$here/$seqres.full -v verify=$verify <$tmp.config '
> +    $AWK_PROG -v full_file=$seqres.full -v verify=$verify <$tmp.config '
>  BEGIN	{ nfile = 0 }
>  /^\#/	{ next }
>  	{ file[nfile] = $1
> @@ -238,7 +238,7 @@ END	{ srand('$iter')
>  	    }
>  	  }
>  	}' \
> -	| tee -a $here/$seqres.full | sh
> +	| tee -a $seqres.full | sh
>  }
>  
>  _check()
> @@ -292,7 +292,7 @@ _cleanup()
>      fi
>  }
>  
> -rm -f $here/$seqres.full
> +rm -f $seqres.full
>  status=0
>  _cleanup
>  status=1
> @@ -306,7 +306,7 @@ _setup
>  for iter in 1 2 3 4 5
>  do
>      echo -n "iter $iter chain ... "
> -    echo "iter $iter" >> $here/$seqres.full
> +    echo "iter $iter" >> $seqres.full
>      _chain
>      _check
>      if [ -f $tmp.bad ]
> diff --git a/tests/generic/010 b/tests/generic/010
> index d338db6..0bdfdd5 100755
> --- a/tests/generic/010
> +++ b/tests/generic/010
> @@ -64,7 +64,7 @@ rm -f $seqres.full
>  
>  cd $testdir
>  
> -$here/src/dbtest -l 5 -n 1000 2>&1 | tee -a $here/$seqres.full | _filter_dbtest
> +$here/src/dbtest -l 5 -n 1000 2>&1 | tee -a $seqres.full | _filter_dbtest
>  
>  # success, all done
>  exit
> diff --git a/tests/generic/013 b/tests/generic/013
> index a9c07c4..b364f1b 100755
> --- a/tests/generic/013
> +++ b/tests/generic/013
> @@ -78,11 +78,11 @@ _do_test()
>      if ! $FSSTRESS_PROG $_param $FSSTRESS_AVOID -v -m 8 -n $_count -d $out >>$dbgoutfile 2>&1
>      then
>          echo "    fsstress (count=$_count) returned $? - see $seqres.full"
> -        echo "--------------------------------------"       >>$here/$seqres.full
> -        echo "$_n - output from fsstress:"                  >>$here/$seqres.full
> -        echo "--------------------------------------"       >>$here/$seqres.full
> -        echo "<NOT LOGGED>"                                 >>$here/$seqres.full
> -        #cat $tmp.out                                       >>$here/$seqres.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        echo "$_n - output from fsstress:"                  >>$seqres.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        echo "<NOT LOGGED>"                                 >>$seqres.full
> +        #cat $tmp.out                                       >>$seqres.full
>          status=1
>      fi
>  
> @@ -96,7 +96,7 @@ _supported_os IRIX Linux
>  
>  _setup_testdir
>  
> -rm -f $here/$seqres.full
> +rm -f $seqres.full
>  echo "brevity is wit..."
>  
>  count=1000
> diff --git a/tests/generic/074 b/tests/generic/074
> index 6df8c57..b9e1595 100755
> --- a/tests/generic/074
> +++ b/tests/generic/074
> @@ -108,7 +108,7 @@ _process_args()
>  
>  
>  # real QA test starts here
> -rm -f $here/$seqres.full
> +rm -f $seqres.full
>  
>  _supported_fs generic
>  _supported_os IRIX Linux
> diff --git a/tests/generic/075 b/tests/generic/075
> index 52e6a43..4477db4 100755
> --- a/tests/generic/075
> +++ b/tests/generic/075
> @@ -78,10 +78,10 @@ _do_test()
>      cd $out
>      if ! $here/ltp/fsx $_param -P $here $seq.$_n &>/dev/null
>      then
> -	echo "    fsx ($_param) failed, $? - compare $seq.$_n.{good,bad,fsxlog}"
> -	mv $out/$seq.$_n $here/$seq.$_n.full
> -	od -xAx $here/$seq.$_n.full > $here/$seq.$_n.bad
> -	od -xAx $here/$seq.$_n.fsxgood > $here/$seq.$_n.good
> +	echo "    fsx ($_param) failed, $? - compare $seqres.$_n.{good,bad,fsxlog}"
> +	mv $out/$seq.$_n $seqres.$_n.full
> +	od -xAx $seqres.$_n.full > $seqres.$_n.bad
> +	od -xAx $seqres.$_n.fsxgood > $seqres.$_n.good
>  	status=1
>  	exit
>      fi
> @@ -139,7 +139,7 @@ echo "Params: n = $numops1 N = $numops2 l = $filelen" >>$seqres.full
>  
>  _setup_testdir
>  
> -rm -f $here/$seqres.full
> +rm -f $seqres.full
>  echo "brevity is wit..."
>  
>  _check_test_fs
> diff --git a/tests/generic/089 b/tests/generic/089
> index c4c76e2..fdddad4 100755
> --- a/tests/generic/089
> +++ b/tests/generic/089
> @@ -73,8 +73,8 @@ mtab()
>  
>  	echo directory entries:
>  	ls | grep mtab
> -	echo directory entries >> $here/$seqres.full
> -	ls -li >> $here/$seqres.full
> +	echo directory entries >> $seqres.full
> +	ls -li >> $seqres.full
>  }
>  
>  # directory with only a few entries
> diff --git a/tests/generic/100 b/tests/generic/100
> index 123dc5f..f4b0c8f 100755
> --- a/tests/generic/100
> +++ b/tests/generic/100
> @@ -62,10 +62,10 @@ rm -rf $POPULATED_DIR
>  rm -f $TEMP_DIR/$TAR_FILE
>  
>  # Create the new directory structure
> -_populate_fs -n $NDIRS -f $NFILES -d $DEPTH -r $POPULATED_DIR -s $SIZE >>$here/$seqres.full 2>&1
> +_populate_fs -n $NDIRS -f $NFILES -d $DEPTH -r $POPULATED_DIR -s $SIZE >>$seqres.full 2>&1
>  
>  # Then tar up the directory structure
> -tar -cvf $TEMP_DIR/$TAR_FILE $POPULATED_DIR >>$here/$seqres.full 2>&1
> +tar -cvf $TEMP_DIR/$TAR_FILE $POPULATED_DIR >>$seqres.full 2>&1
>  
>  # create f/s
>  _require_scratch
> @@ -73,12 +73,12 @@ _setup_testdir
>  
>  # untar on f/s
>  cd $testdir
> -tar -xRvf $TEMP_DIR/$TAR_FILE >>$here/$seqres.full 2>&1
> +tar -xRvf $TEMP_DIR/$TAR_FILE >>$seqres.full 2>&1
>  cd $here
>  
>  
>  # use diff -qr to compare
> -ls -R -l ${testdir}${POPULATED_DIR} >>$here/$seqres.full 2>&1
> +ls -R -l ${testdir}${POPULATED_DIR} >>$seqres.full 2>&1
>  diff -qr $POPULATED_DIR ${testdir}${POPULATED_DIR}
>  
>  cd /
> diff --git a/tests/generic/112 b/tests/generic/112
> index 5f5b19d..0cd19db 100755
> --- a/tests/generic/112
> +++ b/tests/generic/112
> @@ -79,7 +79,7 @@ _do_test()
>      if ! $here/ltp/fsx $_param -P $here $seq.$_n &>/dev/null
>      then
>  	echo "    fsx ($_param) returned $? - see $seq.$_n.full"
> -	mv $seq.$_n.fsxlog $here/$seq.$_n.full
> +	mv $seq.$_n.fsxlog $seqres.$_n.full
>  	status=1
>  	exit
>      fi
> @@ -140,7 +140,7 @@ echo "Params: n = $numops1 N = $numops2 l = $filelen" >>$seqres.full
>  
>  _setup_testdir
>  
> -rm -f $here/$seqres.full
> +rm -f $seqres.full
>  echo "brevity is wit..."
>  
>  _check_test_fs
> diff --git a/tests/generic/192 b/tests/generic/192
> index 66d8a66..13784f7 100755
> --- a/tests/generic/192
> +++ b/tests/generic/192
> @@ -67,7 +67,7 @@ time2=`_access_time $testfile | tee -a $seqres.full`
>  cd /
>  umount $TEST_DIR
>  _test_mount
> -time3=`_access_time $testfile | tee -a $here/$seqres.full`
> +time3=`_access_time $testfile | tee -a $seqres.full`
>  
>  delta1=`expr $time2 - $time1`
>  delta2=`expr $time3 - $time1`
> diff --git a/tests/generic/232 b/tests/generic/232
> index ee0e16e..2402c45 100755
> --- a/tests/generic/232
> +++ b/tests/generic/232
> @@ -39,7 +39,7 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
>  
>  _filter_num()
>  {
> -	tee -a $here/$seqres.full |\
> +	tee -a $seqres.full |\
>  	sed -e 's/[0-9][0-9]* inodes/I inodes/g' \
>  	    -e 's/[0-9][0-9]* paths/P paths/g' \
>  	    -e 's/seed = [0-9][0-9]*/seed = S/'
> @@ -55,11 +55,11 @@ _fsstress()
>  	count=2000
>  	args=`_scale_fsstress_args -d $out -n $count -p 7`
>  
> -	echo "fsstress $args" >> tee -a $here/$seqres.full
> -	if ! $FSSTRESS_PROG $args | tee -a $here/$seqres.full | _filter_num
> +	echo "fsstress $args" >> tee -a $seqres.full
> +	if ! $FSSTRESS_PROG $args | tee -a $seqres.full | _filter_num
>  	then
>  		echo "    fsstress $args returned $?"
> -		cat $tmp.out | tee -a $here/$seqres.full
> +		cat $tmp.out | tee -a $seqres.full
>  		status=1
>  	fi
>  }
> diff --git a/tests/generic/233 b/tests/generic/233
> index 1eb68c5..2b6cd2f 100755
> --- a/tests/generic/233
> +++ b/tests/generic/233
> @@ -43,7 +43,7 @@ FSX_ARGS="-q -l $FSX_FILE_SIZE -o 65536 -S 191110531 -N 100000"
>  
>  _filter_num()
>  {
> -	tee -a $here/$seqres.full |\
> +	tee -a $seqres.full |\
>  	sed -e 's/[0-9][0-9]* inodes/I inodes/g' \
>  	    -e 's/[0-9][0-9]* paths/P paths/g' \
>  	    -e 's/seed = [0-9][0-9]*/seed = S/'
> @@ -62,11 +62,11 @@ _fsstress()
>  -f rename=10 -f fsync=2 -f write=15 -f dwrite=15 \
>  -n $count -d $out -p 7`
>  
> -	echo "fsstress $args" >> tee -a $here/$seqres.full
> -	if ! su $qa_user -c "$FSSTRESS_PROG $args" | tee -a $here/$seqres.full | _filter_num
> +	echo "fsstress $args" >> tee -a $seqres.full
> +	if ! su $qa_user -c "$FSSTRESS_PROG $args" | tee -a $seqres.full | _filter_num
>  	then
>  		echo "    fsstress $args returned $?"
> -		cat $tmp.out | tee -a $here/$seqres.full
> +		cat $tmp.out | tee -a $seqres.full
>  		status=1
>  	fi
>  }
> diff --git a/tests/generic/269 b/tests/generic/269
> index 6e33368..684cf42 100755
> --- a/tests/generic/269
> +++ b/tests/generic/269
> @@ -45,7 +45,7 @@ _workout()
>  	enospc_time=2
>  	out=$SCRATCH_MNT/fsstress.$$
>  	args=`_scale_fsstress_args -p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out`
> -	echo "fsstress $args" >> $here/$seqres.full
> +	echo "fsstress $args" >> $seqres.full
>  	$FSSTRESS_PROG $args > /dev/null 2>&1 &
>  	pid=$!
>  	echo "Run dd writers in parallel"
> @@ -53,7 +53,7 @@ _workout()
>  	do
>  		# File will be opened with O_TRUNC each time
>  		dd if=/dev/zero of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M \
> -			>> $here/$seqres.full 2>&1
> +			>> $seqres.full 2>&1
>  		sleep $enospc_time
>  	done
>  	kill $pid
> diff --git a/tests/generic/270 b/tests/generic/270
> index 294bb62..b5ed7af 100755
> --- a/tests/generic/270
> +++ b/tests/generic/270
> @@ -48,7 +48,7 @@ _workout()
>  	enospc_time=2
>  	out=$SCRATCH_MNT/fsstress.$$
>  	args=`_scale_fsstress_args -p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out`
> -	echo "fsstress $args" >> $here/$seqres.full
> +	echo "fsstress $args" >> $seqres.full
>  	# Grant chown capability 
>  	cp $FSSTRESS_PROG  $tmp.fsstress.bin
>  	if [ "`whereis setcap`" == "setcap:" ]; then
> @@ -65,7 +65,7 @@ _workout()
>  		# File will be opened with O_TRUNC each time
>  		su $qa_user -c "dd if=/dev/zero \
>  			of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M " \
> -			>> $here/$seqres.full 2>&1
> +			>> $seqres.full 2>&1
>  		sleep $enospc_time
>  	done
>  
> diff --git a/tests/shared/305 b/tests/shared/305
> index bcb235f..91cbf03 100644
> --- a/tests/shared/305
> +++ b/tests/shared/305
> @@ -62,7 +62,7 @@ disallow_fail_make_request()
>  start_fail_scratch_dev()
>  {
>      echo "Force SCRATCH_DEV device failure"
> -    echo " echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $here/$seqres.full
> +    echo " echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $seqres.full
>      echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail
>  
>  }
> @@ -70,7 +70,7 @@ start_fail_scratch_dev()
>  stop_fail_scratch_dev()
>  {
>      echo "Make SCRATCH_DEV device operable again"
> -    echo " echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $here/$seqres.full
> +    echo " echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $seqres.full
>      echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail
>  
>  }
> @@ -139,12 +139,12 @@ _workout()
>  	echo ""
>  	echo "Start fsstress.."
>  	echo ""
> -	echo "fsstress $args" >> $here/$seqres.full
> +	echo "fsstress $args" >> $seqres.full
>  	$FSSTRESS_PROG $args > /dev/null 2>&1 &
>  	fs_pid=$!
>  	echo "Start fio.."
>  	cat $tmp-$seq.fio >>  $seqres.full
> -	$FIO_PROG $tmp-$seq.fio >> $here/$seqres.full 2>&1 &
> +	$FIO_PROG $tmp-$seq.fio >> $seqres.full 2>&1 &
>  	fio_pid=$!
>  
>  	# Let's it work for awhile, and force device failure
> @@ -154,7 +154,7 @@ _workout()
>  	# that so buffered write(2) may succeed, but any integrity operations
>  	# such as (sync, fsync, fdatasync, direct-io) should fail.
>  	dd if=/dev/zero of=$SCRATCH_MNT/touch_failed_filesystem count=1 bs=4k conv=fsync \
> -	    >> $here/$seqres.full 2>&1 && \
> +	    >> $seqres.full 2>&1 && \
>  	    _fail "failed: still able to perform integrity fsync on $SCRATCH_MNT"
>  
>  	kill $fs_pid
> @@ -176,7 +176,7 @@ _workout()
>  
>  # real QA test starts here
>  
> -_scratch_mkfs >> $here/$seqres.full 2>&1 || _fail "mkfs failed"
> +_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
>  _scratch_mount || _fail "mount failed"
>  allow_fail_make_request
>  _workout
> diff --git a/tests/xfs/008 b/tests/xfs/008
> index 4bf6c00..e7a1768 100755
> --- a/tests/xfs/008
> +++ b/tests/xfs/008
> @@ -73,14 +73,14 @@ _do_test()
>  	fi
>      else
>          echo "    randholes returned $? - see $seq.out.full"
> -        echo "--------------------------------------"       >>$here/$seq.out.full
> -        echo "$_n - output from randholes:"                 >>$here/$seq.out.full
> -        echo "--------------------------------------"       >>$here/$seq.out.full
> -        cat $tmp.out                                        >>$here/$seq.out.full
> -        echo "--------------------------------------"       >>$here/$seq.out.full
> -        echo "$_n - output from bmap:"                      >>$here/$seq.out.full
> -        echo "--------------------------------------"       >>$here/$seq.out.full
> -        xfs_bmap -vvv $out                                  >>$here/$seq.out.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        echo "$_n - output from randholes:"                 >>$seqres.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        cat $tmp.out                                        >>$seqres.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        echo "$_n - output from bmap:"                      >>$seqres.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        xfs_bmap -vvv $out                                  >>$seqres.full
>          status=1
>      fi
>  }
> @@ -91,7 +91,7 @@ _supported_os IRIX Linux
>  
>  _setup_testdir
>  
> -rm -f $here/$seq.out.full
> +rm -f $seqres.full
>  
>  # Note on special numbers here.
>  #
> diff --git a/tests/xfs/012 b/tests/xfs/012
> index 87c0b85..cd9c485 100755
> --- a/tests/xfs/012
> +++ b/tests/xfs/012
> @@ -62,7 +62,7 @@ _do_test()
>      echo "-----------------------------------------------"
>      if  ! $here/src/holes $_param $out >$tmp.out
>      then
> -        echo "    holes returned $? - see $seq.out.full"
> +        echo "    holes returned $? - see $seqres.full"
>          failed=1
>          status=1
>      fi
> @@ -78,7 +78,7 @@ _do_test()
>          
>          if [ $count -ne $_count ]
>          then
> -            echo "    unexpected number of holes - see $seq.out.full"
> +            echo "    unexpected number of holes - see $seqres.full"
>              status=1
>              failed=1
>          fi
> @@ -86,18 +86,18 @@ _do_test()
>          
>      if [ $failed -eq 1 ]
>      then
> -        echo "--------------------------------------"       >>$here/$seq.out.full
> -        echo "$_n - output from holes:"                     >>$here/$seq.out.full
> -        echo "--------------------------------------"       >>$here/$seq.out.full
> -        cat $tmp.out                                        >>$here/$seq.out.full
> -        echo "--------------------------------------"       >>$here/$seq.out.full
> -        echo "$_n - output from bmap:"                      >>$here/$seq.out.full
> -        echo "--------------------------------------"       >>$here/$seq.out.full
> -        xfs_bmap -vvv $out                                  >>$here/$seq.out.full
> -        echo "--------------------------------------"       >>$here/$seq.out.full
> -        echo "$_n - output from ls -li:"                    >>$here/$seq.out.full
> -        echo "--------------------------------------"       >>$here/$seq.out.full
> -        ls -li $out                                         >>$here/$seq.out.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        echo "$_n - output from holes:"                     >>$seqres.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        cat $tmp.out                                        >>$seqres.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        echo "$_n - output from bmap:"                      >>$seqres.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        xfs_bmap -vvv $out                                  >>$seqres.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        echo "$_n - output from ls -li:"                    >>$seqres.full
> +        echo "--------------------------------------"       >>$seqres.full
> +        ls -li $out                                         >>$seqres.full
>          status=1
>      fi
>  }
> @@ -108,7 +108,7 @@ _supported_os IRIX Linux
>  
>  _setup_testdir
>  
> -rm -f $here/$seq.out.full
> +rm -f $seqres.full
>  
>  # small & fairly dense
>  _do_test 1 "-l 40960000 -b 40960 -i 10 -c 1" 100
> diff --git a/tests/xfs/024 b/tests/xfs/024
> index 68e9788..2e13288 100755
> --- a/tests/xfs/024
> +++ b/tests/xfs/024
> @@ -43,11 +43,11 @@ _require_tape $TAPE_DEV
>  _create_dumpdir_fill
>  # ensure file/dir timestamps precede dump timestamp
>  sleep 2
> -src/bstat $SCRATCH_MNT >>$here/$seqres.full
> +src/bstat $SCRATCH_MNT >>$seqres.full
>  _erase_hard
>  _do_dump
>  _append_dumpdir_fill
> -src/bstat $SCRATCH_MNT >>$here/$seqres.full
> +src/bstat $SCRATCH_MNT >>$seqres.full
>  _erase_hard
>  _do_dump -l 1
>  _do_restore
> diff --git a/tests/xfs/067 b/tests/xfs/067
> index fbfaa1f..27f5713 100755
> --- a/tests/xfs/067
> +++ b/tests/xfs/067
> @@ -50,11 +50,11 @@ isize=0
>  _scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
>  [ $? -eq 0 ] && source $tmp.mkfs
>  if [ "$isize" -lt 1024 ]; then
> -    _scratch_mkfs_xfs -i size=1024 >>$here/$seqres.full \
> +    _scratch_mkfs_xfs -i size=1024 >>$seqres.full \
>  	|| _notrun "Cannot mkfs for this test using MKFS_OPTIONS specified"
>  fi
> -_scratch_mount >>$here/$seqres.full || _fail "mount failed"
> -xfs_info $SCRATCH_MNT >>$here/$seqres.full
> +_scratch_mount >>$seqres.full || _fail "mount failed"
> +xfs_info $SCRATCH_MNT >>$seqres.full
>  cd $SCRATCH_MNT
>  
>  echo ""
> diff --git a/tests/xfs/114 b/tests/xfs/114
> index 4dfdf86..1029dbc 100755
> --- a/tests/xfs/114
> +++ b/tests/xfs/114
> @@ -80,8 +80,8 @@ _test_create()
>  	p=dir2/dir3/dir4/file4
>  	touch $p
>  
> -	#_print_names $p >>$here/$seqres.full
> -	_print_names $p | tee -a $here/$seqres.full
> +	#_print_names $p >>$seqres.full
> +	_print_names $p | tee -a $seqres.full
>  
>  	_check_paths $SCRATCH_MNT/$p
>  }
> @@ -131,13 +131,13 @@ _test_hardlink()
>  		ln $p $x
>  	done
>  
> -	_print_names $p >>$here/$seqres.full
> +	_print_names $p >>$seqres.full
>  
>  	echo ""
>  	echo "print out names and check after created hardlinks"
>  	echo ""
>  	for x in $paths; do
> -		_print_names $x | tee -a $here/$seqres.full
> +		_print_names $x | tee -a $seqres.full
>  		_check_paths $SCRATCH_MNT/$x
>  	done
>  
> @@ -161,7 +161,7 @@ _test_hardlink()
>  	echo ""
>  	for x in $paths; do
>  		if [ -e $x ]; then 
> -			_print_names $x | tee -a $here/$seqres.full
> +			_print_names $x | tee -a $seqres.full
>  			_check_paths $SCRATCH_MNT/$x
>  		fi
>  	done
> @@ -230,7 +230,7 @@ _test_rename()
>  
>  _filter_num()
>  {
> -	tee -a $here/$seqres.full |\
> +	tee -a $seqres.full |\
>  	sed -e 's/[0-9][0-9]* inodes/I inodes/g' \
>  	    -e 's/[0-9][0-9]* paths/P paths/g' \
>  	    -e 's/seed = [0-9][0-9]*/seed = S/'
> @@ -255,7 +255,7 @@ _test_fsstress()
>  	if ! $FSSTRESS_PROG $args | _filter_num
>  	then
>  		echo "    fsstress $args returned $?"
> -		cat $tmp.out | tee -a $here/$seqres.full
> +		cat $tmp.out | tee -a $seqres.full
>  		status=1
>  	fi
>  
> @@ -284,8 +284,8 @@ _test_dirstress()
>  	if ! $here/src/dirstress $args >$tmp.out 2>&1 | _filter_num
>  	then
>  		echo "    dirstress failed"
> -		echo "*** dirstress $args" | tee -a $here/$seqres.full
> -		cat $tmp.out >>$here/$seqres.full
> +		echo "*** dirstress $args" | tee -a $seqres.full
> +		cat $tmp.out >>$seqres.full
>  		status=1
>  		exit
>  	fi
> @@ -295,8 +295,8 @@ _test_dirstress()
>  	if ! $here/src/dirstress $args >$tmp.out 2>&1 | _filter_num
>  	then
>  		echo "    dirstress failed"
> -		echo "*** dirstress $args" | tee -a $here/$seqres.full
> -		cat $tmp.out >>$here/$seqres.full
> +		echo "*** dirstress $args" | tee -a $seqres.full
> +		cat $tmp.out >>$seqres.full
>  		status=1
>  		exit
>  	fi
> @@ -316,16 +316,16 @@ _require_scratch
>  _require_attrs
>  _need_to_be_root
>  
> -rm -f $here/$seqres.full
> +rm -f $seqres.full
>  
>  echo "mkfs"
> -_scratch_mkfs_xfs >>$here/$seqres.full 2>&1 \
> +_scratch_mkfs_xfs >>$seqres.full 2>&1 \
>      || _fail "mkfs scratch failed"
> -_scratch_mkfs_xfs -i parent=1 >>$here/$seqres.full 2>&1 \
> +_scratch_mkfs_xfs -i parent=1 >>$seqres.full 2>&1 \
>      || _notrun "parent inodes not supported"
>  
>  echo "mount"
> -_scratch_mount >>$here/$seqres.full 2>&1 \
> +_scratch_mount >>$seqres.full 2>&1 \
>      || _fail "mount failed: $MOUNT_OPTIONS"
>  
>  # real QA test starts here
> diff --git a/tests/xfs/115 b/tests/xfs/115
> index 0933c54..967a904 100755
> --- a/tests/xfs/115
> +++ b/tests/xfs/115
> @@ -102,16 +102,16 @@ _supported_os IRIX
>  _require_scratch
>  _require_attrs
>  
> -rm -f $here/$seqres.full
> +rm -f $seqres.full
>  
>  echo "mkfs"
> -_scratch_mkfs_xfs >>$here/$seqres.full 2>&1 \
> +_scratch_mkfs_xfs >>$seqres.full 2>&1 \
>      || _fail "mkfs scratch failed"
> -_scratch_mkfs_xfs -i paths=1 >>$here/$seqres.full 2>&1 \
> +_scratch_mkfs_xfs -i paths=1 >>$seqres.full 2>&1 \
>      || _notrun "i_paths not supported"
>  
>  echo "mount"
> -_scratch_mount >>$here/$seqres.full 2>&1 \
> +_scratch_mount >>$seqres.full 2>&1 \
>      || _fail "mount failed: $MOUNT_OPTIONS"
>  
>  # real QA test starts here
> diff --git a/tests/xfs/168 b/tests/xfs/168
> index 4ca2869..901125a 100755
> --- a/tests/xfs/168
> +++ b/tests/xfs/168
> @@ -107,7 +107,7 @@ wait
>  # dmapi destroy events are asyncronous,  don't rely on fixed ordering of events
>  # in print_event output, use sort.
>  echo "# here comes the dmapi print_event filtered and sorted output"
> -cat $tmp.print_event_out | tee -a $here/$seqres.full | _filter_dmapi_print_event | LC_COLLATE=POSIX sort
> +cat $tmp.print_event_out | tee -a $seqres.full | _filter_dmapi_print_event | LC_COLLATE=POSIX sort
>  rm $tmp.print_event_out
>  
>  status=0
> diff --git a/tests/xfs/186 b/tests/xfs/186
> index 44edaf7..8df91b6 100755
> --- a/tests/xfs/186
> +++ b/tests/xfs/186
> @@ -78,7 +78,7 @@ _rmv_eas()
>  
>  _filter_inode()
>  {
> -	tee -a $here/$seqres.full | \
> +	tee -a $seqres.full | \
>  		sed -e "s/core.forkoff/forkoff/g" | \
>  		egrep '^u.sfdir2|^a.sfattr|forkoff' | \
>  		egrep -v 'inumber|parent'
> @@ -86,7 +86,7 @@ _filter_inode()
>  
>  _filter_version()
>  {
> -	tee -a $here/$seqres.full | tr ',' '\n' | grep ATTR
> +	tee -a $seqres.full | tr ',' '\n' | grep ATTR
>  }
>  
>  _print_inode()
> diff --git a/tests/xfs/282 b/tests/xfs/282
> index 8ddb258..15ccc3f 100755
> --- a/tests/xfs/282
> +++ b/tests/xfs/282
> @@ -46,13 +46,13 @@ _require_legacy_v2_format
>  _create_dumpdir_fill
>  # ensure file/dir timestamps precede dump timestamp
>  sleep 2
> -src/bstat $SCRATCH_MNT >>$here/$seqres.full
> +src/bstat $SCRATCH_MNT >>$seqres.full
>  
>  echo "*** Level 0 dump, format 2"
>  _do_dump_file -f $tmp.l0 -K
>  
>  _append_dumpdir_fill
> -src/bstat $SCRATCH_MNT >>$here/$seqres.full
> +src/bstat $SCRATCH_MNT >>$seqres.full
>  
>  echo "*** Level 1 dump, current format"
>  _do_dump_file -l 1 -f $tmp.l1
> diff --git a/tests/xfs/283 b/tests/xfs/283
> index cd9609e..def2107 100755
> --- a/tests/xfs/283
> +++ b/tests/xfs/283
> @@ -46,13 +46,13 @@ _require_legacy_v2_format
>  _create_dumpdir_fill
>  # ensure file/dir timestamps precede dump timestamp
>  sleep 2
> -src/bstat $SCRATCH_MNT >>$here/$seqres.full
> +src/bstat $SCRATCH_MNT >>$seqres.full
>  
>  echo "*** Level 0 dump, current format"
>  _do_dump_file -f $tmp.l0
>  
>  _append_dumpdir_fill
> -src/bstat $SCRATCH_MNT >>$here/$seqres.full
> +src/bstat $SCRATCH_MNT >>$seqres.full
>  
>  echo "*** Level 1 dump, format 2"
>  _do_dump_file -l 1 -f $tmp.l1 -K
> -- 
> 1.7.10.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
