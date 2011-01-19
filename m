Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0JDrWtb222671 for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 07:53:33 -0600
Date: Wed, 19 Jan 2011 08:55:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110119135548.GA11502@infradead.org>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
	<20110114235549.GI16267@dastard>
	<20110118204752.GB28791@infradead.org>
	<20110118231831.GZ28803@dastard>
	<20110119120321.GC12941@infradead.org>
	<20110119133147.GN16267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110119133147.GN16267@dastard>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Thu, Jan 20, 2011 at 12:31:47AM +1100, Dave Chinner wrote:
> > If we want to completely get rid of buffers heads things are a bit
> > more complicated.  It's doable as shown by the _nobh aops, but we'll
> > use quite a bit of per-block state that needs to be replaced by per-page
> > state,
> 
> Sure, or use a similar method to btrfs which stores dirty state bits
> in a separate extent tree. Worst case memory usage is still much
> less than a bufferhead per block...

I'm not sure need to track sub-page dirty state.  It only matters if we:

 a) have a file fragmented enough that it has multiple extents allocated
    inside a single page
 b) have enough small writes that just dirty parts of a page

with a good enough persistant preallocation a) should happen almost
never, while b) might be an issue, specially with setups of 64k
page size and 4k blocks (e.g. ppc64 enterprise distro configs)

> > and we'll lose the way to cache the block number in the buffer
> > head.  While we don't make use of that in writepage we do so in
> > the write path, although I'm not sure how important it is.  If we
> > get your multi-page write work in it probably won't matter any more.
> 
> The only place we use bh->b_blocknr is for ioend manipulation. Am I
> missing something else?

You're right.  I thought we use it in the write path, but we only
care about the buffer_mapped flag, but never actually look at the
block number.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
