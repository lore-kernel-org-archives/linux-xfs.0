Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54404 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729265AbeHOR27 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Aug 2018 13:28:59 -0400
Date: Wed, 15 Aug 2018 10:36:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: mount (quotacheck) triggers OOM killer
Message-ID: <20180815143631.GA24791@bfoster>
References: <20180815114152.GA519@geggus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180815114152.GA519@geggus.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sven Geggus <lists@fuchsschwanzdomain.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Aug 15, 2018 at 01:41:53PM +0200, Sven Geggus wrote:
> Hello,
> 
> my fileserver has been running with this kernel for about 1.5years now
> without problems. The filesystem should be even older.
> 
> Unfortunately today I got an nfsd crash and thus unmounted, rebooted and ran
> xfs_repair afterwards.
> 
> Unfortunately I'm now unable to mount the filesystem as quotacheck crashes
> the machine with OOM.
> 
> Is there a way to skip quotacheck? What would be the way to go in this case?
> mkfs + restore from backup?
> 
> Here is what I get. Kernel is somewhat older (vanilla 4.9.0).
> 

Commit e0d76fa447 ("xfs: prevent quotacheck from overloading inode lru")
might be what you want. It targeted stable v4.9 and was included in
v4.9.7.

Brian

> Aug 15 11:31:38 alpha-centauri kernel: [ 5869.299844] XFS (drbd0): Mounting V4 Filesystem
> Aug 15 11:31:39 alpha-centauri kernel: [ 5869.568131] XFS (drbd0): Ending clean mount
> Aug 15 11:31:39 alpha-centauri kernel: [ 5869.577553] XFS (drbd0): Quotacheck needed: Please wait.
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032121] mount invoked oom-killer: gfp_mask=0x26042d0(GFP_TEMPORARY|__GFP_NOWARN|__GFP_COMP|__GFP_NOTRACK), nodemask=0, order=0, oom_score_adj=0
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032148] mount cpuset=/ mems_allowed=0
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032165] CPU: 4 PID: 7541 Comm: mount Not tainted 4.9.0-iosbfs1+ #1
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032193] Hardware name: Supermicro X9DRi-LN4+/X9DR3-LN4+/X9DRi-LN4+/X9DR3-LN4+, BIOS 1.1 06/07/2012
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032240]  0000000000000000 ffffffff8138f9c6 ffffc90004f63938 ffffffff8197a994
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032290]  ffffffff8113d8a2 0000000000000000 0000000000000000 ffff880858995000
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032340]  ffffffff8197a994 0000000000000000 ffffc90004f63938 0000000000000001
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032391] Call Trace:
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032418]  [<ffffffff8138f9c6>] ? dump_stack+0x46/0x59
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032447]  [<ffffffff8113d8a2>] ? dump_header.isra.20+0x75/0x19f
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032478]  [<ffffffff810f10b0>] ? oom_kill_process+0x76/0x31a
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032506]  [<ffffffff810f18dc>] ? out_of_memory+0x46f/0x492
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032535]  [<ffffffff810f5038>] ? __alloc_pages_slowpath+0x7d4/0x877
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032564]  [<ffffffff810f5255>] ? __alloc_pages_nodemask+0x17a/0x206
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032594]  [<ffffffff81130210>] ? cache_grow_begin+0xa0/0x268
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032622]  [<ffffffff81130824>] ? fallback_alloc+0x142/0x1a7
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032650]  [<ffffffff81130ec3>] ? kmem_cache_alloc+0x8a/0x125
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032679]  [<ffffffff81273439>] ? kmem_zone_alloc+0x42/0x98
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032708]  [<ffffffff81260225>] ? xfs_inode_alloc+0x1c/0x12d
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032736]  [<ffffffff8126088e>] ? xfs_iget+0x40b/0x6ee
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032765]  [<ffffffff8110edcb>] ? list_lru_add+0x4b/0x7d
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032794]  [<ffffffff81286fbe>] ? xfs_qm_dqusage_adjust+0x5a/0x1ac
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032824]  [<ffffffff8126a914>] ? xfs_bulkstat+0x395/0x494
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032851]  [<ffffffff81286f64>] ? xfs_qm_quotacheck_dqadjust+0x11a/0x11a
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032881]  [<ffffffff81287a65>] ? xfs_qm_quotacheck+0xf3/0x24b
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032908]  [<ffffffff81287c4d>] ? xfs_qm_mount_quotas+0x90/0x13b
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032936]  [<ffffffff8126c162>] ? xfs_mountfs+0x5c4/0x769
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032964]  [<ffffffff812704bc>] ? xfs_fs_fill_super+0x477/0x552
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.032992]  [<ffffffff81270045>] ? xfs_fs_put_super+0x82/0x82
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.033021]  [<ffffffff8114275b>] ? mount_bdev+0x12e/0x17e
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.033048]  [<ffffffff81143274>] ? mount_fs+0x60/0x123
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.033075]  [<ffffffff811576c4>] ? vfs_kern_mount+0x60/0xd5
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.033103]  [<ffffffff81159d10>] ? do_mount+0x6d9/0x970
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.033130]  [<ffffffff81159500>] ? finish_automount+0x7b/0x8d
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.033157]  [<ffffffff811595e3>] ? copy_mount_options+0xd1/0x113
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.033185]  [<ffffffff8115a1ca>] ? SyS_mount+0x6d/0x93
> Aug 15 11:53:51 alpha-centauri kernel: [ 7202.033214]  [<ffffffff81652a20>] ? entry_SYSCALL_64_fastpath+0x13/0x94
> 
> Sven
> 
> -- 
> The main thing to note is that when you choose open source you don't
> get a Windows operating system.
>                                   (from http://www.dell.com/ubuntu)
> /me is giggls@ircnet, http://sven.gegg.us/ on the Web
