Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 06DD729DF8
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 19:54:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D2B99304051
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 17:54:27 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id hgEu03oCoABUgExj for
	<xfs@oss.sgi.com>; Sun, 12 Jan 2014 17:54:25 -0800 (PST)
Message-ID: <52D34784.1050402@cn.fujitsu.com>
Date: Mon, 13 Jan 2014 09:55:16 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Add pairing mount options test
References: <1389162648-19309-1-git-send-email-quwenruo@cn.fujitsu.com>
	<52D01CA9.4040107@sandeen.net> <52D33F92.2000609@cn.fujitsu.com>
	<52D342F0.5020402@sandeen.net>
In-Reply-To: <52D342F0.5020402@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs <linux-btrfs@vger.kernel.org>

On Sun, 12 Jan 2014 19:35:44 -0600, Eric Sandeen wrote:
> On 1/12/14, 7:21 PM, Qu Wenruo wrote:
>> On fri, 10 Jan 2014 10:15:37 -0600, Eric Sandeen wrote:
>>> On 1/8/14, 12:30 AM, Qu Wenruo wrote:
>>>> Test remount btrfs with different pairing options like barrier and no barrier.
>>> It seems that while this tests that the remount succeeds, and that
>>> the option string is present in /proc/mounts, it does not test that
>>> the mount option is actually in effect.
>> Yes, this is what the new test case is intended to do.
>> This case was just a test case tests the mount options themselves
>> to ensure all the pairing mount options works during remounting,
>> since most pairing options are missing before.
>>> I suppose for many of these options that would be hard to test; for
>>> i.e. acl though it should be trivial.
>>>
>>> What do you think, is this enough to ensure that remount handling
>>> is working as expected for all of these options?
>> In my opinion, this test should just focuses on the remount handling and
>> the pairing options.
>> For the detailed function should be examineed in other test cases.
> Except those won't test that a remount with those options actually *worked*;
> in fact they don't do remount at all.
>
> In other words, all this does is test that an option flag was set or unset in
> the superblock, but it doesn't really test whether the option has been
> properly set up (or torn down) as a result.
>
> I won't say no to this, but it seems to be of somewhat limited use.
>
> -Eric
It is true that this test case just tests the flags.
But sometimes it is unsafe to just trigger the flags.
(All right, just the inode_cache flags which is not in the test case)

Though the case is mainly for the flags/mount options examining, but it 
may be
able to find some flag triggering defeats if run for enough long time.

Anyway, thanks for your commenting.

Thanks
Qu
>> Also, most of the pairing options are instructive,
>> and some may not be in effect before next transaction (for the incomming noinode_cache options),
>> so I think is OK for just examining the options and remount handling for now.
>>
>> Thanks
>> Qu
>>> Thanks,
>>> -Eric
>>>
>>>> Mainly used to test the following comming btrfs kernel commit:(Not in
>>>> mainline yet)
>>>> 8dd6d2c btrfs: Add treelog mount option.
>>>> f1eccd3 btrfs: Add datasum mount option.
>>>> aad3269 btrfs: Add datacow mount option.
>>>> 22bab74 btrfs: Add acl mount option.
>>>> 170e45e btrfs: Add noflushoncommit mount option.
>>>> ce41bc9 btrfs: Add noenospc_debug mount option.
>>>> f3c639b btrfs: Add nodiscard mount option.
>>>> 962cbee btrfs: Add noautodefrag mount option.
>>>> 0b4fa2a btrfs: Add "barrier" option to support "-o remount,barrier"
>>>>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> Cc: Eric Sandeen <sandeen@redhat.com>
>>>> ---
>>>>    tests/btrfs/025     | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>    tests/btrfs/025.out |   2 +
>>>>    tests/btrfs/group   |   1 +
>>>>    3 files changed, 128 insertions(+)
>>>>    create mode 100755 tests/btrfs/025
>>>>    create mode 100644 tests/btrfs/025.out
>>>>
>>>> diff --git a/tests/btrfs/025 b/tests/btrfs/025
>>>> new file mode 100755
>>>> index 0000000..014da19
>>>> --- /dev/null
>>>> +++ b/tests/btrfs/025
>>>> @@ -0,0 +1,125 @@
>>>> +#!/bin/bash
>>>> +# Btrfs QA test No. 025
>>>> +#
>>>> +# Check for paired btrfs mount options
>>>> +#
>>>> +# Regression test for the following btrfs commits
>>>> +# 8dd6d2c btrfs: Add treelog mount option.
>>>> +# f1eccd3 btrfs: Add datasum mount option.
>>>> +# aad3269 btrfs: Add datacow mount option.
>>>> +# 22bab74 btrfs: Add acl mount option.
>>>> +# 170e45e btrfs: Add noflushoncommit mount option.
>>>> +# ce41bc9 btrfs: Add noenospc_debug mount option.
>>>> +# f3c639b btrfs: Add nodiscard mount option.
>>>> +# 962cbee btrfs: Add noautodefrag mount option.
>>>> +# 0b4fa2a btrfs: Add "barrier" option to support "-o remount,barrier"
>>>> +#
>>>> +#-----------------------------------------------------------------------
>>>> +# Copyright (c) 2014 Fujitsu, Inc.  All Rights Reserved.
>>>> +#
>>>> +# This program is free software; you can redistribute it and/or
>>>> +# modify it under the terms of the GNU General Public License as
>>>> +# published by the Free Software Foundation.
>>>> +#
>>>> +# This program is distributed in the hope that it would be useful,
>>>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> +# GNU General Public License for more details.
>>>> +#
>>>> +# You should have received a copy of the GNU General Public License
>>>> +# along with this program; if not, write the Free Software Foundation,
>>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>>> +#-----------------------------------------------------------------------
>>>> +#
>>>> +
>>>> +seq=`basename $0`
>>>> +seqres=$RESULT_DIR/$seq
>>>> +echo "QA output created by $seq"
>>>> +
>>>> +status=0    # success is the default!
>>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>>> +
>>>> +PAIRING_OPTIONS="autodefrag noautodefrag discard nodiscard enospc_debug noenospc_debug flushoncommit noflushoncommit noacl acl nobarrier barrier nodatacow datacow nodatasum datasum notreelog treelog space_cache nospace_cache ssd nossd"
>>>> +
>>>> +# options that does not show in mount options
>>>> +HIDDEN_OPTIONS="noautodefrag nodiscard noenospc_debug noflushoncommit acl barrier datacow datasum treelog nossd"
>>>> +_cleanup()
>>>> +{
>>>> +    rm $tmp.running &> /dev/null
>>>> +    wait
>>>> +    cd /
>>>> +    _scratch_unmount &> /dev/null
>>>> +}
>>>> +
>>>> +# check the mount option
>>>> +check_mount_opt()
>>>> +{
>>>> +    mount_point=$1
>>>> +    expected_opt=$2
>>>> +
>>>> +    mount_opt=`cat /proc/mounts | grep $mount_point | cut -d\  -f4`
>>>> +    if grep $2 $mount_opt; then
>>>> +        _fail "test failed: expected $expected_opt option not shown in mount options"
>>>> +    fi
>>>> +}
>>>> +
>>>> +# background noise
>>>> +start_bgnoise()
>>>> +{
>>>> +    touch $tmp.running
>>>> +    while [ -f "$tmp.running" ]; do
>>>> +        run_check $FSSTRESS_PROG -d $SCRATCH_MNT -n 500 -p 4
>>>> +        if [ $? != 0 ]; then
>>>> +            _fail "Some error happened executing fsstress when remounting"
>>>> +        fi
>>>> +    done &
>>>> +    noise_pid=`jobs -p %1`
>>>> +    echo $noise_pid > $tmp.running
>>>> +}
>>>> +
>>>> +stop_bgnoise()
>>>> +{
>>>> +    pid=`cat $tmp.running`
>>>> +    rm $tmp.running
>>>> +    wait $pid
>>>> +}
>>>> +
>>>> +# get standard environment, filters
>>>> +. ./common/rc
>>>> +. ./common/filter
>>>> +
>>>> +# real QA test starts here
>>>> +_supported_fs btrfs
>>>> +_supported_os Linux
>>>> +
>>>> +_need_to_be_root
>>>> +_require_scratch
>>>> +
>>>> +# no need to use the original mount options
>>>> +unset MOUNT_OPTIONS
>>>> +
>>>> +_scratch_mkfs > /dev/null 2>&1
>>>> +_scratch_mount
>>>> +
>>>> +start_bgnoise
>>>> +for remount_opt in $PAIRING_OPTIONS; do
>>>> +    # Sleep for a while ensuring fsstress to do enough stress
>>>> +    sleep 1
>>>> +    _remount $SCRATCH_MNT $remount_opt
>>>> +    if [ $? != 0 ]; then
>>>> +        stop_bgnoise
>>>> +        _fail "test failed: $remount_opt not supported"
>>>> +    fi
>>>> +    if [[ ! $HIDDEN_OPTIONS =~ $remount ]]; then
>>>> +        check_mount_opt $SCRATCH_MNT $remount_opt
>>>> +
>>>> +        # Special check for nodatacow
>>>> +        if [ $remount_opt == "nodatacow" ]; then
>>>> +            check_mount_opt $SCRATCH_MNT nodatasum
>>>> +        fi
>>>> +    fi
>>>> +done
>>>> +stop_bgnoise
>>>> +_scratch_unmount || _fail "umount failed"
>>>> +echo "Silence is golden"
>>>> +status=0; exit
>>>> diff --git a/tests/btrfs/025.out b/tests/btrfs/025.out
>>>> new file mode 100644
>>>> index 0000000..3d70951
>>>> --- /dev/null
>>>> +++ b/tests/btrfs/025.out
>>>> @@ -0,0 +1,2 @@
>>>> +QA output created by 025
>>>> +Silence is golden
>>>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>>>> index 87e7bca..1a4dad8 100644
>>>> --- a/tests/btrfs/group
>>>> +++ b/tests/btrfs/group
>>>> @@ -27,3 +27,4 @@
>>>>    022 auto
>>>>    023 auto
>>>>    024 auto quick
>>>> +025 auto quick
>>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
