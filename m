Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6198C48BC2
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 05:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF4F86140E
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 05:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhFYFFG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Jun 2021 01:05:06 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:41128 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233113AbhFYFFD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Jun 2021 01:05:03 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 50B3E684AB;
        Fri, 25 Jun 2021 15:02:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lwdzC-00Giwn-Lw; Fri, 25 Jun 2021 15:02:38 +1000
Date:   Fri, 25 Jun 2021 15:02:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: Add kvrealloc()
Message-ID: <20210625050238.GA664593@dread.disaster.area>
References: <20210625023029.1472466-1-david@fromorbit.com>
 <20210625023029.1472466-2-david@fromorbit.com>
 <YNVTY0uNdYz8xYp5@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNVTY0uNdYz8xYp5@casper.infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=k1IS4gJYJm307DBGtdEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 25, 2021 at 04:54:11AM +0100, Matthew Wilcox wrote:
> On Fri, Jun 25, 2021 at 12:30:27PM +1000, Dave Chinner wrote:
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 8ae31622deef..34d88ff00f31 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -830,6 +830,20 @@ static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
> >  extern void kvfree(const void *addr);
> >  extern void kvfree_sensitive(const void *addr, size_t len);
> >  
> > +static inline void *kvrealloc(void *p, size_t oldsize, size_t newsize,
> > +		gfp_t flags)
> > +{
> > +	void *newp;
> > +
> > +	if (oldsize >= newsize)
> > +		return p;
> > +	newp = kvmalloc(newsize, flags);
> > +	memcpy(newp, p, oldsize);
> > +	kvfree(p);
> > +	return newp;
> > +}
> 
> Why make this an inline function instead of putting it in mm/util.c?

Not fussed, I can do that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
