Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55955 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941542AbcLVUYO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Dec 2016 15:24:14 -0500
Date: Thu, 22 Dec 2016 12:24:13 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS_IOC_FSEMAP requirements
Message-ID: <20161222202413.GA4951@infradead.org>
References: <20161220102935.ppt7ixjoh53uhu2e@eorzea.usersys.redhat.com>
 <20161221014816.GC5487@birch.djwong.org>
 <20161222085716.GA23054@infradead.org>
 <20161222200729.GT4326@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161222200729.GT4326@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Fri, Dec 23, 2016 at 07:07:29AM +1100, Dave Chinner wrote:
> And extent per rbtree node is almost certainly not the right choice
> because of the object count requirement - we do not want to a
> kmalloc for every extent we add to the list.

People are doing a kmalloc for each Packet / I/O at millions of 
I/Os per second, so I'm not that worried about that.  It's certainly
more efficient than the crazy amount of memmoves we're currently
doing based on my first preliminary numbers.

That beeing said I'm still looking for something even better.

> That was before I found out how easy it is to use the rhashtable
> code and how much faster it is for large lists than an rbtree.
> That's the way I've been thinking recently, anyway...

hashes generally aren't very good for sequential iteration, of which
we do a lot for the extent tree.  That beeing said it was on my todo
list to simply give it a try after I saw the buffer cache patch.

> My plan for the blocksize < page size was simply to track dirtines
> on pages and forget about sub-page dirtiness. That way the
> IO path is simply iterates entire pages to cover all the
> mapped regions of the page. iomap already does that for us, and I
> started on making writepage work that way, too. Haven't got to
> working writepage code yet, though.

There are four things that buffer_heads are used for in the blocksize <
pagesize case.

 - dirties - could be handled as mentioned by you
 - uptodateness - we could always read in the whole page and things
	would just work.  But on 64k page size this actually seems
	to be a performance issue, otherwise we wouldn't have the
	is_partially_uptodate address_space operation
 - tracking the block number for pure overwrites.  Probably not
   	really needed
 - tracking of I/O completions - we must write out the whole page
	on a writepage call, and something must track when all I/Os
	for the page have finished so that we can unlock it (or
	drop the writepage bit for the write case).

Nothing unsolveable, but at least the last one is a little nasty,
and doing the dumb things for 1 and 2 might cause performance
regressions.
