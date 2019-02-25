Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:23589 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726888AbfBYUL2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Feb 2019 15:11:28 -0500
Date: Tue, 26 Feb 2019 07:11:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: allocate sector sized IO buffer via page_frag_alloc
Message-ID: <20190225201122.GF23020@dastard>
References: <20190225040904.5557-1-ming.lei@redhat.com>
 <20190225043648.GE23020@dastard>
 <20190225084623.GA8397@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190225084623.GA8397@ming.t460p>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Vitaly Kuznetsov <vkuznets@redhat.com>, Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Christopher Lameter <cl@linux.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org, linux-block@vger.kernel.org

On Mon, Feb 25, 2019 at 04:46:25PM +0800, Ming Lei wrote:
> On Mon, Feb 25, 2019 at 03:36:48PM +1100, Dave Chinner wrote:
> > On Mon, Feb 25, 2019 at 12:09:04PM +0800, Ming Lei wrote:
> > > XFS uses kmalloc() to allocate sector sized IO buffer.
> > ....
> > > Use page_frag_alloc() to allocate the sector sized buffer, then the
> > > above issue can be fixed because offset_in_page of allocated buffer
> > > is always sector aligned.
> > 
> > Didn't we already reject this approach because page frags cannot be
> 
> I remembered there is this kind of issue mentioned, but just not found
> the details, so post out the patch for restarting the discussion.

As previously discussed, the only solution that fits all use cases
we have to support are a slab caches that do not break object
alignment when slab debug options are turned on.

> > reused and that pages allocated to the frag pool are pinned in
> > memory until all fragments allocated on the page have been freed?
> 
> Yes, that is one problem. But if one page is consumed, sooner or later,
> all fragments will be freed, then the page becomes available again.

Ah, no, your assumption about how metadata caching in XFS works is
flawed. Some metadata ends up being cached for the life of the
filesystem because it is so frequently referenced it never gets
reclaimed. AG headers, btree root blocks, etc.  And the XFS metadata
cache hangs on to such metadata even under extreme memory pressure
because if we reclaim it then any filesystem operation will need to
reallocate that memory to clean dirty pages and that is the very
last thing we want to do under extreme memory pressure conditions.

If allocation cannot reuse holes in pages (i.e. works as a proper
slab cache) then we are going to blow out the amount of memory that
the XFS metadata cache uses very badly on filesystems where block
size != page size. 

> > i.e. when we consider 64k page machines and 4k block sizes (i.e.
> > default config), every single metadata allocation is a sub-page
> > allocation and so will use this new page frag mechanism. IOWs, it
> > will result in fragmenting memory severely and typical memory
> > reclaim not being able to fix it because the metadata that pins each
> > page is largely unreclaimable...
> 
> It can be an issue in case of IO timeout & retry.

This makes no sense to me. Exactly how does filesystem memory
allocation affect IO timeouts and any retries the filesystem might
issue?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
