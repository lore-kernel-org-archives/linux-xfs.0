Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1963B7FAC
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 18:02:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 05B298F8059
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 16:02:15 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HaGHYSA3OCPFQVHf for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 16:02:14 -0700 (PDT)
Date: Fri, 1 Aug 2014 09:02:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: flush both inodes in xfs_swap_extents
Message-ID: <20140731230212.GT26465@dastard>
References: <1406787128-11897-1-git-send-email-david@fromorbit.com>
	<1406787128-11897-3-git-send-email-david@fromorbit.com>
	<20140731171602.GF22173@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140731171602.GF22173@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Jul 31, 2014 at 10:16:02AM -0700, Christoph Hellwig wrote:
> >  int
> > +xfs_swap_extent_flush(
> > +	struct xfs_inode	*ip)
> > +{
> > +	int	error;
> 
> nipick:  shouldn't the arguments and local variables align to the same
> level?

*nod*

> Also a local struct inode variable instead of using VFS_I(ip) 4 times
> would be nice.

Will fix.

> Otherwise looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.

-Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
