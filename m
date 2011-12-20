Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBKLLAln184016 for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 15:21:11 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	u6lvj3Tf5532XPOb for <xfs@oss.sgi.com>;
	Tue, 20 Dec 2011 13:21:07 -0800 (PST)
Date: Wed, 21 Dec 2011 08:21:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2 v2] xfs: log all dirty inodes in xfs_fs_sync_fs
Message-ID: <20111220212106.GY23662@dastard>
References: <20111218154936.GA17626@infradead.org>
	<20111218155015.GC17626@infradead.org>
	<20111220200841.GA2788@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111220200841.GA2788@infradead.org>
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

On Tue, Dec 20, 2011 at 03:08:41PM -0500, Christoph Hellwig wrote:
> Since Linux 2.6.36 the writeback code has introduces various measures for
> live lock prevention during sync().  Unfortunately some of these are
> actively harmful for the XFS model, where the inode gets marked dirty for
> metadata from the data I/O handler.
> 
> The older_than_this checks that are now more strictly enforced since
> 
>     writeback: avoid livelocking WB_SYNC_ALL writeback
> 
> by only calling into __writeback_inodes_sb and thus only sampling the
> current cut off time once.  But on a slow enough devices the previous
> asynchronous sync pass might not have fully completed yet, and thus XFS
> might mark metadata dirty only after that sampling of the cut off time for
> the blocking pass already happened.  I have not myself reproduced this
> myself on a real system, but by introducing artificial delay into the
> XFS I/O completion workqueues it can be reproduced easily.
> 
> Fix this by iterating over all XFS inodes in ->sync_fs and log all that
> are dirty.  This might log inode that only got redirtied after the
> previous pass, but given how cheap delayed logging of inodes is it
> isn't a major concern for performance.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK now.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
