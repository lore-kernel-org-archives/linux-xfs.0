Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 673317FBA
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 10:28:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 381B48F8078
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2013 08:28:51 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id w1Wm4Hmm0EARyXHO for
	<xfs@oss.sgi.com>; Wed, 13 Feb 2013 08:28:44 -0800 (PST)
Message-ID: <511BBF33.20908@redhat.com>
Date: Wed, 13 Feb 2013 10:28:35 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add disk failure simulation test
References: <1360770097-6351-1-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1360770097-6351-1-git-send-email-dmonakhov@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, dchinner@redhat.com, xfs@oss.sgi.com

On 2/13/13 9:41 AM, Dmitry Monakhov wrote:
> There are many situations where disk may fail for example
> 1) brutal usb dongle unplug
> 2) iscsi (or any other netbdev) failure due to network issues
> In this situation filesystem which use this blockdevice is
> expected to fail(force RO remount, abort, etc) but whole system
> should still be operational. In other words:
> 1) Kernel should not panic
> 2) Memory should not leak
> 3) Data integrity operations (sync,fsync,fdatasync, directio) should fail
>    for affected filesystem
> 4) It should be possible to umount broken filesystem
> 
> Later when disk becomes available again we expect(only for journaled filesystems):
> 5) It will be possible to mount filesystem w/o explicit fsck (in order to caught
>    issues like https://patchwork.kernel.org/patch/1983981/)
> 6) Filesystem should be operational
> 7) After mount/umount has being done all errors should be fixed so fsck should
>    not spot any issues.

Thanks, this should be very useful.  A couple questions & nitpicky
things below.

> This test use fault enjection (CONFIG_FAIL_MAKE_REQUEST=y config option )
> which force all new IO requests to fail for a given device. Xfs already has
> XFS_IOC_GOINGDOWN ioctl which provides similar behaviour, but it is fsspeciffic
> and it does it in an easy way because it perform freeze_bdev() before actual
> shotdown.

Well, just FWIW it depends on the flags it was given:

/*
 * Flags for going down operation
 */
#define XFS_FSOP_GOING_FLAGS_DEFAULT            0x0     /* going down */
#define XFS_FSOP_GOING_FLAGS_LOGFLUSH           0x1     /* flush log but not data */
#define XFS_FSOP_GOING_FLAGS_NOLOGFLUSH         0x2     /* don't flush log nor data */

Only the default case does freeze_bdev.

> Test run fsstress in background and then force disk failure.
> Once disk failed it check that (1)-(4) is true.
> Then makes disk available again and check that (5)-(7) is also true
> 
> BE CAREFUL!! test known to cause memory corruption for XFS
> see: https://gist.github.com/dmonakhov/4945005

For other reviewers, this patch depends on the series:
[PATCH 0/8] xfstests: Stress tests improments v3

> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  292           |  137 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  292.out       |    8 +++
>  common.config |    1 +
>  common.rc     |    6 +++
>  group         |    1 +
>  5 files changed, 153 insertions(+), 0 deletions(-)
>  create mode 100755 292
>  create mode 100644 292.out
> 
> diff --git a/292 b/292
> new file mode 100755
> index 0000000..3dd6608
> --- /dev/null
> +++ b/292
> @@ -0,0 +1,136 @@
> +#! /bin/bash
> +# FSQA Test No. 292
> +#
> +# Run fsstress and simulate disk failure
> +# check filesystem consystency at the end.

"consistency," just to be picky.

> +#
> +#-----------------------------------------------------------------------
> +# Copyright (c) 2006 Silicon Graphics, Inc.  All Rights Reserved.

(c) 2013 Dmitry Monakhov

> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,
> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#-----------------------------------------------------------------------
> +#
> +# creator
> +owner=dmonakhov@openvz.org
> +
> +seq=`basename $0`
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +
> +# get standard environment, filters and checks
> +. ./common.rc
> +. ./common.filter
> +
> +# TODO move it to common.blkdev if necessery

maybe a comment as to why you do this?  (presumably to find the right thing in /sys)
I hope this always works with all udev schemes etc?

> +SCRATCH_REAL_DEV=`readlink -f $SCRATCH_DEV`
> +SCRATCH_BDEV=`basename $SCRATCH_REAL_DEV`
> +
> +allow_fail_make_request()
> +{
> +    [ -f "$DEBUGFS_MNT/fail_make_request/probability" ] \
> +	|| _notrun "$DEBUGFS_MNT/fail_make_request \
> + not found. Seems that CONFIG_FAIL_MAKE_REQUEST kernel config option not enabled"
> +
> +    echo "Allow global fail_make_request feature"
> +    echo 100 > $DEBUGFS_MNT/fail_make_request/probability
> +    echo 9999999 > $DEBUGFS_MNT/fail_make_request/times
> +    echo 0 >  /sys/kernel/debug/fail_make_request/verbose
> +
> +}
> +
> +disallow_fail_make_request()
> +{
> +    echo "Disallow global fail_make_request feature"
> +    echo 0 > $DEBUGFS_MNT/fail_make_request/probability
> +    echo 0 > $DEBUGFS_MNT/fail_make_request/times
> +}
> +
> +poweroff_scratch_dev()

I guess I'd prefer just "fail_scratch_dev" since you aren't really
powering off anything.  :)

> +{
> +    echo "Force SCRATCH_DEV device failure"
> +    echo " echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $here/$seq.full
> +    echo 1 > /sys/block/$SCRATCH_BDEV/make-it-fail
> +
> +}
> +
> +poweron_scratch_dev()

Hm "unfail_scratch_dev?" :)

> +{
> +    echo "Make SCRATCH_DEV device operatable again"

"operable"

> +    echo " echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail" >> $here/$seq.full
> +    echo 0 > /sys/block/$SCRATCH_BDEV/make-it-fail
> +
> +}
> +
> +_cleanup()
> +{
> +    poweron_scratch_dev
> +    disallow_fail_make_request
> +}
> +trap "_cleanup; exit \$status" 1 2 3 15
> +
> +# Disable all sync operations to get higher load
> +FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0 -f setattr=1"
> +
> +_workout()
> +{
> +	out=$SCRATCH_MNT/fsstress.$$
> +	args=`_scale_fsstress_args -p 1 -n999999999 -f setattr=0 $FSSTRESS_AVOID -d $out`
> +	echo ""
> +	echo "Run fsstress"
> +	echo ""
> +	echo "fsstress $args" >> $here/$seq.full
> +	$FSSTRESS_PROG $args > /dev/null 2>&1 &
> +	pid=$!
> +	# Let's it work for awhile
> +	sleep $((20 + 10 * $TIME_FACTOR))
> +	poweroff_scratch_dev
> +	# After device turns in to failed state filesystem may not know about that
> +	# so buffered write(2) may succeed, but any integrity operation such as
> +	# (sync, fsync, fdatasync, direct-io) should fail.
> +	dd if=/dev/zero of=$SCRATCH_MNT/touch_failed_filesystem count=1 bs=4k conv=fsync \
> +	    >> $here/$seq.full 2>&1 && \
> +	    _fail "failed: still able to perform integrity sync on $SCRATCH_MNT"
> +
> +	kill $pid
> +	wait $pid
> +
> +	# We expect that broken fs is still can be umounted
> +	run_check umount -f $SCRATCH_DEV

why -f, out of curiosity?

> +	poweron_scratch_dev
> +
> +	# In order to check that filesystem is able to recover journal on mount(2)
> +	# perform mount/umount, after that all errors should be fixed
> +	run_check _scratch_mount
> +	run_check _scratch_unmount
> +	_check_scratch_fs
> +}
> +
> +# real QA test starts here
> +_supported_fs ext3 ext4 xfs btrfs

Could this be expanded to "generic" but only enforce a post-log-recovery clean
fsck for filesystems we know have journaling?

> +_supported_os Linux
> +_need_to_be_root
> +_require_scratch
> +_require_debugfs

should you have a:

_require_fail_make_request

here, instead of doing it in allow_fail_make_request ?
Might just be a little more obvious, and possibly useful
for other tests that build on this one.

> +
> +_scratch_mkfs >> $here/$seq.full 2>&1 || _fail "mkfs failed"
> +_scratch_mount || _fail "mount failed"
> +allow_fail_make_request
> +_workout
> +status=$?
> +disallow_fail_make_request
> +exit
> diff --git a/292.out b/292.out
> new file mode 100644
> index 0000000..08d9820
> --- /dev/null
> +++ b/292.out
> @@ -0,0 +1,8 @@
> +QA output created by 292
> +Allow global fail_make_request feature
> +
> +Run fsstress
> +
> +Force SCRATCH_DEV device failure
> +Make SCRATCH_DEV device operatable again
> +Disallow global fail_make_request feature
> diff --git a/common.config b/common.config
> index a956a46..f7a2422 100644
> --- a/common.config
> +++ b/common.config
> @@ -75,6 +75,7 @@ export BENCH_PASSES=${BENCH_PASSES:=5}
>  export XFS_MKFS_OPTIONS=${XFS_MKFS_OPTIONS:=-bsize=4096}
>  export TIME_FACTOR=${TIME_FACTOR:=1}
>  export LOAD_FACTOR=${LOAD_FACTOR:=1}
> +export DEBUGFS_MNT=${DEBUGFS_MNT:="/sys/kernel/debug"}
>  
>  export PWD=`pwd`
>  #export DEBUG=${DEBUG:=...} # arbitrary CFLAGS really.
> diff --git a/common.rc b/common.rc
> index 5c3dda1..d5d9c9f 100644
> --- a/common.rc
> +++ b/common.rc
> @@ -1027,6 +1027,12 @@ _require_sparse_files()
>      esac
>  }
>  
> +_require_debugfs()
> +{
> +    #boot_params always present in debugfs
> +    [ -d "$DEBUGFS_MNT/boot_params" ] || _notrun "Debugfs not mounted"
> +}

Would it make more sense to look for debugfs in /proc/filesystems
as a test for it being *available* (as opposed to mounted somewhere?)

I wonder if a helper (maybe in _require_debugfs) should work out if
it's mounted, if not, try to mount it, and in the end, export DEBUGFS_MNT
for any test that wants to use it.

Otherwise if it happens to be mounted elsewhere, this'll all fail.
Just a thought.  Maybe that's unusual enough that there's no point.
But getting it mounted if it's not would be helpful I think.

> +
>  # check that a FS on a device is mounted
>  # if so, return mount point
>  #
> diff --git a/group b/group
> index b962a33..c409957 100644
> --- a/group
> +++ b/group
> @@ -415,3 +415,4 @@ stress
>  289 auto aio dangerous ioctl rw stress
>  290 auto aio dangerous ioctl rw stress
>  291 auto aio dangerous ioctl rw stress
> +292 dangerous rw stress
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
