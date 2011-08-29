Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7T123IF027934 for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 20:02:03 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3318013A8DBD
	for <xfs@oss.sgi.com>; Sun, 28 Aug 2011 18:05:07 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	CBUPIjSI37eOBwVF for <xfs@oss.sgi.com>;
	Sun, 28 Aug 2011 18:05:07 -0700 (PDT)
Date: Mon, 29 Aug 2011 11:01:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS metadata flushing design - current and future
Message-ID: <20110829010149.GE3162@dastard>
References: <20110827080321.GA16661@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110827080321.GA16661@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, Aug 27, 2011 at 04:03:21AM -0400, Christoph Hellwig wrote:
> Here is a little writeup I did about how we handle dirty metadata
> flushing in XFS currently, and how we can improve on it in the
> relatively short term:
> 
> 
> ---
> Metadata flushing in XFS
> ========================
> 
> This document describes the state of the handling of dirty XFS in-core
> metadata, and how it gets flushed to disk, as well as ideas how to
> simplify it in the future.
> 
> 
> Buffers
> -------
> 
> All metadata is XFS is read and written using buffers as the lowest layer.
> There are two ways to write a buffer back to disk: delwri and sync.
> Delwri means the buffers gets added to a delayed write list, which a
> background thread writes back periodically or when forced to.  Synchronous
> writes means the buffer is written back immediately, and the callers waits
> for completion synchronously.

Right, that's how buffers are flushed, but for some metadata there
is a layer above this - the in-memory object that needs to be
flushed to the buffer before the buffer can be written. Inodes and
dquots fall into this category, so describing how they are flushed
would also be a good idea. something like:

----

High Level Objects
------------------

Some objects are logged directly when changed, rather than modified
in buffers first. When these items are written back, then first need
to b flushed to the backing buffer, and then IO issued on the
backing buffer. These objects can be written in two ways: delwri and
sync.

Delwri means the object is locked and written to the backing buffer,
and the buffer is then written via it's delwri mechanism. The object
remains locked (and so cannot be written to the buffer again) until
the backing buffer is written to disk and marked clean. This allows
multiple objects in the one buffer to be written at different times
but be cleaned in a single buffer IO.

Delwri means the object is locked and written to the backing buffer,
and the buffer is written immediately to disk via it's sync
mechanism. The object remains locked until the buffer IO completes.

Objects need to be attached to the buffer with a callback so that
they can be updated and unlocked when buffer IO completes. Buffer IO
completion will walk the callback list to do this processing.

----


> Logging and the Active Item List (AIL)
> --------------------------------------
> 
> The prime method of metadata writeback in XFS is by logging the changes
> into the transaction log, and writing back the changes to the original
> location in the background.  The prime data structure to drive the
> asynchronous write back is the Active Item List or AIL.  The AIL contains
> a list of all changes in the log that need to be written back, ordered
> by on the time they were committed to the log using the Log Sequence
> Number (LSN).  The AIL is periodically pushed out to try to move the
> log tail LSN forward.  In addition periodically the sync worker attempts
> to push out all items in the AIL.
> 
> Non-transaction metadata updates
> --------------------------------
> 
> XFS still has a few updates where update metadata non-transactional.
> 
> The prime cause for non-transaction metadata updates are timestamps in the
> inode, and inode size updates from extending writes.  These are handled
> by marking the inode dirty in the VFS and XFS inodes, and either relying
> on transactional updates to piggy-back these updates, or on the VFS
> periodic writeback thread to call into the ->write_inode method in
> XFS to write these changes back.  ->write_inode either starts delwri
> buffer writeback on the inode, or starts a new transaction to log
> the inode core containing these changes.
> 
> The dquot structures may be scheduled for delwri writeback after a
> quota check during an unclean mount.
> 
> Extended attribute payloads that are stored outside the main attribute
> btree are written back synchronously using buffers.
> 
> New allocation group headers written during a filesystem resizing are
> written synchronously using buffers.
> 
> The superblock is written synchronously using buffers during umount
> and sync operations.
> 
> Log recovery writes back various pieces of metadata synchronously
> or using delwri buffers.
> 
> 
> Other flushing methods
> ----------------------
> 
> For historical reasons we still have a few places that flush XFS metadata
> using others methods than logging and the AIL or explicit synchronous
> or delwri writes.
> 
> Filesystem freezing loops over all inodes in the system to flush out
> inodes marked dirty directly using xfs_iflush.
> 
> The quotacheck code marks dquots dirty, just to flush them at the end of
> the quotacheck operation.

This is safe because the filesystem isn't "open for business" until
the quotacheck completes. The quotacheck needed flags aren't cleared
until all the updates are on disk, so this doesn't need tobe done
transactionally.

> The periodic and explicit sync code walks through all dqouts and writes
> back all dirty dquots directly.
>
> Future directions
> -----------------
> 
> We should get rid of both the reliance of the VFS writeback tracking, and
> XFS-internal non-AIL metadata flushing.

I'm assuming you mean VFS level dirty inode writeback tracking, not
dirty page cache tracking?

> To get rid of the VFS writeback we'll just need to log all time stamps and size
> updates explicitly when they happens.  This could be done today, but the
> overhead for frequent transactions in that area is deemed to high, especially
> with delayed logging enabled.  We plan to deprecate the non-delaylog mode
> by Linux 3.3, and introduce a new fast-path for inode core updates that
> will allow to use direct logging for this updates without introducing
> large overhead.
> 
> The explicit inode flushing using xfs_sync_attr looks like an attempt to
> make sure we do not have any inodes in the AIL when freezing a filesystem.
> A better replacement would be a call into the AIL code that allows to
> completely empty the AIL before a freeze.

Agreed, good simplification, and would enable us to get rid of some
of the kludgy code in freeze.

> The explicit quota flushing needs a bit more work.  First quota check needs
> to be converted to queue up inodes to the delwri list immediately when
> updating the dquot for each inode.  Second the code in xfs_qm_scall_setqlim
> that attached a dquot to the transaction, but marks it dirty manually instead
> of through the transaction interface needs a detailed audit.  After this
> we should be able to get rid of all explicit xfs_qm_sync calls.

Yes, it would be great to remove theneed for explicit quota
flushing.


Another thing I've noticed is that AIL pushing of dirty inodes can
be quite inefficient from a CPU usage perspective. Inodes that have
already been flushed to their backing buffer results in a
IOP_PUSHBUF call when the AIL tries to push them. Pushing the buffer
requires a buffer cache search, followed by a delwri list promotion.
However, the initial xfs_iflush() call on a dirty inode also
clusters all the other remaining dirty inodes in the buffer to the
buffer. When the AIl hits those other dirty inodes, they are already
locked and so we do a IOP_PUSHBUF call. On every other dirty inode.
So on a completely dirty inode cluster, we do ~30 needless buffer
cache searches and buffer delwri promotions all for the same buffer.
That's a lot of extra work we don't need to be doing - ~10% of the
buffer cache lookups come from IOP_PUSHBUF under inode intensive
metadata workloads:

	xs_push_ail_pushbuf...       5665434
	xs_iflush_count.......        173551
	xs_icluster_flushcnt..        171554
	xs_icluster_flushinode       5316393
	pb_get................      63362891

This shows we've done 171k explicit inode cluster flushes when
writing inodes, and we've clustered 5.3M inodes in those cluster
writes. We've also have 5.6M IOP_PUSHBUF calls, which indicates most
of them are coming from finding flush locked inodes. There's been
63M buffer cache lookups, so we're causing roughly 8% of buffer
cache lookups just through flushing inodes from the AIL.

Also, larger inode buffers to reduce the amount of IO we do to both
read and write inodes might also provide significant benefits by
reducing the amount of IO and number of buffers we need to track in
the cache...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
