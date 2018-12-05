Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54836 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726866AbeLEIkh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Dec 2018 03:40:37 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id DAA222CA04
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 08:40:36 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201897] New: [xfstests generic/482]: filesystem corruption
 after log replay
Date: Wed, 05 Dec 2018 08:40:35 +0000
Message-ID: <bug-201897-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201897

            Bug ID: 201897
           Summary: [xfstests generic/482]: filesystem corruption after
                    log replay
           Product: File System
           Version: 2.5
    Kernel Version: v4.20-rc4 and xfs-4.20-fixes-3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

generic/482 fails on v4.20-rc4, and xfs-4.20-fixes-3. But they have different
coruption output(xfs_repair -n):

# ./check generic/482
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 hp-dl380pg8-01 4.20.0-rc4+
MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1
/dev/mapper/rhel_hp--dl380pg8--01-xfscratch
MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0
/dev/mapper/rhel_hp--dl380pg8--01-xfscratch /mnt/xfstests/mnt2                  

generic/482     [failed, exit status 1]- output mismatch (see
/var/lib/xfstests/results//generic/482.out.bad)                                 
    --- tests/generic/482.out   2018-12-05 02:29:59.736699716 -0500
    +++ /var/lib/xfstests/results//generic/482.out.bad  2018-12-05
03:10:34.985268665 -0500
    @@ -1,2 +1,3 @@
     QA output created by 482
    -Silence is golden
    +_check_xfs_filesystem: filesystem on
/dev/mapper/rhel_hp--dl380pg8--01-xfscratch is inconsistent (r)                 
    +(see /var/lib/xfstests/results//generic/482.full for details)
    ...
    (Run 'diff -u /var/lib/xfstests/tests/generic/482.out
/var/lib/xfstests/results//generic/482.out.bad'  to see the entire diff)        
Ran: generic/482
Failures: generic/482
Failed 1 of 1 tests

# cat results/generic/482.full
_check_xfs_filesystem: filesystem on
/dev/mapper/rhel_hp--dl380pg8--01-xfscratch is inconsistent (r)
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
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
unknown block state, ag 1, block 2066
unknown block state, ag 1, block 2126
unknown block state, ag 1, block 2459
...
unknown block state, ag 1, block 7780
unknown block state, ag 1, block 8189
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 0
        - agno = 2
        - agno = 3
Missing reverse-mapping record for (1/1007) len 16 owner 805306519 off 348
Missing reverse-mapping record for (1/1018) len 5 owner 134 off 118
Missing reverse-mapping record for (1/1023) len 14 owner 163 off 810
...
Missing reverse-mapping record for (1/3172) len 25 owner 268435634 off 54
Missing reverse-mapping record for (1/3461) len 31 owner 138 off 783
Incorrect reverse-mapping: saw (1/4066) len 23 owner 170 off 692; should be
(1/4066) len 28 owner 170 off 692
Incorrect reverse-mapping: saw (1/4094) unwritten len 16 owner 268435610 off
112; should be (1/4094) unwritten len 212 owner 268435610 off 112
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
Maximum metadata LSN (1:6336) is ahead of log (1:1963).
Would format log to cycle 4.
No modify flag set, skipping filesystem flush and exiting.
*** end xfs_repair output

But on 4.20-rc1 with xfs-4.20-fixes-3, I got different corruption output:
# cat results//generic/482.full
....
....
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
        - agno = 3
bad symlink header ino 201326746, file block 0, disk block 25165839
problem with symbolic link in inode 201326746
would have cleared inode 201326746
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
entry "l21" in shortform directory 201326726 references free inode 201326746
would have junked entry "l21" in directory inode 201326726
bad symlink header ino 201326746, file block 0, disk block 25165839
problem with symbolic link in inode 201326746
would have cleared inode 201326746
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
entry "l21" in shortform directory inode 201326726 points to free inode
201326746
would junk entry
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
Maximum metadata LSN (1:2865) is ahead of log (1:681).
Would format log to cycle 4.
No modify flag set, skipping filesystem flush and exiting.
*** end xfs_repair output
....
....

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
