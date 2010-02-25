Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1PKVqqn127424 for <xfs@oss.sgi.com>; Thu, 25 Feb 2010 14:31:52 -0600
Subject: Re: [PATCH 2/4] [PATCH 2/4] xfs: remove wrappers for read/write
	file operations
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100217083105.GB19943@infradead.org>
References: <20100215094445.528696829@bombadil.infradead.org>
	<20100215094604.318261333@bombadil.infradead.org>
	<20100217035511.GJ28392@discord.disaster>
	<20100217083105.GB19943@infradead.org>
Date: Thu, 25 Feb 2010 14:33:12 -0600
Message-ID: <1267129992.1905.24.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2010-02-17 at 03:31 -0500, Christoph Hellwig wrote:
> On Wed, Feb 17, 2010 at 02:55:11PM +1100, Dave Chinner wrote:
> > You've changed a local variable "pos" which had the value
> > iocb->ki_pos to a function parameter of the same name which has a
> > different value.  Given this, all the existing uses of "pos" in this
> > function need to be converted to "iocb->ki_pos" as the old
> > xfs_write() never saw the original "pos" variable passed to
> > xfs_file_aio_write().

I think the simplest explanation is that previously, the value
of "offset" passed in is simply &iocb->ki_pos, and Christoph's
changes are then simply replacing "*offset" with "iocb->ki_pos".

In any case, I'm convinced the old is equivalent to the new...

					-Alex

> Oh, I should have explained this in more detail.  The aio_read/aio_write
> ABI both has a pos argument and the file position in iocb->ki_pos.
> They were added for allowing aio that does partial I/O in each method
> call using retries, but we don't actually use the anywhere.  Thus these
> two are always these same and we even enforce that with a
> 
> 	BUG_ON(iocb->ki_pos != pos);
> 
> in the code (both old and new).  Now how does the old pos local variable
> come in play?  The old code didn't want to pass the kiocb to the
> low-level xfs-write function, but as want the offset it passes a pointer
> to iocb->ki_pos, which is called offset.  We take a local copy of it
> before we might start modifying it, which we call pos.  pos gets updated
> early in generic_write_checks if this is an O_APPEND write, but
> otherwise stays immutable and marks the position where this write
> started, while iocb->ki_pos (aka the old offset) gets updated by
> generic_file_direct_write / generic_file_buffered_write to the new
> file position after the I/O was done.
> 
> > Such as here. Actually, I'm surprised the compiler let you take
> > the address of a function parameter considering parameters may be
> > passed in registers....
> 
> Taking the address of arguments is perfectly valid in C, the only thing
> you can't take addresses of are "register" variables.  This code is
> the same as mm/filemap.c:__generic_file_aio_write, btw.
> 
> > > -		trace_xfs_file_direct_write(xip, count, *offset, ioflags);
> > > +		trace_xfs_file_direct_write(ip, count, iocb->ki_pos, ioflags);
> > >  		ret = generic_file_direct_write(iocb, iovp,
> > > -				&segs, pos, offset, count, ocount);
> > > +				&nr_segs, pos, &iocb->ki_pos, count, ocount);
> > 
> > But you did convert some ;)
> 
> I did carefull convert all offset references to ki->ki_pos, but all
> uses of pos stay the same.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
