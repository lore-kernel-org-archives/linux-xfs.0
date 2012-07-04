Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q648XuIo186501 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 03:33:56 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VHz2u2zWceg5lZFn for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 01:33:54 -0700 (PDT)
Date: Wed, 4 Jul 2012 18:33:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: implement ->update_time
Message-ID: <20120704083353.GH19223@dastard>
References: <20120606210128.GA12819@infradead.org>
	<20120704060606.GA7333@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120704060606.GA7333@infradead.org>
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

On Wed, Jul 04, 2012 at 02:06:06AM -0400, Christoph Hellwig wrote:
> ping?
> 
> On Wed, Jun 06, 2012 at 05:01:28PM -0400, Christoph Hellwig wrote:
> > Use this new method to replace our hacky use of ->dirty_inode.  An additional
> > benefit is that we can now propagate errors up the stack.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>

I've been testing it and haven't had any problems with it - I just
haven't done a final review of it yet.  I'll try to do it tomorrow
morning....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
