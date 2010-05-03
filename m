Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o434Le1Y130030 for <xfs@oss.sgi.com>; Sun, 2 May 2010 23:21:40 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7A2A6306F7E
	for <xfs@oss.sgi.com>; Sun,  2 May 2010 21:23:46 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	qKAxlio6K0pGfWwy for <xfs@oss.sgi.com>;
	Sun, 02 May 2010 21:23:46 -0700 (PDT)
Date: Mon, 3 May 2010 14:23:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] [PATCH] xfs: simplify buffer to transaction matching
Message-ID: <20100503042343.GD2591@dastard>
References: <20100418001041.865247520@bombadil.infradead.org>
	<20100418001058.677429475@bombadil.infradead.org>
	<20100420064155.GH15130@dastard>
	<20100501125839.GA26342@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100501125839.GA26342@infradead.org>
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

On Sat, May 01, 2010 at 08:58:39AM -0400, Christoph Hellwig wrote:
> On Tue, Apr 20, 2010 at 04:41:55PM +1000, Dave Chinner wrote:
> > Good start, but I think that it should use xfs_trans_first_item()
> > and xfs_trans_next_item() rather than walking the descriptor
> > table directly.
> 
> I tried implementing it, but it doesn't work.  We can call the buffer
> matching routines on transactions that don't have any item linked to
> it, which will cause xfs_trans_first_item to panic.  Compare this code
> in xfs_trans_buf_item_match:
> 
> 	for (licp = &tp->t_items; licp != NULL; licp = licp->lic_next) {
> 		if (xfs_lic_are_all_free(licp)) {
> 			ASSERT(licp == &tp->t_items);
> 			ASSERT(licp->lic_next == NULL);
> 			return NULL;
> 		}
> 
> 		...
> 	}
> 
> to this in xfs_trans_first_item:
> 
> 	licp = &tp->t_items;
>         /*
> 	 * If it's not in the first chunk, skip to the second.
> 	 */
> 	if (xfs_lic_are_all_free(licp)) {
> 		licp = licp->lic_next;
> 	}
> 
> 	/*
> 	 * Return the first non-free descriptor in the chunk.
> 	 */
> 	ASSERT(!xfs_lic_are_all_free(licp));

Is there any reason why xfs_trans_first_item() should panic if it
doesn't find a log item? I can't think of one that can't be handled
by returning NULL and the caller doing ASSERT(lidp)? The callers:

	xfs_trans_count_vecs - has assert, triggers shutdown
	xfs_trans_fill_vecs - has assert, handles null return
	xfs_trans_committed - handles null return
	xfs_trans_uncommit - handles null return

So it seems like we could make xfs_trans_first_item() not assert
fail on debug kernels.

The other thing that concerns me is that we have two different
definitions of "empty transactions" in these two functions. It seems
to me that xfs_trans_first_item() is the correct one - if we remove
items from the transaction there is no guarantee that the embedded
chunk in the transaction contains any active descriptors. Hence I
think the code in xfs_trans_buf_item_match[_all]() is actually
buggy...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
