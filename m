Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53200 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389024AbfA1QXc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 11:23:32 -0500
Date: Mon, 28 Jan 2019 08:22:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] iomap: fix a use after free in iomap_dio_rw
Message-ID: <20190128162233.GF4368@magnolia>
References: <20190117075707.8640-1-hch@lst.de>
 <20190117212658.GD6173@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117212658.GD6173@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chandan Rajendra <chandan@linux.ibm.com>

On Fri, Jan 18, 2019 at 08:26:58AM +1100, Dave Chinner wrote:
> On Thu, Jan 17, 2019 at 08:57:07AM +0100, Christoph Hellwig wrote:
> > Introduce a local wait_for_completion variable to avoid an access to the
> > potentially freed dio struture after dropping the last reference count.
> > 
> > Also use the chance to document the completion behavior to make the
> > refcounting clear to the reader of the code.
> > 
> > Fixes: ff6a9292e6 ("iomap: implement direct I/O")
> > Reported-by: Chandan Rajendra <chandan@linux.ibm.com>
> > Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Tested-by: Chandan Rajendra <chandan@linux.ibm.com>
> > Tested-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/iomap.c | 28 +++++++++++++++++++++-------
> >  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> Looks good, minor comment cleanup needed, though. maybe Darrick can
> do it on commit?
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> > @@ -1925,8 +1925,24 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
> >  	if (dio->flags & IOMAP_DIO_WRITE_FUA)
> >  		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
> >  
> > +	/*
> > +	 * We are about to drop our additional submission reference, which
> > +	 * might be the last reference to the dio.  There are three three
> > +	 * different ways we can progress here:
> > +	 *
> > +	 *  (a) If this is the last reference we will always complete and free
> > +	 *	the dio ourselves. right here.
> 
> s/ right here.//

Fixed.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
