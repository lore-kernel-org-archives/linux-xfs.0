Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 01:03:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8N83aBi031111
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 01:03:36 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C32C46FD24
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 01:05:07 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id KQhPh7rKFD0fE4hX for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 01:05:07 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1Ki2tM-0008Ln-KS
	for xfs@oss.sgi.com; Tue, 23 Sep 2008 18:05:04 +1000
Date: Tue, 23 Sep 2008 18:05:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC 3/3] Future Directions - Reliability
Message-ID: <20080923080504.GD5448@disturbed>
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
-------------------------

Reliable Detection and Repair of Metadata Corruption
----------------------------------------------------

$Id: future_directions-reliability.txt,v 1.1 2008/09/23 07:39:05 dave Exp dave $

This can be broken down into specific phases. Firstly, we cannot repair a
corruption we have not detected. Hence the first thing we need to do is
reliable detection of errors and corruption. Once we can reliably detect errors
in structures and verified that we are propagating all the errors reported from
lower layers into XFS correctly, we can look at ways of handling them more
robustly. In many cases, the same type of error needs to be handled differently
due to the context in which the error occurs.  This introduces extra complexity
into this problem.

Rather than continually refering to specific types of problems (such as
corruption or error handling) I'll refer to them as 'exceptions'. This avoids
thinking about specific error conditions through specific paths and so helps us
to look at the issues from a more general or abstract point of view.

Exception Detection
-------------------

Our current approach to exception detection is entirely reactive and rather
slapdash - we read a metadata block from disk and check certain aspects of it
(e.g. the magic number) to determine if it is the block we wanted. We have no
way of verifying that it is the correct block of metadata of the type
we were trying to read; just that it is one of that specific type. We
do bounds checking on critical fields, but this can't detect bit errors
in those fields. There's many fields we don't even bother to check because
the range of valid values are not limited.

Effectively, this can be broken down into three separate areas:

	- ensuring what we've read is exactly what we wrote
	- ensuring what we've read is the block we were supposed to read
	- robust contents checking

Firstly, if we introduce a mechanism that we can use to ensure what we read is
something that the filesystem wrote, we can detect a whole range of exceptions
that are caused in layers below the filesystem (software and hardware). The
best method for this is to use a guard value that travels with the metadata it
is guarding. The guard value needs to be derived from the contents of the
block being guarded. Any event that changes the guard or the contents it is
guarding will immediately trigger an exception handling process when the
metadata is read in. Some examples of what this will detect are:

	- bit errors in media/busses/memory after guard is calculated
	- uninitialised blocks being returned from lower layers (dmcrypt
	  had a readahead cancelling bug that could do this)
	- zeroed sectors as a result of double sector failures
	  in RAID5 systems
	- overwrite by data blocks
	- partial overwrites (e.g. due to power failure)

The simplest method for doing this is introducing a checksum or CRC into each
block. We can calculate this for each different type of metadata being written
just before they are written to disk, hence we are able to provide a guard that
travels all the way to and from disk with the metadata itself. Given that
metadata blocks can be a maximum of 64k in size, we don't need a hugely complex
CRC or number of bits to protect blocks of this size. A 32 bit CRC will allow
us to reliably detect 15 bit errors on a 64k block, so this would catch almost
all types of bit error exceptions that occur. It will also detect almost all
other types of major content change that might occur due to an exception.
It has been noted that we should select the guard algorithm to be one that
has (or is targetted for) widespread hardware acceleration support.

The other advantage this provides us with is a very fast method of determining
if a corrupted btree is a result of a lower layer problem or indeed an XFS
problem. That is, instead of always getting a WANT_CORRUPTED_GOTO btree
exception and shutdown, we'll get a'bad CRC' exception before we even start
processing the contents. This will save us much time when triaging corrupt
btrees - we won't spend time chasing problems that result from (potentially
silent or unhandled) lower layer exceptions.

While a metadata block guard will protect us against content change, it won't
protect us against blocks that are written to the wrong location on disk. This,
unfortunately, happens more often that anyone would like and can be very
difficult to track down when it does occur. To protect against this problem,
metadata needs to be self-describing on disk. That is, if we read a block
on disk, there needs to be enough information in that block to determine
that it is the correct block for that location.

Currently we have a very simplistic method of determining that we really have
read the correct block - the magic numbers in each metadata structure.  This
only enables us to identify type - we still need location and filesystem to
really determine if the block we've read is the correct one. We need the
filesystem identifier because misdirected writes can cross filesystem
boundaries.  This is easily done by including the UUID of the filesystem in
every individually referencable metadata structure on disk.

For block based metadata structures such as btrees, AG headers, etc, we
can add the block number directly to the header structures hence enabling
easy checking. e.g. for btree blocks, we already have sibling pointers in the
header, so adding a long 'self' pointer makes a great deal of sense.
For inodes, adding the inode number into the inode core will provide exactly
the same protection - we'll now know that the inode we are reading is the
one we are supposed to have read. We can make similar modifications to dquots
to make them self identifying as well.

So now we are able to verify the metadata we read from disk is what we wrote
and it's the correct metadata block, the only thing that remains is more
robust checking of the content. In many cases we already do this in DEBUG
code but not in runtime code. For example, when we read an inode cluster
in we only check the first inode for a matching magic number, whereas in
debug code we check every inode in the cluster.

In some cases, there is not much point in doing this sort of detailed checking;
it's pretty hard to check the validity of the contents of a btree block without
doing a full walk of the tree and that is prohibitive overhead for production
systems. The added block guards and self identifiers should be sufficient to
catch all non-filesystem based exceptions in this case, whilst the existing
exception detection should catch all others. With the btree factoring that
is being done on for this work, all of the btrees should end up protected by
WANT_CORRUPTED_GOTO runtime exception checking.

We also need to verify that metadata is sane before we use it. For example, if
we pull a block number out of a btree record in a block that has passed all
other validity it still may be invalid due to corruption prior to writing
it to disk. In these cases we need to ensure the block number lands
within the filesystem and/or within the bounds of the specific AG.

Similar checking is needed for pretty much any forward or backwards reference
we are going to follow or using in an algorithm somewhere. This will help
prevent kernel panics by out of bound references (e.g. using an unchecked ag
number to index the per-AG array) by turning them into a handled exception
(which will initially be a shutdown). That is, we will turn a total system
failure into a (potentially recoverable) filesystem failure.

Another failures that we often have reported is that XFS has 'hung' and
traige indicates that the filesystem appears to be waiting for a metadata
I/O completion to occur. We have seen in the past I/O errors not being
propagated from the lower layers back into the filesystem causing these
sort of problems. We have also seen cases where there have been silent
I/O errors and the first thing to go wrong is 'XFS has hung'.

To catch situations like this, we need to track all I/O we have in flight and
have some method of timing them out.  That is, if we haven't completed the I/O
in N seconds, issue a warning and enter an exception handling process that
attempts to deal with the problem.

My initial thoughts on this is that it could be implemented via the MRU cache
without much extra code being needed.  The complexity with this is that we
can't catch data read I/O because we use the generic I/O path for read. We do
our own data write and metadata read/write, so we can easily add hooks to track
all these types of I/O. Hence we will initially target just metadata I/O as
this would only need to hook into the xfs_buf I/O submission layer.

To further improve exception detection, once guards and self-describing
structures are on disk, we can add filesystem scrubbing daemons that can verify
the structure of the filesystem pro-actively. That is, we can use background
processes to discovery degradation in the filesystem before it is found by a
user intiated operation. This gives us the ability to do exception handling in
a context that enables further checking and potential repair of the exception.
This sort of exception handling may not be possible if we are in a
user-initiated I/O context, and certainly not if we are in a transaction
context.

This will also allow us to detect errors in rarely referenced parts of
the filesystem, thereby giving us advance warning of degradation in filesystems
that we might not otherwise get (e.g. in systems without media scrubbing).
Ideally, data scrubbing woul dneed to be done as well, but without data guards
it is rather hard to detect that there's been a change in the data....


Exception Handling
------------------

Once we can detect exceptions, we need to handle them in a sane manner.
The method of exception handling is two-fold:

	- retry (write) or cancel (read) asynchronous I/O
	- shut down the filesystem (fatal).

Effectively, we either defer non-critical failures to a later point in
time or we come to a complete halt and prevent the filesystem from being
accessed further. We have no other methods of handling exceptions.

If we look at the different types of exceptions we can have, they
broadly fall into:

	- media read errors
	- media write errors
	- successful media read, corrupted contents

The context in which the errors occur also influences the exception processing
that is required. For example, an unrecoverable metadata read error within a
dirty transaction is a fatal error, whilst the same error during a read-only
operation will simply log the error to syslog and return an error to userspace.

Furthermore, the storage subsystem plays a part indeciding how to handle
errors. The reason is that in many storage configurations I/O errors can be
transient. For example, in a SAN a broken fibre can cause a failover to a
redundant path, however the inflight I/O on the failed is usually timed out and
an error returned. We don't want to shut down the filesystem on such an error -
we want to wait for failover to a redundant path and then retry the I/O. If the
failover succeeds, then the I/O will succeed. Hence any robust method of
exception handling needs to consider that I/O exceptions may be transient.

In the abscence of redundant metadata, there is little we can do right now
on a permanent media read error. There are a number of approaches we
can take for handling the exception:

	- try reading the block again. Normally we don't get an error
	  returned until the device has given up on trying to recover it.
	  If it's a transient failure, then we should eventually get a
	  good block back. If a retry fails, then:

	- inform the lower layer that it needs to perform recovery on that
	  block before trying to read it again. For path failover situations,
	  this should block until a redundant path is brought online. If no
	  redundant path exists or recovery from parity/error coding blocks
	  fails, then we cannot recover the block and we have a fatal error
	  situation.

Ultimately, however, we reach a point where we have to give up - the metadata
no longer exists on disk and we have to enter a repair process to fix the
problem. That is, shut down the filesystem and get a human to intervene
and fix the problem.

At this point, the only way we can prevent a shutdown situation from occurring
is to have redundant metadata on disk. That is, whenever we get an error
reported, we can immediately retry by reading from an alternate metadata block.
If we can read from the alternate block, we can continue onwards without
the user even knowing there is a block in the filesystem. Of course, we'd
need to log the event for the administrator to take action on at some point
in the future.

Even better, we can mostly avoid this intervention if we have alternate
metadata blocks. That is, we can repair blocks that are returning read errors
during the exception processing. In the case of media errors, they can
generally be corrected simply by re-writing the block that was returning the
error. This will force drives to remap the bad blocks internally so the next
read from that location will return valid data. This, if my understanding is
correct, is the same process that ZFS and BTRFS use to recover from and correct
such errors.

NOTE: Adding redundant metadata can be done in several different ways. I'm not
going to address that here as it is a topic all to itself. The focus of this
document is to outline how the redundant metadata could be used to enhance
exception processing and prevent a large number of cases where we currently
shut down the filesystem.

TODO:
	Transient write error
	Permanent write error
	Corrupted data on read
	Corrupted data on write (detected during guard calculation)
	I/O timeouts
	Memory corruption


Reverse Mapping
---------------

It is worth noting that even redundant metadata doesn't solve all our
problems. Realistically, all that redundant metadata gives us is the ability
to recover from top-down traversal exceptions. It does not help exception
handling of occurences such as double sector failures (i.e. loss of redundancy
and a metadata block). Double sector failures are the most common cause
of RAID5 data loss - loss of a disk followed by a sector read error during
rebuild on one of the remaining disks.

In this case, we've got a block on disk that is corrupt. We know what block it
is, but we have no idea who the owner of the block is. If it is a metadata
block, then we can recover it if we have redundant metadata.  Even if this is
user data, we still want to be able to tell them what file got corrupted by the
failure event.  However, without doing a top-down traverse of the filesystem we
cannot find the owner of the block that was corrupted.

This is where we need a reverse block map. Every time we do an allocation of
an extent we know who the owner of the block is. If we record this information
in a separate tree then we can do a simple lookup to find the owner of any
block and start an exception handling process to repair the damage. Ideally
we also need to include information about the type of block as well. For
example, and inode can own:

	- data blocks
	- data fork BMBT blocks
	- attribute blocks
	- attribute fork BMBT blocks

So keeping track of owner + type would help indicate what sort of exception
handling needs to take place. For example, a missing data fork BMBT block means there
will be unreferenced extents across the filesystem. These 'lost extents'
could be recovered by reverse map traversal to find all the BMBT and data
blocks owned by that inode and finding the ones that are not referenced.
If the reverse map held suffient extra metadata - such as the offset within the
file for the extent - the exception handling process could rebuild the BMBT
tree completely without needing ænd external help.

It would seem to me that the reverse map needs to be a long-pointer format
btree and held per-AG. it needs long pointers because the owner of an extent
can be anywhere in the filesystem, and it needs to be per-AG to avoid adverse
effect on allocation parallelism.

The format of the reverse map record will be dependent on the amount of
metdata we need to store. We need:

	- owner (64 bit, primary record)
	- {block, len} extent descriptor
	- type
	- per-type specific metadata (e.g. offset for data types).

Looking at worst case here, say we have 32 bytes per record, the worst case
space usage of the reverse map btree woul dbe roughly 62 records per 4k
block. With a 1TB allocation group, we have 2^28 4k blocks in the AG
that could require unique reverse mappings. That gives us roughly 2^22
4k blocks to for the reverse map, or 2^34 bytes - roughly 16GB per 1TB
of space.

It may be a good idea to allocate this space at mkfs time (tagged as unwritten
so it doesn't need zeroing) to avoid allocation overhead and potential free
space fragmentation as the reverse map index grows and shrinks. If we do
this we could even treat this as a array/skip list where a given block in the
AG has a fixed location in the map. This will require more study to determine
the advantages and disadvantages of such approaches.


Recovering From Errors During Transactions
------------------------------------------

One of the big problems we face with exception recovery is what to do
when we take an exception inside a dirty transaction. At present, any
error is treated as a fatal error, the transaction is cancelled and
the filesystem is shut down. Even though we may have a context which
can return an error, we are unable to revert the changes we have
made during the transaction and so cannot back out.

Effectively, a cancelled dirty transaction looks exactly like in-memory
structure corruption. That is, what is in memory is different to that
on disk, in the log or in asynchronous transactions yet to be written
to the log. Hence we cannot simply return an error and continue.

To be able to do this, we need to be able to undo changes made in a given
transaction. The method XFS uses for journalling - write-ahead logging -
makes this diffcult to do. A transaction proceeds in the following
order:

	- allocate transaction
	- reserve space in the journal for transaction
	- repeat until change is complete:
		- lock item
		- join item to transaction
		- modify item
		- record region of change to item
	- transaction commit

Effectively, we modify structures in memory then record where we
changed them for the transaction commit to write to disk. Unfortunately,
this means we overwrite the original state of the items in memory,
leaving us with no way to back out those changes from memory if
something goes wrong.

However, based on the observation that we are supposed to join an item to the
transaction *before* we start modifying it, it is possible to record the state
of the item before we start changing it. That is, we have a hoook that can
allow us take a copy of the unmodified item when we join it to the
transaction.

If we have an unmodified copy of the item in memory, then if the transaction
is cancelled when dirty, we have the information necessary to undo, or roll
back, the changes made in the transaction. This would allow us to return
the in-memory state to that prior to the transaction starting, thereby
ensuring that the in-memory state matches the rest of the filesystem and
allowing us to return an error to the calling context.

This is not without overhead. we would have to copy every metadata item
entirely in every transaction. This will increase the CPU overhead
of each transaction as well as the memory required. It is the memory
requirement more than the CPU overhead that concerns me - we may need
to ensure we have a memory pool associated with transaction reservation
that guarantees us enough memory is available to complete the transaction.
However, given that we could roll back transactions, we could now *fail
transactions* with ENOMEM and not have to shut down the filesystem, so this
may be an acceptible trade-off.

In terms of implementation, it is worth noting that there is debug code in
the xfs_buf_log_item for checking that all the modified regions of a buffer
were logged. Importantly, this is implemented by copying the original buffer
in the item initialisation when it is first attached to a transaction. In
other words, this debug code implements the mechanism we need to be able
to rollback changes made in a transaction. Other item types would require
similar changes to be made.

Overall, this doesn't look like a particularly complex change to make; the
only real question is how much overhead is it going to introduce. With CPUs
growing more cores all the time, and XFS being aimed at extremely
multi-threaded workloads, this overhead may not be a concern for long.


Failure Domains
-----------------

If we plan to have redundant metadata, or even try to provide fault isolation
between different parts of the filesystem namespace, we need to know about
independent regions of the filesystem. 'Independent Regions' (IR) are ranges
of the filesystem block address space that don't share resources with
any other range.

A classic example of a filesystem made up of multiple IRs is a linear
concatenation of multiple drives into a larger address space.  The address
space associated with each drive can operate independently from the other
drives, and a failure of one drive will not affect the operation of the address
spaces associated with other drives in the linear concatenation.

A Failure Domain (FD) is made up of one or more IRs. IRs cannot be shared
between FDs - IRs are not independent if they are shared! Effectively, an
ID is an encoding of the address space within the filesystem that lower level
failures (from below the filesystem) will not propagate outside. The geometry
and redundancy in the underlying storage will determine the nature of the
IRs available to the filesystem.

To use redundant metadata effectively for recovering from fatal lower layer
loss or corruption, we really need to be able to place said redundant
metadata in a different FDs. That way a loss in one domain can be recovered
from a domain that is still intact. It also means that it is extremely
difficult to lose or corrupt all copies of a given piece of metadata;
that would require multiple independent faults to occur in a localised
temporaral window. Concurrent multiple component failure in multiple
IRs is considered to be quite unlikely - if such an event were to
occur, it is likely that there is more to worry about than filesystem
consistency (like putting out the fire in the data center).

Another use of FDs is to try to minimise the number of domain boundaries
each object in the filesystem crosses. If an object is wholly contained
within a FD, and that object is corrupted, then the repair problem is
isolated to that FD, not the entire filesystem. That is, by making
allocation strategies and placement decisions aware of failure domain
boundaries we can constraint the location of related data and metadata.
Once locality is constrained, the scope of repairing an object if
it becomes corrupted is reduced to that of ensuring the FD is consistent.

There are many ways of limiting cross-domain dependencies; I will
not try to detail them here. Likewise, there are many ways of introducing
such information into XFS - mkfs, dynamically via allocation policies,
etc - so I won't try to detail them, either. The main point to be
made is that to make full use of redundant metadata and to reduce
the scope of common reapir problems we need to pay attention to 
how the system can fail to ensure that we can recover from failures
as quickly as possible.
