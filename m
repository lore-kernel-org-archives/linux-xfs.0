Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3LrF62021964 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 15:53:15 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15AE81686C0F
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 13:53:13 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	7wABagGIrkJ51Abv for <xfs@oss.sgi.com>;
	Wed, 03 Dec 2008 13:53:13 -0800 (PST)
Date: Thu, 4 Dec 2008 08:48:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 20/22] move vn_iowait / vn_iowake into xfs_aops.c
Message-ID: <20081203214809.GY18236@disturbed>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160652.542003000@bombadil.infradead.org>
	<20081203031719.GQ18236@disturbed>
	<20081203105831.GB19287@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081203105831.GB19287@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Wed, Dec 03, 2008 at 05:58:31AM -0500, Christoph Hellwig wrote:
> On Wed, Dec 03, 2008 at 02:17:19PM +1100, Dave Chinner wrote:
> > On Tue, Dec 02, 2008 at 11:04:50AM -0500, Christoph Hellwig wrote:
> > > The whole machinery to wait on I/O completion is related to the I/O path
> > > and should be there instead of in xfs_vnode.c.  Also give the functions
> > > more descriptive names.
> > 
> > I'm not sure that "xfs_ioend_..." is the best name - it looks
> > slightly weird in some of the callers' contexts. Just dropping the
> > "end" out of the names makes the code read much better (i.e.
> > xfs_io_wait() and xfs_io_wake()). Not particularly important,
> > though, and everything else looks good.
> 
> xfs_ioend_* wasn't my first choice either.  I first did
> xfs_iowait/xfs_iowake, but that clashes with the buffercache.

Ah, so it does. but:

#define xfs_iowait(bp)  xfs_buf_iowait(bp)

Perhaps we should kill that define and just use xfs_buf_iowait(bp)
because it documents that we really are waiting on a specific
object....

Then maybe we can use xfs_data_iowake/xfs_data_iowait for the data
I/O on an inode to complete. That way it's obvious from the code
exactly what we are waiting on, too (which might make some of the
comments redundant).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
