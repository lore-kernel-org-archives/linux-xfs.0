Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94714C433ED
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 08:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78FEF6124B
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Apr 2021 08:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhDOIpC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Apr 2021 04:45:02 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:37183 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232033AbhDOIpA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Apr 2021 04:45:00 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id CFAED107A82;
        Thu, 15 Apr 2021 18:44:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lWxbz-008ukp-T9; Thu, 15 Apr 2021 18:44:31 +1000
Date:   Thu, 15 Apr 2021 18:44:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] xfs: support deactivating AGs
Message-ID: <20210415084431.GP63242@dread.disaster.area>
References: <20210414195240.1802221-1-hsiangkao@redhat.com>
 <20210414195240.1802221-2-hsiangkao@redhat.com>
 <20210415034255.GJ63242@dread.disaster.area>
 <20210415042837.GA1864610@xiangao.remote.csb>
 <20210415062824.GN63242@dread.disaster.area>
 <20210415070833.GD1864610@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415070833.GD1864610@xiangao.remote.csb>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_f
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=3YhXtTcJ-WEA:10 a=7-415B0cAAAA:8
        a=duduCrNGJUkIz8KOls4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 15, 2021 at 03:08:33PM +0800, Gao Xiang wrote:
> On Thu, Apr 15, 2021 at 04:28:24PM +1000, Dave Chinner wrote:
> > On Thu, Apr 15, 2021 at 12:28:37PM +0800, Gao Xiang wrote:
> > > My current thought is that we could implement it in that way as the
> > > first step (in order to land the shrinking functionality to let
> > > end-users benefit of this), and by the codebase evolves, it can be
> > > transformed to a more gentle way.
> > 
> > I think converting this patchset to active/passive references ias
> > I've described solves the problem entirely - there's no "evolving"
> > needed as we can solve it with this one structural change...
> 
> Since currently even xfs_perag_put() reaches zero, it won't free
> the per-ag anyway (it may just use to mark the pointer is no longer
> used in the context? not sure what's the exact use of the such pairs),

It tells us when we have an unbalanced get/put pair in the code or
we are failing to clean up everything at unmount time (e.g due to a
shutdown bug). i.e. Unmount on debug kernels will assert fail if the
ref count is not zero, and this indicates either a resource leak or
unbalanced get/put pairing.

I just used exactly this code to debug the active references patch I
just sent. Three different conversion bugs, all count at unmount
time in a couple of different ways. One was:

[   92.219489] XFS: Assertion failed: atomic_read(&pag->pag_ref) == 0, file: fs/xfs/xfs_mount.c, line: 150
[   92.223416] ------------[ cut here ]------------
[   92.225597] kernel BUG at fs/xfs/xfs_message.c:110!
[   92.227547] invalid opcode: 0000 [#1] PREEMPT SMP
[   92.229308] CPU: 8 PID: 18310 Comm: umount Not tainted 5.12.0-rc6-dgc+ #3114
[   92.231859] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014
[   92.234801] RIP: 0010:assfail+0x27/0x2d
[   92.235908] Code: 0b 5d c3 66 66 66 66 90 55 41 89 c8 48 89 d1 48 89 f2 48 89 e5 48 c7 c6 f0 b9 58 82 e8 79 f9 ff ff 80 3d 4e 1d 85 02 00 74 02 <0f> 0b 0f 09
[   92.241143] RSP: 0018:ffffc9000ed3bd80 EFLAGS: 00010202
[   92.242623] RAX: 0000000000000000 RBX: ffff8881031de400 RCX: 0000000000000000
[   92.244626] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffff82518041
[   92.246651] RBP: ffffc9000ed3bd80 R08: 0000000000000000 R09: 000000000000000a
[   92.248657] R10: 000000000000000a R11: f000000000000000 R12: 0000000000000001
[   92.250664] R13: ffff8881017775a0 R14: ffff888101777000 R15: ffff888101777578
[   92.252697] FS:  00007f69fe76ac80(0000) GS:ffff8885fec00000(0000) knlGS:0000000000000000
[   92.254973] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   92.256603] CR2: 00007f241f55bad0 CR3: 00000001030ae002 CR4: 0000000000060ee0
[   92.258617] Call Trace:
[   92.259347]  xfs_free_perag+0xc1/0xf0
[   92.260403]  xfs_unmountfs+0xa8/0x130
[   92.261462]  xfs_fs_put_super+0x3a/0xa0
[   92.262556]  generic_shutdown_super+0x6a/0x100
[   92.263815]  kill_block_super+0x27/0x50
[   92.264919]  deactivate_locked_super+0x36/0xa0
[   92.266179]  deactivate_super+0x40/0x50
[   92.267271]  cleanup_mnt+0x135/0x190
[   92.268299]  __cleanup_mnt+0x12/0x20
[   92.269327]  task_work_run+0x61/0xb0
[   92.270349]  exit_to_user_mode_prepare+0x122/0x130
[   92.271706]  syscall_exit_to_user_mode+0x17/0x40
[   92.273034]  do_syscall_64+0x3f/0x50
[   92.274056]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   92.275485] RIP: 0033:0x7f69fe9b0ee7

Another was:

[   75.056242] XFS: Assertion failed: atomic_read(&pag->pag_ref) > 0, file: fs/xfs/libxfs/xfs_sb.c, line: 90
[   75.060870] ------------[ cut here ]------------
[   75.062750] kernel BUG at fs/xfs/xfs_message.c:110!
[   75.064699] invalid opcode: 0000 [#1] PREEMPT SMP
[   75.066437] CPU: 6 PID: 5859 Comm: umount Not tainted 5.12.0-rc6-dgc+ #3113
[   75.068369] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-1 04/01/2014
[   75.070654] RIP: 0010:assfail+0x27/0x2d
[   75.071760] Code: 0b 5d c3 66 66 66 66 90 55 41 89 c8 48 89 d1 48 89 f2 48 89 e5 48 c7 c6 f0 b9 58 82 e8 79 f9 ff ff 80 3d 4e 1d 85 02 00 74 02 <0f> 0b 0f 09
[   75.077411] RSP: 0018:ffffc9000271bcd0 EFLAGS: 00010202
[   75.078841] RAX: 0000000000000000 RBX: ffff8885c156d000 RCX: 0000000000000000
[   75.080806] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffff82518041
[   75.082755] RBP: ffffc9000271bcd0 R08: 0000000000000000 R09: 000000000000000a
[   75.087486] R10: 000000000000000a R11: f000000000000000 R12: ffff88825a85cc40
[   75.089465] R13: ffff8885c156d000 R14: ffff88825a85cca0 R15: ffff8883b9d7a800
[   75.091419] FS:  00007f5aa4206c80(0000) GS:ffff8883b9d00000(0000) knlGS:0000000000000000
[   75.093659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   75.095254] CR2: 00007ffd3876cf48 CR3: 000000025897b001 CR4: 0000000000060ee0
[   75.097238] Call Trace:
[   75.097941]  xfs_perag_put+0x8f/0xa0
[   75.098949]  xfs_buf_rele+0x284/0x540
[   75.099999]  xfs_buftarg_drain+0x195/0x250
[   75.101142]  xfs_log_unmount+0x2a/0x80
[   75.102195]  xfs_unmountfs+0x88/0x130
[   75.103221]  xfs_fs_put_super+0x3a/0xa0
[   75.104320]  generic_shutdown_super+0x6a/0x100
[   75.105549]  kill_block_super+0x27/0x50
[   75.106626]  deactivate_locked_super+0x36/0xa0
[   75.107896]  deactivate_super+0x40/0x50
[   75.108969]  cleanup_mnt+0x135/0x190
[   75.109965]  __cleanup_mnt+0x12/0x20
[   75.110977]  task_work_run+0x61/0xb0
[   75.112141]  exit_to_user_mode_prepare+0x122/0x130
[   75.113473]  syscall_exit_to_user_mode+0x17/0x40
[   75.114770]  do_syscall_64+0x3f/0x50
[   75.115791]  entry_SYSCALL_64_after_hwframe+0x44/0xae

IOWs, the passive reference counting we have right now is extremely
useful for debug and triage purposes, even if it not actively used
by the code right now for life cycle management. It was always
intended to form the basis of dynamic perag management (e.g. for
huge filesystems with millions of AGs and a shrinker to manage perag
memory footprint like we do inodes....) and it turns out that it's
also useful for shrink....

> so in practice I think after active/passive references are introduced,
> there is still the only one real reference count that works for the
> per-ag lifetime management and currently it doesn't manage whole
> lifetime at all...

I'm not sure I follow you there - the perag reference count doesn't
manage the lifecycle of the perag object at all - it just keeps
track of the number of current users of the structure...

> So (my own understanding is) I think in practice, that approachs
> would be somewhat equal to relocate/rearrange xfs_perag_get()/put()
> pair to manage the perag lifetime instead. and maybe use xfs_perag_ptr()
> to access perag when some reference count is available.

We pass the actively referenced perag pointer around int eh
structures that use it. The lifetime of the active reference matches
the structure that keeps track of it, so nothing should be doing
lookups that don't take reference counts because they should already
have access to a the relevant perag object that has been looked
up...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
