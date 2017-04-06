Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from walrus.jabberwocky.com ([173.9.29.57]:57364 "EHLO
        mail.jabberwocky.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752494AbdDFSuv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2017 14:50:51 -0400
Received: from dshaw.nasuni.net (50-202-126-134-static.hfc.comcastbusiness.net [50.202.126.134])
        by mail.jabberwocky.com (Postfix) with ESMTPSA id AB38620276A0
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2017 14:41:45 -0400 (EDT)
From: David Shaw <dshaw@jabberwocky.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Processes stuck in D state when accessing XFSv5 filesystem
Message-Id: <C1597D74-938F-4236-91F0-4CA1D6907F50@jabberwocky.com>
Date: Thu, 6 Apr 2017 14:41:45 -0400
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello,

I'm having a problem with processes getting "stuck" when accessing an XFS (v5) filesystem.  When it happens, I start getting the "blocked for more than 120 seconds" error, and the process stays in that state until I reboot.  The kernel is 3.10.0-514.2.2 and the xfsprogs is 4.5.0-9 (both Centos 7.3).

I have tried running xfs_repair on the filesystem in question, but no problems were reported as fixed.  The stuck processes did happen again after the xfs_repair run.

Any thoughts or directions I could go with this?  One thing which may or may not be useful is that while the current kernel and xfsprogs are as given above, the filesystem was originally created using kernel 3.10.0-327.13.1 and xfsprogs 3.2.2-2 (Centos 7.2).  It's an XFSv5 filesystem, and I know there were a number of problems with XFSv5 in Centos 7.2 that were resolved in 7.3.

Thanks very much for any advice,

David

2017-04-05 17:15:03.853 localhost kernel: [607696.887764] INFO: task serv:23300 blocked for more than 120 seconds.
2017-04-05 17:15:03.853 localhost kernel: [607696.887764] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2017-04-05 17:15:03.853 localhost kernel: [607696.887765] serv         D 0000000000000000     0 23300  11642 0x00000000
2017-04-05 17:15:03.853 localhost kernel: [607696.887766]  ffff880856bff910 0000000000000086 ffff8807d93c1f60 ffff880856bfffd8
2017-04-05 17:15:03.853 localhost kernel: [607696.887768]  ffff880856bfffd8 ffff880856bfffd8 ffff8807d93c1f60 ffff880484aed3b0
2017-04-05 17:15:03.853 localhost kernel: [607696.887769]  7fffffffffffffff ffff8807d93c1f60 0000000000000002 0000000000000000
2017-04-05 17:15:03.853 localhost kernel: [607696.887770] Call Trace:
2017-04-05 17:15:03.853 localhost kernel: [607696.887772]  [<ffffffff8168b899>] schedule+0x29/0x70
2017-04-05 17:15:03.853 localhost kernel: [607696.887774]  [<ffffffff816892e9>] schedule_timeout+0x239/0x2d0
2017-04-05 17:15:03.853 localhost kernel: [607696.887778]  [<ffffffff812efba3>] ? blk_peek_request+0x83/0x280
2017-04-05 17:15:03.853 localhost kernel: [607696.887808]  [<ffffffffa03358a7>] ? xfs_iext_bno_to_ext+0xa7/0x1a0 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887810]  [<ffffffff8168ab68>] __down_common+0x108/0x154
2017-04-05 17:15:03.853 localhost kernel: [607696.887821]  [<ffffffffa0343136>] ? _xfs_buf_find+0x176/0x340 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887823]  [<ffffffff8168abd1>] __down+0x1d/0x1f
2017-04-05 17:15:03.853 localhost kernel: [607696.887825]  [<ffffffff810b6581>] down+0x41/0x50
2017-04-05 17:15:03.853 localhost kernel: [607696.887835]  [<ffffffffa0342f2c>] xfs_buf_lock+0x3c/0xd0 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887844]  [<ffffffffa0343136>] _xfs_buf_find+0x176/0x340 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887853]  [<ffffffffa034332a>] xfs_buf_get_map+0x2a/0x240 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887862]  [<ffffffffa0343ea0>] xfs_buf_read_map+0x30/0x160 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887875]  [<ffffffffa0373709>] xfs_trans_read_buf_map+0x199/0x400 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887884]  [<ffffffffa03222c4>] xfs_da_read_buf+0xd4/0x100 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887892]  [<ffffffffa0308879>] xfs_attr3_leaf_read+0x29/0x70 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887900]  [<ffffffffa0318028>] ? xfs_bmbt_get_all+0x18/0x20 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887906]  [<ffffffffa0305efc>] xfs_attr_leaf_get+0x4c/0x120 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887913]  [<ffffffffa030722c>] xfs_attr_get+0x12c/0x1d0 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887925]  [<ffffffffa03628ad>] xfs_xattr_get+0x3d/0x80 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887927]  [<ffffffff8122349c>] generic_getxattr+0x4c/0x70
2017-04-05 17:15:03.853 localhost kernel: [607696.887928]  [<ffffffff812238e8>] vfs_getxattr+0x88/0xb0
2017-04-05 17:15:03.853 localhost kernel: [607696.887930]  [<ffffffff81223a2b>] getxattr+0xab/0x1d0
2017-04-05 17:15:03.853 localhost kernel: [607696.887931]  [<ffffffff8120ecad>] ? putname+0x3d/0x60
2017-04-05 17:15:03.853 localhost kernel: [607696.887932]  [<ffffffff8120fe52>] ? user_path_at_empty+0x72/0xc0
2017-04-05 17:15:03.853 localhost kernel: [607696.887934]  [<ffffffff81224811>] SyS_lgetxattr+0x61/0xb0
2017-04-05 17:15:03.853 localhost kernel: [607696.887936]  [<ffffffff816967c9>] system_call_fastpath+0x16/0x1b
2017-04-05 17:15:03.853 localhost kernel: [607696.887937] INFO: task serv:23317 blocked for more than 120 seconds.
2017-04-05 17:15:03.853 localhost kernel: [607696.887938] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2017-04-05 17:15:03.853 localhost kernel: [607696.887939] serv         D ffff880867f07980     0 23317  11642 0x00000000
2017-04-05 17:15:03.853 localhost kernel: [607696.887940]  ffff8806082df9d0 0000000000000086 ffff88012b88de20 ffff8806082dffd8
2017-04-05 17:15:03.853 localhost kernel: [607696.887942]  ffff8806082dffd8 ffff8806082dffd8 ffff88012b88de20 ffff880484aed458
2017-04-05 17:15:03.853 localhost kernel: [607696.887943]  ffff880484aed460 7fffffffffffffff ffff88012b88de20 ffff880867f07980
2017-04-05 17:15:03.853 localhost kernel: [607696.887944] Call Trace:
2017-04-05 17:15:03.853 localhost kernel: [607696.887946]  [<ffffffff8168b899>] schedule+0x29/0x70
2017-04-05 17:15:03.853 localhost kernel: [607696.887948]  [<ffffffff816892e9>] schedule_timeout+0x239/0x2d0
2017-04-05 17:15:03.853 localhost kernel: [607696.887950]  [<ffffffff812f04d4>] ? blk_finish_plug+0x14/0x40
2017-04-05 17:15:03.853 localhost kernel: [607696.887961]  [<ffffffffa0342014>] ? _xfs_buf_ioapply+0x334/0x460 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887963]  [<ffffffff8168bc76>] wait_for_completion+0x116/0x170
2017-04-05 17:15:03.853 localhost kernel: [607696.887967]  [<ffffffff810c4fe0>] ? wake_up_state+0x20/0x20
2017-04-05 17:15:03.853 localhost kernel: [607696.887978]  [<ffffffffa0343e53>] ? _xfs_buf_read+0x23/0x40 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.887990]  [<ffffffffa0343d46>] xfs_buf_submit_wait+0xe6/0x1d0 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888004]  [<ffffffffa0373709>] ? xfs_trans_read_buf_map+0x199/0x400 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888015]  [<ffffffffa0343e53>] _xfs_buf_read+0x23/0x40 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888027]  [<ffffffffa0343f68>] xfs_buf_read_map+0xf8/0x160 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888041]  [<ffffffffa0373709>] xfs_trans_read_buf_map+0x199/0x400 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888051]  [<ffffffffa03222c4>] xfs_da_read_buf+0xd4/0x100 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888060]  [<ffffffffa0308879>] xfs_attr3_leaf_read+0x29/0x70 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888070]  [<ffffffffa0318028>] ? xfs_bmbt_get_all+0x18/0x20 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888078]  [<ffffffffa0305efc>] xfs_attr_leaf_get+0x4c/0x120 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888087]  [<ffffffffa030722c>] xfs_attr_get+0x12c/0x1d0 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888100]  [<ffffffffa03628ad>] xfs_xattr_get+0x3d/0x80 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888101]  [<ffffffff8122349c>] generic_getxattr+0x4c/0x70
2017-04-05 17:15:03.853 localhost kernel: [607696.888103]  [<ffffffff812238e8>] vfs_getxattr+0x88/0xb0
2017-04-05 17:15:03.853 localhost kernel: [607696.888104]  [<ffffffff81223a2b>] getxattr+0xab/0x1d0
2017-04-05 17:15:03.853 localhost kernel: [607696.888105]  [<ffffffff8120ecad>] ? putname+0x3d/0x60
2017-04-05 17:15:03.853 localhost kernel: [607696.888107]  [<ffffffff8120fe52>] ? user_path_at_empty+0x72/0xc0
2017-04-05 17:15:03.853 localhost kernel: [607696.888108]  [<ffffffff81224811>] SyS_lgetxattr+0x61/0xb0
2017-04-05 17:15:03.853 localhost kernel: [607696.888110]  [<ffffffff816967c9>] system_call_fastpath+0x16/0x1b
2017-04-05 17:15:03.853 localhost kernel: [607696.888112] INFO: task serv:190686 blocked for more than 120 seconds.
2017-04-05 17:15:03.853 localhost kernel: [607696.888113] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2017-04-05 17:15:03.853 localhost kernel: [607696.888114] serv         D 0000000000000000     0 190686  11642 0x00000000
2017-04-05 17:15:03.853 localhost kernel: [607696.888115]  ffff8804177e3910 0000000000000086 ffff88020c9d8000 ffff8804177e3fd8
2017-04-05 17:15:03.853 localhost kernel: [607696.888117]  ffff8804177e3fd8 ffff8804177e3fd8 ffff88020c9d8000 ffff880484aed3b0
2017-04-05 17:15:03.853 localhost kernel: [607696.888118]  7fffffffffffffff ffff88020c9d8000 0000000000000002 0000000000000000
2017-04-05 17:15:03.853 localhost kernel: [607696.888119] Call Trace:
2017-04-05 17:15:03.853 localhost kernel: [607696.888121]  [<ffffffff8168b899>] schedule+0x29/0x70
2017-04-05 17:15:03.853 localhost kernel: [607696.888123]  [<ffffffff816892e9>] schedule_timeout+0x239/0x2d0
2017-04-05 17:15:03.853 localhost kernel: [607696.888134]  [<ffffffffa03358a7>] ? xfs_iext_bno_to_ext+0xa7/0x1a0 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888136]  [<ffffffff8168ab68>] __down_common+0x108/0x154
2017-04-05 17:15:03.853 localhost kernel: [607696.888148]  [<ffffffffa0343136>] ? _xfs_buf_find+0x176/0x340 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888149]  [<ffffffff8168abd1>] __down+0x1d/0x1f
2017-04-05 17:15:03.853 localhost kernel: [607696.888151]  [<ffffffff810b6581>] down+0x41/0x50
2017-04-05 17:15:03.853 localhost kernel: [607696.888162]  [<ffffffffa0342f2c>] xfs_buf_lock+0x3c/0xd0 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888174]  [<ffffffffa0343136>] _xfs_buf_find+0x176/0x340 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888185]  [<ffffffffa034332a>] xfs_buf_get_map+0x2a/0x240 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888196]  [<ffffffffa0343ea0>] xfs_buf_read_map+0x30/0x160 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888210]  [<ffffffffa0373709>] xfs_trans_read_buf_map+0x199/0x400 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888220]  [<ffffffffa03222c4>] xfs_da_read_buf+0xd4/0x100 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888230]  [<ffffffffa0308879>] xfs_attr3_leaf_read+0x29/0x70 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888239]  [<ffffffffa0318028>] ? xfs_bmbt_get_all+0x18/0x20 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888247]  [<ffffffffa0305efc>] xfs_attr_leaf_get+0x4c/0x120 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888256]  [<ffffffffa030722c>] xfs_attr_get+0x12c/0x1d0 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888269]  [<ffffffffa03628ad>] xfs_xattr_get+0x3d/0x80 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888270]  [<ffffffff8122349c>] generic_getxattr+0x4c/0x70
2017-04-05 17:15:03.853 localhost kernel: [607696.888272]  [<ffffffff812238e8>] vfs_getxattr+0x88/0xb0
2017-04-05 17:15:03.853 localhost kernel: [607696.888273]  [<ffffffff81223a2b>] getxattr+0xab/0x1d0
2017-04-05 17:15:03.853 localhost kernel: [607696.888274]  [<ffffffff8120ecad>] ? putname+0x3d/0x60
2017-04-05 17:15:03.853 localhost kernel: [607696.888276]  [<ffffffff8120fe52>] ? user_path_at_empty+0x72/0xc0
2017-04-05 17:15:03.853 localhost kernel: [607696.888277]  [<ffffffff81224811>] SyS_lgetxattr+0x61/0xb0
2017-04-05 17:15:03.853 localhost kernel: [607696.888279]  [<ffffffff816967c9>] system_call_fastpath+0x16/0x1b
2017-04-05 17:15:03.853 localhost kernel: [607696.888280] INFO: task serv:190687 blocked for more than 120 seconds.
2017-04-05 17:15:03.853 localhost kernel: [607696.888281] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
2017-04-05 17:15:03.853 localhost kernel: [607696.888281] serv         D 0000000000000000     0 190687  11642 0x00000000
2017-04-05 17:15:03.853 localhost kernel: [607696.888283]  ffff88048d82b910 0000000000000086 ffff88010a6a0fb0 ffff88048d82bfd8
2017-04-05 17:15:03.853 localhost kernel: [607696.888284]  ffff88048d82bfd8 ffff88048d82bfd8 ffff88010a6a0fb0 ffff880484aed3b0
2017-04-05 17:15:03.853 localhost kernel: [607696.888286]  7fffffffffffffff ffff88010a6a0fb0 0000000000000002 0000000000000000
2017-04-05 17:15:03.853 localhost kernel: [607696.888287] Call Trace:
2017-04-05 17:15:03.853 localhost kernel: [607696.888289]  [<ffffffff8168b899>] schedule+0x29/0x70
2017-04-05 17:15:03.853 localhost kernel: [607696.888291]  [<ffffffff816892e9>] schedule_timeout+0x239/0x2d0
2017-04-05 17:15:03.853 localhost kernel: [607696.888301]  [<ffffffffa03358a7>] ? xfs_iext_bno_to_ext+0xa7/0x1a0 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888303]  [<ffffffff8168ab68>] __down_common+0x108/0x154
2017-04-05 17:15:03.853 localhost kernel: [607696.888315]  [<ffffffffa0343136>] ? _xfs_buf_find+0x176/0x340 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888317]  [<ffffffff8168abd1>] __down+0x1d/0x1f
2017-04-05 17:15:03.853 localhost kernel: [607696.888318]  [<ffffffff810b6581>] down+0x41/0x50
2017-04-05 17:15:03.853 localhost kernel: [607696.888330]  [<ffffffffa0342f2c>] xfs_buf_lock+0x3c/0xd0 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888341]  [<ffffffffa0343136>] _xfs_buf_find+0x176/0x340 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888352]  [<ffffffffa034332a>] xfs_buf_get_map+0x2a/0x240 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888364]  [<ffffffffa0343ea0>] xfs_buf_read_map+0x30/0x160 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888378]  [<ffffffffa0373709>] xfs_trans_read_buf_map+0x199/0x400 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888388]  [<ffffffffa03222c4>] xfs_da_read_buf+0xd4/0x100 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888397]  [<ffffffffa0308879>] xfs_attr3_leaf_read+0x29/0x70 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888407]  [<ffffffffa0318028>] ? xfs_bmbt_get_all+0x18/0x20 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888415]  [<ffffffffa0305efc>] xfs_attr_leaf_get+0x4c/0x120 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888424]  [<ffffffffa030722c>] xfs_attr_get+0x12c/0x1d0 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888437]  [<ffffffffa03628ad>] xfs_xattr_get+0x3d/0x80 [xfs]
2017-04-05 17:15:03.853 localhost kernel: [607696.888438]  [<ffffffff8122349c>] generic_getxattr+0x4c/0x70
2017-04-05 17:15:03.853 localhost kernel: [607696.888439]  [<ffffffff812238e8>] vfs_getxattr+0x88/0xb0
2017-04-05 17:15:03.853 localhost kernel: [607696.888441]  [<ffffffff81223a2b>] getxattr+0xab/0x1d0
2017-04-05 17:15:03.853 localhost kernel: [607696.888442]  [<ffffffff8120ecad>] ? putname+0x3d/0x60
2017-04-05 17:15:03.853 localhost kernel: [607696.888444]  [<ffffffff8120fe52>] ? user_path_at_empty+0x72/0xc0
2017-04-05 17:15:03.853 localhost kernel: [607696.888445]  [<ffffffff81224811>] SyS_lgetxattr+0x61/0xb0
2017-04-05 17:15:03.853 localhost kernel: [607696.888447]  [<ffffffff816967c9>] system_call_fastpath+0x16/0x1bƒ

