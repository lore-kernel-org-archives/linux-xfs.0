Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56590 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbfBASjR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 13:39:17 -0500
Subject: Re: [PATCH 2/2] xfs_repair: correctly account for free space btree
 shrinks when fixing freelist
References: <154887062444.5611.12746798208748899665.stgit@magnolia>
 <154887063081.5611.2097236157481583596.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <01d11bd4-3e99-e267-5e76-7c3fc7162558@sandeen.net>
Date: Fri, 1 Feb 2019 12:39:16 -0600
MIME-Version: 1.0
In-Reply-To: <154887063081.5611.2097236157481583596.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/30/19 11:50 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we fix the freelist at the end of build_agf_agfl in phase 5 of
> repair, we need to create incore rmap records for the blocks that get
> added to the AGFL.  We can't let the regular freelist fixing code use
> the regular on-disk rmapbt update code because the rmapbt isn't fully
> set up yet.
> 
> Unfortunately, the original code fails to account for the fact that the
> free space btrees can shrink when we allocate blocks to fix the
> freelist; those blocks are also put on the freelist, but there are
> already incore rmaps for all the free space btree blocks.  We must not
> create (redundant) incore rmaps for those blocks.  If we do, repair
> fails with a complaint that rebuilding the rmapbt failed during phase 5.
> xfs/137 on a 1k block size occasionally triggers this bug.
> 
> To fix the problem, construct a bitmap of all OWN_AG blocks that we know
> about before traversing the AGFL, and only create new incore rmaps for
> those AGFL blocks that are not already tracked in the bitmap.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/rmap.c |   54 ++++++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 44 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/repair/rmap.c b/repair/rmap.c
> index c5a86646..3bb05065 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -12,6 +12,7 @@
>  #include "dinode.h"
>  #include "slab.h"
>  #include "rmap.h"
> +#include "bitmap.h"
>  
>  #undef RMAP_DEBUG
>  
> @@ -450,6 +451,8 @@ rmap_store_ag_btree_rec(
>  	struct xfs_buf		*agflbp = NULL;
>  	struct xfs_trans	*tp;
>  	__be32			*agfl_bno, *b;
> +	struct xfs_ag_rmap	*ag_rmap = &ag_rmaps[agno];
> +	struct bitmap		*own_ag_bitmap = NULL;
>  	int			error = 0;
>  	struct xfs_owner_info	oinfo;
>  
> @@ -457,9 +460,8 @@ rmap_store_ag_btree_rec(
>  		return 0;
>  
>  	/* Release the ar_rmaps; they were put into the rmapbt during p5. */
> -	free_slab(&ag_rmaps[agno].ar_rmaps);
> -	error = init_slab(&ag_rmaps[agno].ar_rmaps,
> -				  sizeof(struct xfs_rmap_irec));
> +	free_slab(&ag_rmap->ar_rmaps);
> +	error = init_slab(&ag_rmap->ar_rmaps, sizeof(struct xfs_rmap_irec));
>  	if (error)
>  		goto err;
>  
> @@ -479,19 +481,50 @@ rmap_store_ag_btree_rec(
>  	 * rmap, we only need to add rmap records for AGFL blocks past
>  	 * that point in the AGFL because those blocks are a result of a
>  	 * no-rmap no-shrink freelist fixup that we did earlier.
> +	 *
> +	 * However, some blocks end up on the AGFL because the free space
> +	 * btrees shed blocks as a result of allocating space to fix the
> +	 * freelist.  We already created in-core rmap records for the free
> +	 * space btree blocks, so we must be careful not to create those
> +	 * records again.  Create a bitmap of already-recorded OWN_AG rmaps.
>  	 */
> +	error = init_slab_cursor(ag_rmap->ar_raw_rmaps, rmap_compare, &rm_cur);
> +	if (error)
> +		goto err;
> +	if (!bitmap_init(&own_ag_bitmap)) {
> +		error = -ENOMEM;
> +		goto err;

I think that this ^^

> +	}
> +	while ((rm_rec = pop_slab_cursor(rm_cur)) != NULL) {
> +		if (rm_rec->rm_owner != XFS_RMAP_OWN_AG)
> +			continue;
> +		if (!bitmap_set(own_ag_bitmap, rm_rec->rm_startblock,
> +					rm_rec->rm_blockcount)) {
> +			error = EFSCORRUPTED;
> +			goto err;

and this need to free up rm_cur to be tidy, right?

-Eric
