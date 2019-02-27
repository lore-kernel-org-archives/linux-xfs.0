Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39156 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729918AbfB0UrM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 27 Feb 2019 15:47:12 -0500
Date: Wed, 27 Feb 2019 15:47:09 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] generic: skip dm-log-writes tests on XFS v5 superblock
 filesystems
Message-ID: <20190227204709.GC50261@bfoster>
References: <20190226181407.44612-1-bfoster@redhat.com>
 <CAOQ4uxg12SAKrSpX8_cdx4Cs56FVjdXiH5U1e8Y3yyCegNYDSw@mail.gmail.com>
 <20190227131838.GA49593@bfoster>
 <20190227141732.GA49946@bfoster>
 <20190227155419.qmjzfbviolg6cwht@MacBook-Pro-91.local>
 <20190227171337.GA50261@bfoster>
 <20190227192747.5u7bd3d2665bndvc@macbook-pro-91.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227192747.5u7bd3d2665bndvc@macbook-pro-91.dhcp.thefacebook.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: Amir Goldstein <amir73il@gmail.com>, fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Qu Wenruo <wqu@suse.com>

On Wed, Feb 27, 2019 at 02:27:49PM -0500, Josef Bacik wrote:
> On Wed, Feb 27, 2019 at 12:13:37PM -0500, Brian Foster wrote:
> > On Wed, Feb 27, 2019 at 10:54:20AM -0500, Josef Bacik wrote:
> > > On Wed, Feb 27, 2019 at 09:17:32AM -0500, Brian Foster wrote:
> > > > On Wed, Feb 27, 2019 at 08:18:39AM -0500, Brian Foster wrote:
> > > > > On Tue, Feb 26, 2019 at 11:10:02PM +0200, Amir Goldstein wrote:
> > > > > > On Tue, Feb 26, 2019 at 8:14 PM Brian Foster <bfoster@redhat.com> wrote:
> > > > > > >
> > > > > > > The dm-log-writes mechanism runs a workload against a filesystem,
> > > > > > > tracks underlying FUAs and restores the filesystem to various points
> > > > > > > in time based on FUA marks. This allows fstests to check fs
> > > > > > > consistency at various points and verify log recovery works as
> > > > > > > expected.
> > > > > > >
> > > > > > 
> > > > > > Inaccurate. generic/482 restores to FUA points.
> > > > > > generic/45[57] restore to user defined points in time (marks).
> > > > > > dm-log-writes mechanism is capable of restoring either.
> > > > > > 
> > > > > 
> > > > > The above is poorly worded. I'm aware of the separate tests and I've
> > > > > used the mechanism to bounce around to various marks. Note that my
> > > > > understanding of the mechanism beyond that is rudimentary. I'll reword
> > > > > this if the patch survives, but it sounds like there may be opportunity
> > > > > to fix the mechanism, which clearly would be ideal.
> > > > > 
> > > > > > > This mechanism does not play well with LSN based log recovery
> > > > > > > ordering behavior on XFS v5 superblocks, however. For example,
> > > > > > > generic/482 can reproduce false positive corruptions based on extent
> > > > > > > to btree conversion of an inode if the inode and associated btree
> > > > > > > block are written back after different checkpoints. Even though both
> > > > > > > items are logged correctly in the extent-to-btree transaction, the
> > > > > > > btree block can be relogged (multiple times) and only written back
> > > > > > > once when the filesystem unmounts. If the inode was written back
> > > > > > > after the initial conversion, recovery points between that mark and
> > > > > > > when the btree block is ultimately written back will show corruption
> > > > > > > because log recovery sees that the destination buffer is newer than
> > > > > > > the recovered buffer and intentionally skips the buffer. This is a
> > > > > > > false positive because the destination buffer was resiliently
> > > > > > > written back after being physically relogged one or more times.
> > > > > > >
> > > > > > 
> > > > > > This story doesn't add up.
> > > > > > Either dm-log-writes emulated power failure correctly or it doesn't.
> > > > > 
> > > > > It doesn't. It leaves the log and broader filesystem in a state that
> > > > > makes no sense with respect to a power failure.
> > > > > 
> > > > > > My understanding is that the issue you are seeing is a result of
> > > > > > XFS seeing "data from the future" after a restore of a power failure
> > > > > > snapshot, because the scratch device is not a clean slate.
> > > > > > If I am right, then the correct solution is to wipe the journal before
> > > > > > starting to replay restore points.
> > > > > > 
> > > > > > Am I misunderstanding whats going on?
> > > > > > 
> > > > > 
> > > > > Slightly. Wiping the journal will not help. I _think_ that a wipe of the
> > > > > broader filesystem before recovering from the initial fua and replaying
> > > > > in order from there would mitigate the problem. Is there an easy way to
> > > > > test that theory? For example, would a mkfs of the scratch device before
> > > > > the replay sequence of generic/482 begins allow the test to still
> > > > > otherwise function correctly?
> > > > > 
> > > > 
> > > > FYI, I gave this a try and it didn't ultimately work because mkfs didn't
> > > > clear the device either. I ended up reproducing the problem, physically
> > > > zeroing the device, replaying the associated FUA and observing the
> > > > problem go away. From there, if I replay to the final FUA mark and go
> > > > back to the (originally) problematic FUA, the problem is reintroduced.
> > > > 
> > > 
> > > Sorry guys, whenever I run log-writes on xfs I use my helper script here
> > > 
> > > https://github.com/josefbacik/log-writes
> > > 
> > > specifically replay-individual-faster.sh.  This creates a snapshot at every
> > > replay point, mounts and checks the fs, and then destroys the snapshot and keeps
> > > going.  This way you don't end up with the "new" data still being on the device.
> > > It's not super fast, but this is usually a fire and forget sort of thing.  I
> > > could probably integrate this into xfstests for our log-writes tests, those tend
> > > to not generate large logs so wouldn't take super long.  Does this fix the
> > > problem for you Brian?
> > > 
> > 
> > Thanks Josef. At a glance at that script I'm not quite following how
> > this fits together. Are you taking a snapshot of the original device
> > before the workload being tested is run against dm-log-writes, then
> > replaying on top of that? In general, anything that puts the device back
> > into the state from before the workload ran and replays from there
> > should be enough to fix the problem I think. As long as a replay
> > sequence runs in order, I don't think snapshots of each replay point
> > should technically be necessary (vs a single replay snapshot, for e.g.).
> > 
> 
> Well we do this so we can mount/unmount the fs to get the log replay to happen,
> and then run fsck.  We want the snapshot so that we can roll back the changes of
> the log replay.
> 
> > Note that I ended up testing generic/482 with a loop device for a
> > scratch device and that also worked around the problem, I suspect
> > because that allowed the aforementioned discards to actually reset the
> > underlying the device via loop discard->hole punch (which doesn't occur
> > with my original, non-loop scratch dev). So it seems that another option
> > for more deterministic behavior in fstests could be to just enforce the
> > use of a loop device as the underlying target in these particular tests.
> > For example, have the log-writes init create a file on the test device
> > and loop mount that rather than using the scratch device. Just a thought
> > though, it's not clear to me that's any more simple than what you have
> > already implemented here..
> > 
> 
> I'm good either way.  What I've done here isn't simple, it's more meant for my
> long running tests.  Doing loop and discarding the whole device would be cool,
> but I'm afraid of punch hole bugs in the underlying file system making things
> weird, or running on kernels where loop doesn't do punch hole or the fs doesn't
> support punch hole.
> 

True..

> Each solution has its drawbacks.  Adding a bunch of infrastructure to do
> snapshots isn't super awesome, but may be the most flexible.  The loop solution
> has the added benefit of also testing punch hole/discard ;).
> 

As yet another option, it looks like fstests already has thin pool
infrastructure in common/dmthin. I ran the same test using a manually
created thin volume for SCRATCH_DEV instead of a loop device. I see a
performance drop, but no failures so far and the test still runs in the
low-to-mid 200s range, which seems reasonable enough to me.

Brian

> Josef
