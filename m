Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 220ACC43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 22:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiF2WEo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiF2WEo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 18:04:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B495275DD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 15:04:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06A71614D9
        for <linux-xfs@vger.kernel.org>; Wed, 29 Jun 2022 22:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EEAC34114;
        Wed, 29 Jun 2022 22:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656540282;
        bh=aT2opfC+eMgb3pfzGJ7tDsl4wV2oOJoLOVCD3dNemVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j2MuoJ4eK8JxF0wcD4DUribPcfOM/T9w+9ZLSmEbcaPqDypj3LIYSdRKdqtN8vnPD
         qsF9eT9Q9yrtvMCebQxhcefn54bLbfRMz2vdv+FIH0dQpUUxbvKGquCfgf0n6e8k88
         PIA8F5SPUwtrz48//W403a1g616F566hs3JRnIK4/tA6USkIRyEj7HPV6c4Hn2amuP
         85EvKTCA1jby7rE1vObRzba6zaPpsvjRlD1Ju4tymcU3b0+Ak397bgiGeE0uJ74FJ+
         /kRFMJM7Ofw+dIBM/RysSsC4ayDWJw9+rtN9xw1tRKI0tZdZ35MlSQZMYSbrXTTuyl
         AlaiAj76nYPzQ==
Date:   Wed, 29 Jun 2022 15:04:41 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: lockless buffer lookup
Message-ID: <YrzMeZ/mW+yN94Oo@magnolia>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627060841.244226-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 04:08:41PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have a standalone fast path for buffer lookup, we can
> easily convert it to use rcu lookups. When we continually hammer the
> buffer cache with trylock lookups, we end up with a huge amount of
> lock contention on the per-ag buffer hash locks:
> 
> -   92.71%     0.05%  [kernel]                  [k] xfs_inodegc_worker
>    - 92.67% xfs_inodegc_worker
>       - 92.13% xfs_inode_unlink
>          - 91.52% xfs_inactive_ifree
>             - 85.63% xfs_read_agi
>                - 85.61% xfs_trans_read_buf_map
>                   - 85.59% xfs_buf_read_map
>                      - xfs_buf_get_map
>                         - 85.55% xfs_buf_find
>                            - 72.87% _raw_spin_lock
>                               - do_raw_spin_lock
>                                    71.86% __pv_queued_spin_lock_slowpath
>                            - 8.74% xfs_buf_rele
>                               - 7.88% _raw_spin_lock
>                                  - 7.88% do_raw_spin_lock
>                                       7.63% __pv_queued_spin_lock_slowpath
>                            - 1.70% xfs_buf_trylock
>                               - 1.68% down_trylock
>                                  - 1.41% _raw_spin_lock_irqsave
>                                     - 1.39% do_raw_spin_lock
>                                          __pv_queued_spin_lock_slowpath
>                            - 0.76% _raw_spin_unlock
>                                 0.75% do_raw_spin_unlock
> 
> This is basically hammering the pag->pag_buf_lock from lots of CPUs
> doing trylocks at the same time. Most of the buffer trylock
> operations ultimately fail after we've done the lookup, so we're
> really hammering the buf hash lock whilst making no progress.
> 
> We can also see significant spinlock traffic on the same lock just
> under normal operation when lots of tasks are accessing metadata
> from the same AG, so let's avoid all this by converting the lookup
> fast path to leverages the rhashtable's ability to do rcu protected
> lookups.
> 
> We avoid races with the buffer release path by using
> atomic_inc_not_zero() on the buffer hold count. Any buffer that is
> in the LRU will have a non-zero count, thereby allowing the lockless
> fast path to be taken in most cache hit situations. If the buffer
> hold count is zero, then it is likely going through the release path
> so in that case we fall back to the existing lookup miss slow path.
> 
> The slow path will then do an atomic lookup and insert under the
> buffer hash lock and hence serialise correctly against buffer
> release freeing the buffer.
> 
> The use of rcu protected lookups means that buffer handles now need
> to be freed by RCU callbacks (same as inodes). We still free the
> buffer pages before the RCU callback - we won't be trying to access
> them at all on a buffer that has zero references - but we need the
> buffer handle itself to be present for the entire rcu protected read
> side to detect a zero hold count correctly.

Hmm, so what still uses pag_buf_lock?  Are we still using it to
serialize xfs_buf_rele calls?

--D

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf.c | 22 +++++++++++++++-------
>  fs/xfs/xfs_buf.h |  1 +
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 3461ef3ebc1c..14a2d2d6a4e0 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -294,6 +294,16 @@ xfs_buf_free_pages(
>  	bp->b_flags &= ~_XBF_PAGES;
>  }
>  
> +static void
> +xfs_buf_free_callback(
> +	struct callback_head	*cb)
> +{
> +	struct xfs_buf		*bp = container_of(cb, struct xfs_buf, b_rcu);
> +
> +	xfs_buf_free_maps(bp);
> +	kmem_cache_free(xfs_buf_cache, bp);
> +}
> +
>  static void
>  xfs_buf_free(
>  	struct xfs_buf		*bp)
> @@ -307,8 +317,7 @@ xfs_buf_free(
>  	else if (bp->b_flags & _XBF_KMEM)
>  		kmem_free(bp->b_addr);
>  
> -	xfs_buf_free_maps(bp);
> -	kmem_cache_free(xfs_buf_cache, bp);
> +	call_rcu(&bp->b_rcu, xfs_buf_free_callback);
>  }
>  
>  static int
> @@ -567,14 +576,13 @@ xfs_buf_find_fast(
>  	struct xfs_buf          *bp;
>  	int			error;
>  
> -	spin_lock(&pag->pag_buf_lock);
> +	rcu_read_lock();
>  	bp = rhashtable_lookup(&pag->pag_buf_hash, map, xfs_buf_hash_params);
> -	if (!bp) {
> -		spin_unlock(&pag->pag_buf_lock);
> +	if (!bp || !atomic_inc_not_zero(&bp->b_hold)) {
> +		rcu_read_unlock();
>  		return -ENOENT;
>  	}
> -	atomic_inc(&bp->b_hold);
> -	spin_unlock(&pag->pag_buf_lock);
> +	rcu_read_unlock();
>  
>  	error = xfs_buf_find_lock(bp, flags);
>  	if (error) {
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 58e9034d51bd..02b3c1635ec3 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -196,6 +196,7 @@ struct xfs_buf {
>  	int			b_last_error;
>  
>  	const struct xfs_buf_ops	*b_ops;
> +	struct rcu_head		b_rcu;
>  };
>  
>  /* Finding and Reading Buffers */
> -- 
> 2.36.1
> 
