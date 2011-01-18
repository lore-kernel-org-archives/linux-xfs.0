Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0IKjYG1157043 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 14:45:34 -0600
Date: Tue, 18 Jan 2011 15:47:52 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Issues with delalloc->real extent allocation
Message-ID: <20110118204752.GB28791@infradead.org>
References: <20110114002900.GF16267@dastard> <20110114214334.GN28274@sgi.com>
	<20110114235549.GI16267@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110114235549.GI16267@dastard>
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

On Sat, Jan 15, 2011 at 10:55:49AM +1100, Dave Chinner wrote:
> I see from later on you are getting this state fom using a large
> extsize. Perhaps this comes back to my comment about extsize
> alignment might be better handled at the .aio_write level rather
> than hiding inside the get_block() callback and attempting to handle
> the mismatch at the .writepage level.
>
> Worth noting, though, is that DIO handles extsize unaligned writes
> by allocating unwritten extsize sized/aligned extents an then doing
> conversion at IO completion time. So perhaps we should be following
> this example for delalloc conversion....

That's the other option for zeroing.  In many ways this makes a lot
more sense, also for the thin provisioned virtualization image file
use case I'm looking into right now.

> 
> I think, however, if we use delalloc->unwritten allocation, we will
> need to stop trusting the state of buffer heads in .writepage.  That
> is because we'd then have blocks marked as buffer_delay() that
> really cover unwritten extents and would need remapping. We're
> already moving in the direction of not using the state in buffer
> heads in ->writepage, so perhaps we need to speed up that
> conversion as the first. Christoph, what are you plans here?

We really don't do much with the flags anymore.  We already treat
overwritten (just buffer_uptodate) and delayed buffers are already
exactly the same.   Unwritten buffers are still slightly different,
in that we add XFS_BMAPI_IGSTATE to the bmapi flags.  This is just
a leftover from the old code, and finding out why exactly we add
it is still on my todo list.  The page clustering code checks if
the buffer still matches the type in xfs_convert_page, though.
And I'm not quite sure yet how we can remove that - the easiest
option would be to keep holding the ilock until the whole clustered
writeout is done, but we'd need to investigate what effect that
has on performance.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
