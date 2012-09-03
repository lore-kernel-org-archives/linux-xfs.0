Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8344uoj132893 for <xfs@oss.sgi.com>; Sun, 2 Sep 2012 23:04:56 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jy6ZXwM1xh3tDLAh for <xfs@oss.sgi.com>;
	Sun, 02 Sep 2012 21:05:51 -0700 (PDT)
Date: Mon, 3 Sep 2012 14:05:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2 00/13] xfs: remove the xfssyncd mess
Message-ID: <20120903040523.GP15292@dastard>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<5040C3A0.2050107@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5040C3A0.2050107@sgi.com>
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
Cc: xfs@oss.sgi.com

On Fri, Aug 31, 2012 at 09:01:04AM -0500, Mark Tinguely wrote:
> On 08/30/12 07:00, Dave Chinner wrote:
> >Version 2 of the patchset I described here:
> >
> >http://oss.sgi.com/archives/xfs/2012-06/msg00064.html
> >
> >This version has run through xfstests completely once, so it's
> >less likely to let smoke out....
> >
> >Version 2:
> >- fix writeback_inodes_sb_if_idle call in xfs_create()
> >- refreshed patch 13 before sending.
> >
> >_______________________________________________
> >xfs mailing list
> >xfs@oss.sgi.com
> >http://oss.sgi.com/mailman/listinfo/xfs
> 
> I wanted to get a fast look at your patch series. I am getting the
> following ASSERT on xfstest 179 when running the series with the
> latest OSS soruces.The ASSERT appears to start at patch number 3.
> Sorry these boxes won't kdump the top of tree kernels:
> 
> [17474.545964] XFS: Assertion failed: atomic_read(&bp->b_hold) > 0,
> file: /root/xfs/fs/xfs/xfs_buf.c, line: 896

FWIW, when you paste stack traces, can you turn off line wrapping
when you paste it so the crash is simple to quote in reply? (use
:set paste in mutt, the :set nopaste when finished pasting it in).

> [17474.559784] Process umount (pid: 26427, threadinfo
...
> [17474.559784] Call Trace:
> [17474.559784]  [<ffffffffa05b4ed4>] xfs_buf_rele+0xa4/0x1b0 [xfs]
> [17474.559784]  [<ffffffffa05b5b86>] xfs_buf_iodone_work+0x46/0x50 [xfs]
> [17474.559784]  [<ffffffffa05b5c26>] xfs_buf_ioend+0x96/0x120 [xfs]
> [17474.559784]  [<ffffffffa061e939>] xfs_buf_iodone_callbacks+0x59/0x230 [xfs]
> [17474.559784]  [<ffffffffa05b5b61>] xfs_buf_iodone_work+0x21/0x50 [xfs]
> [17474.559784]  [<ffffffffa05b5c26>] xfs_buf_ioend+0x96/0x120 [xfs]
> [17474.559784]  [<ffffffffa061f7e9>] xfs_buf_item_unpin+0x289/0x2d0 [xfs]
> [17474.559784]  [<ffffffffa0617c33>] xfs_trans_committed_bulk+0x213/0x300 [xfs]
> [17474.559784]  [<ffffffffa061dde6>] xlog_cil_committed+0x36/0x130 [xfs]
> [17474.559784]  [<ffffffffa061e1e8>] xlog_cil_push+0x308/0x430 [xfs]
> [17474.559784]  [<ffffffffa061e466>] xlog_cil_force_lsn+0x146/0x1b0 [xfs]
> [17474.559784]  [<ffffffffa061c1e4>] _xfs_log_force+0x64/0x280 [xfs]
> [17474.559784]  [<ffffffffa061c454>] xfs_log_force+0x54/0x80 [xfs]
> [17474.559784]  [<ffffffffa05c65dd>] xfs_fs_sync_fs+0x2d/0x50 [xfs]
> [17474.559784]  [<ffffffff8118c00b>] __sync_filesystem+0x2b/0x50
> [17474.559784]  [<ffffffff8118c073>] sync_filesystem+0x43/0x60
> [17474.559784]  [<ffffffff81160846>] generic_shutdown_super+0x36/0xe0
> [17474.559784]  [<ffffffff8116091c>] kill_block_super+0x2c/0x80
> [17474.559784]  [<ffffffff81160e78>] deactivate_locked_super+0x38/0x90
> [17474.559784]  [<ffffffff81161951>] deactivate_super+0x61/0x70
> [17474.559784]  [<ffffffff8117c659>] mntput_no_expire+0x149/0x1b0
> [17474.559784]  [<ffffffff8117d10e>] sys_umount+0x6e/0xd0

Nothing has been shut down in XFS at this point (i.e. .put_super()
has not yet been called) so none of the shutdown changes could have
caused this problem.

Indeed, it looks like this is during a forced shutdown here in
xfs_buf_item_unpin:

        } else if (freed && remove) {
                xfs_buf_lock(bp);
                xfs_buf_ioerror(bp, EIO);
                XFS_BUF_UNDONE(bp);
                xfs_buf_stale(bp);
>>>>>>          xfs_buf_ioend(bp, 0);
        }

Now, xfs_buf_stale() does this:

	ASSERT(atomic_read(&bp->b_hold) >= 1);

Which means that in calling xfs_buf_ioend(), at least two references
to the buffer are being dropped. Working out why that is occurring
will find the root cause of this problem. 

All that I can say at this point is that I find it highly unlikely
that it is caused by the changes in this patchset.

> I got this ASSERT when I ran it on the 8/27 OSS sources:
> 
> [188646.952426] XFS: Assertion failed:
> atomic_read(&iclog->ic_refcnt) == 0, file:
>  /root/xfs/fs/xfs/xfs_log.c, line: 2590

> [188646.967020] Process kworker/2:1H (pid: 356, threadinfo ffff8808396a4000, task ffff88083a9aa1c0)
> [188646.967020] Call Trace:
> [188646.967020]  [<ffffffffa01dd2bf>] xlog_state_done_syncing+0x7f/0x110 [xfs]
> [188646.967020]  [<ffffffffa01ddbde>] xlog_iodone+0x7e/0x100 [xfs]
> [188646.967020]  [<ffffffffa0179b51>] xfs_buf_iodone_work+0x21/0x50 [xfs]
> [188646.967020]  [<ffffffff8105d6b3>] process_one_work+0x1d3/0x370
> [188646.967020]  [<ffffffff810603e3>] worker_thread+0x133/0x390
> [188646.967020]  [<ffffffff810651ce>] kthread+0x9e/0xb0
> [188646.967020]  [<ffffffff8143e504>] kernel_thread_helper+0x4/0x10

I've never seen that ASSERT fire. That implies we've got a log
buffer that is being actively modified under IO, but I cannot see
how that would happen. Was this during an unmount? What test?

/me is starting to wonder about memory errors...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
