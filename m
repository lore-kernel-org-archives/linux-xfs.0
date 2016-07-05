Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 828607CD3
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 08:42:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 53CAA304032
	for <xfs@oss.sgi.com>; Tue,  5 Jul 2016 06:42:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id khLMfLnKvrIU7wzF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jul 2016 06:42:35 -0700 (PDT)
Date: Tue, 5 Jul 2016 09:42:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: add readahead bufs to lru early to prevent
	post-unmount panic
Message-ID: <20160705134232.GA56444@bfoster.bfoster>
References: <1467291229-13548-1-git-send-email-bfoster@redhat.com>
	<20160630224457.GT12670@dastard>
	<20160630235621.GA44823@bfoster.bfoster>
	<20160701043331.GV12670@dastard>
	<20160701125303.GA1098@laptop.bfoster>
	<20160704000838.GW12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160704000838.GW12670@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 04, 2016 at 10:08:38AM +1000, Dave Chinner wrote:
> On Fri, Jul 01, 2016 at 08:53:03AM -0400, Brian Foster wrote:
> > On Fri, Jul 01, 2016 at 02:33:31PM +1000, Dave Chinner wrote:
> > > On Thu, Jun 30, 2016 at 07:56:21PM -0400, Brian Foster wrote:
> > > Note also that buffers that contain stale data (i.e. XBF_STALE) are
> > > not added to the LRU and xfs_buf_stale() removes buffers from the
> > > LRU, so shortcutting the above reclaim lifecycle in the case where a
> > > user invalidates the contents of the buffer. The end result is the
> > > same - there are no buffers with stale contents on the LRU.
> > > 
> > 
> > Yes, but this seems arbitrary. The buffer may or may not be on the LRU
> > when it is marked stale.
> 
> Yes, because (as I've already explained) we can mark buffers stale
> without needing to fill them with data. But whether or not the
> buffer is in the LRU when we mark it stale is irrelevant, because we
> only have a requirement that stale buffers are removed from the LRU
> so that they are torn down immediately on release.
> 
> This is actually very important because this is how we prevent
> duplicate buffers from entering the cache when we free metadata.
> Once we free a metadata buffer and finish committing the transaction,
> the buffer must not be kept in the cache because the extent it
> covers could be reallocated at any time, and in a different shape.
> It could even be user data. In all cases, the buffer needs to be
> removed from the cache immediately, and that's why xfs_buf_stale()
> behaves like this.
> 

Yes, I understand. I think we're talking past eachother on this
particular train of thought. Your original point was that the LRU is for
"unused" buffers, and/or buffers aren't on the LRU until "their content
is used." The example given was that stale buffers are immediately
removed from the LRU and thus "buffers with stale data are never on the
LRU."

My response to that is that's an implementation detail of XBF_STALE
buffers and not necessarily true in other cases. We do actually end up
with buffers with "stale" (as opposed to XBF_STALE, perhaps "invalid" is
a better term) data in the event of I/O error. If a callsite allocates a
buffer, never issues I/O on it (i.e., it is !XBF_DONE) and releases it,
it ends up on the LRU. (I don't know that we do that anywhere given this
is a filesystem after all ;), but that's the natural lifecycle in that
particular case afaict).

So nothing about the LRU suggests to me that the contents must have
valid data. AFAICT, it's primarily memory management mechanism to allow
priority-ordered releasing of "unused" buffers, where an unused buffer
is defined as a buffer without any active references, regardless of what
the buffer contains.

I'm sympathetic to the argument that in the ideal case the LRU might not
contain buffers actively in use, but IMO that's beyond the scope of the
original patch. IOW, if we want to change that, we should approach it
separately.

> > > readahead is a special case - there is no accessor to say "cache
> > > this buffer for N references", but we have to keep it around for
> > > some time so that readahead is effective. We don't want to add it
> > > before we've done IO on it, and realistically we should only add it
> > > to the LRU if there was no IO error. We've had to work around bugs
> > > introduced by caching failed readahead buffers on the LRU in the
> > > past....
> > > 
> > 
> > Ok, that makes sense. At least, I get the sense that you have a view of
> > the LRU that is slightly different from what the code actually does
> > (e.g., buffers w/ I/O errors on the LRU when they shouldn't be), which
> > is why I'm trying to reconcile some of the reasoning here.
> > 
> > In other words, if the LRU was an unused only buffer list where used or
> > stale buffers were pulled off and later reinserted/reprioritized (in
> > terms of reclaim), then this would all make complete sense to me. In
> > actuality, we have an LRU list that has buffers with I/O errors, buffers
> > in use, buffers that might or might not be stale, etc.
> 
> Nothing is as simple as it seems - clean design never remains that
> way once reality intrudes. However, the general rule is that buffers are not added to the LRU until the initial
> user has finished and release them. THis is done for many reasons.
> 

Agreed on the first point. :) I think that's the only reason for the
original patch to exist. ;) (As noted previously, I agree that it is a
hack).

> Firstly, We do not add them a lookup time because we do not know if
> the caller wants them to be added to the LRU.
> 

We set b_lru_ref to 1 on buffer allocation. But it's true that we don't
know if it's going to be marked stale before it is released, of course.

> Secondly, we also don't add at lookup time because buffer lookup is
> the single hottest path in the XFS codebase. i.e.  xfs_buf_find()
> and the struct xfs_buf are one of the few places where we've
> actually optimised the code to minimise cache footprint and CPU
> overhead.
> 

Ok...

> Currently, all of th einformation that a buffer lookup
> accesses is in the first cacheline of the struct xfs_buf, ensuring
> that we only take one cache miss penalty per buffer we walk through
> the rb-tree. If we now add a check to see if the buffer is on the
> LRU into the lookup path, we are - at minimum - adding an extra
> cacheline miss to the hot path. If we have to add the buffer to the
> LRU, then we're adding another couple of cacheline misses and
> another lock, all of which will have an impact on performance.
> 

Performance is a fair point against adding all buffers to the LRU
immediately. I take that to mean we'd have to test such a change with
that in mind, but it sounds like this path is already optimized without
any more room in the first cacheline, thus probably not likely to be an
option.

I'm not sure this is as as critical applied solely to read ahead
buffers, however...

> THird, we add/remove buffers to/from the LRU lazily in paths that
> are not performance critical as a result. This is exactly the same
> algorithms the VFS uses for the inode and dentry cache LRUs, and we
> also use this for the XFS dquot LRU, too. The b_lru_ref count
> replaces the single referenced flag that the inode/dentry caches use
> so we can prioritise reclaim to match typical btree and directory
> access patterns (i.e. reclaim data before leaf before node before
> root) but otherwise the buffer LRU is no different to the VFS cache
> algorithms....
> 
> Finally, and perhaps the most important, is behaviour under low memory
> conditions. If we add the buffer to the LRU when we first look it up
> in the cache, the shrinker can now see it and decrement the
> b_lru_ref count while we are doing the first operation on that
> buffer. Say this transaction generates sufficient memory pressure
> that it causes the shrinker to completely decrement b_lru_ref - it
> will then remove the buffer from the LRU *before we've even finished
> with it*. This will cause the buffer to be freed immediately after
> the caller releases it (because b_lru_ref is zero), and so the next
> access requires the buffer to be read from disk again.  What we end
> up with here is a situation where the buffer cache cannot maintian a
> working set of buffers between operations because the memory
> pressure within an operation causes the buffers to be removed from
> the LRU before the operation completes.
> 

This makes sense, we probably don't want to subject active buffers to
deprioritization via the shrinker before their initial use. It sounds
like this could technically be a flaw for buffers once they're actually
reused, as well. I could see an argument for reused buffers remaining on
the LRU such that their b_lru_ref remains consistent (in terms of
priority) with associated buffers (e.g., btree node vs. leaf priority
ordering) in the event of shrinker activity, but it seems like there are
other ways for that to get out of sync just the same. It could also be
the case that such buffers tend to be "held" together.

Again, I'm not sure how important this is to readahead buffers since
they are released on I/O completion. If we're waiting on the readahead
before it completes then the buffer is not fully released, but that's a
matter of timing more than anything. E.g., faster storage could disrupt
that just as much as this particular change. Otherwise, this just means
the readahead buffer could be freed before we try to use it, which is
already the case today.

> So, yeah, there's lots of "assumed knowledge" in why the buffer
> cache LRU is structured the way it is. That, unfortunately, is
> pretty much typical of all the linux slab caches that are controlled
> by shrinkers....
> 
> FWIW, readahead is often not complete before the followup read
> comes in, which means there's a caller blocked on the buffer with an
> active reference by the time IO completion runs xfs_buf_relse() to
> unlock the buffer. In these cases, the readahead buffer does not go
> onto the LRU until after the blocked caller has finished with the
> buffer and called xfs_buf_rele() itself (i.e. after the transaction
> subsystem is done with it).
> 
> > > > The other thought I had was to change where buffers are added
> > > > to the LRU altogether, but didn't want to jump right to that.
> > > > Is there any issue with populating the LRU with initially held
> > > > buffers as such, or any particular reason LRU addition was
> > > > deferred to I/O completion in the first place?
> > > 
> > > Yes, because then we have to deal with buffers that fail memory
> > > allocation, read IO or are allocated just to invalidate a range
> > > of disk blocks during a transaction (e.g. removing a remote
> > > attribute).  There are probably other cases where we don't want
> > > to put buffers we allocate onto the LRU, but I can't think of
> > > any more right now.
> > 
> > I was thinking more along the lines of insertion on I/O submission
> > rather than allocation. I.e., similar the proposed #1 below, but
> > to actually insert to the list such that we never lose track of
> > the buffer.
> 
> Why do we need a list?
> 

I was referring to the LRU.

> It's a similar situation to inode_dio_wait(): we don't track direct
> IO because of the per-IO overhead of doing so, especially as we only
> need to implement a "drain barrier". i.e. it only needs a counter to
> implement the barrier needed for truncate/hole punch operations.
> That's exactly the same case here xfs_wait_buftarg() is a drain
> barrier; we could simply count every single IO in flight and wait
> for that to return to zero before walking the LRU, and it would
> solve the problem for everything, regardless of the type of buffer
> or whether it is in or going to be put in the LRU....
> 
> Also, remember that xfs_wait_buftarg() is run with the assumption
> that all high level processing has been stopped, and we are only
> waiting for remaining users to drop their locks and go away (e.g.
> complete async IO from AIL pushing). It's not a general use case we
> are working on here...
> 
> > I guess my initial approach was to make the fix as isolated as possible
> > because this code is hairy and it seems we have a lot of little hacks
> > around to deal with other corner cases such as this. Surely this adds
> > yet another one, but afaics, so does a counter mechanism. At the end of
> > the day, the only real issue we know it fixes is this readahead corner
> > case.
> > 
> > I think that if we're going to go as far as adding a list/counter
> > mechanism, we should try to fix this in a way that is more broadly
> > useful. By that I mean fix up the existing mechanism or add something
> > that allows us to start unwinding some of the preexisting hacks such as
> > cycling buffer locks to ensure I/O completion (perhaps alleviating the
> > need to hold locks across I/O in the first place), etc.
> > 
> > Perhaps the counter approach opens the door for that, I have to think
> > about it some more..
> 
> I don't think we can get rid of lock cycling - the counter can only
> exist within the IO context which is within the lock context. Hence
> to guarantee that all users of a buffer have finished, lock cycling
> is still necessary. i.e. lock cycling is a life cycle barrier, not
> an IO barrier...
> 

Ok, but we apparently use it as such in places like
xfs_buf_delwri_submit().

> > > We can do metadata buffer writes outside the superblock write
> > > protection context.  A good example of that is log recovery on
> > > read-only filesystems....
> > > 
> > 
> > This waits for I/O to complete so is unaffected by this problem.
> 
> Sure, but that's not what you were asking about. My point was that
> there is no specific high level superblock protection against
> async metadata IO being issued from non-VFS interfacing, internal
> filesystem subsystems.
> 

Ok, I wasn't being clear... the sb protection was just an example. The
fundamental question was whether we have to handle the write case due to
not otherwise having some kind of synchronization or protection against
tearing down infrastructure before I/Os complete. IOW, I don't care as
much about the sb write protection specifically as whether we can
identify any places where this is an actual, real problem that needs to
be solved.

(Again, I'm not against stepping back and taking a larger look at the
current buffer mechanisms to try and resolve such problems in theory,
but I would prefer to do that separately from this fix).

> > Now
> > that I take a look at that, I'm not sure we'd be able to replace that
> > with an I/O counter wait since technically that would wait for all
> > in-flight I/O to complete. This context (xfs_buf_delwri_submit()) is
> > only looking to wait for the locally submitted I/O to complete. Ugh.
> 
> I'm not advocating doing that at all.
> 

I know, I was. I was hoping that if we go down the path of a more
generic mechanism we might come up with something more useful beyond
this particular readahead problem.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
