Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0KBDtCR073090 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 05:13:55 -0600
Date: Thu, 20 Jan 2011 06:16:12 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110120111612.GA14571@infradead.org>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
	<20110114235549.GI16267@dastard>
	<20110118204752.GB28791@infradead.org>
	<20110118231831.GZ28803@dastard>
	<20110119120321.GC12941@infradead.org>
	<20110119133147.GN16267@dastard>
	<20110119135548.GA11502@infradead.org>
	<20110120013346.GO16267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110120013346.GO16267@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, bpm@sgi.com, xfs@oss.sgi.com

On Thu, Jan 20, 2011 at 12:33:46PM +1100, Dave Chinner wrote:
> It's case b) that I'm mainly worried about, esp. w.r.t the 64k page
> size on ia64/ppc. If we only track a single dirty bit in the page,
> then every sub-page, non-appending write to an uncached region of a
> file becomes a RMW cycle to initialise the areas around the write
> correctly. The question is whether we care about this enough given
> that we return at least PAGE_SIZE in stat() to tell applications the
> optimal IO size to avoid RMW cycles.

Note that this generally is only true for the first write into the
region - after that we'll have the rest read into the cache.  But
we also have the same issue for appending writes if they aren't
page aligned.

> And if we only do IO on whole pages (i.e regardless of block size)
> .writepage suddenly becomes a lot simpler, as well as being trivial
> to implement our own .readpage/.readpages....

I don't think it simplifies writepage a lot.  All the buffer head
handling goes away, but we'll still need to do xfs_bmapi calls at
block size granularity.  Why would you want to replaced the
readpage/readpages code?  The generic mpage helpers for it do just fine.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
