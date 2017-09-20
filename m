Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56964 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750872AbdITDkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 23:40:12 -0400
From: Richard Wareing <rwareing@fb.com>
Subject: Re: [PATCH] xfs: Add test for CVE-2017-14340
Date: Wed, 20 Sep 2017 03:40:06 +0000
Message-ID: <BA0F6FA4-4C58-4263-BF66-32C20DCA090E@fb.com>
References: <20170920003054.4171675-1-rwareing@fb.com>
 <20170920004125.GD7112@magnolia>
In-Reply-To: <20170920004125.GD7112@magnolia>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <06110C3054A18D4F99D396FC78C164C1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>

Darrick J. Wong <darrick.wong@oracle.com> wrote:

> On Tue, Sep 19, 2017 at 05:30:54PM -0700, Richard Wareing wrote:
>> Verify kernel doesn't panic when user attempts to set realtime flags
>> on non-realtime FS, using kernel compiled with CONFIG_XFS_RT.  Unpatched
>> kernels will panic during this test.  Kernels not compiled with
>> CONFIG_XFS_RT should pass test.
>>
>> This bug was fixed via commit b31ff3cdf540110da4572e3e29bd172087af65cc
>
> Oooh, a commit id, nice! :)
>
>> on the main kernel tree.
>>
>> Signed-off-by: Richard Wareing <rwareing@fb.com>
>> ---
>>  tests/xfs/431     | 86 ++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++
>>  tests/xfs/431.out |  3 ++
>>  tests/xfs/group   |  1 +
>>  3 files changed, 90 insertions(+)
>>  create mode 100755 tests/xfs/431
>>  create mode 100644 tests/xfs/431.out
>>
>> diff --git a/tests/xfs/431 b/tests/xfs/431
>> new file mode 100755
>> index 0000000..f928abc
>> --- /dev/null
>> +++ b/tests/xfs/431
>> @@ -0,0 +1,86 @@
>> +#! /bin/bash
>> +# FS QA Test 431
>> +#
>> +# Verify kernel doesn't panic when user attempts to set realtime flags
>> +# on non-realtime FS, using kernel compiled with CONFIG_XFS_RT.  =20
>> Unpatched
>> +# kernels will panic during this test.  Kernels not compiled with
>> +# CONFIG_XFS_RT should pass test.
>> +#
>> +#----------------------------------------------------------------------=
-
>> +# Copyright (c) 2017 YOUR NAME HERE.  All Rights Reserved.
>
> Mr. HERE, please update this line! :)
>

Fixed in v2.

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
>> +#----------------------------------------------------------------------=
-
>> +#
>> +
>> +seq=3D`basename $0`
>> +seqres=3D$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=3D`pwd`
>> +tmp=3D/tmp/$$
>> +status=3D1	# failure is the default!
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
>> +_require_test
>> +
>
> Shouldn't we unset USE_EXTERNAL/SCRATCH_RTDEV here since the bug only
> affects non-rt xfses?
>

I tried playing around with this, but wasn't able to get it to
work.  The best I think to do is create a "_require_no_realtime"
and skip the test if it's being run under a realtime test run.


>> +_scratch_mkfs >/dev/null 2>&1
>> +_scratch_mount
>> +
>> +# Set realtime inherit flag on scratch mount, suppress output
>> +# as this may simply error out on future kernels, we will check
>> +# exit code instead.
>> +$XFS_IO_PROG -c 'chattr +t' $SCRATCH_MNT &> /dev/null
>> +chattr_ret=3D$?
>> +
>> +# Erroring out here is fine, this would be desired behavior for
>> +# FSes without realtime devices present.
>> +if (( chattr_ret =3D=3D 0)); then
>> +  # Attempt to write/fsync data to file
>> +  $XFS_IO_PROG -fc 'pwrite 0 1m' -c fsync $SCRATCH_MNT/testfile |
>> +    tee -a $seqres.full | common_line_filter | _filter_xfs_io
>> +
>> +  # Remove the rt inherit flag after we are done or xfs_repair
>> +  # will fail.
>> +  $XFS_IO_PROG -c 'chattr -t' $SCRATCH_MNT | tee -a $seqres.full 2>&1
>> +fi
>> +
>> +
>> +rm -f $SCRATCH_MNT/testfile
>> +
>> +# success, all done
>> +status=3D0
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
>> index 0a449b9..3f97f02 100644
>> --- a/tests/xfs/group
>> +++ b/tests/xfs/group
>> @@ -427,3 +427,4 @@
>>  428 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>>  429 dangerous_fuzzers dangerous_scrub dangerous_repair
>>  430 dangerous_fuzzers dangerous_scrub dangerous_online_repair
>> +431 quick
>
> This ought to have 'dangerous' too, so that everyone knows that it can
> crash an unpatched kernel.
>
> (After stable/distros have had a few weeks to fix this you could add it
> to the 'auto' group as well so that everyone will run it.)
>

Fixed in v3.

> --D
>
>> --=20
>> 2.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


