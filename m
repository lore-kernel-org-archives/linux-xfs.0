Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q820afsx205425 for <xfs@oss.sgi.com>; Sat, 1 Sep 2012 19:36:41 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	r6UaF8goh6mGuxsU for <xfs@oss.sgi.com>;
	Sat, 01 Sep 2012 17:37:35 -0700 (PDT)
Date: Sun, 2 Sep 2012 10:37:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs sb_internal#2 lockdep splat
Message-ID: <20120902003731.GK15292@dastard>
References: <alpine.DEB.2.00.1208311318140.19947@cobra.newdream.net>
	<20120901230425.GA6896@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120901230425.GA6896@infradead.org>
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
Cc: Jan Kara <jack@suse.cz>, Sage Weil <sage@inktank.com>, xfs@oss.sgi.com

On Sat, Sep 01, 2012 at 07:04:26PM -0400, Christoph Hellwig wrote:
> I've had some time to look at this issue and it seems to be due to the
> brand new filesystem freezing code in the VFS which (ab-)uses lockdep
> in a creative way.

Yes. It's interacting strangely with other lockdep abuses like the
work queue annotations, which is where this one is coming from.
Basically, freeze counters and work queue flushes are *not locks*,
but lockdep is being told they are locks and it's not smart enough
to know the difference. It just sees different orders in different
contexts and complains.

> In short the XFS code to flush pending delalloc data when running into
> ENOSPC conditions.  I don't understand the fsfreeze code and its usage
> of lockdep enough to confirm if the warning is correct, but Dave has
> patches to rip this code path out in the current from and replace it
> with the VM layer code used by ext4 and btrfs.  I suspect that should
> sort out this issue.

Right, after a couple of days of thinking, I think the root of the
issue is that lockdep sees that the data writeback done by the
xfs_flush_worker can run transactions, but does so while holding an
open transaction. So we have a wait synchronous with an open
transaction that is dependent on other transactions being started.

However, this is a false positive warning because of freeze
behaviour (context) that lockdep is not aware of and cannot be told
about. That is, the inode flush will always be completed before the
freeze can progress past the FREEZE_WRITE stage, and the
transactions are in the FREEZE_FS context. IOWs:

> > [23405.638393]  Possible unsafe locking scenario:
> > [23405.638393] 
> > [23405.638394]        CPU0                    CPU1
> > [23405.638394]        ----                    ----
> > [23405.638396]   lock(sb_internal#2);
> > [23405.638398]                                lock((&mp->m_flush_work));
> > [23405.638400]                                lock(sb_internal#2);
> > [23405.638402]   lock((&mp->m_flush_work));

ignores the fact the CPU0 lock order is actually:

	lock(sb_internal#0);		<< FREEZE_WRITE
	lock(sb_internal#2);		<< FREEZE_FS
	lock((&mp->m_flush_work));

And that it is safe to do any sort of dependent lock of
sb_internal#2 while a sb_internal#0 lock is held and that nested
dependent sb_internal#2 lock levels is also safe for the same
reason. Inversions/nesting of FREEZE_FS only matter outside
FREEZE_WRITE/FREEZE_PAGECACHE context, not when they are inside that
context.

Indeed, changing the code to use the VFS flush functions doesn't
change this at all - we still block waiting for IO submission and
hence allocation transactions whilst holding the same "locks". We'll
just avoid lockdep false positives because the VFS writeback code
doesn't use the workqueue infrastructure and hence has no lockdep
annotations to make waiting for the IO submission look like a
lock...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
