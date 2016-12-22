Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:59143 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S966791AbcLVUIN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 15:08:13 -0500
Date: Fri, 23 Dec 2016 07:07:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS_IOC_FSEMAP requirements
Message-ID: <20161222200729.GT4326@dastard>
References: <20161220102935.ppt7ixjoh53uhu2e@eorzea.usersys.redhat.com>
 <20161221014816.GC5487@birch.djwong.org>
 <20161222085716.GA23054@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161222085716.GA23054@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Dec 22, 2016 at 12:57:16AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 20, 2016 at 05:48:16PM -0800, Darrick J. Wong wrote:
> > As for project ideas, I can think of a handful of them -- reworking the
> > in-core extent tree not to require large contiguous memory allocations,
> > sorting out reflink+dax,
> 
> FYI, I have significant work done on both of them.  I just need to sort
> out the ENOSPC issues (just got another report where we're running into
> ENOSPC for inobt updates, so there might be even more dragons there)
> and the DAX DIO rework, which is 90% of the work for reflink+DAX.
> 
> For the extent tree I played around with a simple rbtree, but I need
> to finish abstracting away the access the the extent list - the first
> pile of that landed for 4.10, but there is a lot more to be done before
> I can easily change the representation.  I'm also not sure anymore
> that the rbtree is the best choice.

And extent per rbtree node is almost certainly not the right choice
because of the object count requirement - we do not want to a
kmalloc for every extent we add to the list.  At I was looking at
replacing the indirect array with an rbtree - potentially the
interval tree variant - so that we still have pages of extents and
increments/walking is still mainly just pointer increments.

That was before I found out how easy it is to use the rhashtable
code and how much faster it is for large lists than an rbtree.
That's the way I've been thinking recently, anyway...

> > and stomping out the rest of the buffer head
> > usage,
> 
> The next for that is the switch bmap and buffered reads for iomap,
> I have a version that works for blocksize == page_size, just need
> to finish the blocksize < pagesize case.  Once get_blocks is gone
> we should be able to just kill buffer_heads trivially for the blocksize
> == pagesize case, it's just the small block size that will require
> a significant effort.  My initial plan was to just keep buffer_heads
> for those as the first step while not using them for the common
> blocksize == pagesize case.

My plan for the blocksize < page size was simply to track dirtines
on pages and forget about sub-page dirtiness. That way the
IO path is simply iterates entire pages to cover all the
mapped regions of the page. iomap already does that for us, and I
started on making writepage work that way, too. Haven't got to
working writepage code yet, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
