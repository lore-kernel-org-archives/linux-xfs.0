Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23280 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727337AbeLEWbn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 17:31:43 -0500
Date: Thu, 6 Dec 2018 09:31:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use a dedicated SLAB cache for sector sized buffer
 data
Message-ID: <20181205223139.GV6311@dastard>
References: <20181205172023.5061-1-hch@lst.de>
 <20181205215000.GU6311@dastard>
 <20181205215651.GA4033@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205215651.GA4033@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, tom.leiming@gmail.com, vkuznets@redhat.com

On Wed, Dec 05, 2018 at 10:56:51PM +0100, Christoph Hellwig wrote:
> On Thu, Dec 06, 2018 at 08:50:00AM +1100, Dave Chinner wrote:
> > On Wed, Dec 05, 2018 at 09:20:23AM -0800, Christoph Hellwig wrote:
> > > XFS currently uses a slab allocator for buffers smaller than the page
> > 
> > Currently uses heap allocated memory?
> 
> Or kmalloc, yeah.
> 
> > I thought you were looking at using the page_frag infrastructure for
> > this so we didn't need a slab per filesystem for this?
> 
> I did look into it, but using page_frag for buffers creates an inherent
> memory leak given that page_frag never reuses a freed fragement.  So
> until all fragments in a page are free all the others bits effectively
> leak, which is pretty bad on the buffer cache.

Ok, that's definitely a showstopper. I didn't notice this
behaviour when I had a quick look at it back when it was first
mentioned.

> > I think there's a problem with this code - we can have different
> > sector sizes for different devices in the filesystem. e.g. the log
> > can have a different sector size to the data device, and this may
> > matter for log recovery which does a lot of single sector IO.
> 
> That's fine because log recovery is one I/O at a time, and we always
> free the current buffer before allocating the next one, so we'd waste
> the memory one way or another.

True. Can you mention this in the commit message so it gets recorded
with the change and doesn't get lost in the mists of time?

> > Hence I think this slab really needs to be managed as a property of
> > the of the buftarg rather than be a global property of the
> > xfs_mount. in most cases the log and data devices are the same
> > buftarg, but we should attempt to handle this special case
> > correctly...
> 
> We could waste another slab cache on the block device, but as said
> we don't really save any memory by creating a new cache, we actually
> waste memory due to the overhead.

Slub will merge all into the one cache per sector size, anyway, so
there really isn't any wasted memory to speak of here.

Regardless, with a commit message update to explain why a single
cache is fine, then I'm happy with this.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
