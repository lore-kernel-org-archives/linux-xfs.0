Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBUBdRv3240569 for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 05:39:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D9F211072BC
	for <xfs@oss.sgi.com>; Thu, 30 Dec 2010 03:41:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DTiSnRqkK02p6XWQ for
	<xfs@oss.sgi.com>; Thu, 30 Dec 2010 03:41:31 -0800 (PST)
Date: Thu, 30 Dec 2010 06:41:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs: add FITRIM support
Message-ID: <20101230114129.GA4321@infradead.org>
References: <20101125112304.GA4195@infradead.org>
	<20101223014409.GL4907@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101223014409.GL4907@dastard>
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
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Thu, Dec 23, 2010 at 12:44:09PM +1100, Dave Chinner wrote:
> Hmmmm - if we are given a range to trim, wouldn't we do better to
> walk the by-bno btree instead?  i.e, we have two different cases
> here - trim an entire AG, and trim part of an AG given by {start, end}. 
> 
> We only need these range checks on the AGs that are only partially
> trimmed, and it would seem more efficient to me to walk the by-bno
> tree for those rather than walk the by-size tree trying to find
> range matches.

It might be, but I'm not sure it's really worth the complexity.  I can't
really find any good use case for a partially trim anyway.

Ccing Lukas to figure out what his intent with this was.

> Hmmm - so we hold the agf locked for the entire trim? That's a bit
> ugly. Given this is best effort, we could avoid this by changing it
> to something like:
> 
> 	longest = 0;
> 	do {
> 		lock agf
> 		force log
> 		if (!longest)
> 			longest = agf->longest
> 		init cursor
> 		do {
> 			xfs_alloc_lookup_le(longest)
> 			alloc_get_rec(&fbno, &flen)
> 			check flen
> 			busy search
> 			discard
> 			decrement cursor
> 		} while (flen == longest)
> 		destroy cursor
> 		unlock agf
> 		longest = flen;
> 	} while(1)

This doesn't seem overly efficient.  Unless we have lots of extents
with same size we keep having to allocate new cursors all the time.

I'm not too worried about busy systems - FITRIM is explicitly called and
we should expect admins not to call it during the most busy time of the
day.  And even in it's current form it's already much better than
wiper.sh in that respect.

I think adding a periodical break using a modified scheme is fine, but
I'd really like to get the code out into some more testers hands for
now.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
