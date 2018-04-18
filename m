Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:14511 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752091AbeDRXeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 19:34:22 -0400
Date: Thu, 19 Apr 2018 09:34:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: make xfs_buf_incore out of line
Message-ID: <20180418233419.GO23861@dastard>
References: <20180418002111.11637-1-david@fromorbit.com>
 <20180418002111.11637-2-david@fromorbit.com>
 <20180418114658.agqbu2uf2ti6hly7@odin.usersys.redhat.com>
 <20180418152442.GO24738@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418152442.GO24738@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 18, 2018 at 08:24:42AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 18, 2018 at 01:46:58PM +0200, Carlos Maiolino wrote:
> > On Wed, Apr 18, 2018 at 10:21:10AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Move xfs_buf_incore out of line and make it the only way to look up
> > > a buffer in the buffer cache from outside the buffer cache. Convert
> > > the external users of _xfs_buf_find() to xfs_buf_incore() and make
> > > _xfs_buf_find() static.
> > > 
> > 
> > Looks good, but shouldn't it be xfs_incore() instead of xfs_buf_incore() in the
> > Subject/description?
> 
> I wonder if this function really should be named xfs_buf_incore because
> xfs maintains a lot of incore state besides buffers, but as far as this
> patch goes I'll fix the commit message on the way in.

I think I intended to rename it xfs_buf_incore() in this patch,
but got distracted between writing the commit message (I almost
always do that first) and then making the change. ANd so I forgot
to s/xfs_incore/xfs_buf_incore.

Do you want me to resend?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
