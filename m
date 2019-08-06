Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52932 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFFwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 01:52:50 -0400
Date: Mon, 5 Aug 2019 22:52:49 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/24] xfs: correctly acount for reclaimable slabs
Message-ID: <20190806055249.GB25736@infradead.org>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801021752.4986-13-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Thu, Aug 01, 2019 at 12:17:40PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The XFS inode item slab actually reclaimed by inode shrinker
> callbacks from the memory reclaim subsystem. These should be marked
> as reclaimable so the mm subsystem has the full picture of how much
> memory it can actually reclaim from the XFS slab caches.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, I wonder if we should just kill off our KM_ZONE_* defined.  They
just make it a little harder to figure out what is actually going on
without a real benefit.
