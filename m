Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D06D7F87
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 17:08:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C3A4AC002
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 15:08:01 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	sRF8HmDGFzhjlELd for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2015 15:07:59 -0800 (PST)
Date: Mon, 2 Feb 2015 10:04:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't allocate an ioend for direct I/O completions
Message-ID: <20150201230403.GD4251@dastard>
References: <1422485661-520-1-git-send-email-hch@lst.de>
	<20150130144223.GA27441@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150130144223.GA27441@laptop.bfoster>
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
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Jan 30, 2015 at 09:42:23AM -0500, Brian Foster wrote:
> On Wed, Jan 28, 2015 at 11:54:21PM +0100, Christoph Hellwig wrote:
> > Back in the days when the direct I/O ->end_io callback could be called
> > from interrupt context for AIO we needed a structure to hand off to the
> > workqueue, and reused the ioend structure for this purpose.  These days
> > ->end_io is always called from user or workqueue context, which allows us
> > to avoid this memory allocation and simplify the code significantly.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> Looks mostly Ok to me. In fact, with xfs_finish_ioend_sync() calling
> xfs_end_io() directly, I don't see how we currently get into the wq at
> all. Anyways, a few notes...

I've pulled this in after making the couple of minor changes that
Brian suggested....

> > @@ -1507,39 +1514,17 @@ xfs_vm_direct_IO(
> >  {
> >  	struct inode		*inode = iocb->ki_filp->f_mapping->host;
> >  	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
> > -	struct xfs_ioend	*ioend = NULL;
> > -	ssize_t			ret;
> >  
> >  	if (rw & WRITE) {
> 
> A nit, but I guess you could kill the braces here now too.

Given it's a multi-line return statement, the braces are fine. FWIW,
when we have a if () { return ...} else { return ... } we normally
kill the else. i.e:

	if (rw & WRITE) {
		return foo(
			bar,
			baz);
	}
	return .....;

So I modified it like this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
