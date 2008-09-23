Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 23 Sep 2008 01:02:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8N82SoV030798
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 01:02:29 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4BF546FD16
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 01:04:01 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id YWBs7QnBLCjv80jv for <xfs@oss.sgi.com>; Tue, 23 Sep 2008 01:04:01 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1Ki2sJ-0008Jx-9V
	for xfs@oss.sgi.com; Tue, 23 Sep 2008 18:03:59 +1000
Date: Tue, 23 Sep 2008 18:03:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC 2/3] Future Directions - Journalling
Message-ID: <20080923080359.GC5448@disturbed>
References: <20080923075910.GA5448@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923075910.GA5448@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Future Directions for XFS
-------------------------

Improving Metadata Performance By Reducing Journal Overhead
-----------------------------------------------------------

$Id: future_directions-journalling.txt,v 1.1 2008/09/23 07:38:44 dave Exp dave $

XFS currently uses asynchronous write-ahead logging to ensure that changes to
the filesystem structure are preserved on crash.  It does this by logging
detailed records ofteh changes being made to each object on disk during a
transaction. Every byte that is modified needs to be recorded in the journal.

There are two issues with this approach. The first is that transactions can
modify a *lot* of metadata  to complete a single operation. Worse is the fact
that the average size of a transactions grows as structures get larger and
deeper, so performance on larger, fuller filesystem drops off as log bandwidth
is consumed by fewer, larger transactions.

The second is that we re-log previous changes that are active in the journal
if the object is modified again. hence if an object is modified repeatedly, the
dirty parts of the object get rewritten over and over again. in the worst case,
frequently logged buffers will be entirely dirty and so even if we only change
a single byte in the buffer we'll log the entire buffer.

An example of how needless this can be is the operation of a removing all the
files in a directory result in the directory blocks being logged over and over
again before finally being freed and made stale in the log. If we are freeing
the entire contents of the directory, the only transactions we really need in
the journal w.r.t to directory buffers is the 'remove, stale and free'
transaction; all other changes are irrelevant because we don't care about
changes to free space. Depending on the directory block size, we might log each
directory buffer tens to hundreds of times before making it stale...

Clearly we have two different axis to approach this problem along:

	- reduce the amount we log in a given transaction
	- reduce the number of times we re-log objects.

Both of these things give the same end result - we require less bandwidth to
the journal to log changes that are happening in the filesystem. Let's start
by looking at how to reduce re-logging of objects.


Asynchronous Transaction Aggregation
------------------------------------

The first observation that we need to make is that we are already doing
asynchronous journalling for everything other than explicitly synchronous
transactions. This means we are aggregating completed transactions in memory
before writing them to disk. This reduces the number of disk I/Os needed to
write the log, but it does nothing to help prevent relogging of items.

The second observation is that we store asynchronous committed transactions
in two forms while they are being written to disk:

	- the physical form in the log buffer that will be written
	- the logical form attached to the log buffer so that on I/O completion
	  of the log buffer the items in the transaction can be unpinned and
	  moved to or updated in the AIL for later writeback.

The fact that we store the logical form of the transaction until after the
log buffer is written to the journal is important - it means the transaction
and all it's dirty items live longer than process that creates and commits
the transaction. This allows us to redefine what 'transaction commit' actually
means.

A transaction commit currently takes the following steps:

	- apply superblock and dquot changes to in-core structures
	- build an vector array to all the dirty regions in all the items in
	  the transaction.
	- write the vector array into the log buffer (may trigger log I/O)
	- release ununsed transaction reservations to in-core structures
	- attach transaction to log buffer callbacks
	- write a commit record into the log buffer for the transaction
	- unlock all the items locked in the transaction
	- release the log buffer (may trigger log I/O)
	- if synchronous transaction, issue a synchronous log force to
	  get the transaction on disk.

Based on the observation that the transaction structure exists until it is
freed during log buffer I/o completion, we really don't have to format the
transaction into a log buffer during the transaction commit - we could
simply queue it into a list for later processing. Synchronous
transactions don't change this - they just queue the transaction then
do a log force to cause the transaction queue to be flushed to disk.

Now that we have an asynchronous transaction queue in logical format, we can
take our time deciding when and how best to write it to disk. If we have
the situation where we are relogging items, we will have a given item
in multiple transactions. If we write out each transaction as an individual
commit like we currently do, we'd then have the problem of future changes
being written in the first transaction that we write. This will cause
problems for recovery.

Hence what we really want to do is aggregate all those transactions into a
single large journal commit. This makes the journalling model more of a
'checkpoint of changes' than a 'transactional change' model. By commiting
a set of transactions rather than just a single transaction per commit
record, we can avoid needed to commit items several times to the log
if they are modified in multiple transactions. During recovery, we only
recover the entire commit so we only need a single version of each item
that encompasses all the changes in the commit period.

As an aside, if we have large numbers of items per commit record now,
it makes sense to start optimising the recovery read-ahead by sorting
all the items in the commit record before issuing readahead on them.
This will reduce the seeking the readahead triggers somewhat, so should
lead to faster recovery times.

The down sides to this approach are:

	- holds items pinned in memory for longer, thereby increases
	  the chances of triggering a log force to unpin them.
	- partial log forces (i.e. those to a specific LSN) are no longer
	  really possible as we do not have multiple independent queues
	  (iclogbufs) holding the transactions.
	- log forces become more expensive by having to drain the entire
	  async transaction queue.
	- synchronous transactions become more expensive by having to
	  drain the entire async transaction queue.
	- possible 'interesting' interactions with tail-pushing if we
	  allow too many async transactions to be queued without flushing
	  them.

The main concern with this approach is ensuring that we don't adversely affect
fsync() performance. For example, ext3 uses a checkpoint based journalling
system that has a very long checkpoint period (5 seconds).  As a result, a
synchronous operation such as an fsync() can be forced to flush up to 5 seconds
worth of transactions to disk. In ordered mode, this also involves flushing
data, so the fsync() latency can be measured in tens of seconds on a busy
filesystem. This is known as the 'sync the world' problem, and currently XFS
does not suffer from this at all. 

[Data point: Recent testing of this phenomenon by Chris Mason showed XFS took
less than one second to fsync a 4k write in the presence of a background
streaming write; BTRFS took two seconds and ext3 took five seconds. ]

To avoid this type of latency, we should not be allowing too many transactions
to accumulate in the async transaction queue. If we look at optimising
workloads such as sequential creates or deletes in a single directory then, in
theory, accumulating just 10 async transactions into a single commit record
should provide close to an order of magnitude reduction in bandwidth to the log
under these workloads. We also reduce the number of log writes by aggregating
like this and that will give us even larger gains by avoiding seeks to write
log buffers out.

Hence I don't think the async transaction queue needs to be all that deep
to realise substantial gains, and hence the impact on synchronous transaction
latency can be kept quite low as a result.


Atomic Multi-Transaction Operations
-----------------------------------

A feature asynchronous transaction aggregation makes possible is atomic
multi-transaction operations.  On the first transaction we hold the queue in
memory, preventing it from being committed. We can then do further transactions
that will end up in the same commit record, and on the final transaction we
unlock the async transaction queue. This will allow all those transaction to be
applied atomically. This is far simpler than any other method I've been looking
at to do this.

After a bit of reflection, I think this feature may be necessary for correct
implementation of existing logging techniques. The way we currently implement
rolling transactions (with permanent log reservations and rolling
dup/commit/re-reserve sequences) would seem to require all the commits in a
rolling transaction to be including in a single commit record.  If I understand
history and the original design correctly, these rolling transactions were
implemented so that large, complex transactions would not pin the tail of the
log as they progressed.  IOWs, they implicitly use re-logging to keep the tail
of the log moving forward as they progress and continue to modify items in the
transaction.

Given we are using asynchronous transaction aggregation as a method of reducing
re-logging, it would make sense to prevent these sorts of transactions from
pinning the tail of the log at all. Further, because we are effectively
disturbing the concept of unique transactions, I don't think that allowing a
rolling transaction to span aggregated commits is valid as we are going to be
ignoring the transaction IDs that are used to identify individual transactions.

Hence I think it is a good idea to simply replace rolling transactions with
atomic multi-transaction operations. This may also allow us to split some of
the large compound transactions into smaller, more self contained transactions.
This would reduce reservation pressure on log space in the common case where
all the corner cases in the transactions are not taken. In terms of
implementation, I think we can initially augment the permanent transaction
reservation/release interface to acheive this. With a working implementation,
we can then look to changing to a more explicit interface and slowly work to
remove the 'permanent log transaction' concept entirely. This shold simplify
the log code somewhat....

Note: This asynchronous transaction aggregation is originally based on a
concept floated by Nathan Scott called 'Delayed Logging' after observing how
ext3 implemented journalling.  This never passed more than a concept
description phase....


Operation Based Logging
-----------------------

The second approach to reducing log traffic is to change exactly what we
log in the transactions. At the moment, what we log is the exact change to
the item that is being made. For things like inodes and dquots, this isn't
particularly expensive because it is already a very compact form. The issue
comes with changes that are logged in buffers.

The prime example of this is a btree modification that involves either removing
or inserting a record into a buffer. The records are kept in compact form, so an
insert or remove will also move other records around in the buffer. In the worst
case, a single insert or remove of a 16 byte record can dirty an entire block
(4k generally, but could be up to 64k). In this case, if we were to log the
btree operation (e.g. insert {record, index}) rather than the resultant change
on the buffer the overhead of a btree operation is fixed. Such logging also
allows us to avoid needing to log the changes due to splits and merges - we just
replay the operation and subsequent splits/merges get done as part of replay.

The result of this is that complex transactions no longer need as much log space
as all possible change they can cause - we only log the basic operations that
are occurring and their result. Hence transaction end up being much smaller,
vary less in size between empty and full filesystems, etc. An example set of
operations describing all the changes made by an extent allocation on an inode
would be:

	- inode X intent to allocate extent {off, len}
	- AGCNT btree update record in AG X {old rec} {new rec values}
	- AGBNO btree delete record in AG X {block, len}
	- inode X BMBT btree insert record {off, block, len}
	- inode X delta

This comes down to a relatively small, bound amount of space which is close the
minimun and existing allocation transaction would consume.  However, with this
method of logging the transaction size does not increase with the size of
structures or the amount of updates necessary to complete the operations.

A major difference to the existing transaction system is that re-logging
of items doesn't fit very neatly with operation based logging. 

There are three main disadvantages to this approach:

	- recovery becomes more complex - it will need to change substantially
	  to accomodate operation replay rather than just reading from disk
	  and applying deltas.
	- we have to create a whole new set of item types and add the necessary
	  hooks into the code to log all the operations correctly.
	- re-logging is probably not possible, and that introduces 
	  differences to the way we'll need to track objects for flushing. It
	  may, in fact, require transaction IDs in all objects to allow us
	  to determine what the last transaction that modified the item
	  on disk was during recovery.

Changing the logging strategy as described is a much more fundamental change to
XFS than asynchronous transaction aggregation. It will be difficult to change
to such a model in an evolutionary manner; it is more of a 'flag day' style
change where then entire functionality needs to be added in one hit. Given that
we will also still have to support the old log format, it doesn't enable us to
remove any code, either.

Given that we are likely to see major benefits in the problem workloads as a
result of asynchronous transaction aggregation, it may not be necessary to
completely rework the transaction subsystem. Combining aggregation with an
ongoing process of targeted reduction of transaction size will provide benefits
out to at least the medium term. It is unclear whether this direction will be
sufficient in the long run until we can measure the benefit that aggregation
will provide.


Reducing Transaction Overhead
-----------------------------

To switch tracks completely, I have not addressed general issues with overhead
in the transaction subsystem itself. There are several points where the
transaction subsystem will single thread because of filesystem scope locks and
structures.  We have, for example, the log grant lock for protecting
reservation and used log space, the AIL lock for tracking dirty metadata, the
log state lock for state transition of log buffers and other associated
structure modifications.

We have already started down the path of reducing contention in
various paths. For example:

	- changing iclog reference counts to atomics to avoid needing the log
	  state lock on every transaction commit
	- protecting iclog callback lists with a per-iclog lock instead of the log
	  state lock
	- removing the AIL lock from the transaction reserve path by isolating
	  AIL tail pushing to a single thread instead of being done
	  synchronously.

Asynchronous transaction aggregation is likely to perturb the current known
behaviour and bottlenecks as a result of moving all of the log interfacing out
of the direct transaction commit path.  Similar to moving the AIL pushing into
it's own thread, this will mean that there will typically only be a single
thread formatting and writing to iclog buffers. This will remove much of the
parallelism that puts excessive pressure on many of these locks.

I am certain that asynchronous transaction aggregation will open up new areas
of optimisation in the log formatting and dispatch code - it will probably
enable us to remove a lot of the complexity because we will be able to directly
control the parallelism in the formatting and dispatch of log buffers. This
implies that we may not need to be limited to a fixed pool of fixed sized log
buffers for writing transactions to disk.

However, it is probably best to leave consideration of such optimisations until
after the asynchronous transaction aggregation is implemented and we can
directly observe the pain points that become apparent as a result of such a
change.


Reducing Recovery Time
----------------------

With 2GB logs, recovery can take an awfully long time due to the need
to read each object synchronously as we process the jounral. An obvious
way to avoid this is to add another pass to the processing to do asynchronous
readahead of all the objects in the log before doing the processing passes.
This will populate the cache as quickly as possible and hide any read latency
that could occur as we process commit records.

A logical extension to this is to sort the objects in ascending offset order
before issuing I/O on them. That will further optimise the readahead I/O
to reduce seeking and hence should speed up the read phase of recovery
further.

ToDo: Further investigation of recovery for future optimisation.
