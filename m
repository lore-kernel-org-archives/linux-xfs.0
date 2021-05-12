Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447C4C433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 01:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 083016192A
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 01:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhELBxz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 21:53:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhELBxz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 May 2021 21:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD59461186;
        Wed, 12 May 2021 01:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620784367;
        bh=jwhdJZiqbKaVYRPBa2Mi3sV89eN/hbjz5+xaqXb1bxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GiYRfr8Xbi1OgUxPoTQUIBKLE+ArrJqGYGJdNPBAxbp8pdlpx6VwyhDNdbLKvCzWV
         bhCyW8mL64xnAgN4kiJ1kfGG1MDnd8q0Setpzd5oD4YRTadm28V5AkvmEi4Zd0t2Gj
         sPZAN1ySLfLUJW0udUZrmO/STSZJ3OuwuwEZw2xmYkY5QFYLGNtSSxblk/lyxnELrA
         MS3thZc9airzEo+FARoWKHFaPbbfvE0mIFCVOBwFHnbCztV3i8L0Y1F7tFfjBJgxKy
         KF4MWDUxsAAa+uhkZtOYGp4oyz/ef+N4wIbzBCCb+fgxECrIxukFewLIuJvdBlQ3KW
         fV27xjxekipfQ==
Date:   Tue, 11 May 2021 18:52:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: hold buffer across unpin and potential shutdown
 processing
Message-ID: <20210512015244.GW8582@magnolia>
References: <20210511135257.878743-1-bfoster@redhat.com>
 <20210511135257.878743-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511135257.878743-2-bfoster@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 09:52:56AM -0400, Brian Foster wrote:
> The special processing used to simulate a buffer I/O failure on fs
> shutdown has a difficult to reproduce race that can result in a use
> after free of the associated buffer. Consider a buffer that has been
> committed to the on-disk log and thus is AIL resident. The buffer
> lands on the writeback delwri queue, but is subsequently locked,
> committed and pinned by another transaction before submitted for
> I/O. At this point, the buffer is stuck on the delwri queue as it
> cannot be submitted for I/O until it is unpinned. A log checkpoint
> I/O failure occurs sometime later, which aborts the bli. The unpin
> handler is called with the aborted log item, drops the bli reference
> count, the pin count, and falls into the I/O failure simulation
> path.
> 
> The potential problem here is that once the pin count falls to zero
> in ->iop_unpin(), xfsaild is free to retry delwri submission of the
> buffer at any time, before the unpin handler even completes. If
> delwri queue submission wins the race to the buffer lock, it
> observes the shutdown state and simulates the I/O failure itself.
> This releases both the bli and delwri queue holds and frees the
> buffer while xfs_buf_item_unpin() sits on xfs_buf_lock() waiting to
> run through the same failure sequence. This problem is rare and
> requires many iterations of fstest generic/019 (which simulates disk
> I/O failures) to reproduce.
> 
> To avoid this problem, grab a hold on the buffer before the log item
> is unpinned if the associated item has been aborted and will require
> a simulated I/O failure. The hold is already required for the
> simulated I/O failure, so the ordering simply guarantees the unpin
> handler access to the buffer before it is unpinned and thus
> processed by the AIL. This particular ordering is required so long
> as the AIL does not acquire a reference on the bli, which is the
> long term solution to this problem.

Are you working on that too, or are we just going to let that lie for
the time being? :)

> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c | 37 +++++++++++++++++++++----------------
>  1 file changed, 21 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index fb69879e4b2b..7ff31788512b 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
> @@ -475,17 +475,8 @@ xfs_buf_item_pin(
>  }
>  
>  /*
> - * This is called to unpin the buffer associated with the buf log
> - * item which was previously pinned with a call to xfs_buf_item_pin().
> - *
> - * Also drop the reference to the buf item for the current transaction.
> - * If the XFS_BLI_STALE flag is set and we are the last reference,
> - * then free up the buf log item and unlock the buffer.
> - *
> - * If the remove flag is set we are called from uncommit in the
> - * forced-shutdown path.  If that is true and the reference count on
> - * the log item is going to drop to zero we need to free the item's
> - * descriptor in the transaction.
> + * This is called to unpin the buffer associated with the buf log item which
> + * was previously pinned with a call to xfs_buf_item_pin().
>   */
>  STATIC void
>  xfs_buf_item_unpin(
> @@ -502,12 +493,26 @@ xfs_buf_item_unpin(
>  
>  	trace_xfs_buf_item_unpin(bip);
>  
> +	/*
> +	 * Drop the bli ref associated with the pin and grab the hold required
> +	 * for the I/O simulation failure in the abort case. We have to do this
> +	 * before the pin count drops because the AIL doesn't acquire a bli
> +	 * reference. Therefore if the refcount drops to zero, the bli could
> +	 * still be AIL resident and the buffer submitted for I/O (and freed on
> +	 * completion) at any point before we return. This can be removed once
> +	 * the AIL properly holds a reference on the bli.
> +	 */
>  	freed = atomic_dec_and_test(&bip->bli_refcount);
> -
> +	if (freed && !stale && remove)
> +		xfs_buf_hold(bp);
>  	if (atomic_dec_and_test(&bp->b_pin_count))
>  		wake_up_all(&bp->b_waiters);
>  
> -	if (freed && stale) {
> +	 /* nothing to do but drop the pin count if the bli is active */
> +	if (!freed)
> +		return;

Hmm, this all seems convoluted as promised, but if I'm reading the code
correctly, you're moving the buffer hold above where we wake the
pincount waiters, because the AIL could be in xfs_buf_wait_unpin,
holding the only reference?  So if we wake it and the write is quick,
the AIL's ioend will nuke the buffer before this thread (which is trying
to kill a transaction and shut down the system?) gets a chance to
free the buffer via _buf_ioend_fail?

If I got that right,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> +
> +	if (stale) {
>  		ASSERT(bip->bli_flags & XFS_BLI_STALE);
>  		ASSERT(xfs_buf_islocked(bp));
>  		ASSERT(bp->b_flags & XBF_STALE);
> @@ -550,13 +555,13 @@ xfs_buf_item_unpin(
>  			ASSERT(bp->b_log_item == NULL);
>  		}
>  		xfs_buf_relse(bp);
> -	} else if (freed && remove) {
> +	} else if (remove) {
>  		/*
>  		 * The buffer must be locked and held by the caller to simulate
> -		 * an async I/O failure.
> +		 * an async I/O failure. We acquired the hold for this case
> +		 * before the buffer was unpinned.
>  		 */
>  		xfs_buf_lock(bp);
> -		xfs_buf_hold(bp);
>  		bp->b_flags |= XBF_ASYNC;
>  		xfs_buf_ioend_fail(bp);
>  	}
> -- 
> 2.26.3
> 
