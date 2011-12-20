Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBKLJBHr183757 for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 15:19:11 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	57Ed5fci3FZ84pK5 for <xfs@oss.sgi.com>;
	Tue, 20 Dec 2011 13:19:09 -0800 (PST)
Date: Wed, 21 Dec 2011 08:19:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/1] xfs: log the inode in ->write_inode calls for kupdate
Message-ID: <20111220211907.GX23662@dastard>
References: <20111218154936.GA17626@infradead.org>
	<20111218154955.GB17626@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111218154955.GB17626@infradead.org>
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
Cc: Paul Anderson <pha@umich.edu>, Sean Thomas Caron <scaron@umich.edu>, xfs@oss.sgi.com

On Sun, Dec 18, 2011 at 10:49:55AM -0500, Christoph Hellwig wrote:
> If the writeback code writes back an inode because it has expired we currently
> use the non-blockin ->write_inode path.  This means any inode that is pinned
> is skipped.  With delayed logging and a workload that has very little log
> traffic otherwise it is very likely that an inode that gets constantly
> written to is always pinned, and thus we keep refusing to write it.  The VM
> writeback code at that point redirties it and doesn't try to write it again
> for another 30 seconds.  This means under certain scenarious time based
> metadata writeback never happens.
> 
> Fix this by calling into xfs_log_inode for kupdate in addition to data
> integrity syncs, and thus transfer the inode to the log ASAP.

Makes sense.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
