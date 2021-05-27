Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929E5C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 11:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 717B261248
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 11:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhE0LWM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 07:22:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48220 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229591AbhE0LWM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 07:22:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622114439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/FTZ+scbVLXU5z5e1I+bSGMayDJIM7YYloWIy9qpv8k=;
        b=hRpHbk3JdadHgOtUeJCE0SRafGHqrSEk3iWEF74ugDcc2dEAHqiXsbytvTEAFNNyTFAsjW
        aEQR7IJ+OOZeLBl9cqWaFr9qnHZ9jLLFPse+5asf0Yn++nUim20dR03OnM+gcoN6Wp2gaN
        3KmiKXLLKH36PhKrkkmaoI21vCKv2JA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-nE4yuaYvMgmUwAR7Q2bTlg-1; Thu, 27 May 2021 07:20:37 -0400
X-MC-Unique: nE4yuaYvMgmUwAR7Q2bTlg-1
Received: by mail-qv1-f72.google.com with SMTP id h11-20020a0ceecb0000b0290211ed54e716so3682156qvs.9
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 04:20:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/FTZ+scbVLXU5z5e1I+bSGMayDJIM7YYloWIy9qpv8k=;
        b=R4izBSq6BUE8GHfm+Qe6JyJVbfWfpQFuqxNA6JqNP9Mi/bi5nI4TgqV2Ji/yoZkWuO
         3Tp+uxMnkm3HVwSoAtPYbM7IFLTCpEtIzEUfMQD7nxKvVF855F0nQp8SuC36JJJQGT5m
         VJVk0Q/ASDhcV7azhdhCIVGsezk+g8OFBB2w7n1xsVmcGSZxMoUvmXPMIag4pKP9YbiZ
         NgxlLanmlkHG2ZfDqYn9bPf3QmgZLzfnkLnvMKGLzAKHt25txQThwiIoliRrhjPnzqlV
         +I1QDn8N5GtXW42vROj/x4KqylraMwyH8ip7XcH4aHGiIRAqE2SkNw8HKHshgdZbdqLr
         g2Hg==
X-Gm-Message-State: AOAM530/9PBynkchhklf0bR8v37/CNkZ6Lw6tdFtN6iKZRL5jGZTgAD2
        lFk2jVnjMpUM/azu3Cx4S1HuPvPa3ts3kGmRvBiHgejA3Jk4zCSDPR6nznPKXD2Jj/iKBPYoEDe
        8BLYnVk2D/sy/PG5EUKGn
X-Received: by 2002:a0c:c184:: with SMTP id n4mr2717226qvh.36.1622114436751;
        Thu, 27 May 2021 04:20:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxuUSIGwa5ZPZSLwuR0WlRfW00n2MQWprQeBcwEWDQObEC96+5LzClQIt3/MMOwv/iJImigw==
X-Received: by 2002:a0c:c184:: with SMTP id n4mr2717212qvh.36.1622114436517;
        Thu, 27 May 2021 04:20:36 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id s24sm1089450qtx.94.2021.05.27.04.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 04:20:36 -0700 (PDT)
Date:   Thu, 27 May 2021 07:20:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/23] xfs: remove xfs_perag_t
Message-ID: <YK+AgoWIHH8QgDIs@bfoster>
References: <20210519012102.450926-1-david@fromorbit.com>
 <20210519012102.450926-24-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519012102.450926-24-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 11:21:02AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Almost unused, gets rid of another typedef.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag.c    | 24 +++++++++++-----------
>  fs/xfs/libxfs/xfs_ag.h    |  4 ++--
>  fs/xfs/libxfs/xfs_alloc.c | 42 +++++++++++++++++++--------------------
>  3 files changed, 35 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 0e0819f6fb89..29c42698aa90 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -104,19 +104,19 @@ xfs_perag_put(
>   */
>  int
>  xfs_initialize_perag_data(
> -	struct xfs_mount *mp,
> -	xfs_agnumber_t	agcount)
> +	struct xfs_mount	*mp,
> +	xfs_agnumber_t		agcount)
>  {
> -	xfs_agnumber_t	index;
> -	xfs_perag_t	*pag;
> -	xfs_sb_t	*sbp = &mp->m_sb;
> -	uint64_t	ifree = 0;
> -	uint64_t	ialloc = 0;
> -	uint64_t	bfree = 0;
> -	uint64_t	bfreelst = 0;
> -	uint64_t	btree = 0;
> -	uint64_t	fdblocks;
> -	int		error = 0;
> +	xfs_agnumber_t		index;
> +	struct xfs_perag	*pag;
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +	uint64_t		ifree = 0;
> +	uint64_t		ialloc = 0;
> +	uint64_t		bfree = 0;
> +	uint64_t		bfreelst = 0;
> +	uint64_t		btree = 0;
> +	uint64_t		fdblocks;
> +	int			error = 0;
>  
>  	for (index = 0; index < agcount; index++) {
>  		/*
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index bebbe1bfce27..39f6a0dc984a 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -29,7 +29,7 @@ struct xfs_ag_resv {
>   * Per-ag incore structure, copies of information in agf and agi, to improve the
>   * performance of allocation group selection.
>   */
> -typedef struct xfs_perag {
> +struct xfs_perag {
>  	struct xfs_mount *pag_mount;	/* owner filesystem */
>  	xfs_agnumber_t	pag_agno;	/* AG this structure belongs to */
>  	atomic_t	pag_ref;	/* perag reference count */
> @@ -102,7 +102,7 @@ typedef struct xfs_perag {
>  	 * or have some other means to control concurrency.
>  	 */
>  	struct rhashtable	pagi_unlinked_hash;
> -} xfs_perag_t;
> +};
>  
>  int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
>  			xfs_agnumber_t *maxagi);
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index f7864f33c1f0..00bb34251829 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -2694,21 +2694,21 @@ xfs_alloc_fix_freelist(
>   * Get a block from the freelist.
>   * Returns with the buffer for the block gotten.
>   */
> -int				/* error */
> +int
>  xfs_alloc_get_freelist(
> -	xfs_trans_t	*tp,	/* transaction pointer */
> -	struct xfs_buf	*agbp,	/* buffer containing the agf structure */
> -	xfs_agblock_t	*bnop,	/* block address retrieved from freelist */
> -	int		btreeblk) /* destination is a AGF btree */
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	xfs_agblock_t		*bnop,
> +	int			btreeblk)
>  {
> -	struct xfs_agf	*agf = agbp->b_addr;
> -	struct xfs_buf	*agflbp;/* buffer for a.g. freelist structure */
> -	xfs_agblock_t	bno;	/* block number returned */
> -	__be32		*agfl_bno;
> -	int		error;
> -	int		logflags;
> -	xfs_mount_t	*mp = tp->t_mountp;
> -	xfs_perag_t	*pag;	/* per allocation group data */
> +	struct xfs_agf		*agf = agbp->b_addr;
> +	struct xfs_buf		*agflbp;
> +	xfs_agblock_t		bno;
> +	__be32			*agfl_bno;
> +	int			error;
> +	int			logflags;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_perag	*pag;
>  
>  	/*
>  	 * Freelist is empty, give up.
> @@ -2818,20 +2818,20 @@ xfs_alloc_pagf_init(
>  /*
>   * Put the block on the freelist for the allocation group.
>   */
> -int					/* error */
> +int
>  xfs_alloc_put_freelist(
> -	xfs_trans_t		*tp,	/* transaction pointer */
> -	struct xfs_buf		*agbp,	/* buffer for a.g. freelist header */
> -	struct xfs_buf		*agflbp,/* buffer for a.g. free block array */
> -	xfs_agblock_t		bno,	/* block being freed */
> -	int			btreeblk) /* block came from a AGF btree */
> +	struct xfs_trans	*tp,
> +	struct xfs_buf		*agbp,
> +	struct xfs_buf		*agflbp,
> +	xfs_agblock_t		bno,
> +	int			btreeblk)
>  {
>  	struct xfs_mount	*mp = tp->t_mountp;
>  	struct xfs_agf		*agf = agbp->b_addr;
> -	__be32			*blockp;/* pointer to array entry */
> +	struct xfs_perag	*pag;
> +	__be32			*blockp;
>  	int			error;
>  	int			logflags;
> -	xfs_perag_t		*pag;	/* per allocation group data */
>  	__be32			*agfl_bno;
>  	int			startoff;
>  
> -- 
> 2.31.1
> 

