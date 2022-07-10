Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE410C43334
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Jul 2022 00:15:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiGJAPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jul 2022 20:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGJAPp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jul 2022 20:15:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5D3FD35
        for <linux-xfs@vger.kernel.org>; Sat,  9 Jul 2022 17:15:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98B76B80815
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jul 2022 00:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42545C3411C;
        Sun, 10 Jul 2022 00:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657412141;
        bh=lltQxV0nJ9S3mL4bIhNlmanJ5bR9UoPXBI/ogPiOuk4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mv44R5g+vIhkyhOfdwHh5RX68q9hjQZsdLF7GgSqW/yBBZPM8hpYE9B84x9czipzq
         60P/OUqqkYM405UZejNHS2M1ppOYLVLr7eijhJUJxyb3DBpLh7dQx+qE4vQ2/JNJ75
         d8WqjsySBARGjpxPkEBS9yaOZwiGwD/gvU58ydeteSGndr5AkSQ5Y6sNTIsbrQFaNH
         gPYsZ9Vp9K7n50E4olPrVUtpkL9aykiFeeGy95XwQ3fbQMK4o3PHwp/pEcl7k/6v0X
         GEWZDCXZ1U3Eh/wEvcJKOBI417rPXVgdqJj5TFSGzLyj1RDYXifmcG/WvpOwY36sp+
         ebjKlx2uwTSBA==
Date:   Sat, 9 Jul 2022 17:15:40 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: lockless buffer lookup
Message-ID: <YsoaLD2T/aelPMxJ@magnolia>
References: <20220707235259.1097443-1-david@fromorbit.com>
 <20220707235259.1097443-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707235259.1097443-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 08, 2022 at 09:52:59AM +1000, Dave Chinner wrote:
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
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good, will test....
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c | 22 +++++++++++++++-------
>  fs/xfs/xfs_buf.h |  1 +
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 1a6542e01bec..6dac5583977f 100644
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
> @@ -567,14 +576,13 @@ xfs_buf_lookup(
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
