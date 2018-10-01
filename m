Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:1955 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725936AbeJBF5j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Oct 2018 01:57:39 -0400
Date: Tue, 2 Oct 2018 09:17:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't use slab for metadata buffers
Message-ID: <20181001231726.GK18567@dastard>
References: <20181001220911.4679-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001220911.4679-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 01, 2018 at 03:09:11PM -0700, Christoph Hellwig wrote:
> It turns out the slub allocator won't always give us aligned memory,
> and on some controllers this can lead to data corruption.  Remove the
> special slab backed fast path in xfs_buf_allocate_memory.  The only
> downside of this is a slight waste of memory for metadata buffers
> smaller than page size.

NAK.

This approach creates a massive problem for 64k page size machines
with sub-page size filesystem block sizes (i.e. default
configurations). Every buffer will now be made up of a 64k page,
even though they typically only use 4kB of that page. i.e. this
blows the metadata cache footprint out by an order of magnitude and
that's going to have a massive impact of system performance.

Yes, we need to fix this alignment problem (that has only recently
been reported for the Xen blk-front driver) but removing sub-page
buffer support is not the right way to fix this. We need to:

- go back to using the block device page cache and sharing pages
  across buffers (yuk!), or
- replace the heap calls with our own aligned slabs, or
- implement a generic block layer heap that guarantees storage
  hardware aligned sub-page buffers (as I suggested to Jens)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
