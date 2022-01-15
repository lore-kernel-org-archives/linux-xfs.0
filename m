Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB04BC433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 15 Jan 2022 04:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbiAOEJs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Jan 2022 23:09:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54438 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbiAOEJs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jan 2022 23:09:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B502660ABE
        for <linux-xfs@vger.kernel.org>; Sat, 15 Jan 2022 04:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AE4C36AE7;
        Sat, 15 Jan 2022 04:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642219787;
        bh=i34apViF1IV1ym+jkpz171xSuAWj+A6wftopVjryACA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lzYPLBSDkuAuU0HReWIRM5gy5MDGcrQiTd9ZLXWngy2BWWyJVNwb86PBNIq0sL1lI
         u1SCZvti/WIqHwp2tm75yOPYOUlGsM7bBpP1hxkzmpr8GWqu/dN55eYrIO+xP6W0pf
         DYGxV3IvQ7soa7hqMhrKdUF5u3Q9PzpqL7MGp2WbyCmy4zglPAiQg+NE/tapveZHFE
         N+WhUkY+SlvzBIi3x6ePE1pl3auqyyd6/N7Gy//5GxRUkF5KEUPXGQRlWDHHlXn8lk
         zviQxp8NxDMAftpnFspZkyEImKYdw138dAhAdOI7x5QzKzGVTMetX+U+L52fS8ZDX+
         IyxcLMeBdqmeQ==
Date:   Fri, 14 Jan 2022 20:09:46 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: run blockgc on freeze to avoid iget stalls
 after reclaim
Message-ID: <20220115040946.GC90423@magnolia>
References: <20220113133701.629593-1-bfoster@redhat.com>
 <20220113133701.629593-3-bfoster@redhat.com>
 <20220113223810.GG3290465@dread.disaster.area>
 <20220114173535.GA90423@magnolia>
 <YeHSxg3HrZipaLJg@bfoster>
 <20220114213043.GB90423@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220114213043.GB90423@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 14, 2022 at 01:30:43PM -0800, Darrick J. Wong wrote:
> On Fri, Jan 14, 2022 at 02:45:10PM -0500, Brian Foster wrote:
> > On Fri, Jan 14, 2022 at 09:35:35AM -0800, Darrick J. Wong wrote:
> > > On Fri, Jan 14, 2022 at 09:38:10AM +1100, Dave Chinner wrote:
> > > > On Thu, Jan 13, 2022 at 08:37:01AM -0500, Brian Foster wrote:
> > > > > We've had reports on distro (pre-deferred inactivation) kernels that
> > > > > inode reclaim (i.e. via drop_caches) can deadlock on the s_umount
> > > > > lock when invoked on a frozen XFS fs. This occurs because
> > > > > drop_caches acquires the lock and then blocks in xfs_inactive() on
> > > > > transaction alloc for an inode that requires an eofb trim. unfreeze
> > > > > then blocks on the same lock and the fs is deadlocked.
> > > > > 
> > > > > With deferred inactivation, the deadlock problem is no longer
> > > > > present because ->destroy_inode() no longer blocks whether the fs is
> > > > > frozen or not. There is still unfortunate behavior in that lookups
> > > > > of a pending inactive inode spin loop waiting for the pending
> > > > > inactive state to clear, which won't happen until the fs is
> > > > > unfrozen. This was always possible to some degree, but is
> > > > > potentially amplified by the fact that reclaim no longer blocks on
> > > > > the first inode that requires inactivation work. Instead, we
> > > > > populate the inactivation queues indefinitely. The side effect can
> > > > > be observed easily by invoking drop_caches on a frozen fs previously
> > > > > populated with eofb and/or cowblocks inodes and then running
> > > > > anything that relies on inode lookup (i.e., ls).
> > > > > 
> > > > > To mitigate this behavior, invoke internal blockgc reclaim during
> > > > > the freeze sequence to guarantee that inode eviction doesn't lead to
> > > > > this state due to eofb or cowblocks inodes. This is similar to
> > > > > current behavior on read-only remount. Since the deadlock issue was
> > > > > present for such a long time, also document the subtle
> > > > > ->destroy_inode() constraint to avoid unintentional reintroduction
> > > > > of the deadlock problem in the future.
> > > > > 
> > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > ---
> > > > >  fs/xfs/xfs_super.c | 19 +++++++++++++++++--
> > > > >  1 file changed, 17 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > > index c7ac486ca5d3..1d0f87e47fa4 100644
> > > > > --- a/fs/xfs/xfs_super.c
> > > > > +++ b/fs/xfs/xfs_super.c
> > > > > @@ -623,8 +623,13 @@ xfs_fs_alloc_inode(
> > > > >  }
> > > > >  
> > > > >  /*
> > > > > - * Now that the generic code is guaranteed not to be accessing
> > > > > - * the linux inode, we can inactivate and reclaim the inode.
> > > > > + * Now that the generic code is guaranteed not to be accessing the inode, we can
> > > > > + * inactivate and reclaim it.
> > > > > + *
> > > > > + * NOTE: ->destroy_inode() can be called (with ->s_umount held) while the
> > > > > + * filesystem is frozen. Therefore it is generally unsafe to attempt transaction
> > > > > + * allocation in this context. A transaction alloc that blocks on frozen state
> > > > > + * from a context with ->s_umount held will deadlock with unfreeze.
> > > > >   */
> > > > >  STATIC void
> > > > >  xfs_fs_destroy_inode(
> > > > > @@ -764,6 +769,16 @@ xfs_fs_sync_fs(
> > > > >  	 * when the state is either SB_FREEZE_FS or SB_FREEZE_COMPLETE.
> > > > >  	 */
> > > > >  	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT) {
> > > > > +		struct xfs_icwalk	icw = {0};
> > > > > +
> > > > > +		/*
> > > > > +		 * Clear out eofb and cowblocks inodes so eviction while frozen
> > > > > +		 * doesn't leave them sitting in the inactivation queue where
> > > > > +		 * they cannot be processed.
> > > > > +		 */
> > > > > +		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
> > > > > +		xfs_blockgc_free_space(mp, &icw);
> > > > 
> > > > Is a SYNC walk safe to run here? I know we run
> > > > xfs_blockgc_free_space() from XFS_IOC_FREE_EOFBLOCKS under
> > > > SB_FREEZE_WRITE protection, but here we have both frozen writes and
> > > > page faults we're running in a much more constrained freeze context
> > > > here.
> > > > 
> > > > i.e. the SYNC walk will keep busy looping if it can't get the
> > > > IOLOCK_EXCL on an inode that is in cache, so if we end up with an
> > > > inode locked and blocked on SB_FREEZE_WRITE or SB_FREEZE_PAGEFAULT
> > > > for whatever reason this will never return....
> > > 
> > > Are you referring to the case where one could be read()ing from a file
> > > into a buffer that's really a mmap'd page from another file while the
> > > underlying fs is being frozen?
> > > 
> > 
> > I thought this was generally safe as freeze protection sits outside of
> > the locks, but I'm not terribly sure about the read to a mapped buffer
> > case. If that allows an iolock holder to block on a pagefault due to
> > freeze, then SB_FREEZE_PAGEFAULT might be too late for a synchronous
> > scan (i.e. assuming nothing blocks this earlier or prefaults/pins the
> > target buffer)..?
> 
> I think so.  xfs_file_buffered_read takes IOLOCK_SHARED and calls
> filemap_read, which calls copy_page_to_iter.  I /think/ the messy iovec
> code calls copyout, which can then hit a write page fault, which takes
> us to __xfs_filemap_fault.  That takes SB_PAGEFAULT, which is the
> opposite order of what now goes on during a freeze.
> 
> > > Also, I added this second patch and fstests runtime went up by 30%.
> > > ISTR Dave commenting that freeze time would go way up when I submitted a
> > > patch to clean out the cow blocks a few years ago.
> > > 
> > 
> > Do you have any more detailed data on this? I.e., is this an increase
> > across the board? A smaller set of tests doing many freezes with a
> > significant runtime increase?
> 
> I think it's constrained to tests that run freeze and thaw in a loop,
> but the increases in those tests are large.
> 
> Here's what I see when I run all the tests that mention 'freeze' before
> applying the patch:
> 
> generic/068      46s
> generic/085      9s
> generic/280      2s
> generic/311      53s
> generic/390      3s
> generic/459      15s
> generic/491      2s
> xfs/006  8s
> xfs/011  20s
> xfs/119  6s
> xfs/264  13s
> xfs/297  42s
> xfs/318  2s
> xfs/325  2s
> xfs/438  4s
> xfs/517  46s
> 
> And here's after:
> 
> generic/068      47s
> generic/085      17s
> generic/280      4s
> generic/311      81s
> generic/390      4s
> generic/459      14s
> generic/491      2s
> xfs/006  9s
> xfs/011  21s
> xfs/119  11s
> xfs/264  18s
> xfs/297  31s
> xfs/318  3s
> xfs/325  2s
> xfs/438  5s
> xfs/517  46s
> 
> Most of those tests run in more or less the same amount of time, except
> for generic/085, generic/311, xfs/119, xfs/264, and xfs/297.  Of those,
> they all freeze repeatedly except for xfs/119.
> 
> I would imagine that the same thing is going on with tests that touch
> device-mapper, since a dm suspend also freezes the fs, but I didn't
> check those tests all that thoroughly, since most of the dmerror /
> dmflakey tests only switch the dm table once or twice per test.
> 
> > I'm a little on the fence about this because personally, I'm not
> > terribly concerned about the performance of a single freeze call. At the
> > same time, I could see this adding up across hundreds of cycles or
> > whatever via a test or test suite, and that being potentially annoying
> > to devs/testers.
> 
> Well... yeah.  The net effect on djwong-dev is that a -g all test run
> went from 3.6h to 4.8h.  It was less bad for tip (2.8 to 3h).

...and just to undercut my own statements, it seems that CONFIG_LOCKDEP
got turned on somehow between a kernel from a couple of days ago and
when I rebuilt it with the new patches.  The overall fstests slowdowns
are more on the level of 3.6 to 3.7h and 2.8 to 2.9h, though the runtime
increases of the fsfreeze loop tests are about the same.

--D

> > > Also also looking through the archives[1], Brian once commented that
> > > cleaning up all this stuff should be done /if/ one decides to mount the
> > > frozen-snapshot writable at some later point in time.
> > > 
> > 
> > That kind of sounds like the tradeoff of impacting the current/active fs
> > for the benefit of a snapshot that may or may not be used. If not, then
> > it's a waste of time. If so, it might be beneficial for the snap to more
> > accurately reflect the "eventual" state of the original. For cowblocks
> > perhaps it doesn't matter if the mount/recovery will scan and reclaim.
> > I'm not as sure for eofblocks, wouldn't the snap persist all that
> > "intended to be transient" speculative prealloc until/unless said files
> > are reopened/closed?
> 
> Yes, that is the current behavior. :)
> 
> I don't know if it's really optimal (it's at least lazy :P) and Eric has
> tried to shift the balance away from "xfs snapshots take forever to
> mount".
> 
> > > Maybe this means we ought to find a way to remove inodes from the percpu
> > > inactivation lists?  iget used to be able to pry inodes out of deferred
> > > inactivation...
> > > 
> > 
> > Seems a reasonable option. Presumably that mitigates the lookup stalling
> > behavior without the need for any additional scanning work at freeze
> > time (and maybe eliminates the need for an inodegc flush too), but is
> > neutral wrt some of the other tradeoffs (like the above). I think the
> > former is the big question wrt to deferred inactivation whereas the
> > latter has been the case forever.
> > 
> > BTW, should we care at all about somebody dropping the entire cached
> > working set (worst case) onto these queues if the fs is frozen? Maybe
> > not if we have to cycle through all these inodes anyways for a full
> > working set eviction, and presumably a large evictor task (i.e.
> > drop_caches) will minimize the percpu queue distribution...
> 
> I've wondered myself if we really need to dump quite so many inodes onto
> the inactivation queue while we're frozen.  For posteof blocks we could
> just leave them attached and hope that inactivation eventually gets
> them, though that has the unfortunate side effect that space can
> disappear into the depths.
> 
> COW mappings are attached incore to the inode cow fork but the refcount
> btree ondisk, so in principle for frozen inodes we could move the cow
> mappings to an internal bitmap, let the inode go, and free the abandoned
> cow blocks at thaw time.
> 
> Unlinked inodes with no active refcount can of course block in the queue
> forever; userspace can't have those back.
> 
> --D
> 
> > 
> > Brian
> > 
> > > [1] https://lore.kernel.org/linux-xfs/20190117181406.GF37591@bfoster/
> > > 
> > > --D
> > > 
> > > > Cheers,
> > > > 
> > > > Dave.
> > > > -- 
> > > > Dave Chinner
> > > > david@fromorbit.com
> > > 
> > 
