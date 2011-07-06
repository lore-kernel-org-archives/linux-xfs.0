Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p669Bt2I099386 for <xfs@oss.sgi.com>; Wed, 6 Jul 2011 04:11:55 -0500
Date: Wed, 6 Jul 2011 05:11:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/27] xfs: cleanup I/O-related buffer flags
Message-ID: <20110706091154.GK19861@infradead.org>
References: <20110701094321.936534538@bombadil.infradead.org>
	<20110701094607.536262104@bombadil.infradead.org>
	<1309925355.3381.55.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1309925355.3381.55.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jul 05, 2011 at 11:09:15PM -0500, Alex Elder wrote:
> On Fri, 2011-07-01 at 05:43 -0400, Christoph Hellwig wrote:
> > Remove the unused and misnamed _XBF_RUN_QUEUES flag, rename XBF_LOG_BUFFER
> > to the more fitting XBF_SYNCIO, and split XBF_ORDERED into XBF_FUA and
> > XBF_FLUSH to allow more fine grained control over the bio flags.  Also
> > cleanup processing of the flags in _xfs_buf_ioapply to make more sense,
> > and renumber the sparse flag number space to group flags by purpose.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Interesting that _XBF_RUN_QUEUES was never actually used.
> The new names are much more understandable.  Looks like
> READ_META and WRITE_META are now effectively gone...

They have been gone for a while.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
