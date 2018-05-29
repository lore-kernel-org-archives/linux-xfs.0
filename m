Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:12123 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932479AbeE2DKE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 May 2018 23:10:04 -0400
Date: Tue, 29 May 2018 13:10:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 03/22] xfs: add helpers to collect and sift btree
 block pointers during repair
Message-ID: <20180529031001.GJ10363@dastard>
References: <152642361893.1556.9335169821674946249.stgit@magnolia>
 <152642363794.1556.12771807615463619233.stgit@magnolia>
 <20180518035155.GZ23858@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180518035155.GZ23858@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Allison Henderson <allison.henderson@oracle.com>

On Thu, May 17, 2018 at 08:51:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add some helpers to assemble a list of fs block extents.  Generally,
> repair functions will iterate the rmapbt to make a list (1) of all
> extents owned by the nominal owner of the metadata structure; then they
> will iterate all other structures with the same rmap owner to make a
> list (2) of active blocks; and finally we have a subtraction function to
> subtract all the blocks in (2) from (1), with the result that (1) is now
> a list of blocks that were owned by the old btree and must be disposed.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: document the design of how repair functions are supposed to work,
>     implement review comments
> ---

Much easier to understand now. Thanks!

Reviewed-by: Dave Chinner <dchinner@redhat.com>

One thing for a followup patch, though.

> +/* Collect a dead btree extent for later disposal. */
> +int
> +xfs_repair_collect_btree_extent(
> +	struct xfs_scrub_context	*sc,
> +	struct xfs_repair_extent_list	*exlist,
> +	xfs_fsblock_t			fsbno,
> +	xfs_extlen_t			len)
> +{
> +	struct xfs_repair_extent	*rex;
> +
> +	trace_xfs_repair_collect_btree_extent(sc->mp,
> +			XFS_FSB_TO_AGNO(sc->mp, fsbno),
> +			XFS_FSB_TO_AGBNO(sc->mp, fsbno), len);
> +
> +	rex = kmem_alloc(sizeof(struct xfs_repair_extent), KM_MAYFAIL);
> +	if (!rex)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&rex->list);
> +	rex->fsbno = fsbno;
> +	rex->len = len;

This allocation is repeated a couple of times. Single function to do
it would be nice to encapsulate alloc+setup - something like rex =
alloc_rex(fsbno, len) which returns NULL if it fails.

> +		case LEFT_ALIGNED | RIGHT_ALIGNED:
> +			/* Total overlap, just delete ex. */
> +			lp = lp->next;
> +			list_del(&ex->list);
> +			kmem_free(ex);
> +			break;
> +		case 0:
> +			/*
> +			 * Deleting from the middle: add the new right extent
> +			 * and then shrink the left extent.
> +			 */
> +			newex = kmem_alloc(sizeof(struct xfs_repair_extent),
> +					KM_MAYFAIL);
> +			if (!newex) {
> +				error = -ENOMEM;
> +				goto out;
> +			}
> +			INIT_LIST_HEAD(&newex->list);
> +			newex->fsbno = sub_fsb + sub_len;
> +			newex->len = ex->fsbno + ex->len - newex->fsbno;

This is the other place it is called...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
