Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA8N86Wu123253 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 17:08:10 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 42740139C77E
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 15:09:33 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rlZpNBDrpJvL7JSc for
	<xfs@oss.sgi.com>; Mon, 08 Nov 2010 15:09:33 -0800 (PST)
Date: Mon, 8 Nov 2010 18:09:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/16] xfs: convert inode cache lookups to use RCU locking
Message-ID: <20101108230929.GA13299@infradead.org>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<1289206519-18377-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1289206519-18377-8-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: paulmck@linux.vnet.ibm.com, eric.dumazet@gmail.com, xfs@oss.sgi.com

This patch generally looks good to me, but with so much RCU magic I'd prefer
if Paul & Eric could look over it.

On Mon, Nov 08, 2010 at 07:55:10PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With delayed logging greatly increasing the sustained parallelism of inode
> operations, the inode cache locking is showing significant read vs write
> contention when inode reclaim runs at the same time as lookups. There is
> also a lot more write lock acquistions than there are read locks (4:1 ratio)
> so the read locking is not really buying us much in the way of parallelism.
> 
> To avoid the read vs write contention, change the cache to use RCU locking on
> the read side. To avoid needing to RCU free every single inode, use the built
> in slab RCU freeing mechanism. This requires us to be able to detect lookups of
> freed inodes, so en??ure that ever freed inode has an inode number of zero and
> the XFS_IRECLAIM flag set. We already check the XFS_IRECLAIM flag in cache hit
> lookup path, but also add a check for a zero inode number as well.
> 
> We canthen convert all the read locking lockups to use RCU read side locking
> and hence remove all read side locking.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Alex Elder <aelder@sgi.com>
> ---
>  fs/xfs/linux-2.6/xfs_iops.c    |    7 +++++-
>  fs/xfs/linux-2.6/xfs_sync.c    |   13 +++++++++--
>  fs/xfs/quota/xfs_qm_syscalls.c |    3 ++
>  fs/xfs/xfs_iget.c              |   44 ++++++++++++++++++++++++++++++---------
>  fs/xfs/xfs_inode.c             |   22 ++++++++++++-------
>  5 files changed, 67 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
> index 8b46867..909bd9c 100644
> --- a/fs/xfs/linux-2.6/xfs_iops.c
> +++ b/fs/xfs/linux-2.6/xfs_iops.c
> @@ -757,6 +757,8 @@ xfs_diflags_to_iflags(
>   * We don't use the VFS inode hash for lookups anymore, so make the inode look
>   * hashed to the VFS by faking it. This avoids needing to touch inode hash
>   * locks in this path, but makes the VFS believe the inode is validly hashed.
> + * We initialise i_state and i_hash under the i_lock so that we follow the same
> + * setup rules that the rest of the VFS follows.
>   */
>  void
>  xfs_setup_inode(
> @@ -765,10 +767,13 @@ xfs_setup_inode(
>  	struct inode		*inode = &ip->i_vnode;
>  
>  	inode->i_ino = ip->i_ino;
> +
> +	spin_lock(&inode->i_lock);
>  	inode->i_state = I_NEW;
> +	hlist_nulls_add_fake(&inode->i_hash);
> +	spin_unlock(&inode->i_lock);

This screams for another VFS helper, even if it's XFS-specific for now.
Having to duplicate inode.c-private locking rules in XFS seems a bit
nasty to me.

>  
>  	inode_sb_list_add(inode);
> -	hlist_nulls_add_fake(&inode->i_hash);
>  
>  	inode->i_mode	= ip->i_d.di_mode;
>  	inode->i_nlink	= ip->i_d.di_nlink;
> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index afb0d7c..9a53cc9 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c
> @@ -53,6 +53,10 @@ xfs_inode_ag_walk_grab(
>  {
>  	struct inode		*inode = VFS_I(ip);
>  
> +	/* check for stale RCU freed inode */
> +	if (!ip->i_ino)
> +		return ENOENT;

Assuming i_ino is never 0 is fine for XFS, unlike for the generic VFS
code, so ACK.

>  	/* nothing to sync during shutdown */
>  	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
>  		return EFSCORRUPTED;
> @@ -98,12 +102,12 @@ restart:
>  		int		error = 0;
>  		int		i;
>  
> -		read_lock(&pag->pag_ici_lock);
> +		rcu_read_lock();
>  		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
>  					(void **)batch, first_index,
>  					XFS_LOOKUP_BATCH);
>  		if (!nr_found) {
> -			read_unlock(&pag->pag_ici_lock);
> +			rcu_read_unlock();
>  			break;
>  		}
>  
> @@ -129,7 +133,7 @@ restart:
>  		}
>  
>  		/* unlock now we've grabbed the inodes. */
> -		read_unlock(&pag->pag_ici_lock);
> +		rcu_read_unlock();
>  
>  		for (i = 0; i < nr_found; i++) {
>  			if (!batch[i])
> @@ -639,6 +643,9 @@ xfs_reclaim_inode_grab(
>  	struct xfs_inode	*ip,
>  	int			flags)
>  {
> +	/* check for stale RCU freed inode */
> +	if (!ip->i_ino)
> +		return 1;
>  
>  	/*
>  	 * do some unlocked checks first to avoid unnecceary lock traffic.
> diff --git a/fs/xfs/quota/xfs_qm_syscalls.c b/fs/xfs/quota/xfs_qm_syscalls.c
> index bdebc18..8b207fc 100644
> --- a/fs/xfs/quota/xfs_qm_syscalls.c
> +++ b/fs/xfs/quota/xfs_qm_syscalls.c
> @@ -875,6 +875,9 @@ xfs_dqrele_inode(
>  	struct xfs_perag	*pag,
>  	int			flags)
>  {
> +	if (!ip->i_ino)
> +		return ENOENT;
> +

Why do we need the check here again?  Having it in
xfs_inode_ag_walk_grab should be enough.

>  	/* skip quota inodes */
>  	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
>  	    ip == ip->i_mount->m_quotainfo->qi_gquotaip) {
> diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> index 18991a9..edeb918 100644
> --- a/fs/xfs/xfs_iget.c
> +++ b/fs/xfs/xfs_iget.c
> @@ -69,6 +69,7 @@ xfs_inode_alloc(
>  	ASSERT(atomic_read(&ip->i_pincount) == 0);
>  	ASSERT(!spin_is_locked(&ip->i_flags_lock));
>  	ASSERT(completion_done(&ip->i_flush));
> +	ASSERT(ip->i_ino == 0);
>  
>  	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
>  
> @@ -86,9 +87,6 @@ xfs_inode_alloc(
>  	ip->i_new_size = 0;
>  	ip->i_dirty_releases = 0;
>  
> -	/* prevent anyone from using this yet */
> -	VFS_I(ip)->i_state = I_NEW;
> -
>  	return ip;
>  }
>  
> @@ -135,6 +133,16 @@ xfs_inode_free(
>  	ASSERT(!spin_is_locked(&ip->i_flags_lock));
>  	ASSERT(completion_done(&ip->i_flush));
>  
> +	/*
> +	 * because we use SLAB_DESTROY_BY_RCU freeing, ensure the inode
> +	 * always appears to be reclaimed with an invalid inode number
> +	 * when in the free state. The ip->i_flags_lock provides the barrier
> +	 * against lookup races.
> +	 */
> +	spin_lock(&ip->i_flags_lock);
> +	ip->i_flags = XFS_IRECLAIM;
> +	ip->i_ino = 0;
> +	spin_unlock(&ip->i_flags_lock);
>  	kmem_zone_free(xfs_inode_zone, ip);
>  }
>  
> @@ -146,12 +154,28 @@ xfs_iget_cache_hit(
>  	struct xfs_perag	*pag,
>  	struct xfs_inode	*ip,
>  	int			flags,
> -	int			lock_flags) __releases(pag->pag_ici_lock)
> +	int			lock_flags) __releases(RCU)
>  {
>  	struct inode		*inode = VFS_I(ip);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			error;
>  
> +	/*
> +	 * check for re-use of an inode within an RCU grace period due to the
> +	 * radix tree nodes not being updated yet. We monitor for this by
> +	 * setting the inode number to zero before freeing the inode structure.
> +	 * We don't need to recheck this after taking the i_flags_lock because
> +	 * the check against XFS_IRECLAIM will catch a freed inode.
> +	 */
> +	if (ip->i_ino == 0) {
> +		trace_xfs_iget_skip(ip);
> +		XFS_STATS_INC(xs_ig_frecycle);
> +		rcu_read_unlock();
> +		/* Expire the grace period so we don't trip over it again. */
> +		synchronize_rcu();
> +		return EAGAIN;
> +	}
> +
>  	spin_lock(&ip->i_flags_lock);
>  
>  	/*
> @@ -195,7 +219,7 @@ xfs_iget_cache_hit(
>  		ip->i_flags |= XFS_IRECLAIM;
>  
>  		spin_unlock(&ip->i_flags_lock);
> -		read_unlock(&pag->pag_ici_lock);
> +		rcu_read_unlock();
>  
>  		error = -inode_init_always(mp->m_super, inode);
>  		if (error) {
> @@ -203,7 +227,7 @@ xfs_iget_cache_hit(
>  			 * Re-initializing the inode failed, and we are in deep
>  			 * trouble.  Try to re-add it to the reclaim list.
>  			 */
> -			read_lock(&pag->pag_ici_lock);
> +			rcu_read_lock();
>  			spin_lock(&ip->i_flags_lock);
>  
>  			ip->i_flags &= ~XFS_INEW;
> @@ -231,7 +255,7 @@ xfs_iget_cache_hit(
>  
>  		/* We've got a live one. */
>  		spin_unlock(&ip->i_flags_lock);
> -		read_unlock(&pag->pag_ici_lock);
> +		rcu_read_unlock();
>  		trace_xfs_iget_hit(ip);
>  	}
>  
> @@ -245,7 +269,7 @@ xfs_iget_cache_hit(
>  
>  out_error:
>  	spin_unlock(&ip->i_flags_lock);
> -	read_unlock(&pag->pag_ici_lock);
> +	rcu_read_unlock();
>  	return error;
>  }
>  
> @@ -376,7 +400,7 @@ xfs_iget(
>  
>  again:
>  	error = 0;
> -	read_lock(&pag->pag_ici_lock);
> +	rcu_read_lock();
>  	ip = radix_tree_lookup(&pag->pag_ici_root, agino);
>  
>  	if (ip) {
> @@ -384,7 +408,7 @@ again:
>  		if (error)
>  			goto out_error_or_again;
>  	} else {
> -		read_unlock(&pag->pag_ici_lock);
> +		rcu_read_unlock();
>  		XFS_STATS_INC(xs_ig_missed);
>  
>  		error = xfs_iget_cache_miss(mp, pag, tp, ino, &ip,
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 108c7a0..25becb1 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2000,13 +2000,14 @@ xfs_ifree_cluster(
>  		 */
>  		for (i = 0; i < ninodes; i++) {
>  retry:
> -			read_lock(&pag->pag_ici_lock);
> +			rcu_read_lock();
>  			ip = radix_tree_lookup(&pag->pag_ici_root,
>  					XFS_INO_TO_AGINO(mp, (inum + i)));
>  
>  			/* Inode not in memory or stale, nothing to do */
> -			if (!ip || xfs_iflags_test(ip, XFS_ISTALE)) {
> -				read_unlock(&pag->pag_ici_lock);
> +			if (!ip || !ip->i_ino ||
> +			    xfs_iflags_test(ip, XFS_ISTALE)) {
> +				rcu_read_unlock();
>  				continue;
>  			}
>  
> @@ -2019,11 +2020,11 @@ retry:
>  			 */
>  			if (ip != free_ip &&
>  			    !xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
> -				read_unlock(&pag->pag_ici_lock);
> +				rcu_read_unlock();
>  				delay(1);
>  				goto retry;
>  			}
> -			read_unlock(&pag->pag_ici_lock);
> +			rcu_read_unlock();
>  
>  			xfs_iflock(ip);
>  			xfs_iflags_set(ip, XFS_ISTALE);
> @@ -2629,7 +2630,7 @@ xfs_iflush_cluster(
>  
>  	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
>  	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
> -	read_lock(&pag->pag_ici_lock);
> +	rcu_read_lock();
>  	/* really need a gang lookup range call here */
>  	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)ilist,
>  					first_index, inodes_per_cluster);
> @@ -2640,6 +2641,11 @@ xfs_iflush_cluster(
>  		iq = ilist[i];
>  		if (iq == ip)
>  			continue;
> +
> +		/* check we've got a valid inode */
> +		if (!iq->i_ino)
> +			continue;
> +
>  		/* if the inode lies outside this cluster, we're done. */
>  		if ((XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) != first_index)
>  			break;
> @@ -2692,7 +2698,7 @@ xfs_iflush_cluster(
>  	}
>  
>  out_free:
> -	read_unlock(&pag->pag_ici_lock);
> +	rcu_read_unlock();
>  	kmem_free(ilist);
>  out_put:
>  	xfs_perag_put(pag);
> @@ -2704,7 +2710,7 @@ cluster_corrupt_out:
>  	 * Corruption detected in the clustering loop.  Invalidate the
>  	 * inode buffer and shut down the filesystem.
>  	 */
> -	read_unlock(&pag->pag_ici_lock);
> +	rcu_read_unlock();
>  	/*
>  	 * Clean up the buffer.  If it was B_DELWRI, just release it --
>  	 * brelse can handle it with no problems.  If not, shut down the
> -- 
> 1.7.2.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
