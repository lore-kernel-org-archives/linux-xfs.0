Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 223CB7CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 07:51:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DC9D8304059
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 05:51:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xrGDwuIhLeJaWoK2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2016 05:51:38 -0700 (PDT)
Date: Wed, 6 Apr 2016 08:51:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/5] xfs: fix inode validity check in xfs_iflush_cluster
Message-ID: <20160406125136.GA4188@bfoster.bfoster>
References: <1459934574-25543-1-git-send-email-david@fromorbit.com>
	<1459934574-25543-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459934574-25543-2-git-send-email-david@fromorbit.com>
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

On Wed, Apr 06, 2016 at 07:22:50PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Some careless idiot wrote crap code in commit 1a3e8f3 ("xfs: convert
> inode cache lookups to use RCU locking") back in late 2010, and so
> xfs_iflush_cluster checks the wrong inode for whether it is still
> valid under RCU protection. Fix it to lock and check the correct
> inode.
> 
> Part of the reason for the screwup was the unconventional naming of
> the cluster inode variable - iq - so also rename all the cluster
> inode variables to use a more conventional prefixes to reduce
> potential future confusion (cilist, cilist_size, cip).
> 
> Discovered-by: Brain Foster <bfoster@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Heh, the variable name changes are probably a good idea. It's very easy
to misread between iq/ip. I'm not sure how many times I read through
xfs_iflush_cluster() before I realized it wasn't doing what I thought it
was doing, but it was at least once or twice. ;)

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c | 64 +++++++++++++++++++++++++++---------------------------
>  1 file changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f79ea59..2718d10 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3149,16 +3149,16 @@ out_release_wip:
>  
>  STATIC int
>  xfs_iflush_cluster(
> -	xfs_inode_t	*ip,
> -	xfs_buf_t	*bp)
> +	struct xfs_inode	*ip,
> +	struct xfs_buf		*bp)
>  {
> -	xfs_mount_t		*mp = ip->i_mount;
> +	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_perag	*pag;
>  	unsigned long		first_index, mask;
>  	unsigned long		inodes_per_cluster;
> -	int			ilist_size;
> -	xfs_inode_t		**ilist;
> -	xfs_inode_t		*iq;
> +	int			cilist_size;
> +	struct xfs_inode	**cilist;
> +	struct xfs_inode	*cip;
>  	int			nr_found;
>  	int			clcount = 0;
>  	int			bufwasdelwri;
> @@ -3167,23 +3167,23 @@ xfs_iflush_cluster(
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
>  
>  	inodes_per_cluster = mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog;
> -	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
> -	ilist = kmem_alloc(ilist_size, KM_MAYFAIL|KM_NOFS);
> -	if (!ilist)
> +	cilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
> +	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
> +	if (!cilist)
>  		goto out_put;
>  
>  	mask = ~(((mp->m_inode_cluster_size >> mp->m_sb.sb_inodelog)) - 1);
>  	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
>  	rcu_read_lock();
>  	/* really need a gang lookup range call here */
> -	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)ilist,
> +	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)cilist,
>  					first_index, inodes_per_cluster);
>  	if (nr_found == 0)
>  		goto out_free;
>  
>  	for (i = 0; i < nr_found; i++) {
> -		iq = ilist[i];
> -		if (iq == ip)
> +		cip = cilist[i];
> +		if (cip == ip)
>  			continue;
>  
>  		/*
> @@ -3192,20 +3192,20 @@ xfs_iflush_cluster(
>  		 * We need to check under the i_flags_lock for a valid inode
>  		 * here. Skip it if it is not valid or the wrong inode.
>  		 */
> -		spin_lock(&ip->i_flags_lock);
> -		if (!ip->i_ino ||
> -		    (XFS_INO_TO_AGINO(mp, iq->i_ino) & mask) != first_index) {
> -			spin_unlock(&ip->i_flags_lock);
> +		spin_lock(&cip->i_flags_lock);
> +		if (!cip->i_ino ||
> +		    (XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
> +			spin_unlock(&cip->i_flags_lock);
>  			continue;
>  		}
> -		spin_unlock(&ip->i_flags_lock);
> +		spin_unlock(&cip->i_flags_lock);
>  
>  		/*
>  		 * Do an un-protected check to see if the inode is dirty and
>  		 * is a candidate for flushing.  These checks will be repeated
>  		 * later after the appropriate locks are acquired.
>  		 */
> -		if (xfs_inode_clean(iq) && xfs_ipincount(iq) == 0)
> +		if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
>  			continue;
>  
>  		/*
> @@ -3213,15 +3213,15 @@ xfs_iflush_cluster(
>  		 * then this inode cannot be flushed and is skipped.
>  		 */
>  
> -		if (!xfs_ilock_nowait(iq, XFS_ILOCK_SHARED))
> +		if (!xfs_ilock_nowait(cip, XFS_ILOCK_SHARED))
>  			continue;
> -		if (!xfs_iflock_nowait(iq)) {
> -			xfs_iunlock(iq, XFS_ILOCK_SHARED);
> +		if (!xfs_iflock_nowait(cip)) {
> +			xfs_iunlock(cip, XFS_ILOCK_SHARED);
>  			continue;
>  		}
> -		if (xfs_ipincount(iq)) {
> -			xfs_ifunlock(iq);
> -			xfs_iunlock(iq, XFS_ILOCK_SHARED);
> +		if (xfs_ipincount(cip)) {
> +			xfs_ifunlock(cip);
> +			xfs_iunlock(cip, XFS_ILOCK_SHARED);
>  			continue;
>  		}
>  
> @@ -3229,18 +3229,18 @@ xfs_iflush_cluster(
>  		 * arriving here means that this inode can be flushed.  First
>  		 * re-check that it's dirty before flushing.
>  		 */
> -		if (!xfs_inode_clean(iq)) {
> +		if (!xfs_inode_clean(cip)) {
>  			int	error;
> -			error = xfs_iflush_int(iq, bp);
> +			error = xfs_iflush_int(cip, bp);
>  			if (error) {
> -				xfs_iunlock(iq, XFS_ILOCK_SHARED);
> +				xfs_iunlock(cip, XFS_ILOCK_SHARED);
>  				goto cluster_corrupt_out;
>  			}
>  			clcount++;
>  		} else {
> -			xfs_ifunlock(iq);
> +			xfs_ifunlock(cip);
>  		}
> -		xfs_iunlock(iq, XFS_ILOCK_SHARED);
> +		xfs_iunlock(cip, XFS_ILOCK_SHARED);
>  	}
>  
>  	if (clcount) {
> @@ -3250,7 +3250,7 @@ xfs_iflush_cluster(
>  
>  out_free:
>  	rcu_read_unlock();
> -	kmem_free(ilist);
> +	kmem_free(cilist);
>  out_put:
>  	xfs_perag_put(pag);
>  	return 0;
> @@ -3293,8 +3293,8 @@ cluster_corrupt_out:
>  	/*
>  	 * Unlocks the flush lock
>  	 */
> -	xfs_iflush_abort(iq, false);
> -	kmem_free(ilist);
> +	xfs_iflush_abort(cip, false);
> +	kmem_free(cilist);
>  	xfs_perag_put(pag);
>  	return -EFSCORRUPTED;
>  }
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
