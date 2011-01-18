Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0INGITR164643 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 17:16:19 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B57CE61C09
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 15:18:35 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	VQ3wTD4hJAbx3AfO for <xfs@oss.sgi.com>;
	Tue, 18 Jan 2011 15:18:35 -0800 (PST)
Date: Wed, 19 Jan 2011 10:18:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110118231831.GZ28803@dastard>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
	<20110114235549.GI16267@dastard>
	<20110118204752.GB28791@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118204752.GB28791@infradead.org>
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

On Tue, Jan 18, 2011 at 03:47:52PM -0500, Christoph Hellwig wrote:
> On Sat, Jan 15, 2011 at 10:55:49AM +1100, Dave Chinner wrote:
> > I see from later on you are getting this state fom using a large
> > extsize. Perhaps this comes back to my comment about extsize
> > alignment might be better handled at the .aio_write level rather
> > than hiding inside the get_block() callback and attempting to handle
> > the mismatch at the .writepage level.
> >
> > Worth noting, though, is that DIO handles extsize unaligned writes
> > by allocating unwritten extsize sized/aligned extents an then doing
> > conversion at IO completion time. So perhaps we should be following
> > this example for delalloc conversion....
> 
> That's the other option for zeroing.  In many ways this makes a lot
> more sense, also for the thin provisioned virtualization image file
> use case I'm looking into right now.
> 
> > 
> > I think, however, if we use delalloc->unwritten allocation, we will
> > need to stop trusting the state of buffer heads in .writepage.  That
> > is because we'd then have blocks marked as buffer_delay() that
> > really cover unwritten extents and would need remapping. We're
> > already moving in the direction of not using the state in buffer
> > heads in ->writepage, so perhaps we need to speed up that
> > conversion as the first. Christoph, what are you plans here?
> 
> We really don't do much with the flags anymore.  We already treat
> overwritten (just buffer_uptodate) and delayed buffers are already
> exactly the same.

Except for the fact we use the delalloc state from the buffer to
trigger allocation after mapping. We could probably just use
isnullstartblock() for this - only a mapping from a buffer over a
delalloc range should return a null startblock.

> Unwritten buffers are still slightly different,
> in that we add XFS_BMAPI_IGSTATE to the bmapi flags.  This is just
> a leftover from the old code, and finding out why exactly we add
> it is still on my todo list.

XFS_BMAPI_IGSTATE does a couple of things. Firstly, It prevents
xfs_bmapi() from allocating new extents (turns off write mode).
This isn't an issue where it is used because neither of the call
sites set XFS_BMAPI_WRITE.

Secondly, it allows xfs_bmapi() to consider adjacent written
and unwritten extents as contiguous but has no effect on delalloc
extents. That is, if we have:

	A               B                 C
	+---------------+-----------------+
	    unwritten          written

And we ask to map the range A-C with a single map, we'll get back
A-B.  If we add XFS_BMAPI_IGSTATE, we'll get back A-C instead. This
means that when we map the range A-C for IO, we'll do it as a single
IO. The unwritten extent conversion code handles ranges like this
correctly - it will only convert the unwritten part of the range to
written. It is arguable that this is unnecessary because the
elevator will merge the two adjacent IOs anyway, but it does reduce
the number of mapping calls and IOs issued...

Hence it is effectively mechanism for optimising IO mappings where
we have contiguous extents with mixed written/unwritten state.

In fact, we probably should be setting this for normal written
extents as well, so that the case:

	A               B                 C
	+---------------+-----------------+
	    written          unwritten

is also handled with the same optimisation. That makes handling
unwritten and overwrites identical, with only delalloc being
different. If we assume delalloc when we get a null startblock,
then we don't need to look at the buffer state at all for the
initial mapping.

> The page clustering code checks if
> the buffer still matches the type in xfs_convert_page, though.
> And I'm not quite sure yet how we can remove that - the easiest
> option would be to keep holding the ilock until the whole clustered
> writeout is done, but we'd need to investigate what effect that
> has on performance.

Holding the ilock doesn't protect against page cache truncation, but
we can still check for that via page->mapping. Otherwise this seems
like it would work to me - I trust the extent list to reflect the
correct state a lot more than I do the buffer heads.

It seems to me that with such modifications, the only thing that we
are using the bufferhead for is the buffer_uptodate() flag to
determine if we should write the block or not. If we can find some
other way of holding this state then we don't need bufferheads in
the write path at all, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
