Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DAa09W026023 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 05:36:00 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	jPYW5t9uiD6ln7Eh for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 03:35:58 -0700 (PDT)
Date: Fri, 13 Apr 2012 20:35:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/10] xfs: do not add buffers to the delwri queue until
	pushed
Message-ID: <20120413103552.GL6734@dastard>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164646.539031348@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327164646.539031348@bombadil.infradead.org>
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

On Tue, Mar 27, 2012 at 12:44:08PM -0400, Christoph Hellwig wrote:
> Instead of adding buffers to the delwri list as soon as they are logged,
> even if they can't be written until commited because they are pinned
> defer adding them to the delwri list until xfsaild pushes them.  This
> makes the code more similar to other log items and prepares for writing
> buffers directly from xfsaild.
> 
> The complication here is that we need to fail buffers that were added
> but not logged yet in xfs_buf_item_unpin, borrowing code from
> xfs_bioerror.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
