Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U6B8lp186126 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:11:09 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B9FD91E57017
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 23:11:05 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	YMMYnvCSiDpBydmc for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 23:11:05 -0700 (PDT)
Date: Thu, 30 Jun 2011 16:11:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/27] xfs: factor out xfs_dir2_leaf_find_entry
Message-ID: <20110630061102.GG561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140339.086201354@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110629140339.086201354@bombadil.infradead.org>
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

On Wed, Jun 29, 2011 at 10:01:22AM -0400, Christoph Hellwig wrote:
> Add a new xfs_dir2_leaf_find_entry helper to factor out some duplicate code
> from xfs_dir2_leaf_addname xfs_dir2_leafn_add.  Found by Eric Sandeen using
> an automated code duplication checked.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks sane - a couple of minor whitespacy comments, otherwise:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> 
> Index: xfs/fs/xfs/xfs_dir2_leaf.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_dir2_leaf.c	2011-06-22 21:56:26.102462981 +0200
> +++ xfs/fs/xfs/xfs_dir2_leaf.c	2011-06-23 12:41:51.716439911 +0200
> @@ -152,6 +152,118 @@ xfs_dir2_block_to_leaf(
>  	return 0;
>  }
>  
> +xfs_dir2_leaf_entry_t *
> +xfs_dir2_leaf_find_entry(
> +	xfs_dir2_leaf_t		*leaf,		/* leaf structure */
> +	int			index,		/* leaf table position */
> +	int			compact,	/* need to compact leaves */
> +	int			lowstale,	/* index of prev stale leaf */
> +	int			highstale,	/* index of next stale leaf */
> +	int			*lfloglow,	/* low leaf logging index */
> +	int			*lfloghigh)	/* high leaf logging index */
> +{
> +	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry table pointer */
> +
> +	if (!leaf->hdr.stale) {
> +		/*
> +		 * Now we need to make room to insert the leaf entry.
> +		 *
> +		 * If there are no stale entries, just insert a hole at index.
> +		 */
> +		lep = &leaf->ents[index];
> +		if (index < be16_to_cpu(leaf->hdr.count))
> +			memmove(lep + 1, lep,
> +				(be16_to_cpu(leaf->hdr.count) - index) *
> +				 sizeof(*lep));
> +
> +		/*
> +		 * Record low and high logging indices for the leaf.
> +		 */
> +		*lfloglow = index;
> +		*lfloghigh = be16_to_cpu(leaf->hdr.count);
> +		be16_add_cpu(&leaf->hdr.count, 1);

You could probably just return here, and that would remove the:

> +	} else {

and the indenting that the else branch causes.

> +		/*
> +		 * There are stale entries.
> +		 *
> +		 * We will use one of them for the new entry.  It's probably
> +		 * not at the right location, so we'll have to shift some up
> +		 * or down first.
> +		 *
> +		 * If we didn't compact before, we need to find the nearest
> +		 * stale entries before and after our insertion point.
> +		 */
> +		if (compact == 0) {
> +			/*
> +			 * Find the first stale entry before the insertion
> +			 * point, if any.
> +			 */
> +			for (lowstale = index - 1;
> +			     lowstale >= 0 &&
> +				be32_to_cpu(leaf->ents[lowstale].address) !=
> +				XFS_DIR2_NULL_DATAPTR;
> +			     lowstale--)
> +				continue;
> +			/*
> +			 * Find the next stale entry at or after the insertion
> +			 * point, if any.   Stop if we go so far that the
> +			 * lowstale entry would be better.
> +			 */
> +			for (highstale = index;
> +			     highstale < be16_to_cpu(leaf->hdr.count) &&
> +				be32_to_cpu(leaf->ents[highstale].address) !=
> +				XFS_DIR2_NULL_DATAPTR &&
> +				(lowstale < 0 ||
> +				 index - lowstale - 1 >= highstale - index);
> +			     highstale++)
> +				continue;
> +		}
> +		/*
> +		 * If the low one is better, use it.
> +		 */

Line of whitespace before the comment.

> +		if (lowstale >= 0 &&
> +		    (highstale == be16_to_cpu(leaf->hdr.count) ||
> +		     index - lowstale - 1 < highstale - index)) {
> +			ASSERT(index - lowstale - 1 >= 0);
> +			ASSERT(be32_to_cpu(leaf->ents[lowstale].address) ==
> +			       XFS_DIR2_NULL_DATAPTR);
> +			/*
> +			 * Copy entries up to cover the stale entry
> +			 * and make room for the new entry.
> +			 */
> +			if (index - lowstale - 1 > 0)
> +				memmove(&leaf->ents[lowstale],
> +					&leaf->ents[lowstale + 1],
> +					(index - lowstale - 1) * sizeof(*lep));
> +			lep = &leaf->ents[index - 1];
> +			*lfloglow = MIN(lowstale, *lfloglow);
> +			*lfloghigh = MAX(index - 1, *lfloghigh);
> +
> +		/*
> +		 * The high one is better, so use that one.
> +		 */
> +		} else {

I prefer comments inside the else branch...

> +			ASSERT(highstale - index >= 0);
> +			ASSERT(be32_to_cpu(leaf->ents[highstale].address) ==
> +			       XFS_DIR2_NULL_DATAPTR);
> +			/*
> +			 * Copy entries down to cover the stale entry
> +			 * and make room for the new entry.
> +			 */
> +			if (highstale - index > 0)
> +				memmove(&leaf->ents[index + 1],
> +					&leaf->ents[index],
> +					(highstale - index) * sizeof(*lep));
> +			lep = &leaf->ents[index];
> +			*lfloglow = MIN(index, *lfloglow);
> +			*lfloghigh = MAX(highstale, *lfloghigh);
> +		}
> +		be16_add_cpu(&leaf->hdr.stale, -1);
> +	}
> +
> +	return lep;
> +}
> +
>  /*
>   * Add an entry to a leaf form directory.
>   */
> @@ -430,102 +542,11 @@ xfs_dir2_leaf_addname(
.....
> -		}
> -		be16_add_cpu(&leaf->hdr.stale, -1);
> -	}
> +
> +
> +	lep = xfs_dir2_leaf_find_entry(leaf, index, compact, lowstale,
> +				       highstale, &lfloglow, &lfloghigh);
> +

Only need one line of whitespace before the function call.

.....
> -			lep = &leaf->ents[index];
> -			lfloglow = MIN(index, lfloglow);
> -			lfloghigh = MAX(highstale, lfloghigh);
> -		}
> -		be16_add_cpu(&leaf->hdr.stale, -1);
> -	}
> +
> +
>  	/*
>  	 * Insert the new entry, log everything.
>  	 */
> +	lep = xfs_dir2_leaf_find_entry(leaf, index, compact, lowstale,
> +				       highstale, &lfloglow, &lfloghigh);
> +

Same for the whitespace before the comment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
