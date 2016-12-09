Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23244 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932353AbcLIRc1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Dec 2016 12:32:27 -0500
Date: Fri, 9 Dec 2016 09:32:13 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH, RFC] xfs: take indirect blocks into accounting when
 selecting an AG
Message-ID: <20161209173213.GZ16813@birch.djwong.org>
References: <1481303709-12632-1-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1481303709-12632-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, eguan@redhat.com

On Fri, Dec 09, 2016 at 06:15:09PM +0100, Christoph Hellwig wrote:
> We need to make sure that the indirect blocks (e.g. bmap btree blocks)
> can be allocated from the same AG [1] when comitting to an AG for a
> file data block allocation.  To do that we calculate the worst possible
> indirect len and subtract that from the free space in the AG.
> 
> I don't really like how this makes the space allocator call back into
> the bmap code (even if only for a trivial helper), but I can't think
> of a better idea.
> 
> [1] strictly speaking the same AG or one with a higher AG number, but
> that is so incredibly hard to express that we settle for the same AG.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |  7 ++++++-
>  fs/xfs/libxfs/xfs_bmap.c  | 17 +++++++++++------
>  fs/xfs/libxfs/xfs_bmap.h  |  5 +++++
>  3 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index effb64c..037cbd8 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -38,6 +38,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
>  #include "xfs_ag_resv.h"
> +#include "xfs_bmap.h"
>  
>  struct workqueue_struct *xfs_alloc_wq;
>  
> @@ -2058,6 +2059,7 @@ xfs_alloc_space_available(
>  	struct xfs_perag	*pag = args->pag;
>  	xfs_extlen_t		longest;
>  	xfs_extlen_t		reservation; /* blocks that are still reserved */
> +	xfs_extlen_t		indlen = 0;
>  	int			available;
>  
>  	if (flags & XFS_ALLOC_FLAG_FREEING)
> @@ -2071,9 +2073,12 @@ xfs_alloc_space_available(
>  	if ((args->minlen + args->alignment + args->minalignslop - 1) > longest)
>  		return false;
>  
> +	if (xfs_alloc_is_userdata(args->datatype))
> +		indlen = __xfs_bmap_worst_indlen(args->mp, max(args->minlen, args->maxlen));

/me wonders, when is it the case that minlen > maxlen?

I'm also wondering why we can't just increase args->minleft to require
that we leave enough space in whichever AG we pick to expand to bmbt?
AFAICT that's the purpose of the minleft field.

(That said, I'd been working on a patch to do exactly this and it hasn't
solved the problem yet...)

It also would be useful to add a comment as to why we're doing this,
/* Make sure we leave enough space in this AG for a bmbt expansion. */

> +
>  	/* do we have enough free space remaining for the allocation? */
>  	available = (int)(pag->pagf_freeblks + pag->pagf_flcount -
> -			  reservation - min_free - args->total);
> +			  reservation - min_free - indlen - args->total);
>  	if (available < (int)args->minleft || available <= 0)
>  		return false;
>  
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 266f641..b52a32d 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -183,19 +183,16 @@ xfs_bmbt_update(
>   * Compute the worst-case number of indirect blocks that will be used
>   * for ip's delayed extent of length "len".
>   */
> -STATIC xfs_filblks_t
> -xfs_bmap_worst_indlen(
> -	xfs_inode_t	*ip,		/* incore inode pointer */
> +xfs_filblks_t
> +__xfs_bmap_worst_indlen(
> +	xfs_mount_t	*mp,		/* mount structure */

struct xfs_mount?

>  	xfs_filblks_t	len)		/* delayed extent length */
>  {
>  	int		level;		/* btree level number */
>  	int		maxrecs;	/* maximum record count at this level */
> -	xfs_mount_t	*mp;		/* mount structure */
>  	xfs_filblks_t	rval;		/* return value */
>  	xfs_filblks_t   orig_len;
>  
> -	mp = ip->i_mount;
> -
>  	/* Calculate the worst-case size of the bmbt. */
>  	orig_len = len;
>  	maxrecs = mp->m_bmap_dmxr[0];
> @@ -222,6 +219,14 @@ xfs_bmap_worst_indlen(
>  	return rval;
>  }
>  
> +STATIC xfs_filblks_t
> +xfs_bmap_worst_indlen(
> +	xfs_inode_t	*ip,		/* incore inode pointer */
> +	xfs_filblks_t	len)		/* delayed extent length */
> +{
> +	return __xfs_bmap_worst_indlen(ip->i_mount, len);
> +}
> +
>  /*
>   * Calculate the default attribute fork offset for newly created inodes.
>   */
> diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
> index cecd094..aa2964a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.h
> +++ b/fs/xfs/libxfs/xfs_bmap.h
> @@ -263,4 +263,9 @@ int	xfs_bmap_map_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
>  int	xfs_bmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
>  		struct xfs_inode *ip, struct xfs_bmbt_irec *imap);
>  
> +xfs_filblks_t
> +__xfs_bmap_worst_indlen(
> +	xfs_mount_t	*mp,		/* mount structure */

struct xfs_mount?

--D

> +	xfs_filblks_t	len);		/* delayed extent length */
> +
>  #endif	/* __XFS_BMAP_H__ */
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
