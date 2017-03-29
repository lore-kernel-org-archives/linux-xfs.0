Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:40515 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753959AbdC2NdD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Mar 2017 09:33:03 -0400
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
Date: Wed, 29 Mar 2017 15:33:00 +0200
Message-ID: <74555470.x0EUG58Vde@libor-nb>
In-Reply-To: <b6492357-4bf3-c570-be33-90010e3b1967@sandeen.net>
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com> <2727630.ZS8FFPfE3C@libor-nb> <b6492357-4bf3-c570-be33-90010e3b1967@sandeen.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Hello,
so here is trace from today.
Hope it helps you

Libor

Mar 29 15:05:12 vps2 kernel: [1154612.424431] XFS (dm-2): Metadata corruption detected at xfs_attr3_leaf_write_verify+0xe8/0x100 [xfs], xfs_attr3_leaf block 0x24dd5310
Mar 29 15:05:12 vps2 kernel: [1154612.424882] XFS (dm-2): Unmount and run xfs_repair
Mar 29 15:05:12 vps2 kernel: [1154612.425072] XFS (dm-2): First 64 bytes of corrupted metadata buffer:
Mar 29 15:05:12 vps2 kernel: [1154612.425262] ffff979235612000: 00 00 00 00 00 00 00 00 fb ee 00 00 00 00 00 00  ................
Mar 29 15:05:12 vps2 kernel: [1154612.425478] ffff979235612010: 10 00 00 00 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........
Mar 29 15:05:12 vps2 kernel: [1154612.425708] ffff979235612020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 29 15:05:12 vps2 kernel: [1154612.425960] ffff979235612030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
Mar 29 15:05:12 vps2 kernel: [1154612.426259] CPU: 2 PID: 453 Comm: xfsaild/dm-2 Tainted: G            E   4.9.0-0.bpo.2-amd64 #1 Debian 4.9.13-1~bpo8+1
Mar 29 15:05:12 vps2 kernel: [1154612.426260] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/14/2014
Mar 29 15:05:12 vps2 kernel: [1154612.426262]  0000000000000000 ffffffffb1b29cd5 ffff9794ac29c980 ffff9791295d83c0
Mar 29 15:05:12 vps2 kernel: [1154612.426264]  ffffffffc064aa58 0000000000000000 0000000001d9a9ff 0000000000000000
Mar 29 15:05:12 vps2 kernel: [1154612.426266]  ffffbd1ac1fb3d40 ffffffffc0695997 ffff9792b0dd60c0 ffffffffc0693cc4
Mar 29 15:05:12 vps2 kernel: [1154612.426268] Call Trace:
Mar 29 15:05:12 vps2 kernel: [1154612.426277]  [<ffffffffb1b29cd5>] ? dump_stack+0x5c/0x77
Mar 29 15:05:12 vps2 kernel: [1154612.426339]  [<ffffffffc064aa58>] ? xfs_attr3_leaf_write_verify+0xe8/0x100 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.426361]  [<ffffffffc0695997>] ? xfs_buf_delwri_submit_buffers+0x137/0x260 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.426384]  [<ffffffffc0693cc4>] ? _xfs_buf_ioapply+0x84/0x450 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.426389]  [<ffffffffb18a2b30>] ? wake_up_q+0x60/0x60
Mar 29 15:05:12 vps2 kernel: [1154612.426411]  [<ffffffffc0695997>] ? xfs_buf_delwri_submit_buffers+0x137/0x260 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.426446]  [<ffffffffc06956d7>] ? xfs_buf_submit+0x67/0x1f0 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.426473]  [<ffffffffc0695997>] ? xfs_buf_delwri_submit_buffers+0x137/0x260 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.426505]  [<ffffffffc06c777b>] ? xfsaild+0x2cb/0x7b0 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.426531]  [<ffffffffc06bf2f9>] ? xfs_inode_item_push+0x99/0x140 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.426558]  [<ffffffffc06c777b>] ? xfsaild+0x2cb/0x7b0 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.426585]  [<ffffffffc06c74b0>] ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.426589]  [<ffffffffb18974c0>] ? kthread+0xe0/0x100
Mar 29 15:05:12 vps2 kernel: [1154612.426592]  [<ffffffffb182476b>] ? __switch_to+0x2bb/0x700
Mar 29 15:05:12 vps2 kernel: [1154612.426594]  [<ffffffffb18973e0>] ? kthread_park+0x60/0x60
Mar 29 15:05:12 vps2 kernel: [1154612.426597]  [<ffffffffb1dfb675>] ? ret_from_fork+0x25/0x30
Mar 29 15:05:12 vps2 kernel: [1154612.426602] XFS (dm-2): xfs_do_force_shutdown(0x8) called from line 1323 of file /home/zumbi/linux-4.9.13/fs/xfs/xfs_buf.c.  Return address = 0xffffffffc0694084
Mar 29 15:05:12 vps2 kernel: [1154612.427033] XFS (dm-2): Corruption of in-memory data detected.  Shutting down filesystem
Mar 29 15:05:12 vps2 kernel: [1154612.427323] CPU: 2 PID: 453 Comm: xfsaild/dm-2 Tainted: G            E   4.9.0-0.bpo.2-amd64 #1 Debian 4.9.13-1~bpo8+1
Mar 29 15:05:12 vps2 kernel: [1154612.427323] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/14/2014
Mar 29 15:05:12 vps2 kernel: [1154612.427324]  0000000000000000 ffffffffb1b29cd5 0000000000000008 ffff979528c42000
Mar 29 15:05:12 vps2 kernel: [1154612.427326]  ffffffffc069c1fa ffffffffc0694084 0000000000000000 ffffbd1ac1fb3d40
Mar 29 15:05:12 vps2 kernel: [1154612.427328]  ffffffffc0695997 ffff9792b0dd60c0 ffffffffc0694084 0000000000000000
Mar 29 15:05:12 vps2 kernel: [1154612.427329] Call Trace:
Mar 29 15:05:12 vps2 kernel: [1154612.427335]  [<ffffffffb1b29cd5>] ? dump_stack+0x5c/0x77
Mar 29 15:05:12 vps2 kernel: [1154612.427380]  [<ffffffffc069c1fa>] ? xfs_do_force_shutdown+0x13a/0x140 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.427408]  [<ffffffffc0694084>] ? _xfs_buf_ioapply+0x444/0x450 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.427432]  [<ffffffffc0695997>] ? xfs_buf_delwri_submit_buffers+0x137/0x260 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.427458]  [<ffffffffc0694084>] ? _xfs_buf_ioapply+0x444/0x450 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.427462]  [<ffffffffb18a2b30>] ? wake_up_q+0x60/0x60
Mar 29 15:05:12 vps2 kernel: [1154612.427485]  [<ffffffffc0695997>] ? xfs_buf_delwri_submit_buffers+0x137/0x260 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.427508]  [<ffffffffc06956d7>] ? xfs_buf_submit+0x67/0x1f0 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.427530]  [<ffffffffc0695997>] ? xfs_buf_delwri_submit_buffers+0x137/0x260 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.427562]  [<ffffffffc06c777b>] ? xfsaild+0x2cb/0x7b0 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.427596]  [<ffffffffc06bf2f9>] ? xfs_inode_item_push+0x99/0x140 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.427625]  [<ffffffffc06c777b>] ? xfsaild+0x2cb/0x7b0 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.427652]  [<ffffffffc06c74b0>] ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
Mar 29 15:05:12 vps2 kernel: [1154612.427654]  [<ffffffffb18974c0>] ? kthread+0xe0/0x100
Mar 29 15:05:12 vps2 kernel: [1154612.427656]  [<ffffffffb182476b>] ? __switch_to+0x2bb/0x700
Mar 29 15:05:12 vps2 kernel: [1154612.427657]  [<ffffffffb18973e0>] ? kthread_park+0x60/0x60
Mar 29 15:05:12 vps2 kernel: [1154612.427659]  [<ffffffffb1dfb675>] ? ret_from_fork+0x25/0x30
Mar 29 15:05:12 vps2 kernel: [1154612.427671] XFS (dm-2): Please umount the filesystem and rectify the problem(s)

