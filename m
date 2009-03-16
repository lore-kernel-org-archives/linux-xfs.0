Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G7rx3M076642 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:54:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B73C519BE01
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 00:53:38 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lexPL4IBO4bCbjLf for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 00:53:38 -0700 (PDT)
Date: Mon, 16 Mar 2009 03:53:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] [XFS] introduce a AG inode tree walker
Message-ID: <20090316075338.GA19858@infradead.org>
References: <1237117603-26071-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237117603-26071-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Mar 15, 2009 at 10:46:37PM +1100, Dave Chinner wrote:
> This series splits up the sync and reclaim code into three
> separate actions. The first is the tree walker, the second is
> the inode validation and the third is the operation to execute
> on the inode.
> 
> This allows us to somewhat abstract the radix tree away from the
> act of walking the cached inodes and puts in place mechanisms that
> can be extended for bulk inode cache lookups.
> 
> This also splits the inode writeback into separate data and metadata
> sync operations and optimises them a little......

Just did a quick XFSQA run with your whole patch series applied and
I get this oops in 001:

[   37.023076] Filesystem "vdb": Disabling barriers, not supported with external log device
[   37.055812] XFS mounting filesystem vdb
001 9s ...
[   46.688828] BUG: unable to handle kernel NULL pointer dereference at 00000332
[   46.711217] IP: [<c0477be5>] xfs_sync_inode_data+0x15/0xd0
[   46.733131] *pde = 00000000 
[   46.744335] Oops: 0000 [#1] SMP 
[   46.748325] last sysfs file: /sys/class/net/lo/operstate
[   46.748325] Modules linked in:
[   46.748325] 
[   46.748325] Pid: 5229, comm: umount Not tainted (2.6.29-rc7-xfs #207) 
[   46.748325] EIP: 0060:[<c0477be5>] EFLAGS: 00010246 CPU: 0
[   46.748325] EIP is at xfs_sync_inode_data+0x15/0xd0
[   46.748325] EAX: 00000002 EBX: 00000002 ECX: f2784530 EDX: 00000000
[   46.748325] ESI: c04777c0 EDI: 0000000a EBP: f2799df8 ESP: f2799dd8
[   46.748325]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   46.748325] Process umount (pid: 5229, ti=f2798000 task=f2784530 task.ti=f2798000)
[   46.748325] Stack:
[   46.748325]  00000001 f2799e04 c04777c0 f57b168c f6fc99d0 f57b1638 c04777c0 f5654230
[   46.748325]  f2799e20 c0477de3 f2799e10 ffffffff 00000000 00000000 00000084 00000000
[   46.748325]  f5654230 00000000 f2799e48 c0477eae c0477bd0 0000000a ffffffff c0477bd0
[   46.748325] Call Trace:
[   46.748325]  [<c04777c0>] ? xfs_sync_inode_valid+0x0/0xa0
[   46.748325]  [<c04777c0>] ? xfs_sync_inode_valid+0x0/0xa0
[   46.748325]  [<c0477de3>] ? xfs_inode_ag_walk+0x63/0xd0
[   46.748325]  [<c0477eae>] ? xfs_inode_ag_iterator+0x5e/0xa0
[   46.748325]  [<c0477bd0>] ? xfs_sync_inode_data+0x0/0xd0
[   46.748325]  [<c0477bd0>] ? xfs_sync_inode_data+0x0/0xd0
[   46.748325]  [<c04777c0>] ? xfs_sync_inode_valid+0x0/0xa0
[   46.748325]  [<c047803c>] ? xfs_sync_inodes+0x7c/0xc0
[   46.748325]  [<c04781e1>] ? xfs_quiesce_data+0x11/0x70
[   46.748325]  [<c04754cf>] ? xfs_fs_sync_super+0x3f/0xe0
[   46.748325]  [<c04003e0>] ? xfs_fs_quota_sync+0x0/0x40
[   46.748325]  [<c0205bd5>] ? quota_sync_sb+0x35/0xf0
[   46.748325]  [<c04003e0>] ? xfs_fs_quota_sync+0x0/0x40
[   46.748325]  [<c0205cb3>] ? sync_dquots+0x23/0x140
[   46.748325]  [<c01c7b19>] ? __fsync_super+0x19/0x70
[   46.748325]  [<c01c7b7b>] ? fsync_super+0xb/0x20
[   46.748325]  [<c01c7df2>] ? generic_shutdown_super+0x22/0xf0
[   46.748325]  [<c07be830>] ? down_write+0x80/0x90
[   46.748325]  [<c01c7ee5>] ? kill_block_super+0x25/0x40
[   46.748325]  [<c01c81ba>] ? deactivate_super+0x7a/0x90
[   46.748325]  [<c01dbf42>] ? mntput_no_expire+0xe2/0x110
[   46.748325]  [<c01dc21f>] ? sys_umount+0x4f/0x310
[   46.748325]  [<c01dc4f9>] ? sys_oldumount+0x19/0x20
[   46.748325]  [<c0120c7e>] ? syscall_call+0x7/0xb
[   46.748325]  [<c0120000>] ? sys_sigreturn+0x20/0xe0
[   46.748325] Code: ff 84 c0 74 ed ba 06 00 00 00 89 d8 e8 d5 10 fd ff 89 c6 eb b3 90 55 89 e5 83 ec 20 89 5d f4 89 c3 89 7d fc 89 d7 31 d2 89 75 f8 <8b> 80 30 03 00 00 e8 40 75 d2 ff 85 c0 74 6e f7 c7 20 00 00 00 
[   46.748325] EIP: [<c0477be5>] xfs_sync_inode_data+0x15/0xd0 SS:ESP 0068:f2799dd8
[   47.513225] ---[ end trace 4957da56f1d7015c ]---


> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
