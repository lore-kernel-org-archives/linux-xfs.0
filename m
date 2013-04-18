Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 804287F5A
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 11:33:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2758AC002
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 09:33:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 2EdqtPuqDKsUsauN for <xfs@oss.sgi.com>;
	Thu, 18 Apr 2013 09:33:13 -0700 (PDT)
References: <1366226244.3762.32346.camel@chandra-dt.ibm.com>
	<516F1563.4000909@sandeen.net>
	<1366297953.3762.32358.camel@chandra-dt.ibm.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1366297953.3762.32358.camel@chandra-dt.ibm.com>
Message-Id: <6AD0A59E-4807-47CB-AD89-C664DE316919@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfstests: Remove dependence of xfs_check script
Date: Thu, 18 Apr 2013 09:30:39 -0700
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
To: "sekharan@us.ibm.com" <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Apr 18, 2013, at 8:12 AM, Chandra Seetharaman <sekharan@us.ibm.com> wrote:

> Thanks Eric.
> 
> Adding this above _xfs_check() in common/config sounds good ?
> 
> # xfs_check script is planned to be deprecated. But, we want to
> # be able to invoke "xfs_check" behavior in xfstests in order to
> # maintain the current verification levels. 
> 
Sure, that's perfect.

Thanks,
Eric

> 
> On Wed, 2013-04-17 at 14:34 -0700, Eric Sandeen wrote:
>> On 4/17/13 12:17 PM, Chandra Seetharaman wrote:
>>> Replace the usage of the script xfs_check and add the relevant code to
>>> xfstests.
>>> 
>>> This is in preparation of the planned deprecation of xfs_check.
>> 
>> Other than maybe having a comment about why _xfs_check() is embedded
>> in common/rc for future readers, this looks fine to me, thanks.
>> 
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>> 
>>> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
>>> ---
>>> diff --git a/common/config b/common/config
>>> index bf62996..dfbb5c2 100644
>>> --- a/common/config
>>> +++ b/common/config
>>> @@ -154,7 +154,6 @@ export DF_PROG="`set_prog_path df`"
>>> 
>>> export XFS_LOGPRINT_PROG="`set_prog_path xfs_logprint`"
>>> export XFS_REPAIR_PROG="`set_prog_path xfs_repair`"
>>> -export XFS_CHECK_PROG="`set_prog_path xfs_check`"
>>> export XFS_DB_PROG="`set_prog_path xfs_db`"
>>> export XFS_GROWFS_PROG=`set_prog_path xfs_growfs`
>>> export XFS_IO_PROG="`set_prog_path xfs_io`"
>>> diff --git a/common/rc b/common/rc
>>> index 09fb83f..9cea3f9 100644
>>> --- a/common/rc
>>> +++ b/common/rc
>>> @@ -166,7 +166,6 @@ case "$FSTYP" in
>>>     xfs)
>>>     [ "$XFS_LOGPRINT_PROG" = "" ] && _fatal "xfs_logprint not found"
>>>     [ "$XFS_REPAIR_PROG" = "" ] && _fatal "xfs_repair not found"
>>> -     [ "$XFS_CHECK_PROG" = "" ] && _fatal "xfs_check not found"
>>>     [ "$XFS_DB_PROG" = "" ] && _fatal "xfs_db not found"
>>>     [ "$MKFS_XFS_PROG" = "" ] && _fatal "mkfs_xfs not found"
>>>     ;;
>>> @@ -387,6 +386,31 @@ _scratch_mkfs_xfs()
>>>     return $mkfs_status
>>> }
>>> 
>>> +_xfs_check()
>>> +{
>>> +    OPTS=" "
>>> +    DBOPTS=" "
>>> +
>>> +    OPTIND=1
>>> +    while getopts "b:fi:l:stvV" c
>>> +    do
>>> +        case $c in
>>> +            s) OPTS=$OPTS"-s ";;
>>> +            t) OPTS=$OPTS"-t ";;
>>> +            v) OPTS=$OPTS"-v ";;
>>> +            i) OPTS=$OPTS"-i "$OPTARG" ";;
>>> +            b) OPTS=$OPTS"-b "$OPTARG" ";;
>>> +            f) DBOPTS=$DBOPTS" -f";;
>>> +            l) DBOPTS=$DBOPTS" -l "$OPTARG" ";;
>>> +            V) $XFS_DB_PROG -p xfs_check -V
>>> +                return $?
>>> +                ;;
>>> +        esac
>>> +    done
>>> +    ${XFS_DB_PROG}${DBOPTS} -F -i -p xfs_check -c "check$OPTS" $1
>>> +    return $?
>>> +}
>>> +
>>> _setup_large_ext4_fs()
>>> {
>>>    fs_size=$1
>>> @@ -589,7 +613,7 @@ _scratch_xfs_check()
>>>         SCRATCH_OPTIONS="-l $SCRATCH_LOGDEV"
>>>     [ "$LARGE_SCRATCH_DEV" = yes ] && \
>>>         SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
>>> -    $XFS_CHECK_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
>>> +    _xfs_check $SCRATCH_OPTIONS $* $SCRATCH_DEV
>>> }
>>> 
>>> _scratch_xfs_repair()
>>> @@ -1426,7 +1450,7 @@ _check_xfs_filesystem()
>>>     # option (-t) to avoid indexing the free space trees doesn't make it pass on
>>>     # large filesystems. Avoid it.
>>>     if [ "$LARGE_SCRATCH_DEV" != yes ]; then
>>> -        $XFS_CHECK_PROG $extra_log_options $device 2>&1 |\
>>> +        _xfs_check $extra_log_options $device 2>&1 |\
>>>         _fix_malloc >$tmp.fs_check
>>>     fi
>>>     if [ -s $tmp.fs_check ]
>>> diff --git a/crash/xfscrash b/crash/xfscrash
>>> index 7831d7e..579b724 100755
>>> --- a/crash/xfscrash
>>> +++ b/crash/xfscrash
>>> @@ -120,11 +120,11 @@ _check()
>>>     if [ $expect -eq 0 ]
>>>     then
>>>         _echo "      *** xfs_check ($LOG/check_clean.out)"   
>>> -        xfs_check $TEST_DEV &> $LOG/check_clean.out || fail=1
>>> +        _xfs_check $TEST_DEV &> $LOG/check_clean.out || fail=1
>>>         [ -s /tmp/xfs_check_clean.out ] && fail=1
>>>     else
>>>         _echo "      *** xfs_check ($LOG/check_dirty.out)"   
>>> -        xfs_check $TEST_DEV &> $LOG/check_dirty.out || fail=1
>>> +        _xfs_check $TEST_DEV &> $LOG/check_dirty.out || fail=1
>>>     fi
>>> 
>>>     if [ $fail -eq 0 -a $expect -eq 0 ]
>>> diff --git a/tests/xfs/085 b/tests/xfs/085
>>> index 27f29a3..af71b77 100755
>>> --- a/tests/xfs/085
>>> +++ b/tests/xfs/085
>>> @@ -70,7 +70,7 @@ _print_logstate
>>> 
>>> # curious if FS consistent at start
>>> if false; then
>>> -    if $XFS_CHECK_PROG $SCRATCH_DEV; then
>>> +    if _xfs_check $SCRATCH_DEV; then
>>>        echo "*** checked ok ***"
>>>     fi
>>> fi
>>> diff --git a/tests/xfs/291 b/tests/xfs/291
>>> old mode 100644
>>> new mode 100755
>>> index f842679..7723b9e
>>> --- a/tests/xfs/291
>>> +++ b/tests/xfs/291
>>> @@ -113,7 +113,7 @@ done
>>> _scratch_unmount
>>> # Can xfs_repair and xfs_check cope with this monster?
>>> _scratch_xfs_repair >> $seqres.full 2>&1 || _fail "xfs_repair failed"
>>> -xfs_check $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_check failed"
>>> +_xfs_check $SCRATCH_DEV >> $seqres.full 2>&1 || _fail "xfs_check failed"
>>> 
>>> # Yes they can!  Now...
>>> # Can xfs_metadump cope with this monster?
>>> 
>>> 
>>> _______________________________________________
>>> xfs mailing list
>>> xfs@oss.sgi.com
>>> http://oss.sgi.com/mailman/listinfo/xfs
>> 
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
