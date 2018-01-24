Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48016 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932474AbeAXVhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jan 2018 16:37:46 -0500
Date: Wed, 24 Jan 2018 13:37:40 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] Get rid of xfs_buf_log_item_t typedef
Message-ID: <20180124213740.GB9068@magnolia>
References: <20180124084736.17411-1-cmaiolino@redhat.com>
 <20180124084736.17411-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180124084736.17411-2-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 24, 2018 at 09:47:34AM +0100, Carlos Maiolino wrote:
> Take advantage of the rework on xfs_buf log items list, to get rid of
> ths typedef for xfs_buf_log_item.
> 
> This patch also fix some indentation alignment issues found along the way.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_buf_item.c  | 40 ++++++++++++++++----------------
>  fs/xfs/xfs_buf_item.h  |  6 ++---
>  fs/xfs/xfs_trans_buf.c | 62 +++++++++++++++++++++++++++-----------------------
>  3 files changed, 56 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index e0a0af0946f2..8afcfa3ed976 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -61,14 +61,14 @@ xfs_buf_log_format_size(
>   */
>  STATIC void
>  xfs_buf_item_size_segment(
> -	struct xfs_buf_log_item	*bip,
> -	struct xfs_buf_log_format *blfp,
> -	int			*nvecs,
> -	int			*nbytes)
> +	struct xfs_buf_log_item		*bip,
> +	struct xfs_buf_log_format	*blfp,
> +	int				*nvecs,
> +	int				*nbytes)
>  {
> -	struct xfs_buf		*bp = bip->bli_buf;
> -	int			next_bit;
> -	int			last_bit;
> +	struct xfs_buf			*bp = bip->bli_buf;
> +	int				next_bit;
> +	int				last_bit;
>  
>  	last_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
>  	if (last_bit == -1)
> @@ -218,12 +218,12 @@ xfs_buf_item_format_segment(
>  	uint			offset,
>  	struct xfs_buf_log_format *blfp)
>  {
> -	struct xfs_buf	*bp = bip->bli_buf;
> -	uint		base_size;
> -	int		first_bit;
> -	int		last_bit;
> -	int		next_bit;
> -	uint		nbits;
> +	struct xfs_buf		*bp = bip->bli_buf;
> +	uint			base_size;
> +	int			first_bit;
> +	int			last_bit;
> +	int			next_bit;
> +	uint			nbits;
>  
>  	/* copy the flags across from the base format item */
>  	blfp->blf_flags = bip->__bli_format.blf_flags;
> @@ -406,10 +406,10 @@ xfs_buf_item_unpin(
>  	int			remove)
>  {
>  	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
> -	xfs_buf_t	*bp = bip->bli_buf;
> -	struct xfs_ail	*ailp = lip->li_ailp;
> -	int		stale = bip->bli_flags & XFS_BLI_STALE;
> -	int		freed;
> +	xfs_buf_t		*bp = bip->bli_buf;
> +	struct xfs_ail		*ailp = lip->li_ailp;
> +	int			stale = bip->bli_flags & XFS_BLI_STALE;
> +	int			freed;
>  
>  	ASSERT(bp->b_fspriv == bip);
>  	ASSERT(atomic_read(&bip->bli_refcount) > 0);
> @@ -880,7 +880,7 @@ xfs_buf_item_log_segment(
>   */
>  void
>  xfs_buf_item_log(
> -	xfs_buf_log_item_t	*bip,
> +	struct xfs_buf_log_item	*bip,
>  	uint			first,
>  	uint			last)
>  {
> @@ -943,7 +943,7 @@ xfs_buf_item_dirty_format(
>  
>  STATIC void
>  xfs_buf_item_free(
> -	xfs_buf_log_item_t	*bip)
> +	struct xfs_buf_log_item	*bip)
>  {
>  	xfs_buf_item_free_format(bip);
>  	kmem_free(bip->bli_item.li_lv_shadow);
> @@ -961,7 +961,7 @@ void
>  xfs_buf_item_relse(
>  	xfs_buf_t	*bp)
>  {
> -	xfs_buf_log_item_t	*bip = bp->b_fspriv;
> +	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
>  	trace_xfs_buf_item_relse(bp, _RET_IP_);
>  	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 9690ce62c9a7..0febfbbf6ba9 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -50,7 +50,7 @@ struct xfs_buf_log_item;
>   * needed to log buffers.  It tracks how many times the lock has been
>   * locked, and which 128 byte chunks of the buffer are dirty.
>   */
> -typedef struct xfs_buf_log_item {
> +struct xfs_buf_log_item {
>  	xfs_log_item_t		bli_item;	/* common item structure */
>  	struct xfs_buf		*bli_buf;	/* real buffer pointer */
>  	unsigned int		bli_flags;	/* misc flags */
> @@ -59,11 +59,11 @@ typedef struct xfs_buf_log_item {
>  	int			bli_format_count;	/* count of headers */
>  	struct xfs_buf_log_format *bli_formats;	/* array of in-log header ptrs */
>  	struct xfs_buf_log_format __bli_format;	/* embedded in-log header */
> -} xfs_buf_log_item_t;
> +};
>  
>  int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
>  void	xfs_buf_item_relse(struct xfs_buf *);
> -void	xfs_buf_item_log(xfs_buf_log_item_t *, uint, uint);
> +void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
>  bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
>  void	xfs_buf_attach_iodone(struct xfs_buf *,
>  			      void(*)(struct xfs_buf *, xfs_log_item_t *),
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 3ba7a96a8abd..74563cd2970c 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -139,7 +139,7 @@ xfs_trans_get_buf_map(
>  	xfs_buf_flags_t		flags)
>  {
>  	xfs_buf_t		*bp;
> -	xfs_buf_log_item_t	*bip;
> +	struct xfs_buf_log_item	*bip;
>  
>  	if (!tp)
>  		return xfs_buf_get_map(target, map, nmaps, flags);
> @@ -188,12 +188,13 @@ xfs_trans_get_buf_map(
>   * mount structure.
>   */
>  xfs_buf_t *
> -xfs_trans_getsb(xfs_trans_t	*tp,
> -		struct xfs_mount *mp,
> -		int		flags)
> +xfs_trans_getsb(
> +	xfs_trans_t		*tp,
> +	struct xfs_mount	*mp,
> +	int			flags)
>  {
>  	xfs_buf_t		*bp;
> -	xfs_buf_log_item_t	*bip;
> +	struct xfs_buf_log_item	*bip;
>  
>  	/*
>  	 * Default to just trying to lock the superblock buffer
> @@ -352,10 +353,11 @@ xfs_trans_read_buf_map(
>   * brelse() call.
>   */
>  void
> -xfs_trans_brelse(xfs_trans_t	*tp,
> -		 xfs_buf_t	*bp)
> +xfs_trans_brelse(
> +	xfs_trans_t		*tp,
> +	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip;
> +	struct xfs_buf_log_item	*bip;
>  	int			freed;
>  
>  	/*
> @@ -456,10 +458,11 @@ xfs_trans_brelse(xfs_trans_t	*tp,
>   */
>  /* ARGSUSED */
>  void
> -xfs_trans_bhold(xfs_trans_t	*tp,
> -		xfs_buf_t	*bp)
> +xfs_trans_bhold(
> +	xfs_trans_t		*tp,
> +	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip = bp->b_fspriv;
> +	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
>  	ASSERT(bp->b_transp == tp);
>  	ASSERT(bip != NULL);
> @@ -476,10 +479,11 @@ xfs_trans_bhold(xfs_trans_t	*tp,
>   * for this transaction.
>   */
>  void
> -xfs_trans_bhold_release(xfs_trans_t	*tp,
> -			xfs_buf_t	*bp)
> +xfs_trans_bhold_release(
> +	xfs_trans_t		*tp,
> +	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip = bp->b_fspriv;
> +	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
>  	ASSERT(bp->b_transp == tp);
>  	ASSERT(bip != NULL);
> @@ -600,10 +604,10 @@ xfs_trans_log_buf(
>   */
>  void
>  xfs_trans_binval(
> -	xfs_trans_t	*tp,
> -	xfs_buf_t	*bp)
> +	xfs_trans_t		*tp,
> +	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip = bp->b_fspriv;
> +	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  	int			i;
>  
>  	ASSERT(bp->b_transp == tp);
> @@ -655,10 +659,10 @@ xfs_trans_binval(
>   */
>  void
>  xfs_trans_inode_buf(
> -	xfs_trans_t	*tp,
> -	xfs_buf_t	*bp)
> +	xfs_trans_t		*tp,
> +	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip = bp->b_fspriv;
> +	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
>  	ASSERT(bp->b_transp == tp);
>  	ASSERT(bip != NULL);
> @@ -679,10 +683,10 @@ xfs_trans_inode_buf(
>   */
>  void
>  xfs_trans_stale_inode_buf(
> -	xfs_trans_t	*tp,
> -	xfs_buf_t	*bp)
> +	xfs_trans_t		*tp,
> +	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip = bp->b_fspriv;
> +	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
>  	ASSERT(bp->b_transp == tp);
>  	ASSERT(bip != NULL);
> @@ -704,10 +708,10 @@ xfs_trans_stale_inode_buf(
>  /* ARGSUSED */
>  void
>  xfs_trans_inode_alloc_buf(
> -	xfs_trans_t	*tp,
> -	xfs_buf_t	*bp)
> +	xfs_trans_t		*tp,
> +	xfs_buf_t		*bp)
>  {
> -	xfs_buf_log_item_t	*bip = bp->b_fspriv;
> +	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
>  	ASSERT(bp->b_transp == tp);
>  	ASSERT(bip != NULL);
> @@ -797,9 +801,9 @@ xfs_trans_buf_copy_type(
>  /* ARGSUSED */
>  void
>  xfs_trans_dquot_buf(
> -	xfs_trans_t	*tp,
> -	xfs_buf_t	*bp,
> -	uint		type)
> +	xfs_trans_t		*tp,
> +	xfs_buf_t		*bp,
> +	uint			type)
>  {
>  	struct xfs_buf_log_item	*bip = bp->b_fspriv;
>  
> -- 
> 2.14.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
