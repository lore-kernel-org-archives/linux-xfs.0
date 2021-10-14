Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A09C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 14:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FFC2610EA
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 14:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbhJNOMr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 10:12:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231388AbhJNOMq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 10:12:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634220641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/bP7eAe58KmRZqx0g7n7Pk9RXA+OSk9FFKouwIoobiQ=;
        b=MC+G+32F12zDxSQRZxQ9Drn8P9kHyjVOcKjpnTN1grX7YJmRNUG9QTxBL+K9kxL3cLl7JY
        RRhLa0JBrX57g+Fz65goDlrQm+KfV3BynsJTtvv+rbGbjA/BihyeD+JpK/v/qvBwzanPQL
        DU9gpEZrZiOcMC8pBWCetNgMkT28IZU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-hyVixiDaMOWAgmep3V_vJw-1; Thu, 14 Oct 2021 10:10:40 -0400
X-MC-Unique: hyVixiDaMOWAgmep3V_vJw-1
Received: by mail-qt1-f197.google.com with SMTP id w12-20020ac80ecc000000b002a7a4cd22faso1444835qti.4
        for <linux-xfs@vger.kernel.org>; Thu, 14 Oct 2021 07:10:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/bP7eAe58KmRZqx0g7n7Pk9RXA+OSk9FFKouwIoobiQ=;
        b=saan/ctjZoXvzqR907UO9xZ1KQkFPG3Q/hCp13nkJ1tvb12AtOAmNPheiwFuPk4kUq
         BsrhDyzp2T0YLpINLOEAG+aKP7zgReOHK+iRVAEFKFVq0jM0eKCmpytpUMmLxs1jSdGF
         BsRo7Wih0SQ2ohTAkqpedcyrizDPLpKoSJ/And0b2yTqzb5tPkDI23CZ4+Xaw6CmxnbO
         VkHkws7PPxvsagskl29TA2YkVlONrAP+hsrEN5ENp8JCEwQ4IaJlLIKqAGJELe1D4qWr
         fzZRS8K0x633gOFvHbgp1rr3ewa04jeffvi7yly29rrUWuCEWJglWCmCekfju+0dN78u
         FUZA==
X-Gm-Message-State: AOAM531lUF0XVQO2lo2ic+46lXRFtmaNMx01Vx21BiS63F+OFYnxtiDQ
        XQ/hWJXU0uvHXYBSvPVptd1rza3oFyb4B+2QY6utuvPQ8wdZELMxSUPA/crMqN08d1x4VLFbYcU
        hVmWG3Dlg93UzljVIYeVx
X-Received: by 2002:a05:620a:4448:: with SMTP id w8mr4940856qkp.261.1634220639427;
        Thu, 14 Oct 2021 07:10:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZMTIZaj6KlZYRyQ5g94izIbr1+qA6aAe+68yUz5mgD0kHRZ8IYQOHsgkv8ZCGQgkNwig9Vw==
X-Received: by 2002:a05:620a:4448:: with SMTP id w8mr4940828qkp.261.1634220639166;
        Thu, 14 Oct 2021 07:10:39 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id r9sm1423115qtx.15.2021.10.14.07.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 07:10:38 -0700 (PDT)
Date:   Thu, 14 Oct 2021 10:10:36 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] xfs: terminate perag iteration reliably on agcount
Message-ID: <YWg6XNufgGOUXNnI@bfoster>
References: <20211012165203.1354826-1-bfoster@redhat.com>
 <20211012165203.1354826-4-bfoster@redhat.com>
 <20211012190822.GN24307@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012190822.GN24307@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 12:08:22PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 12, 2021 at 12:52:02PM -0400, Brian Foster wrote:
> > The for_each_perag_from() iteration macro relies on sb_agcount to
> > process every perag currently within EOFS from a given starting
> > point. It's perfectly valid to have perag structures beyond
> > sb_agcount, however, such as if a growfs is in progress. If a perag
> > loop happens to race with growfs in this manner, it will actually
> > attempt to process the post-EOFS perag where ->pag_agno ==
> > sb_agcount. This is reproduced by xfs/104 and manifests as the
> > following assert failure in superblock write verifier context:
> > 
> >  XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22
> > 
> > Update the corresponding macro to only process perags that are
> > within the current sb_agcount.
> 
> Does this need a Fixes: tag?
> 

Probably. I briefly looked into this originally, saw that this code was
introduced/modified across a span of commits and skipped it because it
wasn't immediately clear which singular commit may have introduced the
bug(s). Since these are now separate patches, I'd probably go with
58d43a7e3263 ("xfs: pass perags around in fsmap data dev functions") for
this one (since it introduced the use of sb_agcount) and f250eedcf762
("xfs: make for_each_perag... a first class citizen") for the next
patch.

That said, technically we could probably refer to the latter for both of
these fixes as a suitable enough catchall for the intended purpose of
the Fixes tag. I suspect the fundamental problem actually exists in that
base patch because for_each_perag() iterates solely based on pag !=
NULL. It seems a little odd that the sb_agcount usage is not introduced
until a couple patches later, but I suppose that could just be
considered a dependency. In reality, it's probably unlikely to ever have
a stable kernel at that intermediate point of a rework series so it
might not matter much either way. I don't really have a preference one
way or the other. Your call..?

> Also ... should we be checking for agno <= agcount-1 for the initial
> xfs_perag_get in the first for loop clause of for_each_perag_range?
> I /think/ the answer is that the current users are careful enough to
> check that race, but I haven't looked exhaustively.
> 

Not sure I follow... for_each_perag_range() is a more generic variant
that doesn't know or care about sb_agcount. I think it should support
the ability to span an arbitrary range of perags regardless of
sb_agcount. Hm?

> Welcome back, by the way. :)
> 

Thanks!

Brian

> --D
> 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_ag.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > index cf8baae2ba18..b8cc5017efba 100644
> > --- a/fs/xfs/libxfs/xfs_ag.h
> > +++ b/fs/xfs/libxfs/xfs_ag.h
> > @@ -142,7 +142,7 @@ struct xfs_perag *xfs_perag_next(
> >  		(pag) = xfs_perag_next((pag), &(agno)))
> >  
> >  #define for_each_perag_from(mp, agno, pag) \
> > -	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
> > +	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
> >  
> >  
> >  #define for_each_perag(mp, agno, pag) \
> > -- 
> > 2.31.1
> > 
> 

