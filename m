Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53060 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727337AbeLEV4w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:56:52 -0500
Date: Wed, 5 Dec 2018 22:56:51 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: use a dedicated SLAB cache for sector sized
 buffer data
Message-ID: <20181205215651.GA4033@lst.de>
References: <20181205172023.5061-1-hch@lst.de> <20181205215000.GU6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205215000.GU6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, tom.leiming@gmail.com, vkuznets@redhat.com

On Thu, Dec 06, 2018 at 08:50:00AM +1100, Dave Chinner wrote:
> On Wed, Dec 05, 2018 at 09:20:23AM -0800, Christoph Hellwig wrote:
> > XFS currently uses a slab allocator for buffers smaller than the page
> 
> Currently uses heap allocated memory?

Or kmalloc, yeah.

> I thought you were looking at using the page_frag infrastructure for
> this so we didn't need a slab per filesystem for this?

I did look into it, but using page_frag for buffers creates an inherent
memory leak given that page_frag never reuses a freed fragement.  So
until all fragments in a page are free all the others bits effectively
leak, which is pretty bad on the buffer cache.

> I think there's a problem with this code - we can have different
> sector sizes for different devices in the filesystem. e.g. the log
> can have a different sector size to the data device, and this may
> matter for log recovery which does a lot of single sector IO.

That's fine because log recovery is one I/O at a time, and we always
free the current buffer before allocating the next one, so we'd waste
the memory one way or another.

> Hence I think this slab really needs to be managed as a property of
> the of the buftarg rather than be a global property of the
> xfs_mount. in most cases the log and data devices are the same
> buftarg, but we should attempt to handle this special case
> correctly...

We could waste another slab cache on the block device, but as said
we don't really save any memory by creating a new cache, we actually
waste memory due to the overhead.
