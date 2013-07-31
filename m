Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B808A7CBF
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 10:52:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A401C8F8035
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 08:52:31 -0700 (PDT)
Received: from mo-p00-ob.rzone.de (mo-p00-ob.rzone.de [81.169.146.161]) by
	cuda.sgi.com with ESMTP id gyBnKRT8EVbuVDtI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 31 Jul 2013 08:52:27 -0700 (PDT)
Message-ID: <51F932B6.80203@giantdisaster.de>
Date: Wed, 31 Jul 2013 17:52:22 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstest: add a test for btrfs device replace operation
References: <1374830885-26966-1-git-send-email-sbehrens@giantdisaster.de>
	<51F293E8.3080601@redhat.com>
In-Reply-To: <51F293E8.3080601@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, 26 Jul 2013 10:21:12 -0500, Eric Sandeen wrote:
> On 7/26/13 4:28 AM, Stefan Behrens wrote:
>> Unfortunately this test takes 6 minutes on my SSD equiped test box since
>> it runs all possible single/dup/raid0/raid1/raid10/mixed profiles, one
>> round with the '-f' option to 'btrfs replace start' and one round
>> without this option. The cancelation is tested only once and with the
>> dup/single profile for metadata/data.
>>
>> Almost all the time is spent when the filesystem is populated with test
>> data. The replace operation itself takes one second for all the tests,
>> and 20 seconds for the test that is marked as 'thorough' (this one
>> spends more than a minute to populate the filesystem with data).
> 
> Can you tell it to make a smaller filesystem so this doesn't take
> as long?  Would that still be spread across all devices properly?
> All you really need is data across all devices, right - whether it's
> 2G or 200G or 2000G in total shouldn't _really_ matter?
> 
>> The amount of tests done depends on the number of devices in the
>> SCRATCH_DEV_POOL. For full test coverage, at least 5 devices should
>> be available (e.g. 5 partitions).
>>
>> For the first round, the last device in the SCRATCH_DEV_POOL string
>> is taken as the target device for the replace operation, the first
>> device is the source device. For the second round it is the other way
>> round. Therefore make sure that both devices have _exactly_ the same
>> size, otherwise the tests fail! The target device for a replace
>> operation always needs to be larger or of equal size than the source
>> device.
>>
>> If SCRATCH_DEV_POOL is set to "A B C D E" for example, the first
>> round creates a filesystem on "A B C D" and replaces A with E in the
>> first round, and E again with A in the second round. E and A need to
>> have the same size for the tests to succeed.
>>
>> To check the filesystems after replacing a device, a scrub run is
>> performed, a btrfsck run, and finally the filesystem is remounted.
>>
>> This commit depends on my other commit:
>> "xfstest: don't remove the two first devices from SCRATCH_DEV_POOL"
>>
>> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
>> ---
>>  tests/btrfs/317     | 209 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/317.out |   3 +
>>  tests/btrfs/group   |   1 +
>>  3 files changed, 213 insertions(+)
>>
>> diff --git a/tests/btrfs/317 b/tests/btrfs/317
>> new file mode 100755
>> index 0000000..b4f0d8c
>> --- /dev/null
>> +++ b/tests/btrfs/317
>> @@ -0,0 +1,209 @@
>> +#! /bin/bash
>> +# FSQA Test No. 317
>> +#
>> +# Test of the btrfs replace operation.
>> +#
>> +# The amount of tests done depends on the number of devices in the
>> +# SCRATCH_DEV_POOL. For full test coverage, at least 5 devices should
>> +# be available (e.g. 5 partitions).
>> +#
>> +# For the first round, the last device in the SCRATCH_DEV_POOL string
>> +# is taken as the target device for the replace operation, the first
>> +# device is the source device. For the second round it is the other way
>> +# round.
>> +#
>> +# THEREFORE MAKE SURE THAT BOTH DEVICES HAVE _EXACTLY_ THE SAME
>> +# SIZE, OTHERWISE THE TESTS FAIL!
> 
> I sure hope the script enforces that, and does _notrun if they
> differ?  I'll look.  If not, that's a problem.  If so, please
> change above to "OTHERWISE THE TEST WILL BE SKIPPED."
> 
> (coming back after reading it all: nothing enforces this - you
> need to do that, tests should be _notrun, not failed, due to
> incompatible configurations)

Thank you for the review! All your comments are addressed in the V2 of
the patch.

All tests except for one work populate the test filesystem with only
12MB in V2, thus spend less time. And to assure that the test is not
running the replace operation on an empty source disk, the number of
devices that are included in the filesystem is adapted and reduced to
the minimum number (1 for single/dup, 2 for RAID0/1, 4 for RAID10).

> 
>> +#
>> +# The target device for a replace operation always needs to be larger
>> +# or of equal size than the source device.
>> +#
>> +# If SCRATCH_DEV_POOL is set to "A B C D E" for example, the first
>> +# round creates a filesystem on "A B C D" and replaces A with E in the
>> +# first round, and E again with A in the second round. E and A need to
>> +# have the same size for the tests to succeed.
>> +#
>> +# To check the filesystems after replacing a device, a scrub run is
>> +# performed, a btrfsck run, and finally the filesystem is remounted.
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (C) 2013 STRATO.  All rights reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> +#
>> +#-----------------------------------------------------------------------
>> +#
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1
>> +noise_pid=0
>> +
>> +_cleanup()
>> +{
>> +	if [ $noise_pid -ne 0 ] && ps -p $noise_pid | grep -q $noise_pid; then
>> +		kill -TERM $noise_pid
>> +	fi
>> +	wait
>> +	rm -f $tmp.tmp
>> +}
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +_need_to_be_root
>> +_supported_fs btrfs
>> +_require_scratch
>> +_require_scratch_dev_pool
>> +
>> +rm -f $seqres.full
>> +rm -f $tmp.tmp
>> +
>> +echo "*** test btrfs replace"
>> +
>> +workout()
>> +{
>> +	mkfs_options=$1
>> +	num_devs4raid=$2
>> +	with_cancel=$3
>> +	quick=$4
>> +	local first_dev=`echo ${SCRATCH_DEV_POOL} | awk '{print $1}'`
>> +	local last_dev=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
>> +	local without_1stnlast_dev=`echo $SCRATCH_DEV_POOL | \
>> +		awk '{ORS=" "; for (i = 2; i < NF; i++) print $i}'`
>> +
>> +	if [ "`echo $SCRATCH_DEV_POOL | wc -w`" -lt `expr $num_devs4raid + 1` ]; then
>> +		echo "skip workout $1 $2 $3 $4" >> $seqres.full
>> +		echo "Too less devices in SCRATCH_DEV_POOL $SCRATCH_DEV_POOL" >> $seqres.full
> 
> "Too few devices" or "Not enough devices"
> 
> Would be nice to echo how many are needed too.
> 
> (although nobody will see this output, since unless there are other problems,
> the test will succeed anyway...)

done

> 
>> +		return 0
>> +	fi
>> +
>> +	# dup works only on a single disk
>> +	if echo $mkfs_options | grep -q dup; then
>> +		without_1stnlast_dev=""
>> +	fi
>> +
>> +	# _scratch_mkfs adds the 1st device again (which is $SCRATCH_DEV)
>> +	_scratch_mkfs $mkfs_options $without_1stnlast_dev >> $seqres.full 2>&1 || _fail "mkfs failed"
>> +	_scratch_mount
>> +
>> +	_populate_fs -r $SCRATCH_MNT/zero       -s 130  -f 1000 -d 0 -n 0
>> +	_populate_fs -r $SCRATCH_MNT/urandom -x -s 1300 -f 10   -d 0 -n 0
> 
> ok so one dir full of zeroed files, one full of random files.
> 
> what happens if the fs fills during this, is it a problem, or is it ok?
> 
> I think it will emit output that would cause the test to fail.  Can you check?

The V2 is using dd instead of _populate_fs for speed reasons, and
redirects the output to prevent errors in the ENOSPC case.

> 
> You could do i.e. _require_fs_space $SCRATCH_MNT <XXXX> after _scratch_mount
> to be sure there is sufficient space before proceeding.
> 
>> +	if [ "${quick}Q" = "quickQ" ]; then
>> +		dd if=/dev/urandom of=$SCRATCH_MNT/r bs=1M count=10 >> $seqres.full 2>&1 &
>> +		dd if=/dev/zero of=$SCRATCH_MNT/0 bs=1M count=250 >> $seqres.full 2>&1
>> +		wait
>> +	else
>> +		dd if=/dev/urandom of=$SCRATCH_MNT/r bs=1M count=100 >> $seqres.full 2>&1 &
>> +		dd if=/dev/zero of=$SCRATCH_MNT/0 bs=1M count=2500 >> $seqres.full 2>&1
>> +		wait
>> +	fi
> 
> so "quick" means do 1/10 of the IO vs. otherwise; 2.3G difference.
> 
> It'd be *nice* if we could scale everything down to speed up the test?

I hope the 3 minutes that it takes with V2 is not too much anymore? The
test tries to cover as much as possible.

> 
>> +	echo 3 > /proc/sys/vm/drop_caches; echo 3 > /proc/sys/vm/drop_caches
>> +	sync
>> +
>> +	# generate some (slow) background traffic in parallel to the
>> +	# replace operation. It is not a problem if cat fails early
>> +	# with ENOSPC.
>> +	cat /dev/urandom > $SCRATCH_MNT/noise 2> $seqres.full 2>&1 &
>> +	noise_pid=$!
>> +
>> +	if [ "${with_cancel}Q" = "cancelQ" ]; then
>> +		$BTRFS_UTIL_PROG replace start -f $first_dev $last_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
>> +		sleep 1
>> +		$BTRFS_UTIL_PROG replace cancel $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace cancel failed"
>> +
>> +		$BTRFS_UTIL_PROG replace status $SCRATCH_MNT > $tmp.tmp 2>&1
>> +		cat $tmp.tmp >> $seqres.full
>> +		egrep -q "canceled|finished" $tmp.tmp || _fail "btrfs replace status failed"
>> +	else
>> +		$BTRFS_UTIL_PROG replace start -Bf $first_dev $last_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
> 
> ok, -B means don't background.  (of course!) ;)  So we wait...

That's similar to the meaning of '-B' in the scrub command.

> 
>> +
>> +		$BTRFS_UTIL_PROG replace status $SCRATCH_MNT > $tmp.tmp 2>&1
>> +		cat $tmp.tmp >> $seqres.full
>> +		grep -q finished $tmp.tmp || _fail "btrfs replace status failed"
> 
> and make sure it finished. ok.
> 
>> +	fi
>> +
>> +	$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT > $tmp.tmp 2>&1
>> +	cat $tmp.tmp >> $seqres.full
>> +	grep -q finished $tmp.tmp || _fail "btrfs scrub failed"
>> +	grep -q "with 0 errors" $tmp.tmp || _fail "btrfs scrub failed"
> 
> Just curious, do you need to grep output to determine failure in all these cases?
> Does exit status not suffice?  (if not, seems like that should be fixed)

Right, the exit status of scrub suffices if started with -B option to
prevent the backgrounding. When scrub detects disk errors, the exit
status indicates it.

The exit status of 'btrfs replace start -B' is also indicating errors,
but since this is part of the thing to test, V2 is still evaluating the
output of 'btrfs replace status' in addition to checking the status code.

> 
>> +
>> +	if ps -p $noise_pid | grep -q $noise_pid; then
>> +		kill -TERM $noise_pid 2> /dev/null
>> +	fi
>> +	noise_pid=0
>> +	wait
>> +	umount $SCRATCH_MNT
>> +	if [ "${with_cancel}Q" = "cancelQ" ]; then
>> +		_check_btrfs_filesystem $first_dev
>> +		return 0
>> +	else
>> +		_check_btrfs_filesystem $last_dev
>> +	fi
> 
> Can you add a comment here?  I'm confused about why we do first vs last dev on the cmdline.

done

After running the replace procedure to replace $first_dev with
$last_dev, the script needs to run all the checks on the $last_dev since
the $first_dev is not a part of the filesystem anymore.

If the operation was canceled, it's still the $first_dev that needs to
be dealt with.

> 
>> +
>> +	# now one more time without the -f option. Instead of wasting
>> +	# time to populate the filesystem with data again, use the
>> +	# existing filesystem in the state as it is after the previous
>> +	# replace operation.
>> +	umount $SCRATCH_MNT > /dev/null 2>&1
> 
> Didn't you just unmount this already?  Prior to the fsck?

done

> 
>> +	_mount -t $FSTYP `_scratch_mount_options | sed "s&${SCRATCH_DEV}&${last_dev}&"`
> 
> oof, can you at least comment to say what the above line is doing?  That makes my brain hurt.

done (added a comment to explain the "why" which also makes clear "what"
is done).

> 
>> +	if [ $? -ne 0 ]; then
>> +		echo "mount failed"
>> +		exit 1
>> +	fi
>> +
>> +	cat /dev/urandom > $SCRATCH_MNT/noise2 2> $seqres.full 2>&1 &
>> +	noise_pid=$!
> 
> If the last noise generator filled the fs, this'll do nothing, right?
> Better to remove the existing noise file & restart the noise generator on the same filename?

done

> 
>> +	$BTRFS_UTIL_PROG replace start -B $last_dev $first_dev $SCRATCH_MNT >> $seqres.full 2>&1 || _fail "btrfs replace start failed"
>> +
>> +	$BTRFS_UTIL_PROG replace status $SCRATCH_MNT > $tmp.tmp 2>&1
>> +	cat $tmp.tmp >> $seqres.full
>> +	grep -q finished $tmp.tmp || _fail "btrfs replace status failed"
>> +
>> +	$BTRFS_UTIL_PROG scrub start -B $SCRATCH_MNT > $tmp.tmp 2>&1
>> +	cat $tmp.tmp >> $seqres.full
>> +	grep -q finished $tmp.tmp || _fail "btrfs scrub failed"
>> +	grep -q "with 0 errors" $tmp.tmp || _fail "btrfs scrub failed"
>> +
>> +	if ps -p $noise_pid | grep -q $noise_pid; then
>> +		kill -TERM $noise_pid 2> /dev/null
>> +	fi
>> +	noise_pid=0
>> +	wait
>> +	umount $SCRATCH_MNT
> 
> There's an awful lot of cut & paste here from the first run with -f; can you maybe make it functions?

done

> 
>> +	_check_btrfs_filesystem $first_dev
>> +}
>> +
>> +workout "-m single -d single" 1 no quick
>> +workout "-m single -d single -M" 1 no quick
>> +workout "-m dup -d single" 1 no quick
>> +workout "-m dup -d single" 1 cancel quick
>> +workout "-m dup -d dup -M" 1 no quick
>> +workout "-m raid0 -d raid0" 2 no quick
>> +workout "-m raid1 -d raid1" 2 no thorough
>> +#workout "-m raid5 -d raid5" 2 no quick
>> +#workout "-m raid6 -d raid6" 3 no quick
> 
> Why commented out?

The replace operation depends on scrub and makes use of the scrub code.
And scrub does not yet support RAID5/6. Therefore 'btrfs replace start'
fails with EINVAL on RAID5/6 filesystems.

> 
>> +workout "-m raid10 -d raid10" 4 no quick
>> +
>> +echo "*** done"
>> +status=0
>> +exit
>> diff --git a/tests/btrfs/317.out b/tests/btrfs/317.out
>> new file mode 100644
>> index 0000000..4bda623
>> --- /dev/null
>> +++ b/tests/btrfs/317.out
>> @@ -0,0 +1,3 @@
>> +QA output created by 317
>> +*** test btrfs replace
>> +*** done
>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>> index bc6c256..1b64321 100644
>> --- a/tests/btrfs/group
>> +++ b/tests/btrfs/group
>> @@ -9,3 +9,4 @@
>>  276 auto rw metadata
>>  284 auto
>>  307 auto quick
>> +317 auto
>>
> 

Thanks again!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
