Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0VNwASx137672 for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 17:58:11 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4450D1889DAE
	for <xfs@oss.sgi.com>; Sat, 31 Jan 2009 15:57:29 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	6eEyBoOqtsAmWeoB for <xfs@oss.sgi.com>;
	Sat, 31 Jan 2009 15:57:29 -0800 (PST)
Date: Sun, 1 Feb 2009 10:57:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090131235725.GA24173@disturbed>
References: <20090113214949.GN8071@disturbed>
	<Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
	<20090118173144.GA1999@infradead.org>
	<Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com>
	<20090120232422.GF10158@disturbed>
	<20090122205913.GA30859@infradead.org>
	<20090122224347.GA18751@infradead.org>
	<Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com>
	<20090124071249.GF32390@disturbed>
	<Pine.LNX.4.64.0901291136050.19368@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901291136050.19368@hs20-bc2-1.build.redhat.com>
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jan 29, 2009 at 11:39:00AM -0500, Mikulas Patocka wrote:
> On Sat, 24 Jan 2009, Dave Chinner wrote:
> > On Fri, Jan 23, 2009 at 03:14:30PM -0500, Mikulas Patocka wrote:
> > > If I placed
> > > xfs_sync_inodes(ip->i_mount, SYNC_DELWRI);
> > > xfs_sync_inodes(ip->i_mount, SYNC_DELWRI | SYNC_IOWAIT);
> > > directly to xfs_flush_device, I got lock dependency warning (though not a 
> > > real deadlock).
> > 
> > Same reason memory reclaim gives lockdep warnings on XFS - we're
> > recursing into operations that take inode locks while we currently
> > hold an inode lock.  However, it shouldn't deadlock because
> > we should ever try to take the iolock on the inode that we current
> > hold it on.
> > 
> > > So synchronous flushing definitely needs some thinking and lock 
> > > rearchitecting.
> > 
> > No, not at all. At most the grabbing of the iolock in
> > xfs_sync_inodes_ag() needs to become a trylock....
> 
> You are wrong, the comments in the code are right. It really
> deadlocks if it is modified to use synchronous wait for the end of
> the flush and if the flush is done with xfs_sync_inodes:
> 
> xfssyncd      D 0000000000606808     0  4819      2
> Call Trace:
>  [0000000000606788] rwsem_down_failed_common+0x1ac/0x1d8
>  [0000000000606808] rwsem_down_read_failed+0x24/0x34
>  [0000000000606848] __down_read+0x30/0x40
>  [0000000000468a64] down_read_nested+0x48/0x58
>  [00000000100e6cc8] xfs_ilock+0x48/0x8c [xfs]
>  [000000001011018c] xfs_sync_inodes_ag+0x17c/0x2dc [xfs]
>  [000000001011034c] xfs_sync_inodes+0x60/0xc4 [xfs]
>  [00000000101103c4] xfs_flush_device_work+0x14/0x2c [xfs]
>  [000000001010ff1c] xfssyncd+0x110/0x174 [xfs]
>  [000000000046556c] kthread+0x54/0x88
>  [000000000042b2a0] kernel_thread+0x3c/0x54
>  [00000000004653b8] kthreadd+0xac/0x160

So it is stuck:

127                 /*
128                  * If we have to flush data or wait for I/O completion
129                  * we need to hold the iolock.
130                  */
131                 if ((flags & SYNC_DELWRI) && VN_DIRTY(inode)) {
132     >>>>>>>>            xfs_ilock(ip, XFS_IOLOCK_SHARED);
133                         lock_flags |= XFS_IOLOCK_SHARED;
134                         error = xfs_flush_pages(ip, 0, -1, fflag, FI_NONE);
135                         if (flags & SYNC_IOWAIT)
136                                 xfs_ioend_wait(ip);
137                 }

Given that we are stuck on the iolock in xfs_sync_inodes_ag(), I
suspect you should re-read my comments above about "lock
re-architecting" ;).

If you make the xfs_ilock() there xfs_ilock_nowait() and avoid data
writeback if we don't get the lock the deadlock goes away, right?

BTW, can you post the patch you are working on?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
