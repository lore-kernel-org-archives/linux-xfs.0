Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41918 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750872AbeDSBKs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 21:10:48 -0400
Date: Wed, 18 Apr 2018 18:10:44 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: make xfs_buf_incore out of line
Message-ID: <20180419011044.GV24738@magnolia>
References: <20180418002111.11637-1-david@fromorbit.com>
 <20180418002111.11637-2-david@fromorbit.com>
 <20180418114658.agqbu2uf2ti6hly7@odin.usersys.redhat.com>
 <20180418152442.GO24738@magnolia>
 <20180418233419.GO23861@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418233419.GO23861@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 19, 2018 at 09:34:19AM +1000, Dave Chinner wrote:
> On Wed, Apr 18, 2018 at 08:24:42AM -0700, Darrick J. Wong wrote:
> > On Wed, Apr 18, 2018 at 01:46:58PM +0200, Carlos Maiolino wrote:
> > > On Wed, Apr 18, 2018 at 10:21:10AM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Move xfs_buf_incore out of line and make it the only way to look up
> > > > a buffer in the buffer cache from outside the buffer cache. Convert
> > > > the external users of _xfs_buf_find() to xfs_buf_incore() and make
> > > > _xfs_buf_find() static.
> > > > 
> > > 
> > > Looks good, but shouldn't it be xfs_incore() instead of xfs_buf_incore() in the
> > > Subject/description?
> > 
> > I wonder if this function really should be named xfs_buf_incore because
> > xfs maintains a lot of incore state besides buffers, but as far as this
> > patch goes I'll fix the commit message on the way in.
> 
> I think I intended to rename it xfs_buf_incore() in this patch,
> but got distracted between writing the commit message (I almost
> always do that first) and then making the change. ANd so I forgot
> to s/xfs_incore/xfs_buf_incore.
> 
> Do you want me to resend?

Nah, I'll just s/xfs_incore/xfs_buf_incore/ what I already have.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
