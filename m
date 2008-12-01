Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB1MKW9g024832 for <xfs@oss.sgi.com>; Mon, 1 Dec 2008 16:20:33 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AEB41639762
	for <xfs@oss.sgi.com>; Mon,  1 Dec 2008 14:20:09 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id w5H9E3XNlaZkjnVk for
	<xfs@oss.sgi.com>; Mon, 01 Dec 2008 14:20:09 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1L7H7f-0007po-Rv
	for xfs@oss.sgi.com; Mon, 01 Dec 2008 22:20:07 +0000
Date: Mon, 1 Dec 2008 17:20:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH][mainline-only] remove useless mnt_want_write call in
	xfs_write
Message-ID: <20081201222007.GA28519@infradead.org>
References: <20080814212551.GA20980@lst.de> <20080929074450.GB23785@lst.de>
	<20081110133150.GA27234@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081110133150.GA27234@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs@oss.sgi.com

ping^2?

Note that with the new git tree it's also not just mainline only
anymore.

On Mon, Nov 10, 2008 at 08:31:50AM -0500, Christoph Hellwig wrote:
> ping?
> 
> On Mon, Sep 29, 2008 at 09:44:50AM +0200, Christoph Hellwig wrote:
> > Any chance to get this into the git tree for the first 2.6.28 pull?
> > 
> > On Thu, Aug 14, 2008 at 11:25:51PM +0200, Christoph Hellwig wrote:
> > > When mnt_want_write was introduced a call to it was added around
> > > xfs_ichgtime, but there is no need for this because a file can't be open
> > > read/write on a r/o mount, and a mount can't degrade r/o while we still
> > > have files open for writing.  As the mnt_want_write changes were never
> > > merged into the CVS tree this patch is for mainline only.
> > > 
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > --- linux-2.6/fs/xfs/linux-2.6/xfs_lrw.c	2008-08-14 14:52:15.000000000 -0300
> > > +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2008-08-14 14:54:53.000000000 -0300
> > > @@ -51,7 +51,6 @@
> > >  #include "xfs_vnodeops.h"
> > >  
> > >  #include <linux/capability.h>
> > > -#include <linux/mount.h>
> > >  #include <linux/writeback.h>
> > >  
> > >  
> > > @@ -668,15 +667,8 @@ start:
> > >  	if (new_size > xip->i_size)
> > >  		xip->i_new_size = new_size;
> > >  
> > > -	/*
> > > -	 * We're not supposed to change timestamps in readonly-mounted
> > > -	 * filesystems.  Throw it away if anyone asks us.
> > > -	 */
> > > -	if (likely(!(ioflags & IO_INVIS) &&
> > > -		   !mnt_want_write(file->f_path.mnt))) {
> > > +	if (likely(!(ioflags & IO_INVIS)))
> > >  		xfs_ichgtime(xip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> > > -		mnt_drop_write(file->f_path.mnt);
> > > -	}
> > >  
> > >  	/*
> > >  	 * If the offset is beyond the size of the file, we have a couple
> > ---end quoted text---
> > 
> > 
> ---end quoted text---
> 
> 
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
