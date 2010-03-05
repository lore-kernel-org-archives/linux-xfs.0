Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o259Jdad237712 for <xfs@oss.sgi.com>; Fri, 5 Mar 2010 03:19:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E6C01D17515
	for <xfs@oss.sgi.com>; Fri,  5 Mar 2010 01:21:07 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gAZA3BFwCZNOU0Au for
	<xfs@oss.sgi.com>; Fri, 05 Mar 2010 01:21:07 -0800 (PST)
Date: Fri, 5 Mar 2010 04:21:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: truncate delalloc extents when IO fails in
	writeback
Message-ID: <20100305092105.GA1499@infradead.org>
References: <1267667185-7736-1-git-send-email-david@fromorbit.com>
	<1267667185-7736-3-git-send-email-david@fromorbit.com>
	<20100304142851.GA19157@infradead.org>
	<20100304220309.GI14317@discord.disaster>
	<20100305020042.GM14317@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100305020042.GM14317@discord.disaster>
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

On Fri, Mar 05, 2010 at 01:00:42PM +1100, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently use block_invalidatepage() to clean up pages where I/O
> fails in ->writepage(). Unfortunately, if the page has delalloc
> regions on it, we fail to remove the delalloc regions when we
> invalidate the page.  This can result in tripping a BUG() in
> xfs_get_blocks() later on if a direct IO read is done on that same
> region - the delalloc extent is returned when none is supposed to be
> there.
> 
> Fix this by truncating away the delalloc regions on the page before
> invalidating it. Because they are delalloc, we can do this without
> needing a transaction. Indeed - if we get ENOSPC errors, we have to
> be able to do this truncation without a transaction as there is
> no space left for block reservation (typically why we see a ENOSPC
> in writeback).

Looks good.  I also like the new assert to ensure no blocks actually
get freed.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
