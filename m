Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52280 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbfBLADv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 19:03:51 -0500
Date: Mon, 11 Feb 2019 16:03:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: small fixes and optimizations for delalloc and reflink
Message-ID: <20190212000337.GA23989@magnolia>
References: <20190211125427.16577-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211125427.16577-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>

On Mon, Feb 11, 2019 at 01:54:17PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series contains my changes to fix up the delalloc and reflink
> code to prepare for the always COW mode.  This sits on top of
> the 'xfs: properly invalidate cached writeback mapping' series from
> Brian.
> 
> To make reviewing easier I also have a git tree available here:
> 
>     git://git.infradead.org/users/hch/xfs.git xfs-mapping-validation.4
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-mapping-validation.4

I pulled this series in and saw a bunch of new regressions in
generic/127 generic/269 generic/476 generic/521 generic/522 xfs/442 with
quota, rmap, and reflink enabled.  The regressions were all the
XFS_WANT_CORRUPTED_GOTO near the top of xfs_rmap_unmap_shared.

--D

The generic/127 crash produced the attached stacktrace; the other tests crashed
with similar stack traces.

[ 1695.579535] XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_rmap.c, line: 1776
[ 1695.584880] WARNING: CPU: 3 PID: 5240 at fs/xfs/xfs_message.c:104 assfail+0x27/0x2a [xfs]
[ 1695.586419] Modules linked in: mq_deadline dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey xfs libcrc32c xt_REDIRECT xt_set ip_set_hash_net ip_set nfnetlink iptable_nat nf_nat_ipv4 nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 bfq dax_pmem device_dax nd_pmem sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
[ 1695.591749] CPU: 3 PID: 5240 Comm: kworker/3:11 Not tainted 5.0.0-rc5-djw #rc5
[ 1695.593119] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1 04/01/2014
[ 1695.594774] Workqueue: xfs-conv/sdc xfs_end_io [xfs]
[ 1695.595805] RIP: 0010:assfail+0x27/0x2a [xfs]
[ 1695.596667] Code: 0f 0b c3 66 66 66 66 90 48 89 f1 41 89 d0 48 c7 c6 40 e2 39 a0 48 89 fa 31 ff e8 6d f9 ff ff 80 3d 4c 84 0a 00 00 74 02 0f 0b <0f> 0b c3 48 8b b3 a8 02 00 00 48 c7 c7 b8 e6 39 a0 c6 05 b4 7f 0a
[ 1695.600041] RSP: 0018:ffffc900024b7b18 EFLAGS: 00010246
[ 1695.601045] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[ 1695.602387] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa039033f
[ 1695.603725] RBP: ffff888077d5f1c0 R08: 0000000000000000 R09: 0000000000000000
[ 1695.605060] R10: 000000000000000a R11: f000000000000000 R12: ffffc900024b7bd8
[ 1695.606391] R13: 0000000000000000 R14: 0000000000002f9e R15: ffff8880277d3000
[ 1695.607718] FS:  0000000000000000(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
[ 1695.609224] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1695.610308] CR2: 000055db35944008 CR3: 000000003c7fd002 CR4: 00000000000606a0
[ 1695.611730] Call Trace:
[ 1695.612334]  xfs_rmap_unmap_shared+0x4e8/0x750 [xfs]
[ 1695.613362]  xfs_rmap_finish_one+0x2c3/0x3e0 [xfs]
[ 1695.614392]  xfs_trans_log_finish_rmap_update+0x2f/0x40 [xfs]
[ 1695.615620]  xfs_rmap_update_finish_item+0x2c/0x40 [xfs]
[ 1695.616742]  xfs_defer_finish_noroll+0x1c6/0x770 [xfs]
[ 1695.617813]  ? xfs_reflink_end_cow_extent+0x281/0x3a0 [xfs]
[ 1695.619058]  __xfs_trans_commit+0x16f/0x420 [xfs]
[ 1695.620121]  xfs_reflink_end_cow_extent+0x281/0x3a0 [xfs]
[ 1695.621330]  xfs_reflink_end_cow+0x7f/0x280 [xfs]
[ 1695.622420]  xfs_end_io+0xd0/0x120 [xfs]
[ 1695.623296]  process_one_work+0x258/0x610
[ 1695.624190]  worker_thread+0x3d/0x390
[ 1695.624980]  ? wq_calc_node_cpumask+0x80/0x80
[ 1695.625896]  kthread+0x121/0x140
[ 1695.626650]  ? kthread_create_on_node+0x60/0x60
[ 1695.627625]  ret_from_fork+0x3a/0x50
[ 1695.628427] irq event stamp: 651462
[ 1695.629229] hardirqs last  enabled at (651461): [<ffffffff810cb74d>] console_unlock+0x43d/0x5e0
[ 1695.631054] hardirqs last disabled at (651462): [<ffffffff81001ba0>] trace_hardirqs_off_thunk+0x1a/0x1c
[ 1695.632988] softirqs last  enabled at (651458): [<ffffffff81a003a8>] __do_softirq+0x3a8/0x4bd
[ 1695.634637] softirqs last disabled at (651449): [<ffffffff810616bc>] irq_exit+0xbc/0xe0
[ 1695.636165] ---[ end trace bb01f9243a156636 ]---
