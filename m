Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43424 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbfB0ORf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Feb 2019 09:17:35 -0500
Date: Wed, 27 Feb 2019 09:17:32 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock
 filesystems
Message-ID: <20190227141732.GA49946@bfoster>
References: <20190226181407.44612-1-bfoster@redhat.com>
 <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190227131838.GA49593@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227131838.GA49593@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>

On Wed, Feb 27, 2019 at 08:18:39AM -0500, Brian Foster wrote:
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
> 
> The above is poorly worded. I'm aware of the separate tests and I've
> used the mechanism to bounce around to various marks. Note that my
> understanding of the mechanism beyond that is rudimentary. I'll reword
> this if the patch survives, but it sounds like there may be opportunity
> to fix the mechanism, which clearly would be ideal.
> 
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
> 
> It doesn't. It leaves the log and broader filesystem in a state that
> makes no sense with respect to a power failure.
> 
> > My understanding is that the issue you are seeing is a result of
> > XFS seeing "data from the future" after a restore of a power failure
> > snapshot, because the scratch device is not a clean slate.
> > If I am right, then the correct solution is to wipe the journal before
> > starting to replay restore points.
> > 
> > Am I misunderstanding whats going on?
> > 
> 
> Slightly. Wiping the journal will not help. I _think_ that a wipe of the
> broader filesystem before recovering from the initial fua and replaying
> in order from there would mitigate the problem. Is there an easy way to
> test that theory? For example, would a mkfs of the scratch device before
> the replay sequence of generic/482 begins allow the test to still
> otherwise function correctly?
> 

FYI, I gave this a try and it didn't ultimately work because mkfs didn't
clear the device either. I ended up reproducing the problem, physically
zeroing the device, replaying the associated FUA and observing the
problem go away. From there, if I replay to the final FUA mark and go
back to the (originally) problematic FUA, the problem is reintroduced.

Brian

> I was going to elaborate further on the sequence of events, but I see
> Dave has already nicely described this generically in his most recent
> reply.
> 
> > IIRC, some of Josef's earlier versions used dm snapshots to restore
> > the blockdev to a clean state before replying log-writes.
> > I think that one of the earlier versions of generic/482 also took
> > that approach, but that resulted in longer test runtime (not sure).
> > 
> > > Update the dm-log-writes require checks to enforce v4 superblocks
> > > when running against XFS and skip the test otherwise.
> > 
> > You might as well disable dm-log-writes test for XFS completely.
> > Who cares about v4 superblocks these days?
> > We need a tool to make sure the NEW features are crash resilient.
> > 
> > dm-log-writes proved itself to be a powerful generic test tool that found
> > some serious crash consistency bugs in every one of the major filesystems
> > and it found bugs with XFS reflink log recovery as well, so IMO
> > disabling dm-log-writes for v5 would be "very unwise!".
> > 
> 
> Thanks for the insight
> 
> Brian
> 
> > Thanks,
> > Amir.
