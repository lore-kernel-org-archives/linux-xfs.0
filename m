Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573B4C47093
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 13:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E0AE613E7
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Jun 2021 13:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhFBNfD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Jun 2021 09:35:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35343 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230386AbhFBNe3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 09:34:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622640766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5zPJmJNp/550bqG0jE2bVoaHNFfr3YsMIOvpGwRti+c=;
        b=JjVBIYcwst6NHXtIUNG2vOFT1UC77NYV1aSGu4KzHemroQxcnWL2VPPVwPr19NVTHvh+9K
        mn/0euh+79GUd+L5eBZWxfPpn6vu7grH/Eq9ipQE8Lw1gy4zAwjegU+tKdGSLLS+us8AOV
        gHtOU/P9q+Ll8O2Bo8zV2++lL97i4Ow=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-MpVuK31nONGb1rkXo74D-w-1; Wed, 02 Jun 2021 09:32:45 -0400
X-MC-Unique: MpVuK31nONGb1rkXo74D-w-1
Received: by mail-qt1-f199.google.com with SMTP id j19-20020ac85f930000b029021f033edf60so1326292qta.10
        for <linux-xfs@vger.kernel.org>; Wed, 02 Jun 2021 06:32:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5zPJmJNp/550bqG0jE2bVoaHNFfr3YsMIOvpGwRti+c=;
        b=f/Er0TfTGq/HnQlIc1N34w3LmIbKdzO2jn0pKNld4Pip9kYRlnw8Q7C+b4wcE19OZk
         U1cFtBZpJs0z4ea3izKXR7z314j4JacQSCKy74RgLihSeESmqzwsUM7ZmJAdaUkrnEEr
         iqy4qlCttZ7LpDlqjwbYjSXXvAZp+Ar982rm+ugYh/M3zE1EVm+x4Lx6anTFSF9Z4ruz
         8QRa3LU2K5Zm1TFAnjjwJug7lLTqfvq0MV94SAl16QE0CkxhDKOsnsDLcFPLHrGfywow
         8rQmwFVheu5aq44RG/1jHQFRiuNl5unglbgE2VnLBCSZxWP9QpikCRj0IJDwpMhZCncL
         QCsg==
X-Gm-Message-State: AOAM531Mo+fsOGcrVQKl1ctSwhDJC1PXAOB2kURTm8nr3+KWWGeePxLd
        zMKN5VcKWy3zswjMvDK0siOGCLEFA34/4DcX1e9KU241gBeuoWtcYMpmY4CuCwOs+py8axQVbYk
        rBn3sevC1DWo12kBl4jNk
X-Received: by 2002:a05:620a:1021:: with SMTP id a1mr26882733qkk.399.1622640763923;
        Wed, 02 Jun 2021 06:32:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0wurpAm89t5mVfELdiB/BoIN3jYrHmQgwb0OX+pEYLo6rNk6NVv6UCRxOc8xqqLKSPcKNBA==
X-Received: by 2002:a05:620a:1021:: with SMTP id a1mr26882580qkk.399.1622640762403;
        Wed, 02 Jun 2021 06:32:42 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id u11sm7351042qkk.12.2021.06.02.06.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 06:32:41 -0700 (PDT)
Date:   Wed, 2 Jun 2021 09:32:34 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: hold buffer across unpin and potential shutdown
 processing
Message-ID: <YLeIcvE4oNfEeAtS@bfoster>
References: <20210503121816.561340-1-bfoster@redhat.com>
 <20210503232539.GI63242@dread.disaster.area>
 <YJKGeUrMLvD7VK4l@bfoster>
 <20210506025611.GM63242@dread.disaster.area>
 <YJRDrsbcycnKNMTA@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJRDrsbcycnKNMTA@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 03:29:50PM -0400, Brian Foster wrote:
> On Thu, May 06, 2021 at 12:56:11PM +1000, Dave Chinner wrote:
> > On Wed, May 05, 2021 at 07:50:17AM -0400, Brian Foster wrote:
> > > On Tue, May 04, 2021 at 09:25:39AM +1000, Dave Chinner wrote:
> > > > On Mon, May 03, 2021 at 08:18:16AM -0400, Brian Foster wrote:
> > > > i.e. the problem here is that we've dropped the bip->bli_refcount
> > > > before we've locked the buffer and taken a reference to it for
> > > > the fail path?
> > > > 
> > > > OK, I see that xfs_buf_item_done() (called from ioend processing)
> > > > simply frees the buf log item and doesn't care about the bli
> > > > refcount at all. So the first ioend caller will free the buf log
> > > > item regardless of whether there are other references to it at all.
> > > > 
> > > > IOWs, once we unpin the buffer, the bli attached to the buffer and
> > > > being tracked in the AIL has -zero- references to the bli and so it
> > > > gets freed unconditionally on IO completion.
> > > > 
> > > > That seems to the be the problem here - the bli is not reference
> > > > counted while it is the AIL....
> > > > 
> > > 
> > > I think it depends on how you look at it. As you point out, we've had
> > > this odd bli reference count pattern for as long as I can remember where
> > 
> > Yes, and it's been a constant source of use-after free bugs in
> > shutdown processing for as long as I can remember. I want to fix it
> > so we don't have to keep band-aiding this code every time we change
> > how some part of log item or stale inode/buffer processing works...
> > 
> 
> IME, most of the bugs in this area tend to be shutdown/error related and
> generally relate to the complexity of all the various states and
> contexts for the different callback contexts. That isn't a direct result
> of this bli refcount behavior, as odd as it is, though that certainly
> contributes to the overall complexity.
> 
> > 
> > > >  
> > > > -	freed = atomic_dec_and_test(&bip->bli_refcount);
> > > > -
> > > > +	/*
> > > > +	 * We can wake pin waiters safely now because we still hold the
> > > > +	 * bli_refcount that was taken when the pin was gained.
> > > > +	 */
> > > >  	if (atomic_dec_and_test(&bp->b_pin_count))
> > > >  		wake_up_all(&bp->b_waiters);
> > > >  
> > > > -	if (freed && stale) {
> > > > -		ASSERT(bip->bli_flags & XFS_BLI_STALE);
> > > > -		ASSERT(xfs_buf_islocked(bp));
> > > > -		ASSERT(bp->b_flags & XBF_STALE);
> > > > -		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
> > > > -
> > > > -		trace_xfs_buf_item_unpin_stale(bip);
> > > > -
> > > > -		if (remove) {
> > > > -			/*
> > > > -			 * If we are in a transaction context, we have to
> > > > -			 * remove the log item from the transaction as we are
> > > > -			 * about to release our reference to the buffer.  If we
> > > > -			 * don't, the unlock that occurs later in
> > > > -			 * xfs_trans_uncommit() will try to reference the
> > > > -			 * buffer which we no longer have a hold on.
> > > > -			 */
> > > > -			if (!list_empty(&lip->li_trans))
> > > > -				xfs_trans_del_item(lip);
> > > > -
> > > > -			/*
> > > > -			 * Since the transaction no longer refers to the buffer,
> > > > -			 * the buffer should no longer refer to the transaction.
> > > > -			 */
> > > > -			bp->b_transp = NULL;
> > > > +	if (!stale) {
> > > > +		if (!remove) {
> > > > +			/* Nothing to do but drop the refcount the pin owned. */
> > > > +			atomic_dec(&bip->bli_refcount);
> > > > +			return;
> > > >  		}
> > > 
> > > Hmm.. this seems a bit wonky to me. This code historically acts on the
> > > drop of the final reference to the bli.
> > 
> > Yes, and that's the problem that needs fixing. The AIL needs a
> > reference so that we aren't racing with writeback from the AIL to
> > free the object because both sets of code run without actually
> > holding an active reference to the BLI...
> > 
> > > This is not critical for the
> > > common (!stale && !remove) case because that's basically a no-op here
> > > outside of dropping the reference, and it looks like the stale buffer
> > > handling code further down continues to follow that model, but in this
> > > branch it seems we're trying to be clever in how the reference is
> > > managed and as a result can act on a bli that might actually have
> > > additional references.
> > 
> > Who cares? If something else has active references, then we must not
> > free the bli or buffer here, anyway. The lack of active references
> > by active BLI usres is why we keep getting use-after-free bugs in
> > this code.....
> > 
> 
> Well, this impacts more than just whether we free the buffer or not in
> the abort case. This potentially runs the I/O failure sequence on a
> pinned buffer, or blocks log I/O completion on a buffer lock that might
> be held by a transaction.
> 
> I don't know if these are immediate problems or not and this is all
> abort/shutdown related, but re: my point above around shutdown issues,
> I'd prefer to try and avoid these kind of oddball quirks if we can vs.
> just replace the historical quirks with new ones.
> 
> > > If so, I don't think it's appropriate to run
> > > through the error sequence that follows.
> > > 
> > > >  
> > > >  		/*
> > > > -		 * If we get called here because of an IO error, we may or may
> > > > -		 * not have the item on the AIL. xfs_trans_ail_delete() will
> > > > -		 * take care of that situation. xfs_trans_ail_delete() drops
> > > > -		 * the AIL lock.
> > > > -		 */
> > > > -		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
> > > > -			xfs_buf_item_done(bp);
> > > > -			xfs_buf_inode_iodone(bp);
> > > > -			ASSERT(list_empty(&bp->b_li_list));
> > > > -		} else {
> > > > -			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
> > > > -			xfs_buf_item_relse(bp);
> > > > -			ASSERT(bp->b_log_item == NULL);
> > > > -		}
> > > > -		xfs_buf_relse(bp);
> > > > -	} else if (freed && remove) {
> > > > -		/*
> > > > +		 * Fail the IO before we drop the bli refcount. This guarantees
> > > > +		 * that a racing writeback completion also failing the buffer
> > > > +		 * and running completion will not remove the last reference to
> > > > +		 * the bli and free it from under us.
> > > > +		 *
> > > >  		 * The buffer must be locked and held by the caller to simulate
> > > >  		 * an async I/O failure.
> > > >  		 */
> > > > @@ -559,7 +555,62 @@ xfs_buf_item_unpin(
> > > >  		xfs_buf_hold(bp);
> > > >  		bp->b_flags |= XBF_ASYNC;
> > > >  		xfs_buf_ioend_fail(bp);
> > > > +		xfs_buf_item_relse(bp);
> > > 
> > > Did you mean for this to be xfs_buf_item_put() instead of _relse()? The
> > 
> > Yes. I did say "untested" which implies the patch isn't complete or will
> > work. It's just a demonstration of how this reference counting might
> > be done, not a complete, working solution. Patches are a much faster
> > way of explaining the overall solution that plain text...
> > 
> 
> Sure, I'm just trying to clarify intent. It's a refcount patch so
> whether we drop a refcount or explicitly free an objects is particularly
> relevant. ;)
> 
> > > >  	}
> > > > +
> > > > +	/*
> > > > +	 * Stale buffer - only process it if this is the last reference to the
> > > > +	 * BLI. If this is the last BLI reference, then the buffer will be
> > > > +	 * locked and have two references - once from the transaction commit and
> > > > +	 * one from the BLI - and we do not unlock and release transaction
> > > > +	 * reference until we've finished cleaning up the BLI.
> > > > +	 */
> > > > +	if (!atomic_dec_and_test(&bip->bli_refcount))
> > > > +		return;
> > > > +
> > > 
> > > If the buffer is stale, will this ever be the last reference now that
> > > _item_committed() bumps the refcount?
> > 
> > If the AIL has a reference, then no.
> > 
> 
> Ok, but how would we get here without an AIL reference? That seems
> impossible to me based on your patch.
> 
> > > This change also seems to have
> > > ramifications for the code that follows, such as if a staled buffer is
> > > already in the AIL (with a bli ref), would this code ever get to the
> > > point of removing it?
> > 
> > That's easy enough to handle - if the buffer is stale and we are in
> > this code, we hold the buffer locked. Hence we can remove from the
> > AIL if it is in the AIL and drop that reference, too. Indeed, this
> > code already does the AIL removal, so all this requires is a simple
> > rearrangement of the logic in this function....
> > 
> 
> Hmm, I don't think that's a correct assertion. If the buffer is stale
> and we're in this code and we have the last reference to the bli, then
> we know we hold the buffer locked. Otherwise, ISTM we can get here while
> the transaction that staled the buffer might still own the lock.
> 
> > The only difference is that we have to do this before we drop the
> > current reference we have on the BLI, which is not what we do now
> > and that's where all the problems lie.
> > 
> > > All in all, I'll reiterate that I think it would be nice to fix up the
> > > bli reference count handling in general, but I think the scope and
> > > complexity of that work is significantly beyond what is reasonably
> > > necessary to fix this bug.
> > 
> > And so leaving the underlying problem in the code for the next set
> > of changes someone does to trigger the problem in a differen way.
> > We've indentified what the root cause is, so can we please spend
> > the time to fix it properly?
> > 
> 
> That is not what I'm saying at all. I'm saying that I'd prefer to fix
> the bug first and then step back and evaluate the overall refcount
> design independently because the latter is quite complex and there are
> all kinds of subtle interactions that the RFC patch just glazes over (by
> design). For example, how log recovery processes bli's slightly
> differently looks like yet another impedence mismatch from when the fs
> is fully active.
> 

Just an update on this particular bit...

I've probably spent about a week and a half now working through some
attempts to rework the bli refcount handling (going back to the drawing
board at least a couple times) and while I can get to something mostly
functional (surviving an fstests run), the last steps to test/prove a
solid/reliable implementation end up falling short. On extended testing
I end up sorting through the same kind of shutdown/unmount hang, use
after free, extremely subtle interactions that I've spent many hours
trying to stamp out over the past several years.

Because of that, I don't think this is something worth pushing for in
the short term. While the proposed idea sounds nice in theory, my take
away in practice is that the current design is in place for a reason
(i.e. the refcount historically looks like a transaction reference count
used to provide unlocked/isolated access through the log subsystem as
opposed to a traditional memory object lifecycle reference count) and
has quite a lot of incremental stability that has been baked in over
time.

I do still think this is (or should be :P) ultimately fixable, but I'm
wondering if we're probably better served by exploring some of the
historical warts and subtle rules/dependencies/hurdles of the current
model to see if they can be removed or simplified to the point where the
reference counting incrementally and naturally becomes a bit more
straightforward. I probably need to reset my brain and think a little
more about that...

Brian

> So I propose to rework my patch a bit into something that reflects the
> intended direction (see below for an untested diff) and proceed from
> there...
> 
> Brian
> 
> --- 8< ---
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

