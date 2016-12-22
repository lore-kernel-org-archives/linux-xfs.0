Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57242 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758084AbcLVI5W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 03:57:22 -0500
Date: Thu, 22 Dec 2016 00:57:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS_IOC_FSEMAP requirements
Message-ID: <20161222085716.GA23054@infradead.org>
References: <20161220102935.ppt7ixjoh53uhu2e@eorzea.usersys.redhat.com>
 <20161221014816.GC5487@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161221014816.GC5487@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 20, 2016 at 05:48:16PM -0800, Darrick J. Wong wrote:
> As for project ideas, I can think of a handful of them -- reworking the
> in-core extent tree not to require large contiguous memory allocations,
> sorting out reflink+dax,

FYI, I have significant work done on both of them.  I just need to sort
out the ENOSPC issues (just got another report where we're running into
ENOSPC for inobt updates, so there might be even more dragons there)
and the DAX DIO rework, which is 90% of the work for reflink+DAX.

For the extent tree I played around with a simple rbtree, but I need
to finish abstracting away the access the the extent list - the first
pile of that landed for 4.10, but there is a lot more to be done before
I can easily change the representation.  I'm also not sure anymore
that the rbtree is the best choice.

> and stomping out the rest of the buffer head
> usage,

The next for that is the switch bmap and buffered reads for iomap,
I have a version that works for blocksize == page_size, just need
to finish the blocksize < pagesize case.  Once get_blocks is gone
we should be able to just kill buffer_heads trivially for the blocksize
== pagesize case, it's just the small block size that will require
a significant effort.  My initial plan was to just keep buffer_heads
for those as the first step while not using them for the common
blocksize == pagesize case.
