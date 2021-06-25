Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF20C49EA7
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 05:05:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B1D76141F
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Jun 2021 05:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhFYFHh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Jun 2021 01:07:37 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:41428 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230193AbhFYFHg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Jun 2021 01:07:36 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 3F1AB106793;
        Fri, 25 Jun 2021 15:05:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lwe1h-00Giyy-9a; Fri, 25 Jun 2021 15:05:13 +1000
Date:   Fri, 25 Jun 2021 15:05:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm: Add kvrealloc()
Message-ID: <20210625050513.GB664593@dread.disaster.area>
References: <20210625023029.1472466-1-david@fromorbit.com>
 <20210625023029.1472466-2-david@fromorbit.com>
 <867caabb-bac5-8b34-9a68-53e8953f2fad@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867caabb-bac5-8b34-9a68-53e8953f2fad@huawei.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=Hvcnu7jGTm_TG-eP9zEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 25, 2021 at 10:40:08AM +0800, Miaohe Lin wrote:
> On 2021/6/25 10:30, Dave Chinner wrote:
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
> 
> Shouldn't we check newp against NULL before memcpy?

Sure, the flags cwwe pass it from XFS mean it can't fail, but I
guess someone could add a noretry flag or something like that...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
