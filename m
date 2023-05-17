Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689D9C77B75
	for <linux-xfs@archiver.kernel.org>; Wed, 17 May 2023 01:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjEQB0p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 May 2023 21:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjEQB0o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2023 21:26:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E0013E
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2023 18:26:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E44960FBA
        for <linux-xfs@vger.kernel.org>; Wed, 17 May 2023 01:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8C6C433D2;
        Wed, 17 May 2023 01:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684286802;
        bh=R9Bz1mjRjNs+MDI1UBM5UBs7sdJ8ISsZ4GPbVSIafrU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OaGnDX9NgMnyLMayrqu1tgwGOP25g6cNtZgRlYwF58KODAombaDDEeIJzTJkkzW68
         ZP3/PKOv+8n+A/qUY/yOLXJcnrQuNo5ZJ5GU68e8LtKYPijETij6FsuICgT7yoyB1J
         0+YAPuYIXd1IuXseP9JeMSVSGkYMw+YP83+hRF7FpAk2cNd6xBZek9oDR1Aa/ZKGd6
         65LAT5T7SOwJ5iClF6TCUfITyoccfrfq2f3nOT63rQ3iRnuGPLdEP1xFqKzMkQjTZJ
         ziIUNJMQDtlBicwuF1L+1KqTr/Zii6CkMZ/2S1Yd65NzzwI59hIKOGpT4lFnYGOmJY
         +0isznQaUXEFA==
Date:   Tue, 16 May 2023 18:26:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: buffer pins need to hold a buffer reference
Message-ID: <20230517012642.GQ858799@frogsfrogsfrogs>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517000449.3997582-2-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 17, 2023 at 10:04:46AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When a buffer is unpinned by xfs_buf_item_unpin(), we need to access
> the buffer after we've dropped the buffer log item reference count.
> This opens a window where we can have two racing unpins for the
> buffer item (e.g. shutdown checkpoint context callback processing
> racing with journal IO iclog completion processing) and both attempt
> to access the buffer after dropping the BLI reference count.  If we
> are unlucky, the "BLI freed" context wins the race and frees the
> buffer before the "BLI still active" case checks the buffer pin
> count.
> 
> This results in a use after free that can only be triggered
> in active filesystem shutdown situations.
> 
> To fix this, we need to ensure that buffer existence extends beyond
> the BLI reference count checks and until the unpin processing is
> complete. This implies that a buffer pin operation must also take a
> buffer reference to ensure that the buffer cannot be freed until the
> buffer unpin processing is complete.
> 
> Reported-by: yangerkun <yangerkun@huawei.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

LGTM
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf_item.c | 88 ++++++++++++++++++++++++++++++++-----------
>  1 file changed, 65 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index df7322ed73fa..b2d211730fd2 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -452,10 +452,18 @@ xfs_buf_item_format(
>   * This is called to pin the buffer associated with the buf log item in memory
>   * so it cannot be written out.
>   *
> - * We also always take a reference to the buffer log item here so that the bli
> - * is held while the item is pinned in memory. This means that we can
> - * unconditionally drop the reference count a transaction holds when the
> - * transaction is completed.
> + * We take a reference to the buffer log item here so that the BLI life cycle
> + * extends at least until the buffer is unpinned via xfs_buf_item_unpin() and
> + * inserted into the AIL.
> + *
> + * We also need to take a reference to the buffer itself as the BLI unpin
> + * processing requires accessing the buffer after the BLI has dropped the final
> + * BLI reference. See xfs_buf_item_unpin() for an explanation.
> + * If unpins race to drop the final BLI reference and only the
> + * BLI owns a reference to the buffer, then the loser of the race can have the
> + * buffer fgreed from under it (e.g. on shutdown). Taking a buffer reference per
> + * pin count ensures the life cycle of the buffer extends for as
> + * long as we hold the buffer pin reference in xfs_buf_item_unpin().
>   */
>  STATIC void
>  xfs_buf_item_pin(
> @@ -470,13 +478,30 @@ xfs_buf_item_pin(
>  
>  	trace_xfs_buf_item_pin(bip);
>  
> +	xfs_buf_hold(bip->bli_buf);
>  	atomic_inc(&bip->bli_refcount);
>  	atomic_inc(&bip->bli_buf->b_pin_count);
>  }
>  
>  /*
> - * This is called to unpin the buffer associated with the buf log item which
> - * was previously pinned with a call to xfs_buf_item_pin().
> + * This is called to unpin the buffer associated with the buf log item which was
> + * previously pinned with a call to xfs_buf_item_pin().  We enter this function
> + * with a buffer pin count, a buffer reference and a BLI reference.
> + *
> + * We must drop the BLI reference before we unpin the buffer because the AIL
> + * doesn't acquire a BLI reference whenever it accesses it. Therefore if the
> + * refcount drops to zero, the bli could still be AIL resident and the buffer
> + * submitted for I/O at any point before we return. This can result in IO
> + * completion freeing the buffer while we are still trying to access it here.
> + * This race condition can also occur in shutdown situations where we abort and
> + * unpin buffers from contexts other that journal IO completion.
> + *
> + * Hence we have to hold a buffer reference per pin count to ensure that the
> + * buffer cannot be freed until we have finished processing the unpin operation.
> + * The reference is taken in xfs_buf_item_pin(), and we must hold it until we
> + * are done processing the buffer state. In the case of an abort (remove =
> + * true) then we re-use the current pin reference as the IO reference we hand
> + * off to IO failure handling.
>   */
>  STATIC void
>  xfs_buf_item_unpin(
> @@ -493,24 +518,18 @@ xfs_buf_item_unpin(
>  
>  	trace_xfs_buf_item_unpin(bip);
>  
> -	/*
> -	 * Drop the bli ref associated with the pin and grab the hold required
> -	 * for the I/O simulation failure in the abort case. We have to do this
> -	 * before the pin count drops because the AIL doesn't acquire a bli
> -	 * reference. Therefore if the refcount drops to zero, the bli could
> -	 * still be AIL resident and the buffer submitted for I/O (and freed on
> -	 * completion) at any point before we return. This can be removed once
> -	 * the AIL properly holds a reference on the bli.
> -	 */
>  	freed = atomic_dec_and_test(&bip->bli_refcount);
> -	if (freed && !stale && remove)
> -		xfs_buf_hold(bp);
>  	if (atomic_dec_and_test(&bp->b_pin_count))
>  		wake_up_all(&bp->b_waiters);
>  
> -	 /* nothing to do but drop the pin count if the bli is active */
> -	if (!freed)
> +	 /*
> +	  * Nothing to do but drop the buffer pin reference if the BLI is
> +	  * still active
> +	  */
> +	if (!freed) {
> +		xfs_buf_rele(bp);
>  		return;
> +	}
>  
>  	if (stale) {
>  		ASSERT(bip->bli_flags & XFS_BLI_STALE);
> @@ -522,6 +541,15 @@ xfs_buf_item_unpin(
>  
>  		trace_xfs_buf_item_unpin_stale(bip);
>  
> +		/*
> +		 * The buffer has been locked and referenced since it was marked
> +		 * stale so we own both lock and reference exclusively here. We
> +		 * do not need the pin reference any more, so drop it now so
> +		 * that we only have one reference to drop once item completion
> +		 * processing is complete.
> +		 */
> +		xfs_buf_rele(bp);
> +
>  		/*
>  		 * If we get called here because of an IO error, we may or may
>  		 * not have the item on the AIL. xfs_trans_ail_delete() will
> @@ -538,16 +566,30 @@ xfs_buf_item_unpin(
>  			ASSERT(bp->b_log_item == NULL);
>  		}
>  		xfs_buf_relse(bp);
> -	} else if (remove) {
> +		return;
> +	}
> +
> +	if (remove) {
>  		/*
> -		 * The buffer must be locked and held by the caller to simulate
> -		 * an async I/O failure. We acquired the hold for this case
> -		 * before the buffer was unpinned.
> +		 * We need to simulate an async IO failures here to ensure that
> +		 * the correct error completion is run on this buffer. This
> +		 * requires a reference to the buffer and for the buffer to be
> +		 * locked. We can safely pass ownership of the pin reference to
> +		 * the IO to ensure that nothing can free the buffer while we
> +		 * wait for the lock and then run the IO failure completion.
>  		 */
>  		xfs_buf_lock(bp);
>  		bp->b_flags |= XBF_ASYNC;
>  		xfs_buf_ioend_fail(bp);
> +		return;
>  	}
> +
> +	/*
> +	 * BLI has no more active references - it will be moved to the AIL to
> +	 * manage the remaining BLI/buffer life cycle. There is nothing left for
> +	 * us to do here so drop the pin reference to the buffer.
> +	 */
> +	xfs_buf_rele(bp);
>  }
>  
>  STATIC uint
> -- 
> 2.40.1
> 
