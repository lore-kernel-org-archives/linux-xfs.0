Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 499577CA4
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 07:38:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0487130405F
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 05:38:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CZb9Wz2kGacAUlT6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 05:38:11 -0700 (PDT)
Date: Thu, 25 Aug 2016 08:38:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: make xfs_inode_set_eofblocks_tag cheaper for
	the common case
Message-ID: <20160825123808.GC25041@bfoster.bfoster>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
	<1471816273-28940-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1471816273-28940-4-git-send-email-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, Aug 21, 2016 at 11:51:12PM +0200, Christoph Hellwig wrote:
> For long growing file writes we will usually already have the eofblocks
> tag set when adding more speculative preallocations.  Add a flag in the
> inode to allow us to skip the the fairly expensive AG-wide spinlocks
> and multiple radix tree operations in that case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_icache.c | 14 ++++++++++++++
>  fs/xfs/xfs_inode.h  |  1 +
>  2 files changed, 15 insertions(+)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index fb39a66..65b2e3f 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1414,6 +1414,16 @@ xfs_inode_set_eofblocks_tag(
>  	struct xfs_perag *pag;
>  	int tagged;
>  
> +	/*
> +	 * Don't bother locking the AG and looking up in the radix trees
> +	 * if we already know that we have the tag set.
> +	 */
> +	if (ip->i_flags & XFS_IEOFBLOCKS)
> +		return;
> +	spin_lock(&ip->i_flags_lock);
> +	ip->i_flags |= XFS_IEOFBLOCKS;
> +	spin_unlock(&ip->i_flags_lock);
> +

I'm guessing the lockless check is intentional, but is that really
necessary? E.g., it doesn't seem like using ->i_flags_lock
unconditionally should affect performance in the way the AG lock or
radix tree work does, particularly since we're already holding
IOLOCK_EXCL in the current implementation. I could be wrong, but FWIW,
we do already have xfs_iflags_test_and_set() sitting around as well...

Brian

>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
>  	spin_lock(&pag->pag_ici_lock);
>  	trace_xfs_inode_set_eofblocks_tag(ip);
> @@ -1449,6 +1459,10 @@ xfs_inode_clear_eofblocks_tag(
>  	struct xfs_mount *mp = ip->i_mount;
>  	struct xfs_perag *pag;
>  
> +	spin_lock(&ip->i_flags_lock);
> +	ip->i_flags &= ~XFS_IEOFBLOCKS;
> +	spin_unlock(&ip->i_flags_lock);
> +
>  	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
>  	spin_lock(&pag->pag_ici_lock);
>  	trace_xfs_inode_clear_eofblocks_tag(ip);
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index e1a411e..8f30d25 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -216,6 +216,7 @@ xfs_get_initial_prid(struct xfs_inode *dp)
>  #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
>  #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
>  #define XFS_IDONTCACHE		(1 << 9) /* don't cache the inode long term */
> +#define XFS_IEOFBLOCKS		(1 << 10)/* has the preallocblocks tag set */
>  
>  /*
>   * Per-lifetime flags need to be reset when re-using a reclaimable inode during
> -- 
> 2.1.4
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
