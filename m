Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Jul 2006 10:01:32 -0700 (PDT)
Received: from orca.ele.uri.edu (orca.ele.uri.edu [131.128.51.63])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6LH1JDW002953
	for <linux-xfs@oss.sgi.com>; Fri, 21 Jul 2006 10:01:20 -0700
Subject: Re: stable xfs
From: Ming Zhang <mingz@ele.uri.edu>
Reply-To: mingz@ele.uri.edu
In-Reply-To: <20060721160709.GB12347@tuatara.stupidest.org>
References: <17598.2129.999932.67127@base.ty.sabi.co.UK>
	 <1153314670.2691.14.camel@localhost.localdomain>
	 <20060720061527.GB18135@tuatara.stupidest.org>
	 <1153404502.2768.50.camel@localhost.localdomain>
	 <20060720161707.GB26748@tuatara.stupidest.org>
	 <1153413481.2768.65.camel@localhost.localdomain>
	 <20060720190401.GA28836@tuatara.stupidest.org>
	 <1153441178.2768.158.camel@localhost.localdomain>
	 <20060721032632.GA4138@tuatara.stupidest.org>
	 <1153487431.2841.8.camel@localhost.localdomain>
	 <20060721160709.GB12347@tuatara.stupidest.org>
Content-Type: text/plain
Date: Fri, 21 Jul 2006 13:00:44 -0400
Message-Id: <1153501244.2841.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>, Linux XFS <linux-xfs@oss.sgi.com>

On Fri, 2006-07-21 at 09:07 -0700, Chris Wedgwood wrote:
> On Fri, Jul 21, 2006 at 09:10:31AM -0400, Ming Zhang wrote:
> 
> > then what is the benefit? because files under same dir can be accessed
> > with locality so put close will reduce disk head seek?
> 
> yes
> 
> > other than this, what else benefit?
> 
> that alone has a measurable benefit to me (i have an overlay
> filesystem over many smaller 400 to 500GB filesystems so i don't get
> the benefit of many spindles to reduce average seek times)

what u mean overlay fs over small fs? like a unionfs?

> 
> > so if i have 500GB file, will it be copied to another 500GB temp
> > file?
> 

but other than fsr. there is no better way for this right?

of course, preallocate is always good. but i do not have control over
applications.


> yes, which in many cases isn't always derisable because:
> 
>   * if the file had a small number of extents in the first place,
>     reducing them slightly more isn't much of a gain (ie. going from
>     say 11 to 10 is argubly pointless) (i have a patch to specifiy
>     the miniumum gains before doing the copy somewhere)
> 
>   * if the file changes during the copy, then it will be skipped until
>     next time, for larger files this is problematic,  you could
>     argue attemtping to fsr a file that is less than <n> seconds old
>     is pointless as it has a high chance of being active (i have a
>     patch for that too))

sounds like a useful patch. :P will it be merged into fsr code?

> 
>   * fsr has no global overview of what it's doing, so it never does
>     things like 'move this file out of the way to make room for this
>     one' (it can't do this w/o assistance right now), and of course it
>     can't move inodes w/o changing them so there are limits to what
>     can be done anyhow

what kind of assistance you mean?

> 
