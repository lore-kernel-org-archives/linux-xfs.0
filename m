Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 16:55:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QNtVGV003284
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 16:55:33 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 594FF28F305
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 16:56:31 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id ZX9q0H3l5y2NeIoE for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 16:56:31 -0700 (PDT)
Date: Fri, 27 Jun 2008 09:54:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TAKE 976035 - streamline init/exit path
Message-ID: <20080626235441.GU29319@disturbed>
References: <20080625030057.973173A5D1@itchy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625030057.973173A5D1@itchy>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 25, 2008 at 01:00:57PM +1000, Niv Sardi wrote:
> streamline init/exit path
> 
> Currently the xfs module init/exit code is a mess.  It's farmed out
> over a lot of function with very little error checking.  This patch
> makes sure we propagate all initialization failures properly and clean
> up after them.  Various runtime initializations are replaced with
> compile-time initializations where possible to make this easier.  The
> exit path is similarly consolidated.
> 
> There's now split out function to create/destroy the kmem zones and
> alloc/free the trace buffers.  I've also changed the ktrace
> allocations to KM_MAYFAIL and handled errors resulting from that.
> 
> And yes, we really should replace the XFS_*_TRACE ifdefs with a single
> XFS_TRACE..
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Niv Sardi <xaiki@sgi.com>

Niv, can you now do another checkin that fixes the compilation
error when CONFIG_PROCFS=N in fs/xfs/linux-2.6/xfs_stats.h that
was reported on linux-next (i.e. fix the bug that led up to
everyone discovering the busted commit)?

BTW, your script is still busted - look at the wacky cc list
on the take message. Please be a little more careful...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
