Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756494AbdIHNdz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 09:33:55 -0400
Date: Fri, 8 Sep 2017 09:33:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Some questions about per-ag metadata space reservations...
Message-ID: <20170908133353.GA300@bfoster.bfoster>
References: <20170906103054.GR17782@dastard>
 <20170907134457.GC60838@bfoster.bfoster>
 <20170907231136.GA17782@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907231136.GA17782@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

cc Christoph (re: finobt perag reservation)

On Fri, Sep 08, 2017 at 09:11:36AM +1000, Dave Chinner wrote:
> On Thu, Sep 07, 2017 at 09:44:58AM -0400, Brian Foster wrote:
> > On Wed, Sep 06, 2017 at 08:30:54PM +1000, Dave Chinner wrote:
...
> > > When combined with a thinly provisioned device, this enables us to
> > > shrink the XFS filesystem simply by running fstrim to punch all the
> > > free space out of the underlying thin device and then adjusting the
> > > free space down appropriately. Because the thin device abstracts the
> > > physical location of the data in the block device away from the
> > > address space presented to the filesystem, we don't need to move any
> > > data or metadata to free up this space - it's just an accounting
> > > change.
> > > 
> > 
> > How are you dealing with block size vs. thin chunk allocation size
> > alignment? You could require they match, but if not it seems like there
> > could be a bit more involved than an accounting change.
> 
> Not a filesystem problem. If there's less pool space than you let
> the filesystem have, then the pool will ENOSPC before the filesystem
> will. regular fstrim (which you should be doing on thin filesystems
> anyway) will keep them mostly aligned because XFS tends to pack
> holes in AG space rather than continually growing the space they
> use.
> 

I don't see how tracking underlying physical/available pool space in the
filesystem is a filesystem problem but tracking the alignment/size of
those physical allocations is not. It seems to me that either they are
both fs problems or they aren't. This is just a question of accuracy.

I get that the filesystem may return ENOSPC before the pool shuts down
more often than not, but that is still workload dependent. If it's not
important, perhaps I'm just not following what the
objectives/requirements are for this feature.

...
> 
> Based on the commit message, I think the justification for finobt
> reservations was weak and wasn't backed up by analysis as to why the
> reserve block pool was drained (which should never occur in normal
> ENOSPC conditions). The per-ag reserve also requires a walk of every
> finobt at mount time, so there's also mount time regressions for
> filesystems with sparsely populated inode trees.
> 

I agree. I'd be fine with ripping this out in favor of a better
solution. The problem is since we don't have a detailed root cause of
the problem, it's not clear what the right fix is. I'm not sure where
this leaves the user that originally reproduced the problem. Does
bumping the reserve block pool work around the problem? Can we revisit
it to find a more specific root cause? Christoph?

...
> Yes, that's what it does to ensure users get ENOSPC for data
> allocation before we run out of metadata reservation space, even if
> we don't need the metadata reservation space.  It's size is
> physically bound by the AG size so we can calculate it any time we
> know what the AG size is.
> 

Right. So I got the impression that the problem was enforcement of the
reservation. Is that not the case? Rather, is the problem the
calculation of the reservation requirement due to the basis on AG size
(which is no longer valid due to the thin nature)? IOW, the reservations
restrict far too much space and cause the fs to return ENOSPC too
early?

E.g., re-reading your original example.. you have a 32TB fs backed by
1TB of physical allocation to the volume. You mount the fs and see 1TB
"available" space, but ~600GB if that is already consumed by
reservation so you end up at ENOSPC after 300-400GB of real usage. Hm?

If that is the case, then it does seem that dynamic reservation based on
current usage could be a solution in-theory. I.e., basing the
reservation on usage effectively bases it against "real" space, whether
the underlying volume is thin or fully allocated. That seems do-able for
the finobt (if we don't end up removing this reservation entirely) as
noted above. If that would not help your use case, could you elaborate
on why using the finobt example? Of course, I've no idea if that's a
viable approach for the other reservations so it's still just a handwavy
idea.

...
> 
> I was working on the idea that thin filesystems have sufficient
> spare physical space (e.g. logical size < (physical size - max
> metadata reservation) that even when maxxed out there's sufficient
> physical space remaining for all the metadata without needing to
> reserve that space.
> 
> In theory, this /should/ work as the metadata blocks are already
> reserved as used space at mount time and hence the actual allocation
> of those blocks is only accounted against the reservation, not the
> global freespace counter.  Hence these metadata blocks aren't
> counted as used space when they are allocated - they are always
> accounted as used space whether used or not. Hence if I remove the
> "accounted as used space" part of the reservation, but then ensure
> that there is physically enough room for them to always succeed, we
> end up with exactly the same metadata space guarantee.  The only
> difference is how it's accounted and provided....
> 

I'd probably need to see patches to make sure I follow this correctly.
While I'm sure we can ultimately implement whatever accounting tricks we
want, I'm more curious how accuracy is maintained for anything based on
assumptions about how physical space is allocated in the underlying
volume.

> I've written the patches to do this, but I haven't tested it other
> than checking falloc triggers ENOSPC when it's supposed to. I'm just
> finishing off the repair support so I can run it through xfstests.
> That will be interesting. :P
> 
> FWIW, I think there is a good case for storing the metadata
> reservation on disk in the AGF and removing it from user visible
> global free space.  We already account for free space, rmap and
> refcount btree block usage in the AGF, so we already have the
> mechanisms for tracking the necessary per-ag metadata usage outside
> of the global free space counters. Hence there doesn't appear to me
> to be any reason why why we can't do the per-ag metadata
> reservation/usage accounting in the AGF and get rid of the in-memory
> reservation stuff.
> 

Sounds interesting, that might very well be a cleaner implementation of
reservations. The current reservation tracking tends to confuse me more
often than not. ;)

> If we do that, users will end up with exactly the same amount of
> free space, but the metadata reservations are no longer accounted as
> user visible used space.  i.e. the users never need to see the
> internal space reservations we need to make the filesystem work
> reliably. This would work identically for normal filesystems and
> thin filesystems without needing to play special games for thin
> filesystems....
> 

Indeed, though this seems more like a usability enhancement. Couldn't we
accomplish this part by just subtracting the reservations from the total
free space up front (along with whatever accounting changes need to
happen to support that)?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
