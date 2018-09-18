Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:42390 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726433AbeIRNBY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 09:01:24 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 4E74C29D06
        for <linux-xfs@vger.kernel.org>; Tue, 18 Sep 2018 07:30:05 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201173] New: [xfstests xfs/137]: xfs_repair hang when it trying
 to repair a 500t xfs
Date: Tue, 18 Sep 2018 07:30:05 +0000
Message-ID: <bug-201173-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201173

            Bug ID: 201173
           Summary: [xfstests xfs/137]: xfs_repair hang when it trying to
                    repair a 500t xfs
           Product: File System
           Version: 2.5
    Kernel Version: v4.18
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

When I test on 500T xfs by xfstests, xfs/137 hang there several days:

# cat ~/results//xfs/137.full

fallocate: No space left on device
meta-data=/dev/mapper/VG500T-LV500T isize=512    agcount=500, agsize=268435455
blks
         =                       sectsz=4096  attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=1
data     =                       bsize=4096   blocks=134217727500, imaxpct=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
Formatting the log to cycle 3, stripe unit 4096 bytes.
seed = 1536168186
Formatting the log to cycle 3, stripe unit 4096 bytes.
mount: /mnt/scratch: wrong fs type, bad option, bad superblock on
/dev/mapper/VG500T-LV500T, missing codepage or helper program, or other error.
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Memory available for repair (41853MB) may not be sufficient.
At least 64048MB is needed to repair this filesystem efficiently
If repair fails due to lack of memory, please
turn prefetching off (-P) to reduce the memory footprint.
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - 15:14:40: scanning filesystem freespace - 500 of 500 allocation
groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - 15:14:40: scanning agi unlinked lists - 500 of 500 allocation groups
done
        - process known inodes and perform inode discovery...
        - agno = 15
        - agno = 60
        - agno = 0
        - agno = 61
        - agno = 45
        - agno = 30
...
...
        - agno = 12
        - agno = 13
        - agno = 14
        - 15:14:42: process known inodes and inode discovery - 640 of 640
inodes done
        - process newly discovered inodes...
        - 15:14:42: process newly discovered inodes - 500 of 500 allocation
groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 15:14:42: setting up duplicate extent list - 500 of 500 allocation
groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 30
        - agno = 60
        - agno = 15
        - agno = 45
        ...
        ...
        - agno = 12
        - agno = 13
        - agno = 14
        - 15:14:43: check for inodes claiming duplicate blocks - 640 of 640
inodes done
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
        - 15:14:44: verify and correct link counts - 500 of 500 allocation
groups done
Maximum metadata LSN (3:4168) is ahead of log (3:8).
Would format log to cycle 6.
No modify flag set, skipping filesystem flush and exiting.
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Me        - agno = 12
        - agno = 13
        - agno = 14
        - 15:14:43: check for inodes claiming duplicate blocks - 640 of 640
inodes done
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
        - 15:14:44: verify and correct link counts - 500 of 500 allocation
groups done
Maximum metadata LSN (3:4168) is ahead of log (3:8).
Would format log to cycle 6.
No modify flag set, skipping filesystem flush and exiting.
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Memory available for repair (41853MB) may not be sufficient.
At least 64048MB is needed to repair this filesystem efficiently
If repair fails due to lack of memory, please
turn prefetching off (-P) to reduce the memory footprint.
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - 15:14:46: scanning filesystem freespace - 500 of 500 allocation
groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - 15:14:46: scanning agi unlinked lists - 500 of 500 allocation groups
done
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 15
        - agno = 30
        - agno = 60mory available for repair (41853MB) may not be sufficient.
At least 64048MB is needed to repair this filesystem efficiently
If repair fails due to lack of memory, please
turn prefetching off (-P) to reduce the memory footprint.
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - 15:14:46: scanning filesystem freespace - 500 of 500 allocation
groups done
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - 15:14:46: scanning agi unlinked lists - 500 of 500 allocation groups
done
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 15
        - agno = 30
        - agno = 60
        ...
        ...
        - agno = 12
        - agno = 13
        - agno = 14
        - 15:14:47: process known inodes and inode discovery - 640 of 640
inodes done
        - process newly discovered inodes...
        - 15:14:47: process newly discovered inodes - 500 of 500 allocation
groups done
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - 15:14:47: setting up duplicate extent list - 500 of 500 allocation
groups done
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 15
        - agno = 30
        - agno = 45
...
...
          - agno = 14
clearing reflink flag on inode 1056545176706
clearing reflink flag on inode 1056545176712
clearing reflink flag on inode 1056545176720
clearing reflink flag on inode 1056545176727
clearing reflink flag on inode 1056545176729
...
...
clearing reflink flag on inode 1056545193071
clearing reflink flag on inode 1056545193082
clearing reflink flag on inode 1056545201865
        - 15:14:48: check for inodes claiming duplicate blocks - 640 of 640
inodes done
Phase 5 - rebuild AG headers and trees...
        - 15:14:48: rebuild AG headers and trees - 500 of 500 allocation groups
done
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
<hanging there, no more output>

Version-Release number of selected component (if applicable):
linux v4.18

How reproducible:
100%

Steps to Reproduce:
1) Download the metadump from below link (I can't upload it to be a
attachment):
https://drive.google.com/open?id=13dRUjuFolGmYDEqptu7XHvsU2h5KDIen

2) xfs_mdrestore it
3) xfs_repair it

Additional info:
gdb output:
(gdb) thread 1
[Switching to thread 1 (Thread 0x7f746a6df380 (LWP 30956))]
#0  0x00007f7469ea13cc in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
(gdb) bt
#0  0x00007f7469ea13cc in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
#1  0x000000000044dc9b in wait_for_inode_prefetch.part ()
#2  0x0000000000451663 in traverse_function ()
#3  0x000000000044a00d in prefetch_ag_range ()
#4  0x000000000044df06 in do_inode_prefetch ()
#5  0x00000000004522e6 in phase6 ()
#6  0x0000000000404449 in main ()
(gdb) thread 2
[Switching to thread 2 (Thread 0x7f74097fa700 (LWP 38745))]
#0  0x00007f7469ea3d56 in do_futex_wait.constprop () from
/lib64/libpthread.so.0
(gdb) bt
#0  0x00007f7469ea3d56 in do_futex_wait.constprop () from
/lib64/libpthread.so.0
#1  0x00007f7469ea3e48 in __new_sem_wait_slow.constprop.0 () from
/lib64/libpthread.so.0
#2  0x000000000044a57f in pf_queuing_worker ()
#3  0x00007f7469e9b2de in start_thread () from /lib64/libpthread.so.0
#4  0x00007f7469979913 in clone () from /lib64/libc.so.6
(gdb) thread 3
[Switching to thread 3 (Thread 0x7f7408ff9700 (LWP 38746))]
#0  0x00007f7469ea13cc in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
(gdb) bt
#0  0x00007f7469ea13cc in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
#1  0x000000000044b5c5 in pf_io_worker ()
#2  0x00007f7469e9b2de in start_thread () from /lib64/libpthread.so.0
#3  0x00007f7469979913 in clone () from /lib64/libc.so.6
(gdb) thread 4
[Switching to thread 4 (Thread 0x7f7409ffb700 (LWP 38747))]
#0  0x00007f7469ea13cc in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
(gdb) bt
#0  0x00007f7469ea13cc in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
#1  0x000000000044b5c5 in pf_io_worker ()
#2  0x00007f7469e9b2de in start_thread () from /lib64/libpthread.so.0
#3  0x00007f7469979913 in clone () from /lib64/libc.so.6
(gdb) thread 5
[Switching to thread 5 (Thread 0x7f745c34a700 (LWP 38748))]
#0  0x00007f7469ea13cc in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
(gdb) bt
#0  0x00007f7469ea13cc in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
#1  0x000000000044b5c5 in pf_io_worker ()
#2  0x00007f7469e9b2de in start_thread () from /lib64/libpthread.so.0
#3  0x00007f7469979913 in clone () from /lib64/libc.so.6
(gdb) thread 6
[Switching to thread 6 (Thread 0x7f740a7fc700 (LWP 38749))]
#0  0x00007f7469ea13cc in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
(gdb) bt
#0  0x00007f7469ea13cc in pthread_cond_wait@@GLIBC_2.3.2 () from
/lib64/libpthread.so.0
#1  0x000000000044b5c5 in pf_io_worker ()
#2  0x00007f7469e9b2de in start_thread () from /lib64/libpthread.so.0
#3  0x00007f7469979913 in clone () from /lib64/libc.so.6

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
