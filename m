Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55886 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfFYKjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:39:18 -0400
Date: Tue, 25 Jun 2019 03:39:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] xfs: account for log space when formatting new AGs
Message-ID: <20190625103917.GD30156@infradead.org>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
 <156114702648.1643538.14530619220062934565.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156114702648.1643538.14530619220062934565.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@sandeen.net, linux-xfs@vger.kernel.org, Allison Collins <allison.henderson@oracle.com>

On Fri, Jun 21, 2019 at 12:57:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're writing out a fresh new AG, make sure that we don't list an
> internal log as free and that we create the rmap for the region.  growfs
> never does this, but we will need it when we hook up mkfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  libxfs/xfs_ag.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
> 
> 
> diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
> index fe79693e..237d6c53 100644
> --- a/libxfs/xfs_ag.c
> +++ b/libxfs/xfs_ag.c
> @@ -11,6 +11,7 @@
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
> @@ -45,6 +46,12 @@ xfs_get_aghdr_buf(
>  	return bp;
>  }
>  
> +static inline bool is_log_ag(struct xfs_mount *mp, struct aghdr_init_data *id)
> +{
> +	return mp->m_sb.sb_logstart > 0 &&
> +	       id->agno == XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart);
> +}
> +
>  /*
>   * Generic btree root block init function
>   */
> @@ -65,11 +72,50 @@ xfs_freesp_init_recs(
>  	struct aghdr_init_data	*id)
>  {
>  	struct xfs_alloc_rec	*arec;
> +	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
>  
>  	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
>  	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
> +
> +	if (is_log_ag(mp, id)) {
> +		struct xfs_alloc_rec	*nrec;
> +		xfs_agblock_t		start = XFS_FSB_TO_AGBNO(mp,
> +							mp->m_sb.sb_logstart);

This new code is pretty self-contained, maybe it should move into
a separate helper?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
