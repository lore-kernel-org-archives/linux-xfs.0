Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0569C43460
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 13:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 992A36142D
	for <linux-xfs@archiver.kernel.org>; Mon, 10 May 2021 13:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236167AbhEJNlm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 May 2021 09:41:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26165 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349829AbhEJMzH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 May 2021 08:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620651242;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IdrZx4dbh+CvEWYBAqPvSTSFX5MFkY0m0fZoe4aZISw=;
        b=DsC+KGMat303pv8pVxFHz9ttwtMLJkitagPrn+ppXZmpSKVZDL633F6o6Mn7Aaxd+cIJOM
        znO3KrdFkJ8yY+hYGMqO1A2z+7XRAC14Gnx6XOnw0pa47GHodCG0kbFFE86oAcZ+jZf8xM
        Ma08OU3fGltneKr5cczrVHmkfmIMNLI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-n_6F34IYPgu-w4nFKjY-3w-1; Mon, 10 May 2021 08:53:58 -0400
X-MC-Unique: n_6F34IYPgu-w4nFKjY-3w-1
Received: by mail-qv1-f69.google.com with SMTP id t9-20020a0cde090000b02901c4c7ae0cceso12456001qvk.7
        for <linux-xfs@vger.kernel.org>; Mon, 10 May 2021 05:53:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IdrZx4dbh+CvEWYBAqPvSTSFX5MFkY0m0fZoe4aZISw=;
        b=BNWPwlwT/VW9uQ6yTnTR/2P5WsfpGQRGhRP85o3EAfXO4e6uK94b5dSDEha5CNONfX
         n8F+1bgfsLto3R0giRIsbcIJpjQhCcY97z3P8Kyusopt441vXcO/jbO+2wdebwpO+rDy
         5eUsZTMANG+zT5vjx/4sVOQ3OHdmsM9qoZEnjD3mIUXjEqwvLetIu4bRPAUMvcAmfu4g
         yCgkN35ddcfwziOfpDiKlPOe98OZsc5XJOa/QRcEJORi/c45lpOytcgMKoDd2aB6XwnS
         yy0Pfde1KGOcppwPIdd8btPGFIKx4fb9d9vP0MV9M1brygL1BXTSANpjQzLS+LQza5Ga
         wuwQ==
X-Gm-Message-State: AOAM532IEfCqyy4Bcz6YCD30icDKcaEcych/bWLv16zlxVxAjSGIT/hA
        BPebCRcM3uBvCUA6Zj/LyTTuEgPNQ8hYaqmAmvoiIrJRsbVeIH2p7l5jkDqx9tqnhT/Y1gQRXLL
        kLUwbCRr/HH32P83JXBjn
X-Received: by 2002:a05:620a:240c:: with SMTP id d12mr3284170qkn.190.1620651238265;
        Mon, 10 May 2021 05:53:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJybNVlMqzKgABUsbBJQ/mLoX04xKitjl6cZpo28E0GPz5RipJz7FGxnypcNyisT1486jNJ7Dw==
X-Received: by 2002:a05:620a:240c:: with SMTP id d12mr3284159qkn.190.1620651238033;
        Mon, 10 May 2021 05:53:58 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id m205sm4116946qke.2.2021.05.10.05.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 05:53:57 -0700 (PDT)
Date:   Mon, 10 May 2021 08:53:56 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/22] xfs: make for_each_perag... a first class citizen
Message-ID: <YJks5KC4l9N9/vIT@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:36PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> for_each_perag_tag() is defined in xfs_icache.c for local use.
> Promote this to xfs_ag.h and define equivalent iteration functions
> so that we can use them to iterate AGs instead to replace open coded
> perag walks and perag lookups.
> 
> We also convert as many of the straight forward open coded AG walks
> to use these iterators as possible. Anything that is not a direct
> conversion to an iterator is ignored and will be updated in future
> commits.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_ag.h    | 17 +++++++++++++++++
>  fs/xfs/scrub/fscounters.c | 36 ++++++++++++++----------------------
>  fs/xfs/xfs_extent_busy.c  |  7 ++-----
>  fs/xfs/xfs_fsops.c        |  8 ++------
>  fs/xfs/xfs_health.c       |  4 +---
>  fs/xfs/xfs_icache.c       | 15 ++-------------
>  6 files changed, 38 insertions(+), 49 deletions(-)
> 
...
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 453ae9adf94c..2dfdac566399 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
...
> @@ -229,12 +224,9 @@ xchk_fscount_aggregate_agcounts(
>  		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
>  		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
>  
> -		xfs_perag_put(pag);
> -
> -		if (xchk_should_terminate(sc, &error))
> -			break;
>  	}
> -
> +	if (pag)
> +		xfs_perag_put(pag);

It's not shown in the diff, but there is still an exit path out of the
above loop that calls xfs_perag_put(). The rest of the patch LGTM.

Brian

>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 184732aa8674..6af0b5a1c7b0 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -605,12 +605,11 @@ void
>  xfs_extent_busy_wait_all(
>  	struct xfs_mount	*mp)
>  {
> +	struct xfs_perag	*pag;
>  	DEFINE_WAIT		(wait);
>  	xfs_agnumber_t		agno;
>  
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		struct xfs_perag *pag = xfs_perag_get(mp, agno);
> -
> +	for_each_perag(mp, agno, pag) {
>  		do {
>  			prepare_to_wait(&pag->pagb_wait, &wait, TASK_KILLABLE);
>  			if  (RB_EMPTY_ROOT(&pag->pagb_tree))
> @@ -618,8 +617,6 @@ xfs_extent_busy_wait_all(
>  			schedule();
>  		} while (1);
>  		finish_wait(&pag->pagb_wait, &wait);
> -
> -		xfs_perag_put(pag);
>  	}
>  }
>  
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index be9cf88d2ad7..07c745cd483e 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -576,10 +576,8 @@ xfs_fs_reserve_ag_blocks(
>  	int			err2;
>  
>  	mp->m_finobt_nores = false;
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		pag = xfs_perag_get(mp, agno);
> +	for_each_perag(mp, agno, pag) {
>  		err2 = xfs_ag_resv_init(pag, NULL);
> -		xfs_perag_put(pag);
>  		if (err2 && !error)
>  			error = err2;
>  	}
> @@ -605,10 +603,8 @@ xfs_fs_unreserve_ag_blocks(
>  	int			error = 0;
>  	int			err2;
>  
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		pag = xfs_perag_get(mp, agno);
> +	for_each_perag(mp, agno, pag) {
>  		err2 = xfs_ag_resv_free(pag);
> -		xfs_perag_put(pag);
>  		if (err2 && !error)
>  			error = err2;
>  	}
> diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
> index b79475ea3dbd..5de3195f6cb2 100644
> --- a/fs/xfs/xfs_health.c
> +++ b/fs/xfs/xfs_health.c
> @@ -34,14 +34,12 @@ xfs_health_unmount(
>  		return;
>  
>  	/* Measure AG corruption levels. */
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		pag = xfs_perag_get(mp, agno);
> +	for_each_perag(mp, agno, pag) {
>  		xfs_ag_measure_sickness(pag, &sick, &checked);
>  		if (sick) {
>  			trace_xfs_ag_unfixed_corruption(mp, agno, sick);
>  			warn = true;
>  		}
> -		xfs_perag_put(pag);
>  	}
>  
>  	/* Measure realtime volume corruption levels. */
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 588ea2bf88bb..7dad83a6f586 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -1061,15 +1061,13 @@ xfs_reclaim_inodes_ag(
>  	int			*nr_to_scan)
>  {
>  	struct xfs_perag	*pag;
> -	xfs_agnumber_t		ag = 0;
> +	xfs_agnumber_t		agno;
>  
> -	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
> +	for_each_perag_tag(mp, agno, pag, XFS_ICI_RECLAIM_TAG) {
>  		unsigned long	first_index = 0;
>  		int		done = 0;
>  		int		nr_found = 0;
>  
> -		ag = pag->pag_agno + 1;
> -
>  		first_index = READ_ONCE(pag->pag_ici_reclaim_cursor);
>  		do {
>  			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
> @@ -1134,7 +1132,6 @@ xfs_reclaim_inodes_ag(
>  		if (done)
>  			first_index = 0;
>  		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
> -		xfs_perag_put(pag);
>  	}
>  }
>  
> @@ -1554,14 +1551,6 @@ xfs_inode_clear_cowblocks_tag(
>  	return xfs_blockgc_clear_iflag(ip, XFS_ICOWBLOCKS);
>  }
>  
> -#define for_each_perag_tag(mp, next_agno, pag, tag) \
> -	for ((next_agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
> -		(pag) != NULL; \
> -		(next_agno) = (pag)->pag_agno + 1, \
> -		xfs_perag_put(pag), \
> -		(pag) = xfs_perag_get_tag((mp), (next_agno), (tag)))
> -
> -
>  /* Disable post-EOF and CoW block auto-reclamation. */
>  void
>  xfs_blockgc_stop(
> -- 
> 2.31.1
> 

