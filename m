Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n55IHxFn057979 for <xfs@oss.sgi.com>; Fri, 5 Jun 2009 13:17:59 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBCC72D6DB4
	for <xfs@oss.sgi.com>; Fri,  5 Jun 2009 11:18:17 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 5gqOxwe53wXiWCaC for <xfs@oss.sgi.com>;
	Fri, 05 Jun 2009 11:18:17 -0700 (PDT)
Message-ID: <4A29615E.2070303@sandeen.net>
Date: Fri, 05 Jun 2009 13:18:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/7] xfs: introduce a per-ag inode iterator
References: <20090514171233.942489000@bombadil.infradead.org>	<20090514171558.869514000@bombadil.infradead.org>	<4A26F6B1.20509@sandeen.net>
	<20090604171726.GA13501@infradead.org>
In-Reply-To: <20090604171726.GA13501@infradead.org>
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

Christoph Hellwig wrote:
> On Wed, Jun 03, 2009 at 05:18:25PM -0500, Eric Sandeen wrote:
>> Ok, it's looking for EAGAIN here, I'm assuming this is for when we are
>> calling xfs_reclaim_inode_now, because...
>>
>> ...
>> ... because before, that's what we did above, after testing for a non-0
>> return from xfs_reclaim_inode.
>>
>> But xfs_reclaim_inode_now() returns 0 or the result of
>> xfs_reclaim_inode, which is 0/1, so above:
> 
> Yeah.  Updated patch below that besides addressing the other comments
> makes xfs_reclaim_inode return -EAGAIN if it has to skip an inode.
> 
> Subject: xfs: introduce a per-ag inode iterator
> From: Dave Chinner <david@fromorbit.com>
> 
> From: Dave Chinner <david@fromorbit.com>
> 
> Given that we walk across the per-ag inode lists so often, it makes sense to
> introduce an iterator for this.
> 
> Convert the sync and reclaim code to use this new iterator, quota code will
> follow in the next patch.
> 
> Also change xfs_reclaim_inode to return -EGAIN instead of 1 for an inode
> already under reclaim.  This simplifies the AG iterator and doesn't
> matter for the only other caller.
> 
> [hch: merged the lookup and execute callbacks back into one to get the
>  pag_ici_lock locking correct and simplify the code flow]
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ok, I like this version :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Index: xfs/fs/xfs/linux-2.6/xfs_sync.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_sync.c	2009-06-04 12:50:25.380940755 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_sync.c	2009-06-04 13:09:06.199942249 +0200
> @@ -49,6 +49,123 @@
>  #include <linux/freezer.h>
>  
>  
> +STATIC xfs_inode_t *
> +xfs_inode_ag_lookup(
> +	struct xfs_mount	*mp,
> +	struct xfs_perag	*pag,
> +	uint32_t		*first_index,
> +	int			tag)
> +{
> +	int			nr_found;
> +	struct xfs_inode	*ip;
> +
> +	/*
> +	 * use a gang lookup to find the next inode in the tree
> +	 * as the tree is sparse and a gang lookup walks to find
> +	 * the number of objects requested.
> +	 */
> +	read_lock(&pag->pag_ici_lock);
> +	if (tag == -1) {
> +		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
> +				(void **)&ip, *first_index, 1);
> +	} else {
> +		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
> +				(void **)&ip, *first_index, 1, tag);
> +	}
> +	if (!nr_found)
> +		goto unlock;
> +
> +	/*
> +	 * Update the index for the next lookup. Catch overflows
> +	 * into the next AG range which can occur if we have inodes
> +	 * in the last block of the AG and we are currently
> +	 * pointing to the last inode.
> +	 */
> +	*first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
> +	if (*first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
> +		goto unlock;
> +
> +	return ip;
> +
> +unlock:
> +	read_unlock(&pag->pag_ici_lock);
> +	return NULL;
> +}
> +
> +STATIC int
> +xfs_inode_ag_walk(
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		ag,
> +	int			(*execute)(struct xfs_inode *ip,
> +					   struct xfs_perag *pag, int flags),
> +	int			flags,
> +	int			tag)
> +{
> +	struct xfs_perag	*pag = &mp->m_perag[ag];
> +	uint32_t		first_index;
> +	int			last_error = 0;
> +	int			skipped;
> +
> +restart:
> +	skipped = 0;
> +	first_index = 0;
> +	do {
> +		int		error = 0;
> +		xfs_inode_t	*ip;
> +
> +		ip = xfs_inode_ag_lookup(mp, pag, &first_index, tag);
> +		if (!ip)
> +			break;
> +
> +		error = execute(ip, pag, flags);
> +		if (error == EAGAIN) {
> +			skipped++;
> +			continue;
> +		}
> +		if (error)
> +			last_error = error;
> +		/*
> +		 * bail out if the filesystem is corrupted.
> +		 */
> +		if (error == EFSCORRUPTED)
> +			break;
> +
> +	} while (1);
> +
> +	if (skipped) {
> +		delay(1);
> +		goto restart;
> +	}
> +
> +	xfs_put_perag(mp, pag);
> +	return last_error;
> +}
> +
> +STATIC int
> +xfs_inode_ag_iterator(
> +	struct xfs_mount	*mp,
> +	int			(*execute)(struct xfs_inode *ip,
> +					   struct xfs_perag *pag, int flags),
> +	int			flags,
> +	int			tag)
> +{
> +	int			error = 0;
> +	int			last_error = 0;
> +	xfs_agnumber_t		ag;
> +
> +	for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
> +		if (!mp->m_perag[ag].pag_ici_init)
> +			continue;
> +		error = xfs_inode_ag_walk(mp, ag, execute, flags, tag);
> +		if (error) {
> +			last_error = error;
> +			if (error == EFSCORRUPTED)
> +				break;
> +		}
> +	}
> +	return XFS_ERROR(last_error);
> +}
> +
>  /* must be called with pag_ici_lock held and releases it */
>  STATIC int
>  xfs_sync_inode_valid(
> @@ -85,12 +202,17 @@ xfs_sync_inode_valid(
>  STATIC int
>  xfs_sync_inode_data(
>  	struct xfs_inode	*ip,
> +	struct xfs_perag	*pag,
>  	int			flags)
>  {
>  	struct inode		*inode = VFS_I(ip);
>  	struct address_space *mapping = inode->i_mapping;
>  	int			error = 0;
>  
> +	error = xfs_sync_inode_valid(ip, pag);
> +	if (error)
> +		return error;
> +
>  	if (!mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
>  		goto out_wait;
>  
> @@ -107,16 +229,22 @@ xfs_sync_inode_data(
>   out_wait:
>  	if (flags & SYNC_IOWAIT)
>  		xfs_ioend_wait(ip);
> +	IRELE(ip);
>  	return error;
>  }
>  
>  STATIC int
>  xfs_sync_inode_attr(
>  	struct xfs_inode	*ip,
> +	struct xfs_perag	*pag,
>  	int			flags)
>  {
>  	int			error = 0;
>  
> +	error = xfs_sync_inode_valid(ip, pag);
> +	if (error)
> +		return error;
> +
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  	if (xfs_inode_clean(ip))
>  		goto out_unlock;
> @@ -136,117 +264,33 @@ xfs_sync_inode_attr(
>  
>   out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +	IRELE(ip);
>  	return error;
>  }
>  
> -/*
> - * Sync all the inodes in the given AG according to the
> - * direction given by the flags.
> - */
> -STATIC int
> -xfs_sync_inodes_ag(
> -	xfs_mount_t	*mp,
> -	int		ag,
> -	int		flags)
> -{
> -	xfs_perag_t	*pag = &mp->m_perag[ag];
> -	int		nr_found;
> -	uint32_t	first_index = 0;
> -	int		error = 0;
> -	int		last_error = 0;
> -
> -	do {
> -		xfs_inode_t	*ip = NULL;
> -
> -		/*
> -		 * use a gang lookup to find the next inode in the tree
> -		 * as the tree is sparse and a gang lookup walks to find
> -		 * the number of objects requested.
> -		 */
> -		read_lock(&pag->pag_ici_lock);
> -		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
> -				(void**)&ip, first_index, 1);
> -
> -		if (!nr_found) {
> -			read_unlock(&pag->pag_ici_lock);
> -			break;
> -		}
> -
> -		/*
> -		 * Update the index for the next lookup. Catch overflows
> -		 * into the next AG range which can occur if we have inodes
> -		 * in the last block of the AG and we are currently
> -		 * pointing to the last inode.
> -		 */
> -		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
> -		if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino)) {
> -			read_unlock(&pag->pag_ici_lock);
> -			break;
> -		}
> -
> -		error = xfs_sync_inode_valid(ip, pag);
> -		if (error) {
> -			if (error == EFSCORRUPTED)
> -				return 0;
> -			continue;
> -		}
> -
> -		/*
> -		 * If we have to flush data or wait for I/O completion
> -		 * we need to hold the iolock.
> -		 */
> -		if (flags & SYNC_DELWRI)
> -			error = xfs_sync_inode_data(ip, flags);
> -
> -		if (flags & SYNC_ATTR)
> -			error = xfs_sync_inode_attr(ip, flags);
> -
> -		IRELE(ip);
> -
> -		if (error)
> -			last_error = error;
> -		/*
> -		 * bail out if the filesystem is corrupted.
> -		 */
> -		if (error == EFSCORRUPTED)
> -			return XFS_ERROR(error);
> -
> -	} while (nr_found);
> -
> -	return last_error;
> -}
> -
>  int
>  xfs_sync_inodes(
>  	xfs_mount_t	*mp,
>  	int		flags)
>  {
> -	int		error;
> -	int		last_error;
> -	int		i;
> +	int		error = 0;
>  	int		lflags = XFS_LOG_FORCE;
>  
>  	if (mp->m_flags & XFS_MOUNT_RDONLY)
>  		return 0;
> -	error = 0;
> -	last_error = 0;
>  
>  	if (flags & SYNC_WAIT)
>  		lflags |= XFS_LOG_SYNC;
>  
> -	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
> -		if (!mp->m_perag[i].pag_ici_init)
> -			continue;
> -		error = xfs_sync_inodes_ag(mp, i, flags);
> -		if (error)
> -			last_error = error;
> -		if (error == EFSCORRUPTED)
> -			break;
> -	}
>  	if (flags & SYNC_DELWRI)
> -		xfs_log_force(mp, 0, lflags);
> +		error = xfs_inode_ag_iterator(mp, xfs_sync_inode_data, flags, -1);
>  
> -	return XFS_ERROR(last_error);
> +	if (flags & SYNC_ATTR)
> +		error = xfs_inode_ag_iterator(mp, xfs_sync_inode_attr, flags, -1);
> +
> +	if (!error && (flags & SYNC_DELWRI))
> +		xfs_log_force(mp, 0, lflags);
> +	return XFS_ERROR(error);
>  }
>  
>  STATIC int
> @@ -613,7 +657,7 @@ xfs_reclaim_inode(
>  			xfs_ifunlock(ip);
>  			xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  		}
> -		return 1;
> +		return -EAGAIN;
>  	}
>  	__xfs_iflags_set(ip, XFS_IRECLAIM);
>  	spin_unlock(&ip->i_flags_lock);
> @@ -698,72 +742,20 @@ xfs_inode_clear_reclaim_tag(
>  	xfs_put_perag(mp, pag);
>  }
>  
> -
> -STATIC void
> -xfs_reclaim_inodes_ag(
> -	xfs_mount_t	*mp,
> -	int		ag,
> -	int		mode)
> +STATIC int
> +xfs_reclaim_inode_now(
> +	struct xfs_inode	*ip,
> +	struct xfs_perag	*pag,
> +	int			flags)
>  {
> -	xfs_inode_t	*ip = NULL;
> -	xfs_perag_t	*pag = &mp->m_perag[ag];
> -	int		nr_found;
> -	uint32_t	first_index;
> -	int		skipped;
> -
> -restart:
> -	first_index = 0;
> -	skipped = 0;
> -	do {
> -		/*
> -		 * use a gang lookup to find the next inode in the tree
> -		 * as the tree is sparse and a gang lookup walks to find
> -		 * the number of objects requested.
> -		 */
> -		read_lock(&pag->pag_ici_lock);
> -		nr_found = radix_tree_gang_lookup_tag(&pag->pag_ici_root,
> -					(void**)&ip, first_index, 1,
> -					XFS_ICI_RECLAIM_TAG);
> -
> -		if (!nr_found) {
> -			read_unlock(&pag->pag_ici_lock);
> -			break;
> -		}
> -
> -		/*
> -		 * Update the index for the next lookup. Catch overflows
> -		 * into the next AG range which can occur if we have inodes
> -		 * in the last block of the AG and we are currently
> -		 * pointing to the last inode.
> -		 */
> -		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
> -		if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino)) {
> -			read_unlock(&pag->pag_ici_lock);
> -			break;
> -		}
> -
> -		/* ignore if already under reclaim */
> -		if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
> -			read_unlock(&pag->pag_ici_lock);
> -			continue;
> -		}
> -
> +	/* ignore if already under reclaim */
> +	if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
>  		read_unlock(&pag->pag_ici_lock);
> -
> -		/*
> -		 * hmmm - this is an inode already in reclaim. Do
> -		 * we even bother catching it here?
> -		 */
> -		if (xfs_reclaim_inode(ip, 0, mode))
> -			skipped++;
> -	} while (nr_found);
> -
> -	if (skipped) {
> -		delay(1);
> -		goto restart;
> +		return 0;
>  	}
> -	return;
> +	read_unlock(&pag->pag_ici_lock);
>  
> +	return xfs_reclaim_inode(ip, 0, flags);
>  }
>  
>  int
> @@ -771,14 +763,6 @@ xfs_reclaim_inodes(
>  	xfs_mount_t	*mp,
>  	int		mode)
>  {
> -	int		i;
> -
> -	for (i = 0; i < mp->m_sb.sb_agcount; i++) {
> -		if (!mp->m_perag[i].pag_ici_init)
> -			continue;
> -		xfs_reclaim_inodes_ag(mp, i, mode);
> -	}
> -	return 0;
> +	return xfs_inode_ag_iterator(mp, xfs_reclaim_inode_now, mode,
> +					XFS_ICI_RECLAIM_TAG);
>  }
> -
> -
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
