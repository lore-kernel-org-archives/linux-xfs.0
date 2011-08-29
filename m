Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7TCXMDX071796 for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 07:33:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D66291B8AC7E
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2011 05:33:21 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	G3B7aI9PB90Wkg27 for <xfs@oss.sgi.com>;
	Mon, 29 Aug 2011 05:33:21 -0700 (PDT)
Date: Mon, 29 Aug 2011 08:33:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS metadata flushing design - current and future
Message-ID: <20110829123318.GA12928@infradead.org>
References: <20110827080321.GA16661@infradead.org>
	<20110829010149.GE3162@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110829010149.GE3162@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Aug 29, 2011 at 11:01:49AM +1000, Dave Chinner wrote:
> Another thing I've noticed is that AIL pushing of dirty inodes can
> be quite inefficient from a CPU usage perspective. Inodes that have
> already been flushed to their backing buffer results in a
> IOP_PUSHBUF call when the AIL tries to push them. Pushing the buffer
> requires a buffer cache search, followed by a delwri list promotion.
> However, the initial xfs_iflush() call on a dirty inode also
> clusters all the other remaining dirty inodes in the buffer to the
> buffer. When the AIl hits those other dirty inodes, they are already
> locked and so we do a IOP_PUSHBUF call. On every other dirty inode.
> So on a completely dirty inode cluster, we do ~30 needless buffer
> cache searches and buffer delwri promotions all for the same buffer.
> That's a lot of extra work we don't need to be doing - ~10% of the
> buffer cache lookups come from IOP_PUSHBUF under inode intensive
> metadata workloads:

One really stupid thing we do in that area is that the xfs_iflush from
xfs_inode_item_push puts the buffer at the end of the delwri list and
expects it to be aged, just so that the first xfs_inode_item_pushbuf
can promote it to the front of the list.  Now that we mostly write
metadata from AIL pushing we should not do an additional pass of aging
on that - that's what we already the AIL for.  Once we did that we
should be able to remove the buffer promotion and make the pushuf a
no-op.  The only thing this might interact with in a not so nice way
would be inode reclaim if it still did delwri writes with the delay
period, but we might be able to get away without that one as well.

> Also, larger inode buffers to reduce the amount of IO we do to both
> read and write inodes might also provide significant benefits by
> reducing the amount of IO and number of buffers we need to track in
> the cache...

We could try to get for large in-core clusters.  That is try to always
allocate N aligned inode clusters together, and always read/write
clusters in that alignment together if possible.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
