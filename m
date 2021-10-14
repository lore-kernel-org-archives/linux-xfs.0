Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65075C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 17:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E86A603E8
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 17:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233558AbhJNRoI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 13:44:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232779AbhJNRoH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 13:44:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634233322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5niZdcnuLXA/dAnya5ood6hs95Odwg1KLMhZ5D015o0=;
        b=AbRERN3VYhiymH5sZLg7ebf4Pvt+ZjKpWX96qMgmtqn13gEyBXEMypQtFqfX8+KMoDQBQd
        9xjjJqXVZmcL2aTiBRM0iS+AhGkstwuZjpHWkArLCvxOq2OdJ97cOgpZrOomFVG1zkyZbW
        zLJ39P3UFuuTmCmjWTZuFsXJaTgowNM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-Wh2dc2lzOIGwIRlgo3wk4w-1; Thu, 14 Oct 2021 13:42:00 -0400
X-MC-Unique: Wh2dc2lzOIGwIRlgo3wk4w-1
Received: by mail-qt1-f200.google.com with SMTP id 12-20020aed208c000000b002a78b33ad97so4975031qtb.23
        for <linux-xfs@vger.kernel.org>; Thu, 14 Oct 2021 10:42:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5niZdcnuLXA/dAnya5ood6hs95Odwg1KLMhZ5D015o0=;
        b=fttiqPP7gXznniyXluznoApQtsYUwt9jTSNZFH15n4Xmfe+xsg9FBAvegCIUhDBIdy
         ssOSn4eeBggH7aPURqFCTnyT/xpoe1aXBIPBinChs1/eOkT45mL5/k0hdyJyIuF94SDW
         ZcejN9f8+onR+yavsvtsq8jE3iG4v9yvREHCx7to7bYoIfjzYy3coxj7ynJSRdozD3PW
         yfdIqE9nOSwspvxHfOTmGfZQ9JsPUlaxI4knle773W0YgSkhOULYZj+7note1qV5o+Mk
         oXRgfx9nGoHcBc1NdEii0Gc/2MMJk2WxL1Hs0cKzTJkZyh8ULtruds7vRKhBMJrixFQO
         YoCg==
X-Gm-Message-State: AOAM533MyXu1WUhgcF/cu6ObAsrU2F/OQFSXi+qTSVRPr9trX3JkoX7B
        hrUIvhnDJyNCSBoN4RXA2RyzlTg3I2y/BWyNq4kjvZPATvCxY43MoVrduv78NFynAG5fB1nLGKJ
        fifLef3Exj2X0Cya+uaWx
X-Received: by 2002:ad4:4366:: with SMTP id u6mr6866046qvt.36.1634233320138;
        Thu, 14 Oct 2021 10:42:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYEQkWL3mS1xnAiPpGpfz4P0Vs0BILVT4ICvZwXBPTTk15XXswySy9S+KW6SL3DEjDTfRO5g==
X-Received: by 2002:ad4:4366:: with SMTP id u6mr6866022qvt.36.1634233319818;
        Thu, 14 Oct 2021 10:41:59 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id q6sm1653901qtn.65.2021.10.14.10.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 10:41:59 -0700 (PDT)
Date:   Thu, 14 Oct 2021 13:41:57 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] xfs: terminate perag iteration reliably on agcount
Message-ID: <YWhr5Z184iH4/X8G@bfoster>
References: <20211012165203.1354826-1-bfoster@redhat.com>
 <20211012165203.1354826-4-bfoster@redhat.com>
 <20211012190822.GN24307@magnolia>
 <YWg6XNufgGOUXNnI@bfoster>
 <20211014164621.GA24333@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014164621.GA24333@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 09:46:21AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 14, 2021 at 10:10:36AM -0400, Brian Foster wrote:
> > On Tue, Oct 12, 2021 at 12:08:22PM -0700, Darrick J. Wong wrote:
> > > On Tue, Oct 12, 2021 at 12:52:02PM -0400, Brian Foster wrote:
> > > > The for_each_perag_from() iteration macro relies on sb_agcount to
> > > > process every perag currently within EOFS from a given starting
> > > > point. It's perfectly valid to have perag structures beyond
> > > > sb_agcount, however, such as if a growfs is in progress. If a perag
> > > > loop happens to race with growfs in this manner, it will actually
> > > > attempt to process the post-EOFS perag where ->pag_agno ==
> > > > sb_agcount. This is reproduced by xfs/104 and manifests as the
> > > > following assert failure in superblock write verifier context:
> > > > 
> > > >  XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22
> > > > 
> > > > Update the corresponding macro to only process perags that are
> > > > within the current sb_agcount.
> > > 
> > > Does this need a Fixes: tag?
> > > 
> > 
> > Probably. I briefly looked into this originally, saw that this code was
> > introduced/modified across a span of commits and skipped it because it
> > wasn't immediately clear which singular commit may have introduced the
> > bug(s). Since these are now separate patches, I'd probably go with
> > 58d43a7e3263 ("xfs: pass perags around in fsmap data dev functions") for
> > this one (since it introduced the use of sb_agcount) and f250eedcf762
> > ("xfs: make for_each_perag... a first class citizen") for the next
> > patch.
> > 
> > That said, technically we could probably refer to the latter for both of
> > these fixes as a suitable enough catchall for the intended purpose of
> > the Fixes tag. I suspect the fundamental problem actually exists in that
> > base patch because for_each_perag() iterates solely based on pag !=
> > NULL. It seems a little odd that the sb_agcount usage is not introduced
> > until a couple patches later, but I suppose that could just be
> > considered a dependency. In reality, it's probably unlikely to ever have
> > a stable kernel at that intermediate point of a rework series so it
> > might not matter much either way. I don't really have a preference one
> > way or the other. Your call..?
> 
> Those fixes tags seem like a reasonable breadcrumb for finding fixes.
> I'll add them to the respective patches on commit.  So for this third
> one:
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 

Thanks. Do you want me to post my v3 with the style and tag fixes or
have you already made those changes?

> > > Also ... should we be checking for agno <= agcount-1 for the initial
> > > xfs_perag_get in the first for loop clause of for_each_perag_range?
> > > I /think/ the answer is that the current users are careful enough to
> > > check that race, but I haven't looked exhaustively.
> > > 
> > 
> > Not sure I follow... for_each_perag_range() is a more generic variant
> > that doesn't know or care about sb_agcount. I think it should support
> > the ability to span an arbitrary range of perags regardless of
> > sb_agcount. Hm?
> 
> Oh, I was idly wondering if these iterators ought to have one more
> training wheel where the loop would be skipped entirely if you did
> something buggy such as:
> 
> agno = mp->m_sb.sb_agcount;
> /* time goes by */
> for_each_perag_from(mp, agno...)
> 	/* stuff */
> 
> Normally that would be skipped since xfs_perag_get(sb_agcount) returns
> NULL, except in the case that it's racing with growfs.  But, some
> malfunction like this should be fairly easy to spot even in the common
> case.
> 

Oh, I see. Yeah, I think technically that would be more defensive logic.
We might be able to repurpose xfs_perag_next() into something more
generic that also covers the init case, but I'm not terribly concerned
with that type of misuse in the context of this patch (and not sure it
warrants the quirky logic if there are bigger changes pending with these
macros anyways).

Brian

> --D
> 
> > > Welcome back, by the way. :)
> > > 
> > 
> > Thanks!
> > 
> > Brian
> > 
> > > --D
> > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_ag.h | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > > > index cf8baae2ba18..b8cc5017efba 100644
> > > > --- a/fs/xfs/libxfs/xfs_ag.h
> > > > +++ b/fs/xfs/libxfs/xfs_ag.h
> > > > @@ -142,7 +142,7 @@ struct xfs_perag *xfs_perag_next(
> > > >  		(pag) = xfs_perag_next((pag), &(agno)))
> > > >  
> > > >  #define for_each_perag_from(mp, agno, pag) \
> > > > -	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
> > > > +	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
> > > >  
> > > >  
> > > >  #define for_each_perag(mp, agno, pag) \
> > > > -- 
> > > > 2.31.1
> > > > 
> > > 
> > 
> 

