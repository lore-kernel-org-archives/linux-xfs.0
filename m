Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932646AbcI3Qqh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Sep 2016 12:46:37 -0400
Date: Fri, 30 Sep 2016 12:46:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 17/63] xfs: refcount btree requires more reserved space
Message-ID: <20160930164635.GB53197@bfoster.bfoster>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520484599.29434.5098069586045766209.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147520484599.29434.5098069586045766209.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org

(Dropping fsdevel CC from future replies to reduce review spam.)

On Thu, Sep 29, 2016 at 08:07:26PM -0700, Darrick J. Wong wrote:
> The reference count btree is allocated from the free space, which
> means that we have to ensure that an AG can't run out of free space
> while performing a refcount operation.  In the pathological case each
> AG block has its own refcntbt record, so we have to keep that much
> space available.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: Calculate the maximum possible size of the rmap and refcount
> btrees based on minimally-full btree blocks.  This increases the
> per-AG block reservations to handle the worst case btree size.
> ---

The code seems fine but I'm thrown off a bit by the commit log
description because the patch doesn't actually change behavior (wrt to
keeping space available for the refcountbt), but rather adds support
functions for such a mechanism to come (I presume).

Brian

>  fs/xfs/libxfs/xfs_alloc.c          |    3 +++
>  fs/xfs/libxfs/xfs_refcount_btree.c |   23 +++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_refcount_btree.h |    4 ++++
>  3 files changed, 30 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index be7e3fc..9d9a46e 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -38,6 +38,7 @@
>  #include "xfs_buf_item.h"
>  #include "xfs_log.h"
>  #include "xfs_ag_resv.h"
> +#include "xfs_refcount_btree.h"
>  
>  struct workqueue_struct *xfs_alloc_wq;
>  
> @@ -128,6 +129,8 @@ xfs_alloc_ag_max_usable(
>  		blocks++;		/* finobt root block */
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
>  		blocks++; 		/* rmap root block */
> +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> +		blocks++;		/* refcount root block */
>  
>  	return mp->m_sb.sb_agblocks - blocks;
>  }
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
> index 81d58b0..6b5e82b9 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.c
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.c
> @@ -387,3 +387,26 @@ xfs_refcountbt_compute_maxlevels(
>  	mp->m_refc_maxlevels = xfs_btree_compute_maxlevels(mp,
>  			mp->m_refc_mnr, mp->m_sb.sb_agblocks);
>  }
> +
> +/* Calculate the refcount btree size for some records. */
> +xfs_extlen_t
> +xfs_refcountbt_calc_size(
> +	struct xfs_mount	*mp,
> +	unsigned long long	len)
> +{
> +	return xfs_btree_calc_size(mp, mp->m_refc_mnr, len);
> +}
> +
> +/*
> + * Calculate the maximum refcount btree size.
> + */
> +xfs_extlen_t
> +xfs_refcountbt_max_size(
> +	struct xfs_mount	*mp)
> +{
> +	/* Bail out if we're uninitialized, which can happen in mkfs. */
> +	if (mp->m_refc_mxr[0] == 0)
> +		return 0;
> +
> +	return xfs_refcountbt_calc_size(mp, mp->m_sb.sb_agblocks);
> +}
> diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
> index 9e9ad7c..780b02f 100644
> --- a/fs/xfs/libxfs/xfs_refcount_btree.h
> +++ b/fs/xfs/libxfs/xfs_refcount_btree.h
> @@ -64,4 +64,8 @@ extern int xfs_refcountbt_maxrecs(struct xfs_mount *mp, int blocklen,
>  		bool leaf);
>  extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
>  
> +extern xfs_extlen_t xfs_refcountbt_calc_size(struct xfs_mount *mp,
> +		unsigned long long len);
> +extern xfs_extlen_t xfs_refcountbt_max_size(struct xfs_mount *mp);
> +
>  #endif	/* __XFS_REFCOUNT_BTREE_H__ */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
