Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1K0tX8Q142082 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 18:55:34 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9B8F418C74B4
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 16:55:00 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	3rf8q049YZjLTrwt for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2009 16:55:00 -0800 (PST)
Date: Fri, 20 Feb 2009 10:58:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, needs a new owner] XFS multi-buftarg
Message-ID: <20090219235803.GF8830@disturbed>
References: <4993A012.5060008@sgi.com> <20090219192340.GA13964@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090219192340.GA13964@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 19, 2009 at 02:23:40PM -0500, Christoph Hellwig wrote:
> On Thu, Feb 12, 2009 at 03:05:38PM +1100, Mark Goodwin wrote:
> >
> > Series of 10 patches, originally by Dave Chinner. This series
> > is unfinished, or needs forward porting to top-of-tree at the
> > very least. The feature implements some allocator/layout optimizations
> > by grouping AGs based on concat units, I think ;-)
> >
> > 02/10 xfs-factor-pag-freelist-check-2
> 
> This one is an independent cleanup.  It looks good to me and passes
> XFSQA.  Dave, can you submit this one for 2.6.30?

Ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
