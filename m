Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Jul 2008 12:51:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6BJpXJq010235
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 12:51:35 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4E3A2DF038
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 12:52:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id K7yvUC11ENYxlWbq for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 12:52:39 -0700 (PDT)
Message-ID: <4877BA05.4000109@sandeen.net>
Date: Fri, 11 Jul 2008 14:52:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs bug in 2.6.26-rc9
References: <alpine.DEB.1.10.0807110939520.30192@uplift.swm.pp.se> <20080711084248.GU29319@disturbed> <20080711190209.GA7401@Chamillionaire.breakpoint.cc>
In-Reply-To: <20080711190209.GA7401@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
Cc: Dave Chinner <david@fromorbit.com>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Sebastian Siewior wrote:
> * Dave Chinner | 2008-07-11 18:42:49 [+1000]:
> 
>> Oh - you must be running a debug XFS.  CONFIG_XFS_DEBUG was only
>> introduced in 2.6.26-rc1 and defaults to 'N', so you must have
>> selected the non-default option when prompted. This will cause your
>> machine to oops at the slightest inconsistency that is found,
>> regardless of whether it is fatal or not. Like the help text says,
>> don't set this unless you are an XFS developer....
> Could you please add this to the Kconfig entry. Debug mode is usually
> noisy, little slower and mostly usefull just to the developers but *I*
> would not expect to BUG() in the non-fatal case.
> Not sure but if this is just for hch and you than a define in xfs.h
> might be safer :)
> 
>> Dave.
> Sebastian
> 
> 

heh, it ws hch who added the Kconfig option in the first place :)

> Back when I first submitted XFS for mainline inclusion we made the
> decision that the debug code is far to extensive to be accidentally
> enabled by users in mainline.  But then again it's often quite useful
> to track problems down and hacking the makefile all the time is rather
> annoying.  Given all the debug options with even more overhead like
> lockdep or DEBUG_PAGE_ALLOC users (or rather developers) should know
> by now what they're doing.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

But yeah, a bit more of a stern warning about the fatality of the debug
tests might be useful.  Just in case anyone reads that part and not the
"only use this if you are an xfs developer" part ;)

-Eric
