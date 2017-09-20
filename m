Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45315 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdITW14 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2017 18:27:56 -0400
Date: Wed, 20 Sep 2017 15:27:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 18/19] xfs: remove all xfs_bmbt_set_* helpers except for
 xfs_bmbt_set_all
Message-ID: <20170920222752.GZ7112@magnolia>
References: <20170918152422.24345-1-hch@lst.de>
 <20170918152422.24345-19-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918152422.24345-19-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 18, 2017 at 08:24:21AM -0700, Christoph Hellwig wrote:
> Unused after the big bmap refactor.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap_btree.c | 102 ++++++-----------------------------------
>  fs/xfs/libxfs/xfs_bmap_btree.h |   6 ---
>  2 files changed, 14 insertions(+), 94 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 7e2d981626ef..e66ebd982cfb 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -188,44 +188,27 @@ xfs_bmbt_disk_get_startoff(
>  		 xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN)) >> 9;
>  }
>  
> -
>  /*
> - * Set all the fields in a bmap extent record from the arguments.
> + * Set all the fields in a bmap extent record from the uncompressed form.
>   */
>  void
> -xfs_bmbt_set_allf(
> -	xfs_bmbt_rec_host_t	*r,
> -	xfs_fileoff_t		startoff,
> -	xfs_fsblock_t		startblock,
> -	xfs_filblks_t		blockcount,
> -	xfs_exntst_t		state)
> +xfs_bmbt_set_all(
> +	struct xfs_bmbt_rec_host *r,
> +	struct xfs_bmbt_irec	*s)
>  {
> -	int		extent_flag = (state == XFS_EXT_NORM) ? 0 : 1;
> -
> -	ASSERT(state == XFS_EXT_NORM || state == XFS_EXT_UNWRITTEN);
> -	ASSERT((startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)) == 0);
> -	ASSERT((blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)) == 0);
> +	int			extent_flag = (s->br_state != XFS_EXT_NORM);
>  
> -	ASSERT((startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)) == 0);
> +	ASSERT(s->br_state == XFS_EXT_NORM || s->br_state == XFS_EXT_UNWRITTEN);
> +	ASSERT(!(s->br_startoff & xfs_mask64hi(64-BMBT_STARTOFF_BITLEN)));
> +	ASSERT(!(s->br_blockcount & xfs_mask64hi(64-BMBT_BLOCKCOUNT_BITLEN)));
> +	ASSERT(!(s->br_startblock & xfs_mask64hi(64-BMBT_STARTBLOCK_BITLEN)));
>  
>  	r->l0 = ((xfs_bmbt_rec_base_t)extent_flag << 63) |
> -		((xfs_bmbt_rec_base_t)startoff << 9) |
> -		((xfs_bmbt_rec_base_t)startblock >> 43);
> -	r->l1 = ((xfs_bmbt_rec_base_t)startblock << 21) |
> -		((xfs_bmbt_rec_base_t)blockcount &
> -		(xfs_bmbt_rec_base_t)xfs_mask64lo(21));
> -}
> -
> -/*
> - * Set all the fields in a bmap extent record from the uncompressed form.
> - */
> -void
> -xfs_bmbt_set_all(
> -	xfs_bmbt_rec_host_t *r,
> -	xfs_bmbt_irec_t	*s)
> -{
> -	xfs_bmbt_set_allf(r, s->br_startoff, s->br_startblock,
> -			     s->br_blockcount, s->br_state);
> +		 ((xfs_bmbt_rec_base_t)s->br_startoff << 9) |
> +		 ((xfs_bmbt_rec_base_t)s->br_startblock >> 43);
> +	r->l1 = ((xfs_bmbt_rec_base_t)s->br_startblock << 21) |
> +		 ((xfs_bmbt_rec_base_t)s->br_blockcount &
> +		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21));
>  }
>  
>  /*
> @@ -253,63 +236,6 @@ xfs_bmbt_disk_set_all(
>  		  (xfs_bmbt_rec_base_t)xfs_mask64lo(21)));
>  }
>  
> -/*
> - * Set the blockcount field in a bmap extent record.
> - */
> -void
> -xfs_bmbt_set_blockcount(
> -	xfs_bmbt_rec_host_t *r,
> -	xfs_filblks_t	v)
> -{
> -	ASSERT((v & xfs_mask64hi(43)) == 0);
> -	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64hi(43)) |
> -		  (xfs_bmbt_rec_base_t)(v & xfs_mask64lo(21));
> -}
> -
> -/*
> - * Set the startblock field in a bmap extent record.
> - */
> -void
> -xfs_bmbt_set_startblock(
> -	xfs_bmbt_rec_host_t *r,
> -	xfs_fsblock_t	v)
> -{
> -	ASSERT((v & xfs_mask64hi(12)) == 0);
> -	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t)xfs_mask64hi(55)) |
> -		  (xfs_bmbt_rec_base_t)(v >> 43);
> -	r->l1 = (r->l1 & (xfs_bmbt_rec_base_t)xfs_mask64lo(21)) |
> -		  (xfs_bmbt_rec_base_t)(v << 21);
> -}
> -
> -/*
> - * Set the startoff field in a bmap extent record.
> - */
> -void
> -xfs_bmbt_set_startoff(
> -	xfs_bmbt_rec_host_t *r,
> -	xfs_fileoff_t	v)
> -{
> -	ASSERT((v & xfs_mask64hi(9)) == 0);
> -	r->l0 = (r->l0 & (xfs_bmbt_rec_base_t) xfs_mask64hi(1)) |
> -		((xfs_bmbt_rec_base_t)v << 9) |
> -		  (r->l0 & (xfs_bmbt_rec_base_t)xfs_mask64lo(9));
> -}
> -
> -/*
> - * Set the extent state field in a bmap extent record.
> - */
> -void
> -xfs_bmbt_set_state(
> -	xfs_bmbt_rec_host_t *r,
> -	xfs_exntst_t	v)
> -{
> -	ASSERT(v == XFS_EXT_NORM || v == XFS_EXT_UNWRITTEN);
> -	if (v == XFS_EXT_NORM)
> -		r->l0 &= xfs_mask64lo(64 - BMBT_EXNTFLAG_BITLEN);
> -	else
> -		r->l0 |= xfs_mask64hi(BMBT_EXNTFLAG_BITLEN);
> -}
> -
>  /*
>   * Convert in-memory form of btree root to on-disk form.
>   */
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
> index bd3c56f1cd03..93f95bcee915 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.h
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.h
> @@ -109,12 +109,6 @@ extern xfs_filblks_t xfs_bmbt_disk_get_blockcount(xfs_bmbt_rec_t *r);
>  extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
>  
>  extern void xfs_bmbt_set_all(xfs_bmbt_rec_host_t *r, xfs_bmbt_irec_t *s);
> -extern void xfs_bmbt_set_allf(xfs_bmbt_rec_host_t *r, xfs_fileoff_t o,
> -			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
> -extern void xfs_bmbt_set_blockcount(xfs_bmbt_rec_host_t *r, xfs_filblks_t v);
> -extern void xfs_bmbt_set_startblock(xfs_bmbt_rec_host_t *r, xfs_fsblock_t v);
> -extern void xfs_bmbt_set_startoff(xfs_bmbt_rec_host_t *r, xfs_fileoff_t v);
> -extern void xfs_bmbt_set_state(xfs_bmbt_rec_host_t *r, xfs_exntst_t v);
>  
>  extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
>  			xfs_bmdr_block_t *, int);
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
