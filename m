Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55524 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750911AbeAPMus (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Jan 2018 07:50:48 -0500
Date: Tue, 16 Jan 2018 07:50:45 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 4/5] xfs: attr leaf verifier needs to check for
 obviously bad count
Message-ID: <20180116125044.GB52295@bfoster.bfoster>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
 <151579466415.8694.4992590880368427655.stgit@magnolia>
 <20180115200527.GE5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180115200527.GE5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 15, 2018 at 12:05:27PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In the attribute leaf verifier, we can check for obviously bad values of
> firstused and count so that later attempts at lasthash don't run off the
> end of the memory buffer.  Found by ones fuzzing hdr.count in xfs/400 with
> KASAN.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: strengthen checking, clarify what we're testing via comments
> ---

Ok, digging more into the code I see that firstused refers to the lowest
->nameidx of the xfs_attr_leaf_entry's in the block. On insert,
->nameidx is constructed from freemap.base, which starts at just beyond
the block header. freemap.base+freemap.size essentially refers to a raw
block offset where the name/value info is placed, so I think I just
misread that code the first time around. This makes sense and the
cleanups look good. Thanks for the clarification.

One more small question..

>  fs/xfs/libxfs/xfs_attr_leaf.c |   26 +++++++++++++++++++++-----
>  1 file changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 6fddce7..f1a1c60 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -249,12 +249,13 @@ xfs_attr3_leaf_hdr_to_disk(
>  
>  static xfs_failaddr_t
>  xfs_attr3_leaf_verify(
> -	struct xfs_buf		*bp)
> +	struct xfs_buf			*bp)
>  {
> -	struct xfs_mount	*mp = bp->b_target->bt_mount;
> -	struct xfs_attr_leafblock *leaf = bp->b_addr;
> -	struct xfs_perag *pag = bp->b_pag;
> -	struct xfs_attr3_icleaf_hdr ichdr;
> +	struct xfs_attr3_icleaf_hdr	ichdr;
> +	struct xfs_mount		*mp = bp->b_target->bt_mount;
> +	struct xfs_attr_leafblock	*leaf = bp->b_addr;
> +	struct xfs_perag		*pag = bp->b_pag;
> +	struct xfs_attr_leaf_entry	*entries;
>  
>  	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
>  
> @@ -282,6 +283,21 @@ xfs_attr3_leaf_verify(
>  	if (pag && pag->pagf_init && ichdr.count == 0)
>  		return __this_address;
>  
> +	/*
> +	 * firstused is the block offset of the first name info structure.
> +	 * Make sure it doesn't go off the block or crash into the header.
> +	 */
> +	if (ichdr.firstused > mp->m_attr_geo->blksize)
> +		return __this_address;
> +	if (ichdr.firstused < xfs_attr3_leaf_hdr_size(leaf))
> +		return __this_address;
> +
> +	/* Make sure the entries array doesn't crash into the name info. */
> +	entries = xfs_attr3_leaf_entryp(bp->b_addr);
> +	if ((char *)&entries[ichdr.count] >=
> +	    (char *)bp->b_addr + ichdr.firstused)
> +		return __this_address;
> +

Can the end of the entries list align with the first namelist object if
the block is full, for example? E.g., is '&entries[ichdr.count] ==
bp->b_addr + ichdr.firstused' a sane possibility?

That aside, this looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	/* XXX: need to range check rest of attr header values */
>  	/* XXX: hash order check? */
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
