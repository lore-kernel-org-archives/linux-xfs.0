Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Jul 2008 16:21:05 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6BNL0kO028620
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 16:21:02 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE7A618BA5D2
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 16:22:05 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id ytiqRef8R371SCtV for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 16:22:05 -0700 (PDT)
Date: Sat, 12 Jul 2008 09:22:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs bug in 2.6.26-rc9
Message-ID: <20080711232201.GG11558@disturbed>
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <20080711190209.GA7401@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711190209.GA7401@Chamillionaire.breakpoint.cc>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jul 11, 2008 at 09:02:09PM +0200, Sebastian Siewior wrote:
> * Dave Chinner | 2008-07-11 18:42:49 [+1000]:
> 
> >Oh - you must be running a debug XFS.  CONFIG_XFS_DEBUG was only
> >introduced in 2.6.26-rc1 and defaults to 'N', so you must have
> >selected the non-default option when prompted. This will cause your
> >machine to oops at the slightest inconsistency that is found,
> >regardless of whether it is fatal or not. Like the help text says,
> >don't set this unless you are an XFS developer....
> Could you please add this to the Kconfig entry.

I effectively quoted from it:

config XFS_DEBUG
        bool "XFS Debugging support (EXPERIMENTAL)"
        depends on XFS_FS && EXPERIMENTAL
        help
          Say Y here to get an XFS build with many debugging features,
          including ASSERT checks, function wrappers around macros,
          and extra sanity-checking functions in various code paths.

          Note that the resulting code will be HUGE and SLOW, and probably
          not useful unless you are debugging a particular problem.

          Say N unless you are an XFS developer, or you play one on TV.

> Debug mode is usually
> noisy, little slower and mostly usefull just to the developers but *I*
> would not expect to BUG() in the non-fatal case.

What do you expect debug code to do? Asserts are designed to
drop the machine into a debugger when they fail so the problem can
be, well, debugged.

> Not sure but if this is just for hch and you than a define in xfs.h
> might be safer :)

And any other XFS developer using the XFS git tree or mainline, as
tends to happen these days. And there are cases where a debug XFS
might be needed to help find a problem that is being hit out in
the field.

Like all other debug config options, don't set them unless you know
what you are doing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
