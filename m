Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:22553 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752098AbeFGW2K (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 18:28:10 -0400
Date: Fri, 8 Jun 2018 08:28:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/3] xfs: replace do_mod with native operations
Message-ID: <20180607222808.GU10363@dastard>
References: <20180607052751.6541-1-david@fromorbit.com>
 <20180607052751.6541-3-david@fromorbit.com>
 <20180607155437.GK25007@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180607155437.GK25007@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 07, 2018 at 08:54:37AM -0700, Darrick J. Wong wrote:
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
> > ---
.....
> > @@ -1090,7 +1094,7 @@ xfs_adjust_extent_unmap_boundaries(
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	struct xfs_bmbt_irec	imap;
> >  	int			nimap, error;
> > -	xfs_extlen_t		mod = 0;
> > +	xfs_rtblock_t		mod = 0;
> >  
> >  	nimap = 1;
> >  	error = xfs_bmapi_read(ip, *startoffset_fsb, 1, &imap, &nimap, 0);
> > @@ -1099,7 +1103,7 @@ xfs_adjust_extent_unmap_boundaries(
> >  
> >  	if (nimap && imap.br_startblock != HOLESTARTBLOCK) {
> >  		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
> > -		mod = do_mod(imap.br_startblock, mp->m_sb.sb_rextsize);
> > +		div64_u64_rem(imap.br_startblock, mp->m_sb.sb_rextsize, &mod);
> 
> Why does this need to be a div64_u64_rem?  sb_rextsize is 32-bit, so the
> remainder won't exceed 2^32-1, right?
> 
> >  		if (mod)
> >  			*startoffset_fsb += mp->m_sb.sb_rextsize - mod;
> 
> Indeed if it ever did that would screw up this logic, wouldn't it?

Yeah, i think I screwed that one up, probably confused rextsize with
rextents. IOWs mod can remain as a xfs_extlen_t and this can become
div_u64_rem().

I'll fix and repost.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
