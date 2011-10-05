Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p954b6ZW085569 for <xfs@oss.sgi.com>; Tue, 4 Oct 2011 23:37:06 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2946B1A8C9A
	for <xfs@oss.sgi.com>; Tue,  4 Oct 2011 21:37:04 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	TJJW1Dnw1BG0iOMn for <xfs@oss.sgi.com>;
	Tue, 04 Oct 2011 21:37:04 -0700 (PDT)
Date: Wed, 5 Oct 2011 15:36:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: SEEK_DATA/SEEK_HOLE support
Message-ID: <20111005043659.GO3159@dastard>
References: <4E887D7F.2010306@oracle.com>
	<20111002154259.GA14543@infradead.org>
	<4E888C0D.9060701@oracle.com> <20111002175902.GA9420@infradead.org>
	<4E89343B.4030007@oracle.com> <20111003234305.GM3159@dastard>
	<20111004130208.GA19263@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111004130208.GA19263@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com

On Tue, Oct 04, 2011 at 09:02:08AM -0400, Christoph Hellwig wrote:
> On Tue, Oct 04, 2011 at 10:43:05AM +1100, Dave Chinner wrote:
> > The lookup is pretty simple - if there's cached data over the
> > unwritten range, then I'm considering it a data range. If there's no
> > cached data over the unwritten extent, it's a hole. That makes the
> > lookup simply a case of finding the first cached page in the
> > unwritten extent.
> > 
> > It'll end up reading something like this:
> > 
> > 	iomap = offset_to_extent(offset);
> > 	first_index = extent_to_page_index(iomap);
> > 
> > 	nr_found = pagevec_lookup(&pvec, inode->i_mapping, first_index, 1);
> > 	if (!nr_found)
> > 		break;
> > 
> > 	offset = page->index << PAGECACHE_SHIFT;
> > 	pagevec_release(&pvec);
> > 
> > 	/* If we fell off the end of the extent lookup next extent */
> > 	if (offset >= end_of_extent(iomap)) {
> > 		offset = end_of_extent(iomap);
> > 		goto next_extent;
> > 	}
> > 
> > All the extent manipulations are pretty filesystem specific, so
> > there's not much that can be extracted into generic helper, I
> > think...
> 
> Actually pretty similar code will work just fine if you passt the
> start + len of the extents in (which we got from looking it up
> fs-specificly):
> 
> Note that we have to look for both dirty and writeback pages to
> make it safe.

That will only work if you can prevent concurrent unwritten extent
conversion from happening while we do the separate tag lookups on
the range because it requires two radix tree tag lookups rather than
just one index lookup. i.e. miss the dirty page because it went
dirty->writeback during the dirty tag search, and miss the same page
when doing the writeback lookup because it went writeback->clean
very quickly due to IO completion.

So to stop that from happening, it requires that filesystems can
exclude unwritten extent conversion from happening while a
SEEK_HOLE/SEEK_DATA operation is in progress, and that the
filesystem can safely do mapping tree lookups while providing that
extent tree exclusion.  I know that XFS has no problems here, but
filesystems that use i_mutex for everything might be in trouble.

Besides, if we just look for pages in the cache over unwritten
extents (i.e. someone has treated it as data already), then it can
be done locklessly without having to worry about page state changes
occurring concurrently...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
