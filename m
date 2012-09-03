Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8339BXc124771 for <xfs@oss.sgi.com>; Sun, 2 Sep 2012 22:09:11 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	RC71uXW4V7VE6hnq for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 20:10:06 -0700 (PDT)
Date: Mon, 3 Sep 2012 13:09:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/13] xfs: rename the xfs_syncd workqueue
Message-ID: <20120903030958.GN15292@dastard>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<1346328017-2795-3-git-send-email-david@fromorbit.com>
	<20120901231722.GB27456@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120901231722.GB27456@infradead.org>
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

On Sat, Sep 01, 2012 at 07:17:22PM -0400, Christoph Hellwig wrote:
> On Thu, Aug 30, 2012 at 10:00:06PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > There is nothing "sync" realted to this work queue any more. It is a general
> > purpose per-filesystem work queue. Rename it appropriately, and remove the
> > "syncd" naming from various functions.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> With the current leight-weight workqueues I don't see why we'd even want
> a shared one for the different callers.  Let's move the patch until
> after killing xfs_flush_worker & co, and then add a workqueue for
> background and the log sync individually.

OK. It starts to make workqueues like slab caches - all the cool
kids have got one. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
