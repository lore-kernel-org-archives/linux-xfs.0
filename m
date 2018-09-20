Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:55018 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727232AbeIUDJa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Sep 2018 23:09:30 -0400
Date: Fri, 21 Sep 2018 07:23:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: introduce an always_cow mode
Message-ID: <20180920212357.GN27618@dastard>
References: <20180920144220.2181-1-hch@lst.de>
 <20180920144220.2181-6-hch@lst.de>
 <20180920201702.GN20086@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180920201702.GN20086@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Sep 20, 2018 at 01:17:02PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 20, 2018 at 04:42:20PM +0200, Christoph Hellwig wrote:
> > When the (debug-only) always_cow module parameter is set, we will always
> > write out place, even if the file is not reflinked.  In addition to being
> > a useful debug aid this prepares for modes where we must always write
> > out of place.  An example for that is the upcoming support for atomic
> > overwrites.
....
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index b25ea7a3a0e7..a893f6d65ff0 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -129,6 +129,11 @@
> >   * ioend, the better.
> >   */
> >  
> > +#ifdef DEBUG
> > +bool xfs_always_cow;
> > +module_param_named(always_cow, xfs_always_cow, bool, 0644);
> > +#endif
> 
> I would have expected this to end up in /proc/sys/fs/xfs/always_cow
> along with all the other behavior knobs, but I guess this is a debugging
> thing...?

sys/fs/xfs/debug/always_cow is the place for this if it is truly a
global debug option. However, that's probably not the best way to
enable this sort of debug for people with XFS root filesystems
trying to test XFS filesystems. I suspect it should be a per-mount
configuration (i.e. /sys/fs/xfs/<dev>/debug/always_cow)

However, this mode of operation seems like it is going to form the
basis of other per-filesystem features, so it would be good to know
how/if those features make use of this always_cow mode or are
controlled by some other set of knobs first.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
