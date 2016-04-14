Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F41D7CA0
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 07:11:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2CE588F8033
	for <xfs@oss.sgi.com>; Thu, 14 Apr 2016 05:10:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id f37IwkQSWZGt7HvX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 14 Apr 2016 05:10:57 -0700 (PDT)
Date: Thu, 14 Apr 2016 08:10:55 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 10/11] xfs: simplify inode reclaim tagging interfaces
Message-ID: <20160414121055.GC20696@bfoster.bfoster>
References: <1460525492-1170-1-git-send-email-david@fromorbit.com>
	<1460525492-1170-11-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460525492-1170-11-git-send-email-david@fromorbit.com>
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

On Wed, Apr 13, 2016 at 03:31:31PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Inode radix tree tagging for reclaim passes a lot of unnecessary
> variables around. Over time the xfs-perag has grown a xfs_mount
> backpointer, and an internal agno so we don't need to pass other
> variables into the tagging functions to supply this information.
> 
> Rework the functions to pass the minimal variable set required
> and simplify the internal logic and flow.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_icache.c | 97 +++++++++++++++++++++++++++--------------------------
>  1 file changed, 49 insertions(+), 48 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index a60db43..927e7b0 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -37,8 +37,7 @@
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
>  
> -STATIC void __xfs_inode_clear_reclaim_tag(struct xfs_mount *mp,
> -				struct xfs_perag *pag, struct xfs_inode *ip);
> +STATIC void xfs_inode_clear_reclaim_tag(struct xfs_perag *pag, xfs_ino_t ino);
>  
>  /*
>   * Allocate and initialise an xfs_inode.
> @@ -271,7 +270,7 @@ xfs_iget_cache_hit(
>  		 */
>  		ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
>  		ip->i_flags |= XFS_INEW;
> -		__xfs_inode_clear_reclaim_tag(mp, pag, ip);
> +		xfs_inode_clear_reclaim_tag(pag, ip->i_ino);
>  		inode->i_state = I_NEW;
>  
>  		ASSERT(!rwsem_is_locked(&ip->i_iolock.mr_lock));
> @@ -768,29 +767,44 @@ xfs_reclaim_worker(
>  }
>  
>  static void
> -__xfs_inode_set_reclaim_tag(
> +xfs_perag_set_reclaim_tag(
>  	struct xfs_perag	*pag,
> -	struct xfs_inode	*ip)
> +	xfs_ino_t		ino)

No need to pass the inode number here. Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  {
> -	radix_tree_tag_set(&pag->pag_ici_root,
> -			   XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
> +	struct xfs_mount	*mp = pag->pag_mount;
> +
> +	ASSERT(spin_is_locked(&pag->pag_ici_lock));
> +	if (pag->pag_ici_reclaimable++)
> +		return;
> +
> +	/* propagate the reclaim tag up into the perag radix tree */
> +	spin_lock(&mp->m_perag_lock);
> +	radix_tree_tag_set(&mp->m_perag_tree, pag->pag_agno,
>  			   XFS_ICI_RECLAIM_TAG);
> +	spin_unlock(&mp->m_perag_lock);
>  
> -	if (!pag->pag_ici_reclaimable) {
> -		/* propagate the reclaim tag up into the perag radix tree */
> -		spin_lock(&ip->i_mount->m_perag_lock);
> -		radix_tree_tag_set(&ip->i_mount->m_perag_tree,
> -				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
> -				XFS_ICI_RECLAIM_TAG);
> -		spin_unlock(&ip->i_mount->m_perag_lock);
> +	/* schedule periodic background inode reclaim */
> +	xfs_reclaim_work_queue(mp);
>  
> -		/* schedule periodic background inode reclaim */
> -		xfs_reclaim_work_queue(ip->i_mount);
> +	trace_xfs_perag_set_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
> +}
>  
> -		trace_xfs_perag_set_reclaim(ip->i_mount, pag->pag_agno,
> -							-1, _RET_IP_);
> -	}
> -	pag->pag_ici_reclaimable++;
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
>  }
>  
>  /*
> @@ -800,48 +814,35 @@ __xfs_inode_set_reclaim_tag(
>   */
>  void
>  xfs_inode_set_reclaim_tag(
> -	xfs_inode_t	*ip)
> +	struct xfs_inode	*ip)
>  {
> -	struct xfs_mount *mp = ip->i_mount;
> -	struct xfs_perag *pag;
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_perag	*pag;
>  
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
>  	spin_lock(&pag->pag_ici_lock);
>  	spin_lock(&ip->i_flags_lock);
> -	__xfs_inode_set_reclaim_tag(pag, ip);
> +
> +	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
> +			   XFS_ICI_RECLAIM_TAG);
> +	xfs_perag_set_reclaim_tag(pag, ip->i_ino);
>  	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
> +
>  	spin_unlock(&ip->i_flags_lock);
>  	spin_unlock(&pag->pag_ici_lock);
>  	xfs_perag_put(pag);
>  }
>  
> -STATIC void
> -__xfs_inode_clear_reclaim(
> -	xfs_perag_t	*pag,
> -	xfs_inode_t	*ip)
> -{
> -	pag->pag_ici_reclaimable--;
> -	if (!pag->pag_ici_reclaimable) {
> -		/* clear the reclaim tag from the perag radix tree */
> -		spin_lock(&ip->i_mount->m_perag_lock);
> -		radix_tree_tag_clear(&ip->i_mount->m_perag_tree,
> -				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
> -				XFS_ICI_RECLAIM_TAG);
> -		spin_unlock(&ip->i_mount->m_perag_lock);
> -		trace_xfs_perag_clear_reclaim(ip->i_mount, pag->pag_agno,
> -							-1, _RET_IP_);
> -	}
> -}
>  
>  STATIC void
> -__xfs_inode_clear_reclaim_tag(
> -	xfs_mount_t	*mp,
> -	xfs_perag_t	*pag,
> -	xfs_inode_t	*ip)
> +xfs_inode_clear_reclaim_tag(
> +	struct xfs_perag	*pag,
> +	xfs_ino_t		ino)
>  {
>  	radix_tree_tag_clear(&pag->pag_ici_root,
> -			XFS_INO_TO_AGINO(mp, ip->i_ino), XFS_ICI_RECLAIM_TAG);
> -	__xfs_inode_clear_reclaim(pag, ip);
> +			     XFS_INO_TO_AGINO(pag->pag_mount, ino),
> +			     XFS_ICI_RECLAIM_TAG);
> +	xfs_perag_clear_reclaim_tag(pag);
>  }
>  
>  /*
> @@ -1032,7 +1033,7 @@ reclaim:
>  	if (!radix_tree_delete(&pag->pag_ici_root,
>  				XFS_INO_TO_AGINO(ip->i_mount, ino)))
>  		ASSERT(0);
> -	__xfs_inode_clear_reclaim(pag, ip);
> +	xfs_perag_clear_reclaim_tag(pag);
>  	spin_unlock(&pag->pag_ici_lock);
>  
>  	/*
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
