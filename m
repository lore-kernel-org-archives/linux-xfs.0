Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3701std062598 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 19:01:54 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92B3812B6C34
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 17:05:08 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dG2WhURnukq9I7vH for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 17:05:08 -0700 (PDT)
Date: Thu, 7 Apr 2011 10:05:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/9] xfs: fix extent format buffer allocation size
Message-ID: <20110407000505.GM31057@dastard>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-2-git-send-email-david@fromorbit.com>
	<20110406133816.GA16276@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110406133816.GA16276@infradead.org>
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

On Wed, Apr 06, 2011 at 09:38:17AM -0400, Christoph Hellwig wrote:
> On Wed, Apr 06, 2011 at 04:19:10PM +1000, Dave Chinner wrote:
> > +	ext_buffer = kmem_alloc(XFS_IFORK_SIZE(ip, whichfork),
> > +							KM_SLEEP | KM_NOFS);
> 
> As mentioned before the KM_NOFS is a change from the previous version
> and really should not be needed.

Ok. If you feel strongly enough to point it out a second time, I'll
fix it ;)

> Also the feedback that the new helper needs to be under the
> !XFS_NATIVE_ENDIAN ifdef wasn't picked up either.

The function is needed regardless of XFS_NATIVE_HOST due to the fact
it is needed to pick the real extents out of the n-core data fork
when delayed allocation extents are present. This is endian
independent.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
