Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p93NhBjV005175 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 18:43:12 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 555B6143E529
	for <xfs@oss.sgi.com>; Mon,  3 Oct 2011 16:49:43 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9ip0MkNY8l6GMTYA for <xfs@oss.sgi.com>;
	Mon, 03 Oct 2011 16:49:43 -0700 (PDT)
Date: Tue, 4 Oct 2011 10:43:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: SEEK_DATA/SEEK_HOLE support
Message-ID: <20111003234305.GM3159@dastard>
References: <4E887D7F.2010306@oracle.com>
	<20111002154259.GA14543@infradead.org>
	<4E888C0D.9060701@oracle.com> <20111002175902.GA9420@infradead.org>
	<4E89343B.4030007@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E89343B.4030007@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Oct 03, 2011 at 12:04:11PM +0800, Jeff Liu wrote:
> On 10/03/2011 01:59 AM, Christoph Hellwig wrote:
> 
> > On Mon, Oct 03, 2011 at 12:06:37AM +0800, Jeff Liu wrote:
> >> IMHO, to avoid data loss in some user application like cp(1), for
> >> unwritten extents, we always need to check the pages status.  Just as
> >> you mentioned above, return the map offset if pages are dirty for
> >> SEEK_DATA, or a hole found.
> > 
> > I'd suggest to first implement the simple versions I schemed below,
> > which would treat unwritten extents as data.  That is sub-optimal,
> > but a) safe and b) easy to implement.  The second step would be to
> > add probing for unwritten extents, which is even something we could
> > do as a common helper routine shared by filesystems.
> 
> So I'll wait for Dave's patch become ready, and then continue to improve
> it if necessary.
> In the meantime, I'll try to figure out how to add a helper which can be
> shared by all file systems for UNWRITTEN extents.

The lookup is pretty simple - if there's cached data over the
unwritten range, then I'm considering it a data range. If there's no
cached data over the unwritten extent, it's a hole. That makes the
lookup simply a case of finding the first cached page in the
unwritten extent.

It'll end up reading something like this:

	iomap = offset_to_extent(offset);
	first_index = extent_to_page_index(iomap);

	nr_found = pagevec_lookup(&pvec, inode->i_mapping, first_index, 1);
	if (!nr_found)
		break;

	offset = page->index << PAGECACHE_SHIFT;
	pagevec_release(&pvec);

	/* If we fell off the end of the extent lookup next extent */
	if (offset >= end_of_extent(iomap)) {
		offset = end_of_extent(iomap);
		goto next_extent;
	}

All the extent manipulations are pretty filesystem specific, so
there's not much that can be extracted into generic helper, I
think...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
