Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55578 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730419AbeHISZn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Aug 2018 14:25:43 -0400
Date: Thu, 9 Aug 2018 08:59:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 05/14] xfs: repair free space btrees
Message-ID: <20180809155959.GK30972@magnolia>
References: <20180801162316.GH30972@magnolia>
 <20180801183919.GE48176@bfoster>
 <20180802062845.GQ30972@magnolia>
 <20180802134824.GB65267@bfoster>
 <20180802192205.GT30972@magnolia>
 <20180803104940.GA5657@bfoster>
 <20180807233458.GH30972@magnolia>
 <20180808122953.GB2819@bfoster>
 <20180808224232.GJ30972@magnolia>
 <20180809120027.GC21030@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180809120027.GC21030@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, allison.henderson@oracle.com

On Thu, Aug 09, 2018 at 08:00:28AM -0400, Brian Foster wrote:
> On Wed, Aug 08, 2018 at 03:42:32PM -0700, Darrick J. Wong wrote:
> > On Wed, Aug 08, 2018 at 08:29:54AM -0400, Brian Foster wrote:
> > > On Tue, Aug 07, 2018 at 04:34:58PM -0700, Darrick J. Wong wrote:
> > > > On Fri, Aug 03, 2018 at 06:49:40AM -0400, Brian Foster wrote:
> > > > > On Thu, Aug 02, 2018 at 12:22:05PM -0700, Darrick J. Wong wrote:
> > > > > > On Thu, Aug 02, 2018 at 09:48:24AM -0400, Brian Foster wrote:
> > > > > > > On Wed, Aug 01, 2018 at 11:28:45PM -0700, Darrick J. Wong wrote:
> > > > > > > > On Wed, Aug 01, 2018 at 02:39:20PM -0400, Brian Foster wrote:
> > > > > > > > > On Wed, Aug 01, 2018 at 09:23:16AM -0700, Darrick J. Wong wrote:
> > > > > > > > > > On Wed, Aug 01, 2018 at 07:54:09AM -0400, Brian Foster wrote:
> > > > > > > > > > > On Tue, Jul 31, 2018 at 03:01:25PM -0700, Darrick J. Wong wrote:
> > > > > > > > > > > > On Tue, Jul 31, 2018 at 01:47:23PM -0400, Brian Foster wrote:
> > > > > > > > > > > > > On Sun, Jul 29, 2018 at 10:48:21PM -0700, Darrick J. Wong wrote:
> ...
> > > > > > So, that early draft spent a lot of time tearing down and reconstructing
> > > > > > rmapbt cursors since the standard _btree_query_all isn't suited to that
> > > > > > kind of usage.  It was easily twice as slow on a RAM-backed disk just
> > > > > > from the rmap cursor overhead and much more complex, so I rewrote it to
> > > > > > be simpler.  I also have a slight preference for not touching anything
> > > > > > until we're absolutely sure we have all the data we need to repair the
> > > > > > structure.
> > > > > > 
> > > > > 
> > > > > Yes, I think that is sane in principle. I'm just a bit concerned about
> > > > > how reliable that xfs_repair-like approach will be in the kernel longer
> > > > > term, particularly once we start having to deal with large filesystems
> > > > > and limited or contended memory, etc. We already have xfs_repair users
> > > > > that need to tweak settings because there isn't enough memory available
> > > > > to repair the fs. Granted that is for fs-wide repairs and the flipside
> > > > > is that we know a single AG can only be up to 1TB. It's certainly
> > > > > possible that putting some persistent backing behind the in-core data is
> > > > > enough to resolve the problem (and the current approach is certainly
> > > > > reasonable enough to me for the initial implementation).
> > > > > 
> > > > > bjoin limitations aside, I wonder if a cursor roll mechanism that held
> > > > > all of the cursor buffers, rolled the transaction and then rejoined all
> > > > > said buffers would help us get around that. (Not sure I follow the early
> > > > > prototype behavior, but it sounds like we had to restart the rmapbt
> > > > > lookup over and over...).
> > > > 
> > > > Correct.
> > > > 
> > > > > Another caveat with that approach may be that I think we'd need to be
> > > > > sure that the reconstruction operation doesn't ever need to update the
> > > > > rmapbt while we're mid walk of the latter.
> > > > 
> > > > <nod> Looking even farther back in my notes, that was also an issue --
> > > > fixing the free list causes blocks to go on or off the agfl, which
> > > > causes rmapbt updates, which meant that the only way I could get
> > > > in-place updates to work was to re-lookup where we were in the btree and
> > > > also try to deal with any rmapbt entries that might have crept in as
> > > > result of the record insertion.
> > > > 
> > > > Getting the concurrency right for each repair function looked like a
> > > > difficult problem to solve, but amassing all the records elsewhere and
> > > > rebuilding was easy to understand.
> > > > 
> > > 
> > > Yeah. This all points to this kind of strategy being too complex to be
> > > worth the prospective benefits in the short term. Clearly we have
> > > several, potentially tricky roadblocks to work through before this can
> > > be made feasible. Thanks for the background, it's still useful to have
> > > this context to compare with whatever we may have to do to support a
> > > reclaimable memory approach.
> > 
> > <nod>  Reclaimable memfd "memory" isn't too difficult, we can call
> > kernel_read and kernel_write, though lockdep gets pretty mad about xfs
> > taking sb_start_write (on the memfd filesystem) at the same time it has
> > sb_starT_write on the xfs (not to mention the stack usage) so I had to
> > throw in the extra twist of delegating the actual file io to a workqueue
> > item (a la xfs_btree_split).
> > 
> 
> Ok, I'm more curious what the surrounding code looks like around
> managing the underlying file pages. Now that I think of it, the primary
> usage was to dump everything into the file and read it back
> sequentually,

Yep.  Simplified, the code is more or less:

array_init(array)
{
	array->filp = shmem_file_create(...);
}

array_destroy(array)
{
	fput(array->filp);
}

array_set(array, nr, ptr)
{
	kernel_write(array->filp, ptr, array->obj_size, nr * array->obj_size);
}

array_get(array, nr, ptr)
{
	kernel_read(array->filp, ptr, array->obj_size, nr * array->obj_size);
}

That's leaving out all the bookkeeping and other weird details to show
pseudocode versions of the file manipulation calls.

I did end up playing a bit of sleight-of-hand with the file io, however
-- all the io is deferred to a workqueue for the dual purpose of
avoiding stack overflows in the memfd file's io paths and to avoid some
sort of deadlock in the page fault handler of the memfd write.  I didn't
investigate the deadlock too deeply, as solving the first problem seemed
to make the second go away.

> so perhaps this really isn't that difficult to deal with since the
> file content is presumably fixed size data structures.

Correct.  There is one user that needs variable-sized records (the
extended attribute repair) for which I've constructed the 'xblob' data
structure which stores blobs in a second memfd and returns the file
offset of a blob as a magic cookie that is recorded in the (fixed size)
attr keys.

Presumably the future directory rebuilder will use xblob too.

> (Hmm, was there a sort in there somewhere as well?).

Yes.  I spent a couple of days implementing a hybrid quicksort/insertion
sort that won't blow out the call stack.

> > > > > That may be an issue for inode btree reconstruction, for example,
> > > > > since it looks like inobt block allocation requires rmapbt updates.
> > > > > We'd probably need some way to share (or invalidate) a cursor across
> > > > > different contexts to deal with that.
> > > > 
> > > > I might pursue that strategy if we ever hit the point where we can't
> > > > find space to store the records (see below).  Another option could be to
> > > > divert all deferred items for an AG, build a replacement btree in new
> > > > space, then finish all the deferred items... but that's starting to get
> > > > into offlineable AGs, which is its own project that I want to tackle
> > > > later.
> > > > 
> > > > (Not that much later, just not this cycle.)
> > > > 
> > > 
> > > *nod*
> > > 
> > > > > > For other repair functions (like the data/attr fork repairs) we have to
> > > > > > scan all the rmapbts for extents, and I'd prefer to lock those AGs only
> > > > > > for as long as necessary to extract the extents we want.
> > > > > > 
> > > > > > > The obvious problem is that we still have some checks that allow the
> > > > > > > whole repair operation to bail out before we determine whether we can
> > > > > > > start to rebuild the on-disk btrees. These are things like making sure
> > > > > > > we can actually read the associated rmapbt blocks (i.e., no read errors
> > > > > > > or verifier failures), basic record sanity checks, etc. But ISTM that
> > > > > > > isn't anything we couldn't get around with a multi-pass implementation.
> > > > > > > Secondary issues might be things like no longer being able to easily
> > > > > > > insert the longest free extent range(s) first (meaning we'd have to
> > > > > > > stuff the agfl with old btree blocks or figure out some other approach).
> > > > > > 
> > > > > > Well, you could scan the rmapbt twice -- once to find the longest
> > > > > > record, then again to do the actual insertion.
> > > > > > 
> > > > > 
> > > > > Yep, that's what I meant by multi-pass.
> > > > > 
> > > > > > > BTW, isn't the typical scrub sequence already multi-pass by virtue of
> > > > > > > the xfs_scrub_metadata() implementation? I'm wondering if the ->scrub()
> > > > > > > callout could not only detect corruption, but validate whether repair
> > > > > > > (if requested) is possible based on the kind of checks that are
> > > > > > > currently in the repair side rmapbt walkers. Thoughts?r
> > > > > > 
> > > > > > Yes, scrub basically validates that for us now, with the notable
> > > > > > exception of the notorious rmapbt scrubber, which doesn't
> > > > > > cross-reference with inode block mappings because that would be a
> > > > > > locking nightmare.
> > > > > > 
> > > > > > > Are there future
> > > > > > > changes that are better supported by an in-core tracking structure in
> > > > > > > general (assuming we'll eventually replace the linked lists with
> > > > > > > something more efficient) as opposed to attempting to optimize out the
> > > > > > > need for that tracking at all?
> > > > > > 
> > > > > > Well, I was thinking that we could just allocate a memfd (or a file on
> > > > > > the same xfs once we have AG offlining) and store the records in there.
> > > > > > That saves us the list_head overhead and potentially enables access to a
> > > > > > lot more storage than pinning things in RAM.
> > > > > > 
> > > > > 
> > > > > Would using the same fs mean we have to store the repair data in a
> > > > > separate AG, or somehow locate/use free space in the target AG?
> > > > 
> > > > As part of building an "offline AG" feature we'd presumably have to
> > > > teach the allocators to avoid the offline AGs for allocations, which
> > > > would make it so that we could host the repair data files in the same
> > > > XFS that's being fixed.  That seems a little risky to me, but the disk
> > > > is probably larger than mem+swap.
> > > > 
> > > 
> > > Got it, so we'd use the remaining space in the fs outside of the target
> > > AG. ISTM that still presumes the rest of the fs is coherent, but I
> > > suppose the offline AG thing helps us with that. We'd just have to make
> > > sure we've shut down all currently corrupted AGs before we start to
> > > repair a particular corrupted one, and then hope there's still enough
> > > free space in the fs to proceed.
> > 
> > That's a pretty big hope. :)  I think for now 
> > 
> > > That makes more sense, but I still agree that it seems risky in general.
> > > Technical risk aside, there's also usability concerns in that the local
> > > free space requirement is another bit of non-determinism
> > 
> > I don't think it's non-deterministic, it's just hard for the filesystem
> > to communicate to the user/admin ahead of time.  Roughly speaking, we
> > need to have about as much disk space for the new btree as we had
> > allocated for the old one.
> > 
> 
> Right, maybe non-deterministic is not the best term. What I mean is that
> it's not clear to the user why a particular filesystem may not be able
> to run a repair (e.g., if it has plenty of reported free space but
> enough AGs may be shut down due to corruption). So in certain scenarios
> an unrelated corruption or particular ordering of AG repairs could be
> the difference between whether an online repair succeeds or defers to
> offline repair on the otherwise same filesystem. 

<nod>

> > As far as memory requirements go, in last week's revising of the patches
> > I compressed the in-memory record structs down about as far as possible;
> > with the removal of the list heads, the memory requirements drop by
> > 30-60%.  We require the same amount of memory as would be needed to
> > store all of the records in the leaf nodes, and no more, and we can use
> > swap space to do it.
> > 
> 
> Nice. When looking at the existing structures it looked like a worst
> case (1TB AG, every other 1k block allocated) could require up to
> 10-12GB RAM (but I could have easily messed that up).r

Sounds about right.  1TB AG = 268 million 4k blocks

bnobt: 8-byte records, or ~2.2GB of memory
inobt: 16-byte records, or ~4.3GB of memory
refcountbt: 12-byte records, or ~3.2GB of memory
rmapbt: 24-byte records, or ~6.4GB of memory

Multiply by 4 for a 1k block filesystem, divide by 16 for a 64k block fs.

Note that if the AG is full and heavily shared then the rmapbt
requirements can exceed that, but that's a known property of rmap in
general.

> That's not insane on its own, it's just the question of allocating
> that much memory in the kernel. Slimming that down and pushing it into
> something swappable doesn't _sound_ too overbearing. I'm not really
> sure what default distro swap sizes are these days (some % of RAM?),

I think so?  I think RH/Centos/OL default to the size of RAM + 2GB
nowadays, and Ubuntu seems to do RAM+sqrt(RAM)?

> but it shouldn't be that hard to find ~10GB of disk space somewhere to
> facilitate a repair.
>
> > > around the ability to online repair vs. having to punt to xfs_repair,
> > > or if the repair consumes whatever free space remains in the fs to the
> > > detriment of whatever workload the user presumably wanted to keep the
> > > fs online for, etc.
> > 
> > I've occasionally thought that future xfs_scrub could ask the kernel to
> > estimate how much disk and memory it will need for the repair (and
> > whether the disk space requirement is fs-scope or AG-scope); then it
> > could forego a repair action and recommend xfs_repair if running the
> > online repair would take the system below some configurable threshold.
> > 
> 
> I think something like that would improve usability once we nail down
> the core mechanism.

Ok, I'll put it on my list of things to do.

> > > > > presume either way we'd have to ensure that AG is either consistent or
> > > > > locked out from outside I/O. If we have the total record count we can
> > > > 
> > > > We usually don't, but for the btrees that have their own record/blocks
> > > > counters we might be able to guess a number, fallocate it, and see if
> > > > that doesn't ENOSPC.
> > > > 
> > > > > preallocate the file and hope there is no such other free space
> > > > > corruption or something that would allow some other task to mess with
> > > > > our blocks. I'm a little skeptical overall on relying on a corrupted
> > > > > filesystem to store repair data, but perhaps there are ways to mitigate
> > > > > the risks.
> > > > 
> > > > Store it elsewhere?  /home for root repairs, /root for any other
> > > > repair... though if we're going to do that, why not just add a swap file
> > > > temporarily?
> > > > 
> > > 
> > > Indeed. The thought crossed my mind about whether we could do something
> > > like have an internal/isolated swap file for dedicated XFS allocations
> > > to avoid contention with the traditional swap.
> > 
> > Heh, I think e2fsck has some feature like that where you can pass it a
> > swap file.  No idea how much good that does on modern systems where
> > there's one huge partition... :)
> > 
> 
> Interesting. Couldn't you always create an additional swap file, run the
> repair then kill it off when it's no longer needed?

Yes, though as I think you said in an earlier reply, it would be nice to
have our own private swap file instead of risking some other process
taking it.

> > > Userspace could somehow set it up or communicate to the kernel. I have
> > > no idea how realistic that is though or if there's a better interface
> > > for that kind of thing (i.e., file backed kmem cache?).
> > 
> > I looked, and there aren't any other mechanisms for unpinnned kernel
> > memory allocations.
> > 
> 
> Ok, it looks like swap or traditional files it is then. ;P
> 
> > > What _seems_ beneficial about that approach is we get (potentially
> > > external) persistent backing and memory reclaim ability with the
> > > traditional memory allocation model.
> > >
> > > ISTM that if we used a regular file, we'd need to deal with the
> > > traditional file interface somehow or another (file read/pagecache
> > > lookup -> record ??).
> > 
> > Yes, that's all neatly wrapped up in kernel_read() and kernel_write() so
> > all we need is a (struct file *).
> > 
> > > We could repurpose some existing mechanism like the directory code or
> > > quota inode mechanism to use xfs buffers for that purpose, but I think
> > > that would require us to always use an internal inode. Allowing
> > > userspace to pass an fd/file passes that consideration on to the user,
> > > which might be more flexible. We could always warn about additional
> > > limitations if that fd happens to be based on the target fs.
> > 
> > <nod> A second advantage of the struct file/kernel_{read,write} approach
> > is that we if we ever decide to let userspace pass in a fd, it's trivial
> > to feed that struct file to the kernel io routines instead of a memfd
> > one.
> > 
> 
> Yeah, I like this flexibility. In fact, I'm wondering why we wouldn't do
> something like this anyways. Could/should xfs_scrub be responsible for
> allocating a memfd and passing along the fd? Another advantage of doing
> that is whatever logic we may need to clean up old repair files or
> whatever is pushed to userspace.

There are two ways we could do this -- one is to have the kernel manage
the memfd creation internally (like my patches do now); the other is for
xfs_scrub to pass in creat(O_TMPFILE).

When repair fputs the file (or fdputs the fd if we switch to using
that), the kernel will perform the usual deletion of the zero-linkcount
zero-refcount file.  We get all the "cleanup" for free by closing the
file.

One other potential complication is that a couple of the repair
functions need two memfds.  The extended attribute repair creates a
fixed-record array for attr keys and an xblob to hold names and values;
each structure gets its own memfd.  The refcount repair creates two
fixed-record arrays, one for refcount records and another to act as a
stack of rmaps to compute reference counts.

(In theory the xbitmap could also be converted to use the fixed record
array, but in practice they haven't (yet) become large enough to warrant
it, and there's currently no way to insert or delete records from the
middle of the array.)

> > > > > I'm not familiar with memfd. The manpage suggests it's ram backed, is it
> > > > > swappable or something?
> > > > 
> > > > It's supposed to be.  The quick test I ran (allocate a memfd, write 1GB
> > > > of junk to it on a VM with 400M of RAM) seemed to push about 980MB into
> > > > the swap file.
> > > > 
> > > 
> > > Ok.
> > > 
> > > > > If so, that sounds a reasonable option provided the swap space
> > > > > requirement can be made clear to users
> > > > 
> > > > We can document it.  I don't think it's any worse than xfs_repair being
> > > > able to use up all the memory + swap... and since we're probably only
> > > > going to be repairing one thing at a time, most likely scrub won't need
> > > > as much memory.
> > > > 
> > > 
> > > Right, but as noted below, my concerns with the xfs_repair comparison
> > > are that 1.) the kernel generally has more of a limit on anonymous
> > > memory allocations than userspace (i.e., not swappable AFAIU?) and 2.)
> > > it's not clear how effectively running the system out of memory via the
> > > kernel will behave from a failure perspective.
> > > 
> > > IOW, xfs_repair can run the system out of memory but for the most part
> > > that ends up being a simple problem for the system: OOM kill the bloated
> > > xfs_repair process. For an online repair in a similar situation, I have
> > > no idea what's going to happen.
> > 
> > Back in the days of the huge linked lists the oom killer would target
> > other proceses because it doesn't know that the online repair thread is
> > sitting on a ton of pinned kernel memory...
> > 
> 
> Makes sense, kind of what I'd expect...
> 
> > > The hope is that the online repair hits -ENOMEM and unwinds, but ISTM
> > > we'd still be at risk of other subsystems running into memory
> > > allocation problems, filling up swap, the OOM killer going after
> > > unrelated processes, etc.  What if, for example, the OOM killer starts
> > > picking off processes in service to a running online repair that
> > > immediately consumes freed up memory until the system is borked?
> > 
> > Yeah.  One thing we /could/ do is register an oom notifier that would
> > urge any running repair threads to bail out if they can.  It seems to me
> > that the oom killer blocks on the oom_notify_list chain, so our handler
> > could wait until at least one thread exits before returning.
> > 
> 
> Ok, something like that could be useful. I agree that we probably don't
> need to go that far until the mechanism is nailed down and testing shows
> that OOM is a problem.

It already is a problem on my contrived "2TB hardlink/reflink farm fs" +
"400M of RAM and no swap" scenario.  Granted, pretty much every other
xfs utility also blows out on that so I'm not sure how hard I really
need to try...

> > > I don't know how likely that is or if it really ends up much different
> > > from the analogous xfs_repair situation. My only point right now is
> > > that failure scenario is something we should explore for any solution
> > > we ultimately consider because it may be an unexpected use case of the
> > > underlying mechanism.
> > 
> > Ideally, online repair would always be the victim since we know we have
> > a reasonable fallback.  At least for memfd, however, I think the only
> > clues we have to decide the question "is this memfd getting in the way
> > of other threads?" is either seeing ENOMEM, short writes, or getting
> > kicked by an oom notification.  Maybe that'll be enough?
> > 
> 
> Hm, yeah. It may be challenging to track memfd usage as such. If
> userspace has access to the fd on an OOM notification or whatever, it
> might be able to do more accurate analysis based on an fstat() or
> something.
> 
> Related question... is the online repair sequence currently
> interruptible, if xfs_scrub receives a fatal signal while pulling in
> entries during an allocbt scan for example?

It's interruptible (fatal signals only) during the scan phase, but once
it starts logging metadata updates it will run all the way to
completion.

> > > (To the contrary, just using a cached file seems a natural fit from
> > > that perspective.)
> > 
> > Same here.
> > 
> > > > > and the failure characteristics aren't more severe than for userspace.
> > > > > An online repair that puts the broader system at risk of OOM as
> > > > > opposed to predictably failing gracefully may not be the most useful
> > > > > tool.
> > > > 
> > > > Agreed.  One huge downside of memfd seems to be the lack of a mechanism
> > > > for the vm to push back on us if we successfully write all we need to
> > > > the memfd but then other processes need some memory.  Obviously, if the
> > > > memfd write itself comes up short or fails then we dump the memfd and
> > > > error back to userspace.  We might simply have to free array memory
> > > > while we iterate the records to minimize the time spent at peak memory
> > > > usage.
> > > > 
> > > 
> > > Hm, yeah. Some kind of fixed/relative size in-core memory pool approach
> > > may simplify things because we could allocate it up front and know right
> > > away whether we just don't have enough memory available to repair.
> > 
> > Hmm.  Apparently we actually /can/ call fallocate on memfd to grab all
> > the pages at once, provided we have some guesstimate beforehand of how
> > much space we think we'll need.
> > 
> > So long as my earlier statement about the memory requirements being no
> > more than the size of the btree leaves is actually true (I haven't
> > rigorously tried to prove it), we need about (xrep_calc_ag_resblks() *
> > blocksize) worth of space in the memfd file.  Maybe we ask for 1.5x
> > that and if we don't get it, we kill the memfd and exit.
> > 
> 
> Indeed. It would be nice if we could do all of the file management bits
> in userspace.

Agreed, though no file management would be even better. :)

--D

> Brian
> 
> > --D
> > 
> > > 
> > > Brian
> > > 
> > > > --D
> > > > 
> > > > > 
> > > > > Brian
> > > > > 
> > > > > > --D
> > > > > > 
> > > > > > > Brian
> > > > > > > 
> > > > > > > > --D
> > > > > > > > 
> > > > > > > > > Brian
> > > > > > > > > 
> > > > > > > > > > --D
> > > > > > > > > > 
> > > > > > > > > > > Brian
> > > > > > > > > > > 
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > > +done:
> > > > > > > > > > > > > > +	/* Free all the OWN_AG blocks that are not in the rmapbt/agfl. */
> > > > > > > > > > > > > > +	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
> > > > > > > > > > > > > > +	return xrep_reap_extents(sc, old_allocbt_blocks, &oinfo,
> > > > > > > > > > > > > > +			XFS_AG_RESV_NONE);
> > > > > > > > > > > > > > +}
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > ...
> > > > > > > > > > > > > > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > > > > > > > > > > > > > index 0ed68379e551..82f99633a597 100644
> > > > > > > > > > > > > > --- a/fs/xfs/xfs_extent_busy.c
> > > > > > > > > > > > > > +++ b/fs/xfs/xfs_extent_busy.c
> > > > > > > > > > > > > > @@ -657,3 +657,17 @@ xfs_extent_busy_ag_cmp(
> > > > > > > > > > > > > >  		diff = b1->bno - b2->bno;
> > > > > > > > > > > > > >  	return diff;
> > > > > > > > > > > > > >  }
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > > +/* Are there any busy extents in this AG? */
> > > > > > > > > > > > > > +bool
> > > > > > > > > > > > > > +xfs_extent_busy_list_empty(
> > > > > > > > > > > > > > +	struct xfs_perag	*pag)
> > > > > > > > > > > > > > +{
> > > > > > > > > > > > > > +	spin_lock(&pag->pagb_lock);
> > > > > > > > > > > > > > +	if (pag->pagb_tree.rb_node) {
> > > > > > > > > > > > > 
> > > > > > > > > > > > > RB_EMPTY_ROOT()?
> > > > > > > > > > > > 
> > > > > > > > > > > > Good suggestion, thank you!
> > > > > > > > > > > > 
> > > > > > > > > > > > --D
> > > > > > > > > > > > 
> > > > > > > > > > > > > Brian
> > > > > > > > > > > > > 
> > > > > > > > > > > > > > +		spin_unlock(&pag->pagb_lock);
> > > > > > > > > > > > > > +		return false;
> > > > > > > > > > > > > > +	}
> > > > > > > > > > > > > > +	spin_unlock(&pag->pagb_lock);
> > > > > > > > > > > > > > +	return true;
> > > > > > > > > > > > > > +}
> > > > > > > > > > > > > > diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
> > > > > > > > > > > > > > index 990ab3891971..2f8c73c712c6 100644
> > > > > > > > > > > > > > --- a/fs/xfs/xfs_extent_busy.h
> > > > > > > > > > > > > > +++ b/fs/xfs/xfs_extent_busy.h
> > > > > > > > > > > > > > @@ -65,4 +65,6 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
> > > > > > > > > > > > > >  	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
> > > > > > > > > > > > > >  }
> > > > > > > > > > > > > >  
> > > > > > > > > > > > > > +bool xfs_extent_busy_list_empty(struct xfs_perag *pag);
> > > > > > > > > > > > > > +
> > > > > > > > > > > > > >  #endif /* __XFS_EXTENT_BUSY_H__ */
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > --
> > > > > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > > > > --
> > > > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > > > --
> > > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > > > --
> > > > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > > --
> > > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > > --
> > > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > --
> > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > --
> > > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > --
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
