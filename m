Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U1R2pi163729 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 20:27:03 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E901EE524B9
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 18:27:01 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8iYE1Y6kGn5p1RWk for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 18:27:01 -0700 (PDT)
Date: Thu, 30 Jun 2011 11:26:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/27] xfs: remove the unused ilock_nowait codepath in
	writepage
Message-ID: <20110630012658.GV561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.717434334@bombadil.infradead.org>
	<20110630001525.GU561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110630001525.GU561@dastard>
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

On Thu, Jun 30, 2011 at 10:15:25AM +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2011 at 10:01:11AM -0400, Christoph Hellwig wrote:
> > wbc->nonblocking is never set, so this whole code has been unreachable
> > for a long time.  I'm also not sure it would make a lot of sense -
> > we'd rather finish our writeout after a short wait for the ilock
> > instead of cancelling the whole ioend.
> 
> The problem that the non-blocking code is trying to solve is only
> obvious when the disk subsystem is fast enough to drive the flusher
> thread to being CPU bound.
> 
> e.g. when you have a disk subsystem doing background writeback
> 10GB/s and the flusher thread is put to sleep for 50ms while we wait
> for the lock, it can now only push 9.5GB/s. If we just move on, then
> we'll spend that 50ms doing useful work on another dirty inode
> rather than sleeping onthis one and hence maintaining a 10GB/s
> background write rate.
> 
> I'd suggest that the only thing that should be dropped is the
> wbc->nonblocking check. Numbers would be good to validate that this
> is still relevant, but I don't have a storage subsystem with enough
> bandwidth to drive a flusher thread to being CPU bound...

I just confirmed that I don't have a fast enough storage system to
test this - the flusher thread uses only ~15% of a CPU @ 800MB/s
writeback, so I'd need somewhere above 5GB/s of throughput to see
any sort of artifact from this change....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
