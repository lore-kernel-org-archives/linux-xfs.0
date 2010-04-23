Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3N3NabR009253 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 22:23:36 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27648130CAF0
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 20:25:36 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	IyWysZ6PGvi9yYoG for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 20:25:36 -0700 (PDT)
Date: Fri, 23 Apr 2010 13:25:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Improve scalability of busy extent tracking
Message-ID: <20100423032533.GE10390@dastard>
References: <1271828835-2094-1-git-send-email-david@fromorbit.com>
	<20100422110758.GA22295@infradead.org>
	<20100422171035.GA29007@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100422171035.GA29007@infradead.org>
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

On Thu, Apr 22, 2010 at 01:10:35PM -0400, Christoph Hellwig wrote:
> On Thu, Apr 22, 2010 at 07:07:58AM -0400, Christoph Hellwig wrote:
> > Oh, and while I'm at it:
> > 
> > I'd move the list_del_init(&busyp->list); from xfs_trans_free_busy into
> > xfs_alloc_clear_busy, we also do the list insertation inside
> > xfs_alloc_busy_insert, so that makes it symmetic.
> 
> Or just merge the loop calling xfs_alloc_clear_busy directly in
> xfs_trans_free, ala:

Yeah, that looks like a sane thing to do. I'll update it this way.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
