Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0L1vYc1188746 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 19:57:34 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A101727534F
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 17:59:53 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	q7G9CJinnGqhcZ6U for <xfs@oss.sgi.com>;
	Thu, 20 Jan 2011 17:59:53 -0800 (PST)
Date: Fri, 21 Jan 2011 12:59:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110121015940.GX16267@dastard>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
	<20110114235549.GI16267@dastard>
	<20110118204752.GB28791@infradead.org>
	<20110118231831.GZ28803@dastard>
	<20110119120321.GC12941@infradead.org>
	<20110119133147.GN16267@dastard>
	<20110119135548.GA11502@infradead.org>
	<20110120013346.GO16267@dastard>
	<20110120111612.GA14571@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110120111612.GA14571@infradead.org>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Thu, Jan 20, 2011 at 06:16:12AM -0500, Christoph Hellwig wrote:
> On Thu, Jan 20, 2011 at 12:33:46PM +1100, Dave Chinner wrote:
> > It's case b) that I'm mainly worried about, esp. w.r.t the 64k page
> > size on ia64/ppc. If we only track a single dirty bit in the page,
> > then every sub-page, non-appending write to an uncached region of a
> > file becomes a RMW cycle to initialise the areas around the write
> > correctly. The question is whether we care about this enough given
> > that we return at least PAGE_SIZE in stat() to tell applications the
> > optimal IO size to avoid RMW cycles.
> 
> Note that this generally is only true for the first write into the
> region - after that we'll have the rest read into the cache.  But
> we also have the same issue for appending writes if they aren't
> page aligned.

True - I kind of implied that by saying RMW cycles are limited to
"uncached regions", but you've stated in a much clearer and easier
to understand way. ;)

> > And if we only do IO on whole pages (i.e regardless of block size)
> > .writepage suddenly becomes a lot simpler, as well as being trivial
> > to implement our own .readpage/.readpages....
> 
> I don't think it simplifies writepage a lot.  All the buffer head
> handling goes away, but we'll still need to do xfs_bmapi calls at
> block size granularity.  Why would you want to replaced the
> readpage/readpages code?  The generic mpage helpers for it do just fine.

When I went through the mpage code I found there were cases that it
would attached bufferheads to pages or assume PagePrivate() contains
a bufferhead list. e.g. If there are multiple holes in the page, it
will fall through to block_read_full_page() which makes this
assumption.  If we want/need to keep any of our own state on
PagePrivate(), we cannot use any function that assumes PagePrivate()
is used to hold bufferheads for the page.

Quite frankly, a simple extent mapping loop like we do for
.writepage is far simpler than what mpage_readpages does. This is
what btrfs does (extent_readpages/__extent_read_full_page), and that
is far easier to follow and understand than mpage_do_readpage()....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
