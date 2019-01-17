Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:39509 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726826AbfAQLTi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 06:19:38 -0500
Reply-To: d.aberger@profihost.ag
From: Daniel Aberger - Profihost AG <d.aberger@profihost.ag>
Subject: XFS filesystem hang
Message-ID: <645a3d40-47a5-0f7a-7565-821bbce103f2@profihost.ag>
Date: Thu, 17 Jan 2019 12:14:11 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

one of our servers crashed / hung several times in the past days with
similar errors regarding XFS. Unfortunately we are unable to interprete
the call trace of dmesg to pinpoint the exact problem and I hope you
could help me to do so.

We already ran xfs_repair to ensure that there are no filesystem errors.

Here is an example dmesg output of recent crash of the mentioned server:

2019-01-12 06:06:35     INFO: task mysqld:1171 blocked for more than 120
seconds.
2019-01-12 06:06:35     Tainted: G 4.12.0+139-ph #1
2019-01-12 06:06:35     "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
2019-01-12 06:06:35     mysqld D 0 1171 1 0x00080000
2019-01-12 06:06:35     Call Trace:
2019-01-12 06:06:35     ? __schedule+0x3bc/0x820
2019-01-12 06:06:35     ? strlcpy+0x31/0x40
2019-01-12 06:06:35     ?
kernfs_path_from_node_locked+0x238/0x320schedule+0x32/0x80xlog_grant_head_wait+0xca/0x200xlog_grant_head_check+0x86/0xe0xfs_log_reserve+0xc7/0x1c0xfs_trans_reserve+0x169/0x1c0xfs_trans_alloc+0xb9/0x130xfs_vn_update_time+0x4e/0x130file_update_time+0xa7/0x100xfs_file_aio_write_checks+0x178/0x1a0
2019-01-12 06:06:35     ?
ktime_get+0x3e/0xa0xfs_file_dio_aio_write+0xb1/0x230xfs_file_write_iter+0xff/0x150aio_write+0xf6/0x150
2019-01-12 06:06:35     ? queue_unplugged+0x25/0xa0
2019-01-12 06:06:35     ? kmem_cache_alloc+0xf7/0x570
2019-01-12 06:06:35     ? do_io_submit+0x35c/0x690do_io_submit+0x35c/0x690
2019-01-12 06:06:35     ?
do_syscall_64+0x74/0x150do_syscall_64+0x74/0x150entry_SYSCALL_64_after_hwframe+0x3d/0xa2
2019-01-12 06:06:35     RIP: 0033:0x7f37aa6b6717
2019-01-12 06:06:35     RSP: 002b:00007f32953f4228 EFLAGS: 00000206
ORIG_RAX: 00000000000000d1
2019-01-12 06:06:35     RAX: ffffffffffffffda RBX: 00000000000040f6 RCX:
00007f37aa6b6717
2019-01-12 06:06:35     RDX: 00007f32953f4230 RSI: 0000000000000001 RDI:
00007f37aaef9000
2019-01-12 06:06:35     RBP: 00007f32953f4250 R08: 00007f32953f4230 R09:
0000000000000000
2019-01-12 06:06:35     R10: 0000000000010000 R11: 0000000000000206 R12:
00007f32953f4370
2019-01-12 06:06:35     R13: 00007f37a806d158 R14: 00007f32a5829b98 R15:
00007f379df26100

Thanks,

Daniel
