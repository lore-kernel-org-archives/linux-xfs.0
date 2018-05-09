Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49464 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933806AbeEIHqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 May 2018 03:46:30 -0400
Date: Wed, 9 May 2018 00:46:29 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/3] xfs: add bmapi nodiscard flag
Message-ID: <20180509074629.GC19933@infradead.org>
References: <20180508172231.53570-1-bfoster@redhat.com>
 <20180508172231.53570-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180508172231.53570-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 08, 2018 at 01:22:29PM -0400, Brian Foster wrote:
> Freed extents are unconditionally discarded when online discard is
> enabled. Define XFS_BMAPI_NODISCARD to allow callers to bypass
> discards when unnecessary. For example, this will be useful for
> eofblocks trimming.
> 
> This patch does not change behavior.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c  | 10 +++++++---
>  fs/xfs/libxfs/xfs_alloc.h  | 27 +++++++++++++++++++++++++--
>  fs/xfs/libxfs/xfs_bmap.c   | 17 +++++++++++++----
>  fs/xfs/libxfs/xfs_bmap.h   | 30 ++++++++++++++++++++++++++++--
>  fs/xfs/xfs_extfree_item.c  |  2 +-
>  fs/xfs/xfs_trans.h         |  3 ++-
>  fs/xfs/xfs_trans_extfree.c | 13 +++++++++----
>  7 files changed, 85 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 4bcc095fe44a..06e4b0c47c01 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2949,18 +2949,20 @@ xfs_free_extent_fix_freelist(
>   * after fixing up the freelist.
>   */
>  int				/* error */
> -xfs_free_extent(
> +__xfs_free_extent(
>  	struct xfs_trans	*tp,	/* transaction pointer */
>  	xfs_fsblock_t		bno,	/* starting block number of extent */
>  	xfs_extlen_t		len,	/* length of extent */
>  	struct xfs_owner_info	*oinfo,	/* extent owner */
> -	enum xfs_ag_resv_type	type)	/* block reservation type */
> +	enum xfs_ag_resv_type	type,	/* block reservation type */
> +	bool			skip_discard)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_buf		*agbp;
>  	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, bno);
>  	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, bno);
>  	int			error;
> +	unsigned int		busy_flags = 0;
>  
>  	ASSERT(len != 0);
>  	ASSERT(type != XFS_AG_RESV_AGFL);
> @@ -2984,7 +2986,9 @@ xfs_free_extent(
>  	if (error)
>  		goto err;
>  
> -	xfs_extent_busy_insert(tp, agno, agbno, len, 0);
> +	if (skip_discard)
> +		busy_flags |= XFS_EXTENT_BUSY_SKIP_DISCARD;

Please just add an busy_flags argument to xfs_free_extent, and pass 0 in
the oter callers.  That removes a lot of the boilerplate code.  Then just
add an assert to xfs_free_extent that no flag other than
XFS_EXTENT_BUSY_SKIP_DISCARD is passed for now.

>  void
> -xfs_bmap_add_free(
> +__xfs_bmap_add_free(
>  	struct xfs_mount		*mp,
>  	struct xfs_defer_ops		*dfops,
>  	xfs_fsblock_t			bno,
>  	xfs_filblks_t			len,
> -	struct xfs_owner_info		*oinfo)
> +	struct xfs_owner_info		*oinfo,
> +	bool				skip_discard)
>  {
>  	struct xfs_extent_free_item	*new;		/* new element */
>  #ifdef DEBUG
> @@ -574,6 +575,7 @@ xfs_bmap_add_free(
>  		new->xefi_oinfo = *oinfo;
>  	else
>  		xfs_rmap_skip_owner_update(&new->xefi_oinfo);
> +	new->xefi_skip_discard = skip_discard;

Similarly here, I think we should just pass through the bmapi
flags.  But given the number of callers I think just adding
a xfs_bmap_add_free_flags as the low-level interface with a higher
level xfs_bmap_add_free wrapper for all other callers is fine.
