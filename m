Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QMI6wk103323 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 17:18:07 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	pZcR0K6o9yDTSzDm for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 15:18:05 -0700 (PDT)
Date: Tue, 27 Mar 2012 09:17:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: reduce ilock hold times in xfs_setattr_size
Message-ID: <20120326221750.GR5091@dastard>
References: <20120326211421.518374058@bombadil.infradead.org>
	<20120326211603.455167123@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120326211603.455167123@bombadil.infradead.org>
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

On Mon, Mar 26, 2012 at 05:14:24PM -0400, Christoph Hellwig wrote:
> We do not need the ilock for most checks done in the beginning of
> xfs_setattr_size.  Replace the long critical section before starting the
> transaction with a smaller one around xfs_zero_eof and an optional one
> inside xfs_qm_dqattach that isn't entered unless using quotas.  While
> this isn't a big optimization for xfs_setattr_size itself it will allow
> pushing the ilock into xfs_zero_eof itself later.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks sane to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
