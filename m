Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw1-f48.google.com ([209.85.161.48]:45452 "EHLO
        mail-yw1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfDKQPE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Apr 2019 12:15:04 -0400
Received: by mail-yw1-f48.google.com with SMTP id j128so2250214ywg.12
        for <linux-xfs@vger.kernel.org>; Thu, 11 Apr 2019 09:15:04 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::a407])
        by smtp.gmail.com with ESMTPSA id h204sm15541303ywh.110.2019.04.11.09.15.02
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Apr 2019 09:15:02 -0700 (PDT)
Date: Thu, 11 Apr 2019 12:15:01 -0400
From: Josef Bacik <josef@toxicpanda.com>
Subject: Deadlock waiting for log space
Message-ID: <20190411161500.43svvbxeqt6wbis2@macbook-pro-91.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,

We're seeing a deadlock on xfs in a few kernels in production and are having a
hard time figuring out what's happening.  Here is a breakdown of the stack
traces on a box I could get to before it was rebooted, all the boxes we've found
have been similar

100 hits:
[<ffffffff813bd7ae>] xlog_grant_head_wait+0xbe/0x1e0
[<ffffffff813bd958>] xlog_grant_head_check+0x88/0xe0
[<ffffffff813bff89>] xfs_log_reserve+0xc9/0x1c0
[<ffffffff813ba3dd>] xfs_trans_reserve+0x17d/0x1f0
[<ffffffff813bb72e>] xfs_trans_alloc+0xbe/0x130
[<ffffffff813a96ae>] xfs_vn_update_time+0x4e/0x130
[<ffffffff812563dd>] file_update_time+0xbd/0x130
[<ffffffff8139f964>] xfs_file_aio_write_checks+0x144/0x1b0
[<ffffffff8139fd9f>] xfs_file_buffered_aio_write+0x6f/0x250
[<ffffffff813a009d>] xfs_file_write_iter+0x11d/0x160
[<ffffffff81238233>] __do_readv_writev+0x2d3/0x3b0
[<ffffffff8123838d>] do_readv_writev+0x7d/0xb0
[<ffffffff81238774>] do_writev+0x74/0x100
[<ffffffff81239500>] SyS_writev+0x10/0x20
[<ffffffff81002b03>] do_syscall_64+0x53/0x150
[<ffffffff8196c7c6>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

-----
[<ffffffff813bd7ae>] xlog_grant_head_wait+0xbe/0x1e0
[<ffffffff813bd958>] xlog_grant_head_check+0x88/0xe0
[<ffffffff813bff89>] xfs_log_reserve+0xc9/0x1c0
[<ffffffff813ba3dd>] xfs_trans_reserve+0x17d/0x1f0
[<ffffffff813bb72e>] xfs_trans_alloc+0xbe/0x130
[<ffffffff813a96ae>] xfs_vn_update_time+0x4e/0x130
[<ffffffff812563dd>] file_update_time+0xbd/0x130
[<ffffffff8139f964>] xfs_file_aio_write_checks+0x144/0x1b0
[<ffffffff8139fd9f>] xfs_file_buffered_aio_write+0x6f/0x250
[<ffffffff813a009d>] xfs_file_write_iter+0x11d/0x160
[<ffffffff81236da9>] new_sync_write+0xd9/0x120
[<ffffffff81237f0d>] vfs_write+0x18d/0x1e0
[<ffffffff81239228>] SyS_write+0x48/0xa0
[<ffffffff81002b03>] do_syscall_64+0x53/0x150
[<ffffffff8196c7c6>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

-----
10 hits:
[<ffffffff813bd7ae>] xlog_grant_head_wait+0xbe/0x1e0
[<ffffffff813bd958>] xlog_grant_head_check+0x88/0xe0
[<ffffffff813bff89>] xfs_log_reserve+0xc9/0x1c0
[<ffffffff813ba3dd>] xfs_trans_reserve+0x17d/0x1f0
[<ffffffff813bb72e>] xfs_trans_alloc+0xbe/0x130
[<ffffffff813aedfd>] xfs_remove+0x10d/0x2d0
[<ffffffff813a9cfa>] xfs_vn_unlink+0x4a/0x90
[<ffffffff81249547>] vfs_unlink+0xf7/0x180
[<ffffffff8124a26f>] do_unlinkat+0x25f/0x2e0
[<ffffffff8124afc6>] SyS_unlink+0x16/0x20
[<ffffffff81002b03>] do_syscall_64+0x53/0x150
[<ffffffff8196c7c6>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

-----
2 hits:
[<ffffffff813bd7ae>] xlog_grant_head_wait+0xbe/0x1e0
[<ffffffff813bd958>] xlog_grant_head_check+0x88/0xe0
[<ffffffff813bff89>] xfs_log_reserve+0xc9/0x1c0
[<ffffffff813ba3dd>] xfs_trans_reserve+0x17d/0x1f0
[<ffffffff813bb72e>] xfs_trans_alloc+0xbe/0x130
[<ffffffff813a96ae>] xfs_vn_update_time+0x4e/0x130
[<ffffffff812563dd>] file_update_time+0xbd/0x130
[<ffffffff8139f964>] xfs_file_aio_write_checks+0x144/0x1b0
[<ffffffff8139fc0f>] xfs_file_dio_aio_write+0x10f/0x230
[<ffffffff813a0028>] xfs_file_write_iter+0xa8/0x160
[<ffffffff81236da9>] new_sync_write+0xd9/0x120
[<ffffffff81237f0d>] vfs_write+0x18d/0x1e0
[<ffffffff81239228>] SyS_write+0x48/0xa0
[<ffffffff81002b03>] do_syscall_64+0x53/0x150
[<ffffffff8196c7c6>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

-----
1 hit:
[<ffffffff813bd7ae>] xlog_grant_head_wait+0xbe/0x1e0
[<ffffffff813bd958>] xlog_grant_head_check+0x88/0xe0
[<ffffffff813bff89>] xfs_log_reserve+0xc9/0x1c0
[<ffffffff813ba3dd>] xfs_trans_reserve+0x17d/0x1f0
[<ffffffff813bb72e>] xfs_trans_alloc+0xbe/0x130
[<ffffffff813931ae>] xfs_setfilesize_trans_alloc.isra.14+0x2e/0x70
[<ffffffff81393a62>] xfs_submit_ioend+0x102/0x190
[<ffffffff81394288>] xfs_vm_writepages+0xa8/0xd0
[<ffffffff811b784f>] do_writepages+0x1f/0x30
[<ffffffff81268ce5>] __writeback_single_inode+0x45/0x320
[<ffffffff812694cb>] writeback_sb_inodes+0x25b/0x4e0
[<ffffffff8126980f>] __writeback_inodes_wb+0xbf/0x100
[<ffffffff81269b45>] wb_writeback+0x245/0x2d0
[<ffffffff8126a44b>] wb_workfn+0x14b/0x310
[<ffffffff810a68f0>] process_one_work+0x150/0x410
[<ffffffff810a721d>] worker_thread+0x6d/0x520
[<ffffffff810ad3fc>] kthread+0x12c/0x160
[<ffffffff8196c959>] ret_from_fork+0x29/0x40
[<ffffffffffffffff>] 0xffffffffffffffff

-----
[<ffffffff813bd7ae>] xlog_grant_head_wait+0xbe/0x1e0
[<ffffffff813bd958>] xlog_grant_head_check+0x88/0xe0
[<ffffffff813bff89>] xfs_log_reserve+0xc9/0x1c0
[<ffffffff813ba3dd>] xfs_trans_reserve+0x17d/0x1f0
[<ffffffff813bb72e>] xfs_trans_alloc+0xbe/0x130
[<ffffffff813ad890>] xfs_create+0x190/0x6d0
[<ffffffff813aae49>] xfs_generic_create+0x219/0x2b0
[<ffffffff813aaf14>] xfs_vn_mknod+0x14/0x20
[<ffffffff813aaf53>] xfs_vn_create+0x13/0x20
[<ffffffff81248adb>] path_openat+0x13bb/0x1470
[<ffffffff8124a62b>] do_filp_open+0x8b/0x140
[<ffffffff8123634c>] do_sys_open+0x11c/0x1f0
[<ffffffff8123643e>] SyS_open+0x1e/0x20
[<ffffffff81002b03>] do_syscall_64+0x53/0x150
[<ffffffff8196c7c6>] entry_SYSCALL64_slow_path+0x25/0x25
[<ffffffffffffffff>] 0xffffffffffffffff

The only "fishy" thing is in our kernels (4.6, 4.11, and 4.16) xfs_vm_writepages
calls xfs_submit_ioend with the page locked, whereas upstream doesn't.  However
the change that introduced this is

8e1f065bea1b ("xfs: refactor the tail of xfs_writepage_map")

which just moved things around, and reading the code it looks like the locking
order is page lock -> trans reservation, so not necessarily a problem.  Does
this ring bells for anybody?  If not I'll just keep digging through boxes that
trip over this until I figure out what's going on.  Thanks,

Josef
