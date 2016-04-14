Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5D5AE7CB1
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 07:11:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 265F28F8033
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 05:11:03 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zlE2f1JsKmrYpbFx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2016 05:11:01 -0700 (PDT)
Date: Thu, 14 Apr 2016 08:11:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 11/11] xfs: move reclaim tagging functions
Message-ID: <20160414121059.GD20696@bfoster.bfoster>
References: <1460525492-1170-1-git-send-email-david@fromorbit.com>
	<1460525492-1170-12-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460525492-1170-12-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 13, 2016 at 03:31:32PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Rearrange the inode tagging functions so that they are higher up in
> xfs_cache.c and so there is no need for forward prototypes to be
> defined. This is purely code movement, no other change.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_icache.c | 235 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 116 insertions(+), 119 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 927e7b0..dab58e1 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -37,8 +37,6 @@
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
>  
> -STATIC void xfs_inode_clear_reclaim_tag(struct xfs_perag *pag, xfs_ino_t ino);
> -
>  /*
>   * Allocate and initialise an xfs_inode.
>   */
> @@ -172,6 +170,122 @@ xfs_reinit_inode(
>  }
>  
>  /*
> + * Queue a new inode reclaim pass if there are reclaimable inodes and there
> + * isn't a reclaim pass already in progress. By default it runs every 5s based
> + * on the xfs periodic sync default of 30s. Perhaps this should have it's own
> + * tunable, but that can be done if this method proves to be ineffective or too
> + * aggressive.
> + */
> +static void
> +xfs_reclaim_work_queue(
> +	struct xfs_mount        *mp)
> +{
> +
> +	rcu_read_lock();
> +	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
> +		queue_delayed_work(mp->m_reclaim_workqueue, &mp->m_reclaim_work,
> +			msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
> +	}
> +	rcu_read_unlock();
> +}
> +
> +/*
> + * This is a fast pass over the inode cache to try to get reclaim moving on as
> + * many inodes as possible in a short period of time. It kicks itself every few
> + * seconds, as well as being kicked by the inode cache shrinker when memory
> + * goes low. It scans as quickly as possible avoiding locked inodes or those
> + * already being flushed, and once done schedules a future pass.
> + */
> +void
> +xfs_reclaim_worker(
> +	struct work_struct *work)
> +{
> +	struct xfs_mount *mp = container_of(to_delayed_work(work),
> +					struct xfs_mount, m_reclaim_work);
> +
> +	xfs_reclaim_inodes(mp, SYNC_TRYLOCK);
> +	xfs_reclaim_work_queue(mp);
> +}
> +
> +static void
> +xfs_perag_set_reclaim_tag(
> +	struct xfs_perag	*pag,
> +	xfs_ino_t		ino)
> +{
> +	struct xfs_mount	*mp = pag->pag_mount;
> +
> +	ASSERT(spin_is_locked(&pag->pag_ici_lock));
> +	if (pag->pag_ici_reclaimable++)
> +		return;
> +
> +	/* propagate the reclaim tag up into the perag radix tree */
> +	spin_lock(&mp->m_perag_lock);
> +	radix_tree_tag_set(&mp->m_perag_tree, pag->pag_agno,
> +			   XFS_ICI_RECLAIM_TAG);
> +	spin_unlock(&mp->m_perag_lock);
> +
> +	/* schedule periodic background inode reclaim */
> +	xfs_reclaim_work_queue(mp);
> +
> +	trace_xfs_perag_set_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
> +}
> +
> +static void
> +xfs_perag_clear_reclaim_tag(
> +	struct xfs_perag	*pag)
> +{
> +	struct xfs_mount	*mp = pag->pag_mount;
> +
> +	ASSERT(spin_is_locked(&pag->pag_ici_lock));
> +	if (--pag->pag_ici_reclaimable)
> +		return;
> +
> +	/* clear the reclaim tag from the perag radix tree */
> +	spin_lock(&mp->m_perag_lock);
> +	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno,
> +			     XFS_ICI_RECLAIM_TAG);
> +	spin_unlock(&mp->m_perag_lock);
> +	trace_xfs_perag_clear_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
> +}
> +
> +/*
> + * We set the inode flag atomically with the radix tree tag.
> + * Once we get tag lookups on the radix tree, this inode flag
> + * can go away.
> + */
> +void
> +xfs_inode_set_reclaim_tag(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_perag	*pag;
> +
> +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +	spin_lock(&pag->pag_ici_lock);
> +	spin_lock(&ip->i_flags_lock);
> +
> +	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
> +			   XFS_ICI_RECLAIM_TAG);
> +	xfs_perag_set_reclaim_tag(pag, ip->i_ino);
> +	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
> +
> +	spin_unlock(&ip->i_flags_lock);
> +	spin_unlock(&pag->pag_ici_lock);
> +	xfs_perag_put(pag);
> +}
> +
> +static void
> +xfs_inode_clear_reclaim_tag(
> +	struct xfs_perag	*pag,
> +	xfs_ino_t		ino)
> +{
> +	radix_tree_tag_clear(&pag->pag_ici_root,
> +			     XFS_INO_TO_AGINO(pag->pag_mount, ino),
> +			     XFS_ICI_RECLAIM_TAG);
> +	xfs_perag_clear_reclaim_tag(pag);
> +}
> +
> +/*
>   * Check the validity of the inode we just found it the cache
>   */
>  static int
> @@ -729,123 +843,6 @@ xfs_inode_ag_iterator_tag(
>  }
>  
>  /*
> - * Queue a new inode reclaim pass if there are reclaimable inodes and there
> - * isn't a reclaim pass already in progress. By default it runs every 5s based
> - * on the xfs periodic sync default of 30s. Perhaps this should have it's own
> - * tunable, but that can be done if this method proves to be ineffective or too
> - * aggressive.
> - */
> -static void
> -xfs_reclaim_work_queue(
> -	struct xfs_mount        *mp)
> -{
> -
> -	rcu_read_lock();
> -	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
> -		queue_delayed_work(mp->m_reclaim_workqueue, &mp->m_reclaim_work,
> -			msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
> -	}
> -	rcu_read_unlock();
> -}
> -
> -/*
> - * This is a fast pass over the inode cache to try to get reclaim moving on as
> - * many inodes as possible in a short period of time. It kicks itself every few
> - * seconds, as well as being kicked by the inode cache shrinker when memory
> - * goes low. It scans as quickly as possible avoiding locked inodes or those
> - * already being flushed, and once done schedules a future pass.
> - */
> -void
> -xfs_reclaim_worker(
> -	struct work_struct *work)
> -{
> -	struct xfs_mount *mp = container_of(to_delayed_work(work),
> -					struct xfs_mount, m_reclaim_work);
> -
> -	xfs_reclaim_inodes(mp, SYNC_TRYLOCK);
> -	xfs_reclaim_work_queue(mp);
> -}
> -
> -static void
> -xfs_perag_set_reclaim_tag(
> -	struct xfs_perag	*pag,
> -	xfs_ino_t		ino)
> -{
> -	struct xfs_mount	*mp = pag->pag_mount;
> -
> -	ASSERT(spin_is_locked(&pag->pag_ici_lock));
> -	if (pag->pag_ici_reclaimable++)
> -		return;
> -
> -	/* propagate the reclaim tag up into the perag radix tree */
> -	spin_lock(&mp->m_perag_lock);
> -	radix_tree_tag_set(&mp->m_perag_tree, pag->pag_agno,
> -			   XFS_ICI_RECLAIM_TAG);
> -	spin_unlock(&mp->m_perag_lock);
> -
> -	/* schedule periodic background inode reclaim */
> -	xfs_reclaim_work_queue(mp);
> -
> -	trace_xfs_perag_set_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
> -}
> -
> -static void
> -xfs_perag_clear_reclaim_tag(
> -	struct xfs_perag	*pag)
> -{
> -	struct xfs_mount	*mp = pag->pag_mount;
> -
> -	ASSERT(spin_is_locked(&pag->pag_ici_lock));
> -	if (--pag->pag_ici_reclaimable)
> -		return;
> -
> -	/* clear the reclaim tag from the perag radix tree */
> -	spin_lock(&mp->m_perag_lock);
> -	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno,
> -			     XFS_ICI_RECLAIM_TAG);
> -	spin_unlock(&mp->m_perag_lock);
> -	trace_xfs_perag_clear_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
> -}
> -
> -/*
> - * We set the inode flag atomically with the radix tree tag.
> - * Once we get tag lookups on the radix tree, this inode flag
> - * can go away.
> - */
> -void
> -xfs_inode_set_reclaim_tag(
> -	struct xfs_inode	*ip)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_perag	*pag;
> -
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> -	spin_lock(&pag->pag_ici_lock);
> -	spin_lock(&ip->i_flags_lock);
> -
> -	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
> -			   XFS_ICI_RECLAIM_TAG);
> -	xfs_perag_set_reclaim_tag(pag, ip->i_ino);
> -	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
> -
> -	spin_unlock(&ip->i_flags_lock);
> -	spin_unlock(&pag->pag_ici_lock);
> -	xfs_perag_put(pag);
> -}
> -
> -
> -STATIC void
> -xfs_inode_clear_reclaim_tag(
> -	struct xfs_perag	*pag,
> -	xfs_ino_t		ino)
> -{
> -	radix_tree_tag_clear(&pag->pag_ici_root,
> -			     XFS_INO_TO_AGINO(pag->pag_mount, ino),
> -			     XFS_ICI_RECLAIM_TAG);
> -	xfs_perag_clear_reclaim_tag(pag);
> -}
> -
> -/*
>   * Grab the inode for reclaim exclusively.
>   * Return 0 if we grabbed it, non-zero otherwise.
>   */
> -- 
> 2.7.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
