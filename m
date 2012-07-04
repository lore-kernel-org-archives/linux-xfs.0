Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q648WdRg186227 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 03:32:39 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Bcb85ZxTAXmtMkBv for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 01:32:38 -0700 (PDT)
Date: Wed, 4 Jul 2012 18:32:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: do not call xfs_bdstrat_cb in
	xfs_buf_iodone_callbacks
Message-ID: <20120704083234.GG19223@dastard>
References: <20120702100003.960640484@bombadil.infradead.org>
	<20120702100034.921366796@bombadil.infradead.org>
	<20120703002857.GY19223@dastard>
	<20120703160531.GA855@infradead.org>
	<20120703232923.GC19223@dastard>
	<20120704055723.GB27500@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120704055723.GB27500@infradead.org>
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

On Wed, Jul 04, 2012 at 01:57:23AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 04, 2012 at 09:29:23AM +1000, Dave Chinner wrote:
> > It's not working yet - I found an issue with logging and writeback
> > of uncached buffers through the AIL (i.e. the superblock). This only
> > works by good fortune right now and requires uncached buffers to
> > carry their block number internally, so I need to rethink and rework
> > the patch.
> 
> What is the problem with uncached buffers?  I'd hate having to move
> the superblock buffer away from the uncached scheme.

I'm not exactly sure yet - I last looked at it before I went on
holidays last week. I was getting random ASSERT failures, always on
the superblock buffer and always due ot trying to IO to
XFS_BUF_DADDR_NULL because it was an uncached buffer. The path to it
was always through the AIL flushing, so it was using
xfs_buf_iorequest(bp) and getting the null blkno rather than
xfs_buf_uncached_iorequest(bp, blkno, len) which supplies the blkno.
Like I said, I need to rework is so that either
xfs_buf_iorequest(bp) works with uncached buffers, or we don't use
uncached buffers in transactions.

IMO, using uncached buffers in transactions is dangerous because
concurrent transactions can't find buffers uncached buffers at the
same address and so such buffers need higher level synchronisation
interfaces (as the superblock has).

I'm happy to leave the superblock as uncached and work around it in
some way, but it just seems wrong to me to have one buffer behaves
differently to all the cached and other uncached buffers in the
system. It doesn't sit well in my mind to do that when the problem
simply goes away if we make the superblock a cached buffer again....

> > How much does it change? I'm also trying to get all the read verify
> > callback infrastructure changes done for 3.6, and i suspect these may
> > step on each other. I've just about got those patches done - testing
> > and bug fixing is happening at the moment....
> 
> Basically a lot of impact around all callers of xfsbdstrat (which is
> going away) and some impact in xfs_buf.c around the higher-level
> read/write code.  I'm not entirely done with the plane I have so
> other things might get in the way and make it more complicated in
> the end.
> 
> Another thing it depends on is to only start the sync work item later
> during mount so that the re-read of the superblock after recovery can
> use normal buffer cache interfaces instead of xfsbdstrat.

Well, we've already got conflicts there, because all of the uncached
IO changes I've made remove xfsbdstrat() from those paths....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
