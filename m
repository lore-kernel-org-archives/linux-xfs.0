Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6105C433B4
	for <linux-xfs@archiver.kernel.org>; Wed,  5 May 2021 11:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3271610F7
	for <linux-xfs@archiver.kernel.org>; Wed,  5 May 2021 11:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbhEELvU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 May 2021 07:51:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43598 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232658AbhEELvU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 May 2021 07:51:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620215423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l2POCE+dCTCu9pe6vmWinOfnDpQG+ar4gZmJ+HOdX9w=;
        b=DmqPsBfLi1SY08NYJWT8dO6vJymnlxRCVBlgbeWy4unYTGHxv8qwoAUkeeBaInst3FqtzS
        zNJW3VcAspmcv/tZai4BLSN7O6S//uGn16J1KwOJgJ4QtWZRrtLgswli/PRQBAnsd9BEL2
        hNtZonrm/RyM0oYROWXQwaA3ZyMjUvM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-3skU6Bl4MEW7L8vXyIdAWQ-1; Wed, 05 May 2021 07:50:21 -0400
X-MC-Unique: 3skU6Bl4MEW7L8vXyIdAWQ-1
Received: by mail-qt1-f200.google.com with SMTP id w10-20020ac86b0a0000b02901ba74ac38c9so808709qts.22
        for <linux-xfs@vger.kernel.org>; Wed, 05 May 2021 04:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l2POCE+dCTCu9pe6vmWinOfnDpQG+ar4gZmJ+HOdX9w=;
        b=rKe+LyRqfIV+/QHYk194tM+yohQiYjTPS1q7Yc+BXTpOoJwBhCBThpFc5XF8S80Qwg
         STOn7uHTS9s/XTekcHEXKcAVNen9gOCBl7ym/xI7tz0XOjw512tSWFVFzZWZmQtXcO8p
         wJsVUm3gwII1uoS7ZCKITXsQhD4AYsJC94D2tbwie9uGjihefBJBUFpM2K/R11S4j/kj
         PG8sPWH6eo5dtvz3v4CHpGp9sXvvwlF9uM7eQHizWE/xQN/G/0U2DNaRwoDdJIeAYfiB
         wk9Atg3UVpbKwk5vJEk/DdN6oEHC05NYw4QJm3pc0VTaDaHS4tKO9puLGMiHm5xGwpao
         3avg==
X-Gm-Message-State: AOAM533wfsUtuvoFSMbn7+54/aw7DIkO13OsLr4C9jzLmoPe7QfRVfAq
        g0/388cS3hOIZnmkQaNKe5LaDc8RyGqtDA3YxwJ8g5eB057al9d+92zzTvzlVNLKUo+k5GJTOB8
        kSHkbTsFsLnWCU1cZVDSx
X-Received: by 2002:ac8:6685:: with SMTP id d5mr27470483qtp.60.1620215420266;
        Wed, 05 May 2021 04:50:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzQ0EcbW2dSwSs46R8yBCnriELYLcWFu8YEH4Oksj/4sJXYwJWp4hRY2y/niRqGroqh4XmuSA==
X-Received: by 2002:ac8:6685:: with SMTP id d5mr27470458qtp.60.1620215419814;
        Wed, 05 May 2021 04:50:19 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id i10sm2973077qko.68.2021.05.05.04.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 04:50:19 -0700 (PDT)
Date:   Wed, 5 May 2021 07:50:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: hold buffer across unpin and potential shutdown
 processing
Message-ID: <YJKGeUrMLvD7VK4l@bfoster>
References: <20210503121816.561340-1-bfoster@redhat.com>
 <20210503232539.GI63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503232539.GI63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 04, 2021 at 09:25:39AM +1000, Dave Chinner wrote:
> On Mon, May 03, 2021 at 08:18:16AM -0400, Brian Foster wrote:
> > The special processing used to simulate a buffer I/O failure on fs
> > shutdown has a difficult to reproduce race that can result in a use
> > after free of the associated buffer. Consider a buffer that has been
> > committed to the on-disk log and thus is AIL resident. The buffer
> > lands on the writeback delwri queue, but is subsequently locked,
> > committed and pinned by another transaction before submitted for
> > I/O. At this point, the buffer is stuck on the delwri queue as it
> > cannot be submitted for I/O until it is unpinned. A log checkpoint
> > I/O failure occurs sometime later, which aborts the bli. The unpin
> > handler is called with the aborted log item, drops the bli reference
> > count, the pin count, and falls into the I/O failure simulation
> > path.
> > 
> > The potential problem here is that once the pin count falls to zero
> > in ->iop_unpin(), xfsaild is free to retry delwri submission of the
> > buffer at any time, before the unpin handler even completes. If
> > delwri queue submission wins the race to the buffer lock, it
> > observes the shutdown state and simulates the I/O failure itself.
> > This releases both the bli and delwri queue holds and frees the
> > buffer while xfs_buf_item_unpin() sits on xfs_buf_lock() waiting to
> > run through the same failure sequence. This problem is rare and
> > requires many iterations of fstest generic/019 (which simulates disk
> > I/O failures) to reproduce.
> 
> You've described the race but not the failure that occurs? I'm going
> to guess this is a use-after-free situation or something similar,
> but I'm not immediately sure...
> 

Yes, it's a use after free. I don't recall the exact error output, but
the above implies it by pointing out the delwri queue "frees the buffer
while xfs_buf_item_unpin() sits on xfs_buf_lock() ..." Also, the first
sentence in the commit log explicitly states it's a use after free of
the buffer. :)

> > To avoid this problem, hold the buffer across the unpin sequence in
> > xfs_buf_item_unpin(). This is a bit unfortunate in that the new hold
> > is unconditional while really only necessary for a rare, fatal error
> > scenario, but it guarantees the buffer still exists in the off
> > chance that the handler attempts to access it.
> 
> Ok, so essentially the problem here is that in the case of a
> non-stale buffer we can enter xfs_buf_item_unpin() with an unlocked,
> buffer that only the bli holds a reference to, and that bli
> reference to the can be dropped by a racing IO completion that calls
> xfs_buf_item_done()?
> 

The delwri queue and bli hold references to the buffer on entry of
xfs_buf_item_unpin(). I believe the only reference to the bli at this
point is that acquired via ->iop_pin(). (Technically the bli reference
acquired by the transaction is released via ->iop_committing() after the
item is pinned, so the ref effectively transfers along...).

Once the pin count drops to zero, the buffer is available for I/O. Since
unpin also drops the last bli reference and has no indication of whether
the item is AIL resident, both unpin and the delwri submit race to
perform the simulated I/O failure on the buffer that is effectively only
held by the delwri queue (because the bli hold drops on I/O completion).
If the latter wins, it can free the buffer before unpin has acquired the
hold used to simulate the I/O.

> i.e. the problem here is that we've dropped the bip->bli_refcount
> before we've locked the buffer and taken a reference to it for
> the fail path?
> 
> OK, I see that xfs_buf_item_done() (called from ioend processing)
> simply frees the buf log item and doesn't care about the bli
> refcount at all. So the first ioend caller will free the buf log
> item regardless of whether there are other references to it at all.
> 
> IOWs, once we unpin the buffer, the bli attached to the buffer and
> being tracked in the AIL has -zero- references to the bli and so it
> gets freed unconditionally on IO completion.
> 
> That seems to the be the problem here - the bli is not reference
> counted while it is the AIL....
> 

I think it depends on how you look at it. As you point out, we've had
this odd bli reference count pattern for as long as I can remember where
the refcount seems to span the transaction and pin lifecycle, but then
goes to zero at final unpin so it can do certain bli processing there
and buffer writeback completion can just explicitly free the bli
(dropping the buffer hold). I don't think that by itself is necessarily
the problem since for one it's the buffer we care about here, but also
the current code is clearly written with this reference counting pattern
in mind (i.e. we continue to access the bli after the bli refcount drops
to zero).

That said, I'm not opposed to fixing this bug via an improvement to the
bli reference count handling if we can do so cleanly enough. I didn't
really consider that approach because of the difference in complexity
and scope between reworking bli refcount handling and just grabbing a
buffer hold in the context it's needed..

> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > This is a patch I've had around for a bit for a very rare corner case I
> > was able to reproduce in some past testing. I'm sending this as RFC
> > because I'm curious if folks have any thoughts on the approach. I'd be
> > Ok with this change as is, but I think there are alternatives available
> > too. We could do something fairly simple like bury the hold in the
> > remove (abort) case only, or perhaps consider checking IN_AIL state
> > before the pin count drops and base on that (though that seems a bit
> > more fragile to me). Thoughts?
> > 
> > Brian
> > 
> >  fs/xfs/xfs_buf_item.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index fb69879e4b2b..a1ad6901eb15 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -504,6 +504,7 @@ xfs_buf_item_unpin(
> >  
> >  	freed = atomic_dec_and_test(&bip->bli_refcount);
> >  
> > +	xfs_buf_hold(bp);
> >  	if (atomic_dec_and_test(&bp->b_pin_count))
> >  		wake_up_all(&bp->b_waiters);
> >  
> > @@ -560,6 +561,7 @@ xfs_buf_item_unpin(
> >  		bp->b_flags |= XBF_ASYNC;
> >  		xfs_buf_ioend_fail(bp);
> >  	}
> > +	xfs_buf_rele(bp);
> >  }
> 
> Ok, so we take an extra reference for the xfs_buf_ioend_fail()
> path because we've exposed the code running here to the bli
> reference to the buffer being dropped at any point after the wakeup
> due to IO completion being run by another party.
> 
> Yup, seems like the bli_refcount scope needs to be expanded here.
> 
> Seems to me that we need to change how and where we drop the buf log
> item reference count so the reference to the buffer it owns isn't
> dropped until -after- we process the IO failure case.
> 
> Something like the patch below (completely untested!), perhaps?
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: extend bli_refcount to cover the AIL and IO
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Untested.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_buf_item.c | 207 +++++++++++++++++++++++++++++---------------------
>  fs/xfs/xfs_buf_item.h |   1 -
>  2 files changed, 120 insertions(+), 88 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> index fb69879e4b2b..a0fa0f16d8c7 100644
> --- a/fs/xfs/xfs_buf_item.c
> +++ b/fs/xfs/xfs_buf_item.c
...
> @@ -502,56 +528,26 @@ xfs_buf_item_unpin(
>  
>  	trace_xfs_buf_item_unpin(bip);
>  
> -	freed = atomic_dec_and_test(&bip->bli_refcount);
> -
> +	/*
> +	 * We can wake pin waiters safely now because we still hold the
> +	 * bli_refcount that was taken when the pin was gained.
> +	 */
>  	if (atomic_dec_and_test(&bp->b_pin_count))
>  		wake_up_all(&bp->b_waiters);
>  
> -	if (freed && stale) {
> -		ASSERT(bip->bli_flags & XFS_BLI_STALE);
> -		ASSERT(xfs_buf_islocked(bp));
> -		ASSERT(bp->b_flags & XBF_STALE);
> -		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
> -
> -		trace_xfs_buf_item_unpin_stale(bip);
> -
> -		if (remove) {
> -			/*
> -			 * If we are in a transaction context, we have to
> -			 * remove the log item from the transaction as we are
> -			 * about to release our reference to the buffer.  If we
> -			 * don't, the unlock that occurs later in
> -			 * xfs_trans_uncommit() will try to reference the
> -			 * buffer which we no longer have a hold on.
> -			 */
> -			if (!list_empty(&lip->li_trans))
> -				xfs_trans_del_item(lip);
> -
> -			/*
> -			 * Since the transaction no longer refers to the buffer,
> -			 * the buffer should no longer refer to the transaction.
> -			 */
> -			bp->b_transp = NULL;
> +	if (!stale) {
> +		if (!remove) {
> +			/* Nothing to do but drop the refcount the pin owned. */
> +			atomic_dec(&bip->bli_refcount);
> +			return;
>  		}

Hmm.. this seems a bit wonky to me. This code historically acts on the
drop of the final reference to the bli. This is not critical for the
common (!stale && !remove) case because that's basically a no-op here
outside of dropping the reference, and it looks like the stale buffer
handling code further down continues to follow that model, but in this
branch it seems we're trying to be clever in how the reference is
managed and as a result can act on a bli that might actually have
additional references. If so, I don't think it's appropriate to run
through the error sequence that follows.

>  
>  		/*
> -		 * If we get called here because of an IO error, we may or may
> -		 * not have the item on the AIL. xfs_trans_ail_delete() will
> -		 * take care of that situation. xfs_trans_ail_delete() drops
> -		 * the AIL lock.
> -		 */
> -		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
> -			xfs_buf_item_done(bp);
> -			xfs_buf_inode_iodone(bp);
> -			ASSERT(list_empty(&bp->b_li_list));
> -		} else {
> -			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
> -			xfs_buf_item_relse(bp);
> -			ASSERT(bp->b_log_item == NULL);
> -		}
> -		xfs_buf_relse(bp);
> -	} else if (freed && remove) {
> -		/*
> +		 * Fail the IO before we drop the bli refcount. This guarantees
> +		 * that a racing writeback completion also failing the buffer
> +		 * and running completion will not remove the last reference to
> +		 * the bli and free it from under us.
> +		 *
>  		 * The buffer must be locked and held by the caller to simulate
>  		 * an async I/O failure.
>  		 */
> @@ -559,7 +555,62 @@ xfs_buf_item_unpin(
>  		xfs_buf_hold(bp);
>  		bp->b_flags |= XBF_ASYNC;
>  		xfs_buf_ioend_fail(bp);
> +		xfs_buf_item_relse(bp);

Did you mean for this to be xfs_buf_item_put() instead of _relse()? The
comment above implies dropping the bli refcount after the I/O failure,
but this just frees it. ISTM we will always have the AIL bli reference
here because it was bumped in xfs_buf_item_committed() unless it was AIL
resident already. OTOH, if the buffer is already AIL resident the
eventual xfs_buf_item_done() (via xfs_buf_ioend()) would remove it
before it drops the bli ref. It's not clear to me what the intent is
here. 

> +		return;
>  	}
> +
> +	/*
> +	 * Stale buffer - only process it if this is the last reference to the
> +	 * BLI. If this is the last BLI reference, then the buffer will be
> +	 * locked and have two references - once from the transaction commit and
> +	 * one from the BLI - and we do not unlock and release transaction
> +	 * reference until we've finished cleaning up the BLI.
> +	 */
> +	if (!atomic_dec_and_test(&bip->bli_refcount))
> +		return;
> +

If the buffer is stale, will this ever be the last reference now that
_item_committed() bumps the refcount? This change also seems to have
ramifications for the code that follows, such as if a staled buffer is
already in the AIL (with a bli ref), would this code ever get to the
point of removing it?

All in all, I'll reiterate that I think it would be nice to fix up the
bli reference count handling in general, but I think the scope and
complexity of that work is significantly beyond what is reasonably
necessary to fix this bug. A rework may not ultimately be a huge code
change, but the level of review and testing required to cover and
consider all the corner cases and whatnot for refcount handling is
definitely nontrivial. That's just my .02 on a first pass.

Brian

> +	ASSERT(bip->bli_flags & XFS_BLI_STALE);
> +	ASSERT(xfs_buf_islocked(bp));
> +	ASSERT(bp->b_flags & XBF_STALE);
> +	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
> +
> +	trace_xfs_buf_item_unpin_stale(bip);
> +
> +	if (remove) {
> +		/*
> +		 * If we are in a transaction context, we have to
> +		 * remove the log item from the transaction as we are
> +		 * about to release our reference to the buffer.  If we
> +		 * don't, the unlock that occurs later in
> +		 * xfs_trans_uncommit() will try to reference the
> +		 * buffer which we no longer have a hold on.
> +		 */
> +		if (!list_empty(&lip->li_trans))
> +			xfs_trans_del_item(lip);
> +
> +		/*
> +		 * Since the transaction no longer refers to the buffer,
> +		 * the buffer should no longer refer to the transaction.
> +		 */
> +		bp->b_transp = NULL;
> +	}
> +
> +	/*
> +	 * If we get called here because of an IO error, we may or may
> +	 * not have the item on the AIL. xfs_trans_ail_delete() will
> +	 * take care of that situation. xfs_trans_ail_delete() drops
> +	 * the AIL lock.
> +	 */
> +	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
> +		xfs_buf_item_done(bp);
> +		xfs_buf_inode_iodone(bp);
> +		ASSERT(list_empty(&bp->b_li_list));
> +	} else {
> +		xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
> +		xfs_buf_item_relse(bp);
> +		ASSERT(bp->b_log_item == NULL);
> +	}
> +	xfs_buf_relse(bp);
>  }
>  
>  STATIC uint
> @@ -720,22 +771,24 @@ xfs_buf_item_committing(
>  }
>  
>  /*
> - * This is called to find out where the oldest active copy of the
> - * buf log item in the on disk log resides now that the last log
> - * write of it completed at the given lsn.
> - * We always re-log all the dirty data in a buffer, so usually the
> - * latest copy in the on disk log is the only one that matters.  For
> - * those cases we simply return the given lsn.
> + * The item is about to be inserted into the AIL. If it is not already in the
> + * AIL, we need to take a reference to the BLI for the AIL. This "AIL reference"
> + * will be held until the item is removed from the AIL.
> + *
> + * This is called to find out where the oldest active copy of the buf log item
> + * in the on disk log resides now that the last log write of it completed at the
> + * given lsn.  We always re-log all the dirty data in a buffer, so usually the
> + * latest copy in the on disk log is the only one that matters.  For those cases
> + * we simply return the given lsn.
>   *
> - * The one exception to this is for buffers full of newly allocated
> - * inodes.  These buffers are only relogged with the XFS_BLI_INODE_BUF
> - * flag set, indicating that only the di_next_unlinked fields from the
> - * inodes in the buffers will be replayed during recovery.  If the
> - * original newly allocated inode images have not yet been flushed
> - * when the buffer is so relogged, then we need to make sure that we
> - * keep the old images in the 'active' portion of the log.  We do this
> - * by returning the original lsn of that transaction here rather than
> - * the current one.
> + * The one exception to this is for buffers full of newly allocated inodes.
> + * These buffers are only relogged with the XFS_BLI_INODE_BUF flag set,
> + * indicating that only the di_next_unlinked fields from the inodes in the
> + * buffers will be replayed during recovery.  If the original newly allocated
> + * inode images have not yet been flushed when the buffer is so relogged, then
> + * we need to make sure that we keep the old images in the 'active' portion of
> + * the log.  We do this by returning the original lsn of that transaction here
> + * rather than the current one.
>   */
>  STATIC xfs_lsn_t
>  xfs_buf_item_committed(
> @@ -746,6 +799,9 @@ xfs_buf_item_committed(
>  
>  	trace_xfs_buf_item_committed(bip);
>  
> +	if (!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags))
> +		atomic_inc(&bli->bli_refcount);
> +
>  	if ((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) && lip->li_lsn != 0)
>  		return lip->li_lsn;
>  	return lsn;
> @@ -1009,36 +1065,12 @@ xfs_buf_item_dirty_format(
>  	return false;
>  }
>  
> -STATIC void
> -xfs_buf_item_free(
> -	struct xfs_buf_log_item	*bip)
> -{
> -	xfs_buf_item_free_format(bip);
> -	kmem_free(bip->bli_item.li_lv_shadow);
> -	kmem_cache_free(xfs_buf_item_zone, bip);
> -}
> -
> -/*
> - * xfs_buf_item_relse() is called when the buf log item is no longer needed.
> - */
> -void
> -xfs_buf_item_relse(
> -	struct xfs_buf	*bp)
> -{
> -	struct xfs_buf_log_item	*bip = bp->b_log_item;
> -
> -	trace_xfs_buf_item_relse(bp, _RET_IP_);
> -	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
> -
> -	bp->b_log_item = NULL;
> -	xfs_buf_rele(bp);
> -	xfs_buf_item_free(bip);
> -}
> -
>  void
>  xfs_buf_item_done(
>  	struct xfs_buf		*bp)
>  {
> +	struct xfs_buf_log_item	*bip = bp->b_log_item;
> +
>  	/*
>  	 * If we are forcibly shutting down, this may well be off the AIL
>  	 * already. That's because we simulate the log-committed callbacks to
> @@ -1051,8 +1083,9 @@ xfs_buf_item_done(
>  	 * Note that log recovery writes might have buffer items that are not on
>  	 * the AIL even when the file system is not shut down.
>  	 */
> -	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
> +	xfs_trans_ail_delete(&bip->bli_item,
>  			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
>  			     SHUTDOWN_CORRUPT_INCORE);
> -	xfs_buf_item_relse(bp);
> +
> +	xfs_buf_item_put(bp);
>  }
> diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
> index 50aa0f5ef959..e3ccbf3ca801 100644
> --- a/fs/xfs/xfs_buf_item.h
> +++ b/fs/xfs/xfs_buf_item.h
> @@ -51,7 +51,6 @@ struct xfs_buf_log_item {
>  
>  int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
>  void	xfs_buf_item_done(struct xfs_buf *bp);
> -void	xfs_buf_item_relse(struct xfs_buf *);
>  bool	xfs_buf_item_put(struct xfs_buf_log_item *);
>  void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
>  bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
> 

