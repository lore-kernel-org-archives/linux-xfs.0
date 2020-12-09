Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5204BC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 21:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1548822CB1
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 21:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgLIVEJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Dec 2020 16:04:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:60742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728461AbgLIVEF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Dec 2020 16:04:05 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-xfs@vger.kernel.org
Subject: [Bug 210577] [xfstests generic/616] kernel BUG at
 lib/list_debug.c:28!
Date:   Wed, 09 Dec 2020 21:03:23 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-210577-201763-KD5Ku8y9fK@https.bugzilla.kernel.org/>
In-Reply-To: <bug-210577-201763@https.bugzilla.kernel.org/>
References: <bug-210577-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210577

--- Comment #1 from Dave Chinner (david@fromorbit.com) ---
On Wed, Dec 09, 2020 at 12:14:53PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=210577
> 
>             Bug ID: 210577
>            Summary: [xfstests generic/616] kernel BUG at
>                     lib/list_debug.c:28!
>            Product: File System
>            Version: 2.5
>     Kernel Version: xfs-linux xfs-5.10-fixes-7
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: zlang@redhat.com
>         Regression: No
> 
> xfstests generic/616 always hit a kernel panic on XFS:
> [46457.571135] run fstests generic/616 at 2020-12-08 16:01:49 
> [46484.047411] restraintd[962]: *** Current Time: Tue Dec 08 16:02:15 2020 
> Localwatchdog at: Thu Dec 10 03:12:15 2020 
> [46512.856503] list_add corruption. prev->next should be next
> (fffffe8071968010), but was fffffc73c4b67ee0. (prev=fffffc73c4b67ee0). 
> [46512.860542] ------------[ cut here ]------------ 
> [46512.861685] kernel BUG at lib/list_debug.c:28! 
> [46512.863206] Internal error: Oops - BUG: 0 [#1] SMP 
> [46512.864495] Modules linked in: dm_log_writes dm_thin_pool
> dm_persistent_data
> dm_bio_prison sg dm_snapshot dm_bufio ext4 mbcache jbd2 loop dm_flakey dm_mod
> rfkill sunrpc crct10dif_ce ghash_ce sha2_ce sha256_arm64 sha1_ce vfat fat
> ip_tables xfs libcrc32c virtio_net virtio_blk net_failover virtio_console
> failover virtio_mmio [last unloaded: scsi_debug] 
> [46512.872295] CPU: 3 PID: 1861929 Comm: fsx Tainted: G        W        
> 5.10.0-rc1 #1 
> [46512.874214] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015 
> [46512.875923] pstate: 10400085 (nzcV daIf +PAN -UAO -TCO BTYPE=--) 
> [46512.877600] pc : __list_add_valid+0xac/0x118 
> [46512.878679] lr : __list_add_valid+0xac/0x118 
> [46512.879752] sp : fffffc7429007140 
> [46512.880648] x29: fffffc7429007140 x28: dffffe8000000000  
> [46512.881987] x27: fffffe8071968018 x26: 1fffffd00e32d003  
> [46512.883358] x25: fffffe8071967fd0 x24: 0000000000000000  
> [46512.884707] x23: fffffc73c4b67ee0 x22: fffffc73c4b67ee0  
> [46512.886046] x21: fffffc73c4b67eb8 x20: fffffc73c4b67ee0  
> [46512.887493] x19: fffffe8071968010 x18: 0000000000000000  
> [46512.888888] x17: 0000000000000000 x16: 0000000000000007  
> [46512.890256] x15: 1fffffd00e662581 x14: 0000000000000002  
> [46512.891665] x13: fffffe0e89d51569 x12: 1fffff8e89d51568  
> [46512.893066] x11: 1fffff8e89d51568 x10: fffffe0e89d51568  
> [46512.894477] x9 : fffffe806e735b20 x8 : fffffc744ea8ab47  
> [46512.895844] x7 : 0000000000000001 x6 : fffffe0e89d51569  
> [46512.897182] x5 : fffffe0e89d51569 x4 : fffffe0e89d51569  
> [46512.898565] x3 : 1fffff8e8509e0c2 x2 : d1d35b50805f9d00  
> [46512.899921] x1 : 0000000000000000 x0 : 0000000000000075  
> [46512.901307] Call trace: 
> [46512.901938]  __list_add_valid+0xac/0x118 
> [46512.902965]  __wait_on_page_locked_async+0xdc/0x3d0 
> [46512.904222]  generic_file_buffered_read+0x45c/0x11e8 
> [46512.905500]  generic_file_read_iter+0x268/0x3a0 
> [46512.906943]  xfs_file_buffered_aio_read+0x170/0x688 [xfs] 
> [46512.908457]  xfs_file_read_iter+0x2a8/0x6a0 [xfs] 
> [46512.909653]  io_iter_do_read+0x74/0x108 
> [46512.910668]  io_read+0x678/0x938 
> [46512.911450]  io_issue_sqe+0x12b8/0x2800 
> [46512.912363]  __io_queue_sqe+0x100/0xb68 
> [46512.913292]  io_queue_sqe+0x424/0xd70 
> [46512.914199]  io_submit_sqes+0x1608/0x2250 
> [46512.915171]  __arm64_sys_io_uring_enter+0xb30/0x10c8 
> [46512.916392]  do_el0_svc+0x1c4/0x3c0 
> [46512.917269]  el0_sync_handler+0x88/0xb4 
> [46512.918212]  el0_sync+0x140/0x180 

io_uring on arm64?

The trace suggests that the __wait_on_page_locked_async() has
tripped over a corrupt page wait queue list.  i.e. this doesn't look
like it has anything to do with XFS, but probably needs Jens or
Willy to look at it....

Cheers,

Dave.


> [46512.919053] Code: aa0103e3 91020000 aa1303e1 9441d7a2 (d4210000)  
> [46512.920702] ---[ end trace d98533c43972277e ]--- 
> [46512.921927] Kernel panic - not syncing: Oops - BUG: Fatal exception 
> [46512.923534] SMP: stopping secondary CPUs 
> [46512.924907] Kernel Offset: 0x5e200000 from 0xfffffe8010000000 
> [46512.926299] PHYS_OFFSET: 0xffffff8d40000000 
> [46512.927349] CPU features: 0x0044002,63800438 
> [46512.928409] Memory Limit: none 
> [46512.929181] ---[ end Kernel panic - not syncing: Oops - BUG: Fatal
> exception
> ]--- 
> 
> I hit this panic several times on 64k pagesize machine, likes ppc64le and
> aarch64. Generally reproduced with reflink=1,rmapbt=1.
> meta-data=/dev/sda3              isize=512    agcount=4, agsize=983040 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=0
> data     =                       bsize=4096   blocks=3932160, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=3546, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> -- 
> You are receiving this mail because:
> You are watching the assignee of the bug.
>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
