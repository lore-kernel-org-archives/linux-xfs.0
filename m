Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3D9bGhS018456 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 04:37:16 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qZQPlEBvrtMwgeBe for <xfs@oss.sgi.com>;
	Fri, 13 Apr 2012 02:37:14 -0700 (PDT)
Date: Fri, 13 Apr 2012 19:37:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/10] xfs: remove log item from AIL in xfs_iflush after
	a shutdown
Message-ID: <20120413093712.GF6734@dastard>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164644.420702935@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120327164644.420702935@bombadil.infradead.org>
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

On Tue, Mar 27, 2012 at 12:44:02PM -0400, Christoph Hellwig wrote:
> If a filesystem has been forced shutdown we are never going to write inodes
> to disk, which means the inode items will stay in the AIL until we free
> the inode. Currently that is not a problem, but a pending change requires us
> to empty the AIL before shutting down the filesystem. In that case leaving
> the inode in the AIL is lethal. Make sure to remove the log item from the AIL
> to allow emptying the AIL on shutdown filesystems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Simplifies things a lot - abort immediately rather than leave it for
someone else to cleanup.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
