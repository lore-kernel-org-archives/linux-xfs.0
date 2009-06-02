Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n52FAfiZ107769 for <xfs@oss.sgi.com>; Tue, 2 Jun 2009 10:10:42 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E3981041671
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2009 08:17:24 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id G8ryaZ0Y5QEjrkAX for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2009 08:17:24 -0700 (PDT)
Message-ID: <4A2540F4.4050204@sandeen.net>
Date: Tue, 02 Jun 2009 10:10:44 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 8/9] Enable generic filesystems to be fsck'd
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
	<1243450413-12681-9-git-send-email-sandeen@sandeen.net>
	<20090528125128.GA13425@infradead.org>
	<20090602123852.GA4101@infradead.org>
In-Reply-To: <20090602123852.GA4101@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Thu, May 28, 2009 at 08:51:28AM -0400, Christoph Hellwig wrote:
>> On Wed, May 27, 2009 at 01:53:32PM -0500, Eric Sandeen wrote:
>>> This includes a fair bit of rearranging to avoid code duplication,
>>> but the goal is to allow 'fsck -n -t $FSTYP $device' to be run on
>>> any generic filesystem.
>>>
>>> Any FS for which this doesn't work will need it's own fsck routine.
>> Looks generally good, some comments:
>>
>>  - I would get rid of _check_generic_test_fs and just opencode the
>>    _check_generic_filesystem $TEST_DEV in the two callers.
>>  - why the odd calling convention of _is_mounted which allows to
>>    optionally pass the fstype?  Currently we only have one caller
>>    that doesn't pass it, and if we grow one that needs it I would
>>    rather always pass it explicitly..
>>
>> Btw, I seems like _check_testdir is never actually called, and I can't
>> really see a reason why it would be different from _check_test_fs.
> 
> Here's a version with those changes and additionally making sure
> _check_test_fs continues to be a no-op for nfs and udf.

Thanks :)  nitpicky comments below, mostly probably nitpicking stuff
that was in my original patch ;)

> Index: xfstests-dev/common.rc
> ===================================================================
> --- xfstests-dev.orig/common.rc	2009-06-02 12:12:24.000000000 +0000
> +++ xfstests-dev/common.rc	2009-06-02 12:21:36.000000000 +0000
> @@ -707,29 +707,29 @@
>      [ "$?" == "0" ] || _notrun "$qa_user user not defined."
>  }
>  
> -# check that a FS is mounted as XFS. if so, return mount point
> +# check that a FS on a device is mounted
> +# if so, return mount point
>  #
> -_xfs_mounted()
> +_is_mounted()
>  {
>      if [ $# -ne 1 ]
>      then
> -	echo "Usage: _xfs_mounted device" 1>&2
> +	echo "Usage: _is_mounted device" 1>&2
>  	exit 1
>      fi
>  
>      device=$1
>  
> -    if _mount | grep "$device " | $AWK_PROG '
> -        /type xfs/  { print $3 ; exit 0 }
> -        END         { exit 1 }
> +    if _mount | grep "$device " | $AWK_PROG -v pattern="type $FSTYP" '
> +        pattern        { print $3 ; exit 0 }
> +        END            { exit 1 }
>      '
>      then
> -        echo "_xfs_mounted: $device is not a mounted XFS FS"
> +        echo "_is_mounted: $device is not a mounted $FSTYP FS"
>          exit 1
>      fi
>  }
>  
> -
>  # remount a FS to a new mode (ro or rw)
>  #
>  _remount()
> @@ -749,14 +749,105 @@
>      fi
>  }
>  
> -# run xfs_check and friends on a FS.
> +# Run the apropriate repair/check on a filesystem
             appropriate (that was probably my typo to start with!)
>  #
>  # if the filesystem is mounted, it's either remounted ro before being
>  # checked or it's unmounted and then remounted
>  #
>  
> +# If set, we remount ro instead of unmounting for fsck
>  USE_REMOUNT=0
>  
> +_umount_or_remount_ro()
> +{
> +    if [ $# -ne 1 ]
> +    then
> +	echo "Usage: _umount_or_remount_ro device" 1>&2
                                          <device> might be clearer
> +	exit 1
> +    fi
> +    device=$1
> +
> +    if [ $USE_REMOUNT -eq 0 ]
> +    then
> +        mountpoint=`_is_mounted $device`
> +        $UMOUNT_PROG $device
> +    else
> +        _remount $device ro
> +    fi
> +    echo "$mountpoint"

Maybe we should move the mountpoint assignment outside the conditional,
since we echo it unconditionally.  Only the !USE_REMOUNT case cares
anyway but still...

> +}
> +
> +_mount_or_remount_rw()
> +{
> +    if [ $# -ne 3 ]
> +    then
> +	echo "Usage: _mount_or_remount_rw opts device mountpoint" 1>&2
                                      <opts> <device> <mountpoint>
> +	exit 1
> +    fi
> +    mount_opts=$1
> +    device=$2
> +    mountpoint=$3
> +
> +    if [ $USE_REMOUNT -eq 0 ]
> +    then
> +        if ! _mount -t $FSTYP $mount_opts $device $mountpoint
> +        then
> +            echo "!!! failed to remount $device on $mountpoint"
> +            return 0 # ok=0
> +        fi
> +    else
> +        _remount $device rw
> +    fi
> +
> +    return 1 # ok=1
> +}

# Check a generic filesystem in no-op mode; this assumes that the
# underlying fsck program accepts "-n" for a no-op (check-only) run,
# and that it will still return an errno for corruption in this mode.
#
# Filesystems which don't support this will need to define their
# own check routine.

> +_check_generic_filesystem()
> +{
> +    device=$1
> +
> +    # If type is set, we're mounted
> +    type=`_fs_type $device`
> +    ok=1
> +
> +    if [ "$type" = "$FSTYP" ]
> +    then
> +        # mounted ...
> +        mountpoint=`_umount_or_remount_ro $device`
> +    fi
> +
> +    fsck -t $FSTYP -n $device >$tmp.fsck 2>&1
> +    if [ $? -ne 0 ]
> +    then
> +        echo "_check_generic_filesystem: filesystem on $device is inconsistent (see $seq.full)"
> +
> +        echo "_check_generic filesystem: filesystem on $device is inconsistent" >>$here/$seq.full
> +        echo "*** fsck.$FSTYP output ***"                     >>$here/$seq.full
> +        cat $tmp.fsck                                         >>$here/$seq.full
> +        echo "*** end fsck.$FSTYP output"                     >>$here/$seq.full
> +
> +        ok=0
> +    fi
> +    rm -f $tmp.fsck
> +
> +    if [ $ok -eq 0 ]
> +    then
> +        echo "*** mount output ***"                             >>$here/$seq.full
> +        _mount                                                  >>$here/$seq.full
> +        echo "*** end mount output"                             >>$here/$seq.full
> +    elif [ "$type" = "$FSTYP" ]
> +    then
> +        # was mounted ...
> +	_mount_or_remount_rw "$MOUNT_OPTIONS" $device $mountpoint

oops tab vs. space here

> +        ok=$?
> +    fi
> +
> +    [ $ok -eq 0 ] && exit 1
> +    return 0
> +}
> +
> +# run xfs_check and friends on a FS.
> +
>  _check_xfs_filesystem()
>  {
>      if [ $# -ne 3 ]
> @@ -787,15 +878,8 @@
>  
>      if [ "$type" = "xfs" ]
>      then
> -        # mounted...
> -
> -        if [ $USE_REMOUNT -eq 0 ]
> -        then
> -            mountpoint=`_xfs_mounted $device`
> -            $UMOUNT_PROG $device
> -        else
> -            _remount $device ro
> -        fi
> +        # mounted ...
> +        mountpoint=`_umount_or_remount_ro $device`
>      fi
>  
>      $XFS_LOGPRINT_PROG -t $extra_log_options $device 2>&1 \
> @@ -848,17 +932,7 @@
>          echo "*** end mount output"                             >>$here/$seq.full
>      elif [ "$type" = "xfs" ]
>      then
> -        # mounted...
> -        if [ $USE_REMOUNT -eq 0 ]
> -        then
> -            if ! _mount -t xfs $extra_mount_options $device $mountpoint
> -            then
> -                echo "!!! failed to remount $device on $mountpoint"
> -                ok=0
> -            fi
> -        else
> -            _remount $device rw
> -        fi
> +	_mount_or_remount_rw "$extra_mount_options" $device $mountpoint
>      fi
>  
>      [ $ok -eq 0 ] && exit 1
> @@ -908,12 +982,8 @@
>  
>  }
>  
> -_check_test_fs()
> +_check_xfs_test_fs()
>  {
> -    if [ "$FSTYP" != "xfs" ]; then
> -        return
> -    fi
> -
>      TEST_LOG="none"
>      TEST_RT="none"
>      [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_LOGDEV" ] && \
> @@ -932,6 +1002,24 @@
>      fi
>  }
>  
> +_check_test_fs()
> +{
> +    case $FSTYP in
> +    xfs)
> +	_check_xfs_test_fs
> +	;;
> +    nfs)
> +	# no way to check consistency for nfs
> +	;;
> +    udf)
> +	# do nothing for now
> +	;;
> +    *)
> +        _check_generic_filesystem $TEST_DEV

fix indentation here ...

> +	;;
> +    esac
> +}
> +
>  _check_scratch_fs()
>  {
>      case $FSTYP in
> @@ -953,6 +1041,7 @@
>  	# Don't know how to check an NFS filesystem, yet.
>  	;;
>      *)
> +	_check_generic_filesystem $SCRATCH_DEV
>  	;;
>      esac
>  }
> @@ -987,25 +1076,6 @@
>       echo "$os/$platform $host $kernel"
>  }
>  
> -_check_testdir()
> -{
> -    case $FSTYP in
> -    xfs)
> -	_check_test_fs
> -	;;
> -    udf)
> -	_cleanup_testdir
> -	_check_scratch_fs
> -	_scratch_mount
> -	;;
> -    nfs*)
> -	# Don't know how to check an NFS filesystem, yet.
> -	;;
> -    *)
> -	;;
> -    esac
> -}
> -
>  _setup_udf_scratchdir()
>  {
>      [ "$FSTYP" != "udf" ] \
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
