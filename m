Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C8407F4C
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 13:03:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A155AAC004
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 11:03:41 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id AAiG8VCPgSfB4kEi (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 17 Apr 2013 11:03:40 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 17 Apr 2013 14:03:38 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 9B84DC90081
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 14:03:34 -0400 (EDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r3HI3Xjp335392 for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 14:03:34 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r3HI3WvP029711
	for <xfs@oss.sgi.com>; Wed, 17 Apr 2013 12:03:33 -0600
Subject: Re: [PATCH] xfstests: replace xfs_check with xfs_repair -n
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <516ED4A0.9040706@sandeen.net>
References: <1366216695.3762.32325.camel@chandra-dt.ibm.com>
	<516ED4A0.9040706@sandeen.net>
Date: Wed, 17 Apr 2013 13:03:30 -0500
Message-ID: <1366221810.3762.32341.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: XFS mailing list <xfs@oss.sgi.com>

Hi Eric,

Thanks for the quick feedback.

On Wed, 2013-04-17 at 09:58 -0700, Eric Sandeen wrote:
> On 4/17/13 9:38 AM, Chandra Seetharaman wrote:
> > Replace the usage of "xfs_check" with "xfs_repair -n" as xfs_check
> > is planned to be depracated.
> 
> Hm, I thought the plan was to keep xfs_check around for xfstests

I didn't think the plan was to keep xfs_check, may be I misunderstood.
My understanding was that we wanted to deprecate xfs_check, but first we
have to make xfstests not use xfs_check.

> use, for now; as Dave said in the earlier thread:
> 
> > xfstests also still needs to run xfs_check. That means we also need
> > either an override flag an make $XFS_CHECK_PROG have it set
> > appropriately or add an internal xfs_db wrapper that runs the
> > xfs_check functionality appropriately. The second is probably the
> > better option...
> 
> but that's not what this patch does...

The usages of xfs_check in xfstests looked simple and straight forward.
Besides, I thought we should do what we suggest our users to do :),
hence replaced xfs_check with "xfs_repair -n".

Does this patch break something or technically incorrect ?

Do you think I should instead use 
    xfs_db -F -i -p xfs_check -c "check" <dev>

Please advise.

Chandra
> -Eric
> 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > ---
> > 
> > diff --git a/common/config b/common/config
> > index bf62996..dfbb5c2 100644
> > --- a/common/config
> > +++ b/common/config
> > @@ -154,7 +154,6 @@ export DF_PROG="`set_prog_path df`"
> >  
> >  export XFS_LOGPRINT_PROG="`set_prog_path xfs_logprint`"
> >  export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
> > -export XFS_CHECK_PROG="`set_prog_path xfs_check`"
> >  export XFS_DB_PROG="`set_prog_path xfs_db`"
> >  export XFS_GROWFS_PROG=`set_prog_path xfs_growfs`
> >  export XFS_IO_PROG="`set_prog_path xfs_io`"
> > diff --git a/common/rc b/common/rc
> > index 09fb83f..32a852f 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -166,7 +166,6 @@ case "$FSTYP" in
> >      xfs)
> >  	 [ "$XFS_LOGPRINT_PROG" = "" ] && _fatal "xfs_logprint not found"
> >  	 [ "$XFS_REPAIR_PROG" = "" ] && _fatal "xfs_repair not found"
> > -	 [ "$XFS_CHECK_PROG" = "" ] && _fatal "xfs_check not found"
> >  	 [ "$XFS_DB_PROG" = "" ] && _fatal "xfs_db not found"
> >  	 [ "$MKFS_XFS_PROG" = "" ] && _fatal "mkfs_xfs not found"
> >  	 ;;
> > @@ -589,7 +588,7 @@ _scratch_xfs_check()
> >          SCRATCH_OPTIONS="-l $SCRATCH_LOGDEV"
> >      [ "$LARGE_SCRATCH_DEV" = yes ] && \
> >          SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
> > -    $XFS_CHECK_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
> > +    $XFS_REPAIR_PROG -n $SCRATCH_OPTIONS $* $SCRATCH_DEV &>/dev/null
> >  }
> >  
> >  _scratch_xfs_repair()
> > @@ -1422,25 +1421,6 @@ _check_xfs_filesystem()
> >          ok=0
> >      fi
> >  
> > -    # xfs_check runs out of memory on large files, so even providing the test
> > -    # option (-t) to avoid indexing the free space trees doesn't make it pass on
> > -    # large filesystems. Avoid it.
> > -    if [ "$LARGE_SCRATCH_DEV" != yes ]; then
> > -	    $XFS_CHECK_PROG $extra_log_options $device 2>&1 |\
> > -		 _fix_malloc >$tmp.fs_check
> > -    fi
> > -    if [ -s $tmp.fs_check ]
> > -    then
> > -        echo "_check_xfs_filesystem: filesystem on $device is inconsistent (c) (see $seqres.full)"
> > -
> > -        echo "_check_xfs_filesystem: filesystem on $device is inconsistent" >>$seqres.full
> > -        echo "*** xfs_check output ***"		>>$seqres.full
> > -        cat $tmp.fs_check			>>$seqres.full
> > -        echo "*** end xfs_check output"		>>$seqres.full
> > -
> > -        ok=0
> > -    fi
> > -
> >      $XFS_REPAIR_PROG -n $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
> >      if [ $? -ne 0 ]
> >      then
> > diff --git a/crash/xfscrash b/crash/xfscrash
> > index 7831d7e..6437d54 100755
> > --- a/crash/xfscrash
> > +++ b/crash/xfscrash
> > @@ -119,12 +119,11 @@ _check()
> >      
> >      if [ $expect -eq 0 ]
> >      then
> > -        _echo "      *** xfs_check ($LOG/check_clean.out)"   
> > -        xfs_check $TEST_DEV &> $LOG/check_clean.out || fail=1
> > -        [ -s /tmp/xfs_check_clean.out ] && fail=1
> > +        _echo "      *** Running xfs_repair -n ($LOG/check_clean.out)"   
> > +        xfs_repair -n $TEST_DEV &> $LOG/check_clean.out && fail=1
> >      else
> > -        _echo "      *** xfs_check ($LOG/check_dirty.out)"   
> > -        xfs_check $TEST_DEV &> $LOG/check_dirty.out || fail=1
> > +        _echo "      *** Running xfs_repair -n ($LOG/check_dirty.out)"   
> > +        xfs_repair -n $TEST_DEV &> $LOG/check_dirty.out || fail=1
> >      fi
> >      
> >      if [ $fail -eq 0 -a $expect -eq 0 ]
> > diff --git a/tests/xfs/017 b/tests/xfs/017
> > index 9fc16c2..03f907e 100755
> > --- a/tests/xfs/017
> > +++ b/tests/xfs/017
> > @@ -83,7 +83,7 @@ do
> >          echo "*** XFS_CHECK ***"            >>$seqres.full
> >          echo ""                             >>$seqres.full
> >          _scratch_xfs_check                  >>$seqres.full 2>&1 \
> > -            || _fail "xfs_check failed"
> > +            || _fail "xfs check failed"
> >          _scratch_mount -o remount,rw \
> >              || _fail "remount rw failed"
> >  done
> > diff --git a/tests/xfs/085 b/tests/xfs/085
> > index 27f29a3..02c6703 100755
> > --- a/tests/xfs/085
> > +++ b/tests/xfs/085
> > @@ -70,7 +70,7 @@ _print_logstate
> >  
> >  # curious if FS consistent at start
> >  if false; then
> > -    if $XFS_CHECK_PROG $SCRATCH_DEV; then
> > +    if $XFS_REPAIR_PROG -n $SCRATCH_DEV &>/dev/null; then
> >         echo "*** checked ok ***"
> >      fi
> >  fi
> > diff --git a/tests/xfs/291 b/tests/xfs/291
> > old mode 100644
> > new mode 100755
> > index f842679..dc3c342
> > --- a/tests/xfs/291
> > +++ b/tests/xfs/291
> > @@ -111,9 +111,9 @@ for I in `seq 1 2 5000`; do
> >  done
> >  
> >  _scratch_unmount
> > -# Can xfs_repair and xfs_check cope with this monster?
> > +# Can xfs_repair and check cope with this monster?
> >  _scratch_xfs_repair >> $seqres.full 2>&1 || _fail "xfs_repair failed"
> > -xfs_check $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_check failed"
> > +xfs_repair -n $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_repair -n failed"
> >  
> >  # Yes they can!  Now...
> >  # Can xfs_metadump cope with this monster?
> > 
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
