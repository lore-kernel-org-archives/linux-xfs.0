Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:40348 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727547AbeLEKKf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 05:10:35 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 7AE9D2CD37
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 10:10:34 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201897] [xfstests generic/482]: filesystem corruption after log
 replay
Date: Wed, 05 Dec 2018 10:10:34 +0000
Message-ID: <bug-201897-201763-vwGWb2djKl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-201897-201763@https.bugzilla.kernel.org/>
References: <bug-201897-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201897

--- Comment #5 from Zorro Lang (zlang@redhat.com) ---
(In reply to Zorro Lang from comment #4)
> V5 XFS without reflink feature test pass:
> # ./check generic/482
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 ibm-x3650m4-10 4.20.0-rc1
> MKFS_OPTIONS  -- -f -m reflink=0,rmapbt=0,finobt=0,crc=1 -i sparse=0
> /dev/mapper/rhel_ibm--x3650m4--10-xfscratch
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
> /dev/mapper/rhel_ibm--x3650m4--10-xfscratch /mnt/scratch
> 
> generic/482 1567s ...  774s
> Ran: generic/482
> Passed all 1 tests
> 
> # ./check generic/482
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 ibm-x3650m4-10 4.20.0-rc1
> MKFS_OPTIONS  -- -f -m reflink=0,rmapbt=0,finobt=1,crc=1 -i sparse=1
> /dev/mapper/rhel_ibm--x3650m4--10-xfscratch                                 
> 
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
> /dev/mapper/rhel_ibm--x3650m4--10-xfscratch /mnt/scratch                    
> 
> 
> generic/482 774s ...  841s
> Ran: generic/482
> Passed all 1 tests

Hmm... maybe I said that too early :/ (below 4.20-rc1 contains
xfs-4.20-fixes-3) ...

FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 ibm-x3650m4-10 4.20.0-rc1
MKFS_OPTIONS  -- -f -m reflink=0,rmapbt=0,finobt=1,crc=1 -i sparse=1
/dev/mapper/rhel_ibm--x3650m4--10-xfscratch
MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0
/dev/mapper/rhel_ibm--x3650m4--10-xfscratch /mnt/scratch

generic/482 841s ... [failed, exit status 1]- output mismatch (see
/root/git/xfstests-dev/results//generic/482.out.bad)
    --- tests/generic/482.out   2018-11-25 23:54:50.488528619 -0500
    +++ /root/git/xfstests-dev/results//generic/482.out.bad     2018-12-05
05:07:01.060133234 -0500
    @@ -1,2 +1,3 @@
     QA output created by 482
    -Silence is golden
    +_check_xfs_filesystem: filesystem on
/dev/mapper/rhel_ibm--x3650m4--10-xfscratch is inconsistent (r)
    +(see /root/git/xfstests-dev/results//generic/482.full for details)
    ...
    (Run 'diff -u /root/git/xfstests-dev/tests/generic/482.out
/root/git/xfstests-dev/results//generic/482.out.bad'  to see the entire diff)
Ran: generic/482
Failures: generic/482
Failed 1 of 1 tests

# cat results/generic/482.full
# ./ltp/fsstress -w -d /mnt/scratch -n 512 -p 8
seed = 1543732939
mark mkfs has entry number 235
next fua is entry number 239
=== replay to 239 ===
next fua is entry number 244
=== replay to 244 ===
next fua is entry number 247
=== replay to 247 ===
next fua is entry number 259
=== replay to 259 ===
next fua is entry number 283
=== replay to 283 ===
next fua is entry number 284
=== replay to 284 ===
next fua is entry number 289
=== replay to 289 ===
next fua is entry number 309
=== replay to 309 ===
next fua is entry number 319
=== replay to 319 ===
_check_xfs_filesystem: filesystem on
/dev/mapper/rhel_ibm--x3650m4--10-xfscratch is inconsistent (r)
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
bad symlink header ino 134304910, file block 0, disk block 16788111
problem with symbolic link in inode 134304910
would have cleared inode 134304910
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 2
        - agno = 1
entry "l6" in shortform directory 134304896 references free inode 134304910
        - agno = 3
would have junked entry "l6" in directory inode 134304896
bad symlink header ino 134304910, file block 0, disk block 16788111
problem with symbolic link in inode 134304910
would have cleared inode 134304910
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "l6" in shortform directory inode 134304896 points to free inode
134304910
would junk entry
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
Maximum metadata LSN (1:962) is ahead of log (1:141).
Would format log to cycle 4.
No modify flag set, skipping filesystem flush and exiting.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
