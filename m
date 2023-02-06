Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10895C05027
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Feb 2023 23:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjBFXWQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Feb 2023 18:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBFXWP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Feb 2023 18:22:15 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD852279AA
        for <linux-xfs@vger.kernel.org>; Mon,  6 Feb 2023 15:22:14 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id f16-20020a17090a9b1000b0023058bbd7b2so12382901pjp.0
        for <linux-xfs@vger.kernel.org>; Mon, 06 Feb 2023 15:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WtAMKw0pnM/b33X0pUdz85s/W0M2RGMc1YX/Fyt/3eg=;
        b=DOM/vuzZ20lueGHd2TsT9xqcn0+MPN6JsrMq4kfiUcZG4xzJv/GnBy/xULLbZ5AbPt
         Do4zuetjYS3MwHH2QPxWMW1ahaWroLHrxZG1M28Ko+5H6Cqzme7PXukDVfU7w7bacvSu
         IQ9Y9mxttTjx/hiWUX6VAdaR8qxO+bOy+KVSjGUqhMaejzAZrhjFNpsKnobaAKSp7gig
         Wf5Y/V1WIYEesYCDifQWYaeOd9UXMaC0YLKuAdRCum9WYDg0UCyghM2fOBtIjGZG7Dx3
         rkr8xdeinxwqEk2dE+sRgFuFB+PvcM+wx+NAmH7XbfbX00pSeuraEBmFOhArr97BnajQ
         Zcaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WtAMKw0pnM/b33X0pUdz85s/W0M2RGMc1YX/Fyt/3eg=;
        b=4x8gHf0HNUDiaFubbCIWrKAb4NlM4yJb0EHGqoMHqv+SzmqBcdhsZxA80OupgtErAl
         y/dP+YvAnTcXOqQ2et14Sklk9eOS4/KSz0k+cVkp4aGrvskNIvEFLSe7ssN/GHcIvHC0
         1IN39RbZad7WCEW3Cb/tlLzOq9F3bQd5zANHP3dASw3Gy3Lvxx/ALCEJqNO0UexPpx8K
         MZ2IBl6TbOX4S2JzN1Y+nd6dGPlLXd7kN+It4uY6QbZaiHcXcl0QaKpTvHhgYiBVd3c7
         qLaEOIWt8FbrM6/ULL3sW61mM3UGtt8/dnqGfFJCR4iXD9feP0Gbdmr1YZQO2O3KyXRk
         L9Fw==
X-Gm-Message-State: AO0yUKXzACTVJxhdWhJPSVeItsW0UCYtgGxvjui6oJiFyrMf25mQhloy
        49gIDpxll3REm8dApLxsQNCl8rWsj6009ee2
X-Google-Smtp-Source: AK7set/n8VIH4rQiV25Ia8/DiNS8ltXpCIfTCHyVcuxAibq5VOak+yVT6KL9/PaUObr3mtoGRexFvw==
X-Received: by 2002:a17:90b:3e81:b0:230:d786:4a10 with SMTP id rj1-20020a17090b3e8100b00230d7864a10mr1455477pjb.20.1675725734173;
        Mon, 06 Feb 2023 15:22:14 -0800 (PST)
Received: from dread.disaster.area (pa49-181-4-128.pa.nsw.optusnet.com.au. [49.181.4.128])
        by smtp.gmail.com with ESMTPSA id p19-20020a637413000000b00477def759cbsm6665881pgc.58.2023.02.06.15.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 15:22:13 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pPAoN-00CE1z-22; Tue, 07 Feb 2023 10:22:11 +1100
Date:   Tue, 7 Feb 2023 10:22:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 41/42] xfs: return a referenced perag from filestreams
 allocator
Message-ID: <20230206232211.GA360264@dread.disaster.area>
References: <20230118224505.1964941-1-david@fromorbit.com>
 <20230118224505.1964941-42-david@fromorbit.com>
 <Y9r9VONw2JdhzTI6@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9r9VONw2JdhzTI6@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 01, 2023 at 04:01:24PM -0800, Darrick J. Wong wrote:
> On Thu, Jan 19, 2023 at 09:45:04AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that the filestreams AG selection tracks active perags, we need
> > to return an active perag to the core allocator code. This is
> > because the file allocation the filestreams code will run are AG
> > specific allocations and so need to pin the AG until the allocations
> > complete.
> > 
> > We cannot rely on the filestreams item reference to do this - the
> > filestreams association can be torn down at any time, hence we
> > need to have a separate reference for the allocation process to pin
> > the AG after it has been selected.
> > 
> > This means there is some perag juggling in allocation failure
> > fallback paths as they will do all AG scans in the case the AG
> > specific allocation fails. Hence we need to track the perag
> > reference that the filestream allocator returned to make sure we
> > don't leak it on repeated allocation failure.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c | 38 +++++++++++-----
> >  fs/xfs/xfs_filestream.c  | 93 ++++++++++++++++++++++++----------------
> >  2 files changed, 84 insertions(+), 47 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 098b46f3f3e3..7f56002b545d 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -3427,6 +3427,7 @@ xfs_bmap_btalloc_at_eof(
> >  	bool			ag_only)
> >  {
> >  	struct xfs_mount	*mp = args->mp;
> > +	struct xfs_perag	*caller_pag = args->pag;
> >  	int			error;
> >  
> >  	/*
> > @@ -3454,9 +3455,11 @@ xfs_bmap_btalloc_at_eof(
> >  		else
> >  			args->minalignslop = 0;
> >  
> > -		args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
> > +		if (!caller_pag)
> > +			args->pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ap->blkno));
> >  		error = xfs_alloc_vextent_exact_bno(args, ap->blkno);
> > -		xfs_perag_put(args->pag);
> > +		if (!caller_pag)
> > +			xfs_perag_put(args->pag);
> >  		if (error)
> >  			return error;
> >  
> > @@ -3482,10 +3485,13 @@ xfs_bmap_btalloc_at_eof(
> >  		args->minalignslop = 0;
> >  	}
> >  
> > -	if (ag_only)
> > +	if (ag_only) {
> >  		error = xfs_alloc_vextent_near_bno(args, ap->blkno);
> > -	else
> > +	} else {
> > +		args->pag = NULL;
> >  		error = xfs_alloc_vextent_start_ag(args, ap->blkno);
> > +		args->pag = caller_pag;
> 
> At first glance I wondered if we end up leaking any args->pag set by the
> _iterate_ags function, but I think it's the case that _finish will
> release args->pag and set it back to NULL?

*nod*

> So in effect we're
> preserving the caller's args->pag here, and nothing leaks.  In that
> case, I think we should check that assumption:
> 
> 		ASSERT(args->pag == NULL);
> 		args->pag = caller_pag;

Sure. I'm going to try to remove this conditional caller_pag
situation as we get further down the "per-ags everywhere" hole, but
for the moment this is a necessary quirk...

-Dave.

-- 
Dave Chinner
david@fromorbit.com
