Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FMLFpi207001 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 16:21:15 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	RZ8Io8XWuq6pUbNK for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 14:21:13 -0800 (PST)
Date: Thu, 16 Feb 2012 09:21:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: use per-filesystem radix trees for dquot lookup
Message-ID: <20120215222111.GN14132@dastard>
References: <20120215022926.577682146@bombadil.infradead.org>
	<20120215023147.038502020@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120215023147.038502020@bombadil.infradead.org>
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

On Tue, Feb 14, 2012 at 09:29:28PM -0500, Christoph Hellwig wrote:
> Replace the global hash tables for looking up in-memory dquot structures
> with per-filesystem radix trees to allow scaling to a large number of
> in-memory dquot structures.

And simplifies the code a lot. Only minor comments about using
local quotainfo variables below.

> @@ -1593,10 +1515,10 @@ xfs_qm_dqfree_one(
>  	struct xfs_mount	*mp = dqp->q_mount;
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>  
> -	mutex_lock(&dqp->q_hash->qh_lock);
> -	list_del_init(&dqp->q_hashlist);
> -	dqp->q_hash->qh_version++;
> -	mutex_unlock(&dqp->q_hash->qh_lock);
> +	mutex_lock(&mp->m_quotainfo->qi_tree_lock);
> +	radix_tree_delete(XFS_DQUOT_TREE(mp, dqp->q_core.d_flags),
> +			  be32_to_cpu(dqp->q_core.d_id));
> +	mutex_unlock(&mp->m_quotainfo->qi_tree_lock);

qi->qi_tree_lock, as the local variable is already set up.

> @@ -672,10 +618,9 @@ xfs_qm_dqget(
>  	uint		flags,	  /* DQALLOC, DQSUSER, DQREPAIR, DOWARN */
>  	xfs_dquot_t	**O_dqpp) /* OUT : locked incore dquot */
>  {
> -	xfs_dquot_t	*dqp, *dqp1;
> -	xfs_dqhash_t	*h;
> -	uint		version;
> -	int		error;
> +	struct radix_tree_root *tree = XFS_DQUOT_TREE(mp, type);
> +	struct xfs_dquot	*dqp;
> +	int			error;

Add a quotainfo local variable and use it in the function?

> @@ -1171,10 +1078,10 @@ xfs_qm_dqpurge(
>  	xfs_dqfunlock(dqp);
>  	xfs_dqunlock(dqp);
>  
> -	mutex_lock(&qh->qh_lock);
> -	list_del_init(&dqp->q_hashlist);
> -	qh->qh_version++;
> -	mutex_unlock(&qh->qh_lock);
> +	mutex_lock(&mp->m_quotainfo->qi_tree_lock);
> +	radix_tree_delete(XFS_DQUOT_TREE(mp, dqp->q_core.d_flags),
> +			  be32_to_cpu(dqp->q_core.d_id));
> +	mutex_unlock(&mp->m_quotainfo->qi_tree_lock);

qi->qi_tree_lock as it is already there and used for all the other
quotainfo references.

Otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
