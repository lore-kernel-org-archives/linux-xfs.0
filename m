Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:34265 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726788AbeJLRnB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 12 Oct 2018 13:43:01 -0400
Message-ID: <5BC07346.7030102@cn.fujitsu.com>
Date: Fri, 12 Oct 2018 18:11:18 +0800
From: Xiao Yang <yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Question about reflink tests in xfstests
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

Hi Darrick,

Sorry to bother you.

With xfsprogs v4.19.0-rc0 on kernel v4.19.0-rc7, running xfs/127 alway
get the following error:
---------------------------------------------------------------
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 RHEL8U0Alpha_Intel64 4.19.0-rc7+
MKFS_OPTIONS  -- -f -m rmapbt=1,reflink=1 /dev/sda8
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda8 /mnt/xfstests/scratch

xfs/127 21s ... _check_xfs_filesystem: filesystem on /dev/sda8 is inconsistent (c)
(see /var/lib/xfstests/results//xfs/127.full for details)
...
---------------------------------------------------------------

cat /var/lib/xfstests/results//xfs/127.full
---------------------------------------------------------------
*** xfs_check output ***
agi_freecount 57, counted 56 in ag 0
sb_ifree 57, counted 56
*** end xfs_check output
----------------------------------------------------------------

>From xfs/139, xfs/140 and xfs/233, xfs_check also triggers the similar issue, as below:

cat /var/lib/xfstests/results/xfs/139.full
----------------------------------------------------------------
*** xfs_check output ***
agi_freecount 58, counted 61 in ag 0
agf_freeblks 160, counted 8179 in ag 1
agf_longest 160, counted 8179 in ag 1
agf_freeblks 3910, counted 8179 in ag 2
agf_longest 3910, counted 8179 in ag 2
agf_freeblks 160, counted 8179 in ag 3
agf_longest 160, counted 8179 in ag 3
agf_freeblks 3910, counted 8179 in ag 4
agf_longest 3910, counted 8179 in ag 4
sb_ifree 58, counted 61
sb_fdblocks 5210741, counted 5235317
sb_fdblocks 5210741, aggregate AGF count 5235317
*** end xfs_check output
----------------------------------------------------------------

cat /var/lib/xfstests/results/xfs/140.full
----------------------------------------------------------------
*** xfs_check output ***
agf_freeblks 8163, counted 8171 in ag 0
agf_longest 8163, counted 8168 in ag 0
agi_freecount 57, counted 61 in ag 0
block 1/8062 expected type unknown got freelist
block 1/8066 expected type unknown got freelist
block 1/8068 expected type unknown got freelist
block 1/8069 expected type unknown got freelist
block 1/8070 expected type unknown got freelist
...
----------------------------------------------------------------


cat /var/lib/xfstests/results/xfs/233.full
----------------------------------------------------------------
*** xfs_check output ***
agf_freeblks 4030, counted 4015 in ag 0
agf_longest 4027, counted 4012 in ag 0
agi_freecount 57, counted 56 in ag 0
sb_ifree 57, counted 56
sb_fdblocks 5233119, counted 5233104
sb_fdblocks 5233119, aggregate AGF count 5233104
*** end xfs_check output
----------------------------------------------------------------

I am not sure if this is a XFS bug or these tests need to be fixed.
Could you help me answer the root cause of these failures?

Best Regards,
Xiao Yang
