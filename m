Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF04C43460
	for <linux-xfs@archiver.kernel.org>; Fri,  7 May 2021 14:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BC376142D
	for <linux-xfs@archiver.kernel.org>; Fri,  7 May 2021 14:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbhEGOHh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 May 2021 10:07:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50885 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236526AbhEGOHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 May 2021 10:07:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620396396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H0yxuYRlP3+iPt7uZ1NnSJh0bsPRY20POyt9MhGs9mU=;
        b=AUrsscyeAOd4wWGxOMe6A1M3xJp5D1VwICyEMFAnmwb6SJ9WWQ/Nl5GQBKgIEIrxbruYh9
        G9r6Rtvkw8m01GP5D+MxJjx5RTWXoFev0SqLirKE6a08FIF+iELzhmOvF3jL6v7hqH6AZi
        s5ETv17Nd5XrBBoCPZsURJPrz4mEKZQ=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-522-z3gY2jLxO1WVTjZ6tGgesQ-1; Fri, 07 May 2021 10:06:34 -0400
X-MC-Unique: z3gY2jLxO1WVTjZ6tGgesQ-1
Received: by mail-qv1-f72.google.com with SMTP id a6-20020a0ce3460000b02901c4f39aa36aso6646558qvm.21
        for <linux-xfs@vger.kernel.org>; Fri, 07 May 2021 07:06:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H0yxuYRlP3+iPt7uZ1NnSJh0bsPRY20POyt9MhGs9mU=;
        b=MBPrO2nnKb6hgjpdtax4v04+mWzlSAGsg2K1tYxpKhtyT00zvNCfS47ZwNpBtIB9+g
         3xvhi6tY4+GkiJzLLCVammNqzQHMUf7Yw2YJf8ZpH2OrbCSkMbnVfQoUXc4pBHCTbDWT
         SWtHSM564pVeiFpEHGxvBV4TsjKW7B5/Gu/XwVQYe1kBe2h19rrP/4RxFpXg/5v7vQZZ
         LSTArd8g2gMdmXTk4fUbaQTqjpb7SP3FktW5FWbSlsD/63GHVNuI5rWOQ00DFFhFDdzM
         vArag1ZlFH7fINrXXNBXFg33tbOrnKyTT1OXcNr8k702Sw0JUB1lCqe6ZQb7hKI4s/ee
         PmHA==
X-Gm-Message-State: AOAM530NY4Kf06/1MstmB5XJNdVRTd4gEDZweMiWDK0RC7lfbjbYWbhG
        lTCuubqIsMn5H6/NMkS0lrJLCe6rakMq9OdKv2yqeRvkWr32hn2rH8EBCa+NwW1Pyai3ONjifvz
        1++0M1FbZG0DgNDCNRn1b
X-Received: by 2002:a37:7906:: with SMTP id u6mr9648058qkc.225.1620396394050;
        Fri, 07 May 2021 07:06:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx48YET6vi+LZAMlwiDbV06UePLTLFCXrP277hebn5XPcDNUyZLbSqjm4VhCN0FdxENPy6f9w==
X-Received: by 2002:a37:7906:: with SMTP id u6mr9648028qkc.225.1620396393800;
        Fri, 07 May 2021 07:06:33 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id w196sm4671399qkb.90.2021.05.07.07.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 07:06:33 -0700 (PDT)
Date:   Fri, 7 May 2021 10:06:31 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] xfs: kick extra large ioends to completion
 workqueue
Message-ID: <YJVJZzld5ucxnlAH@bfoster>
References: <20201002153357.56409-3-bfoster@redhat.com>
 <20201005152102.15797-1-bfoster@redhat.com>
 <20201006035537.GD49524@magnolia>
 <20201006124440.GA50358@bfoster>
 <20210506193158.GD8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506193158.GD8582@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 12:31:58PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 06, 2020 at 08:44:40AM -0400, Brian Foster wrote:
> > On Mon, Oct 05, 2020 at 08:55:37PM -0700, Darrick J. Wong wrote:
> > > On Mon, Oct 05, 2020 at 11:21:02AM -0400, Brian Foster wrote:
> > > > We've had reports of soft lockup warnings in the iomap ioend
> > > > completion path due to very large bios and/or bio chains. Divert any
> > > > ioends with 256k or more pages to process to the workqueue so
> 
> Heh, lol, so now we're hitting this internally too.  Certain customers
> are sending 580,000-page bios, which then trip the hangcheck timer when
> we stall the interrupt handler while clearing all the page bits.
> 

Yep, sounds about right. :P

> > > > completion occurs in non-atomic context and can reschedule to avoid
> > > > soft lockup warnings.
> > > 
> > > Hmmmm... is there any way we can just make end_page_writeback faster?
> > > 
> > 
> > I'm not sure that would help us. It's not doing much work as it is. The
> > issue is just that we effectively queue so many of them to a single bio
> > completion due to either bio chaining or the physical page merging
> > implemented by multipage bvecs.
> > 
> > > TBH it still strikes me as odd that we'd cap ioends this way just to
> > > cover for the fact that we have to poke each and every page.
> > > 
> > 
> > I suppose, but it's not like we don't already account for constructing
> > bios that must be handed off to a workqueue for completion processing.
> > Also FWIW this doesn't cap ioend size like my original patch does. It
> > just updates XFS to send them to the completion workqueue.
> 
> <nod> So I guess I'm saying that my resistance to /this/ part of the
> changes is melting away.  For a 2GB+ write IO, I guess the extra overhead
> of poking a workqueue can be amortized over the sheer number of pages.
> 

I think the main question is what is a suitable size threshold to kick
an ioend over to the workqueue? Looking back, I think this patch just
picked 256k randomly to propose the idea. ISTM there could be a
potentially large window from the point where I/O latency starts to
dominate (over the extra context switch for wq processing) and where the
softlockup warning thing will eventually trigger due to having too many
pages. I think that means we could probably use a more conservative
value, I'm just not sure what value should be (10MB, 100MB, 1GB?). If
you have a reproducer it might be interesting to experiment with that.

> > > (Also, those 'bool atomic' in the other patch make me kind of nervous --
> > > how do we make sure (from a QA perspective) that nobody gets that wrong?)
> > > 
> > 
> > Yeah, that's a bit ugly. If somebody has a better idea on the factoring
> > I'm interested in hearing about it. My understanding is that in_atomic()
> > is not reliable and/or generally frowned upon, hence the explicit
> > context parameter.
> > 
> > Also, I don't have the error handy but my development kernel complains
> > quite clearly if we make a call that can potentially sleep in atomic
> > context. I believe this is the purpose of the __might_sleep()
> > (CONFIG_DEBUG_ATOMIC_SLEEP) annotation.
> 
> I wonder if it's not too late to establish a new iomap rule?
> 
> All clients whose ->prepare_ioend handler overrides the default
> ioend->io_bio->bi_end_io handler must call iomap_finish_ioends from
> process context, because the "only" reason why a filesystem would need
> to do that is because some post-write metadata update is necessary, and
> those really shouldn't be running from interrupt context.
> 
> With such a rule (no idea how we'd enforce that) we could at least
> constrain that in_atomic variable to buffered-io.c, since the only time
> it would be unsafe to call cond_resched() is if iomap_writepage_end_bio
> is in use, and it decides to call iomap_finish_ioend directly.
> 

I'm not following if you mean to suggest to change what patch 1 does
somehow or another (it seems similar to what you're describing here) or
something else..?

Brian

> Right now XFS is the only filesystem that overrides the bio endio
> handler, and the only time it does that is for writes that need extra
> metadata updates (unwritten conversion, setfilesize, cow).
> 
> --D
> 
> > Brian
> > 
> > > --D
> > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > > 
> > > > v2:
> > > > - Fix type in macro.
> > > > 
> > > >  fs/xfs/xfs_aops.c | 10 +++++++++-
> > > >  1 file changed, 9 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > > > index 3e061ea99922..c00cc0624986 100644
> > > > --- a/fs/xfs/xfs_aops.c
> > > > +++ b/fs/xfs/xfs_aops.c
> > > > @@ -30,6 +30,13 @@ XFS_WPC(struct iomap_writepage_ctx *ctx)
> > > >  	return container_of(ctx, struct xfs_writepage_ctx, ctx);
> > > >  }
> > > >  
> > > > +/*
> > > > + * Kick extra large ioends off to the workqueue. Completion will process a lot
> > > > + * of pages for a large bio or bio chain and a non-atomic context is required to
> > > > + * reschedule and avoid soft lockup warnings.
> > > > + */
> > > > +#define XFS_LARGE_IOEND	(262144ULL << PAGE_SHIFT)
> > > > +
> > > >  /*
> > > >   * Fast and loose check if this write could update the on-disk inode size.
> > > >   */
> > > > @@ -239,7 +246,8 @@ static inline bool xfs_ioend_needs_workqueue(struct iomap_ioend *ioend)
> > > >  {
> > > >  	return ioend->io_private ||
> > > >  		ioend->io_type == IOMAP_UNWRITTEN ||
> > > > -		(ioend->io_flags & IOMAP_F_SHARED);
> > > > +		(ioend->io_flags & IOMAP_F_SHARED) ||
> > > > +		(ioend->io_size >= XFS_LARGE_IOEND);
> > > >  }
> > > >  
> > > >  STATIC void
> > > > -- 
> > > > 2.25.4
> > > > 
> > > 
> > 
> 

