Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0NKFJqT221129 for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 14:15:20 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66E56185A7DE
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 12:14:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31]) by cuda.sgi.com
	with ESMTP id iVU0xvnonVhDE01M for <xfs@oss.sgi.com>;
	Fri, 23 Jan 2009 12:14:35 -0800 (PST)
Date: Fri, 23 Jan 2009 15:14:30 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: spurious -ENOSPC on XFS
In-Reply-To: <20090122224347.GA18751@infradead.org>
Message-ID: <Pine.LNX.4.64.0901231509010.5179@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
	<20090113214949.GN8071@disturbed>
	<Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
	<20090118173144.GA1999@infradead.org>
	<Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com>
	<20090120232422.GF10158@disturbed>
	<20090122205913.GA30859@infradead.org>
	<20090122224347.GA18751@infradead.org>
MIME-Version: 1.0
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
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com



On Thu, 22 Jan 2009, Christoph Hellwig wrote:

> On Thu, Jan 22, 2009 at 03:59:13PM -0500, Christoph Hellwig wrote:
> > On Wed, Jan 21, 2009 at 10:24:22AM +1100, Dave Chinner wrote:
> > > Right, so you need to use internal xfs sync functions that don't
> > > have these problems. That is:
> > > 
> > > 	error = xfs_sync_inodes(ip->i_mount, SYNC_DELWRI|SYNC_WAIT);
> > > 
> > > will do a blocking flush of all the inodes without deadlocks occurring.
> > > Then you can remove the 500ms wait.
> > 
> > I've given this a try with Eric's testcase from #724 in the oss bugzilla,
> > but it's not enough yet.  I thinks that's because SYNC_WAIT is rather
> > meaningless for data writeout, and we need SYNC_IOWAIT instead.  The
> > patch below gets the testcase working for me:
> 
> Actually I still see failures happing sometimes.  I guess tha'ts because
> our flush is still asynchronous due to the schedule_work..

If I placed
xfs_sync_inodes(ip->i_mount, SYNC_DELWRI);
xfs_sync_inodes(ip->i_mount, SYNC_DELWRI | SYNC_IOWAIT);
directly to xfs_flush_device, I got lock dependency warning (though not a 
real deadlock).

So synchronous flushing definitely needs some thinking and lock 
rearchitecting. If you sync it asynchronously, a deadlock possibility will 
actually turn into spurious -ENOSPC (because the flushing thread will wait 
untill the main thread sleeps for 500ms, drops the lock and returns 
ENOSPC).

Mikulas

=============================================
[ INFO: possible recursive locking detected ]
2.6.29-rc1-devel #2
---------------------------------------------
mc/336 is trying to acquire lock:
 (&(&ip->i_iolock)->mr_lock){----}, at: [<0000000010186b88>] 
xfs_ilock+0x68/0xa0 [xfs]

but task is already holding lock:
 (&(&ip->i_iolock)->mr_lock){----}, at: [<0000000010186bb0>] 
xfs_ilock+0x90/0xa0 [xfs]

other info that might help us debug this:
2 locks held by mc/336:
 #0:  (&sb->s_type->i_mutex_key#8){--..}, at: [<00000000101b1560>] 
xfs_write+0x340/0x6a0 [xfs]
 #1:  (&(&ip->i_iolock)->mr_lock){----}, at: [<0000000010186bb0>] 
xfs_ilock+0x90/0xa0 [xfs]

stack backtrace:
Call Trace:
 [000000000047e924] validate_chain+0x1184/0x1460
 [000000000047ee88] __lock_acquire+0x288/0xae0
 [000000000047f734] lock_acquire+0x54/0x80
 [0000000000470b20] down_read_nested+0x40/0x60
 [0000000010186b88] xfs_ilock+0x68/0xa0 [xfs]
 [00000000101b4f78] xfs_sync_inodes_ag+0x218/0x320 [xfs]
 [00000000101b5100] xfs_sync_inodes+0x80/0x100 [xfs]
 [00000000101b51a0] xfs_flush_device+0x20/0x60 [xfs]
 [000000001018e654] xfs_flush_space+0x94/0x100 [xfs]
 [000000001018e95c] xfs_iomap_write_delay+0x13c/0x240 [xfs]
 [000000001018f100] xfs_iomap+0x280/0x300 [xfs]
 [00000000101a84d4] __xfs_get_blocks+0x74/0x260 [xfs]
 [00000000101a8724] xfs_get_blocks+0x24/0x40 [xfs]
 [00000000004e6800] __block_prepare_write+0x220/0x4e0
 [00000000004e6b68] block_write_begin+0x48/0x100
 [00000000101a785c] xfs_vm_write_begin+0x3c/0x60 [xfs]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
