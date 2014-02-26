Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D9DB57F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 18:34:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B8E038F8071
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 16:34:54 -0800 (PST)
Received: from mail-ea0-f169.google.com (mail-ea0-f169.google.com
	[209.85.215.169]) by cuda.sgi.com with ESMTP id
	FrPBuZ3hsHrVNPUT (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 16:34:53 -0800 (PST)
Received: by mail-ea0-f169.google.com with SMTP id d10so468378eaj.14
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 16:34:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140225233304.GH13647@dastard>
References: <1393352816-26065-1-git-send-email-fdmanana@gmail.com>
	<1393353848-26790-1-git-send-email-fdmanana@gmail.com>
	<20140225195420.GX13647@dastard>
	<CAL3q7H5U2uQyN=z4kjD-fiMk+854URUuf_=0NqUYj4KG4eNsNA@mail.gmail.com>
	<20140225221100.GG13647@dastard>
	<CAL3q7H4BG9v4_cyf-GbCCEPhWqz-Z8+j3tgKKp1doJxg+unSYg@mail.gmail.com>
	<20140225233304.GH13647@dastard>
Date: Wed, 26 Feb 2014 00:34:51 +0000
Message-ID: <CAL3q7H513iVF=bzVws8iBnuJQ+AVLnZwBrQpJkUoYyPezN5WXw@mail.gmail.com>
Subject: Re: [PATCH v2] xfstests: add test for btrfs-progs restore feature
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

On Tue, Feb 25, 2014 at 11:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Feb 25, 2014 at 10:34:07PM +0000, Filipe David Manana wrote:
>> On Tue, Feb 25, 2014 at 10:11 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Tue, Feb 25, 2014 at 09:02:43PM +0000, Filipe David Manana wrote:
>> >> On Tue, Feb 25, 2014 at 7:54 PM, Dave Chinner <david@fromorbit.com> wrote:
>> >> > On Tue, Feb 25, 2014 at 06:44:08PM +0000, Filipe David Borba Manana wrote:
>> >> >> This is a regression test to verify that the restore feature of btrfs-progs
>> >> >> is able to correctly recover files that have compressed extents, specially when
>> >> >> the respective file extent items have a non-zero data offset field.
>> >> >>
>> >> >> This issue is fixed by the following btrfs-progs patch:
>> >> >>
>> >> >>     Btrfs-progs: fix restore of files with compressed extents
>> >> >>
>> >> >> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> >> > ....
>> >> >> +seq=`basename $0`
>> >> >> +seqres=$RESULT_DIR/$seq
>> >> >> +echo "QA output created by $seq"
>> >> >> +
>> >> >> +tmp=/tmp/$$
>> >> >> +status=1     # failure is the default!
>> >> >> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> >> >
>> >> > here=`pwd`
>> >>
>> >> Didn't we agree before, for a previous path, to export "here" from the
>> >> main control skip and then cleanup tests to not redefine it?
>> >> I am confused now :)
>> >
>> > Yes, we did, but there's no patch to do that yet. Hence tests need
>> > to define it until the infrastructure is changed.....
>>
>> There's a patch flying around that adds the _require_fssum() and then
>> removes definition of "here" for all btrfs tests that use fssum.
>
> changing how $here is defined needs to be in a patch of it's own,
> and that patch needs to remove it from every single test in the
> xfstests code base that declares it. test harness infrastructure
> changes should not be buried in an unrelated btrfs test changes....
>
>> >> >> +             | _filter_xfs_io
>> >> >> +     $XFS_IO_PROG -c "pwrite -S 0xd0 -b 11 33000 11" $SCRATCH_MNT/foo \
>> >> >> +             | _filter_xfs_io
>> >> >> +     $XFS_IO_PROG -c "pwrite -S 0xbc -b 100 99000 100" $SCRATCH_MNT/foo \
>> >> >> +             | _filter_xfs_io
>> >> >> +
>> >> >> +     md5sum $SCRATCH_MNT/foo | _filter_scratch
>> >> >
>> >> > So you are doing this with first having "persisted" the new extents.
>> >> > Seems kind of strange that you need to persist some and not
>> >> > others...
>>
>> All I want is to have different file extent items.
>
> Yes, I get that. What is not clear is where you expect
> the failure to be detected - in memory or on disk?
>
>> >> I need to make sure there's fragmentation (i.e. several file extent
>> >> items in the fs btree with data offset fields > 0).
>> >
>> > Right, but my question is why you haven't ensured that btree is on
>> > disk at the time you run the md5sum.
>>
>> Because it's not needed.
>> The sync is only to make sure the first 2 extent items aren't merged
>> together. And that is needed to trigger the failure.
>
> Yes, it's a pre-condition. That's not the answer to the question
> I've been asking, though.
>
>> > That seems important to me
>> > because the above sync commands indicate that having the extents on
>> > disk rather than in memory is important here. e.g. are you expecting
>> > the md5sum to be correct before the data is synced to disk, and then
>> > incorrect after the data is synced to disk by the unmount?
>>
>> Again what's important is having multiple extent items after unmounting.
>
> Ah, so syncing the data after the second set of writes is important,
> and that's what you are testing. So, why aren't you testing this
> with sync and fiemap? Or is it the unmount that matters, rather than
> the data writeback?
>
> Do you see what I'm trying to understand? If it's data writeback
> that triggers the bug or enables it to be detected, then that's what
> the test should use as the trigger. If unmount is necessary, then a
> comment saying "data writeback is not sufficient to trigger or
> detect the corruption - we need can only detect it via unmount and a
> fsck pass"....

See my last reply below, which answers this.

>
>> > code in it to check and unmount the scratch device, so if that is
>> > not happening then there's something broken that needs to be fixed.
>>
>> So _check_btrfs_filesystem() will unmount the fs if it's mounted, do
>> the fsck thing and then remount it. If the isn't mounted when it's
>> called, it will not mount/remount it after doing the fsck. Very
>> explicit, I don't know the motivation for that behaviour.
>
> Ok, so the problem is not as you described - it's not that
> _check_scratch_fs doesn't unmount the filesystem, it's that it
> mounts it again after the check and the test requires it to be
> unmounted *after* it has been checked.  See how much time a simple
> comment can save? :)
>
>> >> matter what its filesystem is (btrfs, extN, xfs, etc)
>> >
>> > Needs a comment.
>>
>> Ok... so should I make a comment to explain what btrfs restore does?
>> Is it unreasonable to expect an unfamiliar reader to run btrfs --help
>> or check the man page for example to see what this command is?
>
> It is unreasonable to expect them to understand why you used btrfs
> restore rather than just doing "_scratch_check_fs; md5sum
> $testfile". That's what the comment needs to explain, because I
> still don't understand why the test uses btrfs restore or why it
> would give any different result to the script fragment in the
> previous sentence...

So, the problem is that the restore command, which only reads from an
unmounted fs (from disk directly) was incorrectly reading certain file
extents (compressed extents with a data offset field != 0). This is
basically what the comment at the top says:

+# Test that btrfs-progs' restore command is able to correctly recover files
+# that have compressed extents, specially when the respective file extent
+# items have a non-zero data offset field.

I'll add a comment just before calling restore...

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
