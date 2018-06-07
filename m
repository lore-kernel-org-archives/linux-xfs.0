Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:37959 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751739AbeFGWXP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 18:23:15 -0400
Date: Fri, 8 Jun 2018 08:23:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: replace do_mod with native operations
Message-ID: <20180607222312.GT10363@dastard>
References: <20180607052751.6541-1-david@fromorbit.com>
 <20180607052751.6541-3-david@fromorbit.com>
 <20180607114204.GD7798@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180607114204.GD7798@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 07, 2018 at 07:42:05AM -0400, Brian Foster wrote:
> On Thu, Jun 07, 2018 at 03:27:50PM +1000, Dave Chinner wrote:
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
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>

....

> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index 80bbfe604ce0..776502a5dcb7 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> ...
> > @@ -1262,8 +1266,11 @@ xfs_rtpick_extent(
> >  		resid = seq - (1ULL << log2);
> >  		b = (mp->m_sb.sb_rextents * ((resid << 1) + 1ULL)) >>
> >  		    (log2 + 1);
> > -		if (b >= mp->m_sb.sb_rextents)
> > -			b = do_mod(b, mp->m_sb.sb_rextents);
> > +		if (b >= mp->m_sb.sb_rextents) {
> > +			xfs_rtblock_t mod;
> > +			div64_u64_rem(b, mp->m_sb.sb_rextents, &mod);
> > +			b = mod;
> > +		}
> 
> Shouldn't we be able to do 'div64_u64_rem(b, mp->m_sb.sb_rextents, &b)'
> here? Otherwise looks fine:

Yeah, I think we can. IIRC I was looking at various implementations
and took the template from something like dm_sector_div64() because
"obviously correct" :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
