Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:58297 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751070AbcLEBVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Dec 2016 20:21:11 -0500
Date: Mon, 5 Dec 2016 12:14:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: make xfs btree stats less huge
Message-ID: <20161205011432.GP31101@dastard>
References: <20161201103052.28453-1-david@fromorbit.com>
 <20161201103052.28453-2-david@fromorbit.com>
 <20161202132044.GC426@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161202132044.GC426@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 02, 2016 at 05:20:44AM -0800, Christoph Hellwig wrote:
> 
> > --- a/fs/xfs/xfs_stats.h
> > +++ b/fs/xfs/xfs_stats.h
> > @@ -21,10 +21,30 @@
> >  
> >  #include <linux/percpu.h>
> >  
> > +enum {
> > +	__XBTS_lookup = 0,
> 
> Add a comment on top of the enum to explain these are the
> offsets into each btree type?

Will do.

> > +#define XFS_STATS_CALC_INDEX(member)	\
> > +	(offsetof(struct __xfsstats, member) / (int)sizeof(__uint32_t))
> 
> what's that int cast for?

Habit - prevents 64 bit division on 32 bit systems. But given this
is evaluated at compile time, that doesn't matter. Will remove.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

-- 
Dave Chinner
david@fromorbit.com
