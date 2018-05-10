Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51074 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965215AbeEJPIp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 11:08:45 -0400
Date: Thu, 10 May 2018 08:08:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/33] iomap: add an iomap-based bmap implementation
Message-ID: <20180510150838.GE25312@magnolia>
References: <20180509074830.16196-1-hch@lst.de>
 <20180509074830.16196-11-hch@lst.de>
 <20180509164628.GV11261@magnolia>
 <20180510064250.GD11422@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180510064250.GD11422@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

On Thu, May 10, 2018 at 08:42:50AM +0200, Christoph Hellwig wrote:
> On Wed, May 09, 2018 at 09:46:28AM -0700, Darrick J. Wong wrote:
> > On Wed, May 09, 2018 at 09:48:07AM +0200, Christoph Hellwig wrote:
> > > This adds a simple iomap-based implementation of the legacy ->bmap
> > > interface.  Note that we can't easily add checks for rt or reflink
> > > files, so these will have to remain in the callers.  This interface
> > > just needs to die..
> > 
> > You /can/ check these...
> > 
> > if (iomap->bdev != inode->i_sb->s_bdev)
> > 	return 0;
> > if (iomap->flags & IOMAP_F_SHARED)
> > 	return 0;
> 
> The latter only checks for a shared extent, not a file with possibly
> shared extents.  I'd rather keep the check for a file with possible
> shared extents.

<nod>

> > > +static loff_t
> > > +iomap_bmap_actor(struct inode *inode, loff_t pos, loff_t length,
> > > +		void *data, struct iomap *iomap)
> > > +{
> > > +	sector_t *bno = data;
> > > +
> > > +	if (iomap->type == IOMAP_MAPPED)
> > > +		*bno = (iomap->addr + pos - iomap->offset) >> inode->i_blkbits;
> > 
> > Does this need to be careful w.r.t. overflow on systems where sector_t
> > is a 32-bit unsigned long?
> > 
> > Also, ioctl_fibmap() typecasts the returned sector_t to an int, which
> > also seems broken.  I agree the interface needs to die, but ioctls take
> > a long time to deprecate.
> 
> Not much we can do about the interface.

Yes, the interface is fubar, but if file /foo maps to block 8589934720
then do we return the truncated result 128?

--D
