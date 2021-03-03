Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6061FC43603
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4231564F5C
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 00:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355019AbhCDASH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:18:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233583AbhCCSUV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Mar 2021 13:20:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0E4864EF1;
        Wed,  3 Mar 2021 18:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614795572;
        bh=MXba549wk/QGi4QAnGx/2OgXvtEfyHWIfQEz2WTG3xQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iCjEj68vQZNhj6WmXouuKpDV9+AW18oLtvrMIb4ZbgXsJzbm8dVWQf/S3ld4kf9RP
         4tIHf0lng/fWQzul1hlB2T2mDBfw242UTV+TMpKOlHDYxBCy/yOIxtseXYmkg8A+ut
         GGl8ezb/NZ2aR76X7cmBKGBUQsaviGU63O8dAWPzwGkTh4wuaTnHt6LRE89RSwAMGt
         dNhMmfgXdGEphHDVDm4E4TNM4UesnC3WKY8NSyLzrfOqnJcbM5CP2FeyYePugOFwd2
         NIeX8Ij02NELpGVSeNFBvRxUpQj13Kn4y9VnbDzP1KXJixLI033ev5fUOqB6bosyjn
         jF9O0xNFgJaYw==
Date:   Wed, 3 Mar 2021 10:19:31 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v7 3/5] xfs: introduce xfs_ag_shrink_space()
Message-ID: <20210303181931.GB3419940@magnolia>
References: <20210302024816.2525095-1-hsiangkao@redhat.com>
 <20210302024816.2525095-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302024816.2525095-4-hsiangkao@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 02, 2021 at 10:48:14AM +0800, Gao Xiang wrote:
> This patch introduces a helper to shrink unused space in the last AG
> by fixing up the freespace btree.
> 
> Also make sure that the per-AG reservation works under the new AG
> size. If such per-AG reservation or extent allocation fails, roll
> the transaction so the new transaction could cancel without any side
> effects.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.c | 108 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h |   2 +
>  2 files changed, 110 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 9331f3516afa..a1128814630a 100644
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
> @@ -485,6 +490,109 @@ xfs_ag_init_headers(
>  	return error;
>  }
>  
> +int
> +xfs_ag_shrink_space(
> +	struct xfs_mount	*mp,
> +	struct xfs_trans	**tpp,
> +	xfs_agnumber_t		agno,
> +	xfs_extlen_t		len)
> +{
> +	struct xfs_alloc_arg	args = {
> +		.tp	= *tpp,
> +		.mp	= mp,
> +		.type	= XFS_ALLOCTYPE_THIS_BNO,
> +		.minlen = len,
> +		.maxlen = len,
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
> +	args.fsbno = XFS_AGB_TO_FSB(mp, agno,
> +				    be32_to_cpu(agi->agi_length) - len);

Paranoia nit: Should we check that len < agi_length?

> +
> +	/* remove the preallocations before allocation and re-establish then */
> +	error = xfs_ag_resv_free(agibp->b_pag);
> +	if (error)
> +		return error;
> +
> +	/* internal log shouldn't also show up in the free space btrees */
> +	error = xfs_alloc_vextent(&args);

I forget, does xfs_alloc_vextent ever roll args.tp?

Other than those two things this looks good to me.

--D

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
> +	be32_add_cpu(&agi->agi_length, -len);
> +	be32_add_cpu(&agf->agf_length, -len);
> +
> +	err2 = xfs_ag_resv_init(agibp->b_pag, *tpp);
> +	if (err2) {
> +		be32_add_cpu(&agi->agi_length, len);
> +		be32_add_cpu(&agf->agf_length, len);
> +		if (err2 != -ENOSPC)
> +			goto resv_err;
> +
> +		__xfs_bmap_add_free(*tpp, args.fsbno, len, NULL, true);
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
> index 5166322807e7..f33388eb130a 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -24,6 +24,8 @@ struct aghdr_init_data {
>  };
>  
>  int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
> +int xfs_ag_shrink_space(struct xfs_mount *mp, struct xfs_trans **tpp,
> +			xfs_agnumber_t agno, xfs_extlen_t len);
>  int xfs_ag_extend_space(struct xfs_mount *mp, struct xfs_trans *tp,
>  			struct aghdr_init_data *id, xfs_extlen_t len);
>  int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
> -- 
> 2.27.0
> 
