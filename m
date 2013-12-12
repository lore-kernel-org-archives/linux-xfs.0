Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D78E47F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 18:06:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C5DE7304077
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 16:06:40 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	SW5Z33ghu2CrREXu for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 16:06:39 -0800 (PST)
Date: Thu, 12 Dec 2013 11:05:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/10 v2] xfs: format log items write directly into the
	linear CIL buffer
Message-ID: <20131212000530.GU10988@dastard>
References: <20131129083919.207915844@bombadil.infradead.org>
	<20131129084001.028583376@bombadil.infradead.org>
	<20131211120341.GA6116@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131211120341.GA6116@infradead.org>
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

On Wed, Dec 11, 2013 at 04:03:41AM -0800, Christoph Hellwig wrote:
> Instead of setting up pointers to memory locations in iop_format which then
> get copied into the CIL linear buffer after return move the copy into
> the individual inode items.  This avoids the need to always have a memory
> block in the exact same layout that gets written into the log around, and
> allow the log items to be much more flexible in their in-memory layouts.
> 
> The only caveat is that we need to properly align the data for each
> iovec so that don't have structures misaligned in subsequent iovecs.

.....

> diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> index 384c6c4..65e054a 100644
> --- a/fs/xfs/xfs_log.h
> +++ b/fs/xfs/xfs_log.h
> @@ -31,18 +31,49 @@ struct xfs_log_vec {
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
>  
> -	*vecp = vec + 1;
> +	*vecp = vec;
>  	return vec->i_addr;

Can you add an assert here like this:

	ASSERT(IS_ALIGNED(vec->i_addr, sizeof(uint64_t));

So we catch any situation where the alignment ends up wrong?

Otherwise, it looks good, so consider it:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
