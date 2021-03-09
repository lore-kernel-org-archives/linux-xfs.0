Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520BDC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 18:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 143CD652BE
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 18:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhCISGS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 13:06:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:57154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232082AbhCISFs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Mar 2021 13:05:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50EA7652B3;
        Tue,  9 Mar 2021 18:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615313148;
        bh=EBCmRuOnrU8WldmJhI+bCpABoV0VcAlKywl6PMJwlSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MLYxEEZG0DHoqymZ4fU5Jdj2gRc/Z3TK61QD0CSRXcRQdRMFVjwLdbsZCDg4y79B8
         3bwPYS091zTZtjDc+tF5ZlBHMLcRm+eD1LPFIWL60lJjjg62UzuM4W5u9Jw/vD9I9f
         8wPSoy87EuoGLnKDYJrs5+L/P4dIcQRUQTNf+4OtS38stqbIa5gOdmwWBFwpHiwZIR
         WCiap6pCsO9VI3+YmjL/b10Zs64h+k3UafyCsXT3yxeKluV3scEsYxe6Szm0rkG8gr
         oMHkBKVlYr5i2dP4f7kHh5NME+lVQqy6Rdp/TSLn206B+km52y2FOUqfx1bZievBUy
         XD3Xt8P84N+8A==
Date:   Tue, 9 Mar 2021 10:05:47 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 3/5] xfs: introduce xfs_ag_shrink_space()
Message-ID: <20210309180547.GY3419940@magnolia>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305025703.3069469-4-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 10:57:01AM +0800, Gao Xiang wrote:
> This patch introduces a helper to shrink unused space in the last AG
> by fixing up the freespace btree.
> 
> Also make sure that the per-AG reservation works under the new AG
> size. If such per-AG reservation or extent allocation fails, roll
> the transaction so the new transaction could cancel without any side
> effects.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Looks fine, moving on to examining the fstests...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ag.c | 111 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h |   4 +-
>  2 files changed, 114 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 9331f3516afa..1f6f9e70e1cb 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -22,6 +22,11 @@
>  #include "xfs_ag.h"
>  #include "xfs_ag_resv.h"
>  #include "xfs_health.h"
> +#include "xfs_error.h"
> +#include "xfs_bmap.h"
> +#include "xfs_defer.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans.h"
>  
>  static int
>  xfs_get_aghdr_buf(
> @@ -485,6 +490,112 @@ xfs_ag_init_headers(
>  	return error;
>  }
>  
> +int
> +xfs_ag_shrink_space(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	**tpp,
> +	xfs_agnumber_t		agno,
> +	xfs_extlen_t		delta)
> +{
> +	struct xfs_alloc_arg	args = {
> +		.tp	= *tpp,
> +		.mp	= mp,
> +		.type	= XFS_ALLOCTYPE_THIS_BNO,
> +		.minlen = delta,
> +		.maxlen = delta,
> +		.oinfo	= XFS_RMAP_OINFO_SKIP_UPDATE,
> +		.resv	= XFS_AG_RESV_NONE,
> +		.prod	= 1
> +	};
> +	struct xfs_buf		*agibp, *agfbp;
> +	struct xfs_agi		*agi;
> +	struct xfs_agf		*agf;
> +	int			error, err2;
> +
> +	ASSERT(agno == mp->m_sb.sb_agcount - 1);
> +	error = xfs_ialloc_read_agi(mp, *tpp, agno, &agibp);
> +	if (error)
> +		return error;
> +
> +	agi = agibp->b_addr;
> +
> +	error = xfs_alloc_read_agf(mp, *tpp, agno, 0, &agfbp);
> +	if (error)
> +		return error;
> +
> +	agf = agfbp->b_addr;
> +	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length))
> +		return -EFSCORRUPTED;
> +
> +	if (delta >= agi->agi_length)
> +		return -EINVAL;
> +
> +	args.fsbno = XFS_AGB_TO_FSB(mp, agno,
> +				    be32_to_cpu(agi->agi_length) - delta);
> +
> +	/* remove the preallocations before allocation and re-establish then */
> +	error = xfs_ag_resv_free(agibp->b_pag);
> +	if (error)
> +		return error;
> +
> +	/* internal log shouldn't also show up in the free space btrees */
> +	error = xfs_alloc_vextent(&args);
> +	if (!error && args.agbno == NULLAGBLOCK)
> +		error = -ENOSPC;
> +
> +	if (error) {
> +		/*
> +		 * if extent allocation fails, need to roll the transaction to
> +		 * ensure that the AGFL fixup has been committed anyway.
> +		 */
> +		err2 = xfs_trans_roll(tpp);
> +		if (err2)
> +			return err2;
> +		goto resv_init_out;
> +	}
> +
> +	/*
> +	 * if successfully deleted from freespace btrees, need to confirm
> +	 * per-AG reservation works as expected.
> +	 */
> +	be32_add_cpu(&agi->agi_length, -delta);
> +	be32_add_cpu(&agf->agf_length, -delta);
> +
> +	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
> +	if (err2) {
> +		be32_add_cpu(&agi->agi_length, delta);
> +		be32_add_cpu(&agf->agf_length, delta);
> +		if (err2 != -ENOSPC)
> +			goto resv_err;
> +
> +		__xfs_bmap_add_free(*tpp, args.fsbno, delta, NULL, true);
> +
> +		/*
> +		 * Roll the transaction before trying to re-init the per-ag
> +		 * reservation. The new transaction is clean so it will cancel
> +		 * without any side effects.
> +		 */
> +		error = xfs_defer_finish(tpp);
> +		if (error)
> +			return error;
> +
> +		error = -ENOSPC;
> +		goto resv_init_out;
> +	}
> +	xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);
> +	xfs_alloc_log_agf(*tpp, agfbp, XFS_AGF_LENGTH);
> +	return 0;
> +
> +resv_init_out:
> +	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
> +	if (!err2)
> +		return error;
> +resv_err:
> +	xfs_warn(mp, "Error %d reserving per-AG metadata reserve pool.", err2);
> +	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +	return err2;
> +}
> +
>  /*
>   * Extent the AG indicated by the @id by the length passed in
>   */
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index 5166322807e7..41293ebde8da 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -24,8 +24,10 @@ struct aghdr_init_data {
>  };
>  
>  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
> +int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans **tpp,
> +			xfs_agnumber_t agno, xfs_extlen_t len);
>  int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
> -			struct aghdr_init_data *id, xfs_extlen_t len);
> +			struct aghdr_init_data *id, xfs_extlen_t delta);
>  int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
>  			struct xfs_ag_geometry *ageo);
>  
> -- 
> 2.27.0
> 
