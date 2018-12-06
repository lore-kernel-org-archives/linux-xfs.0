Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:36324
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727358AbeLFA7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 19:59:43 -0500
Date: Thu, 6 Dec 2018 11:59:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: use a dedicated SLAB cache for sector sized
 buffer data
Message-ID: <20181206005939.GX6311@dastard>
References: <20181205225147.12626-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181205225147.12626-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, tom.leiming@gmail.com, vkuznets@redhat.com

On Wed, Dec 05, 2018 at 02:51:47PM -0800, Christoph Hellwig wrote:
> XFS currently uses kmalloc for buffers smaller than the page size to
> avoid wasting too much memory.  But this can cause a problem with slub
> debugging turned on as the allocations might not be naturally aligned.
> On block devices that require sector size alignment this can lead to
> data corruption.
> 
> Give that our smaller than page size buffers are always sector sized
> on a live file system, we can just create a kmem_cache with an
> explicitly specified alignment requirement for this case to fix this
> case without much effort.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now. I'll throw it in my test kernels because I've got a
mix of different sector size configs I test against and see if
anything whacky falls out...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
