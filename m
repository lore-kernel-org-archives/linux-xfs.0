Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45950 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfFMSga (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:36:30 -0400
Date: Thu, 13 Jun 2019 14:36:25 -0400
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: pagecache locking (was: bcachefs status update) merged)
Message-ID: <20190613183625.GA28171@kmo-pixel>
References: <20190610191420.27007-1-kent.overstreet@gmail.com>
 <CAHk-=wi0iMHcO5nsYug06fV3-8s8fz7GDQWCuanefEGq6mHH1Q@mail.gmail.com>
 <20190611011737.GA28701@kmo-pixel>
 <20190611043336.GB14363@dread.disaster.area>
 <20190612162144.GA7619@kmo-pixel>
 <20190612230224.GJ14308@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612230224.GJ14308@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <dchinner@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Matthew Wilcox <willy@infradead.org>, Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>, Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Jun 13, 2019 at 09:02:24AM +1000, Dave Chinner wrote:
> On Wed, Jun 12, 2019 at 12:21:44PM -0400, Kent Overstreet wrote:
> > Ok, I'm totally on board with returning EDEADLOCK.
> > 
> > Question: Would we be ok with returning EDEADLOCK for any IO where the buffer is
> > in the same address space as the file being read/written to, even if the buffer
> > and the IO don't technically overlap?
> 
> I'd say that depends on the lock granularity. For a range lock,
> we'd be able to do the IO for non-overlapping ranges. For a normal
> mutex or rwsem, then we risk deadlock if the page fault triggers on
> the same address space host as we already have locked for IO. That's
> the case we currently handle with the second IO lock in XFS, ext4,
> btrfs, etc (XFS_MMAPLOCK_* in XFS).
> 
> One of the reasons I'm looking at range locks for XFS is to get rid
> of the need for this second mmap lock, as there is no reason for it
> existing if we can lock ranges and EDEADLOCK inside page faults and
> return errors.

My concern is that range locks are going to turn out to be both more complicated
and heavier weight, performance wise, than the approach I've taken of just a
single lock per address space.

Reason being range locks only help when you've got multiple operations going on
simultaneously that don't conflict - i.e. it's really only going to be useful
for applications that are doing buffered IO and direct IO simultaneously to the
same file. Personally, I think that would be a pretty gross thing to do and I'm
not particularly interested in optimizing for that case myself... but, if you
know of applications that do depend on that I might change my opinion. If not, I
want to try and get the simpler, one-lock-per-address space approach to work.

That said though - range locks on the page cache can be viewed as just a
performance optimization over my approach, they've got the same semantics
(locking a subset of the page cache vs. the entire thing). So that's a bit of a
digression.

> > This would simplify things a lot and eliminate a really nasty corner case - page
> > faults trigger readahead. Even if the buffer and the direct IO don't overlap,
> > readahead can pull in pages that do overlap with the dio.
> 
> Page cache readahead needs to be moved under the filesystem IO
> locks. There was a recent thread about how readahead can race with
> hole punching and other fallocate() operations because page cache
> readahead bypasses the filesystem IO locks used to serialise page
> cache invalidation.
> 
> e.g. Readahead can be directed by userspace via fadvise, so we now
> have file->f_op->fadvise() so that filesystems can lock the inode
> before calling generic_fadvise() such that page cache instantiation
> and readahead dispatch can be serialised against page cache
> invalidation. I have a patch for XFS sitting around somewhere that
> implements the ->fadvise method.

I just puked a little in my mouth.

> I think there are some other patches floating around to address the
> other readahead mechanisms to only be done under filesytem IO locks,
> but I haven't had time to dig into it any further. Readahead from
> page faults most definitely needs to be under the MMAPLOCK at
> least so it serialises against fallocate()...

So I think there's two different approaches we should distinguish between. We
can either add the locking to all the top level IO paths - what you just
described - or, the locking can be pushed down to protect _only_ adding pages to
the page cache, which is the approach I've been taking.

I think both approaches are workable, but I do think that pushing the locking
down to __add_to_page_cache_locked is fundamentally the better, more correct
approach.

 - It better matches the semantics of what we're trying to do. All these
   operations we're trying to protect - dio, fallocate, truncate - they all have
   in common that they just want to shoot down a range of the page cache and
   keep it from being readded. And in general, it's better to have locks that
   protect specific data structures ("adding to this radix tree"), vs. large
   critical sections ("the io path").

   In bcachefs, at least for buffered IO I don't currently need any per-inode IO
   locks, page granularity locks suffice, so I'd like to keep that - under the
   theory that buffered IO to pages already in cache is more of a fast path than
   faulting pages in.

 - If we go with the approach of using the filesystem IO locks, we need to be
   really careful about auditing and adding assertions to make sure we've found
   and fixed all the code paths that can potentially add pages to the page
   cache. I didn't even know about the fadvise case, eesh.

 - We still need to do something about the case where we're recursively faulting
   pages back in, which means we need _something_ in place to even detect that
   that's happening. Just trying to cover everything with the filesystem IO
   locks isn't useful here.

So to summarize - if we have locking specifically for adding pages to the page
cache, we don't need to extend the filesystem IO locks to all these places, and
we need something at that level anyways to handle recursive faults from gup()
anyways.

The tricky part is that there's multiple places that want to call
add_to_page_cache() while holding this pagecache_add_lock.

 - dio -> gup(): but, you had the idea of just returning -EDEADLOCK here which I
   like way better than my recursive locking approach.

 - the other case is truncate/fpunch/etc - they make use of buffered IO to
   handle operations that aren't page/block aligned. But those look a lot more
   tractable than dio, since they're calling find_get_page()/readpage() directly
   instead of via gup(), and possibly they could be structured to not have to
   truncate/punch the partial page while holding the pagecache_add_lock at all
   (but that's going to be heavily filesystem dependent).

The more I think about it, the more convinced I am that this is fundamentally
the correct approach. So, I'm going to work on an improved version of this
patch.

One other tricky thing we need is a way to write out and then evict a page
without allowing it to be redirtied - i.e. something that combines
filemap_write_and_wait_range() with invalidate_inode_pages2_range(). Otherwise,
a process continuously redirtying a page is going to make truncate/dio
operations spin trying to shoot down the page cache - in bcachefs I'm currently
taking pagecache_add_lock in write_begin and mkwrite to prevent this, but I
really want to get rid of that. If we can get that combined
write_and_invalidate() operation, then I think the locking will turn out fairly
clean.
