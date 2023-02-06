Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B96C61DA4
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Feb 2023 23:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjBFXQq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Feb 2023 18:16:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjBFXQp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2023 18:16:45 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622FD468C
        for <linux-xfs@vger.kernel.org>; Mon,  6 Feb 2023 15:16:43 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so16781967pjq.0
        for <linux-xfs@vger.kernel.org>; Mon, 06 Feb 2023 15:16:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GnOKuRRq3lLy/4s5+WANppXrIhEwlqQ15JvlTG0QFPI=;
        b=xIV0AoytJR4a3iZvpRAI+SJF8eNJsJIU0cD6PF7cGBr9IcoCpmdsUcEx3blYWcFSzx
         grF9ACsJ05gPT7XmB21y+vE+LaBq7VNbU2dlvK/CRKAu+y4Vsj6hQuAGG/Nd+fP174yX
         xaAGbMRo737ZiNB/ktHkj+5v4BUtNSdbxnxXMMaTRWYdHP4I8z2YoxOjQ8fzUowihg78
         NXpqx3s38KcOtOma1KKm77Y64TwHO6x7CCxfEcMzUoY4q9tWa3hc1z/gWXAz+APre/h0
         8xF70/z8qIObnoisD83Kbp4NnPTgn2jgtmM38svDH1dRo5gYxJHgECnANQM5ObKjf7RI
         BQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GnOKuRRq3lLy/4s5+WANppXrIhEwlqQ15JvlTG0QFPI=;
        b=Q6BjKefMTMcFrWUh9vbT9lYWA97C9CWPz22/MkEC3YySzcigqcyJ3zTyIBLWr6rXpM
         kte7jkfP81sfBFeLTC25JXJCoWVnvprO75UUofiTp99y660MC2izN0WlZ2EEQFqIg1Qs
         hPL+hwY4yQ9AWJwNSQOcaQJIwayGTdJrIqmx1TjLzd5a3Oo17IsnXf5YTlIGqDOQVcDz
         r1wjFHpkWLeOBHcbyi61A0Pp4bCm7V3jgOJUuqUKpO5oUOqxxKmM8VUv2MntIaN0iI0P
         LHE8xdbSHbuH62AuZgjs/1Z0/J+8N3KFFaHzu+YtMJ6nrRrfk7+oBRu7RGfxRTpZpXGV
         Jj4w==
X-Gm-Message-State: AO0yUKXnxuJ67Mru0fxb5UZu1qY+H78ET9tgGesI3//MEgI9iXbIqv4U
        CGrMgNkMXuWf7jWFDeaYjq7omw==
X-Google-Smtp-Source: AK7set+h4bPTlBNj3H/jPB9bRb5xipSZhMgtQzjGf3UCyOK3cSxHVrp97kfOKVZJqZKZJEHI4ojryw==
X-Received: by 2002:a17:90a:188:b0:230:af67:b83c with SMTP id 8-20020a17090a018800b00230af67b83cmr1569761pjc.1.1675725402888;
        Mon, 06 Feb 2023 15:16:42 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id d188-20020a6336c5000000b004e52190d5a7sm6701614pga.11.2023.02.06.15.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 15:16:42 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pPAj1-00CDy4-7m; Tue, 07 Feb 2023 10:16:39 +1100
Date:   Tue, 7 Feb 2023 10:16:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/42] xfs: use xfs_alloc_vextent_first_ag() where
 appropriate
Message-ID: <20230206231639.GY360264@dread.disaster.area>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-21-david@fromorbit.com>
 <Y9rrAam9LzgERBYY@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9rrAam9LzgERBYY@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 01, 2023 at 02:43:13PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 19, 2023 at 09:44:43AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Change obvious callers of single AG allocation to use
> > xfs_alloc_vextent_first_ag(). This gets rid of
> > XFS_ALLOCTYPE_FIRST_AG as the type used within
> > xfs_alloc_vextent_first_ag() during iteration is _THIS_AG. Hence we
> > can remove the setting of args->type from all the callers of
> > _first_ag() and remove the alloctype.
> > 
> > While doing this, pass the allocation target fsb as a parameter
> > rather than encoding it in args->fsbno. This starts the process
> > of making args->fsbno an output only variable rather than
> > input/output.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 35 +++++++++++++++++++----------------
> >  fs/xfs/libxfs/xfs_alloc.h | 10 ++++++++--
> >  fs/xfs/libxfs/xfs_bmap.c  | 31 ++++++++++++++++---------------
> >  3 files changed, 43 insertions(+), 33 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 28b79facf2e3..186ce3aee9e0 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -3183,7 +3183,8 @@ xfs_alloc_read_agf(
> >   */
> >  static int
> >  xfs_alloc_vextent_check_args(
> > -	struct xfs_alloc_arg	*args)
> > +	struct xfs_alloc_arg	*args,
> > +	xfs_rfsblock_t		target)
> 
> Isn't xfs_rfsblock_t supposed to be used to measure quantities of raw fs
> blocks, and not the segmented agno/agbno numbers that we encode in most
> places?

Yup, just a minor braino. I'll fix those.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
