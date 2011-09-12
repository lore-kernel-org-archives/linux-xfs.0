Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8CEedHS000569 for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 09:40:39 -0500
Subject: Re: [PATCH 1/3] xfs: improve ioend error handling
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060149.777198300@bombadil.infradead.org>
References: <20110824055924.139283426@bombadil.infradead.org>
	<20110824060149.777198300@bombadil.infradead.org>
Date: Mon, 12 Sep 2011 09:40:35 -0500
Message-ID: <1315838435.2916.41.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-08-24 at 01:59 -0400, Christoph Hellwig wrote:
> Return unwritten extent conversion errors to aio_complete.

It might have been good to call attention to the fact that
you were fixing it so ioend->io_error is consistently a
negative errno value now, thereby making the above change
possible.

Are we going to drop the last argument to aio_complete() now?

Anyway, this looks good, and as you privately requested
I will commit this patch without waiting for resolution
of issues in the other two in this series.

> Skip both unwritten extent conversion and size updates if we had an I/O error
> or the filesystem has been shut down.
> 
> Return -EIO to the aio/buffer completion handlers in case of a forced shutdown.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
