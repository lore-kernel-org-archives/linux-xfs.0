Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52089C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 14:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B79561411
	for <linux-xfs@archiver.kernel.org>; Wed, 12 May 2021 14:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbhELO3T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 May 2021 10:29:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbhELO3S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 May 2021 10:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620829690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LyZ47sX/6412SKdBufOemnskqP9TK1KpaNeuclMk/uA=;
        b=R3b42q74XAuwmzLsX5okMP/Yb1glEJlb0LS4efRJS1iwSq19EI9yKPXIrfNbIGwDLPkoPA
        LqwjvgATNjX5c6nKy06mLR74GXBThvkzkTO0qW+pCLmsoPxZnZeKgkbtXaT84MrXMlun6T
        tiWjlY7d213WXSYZokYp84npPOUfbok=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-FNbP-PFgMZicow_eKF5NcA-1; Wed, 12 May 2021 10:28:08 -0400
X-MC-Unique: FNbP-PFgMZicow_eKF5NcA-1
Received: by mail-qt1-f198.google.com with SMTP id d13-20020a05622a05cdb02901c2cffd946bso15891373qtb.23
        for <linux-xfs@vger.kernel.org>; Wed, 12 May 2021 07:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LyZ47sX/6412SKdBufOemnskqP9TK1KpaNeuclMk/uA=;
        b=FdazRzwcE35RrGTjTy3JqDwMiv6hWCaBWRCTVZQaNWNQ/qAjElU/a1ZxgUahHrm5Uh
         OMQv4w3JagdDgd7zY+5aDSI0pV07X3pi2hT+ykeuyDQz/pq225SIBBlmj1guODH4nhMJ
         nnerv9qQXQM34XssZrVz9x6bUejAffliqSudoj9tiG9zlw9fbTqsobxaOjuQ0O65vOY4
         r58apXY4jM3wMLPBNKxN5CgPb+Zlb30IIP553Kbye8XnAqg70FHzIFPNWfAw435Q7Tc0
         sxgU55jQ9edc3RDxBeq3tLeQS7cqQo2+bgtmnrMTX8jDP4vEH3wMK9mvqfGSDqU2K09Z
         bbqw==
X-Gm-Message-State: AOAM5338t5p0jUKhikjgsynG0YPvsC+/HUg5ShwIAA1LNPHIZDsH6ysE
        IAS4bNqwPF2Uh3LsMqLSahxRYhrXv42i8yt56oLGr+DKr7LlYUYJq+MSZYOxKn2A/qcKxlENx2w
        G1XqKlN+OGt+R4YIaNjqL
X-Received: by 2002:a05:622a:1650:: with SMTP id y16mr26882571qtj.385.1620829687965;
        Wed, 12 May 2021 07:28:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx+5Oo+lTkncHiRT4tOHmf4cp0pMumdPLW1dsgyGTkddhGjztA0BLfqzvyEFuFFBWUF1P8poA==
X-Received: by 2002:a05:622a:1650:: with SMTP id y16mr26882552qtj.385.1620829687720;
        Wed, 12 May 2021 07:28:07 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id z4sm95650qtv.7.2021.05.12.07.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 07:28:07 -0700 (PDT)
Date:   Wed, 12 May 2021 10:28:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: hold buffer across unpin and potential shutdown
 processing
Message-ID: <YJvl9KQOi4Hk8WXX@bfoster>
References: <20210511135257.878743-1-bfoster@redhat.com>
 <20210511135257.878743-2-bfoster@redhat.com>
 <20210512015244.GW8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512015244.GW8582@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 06:52:44PM -0700, Darrick J. Wong wrote:
> On Tue, May 11, 2021 at 09:52:56AM -0400, Brian Foster wrote:
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
> > 
> > To avoid this problem, grab a hold on the buffer before the log item
> > is unpinned if the associated item has been aborted and will require
> > a simulated I/O failure. The hold is already required for the
> > simulated I/O failure, so the ordering simply guarantees the unpin
> > handler access to the buffer before it is unpinned and thus
> > processed by the AIL. This particular ordering is required so long
> > as the AIL does not acquire a reference on the bli, which is the
> > long term solution to this problem.
> 
> Are you working on that too, or are we just going to let that lie for
> the time being? :)
> 

It's on my todo list. I need to think about it some more to consider the
functional change to the unpin code and other potential
incompatibilities if the writeback completion code assumes the AIL has a
reference, etc. This patch is an extremely isolated bug fix whereas the
above is a bit broader of a rework to address a design flaw. I'd prefer
not to conflate the two things unless absolutely necessary.

> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_buf_item.c | 37 +++++++++++++++++++++----------------
> >  1 file changed, 21 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index fb69879e4b2b..7ff31788512b 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -475,17 +475,8 @@ xfs_buf_item_pin(
> >  }
> >  
> >  /*
> > - * This is called to unpin the buffer associated with the buf log
> > - * item which was previously pinned with a call to xfs_buf_item_pin().
> > - *
> > - * Also drop the reference to the buf item for the current transaction.
> > - * If the XFS_BLI_STALE flag is set and we are the last reference,
> > - * then free up the buf log item and unlock the buffer.
> > - *
> > - * If the remove flag is set we are called from uncommit in the
> > - * forced-shutdown path.  If that is true and the reference count on
> > - * the log item is going to drop to zero we need to free the item's
> > - * descriptor in the transaction.
> > + * This is called to unpin the buffer associated with the buf log item which
> > + * was previously pinned with a call to xfs_buf_item_pin().
> >   */
> >  STATIC void
> >  xfs_buf_item_unpin(
> > @@ -502,12 +493,26 @@ xfs_buf_item_unpin(
> >  
> >  	trace_xfs_buf_item_unpin(bip);
> >  
> > +	/*
> > +	 * Drop the bli ref associated with the pin and grab the hold required
> > +	 * for the I/O simulation failure in the abort case. We have to do this
> > +	 * before the pin count drops because the AIL doesn't acquire a bli
> > +	 * reference. Therefore if the refcount drops to zero, the bli could
> > +	 * still be AIL resident and the buffer submitted for I/O (and freed on
> > +	 * completion) at any point before we return. This can be removed once
> > +	 * the AIL properly holds a reference on the bli.
> > +	 */
> >  	freed = atomic_dec_and_test(&bip->bli_refcount);
> > -
> > +	if (freed && !stale && remove)
> > +		xfs_buf_hold(bp);
> >  	if (atomic_dec_and_test(&bp->b_pin_count))
> >  		wake_up_all(&bp->b_waiters);
> >  
> > -	if (freed && stale) {
> > +	 /* nothing to do but drop the pin count if the bli is active */
> > +	if (!freed)
> > +		return;
> 
> Hmm, this all seems convoluted as promised, but if I'm reading the code
> correctly, you're moving the buffer hold above where we wake the
> pincount waiters, because the AIL could be in xfs_buf_wait_unpin,
> holding the only reference?  So if we wake it and the write is quick,
> the AIL's ioend will nuke the buffer before this thread (which is trying
> to kill a transaction and shut down the system?) gets a chance to
> free the buffer via _buf_ioend_fail?
> 

Mostly.. this code isn't trying to kill a transaction, it just needs to
process the buffer in the event that logging it failed. The non-failure
case here is that the final bli reference drops in this unpin code, but
the bli reference count does not historically govern the life cycle of
the bli object. Instead, the item stays around in the AIL with refcount
== 0 until the buffer is eventually written back. This can only occur
when xfsaild locks an unpinned buffer, so sort of by proxy (because a
pin elevates bli_refcount) this allows writeback completion to
explicitly free the bli.

IOW, I suspect yet another potential solution to this particular problem
is to check whether the item is in the AIL in the event of an unpin
abort and use that to decide who actually is responsible for the
bli/buffer. I've tested something along those lines in the past as well,
but it's pretty much logically equivalent to this patch so I'm not sure
it's worth exploring further.

Brian

> If I got that right,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> 
> > +
> > +	if (stale) {
> >  		ASSERT(bip->bli_flags & XFS_BLI_STALE);
> >  		ASSERT(xfs_buf_islocked(bp));
> >  		ASSERT(bp->b_flags & XBF_STALE);
> > @@ -550,13 +555,13 @@ xfs_buf_item_unpin(
> >  			ASSERT(bp->b_log_item == NULL);
> >  		}
> >  		xfs_buf_relse(bp);
> > -	} else if (freed && remove) {
> > +	} else if (remove) {
> >  		/*
> >  		 * The buffer must be locked and held by the caller to simulate
> > -		 * an async I/O failure.
> > +		 * an async I/O failure. We acquired the hold for this case
> > +		 * before the buffer was unpinned.
> >  		 */
> >  		xfs_buf_lock(bp);
> > -		xfs_buf_hold(bp);
> >  		bp->b_flags |= XBF_ASYNC;
> >  		xfs_buf_ioend_fail(bp);
> >  	}
> > -- 
> > 2.26.3
> > 
> 

