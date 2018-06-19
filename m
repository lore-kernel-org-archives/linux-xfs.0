Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:41938 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1030305AbeFSSql (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 14:46:41 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4230328A1D
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jun 2018 18:46:41 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 200137] [xfstests generic/485] XFS: Assertion failed:
 (irec->br_startoff & ~XFS_IEXT_STARTOFF_MASK) == 0, file:
 fs/xfs/libxfs/xfs_iext_tree.c, line: 68
Date: Tue, 19 Jun 2018 18:46:40 +0000
Message-ID: <bug-200137-201763-y9BdpFPj5J@https.bugzilla.kernel.org/>
In-Reply-To: <bug-200137-201763@https.bugzilla.kernel.org/>
References: <bug-200137-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=200137

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
(In reply to Darrick J. Wong from comment #1)
> Created attachment 276691 [details]
> proposed fix
> 
> Zoro: does the attached patch fix the problem?

Hi Darrick,

Yes, I can't reproduce this bug again after merged your patch:

# mkfs.xfs -f -m crc=0 -b size=512 /dev/mapper/xxxx-xfstest
meta-data=/dev/mapper/xxxx-xfstest isize=256    agcount=4, agsize=10485760 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0        finobt=0, sparse=0, rmapbt=0
         =                       reflink=0
data     =                       bsize=512    blocks=41943040, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=512    blocks=20480, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# ./check generic/485
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 xxx.xxx.xxx 4.17.0+
MKFS_OPTIONS  -- -f -m crc=0 -b size=512 /dev/mapper/xxxx-xfscratch
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
/dev/mapper/xxxx-xfscratch /mnt/scratch

generic/485      2s
Ran: generic/485
Passed all 1 tests

Thanks,
Zorro

-- 
You are receiving this mail because:
You are watching the assignee of the bug.