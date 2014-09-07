Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A30067F4E
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 18:39:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7C1C2304032
	for <xfs@oss.sgi.com>; Sun,  7 Sep 2014 16:39:17 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	qLJfDbKInF0S9oIa for <xfs@oss.sgi.com>;
	Sun, 07 Sep 2014 16:39:14 -0700 (PDT)
Date: Mon, 8 Sep 2014 09:39:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: storage, libaio, or XFS problem?  3.4.26
Message-ID: <20140907233910.GA30012@dastard>
References: <20140828230817.GU20518@dastard>
	<2d2ce7bb38c00a7d35f4a324f6a36cbb@localhost>
	<20140829235538.GF20518@dastard>
	<d20fe777ec1fd318ae5d4054dffda3f4@localhost>
	<20140831235749.GH20518@dastard>
	<5403E9B9.7040608@hardwarefreak.com>
	<20140901234529.GI20518@dastard>
	<5405FB19.2020208@hardwarefreak.com>
	<20140902221915.GK20518@dastard>
	<540BEBB7.7020306@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <540BEBB7.7020306@hardwarefreak.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: stan hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 07, 2014 at 12:23:03AM -0500, stan hoeppner wrote:
> I have some more information regarding the AIO issue.  I fired up the
> test harness and it ran for 30 hours at 706 MB/s avg write rate, 303
> MB/s per LUN, nearly flawlessly, less than 0.01% buffer loss, and avg IO
> times were less than 0.5 seconds.  Then the app crashed and I found the
> following in dmesg.  I had to "hard reset" the box due to the shrapnel.
>  There are no IO errors of any kind leading up to the forced shutdown.
> I assume the inode update and streamRT-sa hung task traces are a result
> of the forced shutdown, not a cause of it.  In lieu of an xfs_repair
> with a version newer than I'm able to install, any ideas what caused the
> forced shutdown after 30 hours, given there are no errors preceding it?
> 
> 
> Sep  6 06:33:33 Anguish-ssu-1 kernel: [288087.334863] XFS (dm-5):
> xfs_do_force_shutdown(0x8) called from line 3732 of file
> fs/xfs/xfs_bmap.c.  Return address = 0xffffffffa02009a6
> Sep  6 06:33:42 Anguish-ssu-1 kernel: [288096.220920] XFS (dm-5): failed
> to update timestamps for inode 0x2ffc9caae

Hi Stan, can you need to turn off line wrapping for stuff you paste
in? It's all but unreadable when it line wraps like this?

Next, you need to turn /proc/sys/fs/xfs/error_level up to 11 so that
it dumps a stack trace on corruption events. I don't have a (I can't
remember what kernel version you are running) tree in front of me to
convert that line number to something meaningful, so it's not a
great help...

Was there anything in the logs before the shutdown?  i.e. can you
paste the dmesg output from the start of the test (i.e. the mount of
the fs) to the end?

As it is, all the traces looke like this:

> [<ffffffff814f5fd7>] schedule+0x64/0x66
> [<ffffffff814f66ec>] rwsem_down_failed_common+0xdb/0x10d
> [<ffffffff814f6731>] rwsem_down_write_failed+0x13/0x15
> [<ffffffff81261913>] call_rwsem_down_write_failed+0x13/0x20
> [<ffffffff814f5458>] ? down_write+0x25/0x27
> [<ffffffffa01e75e4>] xfs_ilock+0x4f/0xb4 [xfs]
> [<ffffffffa01e40e5>] xfs_rw_ilock+0x2c/0x33 [xfs]
> [<ffffffff814f6ac6>] ? _raw_spin_unlock_irq+0x27/0x32
> [<ffffffffa01e4519>] xfs_file_aio_write_checks+0x41/0xfe [xfs]
> [<ffffffffa01e46ff>] xfs_file_dio_aio_write+0x103/0x1fc [xfs]
> [<ffffffffa01e4ac3>] xfs_file_aio_write+0x152/0x1b5 [xfs]
> [<ffffffffa01e4971>] ? xfs_file_buffered_aio_write+0x179/0x179 [xfs]
> [<ffffffff81133694>] aio_rw_vect_retry+0x85/0x18a
> [<ffffffff8113360f>] ? aio_fsync+0x29/0x29
> [<ffffffff81134c10>] aio_run_iocb+0x7b/0x149
> [<ffffffff81134fe9>] io_submit_one+0x199/0x1f3
> [<ffffffff8113513d>] do_io_submit+0xfa/0x271
> [<ffffffff811352c4>] sys_io_submit+0x10/0x12
> [<ffffffff814fc912>] system_call_fastpath+0x16/0x1b

Which implies that the shutdown didn't unlock the inode correctly.
But without knowing what the call stack at the time of the shutdown
was, I can't really tell...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
