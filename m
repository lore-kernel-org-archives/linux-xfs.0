Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:59081 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751365AbdIGXLk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Sep 2017 19:11:40 -0400
Date: Fri, 8 Sep 2017 09:11:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Some questions about per-ag metadata space reservations...
Message-ID: <20170907231136.GA17782@dastard>
References: <20170906103054.GR17782@dastard>
 <20170907134457.GC60838@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907134457.GC60838@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Sep 07, 2017 at 09:44:58AM -0400, Brian Foster wrote:
> On Wed, Sep 06, 2017 at 08:30:54PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > I've got a bit of a problem with the per-ag reservations we are
> > using at the moment. The existance of them is fine, but the
> > implementation is problematic for something I'm working on right
> > now.
> > 
> > I've been making a couple of mods to the filesystem to separate
> > physical space accounting from free space accounting to allow us to
> > optimise the filesystem for thinly provisioned devices. That is,
> > the filesystem is laid out as though it is the size of the
> > underlying device, but then free space is artificially limited. i.e.
> > we have a "physical size" of the filesystem and a "logical size"
> > that limits the amount of data and metadata that can actually be
> > stored in it.
> > 
> 
> Interesting...
> 
> > When combined with a thinly provisioned device, this enables us to
> > shrink the XFS filesystem simply by running fstrim to punch all the
> > free space out of the underlying thin device and then adjusting the
> > free space down appropriately. Because the thin device abstracts the
> > physical location of the data in the block device away from the
> > address space presented to the filesystem, we don't need to move any
> > data or metadata to free up this space - it's just an accounting
> > change.
> > 
> 
> How are you dealing with block size vs. thin chunk allocation size
> alignment? You could require they match, but if not it seems like there
> could be a bit more involved than an accounting change.

Not a filesystem problem. If there's less pool space than you let
the filesystem have, then the pool will ENOSPC before the filesystem
will. regular fstrim (which you should be doing on thin filesystems
anyway) will keep them mostly aligned because XFS tends to pack
holes in AG space rather than continually growing the space they
use.

.....
> > For a normal filesystem, there's no problem with doing this brute
> > force physical reservation, though it is slightly disconcerting to
> > see a new, empty 100TB filesystem say it's got 2TB used and only
> > 98TB free...
> > 
> 
> Ugh, I think the reservation requirement there is kind of insane. We
> reserve 1GB out of a 1TB fs just for finobt (13GB for rmap and 6GB for
> reflink), most of which will probably never be used.

Yeah, the reservations are large, but the rmap/reflink ones are
necessary. I don't think finobt should use this mechanism - it
should not require more than a few blocks for any given inode chunk
allocation, and they should stop pretty quickly if the finobt blocks
are having to work around ENOSPC conditions by dipping into the
reserve pool.

> I'm not a big fan of this approach. I think the patch was originally
> added because there was some unknown workload that reproduced a finobt
> block allocation failure and filesystem shutdown that couldn't be
> reproduced independently, hence the overkill reservation. I'd much
> prefer to see if we can come up with something that is more dynamic in
> nature.

Based on the commit message, I think the justification for finobt
reservations was weak and wasn't backed up by analysis as to why the
reserve block pool was drained (which should never occur in normal
ENOSPC conditions). The per-ag reserve also requires a walk of every
finobt at mount time, so there's also mount time regressions for
filesystems with sparsely populated inode trees.

> For example, the finobt cannot be larger than the inobt. If we mount a
> 1TB fs with one inode chunk allocated in the fs, there is clearly no
> immediate risk for the finobt to grow beyond a single block until more
> inodes are allocated. I'm wondering if we could come up with something
> that grows and shrinks the reservation as needed based on the size delta
> between the inobt/finobt and rather than guarantee we can always create
> a maximum size finobt, guarantee that the finobt can always grow to the
> size of the inobt. I suppose this might require some clever accounting
> tricks on finobt block allocation/free and some estimation at mount time
> of an already populated fs. I've also not really gone through the per-AG
> reservation stuff since it was originally reviewed, so this is all
> handwaving atm.
> 
> Anyways, I think it would be nice if we could improve these reservation
> requirements first and foremost, though I'm not sure I understand
> whether that would address your issue...

No, it doesn't really. Unless they are brought down to the size of
the existing reserve pool, it's going to be an issue....

> > The issue is that for a thin filesystem, this space reservation
> > come out of the *logical* free space, not the physical free space.
> > With 1TB of thin space, we've got 31TB of /physical free space/ the
> > reservation can be taken out of without the user ever seeing it. The
> > question is this: how on earth do I do this?
> > 
> 
> Hmm, so is the issue that the reservations aren't accounted out of
> whatever counters you're using to artificially limit block allocation?

No, the issue is that they are being accounted out of the existing
freespace counters. They are a persistent reservation
that will always be present. However, rather than hiding this
unusable space from users, we simply pull it from free space.

> I'm a little confused.. ISTM that if you have a 32TB fs and have
> artificially limited the free block accounting to 1TB based on available
> physical space, the reservation accounting needs to be accounted against
> that same artificially limited pool.  IOW, it looks like the perag res
> code eventually calls xfs_mod_fdblocks() just the same as we would for a
> delayed allocation. Can you elaborate a bit on how your updated
> accounting works and how it breaks this model?

Yes, that's what it does to ensure users get ENOSPC for data
allocation before we run out of metadata reservation space, even if
we don't need the metadata reservation space.  It's size is
physically bound by the AG size so we can calculate it any time we
know what the AG size is.

> > I want the available space to match the "thin=size" value on the
> > mkfs command line, but I don't want metadata reservations to take
> > away from this space. metadata allocations need to be accounted to
> > the available space, but the reservations should not be. So how
> > should I go about providing these reservations? Do we even need them
> > to be accounted against free space in this case where we control the
> > filesysetm free blocks to be a /lot/ less than the physical space?
> > 
> 
> I don't understand how you'd guarantee availability of physical blocks
> for metadata if you don't account metadata block reservations out of the
> (physically) available free space. ISTM the only way around that is to
> eliminate the requirement for a reservation in the first place (i.e.,
> allocate physical blocks up front or something like that).

I was working on the idea that thin filesystems have sufficient
spare physical space (e.g. logical size < (physical size - max
metadata reservation) that even when maxxed out there's sufficient
physical space remaining for all the metadata without needing to
reserve that space.

In theory, this /should/ work as the metadata blocks are already
reserved as used space at mount time and hence the actual allocation
of those blocks is only accounted against the reservation, not the
global freespace counter.  Hence these metadata blocks aren't
counted as used space when they are allocated - they are always
accounted as used space whether used or not. Hence if I remove the
"accounted as used space" part of the reservation, but then ensure
that there is physically enough room for them to always succeed, we
end up with exactly the same metadata space guarantee.  The only
difference is how it's accounted and provided....

I've written the patches to do this, but I haven't tested it other
than checking falloc triggers ENOSPC when it's supposed to. I'm just
finishing off the repair support so I can run it through xfstests.
That will be interesting. :P

FWIW, I think there is a good case for storing the metadata
reservation on disk in the AGF and removing it from user visible
global free space.  We already account for free space, rmap and
refcount btree block usage in the AGF, so we already have the
mechanisms for tracking the necessary per-ag metadata usage outside
of the global free space counters. Hence there doesn't appear to me
to be any reason why why we can't do the per-ag metadata
reservation/usage accounting in the AGF and get rid of the in-memory
reservation stuff.

If we do that, users will end up with exactly the same amount of
free space, but the metadata reservations are no longer accounted as
user visible used space.  i.e. the users never need to see the
internal space reservations we need to make the filesystem work
reliably. This would work identically for normal filesystems and
thin filesystems without needing to play special games for thin
filesystems....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
