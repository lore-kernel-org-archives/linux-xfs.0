Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C531C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 23:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242118AbiETXFZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 19:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240765AbiETXFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 19:05:25 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16DC1190D21
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 16:05:23 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CF1A510E6E46;
        Sat, 21 May 2022 09:05:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nsBgL-00EQPk-Rr; Sat, 21 May 2022 09:05:17 +1000
Date:   Sat, 21 May 2022 09:05:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [Bug 216007] New: XFS hangs in iowait when extracting large
 number of files
Message-ID: <20220520230517.GL1098723@dread.disaster.area>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62881eb1
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=jW9XMcD_w1WAFi1Y:21 a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8
        a=7mOBRU54AAAA:8 a=7-415B0cAAAA:8 a=iIXpL5o01sIEst5Xff0A:9
        a=CjuIK1q_8ugA:10 a=zBcMGXd3NVIA:10 a=4XdoLCUCO_b63ij2jC9c:22
        a=AjGcO6oz07-iQ99wixmX:22 a=wa9RWnbW_A1YIeRBVszw:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 20, 2022 at 11:56:06AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=216007
> 
>             Bug ID: 216007
>            Summary: XFS hangs in iowait when extracting large number of
>                     files
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.15.32
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: bugzkernelorg8392@araxon.sk
>         Regression: No
> 
> Created attachment 301008
>   --> https://bugzilla.kernel.org/attachment.cgi?id=301008&action=edit
> output from dmesg after echo w > /proc/sysrq-trigger
> 
> Overview:
> 
> When I try to extract an uncompressed tar archive (2.6 milion files, 760.3 GiB
> in size) on newly created (empty) XFS file system, after first low tens of
> gigabytes extracted the process hangs in iowait indefinitely. One CPU core is
> 100% occupied with iowait, the other CPU core is idle (on 2-core Intel Celeron
> G1610T).
> 
> I have kernel compiled with my .config file. When I try this with a more
> "standard" kernel, the problem is not reproducible.
> 
> Steps to Reproduce:
> 
> 1) compile the kernel with the attached .config
> 
> 2) reboot with this kernel
> 
> 3) create a new XFS filesystem on a spare drive (just mkfs.xfs -f <dev>)
> 
> 4) mount this new file system
> 
> 5) try to extract large amount of data there
> 
> Actual results:
> 
> After 20-40 GiB written, the process hangs in iowait indefinitely, never
> finishing the archive extraction.

[  805.233836] task:tar             state:D stack:    0 pid: 2492 ppid:  2491 flags:0x00004000
[  805.233840] Call Trace:
[  805.233841]  <TASK>
[  805.233842]  __schedule+0x1c9/0x510
[  805.233846]  ? lock_timer_base+0x5c/0x80
[  805.233850]  schedule+0x3f/0xa0
[  805.233853]  schedule_timeout+0x7c/0xf0
[  805.233858]  ? init_timer_key+0x30/0x30
[  805.233862]  io_schedule_timeout+0x47/0x70
[  805.233866]  congestion_wait+0x79/0xd0
[  805.233872]  ? wait_woken+0x60/0x60
[  805.233876]  xfs_buf_alloc_pages+0xd0/0x1b0
[  805.233881]  xfs_buf_get_map+0x259/0x300
[  805.233886]  ? xfs_buf_item_init+0x150/0x160
[  805.233892]  xfs_trans_get_buf_map+0xa9/0x120
[  805.233897]  xfs_ialloc_inode_init+0x129/0x2d0
[  805.233901]  ? xfs_ialloc_ag_alloc+0x1df/0x630
[  805.233904]  xfs_ialloc_ag_alloc+0x1df/0x630
[  805.233908]  xfs_dialloc+0x1b4/0x720
[  805.233912]  xfs_create+0x1d7/0x450
[  805.233917]  xfs_generic_create+0x114/0x2d0
[  805.233922]  path_openat+0x510/0xe10
[  805.233925]  do_filp_open+0xad/0x150
[  805.233929]  ? xfs_blockgc_clear_iflag+0x93/0xb0
[  805.233932]  ? xfs_iunlock+0x52/0x90
[  805.233937]  do_sys_openat2+0x91/0x150
[  805.233942]  __x64_sys_openat+0x4e/0x90
[  805.233946]  do_syscall_64+0x43/0x90
[  805.233952]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  805.233959] RIP: 0033:0x7f763ccc9572
[  805.233962] RSP: 002b:00007ffef1391530 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
[  805.233966] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f763ccc9572
[  805.233969] RDX: 00000000000809c1 RSI: 000055b1d5b19270 RDI: 0000000000000004
[  805.233971] RBP: 0000000000000180 R08: 000000000000c0c0 R09: 000055b1d5b145f0
[  805.233973] R10: 0000000000000180 R11: 0000000000000246 R12: 0000000000000000
[  805.233974] R13: 00000000000809c1 R14: 000055b1d5b19270 R15: 000055b1d59d2248
[  805.233977]  </TASK>

It's waiting on memory allocation, which is probably waiting on IO
completion somewhere to clean dirty pages. This suggests there's a
problem with the storage hardware, the storage stack below XFS or
there's an issue with memory cleaning/reclaim stalling and not
making progress.

> Expected Results:
> 
> Archive extraction continues smoothly until done.
> 
> Build Date & Hardware:
> 
> 2022-05-01 on HP ProLiant MicroServer Gen8, 4GB ECC RAM
> 
> Additional Information:
> 
> No other filesystem tested with the same archive on the same hardware before or
> after this (ext2, ext3, ext4, reiserfs3, jfs, nilfs2, f2fs, btrfs, zfs) has
> shown this behavior. When I downgraded the kernel to 5.10.109, the XFS started
> working again. Kernel versions higher than 5.15 seem to be affected, I tried
> 5.17.1, 5.17.6 and 5.18.0-rc7, they all hang up after a few minutes.

Doesn't actually look like an XFS problem from the evidence
supplied, though.

What sort of storage subsystem does this machine have? If it's a
spinning disk then you've probably just filled memory 

> More could be found here: https://forums.gentoo.org/viewtopic-p-8709116.html

Oh, wait:

"I compiled a more mainstream version of
sys-kernel/gentoo-sources-5.15.32-r1 (removed my .config file and
let genkernel to fill it with default options) and lo and behold, in
this kernel I could not make it go stuck anymore.
[....]
However, after I altered my old kernel config to contain these
values and rebooting, I'm still triggering the bug. It may not be a
XFS issue after all."

From the evidence presented, I'd agree that this doesn't look an
XFS problem, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
