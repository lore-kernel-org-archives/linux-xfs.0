Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:16928 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729592AbfB0GPh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Feb 2019 01:15:37 -0500
Date: Wed, 27 Feb 2019 17:15:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock
 filesystems
Message-ID: <20190227061529.GF16436@dastard>
References: <20190226181407.44612-1-bfoster@redhat.com>
 <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190226232212.GD16436@dastard>
 <CAOQ4uxgueAtF5o+Zjd+N0_h7784veL2FNd7-aB+33HWEN07gHg@mail.gmail.com>
 <ed870e00-1931-d7b1-a3ed-8a184889f6fc@gmx.com>
 <CAOQ4uxhNdzbSiPREmMtv5_81=7bxCRbTaa_KUN00g7De_j6a4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhNdzbSiPREmMtv5_81=7bxCRbTaa_KUN00g7De_j6a4Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Brian Foster <bfoster@redhat.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>

On Wed, Feb 27, 2019 at 06:49:56AM +0200, Amir Goldstein wrote:
> On Wed, Feb 27, 2019 at 6:19 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> >
> >
> >
> > On 2019/2/27 下午12:06, Amir Goldstein wrote:
> > > On Wed, Feb 27, 2019 at 1:22 AM Dave Chinner <david@fromorbit.com> wrote:
> > >>
> > >> On Tue, Feb 26, 2019 at 11:10:02PM +0200, Amir Goldstein wrote:
> > >>> On Tue, Feb 26, 2019 at 8:14 PM Brian Foster <bfoster@redhat.com> wrote:
> > >>>>
> > >>>> The dm-log-writes mechanism runs a workload against a filesystem,
> > >>>> tracks underlying FUAs and restores the filesystem to various points
> > >>>> in time based on FUA marks. This allows fstests to check fs
> > >>>> consistency at various points and verify log recovery works as
> > >>>> expected.
> > >>>>
> > >>>
> > >>> Inaccurate. generic/482 restores to FUA points.
> > >>> generic/45[57] restore to user defined points in time (marks).
> > >>> dm-log-writes mechanism is capable of restoring either.
> > >>>
> > >>>> This mechanism does not play well with LSN based log recovery
> > >>>> ordering behavior on XFS v5 superblocks, however. For example,
> > >>>> generic/482 can reproduce false positive corruptions based on extent
> > >>>> to btree conversion of an inode if the inode and associated btree
> > >>>> block are written back after different checkpoints. Even though both
> > >>>> items are logged correctly in the extent-to-btree transaction, the
> > >>>> btree block can be relogged (multiple times) and only written back
> > >>>> once when the filesystem unmounts. If the inode was written back
> > >>>> after the initial conversion, recovery points between that mark and
> > >>>> when the btree block is ultimately written back will show corruption
> > >>>> because log recovery sees that the destination buffer is newer than
> > >>>> the recovered buffer and intentionally skips the buffer. This is a
> > >>>> false positive because the destination buffer was resiliently
> > >>>> written back after being physically relogged one or more times.
> > >>>>
> > >>>
> > >>> This story doesn't add up.
> > >>> Either dm-log-writes emulated power failure correctly or it doesn't.
> > >>> My understanding is that the issue you are seeing is a result of
> > >>> XFS seeing "data from the future" after a restore of a power failure
> > >>> snapshot, because the scratch device is not a clean slate.
> > >>> If I am right, then the correct solution is to wipe the journal before
> > >>> starting to replay restore points.
> > >>
> > >> If that is the problem, then I think we should be wiping the entire
> > >> block device before replaying the recorded logwrite.
> > >>
> > >
> > > Indeed.
> >
> > May I ask a stupid question?
> >
> > How does it matter whether the device is clean or not?
> > Shouldn't the journal/metadata or whatever be self-contained?
> >
> 
> Yes and no.
> 
> The most simple example (not limited to xfs and not sure it is like that in xfs)
> is how you find the last valid journal commit entry. It should have correct CRC
> and the largest LSN. But it you replay IO on top of existing journal without
> wiping it first, then journal recovery will continue past the point to meant to
> replay or worse.

No, that's not the problem we have with XFS. THe problem is that XFS
will not recover the changes in the log if the object on disk it
would recover into is more recent than the information found in the
log. i.e. it's already been written back and so the journal entry
does not need to be replayed.

IOWs, if the block device is not wiped, the first read of a piece
of a newly allocated and modified metadata object in the log will
see the future state of the object, not whatever was there when the
block was first allocated.

i.e.
			in memory	in journal	on disk
initial contents	0000		n/a		0000
allocate,		0001		n/a		0000
modify, checkpoint 1	0002		0002		0000
modify, checkpoint 2	0003		0003		0000
modify, checkpoint 3	0004		0004		0000
write back		0004		0004		0004
checkpoint 4		0004		n/a		0004

Now when we replay up to checkpoint 1, log recovery will read the
object from disk. If the disk has been zeroed before we replay, the
read in log recovery will see 0000 and replay 0002 over the top,
and all will be good. However, if the device hasn;t been zeroed,
recovery will read "0004", which is more recent than 0002, and it
will not replay 0002 because it knows there are future changes to
that object in the journal that will be replayed.

IOWs, stale metadata (from the future) prevents log recovery from
replaying the objects it should be replaying.

> The problem that Brian describes is more complicated than that and not
> limited to the data in the journal IIUC, but I think what I described above
> may plague also ext4 and xfs v4.

It will affect xfs v4, but we can't detect it at all because we
don't have sequence numbers in the metadata. ext4 is in the same
boat as xfs v4, while btrfs is like XFS v5 with transaction
identifiers in the metadata to indicate when it was written...

> > This "discard everything" assumption doesn't look right to me.
> > Although most mkfs would discard at least part of the device, even
> > without discarding the newly created fs should be self-contained, no
> > wild pointer points to some garbage.

If the block device is in an uninitialised state when we start,
then all bets are off - it is not a "self contained" test because
the initial state is completely unknown. We need to zero so that the
initial state for both creation and each replay that occurs start
from the same initial conditions.

> > Am I missing something? Or do I get too poisoned by btrfs CoW?
> 
> I'd be very surprised if btrfs cannot be flipped by seeing stale data "from
> the future" in the block device. Seems to me like the entire concept of
> CoW and metadata checksums is completely subverted by the existence
> of correct checksums on "stale metadata from the future".

No, this is a journal recovery issue - recovery is a
read-modify-write operation and so if the contents that are read are
stale in a specific way we can be exposed to problems like this.
btrfs is not a journalling filesystem, so it shouldn't be doing RMW
cycles on metadata to bring it into a consistent state during
recovery - it should be doing atomic updates of the tree root to
switch from one consistent state on disk to the next....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
