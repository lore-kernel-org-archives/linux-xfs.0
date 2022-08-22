Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7102CC28D13
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Aug 2022 19:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbiHVTC1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 15:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238061AbiHVTCI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 15:02:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1019E4E607
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 12:00:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FB12611A1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Aug 2022 19:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7042C433C1;
        Mon, 22 Aug 2022 19:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661194803;
        bh=Oi5PASLTxAQyyuwcoUrJjyouu0IfRLxkksc4Q9RmtZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gfada7UwfB3cJaUlJ7KaFGpEOhezRtUobs4/08HgK8NWREzkqWs3r5HN3pIMffoJ8
         xAQMuzt6CZ0juD+M0dh3Jhn+mLyJsaZZbCWLBtzW+M/PMaThTABKJTDAZIhw2lSZ0g
         syxmXnUyqU9w98zEJAZCkg2TmLmzvt+FQuXQ8yeUYO6s/mIW3aJs5elDk1ijs6qqZl
         a4/XoR7U10ziZME+u9SBid3Mj+f1P0PkgNCd/4rSaB6J7d1IZTqWhKljGikYM+Gg55
         IPuBRb7GD3uCZFZz9m5pGqr1TueJPUN2yOmK9+ksZ4TJnnGs9v0yO8omaAJJ37cxEh
         4yU0oHQfM4TZA==
Date:   Mon, 22 Aug 2022 12:00:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: background AIL push targets physical space, not
 grant space
Message-ID: <YwPSMwmcyAZfIe3M@magnolia>
References: <20220809230353.3353059-1-david@fromorbit.com>
 <20220809230353.3353059-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809230353.3353059-4-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 10, 2022 at 09:03:47AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently the AIL attempts to keep 25% of the "log space" free,
> where the current used space is tracked by the reserve grant head.
> That is, it tracks both physical space used plus the amount reserved
> by transactions in progress.
> 
> When we start tail pushing, we are trying to make space for new
> reservations by writing back older metadata and the log is generally
> physically full of dirty metadata, and reservations for modifications
> in flight take up whatever space the AIL can physically free up.
> 
> Hence we don't really need to take into account the reservation
> space that has been used - we just need to keep the log tail moving
> as fast as we can to free up space for more reservations to be made.
> We know exactly how much physical space the journal is consuming in
> the AIL (i.e. max LSN - min LSN) so we can base push thresholds
> directly on this state rather than have to look at grant head
> reservations to determine how much to physically push out of the
> log.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Makes sense, I think.  Though I was wondering about the last patch --
pushing the AIL until it's empty when a trans_alloc can't find grant
reservation could take a while on a slow storage.  Does this mean that
we're trading the incremental freeing-up of the existing code for
potentially higher transaction allocation latency in the hopes that more
threads can get reservation?  Or does the "keep the AIL going" bits make
up for that?

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_log_priv.h  | 18 ++++++++++++
>  fs/xfs/xfs_trans_ail.c | 67 +++++++++++++++++++-----------------------
>  2 files changed, 49 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 91a8c74f4626..9f8c601a302b 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -622,6 +622,24 @@ xlog_wait(
>  
>  int xlog_wait_on_iclog(struct xlog_in_core *iclog);
>  
> +/* Calculate the distance between two LSNs in bytes */
> +static inline uint64_t
> +xlog_lsn_sub(
> +	struct xlog	*log,
> +	xfs_lsn_t	high,
> +	xfs_lsn_t	low)
> +{
> +	uint32_t	hi_cycle = CYCLE_LSN(high);
> +	uint32_t	hi_block = BLOCK_LSN(high);
> +	uint32_t	lo_cycle = CYCLE_LSN(low);
> +	uint32_t	lo_block = BLOCK_LSN(low);
> +
> +	if (hi_cycle == lo_cycle)
> +	       return BBTOB(hi_block - lo_block);
> +	ASSERT((hi_cycle == lo_cycle + 1) || xlog_is_shutdown(log));
> +	return (uint64_t)log->l_logsize - BBTOB(lo_block - hi_block);
> +}
> +
>  /*
>   * The LSN is valid so long as it is behind the current LSN. If it isn't, this
>   * means that the next log record that includes this metadata could have a
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index 243d6b05e5a9..d3dcb4942d6a 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -398,52 +398,47 @@ xfsaild_push_item(
>  /*
>   * Compute the LSN that we'd need to push the log tail towards in order to have
>   * at least 25% of the log space free.  If the log free space already meets this
> - * threshold, this function returns NULLCOMMITLSN.
> + * threshold, this function returns the lowest LSN in the AIL to slowly keep
> + * writeback ticking over and the tail of the log moving forward.
>   */
>  xfs_lsn_t
>  __xfs_ail_push_target(
>  	struct xfs_ail		*ailp)
>  {
> -	struct xlog	*log = ailp->ail_log;
> -	xfs_lsn_t	threshold_lsn = 0;
> -	xfs_lsn_t	last_sync_lsn;
> -	int		free_blocks;
> -	int		free_bytes;
> -	int		threshold_block;
> -	int		threshold_cycle;
> -	int		free_threshold;
> -
> -	free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
> -	free_blocks = BTOBBT(free_bytes);
> +	struct xlog		*log = ailp->ail_log;
> +	struct xfs_log_item	*lip;
>  
> -	/*
> -	 * Set the threshold for the minimum number of free blocks in the
> -	 * log to the maximum of what the caller needs, one quarter of the
> -	 * log, and 256 blocks.
> -	 */
> -	free_threshold = log->l_logBBsize >> 2;
> -	if (free_blocks >= free_threshold)
> +	xfs_lsn_t	target_lsn = 0;
> +	xfs_lsn_t	max_lsn;
> +	xfs_lsn_t	min_lsn;
> +	int32_t		free_bytes;
> +	uint32_t	target_block;
> +	uint32_t	target_cycle;
> +
> +	lockdep_assert_held(&ailp->ail_lock);
> +
> +	lip = xfs_ail_max(ailp);
> +	if (!lip)
> +		return NULLCOMMITLSN;
> +	max_lsn = lip->li_lsn;
> +	min_lsn = __xfs_ail_min_lsn(ailp);
> +
> +	free_bytes = log->l_logsize - xlog_lsn_sub(log, max_lsn, min_lsn);
> +	if (free_bytes >= log->l_logsize >> 2)
>  		return NULLCOMMITLSN;
>  
> -	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
> -						&threshold_block);
> -	threshold_block += free_threshold;
> -	if (threshold_block >= log->l_logBBsize) {
> -		threshold_block -= log->l_logBBsize;
> -		threshold_cycle += 1;
> +	target_cycle = CYCLE_LSN(min_lsn);
> +	target_block = BLOCK_LSN(min_lsn) + (log->l_logBBsize >> 2);
> +	if (target_block >= log->l_logBBsize) {
> +		target_block -= log->l_logBBsize;
> +		target_cycle += 1;
>  	}
> -	threshold_lsn = xlog_assign_lsn(threshold_cycle,
> -					threshold_block);
> -	/*
> -	 * Don't pass in an lsn greater than the lsn of the last
> -	 * log record known to be on disk. Use a snapshot of the last sync lsn
> -	 * so that it doesn't change between the compare and the set.
> -	 */
> -	last_sync_lsn = atomic64_read(&log->l_last_sync_lsn);
> -	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
> -		threshold_lsn = last_sync_lsn;
> +	target_lsn = xlog_assign_lsn(target_cycle, target_block);
>  
> -	return threshold_lsn;
> +	/* Cap the target to the highest LSN known to be in the AIL. */
> +	if (XFS_LSN_CMP(target_lsn, max_lsn) > 0)
> +		return max_lsn;
> +	return target_lsn;
>  }
>  
>  static long
> -- 
> 2.36.1
> 
