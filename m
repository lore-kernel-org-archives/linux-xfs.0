Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TDZ4hF074883 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 08:35:04 -0500
Subject: Re: [PATCH 4/5] [PATCH] xfs: simplify buffer to transaction matching
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100418001058.677429475@bombadil.infradead.org>
References: <20100418001041.865247520@bombadil.infradead.org>
	<20100418001058.677429475@bombadil.infradead.org>
Date: Thu, 29 Apr 2010 08:35:22 -0500
Message-ID: <1272548122.3221.77.camel@doink>
Mime-Version: 1.0
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

On Sat, 2010-04-17 at 20:10 -0400, Christoph Hellwig wrote:
> plain text document attachment (xfs-buf-match-cleanup)
> We currenly have a routine xfs_trans_buf_item_match_all which checks if any
> log item in a transaction contains a given buffer, and a second one that
> only does this check for the first, embedded chunk of log items.  We only
> use the second routine if we know we only have that log item chunk, so get
> rid of the limited routine and always use the more complete one.
> 
> Also rename the old xfs_trans_buf_item_match_all to xfs_trans_buf_item_match
> and update various surrounding comments, and move the remaining
> xfs_trans_buf_item_match on top of the file to avoid a forward prototype.

Dave suggested using the xfs_trans_*_item() routines (which maybe
could be renamed xfs_trans_item_*() someday).  That is the right
thing to do, but not necessary at this point.  In fact I prefer
this smaller change anyway, since it clearly just transforms
the original xfs_trans_buf_item_match_all() code directly to
the new result.  The switch to use xfs_trans_*_item() can (and
should) happen as a follow-on patch.

The simplification is good.

Reviewed-by: Alex Elder <aelder@sgi.com>


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_trans_buf.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_trans_buf.c	2010-03-09 22:58:31.307004136 +0100
> +++ xfs/fs/xfs/xfs_trans_buf.c	2010-03-11 11:46:45.052004554 +0100
> @@ -40,11 +40,51 @@
>  #include "xfs_rw.h"
>  #include "xfs_trace.h"
>  
> +/*
> + * Check to see if a buffer matching the given parameters is already
> + * a part of the given transaction.
> + */
> +STATIC struct xfs_buf *
> +xfs_trans_buf_item_match(
> +	struct xfs_trans	*tp,
> +	struct xfs_buftarg	*target,
> +	xfs_daddr_t		blkno,
> +	int			len)
> +{
> +	xfs_log_item_chunk_t	*licp;
> +	xfs_log_item_desc_t	*lidp;
> +	xfs_buf_log_item_t	*blip;
> +	int			i;
>  
> -STATIC xfs_buf_t *xfs_trans_buf_item_match(xfs_trans_t *, xfs_buftarg_t *,
> -		xfs_daddr_t, int);
> -STATIC xfs_buf_t *xfs_trans_buf_item_match_all(xfs_trans_t *, xfs_buftarg_t *,
> -		xfs_daddr_t, int);
> +	len = BBTOB(len);
> +	for (licp = &tp->t_items; licp != NULL; licp = licp->lic_next) {
> +		if (xfs_lic_are_all_free(licp)) {
> +			ASSERT(licp == &tp->t_items);
> +			ASSERT(licp->lic_next == NULL);
> +			return NULL;
> +		}
> +
> +		for (i = 0; i < licp->lic_unused; i++) {
> +			/*
> +			 * Skip unoccupied slots.
> +			 */
> +			if (xfs_lic_isfree(licp, i))
> +				continue;
> +
> +			lidp = xfs_lic_slot(licp, i);
> +			blip = (xfs_buf_log_item_t *)lidp->lid_item;
> +			if (blip->bli_item.li_type != XFS_LI_BUF)
> +				continue;
> +
> +			if (XFS_BUF_TARGET(blip->bli_buf) == target &&
> +			    XFS_BUF_ADDR(blip->bli_buf) == blkno &&
> +			    XFS_BUF_COUNT(blip->bli_buf) == len)
> +				return blip->bli_buf;
> +		}
> +	}
> +
> +	return NULL;
> +}
>  
>  /*
>   * Add the locked buffer to the transaction.
> @@ -112,14 +152,6 @@ xfs_trans_bjoin(
>   * within the transaction, just increment its lock recursion count
>   * and return a pointer to it.
>   *
> - * Use the fast path function xfs_trans_buf_item_match() or the buffer
> - * cache routine incore_match() to find the buffer
> - * if it is already owned by this transaction.
> - *
> - * If we don't already own the buffer, use get_buf() to get it.
> - * If it doesn't yet have an associated xfs_buf_log_item structure,
> - * then allocate one and add the item to this transaction.
> - *
>   * If the transaction pointer is NULL, make this just a normal
>   * get_buf() call.
>   */
> @@ -149,11 +181,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
>  	 * have it locked.  In this case we just increment the lock
>  	 * recursion count and return the buffer to the caller.
>  	 */
> -	if (tp->t_items.lic_next == NULL) {
> -		bp = xfs_trans_buf_item_match(tp, target_dev, blkno, len);
> -	} else {
> -		bp  = xfs_trans_buf_item_match_all(tp, target_dev, blkno, len);
> -	}
> +	bp = xfs_trans_buf_item_match(tp, target_dev, blkno, len);
>  	if (bp != NULL) {
>  		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
>  		if (XFS_FORCED_SHUTDOWN(tp->t_mountp))
> @@ -259,14 +287,6 @@ int	xfs_error_mod = 33;
>   * within the transaction and already read in, just increment its
>   * lock recursion count and return a pointer to it.
>   *
> - * Use the fast path function xfs_trans_buf_item_match() or the buffer
> - * cache routine incore_match() to find the buffer
> - * if it is already owned by this transaction.
> - *
> - * If we don't already own the buffer, use read_buf() to get it.
> - * If it doesn't yet have an associated xfs_buf_log_item structure,
> - * then allocate one and add the item to this transaction.
> - *
>   * If the transaction pointer is NULL, make this just a normal
>   * read_buf() call.
>   */
> @@ -328,11 +348,7 @@ xfs_trans_read_buf(
>  	 * If the buffer is not yet read in, then we read it in, increment
>  	 * the lock recursion count, and return it to the caller.
>  	 */
> -	if (tp->t_items.lic_next == NULL) {
> -		bp = xfs_trans_buf_item_match(tp, target, blkno, len);
> -	} else {
> -		bp = xfs_trans_buf_item_match_all(tp, target, blkno, len);
> -	}
> +	bp = xfs_trans_buf_item_match(tp, target, blkno, len);
>  	if (bp != NULL) {
>  		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
>  		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
> @@ -901,111 +917,3 @@ xfs_trans_dquot_buf(
>  
>  	bip->bli_format.blf_flags |= type;
>  }
> -
> -/*
> - * Check to see if a buffer matching the given parameters is already
> - * a part of the given transaction.  Only check the first, embedded
> - * chunk, since we don't want to spend all day scanning large transactions.
> - */
> -STATIC xfs_buf_t *
> -xfs_trans_buf_item_match(
> -	xfs_trans_t	*tp,
> -	xfs_buftarg_t	*target,
> -	xfs_daddr_t	blkno,
> -	int		len)
> -{
> -	xfs_log_item_chunk_t	*licp;
> -	xfs_log_item_desc_t	*lidp;
> -	xfs_buf_log_item_t	*blip;
> -	xfs_buf_t		*bp;
> -	int			i;
> -
> -	bp = NULL;
> -	len = BBTOB(len);
> -	licp = &tp->t_items;
> -	if (!xfs_lic_are_all_free(licp)) {
> -		for (i = 0; i < licp->lic_unused; i++) {
> -			/*
> -			 * Skip unoccupied slots.
> -			 */
> -			if (xfs_lic_isfree(licp, i)) {
> -				continue;
> -			}
> -
> -			lidp = xfs_lic_slot(licp, i);
> -			blip = (xfs_buf_log_item_t *)lidp->lid_item;
> -			if (blip->bli_item.li_type != XFS_LI_BUF) {
> -				continue;
> -			}
> -
> -			bp = blip->bli_buf;
> -			if ((XFS_BUF_TARGET(bp) == target) &&
> -			    (XFS_BUF_ADDR(bp) == blkno) &&
> -			    (XFS_BUF_COUNT(bp) == len)) {
> -				/*
> -				 * We found it.  Break out and
> -				 * return the pointer to the buffer.
> -				 */
> -				break;
> -			} else {
> -				bp = NULL;
> -			}
> -		}
> -	}
> -	return bp;
> -}
> -
> -/*
> - * Check to see if a buffer matching the given parameters is already
> - * a part of the given transaction.  Check all the chunks, we
> - * want to be thorough.
> - */
> -STATIC xfs_buf_t *
> -xfs_trans_buf_item_match_all(
> -	xfs_trans_t	*tp,
> -	xfs_buftarg_t	*target,
> -	xfs_daddr_t	blkno,
> -	int		len)
> -{
> -	xfs_log_item_chunk_t	*licp;
> -	xfs_log_item_desc_t	*lidp;
> -	xfs_buf_log_item_t	*blip;
> -	xfs_buf_t		*bp;
> -	int			i;
> -
> -	bp = NULL;
> -	len = BBTOB(len);
> -	for (licp = &tp->t_items; licp != NULL; licp = licp->lic_next) {
> -		if (xfs_lic_are_all_free(licp)) {
> -			ASSERT(licp == &tp->t_items);
> -			ASSERT(licp->lic_next == NULL);
> -			return NULL;
> -		}
> -		for (i = 0; i < licp->lic_unused; i++) {
> -			/*
> -			 * Skip unoccupied slots.
> -			 */
> -			if (xfs_lic_isfree(licp, i)) {
> -				continue;
> -			}
> -
> -			lidp = xfs_lic_slot(licp, i);
> -			blip = (xfs_buf_log_item_t *)lidp->lid_item;
> -			if (blip->bli_item.li_type != XFS_LI_BUF) {
> -				continue;
> -			}
> -
> -			bp = blip->bli_buf;
> -			if ((XFS_BUF_TARGET(bp) == target) &&
> -			    (XFS_BUF_ADDR(bp) == blkno) &&
> -			    (XFS_BUF_COUNT(bp) == len)) {
> -				/*
> -				 * We found it.  Break out and
> -				 * return the pointer to the buffer.
> -				 */
> -				return bp;
> -			}
> -		}
> -	}
> -	return NULL;
> -}
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
