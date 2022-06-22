Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B8FCCA482
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 16:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376621AbiFVQOM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 12:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376484AbiFVQOB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 12:14:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E40FE31343
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 09:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655914439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j4dmxFjzXfBDQwLdUryT4oOxAKinNtUU5vSf/9cHQdg=;
        b=iUMmO9kIInK8YsrpyLCxVpWR90A/nIGHZ5+htZsiBGXgSqU39Rs5DFbXzx2RCODcIWtn5c
        pxPbvo/uPW76LRvlzeOXAQiduqtiLd8xFyqPi+jNnk/J5DILmDYPN5nKaok5I8BR8OCLva
        b5d9aM3PlwZRanLIxtnKuyRTJAc+q8U=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-387-f1CSuT9jOEq-Fhvn2c09zg-1; Wed, 22 Jun 2022 12:13:58 -0400
X-MC-Unique: f1CSuT9jOEq-Fhvn2c09zg-1
Received: by mail-qk1-f200.google.com with SMTP id bk10-20020a05620a1a0a00b006a6b1d676ebso20533356qkb.0
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jun 2022 09:13:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j4dmxFjzXfBDQwLdUryT4oOxAKinNtUU5vSf/9cHQdg=;
        b=L5u3GjjQrASzi2rj2CMWyp9sFaUK1locc8WI4ZNAuC8WTK4xu0QuOzQEIfggmBqjNw
         ebOuXDx593X6GsnyTvncMDdm97fAAbw04FRihp+8n5KpbdyMqBBdz9WrIG2scvL0/6gJ
         n3eevZF54LUls6snxsXYswlW9BCxQhMU1CG2MlOwMKJVV7Gu2WTNkkAnnCRuGxDKnl9O
         STthSvfAvR6v4Pbdwey4w5j+3IHotZ1NfxynVAg980LPxzafoAVJcbDgQdXT03ihxJRz
         DcRLy/0GlRjlI68N1fvOKRDu+tAIQ+/ztJoEyjjJUVHUijUkS5GsgKbuXOtmJsEm2uOu
         ltaA==
X-Gm-Message-State: AJIora8uKnCmiPqhvHLFGWxoEMOySpjBaXvAq9fh5HLinu6GXdGHA9DA
        BRQ+hSN4s95B/QLEhcUxZgtFv8cRedur4Huj8BPWtInaWP78Avm7VAQiuEM9zlUB3UJlIW7MUvX
        Ej34wF+7Lim4qbcNn1Fjr
X-Received: by 2002:ac8:5b50:0:b0:305:3275:b9bf with SMTP id n16-20020ac85b50000000b003053275b9bfmr3767296qtw.498.1655914437396;
        Wed, 22 Jun 2022 09:13:57 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vvYo128voaz85ID6pGNFQoDJrwPT6hFad7TX2EHuD2/3BMJr5vyUeadLqVhJq9/9VwlSCBzQ==
X-Received: by 2002:ac8:5b50:0:b0:305:3275:b9bf with SMTP id n16-20020ac85b50000000b003053275b9bfmr3767242qtw.498.1655914436663;
        Wed, 22 Jun 2022 09:13:56 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id j17-20020a05620a289100b0069fc13ce20asm17078563qkp.59.2022.06.22.09.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 09:13:56 -0700 (PDT)
Date:   Wed, 22 Jun 2022 12:13:54 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: bound maximum wait time for inodegc work
Message-ID: <YrM/woFhObNYQx3b@bfoster>
References: <20220615220416.3681870-1-david@fromorbit.com>
 <20220615220416.3681870-2-david@fromorbit.com>
 <YqytHuc/sJprFn0K@bfoster>
 <20220617215245.GH227878@dread.disaster.area>
 <YrKmrgJh9+SzT0Gz@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrKmrgJh9+SzT0Gz@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 21, 2022 at 10:20:46PM -0700, Darrick J. Wong wrote:
> On Sat, Jun 18, 2022 at 07:52:45AM +1000, Dave Chinner wrote:
> > On Fri, Jun 17, 2022 at 12:34:38PM -0400, Brian Foster wrote:
> > > On Thu, Jun 16, 2022 at 08:04:15AM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Currently inodegc work can sit queued on the per-cpu queue until
> > > > the workqueue is either flushed of the queue reaches a depth that
> > > > triggers work queuing (and later throttling). This means that we
> > > > could queue work that waits for a long time for some other event to
> > > > trigger flushing.
> > > > 
> > > > Hence instead of just queueing work at a specific depth, use a
> > > > delayed work that queues the work at a bound time. We can still
> > > > schedule the work immediately at a given depth, but we no long need
> > > > to worry about leaving a number of items on the list that won't get
> > > > processed until external events prevail.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++--------------
> > > >  fs/xfs/xfs_mount.h  |  2 +-
> > > >  fs/xfs/xfs_super.c  |  2 +-
> > > >  3 files changed, 24 insertions(+), 16 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > index 374b3bafaeb0..46b30ecf498c 100644
> > > > --- a/fs/xfs/xfs_icache.c
> > > > +++ b/fs/xfs/xfs_icache.c
> > > ...
> > > > @@ -2176,7 +2184,7 @@ xfs_inodegc_shrinker_scan(
> > > >  			unsigned int	h = READ_ONCE(gc->shrinker_hits);
> > > >  
> > > >  			WRITE_ONCE(gc->shrinker_hits, h + 1);
> > > > -			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
> > > > +			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
> > > >  			no_items = false;
> > > >  		}
> > > 
> > > This all seems reasonable to me, but is there much practical benefit to
> > > shrinker infra/feedback just to expedite a delayed work item by one
> > > jiffy? Maybe there's a use case to continue to trigger throttling..?
> > 
> > I haven't really considered doing anything other than fixing the
> > reported bug. That just requires an API conversion for the existing
> > "queue immediately" semantics and is the safest minimum change
> > to fix the issue at hand.
> > 
> > So, yes, the shrinker code may (or may not) be superfluous now, but
> > I haven't looked at it and done analysis of the behaviour without
> > the shrinkers enabled. I'll do that in a completely separate
> > patchset if it turns out that it is not needed now.
> 
> I think the shrinker part is still necessary -- bulkstat and xfs_scrub
> on a very low memory machine (~560M RAM) opening and closing tens of
> millions of files can still OOM the machine if one doesn't have a means
> to slow down ->destroy_inode (and hence the next open()) when reclaim
> really starts to dig in.  Without the shrinker bits, it's even easier to
> trigger OOM storms when xfs has timer-delayed inactivation... which is
> something that Brian pointed out a year ago when we were reviewing the
> initial inodegc patchset.
> 

It wouldn't surprise me if the infrastructure is still necessary for the
throttling use case. In that case, I'm more curious about things like
whether it's still as effective as intended with such a small scheduling
delay, or whether it still might be worth simplifying in various ways
(i.e., does the scheduling delay actually make a difference? do we still
need a per cpu granular throttle? etc.).

> > > If
> > > so, it looks like decent enough overhead to cycle through every cpu in
> > > both callbacks that it might be worth spelling out more clearly in the
> > > top-level comment.
> > 
> > I'm not sure what you are asking here - mod_delayed_work_on() has
> > pretty much the same overhead and behaviour as queue_work() in this
> > case, so... ?
> 

I'm just pointing out that the comment around the shrinker
infrastructure isn't very informative if the shrinker turns out to still
be necessary for reasons other than making the workers run sooner.

> <shrug> Looks ok to me, since djwong-dev has had some variant of timer
> delayed inactivation in it longer than it hasn't:
> 

Was that with a correspondingly small delay or something larger (on the
order of seconds or so)? Either way, it sounds like you have a
predictable enough workload that can actually test this continues to
work as expected..?

Brian

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

