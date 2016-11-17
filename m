Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933728AbcKQRLF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Nov 2016 12:11:05 -0500
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4AFE57DCD3
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2016 16:35:17 +0000 (UTC)
Received: from localhost (dhcp-12-157.nay.redhat.com [10.66.12.157])
        by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uAHGZGEA010032
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2016 11:35:16 -0500
Date: Fri, 18 Nov 2016 00:35:15 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: [BUG] dd doesn't return on ENOSPC and hang when fulfilling rmapbt XFS
Message-ID: <20161117163515.GB27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

I hit a test hang in generic/224 when testing rmapbt enabled XFS on a
host that has non-zero sunit/swidth reported from underlying device. And
I simplified the reproducer to the following script, and the hang can be
reproduced on any host now.

-----
#!/bin/bash

dev=/dev/sda5
mnt=/mnt/xfs

mkfs -t xfs -m rmapbt=1 -d agcount=8,size=1g -f $dev
mount $dev $mnt
xfs_io -x -c "resblks 4" $mnt

dd if=/dev/zero of=/mnt/xfs/testfile

echo "dd should return and report ENOSPC"
-----

sysrq-w output:
sysrq: SysRq : Show Blocked State
  task                        PC stack   pid father
dd              D    0  2504   2491 0x00000080
 ffff88021077dd00 0000000000000000 ffff88021623be40 ffff88021fd99300
 ffff8802107467c0 ffffc900019dbc18 ffffffff816e2cf5 ffff88020fa8ce90
 ffffc900019dbc40 0000000000000286 ffff8802107467c0 ffff88020fa8ce90
Call Trace:
 [<ffffffff816e2cf5>] ? __schedule+0x195/0x630
 [<ffffffff816e31c6>] schedule+0x36/0x80
 [<ffffffff812534b4>] wb_wait_for_completion+0x64/0x90
 [<ffffffff810d2910>] ? prepare_to_wait_event+0xf0/0xf0
 [<ffffffff81255b3d>] sync_inodes_sb+0xad/0x290
 [<ffffffff81288bc0>] ? iomap_write_end+0x80/0x80
 [<ffffffff8128922c>] ? iomap_apply+0x6c/0x130
 [<ffffffffa014c2a8>] xfs_flush_inodes+0x28/0x40 [xfs]
 [<ffffffffa013370b>] xfs_file_buffered_aio_write+0x18b/0x280 [xfs]
 [<ffffffffa0133890>] xfs_file_write_iter+0x90/0x130 [xfs]
 [<ffffffff81226b52>] __vfs_write+0xe2/0x140
 [<ffffffff812279d2>] vfs_write+0xb2/0x1b0
 [<ffffffff81003510>] ? syscall_trace_enter+0x1d0/0x2b0
 [<ffffffff81228e25>] SyS_write+0x55/0xc0
 [<ffffffff81003a47>] do_syscall_64+0x67/0x180
 [<ffffffff816e796b>] entry_SYSCALL64_slow_path+0x25/0x25

I tested on 4.9-rc5 kernel, for-next branch from linux-xfs tree and
latest djwong-devel branch from Darrick's tree.

If you need more information please let me know.

Thanks,
Eryu
