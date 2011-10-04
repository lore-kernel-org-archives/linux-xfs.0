Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p94D2Dnt042837 for <xfs@oss.sgi.com>; Tue, 4 Oct 2011 08:02:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 557BB4D1972
	for <xfs@oss.sgi.com>; Tue,  4 Oct 2011 06:02:10 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3HgBihncslKBh5b3 for <xfs@oss.sgi.com>;
	Tue, 04 Oct 2011 06:02:10 -0700 (PDT)
Date: Tue, 4 Oct 2011 09:02:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: SEEK_DATA/SEEK_HOLE support
Message-ID: <20111004130208.GA19263@infradead.org>
References: <4E887D7F.2010306@oracle.com>
	<20111002154259.GA14543@infradead.org>
	<4E888C0D.9060701@oracle.com> <20111002175902.GA9420@infradead.org>
	<4E89343B.4030007@oracle.com> <20111003234305.GM3159@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111003234305.GM3159@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com

On Tue, Oct 04, 2011 at 10:43:05AM +1100, Dave Chinner wrote:
> The lookup is pretty simple - if there's cached data over the
> unwritten range, then I'm considering it a data range. If there's no
> cached data over the unwritten extent, it's a hole. That makes the
> lookup simply a case of finding the first cached page in the
> unwritten extent.
> 
> It'll end up reading something like this:
> 
> 	iomap = offset_to_extent(offset);
> 	first_index = extent_to_page_index(iomap);
> 
> 	nr_found = pagevec_lookup(&pvec, inode->i_mapping, first_index, 1);
> 	if (!nr_found)
> 		break;
> 
> 	offset = page->index << PAGECACHE_SHIFT;
> 	pagevec_release(&pvec);
> 
> 	/* If we fell off the end of the extent lookup next extent */
> 	if (offset >= end_of_extent(iomap)) {
> 		offset = end_of_extent(iomap);
> 		goto next_extent;
> 	}
> 
> All the extent manipulations are pretty filesystem specific, so
> there's not much that can be extracted into generic helper, I
> think...

Actually pretty similar code will work just fine if you passt the
start + len of the extents in (which we got from looking it up
fs-specificly):

Note that we have to look for both dirty and writeback pages to
make it safe.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
