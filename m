Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42545 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729930AbfGHUIM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jul 2019 16:08:12 -0400
Received: by mail-qt1-f194.google.com with SMTP id h18so11895115qtm.9
        for <linux-xfs@vger.kernel.org>; Mon, 08 Jul 2019 13:08:11 -0700 (PDT)
Message-ID: <1562616489.8510.15.camel@lca.pw>
Subject: memory leaks from xfs_rw_bdev()
From: Qian Cai <cai@lca.pw>
Date: Mon, 08 Jul 2019 16:08:09 -0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hch@lst.de
Cc: darrick.wong@oracle.com, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

Booting today's linux-next starts to have several memory leaks. Looks like the
new xfs_rw_bdev() was introduced in the commit "xfs: use bios directly to read
and write the log recovery buffers".

https://patchwork.kernel.org/patch/10977673/

unreferenced object 0xffff888f595487c0 (size 184):
  comm "mount", pid 1473, jiffies 4294946340 (age 14914.220s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 08 40 28 67 8f 88 ff ff  .........@(g....
    00 18 00 00 40 c6 00 00 00 00 00 00 00 00 00 00  ....@...........
  backtrace:
    [<0000000031fb6250>] kmem_cache_alloc+0x272/0x400
    [<000000008ce62f00>] mempool_alloc_slab+0x2d/0x40
    [<000000004eaa8110>] mempool_alloc+0x10a/0x29e
    [<00000000906127bf>] bio_alloc_bioset+0x150/0x330
    [<000000005d5cc981>] xfs_rw_bdev+0x72/0x300 [xfs]
    [<00000000bbf739cd>] xlog_do_io+0xd8/0x1a0 [xfs]
    [<000000003815ee16>] xlog_bread+0x28/0x70 [xfs]
    [<00000000883dc328>] xlog_find_verify_cycle+0x180/0x2c0 [xfs]
    [<00000000457d45f8>] xlog_find_head+0x27c/0x5a0 [xfs]
    [<000000009956dd1f>] xlog_find_tail+0xdb/0x530 [xfs]
    [<00000000c0cdfde4>] xlog_recover+0x8f/0x2a0 [xfs]
    [<00000000f87803cd>] xfs_log_mount+0x247/0x3b0 [xfs]
    [<00000000e3a05975>] xfs_mountfs+0x7bd/0xe30 [xfs]
    [<00000000128f1a43>] xfs_fs_fill_super+0x6f0/0xaa0 [xfs]
    [<000000000ead1e3b>] mount_bdev+0x1d9/0x220
    [<00000000d48a9588>] xfs_fs_mount+0x15/0x20 [xfs]
