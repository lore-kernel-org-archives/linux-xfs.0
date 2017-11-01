Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38799 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752771AbdKADIm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 23:08:42 -0400
Date: Tue, 31 Oct 2017 20:08:36 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: b+tree for the incore extent list
Message-ID: <20171101030836.GH4911@magnolia>
References: <20171031142230.11755-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031142230.11755-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 31, 2017 at 04:22:12PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> this series first updates the incore extent list iteration to use
> a cursor based scheme that hides the implementation details, and then
> switch to use a b+tree to implement the in-core extent list.  This
> reduces the need for a large contiguous allocation that the current
> indirection array requires, and thus avoids stalls during workloads
> using giant extent lists, especially on systems that are long running.
> 
> The algorithms also should be better in general, but due to the fact
> the the operations on the on-disk b+tree have such a high overhead
> not much that effect is seen on the usual benchmarks.
> 
> I also have a git tree available at:
> 
>     git://git.infradead.org/users/hch/xfs.git xfs-incore-btree

FWIW I started xfstesting this but encountered numerous xfs_repair
problems with a -m crc=0 filesystem:

[ 5483.480991] XFS (pmem4): Injecting error (false) at file /raid/home/djwong/cdev/work/linux-dgc/fs/xfs/xfs_trans_ail.c, line 338, on filesystem "pmem4"
[ 5483.483600] XFS (pmem4): Injecting error (false) at file /raid/home/djwong/cdev/work/linux-dgc/fs/xfs/xfs_trans_ail.c, line 338, on filesystem "pmem4"
[ 5485.671575] XFS (pmem4): Intentionally corrupted log record at LSN 0x1a000016f0. Shutdown imminent.
[ 5485.673555] XFS (pmem4): metadata I/O error: block 0x7e728 ("xlog_iodone") error 0 numblks 64
[ 5485.675230] XFS (pmem4): xfs_do_force_shutdown(0x2) called from line 1261 of file /raid/home/djwong/cdev/work/linux-dgc/fs/xfs/xfs_log.c.  Return address = 0xffffffffa0157edb
[ 5485.691317] XFS (pmem4): Log I/O Error Detected.  Shutting down filesystem
[ 5485.691820] XFS (pmem4): xfs_do_force_shutdown(0x1) called from line 236 of file /raid/home/djwong/cdev/work/linux-dgc/fs/xfs/libxfs/xfs_defer.c.  Return address = 0xffffffffa00ea49e
[ 5485.691916] XFS (pmem4): xfs_inactive_ifree: xfs_defer_finish returned error -5
[ 5485.692001] XFS (pmem4): xfs_inactive_ifree: xfs_trans_commit returned error -5
[ 5485.698093] XFS (pmem4): Please umount the filesystem and rectify the problem(s)
[ 5486.628228] XFS (pmem4): Unmounting Filesystem
[ 5589.882261] INFO: task umount:28106 blocked for more than 60 seconds.
[ 5589.883320]       Tainted: G        W       4.14.0-rc6-dgc #2
[ 5589.884473] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 5589.886103] umount          D    0 28106  27867 0x00000000
[ 5589.887491] Call Trace:
[ 5589.888158]  ? __schedule+0x3fd/0xb10
[ 5589.889002]  ? __xfs_iflock+0x9f/0x100 [xfs]
[ 5589.889645]  schedule+0x40/0x90
[ 5589.890013]  io_schedule+0x16/0x40
[ 5589.890537]  __xfs_iflock+0xf8/0x100 [xfs]
[ 5589.891124]  ? bit_waitqueue+0x40/0x40
[ 5589.891565]  xfs_reclaim_inode+0x147/0x410 [xfs]
[ 5589.892117]  xfs_reclaim_inodes_ag+0x247/0x400 [xfs]
[ 5589.892683]  xfs_reclaim_inodes+0x1b/0x20 [xfs]
[ 5589.893223]  xfs_unmountfs+0xc0/0x2c0 [xfs]
[ 5589.893734]  xfs_fs_put_super+0x2c/0x90 [xfs]
[ 5589.894299]  generic_shutdown_super+0x64/0x110
[ 5589.895218]  kill_block_super+0x21/0x50
[ 5589.895867]  deactivate_locked_super+0x34/0x60
[ 5589.896377]  cleanup_mnt+0x3b/0x70
[ 5589.896774]  task_work_run+0x79/0xb0
[ 5589.897193]  exit_to_usermode_loop+0x93/0xa0
[ 5589.897703]  syscall_return_slowpath+0xd7/0x100
[ 5589.898312]  entry_SYSCALL_64_fastpath+0xbc/0xbe
[ 5589.899263] RIP: 0033:0x7f7e8b933447

And for whatever reason on the -m rmapbt=1,reflink=1 -i sparse
filesystem with 1k block size xfs_repair blew up all over the place.

--D

> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-incore-btree
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
