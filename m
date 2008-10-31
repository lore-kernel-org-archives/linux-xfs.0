Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Oct 2008 17:13:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9V0CuX7028454
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 17:12:56 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7F86A1B6F0E3
	for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 17:12:54 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id LXdqcYoP1DiYiOvG for <xfs@oss.sgi.com>; Thu, 30 Oct 2008 17:12:54 -0700 (PDT)
Date: Fri, 31 Oct 2008 11:12:49 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: do_sync() and XFSQA test 182 failures....
Message-ID: <20081031001249.GM4985@disturbed>
References: <20081030085020.GP17077@disturbed> <20081030224625.GA18690@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030224625.GA18690@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 06:46:25PM -0400, Christoph Hellwig wrote:
> On Thu, Oct 30, 2008 at 07:50:20PM +1100, Dave Chinner wrote:
> > [*] Starting pdflush to sync data in the background when we are
> >     about to start flushing ourselves is self-defeating. instead of
> >     having a single thread doing optimal writeout patterns, we now
> >     have two threads trying to sync the same filesystems and
> >     competing with each other to write out dirty inodes.  This
> >     actually causes bugs in sync because pdflush is doing async
> >     flushes. Hence if pdflush races and wins during the sync flush
> >     part of the sync process, sync_inodes(1) will return before all
> >     the data/metadata is on disk because it can't be found to be
> >     waited on.
> 
> Note that this is an XFS special.  Every other filesystem (at least the
> major ones) rely on the VFS to write out data.

The race is based on which thread removes the remaining
dirty inodes from the sb_s_dirty list - I don't think that is XFS
specific.

> > Now the sync is _supposedly_ complete. But we still have a dirty
> > log and superblock thanks to delayed allocation that may have
> > occurred after the sync_supers() call. Hence we can immediately
> > see that we cannot *ever* do a proper sync of an XFS filesystem
> > in Linux without modifying do_sync() to do more callouts.
> >
> > Worse, XFS can also still have *dirty inodes* because sync_inodes(1)
> > will remove inodes from the dirty list in the async pass, but they
> > can get dirtied a short time later (if they had dirty data) when the
> > data I/O completes. Hence if the second sync pass completes before
> > the inode is dirtied again we'll miss flushing it. This will mean we
> > don't write inode size updates during sync. This is the same race
> > that pdflush running in the background can trigger.
> 
> This is a common problem that would hit any filesystem trying to have
> some sort of ordered data or journaled data mode.
> 
> > However, I have a problem - I'm an expert in XFS, not the other tens
> > of Linux filesystems so I can't begin to guess what the impact of
> > changing do_sync() would be on those many filesystems. How many
> > filesystems would such a change break? Indeed - how many are broken
> > right now by having dirty inodes and superblocks slip through
> > sync(1)?
> 
> I would guess more are broken now then a change in order would break.
> Then again purely a change in order would still leave this code
> fragile as hell.

Right, which is why I want a custom ->do_sync method so I can
*guarantee* that sync works on XFS without fear breaking other
filesystems...

> > What are the alternatives? do_sync() operates above any particular
> > filesystem, so it's hard to provide a filesystem specific ->do_sync
> > method to avoid changing sync order for all filesystems. Do we
> > change do_sync() to completely sync a superblock at a time instead
> > of doing each operation across all superblocks before moving onto
> > the next operation? Is there any particular reason (e.g. performance, locking) for the current
> > method that would prevent changing to completely-sync-a-superblock
> > iteration algorithm so we can provide a custom ->do_sync method?
> 
> Locking can't be the reason as we should never hold locks while
> returning from one of the VFS operations.  I think it's performance
> or rather alledged performance as I think it doesn't really matter.

Ok.

> If it matters however there is an easy method to make it perform just
> as well with a proper callout - just spawn a thread for every filesystem
> to perform it in parallel.

Sure, that will be faster as long as the filesystems are on
separate devices.

As it is, once we have custom ->do_sync, XFS will probably grow
multiple threads per filesystem to sync AGs on independent spindles
in parallel.....

> > Are there any other ways that we can get a custom ->do_sync
> > method for XFS? I'd prefer a custom method so we don't have to
> > revalidate every linux filesystem, especially as XFS already has
> > everything it needs to provide it's own sync method (used for
> > freezing) and a test suite to validate it is working correctly.....
> 
> I think having a method for this would be useful.  And given that
> a proper sync should be exactly the same as a filesysytem freeze
> we should maybe use one method for both of those and use the chance
> to give filesystem better control over the freeze process?

Right - that's exactly where we should be going with this, I think.
I'd suggest two callouts, perhaps: ->sync_data and ->sync_metadata.
The freeze code can then still operate in two stages, and we can
also use then for separating data and inode writeback in pdflush....

FWIW, I mentioned doing this sort of thing here:

http://xfs.org/index.php/Improving_inode_Caching#Avoiding_the_Generic_pdflush_Code

I think I'll look at redoing do_sync() to provide a custom sync
method before trying to fix XFS....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
