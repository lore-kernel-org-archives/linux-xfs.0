Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756704AbdIHRTW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 13:19:22 -0400
Date: Fri, 8 Sep 2017 13:19:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 17/17] xfs: remove xfs_bmbt_get_state
Message-ID: <20170908171920.GG905@bfoster.bfoster>
References: <20170903072956.3175-1-hch@lst.de>
 <20170903072956.3175-18-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170903072956.3175-18-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 03, 2017 at 09:29:56AM +0200, Christoph Hellwig wrote:
> Unused after the big bmap refactor.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_bmap_btree.c | 29 +----------------------------
>  fs/xfs/libxfs/xfs_bmap_btree.h |  1 -
>  2 files changed, 1 insertion(+), 29 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index e66ebd982cfb..086e6fc8e4fc 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -38,22 +38,6 @@
>  #include "xfs_rmap.h"
>  
>  /*
> - * Determine the extent state.
> - */
> -/* ARGSUSED */
> -STATIC xfs_exntst_t
> -xfs_extent_state(
> -	xfs_filblks_t		blks,
> -	int			extent_flag)
> -{
> -	if (extent_flag) {
> -		ASSERT(blks != 0);	/* saved for DMIG */
> -		return XFS_EXT_UNWRITTEN;
> -	}
> -	return XFS_EXT_NORM;
> -}
> -
> -/*
>   * Convert on-disk form of btree root to in-memory form.
>   */
>  void
> @@ -90,7 +74,7 @@ xfs_bmdr_to_bmbt(
>  /*
>   * Convert a compressed bmap extent record to an uncompressed form.
>   * This code must be in sync with the routines xfs_bmbt_get_startoff,
> - * xfs_bmbt_get_startblock, xfs_bmbt_get_blockcount and xfs_bmbt_get_state.
> + * xfs_bmbt_get_startblock and xfs_bmbt_get_blockcount.
>   */
>  STATIC void
>  __xfs_bmbt_get_all(
> @@ -156,17 +140,6 @@ xfs_bmbt_get_startoff(
>  		 xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
>  }
>  
> -xfs_exntst_t
> -xfs_bmbt_get_state(
> -	xfs_bmbt_rec_host_t	*r)
> -{
> -	int	ext_flag;
> -
> -	ext_flag = (int)((r->l0) >> (64 - BMBT_EXNTFLAG_BITLEN));
> -	return xfs_extent_state(xfs_bmbt_get_blockcount(r),
> -				ext_flag);
> -}
> -
>  /*
>   * Extract the blockcount field from an on disk bmap extent record.
>   */
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> index 93f95bcee915..6f891eeb88f6 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> @@ -102,7 +102,6 @@ extern void xfs_bmbt_get_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
>  extern xfs_filblks_t xfs_bmbt_get_blockcount(xfs_bmbt_rec_host_t *r);
>  extern xfs_fsblock_t xfs_bmbt_get_startblock(xfs_bmbt_rec_host_t *r);
>  extern xfs_fileoff_t xfs_bmbt_get_startoff(xfs_bmbt_rec_host_t *r);
> -extern xfs_exntst_t xfs_bmbt_get_state(xfs_bmbt_rec_host_t *r);
>  
>  void xfs_bmbt_disk_set_all(struct xfs_bmbt_rec *r, struct xfs_bmbt_irec *s);
>  extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
