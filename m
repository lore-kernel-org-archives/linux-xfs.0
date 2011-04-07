Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p37LDSgC130752 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 16:13:28 -0500
Subject: Re: [PATCH 3/9] xfs: convert ENOSPC inode flushing to use new
	syncd workqueue
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1302141445-27457-4-git-send-email-david@fromorbit.com>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
	<1302141445-27457-4-git-send-email-david@fromorbit.com>
Date: Thu, 07 Apr 2011 16:16:11 -0500
Message-ID: <1302210971.2576.599.camel@doink>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2011-04-07 at 11:57 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On of the problems with the current inode flush at ENOSPC is that we
> queue a flush per ENOSPC event, regardless of how many are already
> queued. Thi can result in    hundreds of queued flushes, most of
> which simply burn CPU scanned and do no real work. This simply slows
> down allocation at ENOSPC.
> 
> We really only need one active flush at a time, and we can easily
> implement that via the new xfs_syncd_wq. All we need to do is queue
> a flush if one is not already active, then block waiting for the
> currently active flush to complete. The result is that we only ever
> have a single ENOSPC inode flush active at a time and this greatly
> reduces the overhead of ENOSPC processing.
> 
> On my 2p test machine, this results in tests exercising ENOSPC
> conditions running significantly faster - 042 halves execution time,
> 083 drops from 60s to 5s, etc - while not introducing test
> regressions.
> 
> This allows us to remove the old xfssyncd threads and infrastructure
> as they are no longer used.

Looks good.  You got rid of a useless log force as well.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
