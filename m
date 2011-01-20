Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0K1VYg9008856 for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 19:31:35 -0600
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27B201623F9D
	for <xfs@oss.sgi.com>; Wed, 19 Jan 2011 17:33:51 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Z6DACADHxC5gmOo1 for <xfs@oss.sgi.com>;
	Wed, 19 Jan 2011 17:33:51 -0800 (PST)
Date: Thu, 20 Jan 2011 12:33:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110120013346.GO16267@dastard>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
	<20110114235549.GI16267@dastard>
	<20110118204752.GB28791@infradead.org>
	<20110118231831.GZ28803@dastard>
	<20110119120321.GC12941@infradead.org>
	<20110119133147.GN16267@dastard>
	<20110119135548.GA11502@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110119135548.GA11502@infradead.org>
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

On Wed, Jan 19, 2011 at 08:55:48AM -0500, Christoph Hellwig wrote:
> On Thu, Jan 20, 2011 at 12:31:47AM +1100, Dave Chinner wrote:
> > > If we want to completely get rid of buffers heads things are a bit
> > > more complicated.  It's doable as shown by the _nobh aops, but we'll
> > > use quite a bit of per-block state that needs to be replaced by per-page
> > > state,
> > 
> > Sure, or use a similar method to btrfs which stores dirty state bits
> > in a separate extent tree. Worst case memory usage is still much
> > less than a bufferhead per block...
> 
> I'm not sure need to track sub-page dirty state.  It only matters if we:
> 
>  a) have a file fragmented enough that it has multiple extents allocated
>     inside a single page
>  b) have enough small writes that just dirty parts of a page
> 
> with a good enough persistant preallocation a) should happen almost
> never, while b) might be an issue, specially with setups of 64k
> page size and 4k blocks (e.g. ppc64 enterprise distro configs)

Right - case a) could probably be handled by making the page size
an implicit extsize hint so we always try to minimise sub-page
fragmentation during allocation.

It's case b) that I'm mainly worried about, esp. w.r.t the 64k page
size on ia64/ppc. If we only track a single dirty bit in the page,
then every sub-page, non-appending write to an uncached region of a
file becomes a RMW cycle to initialise the areas around the write
correctly. The question is whether we care about this enough given
that we return at least PAGE_SIZE in stat() to tell applications the
optimal IO size to avoid RMW cycles.

Given that XFS is aimed towards optimising for the large file/large
IO/high throughput type of application, I'm comfortable with saying
that avoiding sub-page writes for optimal throughput IO is an
application problem and going from there. Especially considering
that stuff like rsync and untarring kernel tarballs are all
appending writes so won't take any performance hit at all...

And if we only do IO on whole pages (i.e regardless of block size)
.writepage suddenly becomes a lot simpler, as well as being trivial
to implement our own .readpage/.readpages....

What do people think about this?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
