Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 156CDC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Oct 2021 21:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F37BF60FD9
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Oct 2021 21:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243426AbhJHVWT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Oct 2021 17:22:19 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:56173 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231714AbhJHVWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Oct 2021 17:22:19 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id D66B8AE78;
        Sat,  9 Oct 2021 08:20:21 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mYxHw-00413h-PC; Sat, 09 Oct 2021 08:20:20 +1100
Date:   Sat, 9 Oct 2021 08:20:20 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: terminate perag iteration reliably on end agno
Message-ID: <20211008212020.GI54211@dread.disaster.area>
References: <20211007125053.1096868-1-bfoster@redhat.com>
 <20211007125053.1096868-4-bfoster@redhat.com>
 <20211007230259.GG54211@dread.disaster.area>
 <YWBZef87p55+XKNh@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWBZef87p55+XKNh@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6160b616
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=zKiAouTkd2xAWZQdSDoA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 08, 2021 at 10:45:13AM -0400, Brian Foster wrote:
> On Fri, Oct 08, 2021 at 10:02:59AM +1100, Dave Chinner wrote:
> > On Thu, Oct 07, 2021 at 08:50:53AM -0400, Brian Foster wrote:
> > > diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
> > > index d05c9217c3af..edcdd4fbc225 100644
> > > --- a/fs/xfs/libxfs/xfs_ag.h
> > > +++ b/fs/xfs/libxfs/xfs_ag.h
> > > @@ -116,34 +116,30 @@ void xfs_perag_put(struct xfs_perag *pag);
> > >  
> > >  /*
> > >   * Perag iteration APIs
> > > - *
> > > - * XXX: for_each_perag_range() usage really needs an iterator to clean up when
> > > - * we terminate at end_agno because we may have taken a reference to the perag
> > > - * beyond end_agno. Right now callers have to be careful to catch and clean that
> > > - * up themselves. This is not necessary for the callers of for_each_perag() and
> > > - * for_each_perag_from() because they terminate at sb_agcount where there are
> > > - * no perag structures in tree beyond end_agno.
> > 
> > We still really need an iterator for the range iterations so that we
> > can have a consistent set of behaviours for all iterations and
> > don't need a special case just for the "mid walk break" where the
> > code keeps the active reference to the perag for itself...
> > 
> 
> Ok, but what exactly are you referring to by "an iterator" beyond what
> we have here to this point? A walker function with a callback or
> something? And why wouldn't we have done that in the first place instead
> of introducing the API wart documented above?

We didn't do it in the first place because we started with the tag
walks that only ever terminate on NULL - that was Darrick's code
used in the inode cache walk functions.. Converting the rest of
agcount based walks was not straight-forward - there were different
cases that needed to be handled and this was the least worst way to
begin the conversion needed for shrink.

Looking back at the history, it was that last conversion for
GETFSMAP that caused the problems sb_agcount based walks in commit
58d43a7e3263 ("xfs: pass perags around in fsmap data dev functions")
where for_each_perag_from() was converted to
for_each_perag_from_range(). There was no termination leak before
this, and races with growfs were simply handled with termination by
NULL lookup return. The bug iwas introduced because we moved away
from termination on NULL lookup by adding a termination via loop
index to support GETFSMAP.

We knew about the API wart and put a plan in place to address it in
future by movign to iterators. That looks something like this but
without the C99 automatic cleanup so external iterator setup and
teardown:

https://lore.kernel.org/linux-xfs/162814685996.2777088.11268635137040103857.stgit@magnolia/

So, yes, we need to fix the bug that was introduced, but asking why
the code wasn't perfect before it was merged doesn't help us make
small steps forwards towards solving the bigger problems we need to
address...

> > >  }
> > >  
> > >  #define for_each_perag_range(mp, agno, end_agno, pag) \
> > >  	for ((pag) = xfs_perag_get((mp), (agno)); \
> > > -		(pag) != NULL && (agno) <= (end_agno); \
> > > -		(pag) = xfs_perag_next((pag), &(agno)))
> > > +		(pag) != NULL; \
> > > +		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
> > >  
> > >  #define for_each_perag_from(mp, agno, pag) \
> > > -	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount, (pag))
> > > +	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
> > 
> > Isn't this one line the entire bug fix right here? i.e. the
> > factoring is largely unnecessary, the grow race bug is fixed by just
> > this one-liner?
> > 
> 
> No, the reference count problems can still occur regardless of this
> particular change.

Ok, so there are two problems then - one is an off-by one that can
result in perag lookups beyond the EOFS racing with growfs instead
of returning NULL.

The other is loop termination via loop index limits can leak a perag
when terminating the walk on the end index rather than a NULL. I
think these two bug fixes should at least be separate patches. Fix
the off-by-one in one patch, fix the termination issue in another.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
