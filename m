Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53279 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751706AbdIUTtJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 15:49:09 -0400
Content-Type: text/plain; charset="us-ascii"; delsp=yes; format=flowed
MIME-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] xfs: Add test for CVE-2017-14340
From: Richard Wareing <rwareing@fb.com>
In-Reply-To: <20170921055656.GW8034@eguan.usersys.redhat.com>
Date: Thu, 21 Sep 2017 12:48:59 -0700
Content-Transfer-Encoding: 7bit
Message-ID: <E73EB1AF-072A-4EF7-8E0C-5ED4724A01E0@fb.com>
References: <20170920003054.4171675-1-rwareing@fb.com>
 <20170920004125.GD7112@magnolia>
 <BA0F6FA4-4C58-4263-BF66-32C20DCA090E@fb.com>
 <20170921055656.GW8034@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Eryu Guan <eguan@redhat.com> wrote:

> On Wed, Sep 20, 2017 at 03:40:06AM +0000, Richard Wareing wrote:
>> Darrick J. Wong <darrick.wong@oracle.com> wrote:
>>
>>> On Tue, Sep 19, 2017 at 05:30:54PM -0700, Richard Wareing wrote:
>>>> Verify kernel doesn't panic when user attempts to set realtime flags
>>>> on non-realtime FS, using kernel compiled with CONFIG_XFS_RT.  Unpatched
>>>> kernels will panic during this test.  Kernels not compiled with
>>>> CONFIG_XFS_RT should pass test.
>>>>
>>>> This bug was fixed via commit b31ff3cdf540110da4572e3e29bd172087af65cc
>>>
>>> Oooh, a commit id, nice! :)
>>>
>>>> on the main kernel tree.
>>>>
>>>> Signed-off-by: Richard Wareing <rwareing@fb.com>
>>>> ---
>>>>  tests/xfs/431     | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  tests/xfs/431.out |  3 ++
>>>>  tests/xfs/group   |  1 +
>>>>  3 files changed, 90 insertions(+)
>>>>  create mode 100755 tests/xfs/431
>>>>  create mode 100644 tests/xfs/431.out
>>>>
>>>> diff --git a/tests/xfs/431 b/tests/xfs/431
>>>> new file mode 100755
>>>> index 0000000..f928abc
>>>> --- /dev/null
>>>> +++ b/tests/xfs/431
>>>> @@ -0,0 +1,86 @@
>>>> +#! /bin/bash
>>>> +# FS QA Test 431
>>>> +#
>>>> +# Verify kernel doesn't panic when user attempts to set realtime flags
>>>> +# on non-realtime FS, using kernel compiled with CONFIG_XFS_RT.
>>>> Unpatched
>>>> +# kernels will panic during this test.  Kernels not compiled with
>>>> +# CONFIG_XFS_RT should pass test.
>>>> +#
>>>> +#-----------------------------------------------------------------------
>>>> +# Copyright (c) 2017 YOUR NAME HERE.  All Rights Reserved.
>>>
>>> Mr. HERE, please update this line! :)
>>
>> Fixed in v2.
>>
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
>>>> +here=`pwd`
>>>> +tmp=/tmp/$$
>>>> +status=1	# failure is the default!
>>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>>> +
>>>> +_cleanup()
>>>> +{
>>>> +	cd /
>>>> +	rm -f $tmp.*
>>>> +}
>>>> +
>>>> +# get standard environment, filters and checks
>>>> +. ./common/rc
>>>> +. ./common/filter
>>>> +
>>>> +# remove previous $seqres.full before test
>>>> +rm -f $seqres.full
>>>> +
>>>> +# real QA test starts here
>>>> +
>>>> +# Modify as appropriate.
>>>> +_supported_fs xfs
>>>> +_supported_os Linux
>>>> +_require_xfs_io_command "chattr"
>>>> +_require_xfs_io_command "fsync"
>>>> +_require_xfs_io_command "pwrite"
>>>> +_require_scratch
>>>> +_require_test
>>>> +
>>>
>>> Shouldn't we unset USE_EXTERNAL/SCRATCH_RTDEV here since the bug only
>>> affects non-rt xfses?
>>
>> I tried playing around with this, but wasn't able to get it to
>> work.  The best I think to do is create a "_require_no_realtime"
>> and skip the test if it's being run under a realtime test run.
>
> Hmm, I don't think we need to exclude test with rtdev, it's true that
> the bug only affects non-rt XFS but there's no harm to do such a
> 'sanity' test with rtdev present.
>

Sounds fine to me, there's no reason this should ever fail on a FS
with a realtime device.  If it did, there's something horribly wrong.

>>>> +_scratch_mkfs >/dev/null 2>&1
>>>> +_scratch_mount
>>>> +
>>>> +# Set realtime inherit flag on scratch mount, suppress output
>>>> +# as this may simply error out on future kernels, we will check
>>>> +# exit code instead.
>>>> +$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT &> /dev/null
>>>> +chattr_ret=$?
>
> It seems that xfs_io always returns 0 even the command fails, e.g.
>
> [root@bootp-73-5-205 xfstests]# xfs_io -c "pwrite 0 4k" /
> pwrite: Bad file descriptor
> [root@bootp-73-5-205 xfstests]# echo $?
> 0
>
> So we should not depend on xfs_io's return value. And I think doing the
> 'pwrite' & 'fsync' test unconditionally should be fine, e.g.
>
> $XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT >>$seqres.full 2>&1
> $XFS_IO_PROG -fc 'pwrite 0 1m' -c fsync ..
> $XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT...
>


xfs_io in other cases exit with non-zero (e.g. ENOENT errors), I've got
another patch will will eventually deny setting the inherit flag on an
FS without an rtdev configured, so I'd rather handle this case now then
fix it later (or worse, forget to fix it).

> I tested on 4.14-rc1 kernels with and without CONFIG_XFS_RT, and with
> and without rtdev present when CONFIG_XFS_RT=y, all tests passed.
>

This kernel passes as it has commit
b31ff3cdf540110da4572e3e29bd172087af65cc :).  Revert this commit and
try again to see things explode.  i.e. The fact it passes, is
indication the kernel is fixed.

>>>> +
>>>> +# Erroring out here is fine, this would be desired behavior for
>>>> +# FSes without realtime devices present.
>>>> +if (( chattr_ret == 0)); then
>>>> +  # Attempt to write/fsync data to file
>>>> +  $XFS_IO_PROG -fc 'pwrite 0 1m' -c fsync $SCRATCH_MNT/testfile |
>>>> +    tee -a $seqres.full | common_line_filter | _filter_xfs_io
>
> (common_line_filter | _filter_xfs_io) == _filter_xfs_io_unique
>
> But I think a bare _filter_xfs_io should just work, there's no common
> lines to be filtered anyway.
>

Fixed.

>>>> +
>>>> +  # Remove the rt inherit flag after we are done or xfs_repair
>>>> +  # will fail.
>>>> +  $XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT | tee -a $seqres.full 2>&1
>
> And please use real tab as indention :)
>

Oops!  We use spaces around here so I always have a hard time keeping
it straight depending on the repo I'm in.  I'll fix this.

>>>> +fi
>>>> +
>>>> +
>>>> +rm -f $SCRATCH_MNT/testfile
>>>> +
>>>> +# success, all done
>>>> +status=0
>>>> +exit
>>>> diff --git a/tests/xfs/431.out b/tests/xfs/431.out
>>>> new file mode 100644
>>>> index 0000000..8c14f11
>>>> --- /dev/null
>>>> +++ b/tests/xfs/431.out
>>>> @@ -0,0 +1,3 @@
>>>> +QA output created by 431
>>>> +wrote 1048576/1048576 bytes at offset 0
>>>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>>>> diff --git a/tests/xfs/group b/tests/xfs/group
>>>> index 0a449b9..3f97f02 100644
>>>> --- a/tests/xfs/group
>>>> +++ b/tests/xfs/group
>>>> @@ -427,3 +427,4 @@
>>>>  428 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>>>>  429 dangerous_fuzzers dangerous_scrub dangerous_repair
>>>>  430 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>>>> +431 quick
>>>
>>> This ought to have 'dangerous' too, so that everyone knows that it can
>>> crash an unpatched kernel.
>>>
>>> (After stable/distros have had a few weeks to fix this you could add it
>>> to the 'auto' group as well so that everyone will run it.)
>
> 'quick' is just a subset of 'auto', all 'quick' tests should be in
> 'auto' group too, the only difference is 'quick' is quick :) usually run
> time is less than 30s. If you want to exclude tests in 'dangerous' group
> you can run check with '-x dangerous' option.
>

Fixing.

> Thanks,
> Eryu
>
>> Fixed in v3.
>>
>>> --D
>>>
>>>> -- 
>>>> 2.9.5
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


