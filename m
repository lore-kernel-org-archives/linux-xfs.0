Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q63NTRoc141205 for <xfs@oss.sgi.com>; Tue, 3 Jul 2012 18:29:27 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	drwNhPkpGqbwlKX2 for <xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 16:29:25 -0700 (PDT)
Date: Wed, 4 Jul 2012 09:29:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: do not call xfs_bdstrat_cb in
	xfs_buf_iodone_callbacks
Message-ID: <20120703232923.GC19223@dastard>
References: <20120702100003.960640484@bombadil.infradead.org>
	<20120702100034.921366796@bombadil.infradead.org>
	<20120703002857.GY19223@dastard>
	<20120703160531.GA855@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120703160531.GA855@infradead.org>
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

On Tue, Jul 03, 2012 at 12:05:31PM -0400, Christoph Hellwig wrote:
> On Tue, Jul 03, 2012 at 10:28:57AM +1000, Dave Chinner wrote:
> > On Mon, Jul 02, 2012 at 06:00:05AM -0400, Christoph Hellwig wrote:
> > > xfs_bdstrat_cb only adds a check for a shutdown filesystem over xfs_buf_iorequest,
> > > but xfs_buf_iodone_callbacks just checked for a shut down filesystem a little
> > > earlier.  In addition the shutdown handling in xfs_bdstrat_cb is not very suitable
> > > for this caller.
> > 
> > Makes sense - I have a patch locally that does this as part of a
> > xfs_buf_iorequest(bp, blkno, length) conversion to get rid of
> > XFS_BUF_SETADDR()....
> 
> Can you send these out ASAP?

It's not working yet - I found an issue with logging and writeback
of uncached buffers through the AIL (i.e. the superblock). This only
works by good fortune right now and requires uncached buffers to
carry their block number internally, so I need to rethink and rework
the patch.

I think that I will make the superblock buffer a cached buffer once
again, but keep the current shortcut to look it up. Doing so will
enable me to keep the distinction I created between cached and
uncached buffers. It will also solve the AIL flush waiting problem
we currently also have with it on freeze/unmount.

> I have another big batch of buffer error
> handling changes for 3.6 I'm working on right now.

How much does it change? I'm also trying to get all the read verify
callback infrastructure changes done for 3.6, and i suspect these may
step on each other. I've just about got those patches done - testing
and bug fixing is happening at the moment....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
