Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA74C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 22:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66B796101D
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 22:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhJNW4z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 18:56:55 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:32960 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230512AbhJNW4z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 18:56:55 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 42C838875F5;
        Fri, 15 Oct 2021 09:54:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mb9cd-006JLR-Ja; Fri, 15 Oct 2021 09:54:47 +1100
Date:   Fri, 15 Oct 2021 09:54:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 12/17] xfs: compute maximum AG btree height for critical
 reservation calculation
Message-ID: <20211014225447.GR2361455@dread.disaster.area>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424268093.756780.1167437160420772989.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163424268093.756780.1167437160420772989.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6168b538
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=IRszdm1-7DIaDo1JLgsA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 01:18:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Compute the actual maximum AG btree height for deciding if a per-AG
> block reservation is critically low.  This only affects the sanity check
> condition, since we /generally/ will trigger on the 10% threshold.  This
> is a long-winded way of saying that we're removing one more usage of
> XFS_BTREE_MAXLEVELS.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.c |    3 ++-
>  fs/xfs/xfs_mount.c          |   14 ++++++++++++++
>  fs/xfs/xfs_mount.h          |    1 +
>  3 files changed, 17 insertions(+), 1 deletion(-)

One minor nit below, otherwise it looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 2aa2b3484c28..fe94058d4e9e 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -91,7 +91,8 @@ xfs_ag_resv_critical(
>  	trace_xfs_ag_resv_critical(pag, type, avail);
>  
>  	/* Critically low if less than 10% or max btree height remains. */
> -	return XFS_TEST_ERROR(avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS,
> +	return XFS_TEST_ERROR(avail < orig / 10 ||
> +			      avail < pag->pag_mount->m_agbtree_maxlevels,
>  			pag->pag_mount, XFS_ERRTAG_AG_RESV_CRITICAL);
>  }
>  
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 06dac09eddbd..5be1dd63fac5 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -567,6 +567,18 @@ xfs_mount_setup_inode_geom(
>  	xfs_ialloc_setup_geometry(mp);
>  }
>  
> +/* Compute maximum possible height for per-AG btree types for this fs. */
> +static inline void
> +xfs_agbtree_compute_maxlevels(
> +	struct xfs_mount	*mp)
> +{
> +	unsigned int		ret;
> +
> +	ret = max(mp->m_alloc_maxlevels, M_IGEO(mp)->inobt_maxlevels);
> +	ret = max(ret, mp->m_rmap_maxlevels);
> +	mp->m_agbtree_maxlevels = max(ret, mp->m_refc_maxlevels);
> +}

"ret" should really be named "levels" here because it's not a return
value anymore...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
