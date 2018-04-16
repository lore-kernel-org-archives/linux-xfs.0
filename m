Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50482 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752783AbeDPRDy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Apr 2018 13:03:54 -0400
Date: Mon, 16 Apr 2018 10:03:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs: xfs: Change return type to vm_fault_t
Message-ID: <20180416170329.GA5203@magnolia>
References: <20180414215937.GH5572@dastard>
 <20180414222407.GA15294@bombadil.infradead.org>
 <20180415072121.GA13601@infradead.org>
 <20180415111104.GB25513@bombadil.infradead.org>
 <20180415120426.GA10479@infradead.org>
 <20180415123427.GA11379@bombadil.infradead.org>
 <20180416085707.GB30363@infradead.org>
 <20180416111423.GA26022@bombadil.infradead.org>
 <20180416112353.GA22921@infradead.org>
 <20180416113139.GB26022@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180416113139.GB26022@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, Souptick Joarder <jrdr.linux@gmail.com>, linux-xfs@vger.kernel.org

On Mon, Apr 16, 2018 at 04:31:39AM -0700, Matthew Wilcox wrote:
> On Mon, Apr 16, 2018 at 04:23:53AM -0700, Christoph Hellwig wrote:
> > On Mon, Apr 16, 2018 at 04:14:23AM -0700, Matthew Wilcox wrote:
> > > That's an unreasonable request.  It would (usually) require writing more
> > > code to convert errnos into VM_FAULT returns.  And that code would get
> > > precisely zero testing upstream because the next commit would come along
> > > and delete it, replacing it with calls to common code.
> > 
> > Well, introduce the damn common code first.  It does not require
> > using the typedef in any way.
> 
> Already done.

I wondered "Yeah, why isn't this one big series?  Where are the rest of
the patches to convert everything else?" and then realized the patch
author landed the function pointer prototype changes in mm.h prior to
4.17-rc1 and is now playing scattershot catch-up across the tree...

...hm, the original mm patch wasn't cc'd to fsdevel either, so that's
probably why I never heard of any of this until now.

So, uh, why wasn't this whole series (all the mm changes and all the
required fs changes) sent out for review prior to the merge window?

I don't like "Hey we bitrotted your filesystem without telling you, now
here's a patch to fix it..."  The code change looks ok, but now I'm
going to schedule some time to go digging to see if there's anything
else lurking beneath the surface here.

> > In this current form of single patches:  NAK to anything I maintain
> > or review.
> 
> Yeah, we already have a plan for dealing with arsehole or MIA maintainers.
> Fortunately, you're not actually the maintainer for XFS, so it'll be up
> to Darrick whether to take it or not.

I also dislike being pitted against the other XFS developers.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
