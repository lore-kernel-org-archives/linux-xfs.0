Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3U2kMg9189808 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 21:46:22 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	0ckPnTW9iDNq5hMa for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 19:46:21 -0700 (PDT)
Date: Mon, 30 Apr 2012 12:40:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 34/37] xfs: clean up xfs_bit.h includes
Message-ID: <20120430024047.GD7015@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-35-git-send-email-david@fromorbit.com>
	<20120429215525.GM19889@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120429215525.GM19889@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sun, Apr 29, 2012 at 05:55:25PM -0400, Christoph Hellwig wrote:
> >   * Visible inode allocation functions.
> >   */
> > +/*
> > + * Find a free (set) bit in the inode bitmask.
> > + */
> > +static inline int xfs_ialloc_find_free(xfs_inofree_t *fp)
> > +{
> > +	return xfs_lowbit64(*fp);
> > +}
> 
> I'd suggest killing this helper entirely - there is just a single
> caller, and using the lowbit helper directly actually is even more
> obvious.

Ok. Done.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
