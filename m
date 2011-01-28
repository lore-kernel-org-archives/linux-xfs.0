Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0SMFQSC176264 for <xfs@oss.sgi.com>; Fri, 28 Jan 2011 16:15:26 -0600
Subject: Re: [PATCH 4/6] xfs: optimize xfs_alloc_fix_freelist
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110121092551.185804716@bombadil.infradead.org>
References: <20110121092227.115815324@bombadil.infradead.org>
	<20110121092551.185804716@bombadil.infradead.org>
Date: Fri, 28 Jan 2011 16:17:48 -0600
Message-ID: <1296253068.2342.282.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Fri, 2011-01-21 at 04:22 -0500, Christoph Hellwig wrote:
> plain text document attachment
> (xfs-avoid-sync-transaction-for-freelist-refill)
> If we shorten the freelist in xfs_alloc_fix_freelist there is no need
> to wait for busy blocks as they will be marked busy again when we call
> xfs_free_ag_extent.  Avoid this by not marking blocks coming from the
> freelist as busy in xfs_free_ag_extent, and not marking transactions
> with busy extents as synchronous in xfs_alloc_get_freelist.  Unlike
> xfs_free_ag_extent which already has the isfl argument,
> xfs_alloc_get_freelist needs to be told about the usage of the blocks
> it returns.  For this we extend the btreeblk flag to a type argument
> which specifies in detail what the block is going to be used for.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Now that I've found my way through the paths that this
code touches (Dave's analysis helped a lot), I understand
what you're doing and I think it looks good.

I agree that the XFS_FREELIST_* symbols need a little
explanation.

And on a broader subject, it might be nice if the sort
of lifecycle of this kind of thing was documented
somewhere (maybe it is).  It would be really cool if
certain changes could point to a Wiki page with a
diagram of what's going on or something.  Nah...

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
