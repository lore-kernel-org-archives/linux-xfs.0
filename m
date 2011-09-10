Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8AIntPX122826 for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 13:49:55 -0500
Date: Sat, 10 Sep 2011 14:49:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 14/25] xfs: remove xfs_bmap_add_extent
Message-ID: <20110910184928.GA4750@infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060643.401685261@bombadil.infradead.org>
	<1315612549.1999.129.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315612549.1999.129.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Sep 09, 2011 at 06:55:49PM -0500, Alex Elder wrote:
> On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> > plain text document attachment (xfs-bmapi-split-xfs_bmap_extent-2)
> > There is no real need to the xfs_bmap_add_extent, as the callers know what
> > kind of extents they need to it.  Removing it means duplicating the
> > extents to btree conversion logic in three places, but overall it's still
> > a lot less, and much simpler code.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Not really a *lot* less code, but it is an improvement.
> 
> Simple question below (coding style) but this looks good.

It's about 70 lines.  I've toned the description down a bit for the next
version.

> > +STATIC void
> > +xfs_bmap_check_leaf_extents(
> > +	struct xfs_btree_cur	*cur,
> > +	struct xfs_inode	*ip,
> > +	int			whichfork);
> > +#else
> > +#define xfs_bmap_check_leaf_extents(cur, ip, whichfork)		do { } while (0)
> > +#endif
> 
> Why do you use "do {} while (0)" rather than just an empty right
> hand side? 

That way it can safely be used e.g. inside single-line conditionals
without braces. It's an idiom used quite a lot in the kernel.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
