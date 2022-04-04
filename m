Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA05C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Apr 2022 13:16:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350405AbiDDNSf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 09:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiDDNSd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Apr 2022 09:18:33 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF8A3CA7F
        for <linux-xfs@vger.kernel.org>; Mon,  4 Apr 2022 06:16:36 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id b21so6521047ljf.11
        for <linux-xfs@vger.kernel.org>; Mon, 04 Apr 2022 06:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=/z95IEsXPogMXdxjU/vb6pPJQgW0kDR2VPBrTDe84XA=;
        b=pWkLwxT3hdSi3G/T5Sl5jum98Fnwt0EEOXFDqCQsj9uJ3k0ZO+Q1tsH0uyJGdp5qgO
         dTfY/wPh8VgAS1HnyCe6MfiFGiP+4AoGOtqMGqj2xzZtMvAL7vkKEX8M9sVLj3jZB+q3
         YXAPLfFAO8pS4rA1VtWDZKhvYe5vCo5mSojUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/z95IEsXPogMXdxjU/vb6pPJQgW0kDR2VPBrTDe84XA=;
        b=kAMoPD6AmnOp3Bj8jKFJNrjrXGM4bwhdPWpiT9EUdlIXMNl/HUYnh+iOQjn7p3PyDi
         nQ1enJzLwxOe5vN2RDeiCyMUsqKWFE8UGvziQxo3sJw+RjDmF3KXZBJ72iy2Yhd2o8Kp
         MmaqjyrGL+9s7qqTfieLfAZxJT8p2MxSVOfqBejCyIe8y5ESApwk1xqoTljEjAo60Css
         5YdZTg9LEsbdjUkevRgrS8WLqDWKSUbSkzZGcE01Vq9joDLHCy2uUCUloWWQp0ZkRr7X
         06433N/9bAQ19NqTcRHPwR9gAKx93L9ENGuDPVYhuR68d40wM36OQp98mfAGJhGY1kBq
         cncw==
X-Gm-Message-State: AOAM532jGcKqU4S6Icd0vXkMzy5SQngbk5WE3f9HvhYip2CPKeZmobVH
        XoGgmIqbrT7bG8TuQ+IESMoChV8ER7zgzgcwq+4gs9AjRAOqMg==
X-Google-Smtp-Source: ABdhPJzx3oExVo+2Bk1dcRZ427iru6XJI+/ENS0LtPAr+uAX5MvRINlA8nG4LveypkDHtlbiQbUAkaFfvATmeE9Jrxc=
X-Received: by 2002:a2e:a593:0:b0:249:80f3:7e7f with SMTP id
 m19-20020a2ea593000000b0024980f37e7fmr21759784ljp.236.1649078194499; Mon, 04
 Apr 2022 06:16:34 -0700 (PDT)
MIME-Version: 1.0
From:   Frank Hofmann <fhofmann@cloudflare.com>
Date:   Mon, 4 Apr 2022 14:16:23 +0100
Message-ID: <CABEBQikRSCuJumOYmgzNLN6dOZ+YUvOQMFby7WJGSwGoFM3YMg@mail.gmail.com>
Subject: Self-deadlock (?) in xfs_inodegc_worker / xfs_inactive ?
To:     linux-xfs@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

we see machines getting stuck with a large number of backed-up
processes that invoke statfs() (monitoring stuff), like:

[Sat Apr  2 09:54:32 2022] INFO: task node_exporter:244222 blocked for
more than 10 seconds.
[Sat Apr  2 09:54:32 2022]       Tainted: G           O
5.15.26-cloudflare-2022.3.4 #1
[Sat Apr  2 09:54:32 2022] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Sat Apr  2 09:54:32 2022] task:node_exporter   state:D stack:    0
pid:244222 ppid:     1 flags:0x00004000
[Sat Apr  2 09:54:32 2022] Call Trace:
[Sat Apr  2 09:54:32 2022]  <TASK>
[Sat Apr  2 09:54:32 2022]  __schedule+0x2cd/0x950
[Sat Apr  2 09:54:32 2022]  schedule+0x44/0xa0
[Sat Apr  2 09:54:32 2022]  schedule_timeout+0xfc/0x140
[Sat Apr  2 09:54:32 2022]  ? try_to_wake_up+0x338/0x4e0
[Sat Apr  2 09:54:32 2022]  ? __prepare_to_swait+0x4b/0x70
[Sat Apr  2 09:54:32 2022]  wait_for_completion+0x86/0xe0
[Sat Apr  2 09:54:32 2022]  flush_work+0x5c/0x80
[Sat Apr  2 09:54:32 2022]  ? flush_workqueue_prep_pwqs+0x110/0x110
[Sat Apr  2 09:54:32 2022]  xfs_inodegc_flush.part.0+0x3b/0x90
[Sat Apr  2 09:54:32 2022]  xfs_fs_statfs+0x29/0x1c0
[Sat Apr  2 09:54:32 2022]  statfs_by_dentry+0x4d/0x70
[Sat Apr  2 09:54:32 2022]  user_statfs+0x57/0xc0
[Sat Apr  2 09:54:32 2022]  __do_sys_statfs+0x20/0x50
[Sat Apr  2 09:54:32 2022]  do_syscall_64+0x3b/0x90
[Sat Apr  2 09:54:32 2022]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[Sat Apr  2 09:54:32 2022] RIP: 0033:0x4ac9db
...

A linear-over-time increasing number of 'D' state processes is usually
what alerts us to this.

The oldest thread found waiting appears always to be the inode gc
worker doing deferred inactivation:

[Sat Apr  2 09:55:47 2022] INFO: task kworker/25:0:3880332 blocked for
more than 85 seconds.
[Sat Apr  2 09:55:47 2022]       Tainted: G           O
5.15.26-cloudflare-2022.3.4 #1
[Sat Apr  2 09:55:47 2022] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Sat Apr  2 09:55:47 2022] task:kworker/25:0    state:D stack:    0
pid:3880332 ppid:     2 flags:0x00004000
[Sat Apr  2 09:55:47 2022] Workqueue: xfs-inodegc/dm-5 xfs_inodegc_worker
[Sat Apr  2 09:55:47 2022] Call Trace:
[Sat Apr  2 09:55:47 2022]  <TASK>
[Sat Apr  2 09:55:47 2022]  __schedule+0x2cd/0x950
[Sat Apr  2 09:55:47 2022]  schedule+0x44/0xa0
[Sat Apr  2 09:55:47 2022]  schedule_timeout+0xfc/0x140
[Sat Apr  2 09:55:47 2022]  __down+0x7d/0xd0
[Sat Apr  2 09:55:47 2022]  down+0x43/0x60
[Sat Apr  2 09:55:47 2022]  xfs_buf_lock+0x29/0xa0
[Sat Apr  2 09:55:47 2022]  xfs_buf_find+0x2c4/0x590
[Sat Apr  2 09:55:47 2022]  xfs_buf_get_map+0x46/0x390
[Sat Apr  2 09:55:47 2022]  xfs_buf_read_map+0x52/0x270
[Sat Apr  2 09:55:47 2022]  ? xfs_read_agf+0x87/0x110
[Sat Apr  2 09:55:47 2022]  xfs_trans_read_buf_map+0x128/0x2a0
[Sat Apr  2 09:55:47 2022]  ? xfs_read_agf+0x87/0x110
[Sat Apr  2 09:55:47 2022]  xfs_read_agf+0x87/0x110
[Sat Apr  2 09:55:47 2022]  xfs_alloc_read_agf+0x34/0x1a0
[Sat Apr  2 09:55:47 2022]  xfs_alloc_fix_freelist+0x3d7/0x4f0
[Sat Apr  2 09:55:47 2022]  ? xfs_buf_find+0x2aa/0x590
[Sat Apr  2 09:55:47 2022]  ? cpumask_next_and+0x1f/0x20
[Sat Apr  2 09:55:47 2022]  ? update_sd_lb_stats.constprop.0+0xfe/0x7d0
[Sat Apr  2 09:55:47 2022]  ? down_trylock+0x25/0x30
[Sat Apr  2 09:55:47 2022]  xfs_alloc_vextent+0x22b/0x440
[Sat Apr  2 09:55:47 2022]  __xfs_inobt_alloc_block.isra.0+0xc5/0x1a0
[Sat Apr  2 09:55:47 2022]  __xfs_btree_split+0xf2/0x610
[Sat Apr  2 09:55:47 2022]  ? xfs_btree_read_buf_block.constprop.0+0xae/0xd0
[Sat Apr  2 09:55:47 2022]  xfs_btree_split+0x4b/0x100
[Sat Apr  2 09:55:47 2022]  xfs_btree_make_block_unfull+0x193/0x1c0
[Sat Apr  2 09:55:47 2022]  xfs_btree_insrec+0x4a9/0x5a0
[Sat Apr  2 09:55:47 2022]  ? xfs_btree_read_buf_block.constprop.0+0x95/0xd0
[Sat Apr  2 09:55:47 2022]  xfs_btree_insert+0xa8/0x1f0
[Sat Apr  2 09:55:47 2022]  ? xfs_inobt_init_common+0x28/0x90
[Sat Apr  2 09:55:47 2022]  xfs_difree_finobt+0xa4/0x240
[Sat Apr  2 09:55:47 2022]  xfs_difree+0x126/0x1a0
[Sat Apr  2 09:55:47 2022]  xfs_ifree+0xca/0x4a0
[Sat Apr  2 09:55:47 2022]  ? xfs_trans_reserve+0x123/0x160
[Sat Apr  2 09:55:47 2022]  ? xfs_trans_alloc+0xec/0x1f0
[Sat Apr  2 09:55:47 2022]  xfs_inactive_ifree.isra.0+0x9e/0x1a0
[Sat Apr  2 09:55:47 2022]  xfs_inactive+0xf8/0x170
[Sat Apr  2 09:55:47 2022]  xfs_inodegc_worker+0x73/0xf0
[Sat Apr  2 09:55:47 2022]  process_one_work+0x1e6/0x380
[Sat Apr  2 09:55:47 2022]  worker_thread+0x50/0x3a0
[Sat Apr  2 09:55:47 2022]  ? rescuer_thread+0x380/0x380
[Sat Apr  2 09:55:47 2022]  kthread+0x127/0x150
[Sat Apr  2 09:55:47 2022]  ? set_kthread_struct+0x40/0x40
[Sat Apr  2 09:55:47 2022]  ret_from_fork+0x22/0x30
[Sat Apr  2 09:55:47 2022]  </TASK>

Once the system is in this state, I/O to the affected filesystem no
longer happens - all ops to it get stuck. Other than rebooting the
system, we have not found a way to recover from this.

This is a histogram (first column: number of proceses 'D'-ed on that
call trace) of `/proc/<PID>/stack`:

336 flush_work+0x5c/0x80 <= xfs_inodegc_flush.part.0+0x3b/0x90 <=
xfs_fs_statfs+0x29/0x1c0 <= statfs_by_dentry+0x4d/0x70 <=
user_statfs+0x57/0xc0 <= __do_sys_statfs+0x20/0x50 <=
do_syscall_64+0x3b/0x90 <= entry_SYSCALL_64_after_hwframe+0x44/0xae
48 xfs_ilock_attr_map_shared+0x24/0x50 <= xfs_attr_get+0x96/0xc0 <=
xfs_xattr_get+0x75/0xb0 <= __vfs_getxattr+0x53/0x70 <=
get_vfs_caps_from_disk+0x6e/0x1d0 <= audit_copy_inode+0x95/0xd0 <=
path_openat+0x27f/0x1090 <= do_filp_open+0xa9/0x150 <=
do_sys_openat2+0x97/0x160 <= __x64_sys_openat+0x54/0x90 <=
do_syscall_64+0x3b/0x90 <= entry_SYSCALL_64_after_hwframe+0x44/0xae
32 down+0x43/0x60 <= xfs_buf_lock+0x29/0xa0 <=
xfs_buf_find+0x2c4/0x590 <= xfs_buf_get_map+0x46/0x390 <=
xfs_buf_read_map+0x52/0x270 <= xfs_trans_read_buf_map+0x128/0x2a0 <=
xfs_read_agi+0x8e/0x120 <= xfs_iunlink_remove+0x59/0x220 <=
xfs_ifree+0x7d/0x4a0 <= xfs_inactive_ifree.isra.0+0x9e/0x1a0 <=
xfs_inactive+0xf8/0x170 <= xfs_inodegc_worker+0x73/0xf0 <=
process_one_work+0x1e6/0x380 <= worker_thread+0x50/0x3a0 <=
kthread+0x127/0x150 <= ret_from_fork+0x22/0x30
5 down+0x43/0x60 <= xfs_buf_lock+0x29/0xa0 <= xfs_buf_find+0x2c4/0x590
<= xfs_buf_get_map+0x46/0x390 <= xfs_buf_read_map+0x52/0x270 <=
xfs_trans_read_buf_map+0x128/0x2a0 <= xfs_read_agi+0x8e/0x120 <=
xfs_ialloc_read_agi+0x26/0xa0 <= xfs_dialloc+0x171/0x720 <=
xfs_create+0x394/0x610 <= xfs_generic_create+0x11e/0x360 <=
path_openat+0xe1c/0x1090 <= do_filp_open+0xa9/0x150 <=
do_sys_openat2+0x97/0x160 <= __x64_sys_openat+0x54/0x90 <=
do_syscall_64+0x3b/0x90 <= entry_SYSCALL_64_after_hwframe+0x44/0xae
1 down+0x43/0x60 <= xfs_buf_lock+0x29/0xa0 <= xfs_buf_find+0x2c4/0x590
<= xfs_buf_get_map+0x46/0x390 <= xfs_buf_read_map+0x52/0x270 <=
xfs_trans_read_buf_map+0x128/0x2a0 <= xfs_read_agi+0x8e/0x120 <=
xfs_iunlink+0x6b/0x1c0 <= xfs_remove+0x2c5/0x410 <=
xfs_vn_unlink+0x53/0xa0 <= vfs_unlink+0x113/0x280 <=
do_unlinkat+0x1ab/0x2d0 <= __x64_sys_unlink+0x3e/0x60 <=
do_syscall_64+0x3b/0x90 <= entry_SYSCALL_64_after_hwframe+0x44/0xae
1 down+0x43/0x60 <= xfs_buf_lock+0x29/0xa0 <= xfs_buf_find+0x2c4/0x590
<= xfs_buf_get_map+0x46/0x390 <= xfs_buf_read_map+0x52/0x270 <=
xfs_trans_read_buf_map+0x128/0x2a0 <= xfs_read_agf+0x87/0x110 <=
xfs_alloc_read_agf+0x34/0x1a0 <= xfs_alloc_fix_freelist+0x3d7/0x4f0 <=
xfs_free_extent_fix_freelist+0x61/0xa0 <= __xfs_free_extent+0x6b/0x1a0
<= xfs_trans_free_extent+0x3b/0xd0 <=
xfs_extent_free_finish_item+0x24/0x40 <=
xfs_defer_finish_noroll+0x1f1/0x580 <= xfs_defer_finish+0x11/0x70 <=
xfs_itruncate_extents_flags+0xc1/0x220 <=
xfs_free_eofblocks+0xbc/0x120 <= xfs_icwalk_ag+0x3a9/0x640 <=
xfs_blockgc_worker+0x31/0xf0 <= process_one_work+0x1e6/0x380 <=
worker_thread+0x50/0x3a0 <= kthread+0x127/0x150 <=
ret_from_fork+0x22/0x30
1 down+0x43/0x60 <= xfs_buf_lock+0x29/0xa0 <= xfs_buf_find+0x2c4/0x590
<= xfs_buf_get_map+0x46/0x390 <= xfs_buf_read_map+0x52/0x270 <=
xfs_trans_read_buf_map+0x128/0x2a0 <= xfs_read_agf+0x87/0x110 <=
xfs_alloc_read_agf+0x34/0x1a0 <= xfs_alloc_fix_freelist+0x3d7/0x4f0 <=
xfs_alloc_vextent+0x22b/0x440 <=
__xfs_inobt_alloc_block.isra.0+0xc5/0x1a0 <=
__xfs_btree_split+0xf2/0x610 <= xfs_btree_split+0x4b/0x100 <=
xfs_btree_make_block_unfull+0x193/0x1c0 <=
xfs_btree_insrec+0x4a9/0x5a0 <= xfs_btree_insert+0xa8/0x1f0 <=
xfs_difree_finobt+0xa4/0x240 <= xfs_difree+0x126/0x1a0 <=
xfs_ifree+0xca/0x4a0 <= xfs_inactive_ifree.isra.0+0x9e/0x1a0 <=
xfs_inactive+0xf8/0x170 <= xfs_inodegc_worker+0x73/0xf0 <=
process_one_work+0x1e6/0x380 <= worker_thread+0x50/0x3a0 <=
kthread+0x127/0x150 <= ret_from_fork+0x22/0x30
1 down+0x43/0x60 <= xfs_buf_lock+0x29/0xa0 <= xfs_buf_find+0x2c4/0x590
<= xfs_buf_get_map+0x46/0x390 <= xfs_buf_read_map+0x52/0x270 <=
xfs_trans_read_buf_map+0x128/0x2a0 <= xfs_imap_to_bp+0x4e/0x70 <=
xfs_trans_log_inode+0x1d0/0x280 <= xfs_bmap_btalloc+0x75f/0x820 <=
xfs_bmapi_allocate+0xe4/0x310 <=
xfs_bmapi_convert_delalloc+0x273/0x490 <= xfs_map_blocks+0x1b5/0x400
<= iomap_do_writepage+0x11d/0x820 <= write_cache_pages+0x189/0x3e0 <=
iomap_writepages+0x1c/0x40 <= xfs_vm_writepages+0x71/0xa0 <=
do_writepages+0xc3/0x1e0 <= __writeback_single_inode+0x37/0x270 <=
writeback_sb_inodes+0x1ed/0x420 <= __writeback_inodes_wb+0x4c/0xd0 <=
wb_writeback+0x1ba/0x270 <= wb_workfn+0x292/0x4d0 <=
process_one_work+0x1e6/0x380 <= worker_thread+0x50/0x3a0 <=
kthread+0x127/0x150 <= ret_from_fork+0x22/0x30


Is this something that has been seen before ?

The codepath from xfs_inactive() through xfs_btree_split(),
xfs_alloc_fix_freelist() to eventually xfs_buf_lock() doesn't look
very new to me (an old report showing the callpath in a different
context is, for example,
https://www.spinics.net/lists/linux-mm/msg147472.html).

But the introduction of deferred inode inactivation last Summer (in
5.15) - and this going through the xfs_inodegc_worker - appears to
roughly correlate with us starting to see these hangs.

There's no "advance warning" for these (no OOMs preceding, no disk
full) as far as we've found.

How would we go about addressing this hang ?

Thanks in advance,
Frank Hofmann
