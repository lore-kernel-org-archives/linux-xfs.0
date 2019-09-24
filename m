Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D28C432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 08:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB10C214AF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 08:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504052AbfIXIHq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 04:07:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47162 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504051AbfIXIHq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 04:07:46 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1F5B1C057867
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2019 08:07:45 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id j125so568034wmj.6
        for <linux-xfs@vger.kernel.org>; Tue, 24 Sep 2019 01:07:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=1t+4sNtHIsVi2BalcsJqVAChGEHrq5kae3ZRrYsotKA=;
        b=Fr04smrJjmeSyy5MRMeY+mJP43X0HNFkY4CtfhxAf/wb64KbDfNesAr2+Q72hGTWi3
         QbwryFvK85MWbRIiE7hXG2+kf2vx8tszp+jcs9B5AsBMCk7HmVDweX9TM5sI+eZC3eYr
         8bCPvh97PE/q2LG6yo3LzgU7UIuOwZYU9mBAkv+XWPBCo7X3xTUl/xneCfhus2+Y1nO/
         jVCroB/XDkEI8azkVKR3GWGEUw+LO1MuxE8A3zI6SdPsLJXZowi/7SKYjJJaMLbQENEC
         rHOfYutdvjQFoCQmcTW2UndFiGp8Loa2SEhdKyQXWQSyT0FVAQO7ggP5XnqVjiIF8I7r
         I7QA==
X-Gm-Message-State: APjAAAXkbHISX9D0TyGdjgltmDVIC6swzf+Dv7FFm1gunnc7tbvA5h52
        jdXIqI/M5rZHejm9RNVNjeD8DUy1OMtnI2j5mhQsSW2V87aishNJuIVg5sYVUmBT+30S4V9BdKx
        KhjLV77aBxAgeyDucL/n8
X-Received: by 2002:adf:f502:: with SMTP id q2mr1246214wro.186.1569312463790;
        Tue, 24 Sep 2019 01:07:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwV9Bk+dI6Dalw0B1Ty1o/8dePuWcdjlB6xsJ7e2saAqJCgevVPPbnqZSu35gImPSAxjchR4Q==
X-Received: by 2002:adf:f502:: with SMTP id q2mr1246198wro.186.1569312463537;
        Tue, 24 Sep 2019 01:07:43 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id o12sm1789873wrm.23.2019.09.24.01.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 01:07:42 -0700 (PDT)
Date:   Tue, 24 Sep 2019 10:07:41 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/2] xfs: Limit total allocation request to maximum
 possible
Message-ID: <20190924080740.d2kutzoap5eigx5k@pegasus.maiolino.io>
Mail-Followup-To: Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
References: <20190918082453.25266-1-cmaiolino@redhat.com>
 <20190918082453.25266-3-cmaiolino@redhat.com>
 <20190918122859.GB29377@bfoster>
 <20190923123934.6zigycei3nmwi54x@pegasus.maiolino.io>
 <20190923131136.GA9071@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923131136.GA9071@bfoster>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 23, 2019 at 09:11:36AM -0400, Brian Foster wrote:
> On Mon, Sep 23, 2019 at 02:39:34PM +0200, Carlos Maiolino wrote:
> > On Wed, Sep 18, 2019 at 08:28:59AM -0400, Brian Foster wrote:
> > > On Wed, Sep 18, 2019 at 10:24:53AM +0200, Carlos Maiolino wrote:
> > > > The original allocation request may have a total value way beyond
> > > > possible limits.
> > > > 
> > > > Trim it down to the maximum possible if needed
> > > > 
> > > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > > ---
> > > 
> > > Confused.. what was wrong with the original bma.total patch that it
> > > needs to be replaced?
> > 
> > At this point in time, what you mean by the 'original' patch? :) Yours? Or
> > Dave's?
> > 
> 
> The original patch I posted..
> 
> > If you meant yours, I was just trying to find out a way to fix it without
> > modifying the callers, nothing else than that.
> > 
> > If you meant regarding Dave's proposal, as he tagged his proposal as a /* Hack
> > */, I was just looking for ways to change total, instead of cropping it to 0.
> > 
> > And giving the fact args.total > blen seems unreasonable, giving it will
> > certainly tail here, I just thought it might be a reasonable way to change
> > args.total value.
> > 
> 
> I think the code is flaky, but I'm not sure why that's unreasonable. The
> intent of args.total is to be larger than the mapping length.
> 
> > By no means this patchset was meant to supersede yours or Dave's idea though, I
> > was just looking for a different approach, if feasible.
> > 
> > 
> > > I was assuming we'd replace the allocation retry
> > > patch with the minlen alignment fixups and combine those with the
> > > bma.total patch to fix the problem. Hm?
> > > 
> > > >  fs/xfs/libxfs/xfs_bmap.c | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > > index 07aad70f3931..3aa0bf5cc7e3 100644
> > > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > > @@ -3477,6 +3477,11 @@ xfs_bmap_btalloc(
> > > >  			error = xfs_bmap_btalloc_filestreams(ap, &args, &blen);
> > > >  		else
> > > >  			error = xfs_bmap_btalloc_nullfb(ap, &args, &blen);
> > > > +
> > > > +		/* We can never have total larger than blen, so trim it now */
> > > > +		if (args.total > blen)
> > > > +			args.total = blen;
> > > > +
> > > 
> > > I don't think this is safe. The reason the original patch only updated
> > > certain callers is because those callers only used it for extra blocks
> > > that are already incorported into bma.minleft by the bmap layer itself.
> > > There are still other callers for which bma.total is specifically
> > > intended to be larger than the map size.
> > 
> > Afaik, yes, but still, total is basically used to attempt an allocation of data
> > + metadata on the same AG if possible, reducing args.total to match blen, the
> > 'worst' case would be to have an allocation of data + metadata on different ags,
> > which, if total is larger than blen, it will fall into that behavior anyway.
> > 
> 
> Maybe..? There is no requirement that the additional blocks accounted by
> args.total be contiguous with the allocation for the mapping, so I don't
> see how you could reliably predict that.

I'm not predicting, {bma,ap}.total is basically:
data size requested + all metadata space it may need, so the original request
can try to allocate everything as close as possible. And, if not possible, we
give up on it by reducing .total.

One of the issues here, is that we reduce .total maybe 'too late', when we
consider it already LOW SPACE mode, that's why Dave's fix does not 'fix' the
original problem without zeroing .total.
My patch was just an attempt to use a different approach to round down .total to
a reasonable size, without messing with the callers of xfs_bmap_alloc().
Anyway, again, I'm not saying my patch is the right approach. I was just trying
a different one.


> 
> Brian
> 
> > 
> > > 
> > > Brian
> > > 
> > > >  		if (error)
> > > >  			return error;
> > > >  	} else if (ap->tp->t_flags & XFS_TRANS_LOWMODE) {
> > > > -- 
> > > > 2.20.1
> > > > 
> > 
> > -- 
> > Carlos

-- 
Carlos
