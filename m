Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6REt95x191840 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 09:55:09 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 003EE476315
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 07:58:11 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	V3OO4uqH6GrTP0jm for <xfs@oss.sgi.com>;
	Tue, 27 Jul 2010 07:58:11 -0700 (PDT)
Date: Wed, 28 Jul 2010 00:58:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS hang in xlog_grant_log_space
Message-ID: <20100727145808.GQ7362@dastard>
References: <20100722190100.GA22269@amd> <20100723135514.GJ32635@dastard>
	<20100727070538.GA2893@amd> <20100727080632.GA4958@amd>
	<20100727113626.GA2884@amd> <20100727133038.GP7362@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100727133038.GP7362@dastard>
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
To: Nick Piggin <npiggin@kernel.dk>
Cc: xfs@oss.sgi.com

On Tue, Jul 27, 2010 at 11:30:38PM +1000, Dave Chinner wrote:
> On Tue, Jul 27, 2010 at 09:36:26PM +1000, Nick Piggin wrote:
> > On Tue, Jul 27, 2010 at 06:06:32PM +1000, Nick Piggin wrote:
> > On this same system, same setup (vanilla kernel with sha given below),
> > I have now twice reproduced a complete hang in XFS. I can give more
> > information, test patches or options etc if required.
> > 
> > setup.sh looks like this:
> > #!/bin/bash
> > modprobe rd rd_size=$[2*1024*1024]
> > dd if=/dev/zero of=/dev/ram0 bs=4K
> > mkfs.xfs -f -l size=64m -d agcount=16 /dev/ram0
> > mount -o delaylog,logbsize=262144,nobarrier /dev/ram0 mnt
> > 
> > The 'dd' is required to ensure rd driver does not allocate pages
> > during IO (which can lead to out of memory deadlocks). Running just
> > involves changing into mnt directory and
> > 
> > while true
> > do
> >   sync
> >   echo 3 > /proc/sys/vm/drop_caches
> >   ../dbench -c ../loadfiles/client.txt -t20 8
> >   rm -rf clients
> > done
> > 
> > And wait for it to hang (happend in < 5 minutes here)
> ....
> > Call Trace:
> >  [<ffffffff812361f8>] xlog_grant_log_space+0x158/0x3d0
> 
> It's waiting on log space to be freed up. Either there's an
> accounting problem (possible), or you've got an xfslogd/xfsaild
> spinning and not making progress competing log IOs or pushing the
> tail of the log. I'll see if I can reproduce it.

Ok, I've just reproduced it. From some tracing:

touch-3340  [004] 1844935.582716: xfs_log_reserve: dev 1:0 type CREATE t_ocnt 2 t_cnt 2 t_curr_res 167148 t_unit_res 167148 t_flags XLOG_TIC_INITED|XLOG_TIC_PERM_RESERV reserve_headq 0xffff88010f489c78 write_headq 0x(null) grant_reserve_cycle 314 grant_reserve_bytes 24250680 grant_write_cycle 314 grant_write_bytes 24250680 curr_cycle 314 curr_block 44137 tail_cycle 313 tail_block 48532

The key part here is this:

curr_cycle 314 curr_block 44137 tail_cycle 313 tail_block 48532

This says the tail of the log is roughly 62MB behind the head. i.e
the log is full and we are waiting for tail pushing to write the
item holding the tail in place to disk so it can them be moved
forward. That's better than an accounting problem, at least.

So what is holding the tail in place? The first item on the AIL
appears to be:

xfsaild/ram0-2997  [000] 1844800.800764: xfs_buf_cond_lock: dev 1:0 bno 0x280120 len 0x2000 hold 3 pincount 0 lock 0 flags ASYNC|DONE|STALE|PAGE_CACHE caller xfs_buf_item_trylock

A stale buffer. Given that the next objects show this trace:

xfsaild/ram0-2997  [000] 1844800.800767: xfs_ilock_nowait: dev 1:0 ino 0x500241 flags ILOCK_SHARED caller xfs_inode_item_trylock
xfsaild/ram0-2997  [000] 1844800.800768: xfs_buf_rele: dev 1:0 bno 0x280120 len 0x2000 hold 4 pincount 0 lock 0 flags ASYNC|DONE|STALE|PAGE_CACHE caller _xfs_buf_find
xfsaild/ram0-2997  [000] 1844800.800769: xfs_iunlock: dev 1:0 ino 0x500241 flags ILOCK_SHARED caller xfs_inode_item_pushbuf

we see the next item on the AIL is an inode but the trace is
followed by a release on the original buffer, than tells me the
inode is flush locked and it returned XFS_ITEM_PUSHBUF to push the
inode buffer out. That results in xfs_inode_item_pushbuf() being
called, and that tries to lock the inode buffer to flush it.
xfs_buf_rele is called if the trylock on the buffer fails.

IOWs, this looks to be another problem with inode cluster freeing.

Ok, so we can't flush the buffer because it is locked. Why is it
locked? Well, that is unclear as yet. None of the blocked processes
should be holding an inode buffer locked, and a stale buffer should
be unlocked during transaction commit and not live longer than
the log IO that writes the transaction to disk. That is, it should
not get locked again before everything is freed up.

That's as much as I can get from post-mortem analysis - I need to
capture a trace that spans the lockup to catch what happens
to the buffer that we are hung on. That will have to wait until the
morning....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
