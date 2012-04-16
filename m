Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3GNsck4257082 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 18:54:39 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	3KxYfvf1Tx7NhPv1 for <xfs@oss.sgi.com>;
	Mon, 16 Apr 2012 16:54:35 -0700 (PDT)
Date: Tue, 17 Apr 2012 09:54:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/10] xfs: implement freezing by emptying the AIL
Message-ID: <20120416235432.GZ6734@dastard>
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164644.830680325@bombadil.infradead.org>
	<4F8C22D4.3040908@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F8C22D4.3040908@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Apr 16, 2012 at 08:47:00AM -0500, Mark Tinguely wrote:
> On 03/27/12 11:44, Christoph Hellwig wrote:
> >Now that we write back all metadata either synchronously or through the AIL
> >we can simply implement metadata freezing in terms of emptying the AIL.
> >
> >The implementation for this is fairly simply and straight-forward:  A new
> >routine is added that increments a counter that tells xfsaild to not stop
> >until the AIL is empty and then waits on a wakeup from
> >xfs_trans_ail_delete_bulk to signal that the AIL is empty.
> >
> >As usual the devil is in the details, in this case the filesystem shutdown
> >code.  Currently we are a bit sloppy there and do not continue ail pushing
> >in that case, and thus never reach the code in the log item implementations
> >that can unwind in case of a shutdown filesystem.  Also the code to
> >abort inode and dquot flushes was rather sloppy before and did not remove
> >the log items from the AIL, which had to be fixed as well.
> >
> >Also treat unmount the same way as freeze now, except that we still keep a
> >synchronous inode reclaim pass to make sure we reclaim all clean inodes, too.
> >
> >As an upside we can now remove the radix tree based inode writeback and
> >xfs_unmountfs_writesb.
> >
> >Signed-off-by: Christoph Hellwig<hch@lst.de>
> 
> Sorry for the empty email.
> 
> This series hangs my test boxes. This patch is the first indication
> of the hang. Reboot, and remove patch 4 and the test are successful.
> 
> The machine is still responsive. Only the SCRATCH filesystem from
> the test suite is hung.
> 
> Per Dave's observation, I added a couple inode reclaims to this
> patch and the test gets further (hangs on run 9 of test 068 rather
> than run 3).

That implies that there are dirty inodes at the VFS level leaking
through the freeze.

.....

> The back traces are from a Linux 3.4-rc2 kernel with just patches
> 0-4 of this series applied. This traceback does not have extra inode
> reclaims. The hang is in test 068. I did an ls and sync to the
> filesystem, so I included their tracebacks as well.  live system.
> 
> I have looked at the remaining patches in the series, but have not
> reviewed them because they depend on this patch...
> 
> --Mark.
> ---
> 
> crash> bt -f 20050
> PID: 20050  TASK: ffff88034a6943c0  CPU: 0   COMMAND: "fsstress"
>  #0 [ffff88034aa93d18] __schedule at ffffffff81416e50
>  #1 [ffff88034aa93e60] schedule at ffffffff814171c4
>  #2 [ffff88034aa93e70] do_wait at ffffffff81040e39
>  #3 [ffff88034aa93ee0] sys_wait4 at ffffffff81040f11
>  #4 [ffff88034aa93f80] system_call_fastpath at ffffffff8141fff9
> 
> PID: 20051  TASK: ffff88034e31e600  CPU: 3   COMMAND: "fsstress"
>  #0 [ffff88034c5c1c08] __schedule at ffffffff81416e50
>  #1 [ffff88034c5c1d50] schedule at ffffffff814171c4
>  #2 [ffff88034c5c1d60] xfs_file_aio_write at ffffffffa044d4b5 [xfs]
>  #3 [ffff88034c5c1df0] do_sync_write at ffffffff8114d3d9
>  #4 [ffff88034c5c1f10] vfs_write at ffffffff8114da0b
>  #5 [ffff88034c5c1f40] sys_write at ffffffff8114db60
>  #6 [ffff88034c5c1f80] system_call_fastpath at ffffffff8141fff9

Frozen write, not holding any locks.

> PID: 20052  TASK: ffff88034ad56080  CPU: 3   COMMAND: "fsstress"
>  #0 [ffff88034a88fbb8] __schedule at ffffffff81416e50
>  #1 [ffff88034a88fd00] schedule at ffffffff814171c4
>  #2 [ffff88034a88fd10] schedule_timeout at ffffffff81415455
>  #3 [ffff88034a88fdb0] wait_for_common at ffffffff814166b7
>  #4 [ffff88034a88fe40] wait_for_completion at ffffffff81416828
>  #5 [ffff88034a88fe50] sync_inodes_sb at ffffffff81174eaa
>  #6 [ffff88034a88fee0] __sync_filesystem at ffffffff8117a4a0
>  #7 [ffff88034a88ff00] sync_one_sb at ffffffff8117a4c7
>  #8 [ffff88034a88ff10] iterate_supers at ffffffff8115126b
>  #9 [ffff88034a88ff50] sys_sync at ffffffff8117a515
> #10 [ffff88034a88ff80] system_call_fastpath at ffffffff8141fff9

Waiting for flusher thread completion, holding the sb->s_umount lock
in read mode.

> PID: 20089  TASK: ffff88034c5ca340  CPU: 2   COMMAND: "xfs_freeze"
>  #0 [ffff88034aaafd18] __schedule at ffffffff81416e50
>  #1 [ffff88034aaafe60] schedule at ffffffff814171c4
>  #2 [ffff88034aaafe70] do_wait at ffffffff81040e39
>  #3 [ffff88034aaafee0] sys_wait4 at ffffffff81040f11
>  #4 [ffff88034aaaff80] system_call_fastpath at ffffffff8141fff9
> 
> PID: 20093  TASK: ffff88034b42a4c0  CPU: 1   COMMAND: "xfs_io"
>  #0 [ffff88034c3abc98] __schedule at ffffffff81416e50
>  #1 [ffff88034c3abde0] schedule at ffffffff814171c4
>  #2 [ffff88034c3abdf0] rwsem_down_failed_common at ffffffff81417de5
>  #3 [ffff88034c3abe60] rwsem_down_write_failed at ffffffff81417e93
>  #4 [ffff88034c3abe70] call_rwsem_down_write_failed at ffffffff8123fd93
>  #5 [ffff88034c3abeb0] down_write at ffffffff81416110
>  #6 [ffff88034c3abec0] thaw_super at ffffffff81150343
>  #7 [ffff88034c3abef0] do_vfs_ioctl at ffffffff8115efb8
>  #8 [ffff88034c3abf30] sys_ioctl at ffffffff8115f139
>  #9 [ffff88034c3abf80] system_call_fastpath at ffffffff8141fff9

waiting for sb->s_umount, which can only be released by flusher
thread completion.

> PID: 20185  TASK: ffff88034c31c280  CPU: 1   COMMAND: "sync"
>  #0 [ffff88034afe7b88] __schedule at ffffffff81416e50
>  #1 [ffff88034afe7cd0] schedule at ffffffff814171c4
>  #2 [ffff88034afe7ce0] schedule_timeout at ffffffff81415455
>  #3 [ffff88034afe7d80] wait_for_common at ffffffff814166b7
>  #4 [ffff88034afe7e10] wait_for_completion at ffffffff81416828
>  #5 [ffff88034afe7e20] writeback_inodes_sb_nr at ffffffff81174c69
>  #6 [ffff88034afe7eb0] writeback_inodes_sb at ffffffff8117522c
>  #7 [ffff88034afe7ee0] __sync_filesystem at ffffffff8117a469
>  #8 [ffff88034afe7f00] sync_one_sb at ffffffff8117a4c7
>  #9 [ffff88034afe7f10] iterate_supers at ffffffff8115126b
> #10 [ffff88034afe7f50] sys_sync at ffffffff8117a4ff
> #11 [ffff88034afe7f80] system_call_fastpath at ffffffff8141fff9

waiting for flusher thread completion, holding the sb->s_umount lock
in read mode.

> 
> PID: 20110  TASK: ffff88034a4820c0  CPU: 2   COMMAND: "ls"
>  #0 [ffff88034a855c78] __schedule at ffffffff81416e50
>  #1 [ffff88034a855dc0] schedule at ffffffff814171c4
>  #2 [ffff88034a855dd0] xfs_trans_alloc at ffffffffa0499fb5 [xfs]
>  #3 [ffff88034a855e30] xfs_fs_dirty_inode at ffffffffa0457aa2 [xfs]
>  #4 [ffff88034a855e60] __mark_inode_dirty at ffffffff811753da
>  #5 [ffff88034a855ea0] touch_atime at ffffffff811662db
>  #6 [ffff88034a855ef0] vfs_readdir at ffffffff8115f934
>  #7 [ffff88034a855f30] sys_getdents64 at ffffffff8115f9c3
>  #8 [ffff88034a855f80] system_call_fastpath at ffffffff8141fff9

Frozen attribute modification, no locks held.

So, what are the flusher threads doing - where are they stuck?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
