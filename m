Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7U1SQcL100005 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 20:28:26 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C4FB13ACCD7
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 18:31:41 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Fq0DdOzf4lDRNDE0 for <xfs@oss.sgi.com>;
	Mon, 29 Aug 2011 18:31:41 -0700 (PDT)
Date: Tue, 30 Aug 2011 11:28:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS metadata flushing design - current and future
Message-ID: <20110830012820.GI3162@dastard>
References: <20110827080321.GA16661@infradead.org>
	<20110829010149.GE3162@dastard>
	<20110829123318.GA12928@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110829123318.GA12928@infradead.org>
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

On Mon, Aug 29, 2011 at 08:33:18AM -0400, Christoph Hellwig wrote:
> On Mon, Aug 29, 2011 at 11:01:49AM +1000, Dave Chinner wrote:
> > Another thing I've noticed is that AIL pushing of dirty inodes can
> > be quite inefficient from a CPU usage perspective. Inodes that have
> > already been flushed to their backing buffer results in a
> > IOP_PUSHBUF call when the AIL tries to push them. Pushing the buffer
> > requires a buffer cache search, followed by a delwri list promotion.
> > However, the initial xfs_iflush() call on a dirty inode also
> > clusters all the other remaining dirty inodes in the buffer to the
> > buffer. When the AIl hits those other dirty inodes, they are already
> > locked and so we do a IOP_PUSHBUF call. On every other dirty inode.
> > So on a completely dirty inode cluster, we do ~30 needless buffer
> > cache searches and buffer delwri promotions all for the same buffer.
> > That's a lot of extra work we don't need to be doing - ~10% of the
> > buffer cache lookups come from IOP_PUSHBUF under inode intensive
> > metadata workloads:
> 
> One really stupid thing we do in that area is that the xfs_iflush from
> xfs_inode_item_push puts the buffer at the end of the delwri list and
> expects it to be aged, just so that the first xfs_inode_item_pushbuf
> can promote it to the front of the list.  Now that we mostly write
> metadata from AIL pushing

Actually, when we have lots of data to be written, we still call
xfs_iflush() a lot from .write_inode. That's where the delayed write
buffer aging has significant benefit.

> we should not do an additional pass of aging
> on that - that's what we already the AIL for.  Once we did that we
> should be able to remove the buffer promotion and make the pushuf a
> no-op. 

If we remove the promotion, then it can be up to 15s before the IO
is actually dispatched, resulting in long stalls until the buffer
ages out. That's the problem that I introduced the promotion to fix.
Yes, the inode writeback code has changed a bit since then, but not
significantly enough to remove that problem.

> The only thing this might interact with in a not so nice way
> would be inode reclaim if it still did delwri writes with the delay
> period, but we might be able to get away without that one as well.

Right - if we only ever call xfs_iflush() from IOP_PUSH() and
shrinker based inode reclaim, then I think this problem mostly
goes away. We'd still need the shrinker path to be able to call 
xfs_iflush() for synchronous inode cluster writeback as that is the
method by which we ensure memory reclaim makes progress....

To make this work, rather than doing the current "pushbuf" operation
on inodes, lets make xfs_iflush() return the backing buffer locked
rather than submitting IO on it directly. Then the caller can submit
the buffer IO however it wants. That way reclaim can do synchronous
IO, and for the AIL pusher we can add the buffer to a local list
that we can then submit for IO rather than the current xfsbufd
wakeup call we do. All inodes we see flush locked in IOP_PUSH we can
then ignore, knowing that they are either currently under IO or on
the local list pending IO submission. Either way, we don't need to
try a pushbuf operation on flush locked inodes.

[ IOWs, the xfs_inode_item_push() simply locks the inode and returns
PUSHBUF if it needs flushing, then xfs_inode_item_pushbuf() calls
xfs_iflush() and gets the dirty buffer back, which it then adds the
buffer to a local dispatch list rather than submitting IO directly. ]

---

FWIW, what this discussion is indicating to me is that we should
timestamp entries in the AIL so we can push it to a time threshold
as well as a LSN threshold.

That is, whenever we insert a new entry into the AIL, we not only
update the LSN and position, we also update the insert time of the
buffer. We can then update the time based threshold every few
seconds and have the AIL wq walker walk until the time threshold is
reached pushing items to disk. This would also make the xfssyncd
"push the entire AIL" change to "push anything older than 30s" which
is much more desirable from a sustained workload POV.

If we then modify the way all buffers are treated such that
the AIL is the "delayed write list" (i.e. we take a reference count
to the buffer when it is first logged and not in the AIL) and the
pushbuf operations simply add the buffer to the local dispatch list,
we can get rid of the delwri buffer list altogether. That also gets
rid of the xfsbufd, too, as the AIL handles the aging, reference
counting and writeback of the buffers entirely....

> > Also, larger inode buffers to reduce the amount of IO we do to both
> > read and write inodes might also provide significant benefits by
> > reducing the amount of IO and number of buffers we need to track in
> > the cache...
> 
> We could try to get for large in-core clusters.  That is try to always
> allocate N aligned inode clusters together, and always read/write
> clusters in that alignment together if possible.

Well, just increasing the cluster buffer to cover an entire inode
chunk for common inode sizes (16k for 256 byte inodes and 32k for
512 byte inodes) would make a significant difference, I think.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
