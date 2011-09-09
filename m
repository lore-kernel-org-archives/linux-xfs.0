Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89Ntr1c066526 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 18:55:53 -0500
Subject: Re: [PATCH 14/25] xfs: remove xfs_bmap_add_extent
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060643.401685261@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060643.401685261@bombadil.infradead.org>
Date: Fri, 9 Sep 2011 18:55:49 -0500
Message-ID: <1315612549.1999.129.camel@doink>
MIME-Version: 1.0
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

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-bmapi-split-xfs_bmap_extent-2)
> There is no real need to the xfs_bmap_add_extent, as the callers know what
> kind of extents they need to it.  Removing it means duplicating the
> extents to btree conversion logic in three places, but overall it's still
> a lot less, and much simpler code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Not really a *lot* less code, but it is an improvement.

Simple question below (coding style) but this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


. . .

>  
> +#ifdef DEBUG
> +STATIC void
> +xfs_bmap_check_leaf_extents(
> +	struct xfs_btree_cur	*cur,
> +	struct xfs_inode	*ip,
> +	int			whichfork);
> +#else
> +#define xfs_bmap_check_leaf_extents(cur, ip, whichfork)		do { } while (0)
> +#endif

Why do you use "do {} while (0)" rather than just an empty right
hand side? 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
