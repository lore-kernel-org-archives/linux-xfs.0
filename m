Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HMdu7B004915 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 16:39:56 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B691C1DB260
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 14:41:11 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	2tWFX0EQtBQFoeka for <xfs@oss.sgi.com>;
	Wed, 17 Feb 2010 14:41:11 -0800 (PST)
Date: Thu, 18 Feb 2010 09:41:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] [PATCH 2/4] xfs: remove wrappers for read/write
	file operations
Message-ID: <20100217224108.GS28392@discord.disaster>
References: <20100215094445.528696829@bombadil.infradead.org>
	<20100215094604.318261333@bombadil.infradead.org>
	<20100217035511.GJ28392@discord.disaster>
	<20100217083105.GB19943@infradead.org>
	<20100217211355.GR28392@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100217211355.GR28392@discord.disaster>
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
Cc: xfs@oss.sgi.com

On Thu, Feb 18, 2010 at 08:13:55AM +1100, Dave Chinner wrote:
> On Wed, Feb 17, 2010 at 03:31:06AM -0500, Christoph Hellwig wrote:
> > On Wed, Feb 17, 2010 at 02:55:11PM +1100, Dave Chinner wrote:
> > > You've changed a local variable "pos" which had the value
> > > iocb->ki_pos to a function parameter of the same name which has a
> > > different value.  Given this, all the existing uses of "pos" in this
> > > function need to be converted to "iocb->ki_pos" as the old
> > > xfs_write() never saw the original "pos" variable passed to
> > > xfs_file_aio_write().
> > 
> > Oh, I should have explained this in more detail.  The aio_read/aio_write
> > ABI both has a pos argument and the file position in iocb->ki_pos.
> > They were added for allowing aio that does partial I/O in each method
> > call using retries, but we don't actually use the anywhere.  Thus these
> > two are always these same and we even enforce that with a
> > 
> > 	BUG_ON(iocb->ki_pos != pos);
> > 
> > in the code (both old and new).  Now how does the old pos local variable
> > come in play?  The old code didn't want to pass the kiocb to the
> > low-level xfs-write function, but as want the offset it passes a pointer
> > to iocb->ki_pos, which is called offset.  We take a local copy of it
> > before we might start modifying it, which we call pos.  pos gets updated
> > early in generic_write_checks if this is an O_APPEND write, but
> > otherwise stays immutable and marks the position where this write
> > started, while iocb->ki_pos (aka the old offset) gets updated by
> > generic_file_direct_write / generic_file_buffered_write to the new
> > file position after the I/O was done.
> 
> Ok, my misunderstanding. I'll go back and review it again with this
> in mind.

It looks ok having taken this into account. I think I originally
read the BUG_ON(iocb->ki_pos != pos) as meaning the two values were
not equivalent because that is what an ASSERT(iocb->ki_pos != pos)
would mean. Anyway:

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
