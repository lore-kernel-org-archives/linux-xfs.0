Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:19465 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751074AbcKAV6o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2016 17:58:44 -0400
Date: Wed, 2 Nov 2016 08:58:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Quota-enabled XFS hangs during mount
Message-ID: <20161101215803.GA14023@dastard>
References: <e26e98c9-d183-acde-0ebd-8e285d0ae03c@zoner.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e26e98c9-d183-acde-0ebd-8e285d0ae03c@zoner.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Martin Svec <martin.svec@zoner.cz>
Cc: linux-xfs@vger.kernel.org

On Tue, Nov 01, 2016 at 05:45:04PM +0100, Martin Svec wrote:
> Hello,
> 
> with user and group quotas enabled, XFS freezes during mount and the following error is reported to
> dmesg (Debian 8 kernel 3.16.0-4):
> 
> [  142.012022] XFS (sdd1): Mounting V4 Filesystem
> [  142.044267] XFS (sdd1): Ending clean mount
> [  142.045428] XFS (sdd1): Quotacheck needed: Please wait.
> [  360.267113] INFO: task mount:699 blocked for more than 120 seconds.
> [  360.267148]       Not tainted 3.16.0-4-amd64 #1
> [  360.267165] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  360.267194] mount           D ffff880079a9eff8     0   699    669 0x00000000
> [  360.267197]  ffff880079a9eba0 0000000000000086 0000000000012f40 ffff880078a9ffd8
> [  360.267199]  0000000000012f40 ffff880079a9eba0 ffff88007ae7de90 ffff880078a9fb08
> [  360.267201]  ffff88007ae7de88 ffff880079a9eba0 ffff880078a9fbb8 0000000000000000
> [  360.267202] Call Trace:
> [  360.267210]  [<ffffffff81514269>] ? schedule_timeout+0x259/0x2d0
> [  360.267268]  [<ffffffffa0196e15>] ? xfs_iunlock+0xc5/0x140 [xfs]
> [  360.267271]  [<ffffffff81515758>] ? wait_for_completion+0xa8/0x110
> [  360.267274]  [<ffffffff810982e0>] ? wake_up_state+0x10/0x10
> [  360.267283]  [<ffffffffa01b5494>] ? xfs_qm_flush_one+0x64/0xa0 [xfs]
> [  360.267293]  [<ffffffffa01b5430>] ? xfs_qm_shrink_scan+0x100/0x100 [xfs]
> [  360.267302]  [<ffffffffa01b59d0>] ? xfs_qm_dquot_walk.isra.9+0xd0/0x150 [xfs]
> [  360.267312]  [<ffffffffa01b7829>] ? xfs_qm_quotacheck+0x269/0x2e0 [xfs]
> [  360.267321]  [<ffffffffa0162150>] ? xfs_parseargs+0xb80/0xb80 [xfs]
> [  360.267331]  [<ffffffffa01b7a01>] ? xfs_qm_mount_quotas+0xe1/0x190 [xfs]
> [  360.267340]  [<ffffffffa015f74d>] ? xfs_mountfs+0x69d/0x710 [xfs]
> [  360.267349]  [<ffffffffa01623e3>] ? xfs_fs_fill_super+0x293/0x310 [xfs]

This trace is quite garbled - obviously the kernel was not compiles
with frame pointers enabled (why do distros still do that?) which
makes it hard to know what is going on here. It looks like it's
waiting for IO completion of dquot writeback after recalculation,
but there's evidence of memory reclaim running in there...

> I also tried vanilla kernel 4.6.7 on the same server and the callstack is slightly different:
> 
> [   75.814590] XFS (sdd1): Mounting V4 Filesystem
> [   75.850660] XFS (sdd1): Ending clean mount
> [   75.852091] XFS (sdd1): Quotacheck needed: Please wait.
> [  240.243744] INFO: task mount:773 blocked for more than 120 seconds.
> [  240.243808]       Tainted: G            E   4.6.7-znr1+ #16
> [  240.243856] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  240.243908] mount           D ffff88007c656000     0   773    741 0x00000000
> [  240.243916]  ffff880079b70e00 ffff88007be28dc0 ffff88007a14c000 ffff88007a14ba90
> [  240.243919]  ffff880079d88e80 ffff880079b70e00 ffff88007a14bca0 ffff88007a14bb48
> [  240.243920]  ffffffff815c4ca1 ffff880079d88e88 ffffffff815c7cbf 7fffffffffffffff
> [  240.243922] Call Trace:
> [  240.243929]  [<ffffffff815c4ca1>] ? schedule+0x31/0x80
> [  240.243932]  [<ffffffff815c7cbf>] ? schedule_timeout+0x22f/0x2c0
> [  240.243978]  [<ffffffffc017415f>] ? xfs_bmapi_read+0xef/0x2d0 [xfs]
> [  240.243981]  [<ffffffff815c56da>] ? wait_for_completion+0xfa/0x130
> [  240.243987]  [<ffffffff810a4920>] ? wake_up_q+0x60/0x60
> [  240.244009]  [<ffffffffc01d4ecd>] ? xfs_qm_flush_one+0x7d/0xc0 [xfs]
> [  240.244030]  [<ffffffffc01d4e50>] ? xfs_qm_dqattach_one+0x120/0x120 [xfs]
> [  240.244051]  [<ffffffffc01d52a0>] ? xfs_qm_dquot_walk.isra.10+0xd0/0x150 [xfs]
> [  240.244072]  [<ffffffffc01d72ec>] ? xfs_qm_quotacheck+0x26c/0x320 [xfs]
> [  240.244093]  [<ffffffffc01d746e>] ? xfs_qm_mount_quotas+0xce/0x170 [xfs]
> [  240.244113]  [<ffffffffc01b9933>] ? xfs_mountfs+0x803/0x870 [xfs]

Ugh. Please turn on CONFIG_FRAME_POINTER=y. However, it still looks
like it's waiting on IO completion.

> [  240.244132]  [<ffffffffc01a8220>] ? xfs_filestream_get_parent+0x70/0x70 [xfs]

Filestreams?

> [  240.244152]  [<ffffffffc01bc043>] ? xfs_fs_fill_super+0x3a3/0x4b0 [xfs]
> [  240.244173]  [<ffffffffc01bbca0>] ? xfs_test_remount_options.isra.11+0x60/0x60 [xfs]
> [  240.244176]  [<ffffffff811f52d5>] ? mount_bdev+0x175/0x1a0
> [  240.244177]  [<ffffffff811f5b96>] ? mount_fs+0x36/0x170
> [  240.244180]  [<ffffffff812114c4>] ? vfs_kern_mount+0x64/0x100
> [  240.244182]  [<ffffffff81213a04>] ? do_mount+0x244/0xd50
> [  240.244184]  [<ffffffff812147f4>] ? SyS_mount+0x84/0xc0
> [  240.244186]  [<ffffffff815c89b6>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8
> 
> Filesystem parameters are as follows:
> 
> orthosie:~# xfs_info /www
> meta-data=/dev/sdd1              isize=256    agcount=103, agsize=655232 blks

urk. 103 AGs of 2.5GB each? That's going to cause all sorts of seek
issues with IO. How many times has this filesystem
been grown since it was first created as a 10GB filesystem? What's
the underlying storage?

>          =                       sectsz=512   attr=2, projid32bit=0
>          =                       crc=0        finobt=0
> data     =                       bsize=4096   blocks=66846464, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=0
> log      =internal               bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Disk usage:
> 
> orthosie:~# df
> Filesystem     1K-blocks      Used Available Use% Mounted on
> /dev/sdd1      267375616 225270324  42105292  85% /www

How many inodes? How much RAM?

> The only workaround is to mount the filesystem without quotas, xfs_repair reports no errors. 

xfs_repair ignores quotas - it simply removes the flags that tell
the kernel to rebuild the quotas on the next mount.

> Any ideas what's wrong? How can I help to fix the problem? Note
> that the server is a non-production clone of a virtual machine
> where the problem originally occurred. So I'm free to any tests
> and experiments.

What else is stuck when the hung task trigger fires (sysrq-w
output)? Is there still IO going on when the hung task warning comes
up, or it the system completely idle at this point?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
