Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL0o3tJ200147 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 18:50:03 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1766E146F504
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 16:51:57 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	CSJD4WxRnM3kFPsh for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 16:51:57 -0800 (PST)
Date: Tue, 21 Dec 2010 11:51:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] xfs: split direct IO write path from
	xfs_file_aio_write
Message-ID: <20101221005154.GM5193@dastard>
References: <1292376208-16282-1-git-send-email-david@fromorbit.com>
	<1292376208-16282-5-git-send-email-david@fromorbit.com>
	<20101216120629.GC20445@infradead.org>
	<20101217073125.GE5193@dastard>
	<20101220112947.GC6881@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101220112947.GC6881@infradead.org>
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

On Mon, Dec 20, 2010 at 06:29:47AM -0500, Christoph Hellwig wrote:
> On Fri, Dec 17, 2010 at 06:31:25PM +1100, Dave Chinner wrote:
> > > Speaking of that, shouldn't xfs_file_aio_read also take the iolock
> > > exclusive during the page invalidation and then demote it, just like
> > > the write case?  The above helpers would enforce that nicely.
> > 
> > Probably, though it might be best to leave that to another cleanup
> > series. I'll see how much perturbation of the read path it makes....
> 
> Yes, it should be a separate patch for sure.  If you prefer another
> series that's fine with me, too.

Turns out to be pretty trivial to do - I included it in the
new xfs_rw_ilock conversion patch for the moment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
