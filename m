Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB5555O1111950 for <xfs@oss.sgi.com>; Sun, 4 Dec 2011 23:05:06 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4947D1564221
	for <xfs@oss.sgi.com>; Sun,  4 Dec 2011 21:05:01 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oniphOyGHZqaDJEn for <xfs@oss.sgi.com>;
	Sun, 04 Dec 2011 21:05:01 -0800 (PST)
Date: Mon, 5 Dec 2011 16:04:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/16] xfs: flatten the dquot lock ordering
Message-ID: <20111205050428.GP7046@dastard>
References: <20111128082722.604873274@bombadil.infradead.org>
	<20111128082837.808570926@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111128082837.808570926@bombadil.infradead.org>
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

On Mon, Nov 28, 2011 at 03:27:31AM -0500, Christoph Hellwig wrote:
> Introduce a new XFS_DQ_FREEING flag that tells lookup and mplist walks
> to skip a dquot that is beeing freed, and use this avoid the trylock
> on the hash and mplist locks in xfs_qm_dqreclaim_one.

Ok, so we now mark dquots being freed with a flag, and then avoid
those inodes during various operations as they dquots are considered
dead.

That means we can use the fact that nothing new will ever use the
dquot being freed while it is still active on lists, so we don't
need to nest locks during reclaim of the dquot to prevent concurrent
lookups from finding it.

Did i understand the intent correctly?

> Also simplify
> xfs_dqpurge by moving the inodes to a dispose list after marking them
> XFS_DQ_FREEING and avoid the locker ordering constraints.

Ok, so changing to a 2 phase reclaim algorithm - mark them for
reclaim and gather them needing only one lock for the list being
walked, then walk that gathered list and free them properly, knowing
that lookups won't find them due to the XFS_DQ_FREEING flag.

Basically the same principles as the VFS cache item reclaim, again?

> Signed-off-by: Christoph Hellwig <hch@lst.de>

......

> @@ -1335,31 +1314,34 @@ xfs_qm_dqpurge(
>  				__func__, dqp);
>  		xfs_dqflock(dqp);
>  	}
> +
>  	ASSERT(atomic_read(&dqp->q_pincount) == 0);
>  	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
>  	       !(dqp->q_logitem.qli_item.li_flags & XFS_LI_IN_AIL));
>  
> +	xfs_dqfunlock(dqp);
> +	xfs_dqunlock(dqp);
> +
> +	mutex_lock(&qh->qh_lock);
>  	list_del_init(&dqp->q_hashlist);
>  	qh->qh_version++;
> +	mutex_unlock(&qh->qh_lock);
>  
> +	mutex_lock(&mp->m_quotainfo->qi_dqlist_lock);
>  	list_del_init(&dqp->q_mplist);
>  	mp->m_quotainfo->qi_dqreclaims++;
>  	mp->m_quotainfo->qi_dquots--;
> +	mutex_unlock(&mp->m_quotainfo->qi_dqlist_lock);
>  
> +	mutex_lock(&xfs_Gqm->qm_dqfrlist_lock);
> +	ASSERT(!list_empty(&dqp->q_freelist));
>  	list_del_init(&dqp->q_freelist);

That assert could do with a comment - I had to think hard about why
that was correct. It's because when the dquot refcount goes to zero it
is moved onto the free list, so when reclaiming a dquot we should
always find it on the free list....

.....

> @@ -489,8 +498,8 @@ xfs_qm_dqpurge_int(
>  	struct xfs_quotainfo	*q = mp->m_quotainfo;
>  	struct xfs_dquot	*dqp, *n;
>  	uint			dqtype;
> -	int			nrecl;
> -	int			nmisses;
> +	int			nmisses = 0;
> +	LIST_HEAD		(dispose_list);

Curious style. I haven't seen that before - not sure whether I like
it or not yet...

>  
>  	if (!q)
>  		return 0;
> @@ -509,46 +518,27 @@ xfs_qm_dqpurge_int(
>  	 */
>  	xfs_qm_detach_gdquots(mp);
>  
> -      again:
> -	nmisses = 0;

I don't think that nmisses is initialised to zero correctly anymore.

> -	ASSERT(mutex_is_locked(&q->qi_dqlist_lock));
>  	/*
>  	 * Try to get rid of all of the unwanted dquots. The idea is to
>  	 * get them off mplist and hashlist, but leave them on freelist.
>  	 */

That comment is no longer correct - they purged dquots don't remain
on the freelist anymore - they are freed....

.....

> @@ -1737,57 +1717,40 @@ again:
>  			}
>  			goto dqunlock;
>  		}
> +		xfs_dqfunlock(dqp);
>  
>  		/*
> -		 * We're trying to get the hashlock out of order. This races
> -		 * with dqlookup; so, we giveup and goto the next dquot if
> -		 * we couldn't get the hashlock. This way, we won't starve
> -		 * a dqlookup process that holds the hashlock that is
> -		 * waiting for the freelist lock.
> +		 * Prevent lookups now that we are past the point of no return.
>  		 */
> -		if (!mutex_trylock(&dqp->q_hash->qh_lock)) {
> -			restarts++;
> -			goto dqfunlock;
> -		}
> +		dqp->dq_flags |= XFS_DQ_FREEING;
> +		xfs_dqunlock(dqp);

Probably worth commenting here that it is safe to access the dquot
unlocked because we own the XFS_DQ_FREEING flag that guarantees
nobody else will start using the dquot once we unlock it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
