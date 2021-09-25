Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B3E6C433FE
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 23:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13F386108E
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 23:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhIYXQi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Sep 2021 19:16:38 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:38153 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230174AbhIYXQi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Sep 2021 19:16:38 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id E8B7DA30B;
        Sun, 26 Sep 2021 09:15:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mUGsm-00Gixm-Ah; Sun, 26 Sep 2021 09:15:00 +1000
Date:   Sun, 26 Sep 2021 09:15:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        djwong@kernel.org
Subject: Re: [PATCH V2 3/5] atomic: convert to uatomic
Message-ID: <20210925231500.GZ1756565@dread.disaster.area>
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-4-chandan.babu@oracle.com>
 <80546d48-9018-e374-2a0b-caf84e521ebd@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80546d48-9018-e374-2a0b-caf84e521ebd@sandeen.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=9uXBr0ESAAAA:20 a=7-415B0cAAAA:8 a=o3-EtIroQ98G-Ty6VNQA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 24, 2021 at 05:13:30PM -0500, Eric Sandeen wrote:
> On 9/24/21 9:09 AM, Chandan Babu R wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now we have liburcu, we can make use of it's atomic variable
> > implementation. It is almost identical to the kernel API - it's just
> > got a "uatomic" prefix. liburcu also provides all the same aomtic
> > variable memory barriers as the kernel, so if we pull memory barrier
> > dependent kernel code across, it will just work with the right
> > barrier wrappers.
> > 
> > This is preparation the addition of more extensive atomic operations
> > the that kernel buffer cache requires to function correctly.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > [chandan.babu@oracle.com: Swap order of arguments provided to atomic[64]_[add|sub]()]
> > Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> > ---
> >   include/atomic.h | 65 ++++++++++++++++++++++++++++++++++++++++--------
> >   1 file changed, 54 insertions(+), 11 deletions(-)
> > 
> > diff --git a/include/atomic.h b/include/atomic.h
> > index e0e1ba84..99cb85d3 100644
> > --- a/include/atomic.h
> > +++ b/include/atomic.h
> > @@ -7,21 +7,64 @@
> >   #define __ATOMIC_H__
> >   /*
> > - * Warning: These are not really atomic at all. They are wrappers around the
> > - * kernel atomic variable interface. If we do need these variables to be atomic
> > - * (due to multithreading of the code that uses them) we need to add some
> > - * pthreads magic here.
> > + * Atomics are provided by liburcu.
> > + *
> > + * API and guidelines for which operations provide memory barriers is here:
> > + *
> > + * https://github.com/urcu/userspace-rcu/blob/master/doc/uatomic-api.md
> > + *
> > + * Unlike the kernel, the same interface supports 32 and 64 bit atomic integers.
> 
> Given this, anyone have any objection to putting the #defines together at the
> top, rather than hiding the 64 variants at the end of the file?

I wanted to keep the -APIs- separate, because all the kernel
atomic/atomic64 stuff is already separate and type checked. I don't
see any point in commingling the two different atomic type APIs
just because the implementation ends up being the same and that some
wrappers are defines and others are static inline code.

Ideally, the wrappers should all be static inlines so we get correct
atomic_t/atomic64_t type checking in userspace. Those are the types
we care about in terms of libxfs, so to typecheck the API properly
these should -all- be static inlines. The patch as it stands was a
"get it working properly" patch, not a "finalised, strictly correct
API" patch. That was somethign for "down the road" as I polished the
patchset ready for eventual review.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
