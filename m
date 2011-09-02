Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p820Jg1c045641 for <xfs@oss.sgi.com>; Thu, 1 Sep 2011 19:19:42 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B32E13B91AE
	for <xfs@oss.sgi.com>; Thu,  1 Sep 2011 17:23:12 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	2qd0D7MEuvbAJDhb for <xfs@oss.sgi.com>;
	Thu, 01 Sep 2011 17:23:12 -0700 (PDT)
Date: Fri, 2 Sep 2011 10:19:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] xfs: improve ioend error handling
Message-ID: <20110902001937.GS32358@dastard>
References: <20110824055924.139283426@bombadil.infradead.org>
	<20110824060149.777198300@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110824060149.777198300@bombadil.infradead.org>
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

On Wed, Aug 24, 2011 at 01:59:25AM -0400, Christoph Hellwig wrote:
> Return unwritten extent conversion errors to aio_complete.
> 
> Skip both unwritten extent conversion and size updates if we had an I/O error
> or the filesystem has been shut down.
> 
> Return -EIO to the aio/buffer completion handlers in case of a forced shutdown.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks sane.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
