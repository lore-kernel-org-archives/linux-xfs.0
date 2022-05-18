Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613A2C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 09:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbiERJOX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 05:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233872AbiERJOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 05:14:21 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B89AE47
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 02:14:18 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CF75153457B;
        Wed, 18 May 2022 19:14:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nrFkz-00DOoB-EI; Wed, 18 May 2022 19:14:13 +1000
Date:   Wed, 18 May 2022 19:14:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCHSET 0/4] xfs: fix leaks and validation errors in logged
 xattr updates
Message-ID: <20220518091413.GQ1098723@dread.disaster.area>
References: <165267191199.625255.12173648515376165187.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165267191199.625255.12173648515376165187.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6284b8e8
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=7-415B0cAAAA:8
        a=yMJqHVqMQurLEcTYM7IA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 15, 2022 at 08:31:52PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> As I've detailed in my reply to Dave, this is a short series of fixes
> for the 5.19 for-next branch that fixes some validation deficiencies in
> xattr log item recovery and some memory leaks due to a confusing API.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> ---
>  fs/xfs/libxfs/xfs_attr.c       |   32 ++++++++++++++++++++++----------
>  fs/xfs/libxfs/xfs_log_format.h |    9 ++++++++-
>  fs/xfs/xfs_attr_item.c         |   36 +++++++++++++++++++++++++++---------
>  3 files changed, 57 insertions(+), 20 deletions(-)

Ok, somewhere in your two patchsets there is a new crash bug
freeing da_state structures. It's tripped by Catherine's LARP test
with my mods on top of that.

[17268.337737] BUG: kernel NULL pointer dereference, address: 00000000000000e0
[17268.340269] #PF: supervisor read access in kernel mode
[17268.342032] #PF: error_code(0x0000) - not-present page
[17268.343802] PGD 0 P4D 0 
[17268.344758] Oops: 0000 [#1] PREEMPT SMP
[17268.346093] CPU: 15 PID: 3417611 Comm: mount Not tainted 5.18.0-rc7-dgc+ #1247
[17268.348579] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[17268.351457] RIP: 0010:xfs_da_state_kill_altpath+0x5/0x40
[17268.353290] Code: 00 00 48 c7 c2 88 c4 84 82 48 c7 c6 10 c0 84 82 31 ff e8 99 5f 7c 00 eb c3 e8 a7 b3 80 00 cc cc cc cc cc cc cc 0f 1f 44 00 00 <8b> 97 e0 00 00 00 85 d2 7e 26 48 8d 87 e8 00 00 00 83 ea 01 48 8d
[17268.359442] RSP: 0018:ffffc90006227ba8 EFLAGS: 00010286
[17268.360918] RAX: 00000000ffffffc3 RBX: ffff888802540300 RCX: ffff888802264050
[17268.362913] RDX: 0000000000000000 RSI: ffffc90006227bac RDI: 0000000000000000
[17268.364909] RBP: 0000000000000000 R08: ffff8888031b4380 R09: ffff88880537a708
[17268.366893] R10: ffffc90006227ab8 R11: 0000000000000000 R12: 00000000ffffffc3
[17268.368884] R13: 0000000000000000 R14: ffff888802540358 R15: ffff8888064ea000
[17268.370871] FS:  00007f269a1f6800(0000) GS:ffff88883ed80000(0000) knlGS:0000000000000000
[17268.373133] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[17268.374744] CR2: 00000000000000e0 CR3: 000000080510b004 CR4: 0000000000060ee0
[17268.376743] Call Trace:
[17268.377478]  <TASK>
[17268.378131]  xfs_da_state_free+0xe/0x30
[17268.379362]  xfs_attr_set_iter+0x5f2/0xa30
[17268.380533]  xfs_xattri_finish_update+0x45/0x80
[17268.381931]  xfs_attri_item_recover+0x308/0x4d0
[17268.383208]  xlog_recover_process_intents+0xcc/0x330
[17268.384632]  ? _raw_spin_lock_irqsave+0x17/0x20
[17268.386005]  ? _raw_spin_unlock_irqrestore+0xe/0x30
[17268.387375]  ? __mod_timer+0x205/0x3a0
[17268.388456]  ? xfs_alloc_pagf_init+0x52/0x60
[17268.389669]  xlog_recover_finish+0x13/0x100
[17268.390858]  xfs_log_mount_finish+0x157/0x1e0
[17268.392100]  xfs_mountfs+0x548/0x980
[17268.393125]  ? xfs_filestream_get_parent+0x80/0x80
[17268.394482]  xfs_fs_fill_super+0x487/0x8c0
[17268.395651]  ? xfs_open_devices+0x1e0/0x1e0
[17268.396847]  get_tree_bdev+0x16c/0x270
[17268.397920]  vfs_get_tree+0x1f/0xb0
[17268.398917]  path_mount+0x2b6/0xa80
[17268.399923]  __x64_sys_mount+0x103/0x140
[17268.401040]  do_syscall_64+0x35/0x80
[17268.402064]  entry_SYSCALL_64_after_hwframe+0x44/0xae

I haven't yet dug into which patch introduces the problem, but it is
a new regression with these 10 patches applied. I'll try to
reproduce tomorrow, if it's reproducable I'll bisect.

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
