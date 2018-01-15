Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46232 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933521AbeAOOmP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Jan 2018 09:42:15 -0500
Date: Mon, 15 Jan 2018 09:42:12 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/5] xfs: attr leaf verifier needs to check for obviously
 bad count
Message-ID: <20180115144211.GD47688@bfoster.bfoster>
References: <151579463950.8694.320025813242574491.stgit@magnolia>
 <151579466415.8694.4992590880368427655.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151579466415.8694.4992590880368427655.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jan 12, 2018 at 02:04:24PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In the attribute leaf verifier, we can check for obviously bad values of
> firstused and count so that later attempts at lasthash don't run off the
> end of the memory buffer.  Found by ones fuzzing hdr.count in xfs/400 with
> KASAN.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |   19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 6fddce7..712d458 100644
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
> @@ -282,6 +283,14 @@ xfs_attr3_leaf_verify(
>  	if (pag && pag->pagf_init && ichdr.count == 0)
>  		return __this_address;
>  
> +	if (ichdr.firstused > mp->m_attr_geo->blksize)
> +		return __this_address;
> +
> +	entries = xfs_attr3_leaf_entryp(bp->b_addr);
> +	if ((char *)&entries[ichdr.count] >=
> +	    (char *)bp->b_addr + ichdr.firstused)
> +		return __this_address;
> +

Hmm, this check confuses me a bit. Should we not consider the header
size in this calculation? (A comment would be useful either way..)

Brian

>  	/* XXX: need to range check rest of attr header values */
>  	/* XXX: hash order check? */
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
