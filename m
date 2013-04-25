Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 972C229DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 17:46:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D2CBAC006
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 15:46:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	vpV6TMZ3b7X3u4GY for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 15:46:01 -0700 (PDT)
Date: Fri, 26 Apr 2013 08:45:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V2
Message-ID: <20130425224556.GS30622@dastard>
References: <1366899176-12876-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1366899176-12876-1-git-send-email-jbacik@fusionio.com>
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
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, Apr 25, 2013 at 10:12:56AM -0400, Josef Bacik wrote:
> This test sets up a dm flakey target and then runs my fsync tester I've been
> using to verify btrfs's fsync() is working properly.  It will create a dm flakey
> device, mount it, run my test, make the flakey device start dropping writes, and
> then unmount the fs.  Then we mount it back up and make sure the md5sums match
> and then run fsck on the device to make sure we got a consistent fs.  I used the
> output from a run on BTRFS since it's the only one that passes this test
> properly.  I verified each test manually to make sure they were in fact valid
> files.  XFS and Ext4 both fail this test in one way or another.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V1->V2
> -make _test_check_fs take an argument on wether or not to force an exit, this is
> because if we failed to fsck we'd leave the dmflakey device around which was
> super annoying.

Why doesn't the standard trap command in the test code catch
the exit case and run the _cleanup function and unmount it?

FWIW, if this change is actually necessary, then it needs to be in a
separate patch.

> -fixed the drop caches bug (thanks Zach!)
> -fixed the output since XFS has a bug with that particular test, it leaves a 0
> length file behind which isn't right. 

What test, what bug, and why have you changed the test to work
around it?

.....
> @@ -478,7 +485,7 @@ _scratch_mkfs_ext4()
>  {
>  	local tmp_dir=/tmp/
>  
> -	/sbin/mkfs -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV \
> +	/sbin/mkfs -t $FSTYP -- -F $MKFS_OPTIONS $* $SCRATCH_DEV \
>  			2>$tmp_dir.mkfserr 1>$tmp_dir.mkfsstd
>  	local mkfs_status=$?

That seems like an unrelated bug fix?

> @@ -1041,6 +1048,27 @@ _require_command()
>      [ -n "$1" -a -x "$1" ] || _notrun "$_cmd utility required, skipped this test"
>  }
>  
> +# this test requires the device mapper flakey target
> +#
> +_require_dm_flakey()
> +{
> +    if [ "$HOSTOS" != "Linux" ]
> +    then
> +	_notrun "This test requires linux for dm flakey support"
> +    fi

No need to check this - any test that uses dm-flakey should have a
"_supported_os Linux" line in it.

> +    $DMSETUP_PROG targets | grep flakey >/dev/null 2>&1
> +    if [ $? -eq 0 ]
> +    then
> +	:
> +    else
> +	_notrun "This test requires dm flakey support"
> +    fi

[ $? -ne 0 ] && _notrun "This test requires dm flakey support"

<snip all the "force exit" mess>

<snip the fsync-tester.c code>

FWIW, rebooting the machine at the end of the test should not be the
default behaviour of fsync-tester.c...

> diff --git a/tests/generic/311 b/tests/generic/311
> new file mode 100755
> index 0000000..3f7abe2
> --- /dev/null
> +++ b/tests/generic/311
> @@ -0,0 +1,177 @@
> +#! /bin/bash
> +# FS QA Test No. 311
> +#
> +#Verify a file systems fsync is working properly.  This won't catch problems
> +#with blockdev flushing, but at the very least it makes sure the file system is
> +#doing the right thing with fsync logically.

How is this different to any of the other tests that test fsync() is
working properly? Please describe what aspect of fsync is being
tested....

> +# creator
> +owner=jbacik@fusionio.com

We don't need to add these any more.

> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +status=1	# failure is the default!
> +
> +_cleanup()
> +{
> +	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
> +	$DMSETUP_PROG remove flakey-test > /dev/null 2>&1
> +}
> +
> +_cleanup

If we are called with a mounted scratch device, then something has
gone badly wrong somewhere else - tests *always* start with
unmounted test and scratch devices.

What I suspect has gone wrong here is that you've removed the line:

trap "_cleanup; exit \$status" 0 1 2 3 15

That will trigger the cleanup function whenever the test exits. I'd
say this is the cause of the problem you have that has caused you to
add the "force exit" crap to the filesytsem check functions...

> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_need_to_be_root
> +_require_scratch
> +_require_dm_flakey
> +
> +[ -x $here/src/fsync-tester ] || _notrun "fsync-tester not build"
> +
> +rm -f $seqres.full
> +BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> +FLAKEY_DEV=/dev/mapper/flakey-test
> +SEED=1
> +testfile=$SCRATCH_MNT/$seq.fsync
> +
> +_mount_flakey()
> +{
> +	_scratch_options mount
> +	_mount -t $FSTYP $SCRATCH_OPTIONS $MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS $* $FLAKEY_DEV $SCRATCH_MNT
> +}

Why do you need to open code all this? We typically don't do
this for loopback device mounts, so I'm not sure it is necessary
here. Indeed, if you are testing on the flakey device, you don't
want XFS using external log or realtime devices, so really just
something like:

mount -t $FSTYP $MOUNT_OPTIONS $FLAKEY_DEV $SCRATCH_MNT

will suffice...

> +_unmount_flakey()
> +{
> +	$UMOUNT_PROG $FLAKEY_DEV
> +}

Empty line after this needed. FWIW, why use $FLAKEY_DEV here and not
$SCRATCH_MNT like in the cleanup function?


> +_drop_writes()
> +{
> +	$DMSETUP_PROG suspend flakey-test

That freezes the filesystem, right?

> +	if [ $? -ne 0 ]; then
> +		echo "failed to suspend flakey-test"
> +		_unmount_flakey
> +		_cleanup
> +		exit
> +	fi

With a properly functioning trap that calls _cleanup(), this can be
replaced with:

	[ $? -ne 0 ] && _fatal "failed to suspend flakey-test"

Same for all the other error cases.

> +	$DMSETUP_PROG load flakey-test --table "0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 0 180 1 drop_writes"

Given that there are 2 different table configurations, perhaps
defining them as variables will make it more obvious. e.g.

FLAKEY_TABLE="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 0 180 0"
FLAKEY_WRITE_TABLE="0 $BLK_DEV_SIZE flakey $SCRATCH_DEV 0 0 180 1 drop_writes"

> +_run_test()
> +{
> +	test_num=$1
> +	extra=""
> +
> +	[ $2 -eq 1 ] && extra="-d"

I'm assuming that $2 == 1 means "use direct IO" given it is not
actually documented? Perhaps "extra" is not such a good name?

> +	$here/src/fsync-tester -s $SEED -r -t $test_num $extra $testfile
> +	if [ $? -ne 0 ]; then
> +		_unmount_flakey
> +		_cleanup
> +		exit
> +	fi
> +
> +	_md5_checksum $testfile
> +	_drop_writes
> +	_unmount_flakey

So, _drop_writes suspends the dm-flakey device, freezes the
filesystem, turns off writes then thaws the filesystem, right?

If so, doesn't that mean you're not actually testing fsync() as the
freeze will effectively sync the entire filesystem before you start
dropping writes?

I can see why you want to stop unmount from writing back metadata to
simulate a crash, but if you've already frozen the filesystem then
writeback has already occurred before you stop the writes. So I
can't see how this is actually testing fsync - what it appears to be
testing is the fileystem freeze code...

[ This is precisely the issue that XFS shutdown ioctls deal with to
trigger an immediate forced shutdown of the filesystem that prevents
*any* further writes from being issued by the filesystem - no sync
operations get in the way and change the state of the filesystem
after then fsync call, so we know that what is on disk is what was
written by the sync/fsync calls being tested.

This is how we test sync/fsync in other XFS tests (e.g.
xfs/137-140), and this is the reason why us XFS people have
suggested that other filesystems should implement the ioctls for
this functionality rather than try to invent new ways of trying
to stop filesystems from writing back dirty metadata for fsync/sync
testing....

Besides, if a corruption is detected, you need a method of stopping
all dirty metadata from being written back in the filesystem to
prevent propagation of the corruption.  These ioctls should just be
an interface into that mechanism. ]

> +_cleanup
> +status=0
> +exit

No need to call _cleanup if you have a functioning trap. And, more
importantly, the only reason that status variable exists is so that
the trap function can ensure a correct exit value from the test.....

> diff --git a/tests/generic/group b/tests/generic/group
> index eb52833..a0830c1 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -113,3 +113,4 @@
>  308 auto quick
>  309 auto quick
>  310 auto
> +311 auto

How long does this take to run? It seems like the quick group would
be appropriate if it takes less than a minute. Also, fsync tests
fall under the category of "metadata" and "log", so they probably
should be added, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
