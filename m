Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:32394 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752739AbeFHHbU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jun 2018 03:31:20 -0400
Date: Fri, 8 Jun 2018 17:31:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3 V2] xfs: replace do_mod with native operations
Message-ID: <20180608073117.GA10363@dastard>
References: <20180607052751.6541-1-david@fromorbit.com>
 <20180607052751.6541-3-david@fromorbit.com>
 <20180608004357.GW10363@dastard>
 <20180608061909.GA12715@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180608061909.GA12715@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 07, 2018 at 11:19:09PM -0700, Christoph Hellwig wrote:
> On Fri, Jun 08, 2018 at 10:43:57AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > do_mod() is a hold-over from when we have different sizes for file
> > offsets and and other internal values for 40 bit XFS filesystems.
> > Hence depending on build flags variables passed to do_mod() could
> > change size. We no longer support those small format filesystems and
> > hence everything is of fixed size theses days, even on 32 bit
> > platforms.
> > 
> > As such, we can convert all the do_mod() callers to platform
> > optimised modulus operations as defined by linux/math64.h.
> > Individual conversions depend on the types of variables being used.
> 
> I have to admit the XFS helpers are much more intuitive.

I've always found them opaque and clunky, especially with the return
value casts they seem to be frequently (but not consistently)
associated with.

> >  7 files changed, 66 insertions(+), 50 deletions(-)
> 
> And the diffstat agrees with me.

No, it's doesn't, actually. The diffstat changes because I separated
calculations from logic operations, just like we do catching and
checking error returns from functions. i.e. the code goes from
this horrible mess or assignments, casts and calculations
intermingled with flow/logic decisions:

               if ((args.mod = (xfs_extlen_t)do_mod(ap->offset, args.prod)))
                       args.mod = (xfs_extlen_t)(args.prod - args.mod);

Into a clear separation of calculation and logic statements like this:

               div_u64_rem(ap->offset, args.prod, &args.mod);
               if (args.mod)
                       args.mod = args.prod - args.mod;

That is also our preferred style for all the code (e.g. for catching
and checking errors). Yes, that means a slight growth in code size,
but I'll take that any day of the week if it means the code is
easier to read....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
