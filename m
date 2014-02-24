Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D916B7F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 17:08:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E9EE30406A
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:08:30 -0800 (PST)
Received: from mail-bk0-f48.google.com (mail-bk0-f48.google.com
	[209.85.214.48]) by cuda.sgi.com with ESMTP id PFkld6VEOeOVH4gr
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:08:28 -0800 (PST)
Received: by mail-bk0-f48.google.com with SMTP id mx12so763910bkb.35
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 15:08:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140224222216.GP4317@dastard>
References: <1393242983-16149-1-git-send-email-fdmanana@gmail.com>
	<20140224122310.GO4317@dastard>
	<CAL3q7H5tfnb+uqa-ru5YNcok1n8PQxxai7UfkH-YgCdts84Tew@mail.gmail.com>
	<20140224222216.GP4317@dastard>
Date: Mon, 24 Feb 2014 23:08:27 +0000
Message-ID: <CAL3q7H7N3VVrfoVvNx_4wPsP38FO=sLNCBC-VJ2Tsz4NLqh39A@mail.gmail.com>
Subject: Re: [PATCH] xfstests: add function _require_fssum()
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

On Mon, Feb 24, 2014 at 10:22 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Feb 24, 2014 at 01:22:36PM +0000, Filipe David Manana wrote:
>> On Mon, Feb 24, 2014 at 12:23 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Mon, Feb 24, 2014 at 11:56:23AM +0000, Filipe David Borba Manana wrote:
>> >> To avoid repeating detection of fssum presence in many btrfs tests, as
>> >> suggested by Dave Chinner.
>> >>
>> >> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> >> ---
>> >>  common/rc       |    7 +++++++
>> >>  tests/btrfs/007 |    5 +----
>> >>  tests/btrfs/016 |    5 +----
>> >>  tests/btrfs/030 |    5 +----
>> >>  tests/btrfs/038 |    5 +----
>> >>  tests/btrfs/039 |    5 +----
>> >>  tests/btrfs/040 |    5 +----
>> >>  tests/btrfs/041 |    5 +----
>> >>  tests/btrfs/042 |    5 +----
>> >>  9 files changed, 15 insertions(+), 32 deletions(-)
>> >>  mode change 100644 => 100755 tests/btrfs/016
>> >>
>> >> diff --git a/common/rc b/common/rc
>> >> index 5df504c..cce05cc 100644
>> >> --- a/common/rc
>> >> +++ b/common/rc
>> >> @@ -2144,6 +2144,13 @@ _require_cp_reflink()
>> >>                 _notrun "This test requires a cp with --reflink support."
>> >>  }
>> >>
>> >> +_require_fssum()
>> >> +{
>> >> +     HERE=`pwd`
>> >> +     FSSUM_PROG=$HERE/src/fssum
>> >> +     [ -x $FSSUM_PROG ] || _notrun "fssum not built"
>> >> +}
>> >
>> > $here is defined by check to be the root of the xfstests instance
>> > that is running. There's 60+ tests that already us it. Hence:
>> >
>> > _require_fssum()
>> > {
>> >         FSSUM_PROG=$here/src/fssum
>> >         [ -x $FSSUM_PROG ] || _notrun "fssum not built"
>> > }
>> >
>> > Is all you need here.
>>
>> Hum, doesn't work unless the test file defines $here. At least when
>> running a single only (.e.g. ./check btrfs/041).
>
> Right, I realised that it isn't exported from check, and the template
> for new tests defines it as:
>
> here=\`pwd\`
>
> which is essentially the same thing. Almost every test does it.
>
> $ git grep here=\`pwd\` |wc -l
> 364
>
> And it works just fine when running a test as you describe above.
> Many of the _requires* functions just use $here directly, and does a
> lot of the common/* infrastructure. It is assumed that $here is set
> and valid and so if it wasn't set, lots of different things would
> break.
>
> Oh, I note that btrfs/034 and btrfs/037 don't set it, so they need
> fixing, too.
>
> Looking at it, though, we shoul djust export the value from check
> and remove the assignment that occurs in every test as they end up
> being the same value:
>
> $ sudo ./check generic/001
> check_here=/home/dave/src/xfstests-dev
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 test2 3.14.0-rc3-dgc+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
>
> generic/001 5s ... [failed, exit status 1] - output mismatch (see /home/dave/src/xfstests-dev/results//generic/001.out.bad)
> .....
> $ cat /home/dave/src/xfstests-dev/results//generic/001.out.bad
> QA output created by 001
> here=/home/dave/src/xfstests-dev
> $
>
>> >> diff --git a/tests/btrfs/007 b/tests/btrfs/007
>> >> index 5df9ccb..5430613 100755
>> >> --- a/tests/btrfs/007
>> >> +++ b/tests/btrfs/007
>> >> @@ -31,7 +31,6 @@ seq=`basename $0`
>> >>  seqres=$RESULT_DIR/$seq
>> >>  echo "QA output created by $seq"
>> >>
>> >> -here=`pwd`
>> >>  tmp=`mktemp -d`
>> >>  status=1
>> >
>> > Yeah, redefining $here is a bad thing to do :/
>
> Right, my mistake. It needs to be defined for the entire test, not
> in a requires function. Hence I think we should just export it from
> check....

Hum, ok. So the decision is to let the tests explicitly define the
variable "here", and not export "here" from the main check script.

>
>> > It also points out that the btrfs tests are using a non-standard
>> > $tmp directory - one that is in the xfstests source directory.
>> > That's a bad thing, too - tests should be using:
>> >
>> > tmp=/tmp/$$
>> >
>> > to store small temporary files.
>> >
>> > If /tmp is too small for what a test needs, then the test should be
>> > using $TEST_DIR as the store for the temporary files to exercise
>> > the filesystem under test as much as possible.  e.g. send image
>> > files build form snapshots of SCRATCH_DEV should be stored on TEST_DIR,
>> > not in $tmp; filesystem image files that are mounted by loopback
>> > should be stored on TEST_DIR or SCRATCH_MNT, not $tmp. And so on.
>> >
>> > i.e. the idea is that you direct as much of the IO to the test_DIR
>> > and SCRATCH_MNT as possible, not to the filesystem that is hosting
>> > $tmp or the xfstests source directory....
>>
>> Right. Sounds like a separate patch (to use TEST_DIR/$$ for e.g. as a
>> place to store temporary test data).
>
> tmp should be set to /tmp/$$. That's where the *test harness* will
> direct temporary log files, mkfs output, etc. If you have temporary
> data for the *test*, and it's large, use TEST_DIR, not $tmp.
> $tmp is generally only for things like log files, time stamps,
> output files that need later processing because they can't be
> filtered directly, etc.
>
> Why? Because if the test corrupts $TEST_DIR and you've got all the
> test harness tmp files on TEST_DIR, how is the test harness going
> to work out what went wrong during the test?

Makes sense. All these btrfs tests are adding small files to /tmp,
less than ~100Kb or so (certainly not megabytes), so that seems fine.

Thanks Dave

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
