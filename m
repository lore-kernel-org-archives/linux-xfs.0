Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 16:57:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7NNv44p019425
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 16:57:06 -0700
Date: Fri, 24 Aug 2007 09:56:52 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 5/17] move v_iocount from bhv_vnode to xfs_inode
Message-ID: <20070823235652.GZ72985246@sgi.com>
References: <20070823193818.GF8050@lst.de> <20070823194749.GB8431@filer.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823194749.GB8431@filer.fsl.cs.sunysb.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Aug 23, 2007 at 03:47:49PM -0400, Josef Sipek wrote:
> On Thu, Aug 23, 2007 at 09:38:18PM +0200, Christoph Hellwig wrote:
> > struct bhv_vnode is on it's way out, so move the I/O count to the XFS inode.
> > 
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
> > ===================================================================
> > --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-08-23 14:46:18.000000000 +0200
> > +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2007-08-23 14:51:38.000000000 +0200
> > @@ -140,9 +140,11 @@ xfs_destroy_ioend(
> >  		next = bh->b_private;
> >  		bh->b_end_io(bh, !ioend->io_error);
> >  	}
> > -	if (unlikely(ioend->io_error))
> > -		vn_ioerror(ioend->io_vnode, ioend->io_error, __FILE__,__LINE__);
> > -	vn_iowake(ioend->io_vnode);
> > +	if (unlikely(ioend->io_error)) {
> > +		vn_ioerror(XFS_I(ioend->io_inode), ioend->io_error,
> > +				__FILE__,__LINE__);
> 
> Should it still be called vn_* if it takes an xfs inode? (And yes, I realize
> this is a patch in the middle of the series.)

Eventually, yes, but that's really only cosmetic at this point. I'm
more concerned with the functional and structural changes at this point
and not so much the cosmetics. There are much bigger cosmetic changes
in the pipeline as a result of this patchset, I think...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
