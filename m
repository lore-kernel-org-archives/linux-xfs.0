Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46573 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726016AbfHFVG0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Aug 2019 17:06:26 -0400
Date: Wed, 7 Aug 2019 07:05:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/24] xfs: correctly acount for reclaimable slabs
Message-ID: <20190806210515.GF7777@dread.disaster.area>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-13-david@fromorbit.com>
 <20190806055249.GB25736@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806055249.GB25736@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Mon, Aug 05, 2019 at 10:52:49PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 01, 2019 at 12:17:40PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The XFS inode item slab actually reclaimed by inode shrinker
> > callbacks from the memory reclaim subsystem. These should be marked
> > as reclaimable so the mm subsystem has the full picture of how much
> > memory it can actually reclaim from the XFS slab caches.
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Btw, I wonder if we should just kill off our KM_ZONE_* defined.  They
> just make it a little harder to figure out what is actually going on
> without a real benefit.

Yeah, they don't serve much purpose now, it might be worth cleaning
up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
