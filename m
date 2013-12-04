Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6FC617F3F
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 18:37:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5AB6530408E
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 16:37:20 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	MsHaRdzw6Vky7deB for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 16:37:18 -0800 (PST)
Date: Wed, 4 Dec 2013 11:37:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/10] xfs: format log items write directly into the
	linear CIL buffer
Message-ID: <20131204003712.GE10988@dastard>
References: <20131129083919.207915844@bombadil.infradead.org>
	<20131129084001.028583376@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131129084001.028583376@bombadil.infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Nov 29, 2013 at 12:39:25AM -0800, Christoph Hellwig wrote:
> Instead of setting up pointers to memory locations in iop_format which then
> get copied into the CIL linear buffer after return move the copy into
> the individual inode items.  This avoids the need to always have a memory
> block in the exact same layout that gets written into the log around, and
> allow the log items to be much more flexible in their in-memory layouts.
> 
> Note that all log item format routines now need to be careful to modify
> the copy of the item that was placed into the CIL after calls to
> xlog_copy_iovec instead of the in-memory copy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>  	 */
>  	base_size = xfs_buf_log_format_size(blfp);
>  
> -	nvecs = 0;
>  	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
>  	if (!(bip->bli_flags & XFS_BLI_STALE) && first_bit == -1) {
>  		/*
>  		 * If the map is not be dirty in the transaction, mark
>  		 * the size as zero and do not advance the vector pointer.
>  		 */
> -		goto out;
> +		return;
>  	}
>  
> -	xlog_copy_iovec(vecp, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
> -	nvecs = 1;
> +	blfp = xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_BFORMAT, blfp, base_size);
> +	blfp->blf_size = 1;

Hmmmm. What guarantee do we have blf_size is now natuarally aligned?
We've returned a pointer that could have any offset into the logvec
buffer, and so some platforms are going to have problems if blfp is
at an address that is not a multiple of 4 or 8, right?

>  xfs_inode_item_format_data_fork(
>  	struct xfs_inode_log_item *iip,
> -	struct xfs_log_iovec	**vecp,
> -	int			*nvecs)
> +	struct xfs_inode_log_format *ilf,
> +	struct xfs_log_vec	*lv,
> +	struct xfs_log_iovec	**vecp)
>  {
>  	struct xfs_inode	*ip = iip->ili_inode;
>  	size_t			data_bytes;
> @@ -239,19 +241,19 @@ xfs_inode_item_format_data_fork(
>  				 * extents, so just point to the
>  				 * real extents array.
>  				 */
> -				xlog_copy_iovec(vecp, XLOG_REG_TYPE_IEXT,
> +				xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_IEXT,
>  						ip->i_df.if_u1.if_extents,
>  						ip->i_df.if_bytes);
> -				iip->ili_format.ilf_dsize = ip->i_df.if_bytes;
> +				ilf->ilf_dsize = ip->i_df.if_bytes;

And by the looks of it, we could have the same problems here?

> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 384c6c4..e04bd0c 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -31,18 +31,44 @@ struct xfs_log_vec {
>  #define XFS_LOG_VEC_ORDERED	(-1)
>  
>  static inline void *
> -xlog_copy_iovec(struct xfs_log_iovec **vecp, uint type, void *data, int len)
> +xlog_prepare_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec **vecp,
> +		uint type)
>  {
>  	struct xfs_log_iovec *vec = *vecp;
>  
> +	if (vec) {
> +		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
> +		vec++;
> +	} else {
> +		vec = &lv->lv_iovecp[0];
> +	}
> +
>  	vec->i_type = type;
> -	vec->i_addr = data;
> -	vec->i_len = len;
> +	vec->i_addr = lv->lv_buf + lv->lv_buf_len;

We could at least check here that the alignment is good...

>  
> -	*vecp = vec + 1;
> +	*vecp = vec;
>  	return vec->i_addr;
>  }
>  
> +static inline void
> +xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec, int len)
> +{
> +	lv->lv_buf_len += len;

And if we need to guarantee alignment, then maybe roundup here to
ensure we don't end up with bad offsets?  That would require padding
the allocation of the buffer to take it into account, too....

Other than this concern, the code looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
