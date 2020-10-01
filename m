Return-Path: <SRS0=mWNF=DI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AFBC4727E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 17:32:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CF2E20897
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 17:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UWZUTb0X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732380AbgJARcc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 13:32:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732213AbgJARcc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 13:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601573550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FBPvz0FUO/kBaAnTzp5YF1qcaSOEUcUB8qAR+Wpsl3M=;
        b=UWZUTb0XHs5Po1HdnPF07vMtzql0UmXCL4QWLySUu4X1uhYE8cKgR+aB0JaVHWSxiJnNBI
        GcFQ2Thi+WLmR/6p2hhl/WIak910VgOVcCzfkGS5Z78HAW5IejKMQfIcV9Y83rleHi7eRn
        mX0uwGXAUfLdjHT1SFX1XMkqW8ST0xs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-254-m1f6xFa9PmKGlI5QJl-wEA-1; Thu, 01 Oct 2020 13:32:28 -0400
X-MC-Unique: m1f6xFa9PmKGlI5QJl-wEA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84BEE425D0;
        Thu,  1 Oct 2020 17:32:27 +0000 (UTC)
Received: from bfoster (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CE78160DA0;
        Thu,  1 Oct 2020 17:32:26 +0000 (UTC)
Date:   Thu, 1 Oct 2020 13:32:24 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 4/5] xfs: xfs_defer_capture should absorb remaining block
 reservation
Message-ID: <20201001173224.GF112884@bfoster>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
 <160140141814.830233.6669476190490393801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140141814.830233.6669476190490393801.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:43:38AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When xfs_defer_capture extracts the deferred ops and transaction state
> from a transaction, it should absorb the remaining block reservation so
> that when we continue the dfops chain, we still have those blocks to
> use.
> 
> This adds the requirement that every log intent item recovery function
> must be careful to reserve enough blocks to handle both itself and all
> defer ops that it can queue.  On the other hand, this enables us to do
> away with the handwaving block estimation nonsense that was going on in
> xlog_finish_defer_ops.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c |    5 +++++
>  fs/xfs/libxfs/xfs_defer.h |    1 +
>  fs/xfs/xfs_log_recover.c  |   18 +-----------------
>  3 files changed, 7 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 85c371d29e8d..0cceebb390c4 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -575,6 +575,10 @@ xfs_defer_ops_capture(
>  	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
>  	tp->t_flags &= ~XFS_TRANS_LOWMODE;
>  
> +	/* Capture the block reservation along with the dfops. */
> +	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
> +	tp->t_blk_res = tp->t_blk_res_used;
> +
>  	return dfc;
>  }
>  
> @@ -632,6 +636,7 @@ xfs_defer_ops_continue(
>  	/* Move captured dfops chain and state to the transaction. */
>  	list_splice_init(&dfc->dfc_dfops, &tp->t_dfops);
>  	tp->t_flags |= dfc->dfc_tpflags;
> +	tp->t_blk_res += dfc->dfc_blkres;
>  
>  	kmem_free(dfc);
>  }

Seems sane, but I'm curious why we need to modify the transactions
directly in both of these contexts. Rather than building up and holding
a growing block reservation across transactions during intent
processing, could we just sample the unused blocks in the transaction at
capture time and use that as a resblks parameter when we allocate the
transaction to continue the chain? Then we at least have some validation
via the traditional allocation path if we ever screw up the accounting..

Brian

> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 3af82ebc1249..b1c7b761afd5 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -75,6 +75,7 @@ struct xfs_defer_capture {
>  	/* Deferred ops state saved from the transaction. */
>  	struct list_head	dfc_dfops;
>  	unsigned int		dfc_tpflags;
> +	unsigned int		dfc_blkres;
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 550d0fa8057a..b06c9881a13d 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2439,26 +2439,10 @@ xlog_finish_defer_ops(
>  {
>  	struct xfs_defer_capture *dfc, *next;
>  	struct xfs_trans	*tp;
> -	int64_t			freeblks;
> -	uint64_t		resblks;
>  	int			error = 0;
>  
>  	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
> -		/*
> -		 * We're finishing the defer_ops that accumulated as a result
> -		 * of recovering unfinished intent items during log recovery.
> -		 * We reserve an itruncate transaction because it is the
> -		 * largest permanent transaction type.  Since we're the only
> -		 * user of the fs right now, take 93% (15/16) of the available
> -		 * free blocks.  Use weird math to avoid a 64-bit division.
> -		 */
> -		freeblks = percpu_counter_sum(&mp->m_fdblocks);
> -		if (freeblks <= 0)
> -			return -ENOSPC;
> -
> -		resblks = min_t(uint64_t, UINT_MAX, freeblks);
> -		resblks = (resblks * 15) >> 4;
> -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, resblks,
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0,
>  				0, XFS_TRANS_RESERVE, &tp);
>  		if (error)
>  			return error;
> 

