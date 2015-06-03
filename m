Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 628207FDF
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 17:45:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2E31AC002
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 15:45:17 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	V1FDY5TnE0JXvyYC for <xfs@oss.sgi.com>;
	Wed, 03 Jun 2015 15:45:16 -0700 (PDT)
Date: Thu, 4 Jun 2015 08:40:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC v2] xfs: byte range buffer dirty region tracking
Message-ID: <20150603224050.GP24666@dastard>
References: <1432865777-14616-1-git-send-email-david@fromorbit.com>
	<20150603140121.GA32420@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150603140121.GA32420@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jun 03, 2015 at 10:01:21AM -0400, Brian Foster wrote:
> On Fri, May 29, 2015 at 12:16:17PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The biggest problem with large directory block sizes is the CPU
> > overhead in maintaining the buffer log item direty region bitmap.
> > The bit manipulations and buffer region mapping calls are right at
> > the top of the profiles when running tests on 64k directory buffers:
.....
> > +	start = 0;
> > +	if (offset < rp->first)
> > +		start = rp->first - offset;
> > +	end = length - 1;
> > +	if (offset + length > rp->last)
> > +		end = rp->last - offset - 1;
> > +
> > +	start &= ~((1 << XFS_BLF_SHIFT) - 1);
> > +	first_bit = start >> XFS_BLF_SHIFT;
> > +	last_bit = end >> XFS_BLF_SHIFT;
> > +	nbits = last_bit - first_bit + 1;
> > +	bitmap_set((unsigned long *)blfp->blf_data_map, first_bit, nbits);
> > +
> > +	ASSERT(end <= length);
> > +	ASSERT(start <= length);
> > +	ASSERT(length >= nbits * XFS_BLF_CHUNK);
> > +	/*
> > +	 * Copy needs to be done a buffer page at a time as we can be logging
> > +	 * unmapped buffers. hence we have to use xfs_buf_iomove() rather than a
> > +	 * straight memcpy here.
> > +	 */
> > +	offset += first_bit * XFS_BLF_CHUNK;
> > +	length = nbits * XFS_BLF_CHUNK;
> > +	buf = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_BCHUNK);
> > +	xfs_buf_iomove(bp, offset, length, buf, XBRW_READ);
> > +	xlog_finish_iovec(lv, *vecp, length);
> 
> Am I following this correctly in that the bitmap lives on because it's
> part of the on-disk log structure?

Yes.

> In other words, we previously updated
> the per-segment bitmaps during the action of logging the buffer and this
> would simply copy the format to the log vector. With this change, we
> have the separate item-wide logging range that is effectively an in-core
> value and used to track the log action. The segment bitmaps must still
> be written to the log to preserve on-disk format, so we defer that to
> when the log buffer is formatted and do so against the copy of the
> format that's actually already copied to the log vector (e.g., via the
> blfp = xlog_copy_iovec(...) above).

Yes.

> Just a minor nit if I am following that correctly... it would be nice if
> the comment above were a bit more explicit to point out we're working on
> the copied format since the bitmap updates are deferred (and the bitmaps
> in the source memory buffer are essentially never valid).

Yep, I can add that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
