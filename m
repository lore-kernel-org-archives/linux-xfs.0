Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6BMWtki256209 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 17:32:55 -0500
Subject: Re: [PATCH 03/11] xfs: factor out xfs_dir2_leaf_find_stale
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110710205017.293539533@bombadil.infradead.org>
References: <20110710204916.856267100@bombadil.infradead.org>
	<20110710205017.293539533@bombadil.infradead.org>
Date: Mon, 11 Jul 2011 17:32:53 -0500
Message-ID: <1310423573.7019.55.camel@doink>
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

On Sun, 2011-07-10 at 16:49 -0400, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

OK, I guess this is fine.  I have a suggestion below
but I see nothing truly wrong with what you have.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/xfs_dir2_leaf.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-07-09 12:07:49.518499801 +0200
> +++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-07-09 12:19:48.171796748 +0200
> @@ -148,6 +148,36 @@ xfs_dir2_block_to_leaf(
>  	return 0;
>  }
>  
> +STATIC void
> +xfs_dir2_leaf_find_stale(
> +	struct xfs_dir2_leaf	*leaf,
> +	int			index,
> +	int			*lowstale,
> +	int			*highstale)
> +{
> +	/*
> +	 * Find the first stale entry before our index, if any.
> +	 */
> +	for (*lowstale = index - 1;
> +	     *lowstale >= 0 &&
> +		leaf->ents[*lowstale].address !=
> +		cpu_to_be32(XFS_DIR2_NULL_DATAPTR);
> +	     --*lowstale)
> +		continue;
> +
> +	/*
> +	 * Find the first stale entry at or after our index, if any.
> +	 * Stop if the answer would be worse than lowstale.

              Stop if the result would require moving more
              entries than using lowstale.

(I realize you didn't change this comment, you just moved
it into this helper function.)

Actually it seems like this searching of the stale
entries and moving things around among them could
be broken into a few even finer-grained utility
routines.  It just seems like what this code is
doing is simpler than what the code complexity
suggests (though I haven't really looked at this
stuff much before).

> +	 */
> +	for (*highstale = index;
> +	     *highstale < be16_to_cpu(leaf->hdr.count) &&
> +		leaf->ents[*highstale].address !=
> +		cpu_to_be32(XFS_DIR2_NULL_DATAPTR) &&
> +		(*lowstale < 0 || index - *lowstale > *highstale - index);
> +	     ++*highstale)
> +		continue;
> +}
> +
>  struct xfs_dir2_leaf_entry *
>  xfs_dir2_leaf_find_entry(
>  	xfs_dir2_leaf_t		*leaf,		/* leaf structure */

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
