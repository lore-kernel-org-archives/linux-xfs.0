Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:37554 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751916AbeBEAjJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Feb 2018 19:39:09 -0500
Date: Mon, 5 Feb 2018 11:40:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fall back to vmalloc when allocation log vector
 buffers
Message-ID: <20180205004001.anj4ias3tc55naok@destitution>
References: <20180201013959.829-1-david@fromorbit.com>
 <20180201044419.GN4849@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180201044419.GN4849@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 31, 2018 at 08:44:19PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 01, 2018 at 12:39:59PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When using large directory blocks, we regularly see memory
> > allocations of >64k being made for the shadow log vector buffer.
> > When we are under memory pressure, kmalloc() may not be able to find
> > contiguous memory chunks large enough to satisfy these allocations
> > easily, and if memory is fragmented we can potentially stall here.
> > 
> > TO avoid this problem, switch the log vector buffer allocation to
> > use kmem_alloc_large(). This will allow failed allocations to fall
> > back to vmalloc and so remove the dependency on large contiguous
> > regions of memory being available. This should prevent slowdowns
> > and potential stalls when memory is low and/or fragmented.
> 
> > Signed-Off-By: Dave Chinner <dchinner@redhat.com>
.....
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 43aa42a3a5d3..61ab5c0a4c45 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -202,7 +202,7 @@ xlog_cil_alloc_shadow_bufs(
> >  			 */
> >  			kmem_free(lip->li_lv_shadow);
> >  
> > -			lv = kmem_alloc(buf_size, KM_SLEEP|KM_NOFS);
> > +			lv = kmem_alloc_large(buf_size, KM_SLEEP|KM_NOFS);
> 
> "KM_SLEEP | KM_NOFS", will fix it on the way in.

*nod*

> I wonder about expanding the uses of vmalloc space, but otoh stalling
> the log seems like a worse idea...

We'll only see this happen when memory is really low and/or
fragmented, so i don't think it's a problem at all. I could trigger
warnings without this patch - they disappear with this patch and the
system seemed more responsive under equivalent loading. That's
entirely subjective, but it's so hard to consistently drive the
system into the severe memory shortages and reclaim failures that
trigger this problem that's the best I was able to do...

> Looks ok enough to give it a spin,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
