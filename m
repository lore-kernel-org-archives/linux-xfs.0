Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:39289 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbfB0EHL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Feb 2019 23:07:11 -0500
MIME-Version: 1.0
References: <20190226181407.44612-1-bfoster@redhat.com> <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190226232212.GD16436@dastard>
In-Reply-To: <20190226232212.GD16436@dastard>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 27 Feb 2019 06:06:57 +0200
Message-ID: <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock filesystems
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>

On Wed, Feb 27, 2019 at 1:22 AM Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Feb 26, 2019 at 11:10:02PM +0200, Amir Goldstein wrote:
> > On Tue, Feb 26, 2019 at 8:14 PM Brian Foster <bfoster@redhat.com> wrote:
> > >
> > > The dm-log-writes mechanism runs a workload against a filesystem,
> > > tracks underlying FUAs and restores the filesystem to various points
> > > in time based on FUA marks. This allows fstests to check fs
> > > consistency at various points and verify log recovery works as
> > > expected.
> > >
> >
> > Inaccurate. generic/482 restores to FUA points.
> > generic/45[57] restore to user defined points in time (marks).
> > dm-log-writes mechanism is capable of restoring either.
> >
> > > This mechanism does not play well with LSN based log recovery
> > > ordering behavior on XFS v5 superblocks, however. For example,
> > > generic/482 can reproduce false positive corruptions based on extent
> > > to btree conversion of an inode if the inode and associated btree
> > > block are written back after different checkpoints. Even though both
> > > items are logged correctly in the extent-to-btree transaction, the
> > > btree block can be relogged (multiple times) and only written back
> > > once when the filesystem unmounts. If the inode was written back
> > > after the initial conversion, recovery points between that mark and
> > > when the btree block is ultimately written back will show corruption
> > > because log recovery sees that the destination buffer is newer than
> > > the recovered buffer and intentionally skips the buffer. This is a
> > > false positive because the destination buffer was resiliently
> > > written back after being physically relogged one or more times.
> > >
> >
> > This story doesn't add up.
> > Either dm-log-writes emulated power failure correctly or it doesn't.
> > My understanding is that the issue you are seeing is a result of
> > XFS seeing "data from the future" after a restore of a power failure
> > snapshot, because the scratch device is not a clean slate.
> > If I am right, then the correct solution is to wipe the journal before
> > starting to replay restore points.
>
> If that is the problem, then I think we should be wiping the entire
> block device before replaying the recorded logwrite.
>

Indeed.

> i.e. this sounds like a "block device we are replaying onto has
> stale data in it" problem because we are replaying the same
> filesystem over the top of itself.  Hence there are no unique
> identifiers in the metadata that can detect stale metadata in
> the block device.
>
> I'm surprised that we haven't tripped over this much earlier that
> this...
>

I remember asking myself the same thing... it's coming back to me
now. I really remember having this discussion during test review.
generic/482 is an adaptation of Josef's test script [1], which
does log recovery onto a snapshot on every FUA checkpoint.

[1] https://github.com/josefbacik/log-writes/blob/master/replay-fsck-wrapper.sh

Setting up snapshots for every checkpoint was found empirically to take
more test runtime, than replaying log from the start for each checkpoint.
That observation was limited to the systems that Qu and Eryu tested on.

IRC, what usually took care of cleaning the block device is replaying the
"discard everything" IO from mkfs time. dm-log-writes driver should take care
of zeroing blocks upon replaying a discard IO even on a target device that
doesn't support discard, but maybe if original device doesn't support discard,
the IO is not recorded at all and therefore not replayed?

Brian, can you check if your log-writes stream contains a discard IO for
the entire block device? I do remember that the initial log-writes tests worked
very reliably on my laptop with SSD and were a bit flaky on another test machine
with spinning rust, but that machine had other hardware reliability issues at
the time (bad SATA cable) so I attributed all issues to that problem.

BTW, looking closer at generic/482, $prev does not seem to be used at all
in the replay loop.

> > > Update the dm-log-writes require checks to enforce v4 superblocks
> > > when running against XFS and skip the test otherwise.
> >
> > You might as well disable dm-log-writes test for XFS completely.
> > Who cares about v4 superblocks these days?
>
> Enough of the inflammatory hyperbole, Amir. Statements like this
> serve no useful purpose.
>

<deep breath> Agreed.

Thanks,
Amir.
