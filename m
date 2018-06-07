Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35680 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935134AbeFGOtH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 10:49:07 -0400
Date: Thu, 7 Jun 2018 07:48:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/2] xfs: xfs_reflink_convert_cow() memory allocation
 deadlock
Message-ID: <20180607144852.GD25007@magnolia>
References: <20180607052132.6207-1-david@fromorbit.com>
 <20180607052132.6207-3-david@fromorbit.com>
 <20180607114140.GB7798@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180607114140.GB7798@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Thu, Jun 07, 2018 at 07:41:40AM -0400, Brian Foster wrote:
> On Thu, Jun 07, 2018 at 03:21:32PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_reflink_convert_cow() manipulates the incore extent list
> > in GFP_KERNEL context in the IO submission path whilst holding
> > locked pages under writeback. This is a memory reclaim deadlock
> > vector. This code is not in a transaction, so any memory allocations
> > it makes aren't protected via the memalloc_nofs_save() context that
> > transactions carry.
> > 
> > Hence we need to run this call under memalloc_nofs_save() context to
> > prevent potential memory allocations from being run as GFP_KERNEL
> > and deadlocking.
> > 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Looks fine modulo the header thing Allison already pointed out:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> BTW, shouldn't we also be using XFS_TRANS_NOFS in
> xfs_iomap_write_allocate()?

/me squints at the usage and thinks ... yes probably. :)

--D

> Brian
> 
> >  fs/xfs/xfs_aops.c  | 11 +++++++++++
> >  fs/xfs/xfs_buf.c   |  1 -
> >  fs/xfs/xfs_linux.h |  1 +
> >  3 files changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 767d53222f31..1eb625fdcb1e 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -531,8 +531,19 @@ xfs_submit_ioend(
> >  {
> >  	/* Convert CoW extents to regular */
> >  	if (!status && ioend->io_type == XFS_IO_COW) {
> > +		/*
> > +		 * Yuk. This can do memory allocation, but is not a
> > +		 * transactional operation so everything is done in GFP_KERNEL
> > +		 * context. That can deadlock, because we hold pages in
> > +		 * writeback state and GFP_KERNEL allocations can block on them.
> > +		 * Hence we must operate in nofs conditions here.
> > +		 */
> > +		unsigned nofs_flag;
> > +
> > +		nofs_flag = memalloc_nofs_save();
> >  		status = xfs_reflink_convert_cow(XFS_I(ioend->io_inode),
> >  				ioend->io_offset, ioend->io_size);
> > +		memalloc_nofs_restore(nofs_flag);
> >  	}
> >  
> >  	/* Reserve log space if we might write beyond the on-disk inode size. */
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 980bc48979e9..e9c058e3761c 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -21,7 +21,6 @@
> >  #include <linux/migrate.h>
> >  #include <linux/backing-dev.h>
> >  #include <linux/freezer.h>
> > -#include <linux/sched/mm.h>
> >  
> >  #include "xfs_format.h"
> >  #include "xfs_log_format.h"
> > diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> > index ae1e66fa3f61..1631cf4546f2 100644
> > --- a/fs/xfs/xfs_linux.h
> > +++ b/fs/xfs/xfs_linux.h
> > @@ -26,6 +26,7 @@ typedef __u32			xfs_nlink_t;
> >  
> >  #include <linux/semaphore.h>
> >  #include <linux/mm.h>
> > +#include <linux/sched/mm.h>
> >  #include <linux/kernel.h>
> >  #include <linux/blkdev.h>
> >  #include <linux/slab.h>
> > -- 
> > 2.17.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
