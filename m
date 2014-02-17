Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB0DA7F72
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 19:40:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26997AC06B
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:40:08 -0800 (PST)
Received: from mail-bk0-f50.google.com (mail-bk0-f50.google.com
	[209.85.214.50]) by cuda.sgi.com with ESMTP id YZummPUFcRoEX4jU
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:40:05 -0800 (PST)
Received: by mail-bk0-f50.google.com with SMTP id d7so741543bkh.37
	for <xfs@oss.sgi.com>; Sun, 16 Feb 2014 17:40:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140217011714.GZ13997@dastard>
References: <1392408522-764-1-git-send-email-fdmanana@gmail.com>
	<1392478573-4513-1-git-send-email-fdmanana@gmail.com>
	<20140216230851.GX13647@dastard>
	<CAL3q7H46_AHDtACuZunRJgSymejgr73NVZ-TWNuBuD6z3j9KXg@mail.gmail.com>
	<20140217011714.GZ13997@dastard>
Date: Mon, 17 Feb 2014 01:40:04 +0000
Message-ID: <CAL3q7H7aJcyV6pDwCmCYhHdQBQvQu0Asd6J3u1_nH8B3FuY_BA@mail.gmail.com>
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
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Feb 17, 2014 at 1:17 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Feb 16, 2014 at 11:43:17PM +0000, Filipe David Manana wrote:
>> On Sun, Feb 16, 2014 at 11:08 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Sat, Feb 15, 2014 at 03:36:13PM +0000, Filipe David Borba Manana wrote:
>> >> Test for a btrfs incremental send issue where we end up sending a
>> >> wrong section of data from a file extent if the corresponding file
>> >> extent is compressed and the respective file extent item has a non
>> >> zero data offset.
>> >>
>> >> Fixed by the following linux kernel btrfs patch:
>> >>
>> >>    Btrfs: use right clone root offset for compressed extents
>> >>
>> >> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> >> ---
>> >>
>> >> V2: Made the test more reliable. Now it doesn't depend anymore of btrfs'
>> >>     hole punch implementation leaving hole file extent items when we punch
>> >>     beyond the file's current size.
>> >>
>> >>  tests/btrfs/040     |  115 +++++++++++++++++++++++++++++++++++++++++++++++++++
>> >>  tests/btrfs/040.out |    1 +
>> >>  tests/btrfs/group   |    1 +
>> >>  3 files changed, 117 insertions(+)
>> >>  create mode 100755 tests/btrfs/040
>> >>  create mode 100644 tests/btrfs/040.out
>> >>
>> >> diff --git a/tests/btrfs/040 b/tests/btrfs/040
>> >> new file mode 100755
>> >> index 0000000..d6b37bf
>> >> --- /dev/null
>> >> +++ b/tests/btrfs/040
>> >> @@ -0,0 +1,115 @@
>> >> +#! /bin/bash
>> >> +# FS QA Test No. btrfs/040
>> >> +#
>> >> +# Test for a btrfs incremental send issue where we end up sending a
>> >> +# wrong section of data from a file extent if the corresponding file
>> >> +# extent is compressed and the respective file extent item has a non
>> >> +# zero data offset.
>> >> +#
>> >> +# Fixed by the following linux kernel btrfs patch:
>> >> +#
>> >> +#   Btrfs: use right clone root offset for compressed extents
>> >> +#
>> >> +#-----------------------------------------------------------------------
>> >> +# Copyright (c) 2014 Filipe Manana.  All Rights Reserved.
>> >> +#
>> >> +# This program is free software; you can redistribute it and/or
>> >> +# modify it under the terms of the GNU General Public License as
>> >> +# published by the Free Software Foundation.
>> >> +#
>> >> +# This program is distributed in the hope that it would be useful,
>> >> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> >> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> >> +# GNU General Public License for more details.
>> >> +#
>> >> +# You should have received a copy of the GNU General Public License
>> >> +# along with this program; if not, write the Free Software Foundation,
>> >> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> >> +#-----------------------------------------------------------------------
>> >> +#
>> >> +
>> >> +seq=`basename $0`
>> >> +seqres=$RESULT_DIR/$seq
>> >> +echo "QA output created by $seq"
>> >> +
>> >> +here=`pwd`
>> >> +tmp=`mktemp -d`
>> >> +status=1     # failure is the default!
>> >> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> >> +
>> >> +_cleanup()
>> >> +{
>> >> +    rm -fr $tmp
>> >> +}
>> >> +
>> >> +# get standard environment, filters and checks
>> >> +. ./common/rc
>> >> +. ./common/filter
>> >> +
>> >> +# real QA test starts here
>> >> +_supported_fs btrfs
>> >> +_supported_os Linux
>> >> +_require_scratch
>> >> +_need_to_be_root
>> >> +
>> >> +FSSUM_PROG=$here/src/fssum
>> >> +[ -x $FSSUM_PROG ] || _notrun "fssum not built"
>> >> +
>> >> +rm -f $seqres.full
>> >> +
>> >> +_scratch_mkfs >/dev/null 2>&1
>> >> +_scratch_mount "-o compress-force=lzo"
>> >> +
>> >> +run_check $XFS_IO_PROG -f -c "truncate 118811" $SCRATCH_MNT/foo
>> >> +run_check $XFS_IO_PROG -c "pwrite -S 0x0d -b 39987 92267 39987" \
>> >> +     $SCRATCH_MNT/foo
>> >
>> > Ugh. filter the output, don't use run_check.
>> >
>> > $XFS_IO_PROG -f -c "truncate 118811" $SCRATCH_MNT/foo
>> > $XFS_IO_PROG -c "pwrite -S 0x0d -b 39987 92267 39987" \
>> >         $SCRATCH_MNT/foo | _filter_xfs_io
>> >
>> > If something fails, we still want the test to continue running, even
>> > if all it does is exercise error handling paths. run_check simply
>> > terminates the test at the first failure.
>>
>> What's the point of continuing? The test will fail anyway, all of the
>> xfs_io calls are necessary to trigger the bug.
>
> Users don't stop doing doing stuff on a filesystem when a single
> failure occurs, so why should the tests? If you stop the moment a
> single failure occurs then you aren't ever going to stress the error
> handling paths, are you?
>
>> > _run_btrfs_util_prog()
>> > {
>> >         run_check $BTRFS_UTIL_PROG $*
>> > }
>> >
>> > would be a good start because it gets that run_check pattern out of
>> > the main test scripts and hence out of the heads of test writers.
>>
>> Well, will get rid of those run_check calls, but that will imply
>> adding some | _filter_scratch in many places. So shortening lines is
>> not a great argument :)
>
> I'm not talking about shortening lines here. I'm talking about the
> correct principles and conceptsi being in the forefront of a test
> writer's mind. Having the concept of "need to filter the output" in
> the head of test writers is *exactly* the right mindset to have.
>
> Indeed, if you have a block of code that needs common filtering,
> that's easy to do:
>
> do_test()
> {
>         # put test in function
> }
>
> do_test | _filter_scratch
>
> Will apply that filter to the entire output of the test, and so
> you don't need it on every command.
>
> Remember - an xfstest is not a "pass/fail" test. It's a "run this
> set of commands, and then check the entire output matches the known
> good output" test. i.e. we are testing the entire set of commands as
> a whole - we are not testing each individual command that is run.
> It's a very different principle to the "test every command that can
> fail" method of writing tests.
>
> _fail should only be used if the test cannot possibly be continued
> (e.g. scratch filesystem corrupted and cannot be mounted).  If one
> of the early commands fails, then that's fine - the test will fail -
> but we still want to run the other commands if we can so as to get
> the best test coverage we can get even on failed tests.

Ok, thanks for the very detailed explanation, very helpful :)


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
