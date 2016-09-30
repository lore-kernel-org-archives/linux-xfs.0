Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17013 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932430AbcI3SAm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Sep 2016 14:00:42 -0400
Date: Fri, 30 Sep 2016 11:00:14 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 34/63] xfs: support removing extents from CoW fork
Message-ID: <20160930180014.GQ14092@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
 <147520496094.29434.16759424174258286275.stgit@birch.djwong.org>
 <20160930074642.GD951@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160930074642.GD951@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Fri, Sep 30, 2016 at 12:46:42AM -0700, Christoph Hellwig wrote:
> >  /*
> > + * xfs_bunmapi_cow() -- Remove the relevant parts of the CoW fork.
> > + *			See xfs_bmap_del_extent.
> > + * @ip: XFS inode.
> > + * @idx: Extent number to delete.
> > + * @del: Extent to remove.
> > + */
> 
> Not quite a kerneldoc comment, not quite a normal one either..
> 
> That being sai the function seems mostly like a copy of the delay
> part of xfs_bmap_del_extent and the duplication seems unfortunate.
> 
> As I plan to do a major rework of that area for the next merge
> window I don't mind it for now, though.  

Yes, it is cobbled together from bmap_del_extent.  I wasn't sure at the
time whether it was worse to have two annoyingly similar functions, or
to sprinkle if statements all throughout the data fork one to special
case the COW fork.  Anyhow, when you rework the whole mess, cc: me and
I'll review it.

> > +	xfs_bmbt_irec_t		*del)
> 
> Same for these uses of the old typedefs in new code.  I'd rather
> avoid those, but instead of introducing churn now I'll sort this
> out later.

I'll at least fix those while I'm running through the entire tree.

--D

> 
> So:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
