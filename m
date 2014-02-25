Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EAC617F52
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 16:34:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6CC18AC004
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 14:34:10 -0800 (PST)
Received: from mail-qc0-f180.google.com (mail-qc0-f180.google.com
	[209.85.216.180]) by cuda.sgi.com with ESMTP id
	8e4E95O5HIgE7ooQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Feb 2014 14:34:08 -0800 (PST)
Received: by mail-qc0-f180.google.com with SMTP id i17so123085qcy.11
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 14:34:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140225221100.GG13647@dastard>
References: <1393352816-26065-1-git-send-email-fdmanana@gmail.com>
	<1393353848-26790-1-git-send-email-fdmanana@gmail.com>
	<20140225195420.GX13647@dastard>
	<CAL3q7H5U2uQyN=z4kjD-fiMk+854URUuf_=0NqUYj4KG4eNsNA@mail.gmail.com>
	<20140225221100.GG13647@dastard>
Date: Tue, 25 Feb 2014 22:34:07 +0000
Message-ID: <CAL3q7H4BG9v4_cyf-GbCCEPhWqz-Z8+j3tgKKp1doJxg+unSYg@mail.gmail.com>
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

On Tue, Feb 25, 2014 at 10:11 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Feb 25, 2014 at 09:02:43PM +0000, Filipe David Manana wrote:
>> On Tue, Feb 25, 2014 at 7:54 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Tue, Feb 25, 2014 at 06:44:08PM +0000, Filipe David Borba Manana wrote:
>> >> This is a regression test to verify that the restore feature of btrfs-progs
>> >> is able to correctly recover files that have compressed extents, specially when
>> >> the respective file extent items have a non-zero data offset field.
>> >>
>> >> This issue is fixed by the following btrfs-progs patch:
>> >>
>> >>     Btrfs-progs: fix restore of files with compressed extents
>> >>
>> >> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> > ....
>> >> +seq=`basename $0`
>> >> +seqres=$RESULT_DIR/$seq
>> >> +echo "QA output created by $seq"
>> >> +
>> >> +tmp=/tmp/$$
>> >> +status=1     # failure is the default!
>> >> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> >
>> > here=`pwd`
>>
>> Didn't we agree before, for a previous path, to export "here" from the
>> main control skip and then cleanup tests to not redefine it?
>> I am confused now :)
>
> Yes, we did, but there's no patch to do that yet. Hence tests need
> to define it until the infrastructure is changed.....

There's a patch flying around that adds the _require_fssum() and then
removes definition of "here" for all btrfs tests that use fssum.

>
>> >> +     _scratch_mount $OPTIONS
>> >> +
>> >> +     $XFS_IO_PROG -f -c "pwrite -S 0xff -b 100000 0 100000" \
>> >> +             $SCRATCH_MNT/foo | _filter_xfs_io
>> >> +
>> >> +     # Ensure a single file extent item is persisted.
>> >> +     _run_btrfs_util_prog filesystem sync $SCRATCH_MNT
>> >
>> > What's the difference here between "sync" and the command run above?
>> > Unless there's some specific reason for using the above command (and
>> > that needs to be commented), I think that sync(1) should be used
>> > instead in all tests.
>>
>> I want to force a btrfs transaction commit. Plain old 'sync' would do
>> it as well for sure, but that applies against all mounted FSs, while
>> btrfs filesystem sync is applied against a single fs.
>
> And the problem with syncing all the filesystems is what?
>
>> Plus, since this is a btrfs specific test, is it non sense to exercise
>> commands from btrfs-progs?
>
> At the expense of testing the command that almost every user in
> the world uses to sync their filesystems?
>
>> >> +             | _filter_xfs_io
>> >> +     $XFS_IO_PROG -c "pwrite -S 0xd0 -b 11 33000 11" $SCRATCH_MNT/foo \
>> >> +             | _filter_xfs_io
>> >> +     $XFS_IO_PROG -c "pwrite -S 0xbc -b 100 99000 100" $SCRATCH_MNT/foo \
>> >> +             | _filter_xfs_io
>> >> +
>> >> +     md5sum $SCRATCH_MNT/foo | _filter_scratch
>> >
>> > So you are doing this with first having "persisted" the new extents.
>> > Seems kind of strange that you need to persist some and not
>> > others...

All I want is to have different file extent items.

>>
>> I need to make sure there's fragmentation (i.e. several file extent
>> items in the fs btree with data offset fields > 0).
>
> Right, but my question is why you haven't ensured that btree is on
> disk at the time you run the md5sum.

Because it's not needed.
The sync is only to make sure the first 2 extent items aren't merged
together. And that is needed to trigger the failure.

> That seems important to me
> because the above sync commands indicate that having the extents on
> disk rather than in memory is important here. e.g. are you expecting
> the md5sum to be correct before the data is synced to disk, and then
> incorrect after the data is synced to disk by the unmount?

Again what's important is having multiple extent items after unmounting.

>
> Will you remember this detail in five years time when this
> test detects a regression? Indeed, will you even be around to
> explain why the test does this in five years time? These regression
> tests are going to be around for the entire life of btrfs, so we
> better make sure that there's enough information in them to be able
> to maintain them in 10-15 years time....

Ok, I hope to be alive in 5, 10 or even 15 years, and I'll make an
effort to remain healthy :)
I'll rephrase the comments to hopefully be more clear about the
intention and conditions necessary to trigger the issue.

>
>>
>> >
>> >> +     _scratch_unmount
>> >> +     _check_scratch_fs
>> >
>> > _check_scratch_fs should be unmounting the SCRATCH_DEV itself
>> > internally. If it's not doing that for btrfs, then the btrfs check
>> > code needs fixing. ;)
>>
>> No it doesn't unmount.
>
> Then _check_btrfs_filesystem() needs fixing. It certainly does have
> code in it to check and unmount the scratch device, so if that is
> not happening then there's something broken that needs to be fixed.

So _check_btrfs_filesystem() will unmount the fs if it's mounted, do
the fsck thing and then remount it. If the isn't mounted when it's
called, it will not mount/remount it after doing the fsck. Very
explicit, I don't know the motivation for that behaviour.

>
> Fix the infrastructure bug, don't work around it.
>
>> >> +
>> >> +     _run_btrfs_util_prog restore $SCRATCH_DEV $tmp
>> >> +     md5sum $tmp/foo | cut -d ' ' -f 1
>> >
>> > What, exactly, are you restoring to /tmp/$$? Does this assume that
>> > /tmp is a btrfs filesystem? If so, that is an invalid assumption -
>> > /tmp can be any type of filesystem at all.
>>
>> The restore command allows you to grab files from a (potentially
>> damaged) btrfs filesystem and save them to a destination path, no
>> matter what its filesystem is (btrfs, extN, xfs, etc)
>
> Needs a comment.

Ok... so should I make a comment to explain what btrfs restore does?
Is it unreasonable to expect an unfamiliar reader to run btrfs --help
or check the man page for example to see what this command is?

>
> [ Ugh. btrfs defines "restore" to mean "recover from [broken]
> device", not "restore from backup" like it's used everywhere else in
> the filesystem world? ]
>
>
>> > It's also wrong to use $tmp like this....
>> >
>> >> +}
>> >> +
>> >> +mkdir $tmp
>> >> +echo "Testing restore of file compressed with lzo"
>> >> +test_btrfs_restore "lzo"
>> >> +echo "Testing restore of file compressed with zlib"
>> >> +test_btrfs_restore "zlib"
>> >> +echo "Testing restore of file without any compression"
>> >> +test_btrfs_restore
>> >
>> > Yup, using $tmp like this is definitely wrong. $tmp is really for test
>> > harness files and test logs, not for *test data*. TEST_DIR is what you
>> > should be using here, not $tmp.
>>
>> Alright... Many other existing tests do things like this.
>
> Yes, but we don't want new tests to do this. I get annoyed by tests
> failing due to running of disk space on /tmp or OOMing on machines
> that use a small tmpfs filesystem for /tmp because tests use it for
> dumping large test files rather than TEST_DIR....
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
