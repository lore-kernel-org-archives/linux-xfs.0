Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 21:26:54 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B4QUlU015639
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:26:31 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DD901BB47AF
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:27:35 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id RX0FPlMAvppmTUGD for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:27:35 -0700 (PDT)
Date: Fri, 11 Jul 2008 14:27:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlocked xfs
Message-ID: <20080711042732.GE11558@disturbed>
References: <4876C667.608@sandeen.net> <4876C9EB.7060601@sgi.com> <4876D1C3.4000006@sgi.com> <20080711040447.GC11558@disturbed> <4876DD2D.2010903@sandeen.net> <4876DDE3.7020801@sgi.com> <4876DF17.9090904@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4876DF17.9090904@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, markgw@sgi.com, xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 10, 2008 at 11:18:31PM -0500, Eric Sandeen wrote:
> Timothy Shimmin wrote:
> > Eric Sandeen wrote:
> >> Dave Chinner wrote:
> >>
> >>> Patch for you to test, Eric, below.
> >>>
> >>> (I haven't been able to test it because UML panics on boot right now.
> >>> I need to hoover in the unit-at-atime build patch that Jeff Dike
> >>> posted this morning)
> >>>
> >>> Cheers,
> >>>
> >>> Dave.
> >> Dave, you frighten me.
> >>
> >> Testing now, will let it run a while.
> >>
> > Excellent.
> > 
> > And it happened pretty reliably before, right?
> 
> It did, yep, though sometimes took a while.
> 
> But, w/ the patch it actually deadlocked really quickly (< 2000 inodes
> written)

Yeah, inverted the if/else logic, I think. Like I
said, untested.

I'll send out an updated patch as soon as I get uml running
again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
