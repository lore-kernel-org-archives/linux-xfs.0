Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-by2nam03on0093.outbound.protection.outlook.com ([104.47.42.93]:58291
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754195AbeFKUIo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 11 Jun 2018 16:08:44 -0400
From: "Xu, Wen" <wen.xu@gatech.edu>
Subject: Re: Bug report: kernel hangs when mounting a crafted xfs image
Date: Mon, 11 Jun 2018 20:08:42 +0000
Message-ID: <7D3F6825-C3AC-4E60-B329-6D6119BA12E2@gatech.edu>
References: <5B6AC96A-7049-48D7-82A1-4AB42322D38B@gatech.edu>
In-Reply-To: <5B6AC96A-7049-48D7-82A1-4AB42322D38B@gatech.edu>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A2AC3E25C1430B4CB9EF27B8E693874D@namprd07.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Cc: "Xu, Wen" <wen.xu@gatech.edu>

I think the following kernel information should help to figure out the problem:

[ 1451.029259] INFO: task mount:1296 blocked for more than 120 seconds.
[ 1451.030575]       Not tainted 4.17.0+ #1
[ 1451.031356] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1451.032946] mount           D    0  1296   1286 0x00000000
[ 1451.032950] Call Trace:
[ 1451.032968]  __schedule+0x3ec/0x890
[ 1451.032972]  ? ___slab_alloc+0x2a9/0x540
[ 1451.032974]  schedule+0x36/0x80
[ 1451.032978]  xlog_grant_head_wait+0xb8/0x1e0
[ 1451.032980]  xlog_grant_head_check+0xf1/0x100
[ 1451.032982]  xfs_log_reserve+0xcb/0x1e0
[ 1451.032984]  xfs_trans_reserve+0x169/0x1d0
[ 1451.032986]  xfs_trans_alloc+0xbc/0x180
[ 1451.032989]  xlog_recover_process_intents.isra.42+0x189/0x270
[ 1451.032992]  xlog_recover_finish+0x21/0xa0
[ 1451.032994]  ? xlog_recover_finish+0x21/0xa0
[ 1451.032996]  xfs_log_mount_finish+0x64/0xe0
[ 1451.032999]  xfs_mountfs+0x5df/0x930
[ 1451.033002]  xfs_fs_fill_super+0x487/0x650
[ 1451.033005]  mount_bdev+0x17b/0x1b0
[ 1451.033007]  ? xfs_test_remount_options+0x60/0x60
[ 1451.033009]  xfs_fs_mount+0x15/0x20
[ 1451.033011]  mount_fs+0x3d/0x150
[ 1451.033014]  ? __alloc_percpu+0x15/0x20
[ 1451.033018]  vfs_kern_mount+0x67/0x110
[ 1451.033020]  do_mount+0x201/0xd00
[ 1451.033023]  ? memdup_user+0x42/0x60
[ 1451.033025]  ksys_mount+0x83/0xd0
[ 1451.033027]  __x64_sys_mount+0x25/0x30
[ 1451.033030]  do_syscall_64+0x5a/0x110
[ 1451.033033]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1451.033036] RIP: 0033:0x7fbae025cb9a
[ 1451.033036] Code: Bad RIP value.
[ 1451.033045] RSP: 002b:00007ffdcea92278 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[ 1451.033057] RAX: ffffffffffffffda RBX: 0000000001747030 RCX: 00007fbae025cb9a
[ 1451.033060] RDX: 0000000001747210 RSI: 0000000001748f30 RDI: 000000000174fec0
[ 1451.033064] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000012
[ 1451.033068] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 000000000174fec0
[ 1451.033072] R13: 0000000001747210 R14: 0000000000000000 R15: 0000000000000003

Thanks,
Wen

> On Jun 11, 2018, at 3:36 PM, Xu, Wen <wen.xu@gatech.edu> wrote:
> 
> When mounting a crafted xfs v4 image, the kernel hangs and never returns for mount operation. Suspect potential deadlock in log recovery exists. Not sure it is considered as a bug or not.
> 
> - Reproduce (on 4.17 upstream kernel)
> # mkdir mnt
> # mount -t xfs 0.img mnt
> 
> The image file (0.img.zip) is available here: https://bugzilla.kernel.org/attachment.cgi?id=276475
> 
> Thanks,
> Wen

