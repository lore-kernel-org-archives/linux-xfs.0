Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:45230 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729274AbfB0EuJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Feb 2019 23:50:09 -0500
MIME-Version: 1.0
References: <20190226181407.44612-1-bfoster@redhat.com> <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190226232212.GD16436@dastard> <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>
 <ed870e00-1931-d7b1-a3ed-8a184889f6fc@gmx.com>
In-Reply-To: <ed870e00-1931-d7b1-a3ed-8a184889f6fc@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 27 Feb 2019 06:49:56 +0200
Message-ID: <CAOQ4uxhNdzbSiPREmMtv5_81=7bxCRbTaa_KUN00g7De_j6a4Q@mail.gmail.com>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock filesystems
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>

On Wed, Feb 27, 2019 at 6:19 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> On 2019/2/27 =E4=B8=8B=E5=8D=8812:06, Amir Goldstein wrote:
> > On Wed, Feb 27, 2019 at 1:22 AM Dave Chinner <david@fromorbit.com> wrot=
e:
> >>
> >> On Tue, Feb 26, 2019 at 11:10:02PM +0200, Amir Goldstein wrote:
> >>> On Tue, Feb 26, 2019 at 8:14 PM Brian Foster <bfoster@redhat.com> wro=
te:
> >>>>
> >>>> The dm-log-writes mechanism runs a workload against a filesystem,
> >>>> tracks underlying FUAs and restores the filesystem to various points
> >>>> in time based on FUA marks. This allows fstests to check fs
> >>>> consistency at various points and verify log recovery works as
> >>>> expected.
> >>>>
> >>>
> >>> Inaccurate. generic/482 restores to FUA points.
> >>> generic/45[57] restore to user defined points in time (marks).
> >>> dm-log-writes mechanism is capable of restoring either.
> >>>
> >>>> This mechanism does not play well with LSN based log recovery
> >>>> ordering behavior on XFS v5 superblocks, however. For example,
> >>>> generic/482 can reproduce false positive corruptions based on extent
> >>>> to btree conversion of an inode if the inode and associated btree
> >>>> block are written back after different checkpoints. Even though both
> >>>> items are logged correctly in the extent-to-btree transaction, the
> >>>> btree block can be relogged (multiple times) and only written back
> >>>> once when the filesystem unmounts. If the inode was written back
> >>>> after the initial conversion, recovery points between that mark and
> >>>> when the btree block is ultimately written back will show corruption
> >>>> because log recovery sees that the destination buffer is newer than
> >>>> the recovered buffer and intentionally skips the buffer. This is a
> >>>> false positive because the destination buffer was resiliently
> >>>> written back after being physically relogged one or more times.
> >>>>
> >>>
> >>> This story doesn't add up.
> >>> Either dm-log-writes emulated power failure correctly or it doesn't.
> >>> My understanding is that the issue you are seeing is a result of
> >>> XFS seeing "data from the future" after a restore of a power failure
> >>> snapshot, because the scratch device is not a clean slate.
> >>> If I am right, then the correct solution is to wipe the journal befor=
e
> >>> starting to replay restore points.
> >>
> >> If that is the problem, then I think we should be wiping the entire
> >> block device before replaying the recorded logwrite.
> >>
> >
> > Indeed.
>
> May I ask a stupid question?
>
> How does it matter whether the device is clean or not?
> Shouldn't the journal/metadata or whatever be self-contained?
>

Yes and no.

The most simple example (not limited to xfs and not sure it is like that in=
 xfs)
is how you find the last valid journal commit entry. It should have correct=
 CRC
and the largest LSN. But it you replay IO on top of existing journal withou=
t
wiping it first, then journal recovery will continue past the point to mean=
t to
replay or worse.

The problem that Brian describes is more complicated than that and not
limited to the data in the journal IIUC, but I think what I described above
may plague also ext4 and xfs v4.

> >
> >> i.e. this sounds like a "block device we are replaying onto has
> >> stale data in it" problem because we are replaying the same
> >> filesystem over the top of itself.  Hence there are no unique
> >> identifiers in the metadata that can detect stale metadata in
> >> the block device.
> >>
> >> I'm surprised that we haven't tripped over this much earlier that
> >> this...
> >>
> >
> > I remember asking myself the same thing... it's coming back to me
> > now. I really remember having this discussion during test review.
> > generic/482 is an adaptation of Josef's test script [1], which
> > does log recovery onto a snapshot on every FUA checkpoint.
> >
> > [1] https://github.com/josefbacik/log-writes/blob/master/replay-fsck-wr=
apper.sh
> >
> > Setting up snapshots for every checkpoint was found empirically to take
> > more test runtime, than replaying log from the start for each checkpoin=
t.
> > That observation was limited to the systems that Qu and Eryu tested on.
> >
> > IRC, what usually took care of cleaning the block device is replaying t=
he
> > "discard everything" IO from mkfs time.
>
> This "discard everything" assumption doesn't look right to me.
> Although most mkfs would discard at least part of the device, even
> without discarding the newly created fs should be self-contained, no
> wild pointer points to some garbage.
>

It's true. We shouldn't make this assumption.
That was my explanation to Dave's question, how come we didn't see
this before?

Here is my log-writes info from generic/482:
./src/log-writes/replay-log -vv --find --end-mark mkfs --log
$LOGWRITES_DEV |grep DISCARD
seek entry 0@2: 0, size 8388607, flags 0x4(DISCARD)
seek entry 1@3: 8388607, size 8388607, flags 0x4(DISCARD)
seek entry 2@4: 16777214, size 4194306, flags 0x4(DISCARD)

> I though all metadata/journal write should be self-contained even for
> later fs writes.
>
> Am I missing something? Or do I get too poisoned by btrfs CoW?
>

I'd be very surprised if btrfs cannot be flipped by seeing stale data "from
the future" in the block device. Seems to me like the entire concept of
CoW and metadata checksums is completely subverted by the existence
of correct checksums on "stale metadata from the future".

Thanks,
Amir.
