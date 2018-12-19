Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:38226 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbeLSAoS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 19:44:18 -0500
Date: Tue, 18 Dec 2018 16:44:11 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: COW improvements and always_cow support V3
Message-ID: <20181219004411.GW27208@magnolia>
References: <20181203222503.30649-1-hch@lst.de>
 <20181206010550.GN24487@magnolia>
 <20181206200930.GA31797@lst.de>
 <20181217175922.GI24487@magnolia>
 <20181218180551.GA15138@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181218180551.GA15138@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Tue, Dec 18, 2018 at 07:05:51PM +0100, Christoph Hellwig wrote:
> On Mon, Dec 17, 2018 at 09:59:22AM -0800, Darrick J. Wong wrote:
> > > This and a few other fsx tests assume you can always fallocate
> > > on XFS.  I sent a series for this:
> > > 
> > > https://www.spinics.net/lists/linux-xfs/msg23433.html
> > > 
> > > But I need to rework some of the patches a little more based on the
> > > review feedback.
> > 
> > "the patches"... as in the fstests patches, or the always_cow series?
> 
> The fstests patches.

FWIW one of my test vms seems to have hung in generic/323 with the xfs
for-next and your patches applied:

MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, /dev/sdf'
MOUNT_OPTIONS='/dev/sdf /opt'

[ 7496.941223] run fstests generic/323 at 2018-12-18 15:11:28
[ 7497.423929] XFS (sda): Mounting V5 Filesystem
[ 7497.440459] XFS (sda): Ending clean mount
[ 7679.154591] INFO: task aio-last-ref-he:13058 blocked for more than 60 seconds.
[ 7679.157665]       Not tainted 4.20.0-rc6-djw #rc6
[ 7679.159654] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 7679.161479] aio-last-ref-he D13376 13058  12660 0x00000004
[ 7679.162846] Call Trace:
[ 7679.214222]  ? __schedule+0x420/0xb40
[ 7679.215268]  schedule+0x40/0x90
[ 7679.216809]  io_schedule+0x16/0x40
[ 7679.218164]  iomap_dio_rw+0x361/0x410
[ 7679.219673]  ? xfs_file_dio_aio_read+0x81/0x180 [xfs]
[ 7679.220986]  xfs_file_dio_aio_read+0x81/0x180 [xfs]
[ 7679.222252]  xfs_file_read_iter+0xba/0xd0 [xfs]
[ 7679.225448]  aio_read+0x16f/0x1d0
[ 7679.244440]  ? kvm_clock_read+0x14/0x30
[ 7679.245592]  ? kvm_sched_clock_read+0x5/0x10
[ 7679.247010]  ? io_submit_one+0x711/0x9b0
[ 7679.248074]  io_submit_one+0x711/0x9b0
[ 7679.249074]  ? __x64_sys_io_submit+0xa7/0x260
[ 7679.250294]  __x64_sys_io_submit+0xa7/0x260
[ 7679.258402]  ? do_syscall_64+0x50/0x170
[ 7679.259631]  ? __ia32_compat_sys_io_submit+0x250/0x250
[ 7679.260840]  do_syscall_64+0x50/0x170
[ 7679.261825]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 7679.263510] RIP: 0033:0x7fdcfeb0c697
[ 7679.265177] Code: Bad RIP value.
[ 7679.266743] RSP: 002b:00007fdc58bd0888 EFLAGS: 00000206 ORIG_RAX: 00000000000000d1
[ 7679.270014] RAX: ffffffffffffffda RBX: 00007fdc58bd0de0 RCX: 00007fdcfeb0c697
[ 7679.273167] RDX: 00007fdc58bd0920 RSI: 0000000000000001 RDI: 00007fdcfef2e000
[ 7679.276350] RBP: 000000000000000c R08: 0000000000000000 R09: 0000000000000000
[ 7679.279523] R10: 00007fdc58bd0920 R11: 0000000000000206 R12: 000000000000000a
[ 7679.282657] R13: 00007fdc58bd0f20 R14: 00000000000b0000 R15: 0000000000000001
[ 7679.289113] 
               Showing all locks held in the system:
[ 7679.291907] 1 lock held by khungtaskd/34:
[ 7679.293705]  #0: 00000000e7a0f77e (rcu_read_lock){....}, at: debug_show_all_locks+0xe/0x190
[ 7679.297938] 1 lock held by in:imklog/920:
[ 7679.299796] 2 locks held by bash/1021:
[ 7679.301357]  #0: 00000000e04cb661 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x24/0x50
[ 7679.305540]  #1: 00000000a0b743c3 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0xdb/0x950
[ 7679.309347] 1 lock held by aio-last-ref-he/13058:
[ 7679.311474]  #0: 00000000db76f3cc (&inode->i_rwsem){++++}, at: xfs_ilock+0x279/0x2e0 [xfs]

[ 7679.315735] =============================================

--D
