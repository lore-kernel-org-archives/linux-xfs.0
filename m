Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559B9C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 10:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D7F206CD
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 10:39:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P1FF9Je5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgJBKjp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Oct 2020 06:39:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59324 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725993AbgJBKjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Oct 2020 06:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601635183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JU8cecP5EBcaLsvpGH9pp7mjRBanLFXc5GwXdqfRNBk=;
        b=P1FF9Je50HEZnfYz3ToBuAvEzi9GTedME4trnaxZkvooFRNG6B+rSgi7auSCRIsumT0lfX
        9+ZH1eW2wQzlCrcBddVPpBs0tXb9vT7/6EdpIOp5Ro2n2F2Uqm0LrJmJoHUFIA9dCTFkda
        OkORq+Dqq1D1dTMGMkzZoi8CleLtSH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-4JEf6TFVPASmL80JCZ_pFQ-1; Fri, 02 Oct 2020 06:39:42 -0400
X-MC-Unique: 4JEf6TFVPASmL80JCZ_pFQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D03441084C85;
        Fri,  2 Oct 2020 10:39:40 +0000 (UTC)
Received: from bfoster (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4666073683;
        Fri,  2 Oct 2020 10:39:40 +0000 (UTC)
Date:   Fri, 2 Oct 2020 06:39:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v4.2 4/5] xfs: xfs_defer_capture should absorb remaining
 block reservation
Message-ID: <20201002103938.GA193265@bfoster>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
 <160140141814.830233.6669476190490393801.stgit@magnolia>
 <20201002042015.GT49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002042015.GT49547@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 09:20:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When xfs_defer_capture extracts the deferred ops and transaction state
> from a transaction, it should record the remaining block reservations so
> that when we continue the dfops chain, we can reserve the same number of
> blocks to use.  We capture the reservations for both data and realtime
> volumes.
> 
> This adds the requirement that every log intent item recovery function
> must be careful to reserve enough blocks to handle both itself and all
> defer ops that it can queue.  On the other hand, this enables us to do
> away with the handwaving block estimation nonsense that was going on in
> xlog_finish_defer_ops.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v4.2: don't fiddle with transaction internals, and save the rt
> reservation too
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_defer.c |    4 ++++
>  fs/xfs/libxfs/xfs_defer.h |    4 ++++
>  fs/xfs/xfs_log_recover.c  |   21 +++------------------
>  3 files changed, 11 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 85c371d29e8d..10aeae7353ab 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -575,6 +575,10 @@ xfs_defer_ops_capture(
>  	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
>  	tp->t_flags &= ~XFS_TRANS_LOWMODE;
>  
> +	/* Capture the remaining block reservations along with the dfops. */
> +	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
> +	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
> +
>  	return dfc;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> index 3af82ebc1249..5c0e59b69ffa 100644
> --- a/fs/xfs/libxfs/xfs_defer.h
> +++ b/fs/xfs/libxfs/xfs_defer.h
> @@ -75,6 +75,10 @@ struct xfs_defer_capture {
>  	/* Deferred ops state saved from the transaction. */
>  	struct list_head	dfc_dfops;
>  	unsigned int		dfc_tpflags;
> +
> +	/* Block reservations for the data and rt devices. */
> +	unsigned int		dfc_blkres;
> +	unsigned int		dfc_rtxres;
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 7804906d145b..1be5208e2a2f 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2439,27 +2439,12 @@ xlog_finish_defer_ops(
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
> -				0, XFS_TRANS_RESERVE, &tp);
> +		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
> +				dfc->dfc_blkres, dfc->dfc_rtxres,
> +				XFS_TRANS_RESERVE, &tp);
>  		if (error)
>  			return error;
>  
> 

