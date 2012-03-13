Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2DK3lcM058714 for <xfs@oss.sgi.com>; Tue, 13 Mar 2012 15:03:47 -0500
Date: Tue, 13 Mar 2012 15:03:54 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/5] xfs: remove the per-filesystem list of dquots
Message-ID: <20120313200354.GI7762@sgi.com>
References: <20120313085232.134690907@bombadil.infradead.org>
	<20120313085308.997632929@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120313085308.997632929@bombadil.infradead.org>
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

Hey Christoph,

On Tue, Mar 13, 2012 at 04:52:36AM -0400, Christoph Hellwig wrote:
> Instead of keeping a separate per-filesystem list of dquots we can walk
> the radix tree for the two places where we need to iterate all quota
> structures.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> ---
>  fs/xfs/xfs_dquot.c |   37 ++----
>  fs/xfs/xfs_dquot.h |    3 
>  fs/xfs/xfs_qm.c    |  283 +++++++++++++++++++++++------------------------------
>  fs/xfs/xfs_qm.h    |    4 
>  4 files changed, 142 insertions(+), 185 deletions(-)
> 
> V2: remove the useless flags/type argument to the iterator callbacks
>

...

> Index: xfs/fs/xfs/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm.c	2012-03-13 09:37:53.236788274 +0100
> +++ xfs/fs/xfs/xfs_qm.c	2012-03-13 09:39:32.823456788 +0100
> @@ -169,6 +169,196 @@ xfs_qm_rele_quotafs_ref(
>  }
>  
>  /*
> + * We use the batch lookup interface to iterate over the dquots as it
> + * currently is the only interface into the radix tree code that allows
> + * fuzzy lookups instead of exact matches.  Holding the lock over multiple
> + * operations is fine as all callers are used either during mount/umount
> + * or quotaoff.
> + */
> +#define XFS_DQ_LOOKUP_BATCH	32
> +
> +STATIC int
> +xfs_qm_dquot_walk(
> +	struct xfs_mount	*mp,
> +	int			type,
> +	int			(*execute)(struct xfs_dquot *dqp))
> +{
> +	struct xfs_quotainfo	*qi = mp->m_quotainfo;
> +	struct radix_tree_root	*tree = XFS_DQUOT_TREE(qi, type);
> +	uint32_t		next_index;
> +	int			last_error = 0;
> +	int			skipped;
> +	int			nr_found;
> +
> +restart:
> +	skipped = 0;
> +	next_index = 0;
> +	nr_found = 0;
> +
> +	while (1) {
> +		struct xfs_dquot *batch[XFS_DQ_LOOKUP_BATCH];

Eesh.. that probably doesn't need to go onto the stack.  I know we are
doing it elsewhere too, and that we also sometimes complain about other
peoples' stack usage.  Don't necessarily have to clean it up now,
though.  ;)

> +		int		error = 0;
> +		int		i;
> +
> +		mutex_lock(&qi->qi_tree_lock);
> +		nr_found = radix_tree_gang_lookup(tree, (void **)batch,
> +					next_index, XFS_DQ_LOOKUP_BATCH);
> +		if (!nr_found) {
> +			mutex_unlock(&qi->qi_tree_lock);
> +			break;
> +		}
> +
> +		for (i = 0; i < nr_found; i++) {
> +			struct xfs_dquot *dqp = batch[i];
> +
> +			next_index = be32_to_cpu(dqp->q_core.d_id) + 1;
> +
> +			error = execute(batch[i]);
> +			if (error == EAGAIN) {
> +				skipped++;
> +				continue;
> +			}
> +			if (error && last_error != EFSCORRUPTED)
> +				last_error = error;
> +		}
> +
> +		mutex_unlock(&qi->qi_tree_lock);
> +
> +		/* bail out if the filesystem is corrupted.  */
> +		if (error == EFSCORRUPTED) {
		    last_error

Error can be overwritten in the nr_found loop above.  I think last_error
is what you want.

> +			skipped = 0;
> +			break;
> +		}
> +	}
> +
> +	if (skipped) {
> +		delay(1);
> +		goto restart;
> +	}
> +
> +	return last_error;
> +}

...

> +/*
> + * Purge the dquot cache.
> + */
> +int
> +xfs_qm_dqpurge_all(
> +	struct xfs_mount	*mp,
> +	uint			flags)
> +{
> +	int			error = 0, error2;
> +
> +	if (flags & XFS_QMOPT_UQUOTA)
> +		error = xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge);
> +	if (flags & XFS_QMOPT_GQUOTA) {
> +		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge);
> +		if (!error)
> +			error = error2;
> +	}
> +	if (flags & XFS_QMOPT_PQUOTA) {
> +		error2 = xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge);
> +		if (!error)
> +			error = error2;
> +	}
> +	return error;
> +}

One caller of this function, xfs_qm_scall_quotaoff, treats the return
value not as an error, but as a counter of the number of dquots left to
purge.  If you really do have an error in here, we probably don't want
to loop.  If we do, lets make it clearer that we're checking for an
error and not a count.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
