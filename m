Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBANm00t127599 for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 17:48:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D86321956578
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:48:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UDB1TKDmO3BgEuJp for
	<xfs@oss.sgi.com>; Thu, 10 Dec 2009 15:48:36 -0800 (PST)
Date: Thu, 10 Dec 2009 18:48:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] [XFS] Reference count per-ag structures
Message-ID: <20091210234836.GA4774@infradead.org>
References: <1259734299-20306-1-git-send-email-david@fromorbit.com>
	<1259734299-20306-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1259734299-20306-7-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Wed, Dec 02, 2009 at 05:11:39PM +1100, Dave Chinner wrote:
> Reference count the per-ag structures to ensure that we keep get/put
> pairs balanced. Assert that the reference counts are zero at unmount
> time to catch leaks. In future, reference counts will enable us to
> safely remove perag structures by allowing us to detect when they
> are no longer in use.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_ag.h    |    4 ++--
>  fs/xfs/xfs_alloc.c |    2 +-
>  fs/xfs/xfs_inode.c |    5 ++++-
>  fs/xfs/xfs_mount.c |    1 +
>  fs/xfs/xfs_mount.h |   11 +++++++++--
>  5 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ag.h b/fs/xfs/xfs_ag.h
> index a5d54bf..b384a3c 100644
> --- a/fs/xfs/xfs_ag.h
> +++ b/fs/xfs/xfs_ag.h

> index 2d076e2..d1349b1 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -2545,7 +2545,6 @@ xfs_alloc_vextent(
>  			}
>  			xfs_perag_put(args->pag);
>  		}
> -		xfs_perag_put(args->pag);
>  		if (bump_rotor || (type == XFS_ALLOCTYPE_ANY_AG)) {
>  			if (args->agno == sagno)
>  				mp->m_agfrotor = (mp->m_agfrotor + 1) %
> @@ -2571,6 +2570,7 @@ xfs_alloc_vextent(
>  			args->len);
>  #endif
>  	}
> +	xfs_perag_put(args->pag);
>  	return 0;
>  error0:
>  	xfs_perag_put(args->pag);

Should be folded into the earlier patches.
>
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 44a1168..e6c178e 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2729,7 +2729,7 @@ xfs_iflush_cluster(
>  	ilist_size = inodes_per_cluster * sizeof(xfs_inode_t *);
>  	ilist = kmem_alloc(ilist_size, KM_MAYFAIL|KM_NOFS);
>  	if (!ilist)
> -		return 0;
> +		goto out_put;
>  
>  	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
>  	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
> @@ -2798,6 +2798,8 @@ xfs_iflush_cluster(
>  out_free:
>  	read_unlock(&pag->pag_ici_lock);
>  	kmem_free(ilist);
> +out_put:
> +	xfs_perag_put(pag);
>  	return 0;
>  
>  
> @@ -2841,6 +2843,7 @@ cluster_corrupt_out:
>  	 */
>  	xfs_iflush_abort(iq);
>  	kmem_free(ilist);
> +	xfs_perag_put(pag);
>  	return XFS_ERROR(EFSCORRUPTED);

Same here.

>  static inline xfs_perag_t *
>  xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
> @@ -393,6 +393,12 @@ xfs_perag_get(struct xfs_mount *mp, xfs_agnumber_t agno)
>  
>  	spin_lock(&mp->m_perag_lock);
>  	pag = radix_tree_lookup(&mp->m_perag_tree, agno);
> +	if (pag) {
> +		ASSERT(atomic_read(&pag->pag_ref) >= 0);
> +		/* catch leaks in the positive direction during testing */
> +		ASSERT(atomic_read(&pag->pag_ref) < 1000);

Is there any good reason why we should not be able to hit this number?


Patch looks good, although I'm a bit worried about the performance
overhead.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
