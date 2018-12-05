Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:14166 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728256AbeLEVuD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 16:50:03 -0500
Date: Thu, 6 Dec 2018 08:50:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: use a dedicated SLAB cache for sector sized buffer
 data
Message-ID: <20181205215000.GU6311@dastard>
References: <20181205172023.5061-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205172023.5061-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, tom.leiming@gmail.com, vkuznets@redhat.com

On Wed, Dec 05, 2018 at 09:20:23AM -0800, Christoph Hellwig wrote:
> XFS currently uses a slab allocator for buffers smaller than the page

Currently uses heap allocated memory?

> size to avoid wasting too much memory.  But this can cause a problem
> with slub debugging turned on as the allocations might not be naturally
> aligned.  On block devices that require sector size alignment this can
> lead to data corruption.
> 
> Give that our smaller than page size buffers are always sector sized
> on a live file system, we can just create a kmem_cache with an
> explicitly specified alignment requirement for this case to fix this
> case without much effort.

I thought you were looking at using the page_frag infrastructure for
this so we didn't need a slab per filesystem for this?

I think there's a problem with this code - we can have different
sector sizes for different devices in the filesystem. e.g. the log
can have a different sector size to the data device, and this may
matter for log recovery which does a lot of single sector IO.

Hence I think this slab really needs to be managed as a property of
the of the buftarg rather than be a global property of the
xfs_mount. in most cases the log and data devices are the same
buftarg, but we should attempt to handle this special case
correctly...

Other than that, the code looks fine to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
