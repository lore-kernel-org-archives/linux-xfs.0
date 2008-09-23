Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 01:01:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8N8135i030477
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 01:01:03 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5A1F1282C36
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 01:02:34 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id UHUHZ4QRqBEriVPp for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 01:02:34 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1Ki2qs-0008HH-3a
	for xfs@oss.sgi.com; Tue, 23 Sep 2008 18:02:30 +1000
Date: Tue, 23 Sep 2008 18:02:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC 1/3] Future Directions - Inode Subsystems
Message-ID: <20080923080230.GB5448@disturbed>
References: <20080923075910.GA5448@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080923075910.GA5448@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Future Directions for XFS

Improving Inode Caching and Operation in XFS
--------------------------------------------

$Id: future_directions-inodes.txt,v 1.1 2008/09/23 07:38:21 dave Exp dave $

Thousand foot view:

We want to drive inode lookup in a manner that is as parallel, scalable and low
overhead as possible. This means efficient indexing, lowering memory
consumption, simplifying the caching heirachy, removing duplication and
reducing/removing lock traffic.

In addition, we want to provide a good foundation for simplifying inode I/O,
improving writeback clustering, preventing RMW of inode buffers under memory
pressure, reducing creation and deletion overhead and removing writeback of
unlogged changes completely.

There are a variety of features in disconnected trees and patch sets that need
to be combined to acheive this - the basic structure needed to implement this is
already in mainline and that is the radix tree inode indexing.  Further
improvements are going to be based around this structure and using it
effectively to avoid needing other indexing mechanisms.

High Level Tasks:

(in no particular order - discussion is more coherent than this list)

	- Combine XFS and Linux inode
	- Introduce compressed cache
	- lockless igrab()
	- remove use of linux inode cache
	- RCU locking on XFs inode cache radix trees
	- background create of contiguous inode regions
	- background unlink
	- background inode chunk removal for noikeep
	- removing unlogged changes to inodes
	- removing inode buffers from create transaction (fast_icr)
	- ascending offset order inode writeback
	- clustering of inode writeback across multiple buffers
	- moving inode I/O directly to page cache?
	- rewrite sync code to be efficient and parallelisable
	- allow pdflush to call filesystem specific sync methods
	- avoiding writeback of unlinked inodes
	- demand paging of large extent maps
	- cross-inode data write clustering
	- prevent buftarg address space cache pollution by read-only, used
	  once inode cluster.
	- allow inode allocation in single filesystem block units instead
	  of chunks.
	- killing bufferheads

Discussion:

Combining XFS and VFS inodes
----------------------------

If we combine the XFS and the Linux inode, we'll increase memory usage for
cached inodes. However, combining them has some distinct advantages:

	- one less memory allocation
	- simpler reclaim code
	- removal of a significant amount of duplicate information
	- a single reference count for the entire inode data
	- solves several issues with RCU locking on the cache and
	  reclaim races

Of course, the downside is the memory usage. We can avoid this problem by making
use of the compressed inode cache - only the active inodes are held in a
non-compressed form, hence most inodes will end up being cached in compressed
form rather than in the XFS/linux inode form.  The compressed form can reduce
the cached inode footprint to 200-300 bytes per inode instead of 1-1.1k that
they currently take on a 64bit system. Hence by moving to a compressed cache we
can greatly increase the number of inodes cached in a given amount of memory
which more that offsets any comparitive increase we will see from inodes in
reclaim. the compressed cache should really have a LRU and a shrinker as well
so that memory pressure will slowly trim it as memory demands occur. [Note:
this compressed cache is discussed further later on in the reclaim context.]

It is worth noting that for embedded systems it may be worth while allowing
the size of the caches to be fixed. Also, to prevent memory fragmentation
problems,we could simply allocate that memory to the compressed cache slab.
In effect, this would become a 'static slab' in that it has a bound maximum
size and never frees and memory. When the cache is full, we reclaim an
object out of it for reuse - this could be done by triggering the shrinker
to reclaim from the LRU. This would prevent the compressed inode cache from
consuming excessive amounts of memory in tightly constrained evironments.
Such an extension to the slab caches does not look difficult to implement,
and would allow such customisation with minimal deviation from mainline code.

Also, it would be a nice-to-have to be able to make use of the 'init_once'
slab cache optimisation that the linux inode uses for idempotent fields
in the inode. This would reduce the allocation overhead of the combined
inode because we wouldn't need to zero the whole structure and then
re-initialise everything in it. We'd only need to initialise the changing
structures in this case - it means a little more code but should use
less CPU time for allocation (especially if the inodes are already hot
in cache).

Bypassing the Linux Inode Cache
-------------------------------

With a larger number of cached inodes that the linux inode cache could possibly
hold, it makes sense to completely remove the linux inode cache from the lookup
path. That is, we do all our inode lookup based on the XFS cache, and if we find
a compressed inode we uncompress it and turn it into a combined linux+XFS inode.
If we also fast-path igrab() to avoid the inode_lock in the common case
(refcount > 0) then we will substantially reduce the traffic on the inode_lock.

If we have not hashed the inode in the linux inode cache, we now have to take
care or tracking dirty inodes ourselves - unhashed inodes are not added to the
superblock dirty inode list by __mark_inode_dirty().  However, we do get a
callout (->dirty_inode) that allows us to do this ourselves. We can use this
callout and a tag in the inode radix tree to track all dirty inodes, or even
just use the superblock list ourselves. Either way, we now have a mechanism that
allows us to track all dirty inodes our own way.

Now that we can track dirty inodes ourselves, we can pretty much isolate
writeback of both data and inodes from the generic pdflush code. If we add a
hook high up in the pdflush path that simply passes us a writeback control
structure with the current writeback guidelines, we can do writeback within
those guidelines in the most optimal fashion for XFS.


Avoiding the Generic pdflush Code
---------------------------------

For pdflush driven writeback, we only want to write back data; all other inode
writeback should be driven from the AIL (our time ordered dirty metadata list)
or xfssyncd in a manner that is most optimal for XFS.

Furthermore, if we implement our own pdflush method, we can parallelise it in
several ways. We can ensure that each filesystem has it's own flush thread or
thread pool, we can have a thread pool shared by all filesystems (like pdflush
currently operates), we can have a flush thread per inode radix tree, and so
one. The method of paralleisation is open for interpretation, but enabling
multiple flush threads to operate on a single filesystem is one of the necessary
requirements to avoid data writeback (and hence delayed allocation) being
limited to the throughput of a single CPU per filesystem.

As it is, once data writeback is separated from inode writeback, we could
simply use pushing the AIL as a method of writing back metadata in the
background. There is no good reason for writing the inode immediately after
data if the inode is in the AIL - it will get written soon enough as the tail
of the AIL gets moved along. If we log all inode changes, then we'll be
unlikely to write the inode multiple times over it's dirty life-cycle as it
will continue to be moved forward in the AIL each time it is logged...


Improving Inode Writeback
-------------------------

To optimise inode writeback, we really need to reduce the impact of inode
buffer read-modify-write cycles. XFS is capable of caching far more inodes in
memory than it has buffer space available for, so RMW cycles during inode
writeback under memory pressure are quite common. Firstly, we want to avoid
blocking pdflush at all costs.  Secondly, we want to issue as much localised
readahead as possible in ascending offset order to allow both elevator merging
of readahead and as little seeking as possible. Finally, we want to issue all
the write cycles as close together as possible to allow the same elevator and
I/O optimisations to take place.

To do this, firstly we need the non-blocking inode flush semantics to issue
readahead on buffers that are not up-to-daterather than reading them
synchronously. Inode writeback already has the interface to handle inodes that
weren't flushed - we return EAGAIN from xfs_iflush() and the higher inode
writeback layers handle this appropriately. It would be easy to add another
flag to pass down to the buffer layer to say 'issue but don't wait for any
read'. If we use a radix tree traversal to issue readahead in such a manner,
we'll get ascending offset readahead being issued.

One problem with this is that we can issue too much readahead and thrash the
cache. A possible solution to this is to make the readahead a 'delayed read'
and on I/o completion add it to a queue that holds a reference on the buffer.
If a followup read occurs soon after, we remove it from the queue and drop that
reference. This prevents the buffer from being reclaimed in betwen the
readahead completing and the real read being issued. We should also issue this
delayed read on buffers that are in the cache so that they don't get reclaimed
to make room for the readahead.

To prevent buildup of delayed read buffers, we can periodically purge them -
those that are older than a given age (say 5 seconds) can be removed from the
list and their reference dropped. This will free the buffer and allow it's
pages to be reclaimed.

Once we have done the readahead pass, we can then do a modify and writeback
pass over all the inodes, knowing that there will be no read cycles to delay
this step. Once again, a radix tree traversal gives us ascending order
writeback and hence the modified buffers we send to the device will be in
optimal order for merging and minimal seek overhead.


Contiguous Inode Allocation
---------------------------

To make optimal use of the radix tree cache and enable wide-scale clustering of
inode writeback across multiple clusters, we really need to ensure that inode
allocation occurs in large contiguous chunks on disk. Right now we only
allocate chunks of 64 indoes at a time; ideally we want to allocate a stripe
unit (or multiple of) full of inodes at a time. This would allow inode
writeback clustering to do full stripe writes to the underlying RAID if there
are dirty inodes spanning the entire stripe unit.

The problem with doing this is that we don't want to introduce the latency of
creating megabytes of inodes when only one is needed for the current operation.
Hence we need to push the inode creation into a background thread and use that
to create contiguous inode chunks asynchronously. This moves the actual on-disk
allocation of inodes out of the normal create path; it should always be able to
find a free inode without doing on disk allocation. This will simplify the
create path by removing the allocate-on-disk-then-retry-the-create double
transaction that currently occurs.

As an aside, we could preallocate a small amount of inodes in each AG (10-20MB
of inodes per AG?) without impacting mkfs time too greatly. This would allow
the filesystem to be used immediately on the first mount without triggering
lots of background allocation. This could alsobe done after the first mount
occurs, but that could interfere with typical benchmarking situations. Another
good reason for this preallocation is that it will help reduce xfs_repair
runtime for most common filesystem usages.

One of the issues that the background create will cause is a substantial amount
of log traffic - every inode buffer initialised will be logged in whole. Hence
if we create a megabyte of inodes, we'll be causing a megabyte of log traffic
just for the inode buffers we've initialised.  This is relatively simple to fix
- we don't log the buffer, we just log the fact that we need to initialise
inodes in a given range.  In recovery, when we see this transaction, then we
build the buffers, initialise them and write them out. Hence, we don't need to
log the buffers used to initialise the inodes.

Also, we can use the background allocations to keep track of recently allocated
inode regions in the per-ag. Using that information to select the next inode to
be used rather than requiring btree searches on every create will greatly reduce
the CPU overhead of workloads that create lots of new inodes. It is not clear
whether a single background thread will be able to allocate enough inodes
to keep up with demand from the rest of the system - we may need multiple
threads for large configurations.


Single Block Inode Allocation
-----------------------------

One of the big problems we have withe filesystems that are approaching
full is that it canbe hard to find a large enough extent to hold 64 inodes.
We've had ENOSPC errors on inode allocation reported on filesystems that
are onl 85% full. This is a sign of free space fragementation, and it
prevents inode allocation from succeeding. We could (and should) write
a free space defragmenterr, but that does not solve the problem - it's
reactive, not preventative.

The main problem we have is that XFS uses inode chunk size and alignment
to optimise inode number to disk location conversion. That is, the conversion
becomes a single set of shifts and masks instead of an AGI btree lookup.
This optimisation substantially reduces the CPU and I/O overhead of
inode lookups, but it does limit our flexibility. If we break the
alignment restriction, every lookup has to go back to a btree search.
Hence we really want to avoid breaking chunkk alignment and size
rules.

An approach to avoiding violation of this rule is to be able to determine which
index to look up when parsing the inode number. For example, we could use the
high bit of the inode number to indicate that it is located in a non-aligned
inode chunk and hence needs to be looked up in the btree. This would avoid
the lookup penalty for correctly aligned inode chunks.

If we then redefine the meaning of the contents of the AGI btree record for
such inode chunks, we do not need a new index to keep these in. Effectively,
we need to add a bitmask to the record to indicate which blocks inside
the chunk can actually contain inodes. We still use aligned/sized records,
but mask out the sections that we are not allowed to allocate inodes in.
Effectively, this would allow sparse inode chunks. There may be limitations
on the resolution of sparseness depending on inode size and block size,
but for the common cases of 4k block size and 256 or 512 byte inodes I
think we can run a fully sparse mapping for each inode chunk.

This would allow us to allocate inode extents of any alignment and size
that fits *inside* the existing alignment/size limitations. That is,
a single extent allocation could not span two btree records, but can
lie anywhere inside a single record. It also means that we can do
multiple extent allocations within one btree record to make optimal
use of the fragmented free space.

It should be noted that this will probably have impact on some of the
inode cluster buffer mapping and clustering algorithms. It is not clear
exactly what impact yet, but certainly write clustering will be affected.
Fortunately we'll be able to detect the inodes that will have this problem
by the high bit inthe inode number.

Inode Unlink
------------

If we turn to look at unlink and reclaim interactions, there are a few
optimisations that can be made.  Firstly, we don't need to do inode inactivation
in reclaim threads - these transactions can easily be pushed to a background
thread. This means that xfs_inactive would be little more than a vmtruncate()
call and queuing to a workqueue. This will substantially speed up the processing
of prune_icache() - we'll get inodes moved into reclaim much faster than we do
right now.

This will have a noticable effect, though. When inodes are unlinked the space
consumed by those inodes may not be immediately freed - it will be returned as
the inodes are processed through the reclaim threads. This means that userspace
monitoring tools such as 'df' may not immediately reflect the result of a
completed unlink operation. This will be a user visible change in behaviour,
though in most cases should not affect anyone and for those that it does affect
a 'sync' should be sufficient to wait for the space to be returned.

Now that inodes to be unlinked are out of general circulation, we can make the
unlinked path more complex. It is desirable to move the unlinked list from the
inode buffer to the inode core, but that has locking implications for incore
unlinked. Hence we really need background thread processing to enable this to
work (i.e. being able to requeue inodes for later processing). To ensure that
to overhead of this work is not a limiting factor, we will probably need
multiple workqueue processing threads for this.

Moving the logging to the inode core enables two things - it allows us to keep
an in-memory copy of the unlinked list off the perag and that allows us to remove
xfs_inotobp(). The in-memory unlinked list means we don't have to read and
traverse the buffers every time we need to find the previous buffer to remove an
inode from the list, but it does mean we have to take the inode lock. If the
previous inode is locked, then we can't remove the inode from the unlinked list
so we must requeue it for this to occur at a later time.

Combined with the changes to inode create, we effectively will only use the
inode buffer in the transaction subsystem for marking the region stale when
freeing an inode chunk from disk (i.e. the default noikeep configuration). If
we are using large inode allocation, we don't want to be freeing random inode
chunks - this will just leave us with fragmented inode regions and undo all the
good work that was done originally.

To avoid this, we should not be freeing inode chunks as soon as they no longer
have any empty inodes in them. We should periodically scan the AGI btree
looking for contiguous chunks that have no inodes allocated in them, and then
freeing the large contiguous regions we find in one go. It is likely this can
be done in a single transaction; it's one extent to be freed, along with a
contiguous set of records to be removed from the AGI btree so should not
require logging much at all. Also, the background scanning could be triggered
by a number of different events - low space in an AG, a large number of free
inodes in an AG, etc - as it doesn't need to be done frequently. As a result
of the lack of frequency that this needs to be done, it can probably be
handled by a single thread or delayed workqueue.

Further optimisations are possible here - if we rule that the AGI btree is the
sole place that inodes are marked free or in-use (with the exception of
unlinked inodes attached to the AGI lists), then we can avoid the need to
write back unlinked inodes or read newly created inodes from disk.  This would
require all inodes to effectively use a random generation number assigned at
create time as we would not be reading it from disk - writing/reading the current
generation number appears to be the only real reason for doing this I/O. This
would require extra checks to determine if an inode is unlinked - we
need to do an imap lookup rather than reading it and then checking it is
valid if it is not already in memory. Avoiding the I/O, however, will greatly speed
up create and remove workloads. Note: the impact of this on the bulkstat algorithm
has not been determined yet.

One of the issues we need to consider with this background inactivation is that
we will be able to defer a large quantity of inactivation transactions so we are
going to need to be careful about how much we allow to be queued. Simple queue
depth throttling should be all that is needed to keep this under control.


Reclaim Optimisations
---------------------

Now that we have efficient unlink, we've got to handle the reclaim of all the
inodes that are now dead or simply not referenced. For inodes that are dirty,
we need to write them out to clean them. For inodes that are clean and not
unlinked, we need to compress them down for more compact storage. This involves
some CPU overhead, but it is worth noting that reclaiming of clean inodes
typically only occurs when we are under memory pressure.

By compressing the XFS inode in this case, we are effectively reducing the
memory usage of the inode rather than freeing it directly. If we then get
another operation on that inode (e.g. the working set is slightly larger than
can be held in linux+XFS inode pairs, we avoid having to read the inode off
disk again - it simply gets uncompressed out of the cache. In essence we use
the compressed inode cache as an exclusive second level cache - it has higher
density than the primary cache and higher load latency and CPU overhead,
but it still avoids I/O in exactly the same manner as the primary cache.

We cannot allow unrestricted build-up of reclaimable inodes - the memory they
consume will be large, so we should be aiming to compress reclaimable inodes as
soon as they are clean.  This will prevent buildup of memory consuming
uncompressed inodes that are not likely to be referenced again immediately.

This clean inode reclaimation process can be accelerated by triggering reclaim
on inode I/O completion. If the inode is clean and reclaimable we should
trigger immediate reclaim processing of that inode.  This will mean that
reclaim of newly cleaned inodes will not get held up behind reclaim of dirty
inodes.

For inodes that are unlinked, we can simply free them in reclaim as theƦ
are no longer in use. We don't want to poison the compressed cache with
unlinked inodes, nor do we need to because we can allocate new inodes
without incurring I/O.

Still, we may end up with lots of inodes queued for reclaim. We may need
to implement a throttle mechanism to slow down the rate at which inodes
are queued for reclaimation in the situation where the reclaim process
is not able to keep up. It should be noted that if we parallelise inode
writeback we should also be able to parallelise inode reclaim via
the same mechanism, so the need for throttling may relatively low
if we can have multiple inodes under reclaim at once.

It should be noted that complexity is exposed by interactions with concurrent
lookups, especially if we move to RCU locking on the radix tree. Firstly, we
need to be able to do an atomic swap of the compressed inode for the
uncompressed inode in the radix tree (and vice versa), to be able to tell them
apart (magic #), and to have atomic reference counts to ensure we can avoid use
after free situations when lookups race with compression or freeing.

Secondly, with the complex unlink/reclaim interactions we will need to be
careful to detect inodes in the process of reclaim - the lookupp process
will need to do different things depending on the state of reclaim. Indeed,
we will need to be able to cancel reclaim of an unlinked inode if we try
to allocate it before it has been fully unlinked or reclaimed. The same
can be said for an inode in the process of being compressed - if we get
a lookup during the compression process, we want to return the existing
inode, not have to wait, re-allocate and uncompress it again. These
are all solvable issues - they just add complexity.


Accelerated Reclaim of buftarg Page Cache for Inodes
----------------------------------------------------

For single use inodes or even read-only inodes, we read them in, use then, then
reclaim them. With the compressed cache, they'll get compressed and live a lot
longer in memory. However, we also will have the inode cluster buffer pages
sitting in memory for some length of time after the inode was read in. This can
consume a large amount of memory that will never be used again, and does not
get reclaimed until they are purged from the LRU by the VM.  It would be
advantageous to accelerate the reclaim of these pages so that they do not build
up unneccessarily.

One method we could use for this would be to introduce our own page LRUs into
the buftarg cache that we can reclaim from. This would allow us to sort pages
according to their contents into different LRUs and periodically reclaim pages
of specific types that were not referenced. This, however, would introduce a
fair amount of complexity into the buffer cache that doesn't currently exist.
Also, from a higher perspective, it makes the buffer cache a complex
part-buffer cache, part VM frankenstein.

A better method would appear to be to leverage the delayed read queue
mechanism. This delayed read queue pins read buffers for a short period of
time, and then if they have not been referenced they get torn down.  If, as
part of this delayed read buffer teardown procedure we all free the backing
pages completely, we acheive the exact same result as having our own LRUs to
manage the page cache. This seems much simpler and a much more holistic
approach to solving the problem than implementing page LRUs.

As an aside, we already have the mechanism in place to vary buffer aging based
on their type. The Irix buffer cache used this to great effect when under
memory pressure and the XFS code that configured it still exists in the Linux
code base. However, the Linux XFS buffer cache has never implemented any
mechanism to allow this functionality to be exploited. A delayed buffer reclaim
mechanism as described above could be greatly enhanced by making use of this
code in XFS.


Killing Bufferheads (a.k.a "Die, buggerheads, Die!")
----------------------------------------------------

[ This is not strictly about inode caching, but doesn't fit into
  other areas of developement as closely as it does to inode caching
  optimisations. ]

XFS is extent based. The Linux page cache is block based. Hence for
every cached page in memory, we have to attach a structure for mapping
the blocks on that page back to to the on-disk location. In XFs, we also
use this to hold state for delayed allocation and unwritten extent blocks
so the generic code can do the right thing when necessary. We also
use it to avoid extent lookups at various times within the XFS I/O
path.

However, this has a massive cost. While XFS might represent the
disk mapping of a 1GB extent in 24 bytes of memory, the page cache
requires 262,144 bufferheads (assuming 4k block size) to represent the
same mapping. That's roughly 14MB of memory neededtoo represent that.

Chris Mason wrote an extent map representation for page cache state
and mappings for BTRFS; that code is mostly generic and could be
adapted to XFS. This would allow us to hold all the page cache state
in extent format and greatly reduce the memory overhead that it currently
has. The tradeoff is increased CPU overhead due to tree lookups where
structure lookups currently are used. Still, this has much lower
overhead than xfs_bmapi() based lookups, so the penalty is going to
be lower than if we did these lookups right now.

If we make this change, we would then have three levels of extent
caching:

	- the BMBT buffers
	- the XFS incore inode extent tree (iext*)
	- the page cache extent map tree

Effectively, the XFS incore inode extent tree becomes redundant - all
the extent state it holds can be moved to the generic page cache tree
and we can do all our incore operations there. Our logging of changes
is based on the BMBT buffers, so getting rid of the iext layer would
not impact the transaction subsystem at all.

Such integration with the generic code will also allow development
of generic writeback routines for delayed allocation, unwritten
extents, etc that are not specific to a given filesystem.


Demand Paging of Large Inode Extent Maps
----------------------------------------

Currently the inode extent map is pinned  in memory until the inode is
reclaimed. Hence an inode with millions of extents will pin a large
amount of memory and this can cause serious issues in low memory
situations. Ideally we would like to be able to page the extent
map in and out once they get to a certain size to avoid this
problem. This feature requires more investigation before an overall
approach can be detailed here.

It should be noted that if we move to an extent-based page cache mapping
tree, the associated extent state tree can be used to track sparse
regions. That is, regions of the extent map that are not in memory
can be easily represented and acceesses to an unread region can then
be used to trigger demand loading.

Food For Thought (Crazy Ideas)
------------------------------

If we are not using inode buffers for logging changes to inodes, we should
consider whether we need them at all. What benefit do the buffers bring us when
all we will use them for is read or write I/O?  Would it be better to go
straight to the buftarg page cache and do page based I/O via submit_bio()?
