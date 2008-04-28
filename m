Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 20:32:48 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3S3WZrG026985
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 20:32:37 -0700
Date: Mon, 28 Apr 2008 13:32:49 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] xfs: reduce stack usage in xfs_bmap_btalloc()
Message-ID: <20080428033249.GE103491721@sgi.com>
References: <200804261651.02078.vda.linux@googlemail.com> <20080427234056.GA108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080427234056.GA108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 09:40:56AM +1000, David Chinner wrote:
> On Sat, Apr 26, 2008 at 04:51:02PM +0200, Denys Vlasenko wrote:
> > Hi David,
> > 
> > This patch reduces xfs_bmap_btalloc() stack usage by 50 bytes
> > by moving part of its body into a helper function.
> 
> Can you please attach your patches inline, Denys (see
> Documentation/SubmittingPatches)?
> 
> > This results in some variables not taking stack space in
> > xfs_bmap_btalloc() anymore.
> > 
> > The helper itself does not call anything stack-deep.
> > Stack-deep call to xfs_alloc_vextent() happen
> > in xfs_bmap_btalloc(), as before.
> 
> I have a set of patches that introduces new functionality into the
> allocator (dynamic allocation policies) that reduces
> xfs_bmap_btalloc() function by 36 bytes (just by chance, I didn't
> design it for this purpose). It breaks it down on functional
> boundaries like Christoph's patch. I'm going to revist that patch
> w.r.t both these patches and see what falls out the bottom...

44 bytes saved in xfs_bmap_btalloc with the same factoring as
Christoph's patch being done. Given that most of this is now
the struct xfs_alloc_arg, I don't think this will be reduced a whole
lot more. I think I might be able to kill the tryagain and isaligned
variables as well which will save another 8 bytes, but I'll leave
that for later....

Good progress, folks.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
