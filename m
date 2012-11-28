Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qASLUxHs215142 for <xfs@oss.sgi.com>; Wed, 28 Nov 2012 15:30:59 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	DC9fhgi91YMzgtSk for <xfs@oss.sgi.com>;
	Wed, 28 Nov 2012 13:33:16 -0800 (PST)
Date: Thu, 29 Nov 2012 08:33:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfs: fix splice/direct-IO deadlock
Message-ID: <20121128213314.GW6434@dastard>
References: <1354068768-4316-1-git-send-email-david@fromorbit.com>
	<1354068768-4316-3-git-send-email-david@fromorbit.com>
	<20121128160736.GA14888@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121128160736.GA14888@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Wed, Nov 28, 2012 at 11:07:36AM -0500, Christoph Hellwig wrote:
> On Wed, Nov 28, 2012 at 01:12:48PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > lockdep reports splice vs direct-io write lock inversions due to
> > generic_file_splice_write() taking the inode->i_mutex inside
> > XFS_IOLOCK_EXCL context. These lock contexts are inverted, hence can
> > deadlock.  Remove the XFS_IOLOCK_EXCL locking context from the outer
> > function and drive it inwards to the actor function that only locks
> > the inode when the lock is really needed,
> 
> punctuation?
> 
> Otherwise the patch looks fine, but I'd love to understand why the
> generic code thes te I_MUTEX_CHILD annotation and we can get away
> without it.
> 
> Also can you add a testcase for this to xfstests?

I've had trouble reproducing it reliably. The only cases I've seen
it occur are some custom FIO workloads. I'll try again to see if I
can come up with something that reliably hits it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
