Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7BBAC433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 11:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7787261992
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 11:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbhCVLag (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 07:30:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229874AbhCVLaS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Mar 2021 07:30:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616412617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HR54KAuvFBArRNlmxd0TxO+iiSn/pFXs7Gfos6I5COw=;
        b=bFHpcuC5kSqgtzZkkcIN1l4HghBNewZGbN0vpkkoDqknGX0RElZJrXn1UbEG+rbx6UJbyl
        8r7LEe4ypSFtiMLnDV+kWVjWi9RSLTAG+pe5DAojgvGhSgQqoJDh0MCGLgdo1DUj+GktNY
        aUFM9BiZdor1UpZRiy54tcH1uWW2hX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-oEcbRiNJPEGLeIpgNI7dPA-1; Mon, 22 Mar 2021 07:30:15 -0400
X-MC-Unique: oEcbRiNJPEGLeIpgNI7dPA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89C6A84BA41;
        Mon, 22 Mar 2021 11:30:14 +0000 (UTC)
Received: from bfoster (ovpn-112-29.rdu2.redhat.com [10.10.112.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1B1B6E6FB;
        Mon, 22 Mar 2021 11:30:05 +0000 (UTC)
Date:   Mon, 22 Mar 2021 07:30:03 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH v8 3/5] xfs: introduce xfs_ag_shrink_space()
Message-ID: <YFh/u86JO4Pzmk8i@bfoster>
References: <20210305025703.3069469-1-hsiangkao@redhat.com>
 <20210305025703.3069469-4-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305025703.3069469-4-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
> ---

Looks mostly good to me. Some nits..

>  fs/xfs/libxfs/xfs_ag.c | 111 +++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_ag.h |   4 +-
>  2 files changed, 114 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 9331f3516afa..1f6f9e70e1cb 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
...
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

Is this check here for a reason? It seems a bit random, so I wonder if
we should just leave the extra verification to buffer verifiers.

> +
> +	if (delta >= agi->agi_length)
> +		return -EINVAL;
> +
> +	args.fsbno = XFS_AGB_TO_FSB(mp, agno,
> +				    be32_to_cpu(agi->agi_length) - delta);
> +
> +	/* remove the preallocations before allocation and re-establish then */

The comment is a little confusing. Perhaps something like the following,
if accurate..?

/*
 * Disable perag reservations so it doesn't cause the allocation request
 * to fail. We'll reestablish reservation before we return.
 */

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

So if this fails and the transaction rolls, do we still hold the agi/agf
buffers here? If not, there might be a window of time where it's
possible for some other task to come in and alloc out of the AG without
the perag res being active.

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

This looks misplaced..?

Or maybe this is trying to make the APIs consistent, but the function
definition still uses len as well as the declaration for
_ag_shrink_space() (while the definition of that function uses delta).

FWIW, the name delta tends to suggest a signed value to me based on our
pattern of usage, whereas here it seems like these helpers always want a
positive value (i.e. a length).

Brian

>  int xfs_ag_get_geometry(struct xfs_mount *mp, xfs_agnumber_t agno,
>  			struct xfs_ag_geometry *ageo);
>  
> -- 
> 2.27.0
> 

