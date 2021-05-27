Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76908C47089
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 22:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 468D76113B
	for <linux-xfs@archiver.kernel.org>; Thu, 27 May 2021 22:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbhE0WLn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 May 2021 18:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233563AbhE0WLm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 18:11:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FD126113B;
        Thu, 27 May 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622153409;
        bh=PvE2wsYqamg1Iy3FWe5ernKwZLFWjZXX6/mxeR8fcik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uTBVe6ci89UXxe90BmXRjbsfruAy3fhhCP+nmA8Ybe7LHtSefThQ6dt8+6x26YPbQ
         iHjGzVTzB1Yh5/mMg2WLrC7KHXdUBwEq6WecfcJn/2gV0Ea1c9g7ZAGe/LUKlNJitb
         g1MhqL6smHgsqtLlPlGUirWba2XvPxsguMsrc+AD4KZvpT6VGwQmBVjdSmkrqjxA0G
         +Zsu32ekuh5XPpebLeVG9GtF0izU26TScibUPtSv8zwOkdBg1p8jOzz8hOusmBzOJe
         9GgE3xFWgpN7jTRlxF03lrxXV6MKKaTsRRaJnOHnX0462VlG0j9QfYdFZPBuy8xPps
         mu0NOZDYegZZg==
Date:   Thu, 27 May 2021 15:10:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/23] xfs: make for_each_perag... a first class citizen
Message-ID: <20210527221008.GT2402049@locust>
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

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
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
