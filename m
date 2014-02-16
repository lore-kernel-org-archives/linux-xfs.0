Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 257B37F57
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:43:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9640304039
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 15:43:20 -0800 (PST)
Received: from mail-bk0-f51.google.com (mail-bk0-f51.google.com
	[209.85.214.51]) by cuda.sgi.com with ESMTP id TM7t0X22VbAmuL11
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 16 Feb 2014 15:43:19 -0800 (PST)
Received: by mail-bk0-f51.google.com with SMTP id w10so3907415bkz.24
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 15:43:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140216230851.GX13647@dastard>
References: <1392408522-764-1-git-send-email-fdmanana@gmail.com>
	<1392478573-4513-1-git-send-email-fdmanana@gmail.com>
	<20140216230851.GX13647@dastard>
Date: Sun, 16 Feb 2014 23:43:17 +0000
Message-ID: <CAL3q7H46_AHDtACuZunRJgSymejgr73NVZ-TWNuBuD6z3j9KXg@mail.gmail.com>
Subject: Re: [PATCH v2] xfstests: add regression test for btrfs incremental
	send
From: Filipe David Manana <fdmanana@gmail.com>
Reply-To: fdmanana@gmail.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Sun, Feb 16, 2014 at 11:08 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Feb 15, 2014 at 03:36:13PM +0000, Filipe David Borba Manana wrote:
>> Test for a btrfs incremental send issue where we end up sending a
>> wrong section of data from a file extent if the corresponding file
>> extent is compressed and the respective file extent item has a non
>> zero data offset.
>>
>> Fixed by the following linux kernel btrfs patch:
>>
>>    Btrfs: use right clone root offset for compressed extents
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> ---
>>
>> V2: Made the test more reliable. Now it doesn't depend anymore of btrfs'
>>     hole punch implementation leaving hole file extent items when we punch
>>     beyond the file's current size.
>>
>>  tests/btrfs/040     |  115 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/btrfs/040.out |    1 +
>>  tests/btrfs/group   |    1 +
>>  3 files changed, 117 insertions(+)
>>  create mode 100755 tests/btrfs/040
>>  create mode 100644 tests/btrfs/040.out
>>
>> diff --git a/tests/btrfs/040 b/tests/btrfs/040
>> new file mode 100755
>> index 0000000..d6b37bf
>> --- /dev/null
>> +++ b/tests/btrfs/040
>> @@ -0,0 +1,115 @@
>> +#! /bin/bash
>> +# FS QA Test No. btrfs/040
>> +#
>> +# Test for a btrfs incremental send issue where we end up sending a
>> +# wrong section of data from a file extent if the corresponding file
>> +# extent is compressed and the respective file extent item has a non
>> +# zero data offset.
>> +#
>> +# Fixed by the following linux kernel btrfs patch:
>> +#
>> +#   Btrfs: use right clone root offset for compressed extents
>> +#
>> +#-----------------------------------------------------------------------
>> +# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
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
>> +tmp=`mktemp -d`
>> +status=1     # failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +    rm -fr $tmp
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# real QA test starts here
>> +_supported_fs btrfs
>> +_supported_os Linux
>> +_require_scratch
>> +_need_to_be_root
>> +
>> +FSSUM_PROG=$here/src/fssum
>> +[ -x $FSSUM_PROG ] || _notrun "fssum not built"
>> +
>> +rm -f $seqres.full
>> +
>> +_scratch_mkfs >/dev/null 2>&1
>> +_scratch_mount "-o compress-force=lzo"
>> +
>> +run_check $XFS_IO_PROG -f -c "truncate 118811" $SCRATCH_MNT/foo
>> +run_check $XFS_IO_PROG -c "pwrite -S 0x0d -b 39987 92267 39987" \
>> +     $SCRATCH_MNT/foo
>
> Ugh. filter the output, don't use run_check.
>
> $XFS_IO_PROG -f -c "truncate 118811" $SCRATCH_MNT/foo
> $XFS_IO_PROG -c "pwrite -S 0x0d -b 39987 92267 39987" \
>         $SCRATCH_MNT/foo | _filter_xfs_io
>
> If something fails, we still want the test to continue running, even
> if all it does is exercise error handling paths. run_check simply
> terminates the test at the first failure.

What's the point of continuing? The test will fail anyway, all of the
xfs_io calls are necessary to trigger the bug.

>
>> +run_check $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
>> +     $SCRATCH_MNT/mysnap1
>> +
>> +run_check $XFS_IO_PROG -c "pwrite -S 0x3e -b 80000 200000 80000" \
>> +     $SCRATCH_MNT/foo
>> +run_check $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
>
> Why a special btrfs sync here? Why isn't "sync" sufficient, or even
> a synchronous write or write plus fsync like:
>
> $XFS_IO_PROG -c "pwrite -S 0x3e -b 80000 200000 80000" -c "fsync" \
>         $SCRATCH_MNT/foo | _filter_xfs_io
>
> Tests need to be documented the same way code is documented....
>
>> +run_check $XFS_IO_PROG -c "pwrite -S 0xdc -b 10000 250000 10000" \
>> +     $SCRATCH_MNT/foo
>> +run_check $XFS_IO_PROG -c "pwrite -S 0xff -b 10000 300000 10000" \
>> +     $SCRATCH_MNT/foo
>
> I'm getting to the point where I'm starting to consider "run_check"
> as being harmful....

Ok...

>
> I know you are trying to work around the fact that the btrfs
> progs commands have inconsistent output and so are difficult to
> match. However, given that this is leading to bad habits like using
> run_check for everything.
>
> I'd suggest that we need a set of $BTRFS_UTIL_PROG specific handlers
> to deal with these differences rather than continuing to pollute the
> tests with run_check. e.g.
>
> _run_btrfs_util_prog()
> {
>         run_check $BTRFS_UTIL_PROG $*
> }
>
> would be a good start because it gets that run_check pattern out of
> the main test scripts and hence out of the heads of test writers.

Well, will get rid of those run_check calls, but that will imply
adding some | _filter_scratch in many places. So shortening lines is
not a great argument :)

thanks

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
