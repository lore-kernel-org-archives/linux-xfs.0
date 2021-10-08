Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D238C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Oct 2021 14:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31E8160F58
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Oct 2021 14:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhJHOrN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Oct 2021 10:47:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230468AbhJHOrN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Oct 2021 10:47:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633704317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TQw/iEj0zogFEo3yYkWuLcLKlstlVlPa71pjRUhE3M0=;
        b=bgYdcpRwyO7Wdtg5msKZSO2O1/IeCxofa2A02r9U+fEAzXln8jltTaJkAN27oa9KOiT2Tb
        R0JVDITU8fugfic9dQTep5luzr34Lk1RgEqWmDEgwBJ4lNJfq/MDNO9ajVa1g3YC2/HI4S
        UZ8uEHy9OL2zb5+wpybZJfiwZDHOphI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-DB9ZnxxBOGuosT6PVNwJ9A-1; Fri, 08 Oct 2021 10:45:16 -0400
X-MC-Unique: DB9ZnxxBOGuosT6PVNwJ9A-1
Received: by mail-qk1-f198.google.com with SMTP id c16-20020a05620a0cf000b0045f1d55407aso3896064qkj.22
        for <linux-xfs@vger.kernel.org>; Fri, 08 Oct 2021 07:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TQw/iEj0zogFEo3yYkWuLcLKlstlVlPa71pjRUhE3M0=;
        b=NRBz7FDO0Wlemh9EteMbyJfQ1MIAf/Ovf28RQHF04pC2hHoDMtmJxc8P2IYg23alxP
         Q+9B9FR5qKlQu1Fj4yPAigH/ydxMEKwVR2r7dRf1t7WIcHY00wZVh2DnKRjb5Gu3bQOJ
         dmVcgd2JcfeRPq/6YW0P6oBi6yXTGsEHB+tZztu8Qm9uCcYIcmVNjRd34f9xEsIUUYLy
         1AosCXJAYEbp3nqlxLhYWhe1Jt5C2KMmWTisU8funHw80cNXBxxVKqztqNWRDfMjJyk0
         gaabotkO7ijKLIqe3Qf/wkaduGiVLRgYcEoIKqBoGFGRbAoC2vqBt/PQjQERkXknp+Iw
         aJKQ==
X-Gm-Message-State: AOAM530qjUOn+1QafNV06yXkhi3OYKAopKlLKcrBcf8o+Man7jNNoUdT
        AE93wyZMKKVB0Jd0W/uWpysIUSsFYysSkDsHE7uPPLPBT4voJW2SvsClcreglV/AL9RijTbngTb
        Qsl7FNdyRrieIpiWiWdGy
X-Received: by 2002:a37:9244:: with SMTP id u65mr3376823qkd.46.1633704315820;
        Fri, 08 Oct 2021 07:45:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZF52Q4oXawdJ+Z2uyZghINdIkACU6pGve4rT2CLfpAtlu/bTUnvLVV7HWreV9KFYM+CaMfw==
X-Received: by 2002:a37:9244:: with SMTP id u65mr3376797qkd.46.1633704315518;
        Fri, 08 Oct 2021 07:45:15 -0700 (PDT)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id w7sm2496428qtc.29.2021.10.08.07.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 07:45:15 -0700 (PDT)
Date:   Fri, 8 Oct 2021 10:45:13 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: terminate perag iteration reliably on end agno
Message-ID: <YWBZef87p55+XKNh@bfoster>
References: <20211007125053.1096868-1-bfoster@redhat.com>
 <20211007125053.1096868-4-bfoster@redhat.com>
 <20211007230259.GG54211@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007230259.GG54211@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 08, 2021 at 10:02:59AM +1100, Dave Chinner wrote:
> On Thu, Oct 07, 2021 at 08:50:53AM -0400, Brian Foster wrote:
> > The for_each_perag*() set of macros are hacky in that some (i.e. those
> > based on sb_agcount) rely on the assumption that perag iteration
> > terminates naturally with a NULL perag at the specified end agno. Others
> > allow for the final AG to have a valid perag and require the calling
> > function to clean up any potential leftover xfs_perag reference on
> > termination of the loop.
> > 
> > Aside from providing a subtly inconsistent interface, the former variant
> > is racy with a potential growfs in progress because growfs can create
> > discoverable post-eofs perags before the final superblock update that
> > completes the grow operation and increases sb_agcount. This leads to
> > unexpected assert failures (reproduced by xfs/104) such as the following
> > in the superblock buffer write verifier path:
> > 
> >  XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22
> 
> Yeah, that's a bad assert. It's not valid in the context of grow or
> shrink or any of the future advanced per-ag management things we
> want to do.
> 

I think it depends on the context. I don't think it's unreasonable to
expect certain paths to not want to process post-eofs perags. I don't
really like the placement of this assert tbh (with it being in a generic
helper) and the sb write verifier is probably not ideal context for the
check in a generic sense, but it does flag unexpected behavior when you
consider the higher level iteration is based on sb_agcount.

> I'm ok with the change being proposed as a expedient bug fix, but
> I'll note that the approach taken to fix it is not compatible with
> future plans for managing shrink and perag operations. I'll comment
> on the patch first, then the rest of the email is commentary about
> how xfs_perag_get() is intended to be used...
> 
> > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > index d05c9217c3af..edcdd4fbc225 100644
> > --- a/fs/xfs/libxfs/xfs_ag.h
> > +++ b/fs/xfs/libxfs/xfs_ag.h
> > @@ -116,34 +116,30 @@ void xfs_perag_put(struct xfs_perag *pag);
> >  
> >  /*
> >   * Perag iteration APIs
> > - *
> > - * XXX: for_each_perag_range() usage really needs an iterator to clean up when
> > - * we terminate at end_agno because we may have taken a reference to the perag
> > - * beyond end_agno. Right now callers have to be careful to catch and clean that
> > - * up themselves. This is not necessary for the callers of for_each_perag() and
> > - * for_each_perag_from() because they terminate at sb_agcount where there are
> > - * no perag structures in tree beyond end_agno.
> 
> We still really need an iterator for the range iterations so that we
> can have a consistent set of behaviours for all iterations and
> don't need a special case just for the "mid walk break" where the
> code keeps the active reference to the perag for itself...
> 

Ok, but what exactly are you referring to by "an iterator" beyond what
we have here to this point? A walker function with a callback or
something? And why wouldn't we have done that in the first place instead
of introducing the API wart documented above?

> >   */
> >  static inline
> >  struct xfs_perag *xfs_perag_next(
> >  	struct xfs_perag	*pag,
> > -	xfs_agnumber_t		*agno)
> > +	xfs_agnumber_t		*agno,
> > +	xfs_agnumber_t		end_agno)
> >  {
> >  	struct xfs_mount	*mp = pag->pag_mount;
> >  
> >  	*agno = pag->pag_agno + 1;
> >  	xfs_perag_put(pag);
> > -	pag = xfs_perag_get(mp, *agno);
> > +	pag = NULL;
> > +	if (*agno <= end_agno)
> > +		pag = xfs_perag_get(mp, *agno);
> >  	return pag;
> 
> 	*agno = pag->pag_agno + 1;
> 	xfs_perag_put(pag);
> 	if (*agno > end_agno)
> 		return NULL;
> 	return xfs_perag_get(mp, *agno);
> 

Will fix.

> >  }
> >  
> >  #define for_each_perag_range(mp, agno, end_agno, pag) \
> >  	for ((pag) = xfs_perag_get((mp), (agno)); \
> > -		(pag) != NULL && (agno) <= (end_agno); \
> > -		(pag) = xfs_perag_next((pag), &(agno)))
> > +		(pag) != NULL; \
> > +		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
> >  
> >  #define for_each_perag_from(mp, agno, pag) \
> > -	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
> > +	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
> 
> Isn't this one line the entire bug fix right here? i.e. the
> factoring is largely unnecessary, the grow race bug is fixed by just
> this one-liner?
> 

No, the reference count problems can still occur regardless of this
particular change.

...
> 
> > The following assert failure occasionally triggers during the xfs_perag
> > free path on unmount, presumably because one of the many
> > for_each_perag() loops in the code that is expected to terminate with a
> > NULL pag raced with a growfs and actually terminated with a non-NULL
> > reference to post-eofs (at the time) perag.
> > 
> >  XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/libxfs/xfs_ag.c, line: 195
> > 
> > Rework the lower level perag iteration logic to explicitly terminate
> > on the specified end agno, not implicitly rely on pag == NULL as a
> > termination clause and thus avoid these problems.
> 
> IMO, this just hides the symptom that results from code that isn't
> handling unexpected adverse loop termination correctly. The
> iterators are going to get more complex in the near future, so we
> really need them to have a robust iterator API that does all the
> cleanup work correctly, rather than try to hide it all in a
> increasingly complex for loop construct.
> 

Any loop that uses one of the sb_agcount based iteration macros in a
context that can race with growfs and doesn't check pag != NULL post
loop is not handling loop termination correctly. The sb_agcount check
effectively builds in an early termination vector to every such usage,
because we can't guarantee that pag == NULL when the sb_agcount check
causes loop termination.

IOW, the following usage pattern documented in the comment above is not
universally correct/safe:

	for_each_perag(...) {
		/* no early termination */
	}
	/* no perag check because no early termination */

... because for_each_perag() is not implemented correctly to guarantee
that pag == NULL on exit of the loop. This is a simple logic bug with a
simple fix.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

