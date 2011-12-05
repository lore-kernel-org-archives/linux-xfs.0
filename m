Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB541Lfb109451 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 22:01:21 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F281998EB04
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 20:01:15 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	l3OWxflX8uE27XKN for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 20:01:15 -0800 (PST)
Date: Mon, 5 Dec 2011 14:55:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: cleanup the transaction commit path a bit
Message-ID: <20111205035516.GF7046@dastard>
References: <20111128082522.224645690@bombadil.infradead.org>
	<20111128082557.082085349@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082557.082085349@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:25:24AM -0500, Christoph Hellwig wrote:
> Now that the nodelaylog mode is gone we can simplify the transaction commit
> path a bit by removing the xfs_trans_commit_cil routine.  Restoring the
> process flags is merged into xfs_trans_commit which already does it for
> the error path, and allocating the log vectors is merged into
> xlog_cil_format_items, which already fills them with data, thus avoiding
> one loop over all log items.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_log.h     |    3 -
>  fs/xfs/xfs_log_cil.c |   82 +++++++++++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_trans.c   |   81 ++------------------------------------------------
>  3 files changed, 66 insertions(+), 100 deletions(-)
> 
> Index: xfs/fs/xfs/xfs_log_cil.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log_cil.c	2011-11-28 09:17:38.320029780 +0100
> +++ xfs/fs/xfs/xfs_log_cil.c	2011-11-28 09:21:33.195424016 +0100
> @@ -161,38 +161,75 @@ xlog_cil_init_post_recovery(
>   * to the copied region inside the buffer we just allocated. This allows us to
>   * format the regions into the iclog as though they are being formatted
>   * directly out of the objects themselves.
> + *
> + * Note that this format differs from the old log vector format in that there
> + * is no transaction header in these log vectors.

Do we even need this comment given the old itransaction commit code
that did this is now gone?

>   */
> -static void
> -xlog_cil_format_items(
> -	struct log		*log,
> -	struct xfs_log_vec	*log_vector)
> +static struct xfs_log_vec *
> +xlog_cil_prepare_log_vecs(
> +	struct xfs_trans	*tp)
>  {
> -	struct xfs_log_vec *lv;
> +	struct xfs_log_item_desc *lidp;
> +	struct xfs_log_vec	*lv = NULL;
> +	struct xfs_log_vec	*ret_lv = NULL;
>  
> -	ASSERT(log_vector);
> -	for (lv = log_vector; lv; lv = lv->lv_next) {
> +
> +	/* Bail out if we didn't find a log item.  */
> +	if (list_empty(&tp->t_items)) {
> +		ASSERT(0);
> +		return NULL;
> +	}
> +
> +	list_for_each_entry(lidp, &tp->t_items, lid_trans) {
> +		struct xfs_log_vec *new_lv;
>  		void	*ptr;
>  		int	index;
>  		int	len = 0;
>  
> +		/* Skip items which aren't dirty in this transaction. */
> +		if (!(lidp->lid_flags & XFS_LID_DIRTY))
> +			continue;
> +
> +		/* Skip items that do not have any vectors for writing */
> +		lidp->lid_size = IOP_SIZE(lidp->lid_item);
> +		if (!lidp->lid_size)
> +			continue;
> +
> +		new_lv = kmem_zalloc(sizeof(*new_lv) +
> +				lidp->lid_size * sizeof(struct xfs_log_iovec),
> +				KM_SLEEP);
> +
> +		/* The allocated iovec region lies beyond the log vector. */
> +		new_lv->lv_iovecp = (struct xfs_log_iovec *)&new_lv[1];
> +		new_lv->lv_niovecs = lidp->lid_size;
> +		new_lv->lv_item = lidp->lid_item;
> +
>  		/* build the vector array and calculate it's length */
> -		IOP_FORMAT(lv->lv_item, lv->lv_iovecp);
> -		for (index = 0; index < lv->lv_niovecs; index++)
> -			len += lv->lv_iovecp[index].i_len;
> -
> -		lv->lv_buf_len = len;
> -		lv->lv_buf = kmem_alloc(lv->lv_buf_len, KM_SLEEP|KM_NOFS);
> -		ptr = lv->lv_buf;
> +		IOP_FORMAT(new_lv->lv_item, new_lv->lv_iovecp);
> +		for (index = 0; index < new_lv->lv_niovecs; index++)
> +			len += new_lv->lv_iovecp[index].i_len;

Would it make sense to have IOP_FORMAT return the length of the
vectors (calculated as itis built) rather than having to add them up
after the fact? That would avoid an extra pass across the vector
array. Regardless, it can be done as a future patch...

Otherwise, looks OK to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
