Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:39877 "EHLO
        mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752739AbcJFMU0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Oct 2016 08:20:26 -0400
Date: Thu, 6 Oct 2016 08:20:17 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
Message-ID: <119370333.805584.1475756417736.JavaMail.zimbra@redhat.com>
In-Reply-To: <20161005200522.GE19539@ZenIV.linux.org.uk>
References: <CA+55aFxrqCng2Qxasc9pyMrKUGFjo==fEaFT1vkH9Lncte3RgQ@mail.gmail.com> <1812816839.401734.1475602751170.JavaMail.zimbra@redhat.com> <20161004214219.GN4205@htj.duckdns.org> <1238277728.610186.1475676579513.JavaMail.zimbra@redhat.com> <20161005153014.GC26977@htj.duckdns.org> <270577901.647921.1475682888765.JavaMail.zimbra@redhat.com> <874538236.682217.1475693824077.JavaMail.zimbra@redhat.com> <20161005200522.GE19539@ZenIV.linux.org.uk>
Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT]
 splice_read reworked)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: tj <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@gmail.com>, linux-fsdevel@vger.kernel.org



----- Original Message -----
> From: "Al Viro" <viro@ZenIV.linux.org.uk>
> To: "CAI Qian" <caiqian@redhat.com>
> Cc: "tj" <tj@kernel.org>, "Linus Torvalds" <torvalds@linux-foundation.org>, "Dave Chinner" <david@fromorbit.com>,
> "linux-xfs" <linux-xfs@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>, "Nick Piggin" <npiggin@gmail.com>,
> linux-fsdevel@vger.kernel.org
> Sent: Wednesday, October 5, 2016 4:05:22 PM
> Subject: Re: local DoS - systemd hang or timeout (WAS: Re: [RFC][CFT] splice_read reworked)
> 
> On Wed, Oct 05, 2016 at 02:57:04PM -0400, CAI Qian wrote:
> 
> > Not sure if this related, and there is always a lockdep regards procfs
> > happened
> > below unless masking by other lockdep issues before the cgroup hang. Also,
> > this
> > hang is always reproducible.
> 
> Sigh...  Let's get the /proc/*/auxv out of the way - this should deal with
> it:
So I applied both this and the sanity patch, and both original sanity and the
proc warnings went away. However, the cgroup hang can still be reproduced as
well as this new xfs internal error below,

[16921.141233] XFS (dm-0): Internal error XFS_WANT_CORRUPTED_RETURN at line 5619 of file fs/xfs/libxfs/xfs_bmap.c.  Caller xfs_bmap_shift_extents+0x1cc/0x3a0 [xfs]
[16921.157694] CPU: 9 PID: 52920 Comm: trinity-c108 Not tainted 4.8.0-rc8-splice-fixw-proc+ #4
[16921.167012] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS GRNDSDP1.86B.0044.R00.1501191641 01/19/2015
[16921.178368]  0000000000000286 00000000c3833246 ffff8803d0a83b60 ffffffff813d2ecc
[16921.186658]  ffff88042a898000 0000000000000001 ffff8803d0a83b78 ffffffffa02f36eb
[16921.194946]  ffffffffa02b544c ffff8803d0a83c30 ffffffffa02a8e52 ffff88042a898040
[16921.203238] Call Trace:
[16921.205972]  [<ffffffff813d2ecc>] dump_stack+0x85/0xc9
[16921.211742]  [<ffffffffa02f36eb>] xfs_error_report+0x3b/0x40 [xfs]
[16921.218660]  [<ffffffffa02b544c>] ? xfs_bmap_shift_extents+0x1cc/0x3a0 [xfs]
[16921.226543]  [<ffffffffa02a8e52>] xfs_bmse_shift_one.constprop.20+0x332/0x370 [xfs]
[16921.235090]  [<ffffffff817cb73a>] ? kmemleak_alloc+0x4a/0xa0
[16921.241426]  [<ffffffffa02b544c>] xfs_bmap_shift_extents+0x1cc/0x3a0 [xfs]
[16921.249122]  [<ffffffffa03142aa>] ? xfs_trans_add_item+0x2a/0x60 [xfs]
[16921.256430]  [<ffffffffa02eb361>] xfs_shift_file_space+0x231/0x2f0 [xfs]
[16921.263931]  [<ffffffffa02ebe8c>] xfs_collapse_file_space+0x5c/0x180 [xfs]
[16921.271622]  [<ffffffffa02f69b8>] xfs_file_fallocate+0x158/0x360 [xfs]
[16921.278907]  [<ffffffff810f8eae>] ? update_fast_ctr+0x4e/0x70
[16921.285320]  [<ffffffff810f8f57>] ? percpu_down_read+0x57/0x90
[16921.291828]  [<ffffffff81284be1>] ? __sb_start_write+0xd1/0xf0
[16921.298337]  [<ffffffff81284be1>] ? __sb_start_write+0xd1/0xf0
[16921.304847]  [<ffffffff8127e000>] vfs_fallocate+0x140/0x230
[16921.311067]  [<ffffffff8127eee4>] SyS_fallocate+0x44/0x70
[16921.317091]  [<ffffffff81003c9c>] do_syscall_64+0x6c/0x1e0
[16921.323212]  [<ffffffff817d4a3f>] entry_SYSCALL64_slow_path+0x25/0x25

    CAI Qian
