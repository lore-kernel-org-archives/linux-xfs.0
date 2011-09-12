Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8CEo0h8000992 for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 09:50:00 -0500
Date: Mon, 12 Sep 2011 10:49:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: improve ioend error handling
Message-ID: <20110912144929.GA2127@infradead.org>
References: <20110824055924.139283426@bombadil.infradead.org>
	<20110824060149.777198300@bombadil.infradead.org>
	<1315838435.2916.41.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315838435.2916.41.camel@doink>
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

On Mon, Sep 12, 2011 at 09:40:35AM -0500, Alex Elder wrote:
> On Wed, 2011-08-24 at 01:59 -0400, Christoph Hellwig wrote:
> > Return unwritten extent conversion errors to aio_complete.
> 
> It might have been good to call attention to the fact that
> you were fixing it so ioend->io_error is consistently a
> negative errno value now, thereby making the above change
> possible.

Indeed, freel free to fix up the commit message if you want.

> Are we going to drop the last argument to aio_complete() now?

I don't think anything related to it changed.  The argument is passed
on directly to userspace, and the usb gadget caller actually sets it.

No idea what the point of it is.

> Anyway, this looks good, and as you privately requested
> I will commit this patch without waiting for resolution
> of issues in the other two in this series.

The other two in this series are postponed - this one just happened to
be in the series because I found the issues while working on the other
two.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
