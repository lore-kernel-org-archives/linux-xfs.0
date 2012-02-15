Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FMxS8U209002 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 16:59:28 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Kcy2yt6OFY26ZZzL for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 14:59:25 -0800 (PST)
Date: Thu, 16 Feb 2012 09:59:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/9] xfs: remove the per-filesystem list of dquots
Message-ID: <20120215225922.GO14132@dastard>
References: <20120215022926.577682146@bombadil.infradead.org>
	<20120215023147.213091674@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120215023147.213091674@bombadil.infradead.org>
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

On Tue, Feb 14, 2012 at 09:29:29PM -0500, Christoph Hellwig wrote:
> Instead of keeping a separate per-filesystem list of dquots we can walk
> the radix tree for the two places where we need to iterate all quota
> structures.

And with the new radix tree iterator code being worked on, this will
become even simpler soon...

.....
> @@ -1025,16 +1017,23 @@ xfs_dqlock2(
>  
>  /*
>   * Take a dquot out of the mount's dqlist as well as the hashlist.  This is

remove from the quota tree. No hashlist anymore, either...

> - * called via unmount as well as quotaoff, and the purge will always succeed.
> + * called via unmount as well as quotaoff.
>   */
> -void
> +int
>  xfs_qm_dqpurge(
> -	struct xfs_dquot	*dqp)
> +	struct xfs_dquot	*dqp,
> +	int			flags)
>  {
>  	struct xfs_mount	*mp = dqp->q_mount;
>  	struct xfs_quotainfo	*qi = mp->m_quotainfo;
>  
>  	xfs_dqlock(dqp);
> +	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
> +		xfs_dqlock(dqp);

xfs_dqunlock()?

> +++ xfs/fs/xfs/xfs_qm.c	2012-02-12 13:22:33.326936637 -0800
> @@ -308,172 +308,157 @@ xfs_qm_unmount_quotas(
>  }
>  
>  /*
> - * Flush all dquots of the given file system to disk. The dquots are
> - * _not_ purged from memory here, just their data written to disk.
> + * The quota lookup is done in batches to keep the amount of lock traffic and
> + * radix tree lookups to a minimum. The batch size is a trade off between
> + * lookup reduction and stack usage.

Given the way the locking works here, the gang lookup doesn't really
do anythign for reducing lock traffic. It reduces lookup overhead a
bit, but seeing as we don't drop the tree lock while executing
operations on each dquot I don't see much advantage in the
complexity of batched lookups....

>   */
> +#define XFS_DQ_LOOKUP_BATCH	32
> +
>  STATIC int
> -xfs_qm_dqflush_all(
> -	struct xfs_mount	*mp)
> -{
> -	struct xfs_quotainfo	*q = mp->m_quotainfo;
> -	int			recl;
> -	struct xfs_dquot	*dqp;
> -	int			error;
> +xfs_qm_dquot_walk(
> +	struct xfs_mount	*mp,
> +	int			type,
> +	int			(*execute)(struct xfs_dquot *dqp, int flags),
> +	int			flags)
> +{
> +	struct radix_tree_root	*tree = XFS_DQUOT_TREE(mp, type);
> +	uint32_t		first_index;
> +	int			last_error = 0;
> +	int			skipped;
> +	int			nr_found;
> +
> +restart:
> +	skipped = 0;
> +	first_index = 0;
> +	nr_found = 0;
>  
> -	if (!q)
> -		return 0;
> -again:
> -	mutex_lock(&q->qi_dqlist_lock);
> -	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
> -		xfs_dqlock(dqp);
> -		if ((dqp->dq_flags & XFS_DQ_FREEING) ||
> -		    !XFS_DQ_IS_DIRTY(dqp)) {
> -			xfs_dqunlock(dqp);
> -			continue;
> -		}
> +	mutex_lock(&mp->m_quotainfo->qi_tree_lock);
> +	do {
> +		struct xfs_dquot *batch[XFS_DQ_LOOKUP_BATCH];
> +		int		error = 0;
> +		int		i;
> +
> +		nr_found = radix_tree_gang_lookup(tree, (void **)batch,
> +					first_index, XFS_DQ_LOOKUP_BATCH);
> +		if (!nr_found)
> +			break;
>  
> -		/* XXX a sentinel would be better */
> -		recl = q->qi_dqreclaims;
> -		if (!xfs_dqflock_nowait(dqp)) {
> -			/*
> -			 * If we can't grab the flush lock then check
> -			 * to see if the dquot has been flushed delayed
> -			 * write.  If so, grab its buffer and send it
> -			 * out immediately.  We'll be able to acquire
> -			 * the flush lock when the I/O completes.
> -			 */
> -			xfs_dqflock_pushbuf_wait(dqp);
> +		for (i = 0; i < nr_found; i++) {
> +			struct xfs_dquot *dqp = batch[i];
> +
> +			first_index = be32_to_cpu(dqp->q_core.d_id) + 1;
> +
> +			error = execute(batch[i], flags);
> +			if (error == EAGAIN) {
> +				skipped++;
> +				continue;
> +			}
> +			if (error && last_error != EFSCORRUPTED)
> +				last_error = error;
> +		}
> +		/* bail out if the filesystem is corrupted.  */
> +		if (error == EFSCORRUPTED) {
> +			skipped = 0;
> +			break;
>  		}

The problem I see with this is that it holds the qi_tree_lock over
the entire walk - it is not dropped anywhere it there is no
reschedule pressure. Hence all lookups will stall while a walk is in
progress. Given a walk can block on IO or dquot locks, this could
mean that a walk holds off lookups for quite some time.

> -		/*
> -		 * Let go of the mplist lock. We don't want to hold it
> -		 * across a disk write.
> -		 */
> -		mutex_unlock(&q->qi_dqlist_lock);
> -		error = xfs_qm_dqflush(dqp, 0);
> -		xfs_dqunlock(dqp);
> -		if (error)
> -			return error;
>  
> -		mutex_lock(&q->qi_dqlist_lock);
> -		if (recl != q->qi_dqreclaims) {
> -			mutex_unlock(&q->qi_dqlist_lock);
> -			/* XXX restart limit */
> -			goto again;
> +		if (need_resched()) {
> +			mutex_unlock(&mp->m_quotainfo->qi_tree_lock);
> +			cond_resched();
> +			mutex_lock(&mp->m_quotainfo->qi_tree_lock);
>  		}

While this plays nice with other threads that require low latency,
it doesn't solve the "hold the lock for the entire walk" problem
when lookups are trying to get the qi tree lock as need_resched
state is only triggered at the scheduler level and not by lock
waiters.

The problem doesn't exist with the current code, because lookups are
done under the hash lock, not the list lock. Now both lookup and
all-dquot-walking functioanlity are under the same lock, so
hold-offs definitely need thinking about.  Do we need to hold the
tree lock over the execute() function - I can see the advantages for
the purge case, but for the flush case it is less clear. Perhaps
unconditionally dropping the tree lock after every batch would
mitigate this problem - after all we already have the index we need
to do the next lookup from and that doesn't change if we drop the
lock....

> +STATIC int
> +xfs_qm_flush_one(
> +	struct xfs_dquot	*dqp,
> +	int			flags)
>  {
> -	struct xfs_quotainfo	*q = mp->m_quotainfo;
> -	struct xfs_dquot	*dqp, *gdqp;
> +	int			error = 0;
>  
> - again:
> -	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
> -	list_for_each_entry(dqp, &q->qi_dqlist, q_mplist) {
> -		xfs_dqlock(dqp);
> -		if (dqp->dq_flags & XFS_DQ_FREEING) {
> -			xfs_dqunlock(dqp);
> -			mutex_unlock(&q->qi_dqlist_lock);
> -			delay(1);
> -			mutex_lock(&q->qi_dqlist_lock);
> -			goto again;
> -		}
> +	xfs_dqlock(dqp);
> +	if (dqp->dq_flags & XFS_DQ_FREEING)
> +		goto out_unlock;
> +	if (!XFS_DQ_IS_DIRTY(dqp))
> +		goto out_unlock;
>  
> -		gdqp = dqp->q_gdquot;
> -		if (gdqp)
> -			dqp->q_gdquot = NULL;
> -		xfs_dqunlock(dqp);
> +	if (!xfs_dqflock_nowait(dqp))
> +		xfs_dqflock_pushbuf_wait(dqp);

For example, this blocks holding the tree lock waiting for IO
completion.

> -xfs_qm_dqpurge_int(
> +xfs_qm_detach_gdquot(
> +	struct xfs_dquot	*dqp,
> +	int			flags)
> +{
> +	struct xfs_dquot	*gdqp;
> +
> +	xfs_dqlock(dqp);
> +	/* XXX(hch): should we bother with freeeing dquots here? */
> +	if (dqp->dq_flags & XFS_DQ_FREEING) {
> +		xfs_dqunlock(dqp);
> +		return 0;
> +	}

Better to be safe, I think, rather than leave a landmine for future
modifications to trip over...

.....

> +	if (!error && (flags & XFS_QMOPT_UQUOTA))
> +		error = xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_dqpurge, 0);
> +	if (!error && (flags & XFS_QMOPT_GQUOTA))
> +		error = xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_dqpurge, 0);
> +	if (!error && (flags & XFS_QMOPT_PQUOTA))
> +		error = xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_dqpurge, 0);
> +	return error;

Seeing as it is a purge, even on an error I'd still try to purge all
trees. Indeed, what happens in the case of a filesystem shutdown
here?

> +	 * We've made all the changes that we need to make incore.  Flush them
> +	 * down to disk buffers if everything was updated successfully.
>  	 */
> -	if (!error)
> -		error = xfs_qm_dqflush_all(mp);
> +	if (!error && XFS_IS_UQUOTA_ON(mp))
> +		error = xfs_qm_dquot_walk(mp, XFS_DQ_USER, xfs_qm_flush_one, 0);
> +	if (!error && XFS_IS_GQUOTA_ON(mp))
> +		error = xfs_qm_dquot_walk(mp, XFS_DQ_GROUP, xfs_qm_flush_one, 0);
> +	if (!error && XFS_IS_PQUOTA_ON(mp))
> +		error = xfs_qm_dquot_walk(mp, XFS_DQ_PROJ, xfs_qm_flush_one, 0);

Same here - I'd still try to flush each tree even if one tree gets
an error...

Hmmmm- all the walk cases pass 0 as their flags. Are they used in
later patches?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
