Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:6561 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750711AbeEaXM3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 19:12:29 -0400
Date: Fri, 1 Jun 2018 09:11:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4 V2] Remove a few macros
Message-ID: <20180531231153.GO10363@dastard>
References: <20180307090506.30199-1-cmaiolino@redhat.com>
 <b5e4681b-8198-82fc-e4da-bfbad08cf32d@sandeen.net>
 <20180531171909.cedwobpqlaf2h5ly@odin.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180531171909.cedwobpqlaf2h5ly@odin.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org

On Thu, May 31, 2018 at 07:19:09PM +0200, Carlos Maiolino wrote:
> On Thu, May 31, 2018 at 11:58:51AM -0500, Eric Sandeen wrote:
> > On 3/7/18 3:05 AM, Carlos Maiolino wrote:
> > > Hi,
> > > 
> > > this is a second version of the patchset aimed to clean up some old macros from
> > > xfsprogs, as the objective to bring xfs_buf handling code closer to kernel code.
> > > 
> > > It fixes some pointer castings Dave mentioned on the V1 patch, also, it removes
> > > a few unneeded castings I spotted while reviewing the ones Dave mentioned.
> > > 
> > > Cheers
> > > 
> > > Carlos Maiolino (4):
> > >    Get rid of XFS_BUF_PTR() macro
> > >    Get rid of XFS_BUF_TARGET() macro
> > >    get rid of XFS_BUF_COUNT() macro
> > >    Get rid of XFS_BUF_SET_COUNT() macro
> > 
> > Sorry, I'd still like to merge these but they need a rebase now.
> > And did the casting-wars between dchinner & hch ever get resolved?
> > 
> 
> 
> I don't know actually, I don't remember seeing Dave replying agreeing or not
> with hch

What was there to argue? Christoph wants us to rely on undocumented,
compiler specific behaviour(*), I want it the pointer arithmetic to
be explicitly correct with a cast.

Maintainer's choice, really.

Cheers,

Dave.

(*) It's been repeatedly demonstrated that the gcc developers don't
care if they break code that relies on undefined behaviour in the C
standard.
-- 
Dave Chinner
david@fromorbit.com
