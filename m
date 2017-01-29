Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35635 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdA2TxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Jan 2017 14:53:01 -0500
Received: by mail-wm0-f51.google.com with SMTP id b65so5152008wmf.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Jan 2017 11:52:54 -0800 (PST)
MIME-Version: 1.0
From: Patrick Dung <mpatdung@gmail.com>
Date: Mon, 30 Jan 2017 03:45:27 +0800
Message-ID: <CAEtPA0AOfhTGM76vhLHDiQbXyHywbypk5hOLhq=AWvwVAQPO3g@mail.gmail.com>
Subject: WARNING: CPU: 11 PID: 7966 at fs/xfs/libxfs/xfs_bmap.c:5408
 xfs_bmap_del_extent+0xdc8/0xe80 [xfs] and having a call trace
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hello

I have encounter this warning message twice in recently.
Do you know what is it about?

[39331.103938] ------------[ cut here ]------------
[39331.104014] WARNING: CPU: 11 PID: 7966 at
fs/xfs/libxfs/xfs_bmap.c:5408 xfs_bmap_del_extent+0xdc8/0xe80 [xfs]
[39331.104122] CPU: 11 PID: 7966 Comm: cp Tainted: G           OE
4.9.3-200.fc25.x86_64 #1
[39331.104127]  ffff9ddbb7ba3ab8 ffffffff843f3ddd 0000000000000000
0000000000000000
[39331.104132]  ffff9ddbb7ba3af8 ffffffff840a202b 00001520b7ba3ca8
ffff900c5a598400
[39331.104136]  ffff9ddbb7ba3ca0 0000000000001cc0 0000000000000000
0000000000000000
[39331.104140] Call Trace:
[39331.104150]  [<ffffffff843f3ddd>] dump_stack+0x63/0x86
[39331.104154]  [<ffffffff840a202b>] __warn+0xcb/0xf0
[39331.104158]  [<ffffffff840a215d>] warn_slowpath_null+0x1d/0x20
[39331.104198]  [<ffffffffc0ba9018>] xfs_bmap_del_extent+0xdc8/0xe80 [xfs]
[39331.104237]  [<ffffffffc0bad3bd>] __xfs_bunmapi+0x5bd/0xb90 [xfs]
[39331.104274]  [<ffffffffc0bad9bb>] xfs_bunmapi+0x2b/0x40 [xfs]
[39331.104320]  [<ffffffffc0be3056>] xfs_free_file_space+0x256/0x300 [xfs]
[39331.104366]  [<ffffffffc0bea79a>] xfs_file_fallocate+0x18a/0x3b0 [xfs]
[39331.104370]  [<ffffffff84256077>] vfs_fallocate+0x157/0x220
[39331.104373]  [<ffffffff84256e88>] SyS_fallocate+0x48/0x80
[39331.104376]  [<ffffffff842591a7>] ? SyS_lseek+0x87/0xb0
[39331.104383]  [<ffffffff8481bbf7>] entry_SYSCALL_64_fastpath+0x1a/0xa9
[39331.104386] ---[ end trace 964857cd95d3bbff ]---

Thanks.
Patrick
