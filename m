Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:64239 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753166AbdIIAZq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 20:25:46 -0400
Date: Sat, 9 Sep 2017 10:25:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Some questions about per-ag metadata space reservations...
Message-ID: <20170909002543.GG17782@dastard>
References: <20170906103054.GR17782@dastard>
 <20170907134457.GC60838@bfoster.bfoster>
 <20170907231136.GA17782@dastard>
 <20170908133353.GA300@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170908133353.GA300@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Fri, Sep 08, 2017 at 09:33:54AM -0400, Brian Foster wrote:
> cc Christoph (re: finobt perag reservation)
> 
> On Fri, Sep 08, 2017 at 09:11:36AM +1000, Dave Chinner wrote:
> > On Thu, Sep 07, 2017 at 09:44:58AM -0400, Brian Foster wrote:
> > > On Wed, Sep 06, 2017 at 08:30:54PM +1000, Dave Chinner wrote:
> ...
> > > > When combined with a thinly provisioned device, this enables us to
> > > > shrink the XFS filesystem simply by running fstrim to punch all the
> > > > free space out of the underlying thin device and then adjusting the
> > > > free space down appropriately. Because the thin device abstracts the
> > > > physical location of the data in the block device away from the
> > > > address space presented to the filesystem, we don't need to move any
> > > > data or metadata to free up this space - it's just an accounting
> > > > change.
> > > > 
> > > 
> > > How are you dealing with block size vs. thin chunk allocation size
> > > alignment? You could require they match, but if not it seems like there
> > > could be a bit more involved than an accounting change.
> > 
> > Not a filesystem problem. If there's less pool space than you let
> > the filesystem have, then the pool will ENOSPC before the filesystem
> > will. regular fstrim (which you should be doing on thin filesystems
> > anyway) will keep them mostly aligned because XFS tends to pack
> > holes in AG space rather than continually growing the space they
> > use.
> > 
> 
> I don't see how tracking underlying physical/available pool space in the
> filesystem is a filesystem problem but tracking the alignment/size of
> those physical allocations is not. It seems to me that either they are
> both fs problems or they aren't. This is just a question of accuracy.

The filesystem cannot do anything about the size/alignment of blocks
in the thin device. It gets a hint through stripe alignment, but
other than that we can only track the space the filesystem uses in
the filesystem. In practice XFS tends to pack used space fairly well
over time (unlike ext4) so I'm really not too concerned about this
right now.

If it becomes a problem, then we can analyse it where the problem
lies and work out how to mitigate it. But until we see such problems
that can't be solved with "allow X% size margins" guidelines, I'm
not going to worry about it.

> I get that the filesystem may return ENOSPC before the pool shuts down
> more often than not, but that is still workload dependent. If it's not
> important, perhaps I'm just not following what the
> objectives/requirements are for this feature.

What I'm trying to do is move the first point of ENOSPC in a thin
environment up into the filesystem. ie. you don't manage user space
requirements by thin device sizing - you way, way over commit that
with the devices and instead use the filesystem "thin size" to limit
what the filesystem can draw from the pool.

That way users know exactly how much space they have available and
can plan appropriately, as opposed to the current case where the
first warning they get of the underlying storage running out of
space when they have heaps of free space is "things suddenly stop
working".

If you overcommit the filesystem thin sizes, then it's no different
to overcommiting the thin pool with large devices - the device pool
is going to ENOSPC first. If you don't leave some amount of margin
in the thin fs sizing, then you're going to ENOSPC the device pool.
If you don't leave margin for snapshots, you're going to ENOSPC the
device pool.

IOWs, using the filesystem to control thin space allocation has
exactly the same admin pitfalls as using dm-thinp to manage the pool
space. The only difference is that when the sizes/margins are set
properly then the fs layer ENOSPCs before the thin device pool
ENOSPCs and so we remove that clusterfuck completely from the
picture.

> ...
> > Yes, that's what it does to ensure users get ENOSPC for data
> > allocation before we run out of metadata reservation space, even if
> > we don't need the metadata reservation space.  It's size is
> > physically bound by the AG size so we can calculate it any time we
> > know what the AG size is.
> > 
> 
> Right. So I got the impression that the problem was enforcement of the
> reservation. Is that not the case? Rather, is the problem the
> calculation of the reservation requirement due to the basis on AG size
> (which is no longer valid due to the thin nature)?

No, the physical metadata reservation space is still required. It
just should not be *accounted* to the logical free space.

> IOW, the reservations
> restrict far too much space and cause the fs to return ENOSPC too
> early?

Yes, the initial problem is that the fixed reservations are
dynamically accounted as used space.

> E.g., re-reading your original example.. you have a 32TB fs backed by
> 1TB of physical allocation to the volume. You mount the fs and see 1TB
> "available" space, but ~600GB if that is already consumed by
> reservation so you end up at ENOSPC after 300-400GB of real usage. Hm?

Yup, that's a visible *symptom*. Another user visible symptom is df
on an empty filesystem reports hundreds of GB (TB even!) of used
space on a completely empty filesystem.

> If that is the case, then it does seem that dynamic reservation based on
> current usage could be a solution in-theory. I.e., basing the
> reservation on usage effectively bases it against "real" space, whether
> the underlying volume is thin or fully allocated. That seems do-able for
> the finobt (if we don't end up removing this reservation entirely) as
> noted above.

The finobt case is different to rmap and reflink. finobt should only
require a per-operation reservation to ensure there is space in the
AG to create the finobt record and btree blocks. We do not need a
permanent, maximum sized tree reservation for this - we just need to
ensure all the required space is available in the one AG rather than
globally available before we start the allocation operation.  If we
can do that, then the operation should (in theory) never fail with
ENOSPC...

As for rmap and refcountbt reservations, they have to have space to
allow rmap and CoW operations to succeed when no user data is
modified, and to allow metadata allocations to run without needing
to update every transaction reservation to take into account all the
rmapbt updates that are necessary. These can be many and span
multiple AGs (think badly fragmented directory blocks) and so the
worst case reservation is /huge/ and made upfront worst-case
reservations for rmap/reflink DOA.

So we avoided this entire problem by ensuring we always have space for
the rmap/refcount metadata; using 1-2% of disk space permanently
was considered a valid trade off for the simplicity of
implementation. That's what the per-ag reservations implement and
we even added on-disk metadata in the AGF to make this reservation
process low overhead.

This was all "it seems like the best compromise" design. We
based it on the existing reserve pool behaviour because it was easy
to do. Now that I'm trying to use these filesystems in anger, I'm
tripping over the problems as a result of this choice to base the
per ag metadata reservations on the reserve pool behaviour.

> > I've written the patches to do this, but I haven't tested it other
> > than checking falloc triggers ENOSPC when it's supposed to. I'm just
> > finishing off the repair support so I can run it through xfstests.
> > That will be interesting. :P
> > 
> > FWIW, I think there is a good case for storing the metadata
> > reservation on disk in the AGF and removing it from user visible
> > global free space.  We already account for free space, rmap and
> > refcount btree block usage in the AGF, so we already have the
> > mechanisms for tracking the necessary per-ag metadata usage outside
> > of the global free space counters. Hence there doesn't appear to me
> > to be any reason why why we can't do the per-ag metadata
> > reservation/usage accounting in the AGF and get rid of the in-memory
> > reservation stuff.
> > 
> 
> Sounds interesting, that might very well be a cleaner implementation of
> reservations. The current reservation tracking tends to confuse me more
> often than not. ;)

In hindsight, I think we should have baked the reservation space
fully into the on-disk format rather than tried to make it dynamic
and backwards compatible. i.e. make it completely hidden from the
user and always there for filesystems with those features enabled.

> > If we do that, users will end up with exactly the same amount of
> > free space, but the metadata reservations are no longer accounted as
> > user visible used space.  i.e. the users never need to see the
> > internal space reservations we need to make the filesystem work
> > reliably. This would work identically for normal filesystems and
> > thin filesystems without needing to play special games for thin
> > filesystems....
> > 
> 
> Indeed, though this seems more like a usability enhancement. Couldn't we
> accomplish this part by just subtracting the reservations from the total
> free space up front (along with whatever accounting changes need to
> happen to support that)?

Yes, I had a crazy thought last night that I might be able to do
some in-memory mods to sb_dblocks and sb_fdblocks at mount time to
to adjust how available space and reservations are accounted. I'll
have a bit of a think and a play over the next few days and see what
I come up with.

The testing I've been doing with thin filesystems backs this up -
they are behaving sanely at ENOSPC without accounting for the
metadata reservations in the user visible free space. I'm still
using the metadata reservations to ensure operations have space in
each AG to complete successfully, it's just not consuming user
accounted free space....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
