Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:33498 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727687AbfGRUAp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Jul 2019 16:00:45 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 208CB28857
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2019 20:00:44 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 204049] [xfstests generic/388]: XFS: Assertion failed:
 ip->i_d.di_format != XFS_DINODE_FMT_BTREE || ip->i_d.di_nextents >
 XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK), file: fs/xfs/xfs_inode.c, line: 3646
Date: Thu, 18 Jul 2019 20:00:43 +0000
Message-ID: <bug-204049-201763-VtyfTEt7Rt@https.bugzilla.kernel.org/>
In-Reply-To: <bug-204049-201763@https.bugzilla.kernel.org/>
References: <bug-204049-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204049

--- Comment #1 from Luis Chamberlain (mcgrof@kernel.org) ---
I reported an immediate v4.19.58 vanilla crash  with generic/388 but with the
"xfs_nocrc" and "xfs_reflink" configuration as per oscheck's testing:

The "xfs_nocrc":

# xfs_info /dev/loop5
meta-data=/dev/loop5             isize=256    agcount=4, agsize=1310720 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0, sparse=0, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096   blocks=5242880, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

The "xfs_reflink" configuration:

# xfs_info /dev/loop5
meta-data=/dev/loop5             isize=512    agcount=4, agsize=1310720 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1
data     =                       bsize=4096   blocks=5242880, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=3693, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

This is being tracked on this bug report:

https://bugzilla.kernel.org/show_bug.cgi?id=204223

The configuration above has rmapbt=1, you have rmapbt=0, at least in
discussions over which types of configurations to test for stable long ago on
the mailing list using rmapbt=0 with reflink was not one which we set out to
cover, so curious what the motivation was for tracking problems with it were
now. I'll just refer to this configuration then as "xfs_reflink_normapbt" and
I'll consider tracking it for stable depending on why you set out to cover it
as well.


I cannot reproduce your crash on v4.19.58 with your same configuration,
""xfs_reflink_normapbt", at least so far I've ran the test 15 times in a loop
and I see no failure. The other crashes occur within 1-3 times of running the
test. How many times did you run the test for it to crash on the system?

I'll leave the test running a bit longer just in case.

Given what I am seeing though, it seems likely there may be a regression here.
Could you bisect? We at least now have an idea of what to expect around the
v4.19 for different configurations including yours.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
