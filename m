Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43712 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbfFEVY0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 17:24:26 -0400
Date: Thu, 6 Jun 2019 07:24:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 18/20] xfs: remove unused buffer cache APIs
Message-ID: <20190605212422.GE29573@dread.disaster.area>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-19-hch@lst.de>
 <20190604062442.GS29573@dread.disaster.area>
 <20190605151210.GB14846@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605151210.GB14846@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 05, 2019 at 05:12:10PM +0200, Christoph Hellwig wrote:
> On Tue, Jun 04, 2019 at 04:24:42PM +1000, Dave Chinner wrote:
> > > @@ -1258,7 +1192,7 @@ xfs_buf_ioend_async(
> > >  	struct xfs_buf	*bp)
> > >  {
> > >  	INIT_WORK(&bp->b_ioend_work, xfs_buf_ioend_work);
> > > -	queue_work(bp->b_ioend_wq, &bp->b_ioend_work);
> > > +	queue_work(bp->b_target->bt_mount->m_buf_workqueue, &bp->b_ioend_work);
> > >  }
> > 
> > It'd be nice to keep bp->b_ioend_wq to avoid pointer chasing here.
> > Perhaps we could set it up in _xfs_buf_alloc() where we are pretty
> > much guaranteed to have the xfs_mount hot in cache, and then it's
> > set for the life of the buffer. Just a thought, but either way:
> 
> We'd need to benchmark this particular case, but the bloat to
> the xfs_buf structure probably cancels out at least one pointer
> dereference.  That being said we probably could at least remove
> one indirection without bloating the buf, I'll take a look at that.

FWIW, I already plan to move the buf workqueue to the xfs_buftarg
so maybe that's the way to go here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
