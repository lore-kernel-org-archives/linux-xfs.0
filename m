Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4CCC47082
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 12:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FBEE61378
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 12:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbhEZMf3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 May 2021 08:35:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233220AbhEZMf3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 May 2021 08:35:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622032437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7UBdPDCHkBIC0lTlay783Y//y4vPox7YVCuxlDTn9tM=;
        b=ZtR8tgrSv+RZ4SlgNjWoDhVRsPZKq9sPSFZyFYny3W/mHsWIlJ6HeVbTAXeX09YmLzYhhA
        zd/qoTP18sH/SNUZyAUAytnZbuRB8/DzMP6SSIUX4KWM9ARZDOvjSF03FEoTxUWlJy5y32
        bhLFb9wm2LzNGgTm85lfXK6+FEG5WXQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-vSstV3lEMueOP3v2nyGyUQ-1; Wed, 26 May 2021 08:33:55 -0400
X-MC-Unique: vSstV3lEMueOP3v2nyGyUQ-1
Received: by mail-qt1-f199.google.com with SMTP id u18-20020a05622a14d2b029022c2829ba03so573396qtx.13
        for <linux-xfs@vger.kernel.org>; Wed, 26 May 2021 05:33:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7UBdPDCHkBIC0lTlay783Y//y4vPox7YVCuxlDTn9tM=;
        b=FH0PCrcPYrOOOK951wJe0h0q36RFm/D+44QaLYp348GU6JHz3mEyTyVABaKhrynUjt
         d5wT305+BUOuKV/c4gHtLl0wTvuslqPYcgPhlIfAte4il9tWguXBbstMxiSyP6j3Z4/J
         GZnrmO7ozY+OpV5nrVdTDEyXXRIx8+4AFFIDt4aRRQ3pJmUKzUocbtyCwTZhPuzeQKwR
         j15OHDY371WoiDQmSY6xd/KpZA3L5uJYIpWcBAK978AlE5W305hjAl7oxRbe3PR4zuyq
         5WImVgAKF5lAYuDYuSoTxCrT7ySC3+8HpF+ftEP9pi4NAUneLVKCzXoDJEFHZlM3+hsk
         dPFw==
X-Gm-Message-State: AOAM5314mWxW2jL3/3Fi7pEEmWRPoFS8LaqHq0+QAUV8zIi51T7dk45u
        iY5vDxNpD/QM26C34DSkfrYM4MAoim58NsME7FRTBHukbDuUlIko2G3I+wiPgy8Q2eMhl8LSPvp
        silz/Q15T5MZIBsUayCvK
X-Received: by 2002:a05:6214:cc6:: with SMTP id 6mr42968583qvx.25.1622032434355;
        Wed, 26 May 2021 05:33:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxgWdWLie8vybw1OIMJ15CC1jwBsyzwNYtGacV3swTTAxEBRlWc057taG3/lm/O4o5hqO1cTQ==
X-Received: by 2002:a05:6214:cc6:: with SMTP id 6mr42968552qvx.25.1622032433959;
        Wed, 26 May 2021 05:33:53 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id d16sm1356234qtw.23.2021.05.26.05.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 05:33:53 -0700 (PDT)
Date:   Wed, 26 May 2021 08:33:51 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/23] xfs: make for_each_perag... a first class citizen
Message-ID: <YK5AL/Zd3dKgzgT6@bfoster>
References: <20210519012102.450926-1-david@fromorbit.com>
 <20210519012102.450926-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519012102.450926-5-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 11:20:43AM +1000, Dave Chinner wrote:
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

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag.h    | 17 +++++++++++++++++
>  fs/xfs/scrub/fscounters.c | 40 +++++++++++++++------------------------
>  fs/xfs/xfs_extent_busy.c  |  7 ++-----
>  fs/xfs/xfs_fsops.c        |  8 ++------
>  fs/xfs/xfs_health.c       |  4 +---
>  fs/xfs/xfs_icache.c       | 15 ++-------------
>  6 files changed, 39 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> index ec37f9d9f310..33783120263c 100644
> --- a/fs/xfs/libxfs/xfs_ag.h
> +++ b/fs/xfs/libxfs/xfs_ag.h
> @@ -114,6 +114,23 @@ struct xfs_perag *xfs_perag_get_tag(struct xfs_mount *, xfs_agnumber_t,
>  				   int tag);
>  void	xfs_perag_put(struct xfs_perag *pag);
>  
> +/*
> + * Perag iteration APIs
> + */
> +#define for_each_perag(mp, next_agno, pag) \
> +	for ((next_agno) = 0, (pag) = xfs_perag_get((mp), 0); \
> +		(pag) != NULL; \
> +		(next_agno) = (pag)->pag_agno + 1, \
> +		xfs_perag_put(pag), \
> +		(pag) = xfs_perag_get((mp), (next_agno)))
> +
> +#define for_each_perag_tag(mp, next_agno, pag, tag) \
> +	for ((next_agno) = 0, (pag) = xfs_perag_get_tag((mp), 0, (tag)); \
> +		(pag) != NULL; \
> +		(next_agno) = (pag)->pag_agno + 1, \
> +		xfs_perag_put(pag), \
> +		(pag) = xfs_perag_get_tag((mp), (next_agno), (tag)))
> +
>  struct aghdr_init_data {
>  	/* per ag data */
>  	xfs_agblock_t		agno;		/* ag to init */
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 453ae9adf94c..fd7941e04ae1 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -71,11 +71,11 @@ xchk_fscount_warmup(
>  	xfs_agnumber_t		agno;
>  	int			error = 0;
>  
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		pag = xfs_perag_get(mp, agno);
> -
> +	for_each_perag(mp, agno, pag) {
> +		if (xchk_should_terminate(sc, &error))
> +			break;
>  		if (pag->pagi_init && pag->pagf_init)
> -			goto next_loop_perag;
> +			continue;
>  
>  		/* Lock both AG headers. */
>  		error = xfs_ialloc_read_agi(mp, sc->tp, agno, &agi_bp);
> @@ -89,21 +89,15 @@ xchk_fscount_warmup(
>  		 * These are supposed to be initialized by the header read
>  		 * function.
>  		 */
> -		error = -EFSCORRUPTED;
> -		if (!pag->pagi_init || !pag->pagf_init)
> +		if (!pag->pagi_init || !pag->pagf_init) {
> +			error = -EFSCORRUPTED;
>  			break;
> +		}
>  
>  		xfs_buf_relse(agf_bp);
>  		agf_bp = NULL;
>  		xfs_buf_relse(agi_bp);
>  		agi_bp = NULL;
> -next_loop_perag:
> -		xfs_perag_put(pag);
> -		pag = NULL;
> -		error = 0;
> -
> -		if (xchk_should_terminate(sc, &error))
> -			break;
>  	}
>  
>  	if (agf_bp)
> @@ -196,13 +190,14 @@ xchk_fscount_aggregate_agcounts(
>  	fsc->ifree = 0;
>  	fsc->fdblocks = 0;
>  
> -	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
> -		pag = xfs_perag_get(mp, agno);
> +	for_each_perag(mp, agno, pag) {
> +		if (xchk_should_terminate(sc, &error))
> +			break;
>  
>  		/* This somehow got unset since the warmup? */
>  		if (!pag->pagi_init || !pag->pagf_init) {
> -			xfs_perag_put(pag);
> -			return -EFSCORRUPTED;
> +			error = -EFSCORRUPTED;
> +			break;
>  		}
>  
>  		/* Count all the inodes */
> @@ -216,10 +211,8 @@ xchk_fscount_aggregate_agcounts(
>  			fsc->fdblocks += pag->pagf_btreeblks;
>  		} else {
>  			error = xchk_fscount_btreeblks(sc, fsc, agno);
> -			if (error) {
> -				xfs_perag_put(pag);
> +			if (error)
>  				break;
> -			}
>  		}
>  
>  		/*
> @@ -229,12 +222,9 @@ xchk_fscount_aggregate_agcounts(
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
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index cb037d7c72b2..422667e0668b 100644
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

