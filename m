Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB5ACE92706
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Oct 2023 14:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbjJEO3l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Oct 2023 10:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234019AbjJEO1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Oct 2023 10:27:52 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FAD4680
        for <linux-xfs@vger.kernel.org>; Wed,  4 Oct 2023 21:53:14 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1c5c91bec75so3963755ad.3
        for <linux-xfs@vger.kernel.org>; Wed, 04 Oct 2023 21:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1696481594; x=1697086394; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IcJ87luw/5xOMK1QCEF7eS6PKJASzLgr7coVNaKvxTo=;
        b=dYNXxHpqtqwD9YONE2t/2ttUy7Ei2jVsFCiAKxUXp+IrNiOP3fgh/1ecf6p7FfFstV
         WzrthbZZQBTeMNKnbI6KkS2w9Y7RRXr5//X9k+srxKDfEWnAGqPU3dM5STOuT19MSyX0
         W2wDOdZUfQNGDTVLDQitN/ei0YwPlZCToS7tXimN5DsZDRraqbwsI5hhCOmkeYzi/Y5t
         8JnJg3WqfWASCpFHI1wEA2xAM2n9X5PUrD9t1E245XXW4+POaozyvpswbX6xRB/iiWLt
         Bg/dccZXKCvCJuN4msWAVdJcQqbr99tgCdcKruXbSo+ip12t7+8irI3LDjvWn2THKUPe
         iTQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696481594; x=1697086394;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcJ87luw/5xOMK1QCEF7eS6PKJASzLgr7coVNaKvxTo=;
        b=kraY/DS0/yqqjiGQxawEYRF6N0pb6hQt56bZhDJm0uL/60oGL4ugM3S6sRpI7Gt0P8
         bq4kFCfFJ7KVqiaEV8eyTmn1aRDV4YfRXBALetSaqIBVV0iHze5qduwS5Dy3UO0mbLzH
         OMRnvVCOMKHsBt7DPSC+Yw3h8ZyPpmd9EH5ulH2Teog70Gy1+OCfCgpDzfmd+OsICGnn
         xIlHVGJzdnWKSnHqQ/eooFIU8qWgJnVHDa414WKH2/2e8iQ3Hodo28FUkAMdJBnO6dMN
         ktaHdxAkgIYhMpaL7EaLU9+2lJsqH8vNtyCzUdO69Y8rnYPtgHj++Po+5jLUohpp4zPG
         Yj/A==
X-Gm-Message-State: AOJu0YxlPXWtdoOeM/KkP5DrlNCGLQBUbCPd+ayazIjE5AL/zUZnBH+J
        OABYBBz0IYHBgL5w3+fMG16j7bFqlq4ybll4sP4=
X-Google-Smtp-Source: AGHT+IGLY+V9tHe+/9HZw4ACvnf8E8a5Tf+qVHdgvafjb8WybXCQBsCZS1Or6X3WcLbLYvJiID409w==
X-Received: by 2002:a17:902:eb45:b0:1bc:506a:58f2 with SMTP id i5-20020a170902eb4500b001bc506a58f2mr1750396pli.46.1696481594325;
        Wed, 04 Oct 2023 21:53:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c20d00b001b53c8659fesm498352pll.30.2023.10.04.21.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Oct 2023 21:53:13 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qoGMI-009dgG-39;
        Thu, 05 Oct 2023 15:53:11 +1100
Date:   Thu, 5 Oct 2023 15:53:10 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: implement block reservation accounting for
 btrees we're staging
Message-ID: <ZR5BNt6BfBcpp1c+@dread.disaster.area>
References: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
 <169577059224.3312911.3596538645136769266.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169577059224.3312911.3596538645136769266.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 04:32:25PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a new xrep_newbt structure to encapsulate a fake root for
> creating a staged btree cursor as well as to track all the blocks that
> we need to reserve in order to build that btree.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/Makefile                   |    1 
>  fs/xfs/libxfs/xfs_btree_staging.h |    7 -
>  fs/xfs/scrub/agheader_repair.c    |    1 
>  fs/xfs/scrub/common.c             |    1 
>  fs/xfs/scrub/newbt.c              |  492 +++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/newbt.h              |   62 +++++
>  fs/xfs/scrub/scrub.c              |    2 
>  fs/xfs/scrub/trace.h              |   37 +++
>  8 files changed, 598 insertions(+), 5 deletions(-)
>  create mode 100644 fs/xfs/scrub/newbt.c
>  create mode 100644 fs/xfs/scrub/newbt.h

Looks reasonable to me. It all makes sense and nothing is obviously
wrong.

Reviewed-by: Dave Chinner <dchinner@redhat.com>


Some notes on the extent allocation API bits - the rework of the
high level allocation primitives I just posted intersects with this
code in some interesting ways....

> +
> +/* Allocate disk space for a new per-AG btree. */
> +STATIC int
> +xrep_newbt_alloc_ag_blocks(
> +	struct xrep_newbt	*xnr,
> +	uint64_t		nr_blocks)
> +{
> +	struct xfs_scrub	*sc = xnr->sc;
> +	struct xfs_mount	*mp = sc->mp;
> +	int			error = 0;
> +
> +	ASSERT(sc->sa.pag != NULL);
> +
> +	while (nr_blocks > 0) {
> +		struct xfs_alloc_arg	args = {
> +			.tp		= sc->tp,
> +			.mp		= mp,
> +			.oinfo		= xnr->oinfo,
> +			.minlen		= 1,
> +			.maxlen		= nr_blocks,
> +			.prod		= 1,
> +			.resv		= xnr->resv,
> +		};
> +		xfs_agnumber_t		agno;
> +
> +		xrep_newbt_validate_ag_alloc_hint(xnr);
> +
> +		error = xfs_alloc_vextent_near_bno(&args, xnr->alloc_hint);

This would require a perag to be held by the caller (sc->sa.pag)
and attached to the args. The target also changes to an agbno
(IIRC).

> +		if (error)
> +			return error;
> +		if (args.fsbno == NULLFSBLOCK)
> +			return -ENOSPC;

This will need to change to handling ENOSPC as the error directly on
failure.

> +
> +		agno = XFS_FSB_TO_AGNO(mp, args.fsbno);
> +
> +		trace_xrep_newbt_alloc_ag_blocks(mp, agno,
> +				XFS_FSB_TO_AGBNO(mp, args.fsbno), args.len,
> +				xnr->oinfo.oi_owner);
> +
> +		if (agno != sc->sa.pag->pag_agno) {
> +			ASSERT(agno == sc->sa.pag->pag_agno);
> +			return -EFSCORRUPTED;
> +		}

This can go away, because it simply isn't possible - it will
allocate a block in sc->sa.pag or fail with ENOSPC.

Hence this will probably simplify down a bit.

> +
> +		error = xrep_newbt_add_blocks(xnr, sc->sa.pag, &args);
> +		if (error)
> +			return error;
> +
> +		nr_blocks -= args.len;
> +		xnr->alloc_hint = args.fsbno + args.len;
> +
> +		error = xrep_defer_finish(sc);
> +		if (error)
> +			return error;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Don't let our allocation hint take us beyond EOFS */
> +static inline void
> +xrep_newbt_validate_file_alloc_hint(
> +	struct xrep_newbt	*xnr)
> +{
> +	struct xfs_scrub	*sc = xnr->sc;
> +
> +	if (xfs_verify_fsbno(sc->mp, xnr->alloc_hint))
> +		return;
> +
> +	xnr->alloc_hint = XFS_AGB_TO_FSB(sc->mp, 0, XFS_AGFL_BLOCK(sc->mp) + 1);
> +}
> +
> +/* Allocate disk space for our new file-based btree. */
> +STATIC int
> +xrep_newbt_alloc_file_blocks(
> +	struct xrep_newbt	*xnr,
> +	uint64_t		nr_blocks)
> +{
> +	struct xfs_scrub	*sc = xnr->sc;
> +	struct xfs_mount	*mp = sc->mp;
> +	int			error = 0;
> +
> +	while (nr_blocks > 0) {
> +		struct xfs_alloc_arg	args = {
> +			.tp		= sc->tp,
> +			.mp		= mp,
> +			.oinfo		= xnr->oinfo,
> +			.minlen		= 1,
> +			.maxlen		= nr_blocks,
> +			.prod		= 1,
> +			.resv		= xnr->resv,
> +		};
> +		struct xfs_perag	*pag;
> +		xfs_agnumber_t		agno;
> +
> +		xrep_newbt_validate_file_alloc_hint(xnr);
> +
> +		error = xfs_alloc_vextent_start_ag(&args, xnr->alloc_hint);
> +		if (error)
> +			return error;
> +		if (args.fsbno == NULLFSBLOCK)
> +			return -ENOSPC;

Similar target/errno changes will be needed here, and ....
> +
> +		agno = XFS_FSB_TO_AGNO(mp, args.fsbno);
> +
> +		trace_xrep_newbt_alloc_file_blocks(mp, agno,
> +				XFS_FSB_TO_AGBNO(mp, args.fsbno), args.len,
> +				xnr->oinfo.oi_owner);
> +
> +		pag = xfs_perag_get(mp, agno);
> +		if (!pag) {
> +			ASSERT(0);
> +			return -EFSCORRUPTED;
> +		}
> +
> +		error = xrep_newbt_add_blocks(xnr, pag, &args);
> +		xfs_perag_put(pag);
> +		if (error)
> +			return error;

I suspect it might be useful to have xfs_alloc_vextent_start_ag() be
able to return the referenced perag that the allocation occurred in
rather than having to split the result and look it up again....

Hust a heads up for now, thought, we can deal with these issues when
merging for one or the other happens...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
