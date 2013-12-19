Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 750577F3F
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 03:24:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3C13D8F8064
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 01:24:19 -0800 (PST)
Received: from mail-ee0-f45.google.com (mail-ee0-f45.google.com
	[74.125.83.45]) by cuda.sgi.com with ESMTP id vK3IDAm8bkNIDlx9
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 19 Dec 2013 01:24:12 -0800 (PST)
Received: by mail-ee0-f45.google.com with SMTP id d49so326020eek.32
	for <xfs@oss.sgi.com>; Thu, 19 Dec 2013 01:24:10 -0800 (PST)
Message-ID: <78FC295EC7FF48C987266DC48B183930@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
References: <AD612A564BB84E75B010AE37687DFC8E@alyakaslap>
	<20131218230615.GQ31386@dastard>
In-Reply-To: <20131218230615.GQ31386@dastard>
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)
Date: Thu, 19 Dec 2013 11:24:15 +0200
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi Dave,
Thank you for your comments.
I realize now that what I proposed cannot be done; I need to understand 
deeper how XFS transactions work (unfortunately, the awesome "XFS Filesystem 
Structure" doc has a TODO in the "Journaling Log" section).

Can you please comment on one more question:
Let's say we had such fully asynchronous "fire-and-forget" discard operation 
(I can implement one myself for my block-device via a custom IOCTL). What is 
wrong if we trigger such operation in xfs_free_ag_extent(), right after we 
have merged the freed extent into a bigger one? I understand that the 
extent-free-intent is not yet committed to the log at this point. But from 
the user's point of view, the extent has been deleted, no? So if the 
underlying block device discards the merged extent right away, before 
committing to the log, what issues this can cause?

Thanks,
Alex.


-----Original Message----- 
From: Dave Chinner
Sent: 19 December, 2013 1:06 AM
To: Alex Lyakas
Cc: xfs@oss.sgi.com
Subject: Re: Questions about XFS discard and xfs_free_extent() code (newbie)

On Wed, Dec 18, 2013 at 08:37:29PM +0200, Alex Lyakas wrote:
> Greetings XFS developers & community,
>
> I am studying the XFS code, primarily focusing now at the free-space
> allocation and deallocation parts.
>
> I learned that freeing an extent happens like this:
> - xfs_free_extent() calls xfs_free_ag_extent(), which attempts to merge 
> the
> freed extents from left and from right in the by-bno btree. Then the 
> by-size
> btree is updated accordingly.
> - xfs_free_extent marks the original (un-merged) extent as "busy" by
> xfs_extent_busy_insert(). This prevents this original extent from being
> allocated. (Except that for metadata allocations such extent or part of it
> can be "unbusied", while it is still not marked for discard with
> XFS_EXTENT_BUSY_DISCARDED).
> - Once the appropriate part of the log is committed, xlog_cil_committed
> calls xfs_discard_extents. This discards the extents using the synchronous
> blkdev_issue_discard() API, and only them "unbusies" the extents. This 
> makes
> sense, because we cannot allow allocating these extents until discarding
> completed.
>
> WRT to this flow, I have some questions:
>
> - xfs_free_extent first inserts the extent into the free-space btrees, and
> only then marks it as busy. How come there is no race window here?

Because the AGF is locked exclusively at this point, meaning only
one process can be modifying the free space tree at this point in
time.

> Can
> somebody allocate the freed extent before it is marked as busy? Or the
> free-space btrees somehow are locked at this point? The code says 
> "validate
> the extent size is legal now we have the agf locked". I more or less see
> that xfs_alloc_fix_freelist() locks *something*, but I don't see
> xfs_free_extent() unlocking anything.

The AGF remains locked until the transaction is committed. The
transaction commit code unlocks items modified in the transaction
via the ->iop_unlock log item callback....

> - If xfs_extent_busy_insert() fails to alloc a xfs_extent_busy structure,
> such extent cannot be discarded, correct?

Correct.

> - xfs_discard_extents() doesn't check the discard granularity of the
> underlying block device, like xfs_ioc_trim() does. So it may send a small
> discard request, which cannot be handled.

Discard is a "advisory" operation - it is never guaranteed to do
anything.

> If it would have checked the
> granularity, it could have avoided sending small requests. But the thing 
> is
> that the busy extent might have been merged in the free-space btree into a
> larger extent, which is now suitable for discard.

Sure, but the busy extent tree tracks extents across multiple
transaction contexts, and we cannot merge extents that are in
different contexts.

> I want to attempt the following logic in xfs_discard_extents():
> # search the "by-bno" free-space btree for a larger extent that fully
> encapsulates the busy extent (which we want to discard)
> # if found, check whether some other part of the larger extent is still 
> busy
> (except for the current busy extent we want to discard)
> # if no, send discard for the larger extent
> Does this make send? And I think that we need to hold the larger
> extent locked somehow until the
> discard completes, to prevent allocation from the discarded range.

You can't search the freespace btrees in log IO completion context -
that will cause deadlocks because we can be holding the locks
searching the freespace trees when we issue a log force and block
waiting for log IO completion to occur. e.g. in
xfs_extent_busy_reuse()....

Also, walking the free space btrees can be an IO bound operation,
overhead/latency we absolutely do not want to add to log IO completion.

Further, walking the free space btrees can be a memory intensive
operation (buffers are demand paged from disk) and log IO completion
may be necessary for memory reclaim to make progress in low memory
situations. So adding unbound memory demand to log IO completion
will cause low memory deadlocks, too.

IOWs, adding freespace tree processing to xfs_discard_extents() just
won't work.

What we really need is a smarter block layer implementation of the
discard operation - it needs to be asynchronous, and it needs to
support merging of adjacent discard requests. Now that SATA 3.1
devices are appearing on the market, queued trim operations are now
possible. Dispatching discard oeprations as synchronous operations
prevents us from taking advantage of these operations. Further,
because it's synchronous, the block layer can't merge adjacent
discards, not batch multiple discard ranges up into a single TRIM
command.

IOWs, what we really need is for the block layer discard code to be
brought up to the capabilities of the hardware on the market first.
Then we will be in a position to be able to optimise the XFS code to
use async dispatch and new IO completion handlers to finish the log
IO completion processing, and at that point we shouldn't need to
care anymore. Note that XFS already dispatches discards in ascending
block order, so if we issue adjacent discards the block layer will
be able to merge them appropriately. Hence we don't need to add that
complexity to XFS....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
