Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58270 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405370AbfHBSeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 14:34:22 -0400
Date: Fri, 2 Aug 2019 11:34:19 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 09/24] xfs: don't allow log IO to be throttled
Message-ID: <20190802183419.GC5597@bombadil.infradead.org>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-10-david@fromorbit.com>
 <F1E7CC65-D2CB-4078-9AA3-9D172ECDE17B@fb.com>
 <20190801235849.GO7777@dread.disaster.area>
 <7093F5C3-53D2-4C49-9C0D-64B20C565D18@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7093F5C3-53D2-4C49-9C0D-64B20C565D18@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: Dave Chinner <david@fromorbit.com>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On Fri, Aug 02, 2019 at 02:11:53PM +0000, Chris Mason wrote:
> Yes and no.  At some point important FS threads have the potential to 
> wait on every single REQ_META IO on the box, so every single REQ_META IO 
> has the potential to create priority inversions.

[...]

> Tejun reminded me that in a lot of ways, swap is user IO and it's 
> actually fine to have it prioritized at the same level as user IO.  We 
> don't want to let a low prio app thrash the drive swapping things in and 
> out all the time, and it's actually fine to make them wait as long as 
> other higher priority processes aren't waiting for the memory.  This 
> depends on the cgroup config, so wrt your current patches it probably 
> sounds crazy, but we have a lot of data around this from the fleet.

swap is only user IO if we're doing the swapping in response to an
allocation done on behalf of a user thread.  If one of the above-mentioned
important FS threads does a memory allocation which causes swapping,
that priority needs to be inherited by the IO.
