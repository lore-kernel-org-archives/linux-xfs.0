Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:15063
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751599AbdIOBEa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Sep 2017 21:04:30 -0400
Date: Fri, 15 Sep 2017 11:03:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Some questions about per-ag metadata space reservations...
Message-ID: <20170915010322.GZ17782@dastard>
References: <20170906103054.GR17782@dastard>
 <20170907134457.GC60838@bfoster.bfoster>
 <20170907231136.GA17782@dastard>
 <20170908133353.GA300@bfoster.bfoster>
 <20170909002543.GG17782@dastard>
 <20170911132608.GC9135@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170911132608.GC9135@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

On Mon, Sep 11, 2017 at 09:26:08AM -0400, Brian Foster wrote:
> On Sat, Sep 09, 2017 at 10:25:43AM +1000, Dave Chinner wrote:
> > On Fri, Sep 08, 2017 at 09:33:54AM -0400, Brian Foster wrote:
> > > If that is the case, then it does seem that dynamic reservation based on
> > > current usage could be a solution in-theory. I.e., basing the
> > > reservation on usage effectively bases it against "real" space, whether
> > > the underlying volume is thin or fully allocated. That seems do-able for
> > > the finobt (if we don't end up removing this reservation entirely) as
> > > noted above.
> > 
> > The finobt case is different to rmap and reflink. finobt should only
> > require a per-operation reservation to ensure there is space in the
> > AG to create the finobt record and btree blocks. We do not need a
> > permanent, maximum sized tree reservation for this - we just need to
> > ensure all the required space is available in the one AG rather than
> > globally available before we start the allocation operation.  If we
> > can do that, then the operation should (in theory) never fail with
> > ENOSPC...
> > 
> 
> I'm not familiar with the workload that motivated the finobt perag
> reservation stuff, but I suspect it's something that pushes an fs (or
> AG) with a ton of inodes to near ENOSPC with a very small finobt, and
> then runs a bunch of operations that populate the finobt without freeing
> up enough space in the particular AG.

That's a characteristic of a hardlink backup farm. And, in new-skool
terms, that's what a reflink- or dedupe- based backup farm will look
like, too. i.e. old backups get removed freeing up inodes, but no
data gets freed so the only new free blocks are the directory blocks
that are no longer in use...

> I suppose that could be due to
> having zero sized files (which seems pointless in practice), sparsely
> freeing inodes such that inode chunks are never freed, using the ikeep
> mount option, and/or otherwise freeing a bunch of small files that only
> free up space in other AGs before the finobt allocation demand is made.

Yup, all of those are potential issues....

> The larger point is that we don't really know much of anything to try
> and at least reason about what the original problem could have been, but
> it seems plausible to create the ENOSPC condition if one tried hard
> enough.

*nod*. i.e. if you're not freeing data, then unlinking dataless
inodes may not succeed at ENOSPC. I think we can do better than what
we currently do, though. e.g. we can simply dump them on the
unlinked list and process them when there is free space to
create the necessary finobt btree blocks to index them rather than
as soon as the last VFS reference goes away (i.e. background
inode freeing).

> > As for rmap and refcountbt reservations, they have to have space to
> > allow rmap and CoW operations to succeed when no user data is
> > modified, and to allow metadata allocations to run without needing
> > to update every transaction reservation to take into account all the
> > rmapbt updates that are necessary. These can be many and span
> > multiple AGs (think badly fragmented directory blocks) and so the
> > worst case reservation is /huge/ and made upfront worst-case
> > reservations for rmap/reflink DOA.
> > 
> > So we avoided this entire problem by ensuring we always have space for
> > the rmap/refcount metadata; using 1-2% of disk space permanently
> > was considered a valid trade off for the simplicity of
> > implementation. That's what the per-ag reservations implement and
> > we even added on-disk metadata in the AGF to make this reservation
> > process low overhead.
> > 
> > This was all "it seems like the best compromise" design. We
> > based it on the existing reserve pool behaviour because it was easy
> > to do. Now that I'm trying to use these filesystems in anger, I'm
> > tripping over the problems as a result of this choice to base the
> > per ag metadata reservations on the reserve pool behaviour.
> > 
> 
> Got it. FWIW, what I was handwaving about sounds like more of a
> compromise between what we do now (worst case res, user visible) and
> what it sounds like you're working towards (worst case res, user
> invisible). By that I mean that I've been thinking about the problem
> more from the angle of whether we can avoid the worst case reservation.
> The reservation itself could still be made visible or not either way. Of
> course, it sounds like changing the reservation requirement for things
> like the rmapbt would be significantly more complicated than for the
> finobt, so "hiding" the reservation might be the next best tradeoff.

Yeah, and having done that I'm tripping over the next issue: it's
possible for the log to be larger than than thin space, so I think
I'm going to have to cut that out of visible used space, too....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
