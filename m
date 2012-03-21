Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2LNGdIe139755 for <xfs@oss.sgi.com>; Wed, 21 Mar 2012 18:16:40 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qIf3SUHUAC0aE6E3 for <xfs@oss.sgi.com>;
	Wed, 21 Mar 2012 16:16:37 -0700 (PDT)
Date: Thu, 22 Mar 2012 10:16:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: remove log item from AIL in xfs_qm_dqflush
	after a shutdown
Message-ID: <20120321231633.GY5091@dastard>
References: <20120316175541.258282540@bombadil.infradead.org>
	<20120316175635.995054821@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120316175635.995054821@bombadil.infradead.org>
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

On Fri, Mar 16, 2012 at 01:55:42PM -0400, Christoph Hellwig wrote:
> If a filesystem has been forced shutdown we are never going to write dquots
> to disk, which means the dquot items will stay in the AIL forever.
> Currently that is not a problem, but a pending chance requires us to
> empty the AIL before shutting down the filesystem, in which case this
> behaviour is lethal.  Make sure to remove the log item from the AIL
> to allow emptying the AIL on shutdown filesystems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
