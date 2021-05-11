Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BC8CC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 12:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44C756191C
	for <linux-xfs@archiver.kernel.org>; Tue, 11 May 2021 12:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhEKMau (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 May 2021 08:30:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230225AbhEKMat (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 08:30:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620736182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AWRpQD/T/1bRmomMaRTlDV288PsD4+2apMxzaPa8zUU=;
        b=JhEkSj5TWfGJ0UQ4O8aqbcRH39sc3IpriweS8kC4OWT5SVOsYBA5OlAyUPZp0pF3icqJ0b
        0Ry/PlLCOgcb4G/SMday6oG7h9foVrM5ARYD/SNZmUPEQPijCXn4VHcxemkai6CbHamSQ6
        HId6AN495q20wYJxw6/ozOpWVaWRkfg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-uvkUtu04P1G8_M6nHgdRKQ-1; Tue, 11 May 2021 08:29:41 -0400
X-MC-Unique: uvkUtu04P1G8_M6nHgdRKQ-1
Received: by mail-qt1-f200.google.com with SMTP id y10-20020a05622a004ab029019d4ad3437cso12901460qtw.12
        for <linux-xfs@vger.kernel.org>; Tue, 11 May 2021 05:29:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AWRpQD/T/1bRmomMaRTlDV288PsD4+2apMxzaPa8zUU=;
        b=pEP8SsxsAkP2Emb+5u2HVyv80R0Tt7N6Me3dsC7w8na5JQeiiyVOSWHkE/X7E4niA1
         sxNOBzp0ITQah+88f3Ey2P7xTcwVr59y/gQZBeaOUyVW3Qp/fiyN/wLTD7zIE8JHWLdX
         ylO2sD0nLYcA9pVfpabGVrHf6wxNPTSJcczrlKwchk4yZnfQkHNGoECZjb9ibaBmuOcU
         x2tQ+wUpPzrigemLs4iISe3bZTHWZNb38Kilwy3WixZg8QMOWXArEJ7iCcRCSLbmz0z4
         yP1sVxIia+ql3d4ovFhOWfSk4mrmO+hlr98isp2SWQBL3PXY1roN/F4uhZgcJtFWW9uy
         MNrg==
X-Gm-Message-State: AOAM531IlQXXSSitiC5h8Jme5dhaiutqoOX3Z5zPrxMHr0l1UpVJiXVd
        OZF8/xnYc4QRZ/gpQ8AHmAPP6u7RY037QIO89P5L5EpHti3/ArCbR2iVN0tGpAXz/zjgcoC52Xw
        MYw74GtmYIaVryXmmsU4Z
X-Received: by 2002:a05:620a:5e2:: with SMTP id z2mr13514150qkg.132.1620736180342;
        Tue, 11 May 2021 05:29:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytGw9UDEiI0XBdxBCfPF1aAEMmsQP5ofpFYpDgmiVnc5uDtkaq/9QrZv3NgYDAbF/ULE4Azg==
X-Received: by 2002:a05:620a:5e2:: with SMTP id z2mr13514129qkg.132.1620736180114;
        Tue, 11 May 2021 05:29:40 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id 7sm9372245qkd.20.2021.05.11.05.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 05:29:39 -0700 (PDT)
Date:   Tue, 11 May 2021 08:29:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/22] xfs: make for_each_perag... a first class citizen
Message-ID: <YJp4sqtlkMRodcNx@bfoster>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-5-david@fromorbit.com>
 <YJks5KC4l9N9/vIT@bfoster>
 <20210511073519.GS63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511073519.GS63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 05:35:19PM +1000, Dave Chinner wrote:
> On Mon, May 10, 2021 at 08:53:56AM -0400, Brian Foster wrote:
> > On Thu, May 06, 2021 at 05:20:36PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > for_each_perag_tag() is defined in xfs_icache.c for local use.
> > > Promote this to xfs_ag.h and define equivalent iteration functions
> > > so that we can use them to iterate AGs instead to replace open coded
> > > perag walks and perag lookups.
> > > 
> > > We also convert as many of the straight forward open coded AG walks
> > > to use these iterators as possible. Anything that is not a direct
> > > conversion to an iterator is ignored and will be updated in future
> > > commits.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_ag.h    | 17 +++++++++++++++++
> > >  fs/xfs/scrub/fscounters.c | 36 ++++++++++++++----------------------
> > >  fs/xfs/xfs_extent_busy.c  |  7 ++-----
> > >  fs/xfs/xfs_fsops.c        |  8 ++------
> > >  fs/xfs/xfs_health.c       |  4 +---
> > >  fs/xfs/xfs_icache.c       | 15 ++-------------
> > >  6 files changed, 38 insertions(+), 49 deletions(-)
> > > 
> > ...
> > > diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> > > index 453ae9adf94c..2dfdac566399 100644
> > > --- a/fs/xfs/scrub/fscounters.c
> > > +++ b/fs/xfs/scrub/fscounters.c
> > ...
> > > @@ -229,12 +224,9 @@ xchk_fscount_aggregate_agcounts(
> > >  		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
> > >  		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
> > >  
> > > -		xfs_perag_put(pag);
> > > -
> > > -		if (xchk_should_terminate(sc, &error))
> > > -			break;
> > >  	}
> > > -
> > > +	if (pag)
> > > +		xfs_perag_put(pag);
> > 
> > It's not shown in the diff, but there is still an exit path out of the
> > above loop that calls xfs_perag_put(). The rest of the patch LGTM.
> 
> Good spot. Fixed.
> 
> FWIW, I'm not entirely happy with the way the iterator can break and
> require conditional cleanup. I'm thinking that I'll come back to
> these and convert them to a iterator structure that will turn this
> into the pattern:
> 
> 	perag_iter_init(&iter, start_agno, end_agno);
> 	for_each_perag(pag, iter) {
> 		....
> 	}
> 	perag_iter_done(&iter);
> 
> and so the code doesn't need to care about whether it exits the loop
> via a break or running out of perags to iterate. I haven't fully
> thought this through, though, so I'm leaving it alone for now...
> 

I think something like that would be an improvement. It's
straightforward enough to follow through these changes with the loop
break quirk in mind, but I suspect that somebody modifying (and/or
reviewing) related code farther in the future might very easily miss
something like an external put being required if a loop is modified to
break out early.

Brian

> -Dave.
> 
> PS - ain't english great? thought, through, though: look the same,
> sound completely different...
> -- 
> Dave Chinner
> david@fromorbit.com
> 

