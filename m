Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54602 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbeLAT2L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Dec 2018 14:28:11 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id C003C2E700
        for <linux-xfs@vger.kernel.org>; Sat,  1 Dec 2018 08:16:14 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 201823] New: inconsistent behaviour of xfs_db, xfs_repair and
 xfs_scrub
Date: Sat, 01 Dec 2018 08:16:13 +0000
Message-ID: <bug-201823-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=201823

            Bug ID: 201823
           Summary: inconsistent behaviour of xfs_db, xfs_repair and
                    xfs_scrub
           Product: File System
           Version: 2.5
    Kernel Version: 4.19.5
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: matthias@bodenbinder.de
        Regression: No

Hi,

I am using xfs on Manjaro with kernel 4.19 and latest xfsprogs 4.19.0-1.

I checked my root filesystem with xfs_db for fragmentation and got metadata
corruption messages:

5# xfs_db -c frag -r /dev/sde1
Metadata corruption detected at 0x558ed74133f3, xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at 0x558ed74133f3, xfs_inode block
0x20cb300/0x8000
Metadata corruption detected at 0x558ed74133f3, xfs_inode block
0x2341340/0x8000
aktuell 976616, ideal 970547, Unterteilungsfaktor 0,62%
Note, this number is largely meaningless.
Files on this filesystem average 1,01 extents per file

But xfs_repiar is not mentioning anything and hence not repairing anything.
Also, xfs_scrub is not complaining:

8# xfs_scrub -v /    
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Phase 1: Find filesystem geometry.
/: using 8 threads to scrub.
Phase 2: Check internal metadata.
Phase 3: Scan all inodes.
Phase 5: Check directory tree.
Phase 7: Check summary counters.
41,6GiB data used;  1,3M inodes used.
41,5GiB data found; 1,3M inodes found.
1,3M inodes counted; 1,3M inodes checked.


How do I have to interpret these results? 
What can I do to get repair it?

I created an xfs dump just in case somebody wants to debug this.

Thank you for your help
Matthias

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
