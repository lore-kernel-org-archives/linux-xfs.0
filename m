Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:47189 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753018AbdKNSIz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2017 13:08:55 -0500
Received: by mail-pf0-f196.google.com with SMTP id t69so6000919pfg.4
        for <linux-xfs@vger.kernel.org>; Tue, 14 Nov 2017 10:08:55 -0800 (PST)
Date: Tue, 14 Nov 2017 10:08:53 -0800
From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] xfs: fix forgotten rcu read unlock when skipping inode
 reclaim
Message-ID: <20171114180853.GA26659@vader.DHCP.thefacebook.com>
References: <20171114010426.GE25227@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171114010426.GE25227@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Omar Sandoval <osandov@fb.com>

On Mon, Nov 13, 2017 at 05:04:26PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit f2e9ad21 ("xfs: check for race with xfs_reclaim_inode"), we
> skip an inode if we're racing with freeing the inode via
> xfs_reclaim_inode, but we forgot to release the rcu read lock when
> dumping the inode, with the result that we exit to userspace with a lock
> held.  Don't do that; generic/320 with a 1k block size fails this
> very occasionally.
> 
> ================================================
> WARNING: lock held when returning to user space!
> 4.14.0-rc6-djwong #4 Tainted: G        W
> ------------------------------------------------
> rm/30466 is leaving the kernel with locks still held!
> 1 lock held by rm/30466:
>  #0:  (rcu_read_lock){....}, at: [<ffffffffa01364d3>] xfs_ifree_cluster.isra.17+0x2c3/0x6f0 [xfs]
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 30466 at kernel/rcu/tree_plugin.h:329 rcu_note_context_switch+0x71/0x700
> Modules linked in: deadline_iosched dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey xfs libcrc32c dax_pmem device_dax nd_pmem sch_fq_codel af_packet [last unloaded: scsi_debug]
> CPU: 1 PID: 30466 Comm: rm Tainted: G        W       4.14.0-rc6-djwong #4
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.10.2-1ubuntu1djwong0 04/01/2014
> task: ffff880037680000 task.stack: ffffc90001064000
> RIP: 0010:rcu_note_context_switch+0x71/0x700
> RSP: 0000:ffffc90001067e50 EFLAGS: 00010002
> RAX: 0000000000000001 RBX: ffff880037680000 RCX: ffff88003e73d200
> RDX: 0000000000000002 RSI: ffffffff819e53e9 RDI: ffffffff819f4375
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffff880062c900d0
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff880037680000
> R13: 0000000000000000 R14: ffffc90001067eb8 R15: ffff880037680690
> FS:  00007fa3b8ce8700(0000) GS:ffff88003ec00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f69bf77c000 CR3: 000000002450a000 CR4: 00000000000006e0
> Call Trace:
>  __schedule+0xb8/0xb10
>  schedule+0x40/0x90
>  exit_to_usermode_loop+0x6b/0xa0
>  prepare_exit_to_usermode+0x7a/0x90
>  retint_user+0x8/0x20
> RIP: 0033:0x7fa3b87fda87
> RSP: 002b:00007ffe41206568 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff02
> RAX: 0000000000000000 RBX: 00000000010e88c0 RCX: 00007fa3b87fda87
> RDX: 0000000000000000 RSI: 00000000010e89c8 RDI: 0000000000000005
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000000
> R10: 000000000000015e R11: 0000000000000246 R12: 00000000010c8060
> R13: 00007ffe41206690 R14: 0000000000000000 R15: 0000000000000000
> ---[ end trace e88f83bf0cfbd07d ]---
> 
> Fixes: f2e9ad212def50bcf4c098c6288779dd97fff0f0
> Cc: Omar Sandoval <osandov@fb.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, Darrick.

Reviewed-by: Omar Sandoval <osandov@fb.com>
