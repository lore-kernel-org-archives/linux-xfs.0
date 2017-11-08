Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:61823 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752872AbdKHXrJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 18:47:09 -0500
Date: Thu, 9 Nov 2017 10:47:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: WTF? Re: [PATCH] License cleanup: add SPDX GPL-2.0 license
 identifier to files with no license
Message-ID: <20171108234704.GH4094@dastard>
References: <20171107020607.GA26910@magnolia>
 <20171107072040.GB4586@infradead.org>
 <20171107073940.GB4654@kroah.com>
 <20171107172042.GB26910@magnolia>
 <20171107182903.GA4588@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171107182903.GA4588@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, linux-kernel@vger.kernel.org

On Tue, Nov 07, 2017 at 07:29:03PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Nov 07, 2017 at 09:20:42AM -0800, Darrick J. Wong wrote:
> > On Tue, Nov 07, 2017 at 08:39:40AM +0100, Greg Kroah-Hartman wrote:
> > > On Mon, Nov 06, 2017 at 11:20:40PM -0800, Christoph Hellwig wrote:
> > > > NAK, for both the libxfs patch and the kernel one.
> > > 
> > > What libxfs patch?  And what "kernel one" are you referring to here?
> > > 
> > > > I wrote the file and it has no copyright header because it conatians
> > > > trivial, non-copyrightable code.
> > > 
> > > What file exactly?
> > > 
> > > And from what I know, there is nothing that is "non-copyrightable".
> > > 
> > > And this isn't changing the copyright of _ANYTHING_ it is just putting
> > > the explicit license of the file, on each file in the kernel, because it
> > > needs to be tracked.
> > > 
> > > > I don't know why people think they can touch license information on
> > > > files I've written without even asking me.
> > > 
> > > Nothing was changed, the license should be the exact same as it was
> > > before.  But as I don't know what file you are referring to here, it's a
> > > bit hard to determine what you are talking about exactly :(
> > 
> > fs/xfs/libxfs/xfs_cksum.h
> 
> Given that it had no license text on it at all, it "defaults" to GPLv2,
> so the GPLv2 SPDX identifier was added to it.

I'll point out here that this file is shared with a userspace
package that has a mixed LGPL/GPL code base, so even if we disregard
what Christoph says, this file could actually be LGPL (like
fs/xfs/libxfs/xfs_fs.h) and not GPL. So from that perspective alone,
your process on deciding what license tag should be used is
flawed and these changes needed, at minimum, maintainer review.

IMO, unannounced, unreviewed tree wide change via a back-door
commits sent straight to Linus reek of an attempt to avoid review
and oversight.  And that is *completely unacceptible* when making
claims about important details like licenses for *code you do
not know anything about*. 

We have a documented process for a reason: to stop shit like this
from happening. 

> No copyright was changed, nothing at all happened except we explicitly
> list the license of the file, instead of it being "implicit" before.

You keep saying "no copyright has changed", despite being given an
explicit statement by the code author that this is *exactly what you
have done*.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
