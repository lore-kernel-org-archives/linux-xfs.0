Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:50122 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729126AbeGRWMW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 18:12:22 -0400
Date: Wed, 18 Jul 2018 14:22:40 -0700
From: Andi Kleen <andi@firstfloor.org>
Subject: XFS long delays on disk full
Message-ID: <20180718212240.vxl33543lrh7vgzz@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

Hi,

I was doing some testing on a 4.18-rc1 kernel, and a single threaded
test wrote a fairly large file to a XFS file system, causing it to
fill up.

After that the process hung in D state for a long time, and only
recovered after several minutes. Here's the backtrace during
the hang:

[<0>] wb_wait_for_completion+0x5e/0x90
[<0>] sync_inodes_sb+0xc9/0x290
[<0>] xfs_flush_inodes+0x25/0x30 [xfs]
[<0>] xfs_file_buffered_aio_write+0x2be/0x300 [xfs]
[<0>] __vfs_write+0x114/0x1a0
[<0>] vfs_write+0xad/0x1a0
[<0>] ksys_write+0x52/0xc0
[<0>] do_syscall_64+0x5b/0x160
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
[<0>] 0xffffffffffffffff

There were no IO errors or similar.

Expected? Already fixed?

Thanks,
-Andi

