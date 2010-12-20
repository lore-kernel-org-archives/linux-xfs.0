Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKBRqfF115620 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 05:27:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09A82146C9C3
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:29:49 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rmXvBQlXISZk3Cr7 for
	<xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:29:49 -0800 (PST)
Date: Mon, 20 Dec 2010 06:29:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] xfs: split direct IO write path from
	xfs_file_aio_write
Message-ID: <20101220112947.GC6881@infradead.org>
References: <1292376208-16282-1-git-send-email-david@fromorbit.com>
	<1292376208-16282-5-git-send-email-david@fromorbit.com>
	<20101216120629.GC20445@infradead.org>
	<20101217073125.GE5193@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101217073125.GE5193@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Dec 17, 2010 at 06:31:25PM +1100, Dave Chinner wrote:
> > Speaking of that, shouldn't xfs_file_aio_read also take the iolock
> > exclusive during the page invalidation and then demote it, just like
> > the write case?  The above helpers would enforce that nicely.
> 
> Probably, though it might be best to leave that to another cleanup
> series. I'll see how much perturbation of the read path it makes....

Yes, it should be a separate patch for sure.  If you prefer another
series that's fine with me, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
