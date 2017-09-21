Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49152 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751793AbdIUVCm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Sep 2017 17:02:42 -0400
Content-Type: text/plain; charset="us-ascii"; delsp=yes; format=flowed
MIME-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH v4] xfs: Add test for CVE-2017-14340
From: Richard Wareing <rwareing@fb.com>
In-Reply-To: <20170921195303.GA5728@magnolia>
Date: Thu, 21 Sep 2017 14:02:30 -0700
Content-Transfer-Encoding: 7bit
Message-ID: <70DE4C3B-089F-4094-AF3F-7C6328F28E41@fb.com>
References: <20170921193458.694078-1-rwareing@fb.com>
 <20170921195303.GA5728@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Thu, Sep 21, 2017 at 12:34:58PM -0700, Richard Wareing wrote:
>> Verify kernel doesn't panic when user attempts to set realtime flags
>> on non-realtime FS, using kernel compiled with CONFIG_XFS_RT.  Unpatched
>> kernels will panic during this test.  Kernels not compiled with
>> CONFIG_XFS_RT should pass test.
>>
>> This bug was fixed via commit b31ff3cdf540110da4572e3e29bd172087af65cc
>> on the main kernel tree.
>>
>> Signed-off-by: Richard Wareing <rwareing@fb.com>
>> ---
>> Changes since v3:
>> * Tabs not spaces
>> * Test added to auto group
>> * _filter_xfs_io filter only
>> * Removed _require_test
>>
>> Changes since v2:
>> * Added to dangerous group
>>
>> Changes since v1:
>> * Corrected copyright text
>>
>> tests/xfs/431     | 83  
>> +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/431.out |  3 ++
>>  tests/xfs/group   |  1 +
>>  3 files changed, 87 insertions(+)
>>  create mode 100755 tests/xfs/431
>>  create mode 100644 tests/xfs/431.out
>>
>> diff --git a/tests/xfs/431 b/tests/xfs/431
>> new file mode 100755
>> index 0000000..1d8df1c
>> --- /dev/null
>> +++ b/tests/xfs/431
>> @@ -0,0 +1,83 @@
>> +#! /bin/bash
>> +# FS QA Test 431
>> +#
>> +# Verify kernel doesn't panic when user attempts to set realtime flags
>> +# on non-realtime FS, using kernel compiled with CONFIG_XFS_RT.   
>> Unpatched
>> +# kernels will panic during this test.  Kernels not compiled with
>> +# CONFIG_XFS_RT should pass test.
>> +#
>> +# See CVE-2017-14340 for more information.
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2017 Facebook, Inc.  All Rights Reserved.
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
>> +#-----------------------------------------------------------------------
>> +#
>> +
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +# Modify as appropriate.
>> +_supported_fs xfs
>> +_supported_os Linux
>> +_require_xfs_io_command "chattr"
>> +_require_xfs_io_command "fsync"
>> +_require_xfs_io_command "pwrite"
>> +_require_scratch
>> +
>> +_scratch_mkfs >/dev/null 2>&1
>> +_scratch_mount
>> +
>> +# Set realtime inherit flag on scratch mount, suppress output
>> +# as this may simply error out on future kernels, we will check
>> +# exit code instead.
>> +$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT &> /dev/null
>> +
>> +# Erroring out here is fine, this would be desired behavior for
>> +# FSes without realtime devices present.
>> +if [ $? -eq 0 ]; then
>
> FWIW xfs_io returns 0 even if the chattr fails, e.g.:
>
> $ mkfifo foo
> $ xfs_io -c 'chattr +t' foo
> xfs_io: cannot get flags on foo: Inappropriate ioctl for device
> $ echo $?
> 0
>
> If it's critical for this test to ensure that +t is set, then you'll
> have to find another way to detect that the +t succeeded.
>
> (Or I'm misunderstanding something.)
>
> --D
>

It's not super critical, but for correctness sake, I'll do a call to
lsattr to verify the flag was set then.

We should also consider fixing xfs_io to have consistent exit code
behavior; unless there's some legit reason to exit w/ code 0.

Richard



>> +	# Attempt to write/fsync data to file
>> +	$XFS_IO_PROG -fc 'pwrite 0 1m' -c fsync $SCRATCH_MNT/testfile |
>> +		tee -a $seqres.full | _filter_xfs_io
>> +
>> +	# Remove the rt inherit flag after we are done or xfs_repair
>> +	# will fail.
>> +	$XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT | tee -a $seqres.full 2>&1
>> +fi
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/xfs/431.out b/tests/xfs/431.out
>> new file mode 100644
>> index 0000000..8c14f11
>> --- /dev/null
>> +++ b/tests/xfs/431.out
>> @@ -0,0 +1,3 @@
>> +QA output created by 431
>> +wrote 1048576/1048576 bytes at offset 0
>> +XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>> diff --git a/tests/xfs/group b/tests/xfs/group
>> index 0a449b9..1765559 100644
>> --- a/tests/xfs/group
>> +++ b/tests/xfs/group
>> @@ -427,3 +427,4 @@
>>  428 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>>  429 dangerous_fuzzers dangerous_scrub dangerous_repair
>>  430 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>> +431 auto quick dangerous
>> -- 
>> 2.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


